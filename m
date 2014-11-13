Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48123 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088AbaKMQNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 11:13:47 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so8800149wib.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2014 08:13:46 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Jonathan Doron <jond@wizery.com>
Subject: [PATCH v2 4/4] cfg80211: Allow usermode to query wiphy specific regd info
Date: Thu, 13 Nov 2014 18:13:39 +0200
Message-Id: <1415895219-19848-4-git-send-email-arik@wizery.com> (sfid-20141113_171406_093413_8D6B6995)
In-Reply-To: <1415895219-19848-1-git-send-email-arik@wizery.com>
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
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
 include/uapi/linux/nl80211.h |  6 +++++
 net/wireless/nl80211.c       | 54 +++++++++++++++++++++++++++++++++++---------
 net/wireless/reg.c           |  2 +-
 net/wireless/reg.h           |  1 +
 4 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f050dcb..9c996bc 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1674,6 +1674,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
  *	&enum nl80211_smps_mode.
  *
+ * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating the
+ *	regulatory information came from the driver and not from the global
+ *	cfg80211 regulatory domain information.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -2026,6 +2030,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SMPS_MODE,
 
+	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3a422e6..f1f632c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -395,6 +395,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_USER_PRIO] = { .type = NLA_U8 },
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -5287,14 +5288,24 @@ static int nl80211_update_mesh_config(struct sk_buff *skb,
 
 static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 {
-	const struct ieee80211_regdomain *regdom;
+	const struct ieee80211_regdomain *regdom = NULL;
+	struct cfg80211_registered_device *rdev;
 	struct sk_buff *msg;
 	void *hdr = NULL;
 	struct nlattr *nl_reg_rules;
 	unsigned int i;
 
-	if (!cfg80211_regdomain)
-		return -EINVAL;
+	if (info->attrs[NL80211_ATTR_WIPHY] != NULL) {
+		struct wiphy *wiphy;
+
+		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		wiphy = &rdev->wiphy;
+		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+			regdom = get_wiphy_regdom(wiphy);
+	}
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -5305,13 +5316,27 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 	if (!hdr)
 		goto put_failure;
 
-	if (reg_last_request_cell_base() &&
-	    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
-			NL80211_USER_REG_HINT_CELL_BASE))
-		goto nla_put_failure;
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
+	} else {
+		if (nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+			goto nla_put_failure;
+		if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
+			goto nla_put_failure;
+	}
 
 	rcu_read_lock();
-	regdom = rcu_dereference(cfg80211_regdomain);
+
+	if (regdom == NULL)
+		regdom = rcu_dereference(cfg80211_regdomain);
 
 	if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2, regdom->alpha2) ||
 	    (regdom->dfs_region &&
@@ -10687,9 +10712,16 @@ static bool nl80211_reg_change_event_fill(struct sk_buff *msg,
 			goto nla_put_failure;
 	}
 
-	if (request->wiphy_idx != WIPHY_IDX_INVALID &&
-	    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx))
-		goto nla_put_failure;
+	if (request->wiphy_idx != WIPHY_IDX_INVALID) {
+		struct wiphy *wiphy;
+
+		wiphy = wiphy_idx_to_wiphy(request->wiphy_idx);
+		if ((wiphy != NULL) &&
+		    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx) &&
+		    (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
+		    (nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG)))
+			goto nla_put_failure;
+	}
 
 	return true;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4ee282d..a5f32d5 100644
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

