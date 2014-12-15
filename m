Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50817 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaLORVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 12:21:00 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so9782293wid.5
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 09:20:59 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v9 3/4] cfg80211: return private regdom for self-managed devices
Date: Mon, 15 Dec 2014 19:20:54 +0200
Message-Id: <1418664055-3963-3-git-send-email-arik@wizery.com> (sfid-20141215_182106_518203_DF93A0E4)
In-Reply-To: <1418664055-3963-1-git-send-email-arik@wizery.com>
References: <1418664055-3963-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a device has self-managed regulatory, insist on returning the wiphy
specific regdomain if a wiphy-idx is specified. The global regdomain is
meaningless for such devices.

Also add an attribute for self-managed devices, so usermode can
distinguish them as such.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 include/uapi/linux/nl80211.h | 10 ++++++++++
 net/wireless/nl80211.c       | 24 ++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fb58e65..b3ada0b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -261,6 +261,9 @@
  *	the regulatory core to help with compliance. A dump version of this API
  *	is now available which will returns the global regdomain as well as
  *	all private regdomains of present wiphys (for those that have it).
+ *	If a wiphy is self-managed (%NL80211_ATTR_WIPHY_SELF_MANAGED_REG), then
+ *	its private regdomain is the only valid one for it. The regulatory
+ *	core is not used to help with compliance in this case.
  * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
  *	after being queried by the kernel. CRDA replies by sending a regulatory
  *	domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
@@ -1702,6 +1705,11 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_MAC_MASK: MAC address mask
  *
+ * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating this device
+ *	is self-managing its regulatory information and any regulatory domain
+ *	obtained from it is coming from the device's wiphy and not the global
+ *	cfg80211 regdomain.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2059,6 +2067,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAC_MASK,
 
+	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c04a934..3d972c2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -396,6 +396,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
+	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -1701,6 +1702,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			       rdev->wiphy.max_num_csa_counters))
 			goto nla_put_failure;
 
+		if (rdev->wiphy.regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+		    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
@@ -5406,6 +5411,8 @@ static int nl80211_get_reg_do(struct sk_buff *skb, struct genl_info *info)
 		goto put_failure;
 
 	if (info->attrs[NL80211_ATTR_WIPHY]) {
+		bool self_managed;
+
 		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);
 		if (IS_ERR(rdev)) {
 			nlmsg_free(msg);
@@ -5413,8 +5420,16 @@ static int nl80211_get_reg_do(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		wiphy = &rdev->wiphy;
+		self_managed = wiphy->regulatory_flags &
+			       REGULATORY_WIPHY_SELF_MANAGED;
 		regdom = get_wiphy_regdom(wiphy);
 
+		/* a self-managed-reg device must have a private regdom */
+		if (WARN_ON(!regdom && self_managed)) {
+			nlmsg_free(msg);
+			return -EINVAL;
+		}
+
 		if (regdom &&
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy)))
 			goto nla_put_failure;
@@ -5471,6 +5486,10 @@ static int nl80211_send_regdom(struct sk_buff *msg, struct netlink_callback *cb,
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy)))
 		goto nla_put_failure;
 
+	if (wiphy && wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+	    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+		goto nla_put_failure;
+
 	return genlmsg_end(msg, hdr);
 
 nla_put_failure:
@@ -11076,6 +11095,11 @@ static bool nl80211_reg_change_event_fill(struct sk_buff *msg,
 		if (wiphy &&
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx))
 			goto nla_put_failure;
+
+		if (wiphy &&
+		    wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+		    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+			goto nla_put_failure;
 	}
 
 	return true;
-- 
1.9.1

