Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35027 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541Ab1JYOHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:07:22 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 26/31] ath6kl: Use the other variant of netdev (un)register APIs
Date: Tue, 25 Oct 2011 19:34:21 +0530
Message-ID: <1319551466-29070-27-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160727_080860_D7933F07)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use replace (un)register_netdev() with (un)register_netdevice()
so that the same ath6kl function can be used with
add_virtual_intf()/del_virtual_intf().

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   15 ++++-----------
 drivers/net/wireless/ath/ath6kl/init.c     |   12 ++++++++++--
 drivers/net/wireless/ath/ath6kl/main.c     |    1 +
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a97365e..7cdd893 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2098,14 +2098,7 @@ void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
 {
 	aggr_module_destroy(vif->aggr_cntxt);
 
-	vif->aggr_cntxt = NULL;
-
-	if (test_bit(NETDEV_REGISTERED, &vif->flags)) {
-		unregister_netdev(vif->ndev);
-		clear_bit(NETDEV_REGISTERED, &vif->flags);
-	}
-
-	free_netdev(vif->ndev);
+	unregister_netdevice(vif->ndev);
 }
 
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
@@ -2137,7 +2130,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	if (ath6kl_init_if_data(vif))
 		goto err;
 
-	if (register_netdev(ndev))
+	if (register_netdevice(ndev))
 		goto err;
 
 	vif->sme_state = SME_DISCONNECTED;
@@ -2152,8 +2145,8 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	return ndev;
 
 err:
-	ath6kl_deinit_if_data(vif);
-
+	aggr_module_destroy(vif->aggr_cntxt);
+	free_netdev(ndev);
 	return NULL;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index ea45f64..d541dc9 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1416,8 +1416,13 @@ static int ath6kl_init(struct ath6kl *ar)
 		goto err_node_cleanup;
 	}
 
+	rtnl_lock();
+
 	/* Add an initial station interface */
 	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION, 0);
+
+	rtnl_unlock();
+
 	if (!ndev) {
 		ath6kl_err("Failed to instantiate a network device\n");
 		status = -ENOMEM;
@@ -1522,7 +1527,9 @@ err_rxbuf_cleanup:
 err_cleanup_scatter:
 	ath6kl_hif_cleanup_scatter(ar);
 err_if_deinit:
+	rtnl_lock();
 	ath6kl_deinit_if_data(netdev_priv(ndev));
+	rtnl_unlock();
 	wiphy_unregister(ar->wiphy);
 err_debug_init:
 	ath6kl_debug_cleanup(ar);
@@ -1621,8 +1628,6 @@ static void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
 		cfg80211_scan_done(vif->scan_req, true);
 		vif->scan_req = NULL;
 	}
-
-	ath6kl_deinit_if_data(vif);
 }
 
 void ath6kl_stop_txrx(struct ath6kl *ar)
@@ -1641,6 +1646,9 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		list_del(&vif->list);
 		spin_unlock(&ar->list_lock);
 		ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
+		rtnl_lock();
+		ath6kl_deinit_if_data(vif);
+		rtnl_unlock();
 		spin_lock(&ar->list_lock);
 	}
 	spin_unlock(&ar->list_lock);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 17cabdc..9ccdc4d 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1445,6 +1445,7 @@ static struct net_device_ops ath6kl_netdev_ops = {
 void init_netdev(struct net_device *dev)
 {
 	dev->netdev_ops = &ath6kl_netdev_ops;
+	dev->destructor = free_netdev;
 	dev->watchdog_timeo = ATH6KL_TX_TIMEOUT;
 
 	dev->needed_headroom = ETH_HLEN;
-- 
1.7.0.4

