Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889A250EBEF
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569670; cv=none; b=SGZjyM6wEr4ZeQYta1HDMTeJtDGvoOoEb3SS/Aarzg/NDEQhf4iYQuXg+pxzGELdqPcd/DTjtBNZG2em/ppYk1rjvCKyVvjuEqGKwAokmv3Hsl1tBKV0VzcO+r8qdMnSyfxwA5hK/+9ddpGyzDHF4tN/xv1eRti5VGixxahAeuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569670; c=relaxed/simple;
	bh=O4+Kb4uOKIQI47MO3Liz2TFzGyCNJhCm87FPryDlXC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7cb1Os5AdiX7QS3Wc6X9MKIlh/yE0kD8Kdtga5DjpOqsDuIGXHp3IJL5WMW49ge7YXyXNKFLc/IQBLAe/8nTc0UyZdRzjJDjxeO01HxQAgVBTJiXq9hc9TnrU7J/TBl/odPF4svJnlt07zvclF9pLfh+5xNn8PJzhlRKoAEChQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rvJjqSCA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rvJjqSCA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=t1PBzGX/UfJw1VkZpENG/3WuDkXBQQ5bEqJSy9dX0F0=;
	t=1791569668; x=1792779268; b=rvJjqSCAi9N+1RFqEM1Sl3+JwQEyh57r9ZSuJA8pg94zF45
	VnF6uwxzpH1ZKxNrh6N+aAmAeIYjp185dkK8u1yAnOQaYp0suftyIfxEYPjfyJmHMwH9UolEr9jYi
	Hhs/pHC0rl+o9ySVgzn1DS3d4lTFsqb8tnXZ9rskdQMn6Arz67i8ATW+9ba3/htjLloOT6WQp06T0
	uAdDR9XSV7mYfFIU4a03tBAGdtgezfUVL3zx9ub9y1D/s4vCXpeMrvmtdT4w8Fz5E3rkN1TDx1QdR
	cgr/juv3eUxdxuIz70mYKmAiR/z7X3kZaie+svC4egbYIuusZaZblpInbb08cpFA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF6v-0000000AtGH-2Hvq;
	Fri, 09 Oct 2026 20:14:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 07/17] wifi: nl80211: allow mgmt frame TX without wiphy mutex
Date: Fri,  9 Oct 2026 20:10:06 +0200
Message-ID: <20261009201417.d376c87d429b.I4acfe051ab48ea9b012aa3bb26a62ab412a6eb9b@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009181416.335754-19-johannes@sipsolutions.net>
References: <20261009181416.335754-19-johannes@sipsolutions.net>
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

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h  | 11 ++++++++
 net/wireless/core.h     |  4 +++
 net/wireless/mlme.c     | 58 ++++++++++++++++++++++++++++++++++++-----
 net/wireless/nl80211.c  | 50 +++++++++++++++++++++++++++--------
 net/wireless/rdev-ops.h | 12 +++++++++
 net/wireless/trace.h    | 14 +++++++++-
 6 files changed, 130 insertions(+), 19 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 16f6b96e0d88..0eee48bdc937 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5087,6 +5087,13 @@ struct mgmt_frame_regs {
  *	This allows the operation to be terminated prior to timeout based on
  *	the duration value.
  * @mgmt_tx: Transmit a management frame.
+ * @mgmt_tx_unlocked: Like @mgmt_tx, but called without the wiphy mutex,
+ *	currently limited to AP/GO/NAN. The driver may -EAGAIN to get
+ *	@mgmt_tx with the wiphy mutex held for the same operation,
+ *	although if the device is removed concurrently that might not
+ *	happen and userspace sees -ENODEV.
+ *	Note this cannot acquire the wiphy mutex or RTNL, that would
+ *	deadlock against unregistering the wdev.
  * @mgmt_tx_cancel_wait: Cancel the wait time from transmitting a management
  *	frame on another channel
  *
@@ -5510,6 +5517,10 @@ struct cfg80211_ops {
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
index 220544a6bb83..0e05d4247bea 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -432,6 +432,10 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
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
index 96fd14f2a305..80ca9031d29c 100644
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
@@ -1003,10 +1002,55 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
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
+	if (!rdev->ops->mgmt_tx_unlocked)
+		return -EAGAIN;
+
+	switch (iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_NAN:
+	case NL80211_IFTYPE_NAN_DATA:
+		break;
+	default:
+		/* the checks for other interface types need the wiphy mutex */
+		return -EAGAIN;
+	}
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
index eb91937a7238..7cb3bb9438d7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15152,6 +15152,22 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
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
@@ -15237,18 +15253,14 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
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
@@ -15279,7 +15291,19 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	params.chan = chandef.chan;
 	cookie = cfg80211_assign_cookie(rdev);
-	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, cookie);
+
+	/* pre_doit didn't lock the wiphy mutex, try without */
+	err = cfg80211_mlme_mgmt_tx_unlocked(rdev, wdev, &params, cookie);
+	if (err == -EAGAIN) {
+		wdev = nl80211_lock_held_wdev(rdev, info, wdev);
+		if (IS_ERR(wdev)) {
+			err = PTR_ERR(wdev);
+		} else {
+			err = nl80211_tx_mgmt_locked(rdev, wdev, &params,
+						     cookie);
+			wiphy_unlock(&rdev->wiphy);
+		}
+	}
 	if (err)
 		goto free_msg;
 
@@ -19930,7 +19954,10 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 	SELECTOR(__sel, WDEV_UP_RTNL_NOMTX,		\
 		 NL80211_FLAG_NEED_WDEV_UP |		\
 		 NL80211_FLAG_NO_WIPHY_MTX |		\
-		 NL80211_FLAG_NEED_RTNL)
+		 NL80211_FLAG_NEED_RTNL)		\
+	SELECTOR(__sel, WDEV_UP_NOMTX,			\
+		 NL80211_FLAG_NEED_WDEV_UP |		\
+		 NL80211_FLAG_NO_WIPHY_MTX)
 
 /*
  * Note: a
@@ -20690,7 +20717,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tx_mgmt,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP |
+					 NL80211_FLAG_NO_WIPHY_MTX),
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
2.56.0

