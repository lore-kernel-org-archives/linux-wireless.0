Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E83D4A9D60
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150318; cv=none; b=fDJ1BBxWweV2pJ8PMXU9dZq0RJh4mfGr2dr1eKK3W6G8eCrrqGcZTeN+udNIL0JYkeu5Lq4uLGyrffsEtLRmAPwQ6DQsu1ewjTiQkb6nMKq1D4qHOyj7ve4jcvdykSPozGKBbksOOzkWkVSbEuDdsesknHSyqOP9/VdCbYrao/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150318; c=relaxed/simple;
	bh=uvVGZBZyKMHLnx1VshlZLxESuqaA5gb32wte2viNN3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7GwkUMGXzfw8O1qo4XDXVG0ecHBzi8CwRcrCGRsIP/jbo4zEX9XIHnuUWPWhppXT8JL+KBU95FrB4K1M+J1yAEBlFf+1pKCU7/2bp8xqiifdP8ln/JW3ibHO50wepFmO2WBUS24LY6swNgRD9vIGnwjR4/Dxg0me4Qv63iIW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xBRe+S3k; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xBRe+S3k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=jMZN0NUfiQ0uRNElJwMWA2oQBwYf9JeJur0f7rmlGxY=;
	t=1791150315; x=1792359915; b=xBRe+S3k14BWMVD30mZ5cgeYXO2GjzjXwTHGnKnDYjsx7RW
	XUuT+mHflO6NSeGa2as3Xf6sNk+LrearjxkqHmSmR52FdPqWbWjl9w7N6+AYP2XgoEraJ1FKjy6xq
	d/Lxc0qX9IfrbOfK7fS6Phsk488hk3CmdXUYiZkF026OMOG/zu42wBfnx8hwatlC+cOSvXZSMxVzN
	8Kg9rel1en+CP9Re8f1Xifl7VsI3VqsYgXdc/vPZ0Q+/cVxHm3ExKdQc5F82hp1ye91APnPY4KZsf
	i9+ZS7/faJe46b/ssXMkOL2O5VwLevlOkBBY6dgjsw1WlMjqQWA77KZw0aTBcQhg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU1A-00000004OqT-2MKu;
	Sun, 04 Oct 2026 23:45:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 06/12] wifi: nl80211: allow mgmt frame TX without wiphy mutex
Date: Sun,  4 Oct 2026 23:40:52 +0200
Message-ID: <20261004234504.0ba29e105934.I4acfe051ab48ea9b012aa3bb26a62ab412a6eb9b@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Management frame transmissions need the wiphy mutex,
but the normal transmit path doesn't, so most cases
shouldn't need it here either. Due to checks, limit
it to AP/GO for now.

To support it, drivers must implement the new method
mgmt_tx_unlocked(), and return -EAGAIN from that for
requests that cannot be done without the wiphy mutex
(e.g. off-channel in mac80211), then the operation
will be retried with the wiphy mutex held.

This requires some work in nl80211_pre_doit() since
the same operation might be called with a wdev or
a netdev, but only netdevs can safely not lock the
wiphy mutex - hence NL80211_FLAG_NO_WIPHY_MTX_NDEV.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h  |  7 ++++
 net/wireless/core.h     |  4 +++
 net/wireless/mlme.c     | 49 +++++++++++++++++++++----
 net/wireless/nl80211.c  | 79 ++++++++++++++++++++++++++++++++---------
 net/wireless/rdev-ops.h | 12 +++++++
 net/wireless/trace.h    | 14 +++++++-
 6 files changed, 141 insertions(+), 24 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ba66fb45dc12..f227b702b38a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5080,6 +5080,9 @@ struct mgmt_frame_regs {
  *	This allows the operation to be terminated prior to timeout based on
  *	the duration value.
  * @mgmt_tx: Transmit a management frame.
+ * @mgmt_tx_unlocked: Like @mgmt_tx, but called without the wiphy mutex,
+ *	for AP/GO only. Return -EAGAIN to get @mgmt_tx with the wiphy
+ *	mutex held for the same operation.
  * @mgmt_tx_cancel_wait: Cancel the wait time from transmitting a management
  *	frame on another channel
  *
@@ -5503,6 +5506,10 @@ struct cfg80211_ops {
 	int	(*mgmt_tx)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			   struct cfg80211_mgmt_tx_params *params,
 			   u64 cookie);
+	int	(*mgmt_tx_unlocked)(struct wiphy *wiphy,
+				    struct wireless_dev *wdev,
+				    struct cfg80211_mgmt_tx_params *params,
+				    u64 cookie);
 	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
 				       struct wireless_dev *wdev,
 				       u64 cookie);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 90d59bac4701..664a759f876b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -413,6 +413,10 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct wireless_dev *wdev,
 			  struct cfg80211_mgmt_tx_params *params,
 			  u64 cookie);
+int cfg80211_mlme_mgmt_tx_unlocked(struct cfg80211_registered_device *rdev,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_mgmt_tx_params *params,
+				   u64 cookie);
 void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
 			       const struct ieee80211_ht_cap *ht_capa_mask);
 void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 96fd14f2a305..e81dae5bf15b 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -892,15 +892,14 @@ static bool cfg80211_allowed_random_address(struct wireless_dev *wdev,
 	return false;
 }
 
-int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
-			  struct wireless_dev *wdev,
-			  struct cfg80211_mgmt_tx_params *params, u64 cookie)
+static int cfg80211_mgmt_tx_check(struct cfg80211_registered_device *rdev,
+				  struct wireless_dev *wdev,
+				  enum nl80211_iftype iftype,
+				  struct cfg80211_mgmt_tx_params *params)
 {
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
 
-	lockdep_assert_wiphy(&rdev->wiphy);
-
 	if (!wdev->wiphy->mgmt_stypes)
 		return -EOPNOTSUPP;
 
@@ -917,14 +916,14 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-	if (!(wdev->wiphy->mgmt_stypes[wdev->iftype].tx & BIT(stype >> 4)))
+	if (!(wdev->wiphy->mgmt_stypes[iftype].tx & BIT(stype >> 4)))
 		return -EINVAL;
 
 	if (ieee80211_is_action(mgmt->frame_control) &&
 	    mgmt->u.action.category != WLAN_CATEGORY_PUBLIC) {
 		int err = 0;
 
-		switch (wdev->iftype) {
+		switch (iftype) {
 		case NL80211_IFTYPE_ADHOC:
 			/*
 			 * check for IBSS DA must be done by driver as
@@ -1003,10 +1002,46 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 	    !cfg80211_allowed_random_address(wdev, mgmt))
 		return -EINVAL;
 
+	return 0;
+}
+
+int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
+			  struct wireless_dev *wdev,
+			  struct cfg80211_mgmt_tx_params *params, u64 cookie)
+{
+	int err;
+
+	lockdep_assert_wiphy(&rdev->wiphy);
+
+	err = cfg80211_mgmt_tx_check(rdev, wdev, wdev->iftype, params);
+	if (err)
+		return err;
+
 	/* Transmit the management frame as requested by user space */
 	return rdev_mgmt_tx(rdev, wdev, params, cookie);
 }
 
+int cfg80211_mlme_mgmt_tx_unlocked(struct cfg80211_registered_device *rdev,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_mgmt_tx_params *params,
+				   u64 cookie)
+{
+	/* can change concurrently, so read only once */
+	enum nl80211_iftype iftype = READ_ONCE(wdev->iftype);
+	int err;
+
+	/* the checks for other interface types need the wiphy mutex */
+	if (!rdev->ops->mgmt_tx_unlocked ||
+	    (iftype != NL80211_IFTYPE_AP && iftype != NL80211_IFTYPE_P2P_GO))
+		return -EAGAIN;
+
+	err = cfg80211_mgmt_tx_check(rdev, wdev, iftype, params);
+	if (err)
+		return err;
+
+	return rdev_mgmt_tx_unlocked(rdev, wdev, params, cookie);
+}
+
 bool cfg80211_rx_mgmt_ext(struct wireless_dev *wdev,
 			  struct cfg80211_rx_info *info)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b342a7b133d5..ae3f4da167c5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15102,6 +15102,22 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 					   info->extack);
 }
 
+static int nl80211_tx_mgmt_locked(struct cfg80211_registered_device *rdev,
+				  struct wireless_dev *wdev,
+				  struct cfg80211_mgmt_tx_params *params,
+				  u64 cookie)
+{
+	if (params->link_id >= 0 &&
+	    !(wdev->valid_links & BIT(params->link_id)))
+		return -EINVAL;
+
+	if (params->offchan &&
+	    !cfg80211_off_channel_oper_allowed(wdev, params->chan))
+		return -EBUSY;
+
+	return cfg80211_mlme_mgmt_tx(rdev, wdev, params, cookie);
+}
+
 static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -15187,18 +15203,14 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	if (!chandef.chan && params.offchan)
 		return -EINVAL;
 
-	if (params.offchan &&
-	    !cfg80211_off_channel_oper_allowed(wdev, chandef.chan))
-		return -EBUSY;
-
 	params.link_id = nl80211_link_id_or_invalid(info->attrs);
 	/*
-	 * This now races due to the unlock, but we cannot check
-	 * the valid links for the _station_ anyway, so that's up
-	 * to the driver.
+	 * This races (even with the wiphy mutex, since it's not held for
+	 * netdevs here), but we cannot check the valid links for the
+	 * _station_ anyway, so that's up to the driver.
 	 */
 	if (params.link_id >= 0 &&
-	    !(wdev->valid_links & BIT(params.link_id)))
+	    !(READ_ONCE(wdev->valid_links) & BIT(params.link_id)))
 		return -EINVAL;
 
 	params.no_sta =
@@ -15229,7 +15241,23 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	params.chan = chandef.chan;
 	cookie = cfg80211_assign_cookie(rdev);
-	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, cookie);
+
+	if (wdev->netdev) {
+		/* pre_doit didn't lock the wiphy mutex, try without */
+		err = cfg80211_mlme_mgmt_tx_unlocked(rdev, wdev, &params,
+						     cookie);
+		if (err == -EAGAIN) {
+			wiphy_lock(&rdev->wiphy);
+			if (!rdev->wiphy.registered || !wdev_running(wdev))
+				err = -ENETDOWN;
+			else
+				err = nl80211_tx_mgmt_locked(rdev, wdev,
+							     &params, cookie);
+			wiphy_unlock(&rdev->wiphy);
+		}
+	} else {
+		err = nl80211_tx_mgmt_locked(rdev, wdev, &params, cookie);
+	}
 	if (err)
 		goto free_msg;
 
@@ -19796,6 +19824,8 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 #define NL80211_FLAG_NO_WIPHY_MTX	0x40
 #define NL80211_FLAG_MLO_VALID_LINK_ID	0x80
 #define NL80211_FLAG_MLO_UNSUPPORTED	0x100
+/* no wiphy mutex if there's a netdev */
+#define NL80211_FLAG_NO_WIPHY_MTX_NDEV	0x200
 
 #define INTERNAL_FLAG_SELECTORS(__sel)			\
 	SELECTOR(__sel, NONE, 0) /* must be first */	\
@@ -19863,7 +19893,10 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 	SELECTOR(__sel, WDEV_UP_RTNL_NOMTX,		\
 		 NL80211_FLAG_NEED_WDEV_UP |		\
 		 NL80211_FLAG_NO_WIPHY_MTX |		\
-		 NL80211_FLAG_NEED_RTNL)
+		 NL80211_FLAG_NEED_RTNL)		\
+	SELECTOR(__sel, WDEV_UP_NOMTX_NETDEV,		\
+		 NL80211_FLAG_NEED_WDEV_UP |		\
+		 NL80211_FLAG_NO_WIPHY_MTX_NDEV)
 
 /*
  * Note: a
@@ -19889,6 +19922,14 @@ static u32 nl80211_internal_flags[] = {
 #undef SELECTOR
 };
 
+static bool nl80211_need_wiphy_mtx(u32 internal_flags, struct net_device *dev)
+{
+	if (internal_flags & NL80211_FLAG_NO_WIPHY_MTX)
+		return false;
+
+	return !(internal_flags & NL80211_FLAG_NO_WIPHY_MTX_NDEV && dev);
+}
+
 static int nl80211_pre_doit(const struct genl_split_ops *ops,
 			    struct sk_buff *skb,
 			    struct genl_info *info)
@@ -19946,7 +19987,7 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 		}
 	}
 
-	if (rdev && !(internal_flags & NL80211_FLAG_NO_WIPHY_MTX)) {
+	if (rdev && nl80211_need_wiphy_mtx(internal_flags, dev)) {
 		if (need_rtnl) {
 			wiphy_lock(&rdev->wiphy);
 		} else {
@@ -20047,19 +20088,24 @@ static void nl80211_post_doit(const struct genl_split_ops *ops,
 			      struct genl_info *info)
 {
 	u32 internal_flags = nl80211_internal_flags[ops->internal_flags];
+	struct net_device *dev = NULL;
+	bool locked;
 
 	if (info->user_ptr[1]) {
 		if (internal_flags & NL80211_FLAG_NEED_WDEV) {
 			struct wireless_dev *wdev = info->user_ptr[1];
 
-			dev_put(wdev->netdev);
+			dev = wdev->netdev;
 		} else {
-			dev_put(info->user_ptr[1]);
+			dev = info->user_ptr[1];
 		}
 	}
 
-	if (info->user_ptr[0] &&
-	    !(internal_flags & NL80211_FLAG_NO_WIPHY_MTX)) {
+	locked = info->user_ptr[0] &&
+		 nl80211_need_wiphy_mtx(internal_flags, dev);
+	dev_put(dev);
+
+	if (locked) {
 		struct cfg80211_registered_device *rdev = info->user_ptr[0];
 
 		/* we kept the mutex locked since pre_doit */
@@ -20601,7 +20647,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tx_mgmt,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP |
+					 NL80211_FLAG_NO_WIPHY_MTX_NDEV),
 	},
 	{
 		.cmd = NL80211_CMD_FRAME_WAIT_CANCEL,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 95882c8972d2..5502cd947844 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -785,6 +785,18 @@ static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_mgmt_tx_unlocked(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev,
+		      struct cfg80211_mgmt_tx_params *params, u64 cookie)
+{
+	int ret;
+	trace_rdev_mgmt_tx_unlocked(&rdev->wiphy, wdev, params);
+	ret = rdev->ops->mgmt_tx_unlocked(&rdev->wiphy, wdev, params, cookie);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, cookie);
+	return ret;
+}
+
 static inline int rdev_tx_control_port(struct cfg80211_registered_device *rdev,
 				       struct net_device *dev,
 				       const void *buf, size_t len,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f5fa2fb76474..1f3c1e0eb26a 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2236,7 +2236,7 @@ TRACE_EVENT(rdev_cancel_remain_on_channel,
 		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->cookie)
 );
 
-TRACE_EVENT(rdev_mgmt_tx,
+DECLARE_EVENT_CLASS(rdev_mgmt_tx_evt,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 struct cfg80211_mgmt_tx_params *params),
 	TP_ARGS(wiphy, wdev, params),
@@ -2266,6 +2266,18 @@ TRACE_EVENT(rdev_mgmt_tx,
 		  BOOL_TO_STR(__entry->dont_wait_for_ack))
 );
 
+DEFINE_EVENT(rdev_mgmt_tx_evt, rdev_mgmt_tx,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_mgmt_tx_params *params),
+	TP_ARGS(wiphy, wdev, params)
+);
+
+DEFINE_EVENT(rdev_mgmt_tx_evt, rdev_mgmt_tx_unlocked,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_mgmt_tx_params *params),
+	TP_ARGS(wiphy, wdev, params)
+);
+
 TRACE_EVENT(rdev_tx_control_port,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 const u8 *buf, size_t len, const u8 *dest, __be16 proto,
-- 
2.55.0

