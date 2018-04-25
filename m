Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:22336 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755805AbeDYRUS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:20:18 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 21/21] staging: wilc1000: reorder functions to avoid forward declaration in linux_wlan
Date: Wed, 25 Apr 2018 22:48:26 +0530
Message-ID: <1524676706-13179-22-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_192021_777541_968841AF)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder the functions in linux_wlan.c file to avoid having explicit
declaration of static functions. Forward declaration is avoided
with the help of reordering the function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 106 +++++++++++++++-------------------
 1 file changed, 46 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1643166..35e30c5 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -24,35 +24,8 @@
 #include <linux/mutex.h>
 #include <linux/completion.h>
 
-static int dev_state_ev_handler(struct notifier_block *this,
-				unsigned long event, void *ptr);
-
-static struct notifier_block g_dev_notifier = {
-	.notifier_call = dev_state_ev_handler
-};
-
-static int wlan_deinit_locks(struct net_device *dev);
-static void wlan_deinitialize_threads(struct net_device *dev);
-
-static void linux_wlan_tx_complete(void *priv, int status);
-static int  mac_init_fn(struct net_device *ndev);
-static struct net_device_stats *mac_stats(struct net_device *dev);
-static int wilc_mac_open(struct net_device *ndev);
-static int wilc_mac_close(struct net_device *ndev);
-static void wilc_set_multicast_list(struct net_device *dev);
-
 bool wilc_enable_ps = true;
 
-static const struct net_device_ops wilc_netdev_ops = {
-	.ndo_init = mac_init_fn,
-	.ndo_open = wilc_mac_open,
-	.ndo_stop = wilc_mac_close,
-	.ndo_start_xmit = wilc_mac_xmit,
-	.ndo_get_stats = mac_stats,
-	.ndo_set_rx_mode  = wilc_set_multicast_list,
-
-};
-
 static int dev_state_ev_handler(struct notifier_block *this,
 				unsigned long event, void *ptr)
 {
@@ -604,6 +577,39 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	return -1;
 }
 
+static int wlan_deinit_locks(struct net_device *dev)
+{
+	struct wilc_vif *vif;
+	struct wilc *wilc;
+
+	vif = netdev_priv(dev);
+	wilc = vif->wilc;
+
+	mutex_destroy(&wilc->hif_cs);
+	mutex_destroy(&wilc->rxq_cs);
+	mutex_destroy(&wilc->txq_add_to_head_cs);
+
+	return 0;
+}
+
+static void wlan_deinitialize_threads(struct net_device *dev)
+{
+	struct wilc_vif *vif;
+	struct wilc *wl;
+
+	vif = netdev_priv(dev);
+	wl = vif->wilc;
+
+	wl->close = 1;
+
+	complete(&wl->txq_event);
+
+	if (wl->txq_thread) {
+		kthread_stop(wl->txq_thread);
+		wl->txq_thread = NULL;
+	}
+}
+
 static void wilc_wlan_deinitialize(struct net_device *dev)
 {
 	struct wilc_vif *vif;
@@ -666,21 +672,6 @@ static int wlan_init_locks(struct net_device *dev)
 	return 0;
 }
 
-static int wlan_deinit_locks(struct net_device *dev)
-{
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
-
-	mutex_destroy(&wilc->hif_cs);
-	mutex_destroy(&wilc->rxq_cs);
-	mutex_destroy(&wilc->txq_add_to_head_cs);
-
-	return 0;
-}
-
 static int wlan_initialize_threads(struct net_device *dev)
 {
 	struct wilc_vif *vif;
@@ -701,24 +692,6 @@ static int wlan_initialize_threads(struct net_device *dev)
 	return 0;
 }
 
-static void wlan_deinitialize_threads(struct net_device *dev)
-{
-	struct wilc_vif *vif;
-	struct wilc *wl;
-
-	vif = netdev_priv(dev);
-	wl = vif->wilc;
-
-	wl->close = 1;
-
-	complete(&wl->txq_event);
-
-	if (wl->txq_thread) {
-		kthread_stop(wl->txq_thread);
-		wl->txq_thread = NULL;
-	}
-}
-
 static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 {
 	int ret = 0;
@@ -1106,6 +1079,10 @@ void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 		wilc_wfi_p2p_rx(wilc->vif[1]->ndev, buff, size);
 }
 
+static struct notifier_block g_dev_notifier = {
+	.notifier_call = dev_state_ev_handler
+};
+
 void wilc_netdev_cleanup(struct wilc *wilc)
 {
 	int i;
@@ -1135,6 +1112,15 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
 
+static const struct net_device_ops wilc_netdev_ops = {
+	.ndo_init = mac_init_fn,
+	.ndo_open = wilc_mac_open,
+	.ndo_stop = wilc_mac_close,
+	.ndo_start_xmit = wilc_mac_xmit,
+	.ndo_get_stats = mac_stats,
+	.ndo_set_rx_mode  = wilc_set_multicast_list,
+};
+
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     int gpio, const struct wilc_hif_func *ops)
 {
-- 
2.7.4
