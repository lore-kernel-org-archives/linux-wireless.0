Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54318 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaA2THX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:07:23 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0LlGoc-1VbBTI0wEw-00b0as for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:07:22 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 02/13] ath9k: move ath9k_process_rssi to common.c
Date: Wed, 29 Jan 2014 20:06:53 +0100
Message-Id: <1391022424-21087-1-git-send-email-linux@rempel-privat.de> (sfid-20140129_200727_078941_98A0B53D)
In-Reply-To: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we can reuse this fucntion on ath9k_htc.
Now we will need to use common version last_rssi, so switch
it too.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  1 -
 drivers/net/wireless/ath/ath9k/common.c | 62 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h |  4 +++
 drivers/net/wireless/ath/ath9k/init.c   |  2 +-
 drivers/net/wireless/ath/ath9k/main.c   |  2 +-
 drivers/net/wireless/ath/ath9k/recv.c   | 64 +--------------------------------
 6 files changed, 69 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b5ac32c..4ce3787 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -757,7 +757,6 @@ struct ath_softc {
 #endif
 
 	struct ath9k_hw_cal_data caldata;
-	int last_rssi;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath9k_debug debug;
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 768c733..7028c52 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -27,6 +27,68 @@ MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless 802.11n LAN cards.");
 MODULE_LICENSE("Dual BSD/GPL");
 
+void ath9k_cmn_process_rssi(struct ath_common *common,
+			    struct ieee80211_hw *hw,
+			    struct ath_rx_status *rx_stats,
+			    struct ieee80211_rx_status *rxs)
+{
+	struct ath_hw *ah = common->ah;
+	int last_rssi;
+	int rssi = rx_stats->rs_rssi;
+	int i, j;
+
+	/*
+	 * RSSI is not available for subframes in an A-MPDU.
+	 */
+	if (rx_stats->rs_moreaggr) {
+		rxs->flag |= RX_FLAG_NO_SIGNAL_VAL;
+		return;
+	}
+
+	/*
+	 * Check if the RSSI for the last subframe in an A-MPDU
+	 * or an unaggregated frame is valid.
+	 */
+	if (rx_stats->rs_rssi == ATH9K_RSSI_BAD) {
+		rxs->flag |= RX_FLAG_NO_SIGNAL_VAL;
+		return;
+	}
+
+	for (i = 0, j = 0; i < ARRAY_SIZE(rx_stats->rs_rssi_ctl); i++) {
+		s8 rssi;
+
+		if (!(ah->rxchainmask & BIT(i)))
+			continue;
+
+		rssi = rx_stats->rs_rssi_ctl[i];
+		if (rssi != ATH9K_RSSI_BAD) {
+		    rxs->chains |= BIT(j);
+		    rxs->chain_signal[j] = ah->noise + rssi;
+		}
+		j++;
+	}
+
+	/*
+	 * Update Beacon RSSI, this is used by ANI.
+	 */
+	if (rx_stats->is_mybeacon &&
+	    ((ah->opmode == NL80211_IFTYPE_STATION) ||
+	     (ah->opmode == NL80211_IFTYPE_ADHOC))) {
+		ATH_RSSI_LPF(common->last_rssi, rx_stats->rs_rssi);
+		last_rssi = common->last_rssi;
+
+		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
+			rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
+		if (rssi < 0)
+			rssi = 0;
+
+		ah->stats.avgbrssi = rssi;
+	}
+
+	rxs->signal = ah->noise + rx_stats->rs_rssi;
+}
+EXPORT_SYMBOL(ath9k_cmn_process_rssi);
+
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index eb85e1b..aaf4a9b5 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -42,6 +42,10 @@
 #define ATH_EP_RND(x, mul) 						\
 	(((x) + ((mul)/2)) / (mul))
 
+void ath9k_cmn_process_rssi(struct ath_common *common,
+			    struct ieee80211_hw *hw,
+			    struct ath_rx_status *rx_stats,
+			    struct ieee80211_rx_status *rxs);
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
 struct ath9k_channel *ath9k_cmn_get_channel(struct ieee80211_hw *hw,
 					    struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c36de30..00e0f60 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -534,7 +534,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 
 	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
-	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
+	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	sc->config.txpowlimit = ATH_TXPOWER_MAX;
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5924f72..c3e15f8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1609,7 +1609,7 @@ static void ath9k_set_assoc_state(struct ath_softc *sc,
 	common->curaid = bss_conf->aid;
 	ath9k_hw_write_associd(sc->sc_ah);
 
-	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
+	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a0ebdd0..5229e63 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -891,68 +891,6 @@ static int ath9k_process_rate(struct ath_common *common,
 	return -EINVAL;
 }
 
-static void ath9k_process_rssi(struct ath_common *common,
-			       struct ieee80211_hw *hw,
-			       struct ath_rx_status *rx_stats,
-			       struct ieee80211_rx_status *rxs)
-{
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = common->ah;
-	int last_rssi;
-	int rssi = rx_stats->rs_rssi;
-	int i, j;
-
-	/*
-	 * RSSI is not available for subframes in an A-MPDU.
-	 */
-	if (rx_stats->rs_moreaggr) {
-		rxs->flag |= RX_FLAG_NO_SIGNAL_VAL;
-		return;
-	}
-
-	/*
-	 * Check if the RSSI for the last subframe in an A-MPDU
-	 * or an unaggregated frame is valid.
-	 */
-	if (rx_stats->rs_rssi == ATH9K_RSSI_BAD) {
-		rxs->flag |= RX_FLAG_NO_SIGNAL_VAL;
-		return;
-	}
-
-	for (i = 0, j = 0; i < ARRAY_SIZE(rx_stats->rs_rssi_ctl); i++) {
-		s8 rssi;
-
-		if (!(ah->rxchainmask & BIT(i)))
-			continue;
-
-		rssi = rx_stats->rs_rssi_ctl[i];
-		if (rssi != ATH9K_RSSI_BAD) {
-		    rxs->chains |= BIT(j);
-		    rxs->chain_signal[j] = ah->noise + rssi;
-		}
-		j++;
-	}
-
-	/*
-	 * Update Beacon RSSI, this is used by ANI.
-	 */
-	if (rx_stats->is_mybeacon &&
-	    ((ah->opmode == NL80211_IFTYPE_STATION) ||
-	     (ah->opmode == NL80211_IFTYPE_ADHOC))) {
-		ATH_RSSI_LPF(sc->last_rssi, rx_stats->rs_rssi);
-		last_rssi = sc->last_rssi;
-
-		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-			rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
-		if (rssi < 0)
-			rssi = 0;
-
-		ah->stats.avgbrssi = rssi;
-	}
-
-	rxs->signal = ah->noise + rx_stats->rs_rssi;
-}
-
 static void ath9k_process_tsf(struct ath_rx_status *rs,
 			      struct ieee80211_rx_status *rxs,
 			      u64 tsf)
@@ -1074,7 +1012,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		goto exit;
 	}
 
-	ath9k_process_rssi(common, hw, rx_stats, rx_status);
+	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
 
 	rx_status->band = ah->curchan->chan->band;
 	rx_status->freq = ah->curchan->chan->center_freq;
-- 
1.8.5.3

