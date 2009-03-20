Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50685 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659AbZCTTYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 15:24:03 -0400
Message-Id: <20090320192353.233644676@atheros.com> (sfid-20090320_202413_971511_1D3CD9E8)
References: <20090320192115.448175935@atheros.com>
Date: Fri, 20 Mar 2009 21:21:17 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 2/4] nl80211: Add more through validation of MLME command parameters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check that the used authentication type and reason code are valid here
so that drivers/mac80211 do not need to care about this. In addition,
remove the unnecessary validation of SSID attribute length which is
taken care of by netlink policy.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/wireless/nl80211.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- uml.orig/net/wireless/nl80211.c	2009-03-20 18:03:53.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-20 18:03:57.000000000 +0200
@@ -2614,6 +2614,14 @@ static int nl80211_dump_scan(struct sk_b
 	return err;
 }
 
+static bool nl80211_valid_auth_type(enum nl80211_auth_type auth_type)
+{
+	return auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM ||
+		auth_type == NL80211_AUTHTYPE_SHARED_KEY ||
+		auth_type == NL80211_AUTHTYPE_FT ||
+		auth_type == NL80211_AUTHTYPE_NETWORK_EAP;
+}
+
 static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
@@ -2666,6 +2674,10 @@ static int nl80211_authenticate(struct s
 	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
 		req.auth_type =
 			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
+		if (!nl80211_valid_auth_type(req.auth_type)) {
+			err = -EINVAL;
+			goto out;
+		}
 	}
 
 	err = drv->ops->auth(&drv->wiphy, dev, &req);
@@ -2718,10 +2730,6 @@ static int nl80211_associate(struct sk_b
 		}
 	}
 
-	if (nla_len(info->attrs[NL80211_ATTR_SSID]) > IEEE80211_MAX_SSID_LEN) {
-		err = -EINVAL;
-		goto out;
-	}
 	req.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
 	req.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 
@@ -2769,9 +2777,15 @@ static int nl80211_deauthenticate(struct
 
 	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (info->attrs[NL80211_ATTR_REASON_CODE])
+	if (info->attrs[NL80211_ATTR_REASON_CODE]) {
 		req.reason_code =
 			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+		if (req.reason_code == 0) {
+			/* Reason Code 0 is reserved */
+			err = -EINVAL;
+			goto out;
+		}
+	}
 
 	if (info->attrs[NL80211_ATTR_IE]) {
 		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
@@ -2817,9 +2831,15 @@ static int nl80211_disassociate(struct s
 
 	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (info->attrs[NL80211_ATTR_REASON_CODE])
+	if (info->attrs[NL80211_ATTR_REASON_CODE]) {
 		req.reason_code =
 			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+		if (req.reason_code == 0) {
+			/* Reason Code 0 is reserved */
+			err = -EINVAL;
+			goto out;
+		}
+	}
 
 	if (info->attrs[NL80211_ATTR_IE]) {
 		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
