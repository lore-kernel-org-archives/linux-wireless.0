Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56135 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932267Ab0KKCfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 21:35:12 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/5] ath9k: handle tx underrun in the driver instead of rate control
Date: Thu, 11 Nov 2010 03:18:35 +0100
Message-Id: <1289441918-94905-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289441918-94905-1-git-send-email-nbd@openwrt.org>
References: <1289441918-94905-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/rc.c   |   18 ------------------
 drivers/net/wireless/ath/ath9k/rc.h   |    2 --
 drivers/net/wireless/ath/ath9k/xmit.c |   25 ++++++++++++++++++++-----
 3 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index c052bd6..33bb33b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1354,22 +1354,6 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		tx_info->status.ampdu_len = 1;
 	}
 
-	/*
-	 * If an underrun error is seen assume it as an excessive retry only
-	 * if max frame trigger level has been reached (2 KB for singel stream,
-	 * and 4 KB for dual stream). Adjust the long retry as if the frame was
-	 * tried hw->max_rate_tries times to affect how ratectrl updates PER for
-	 * the failed rate. In case of congestion on the bus penalizing these
-	 * type of underruns should help hardware actually transmit new frames
-	 * successfully by eventually preferring slower rates. This itself
-	 * should also alleviate congestion on the bus.
-	 */
-	if ((tx_info->pad[0] & ATH_TX_INFO_UNDERRUN) &&
-	    (sc->sc_ah->tx_trig_level >= ath_rc_priv->tx_triglevel_max)) {
-		tx_status = 1;
-		is_underrun = 1;
-	}
-
 	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
 		tx_status = 1;
 
@@ -1596,8 +1580,6 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 		return NULL;
 	}
 
-	rate_priv->tx_triglevel_max = sc->sc_ah->caps.tx_triglevel_max;
-
 	return rate_priv;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index a1dce43..a96f5eb 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -215,7 +215,6 @@ struct ath_rate_priv {
 	u32 per_down_time;
 	u32 probe_interval;
 	u32 prev_data_rix;
-	u32 tx_triglevel_max;
 	struct ath_rateset neg_rates;
 	struct ath_rateset neg_ht_rates;
 	struct ath_rate_softc *asc;
@@ -227,7 +226,6 @@ struct ath_rate_priv {
 
 #define ATH_TX_INFO_FRAME_TYPE_INTERNAL	(1 << 0)
 #define ATH_TX_INFO_FRAME_TYPE_PAUSE	(1 << 1)
-#define ATH_TX_INFO_UNDERRUN		(1 << 4)
 
 enum ath9k_internal_frame_type {
 	ATH9K_IFT_NOT_INTERNAL,
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index eaaeb93..8785ec3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1968,6 +1968,8 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hw *hw = bf->aphy->hw;
+	struct ath_softc *sc = bf->aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
 	u8 i, tx_rateindex;
 
 	if (txok)
@@ -1989,11 +1991,24 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0 && update_rc) {
-		if (ieee80211_is_data(hdr->frame_control)) {
-			if (ts->ts_flags &
-			    (ATH9K_TX_DATA_UNDERRUN | ATH9K_TX_DELIM_UNDERRUN))
-				tx_info->pad[0] |= ATH_TX_INFO_UNDERRUN;
-		}
+		/*
+		 * If an underrun error is seen assume it as an excessive
+		 * retry only if max frame trigger level has been reached
+		 * (2 KB for single stream, and 4 KB for dual stream).
+		 * Adjust the long retry as if the frame was tried
+		 * hw->max_rate_tries times to affect how rate control updates
+		 * PER for the failed rate.
+		 * In case of congestion on the bus penalizing this type of
+		 * underruns should help hardware actually transmit new frames
+		 * successfully by eventually preferring slower rates.
+		 * This itself should also alleviate congestion on the bus.
+		 */
+		if (ieee80211_is_data(hdr->frame_control) &&
+		    (ts->ts_flags & (ATH9K_TX_DATA_UNDERRUN |
+		                     ATH9K_TX_DELIM_UNDERRUN)) &&
+		    ah->tx_trig_level >= sc->sc_ah->caps.tx_triglevel_max)
+			tx_info->status.rates[tx_rateindex].count =
+				hw->max_rate_tries;
 	}
 
 	for (i = tx_rateindex + 1; i < hw->max_rates; i++) {
-- 
1.7.2.2

