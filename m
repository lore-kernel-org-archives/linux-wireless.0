Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932351AbcKJLd6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:33:58 -0500
From: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Subject: cfg80211: add set/get link loss profile
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Message-ID: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org> (sfid-20161110_123409_842187_99F18EF4)
Date: Thu, 10 Nov 2016 13:33:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From b739abb6f29dc43a86b8b2b60e893b4441f8aa1f Mon Sep 17 00:00:00 2001
From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Date: Sun, 6 Nov 2016 16:21:20 +0200
Subject: [PATCH] cfg80211: add set/get link loss profile

Introduce NL80211_CMD_SET_LINK_LOSS_PROFILE and
NL80211_CMD_GET_LINK_LOSS_PROFILE as it required by the user space
to configure the link loss profile.
The link loss profile represents the priority of maintaining link up
in different link quality environments.
Three types of behavior for link loss defined:
LINK_LOSS_PROFILE_RELAXED: prefer maintaining link up even in poor
link quality environment.
LINK_LOSS_PROFILE_DEFAULT: The default behavior for maintaining link
up vs link quality.
LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link up in poor link
quality environment.
New cfg80211 API also been added, set/get_link_loss_profile.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 18 ++++++++
 include/net/cfg80211.h                      | 13 ++++++
 include/uapi/linux/nl80211.h                | 32 +++++++++++++
 net/wireless/nl80211.c                      | 70 +++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h                     | 28 ++++++++++++
 net/wireless/trace.h                        | 39 ++++++++++++++++
 6 files changed, 200 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index d117240..f8d576b 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1424,6 +1424,22 @@ static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
     mutex_unlock(&wil->mutex);
 }
 
+static int
+wil_cfg80211_set_link_loss_profile(struct wiphy *wiphy,
+                   struct wireless_dev *wdev,
+                   enum nl80211_link_loss_profile profile,
+                   const u8 *addr)
+{
+    return -ENOTSUPP;
+}
+
+static enum nl80211_link_loss_profile
+wil_cfg80211_get_link_loss_profile(struct wiphy *wiphy,
+                   struct wireless_dev *wdev, const u8 *addr)
+{
+    return -ENOTSUPP;
+}
+
 static struct cfg80211_ops wil_cfg80211_ops = {
     .add_virtual_intf = wil_cfg80211_add_iface,
     .del_virtual_intf = wil_cfg80211_del_iface,
@@ -1450,6 +1466,8 @@ static struct cfg80211_ops wil_cfg80211_ops = {
     /* P2P device */
     .start_p2p_device = wil_cfg80211_start_p2p_device,
     .stop_p2p_device = wil_cfg80211_stop_p2p_device,
+    .set_link_loss_profile = wil_cfg80211_set_link_loss_profile,
+    .get_link_loss_profile = wil_cfg80211_get_link_loss_profile,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 41ae3f5..2d7a0af 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2744,6 +2744,10 @@ struct cfg80211_nan_func {
  *    All other parameters must be ignored.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
+ *
+ * @set_link_loss_profile: Set link loss profile for specific connection.
+ * @get_link_loss_profile: Get the current link loss profile of specific
+ *    connection.
  */
 struct cfg80211_ops {
     int    (*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3024,6 +3028,15 @@ struct cfg80211_ops {
     int    (*set_multicast_to_unicast)(struct wiphy *wiphy,
                         struct net_device *dev,
                         const bool enabled);
+
+    int    (*set_link_loss_profile)(struct wiphy *wiphy,
+                     struct wireless_dev *wdev,
+                     enum nl80211_link_loss_profile profile,
+                     const u8 *addr);
+    enum nl80211_link_loss_profile    (*get_link_loss_profile)(
+                     struct wiphy *wiphy,
+                     struct wireless_dev *wdev,
+                     const u8 *addr);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e21d23d..b68fad2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -888,6 +888,11 @@
  *    This will contain a %NL80211_ATTR_NAN_MATCH nested attribute and
  *    %NL80211_ATTR_COOKIE.
  *
+ * @NL80211_CMD_SET_LINK_LOSS_PROFILE: Set link loss profile (behavior) for
+ *    specific connection.
+ * @NL80211_CMD_GET_LINK_LOSS_PROFILE: Get current link loss profile of specific
+ *    connection.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1085,6 +1090,9 @@ enum nl80211_commands {
 
     NL80211_CMD_SET_MULTICAST_TO_UNICAST,
 
+    NL80211_CMD_SET_LINK_LOSS_PROFILE,
+    NL80211_CMD_GET_LINK_LOSS_PROFILE,
+
     /* add new commands above here */
 
     /* used to define NL80211_CMD_MAX below */
@@ -1969,6 +1977,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED: Indicates whether or not multicast
  *    packets should be send out as unicast to all stations (flag attribute).
  *
+ * @NL80211_ATTR_LINK_LOSS_PROFILE: attribute that indicate the link loss
+ *    behavior using &enum nl80211_link_loss_profile values.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2373,6 +2384,8 @@ enum nl80211_attrs {
 
     NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED,
 
+    NL80211_ATTR_LINK_LOSS_PROFILE,
+
     /* add attributes here, update the policy in nl80211.c */
 
     __NL80211_ATTR_AFTER_LAST,
@@ -5174,4 +5187,23 @@ enum nl80211_nan_match_attributes {
     NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
 };
 
+/**
+ * enum nl80211_link_loss_profile.
+ *
+ * Used by set_link_loss_profile() and get_link_loss_profile()
+ * to set/get link loss behavior.
+ *
+ * @NL80211_LINK_LOSS_PROFILE_RELAXED: prefer maintaining link
+ *    up even in poor link quality environment
+ * @NL80211_LINK_LOSS_PROFILE_DEFAULT: The default behavior for
+ *    maintaining link up vs link quality.
+ * @NL80211_LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link
+ *    up in poor link quality environment
+ */
+enum nl80211_link_loss_profile {
+    NL80211_LINK_LOSS_PROFILE_RELAXED,
+    NL80211_LINK_LOSS_PROFILE_DEFAULT,
+    NL80211_LINK_LOSS_PROFILE_AGGRESSIVE
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46b2e8c..c8dc7e2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -418,6 +418,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
                     .len = FILS_MAX_KEK_LEN },
     [NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
     [NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
+    [NL80211_ATTR_LINK_LOSS_PROFILE] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -11792,6 +11793,60 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
     return rdev_set_multicast_to_unicast(rdev, dev, enabled);
 }
 
+static int nl80211_set_link_loss_profile(struct sk_buff *skb,
+                     struct genl_info *info)
+{
+    struct cfg80211_registered_device *rdev = info->user_ptr[0];
+    struct wireless_dev *wdev = info->user_ptr[1];
+    enum nl80211_link_loss_profile profile;
+    const u8 *addr;
+    int ret;
+
+    if (!info->attrs[NL80211_ATTR_LINK_LOSS_PROFILE] ||
+        !info->attrs[NL80211_ATTR_MAC])
+        return -EINVAL;
+
+    profile = nla_get_u8(info->attrs[NL80211_ATTR_LINK_LOSS_PROFILE]);
+    addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+    if (profile != NL80211_LINK_LOSS_PROFILE_RELAXED &&
+        profile != NL80211_LINK_LOSS_PROFILE_DEFAULT &&
+        profile != NL80211_LINK_LOSS_PROFILE_AGGRESSIVE)
+        return -EINVAL;
+
+    if (!rdev->ops->set_link_loss_profile)
+        return -EOPNOTSUPP;
+
+    wdev_lock(wdev);
+    ret = rdev_set_link_loss_profile(rdev, wdev, profile, addr);
+    wdev_unlock(wdev);
+
+    return ret;
+}
+
+static int nl80211_get_link_loss_profile(struct sk_buff *skb,
+                     struct genl_info *info)
+{
+    struct cfg80211_registered_device *rdev = info->user_ptr[0];
+    struct wireless_dev *wdev = info->user_ptr[1];
+    const u8 *addr;
+    enum nl80211_link_loss_profile profile;
+
+    if (!info->attrs[NL80211_ATTR_MAC])
+        return -EINVAL;
+
+    addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+    if (!rdev->ops->get_link_loss_profile)
+        return -EOPNOTSUPP;
+
+    wdev_lock(wdev);
+    profile = rdev_get_link_loss_profile(rdev, wdev, addr);
+    wdev_unlock(wdev);
+
+    return profile;
+}
+
 #define NL80211_FLAG_NEED_WIPHY        0x01
 #define NL80211_FLAG_NEED_NETDEV    0x02
 #define NL80211_FLAG_NEED_RTNL        0x04
@@ -12659,6 +12714,21 @@ static const struct genl_ops nl80211_ops[] = {
         .internal_flags = NL80211_FLAG_NEED_NETDEV |
                   NL80211_FLAG_NEED_RTNL,
     },
+    {
+    .cmd = NL80211_CMD_SET_LINK_LOSS_PROFILE,
+        .doit = nl80211_set_link_loss_profile,
+        .policy = nl80211_policy,
+        .flags = GENL_ADMIN_PERM,
+        .internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+                  NL80211_FLAG_NEED_RTNL,
+    },
+    {
+    .cmd = NL80211_CMD_GET_LINK_LOSS_PROFILE,
+        .doit = nl80211_get_link_loss_profile,
+        .policy = nl80211_policy,
+        .internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+                  NL80211_FLAG_NEED_RTNL,
+    },
 };
 
 /* notification functions */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index e9ecf23..9a377c8 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1141,4 +1141,32 @@ rdev_set_coalesce(struct cfg80211_registered_device *rdev,
     trace_rdev_return_int(&rdev->wiphy, ret);
     return ret;
 }
+
+static inline int
+rdev_set_link_loss_profile(struct cfg80211_registered_device *rdev,
+               struct wireless_dev *wdev,
+               enum nl80211_link_loss_profile profile,
+               const u8 *addr)
+{
+    int ret;
+
+    trace_rdev_set_link_loss_profile(&rdev->wiphy, wdev, profile, addr);
+    ret = rdev->ops->set_link_loss_profile(&rdev->wiphy, wdev, profile,
+                           addr);
+    trace_rdev_return_int(&rdev->wiphy, ret);
+    return ret;
+}
+
+static inline enum nl80211_link_loss_profile
+rdev_get_link_loss_profile(struct cfg80211_registered_device *rdev,
+               struct wireless_dev *wdev,
+               const u8 *addr)
+{
+    enum nl80211_link_loss_profile profile;
+
+    trace_rdev_get_link_loss_profile(&rdev->wiphy, wdev, addr);
+    profile = rdev->ops->get_link_loss_profile(&rdev->wiphy, wdev, addr);
+    trace_rdev_return_int(&rdev->wiphy, profile);
+    return profile;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 25f8318..d93a4b1 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2212,6 +2212,45 @@ TRACE_EVENT(rdev_tdls_cancel_channel_switch,
           WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr))
 );
 
+TRACE_EVENT(rdev_set_link_loss_profile,
+    TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+         enum nl80211_link_loss_profile profile, const u8 *addr),
+    TP_ARGS(wiphy, wdev, profile, addr),
+    TP_STRUCT__entry(
+        WIPHY_ENTRY
+        WDEV_ENTRY
+        __field(enum nl80211_link_loss_profile, profile)
+        MAC_ENTRY(addr)
+    ),
+    TP_fast_assign(
+        WIPHY_ASSIGN;
+        WDEV_ASSIGN;
+        __entry->profile = profile;
+        MAC_ASSIGN(addr, addr);
+    ),
+    TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", " MAC_PR_FMT ", PROFILE %d",
+          WIPHY_PR_ARG, WDEV_PR_ARG, MAC_PR_ARG(addr),
+          __entry->profile)
+);
+
+TRACE_EVENT(rdev_get_link_loss_profile,
+    TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+         const u8 *addr),
+    TP_ARGS(wiphy, wdev, addr),
+    TP_STRUCT__entry(
+        WIPHY_ENTRY
+        WDEV_ENTRY
+        MAC_ENTRY(addr)
+    ),
+    TP_fast_assign(
+        WIPHY_ASSIGN;
+        WDEV_ASSIGN;
+        MAC_ASSIGN(addr, addr);
+    ),
+    TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", " MAC_PR_FMT, WIPHY_PR_ARG,
+          WDEV_PR_ARG, MAC_PR_ARG(addr))
+);
+
 /*************************************************************
  *         cfg80211 exported functions traces             *
  *************************************************************/
-- 
2.5.0
