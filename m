Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZC0LlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 07:41:06 -0400
Subject: [PATCH] nl80211: validate some input better
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 12:40:28 +0100
Message-Id: <1238154028.4331.115.camel@johannes.local> (sfid-20090327_124112_873764_BFEBC6CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes nl80211 to:
 * validate that any IE input is a valid IE (stream)
 * move some validation code before locking
 * require that a reason code is given for both deauth/disassoc

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |  114 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 37 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-03-27 12:14:56.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-03-27 12:39:52.000000000 +0100
@@ -118,6 +118,36 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_REASON_CODE] = { .type = NLA_U16 },
 };
 
+/* IE validation */
+static bool is_valid_ie_attr(const struct nlattr *attr)
+{
+	const u8 *pos;
+	int len;
+
+	if (!attr)
+		return true;
+
+	pos = nla_data(attr);
+	len = nla_len(attr);
+
+	while (len) {
+		u8 elemlen;
+
+		if (len < 2)
+			return false;
+		len -= 2;
+
+		elemlen = pos[1];
+		if (elemlen > len)
+			return false;
+
+		len -= elemlen;
+		pos += 2 + elemlen;
+	}
+
+	return true;
+}
+
 /* message building helper */
 static inline void *nl80211hdr_put(struct sk_buff *skb, u32 pid, u32 seq,
 				   int flags, u8 cmd)
@@ -1071,6 +1101,9 @@ static int nl80211_addset_beacon(struct 
 	struct beacon_parameters params;
 	int haveinfo = 0;
 
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_BEACON_TAIL]))
+		return -EINVAL;
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -2444,6 +2477,9 @@ static int nl80211_trigger_scan(struct s
 	enum ieee80211_band band;
 	size_t ie_len;
 
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -2718,6 +2754,12 @@ static int nl80211_authenticate(struct s
 	struct wiphy *wiphy;
 	int err;
 
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -2739,11 +2781,6 @@ static int nl80211_authenticate(struct s
 		goto out;
 	}
 
-	if (!info->attrs[NL80211_ATTR_MAC]) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	wiphy = &drv->wiphy;
 	memset(&req, 0, sizeof(req));
 
@@ -2796,6 +2833,13 @@ static int nl80211_associate(struct sk_b
 	struct wiphy *wiphy;
 	int err;
 
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_SSID])
+		return -EINVAL;
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -2817,12 +2861,6 @@ static int nl80211_associate(struct sk_b
 		goto out;
 	}
 
-	if (!info->attrs[NL80211_ATTR_MAC] ||
-	    !info->attrs[NL80211_ATTR_SSID]) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	wiphy = &drv->wiphy;
 	memset(&req, 0, sizeof(req));
 
@@ -2864,6 +2902,15 @@ static int nl80211_deauthenticate(struct
 	struct wiphy *wiphy;
 	int err;
 
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_REASON_CODE])
+		return -EINVAL;
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -2885,24 +2932,16 @@ static int nl80211_deauthenticate(struct
 		goto out;
 	}
 
-	if (!info->attrs[NL80211_ATTR_MAC]) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	wiphy = &drv->wiphy;
 	memset(&req, 0, sizeof(req));
 
 	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (info->attrs[NL80211_ATTR_REASON_CODE]) {
-		req.reason_code =
-			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
-		if (req.reason_code == 0) {
-			/* Reason Code 0 is reserved */
-			err = -EINVAL;
-			goto out;
-		}
+	req.reason_code = nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+	if (req.reason_code == 0) {
+		/* Reason Code 0 is reserved */
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (info->attrs[NL80211_ATTR_IE]) {
@@ -2928,6 +2967,15 @@ static int nl80211_disassociate(struct s
 	struct wiphy *wiphy;
 	int err;
 
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_REASON_CODE])
+		return -EINVAL;
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -2949,24 +2997,16 @@ static int nl80211_disassociate(struct s
 		goto out;
 	}
 
-	if (!info->attrs[NL80211_ATTR_MAC]) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	wiphy = &drv->wiphy;
 	memset(&req, 0, sizeof(req));
 
 	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (info->attrs[NL80211_ATTR_REASON_CODE]) {
-		req.reason_code =
-			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
-		if (req.reason_code == 0) {
-			/* Reason Code 0 is reserved */
-			err = -EINVAL;
-			goto out;
-		}
+	req.reason_code = nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+	if (req.reason_code == 0) {
+		/* Reason Code 0 is reserved */
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (info->attrs[NL80211_ATTR_IE]) {


