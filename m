Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932335AbdCFOUB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 09:20:01 -0500
Subject: [PATCH v3] cfg80211: add set/get link loss profile
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
 <8737izqw0q.fsf@purkki.adurom.net>
 <b1ab1406-d996-fc03-d0a2-b8028c7c0044@codeaurora.org>
 <8737ipm4jy.fsf@kamboji.qca.qualcomm.com>
 <9bdf0a3a-1283-21c5-0739-e0b48dd9ddcc@codeaurora.org>
 <1482253209.30160.13.camel@redhat.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com
From: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Message-ID: <62127d4a-db9f-ab77-fb86-17d92b0ce81d@codeaurora.org> (sfid-20170306_152046_835052_AC7B775E)
Date: Mon, 6 Mar 2017 15:54:24 +0200
MIME-Version: 1.0
In-Reply-To: <1482253209.30160.13.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From ca61946032a47c8daf1b9013de9f4c72c6e7aaaf Mon Sep 17 00:00:00 2001
From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Date: Mon, 6 Mar 2017 15:47:08 +0200
Subject: [PATCH] cfg80211: add set/get link loss profile

Introduce NL80211_CMD_SET_LINK_LOSS_PROFILE and
NL80211_CMD_GET_LINK_LOSS_PROFILE needed by user space to configure the
link loss profile.
Link loss detection involves close monitoring of the RF link and can
consider dozens of factors like keep alive packets, missing ACKs and
beacons, SNR and so on.
This is why it is usually offloaded to firmware.
This API is intended as a hint to the firmware to decide when to
actually disconnect when potential link loss is detected.
The supported values are:
AGGRESSIVE: disconnect as soon as possible when potential link loss
is detected, even for a very short time (tens of milliseconds).
Choose this when you have a backup connection and you can automatically
switch to the other connection when link is disconnected, like FST
(fast session transfer).
This will keep the connection alive and prevent even short interruptions.
DEFAULT: the default behavior, can be different in each driver but
usually link is maintained for average amounts of time, typically few
seconds of potential link loss before actual disconnection.
User space can monitor the link using CQM notifications or other methods
and disconnect manually if needed.
RELAXED: maintain the link for a long time (typically one minute or more)
even if potential link loss is detected. Choose this if you want user
space to make the decision on when to disconnect

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
---
 include/net/cfg80211.h       | 12 ++++++++
 include/uapi/linux/nl80211.h | 33 +++++++++++++++++++++
 net/wireless/nl80211.c       | 70 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 28 ++++++++++++++++++
 net/wireless/trace.h         | 39 ++++++++++++++++++++++++
 5 files changed, 182 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ffc0868..6b3bc33 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2821,6 +2821,10 @@ struct cfg80211_nan_func {
  *	All other parameters must be ignored.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
+ *
+ * @set_link_loss_profile: Set link loss profile for specific connection.
+ * @get_link_loss_profile: Get the current link loss profile of specific
+ *	connection.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3109,6 +3113,14 @@ struct cfg80211_ops {
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
+	int	(*set_link_loss_profile)(struct wiphy *wiphy,
+					 struct wireless_dev *wdev,
+					 enum nl80211_link_loss_profile profile,
+					 const u8 *addr);
+	enum nl80211_link_loss_profile	(*get_link_loss_profile)(
+					 struct wiphy *wiphy,
+					 struct wireless_dev *wdev,
+					 const u8 *addr);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a499b1..485d670 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -901,6 +901,11 @@
  *	does not result in a change for the current association. Currently,
  *	only the %NL80211_ATTR_IE data is used and updated with this command.
  *
+ * @NL80211_CMD_SET_LINK_LOSS_PROFILE: Set link loss profile (behavior) for
+ *	specific connection.
+ * @NL80211_CMD_GET_LINK_LOSS_PROFILE: Get current link loss profile of specific
+ *	connection.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1100,6 +1105,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_CONNECT_PARAMS,
 
+	NL80211_CMD_SET_LINK_LOSS_PROFILE,
+	NL80211_CMD_GET_LINK_LOSS_PROFILE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2013,6 +2021,10 @@ enum nl80211_commands {
  *	e.g., with %NL80211_CMD_CONNECT event.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
+ *
+ * @NL80211_ATTR_LINK_LOSS_PROFILE: attribute that indicate the link loss
+ *	behavior using &enum nl80211_link_loss_profile values.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -2423,6 +2435,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TIMEOUT_REASON,
 
+	NL80211_ATTR_LINK_LOSS_PROFILE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5254,4 +5268,23 @@ enum nl80211_nan_match_attributes {
 	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
 };
 
+/**
+ * enum nl80211_link_loss_profile.
+ *
+ * Used by set_link_loss_profile() and get_link_loss_profile()
+ * to set/get link loss behavior.
+ *
+ * @NL80211_LINK_LOSS_PROFILE_RELAXED: prefer maintaining link
+ *	up even in poor link quality environment
+ * @NL80211_LINK_LOSS_PROFILE_DEFAULT: The default behavior for
+ *	maintaining link up vs link quality.
+ * @NL80211_LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link
+ *	up in poor link quality environment
+ */
+enum nl80211_link_loss_profile {
+	NL80211_LINK_LOSS_PROFILE_RELAXED,
+	NL80211_LINK_LOSS_PROFILE_DEFAULT,
+	NL80211_LINK_LOSS_PROFILE_AGGRESSIVE
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d516527..1ff90def 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -410,6 +410,7 @@ enum nl80211_multicast_groups {
 		.len = sizeof(struct nl80211_bss_select_rssi_adjust)
 	},
 	[NL80211_ATTR_TIMEOUT_REASON] = { .type = NLA_U32 },
+	[NL80211_ATTR_LINK_LOSS_PROFILE] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -12067,6 +12068,60 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 	return rdev_set_multicast_to_unicast(rdev, dev, enabled);
 }
 
+static int nl80211_set_link_loss_profile(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	enum nl80211_link_loss_profile profile;
+	const u8 *addr;
+	int ret;
+
+	if (!info->attrs[NL80211_ATTR_LINK_LOSS_PROFILE] ||
+	    !info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	profile = nla_get_u8(info->attrs[NL80211_ATTR_LINK_LOSS_PROFILE]);
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (profile != NL80211_LINK_LOSS_PROFILE_RELAXED &&
+	    profile != NL80211_LINK_LOSS_PROFILE_DEFAULT &&
+	    profile != NL80211_LINK_LOSS_PROFILE_AGGRESSIVE)
+		return -EINVAL;
+
+	if (!rdev->ops->set_link_loss_profile)
+		return -EOPNOTSUPP;
+
+	wdev_lock(wdev);
+	ret = rdev_set_link_loss_profile(rdev, wdev, profile, addr);
+	wdev_unlock(wdev);
+
+	return ret;
+}
+
+static int nl80211_get_link_loss_profile(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	const u8 *addr;
+	enum nl80211_link_loss_profile profile;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (!rdev->ops->get_link_loss_profile)
+		return -EOPNOTSUPP;
+
+	wdev_lock(wdev);
+	profile = rdev_get_link_loss_profile(rdev, wdev, addr);
+	wdev_unlock(wdev);
+
+	return profile;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -12942,6 +12997,21 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+	.cmd = NL80211_CMD_SET_LINK_LOSS_PROFILE,
+		.doit = nl80211_set_link_loss_profile,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+	.cmd = NL80211_CMD_GET_LINK_LOSS_PROFILE,
+		.doit = nl80211_get_link_loss_profile,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index f2baf59..0caa9e4 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1165,4 +1165,32 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int
+rdev_set_link_loss_profile(struct cfg80211_registered_device *rdev,
+			   struct wireless_dev *wdev,
+			   enum nl80211_link_loss_profile profile,
+			   const u8 *addr)
+{
+	int ret;
+
+	trace_rdev_set_link_loss_profile(&rdev->wiphy, wdev, profile, addr);
+	ret = rdev->ops->set_link_loss_profile(&rdev->wiphy, wdev, profile,
+					       addr);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline enum nl80211_link_loss_profile
+rdev_get_link_loss_profile(struct cfg80211_registered_device *rdev,
+			   struct wireless_dev *wdev,
+			   const u8 *addr)
+{
+	enum nl80211_link_loss_profile profile;
+
+	trace_rdev_get_link_loss_profile(&rdev->wiphy, wdev, addr);
+	profile = rdev->ops->get_link_loss_profile(&rdev->wiphy, wdev, addr);
+	trace_rdev_return_int(&rdev->wiphy, profile);
+	return profile;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index fd55786..a4635e4 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2252,6 +2252,45 @@
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr))
 );
 
+TRACE_EVENT(rdev_set_link_loss_profile,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 enum nl80211_link_loss_profile profile, const u8 *addr),
+	TP_ARGS(wiphy, wdev, profile, addr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(enum nl80211_link_loss_profile, profile)
+		MAC_ENTRY(addr)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->profile = profile;
+		MAC_ASSIGN(addr, addr);
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", " MAC_PR_FMT ", PROFILE %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, MAC_PR_ARG(addr),
+		  __entry->profile)
+);
+
+TRACE_EVENT(rdev_get_link_loss_profile,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 const u8 *addr),
+	TP_ARGS(wiphy, wdev, addr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		MAC_ENTRY(addr)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		MAC_ASSIGN(addr, addr);
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", " MAC_PR_FMT, WIPHY_PR_ARG,
+		  WDEV_PR_ARG, MAC_PR_ARG(addr))
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.9.1
