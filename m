Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35965 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932280AbdJYJVN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 05:21:13 -0400
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        vkanchan@qti.qualcomm.com, amarnath@qti.qualcomm.com,
        usdutt@qti.qualcomm.com, vamsin@qti.qualcomm.com,
        Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
From: Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
To: johannes@sipsolutions.net
Subject: [PATCH] nl80211: Update ERP info using NL80211_CMD_UPDATE_CONNECT_PARAMS
Date: Wed, 25 Oct 2017 14:50:48 +0530
Message-Id: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org> (sfid-20171025_112153_034094_786FC168)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use NL80211_CMD_UPDATE_CONNECT_PARAMS to update new ERP information,
Association IEs and the Authentication type to driver / firmware which
will be used in subsequent roamings.

Signed-off-by: Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
---
 include/net/cfg80211.h |  5 +++++
 net/wireless/nl80211.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b903ef7..e34faa5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2156,9 +2156,14 @@ struct cfg80211_connect_params {
  * have to be updated as part of update_connect_params() call.
  *
  * @UPDATE_ASSOC_IES: Indicates whether association request IEs are updated
+ * @UPDATE_FILS_ERP_INFO: Indicates that FILS connection parameters (realm,
+ *	username, erp sequence number and rrk) are updated
+ * @UPDATE_AUTH_TYPE: Indicates that Authentication type is updated
  */
 enum cfg80211_connect_params_changed {
 	UPDATE_ASSOC_IES		= BIT(0),
+	UPDATE_FILS_ERP_INFO		= BIT(1),
+	UPDATE_AUTH_TYPE		= BIT(2),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c5d95c3..c5e11d6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9165,6 +9165,45 @@ static int nl80211_update_connect_params(struct sk_buff *skb,
 		changed |= UPDATE_ASSOC_IES;
 	}
 
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_FILS_SK_OFFLOAD) &&
+	    info->attrs[NL80211_ATTR_FILS_ERP_USERNAME] &&
+	    info->attrs[NL80211_ATTR_FILS_ERP_REALM] &&
+	    info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] &&
+	    info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
+		connect.fils_erp_username =
+			nla_data(info->attrs[NL80211_ATTR_FILS_ERP_USERNAME]);
+		connect.fils_erp_username_len =
+			nla_len(info->attrs[NL80211_ATTR_FILS_ERP_USERNAME]);
+		connect.fils_erp_realm =
+			nla_data(info->attrs[NL80211_ATTR_FILS_ERP_REALM]);
+		connect.fils_erp_realm_len =
+			nla_len(info->attrs[NL80211_ATTR_FILS_ERP_REALM]);
+		connect.fils_erp_next_seq_num =
+			nla_get_u16(
+			   info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM]);
+		connect.fils_erp_rrk =
+			nla_data(info->attrs[NL80211_ATTR_FILS_ERP_RRK]);
+		connect.fils_erp_rrk_len =
+			nla_len(info->attrs[NL80211_ATTR_FILS_ERP_RRK]);
+		changed |= UPDATE_FILS_ERP_INFO;
+	} else if (info->attrs[NL80211_ATTR_FILS_ERP_USERNAME] ||
+		   info->attrs[NL80211_ATTR_FILS_ERP_REALM] ||
+		   info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] ||
+		   info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
+		return -EINVAL;
+	}
+
+	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
+		u32 auth_type =
+			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
+		if (!nl80211_valid_auth_type(rdev, auth_type,
+					     NL80211_CMD_CONNECT))
+			return -EINVAL;
+		connect.auth_type = auth_type;
+		changed |= UPDATE_AUTH_TYPE;
+	}
+
 	wdev_lock(dev->ieee80211_ptr);
 	if (!wdev->current_bss)
 		ret = -ENOLINK;
-- 
1.9.1
