Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44717 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1H3HoS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 03:44:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com, shafi.wireless@gmail.com,
	vthiagar@qca.qualcomm.com
Subject: [PATCH v8 1/4] ath9k: eliminate common->{rx,tx}_chainmask
Date: Tue, 30 Aug 2011 09:44:03 +0200
Message-Id: <1314690246-76945-1-git-send-email-nbd@openwrt.org> (sfid-20110830_094422_539126_4B9321E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we already have ah->{rx,tx}chainmask for the same purpose

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath.h                |    3 ---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |    4 ++--
 drivers/net/wireless/ath/ath9k/beacon.c       |    2 +-
 drivers/net/wireless/ath/ath9k/debug.c        |   20 ++++++++++----------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    7 ++-----
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 +--
 drivers/net/wireless/ath/ath9k/hw.c           |    5 ++---
 drivers/net/wireless/ath/ath9k/init.c         |    9 ++-------
 drivers/net/wireless/ath/ath9k/main.c         |    7 +++----
 drivers/net/wireless/ath/ath9k/xmit.c         |    8 ++++----
 10 files changed, 27 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 17c4b56..f6b77c2 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -140,9 +140,6 @@ struct ath_common {
 	u8 curbssid[ETH_ALEN];
 	u8 bssidmask[ETH_ALEN];
 
-	u8 tx_chainmask;
-	u8 rx_chainmask;
-
 	u32 rx_bufsize;
 
 	u32 keymax;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index f80d1d6..bb2214f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -113,7 +113,7 @@ static int ar9003_get_training_power_5g(struct ath_hw *ah)
 	if (delta > scale)
 		return -1;
 
-	switch (get_streams(common->tx_chainmask)) {
+	switch (get_streams(ah->txchainmask)) {
 	case 1:
 		delta = 6;
 		break;
@@ -126,7 +126,7 @@ static int ar9003_get_training_power_5g(struct ath_hw *ah)
 	default:
 		delta = 0;
 		ath_dbg(common, ATH_DBG_CALIBRATE,
-		"Invalid tx-chainmask: %u\n", common->tx_chainmask);
+		"Invalid tx-chainmask: %u\n", ah->txchainmask);
 	}
 
 	power += delta;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 086c9c8..0c757c9 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -107,7 +107,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	series[0].Tries = 1;
 	series[0].Rate = rate;
 	series[0].ChSel = ath_txchainmask_reduction(sc,
-			common->tx_chainmask, series[0].Rate);
+			ah->txchainmask, series[0].Rate);
 	series[0].RateFlags = (ctsrate) ? ATH9K_RATESERIES_RTS_CTS : 0;
 	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0, ctsrate, ctsduration,
 				     series, 4, 0);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index e1f1a96..4062e077 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -95,11 +95,11 @@ static ssize_t read_file_tx_chainmask(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "0x%08x\n", common->tx_chainmask);
+	len = sprintf(buf, "0x%08x\n", ah->txchainmask);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -107,7 +107,7 @@ static ssize_t write_file_tx_chainmask(struct file *file, const char __user *use
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
 	unsigned long mask;
 	char buf[32];
 	ssize_t len;
@@ -120,8 +120,8 @@ static ssize_t write_file_tx_chainmask(struct file *file, const char __user *use
 	if (strict_strtoul(buf, 0, &mask))
 		return -EINVAL;
 
-	common->tx_chainmask = mask;
-	sc->sc_ah->caps.tx_chainmask = mask;
+	ah->txchainmask = mask;
+	ah->caps.tx_chainmask = mask;
 	return count;
 }
 
@@ -138,11 +138,11 @@ static ssize_t read_file_rx_chainmask(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "0x%08x\n", common->rx_chainmask);
+	len = sprintf(buf, "0x%08x\n", ah->rxchainmask);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -150,7 +150,7 @@ static ssize_t write_file_rx_chainmask(struct file *file, const char __user *use
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
 	unsigned long mask;
 	char buf[32];
 	ssize_t len;
@@ -163,8 +163,8 @@ static ssize_t write_file_rx_chainmask(struct file *file, const char __user *use
 	if (strict_strtoul(buf, 0, &mask))
 		return -EINVAL;
 
-	common->rx_chainmask = mask;
-	sc->sc_ah->caps.rx_chainmask = mask;
+	ah->rxchainmask = mask;
+	ah->caps.rx_chainmask = mask;
 	return count;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 9cf42f6..966661c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -509,8 +509,8 @@ static void setup_ht_cap(struct ath9k_htc_priv *priv,
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
 
 	/* ath9k_htc supports only 1 or 2 stream devices */
-	tx_streams = ath9k_cmn_count_streams(common->tx_chainmask, 2);
-	rx_streams = ath9k_cmn_count_streams(common->rx_chainmask, 2);
+	tx_streams = ath9k_cmn_count_streams(priv->ah->txchainmask, 2);
+	rx_streams = ath9k_cmn_count_streams(priv->ah->rxchainmask, 2);
 
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"TX streams %d, RX streams: %d\n",
@@ -601,9 +601,6 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 
-	common->tx_chainmask = priv->ah->caps.tx_chainmask;
-	common->rx_chainmask = priv->ah->caps.rx_chainmask;
-
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0248024..379f6ba 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -826,8 +826,7 @@ void ath9k_htc_ani_work(struct work_struct *work)
 		if (longcal || shortcal)
 			common->ani.caldone =
 				ath9k_hw_calibrate(ah, ah->curchan,
-						   common->rx_chainmask,
-						   longcal);
+						   ah->rxchainmask, longcal);
 
 		ath9k_htc_ps_restore(priv);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3ccadeb..d63f9c8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1470,9 +1470,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u64 tsf = 0;
 	int i, r;
 
-	ah->txchainmask = common->tx_chainmask;
-	ah->rxchainmask = common->rx_chainmask;
-
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
@@ -2086,6 +2083,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	pCap->tx_chainmask = fixup_chainmask(chip_chainmask, pCap->tx_chainmask);
 	pCap->rx_chainmask = fixup_chainmask(chip_chainmask, pCap->rx_chainmask);
+	ah->txchainmask = pCap->tx_chainmask;
+	ah->rxchainmask = pCap->rx_chainmask;
 
 	ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d7761d1..31ef501 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -270,8 +270,8 @@ static void setup_ht_cap(struct ath_softc *sc,
 
 	/* set up supported mcs set */
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-	tx_streams = ath9k_cmn_count_streams(common->tx_chainmask, max_streams);
-	rx_streams = ath9k_cmn_count_streams(common->rx_chainmask, max_streams);
+	tx_streams = ath9k_cmn_count_streams(ah->txchainmask, max_streams);
+	rx_streams = ath9k_cmn_count_streams(ah->rxchainmask, max_streams);
 
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"TX streams %d, RX streams: %d\n",
@@ -506,9 +506,6 @@ static void ath9k_init_misc(struct ath_softc *sc)
 		sc->sc_flags |= SC_OP_RXAGGR;
 	}
 
-	common->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
-	common->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
-
 	ath9k_hw_set_diversity(sc->sc_ah, true);
 	sc->rx.defant = ath9k_hw_getdefantenna(sc->sc_ah);
 
@@ -645,10 +642,8 @@ static void ath9k_init_band_txpower(struct ath_softc *sc, int band)
 static void ath9k_init_txpower_limits(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_channel *curchan = ah->curchan;
 
-	ah->txchainmask = common->tx_chainmask;
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		ath9k_init_band_txpower(sc, IEEE80211_BAND_2GHZ);
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7ac1c21..085ec20 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -318,7 +318,6 @@ static void ath_paprd_activate(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
-	struct ath_common *common = ath9k_hw_common(ah);
 	int chain;
 
 	if (!caldata || !caldata->paprd_done)
@@ -327,7 +326,7 @@ static void ath_paprd_activate(struct ath_softc *sc)
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_enable(ah, false);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(common->tx_chainmask & BIT(chain)))
+		if (!(ah->txchainmask & BIT(chain)))
 			continue;
 
 		ar9003_paprd_populate_single_table(ah, caldata, chain);
@@ -414,7 +413,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(common->tx_chainmask & BIT(chain)))
+		if (!(ah->txchainmask & BIT(chain)))
 			continue;
 
 		chain_ok = 0;
@@ -535,7 +534,7 @@ void ath_ani_calibrate(unsigned long data)
 	if (longcal || shortcal) {
 		common->ani.caldone =
 			ath9k_hw_calibrate(ah, ah->curchan,
-						common->rx_chainmask, longcal);
+						ah->rxchainmask, longcal);
 	}
 
 	ath9k_ps_restore(sc);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 68066c5..49b93c2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1633,7 +1633,7 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_11n_rate_series series[4];
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
@@ -1693,7 +1693,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 			/* MCS rates */
 			series[i].Rate = rix | 0x80;
 			series[i].ChSel = ath_txchainmask_reduction(sc,
-					common->tx_chainmask, series[i].Rate);
+					ah->txchainmask, series[i].Rate);
 			series[i].PktDuration = ath_pkt_duration(sc, rix, len,
 				 is_40, is_sgi, is_sp);
 			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
@@ -1718,10 +1718,10 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 		}
 
 		if (bf->bf_state.bfs_paprd)
-			series[i].ChSel = common->tx_chainmask;
+			series[i].ChSel = ah->txchainmask;
 		else
 			series[i].ChSel = ath_txchainmask_reduction(sc,
-					common->tx_chainmask, series[i].Rate);
+					ah->txchainmask, series[i].Rate);
 
 		series[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
 			phy, rate->bitrate * 100, len, rix, is_sp);
-- 
1.7.3.2

