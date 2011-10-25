Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41312 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab1JYKKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:10:41 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 03/34] ath6kl: Refactor wiphy dev and net dev init functions
Date: Tue, 25 Oct 2011 15:39:59 +0530
Message-ID: <1319537430-12459-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121044_549610_1DB2833A)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This refactoring is done in a manner that it can be used
for multiple virtual interface.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  146 +++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    7 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +
 drivers/net/wireless/ath/ath6kl/init.c     |  149 +++++++---------------------
 drivers/net/wireless/ath/ath6kl/sdio.c     |    8 +-
 5 files changed, 173 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 16c21a4..fcddf1a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1918,45 +1918,83 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
 };
 
-struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
+struct ath6kl *ath6kl_core_alloc(struct device *dev)
 {
-	int ret = 0;
-	struct wireless_dev *wdev;
 	struct ath6kl *ar;
 	struct wiphy *wiphy;
-
-	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
-	if (!wdev) {
-		ath6kl_err("couldn't allocate wireless device\n");
-		return NULL;
-	}
+	u8 ctr;
 
 	/* create a new wiphy for use with cfg80211 */
 	wiphy = wiphy_new(&ath6kl_cfg80211_ops, sizeof(struct ath6kl));
+
 	if (!wiphy) {
 		ath6kl_err("couldn't allocate wiphy device\n");
-		kfree(wdev);
 		return NULL;
 	}
 
 	ar = wiphy_priv(wiphy);
 	ar->p2p = !!ath6kl_p2p;
 	ar->wiphy = wiphy;
-	wdev->wiphy = wiphy;
+	ar->dev = dev;
+
+	spin_lock_init(&ar->lock);
+	spin_lock_init(&ar->mcastpsq_lock);
+
+	init_waitqueue_head(&ar->event_wq);
+	sema_init(&ar->sem, 1);
+
+	INIT_LIST_HEAD(&ar->amsdu_rx_buffer_queue);
+
+	clear_bit(WMI_ENABLED, &ar->flag);
+	clear_bit(SKIP_SCAN, &ar->flag);
+	clear_bit(DESTROY_IN_PROGRESS, &ar->flag);
+
+	ar->listen_intvl_t = A_DEFAULT_LISTEN_INTERVAL;
+	ar->listen_intvl_b = 0;
+	ar->tx_pwr = 0;
+
+	ar->intra_bss = 1;
+	memset(&ar->sc_params, 0, sizeof(ar->sc_params));
+	ar->sc_params.short_scan_ratio = WMI_SHORTSCANRATIO_DEFAULT;
+	ar->sc_params.scan_ctrl_flags = DEFAULT_SCAN_CTRL_FLAGS;
+	ar->lrssi_roam_threshold = DEF_LRSSI_ROAM_THRESHOLD;
+
+	memset((u8 *)ar->sta_list, 0,
+	       AP_MAX_NUM_STA * sizeof(struct ath6kl_sta));
+
+	/* Init the PS queues */
+	for (ctr = 0; ctr < AP_MAX_NUM_STA; ctr++) {
+		spin_lock_init(&ar->sta_list[ctr].psq_lock);
+		skb_queue_head_init(&ar->sta_list[ctr].psq);
+	}
+
+	skb_queue_head_init(&ar->mcastpsq);
+
+	memcpy(ar->ap_country_code, DEF_AP_COUNTRY_CODE, 3);
+
+	return ar;
+}
+
+int ath6kl_register_ieee80211_hw(struct ath6kl *ar)
+{
+	struct wiphy *wiphy = ar->wiphy;
+	int ret;
 
 	wiphy->mgmt_stypes = ath6kl_mgmt_stypes;
 
 	wiphy->max_remain_on_channel_duration = 5000;
 
 	/* set device pointer for wiphy */
-	set_wiphy_dev(wiphy, dev);
+	set_wiphy_dev(wiphy, ar->dev);
 
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
+				 BIT(NL80211_IFTYPE_ADHOC) |
+				 BIT(NL80211_IFTYPE_AP);
 	if (ar->p2p) {
 		wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_GO) |
-			BIT(NL80211_IFTYPE_P2P_CLIENT);
+					  BIT(NL80211_IFTYPE_P2P_CLIENT);
 	}
+
 	/* max num of ssids that can be probed during scanning */
 	wiphy->max_scan_ssids = MAX_PROBED_SSID_INDEX;
 	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
@@ -1970,18 +2008,85 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 	ret = wiphy_register(wiphy);
 	if (ret < 0) {
 		ath6kl_err("couldn't register wiphy device\n");
-		wiphy_free(wiphy);
-		kfree(wdev);
-		return NULL;
+		return ret;
 	}
 
-	return wdev;
+	return 0;
 }
 
-void ath6kl_cfg80211_deinit(struct ath6kl *ar)
+static int ath6kl_init_if_data(struct ath6kl *ar, struct net_device *ndev)
 {
-	struct wireless_dev *wdev = ar->wdev;
+	ar->aggr_cntxt = aggr_init(ndev);
+	if (!ar->aggr_cntxt) {
+		ath6kl_err("failed to initialize aggr\n");
+		return -ENOMEM;
+	}
+
+	setup_timer(&ar->disconnect_timer, disconnect_timer_handler,
+		    (unsigned long) ndev);
 
+	return 0;
+}
+
+void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev)
+{
+	aggr_module_destroy(ar->aggr_cntxt);
+
+	ar->aggr_cntxt = NULL;
+
+	if (test_bit(NETDEV_REGISTERED, &ar->flag)) {
+		unregister_netdev(ndev);
+		clear_bit(NETDEV_REGISTERED, &ar->flag);
+	}
+
+	free_netdev(ndev);
+}
+
+struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
+					enum nl80211_iftype type)
+{
+	struct net_device *ndev;
+	struct wireless_dev *wdev;
+
+	ndev = alloc_netdev(sizeof(*wdev), "wlan%d", ether_setup);
+	if (!ndev)
+		return NULL;
+
+	wdev = netdev_priv(ndev);
+	ndev->ieee80211_ptr = wdev;
+	wdev->wiphy = ar->wiphy;
+	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
+	wdev->netdev = ndev;
+	wdev->iftype = type;
+	ar->wdev = wdev;
+	ar->net_dev = ndev;
+
+	init_netdev(ndev);
+
+	ath6kl_init_control_info(ar);
+
+	/* TODO: Pass interface specific pointer instead of ar */
+	if (ath6kl_init_if_data(ar, ndev))
+		goto err;
+
+	if (register_netdev(ndev))
+		goto err;
+
+	ar->sme_state = SME_DISCONNECTED;
+	set_bit(WLAN_ENABLED, &ar->flag);
+	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
+	set_bit(NETDEV_REGISTERED, &ar->flag);
+
+	return ndev;
+
+err:
+	ath6kl_deinit_if_data(ar, ndev);
+
+	return NULL;
+}
+
+void ath6kl_deinit_ieee80211_hw(struct ath6kl *ar)
+{
 	if (ar->scan_req) {
 		cfg80211_scan_done(ar->scan_req, true);
 		ar->scan_req = NULL;
@@ -1989,5 +2094,4 @@ void ath6kl_cfg80211_deinit(struct ath6kl *ar)
 
 	wiphy_unregister(ar->wiphy);
 	wiphy_free(ar->wiphy);
-	kfree(wdev);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index a84adc2..5daf685 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -17,8 +17,11 @@
 #ifndef ATH6KL_CFG80211_H
 #define ATH6KL_CFG80211_H
 
-struct wireless_dev *ath6kl_cfg80211_init(struct device *dev);
-void ath6kl_cfg80211_deinit(struct ath6kl *ar);
+struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
+					enum nl80211_iftype type);
+int ath6kl_register_ieee80211_hw(struct ath6kl *ar);
+struct ath6kl *ath6kl_core_alloc(struct device *dev);
+void ath6kl_deinit_ieee80211_hw(struct ath6kl *ar);
 
 void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status);
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 5b76d97..d827551 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -632,4 +632,7 @@ void aggr_recv_addba_req_evt(struct ath6kl *ar, u8 tid, u16 seq_no,
 void ath6kl_wakeup_event(void *dev);
 void ath6kl_target_failure(struct ath6kl *ar);
 
+void ath6kl_init_control_info(struct ath6kl *ar);
+void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev);
+void ath6kl_core_free(struct ath6kl *ar);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d22e796..33c1584 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -258,40 +258,12 @@ static int ath6kl_init_service_ep(struct ath6kl *ar)
 	return 0;
 }
 
-static void ath6kl_init_control_info(struct ath6kl *ar)
+void ath6kl_init_control_info(struct ath6kl *ar)
 {
-	u8 ctr;
-
-	clear_bit(WMI_ENABLED, &ar->flag);
 	ath6kl_init_profile_info(ar);
 	ar->def_txkey_index = 0;
 	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
 	ar->ch_hint = 0;
-	ar->listen_intvl_t = A_DEFAULT_LISTEN_INTERVAL;
-	ar->listen_intvl_b = 0;
-	ar->tx_pwr = 0;
-	clear_bit(SKIP_SCAN, &ar->flag);
-	set_bit(WMM_ENABLED, &ar->flag);
-	ar->intra_bss = 1;
-	memset(&ar->sc_params, 0, sizeof(ar->sc_params));
-	ar->sc_params.short_scan_ratio = WMI_SHORTSCANRATIO_DEFAULT;
-	ar->sc_params.scan_ctrl_flags = DEFAULT_SCAN_CTRL_FLAGS;
-	ar->lrssi_roam_threshold = DEF_LRSSI_ROAM_THRESHOLD;
-
-	memset((u8 *)ar->sta_list, 0,
-	       AP_MAX_NUM_STA * sizeof(struct ath6kl_sta));
-
-	spin_lock_init(&ar->mcastpsq_lock);
-
-	/* Init the PS queues */
-	for (ctr = 0; ctr < AP_MAX_NUM_STA; ctr++) {
-		spin_lock_init(&ar->sta_list[ctr].psq_lock);
-		skb_queue_head_init(&ar->sta_list[ctr].psq);
-	}
-
-	skb_queue_head_init(&ar->mcastpsq);
-
-	memcpy(ar->ap_country_code, DEF_AP_COUNTRY_CODE, 3);
 }
 
 /*
@@ -553,61 +525,9 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	return 0;
 }
 
-struct ath6kl *ath6kl_core_alloc(struct device *sdev)
+void ath6kl_core_free(struct ath6kl *ar)
 {
-	struct net_device *dev;
-	struct ath6kl *ar;
-	struct wireless_dev *wdev;
-
-	wdev = ath6kl_cfg80211_init(sdev);
-	if (!wdev) {
-		ath6kl_err("ath6kl_cfg80211_init failed\n");
-		return NULL;
-	}
-
-	ar = wdev_priv(wdev);
-	ar->dev = sdev;
-	ar->wdev = wdev;
-	wdev->iftype = NL80211_IFTYPE_STATION;
-
-	if (ath6kl_debug_init(ar)) {
-		ath6kl_err("Failed to initialize debugfs\n");
-		ath6kl_cfg80211_deinit(ar);
-		return NULL;
-	}
-
-	dev = alloc_netdev(0, "wlan%d", ether_setup);
-	if (!dev) {
-		ath6kl_err("no memory for network device instance\n");
-		ath6kl_cfg80211_deinit(ar);
-		return NULL;
-	}
-
-	dev->ieee80211_ptr = wdev;
-	SET_NETDEV_DEV(dev, wiphy_dev(ar->wiphy));
-	wdev->netdev = dev;
-	ar->sme_state = SME_DISCONNECTED;
-
-	init_netdev(dev);
-
-	ar->net_dev = dev;
-	set_bit(WLAN_ENABLED, &ar->flag);
-
-	ar->wlan_pwr_state = WLAN_POWER_STATE_ON;
-
-	spin_lock_init(&ar->lock);
-
-	ath6kl_init_control_info(ar);
-	init_waitqueue_head(&ar->event_wq);
-	sema_init(&ar->sem, 1);
-	clear_bit(DESTROY_IN_PROGRESS, &ar->flag);
-
-	INIT_LIST_HEAD(&ar->amsdu_rx_buffer_queue);
-
-	setup_timer(&ar->disconnect_timer, disconnect_timer_handler,
-		    (unsigned long) dev);
-
-	return ar;
+	wiphy_free(ar->wiphy);
 }
 
 int ath6kl_unavail_ev(struct ath6kl *ar)
@@ -1465,6 +1385,7 @@ static int ath6kl_init(struct ath6kl *ar)
 {
 	int status = 0;
 	s32 timeleft;
+	struct net_device *ndev;
 
 	if (!ar)
 		return -EIO;
@@ -1486,6 +1407,29 @@ static int ath6kl_init(struct ath6kl *ar)
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: got wmi @ 0x%p.\n", __func__, ar->wmi);
 
+	status = ath6kl_register_ieee80211_hw(ar);
+	if (status)
+		goto err_node_cleanup;
+
+	status = ath6kl_debug_init(ar);
+	if (status) {
+		wiphy_unregister(ar->wiphy);
+		goto err_node_cleanup;
+	}
+
+	/* Add an initial station interface */
+	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION);
+	if (!ndev) {
+		ath6kl_err("Failed to instantiate a network device\n");
+		status = -ENOMEM;
+		wiphy_unregister(ar->wiphy);
+		goto err_debug_init;
+	}
+
+
+	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
+			__func__, ar->net_dev->name, ar->net_dev, ar);
+
 	/*
 	 * The reason we have to wait for the target here is that the
 	 * driver layer has to init BMI in order to set the host block
@@ -1493,7 +1437,7 @@ static int ath6kl_init(struct ath6kl *ar)
 	 */
 	if (ath6kl_htc_wait_target(ar->htc_target)) {
 		status = -EIO;
-		goto err_node_cleanup;
+		goto err_if_deinit;
 	}
 
 	if (ath6kl_init_service_ep(ar)) {
@@ -1570,6 +1514,11 @@ err_rxbuf_cleanup:
 	ath6kl_cleanup_amsdu_rxbufs(ar);
 err_cleanup_scatter:
 	ath6kl_hif_cleanup_scatter(ar);
+err_if_deinit:
+	ath6kl_deinit_if_data(ar, ndev);
+	wiphy_unregister(ar->wiphy);
+err_debug_init:
+	ath6kl_debug_cleanup(ar);
 err_node_cleanup:
 	ath6kl_wmi_shutdown(ar->wmi);
 	clear_bit(WMI_ENABLED, &ar->flag);
@@ -1615,13 +1564,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 		goto err_bmi_cleanup;
 	}
 
-	ar->aggr_cntxt = aggr_init(ar->net_dev);
-	if (!ar->aggr_cntxt) {
-		ath6kl_err("failed to initialize aggr\n");
-		ret = -ENOMEM;
-		goto err_htc_cleanup;
-	}
-
 	ret = ath6kl_fetch_firmwares(ar);
 	if (ret)
 		goto err_htc_cleanup;
@@ -1634,19 +1576,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (ret)
 		goto err_htc_cleanup;
 
-	/* This runs the init function if registered */
-	ret = register_netdev(ar->net_dev);
-	if (ret) {
-		ath6kl_err("register_netdev failed\n");
-		ath6kl_destroy(ar->net_dev, 0);
-		return ret;
-	}
-
-	set_bit(NETDEV_REGISTERED, &ar->flag);
-
-	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
-			__func__, ar->net_dev->name, ar->net_dev, ar);
-
 	return ret;
 
 err_htc_cleanup:
@@ -1655,6 +1584,7 @@ err_bmi_cleanup:
 	ath6kl_bmi_cleanup(ar);
 err_wq:
 	destroy_workqueue(ar->ath6kl_wq);
+
 	return ret;
 }
 
@@ -1710,8 +1640,6 @@ void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
 	if (ar->htc_target)
 		ath6kl_htc_cleanup(ar->htc_target);
 
-	aggr_module_destroy(ar->aggr_cntxt);
-
 	ath6kl_cookie_cleanup(ar);
 
 	ath6kl_cleanup_amsdu_rxbufs(ar);
@@ -1720,17 +1648,12 @@ void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
 
 	ath6kl_debug_cleanup(ar);
 
-	if (unregister && test_bit(NETDEV_REGISTERED, &ar->flag)) {
-		unregister_netdev(dev);
-		clear_bit(NETDEV_REGISTERED, &ar->flag);
-	}
-
-	free_netdev(dev);
+	ath6kl_deinit_if_data(ar, dev);
 
 	kfree(ar->fw_board);
 	kfree(ar->fw_otp);
 	kfree(ar->fw);
 	kfree(ar->fw_patch);
 
-	ath6kl_cfg80211_deinit(ar);
+	ath6kl_deinit_ieee80211_hw(ar);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index b7bbe56..f58dc9c 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -841,7 +841,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 			ath6kl_err("Failed to enable 4-bit async irq mode %d\n",
 				   ret);
 			sdio_release_host(func);
-			goto err_cfg80211;
+			goto err_core_alloc;
 		}
 
 		ath6kl_dbg(ATH6KL_DBG_BOOT, "4-bit async irq mode enabled\n");
@@ -854,7 +854,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	ret = ath6kl_sdio_power_on(ar_sdio);
 	if (ret)
-		goto err_cfg80211;
+		goto err_core_alloc;
 
 	sdio_claim_host(func);
 
@@ -878,8 +878,8 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 err_off:
 	ath6kl_sdio_power_off(ar_sdio);
-err_cfg80211:
-	ath6kl_cfg80211_deinit(ar_sdio->ar);
+err_core_alloc:
+	ath6kl_core_free(ar_sdio->ar);
 err_dma:
 	kfree(ar_sdio->dma_buffer);
 err_hif:
-- 
1.7.0.4

