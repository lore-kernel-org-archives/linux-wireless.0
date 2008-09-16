Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYIPSWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:22:53 -0400
Subject: cfg80211: allow set_interface without type
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 20:22:09 +0200
Message-Id: <1221589329.8916.47.camel@johannes.berg> (sfid-20080916_202256_196441_97193038)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Which then causes no type change.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- everything.orig/net/wireless/nl80211.c	2008-09-16 20:15:08.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-09-16 20:16:01.000000000 +0200
@@ -422,19 +422,20 @@ static int nl80211_set_interface(struct 
 
 	memset(&params, 0, sizeof(params));
 
-	if (info->attrs[NL80211_ATTR_IFTYPE]) {
-		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
-		if (type > NL80211_IFTYPE_MAX)
-			return -EINVAL;
-	} else
-		return -EINVAL;
-
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
 		return err;
 	ifindex = dev->ifindex;
+	type = dev->ieee80211_ptr->iftype;
 	dev_put(dev);
 
+	err = -EINVAL;
+	if (info->attrs[NL80211_ATTR_IFTYPE]) {
+		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
+		if (type > NL80211_IFTYPE_MAX)
+			goto unlock;
+	}
+
 	if (!drv->ops->change_virtual_intf ||
 	    !(drv->wiphy.interface_modes & (1 << type))) {
 		err = -EOPNOTSUPP;


