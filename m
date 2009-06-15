Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:49419 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752126AbZFOTgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:36:01 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 02/11 v2][2.6.31 and w-t] iwmc3200wifi: add iwm_if_add and iwm_if_remove
Date: Mon, 15 Jun 2009 21:36:14 +0200
Message-Id: <35bf6c24e0fce00d5dd2df186d04753dc9df9a48.1245091931.git.samuel@sortiz.org>
In-Reply-To: <24c3a0b2dfd0fa45cca006d0ac8d80ccabd80646.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
 <24c3a0b2dfd0fa45cca006d0ac8d80ccabd80646.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

We used to do alloc_netdev and register_netdev at the same time in
iwm_if_alloc. But some bus related structures will only be initialized
after iwm_priv is allocated. This caused a race condition that the
netdev might be registered earlier. The patch adds iwm_if_add and
iwm_if_remove so that the bus layer could register the device after
all initialization is done.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/iwm.h    |    2 +
 drivers/net/wireless/iwmc3200wifi/netdev.c |   32 +++++++++++++++++----------
 drivers/net/wireless/iwmc3200wifi/sdio.c   |    9 +++++++
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 2237448..4aa0ad1 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -315,6 +315,8 @@ extern const struct iw_handler_def iwm_iw_handler_def;
 void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 		   struct iwm_if_ops *if_ops);
 void iwm_if_free(struct iwm_priv *iwm);
+int iwm_if_add(struct iwm_priv *iwm);
+void iwm_if_remove(struct iwm_priv *iwm);
 int iwm_mode_to_nl80211_iftype(int mode);
 int iwm_priv_init(struct iwm_priv *iwm);
 void iwm_priv_deinit(struct iwm_priv *iwm);
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index 88dd826..aaa20c6 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -123,8 +123,7 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 
 	wdev->iftype = iwm_mode_to_nl80211_iftype(iwm->conf.mode);
 
-	ndev = alloc_netdev_mq(0, "wlan%d", ether_setup,
-			       IWM_TX_QUEUES);
+	ndev = alloc_netdev_mq(0, "wlan%d", ether_setup, IWM_TX_QUEUES);
 	if (!ndev) {
 		dev_err(dev, "no memory for network device instance\n");
 		goto out_priv;
@@ -134,19 +133,10 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 	ndev->wireless_handlers = &iwm_iw_handler_def;
 	ndev->ieee80211_ptr = wdev;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
-	ret = register_netdev(ndev);
-	if (ret < 0) {
-		dev_err(dev, "Failed to register netdev: %d\n", ret);
-		goto out_ndev;
-	}
-
 	wdev->netdev = ndev;
 
 	return iwm;
 
- out_ndev:
-	free_netdev(ndev);
-
  out_priv:
 	iwm_priv_deinit(iwm);
 
@@ -160,8 +150,26 @@ void iwm_if_free(struct iwm_priv *iwm)
 	if (!iwm_to_ndev(iwm))
 		return;
 
-	unregister_netdev(iwm_to_ndev(iwm));
 	free_netdev(iwm_to_ndev(iwm));
 	iwm_wdev_free(iwm);
 	iwm_priv_deinit(iwm);
 }
+
+int iwm_if_add(struct iwm_priv *iwm)
+{
+	struct net_device *ndev = iwm_to_ndev(iwm);
+	int ret;
+
+	ret = register_netdev(ndev);
+	if (ret < 0) {
+		dev_err(&ndev->dev, "Failed to register netdev: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void iwm_if_remove(struct iwm_priv *iwm)
+{
+	unregister_netdev(iwm_to_ndev(iwm));
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index b54da67..c040571 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -454,10 +454,18 @@ static int iwm_sdio_probe(struct sdio_func *func,
 
 	INIT_WORK(&hw->isr_worker, iwm_sdio_isr_worker);
 
+	ret = iwm_if_add(iwm);
+	if (ret) {
+		dev_err(dev, "add SDIO interface failed\n");
+		goto destroy_wq;
+	}
+
 	dev_info(dev, "IWM SDIO probe\n");
 
 	return 0;
 
+ destroy_wq:
+	destroy_workqueue(hw->isr_wq);
  debugfs_exit:
 	iwm_debugfs_exit(iwm);
  if_free:
@@ -472,6 +480,7 @@ static void iwm_sdio_remove(struct sdio_func *func)
 	struct device *dev = &func->dev;
 
 	iwm_debugfs_exit(iwm);
+	iwm_if_remove(iwm);
 	iwm_if_free(iwm);
 	destroy_workqueue(hw->isr_wq);
 
-- 
1.6.3.1

