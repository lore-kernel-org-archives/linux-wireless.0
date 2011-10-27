Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:40218 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1J0Psl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:48:41 -0400
Subject: [PATCH 06/10] ath6kl: separate hardware boot code from module
	initialisation code
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:48:37 +0300
Message-ID: <20111027154837.23519.36126.stgit@localhost6.localdomain6> (sfid-20111027_174845_062589_6D3FB68F)
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the code needed to boot the hardware to a separate function so
that it will be easier boot and shutdown hardware.

No functional changes (hopefully).

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |  183 +++++++++++++++++++-------------
 1 files changed, 106 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index f5d0b99..a0b81c3 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1421,12 +1421,107 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_hw_start(struct ath6kl *ar)
+{
+	long timeleft;
+	int ret, i;
+
+	ret = ath6kl_hif_power_on(ar);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_configure_target(ar);
+	if (ret)
+		goto err_power_off;
+
+	ret = ath6kl_init_upload(ar);
+	if (ret)
+		goto err_power_off;
+
+	/* Do we need to finish the BMI phase */
+	/* FIXME: return error from ath6kl_bmi_done() */
+	if (ath6kl_bmi_done(ar)) {
+		ret = -EIO;
+		goto err_power_off;
+	}
+
+	/*
+	 * The reason we have to wait for the target here is that the
+	 * driver layer has to init BMI in order to set the host block
+	 * size.
+	 */
+	if (ath6kl_htc_wait_target(ar->htc_target)) {
+		ret = -EIO;
+		goto err_power_off;
+	}
+
+	if (ath6kl_init_service_ep(ar)) {
+		ret = -EIO;
+		goto err_cleanup_scatter;
+	}
+
+	/* setup credit distribution */
+	ath6kl_credit_setup(ar->htc_target, &ar->credit_state_info);
+
+	/* start HTC */
+	ret = ath6kl_htc_start(ar->htc_target);
+	if (ret) {
+		/* FIXME: call this */
+		ath6kl_cookie_cleanup(ar);
+		goto err_cleanup_scatter;
+	}
+
+	/* Wait for Wmi event to be ready */
+	timeleft = wait_event_interruptible_timeout(ar->event_wq,
+						    test_bit(WMI_READY,
+							     &ar->flag),
+						    WMI_TIMEOUT);
+
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "firmware booted\n");
+
+	if (ar->version.abi_ver != ATH6KL_ABI_VERSION) {
+		ath6kl_err("abi version mismatch: host(0x%x), target(0x%x)\n",
+			   ATH6KL_ABI_VERSION, ar->version.abi_ver);
+		ret = -EIO;
+		goto err_htc_stop;
+	}
+
+	if (!timeleft || signal_pending(current)) {
+		ath6kl_err("wmi is not ready or wait was interrupted\n");
+		ret = -EIO;
+		goto err_htc_stop;
+	}
+
+	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: wmi is ready\n", __func__);
+
+	/* communicate the wmi protocol verision to the target */
+	/* FIXME: return error */
+	if ((ath6kl_set_host_app_area(ar)) != 0)
+		ath6kl_err("unable to set the host app area\n");
+
+	for (i = 0; i < MAX_NUM_VIF; i++) {
+		ret = ath6kl_target_config_wlan_params(ar, i);
+		if (ret)
+			goto err_htc_stop;
+	}
+
+	return 0;
+
+err_htc_stop:
+	ath6kl_htc_stop(ar->htc_target);
+err_cleanup_scatter:
+	ath6kl_hif_cleanup_scatter(ar);
+err_power_off:
+	ath6kl_hif_power_off(ar);
+
+	return ret;
+}
+
 int ath6kl_core_init(struct ath6kl *ar)
 {
 	struct ath6kl_bmi_target_info targ_info;
-	s32 timeleft;
 	struct net_device *ndev;
-	int i, ret = 0;
+	int ret = 0, i;
 
 	ar->ath6kl_wq = create_singlethread_workqueue("ath6kl");
 	if (!ar->ath6kl_wq)
@@ -1436,6 +1531,11 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (ret)
 		goto err_wq;
 
+	/*
+	 * Turn on power to get hardware (target) version and leave power
+	 * on delibrately as we will boot the hardware anyway within few
+	 * seconds.
+	 */
 	ret = ath6kl_hif_power_on(ar);
 	if (ret)
 		goto err_bmi_cleanup;
@@ -1452,10 +1552,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (ret)
 		goto err_power_off;
 
-	ret = ath6kl_configure_target(ar);
-	if (ret)
-		goto err_power_off;
-
 	ar->htc_target = ath6kl_htc_create(ar);
 
 	if (!ar->htc_target) {
@@ -1469,16 +1565,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	/* FIXME: we should free all firmwares in the error cases below */
 
-	ret = ath6kl_init_upload(ar);
-	if (ret)
-		goto err_htc_cleanup;
-
-	/* Do we need to finish the BMI phase */
-	if (ath6kl_bmi_done(ar)) {
-		ret = -EIO;
-		goto err_htc_cleanup;
-	}
-
 	/* Indicate that WMI is enabled (although not ready yet) */
 	set_bit(WMI_ENABLED, &ar->flag);
 	ar->wmi = ath6kl_wmi_init(ar);
@@ -1522,21 +1608,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
 			__func__, ndev->name, ndev, ar);
 
-	/*
-	 * The reason we have to wait for the target here is that the
-	 * driver layer has to init BMI in order to set the host block
-	 * size.
-	 */
-	if (ath6kl_htc_wait_target(ar->htc_target)) {
-		ret = -EIO;
-		goto err_if_deinit;
-	}
-
-	if (ath6kl_init_service_ep(ar)) {
-		ret = -EIO;
-		goto err_cleanup_scatter;
-	}
-
 	/* setup access class priority mappings */
 	ar->ac_stream_pri_map[WMM_AC_BK] = 0; /* lowest  */
 	ar->ac_stream_pri_map[WMM_AC_BE] = 1;
@@ -1550,54 +1621,17 @@ int ath6kl_core_init(struct ath6kl *ar)
 	/* allocate some buffers that handle larger AMSDU frames */
 	ath6kl_refill_amsdu_rxbufs(ar, ATH6KL_MAX_AMSDU_RX_BUFFERS);
 
-	/* setup credit distribution */
-	ath6kl_credit_setup(ar->htc_target, &ar->credit_state_info);
-
 	ath6kl_cookie_init(ar);
 
-	/* start HTC */
-	ret = ath6kl_htc_start(ar->htc_target);
-	if (ret) {
-		ath6kl_cookie_cleanup(ar);
-		goto err_rxbuf_cleanup;
-	}
-
-	/* Wait for Wmi event to be ready */
-	timeleft = wait_event_interruptible_timeout(ar->event_wq,
-						    test_bit(WMI_READY,
-							     &ar->flag),
-						    WMI_TIMEOUT);
-
-	ath6kl_dbg(ATH6KL_DBG_BOOT, "firmware booted\n");
-
-	if (ar->version.abi_ver != ATH6KL_ABI_VERSION) {
-		ath6kl_err("abi version mismatch: host(0x%x), target(0x%x)\n",
-			   ATH6KL_ABI_VERSION, ar->version.abi_ver);
-		ret = -EIO;
-		goto err_htc_stop;
-	}
-
-	if (!timeleft || signal_pending(current)) {
-		ath6kl_err("wmi is not ready or wait was interrupted\n");
-		ret = -EIO;
-		goto err_htc_stop;
-	}
-
-	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: wmi is ready\n", __func__);
-
-	/* communicate the wmi protocol verision to the target */
-	if ((ath6kl_set_host_app_area(ar)) != 0)
-		ath6kl_err("unable to set the host app area\n");
-
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 
-	for (i = 0; i < MAX_NUM_VIF; i++) {
-		ret = ath6kl_target_config_wlan_params(ar, i);
-		if (ret)
-			goto err_htc_stop;
+	ret = ath6kl_hw_start(ar);
+	if (ret) {
+		ath6kl_err("Failed to boot hardware: %d\n", ret);
+		goto err_rxbuf_cleanup;
 	}
 
 	/*
@@ -1608,14 +1642,9 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	return ret;
 
-err_htc_stop:
-	ath6kl_htc_stop(ar->htc_target);
 err_rxbuf_cleanup:
 	ath6kl_htc_flush_rx_buf(ar->htc_target);
 	ath6kl_cleanup_amsdu_rxbufs(ar);
-err_cleanup_scatter:
-	ath6kl_hif_cleanup_scatter(ar);
-err_if_deinit:
 	rtnl_lock();
 	ath6kl_deinit_if_data(netdev_priv(ndev));
 	rtnl_unlock();

