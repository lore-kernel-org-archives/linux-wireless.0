Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41645 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdJaA3J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 20:29:09 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] mac80211: Update last_ack status for all except probing frames
Date: Mon, 30 Oct 2017 17:29:06 -0700
Message-ID: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20171031_012913_483741_62CBEDD5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update last_ack status for all except station probing frames
(i.e null data). Otherwise the station inactivity duration is
cleared whenever AP is checking presence of idle stations by sending
null data frame for every inactive threshold (ap_max_inactivity).
Though the station is idle for longer period, the inactive
time in station dump is restricted ap_max_inactivity threshold.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 net/mac80211/status.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index da7427a41529..24ce416f74cd 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -185,10 +185,21 @@ static void ieee80211_check_pending_bar(struct sta_info *sta, u8 *addr, u8 tid)
 static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
-	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+	/* Update last_ack status for all except station probing frames
+	 * (i.e null data). Otherwise the station inactivity duration is cleared
+	 * whenever AP is checking presence of idle stations by sending
+	 * null data frame for every inactive threshold (ap_max_inactivity).
+	 * Though the station is idle for longer period, the inactive time in
+	 * station dump is restricted ap_max_inactivity threshold.
+	 */
+	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS) &&
+	    !((info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) &&
+	      (ieee80211_is_nullfunc(mgmt->frame_control) ||
+	       ieee80211_is_qos_nullfunc(mgmt->frame_control))))
 		sta->status_stats.last_ack = jiffies;
 
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
-- 
1.9.1
