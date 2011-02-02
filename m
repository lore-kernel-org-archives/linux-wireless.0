Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab1BBP6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 10:58:07 -0500
Subject: [PATCH 2.6.38] mac80211: fix TX status cookie in HW offload case
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 16:58:06 +0100
Message-ID: <1296662286.5671.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the off-channel TX is done with remain-on-channel
offloaded to hardware, the reported cookie is wrong as
in that case we shouldn't use the SKB as the cookie but
need to instead use the corresponding r-o-c cookie
(XOR'ed with 2 to prevent API mismatches).

Fix this by keeping track of the hw_roc_skb pointer
just for the status processing and use the correct
cookie to report in this case. We can't use the
hw_roc_skb pointer itself because it is NULL'ed when
the frame is transmitted to prevent it being used
twice.

This fixes a bug where the P2P state machine in the
supplicant gets stuck because it never gets a correct
result for its transmitted frame.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |    2 ++
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/status.c      |    7 ++++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/status.c	2010-12-07 22:41:58.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2011-02-02 16:52:19.000000000 +0100
@@ -323,6 +323,7 @@ void ieee80211_tx_status(struct ieee8021
 
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
 		struct ieee80211_work *wk;
+		u64 cookie = (unsigned long)skb;
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(wk, &local->work_list, list) {
@@ -334,8 +335,12 @@ void ieee80211_tx_status(struct ieee8021
 			break;
 		}
 		rcu_read_unlock();
+		if (local->hw_roc_skb_for_status == skb) {
+			cookie = local->hw_roc_cookie ^ 2;
+			local->hw_roc_skb_for_status = NULL;
+		}
 		cfg80211_mgmt_tx_status(
-			skb->dev, (unsigned long) skb, skb->data, skb->len,
+			skb->dev, cookie, skb->data, skb->len,
 			!!(info->flags & IEEE80211_TX_STAT_ACK), GFP_ATOMIC);
 	}
 
--- wireless-testing.orig/net/mac80211/cfg.c	2011-02-01 15:38:56.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2011-02-02 16:52:19.000000000 +0100
@@ -1852,6 +1852,7 @@ static int ieee80211_mgmt_tx(struct wiph
 		*cookie ^= 2;
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
 		local->hw_roc_skb = skb;
+		local->hw_roc_skb_for_status = skb;
 		mutex_unlock(&local->mtx);
 
 		return 0;
@@ -1917,6 +1918,7 @@ static int ieee80211_mgmt_tx_cancel_wait
 		if (ret == 0) {
 			kfree_skb(local->hw_roc_skb);
 			local->hw_roc_skb = NULL;
+			local->hw_roc_skb_for_status = NULL;
 		}
 
 		mutex_unlock(&local->mtx);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2011-02-01 15:38:56.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2011-02-02 16:52:19.000000000 +0100
@@ -953,7 +953,7 @@ struct ieee80211_local {
 
 	struct ieee80211_channel *hw_roc_channel;
 	struct net_device *hw_roc_dev;
-	struct sk_buff *hw_roc_skb;
+	struct sk_buff *hw_roc_skb, *hw_roc_skb_for_status;
 	struct work_struct hw_roc_start, hw_roc_done;
 	enum nl80211_channel_type hw_roc_channel_type;
 	unsigned int hw_roc_duration;


