Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:60113 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaFKOSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:43 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so3837565wes.41
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:42 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/10] cfg80211: pass TDLS initiator in tdls_mgmt operations
Date: Wed, 11 Jun 2014 17:18:21 +0300
Message-Id: <1402496307-32522-4-git-send-email-arik@wizery.com> (sfid-20140611_161856_585887_BFDDEEBB)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TDLS initiator is set once during link setup. If determines the
address ordering in the link identifier IE.

Fix dependent drivers - mwifiex and mac80211.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  3 ++-
 include/net/cfg80211.h                  |  2 +-
 include/uapi/linux/nl80211.h            |  5 +++++
 net/mac80211/ieee80211_i.h              |  3 ++-
 net/mac80211/tdls.c                     |  3 ++-
 net/wireless/nl80211.c                  |  4 ++++
 net/wireless/rdev-ops.h                 |  6 +++---
 net/wireless/trace.h                    | 10 +++++++---
 8 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e95dec9..149d2e6 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2631,7 +2631,8 @@ static int
 mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			   const u8 *peer, u8 action_code, u8 dialog_token,
 			   u16 status_code, u32 peer_capability,
-			   const u8 *extra_ies, size_t extra_ies_len)
+			   bool initiator, const u8 *extra_ies,
+			   size_t extra_ies_len)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int ret;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c17b1f..9d7b59e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2508,7 +2508,7 @@ struct cfg80211_ops {
 	int	(*tdls_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *peer, u8 action_code,  u8 dialog_token,
 			     u16 status_code, u32 peer_capability,
-			     const u8 *buf, size_t len);
+			     bool initiator, const u8 *buf, size_t len);
 	int	(*tdls_oper)(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *peer, enum nl80211_tdls_operation oper);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fb0efa1..407be5c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1591,6 +1591,9 @@ enum nl80211_commands {
  *	creation then the new interface will be owned by the netlink socket
  *	that created it and will be destroyed when the socket is closed
  *
+ * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
+ *	the TDLS link initiator.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1931,6 +1934,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_CSA_C_OFFSETS_TX,
 	NL80211_ATTR_MAX_CSA_COUNTERS,
 
+	NL80211_ATTR_TDLS_INITIATOR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b0d1d16..2e3d18c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1854,7 +1854,8 @@ int ieee80211_max_num_channels(struct ieee80211_local *local);
 int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, u8 action_code, u8 dialog_token,
 			u16 status_code, u32 peer_capability,
-			const u8 *extra_ies, size_t extra_ies_len);
+			bool initiator, const u8 *extra_ies,
+			size_t extra_ies_len);
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
 
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index cafcbde..0b3ca2c 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -299,7 +299,8 @@ fail:
 int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, u8 action_code, u8 dialog_token,
 			u16 status_code, u32 peer_capability,
-			const u8 *extra_ies, size_t extra_ies_len)
+			bool initiator, const u8 *extra_ies,
+			size_t extra_ies_len)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba4f172..8f46b8f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -337,6 +337,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
 	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_TDLS_INITIATOR] = { .type = NLA_FLAG },
 	[NL80211_ATTR_DONT_WAIT_FOR_ACK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PROBE_RESP] = { .type = NLA_BINARY,
 				      .len = IEEE80211_MAX_DATA_LEN },
@@ -7365,6 +7366,7 @@ static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
 	u32 peer_capability = 0;
 	u16 status_code;
 	u8 *peer;
+	bool initiator;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) ||
 	    !rdev->ops->tdls_mgmt)
@@ -7381,12 +7383,14 @@ static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
 	action_code = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_ACTION]);
 	status_code = nla_get_u16(info->attrs[NL80211_ATTR_STATUS_CODE]);
 	dialog_token = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN]);
+	initiator = nla_get_flag(info->attrs[NL80211_ATTR_TDLS_INITIATOR]);
 	if (info->attrs[NL80211_ATTR_TDLS_PEER_CAPABILITY])
 		peer_capability =
 			nla_get_u32(info->attrs[NL80211_ATTR_TDLS_PEER_CAPABILITY]);
 
 	return rdev_tdls_mgmt(rdev, dev, peer, action_code,
 			      dialog_token, status_code, peer_capability,
+			      initiator,
 			      nla_data(info->attrs[NL80211_ATTR_IE]),
 			      nla_len(info->attrs[NL80211_ATTR_IE]));
 }
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index f552b0a..56c2240 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -751,15 +751,15 @@ static inline int rdev_tdls_mgmt(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *peer,
 				 u8 action_code, u8 dialog_token,
 				 u16 status_code, u32 peer_capability,
-				 const u8 *buf, size_t len)
+				 bool initiator, const u8 *buf, size_t len)
 {
 	int ret;
 	trace_rdev_tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
 			     dialog_token, status_code, peer_capability,
-			     buf, len);
+			     initiator, buf, len);
 	ret = rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
 				   dialog_token, status_code, peer_capability,
-				   buf, len);
+				   initiator, buf, len);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 174559a..85474ee 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1454,9 +1454,9 @@ TRACE_EVENT(rdev_tdls_mgmt,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 u8 *peer, u8 action_code, u8 dialog_token,
 		 u16 status_code, u32 peer_capability,
-		 const u8 *buf, size_t len),
+		 bool initiator, const u8 *buf, size_t len),
 	TP_ARGS(wiphy, netdev, peer, action_code, dialog_token, status_code,
-		peer_capability, buf, len),
+		peer_capability, initiator, buf, len),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
@@ -1465,6 +1465,7 @@ TRACE_EVENT(rdev_tdls_mgmt,
 		__field(u8, dialog_token)
 		__field(u16, status_code)
 		__field(u32, peer_capability)
+		__field(bool, initiator)
 		__dynamic_array(u8, buf, len)
 	),
 	TP_fast_assign(
@@ -1475,13 +1476,16 @@ TRACE_EVENT(rdev_tdls_mgmt,
 		__entry->dialog_token = dialog_token;
 		__entry->status_code = status_code;
 		__entry->peer_capability = peer_capability;
+		__entry->initiator = initiator;
 		memcpy(__get_dynamic_array(buf), buf, len);
 	),
 	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT ", action_code: %u, "
-		  "dialog_token: %u, status_code: %u, peer_capability: %u buf: %#.2x ",
+		  "dialog_token: %u, status_code: %u, peer_capability: %u "
+		  "initiator: %s buf: %#.2x ",
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
 		  __entry->action_code, __entry->dialog_token,
 		  __entry->status_code, __entry->peer_capability,
+		  BOOL_TO_STR(__entry->initiator),
 		  ((u8 *)__get_dynamic_array(buf))[0])
 );
 
-- 
1.9.1

