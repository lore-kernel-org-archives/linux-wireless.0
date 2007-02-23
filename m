Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55175 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXBWGjt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 01:39:49 -0500
Received: from localhost (069-064-229-129.pdx.net [69.64.229.129])
	(authenticated bits=0)
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1N6dlhB000806
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2007 22:39:48 -0800
Date: Thu, 22 Feb 2007 22:39:41 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] d80211: optimise if_alloc() name creation.
Message-ID: <20070222223941.7f637c2c@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code to do guess and check for creating a sub-device name is unnecessary.
dev_alloc_name() is optimized to do this already.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

---
 net/d80211/ieee80211_iface.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/net/d80211/ieee80211_iface.c b/net/d80211/ieee80211_iface.c
index 618d29b..de8358c 100644
--- a/net/d80211/ieee80211_iface.c
+++ b/net/d80211/ieee80211_iface.c
@@ -40,11 +40,10 @@ static void ieee80211_if_sdata_deinit(st
 int ieee80211_if_add(struct net_device *dev, const char *name,
 		     int format, struct net_device **new_dev)
 {
-	struct net_device *ndev, *tmp_dev;
+	struct net_device *ndev;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = NULL;
 	int ret;
-	int i;
 
 	ASSERT_RTNL();
 	ndev = *new_dev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
@@ -52,23 +51,17 @@ int ieee80211_if_add(struct net_device *
 	if (!ndev)
 		return -ENOMEM;
 
-	if (strlen(name) == 0) {
-		i = 0;
-		do {
-			snprintf(ndev->name, sizeof(ndev->name), "%s.%d",
-				 dev->name, i++);
-			tmp_dev = dev_get_by_name(ndev->name);
-			if (!tmp_dev)
-				break;
-			dev_put(tmp_dev);
-		} while (i < 10000);
-	} else if (format) {
+	if (*name == '\0') {
+		snprintf(ndev->name, IFNAMSIZ, "%s.%%d", dev->name);
+		format = 1;
+	}
+
+	if (format) {
 		ret = dev_alloc_name(ndev, name);
 		if (ret < 0)
 			goto fail;
-	} else {
+	} else
 		snprintf(ndev->name, IFNAMSIZ, "%s", name);
-	}
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	ndev->base_addr = dev->base_addr;
-- 
1.4.1

