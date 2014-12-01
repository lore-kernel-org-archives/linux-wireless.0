Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62900 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbaLAPsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 10:48:53 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so14487167wgh.10
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 07:48:52 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v6 3/4] cfg80211: return private regdom for self-managed devices
Date: Mon,  1 Dec 2014 17:48:46 +0200
Message-Id: <1417448927-9337-3-git-send-email-arik@wizery.com> (sfid-20141201_164857_533991_3B2CF622)
In-Reply-To: <1417448927-9337-1-git-send-email-arik@wizery.com>
References: <1417448927-9337-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a device has self-managed regulatory, insist on returning the wiphy
specific regdomain if a wiphy-idx is specified. The global regdomain is
meaningless for such devices.

Also add an attribute for self-managed devices, so usermode can
distinguish them as such.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/wireless/nl80211.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index de523aa..ca60c6a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -396,6 +396,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
+	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -5406,6 +5407,8 @@ static int nl80211_get_reg_do(struct sk_buff *skb, struct genl_info *info)
 		goto put_failure;
 
 	if (info->attrs[NL80211_ATTR_WIPHY]) {
+		bool self_managed;
+
 		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);
 		if (IS_ERR(rdev)) {
 			nlmsg_free(msg);
@@ -5413,8 +5416,16 @@ static int nl80211_get_reg_do(struct sk_buff *skb, struct genl_info *info)
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
@@ -5476,6 +5487,10 @@ static int nl80211_send_regdom(struct sk_buff *msg, struct netlink_callback *cb,
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy)))
 		goto nla_put_failure;
 
+	if (wiphy && wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
+	    nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
+		goto nla_put_failure;
+
 	return genlmsg_end(msg, hdr);
 
 nla_put_failure:
@@ -11081,6 +11096,11 @@ static bool nl80211_reg_change_event_fill(struct sk_buff *msg,
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

