Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52123 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KRRC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:02:58 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so1007420bkb.20
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 09:02:57 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH 5/6] cfg80211: Aggregate mgmt_tx parameters into a struct
Date: Mon, 18 Nov 2013 19:02:45 +0200
Message-Id: <1384794166-10906-5-git-send-email-egrumbach@gmail.com> (sfid-20131118_180308_048662_FBD7E99C)
In-Reply-To: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Change cfg80211 and mac80211 to use cfg80211_mgmt_tx_params
struct to aggregate parameters for mgmt_tx functions.
This makes the functions' signatures less clumsy and allows
less painful parameters extension.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h  |   28 +++++++++++++++++++++++++---
 net/mac80211/cfg.c      |   29 +++++++++++++++--------------
 net/wireless/core.h     |    5 ++---
 net/wireless/mlme.c     |   12 ++++--------
 net/wireless/nl80211.c  |   31 +++++++++++++++----------------
 net/wireless/rdev-ops.h |   12 ++++--------
 net/wireless/trace.h    |   15 +++++++--------
 7 files changed, 72 insertions(+), 60 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3eae46c..54bdded 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1945,6 +1945,29 @@ struct cfg80211_update_ft_ies_params {
 };
 
 /**
+ * struct cfg80211_mgmt_tx_params - mgmt tx parameters
+ *
+ * This structure provides information needed to transmit a mgmt frame
+ *
+ * @chan: channel to use
+ * @offchan: indicates wether off channel operation is required
+ * @wait: duration for ROC
+ * @buf: buffer to transmit
+ * @len: buffer length
+ * @no_cck: don't use cck rates for this frame
+ * @dont_wait_for_ack: tells the low level not to wait for an ack
+ */
+struct cfg80211_mgmt_tx_params {
+	struct ieee80211_channel *chan;
+	bool offchan;
+	unsigned int wait;
+	const u8 *buf;
+	size_t len;
+	bool no_cck;
+	bool dont_wait_for_ack;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2342,9 +2365,8 @@ struct cfg80211_ops {
 					    u64 cookie);
 
 	int	(*mgmt_tx)(struct wiphy *wiphy, struct wireless_dev *wdev,
-			  struct ieee80211_channel *chan, bool offchan,
-			  unsigned int wait, const u8 *buf, size_t len,
-			  bool no_cck, bool dont_wait_for_ack, u64 *cookie);
+			   struct cfg80211_mgmt_tx_params *params,
+			   u64 *cookie);
 	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
 				       struct wireless_dev *wdev,
 				       u64 cookie);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 95667b0..9442837 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3146,26 +3146,25 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-			     struct ieee80211_channel *chan, bool offchan,
-			     unsigned int wait, const u8 *buf, size_t len,
-			     bool no_cck, bool dont_wait_for_ack, u64 *cookie)
+			     struct cfg80211_mgmt_tx_params *params,
+			     u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
-	const struct ieee80211_mgmt *mgmt = (void *)buf;
+	const struct ieee80211_mgmt *mgmt = (void *)params->buf;
 	bool need_offchan = false;
 	u32 flags;
 	int ret;
 
-	if (dont_wait_for_ack)
+	if (params->dont_wait_for_ack)
 		flags = IEEE80211_TX_CTL_NO_ACK;
 	else
 		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
 			IEEE80211_TX_CTL_REQ_TX_STATUS;
 
-	if (no_cck)
+	if (params->no_cck)
 		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
 
 	switch (sdata->vif.type) {
@@ -3213,7 +3212,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	/* configurations requiring offchan cannot work if no channel has been
 	 * specified
 	 */
-	if (need_offchan && !chan)
+	if (need_offchan && !params->chan)
 		return -EINVAL;
 
 	mutex_lock(&local->mtx);
@@ -3226,8 +3225,10 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
 		if (chanctx_conf) {
-			need_offchan = chan && (chan != chanctx_conf->def.chan);
-		} else if (!chan) {
+			need_offchan = params->chan &&
+				       (params->chan !=
+					chanctx_conf->def.chan);
+		} else if (!params->chan) {
 			ret = -EINVAL;
 			rcu_read_unlock();
 			goto out_unlock;
@@ -3237,19 +3238,19 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		rcu_read_unlock();
 	}
 
-	if (need_offchan && !offchan) {
+	if (need_offchan && !params->offchan) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + params->len);
 	if (!skb) {
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
-	memcpy(skb_put(skb, len), buf, len);
+	memcpy(skb_put(skb, params->len), params->buf, params->len);
 
 	IEEE80211_SKB_CB(skb)->flags = flags;
 
@@ -3269,8 +3270,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			local->hw.offchannel_tx_hw_queue;
 
 	/* This will handle all kinds of coalescing and immediate TX */
-	ret = ieee80211_start_roc_work(local, sdata, chan,
-				       wait, cookie, skb,
+	ret = ieee80211_start_roc_work(local, sdata, params->chan,
+				       params->wait, cookie, skb,
 				       IEEE80211_ROC_TYPE_MGMT_TX);
 	if (ret)
 		kfree_skb(skb);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index eb0f7a3..bff9869 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -317,9 +317,8 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlpid);
 void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev);
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct wireless_dev *wdev,
-			  struct ieee80211_channel *chan, bool offchan,
-			  unsigned int wait, const u8 *buf, size_t len,
-			  bool no_cck, bool dont_wait_for_ack, u64 *cookie);
+			  struct cfg80211_mgmt_tx_params *params,
+			  u64 *cookie);
 void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
 			       const struct ieee80211_ht_cap *ht_capa_mask);
 void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 6a6b1c8..a9cecd7 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -520,9 +520,7 @@ void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev)
 
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct wireless_dev *wdev,
-			  struct ieee80211_channel *chan, bool offchan,
-			  unsigned int wait, const u8 *buf, size_t len,
-			  bool no_cck, bool dont_wait_for_ack, u64 *cookie)
+			  struct cfg80211_mgmt_tx_params *params, u64 *cookie)
 {
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
@@ -533,10 +531,10 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 	if (!rdev->ops->mgmt_tx)
 		return -EOPNOTSUPP;
 
-	if (len < 24 + 1)
+	if (params->len < 24 + 1)
 		return -EINVAL;
 
-	mgmt = (const struct ieee80211_mgmt *) buf;
+	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
 		return -EINVAL;
@@ -615,9 +613,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
-	return rdev_mgmt_tx(rdev, wdev, chan, offchan,
-			    wait, buf, len, no_cck, dont_wait_for_ack,
-			    cookie);
+	return rdev_mgmt_tx(rdev, wdev, params, cookie);
 }
 
 bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a7f4e79..c2627ba 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7428,10 +7428,10 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	void *hdr = NULL;
 	u64 cookie;
 	struct sk_buff *msg = NULL;
-	unsigned int wait = 0;
-	bool offchan, no_cck, dont_wait_for_ack;
-
-	dont_wait_for_ack = info->attrs[NL80211_ATTR_DONT_WAIT_FOR_ACK];
+	struct cfg80211_mgmt_tx_params params = {
+		.dont_wait_for_ack =
+			info->attrs[NL80211_ATTR_DONT_WAIT_FOR_ACK],
+	};
 
 	if (!info->attrs[NL80211_ATTR_FRAME])
 		return -EINVAL;
@@ -7458,24 +7458,24 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_DURATION]) {
 		if (!(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
 			return -EINVAL;
-		wait = nla_get_u32(info->attrs[NL80211_ATTR_DURATION]);
+		params.wait = nla_get_u32(info->attrs[NL80211_ATTR_DURATION]);
 
 		/*
 		 * We should wait on the channel for at least a minimum amount
 		 * of time (10ms) but no longer than the driver supports.
 		 */
-		if (wait < NL80211_MIN_REMAIN_ON_CHANNEL_TIME ||
-		    wait > rdev->wiphy.max_remain_on_channel_duration)
+		if (params.wait < NL80211_MIN_REMAIN_ON_CHANNEL_TIME ||
+		    params.wait > rdev->wiphy.max_remain_on_channel_duration)
 			return -EINVAL;
 
 	}
 
-	offchan = info->attrs[NL80211_ATTR_OFFCHANNEL_TX_OK];
+	params.offchan = info->attrs[NL80211_ATTR_OFFCHANNEL_TX_OK];
 
-	if (offchan && !(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
+	if (params.offchan && !(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
 		return -EINVAL;
 
-	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
+	params.no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
 	/* get the channel if any has been specified, otherwise pass NULL to
 	 * the driver. The latter will use the current one
@@ -7487,10 +7487,10 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
-	if (!chandef.chan && offchan)
+	if (!chandef.chan && params.offchan)
 		return -EINVAL;
 
-	if (!dont_wait_for_ack) {
+	if (!params.dont_wait_for_ack) {
 		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 		if (!msg)
 			return -ENOMEM;
@@ -7503,10 +7503,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	err = cfg80211_mlme_mgmt_tx(rdev, wdev, chandef.chan, offchan, wait,
-				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
-				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
-				    no_cck, dont_wait_for_ack, &cookie);
+	params.buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
+	params.len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
+	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, &cookie);
 	if (err)
 		goto free_msg;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 37ce9fd..a6c03ab 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -624,16 +624,12 @@ rdev_cancel_remain_on_channel(struct cfg80211_registered_device *rdev,
 
 static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
 			       struct wireless_dev *wdev,
-			       struct ieee80211_channel *chan, bool offchan,
-			       unsigned int wait, const u8 *buf, size_t len,
-			       bool no_cck, bool dont_wait_for_ack, u64 *cookie)
+			       struct cfg80211_mgmt_tx_params *params,
+			       u64 *cookie)
 {
 	int ret;
-	trace_rdev_mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
-			   wait, no_cck, dont_wait_for_ack);
-	ret = rdev->ops->mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
-				  wait, buf, len, no_cck,
-				  dont_wait_for_ack, cookie);
+	trace_rdev_mgmt_tx(&rdev->wiphy, wdev, params);
+	ret = rdev->ops->mgmt_tx(&rdev->wiphy, wdev, params, cookie);
 	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ba5f0d6..f7aa7a7 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1653,9 +1653,8 @@ TRACE_EVENT(rdev_cancel_remain_on_channel,
 
 TRACE_EVENT(rdev_mgmt_tx,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
-		 struct ieee80211_channel *chan, bool offchan,
-		 unsigned int wait, bool no_cck, bool dont_wait_for_ack),
-	TP_ARGS(wiphy, wdev, chan, offchan, wait, no_cck, dont_wait_for_ack),
+		 struct cfg80211_mgmt_tx_params *params),
+	TP_ARGS(wiphy, wdev, params),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		WDEV_ENTRY
@@ -1668,11 +1667,11 @@ TRACE_EVENT(rdev_mgmt_tx,
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		WDEV_ASSIGN;
-		CHAN_ASSIGN(chan);
-		__entry->offchan = offchan;
-		__entry->wait = wait;
-		__entry->no_cck = no_cck;
-		__entry->dont_wait_for_ack = dont_wait_for_ack;
+		CHAN_ASSIGN(params->chan);
+		__entry->offchan = params->offchan;
+		__entry->wait = params->wait;
+		__entry->no_cck = params->no_cck;
+		__entry->dont_wait_for_ack = params->dont_wait_for_ack;
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", " CHAN_PR_FMT ", offchan: %s,"
 		  " wait: %u, no cck: %s, dont wait for ack: %s",
-- 
1.7.9.5

