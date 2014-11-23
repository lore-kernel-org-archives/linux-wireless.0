Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38733 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaKWPCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 10:02:30 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so3431993wid.3
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2014 07:02:28 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Jonathan Doron <jond@wizery.com>
Subject: [PATCH v3 3/3] cfg80211: Allow usermode to query wiphy specific regd info
Date: Sun, 23 Nov 2014 17:02:21 +0200
Message-Id: <1416754941-4439-3-git-send-email-arik@wizery.com> (sfid-20141123_160234_292469_6765BC47)
In-Reply-To: <1416754941-4439-1-git-send-email-arik@wizery.com>
References: <1416754941-4439-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jonathan Doron <jond@wizery.com>

Allow usermode to query wiphy-specific regd info, for drivers that use
wiphy-specific regulatory management.

Use the existing API for sending regdomain info to usermode, but return
the wiphy-specific regd in case wiphy index is provided and the driver
employs wiphy-specific management. This implies user and kernel-mode
support for the feature and is backward compatible.

Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 include/uapi/linux/nl80211.h | 18 ++++++++++-
 net/wireless/nl80211.c       | 71 ++++++++++++++++++++++++++++++++++++--------
 net/wireless/reg.c           |  2 +-
 net/wireless/reg.h           |  1 +
 4 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 3771e7d..b222e5c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -252,7 +252,12 @@
  *	%NL80211_ATTR_IFINDEX.
  *
  * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
- * 	regulatory domain.
+ *	regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
+ *	self-manages its regulatory settings, its private regulatory domain
+ *	will be returned.
+ *	If %NL80211_ATTR_WIPHY_GET_PRIV_REG is specified in addition to
+ *	%NL80211_ATTR_WIPHY, a device's private regulatory domain will be
+ *	returned, even if it's regulatory is not self-managed.
  * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
  *	after being queried by the kernel. CRDA replies by sending a regulatory
  *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
@@ -1693,6 +1698,14 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_MAC_MASK: MAC address mask
  *
+ * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating the
+ *	regulatory information was obtained from the private regdomain
+ *	of a device with self-managed regulatory.
+ * @NL80211_ATTR_WIPHY_GET_PRIV_REG: flag attribute indicating the regulatory
+ *	information should be obtained from a device's private regdomain,
+ *	if it exists. This will happen even if the device is not self-managing
+ *	its regulatory.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2050,6 +2063,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAC_MASK,
 
+	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
+	NL80211_ATTR_WIPHY_GET_PRIV_REG,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index de3a47a..42ccca7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -396,6 +396,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
+	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
+	[NL80211_ATTR_WIPHY_GET_PRIV_REG] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -5328,15 +5330,12 @@ static int nl80211_update_mesh_config(struct sk_buff *skb,
 
 static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 {
-	const struct ieee80211_regdomain *regdom;
+	const struct ieee80211_regdomain *regdom = NULL;
 	struct sk_buff *msg;
 	void *hdr = NULL;
 	struct nlattr *nl_reg_rules;
 	unsigned int i;
 
-	if (!cfg80211_regdomain)
-		return -EINVAL;
-
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOBUFS;
@@ -5346,13 +5345,54 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 	if (!hdr)
 		goto put_failure;
 
-	if (reg_last_request_cell_base() &&
-	    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
-			NL80211_USER_REG_HINT_CELL_BASE))
-		goto nla_put_failure;
+	if (info->attrs[NL80211_ATTR_WIPHY]) {
+		u32 reg_flags;
+		struct wiphy *wiphy;
+		struct cfg80211_registered_device *rdev =
+			cfg80211_get_dev_from_info(genl_info_net(info), info);
+
+		if (IS_ERR(rdev)) {
+			nlmsg_free(msg);
+			return PTR_ERR(rdev);
+		}
+
+		wiphy = &rdev->wiphy;
+		reg_flags = wiphy->regulatory_flags;
+		if (reg_flags & REGULATORY_WIPHY_SELF_MANAGED ||
+		    info->attrs[NL80211_ATTR_WIPHY_GET_PRIV_REG]) {
+			regdom = get_wiphy_regdom(wiphy);
+			if (!regdom) {
+				nlmsg_free(msg);
+				return -EINVAL;
+			}
+
+			if (nla_put_u32(msg, NL80211_ATTR_WIPHY,
+					rdev->wiphy_idx))
+				goto nla_put_failure;
+
+			if (reg_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+			    nla_put_flag(msg,
+					 NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+				goto nla_put_failure;
+		}
+	}
+
+	if (!regdom) {
+		if (!cfg80211_regdomain) {
+			nlmsg_free(msg);
+			return -EINVAL;
+		}
+
+		if (reg_last_request_cell_base() &&
+		    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
+				NL80211_USER_REG_HINT_CELL_BASE))
+			goto nla_put_failure;
+	}
 
 	rcu_read_lock();
-	regdom = rcu_dereference(cfg80211_regdomain);
+
+	if (!regdom)
+		regdom = rcu_dereference(cfg80211_regdomain);
 
 	if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2, regdom->alpha2) ||
 	    (regdom->dfs_region &&
@@ -10970,9 +11010,16 @@ static bool nl80211_reg_change_event_fill(struct sk_buff *msg,
 			goto nla_put_failure;
 	}
 
-	if (request->wiphy_idx != WIPHY_IDX_INVALID &&
-	    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx))
-		goto nla_put_failure;
+	if (request->wiphy_idx != WIPHY_IDX_INVALID) {
+		struct wiphy *wiphy;
+
+		wiphy = wiphy_idx_to_wiphy(request->wiphy_idx);
+		if (wiphy &&
+		    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx) &&
+		    wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+		    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+			goto nla_put_failure;
+	}
 
 	return true;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 18cf13b..662d947 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -142,7 +142,7 @@ static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 	return rtnl_dereference(cfg80211_regdomain);
 }
 
-static const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
+const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
 {
 	return rtnl_dereference(wiphy->regd);
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 5e48031..4b45d6e 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -38,6 +38,7 @@ unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 				   const struct ieee80211_reg_rule *rule);
 
 bool reg_last_request_cell_base(void);
+const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy);
 
 /**
  * regulatory_hint_found_beacon - hints a beacon was found on a channel
-- 
1.9.1

