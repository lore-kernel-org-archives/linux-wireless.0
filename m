Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38829 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab3GDHdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 03:33:02 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix RTS threshold
Date: Thu,  4 Jul 2013 12:59:47 +0530
Message-Id: <1372922987-11240-1-git-send-email-sujith@msujith.org> (sfid-20130704_093305_711608_25216813)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Currently, RTS threshold is not handled for HT. Handle
user-specified threshold values for both aggregated
and unaggregated frames. Use the wiphy's threshold
parameter for now, it can be made per-VIF later on.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 36 +++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9279927..52cd521 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1023,7 +1023,7 @@ void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop)
 }
 
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
-			     struct ath_tx_info *info, int len)
+			     struct ath_tx_info *info, int len, bool rts)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct sk_buff *skb;
@@ -1032,6 +1032,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 	const struct ieee80211_rate *rate;
 	struct ieee80211_hdr *hdr;
 	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
+	u32 rts_thresh = sc->hw->wiphy->rts_threshold;
 	int i;
 	u8 rix = 0;
 
@@ -1054,7 +1055,17 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 		rix = rates[i].idx;
 		info->rates[i].Tries = rates[i].count;
 
-		    if (rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
+		/*
+		 * Handle RTS threshold for unaggregated HT frames.
+		 */
+		if (bf_isampdu(bf) && !bf_isaggr(bf) &&
+		    (rates[i].flags & IEEE80211_TX_RC_MCS) &&
+		    unlikely(rts_thresh != (u32) -1)) {
+			if (!rts_thresh || (len > rts_thresh))
+				rts = true;
+		}
+
+		if (rts || rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 			info->rates[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
 			info->flags |= ATH9K_TXDESC_RTSENA;
 		} else if (rates[i].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
@@ -1147,6 +1158,8 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf_first = NULL;
 	struct ath_tx_info info;
+	u32 rts_thresh = sc->hw->wiphy->rts_threshold;
+	bool rts = false;
 
 	memset(&info, 0, sizeof(info));
 	info.is_first = true;
@@ -1183,7 +1196,22 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 				info.flags |= (u32) bf->bf_state.bfs_paprd <<
 					      ATH9K_TXDESC_PAPRD_S;
 
-			ath_buf_set_rate(sc, bf, &info, len);
+			/*
+			 * mac80211 doesn't handle RTS threshold for HT because
+			 * the decision has to be taken based on AMPDU length
+			 * and aggregation is done entirely inside ath9k.
+			 * Set the RTS/CTS flag for the first subframe based
+			 * on the threshold.
+			 */
+			if (aggr && (bf == bf_first) &&
+			    unlikely(rts_thresh != (u32) -1)) {
+				/*
+				 * "len" is the size of the entire AMPDU.
+				 */
+				if (!rts_thresh || (len > rts_thresh))
+					rts = true;
+			}
+			ath_buf_set_rate(sc, bf, &info, len, rts);
 		}
 
 		info.buf_addr[0] = bf->bf_buf_addr;
@@ -2168,7 +2196,7 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 		bf->bf_lastbf = bf;
 		ath_set_rates(vif, NULL, bf);
-		ath_buf_set_rate(sc, bf, &info, fi->framelen);
+		ath_buf_set_rate(sc, bf, &info, fi->framelen, false);
 		duration += info.rates[0].PktDuration;
 		if (bf_tail)
 			bf_tail->bf_next = bf;
-- 
1.8.3.2

