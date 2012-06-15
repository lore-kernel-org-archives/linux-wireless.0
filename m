Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:46146 "HELO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758171Ab2FOW4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 18:56:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.5] mwifiex: fix wrong return values in add_virtual_intf() error cases
Date: Fri, 15 Jun 2012 15:49:54 -0700
Message-Id: <1339800594-21720-1-git-send-email-bzhao@marvell.com> (sfid-20120616_005638_668110_4C9A9C9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add_virtual_intf() needs to return an ERR_PTR(), instead of NULL,
on errors, otherwise cfg80211 will crash.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
This patch should go to linux-stable too. But it has merge conflict.
I'll resend a backport patch to linux-stable as soon as this patch reaches
upstream mainline.

 drivers/net/wireless/mwifiex/cfg80211.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9c2e08e..ef5a88b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1525,7 +1525,7 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	struct wireless_dev *wdev;
 
 	if (!adapter)
-		return NULL;
+		return ERR_PTR(-EFAULT);
 
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -1535,12 +1535,12 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		if (priv->bss_mode) {
 			wiphy_err(wiphy,
 				  "cannot create multiple sta/adhoc ifaces\n");
-			return NULL;
+			return ERR_PTR(-EINVAL);
 		}
 
 		wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 		if (!wdev)
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 
 		wdev->wiphy = wiphy;
 		priv->wdev = wdev;
@@ -1563,12 +1563,12 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 		if (priv->bss_mode) {
 			wiphy_err(wiphy, "Can't create multiple AP interfaces");
-			return NULL;
+			return ERR_PTR(-EINVAL);
 		}
 
 		wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 		if (!wdev)
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 
 		priv->wdev = wdev;
 		wdev->wiphy = wiphy;
@@ -1585,14 +1585,15 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		break;
 	default:
 		wiphy_err(wiphy, "type not supported\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), name,
 			      ether_setup, 1);
 	if (!dev) {
 		wiphy_err(wiphy, "no memory available for netdevice\n");
-		goto error;
+		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	mwifiex_init_priv_params(priv, dev);
@@ -1623,7 +1624,9 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	/* Register network device */
 	if (register_netdevice(dev)) {
 		wiphy_err(wiphy, "cannot register virtual network device\n");
-		goto error;
+		free_netdev(dev);
+		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-EFAULT);
 	}
 
 	sema_init(&priv->async_sem, 1);
@@ -1635,12 +1638,6 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	mwifiex_dev_debugfs_init(priv);
 #endif
 	return dev;
-error:
-	if (dev && (dev->reg_state == NETREG_UNREGISTERED))
-		free_netdev(dev);
-	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
-
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
 
-- 
1.7.0.2

