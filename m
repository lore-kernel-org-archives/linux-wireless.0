Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34969 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab1JYOGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:06:44 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 21/31] ath6kl: Refactor ath6kl_destroy()
Date: Tue, 25 Oct 2011 19:34:16 +0530
Message-ID: <1319551466-29070-22-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160648_223414_46BF94E6)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that the deinitialization of ath6kl and vif are separated.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 --
 drivers/net/wireless/ath/ath6kl/common.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    5 +-
 drivers/net/wireless/ath/ath6kl/init.c     |  124 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath6kl/main.c     |   75 +----------------
 drivers/net/wireless/ath/ath6kl/sdio.c     |    2 +-
 6 files changed, 79 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0d02ba0..d42cb3e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2142,14 +2142,6 @@ err:
 
 void ath6kl_deinit_ieee80211_hw(struct ath6kl *ar)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-
-	if (vif->scan_req) {
-		cfg80211_scan_done(vif->scan_req, true);
-		vif->scan_req = NULL;
-	}
-
 	wiphy_unregister(ar->wiphy);
 	wiphy_free(ar->wiphy);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index b92f0e5..877cb70 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -92,6 +92,6 @@ void ath6k_seek_credits(struct htc_credit_state_info *cred_inf,
 			struct htc_endpoint_credit_dist *ep_dist);
 struct ath6kl *ath6kl_core_alloc(struct device *sdev);
 int ath6kl_core_init(struct ath6kl *ar);
-int ath6kl_unavail_ev(struct ath6kl *ar);
+void ath6kl_core_cleanup(struct ath6kl *ar);
 struct sk_buff *ath6kl_buf_alloc(int size);
 #endif /* COMMON_H */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index de288ff..498b626 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -584,7 +584,6 @@ static inline u32 ath6kl_get_hi_item_addr(struct ath6kl *ar,
 	return addr;
 }
 
-void ath6kl_destroy(struct net_device *dev, unsigned int unregister);
 int ath6kl_configure_target(struct ath6kl *ar);
 void ath6kl_detect_error(unsigned long ptr);
 void disconnect_timer_handler(unsigned long ptr);
@@ -604,8 +603,6 @@ int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length);
 int ath6kl_read_fwlogs(struct ath6kl *ar);
 void ath6kl_init_profile_info(struct ath6kl_vif *vif);
 void ath6kl_tx_data_cleanup(struct ath6kl *ar);
-void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
-			  bool get_dbglogs);
 
 struct ath6kl_cookie *ath6kl_alloc_cookie(struct ath6kl *ar);
 void ath6kl_free_cookie(struct ath6kl *ar, struct ath6kl_cookie *cookie);
@@ -657,6 +654,8 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 void ath6kl_wakeup_event(void *dev);
 void ath6kl_target_failure(struct ath6kl *ar);
 
+void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
+			 bool wait_fot_compltn, bool cold_reset);
 void ath6kl_init_control_info(struct ath6kl_vif *vif);
 void ath6kl_deinit_if_data(struct ath6kl_vif *vif);
 void ath6kl_core_free(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 4bb348e..c5170c3 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -513,11 +513,27 @@ void ath6kl_core_free(struct ath6kl *ar)
 	wiphy_free(ar->wiphy);
 }
 
-int ath6kl_unavail_ev(struct ath6kl *ar)
+void ath6kl_core_cleanup(struct ath6kl *ar)
 {
-	ath6kl_destroy(ar->vif->ndev, 1);
+	destroy_workqueue(ar->ath6kl_wq);
 
-	return 0;
+	if (ar->htc_target)
+		ath6kl_htc_cleanup(ar->htc_target);
+
+	ath6kl_cookie_cleanup(ar);
+
+	ath6kl_cleanup_amsdu_rxbufs(ar);
+
+	ath6kl_bmi_cleanup(ar);
+
+	ath6kl_debug_cleanup(ar);
+
+	kfree(ar->fw_board);
+	kfree(ar->fw_otp);
+	kfree(ar->fw);
+	kfree(ar->fw_patch);
+
+	ath6kl_deinit_ieee80211_hw(ar);
 }
 
 /* firmware upload */
@@ -1571,6 +1587,36 @@ err_wq:
 	return ret;
 }
 
+static void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
+{
+	static u8 bcast_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	bool discon_issued;
+
+	netif_stop_queue(vif->ndev);
+
+	clear_bit(WLAN_ENABLED, &vif->flags);
+
+	if (wmi_ready) {
+		discon_issued = test_bit(CONNECTED, &vif->flags) ||
+				test_bit(CONNECT_PEND, &vif->flags);
+		ath6kl_disconnect(vif);
+		del_timer(&vif->disconnect_timer);
+
+		if (discon_issued)
+			ath6kl_disconnect_event(vif, DISCONNECT_CMD,
+						(vif->nw_type & AP_NETWORK) ?
+						bcast_mac : vif->bssid,
+						0, NULL, 0);
+	}
+
+	if (vif->scan_req) {
+		cfg80211_scan_done(vif->scan_req, true);
+		vif->scan_req = NULL;
+	}
+
+	ath6kl_deinit_if_data(vif);
+}
+
 void ath6kl_stop_txrx(struct ath6kl *ar)
 {
 	struct ath6kl_vif *vif = ar->vif;
@@ -1586,58 +1632,34 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		return;
 	}
 
-	if (ar->wlan_pwr_state != WLAN_POWER_STATE_CUT_PWR)
-		ath6kl_stop_endpoint(ndev, false, true);
+	ath6kl_cleanup_vif(ar->vif, test_bit(WMI_READY, &ar->flag));
 
-	clear_bit(WLAN_ENABLED, &vif->flags);
-}
+	clear_bit(WMI_READY, &ar->flag);
 
-/*
- * We need to differentiate between the surprise and planned removal of the
- * device because of the following consideration:
- *
- * - In case of surprise removal, the hcd already frees up the pending
- *   for the device and hence there is no need to unregister the function
- *   driver inorder to get these requests. For planned removal, the function
- *   driver has to explicitly unregister itself to have the hcd return all the
- *   pending requests before the data structures for the devices are freed up.
- *   Note that as per the current implementation, the function driver will
- *   end up releasing all the devices since there is no API to selectively
- *   release a particular device.
- *
- * - Certain commands issued to the target can be skipped for surprise
- *   removal since they will anyway not go through.
- */
-void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
-{
-	struct ath6kl *ar;
+	/*
+	 * After wmi_shudown all WMI events will be dropped. We
+	 * need to cleanup the buffers allocated in AP mode and
+	 * give disconnect notification to stack, which usually
+	 * happens in the disconnect_event. Simulate the disconnect
+	 * event by calling the function directly. Sometimes
+	 * disconnect_event will be received when the debug logs
+	 * are collected.
+	 */
+	ath6kl_wmi_shutdown(ar->wmi);
 
-	if (!dev || !ath6kl_priv(dev)) {
-		ath6kl_err("failed to get device structure\n");
-		return;
+	clear_bit(WMI_ENABLED, &ar->flag);
+	if (ar->htc_target) {
+		ath6kl_dbg(ATH6KL_DBG_TRC, "%s: shut down htc\n", __func__);
+		ath6kl_htc_stop(ar->htc_target);
 	}
 
-	ar = ath6kl_priv(dev);
-
-	destroy_workqueue(ar->ath6kl_wq);
-
-	if (ar->htc_target)
-		ath6kl_htc_cleanup(ar->htc_target);
-
-	ath6kl_cookie_cleanup(ar);
-
-	ath6kl_cleanup_amsdu_rxbufs(ar);
-
-	ath6kl_bmi_cleanup(ar);
-
-	ath6kl_debug_cleanup(ar);
-
-	ath6kl_deinit_if_data(netdev_priv(dev));
-
-	kfree(ar->fw_board);
-	kfree(ar->fw_otp);
-	kfree(ar->fw);
-	kfree(ar->fw_patch);
+	/*
+	 * Try to reset the device if we can. The driver may have been
+	 * configure NOT to reset the target during a debug session.
+	 */
+	ath6kl_dbg(ATH6KL_DBG_TRC,
+			"attempting to reset target on instance destroy\n");
+	ath6kl_reset_device(ar, ar->target_type, true, true);
 
-	ath6kl_deinit_ieee80211_hw(ar);
+	clear_bit(WLAN_ENABLED, &ar->flag);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 08af257..a10002d 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -395,8 +395,8 @@ out:
 #define AR6003_RESET_CONTROL_ADDRESS 0x00004000
 #define AR6004_RESET_CONTROL_ADDRESS 0x00004000
 
-static void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
-				bool wait_fot_compltn, bool cold_reset)
+void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
+			 bool wait_fot_compltn, bool cold_reset)
 {
 	int status = 0;
 	u32 address;
@@ -427,77 +427,6 @@ static void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 		ath6kl_err("failed to reset target\n");
 }
 
-void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
-			  bool get_dbglogs)
-{
-	struct ath6kl *ar = ath6kl_priv(dev);
-	struct ath6kl_vif *vif = netdev_priv(dev);
-	static u8 bcast_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	bool discon_issued;
-
-	netif_stop_queue(dev);
-
-	/* disable the target and the interrupts associated with it */
-	if (test_bit(WMI_READY, &ar->flag)) {
-		discon_issued = (test_bit(CONNECTED, &vif->flags) ||
-				 test_bit(CONNECT_PEND, &vif->flags));
-		ath6kl_disconnect(vif);
-		if (!keep_profile)
-			ath6kl_init_profile_info(vif);
-
-		del_timer(&vif->disconnect_timer);
-
-		clear_bit(WMI_READY, &ar->flag);
-		ath6kl_wmi_shutdown(ar->wmi);
-		clear_bit(WMI_ENABLED, &ar->flag);
-		ar->wmi = NULL;
-
-		/*
-		 * After wmi_shudown all WMI events will be dropped. We
-		 * need to cleanup the buffers allocated in AP mode and
-		 * give disconnect notification to stack, which usually
-		 * happens in the disconnect_event. Simulate the disconnect
-		 * event by calling the function directly. Sometimes
-		 * disconnect_event will be received when the debug logs
-		 * are collected.
-		 */
-		if (discon_issued)
-			ath6kl_disconnect_event(vif, DISCONNECT_CMD,
-						(vif->nw_type & AP_NETWORK) ?
-						bcast_mac : vif->bssid,
-						0, NULL, 0);
-
-		ar->user_key_ctrl = 0;
-
-	} else {
-		ath6kl_dbg(ATH6KL_DBG_TRC,
-			   "%s: wmi is not ready 0x%p 0x%p\n",
-			   __func__, ar, ar->wmi);
-
-		/* Shut down WMI if we have started it */
-		if (test_bit(WMI_ENABLED, &ar->flag)) {
-			ath6kl_dbg(ATH6KL_DBG_TRC,
-				   "%s: shut down wmi\n", __func__);
-			ath6kl_wmi_shutdown(ar->wmi);
-			clear_bit(WMI_ENABLED, &ar->flag);
-			ar->wmi = NULL;
-		}
-	}
-
-	if (ar->htc_target) {
-		ath6kl_dbg(ATH6KL_DBG_TRC, "%s: shut down htc\n", __func__);
-		ath6kl_htc_stop(ar->htc_target);
-	}
-
-	/*
-	 * Try to reset the device if we can. The driver may have been
-	 * configure NOT to reset the target during a debug session.
-	 */
-	ath6kl_dbg(ATH6KL_DBG_TRC,
-		   "attempting to reset target on instance destroy\n");
-	ath6kl_reset_device(ar, ar->target_type, true, true);
-}
-
 static void ath6kl_install_static_wep_keys(struct ath6kl_vif *vif)
 {
 	u8 index;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index f73e14f..b7c0566 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -897,7 +897,7 @@ static void ath6kl_sdio_remove(struct sdio_func *func)
 	ath6kl_stop_txrx(ar_sdio->ar);
 	cancel_work_sync(&ar_sdio->wr_async_work);
 
-	ath6kl_unavail_ev(ar_sdio->ar);
+	ath6kl_core_cleanup(ar_sdio->ar);
 
 	ath6kl_sdio_power_off(ar_sdio);
 
-- 
1.7.0.4

