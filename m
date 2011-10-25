Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11758 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab1JYKO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:14:58 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 33/34] ath6kl: Cleanup function parameters in ath6kl_init_if_data()/ath6kl_deinit_if_data()
Date: Tue, 25 Oct 2011 15:40:29 +0530
Message-ID: <1319537430-12459-34-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121739_618238_F9A7F16A)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It makes sense to pass only vif to these functions.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   19 ++++++++-----------
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    4 ++--
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b5d14fa..699589e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1310,7 +1310,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 	ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
 
-	ath6kl_deinit_if_data(vif->ar, vif->ndev);
+	ath6kl_deinit_if_data(vif);
 
 	return 0;
 }
@@ -2192,27 +2192,25 @@ int ath6kl_register_ieee80211_hw(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_init_if_data(struct ath6kl *ar, struct net_device *ndev)
+static int ath6kl_init_if_data(struct ath6kl_vif *vif)
 {
-	struct ath6kl_vif *vif = netdev_priv(ndev);
-
-	vif->aggr_cntxt = aggr_init(ndev);
+	vif->aggr_cntxt = aggr_init(vif->ndev);
 	if (!vif->aggr_cntxt) {
 		ath6kl_err("failed to initialize aggr\n");
 		return -ENOMEM;
 	}
 
 	setup_timer(&vif->disconnect_timer, disconnect_timer_handler,
-		    (unsigned long) ndev);
+		    (unsigned long) vif->ndev);
 	set_bit(WMM_ENABLED, &vif->flags);
 	spin_lock_init(&vif->if_lock);
 
 	return 0;
 }
 
-void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev)
+void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
 {
-	struct ath6kl_vif *vif = netdev_priv(ndev);
+	struct ath6kl *ar = vif->ar;
 
 	aggr_module_destroy(vif->aggr_cntxt);
 
@@ -2221,7 +2219,7 @@ void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev)
 	if (vif->nw_type == ADHOC_NETWORK)
 		ar->ibss_if_active = false;
 
-	unregister_netdevice(ndev);
+	unregister_netdevice(vif->ndev);
 
 	ar->num_vif--;
 }
@@ -2257,8 +2255,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 
 	ath6kl_init_control_info(vif);
 
-	/* TODO: Pass interface specific pointer instead of ar */
-	if (ath6kl_init_if_data(ar, ndev))
+	if (ath6kl_init_if_data(vif))
 		goto err;
 
 	if (register_netdevice(ndev))
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 7a2ee37..8702a9c 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -656,7 +656,7 @@ void ath6kl_target_failure(struct ath6kl *ar);
 void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 			 bool wait_fot_compltn, bool cold_reset);
 void ath6kl_init_control_info(struct ath6kl_vif *vif);
-void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev);
+void ath6kl_deinit_if_data(struct ath6kl_vif *vif);
 void ath6kl_core_free(struct ath6kl *ar);
 struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar);
 void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 33bf74f..89234d8 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1557,7 +1557,7 @@ err_cleanup_scatter:
 	ath6kl_hif_cleanup_scatter(ar);
 err_if_deinit:
 	rtnl_lock();
-	ath6kl_deinit_if_data(ar, ndev);
+	ath6kl_deinit_if_data(netdev_priv(ndev));
 	rtnl_unlock();
 	wiphy_unregister(ar->wiphy);
 err_debug_init:
@@ -1676,7 +1676,7 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		spin_unlock(&ar->list_lock);
 		ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
 		rtnl_lock();
-		ath6kl_deinit_if_data(vif->ar, vif->ndev);
+		ath6kl_deinit_if_data(vif);
 		rtnl_unlock();
 		spin_lock(&ar->list_lock);
 	}
-- 
1.7.0.4

