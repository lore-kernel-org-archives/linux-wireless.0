Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59885 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbaA2THd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:07:33 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0LcmN9-1VS8uq1drz-00k7Pj for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:07:31 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 03/13] ath9k: move ath9k_process_rate to common.c
Date: Wed, 29 Jan 2014 20:06:54 +0100
Message-Id: <1391022424-21087-2-git-send-email-linux@rempel-privat.de> (sfid-20140129_200735_548349_9C7B5D0D)
In-Reply-To: <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
 <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we can reuse this function in ath9k_htc

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common.c | 42 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h |  4 +++
 drivers/net/wireless/ath/ath9k/recv.c   | 59 +++++----------------------------
 3 files changed, 54 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 7028c52..120fd46 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -27,6 +27,48 @@ MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless 802.11n LAN cards.");
 MODULE_LICENSE("Dual BSD/GPL");
 
+int ath9k_cmn_process_rate(struct ath_common *common,
+			   struct ieee80211_hw *hw,
+			   struct ath_rx_status *rx_stats,
+			   struct ieee80211_rx_status *rxs)
+{
+	struct ieee80211_supported_band *sband;
+	enum ieee80211_band band;
+	unsigned int i = 0;
+	struct ath_hw *ah = common->ah;
+
+	band = ah->curchan->chan->band;
+	sband = hw->wiphy->bands[band];
+
+	if (IS_CHAN_QUARTER_RATE(ah->curchan))
+		rxs->flag |= RX_FLAG_5MHZ;
+	else if (IS_CHAN_HALF_RATE(ah->curchan))
+		rxs->flag |= RX_FLAG_10MHZ;
+
+	if (rx_stats->rs_rate & 0x80) {
+		/* HT rate */
+		rxs->flag |= RX_FLAG_HT;
+		rxs->flag |= rx_stats->flag;
+		rxs->rate_idx = rx_stats->rs_rate & 0x7f;
+		return 0;
+	}
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (sband->bitrates[i].hw_value == rx_stats->rs_rate) {
+			rxs->rate_idx = i;
+			return 0;
+		}
+		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
+			rxs->flag |= RX_FLAG_SHORTPRE;
+			rxs->rate_idx = i;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ath9k_cmn_process_rate);
+
 void ath9k_cmn_process_rssi(struct ath_common *common,
 			    struct ieee80211_hw *hw,
 			    struct ath_rx_status *rx_stats,
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index aaf4a9b5..729482f 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -42,6 +42,10 @@
 #define ATH_EP_RND(x, mul) 						\
 	(((x) + ((mul)/2)) / (mul))
 
+int ath9k_cmn_process_rate(struct ath_common *common,
+			   struct ieee80211_hw *hw,
+			   struct ath_rx_status *rx_stats,
+			   struct ieee80211_rx_status *rxs);
 void ath9k_cmn_process_rssi(struct ath_common *common,
 			    struct ieee80211_hw *hw,
 			    struct ath_rx_status *rx_stats,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 5229e63..ab6a86c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -841,56 +841,6 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	return true;
 }
 
-static int ath9k_process_rate(struct ath_common *common,
-			      struct ieee80211_hw *hw,
-			      struct ath_rx_status *rx_stats,
-			      struct ieee80211_rx_status *rxs)
-{
-	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
-	unsigned int i = 0;
-	struct ath_softc __maybe_unused *sc = common->priv;
-	struct ath_hw *ah = sc->sc_ah;
-
-	band = ah->curchan->chan->band;
-	sband = hw->wiphy->bands[band];
-
-	if (IS_CHAN_QUARTER_RATE(ah->curchan))
-		rxs->flag |= RX_FLAG_5MHZ;
-	else if (IS_CHAN_HALF_RATE(ah->curchan))
-		rxs->flag |= RX_FLAG_10MHZ;
-
-	if (rx_stats->rs_rate & 0x80) {
-		/* HT rate */
-		rxs->flag |= RX_FLAG_HT;
-		rxs->flag |= rx_stats->flag;
-		rxs->rate_idx = rx_stats->rs_rate & 0x7f;
-		return 0;
-	}
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_stats->rs_rate) {
-			rxs->rate_idx = i;
-			return 0;
-		}
-		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
-			rxs->flag |= RX_FLAG_SHORTPRE;
-			rxs->rate_idx = i;
-			return 0;
-		}
-	}
-
-	/*
-	 * No valid hardware bitrate found -- we should not get here
-	 * because hardware has already validated this frame as OK.
-	 */
-	ath_dbg(common, ANY,
-		"unsupported hw bitrate detected 0x%02x using 1 Mbit\n",
-		rx_stats->rs_rate);
-	RX_STAT_INC(rx_rate_err);
-	return -EINVAL;
-}
-
 static void ath9k_process_tsf(struct ath_rx_status *rs,
 			      struct ieee80211_rx_status *rxs,
 			      u64 tsf)
@@ -1007,7 +957,14 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		goto exit;
 	}
 
-	if (ath9k_process_rate(common, hw, rx_stats, rx_status)) {
+	if (ath9k_cmn_process_rate(common, hw, rx_stats, rx_status)) {
+		/*
+		 * No valid hardware bitrate found -- we should not get here
+		 * because hardware has already validated this frame as OK.
+		 */
+		ath_dbg(common, ANY, "unsupported hw bitrate detected 0x%02x using 1 Mbit\n",
+			rx_stats->rs_rate);
+		RX_STAT_INC(rx_rate_err);
 		ret =-EINVAL;
 		goto exit;
 	}
-- 
1.8.5.3

