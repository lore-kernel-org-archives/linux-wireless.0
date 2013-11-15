Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49130 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560Ab3KODLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 22:11:08 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13 4/6] mwifiex: fix potential mem leak in .del_virtual_intf
Date: Thu, 14 Nov 2013 19:10:40 -0800
Message-ID: <1384485042-7083-4-git-send-email-bzhao@marvell.com> (sfid-20131115_041113_475817_EF08F378)
In-Reply-To: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
References: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) Currently we freeing wdev for each interface in driver unload
path. We may leak memory if user have already deleted an interface.
mwifiex_add_virtual_intf() allocates wdev structure. So it should
be freed in mwifiex_del_virtual_intf().
This will make sure that wdev will be freed when user deletes an
interface and also in unload path.
2) "priv->netdev->ieee80211_ptr" should also be cleared in
mwifiex_del_virtual_intf.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 3 +++
 drivers/net/wireless/mwifiex/main.c     | 6 ------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ccc9c08..aeaea0e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2310,7 +2310,10 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 		unregister_netdevice(wdev->netdev);
 
 	/* Clear the priv in adapter */
+	priv->netdev->ieee80211_ptr = NULL;
 	priv->netdev = NULL;
+	kfree(wdev);
+	priv->wdev = NULL;
 
 	priv->media_connected = false;
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 42d9a68..78e8a66 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -998,12 +998,6 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	wiphy_unregister(priv->wdev->wiphy);
 	wiphy_free(priv->wdev->wiphy);
 
-	for (i = 0; i < adapter->priv_num; i++) {
-		priv = adapter->priv[i];
-		if (priv)
-			kfree(priv->wdev);
-	}
-
 	mwifiex_terminate_workqueue(adapter);
 
 	/* Unregister device */
-- 
1.8.2.3

