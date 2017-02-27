Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37998 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751046AbdB0QRi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 11:17:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: check HWSIM_ATTR_RADIO_NAME length
Date: Mon, 27 Feb 2017 17:16:40 +0100
Message-Id: <20170227161640.3874-1-johannes@sipsolutions.net> (sfid-20170227_171849_384843_20C034F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unfortunately, the nla policy was defined to have HWSIM_ATTR_RADIO_NAME
as an NLA_STRING, rather than NLA_NUL_STRING, so we can't use it as a
NUL-terminated string in the kernel.

Rather than break the API, kasprintf() the string to a new buffer to
guarantee NUL termination.

Reported-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0889fc81ce9e..50c219fb1a52 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3056,6 +3056,7 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct hwsim_new_radio_params param = { 0 };
+	const char *hwname = NULL;
 
 	param.reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 	param.p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
@@ -3069,8 +3070,14 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	if (info->attrs[HWSIM_ATTR_NO_VIF])
 		param.no_vif = true;
 
-	if (info->attrs[HWSIM_ATTR_RADIO_NAME])
-		param.hwname = nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
+	if (info->attrs[HWSIM_ATTR_RADIO_NAME]) {
+		hwname = kasprintf(GFP_KERNEL, "%.*s",
+				   nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				   (char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]));
+		if (!hwname)
+			return -ENOMEM;
+		param.hwname = hwname;
+	}
 
 	if (info->attrs[HWSIM_ATTR_USE_CHANCTX])
 		param.use_chanctx = true;
@@ -3098,11 +3105,15 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	s64 idx = -1;
 	const char *hwname = NULL;
 
-	if (info->attrs[HWSIM_ATTR_RADIO_ID])
+	if (info->attrs[HWSIM_ATTR_RADIO_ID]) {
 		idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
-	else if (info->attrs[HWSIM_ATTR_RADIO_NAME])
-		hwname = (void *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
-	else
+	} else if (info->attrs[HWSIM_ATTR_RADIO_NAME]) {
+		hwname = kasprintf(GFP_KERNEL, "%.*s",
+				   nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				   (char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]));
+		if (!hwname)
+			return -ENOMEM;
+	} else
 		return -EINVAL;
 
 	spin_lock_bh(&hwsim_radio_lock);
@@ -3111,7 +3122,8 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			if (data->idx != idx)
 				continue;
 		} else {
-			if (strcmp(hwname, wiphy_name(data->hw->wiphy)))
+			if (!hwname ||
+			    strcmp(hwname, wiphy_name(data->hw->wiphy)))
 				continue;
 		}
 
@@ -3122,10 +3134,12 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
 					 info);
+		kfree(hwname);
 		return 0;
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
 
+	kfree(hwname);
 	return -ENODEV;
 }
 
-- 
2.11.0
