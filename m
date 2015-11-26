Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36351 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbbKZK5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 05:57:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/8] mac80211: simplify ack_skb handling
Date: Thu, 26 Nov 2015 11:57:46 +0100
Message-Id: <1448535468-12237-6-git-send-email-johannes@sipsolutions.net> (sfid-20151126_115831_403225_6B92992A)
In-Reply-To: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
References: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the cookie is assigned inside ieee80211_make_ack_skb()
now, we no longer need to return the ack_skb as the cookie
and can simplify the function's return and the callers. Also
rename it to ieee80211_attach_ack_skb() to more accurately
reflect its purpose.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 18 ++++++++----------
 net/mac80211/ieee80211_i.h |  5 ++---
 net/mac80211/offchannel.c  | 11 +++--------
 3 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ae1b92a58e23..2274a163874f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2992,9 +2992,8 @@ u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local)
 	return local->roc_cookie_counter;
 }
 
-struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
-				       struct sk_buff *skb, u64 *cookie,
-				       gfp_t gfp)
+int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
+			     u64 *cookie, gfp_t gfp)
 {
 	unsigned long spin_flags;
 	struct sk_buff *ack_skb;
@@ -3002,7 +3001,7 @@ struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
 
 	ack_skb = skb_copy(skb, gfp);
 	if (!ack_skb)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	spin_lock_irqsave(&local->ack_status_lock, spin_flags);
 	id = idr_alloc(&local->ack_status_frames, ack_skb,
@@ -3011,7 +3010,7 @@ struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
 
 	if (id < 0) {
 		kfree_skb(ack_skb);
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
 	IEEE80211_SKB_CB(skb)->ack_frame_id = id;
@@ -3019,7 +3018,7 @@ struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
 	*cookie = ieee80211_mgmt_tx_cookie(local);
 	IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
 
-	return ack_skb;
+	return 0;
 }
 
 static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
@@ -3097,7 +3096,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_qos_hdr *nullfunc;
-	struct sk_buff *skb, *ack_skb;
+	struct sk_buff *skb;
 	int size = sizeof(*nullfunc);
 	__le16 fc;
 	bool qos;
@@ -3165,10 +3164,9 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	if (qos)
 		nullfunc->qos_ctrl = cpu_to_le16(7);
 
-	ack_skb = ieee80211_make_ack_skb(local, skb, cookie, GFP_ATOMIC);
-	if (IS_ERR(ack_skb)) {
+	ret = ieee80211_attach_ack_skb(local, skb, cookie, GFP_ATOMIC);
+	if (ret) {
 		kfree_skb(skb);
-		ret = PTR_ERR(ack_skb);
 		goto unlock;
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b03d5410a2e9..0c50031fadac 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1484,9 +1484,8 @@ void ieee80211_configure_filter(struct ieee80211_local *local);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
 u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local);
-struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
-				       struct sk_buff *skb, u64 *cookie,
-				       gfp_t gfp);
+int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
+			     u64 *cookie, gfp_t gfp);
 
 /* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index bf21301dfa4b..d616ce34fea7 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -733,7 +733,7 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb, *ack_skb;
+	struct sk_buff *skb;
 	struct sta_info *sta;
 	const struct ieee80211_mgmt *mgmt = (void *)params->buf;
 	bool need_offchan = false;
@@ -876,16 +876,11 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		/* make a copy to preserve the frame contents
 		 * in case of encryption.
 		 */
-		ack_skb = ieee80211_make_ack_skb(local, skb, cookie,
-						 GFP_KERNEL);
-		if (IS_ERR(ack_skb)) {
-			ret = PTR_ERR(ack_skb);
+		ret = ieee80211_attach_ack_skb(local, skb, cookie, GFP_KERNEL);
+		if (ret) {
 			kfree_skb(skb);
 			goto out_unlock;
 		}
-	} else {
-		/* for cookie below */
-		ack_skb = skb;
 	}
 
 	if (!need_offchan) {
-- 
2.6.2

