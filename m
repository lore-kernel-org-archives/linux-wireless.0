Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:14401 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761857AbZFOPiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:38:16 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 02/12][2.6.31 and w-t] iwmc3200wifi: check for iwm_priv_init error
Date: Mon, 15 Jun 2009 17:39:18 +0200
Message-Id: <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
In-Reply-To: <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

We need to check for iwm_priv_init() errors and do proper cleanups.
Otherwise we may fail to catch the create_singlethread_workqueue()
error which will cause a kernel oops when destroy_workqueue() later.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/iwm.h    |    1 +
 drivers/net/wireless/iwmc3200wifi/main.c   |   10 ++++++++++
 drivers/net/wireless/iwmc3200wifi/netdev.c |   19 ++++++++++++-------
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 3cc4e91..a0e7377 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -318,6 +318,7 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 void iwm_if_free(struct iwm_priv *iwm);
 int iwm_mode_to_nl80211_iftype(int mode);
 int iwm_priv_init(struct iwm_priv *iwm);
+void iwm_priv_deinit(struct iwm_priv *iwm);
 void iwm_reset(struct iwm_priv *iwm);
 void iwm_tx_credit_init_pools(struct iwm_priv *iwm,
 			      struct iwm_umac_notif_alive *alive);
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 09ed247..cfe1890 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -219,6 +219,16 @@ int iwm_priv_init(struct iwm_priv *iwm)
 	return 0;
 }
 
+void iwm_priv_deinit(struct iwm_priv *iwm)
+{
+	int i;
+
+	for (i = 0; i < IWM_TX_QUEUES; i++)
+		destroy_workqueue(iwm->txq[i].wq);
+
+	destroy_workqueue(iwm->rx_wq);
+}
+
 /*
  * We reset all the structures, and we reset the UMAC.
  * After calling this routine, you're expected to reload
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index 5b7aa34..de16b2b 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -116,14 +116,20 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 	iwm = wdev_to_iwm(wdev);
 	iwm->bus_ops = if_ops;
 	iwm->wdev = wdev;
-	iwm_priv_init(iwm);
+
+	ret = iwm_priv_init(iwm);
+	if (ret) {
+		dev_err(dev, "failed to init iwm_priv\n");
+		goto out_wdev;
+	}
+
 	wdev->iftype = iwm_mode_to_nl80211_iftype(iwm->conf.mode);
 
 	ndev = alloc_netdev_mq(0, "wlan%d", ether_setup,
 			       IWM_TX_QUEUES);
 	if (!ndev) {
 		dev_err(dev, "no memory for network device instance\n");
-		goto out_wdev;
+		goto out_priv;
 	}
 
 	ndev->netdev_ops = &iwm_netdev_ops;
@@ -143,6 +149,9 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
  out_ndev:
 	free_netdev(ndev);
 
+ out_priv:
+	iwm_priv_deinit(iwm);
+
  out_wdev:
 	iwm_wdev_free(iwm);
 	return ERR_PTR(ret);
@@ -150,15 +159,11 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 
 void iwm_if_free(struct iwm_priv *iwm)
 {
-	int i;
-
 	if (!iwm_to_ndev(iwm))
 		return;
 
 	unregister_netdev(iwm_to_ndev(iwm));
 	free_netdev(iwm_to_ndev(iwm));
 	iwm_wdev_free(iwm);
-	destroy_workqueue(iwm->rx_wq);
-	for (i = 0; i < IWM_TX_QUEUES; i++)
-		destroy_workqueue(iwm->txq[i].wq);
+	iwm_priv_deinit(iwm);
 }
-- 
1.6.3.1

