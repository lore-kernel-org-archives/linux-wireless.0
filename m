Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61920 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0DLIPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 04:15:32 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3C8F5CN009625
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 11:15:30 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3C8FNxL013294
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 11:15:24 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] nl80211: Add support for dynamic ps timeout configuration
Date: Mon, 12 Apr 2010 11:11:42 +0300
Message-Id: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support to configure the dynamic ps timeout via nl80211. The
relevant attribute is added to NL80211_CMD_SET_POWER_SAVE.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/linux/nl80211.h |    2 ++
 net/wireless/nl80211.c  |   16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2ea3ede..c5f12e7 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -864,6 +864,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_LOCAL_STATE_CHANGE,
 
+	NL80211_ATTR_PS_TIMEOUT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index df5505b..709bda3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -151,6 +151,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
+	[NL80211_ATTR_PS_TIMEOUT] = { .type = NLA_U32 },
 };
 
 /* policy for the attributes */
@@ -4682,6 +4683,7 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev;
 	u8 ps_state;
 	bool state;
+	int timeout = -1;
 	int err;
 
 	if (!info->attrs[NL80211_ATTR_PS_STATE]) {
@@ -4696,6 +4698,14 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
+	if (info->attrs[NL80211_ATTR_PS_TIMEOUT]) {
+		timeout = nla_get_u32(info->attrs[NL80211_ATTR_PS_TIMEOUT]);
+		if (timeout < 0) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
 	rtnl_lock();
 
 	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
@@ -4710,11 +4720,14 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	state = (ps_state == NL80211_PS_ENABLED) ? true : false;
+	if (timeout < 0)
+		timeout = wdev->ps_timeout;
 
-	if (state == wdev->ps)
+	if (state == wdev->ps && timeout == wdev->ps_timeout)
 		goto unlock_rdev;
 
 	wdev->ps = state;
+	wdev->ps_timeout = timeout;
 
 	if (rdev->ops->set_power_mgmt(wdev->wiphy, dev, wdev->ps,
 				      wdev->ps_timeout))
@@ -4772,6 +4785,7 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 		ps_state = NL80211_PS_DISABLED;
 
 	NLA_PUT_U32(msg, NL80211_ATTR_PS_STATE, ps_state);
+	NLA_PUT_U32(msg, NL80211_ATTR_PS_TIMEOUT, wdev->ps_timeout);
 
 	genlmsg_end(msg, hdr);
 	err = genlmsg_reply(msg, info);
-- 
1.6.3.3

