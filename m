Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53641 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbZC0SxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 14:53:06 -0400
Date: Fri, 27 Mar 2009 20:52:47 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Require auth type for NL80211_CMD_AUTHENTICATE
Message-ID: <20090327185247.GA11871@jm.kir.nu> (sfid-20090327_195310_291353_53506DEA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_ATTR_AUTH_TYPE is a required parameter for
NL80211_CMD_AUTHENTICATE. We are currently (by chance) defaulting to
open system authentication if the attribute is not specified. It is
better to just reject the invalid command.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/wireless/nl80211.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- uml.orig/net/wireless/nl80211.c	2009-03-27 20:33:21.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-27 20:34:36.000000000 +0200
@@ -2760,6 +2760,9 @@ static int nl80211_authenticate(struct s
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
+	if (!info->attrs[NL80211_ATTR_AUTH_TYPE])
+		return -EINVAL;
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -2806,13 +2809,10 @@ static int nl80211_authenticate(struct s
 		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
-		req.auth_type =
-			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
-		if (!nl80211_valid_auth_type(req.auth_type)) {
-			err = -EINVAL;
-			goto out;
-		}
+	req.auth_type = nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
+	if (!nl80211_valid_auth_type(req.auth_type)) {
+		err = -EINVAL;
+		goto out;
 	}
 
 	err = drv->ops->auth(&drv->wiphy, dev, &req);

-- 
Jouni Malinen                                            PGP id EFC895FA
