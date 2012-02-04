Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:50685 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754390Ab2BDEgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 23:36:19 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.3] mwifiex: add NULL checks in driver unload path
Date: Fri,  3 Feb 2012 20:34:02 -0800
Message-Id: <1328330042-26523-1-git-send-email-bzhao@marvell.com> (sfid-20120204_053623_775612_EEEFAE4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

If driver load is failed, sometimes few pointers may remain
uninitialized ex. priv->wdev, priv->netdev, adapter->sleep_cfm
This will cause NULL pointer dereferance while unloading the
driver.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    3 ++-
 drivers/net/wireless/mwifiex/main.c |   12 ++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 83cc10f..ca59cc0 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -383,7 +383,8 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 
 	adapter->if_ops.cleanup_if(adapter);
 
-	dev_kfree_skb_any(adapter->sleep_cfm);
+	if (adapter->sleep_cfm)
+		dev_kfree_skb_any(adapter->sleep_cfm);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 80e4456..790a379 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -811,7 +811,9 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 			continue;
 
 		rtnl_lock();
-		mwifiex_del_virtual_intf(priv->wdev->wiphy, priv->netdev);
+		if (priv->wdev && priv->netdev)
+			mwifiex_del_virtual_intf(priv->wdev->wiphy,
+						 priv->netdev);
 		rtnl_unlock();
 	}
 
@@ -819,9 +821,11 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	if (!priv)
 		goto exit_remove;
 
-	wiphy_unregister(priv->wdev->wiphy);
-	wiphy_free(priv->wdev->wiphy);
-	kfree(priv->wdev);
+	if (priv->wdev) {
+		wiphy_unregister(priv->wdev->wiphy);
+		wiphy_free(priv->wdev->wiphy);
+		kfree(priv->wdev);
+	}
 
 	mwifiex_terminate_workqueue(adapter);
 
-- 
1.7.0.2

