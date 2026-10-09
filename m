Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE5F511E69
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569679; cv=none; b=C86j11UGYF666Vm6WSCujGPLf68jiGdp/nFtwkirw47YtkN8MV4Q0C485GQhgpR7ORiMgbQPhLENoZAscImtA5oJ24SHUGwWPdlWr/+4mAXab2FP+/CEWxvqeIhVR/oPUPeqm/pD7qI2z6sPx8L8aIglwpk5vOyyylMJF+XqJks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569679; c=relaxed/simple;
	bh=1DtdV7ZiMLphqc2AQdIarxcXNuIIG9MYuBdqfDafXms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEnaiknAItfrDYGgktdGCJz1Iw0iT+xmO4cB4gDW/5GPt6wVf4jubulU0wgl5e1VhsgGYQj6jRnA9OYRHuT2JrCD4WlmzNlY8kxcVWhpwrGH7gLlpgG9Ib6jDxoB5o3ok1JPZKBfSsouEhLNuTvVc62dIrBNRChdVjf7g1WSorY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KU8J8oCo; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KU8J8oCo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ZjCgZlwpbaS0bN87j8i9ipTlnn/vMpUmqEMYp//n7lc=;
	t=1791569677; x=1792779277; b=KU8J8oCoJonyo3+WxjBdV6Z8lDimNnSz8m+69a6satkMdw+
	8HWpbOhjAk67HAxFUwUGMMH3MbnFObMlSM3BFaYFwZ8guWXbEkRKZJ/3COlwhoK0+FyCCy3vCaxLZ
	D95sUOTyy3v+VXOGOw7LUd99ppP3LkrdbBIFBb+vIlFrrTguT6JSubluHh1ugvwmJdZW5fnL4EtGj
	anJod0CruZ6RE1Gw28HzviBM9tnZSNkbMImUHqAug1rQhZzPnCMSPJR7h5Wetjc/+tpA/MKbyVeOX
	xFDCUD63LV7AnSFUDPeWC8svNU//oIlt2wOYr0C7wiJJWDqc4+wekThuHJtk2e6g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF74-0000000AtGH-3Nri;
	Fri, 09 Oct 2026 20:14:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 15/17] wifi: cfg80211: support unlocked station get/dump
Date: Fri,  9 Oct 2026 20:10:14 +0200
Message-ID: <20261009201417.e1d8a7d5f513.I9f6c2aff55861332c15069b9189bbf1e653648d5@changeid>
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

Qualcomm reported that there can be a lot of lock
contention on the wiphy mutex due to background
processes dumping the station statistics.

In many drivers (e.g. all mac80211 drivers without
their own station statistics) it doesn't need to
be locked, the data is never guaranteed to be fully
consistent anyway given it's collected by concurrent
TX/RX.

Support unlocked get/dump station methods so that
drivers can reduce lock contention by implementing
these methods. As in the other cases, it's allowed
to return -EAGAIN if a locked call is needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h  |  14 +++
 net/wireless/nl80211.c  | 201 ++++++++++++++++++++++++++++++++--------
 net/wireless/rdev-ops.h |  27 ++++++
 net/wireless/trace.h    |  19 +++-
 4 files changed, 219 insertions(+), 42 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3fa310b30139..f773856c1818 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4963,7 +4963,13 @@ struct mgmt_frame_regs {
  *	them, also against the existing state! Drivers must call
  *	cfg80211_check_station_change() to validate the information.
  * @get_station: get station information for the station identified by @mac
+ * @get_station_unlocked: Like @get_station, but called without the wiphy
+ *	mutex. Return -EAGAIN to get @get_station called with the wiphy mutex
+ *	held instead.
  * @dump_station: dump station callback -- resume dump at index @idx
+ * @dump_station_unlocked: Like @dump_station, but called without the wiphy
+ *	mutex. Return -EAGAIN to get @dump_station called with the wiphy mutex
+ *	held instead.
  *
  * @add_mpath: add a fixed mesh path
  * @del_mpath: delete a given mesh path
@@ -5395,8 +5401,16 @@ struct cfg80211_ops {
 				  struct station_parameters *params);
 	int	(*get_station)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			       const u8 *mac, struct station_info *sinfo);
+	int	(*get_station_unlocked)(struct wiphy *wiphy,
+					struct wireless_dev *wdev,
+					const u8 *mac,
+					struct station_info *sinfo);
 	int	(*dump_station)(struct wiphy *wiphy, struct wireless_dev *wdev,
 				int idx, u8 *mac, struct station_info *sinfo);
+	int	(*dump_station_unlocked)(struct wiphy *wiphy,
+					 struct wireless_dev *wdev,
+					 int idx, u8 *mac,
+					 struct station_info *sinfo);
 
 	int	(*add_mpath)(struct wiphy *wiphy, struct net_device *dev,
 			       const u8 *dst, const u8 *next_hop);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4044ea7d344a..948113050b50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -266,23 +266,51 @@ nl80211_lock_and_recheck(struct cfg80211_registered_device *rdev,
 	return ERR_PTR(-ENODEV);
 }
 
+/* like nl80211_lock_and_recheck() but under RCU, for wdev_hold() */
+static struct wireless_dev *
+nl80211_wdev_by_id_rcu(struct cfg80211_registered_device *rdev,
+		       struct net *netns, u32 wdev_id)
+{
+	struct wireless_dev *wdev;
+
+	if (!net_eq(wiphy_net(&rdev->wiphy), netns))
+		return NULL;
+
+	list_for_each_entry_rcu(wdev, &rdev->wiphy.wdev_list, list) {
+		if (wdev->identifier != wdev_id)
+			continue;
+		if (wdev->netdev && !net_eq(dev_net(wdev->netdev), netns))
+			return NULL;
+		return wdev;
+	}
+
+	return NULL;
+}
+
 /*
  * Must have wdev_hold(), acquire the wiphy mutex. This has to
  * look up the wdev again (otherwise it could deadlock against
  * wdev removal), so it can return an error pointer.
  */
 static struct wireless_dev *
-nl80211_lock_held_wdev(struct cfg80211_registered_device *rdev,
-		       struct genl_info *info, struct wireless_dev *wdev)
+__nl80211_lock_held_wdev(struct cfg80211_registered_device *rdev,
+			 struct net *netns, struct wireless_dev *wdev)
 {
 	u32 wdev_id = wdev->identifier;
 
 	/* the wdev reference was keeping the wiphy alive */
 	get_device(&rdev->wiphy.dev);
-	info->user_ptr[1] = NULL;
 	wdev_put(wdev);
 
-	wdev = nl80211_lock_and_recheck(rdev, genl_info_net(info), wdev_id);
+	return nl80211_lock_and_recheck(rdev, netns, wdev_id);
+}
+
+static struct wireless_dev *
+nl80211_lock_held_wdev(struct cfg80211_registered_device *rdev,
+		       struct genl_info *info, struct wireless_dev *wdev)
+{
+	info->user_ptr[1] = NULL;
+	wdev = __nl80211_lock_held_wdev(rdev, genl_info_net(info), wdev);
 	if (IS_ERR(wdev))
 		return wdev;
 
@@ -1326,10 +1354,10 @@ nl80211_packet_pattern_policy[MAX_NL80211_PKTPAT + 1] = {
 	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
 };
 
-static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
-				     struct cfg80211_registered_device **rdev,
-				     struct wireless_dev **wdev,
-				     struct nlattr **attrbuf)
+static int __nl80211_prepare_wdev_dump(struct netlink_callback *cb,
+				       struct cfg80211_registered_device **rdev,
+				       struct wireless_dev **wdev,
+				       struct nlattr **attrbuf, bool lock)
 {
 	struct net *netns = sock_net(cb->skb->sk);
 	u32 wdev_id;
@@ -1374,13 +1402,22 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 		wdev_id = cb->args[1];
 	}
 
-	get_device(&(*rdev)->wiphy.dev);
-	rcu_read_unlock();
+	if (!lock) {
+		*wdev = nl80211_wdev_by_id_rcu(*rdev, netns, wdev_id);
+		if (*wdev)
+			wdev_hold(*wdev);
+		rcu_read_unlock();
+		if (!*wdev)
+			return -ENODEV;
+	} else {
+		get_device(&(*rdev)->wiphy.dev);
+		rcu_read_unlock();
 
-	/* things may have changed since the lookup or the last dumpit call */
-	*wdev = nl80211_lock_and_recheck(*rdev, netns, wdev_id);
-	if (IS_ERR(*wdev))
-		return PTR_ERR(*wdev);
+		/* things may have changed since the lookup or last dumpit */
+		*wdev = nl80211_lock_and_recheck(*rdev, netns, wdev_id);
+		if (IS_ERR(*wdev))
+			return PTR_ERR(*wdev);
+	}
 
 	/* 0 is the first index - add 1 to parse only once */
 	cb->args[0] = (*rdev)->wiphy_idx + 1;
@@ -1389,6 +1426,14 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 	return 0;
 }
 
+static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
+				     struct cfg80211_registered_device **rdev,
+				     struct wireless_dev **wdev,
+				     struct nlattr **attrbuf)
+{
+	return __nl80211_prepare_wdev_dump(cb, rdev, wdev, attrbuf, true);
+}
+
 /* message building helper */
 void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
 		     int flags, u8 cmd)
@@ -8843,13 +8888,46 @@ static int nl80211_put_link_station_payload(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int nl80211_fill_station_info(struct cfg80211_registered_device *rdev,
+				     struct wireless_dev *wdev,
+				     struct nl80211_dump_station_ctx *ctx,
+				     bool locked)
+{
+	int err;
+
+	if (!ctx->filter_mac) {
+		if (locked)
+			return rdev_dump_station(rdev, wdev, ctx->sta_idx,
+						 ctx->mac_addr, &ctx->sinfo);
+		if (!rdev->ops->dump_station_unlocked)
+			return -EAGAIN;
+		return rdev_dump_station_unlocked(rdev, wdev, ctx->sta_idx,
+						  ctx->mac_addr, &ctx->sinfo);
+	}
+
+	if (locked)
+		err = rdev_get_station(rdev, wdev, ctx->filter_mac_addr,
+				       &ctx->sinfo);
+	else if (rdev->ops->get_station_unlocked)
+		err = rdev_get_station_unlocked(rdev, wdev, ctx->filter_mac_addr,
+						&ctx->sinfo);
+	else
+		return -EAGAIN;
+
+	if (!err)
+		memcpy(ctx->mac_addr, ctx->filter_mac_addr, ETH_ALEN);
+	return err;
+}
+
 static int nl80211_dump_station(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 	struct nl80211_dump_station_ctx *ctx = (void *)cb->args[2];
+	struct net *netns = sock_net(cb->skb->sk);
 	struct nlattr **attrbuf __free(kfree) = NULL;
+	bool locked = false;
 	int err;
 
 	if (!ctx) {
@@ -8858,11 +8936,9 @@ static int nl80211_dump_station(struct sk_buff *skb,
 			return -ENOMEM;
 	}
 
-	err = nl80211_prepare_wdev_dump(cb, &rdev, &wdev, attrbuf);
+	err = __nl80211_prepare_wdev_dump(cb, &rdev, &wdev, attrbuf, false);
 	if (err)
 		return err;
-	/* nl80211_prepare_wdev_dump acquired it in the successful case */
-	__acquire(&rdev->wiphy.mtx);
 
 	if (!ctx) {
 		ctx = kzalloc_obj(*ctx);
@@ -8919,21 +8995,28 @@ static int nl80211_dump_station(struct sk_buff *skb,
 				}
 			}
 
-			if (ctx->filter_mac) {
-				if (ctx->sta_idx > 0) {
-					err = skb->len;
-					goto out_err_release;
+			if (ctx->filter_mac && ctx->sta_idx > 0) {
+				err = skb->len;
+				goto out_err_release;
+			}
+
+			err = nl80211_fill_station_info(rdev, wdev, ctx,
+							locked);
+			if (err == -EAGAIN && !locked) {
+				cfg80211_sinfo_release_content(&ctx->sinfo);
+				memset(&ctx->sinfo, 0, sizeof(ctx->sinfo));
+
+				/* this fails if the wdev is being removed */
+				wdev = __nl80211_lock_held_wdev(rdev, netns,
+								wdev);
+				if (IS_ERR(wdev)) {
+					err = PTR_ERR(wdev);
+					goto out_err;
 				}
-				err = rdev_get_station(rdev, wdev,
-						       ctx->filter_mac_addr,
-						       &ctx->sinfo);
-				if (!err)
-					memcpy(ctx->mac_addr,
-					       ctx->filter_mac_addr, ETH_ALEN);
-			} else {
-				err = rdev_dump_station(rdev, wdev, ctx->sta_idx,
-							ctx->mac_addr,
-							&ctx->sinfo);
+
+				/* try again locked now */
+				locked = true;
+				continue;
 			}
 			if (err == -ENOENT) {
 				err = skb->len;
@@ -9028,7 +9111,10 @@ static int nl80211_dump_station(struct sk_buff *skb,
 	cfg80211_sinfo_release_content(&ctx->sinfo);
 	memset(&ctx->sinfo, 0, sizeof(ctx->sinfo));
 out_err:
-	wiphy_unlock(&rdev->wiphy);
+	if (locked)
+		wiphy_unlock(&rdev->wiphy);
+	else if (wdev)
+		wdev_put(wdev);
 
 	return err;
 }
@@ -9049,6 +9135,7 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
 	struct station_info sinfo;
+	bool locked = false;
 	struct sk_buff *msg;
 	u8 *mac_addr = NULL;
 	int err, i;
@@ -9074,26 +9161,54 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	err = rdev_get_station(rdev, wdev, mac_addr, &sinfo);
-	if (err) {
-		cfg80211_sinfo_release_content(&sinfo);
-		return err;
-	}
-
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		cfg80211_sinfo_release_content(&sinfo);
 		return -ENOMEM;
 	}
 
+	err = -EAGAIN;
+	if (rdev->ops->get_station_unlocked) {
+		err = rdev_get_station_unlocked(rdev, wdev, mac_addr, &sinfo);
+
+		if (err == -EAGAIN) {
+			cfg80211_sinfo_release_content(&sinfo);
+			memset(&sinfo, 0, sizeof(sinfo));
+		}
+	}
+
+	if (err == -EAGAIN) {
+		/* the wdev pointer is only valid until unlocking after this */
+		info->user_ptr[1] = NULL;
+		/* can fail if the wdev is being removed */
+		wdev = __nl80211_lock_held_wdev(rdev, genl_info_net(info),
+						wdev);
+		if (IS_ERR(wdev)) {
+			err = PTR_ERR(wdev);
+		} else {
+			locked = true;
+			err = rdev_get_station(rdev, wdev, mac_addr, &sinfo);
+		}
+	}
+
+	if (err) {
+		cfg80211_sinfo_release_content(&sinfo);
+		goto out;
+	}
+
 	if (sinfo.valid_links)
 		cfg80211_sta_set_mld_sinfo(&sinfo);
 
 	if (nl80211_send_station(msg, NL80211_CMD_NEW_STATION,
 				 info->snd_portid, info->snd_seq, 0,
-				 rdev, wdev, mac_addr, &sinfo) < 0) {
+				 rdev, wdev, mac_addr, &sinfo) < 0)
+		err = -ENOBUFS;
+out:
+	if (locked)
+		wiphy_unlock(&rdev->wiphy);
+	if (err) {
 		nlmsg_free(msg);
-		return -ENOBUFS;
+		return err;
 	}
 
 	return genlmsg_reply(msg, info);
@@ -19894,6 +20009,9 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 		 NL80211_FLAG_NEED_WIPHY)		\
 	SELECTOR(__sel, WDEV,				\
 		 NL80211_FLAG_NEED_WDEV)		\
+	SELECTOR(__sel, WDEV_NOMTX,			\
+		 NL80211_FLAG_NEED_WDEV |		\
+		 NL80211_FLAG_NO_WIPHY_MTX)		\
 	SELECTOR(__sel, NETDEV,				\
 		 NL80211_FLAG_NEED_NETDEV)		\
 	SELECTOR(__sel, NETDEV_LINK,			\
@@ -20323,7 +20441,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_get_station,
 		.dumpit = nl80211_dump_station,
 		.done = nl80211_dump_station_done,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV |
+					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
 };
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 5502cd947844..ae15cec9bf8b 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -248,6 +248,19 @@ static inline int rdev_get_station(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_get_station_unlocked(struct cfg80211_registered_device *rdev,
+			  struct wireless_dev *wdev, const u8 *mac,
+			  struct station_info *sinfo)
+{
+	int ret;
+
+	trace_rdev_get_station_unlocked(&rdev->wiphy, wdev, mac);
+	ret = rdev->ops->get_station_unlocked(&rdev->wiphy, wdev, mac, sinfo);
+	trace_rdev_return_int_station_info(&rdev->wiphy, ret, sinfo);
+	return ret;
+}
+
 static inline int rdev_dump_station(struct cfg80211_registered_device *rdev,
 				    struct wireless_dev *wdev, int idx, u8 *mac,
 				    struct station_info *sinfo)
@@ -259,6 +272,20 @@ static inline int rdev_dump_station(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_dump_station_unlocked(struct cfg80211_registered_device *rdev,
+			   struct wireless_dev *wdev, int idx, u8 *mac,
+			   struct station_info *sinfo)
+{
+	int ret;
+
+	trace_rdev_dump_station_unlocked(&rdev->wiphy, wdev, idx, mac);
+	ret = rdev->ops->dump_station_unlocked(&rdev->wiphy, wdev, idx, mac,
+					       sinfo);
+	trace_rdev_return_int_station_info(&rdev->wiphy, ret, sinfo);
+	return ret;
+}
+
 static inline int rdev_add_mpath(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *dst, u8 *next_hop)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 1f3c1e0eb26a..31000ffebe43 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1056,12 +1056,17 @@ DEFINE_EVENT(wiphy_wdev_mac_evt, rdev_get_station,
 	TP_ARGS(wiphy, wdev, mac)
 );
 
+DEFINE_EVENT(wiphy_wdev_mac_evt, rdev_get_station_unlocked,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, const u8 *mac),
+	TP_ARGS(wiphy, wdev, mac)
+);
+
 DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_del_mpath,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
 	TP_ARGS(wiphy, netdev, mac)
 );
 
-TRACE_EVENT(rdev_dump_station,
+DECLARE_EVENT_CLASS(rdev_dump_station_evt,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, int _idx,
 		 u8 *mac),
 	TP_ARGS(wiphy, wdev, _idx, mac),
@@ -1082,6 +1087,18 @@ TRACE_EVENT(rdev_dump_station,
 		  __entry->idx)
 );
 
+DEFINE_EVENT(rdev_dump_station_evt, rdev_dump_station,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, int _idx,
+		 u8 *mac),
+	TP_ARGS(wiphy, wdev, _idx, mac)
+);
+
+DEFINE_EVENT(rdev_dump_station_evt, rdev_dump_station_unlocked,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, int _idx,
+		 u8 *mac),
+	TP_ARGS(wiphy, wdev, _idx, mac)
+);
+
 TRACE_EVENT(rdev_return_int_station_info,
 	TP_PROTO(struct wiphy *wiphy, int ret, struct station_info *sinfo),
 	TP_ARGS(wiphy, ret, sinfo),
-- 
2.56.0

