Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53763 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab2H0PAR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 11:00:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3.6 5/6] ath9k: fix PA linearization calibration related crash
Date: Mon, 27 Aug 2012 17:00:07 +0200
Message-Id: <1346079608-40944-5-git-send-email-nbd@openwrt.org> (sfid-20120827_170104_882614_FBF89936)
In-Reply-To: <1346079608-40944-4-git-send-email-nbd@openwrt.org>
References: <1346079608-40944-1-git-send-email-nbd@openwrt.org>
 <1346079608-40944-2-git-send-email-nbd@openwrt.org>
 <1346079608-40944-3-git-send-email-nbd@openwrt.org>
 <1346079608-40944-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before PAPRD training can run, the card needs to have sent a packet for
thermal calibration. Sending a dummy packet with the PAPRD training flag
set causes a crash under some circumstance.
Fix the code by replacing the dummy tx with a delay that waits for a
real packet tx to have occurred.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    2 ++
 drivers/net/wireless/ath/ath9k/hw.h   |    1 +
 drivers/net/wireless/ath/ath9k/link.c |    9 +--------
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +++
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 64a00d2..e4b9f35 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1775,6 +1775,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
+	} else if (caldata) {
+		caldata->paprd_packet_sent = false;
 	}
 	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ce7332c..6599a75 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -405,6 +405,7 @@ struct ath9k_hw_cal_data {
 	int8_t iCoff;
 	int8_t qCoff;
 	bool rtt_done;
+	bool paprd_packet_sent;
 	bool paprd_done;
 	bool nfcal_pending;
 	bool nfcal_interference;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 1c24192..825a29c 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -256,7 +256,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	int len = 1800;
 	int ret;
 
-	if (!caldata)
+	if (!caldata || !caldata->paprd_packet_sent || caldata->paprd_done)
 		return;
 
 	ath9k_ps_wakeup(sc);
@@ -283,13 +283,6 @@ void ath_paprd_calibrate(struct work_struct *work)
 			continue;
 
 		chain_ok = 0;
-
-		ath_dbg(common, CALIBRATE,
-			"Sending PAPRD frame for thermal measurement on chain %d\n",
-			chain);
-		if (!ath_paprd_send_frame(sc, skb, chain))
-			goto fail_paprd;
-
 		ar9003_paprd_setup_gain_table(ah, chain);
 
 		ath_dbg(common, CALIBRATE,
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ef91f6c..e0230a4 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2019,6 +2019,9 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	ath_dbg(common, XMIT, "TX complete: skb: %p\n", skb);
 
+	if (sc->sc_ah->caldata)
+		sc->sc_ah->caldata->paprd_packet_sent = true;
+
 	if (!(tx_flags & ATH_TX_ERROR))
 		/* Frame was ACKed */
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
-- 
1.7.9.6 (Apple Git-31.1)

