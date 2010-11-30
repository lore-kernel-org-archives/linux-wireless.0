Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39541 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0K3KE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 05:04:29 -0500
Received: by fxm8 with SMTP id 8so984641fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 02:04:28 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211: add NL80211_ATTR_PS_TIMEOUT attribute
Date: Tue, 30 Nov 2010 12:04:27 +0200
Message-Id: <1291111467-10531-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with this attribute we can control the timeout in dynamic ps
(similar to "iwconfig wlan0 power timeout" command).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/nl80211.h |    2 ++
 net/wireless/nl80211.c  |   18 ++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 1ce3775..d469bb7 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1002,6 +1002,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MCAST_RATE,
 
+	NL80211_ATTR_PS_TIMEOUT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 13a40dd..0948980 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -160,6 +160,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 				 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_PS_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
@@ -4283,8 +4284,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct wireless_dev *wdev;
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int timeout = wdev->ps_timeout;
 	u8 ps_state;
 	bool state;
 	int err;
@@ -4297,20 +4299,23 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 	if (ps_state != NL80211_PS_DISABLED && ps_state != NL80211_PS_ENABLED)
 		return -EINVAL;
 
-	wdev = dev->ieee80211_ptr;
-
 	if (!rdev->ops->set_power_mgmt)
 		return -EOPNOTSUPP;
 
+	if (info->attrs[NL80211_ATTR_PS_TIMEOUT])
+		timeout = nla_get_u32(info->attrs[NL80211_ATTR_PS_TIMEOUT]);
+
 	state = (ps_state == NL80211_PS_ENABLED) ? true : false;
 
-	if (state == wdev->ps)
+	if (state == wdev->ps && timeout == wdev->ps_timeout)
 		return 0;
 
 	err = rdev->ops->set_power_mgmt(wdev->wiphy, dev, state,
-					wdev->ps_timeout);
-	if (!err)
+					timeout);
+	if (!err) {
 		wdev->ps = state;
+		wdev->ps_timeout = timeout;
+	}
 	return err;
 }
 
@@ -4346,6 +4351,7 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 		ps_state = NL80211_PS_DISABLED;
 
 	NLA_PUT_U32(msg, NL80211_ATTR_PS_STATE, ps_state);
+	NLA_PUT_U32(msg, NL80211_ATTR_PS_TIMEOUT, wdev->ps_timeout);
 
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
-- 
1.7.0.4

