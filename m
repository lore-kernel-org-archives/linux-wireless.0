Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38318 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbbFBLce (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 07:32:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: stop using pointers as userspace cookies
Date: Tue,  2 Jun 2015 13:32:29 +0200
Message-Id: <1433244749-13800-2-git-send-email-johannes@sipsolutions.net> (sfid-20150602_133240_383909_F26197E5)
In-Reply-To: <1433244749-13800-1-git-send-email-johannes@sipsolutions.net>
References: <1433244749-13800-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even if the pointers are really only accessible to root and used
pretty much only by wpa_supplicant, this is still not great; even
for debugging it'd be easier to have something that's easier to
read and guaranteed to never get reused.

With the recent change to make mac80211 create an ack_skb for the
mgmt-tx path this becomes possible, only the client probe method
needs to also allocate an ack_skb, and we can store the cookie in
that skb.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   3 ++
 net/mac80211/cfg.c     | 115 +++++++++++++++++++++++++++++++------------------
 net/mac80211/status.c  |  27 ++++++------
 3 files changed, 90 insertions(+), 55 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 39e864b35083..7466c55bfc0b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -875,6 +875,9 @@ struct ieee80211_tx_info {
 			/* 4 bytes free */
 		} control;
 		struct {
+			u64 cookie;
+		} ack;
+		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
 			s32 ack_signal;
 			u8 ampdu_ack_len;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5ba528f13300..1a17d3208d8f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2546,6 +2546,19 @@ static bool ieee80211_coalesce_started_roc(struct ieee80211_local *local,
 	return true;
 }
 
+static u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local)
+{
+	lockdep_assert_held(&local->mtx);
+
+	local->roc_cookie_counter++;
+
+	/* wow, you wrapped 64 bits ... more likely a bug */
+	if (WARN_ON(local->roc_cookie_counter == 0))
+		local->roc_cookie_counter++;
+
+	return local->roc_cookie_counter;
+}
+
 static int ieee80211_start_roc_work(struct ieee80211_local *local,
 				    struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_channel *channel,
@@ -2583,7 +2596,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	roc->req_duration = duration;
 	roc->frame = txskb;
 	roc->type = type;
-	roc->mgmt_tx_cookie = (unsigned long)txskb;
 	roc->sdata = sdata;
 	INIT_DELAYED_WORK(&roc->work, ieee80211_sw_roc_work);
 	INIT_LIST_HEAD(&roc->dependents);
@@ -2593,17 +2605,10 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	 * or the SKB (for mgmt TX)
 	 */
 	if (!txskb) {
-		/* local->mtx protects this */
-		local->roc_cookie_counter++;
-		roc->cookie = local->roc_cookie_counter;
-		/* wow, you wrapped 64 bits ... more likely a bug */
-		if (WARN_ON(roc->cookie == 0)) {
-			roc->cookie = 1;
-			local->roc_cookie_counter++;
-		}
+		roc->cookie = ieee80211_mgmt_tx_cookie(local);
 		*cookie = roc->cookie;
 	} else {
-		*cookie = (unsigned long)txskb;
+		roc->mgmt_tx_cookie = *cookie;
 	}
 
 	/* if there's one pending or we're scanning, queue this one */
@@ -3284,6 +3289,36 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return err;
 }
 
+static struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
+					      struct sk_buff *skb, u64 *cookie,
+					      gfp_t gfp)
+{
+	unsigned long spin_flags;
+	struct sk_buff *ack_skb;
+	int id;
+
+	ack_skb = skb_copy(skb, gfp);
+	if (!ack_skb)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_irqsave(&local->ack_status_lock, spin_flags);
+	id = idr_alloc(&local->ack_status_frames, ack_skb,
+		       1, 0x10000, GFP_ATOMIC);
+	spin_unlock_irqrestore(&local->ack_status_lock, spin_flags);
+
+	if (id < 0) {
+		kfree_skb(ack_skb);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	IEEE80211_SKB_CB(skb)->ack_frame_id = id;
+
+	*cookie = ieee80211_mgmt_tx_cookie(local);
+	IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
+
+	return ack_skb;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct cfg80211_mgmt_tx_params *params,
 			     u64 *cookie)
@@ -3429,40 +3464,22 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	skb->dev = sdata->dev;
 
 	if (!params->dont_wait_for_ack) {
-		unsigned long spin_flags;
-		int id;
-
-		/* make a copy to preserve the original cookie (in case the
-		 * driver decides to reallocate the skb) and the frame contents
+		/* make a copy to preserve the frame contents
 		 * in case of encryption.
 		 */
-		ack_skb = skb_copy(skb, GFP_KERNEL);
-		if (!ack_skb) {
-			ret = -ENOMEM;
-			kfree_skb(skb);
-			goto out_unlock;
-		}
-
-		spin_lock_irqsave(&local->ack_status_lock, spin_flags);
-		id = idr_alloc(&local->ack_status_frames, ack_skb,
-			       1, 0x10000, GFP_ATOMIC);
-		spin_unlock_irqrestore(&local->ack_status_lock, spin_flags);
-
-		if (id < 0) {
-			ret = -ENOMEM;
-			kfree_skb(ack_skb);
+		ack_skb = ieee80211_make_ack_skb(local, skb, cookie,
+						 GFP_KERNEL);
+		if (IS_ERR(ack_skb)) {
+			ret = PTR_ERR(ack_skb);
 			kfree_skb(skb);
 			goto out_unlock;
 		}
-
-		IEEE80211_SKB_CB(skb)->ack_frame_id = id;
 	} else {
 		/* for cookie below */
 		ack_skb = skb;
 	}
 
 	if (!need_offchan) {
-		*cookie = (unsigned long)ack_skb;
 		ieee80211_tx_skb(sdata, skb);
 		ret = 0;
 		goto out_unlock;
@@ -3555,7 +3572,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_qos_hdr *nullfunc;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *ack_skb;
 	int size = sizeof(*nullfunc);
 	__le16 fc;
 	bool qos;
@@ -3563,20 +3580,24 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	struct sta_info *sta;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	enum ieee80211_band band;
+	int ret;
+
+	/* the lock is needed to assign the cookie later */
+	mutex_lock(&local->mtx);
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (WARN_ON(!chanctx_conf)) {
-		rcu_read_unlock();
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 	band = chanctx_conf->def.chan->band;
 	sta = sta_info_get_bss(sdata, peer);
 	if (sta) {
 		qos = sta->sta.wme;
 	} else {
-		rcu_read_unlock();
-		return -ENOLINK;
+		ret = -ENOLINK;
+		goto unlock;
 	}
 
 	if (qos) {
@@ -3592,8 +3613,8 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + size);
 	if (!skb) {
-		rcu_read_unlock();
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unlock;
 	}
 
 	skb->dev = dev;
@@ -3619,13 +3640,23 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	if (qos)
 		nullfunc->qos_ctrl = cpu_to_le16(7);
 
+	ack_skb = ieee80211_make_ack_skb(local, skb, cookie, GFP_ATOMIC);
+	if (IS_ERR(ack_skb)) {
+		kfree_skb(skb);
+		ret = PTR_ERR(ack_skb);
+		goto unlock;
+	}
+
 	local_bh_disable();
 	ieee80211_xmit(sdata, sta, skb);
 	local_bh_enable();
+
+	ret = 0;
+unlock:
 	rcu_read_unlock();
+	mutex_unlock(&local->mtx);
 
-	*cookie = (unsigned long) skb;
-	return 0;
+	return ret;
 }
 
 static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 56b73e012757..67c428735a51 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -471,15 +471,23 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 	}
 
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
+		u64 cookie = IEEE80211_SKB_CB(skb)->ack.cookie;
 		struct ieee80211_sub_if_data *sdata;
+		struct ieee80211_hdr *hdr = (void *)skb->data;
 
 		rcu_read_lock();
 		sdata = ieee80211_sdata_from_skb(local, skb);
-		if (sdata)
-			cfg80211_mgmt_tx_status(&sdata->wdev,
-						(unsigned long)skb,
-						skb->data, skb->len,
-						acked, GFP_ATOMIC);
+		if (sdata) {
+			if (ieee80211_is_nullfunc(hdr->frame_control) ||
+			    ieee80211_is_qos_nullfunc(hdr->frame_control))
+				cfg80211_probe_status(sdata->dev, hdr->addr1,
+						      cookie, acked,
+						      GFP_ATOMIC);
+			else
+				cfg80211_mgmt_tx_status(&sdata->wdev, cookie,
+							skb->data, skb->len,
+							acked, GFP_ATOMIC);
+		}
 		rcu_read_unlock();
 
 		dev_kfree_skb_any(skb);
@@ -499,11 +507,8 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 	if (dropped)
 		acked = false;
 
-	if (info->flags & (IEEE80211_TX_INTFL_NL80211_FRAME_TX |
-			   IEEE80211_TX_INTFL_MLME_CONN_TX) &&
-	    !info->ack_frame_id) {
+	if (info->flags & IEEE80211_TX_INTFL_MLME_CONN_TX) {
 		struct ieee80211_sub_if_data *sdata;
-		u64 cookie = (unsigned long)skb;
 
 		rcu_read_lock();
 
@@ -525,10 +530,6 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 				ieee80211_mgd_conn_tx_status(sdata,
 							     hdr->frame_control,
 							     acked);
-		} else if (ieee80211_is_nullfunc(hdr->frame_control) ||
-			   ieee80211_is_qos_nullfunc(hdr->frame_control)) {
-			cfg80211_probe_status(sdata->dev, hdr->addr1,
-					      cookie, acked, GFP_ATOMIC);
 		} else {
 			/* we assign ack frame ID for the others */
 			WARN_ON(1);
-- 
2.1.4

