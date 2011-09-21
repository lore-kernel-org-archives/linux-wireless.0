Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7125 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1IUMgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 08:36:45 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 4/4] mac80211: set the request rate as lowest on for mgmt frames
Date: Wed, 21 Sep 2011 18:07:00 +0530
Message-ID: <1316608620-16483-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110921_143649_038349_719B84D8)
In-Reply-To: <1316608620-16483-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316608620-16483-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the ath9k/minstral rate control sets the least
supported rate as first rate for all management frames.
This patch set the requested rate as first rate that was
derived either from scan request or from the tx info.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/rate.c |   69 ++++++++++++++++++++++++++++----------------------
 1 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3d5a2cb..232acd5 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -233,36 +233,6 @@ static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
 	/* could not find a basic rate; use original selection */
 }
 
-bool rate_control_send_low(struct ieee80211_sta *sta,
-			   void *priv_sta,
-			   struct ieee80211_tx_rate_control *txrc)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
-	struct ieee80211_supported_band *sband = txrc->sband;
-	int mcast_rate;
-
-	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc)) {
-		info->control.rates[0].idx = rate_lowest_index(txrc->sband, sta);
-		info->control.rates[0].count =
-			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-			1 : txrc->hw->max_rate_tries;
-		if (!sta && txrc->bss) {
-			mcast_rate = txrc->bss_conf->mcast_rate[sband->band];
-			if (mcast_rate > 0) {
-				info->control.rates[0].idx = mcast_rate - 1;
-				return true;
-			}
-
-			rc_send_low_broadcast(&info->control.rates[0].idx,
-					      txrc->bss_conf->basic_rates,
-					      sband);
-		}
-		return true;
-	}
-	return false;
-}
-EXPORT_SYMBOL(rate_control_send_low);
-
 static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 				int n_bitrates, u32 mask)
 {
@@ -295,6 +265,45 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 	 */
 }
 
+bool rate_control_send_low(struct ieee80211_sta *sta,
+			   void *priv_sta,
+			   struct ieee80211_tx_rate_control *txrc)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
+	struct ieee80211_supported_band *sband = txrc->sband;
+	int mcast_rate;
+
+	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc)) {
+		if (txrc->max_rate_idx != -1) {
+			rate_idx_match_mask(&info->control.rates[0],
+					    txrc->sband->n_bitrates,
+					    txrc->rate_idx_mask);
+			if (info->control.rates[0].idx == -1)
+				txrc->max_rate_idx = -1;
+		}
+		if (txrc->max_rate_idx == -1)
+			info->control.rates[0].idx =
+				rate_lowest_index(txrc->sband, sta);
+		info->control.rates[0].count =
+			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
+			1 : txrc->hw->max_rate_tries;
+		if (!sta && txrc->bss) {
+			mcast_rate = txrc->bss_conf->mcast_rate[sband->band];
+			if (mcast_rate > 0) {
+				info->control.rates[0].idx = mcast_rate - 1;
+				return true;
+			}
+
+			rc_send_low_broadcast(&info->control.rates[0].idx,
+					      txrc->bss_conf->basic_rates,
+					      sband);
+		}
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(rate_control_send_low);
+
 void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc)
-- 
1.7.6.3

