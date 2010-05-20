Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21646 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab0ETVex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 17:34:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 14:34:53 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k: Clean up few function parameters in recv.c
Date: Thu, 20 May 2010 14:34:46 -0700
Message-ID: <1274391288-14633-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_rx_skb_preprocess() needs only ieee80211 frame header,
pass only frame headers instead of skb to that function. Also
remove ineffective frame dump in ath9k_process_rate().

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d855155..512b3f0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -820,16 +820,14 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 
 /* Assumes you've already done the endian to CPU conversion */
 static bool ath9k_rx_accept(struct ath_common *common,
-			    struct sk_buff *skb,
+			    struct ieee80211_hdr *hdr,
 			    struct ieee80211_rx_status *rxs,
 			    struct ath_rx_status *rx_stats,
 			    bool *decrypt_error)
 {
 	struct ath_hw *ah = common->ah;
-	struct ieee80211_hdr *hdr;
 	__le16 fc;
 
-	hdr = (struct ieee80211_hdr *) skb->data;
 	fc = hdr->frame_control;
 
 	if (!rx_stats->rs_datalen)
@@ -900,8 +898,7 @@ static bool ath9k_rx_accept(struct ath_common *common,
 static int ath9k_process_rate(struct ath_common *common,
 			      struct ieee80211_hw *hw,
 			      struct ath_rx_status *rx_stats,
-			      struct ieee80211_rx_status *rxs,
-			      struct sk_buff *skb)
+			      struct ieee80211_rx_status *rxs)
 {
 	struct ieee80211_supported_band *sband;
 	enum ieee80211_band band;
@@ -939,25 +936,21 @@ static int ath9k_process_rate(struct ath_common *common,
 	 */
 	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
 		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
-	if ((common->debug_mask & ATH_DBG_XMIT))
-		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
 
 	return -EINVAL;
 }
 
 static void ath9k_process_rssi(struct ath_common *common,
 			       struct ieee80211_hw *hw,
-			       struct sk_buff *skb,
+			       struct ieee80211_hdr *hdr,
 			       struct ath_rx_status *rx_stats)
 {
 	struct ath_hw *ah = common->ah;
 	struct ieee80211_sta *sta;
-	struct ieee80211_hdr *hdr;
 	struct ath_node *an;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 	__le16 fc;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 
 	rcu_read_lock();
@@ -996,7 +989,7 @@ static void ath9k_process_rssi(struct ath_common *common,
  */
 static int ath9k_rx_skb_preprocess(struct ath_common *common,
 				   struct ieee80211_hw *hw,
-				   struct sk_buff *skb,
+				   struct ieee80211_hdr *hdr,
 				   struct ath_rx_status *rx_stats,
 				   struct ieee80211_rx_status *rx_status,
 				   bool *decrypt_error)
@@ -1009,12 +1002,12 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
-	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
+	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error))
 		return -EINVAL;
 
-	ath9k_process_rssi(common, hw, skb, rx_stats);
+	ath9k_process_rssi(common, hw, hdr, rx_stats);
 
-	if (ath9k_process_rate(common, hw, rx_stats, rx_status, skb))
+	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
 		return -EINVAL;
 
 	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
@@ -1139,7 +1132,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (flush)
 			goto requeue;
 
-		retval = ath9k_rx_skb_preprocess(common, hw, skb, &rs,
+		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
 						 rxs, &decrypt_error);
 		if (retval)
 			goto requeue;
-- 
1.7.0.4

