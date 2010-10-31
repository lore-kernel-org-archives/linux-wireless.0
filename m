Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53519 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab0JaOb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 10:31:59 -0400
Message-ID: <4CCD7DDA.3050806@openwrt.org>
Date: Sun, 31 Oct 2010 15:31:54 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: fix a crash in dev lookup on dump commands
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IS_ERR and PTR_ERR were called with the wrong pointer, leading to a
crash when cfg80211_get_dev_from_ifindex fails.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -224,8 +224,8 @@ static int nl80211_prepare_netdev_dump(s
 	}
 
 	*rdev = cfg80211_get_dev_from_ifindex(sock_net(skb->sk), ifidx);
-	if (IS_ERR(dev)) {
-		err = PTR_ERR(dev);
+	if (IS_ERR(*rdev)) {
+		err = PTR_ERR(*rdev);
 		goto out_rtnl;
 	}
 

