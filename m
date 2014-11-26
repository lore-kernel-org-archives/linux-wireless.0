Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56609 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaKZU4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 15:56:34 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so6316739wiv.14
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 12:56:32 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v4 4/4] cfg80211: return private regdom for self-managed devices
Date: Wed, 26 Nov 2014 22:56:28 +0200
Message-Id: <1417035388-2511-4-git-send-email-arik@wizery.com> (sfid-20141126_215638_465071_4FCB3B5D)
In-Reply-To: <1417035388-2511-1-git-send-email-arik@wizery.com>
References: <1417035388-2511-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a device has self-managed regulatory, insist on returning the wiphy
specific regdomain if a wiphy-idx is specified. The global regdomain is
meaningless for such devices.

Also add an attribute for self-managed devices, so usermode can distinguish
them as such.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 include/uapi/linux/nl80211.h |  7 +++++++
 net/wireless/nl80211.c       | 31 ++++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6517210..00a00ca 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1703,6 +1703,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_WIPHY_REGDOM_LIST: Nested set of attributes containing
  *	a list of wiphy specific regdomains.
  *
+ * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating this device
+ *	is self-managing its regulatory information and any regulatory domain
+ *	obtained from it is coming from the device's wiphy and not the global
+ *	cfg80211 regdomain.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2064,6 +2069,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_REGDOM_LIST,
 
+	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 65bab11..2a7f051 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -398,6 +398,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_PRIV_REG] = { .type = NLA_FLAG },
 	[NL80211_ATTR_WIPHY_REGDOM_LIST] = { .type = NLA_NESTED },
+	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -5409,6 +5410,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 		goto put_failure;
 
 	if (info->attrs[NL80211_ATTR_WIPHY]) {
+		bool self_managed;
 		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);
 		if (IS_ERR(rdev)) {
 			nlmsg_free(msg);
@@ -5416,10 +5418,22 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		wiphy = &rdev->wiphy;
+		self_managed = wiphy->regulatory_flags &
+			       REGULATORY_WIPHY_SELF_MANAGED;
 		regdom = get_wiphy_regdom(wiphy);
 		if (regdom &&
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
 			goto nla_put_failure;
+
+		/* a self-managed-reg device must have a private regdom */
+		if (WARN_ON(!regdom && self_managed)) {
+			nlmsg_free(msg);
+			return -EINVAL;
+		}
+
+		if (self_managed &&
+		    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+			goto nla_put_failure;
 	}
 
 	if (!regdom) {
@@ -5463,6 +5477,10 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 		if (nla_put_flag(msg, NL80211_ATTR_WIPHY_PRIV_REG))
 			goto nla_put_failure_rcu;
 
+		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+		    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+			goto nla_put_failure_rcu;
+
 		nla_nest_end(msg, nl_priv_regdom);
 		i++;
 	}
@@ -11031,9 +11049,16 @@ static bool nl80211_reg_change_event_fill(struct sk_buff *msg,
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
 
-- 
1.9.1

