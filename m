Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020Ab3CHKJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 05:09:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix crash with P2P Device returning action frames
Date: Fri,  8 Mar 2013 11:09:52 +0100
Message-Id: <1362737392-10782-1-git-send-email-johannes@sipsolutions.net> (sfid-20130308_111001_541108_74286781)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a P2P Device interface receives an unhandled action
frame, we attempt to return it. This crashes because it
doesn't have a channel context. Fix the crash by using
status->band and properly mark the return frame as an
off-channel frame.

Reported-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5b4492a..2528b5a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2666,7 +2666,19 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 
 		memset(nskb->cb, 0, sizeof(nskb->cb));
 
-		ieee80211_tx_skb(rx->sdata, nskb);
+		if (rx->sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE) {
+			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(nskb);
+
+			info->flags = IEEE80211_TX_CTL_TX_OFFCHAN |
+				      IEEE80211_TX_INTFL_OFFCHAN_TX_OK |
+				      IEEE80211_TX_CTL_NO_CCK_RATE;
+			if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
+				info->hw_queue =
+					local->hw.offchannel_tx_hw_queue;
+		}
+
+		__ieee80211_tx_skb_tid_band(rx->sdata, nskb, 7,
+					    status->band);
 	}
 	dev_kfree_skb(rx->skb);
 	return RX_QUEUED;
-- 
1.8.0

