Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37968 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756105Ab3KODKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 22:10:54 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13 2/6] mwifiex: failure path handling in mwifiex_add_virtual_intf()
Date: Thu, 14 Nov 2013 19:10:38 -0800
Message-ID: <1384485042-7083-2-git-send-email-bzhao@marvell.com> (sfid-20131115_041057_650180_4D38A3EA)
In-Reply-To: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
References: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) If register_netdevice() is failed, we are freeing netdev
pointer, but priv->netdev is not cleared. This gives kernel
paging request error when driver is unloaded or interface is
deleted. Fix the problem by clearing the pointer.
2) Fix memory leak issue by freeing 'wdev' in failure paths.
Also, clear priv->wdev pointer.

As mwifiex_add_virtual_intf() successfully handles the
failure conditions, redundant code under err_add_intf label
is removed in this patch.

Reported-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 20 ++++++++++++++++----
 drivers/net/wireless/mwifiex/main.c     | 13 ++-----------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fbad00a..ccc9c08 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2210,8 +2210,10 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_started = 0;
 		priv->bss_num = 0;
 
-		if (mwifiex_cfg80211_init_p2p_client(priv))
-			return ERR_PTR(-EFAULT);
+		if (mwifiex_cfg80211_init_p2p_client(priv)) {
+			wdev = ERR_PTR(-EFAULT);
+			goto done;
+		}
 
 		break;
 	default:
@@ -2224,7 +2226,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	if (!dev) {
 		wiphy_err(wiphy, "no memory available for netdevice\n");
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
-		return ERR_PTR(-ENOMEM);
+		wdev = ERR_PTR(-ENOMEM);
+		goto done;
 	}
 
 	mwifiex_init_priv_params(priv, dev);
@@ -2264,7 +2267,9 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		wiphy_err(wiphy, "cannot register virtual network device\n");
 		free_netdev(dev);
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
-		return ERR_PTR(-EFAULT);
+		priv->netdev = NULL;
+		wdev = ERR_PTR(-EFAULT);
+		goto done;
 	}
 
 	sema_init(&priv->async_sem, 1);
@@ -2274,6 +2279,13 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_init(priv);
 #endif
+
+done:
+	if (IS_ERR(wdev)) {
+		kfree(priv->wdev);
+		priv->wdev = NULL;
+	}
+
 	return wdev;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 7c7da3e..9236b42 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -411,7 +411,7 @@ static void mwifiex_terminate_workqueue(struct mwifiex_adapter *adapter)
  */
 static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 {
-	int ret, i;
+	int ret;
 	char fmt[64];
 	struct mwifiex_private *priv;
 	struct mwifiex_adapter *adapter = context;
@@ -479,6 +479,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 					NL80211_IFTYPE_STATION, NULL, NULL);
 	if (IS_ERR(wdev)) {
 		dev_err(adapter->dev, "cannot create default STA interface\n");
+		rtnl_unlock();
 		goto err_add_intf;
 	}
 	rtnl_unlock();
@@ -488,16 +489,6 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	goto done;
 
 err_add_intf:
-	for (i = 0; i < adapter->priv_num; i++) {
-		priv = adapter->priv[i];
-
-		if (!priv)
-			continue;
-
-		if (priv->wdev && priv->netdev)
-			mwifiex_del_virtual_intf(adapter->wiphy, priv->wdev);
-	}
-	rtnl_unlock();
 err_register_cfg80211:
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
-- 
1.8.2.3

