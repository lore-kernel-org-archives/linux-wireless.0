Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38264 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab2CNJLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 05:11:18 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20320.24726.682393.111484@gargle.gargle.HOWL> (sfid-20120314_101121_664025_B374E3D1)
Date: Wed, 14 Mar 2012 14:40:46 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 4/6] ath9k_hw: Cleanup FastChannelChange
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The logic to determine whether to use FCC is a bit convoluted.
Use a small helper function to decide whether FCC is to be
used.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |  104 +++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |    4 --
 3 files changed, 74 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 02cc1ce..780ecd8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1521,17 +1521,81 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_check_alive);
 
+/*
+ * Fast channel change:
+ * (Change synthesizer based on channel freq without resetting chip)
+ *
+ * Don't do FCC when
+ *   - Flag is not set
+ *   - Chip is just coming out of full sleep
+ *   - Channel to be set is same as current channel
+ *   - Channel flags are different, (eg.,moving from 2GHz to 5GHz channel)
+ */
+static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int ret;
+
+	if (AR_SREV_9280(ah) && common->bus_ops->ath_bus_type == ATH_PCI)
+		goto fail;
+
+	if (ah->chip_fullsleep)
+		goto fail;
+
+	if (!ah->curchan)
+		goto fail;
+
+	if (chan->channel == ah->curchan->channel)
+		goto fail;
+
+	if ((chan->channelFlags & CHANNEL_ALL) !=
+	    (ah->curchan->channelFlags & CHANNEL_ALL))
+		goto fail;
+
+	if (!ath9k_hw_check_alive(ah))
+		goto fail;
+
+	/*
+	 * For AR9462, make sure that calibration data for
+	 * re-using are present.
+	 */
+	if (AR_SREV_9462(ah) && (!ah->caldata ||
+				 !ah->caldata->done_txiqcal_once ||
+				 !ah->caldata->done_txclcal_once ||
+				 !ah->caldata->rtt_hist.num_readings))
+		goto fail;
+
+	ath_dbg(common, RESET, "FastChannelChange for %d -> %d\n",
+		ah->curchan->channel, chan->channel);
+
+	ret = ath9k_hw_channel_change(ah, chan);
+	if (!ret)
+		goto fail;
+
+	ath9k_hw_loadnf(ah, ah->curchan);
+	ath9k_hw_start_nfcal(ah, true);
+
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_MCI) && ar9003_mci_is_ready(ah))
+		ar9003_mci_2g5g_switch(ah, true);
+
+	if (AR_SREV_9271(ah))
+		ar9002_hw_load_ani_reg(ah, chan);
+
+	return 0;
+fail:
+	return -EINVAL;
+}
+
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
-		   struct ath9k_hw_cal_data *caldata, bool bChannelChange)
+		   struct ath9k_hw_cal_data *caldata, bool fastcc)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 saveLedState;
-	struct ath9k_channel *curchan = ah->curchan;
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	u64 tsf = 0;
 	int i, r;
-	bool allow_fbs = false, start_mci_reset = false;
+	bool start_mci_reset = false;
 	bool mci = !!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
 	bool save_fullsleep = ah->chip_fullsleep;
 
@@ -1544,8 +1608,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
-	if (curchan && !ah->chip_fullsleep)
-		ath9k_hw_getnf(ah, curchan);
+	if (ah->curchan && !ah->chip_fullsleep)
+		ath9k_hw_getnf(ah, ah->curchan);
 
 	ah->caldata = caldata;
 	if (caldata &&
@@ -1558,32 +1622,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 
-	if (AR_SREV_9280(ah) && common->bus_ops->ath_bus_type == ATH_PCI)
-		bChannelChange = false;
-
-	if (caldata &&
-	    caldata->done_txiqcal_once &&
-	    caldata->done_txclcal_once &&
-	    caldata->rtt_hist.num_readings)
-		allow_fbs = true;
-
-	if (bChannelChange &&
-	    (ah->chip_fullsleep != true) &&
-	    (ah->curchan != NULL) &&
-	    (chan->channel != ah->curchan->channel) &&
-	    (allow_fbs ||
-	     ((chan->channelFlags & CHANNEL_ALL) ==
-	      (ah->curchan->channelFlags & CHANNEL_ALL)))) {
-		if (ath9k_hw_channel_change(ah, chan)) {
-			ath9k_hw_loadnf(ah, ah->curchan);
-			ath9k_hw_start_nfcal(ah, true);
-			if (mci && ar9003_mci_is_ready(ah))
-				ar9003_mci_2g5g_switch(ah, true);
-
-			if (AR_SREV_9271(ah))
-				ar9002_hw_load_ani_reg(ah, chan);
-			return 0;
-		}
+	if (fastcc) {
+		r = ath9k_hw_do_fastcc(ah, chan);
+		if (!r)
+			return r;
 	}
 
 	if (mci)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1707137..23c8dfa 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -924,7 +924,7 @@ const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_deinit(struct ath_hw *ah);
 int ath9k_hw_init(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
-		   struct ath9k_hw_cal_data *caldata, bool bChannelChange);
+		   struct ath9k_hw_cal_data *caldata, bool fastcc);
 int ath9k_hw_fill_cap_info(struct ath_hw *ah);
 u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 77c61bc..a07565c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -334,10 +334,6 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 		hchan = ah->curchan;
 	}
 
-	if (fastcc && (ah->chip_fullsleep ||
-	    !ath9k_hw_check_alive(ah)))
-		fastcc = false;
-
 	if (!ath_prepare_reset(sc, retry_tx, flush))
 		fastcc = false;
 
-- 
1.7.9.4

