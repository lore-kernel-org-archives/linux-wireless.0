Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:60540 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2AQSIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 13:08:37 -0500
Subject: [PATCH v3 1/8] ath6kl: rename vif init and cleanup functions
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 20:08:27 +0200
Message-ID: <20120117180827.29995.67922.stgit@localhost6.localdomain6> (sfid-20120117_190840_608620_100DBBE6)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl_cfg80211_vif_init/cleanup() follow more closely the style used
elsewhere in ath6kl.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    9 ++++-----
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 ++
 drivers/net/wireless/ath/ath6kl/core.h     |    1 -
 drivers/net/wireless/ath/ath6kl/init.c     |    5 +++--
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a13ecec..7e92dc9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1401,7 +1401,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 	ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
 
-	ath6kl_deinit_if_data(vif);
+	ath6kl_cfg80211_vif_cleanup(vif);
 
 	return 0;
 }
@@ -2806,7 +2806,7 @@ int ath6kl_register_ieee80211_hw(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_init_if_data(struct ath6kl_vif *vif)
+static int ath6kl_cfg80211_vif_init(struct ath6kl_vif *vif)
 {
 	vif->aggr_cntxt = aggr_init(vif->ndev);
 	if (!vif->aggr_cntxt) {
@@ -2827,7 +2827,7 @@ static int ath6kl_init_if_data(struct ath6kl_vif *vif)
 	return 0;
 }
 
-void ath6kl_deinit_if_data(struct ath6kl_vif *vif)
+void ath6kl_cfg80211_vif_cleanup(struct ath6kl_vif *vif)
 {
 	struct ath6kl *ar = vif->ar;
 	struct ath6kl_mc_filter *mc_filter, *tmp;
@@ -2880,8 +2880,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 
 	ath6kl_init_control_info(vif);
 
-	/* TODO: Pass interface specific pointer instead of ar */
-	if (ath6kl_init_if_data(vif))
+	if (ath6kl_cfg80211_vif_init(vif))
 		goto err;
 
 	if (register_netdevice(ndev))
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 81f20a5..aa96169 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -53,6 +53,8 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 int ath6kl_cfg80211_resume(struct ath6kl *ar);
 
+void ath6kl_cfg80211_vif_cleanup(struct ath6kl_vif *vif);
+
 void ath6kl_cfg80211_stop(struct ath6kl_vif *vif);
 void ath6kl_cfg80211_stop_all(struct ath6kl *ar);
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ba39539..a75c09e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -745,7 +745,6 @@ void ath6kl_wakeup_event(void *dev);
 void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 			 bool wait_fot_compltn, bool cold_reset);
 void ath6kl_init_control_info(struct ath6kl_vif *vif);
-void ath6kl_deinit_if_data(struct ath6kl_vif *vif);
 void ath6kl_core_free(struct ath6kl *ar);
 struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar);
 void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e5969c1..f7378f4 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1715,7 +1715,7 @@ err_rxbuf_cleanup:
 	ath6kl_htc_flush_rx_buf(ar->htc_target);
 	ath6kl_cleanup_amsdu_rxbufs(ar);
 	rtnl_lock();
-	ath6kl_deinit_if_data(netdev_priv(ndev));
+	ath6kl_cfg80211_vif_cleanup(netdev_priv(ndev));
 	rtnl_unlock();
 	wiphy_unregister(ar->wiphy);
 err_debug_init:
@@ -1736,6 +1736,7 @@ err_wq:
 	return ret;
 }
 
+/* FIXME: move this to cfg80211.c and rename to ath6kl_cfg80211_vif_stop() */
 void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
 {
 	static u8 bcast_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
@@ -1781,7 +1782,7 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		spin_unlock_bh(&ar->list_lock);
 		ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
 		rtnl_lock();
-		ath6kl_deinit_if_data(vif);
+		ath6kl_cfg80211_vif_cleanup(vif);
 		rtnl_unlock();
 		spin_lock_bh(&ar->list_lock);
 	}

