Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5611 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753657AbcJYWpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 18:45:23 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 4/8] cfg80211: Add Fast Initial Link Setup (FILS) auth algs
Date: Wed, 26 Oct 2016 01:42:33 +0300
Message-ID: <1477435357-8495-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_004530_713662_473E2E22)
In-Reply-To: <1477435357-8495-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477435357-8495-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This defines authentication algorithms for FILS (IEEE 802.11ai).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/ieee80211.h    |  3 +++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/nl80211.c       | 21 +++++++++++++++++++--
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a80516f..9a523d9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1576,6 +1576,9 @@ struct ieee80211_vht_operation {
 #define WLAN_AUTH_SHARED_KEY 1
 #define WLAN_AUTH_FT 2
 #define WLAN_AUTH_SAE 3
+#define WLAN_AUTH_FILS_SK 4
+#define WLAN_AUTH_FILS_SK_PFS 5
+#define WLAN_AUTH_FILS_PK 6
 #define WLAN_AUTH_LEAP 128
 
 #define WLAN_AUTH_CHALLENGE_LEN 128
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 39e1647..5d36e83 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3663,6 +3663,9 @@ enum nl80211_bss_status {
  * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
  * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
  * @NL80211_AUTHTYPE_SAE: Simultaneous authentication of equals
+ * @NL80211_AUTHTYPE_FILS_SK: Fast Initial Link Setup shared key
+ * @NL80211_AUTHTYPE_FILS_SK_PFS: Fast Initial Link Setup shared key with PFS
+ * @NL80211_AUTHTYPE_FILS_PK: Fast Initial Link Setup public key
  * @__NL80211_AUTHTYPE_NUM: internal
  * @NL80211_AUTHTYPE_MAX: maximum valid auth algorithm
  * @NL80211_AUTHTYPE_AUTOMATIC: determine automatically (if necessary by
@@ -3675,6 +3678,9 @@ enum nl80211_auth_type {
 	NL80211_AUTHTYPE_FT,
 	NL80211_AUTHTYPE_NETWORK_EAP,
 	NL80211_AUTHTYPE_SAE,
+	NL80211_AUTHTYPE_FILS_SK,
+	NL80211_AUTHTYPE_FILS_SK_PFS,
+	NL80211_AUTHTYPE_FILS_PK,
 
 	/* keep last */
 	__NL80211_AUTHTYPE_NUM,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 36dd300..ebd7eaf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3762,12 +3762,23 @@ static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
 		if (!(rdev->wiphy.features & NL80211_FEATURE_SAE) &&
 		    auth_type == NL80211_AUTHTYPE_SAE)
 			return false;
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_FILS) &&
+		    (auth_type == NL80211_AUTHTYPE_FILS_SK ||
+		     auth_type == NL80211_AUTHTYPE_FILS_SK_PFS ||
+		     auth_type == NL80211_AUTHTYPE_FILS_PK))
+			return false;
 		return true;
 	case NL80211_CMD_CONNECT:
 	case NL80211_CMD_START_AP:
 		/* SAE not supported yet */
 		if (auth_type == NL80211_AUTHTYPE_SAE)
 			return false;
+		/* FILS not supported yet */
+		if (auth_type == NL80211_AUTHTYPE_FILS_SK ||
+		    auth_type == NL80211_AUTHTYPE_FILS_SK_PFS ||
+		    auth_type == NL80211_AUTHTYPE_FILS_PK)
+			return false;
 		return true;
 	default:
 		return false;
@@ -7796,12 +7807,18 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 	if (!nl80211_valid_auth_type(rdev, auth_type, NL80211_CMD_AUTHENTICATE))
 		return -EINVAL;
 
-	if (auth_type == NL80211_AUTHTYPE_SAE &&
+	if ((auth_type == NL80211_AUTHTYPE_SAE ||
+	     auth_type == NL80211_AUTHTYPE_FILS_SK ||
+	     auth_type == NL80211_AUTHTYPE_FILS_SK_PFS ||
+	     auth_type == NL80211_AUTHTYPE_FILS_PK) &&
 	    !info->attrs[NL80211_ATTR_AUTH_DATA])
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_AUTH_DATA]) {
-		if (auth_type != NL80211_AUTHTYPE_SAE)
+		if (auth_type != NL80211_AUTHTYPE_SAE &&
+		    auth_type != NL80211_AUTHTYPE_FILS_SK &&
+		    auth_type != NL80211_AUTHTYPE_FILS_SK_PFS &&
+		    auth_type != NL80211_AUTHTYPE_FILS_PK)
 			return -EINVAL;
 		auth_data = nla_data(info->attrs[NL80211_ATTR_AUTH_DATA]);
 		auth_data_len = nla_len(info->attrs[NL80211_ATTR_AUTH_DATA]);
-- 
1.9.1
