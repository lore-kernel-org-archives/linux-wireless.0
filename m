Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4060 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576Ab1JYOGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:06:45 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 05/31] ath6kl: Define an initial vif structure and use it
Date: Tue, 25 Oct 2011 19:34:00 +0530
Message-ID: <1319551466-29070-6-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160657_032730_64258B36)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vif specific information need to be moved from struct ath6kl.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   41 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath6kl/core.h     |   11 ++++++-
 drivers/net/wireless/ath/ath6kl/init.c     |    4 +-
 3 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fcddf1a..e663d60 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2014,51 +2014,58 @@ int ath6kl_register_ieee80211_hw(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_init_if_data(struct ath6kl *ar, struct net_device *ndev)
+static int ath6kl_init_if_data(struct ath6kl_vif *vif)
 {
-	ar->aggr_cntxt = aggr_init(ndev);
+	struct ath6kl *ar = vif->ar;
+
+	ar->aggr_cntxt = aggr_init(vif->ndev);
 	if (!ar->aggr_cntxt) {
 		ath6kl_err("failed to initialize aggr\n");
 		return -ENOMEM;
 	}
 
 	setup_timer(&ar->disconnect_timer, disconnect_timer_handler,
-		    (unsigned long) ndev);
+		    (unsigned long) vif->ndev);
 
 	return 0;
 }
 
-void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev)
+void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
 {
+	struct ath6kl *ar = vif->ar;
+
 	aggr_module_destroy(ar->aggr_cntxt);
 
 	ar->aggr_cntxt = NULL;
 
 	if (test_bit(NETDEV_REGISTERED, &ar->flag)) {
-		unregister_netdev(ndev);
+		unregister_netdev(vif->ndev);
 		clear_bit(NETDEV_REGISTERED, &ar->flag);
 	}
 
-	free_netdev(ndev);
+	free_netdev(vif->ndev);
 }
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 					enum nl80211_iftype type)
 {
 	struct net_device *ndev;
-	struct wireless_dev *wdev;
+	struct ath6kl_vif *vif;
 
-	ndev = alloc_netdev(sizeof(*wdev), "wlan%d", ether_setup);
+	ndev = alloc_netdev(sizeof(*vif), "wlan%d", ether_setup);
 	if (!ndev)
 		return NULL;
 
-	wdev = netdev_priv(ndev);
-	ndev->ieee80211_ptr = wdev;
-	wdev->wiphy = ar->wiphy;
-	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
-	wdev->netdev = ndev;
-	wdev->iftype = type;
-	ar->wdev = wdev;
+	vif = netdev_priv(ndev);
+	ndev->ieee80211_ptr = &vif->wdev;
+	vif->wdev.wiphy = ar->wiphy;
+	vif->ar = ar;
+	ar->vif = vif;
+	vif->ndev = ndev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(vif->wdev.wiphy));
+	vif->wdev.netdev = ndev;
+	vif->wdev.iftype = type;
+	ar->wdev = &vif->wdev;
 	ar->net_dev = ndev;
 
 	init_netdev(ndev);
@@ -2066,7 +2073,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	ath6kl_init_control_info(ar);
 
 	/* TODO: Pass interface specific pointer instead of ar */
-	if (ath6kl_init_if_data(ar, ndev))
+	if (ath6kl_init_if_data(vif))
 		goto err;
 
 	if (register_netdev(ndev))
@@ -2080,7 +2087,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	return ndev;
 
 err:
-	ath6kl_deinit_if_data(ar, ndev);
+	ath6kl_deinit_if_data(vif);
 
 	return NULL;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f1b3c47..0c1dee0 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -380,6 +380,12 @@ struct ath6kl_req_key {
 	u8 key_len;
 };
 
+struct ath6kl_vif {
+	struct wireless_dev wdev;
+	struct net_device *ndev;
+	struct ath6kl *ar;
+};
+
 /* Flag info */
 #define WMI_ENABLED	0
 #define WMI_READY	1
@@ -410,6 +416,7 @@ struct ath6kl {
 	int total_tx_data_pend;
 	struct htc_target *htc_target;
 	void *hif_priv;
+	struct ath6kl_vif *vif;
 	spinlock_t lock;
 	struct semaphore sem;
 	int ssid_len;
@@ -543,7 +550,7 @@ struct ath6kl {
 
 static inline void *ath6kl_priv(struct net_device *dev)
 {
-	return wdev_priv(dev->ieee80211_ptr);
+	return ((struct ath6kl_vif *) netdev_priv(dev))->ar;
 }
 
 static inline void ath6kl_deposit_credit_to_ep(struct htc_credit_state_info
@@ -643,6 +650,6 @@ void ath6kl_wakeup_event(void *dev);
 void ath6kl_target_failure(struct ath6kl *ar);
 
 void ath6kl_init_control_info(struct ath6kl *ar);
-void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev);
+void ath6kl_deinit_if_data(struct ath6kl_vif *vif);
 void ath6kl_core_free(struct ath6kl *ar);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 7720177..246399d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1498,7 +1498,7 @@ err_rxbuf_cleanup:
 err_cleanup_scatter:
 	ath6kl_hif_cleanup_scatter(ar);
 err_if_deinit:
-	ath6kl_deinit_if_data(ar, ndev);
+	ath6kl_deinit_if_data(netdev_priv(ndev));
 	wiphy_unregister(ar->wiphy);
 err_debug_init:
 	ath6kl_debug_cleanup(ar);
@@ -1631,7 +1631,7 @@ void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
 
 	ath6kl_debug_cleanup(ar);
 
-	ath6kl_deinit_if_data(ar, dev);
+	ath6kl_deinit_if_data(netdev_priv(dev));
 
 	kfree(ar->fw_board);
 	kfree(ar->fw_otp);
-- 
1.7.0.4

