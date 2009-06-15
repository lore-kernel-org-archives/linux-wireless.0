Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:54749 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762005AbZFOPiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:38:21 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 03/12][2.6.31 and w-t] iwmc3200wifi: add iwm_if_add and iwm_if_remove
Date: Mon, 15 Jun 2009 17:39:19 +0200
Message-Id: <9b2b9b463d1313b871f56ad77b48b4960653b766.1245076752.git.samuel@sortiz.org>
In-Reply-To: <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
 <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
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
index a0e7377..73c1011 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -316,6 +316,8 @@ extern const struct iw_handler_def iwm_iw_handler_def;
 void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 		   struct iwm_if_ops *if_ops);
 void iwm_if_free(struct iwm_priv *iwm);
+int iwm_if_add(struct iwm_priv *iwm);
+void iwm_if_remove(struct iwm_priv *iwm);
 int iwm_mode_to_nl80211_iftype(int mode);
 int iwm_priv_init(struct iwm_priv *iwm);
 void iwm_priv_deinit(struct iwm_priv *iwm);
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index de16b2b..d1797b9 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -125,8 +125,7 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 
 	wdev->iftype = iwm_mode_to_nl80211_iftype(iwm->conf.mode);
 
-	ndev = alloc_netdev_mq(0, "wlan%d", ether_setup,
-			       IWM_TX_QUEUES);
+	ndev = alloc_netdev_mq(0, "wlan%d", ether_setup, IWM_TX_QUEUES);
 	if (!ndev) {
 		dev_err(dev, "no memory for network device instance\n");
 		goto out_priv;
@@ -136,19 +135,10 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
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
 
@@ -162,8 +152,26 @@ void iwm_if_free(struct iwm_priv *iwm)
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
index 97e7da3..057a588 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -454,6 +454,12 @@ static int iwm_sdio_probe(struct sdio_func *func,
 
 	INIT_WORK(&hw->isr_worker, iwm_sdio_isr_worker);
 
+	ret = iwm_if_add(iwm);
+	if (ret) {
+		dev_err(dev, "add SDIO interface failed\n");
+		goto destroy_wq;
+	}
+
 	/* The SDIO bus is set and ready to be enabled */
 	set_bit(IWM_STATUS_BUS_READY, &iwm->status);
 
@@ -461,6 +467,8 @@ static int iwm_sdio_probe(struct sdio_func *func,
 
 	return 0;
 
+ destroy_wq:
+	destroy_workqueue(hw->isr_wq);
  debugfs_exit:
 	iwm_debugfs_exit(iwm);
  if_free:
@@ -475,6 +483,7 @@ static void iwm_sdio_remove(struct sdio_func *func)
 	struct device *dev = &func->dev;
 
 	iwm_debugfs_exit(iwm);
+	iwm_if_remove(iwm);
 	iwm_if_free(iwm);
 	destroy_workqueue(hw->isr_wq);
 
-- 
1.6.3.1

