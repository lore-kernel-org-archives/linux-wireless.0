Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:38784 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1J0Pse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:48:34 -0400
Subject: [PATCH 05/10] ath6kl: merge ath6kl_init() to ath6kl_core_init()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:48:29 +0300
Message-ID: <20111027154829.23519.93667.stgit@localhost6.localdomain6> (sfid-20111027_174837_407560_C8134BFB)
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for splitting module initialisation and hardware boot
code from each other.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |  148 ++++++++++++++------------------
 1 files changed, 65 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 0564add..f5d0b99 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1421,20 +1421,62 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_init(struct ath6kl *ar)
+int ath6kl_core_init(struct ath6kl *ar)
 {
-	int status = 0;
+	struct ath6kl_bmi_target_info targ_info;
 	s32 timeleft;
 	struct net_device *ndev;
-	int i;
+	int i, ret = 0;
 
-	if (!ar)
-		return -EIO;
+	ar->ath6kl_wq = create_singlethread_workqueue("ath6kl");
+	if (!ar->ath6kl_wq)
+		return -ENOMEM;
+
+	ret = ath6kl_bmi_init(ar);
+	if (ret)
+		goto err_wq;
+
+	ret = ath6kl_hif_power_on(ar);
+	if (ret)
+		goto err_bmi_cleanup;
+
+	ret = ath6kl_bmi_get_target_info(ar, &targ_info);
+	if (ret)
+		goto err_power_off;
+
+	ar->version.target_ver = le32_to_cpu(targ_info.version);
+	ar->target_type = le32_to_cpu(targ_info.type);
+	ar->wiphy->hw_version = le32_to_cpu(targ_info.version);
+
+	ret = ath6kl_init_hw_params(ar);
+	if (ret)
+		goto err_power_off;
+
+	ret = ath6kl_configure_target(ar);
+	if (ret)
+		goto err_power_off;
+
+	ar->htc_target = ath6kl_htc_create(ar);
+
+	if (!ar->htc_target) {
+		ret = -ENOMEM;
+		goto err_power_off;
+	}
+
+	ret = ath6kl_fetch_firmwares(ar);
+	if (ret)
+		goto err_htc_cleanup;
+
+	/* FIXME: we should free all firmwares in the error cases below */
+
+	ret = ath6kl_init_upload(ar);
+	if (ret)
+		goto err_htc_cleanup;
 
 	/* Do we need to finish the BMI phase */
 	if (ath6kl_bmi_done(ar)) {
-		status = -EIO;
-		goto ath6kl_init_done;
+		ret = -EIO;
+		goto err_htc_cleanup;
 	}
 
 	/* Indicate that WMI is enabled (although not ready yet) */
@@ -1442,18 +1484,18 @@ static int ath6kl_init(struct ath6kl *ar)
 	ar->wmi = ath6kl_wmi_init(ar);
 	if (!ar->wmi) {
 		ath6kl_err("failed to initialize wmi\n");
-		status = -EIO;
-		goto ath6kl_init_done;
+		ret = -EIO;
+		goto err_htc_cleanup;
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: got wmi @ 0x%p.\n", __func__, ar->wmi);
 
-	status = ath6kl_register_ieee80211_hw(ar);
-	if (status)
+	ret = ath6kl_register_ieee80211_hw(ar);
+	if (ret)
 		goto err_node_cleanup;
 
-	status = ath6kl_debug_init(ar);
-	if (status) {
+	ret = ath6kl_debug_init(ar);
+	if (ret) {
 		wiphy_unregister(ar->wiphy);
 		goto err_node_cleanup;
 	}
@@ -1471,7 +1513,7 @@ static int ath6kl_init(struct ath6kl *ar)
 
 	if (!ndev) {
 		ath6kl_err("Failed to instantiate a network device\n");
-		status = -ENOMEM;
+		ret = -ENOMEM;
 		wiphy_unregister(ar->wiphy);
 		goto err_debug_init;
 	}
@@ -1486,12 +1528,12 @@ static int ath6kl_init(struct ath6kl *ar)
 	 * size.
 	 */
 	if (ath6kl_htc_wait_target(ar->htc_target)) {
-		status = -EIO;
+		ret = -EIO;
 		goto err_if_deinit;
 	}
 
 	if (ath6kl_init_service_ep(ar)) {
-		status = -EIO;
+		ret = -EIO;
 		goto err_cleanup_scatter;
 	}
 
@@ -1514,9 +1556,8 @@ static int ath6kl_init(struct ath6kl *ar)
 	ath6kl_cookie_init(ar);
 
 	/* start HTC */
-	status = ath6kl_htc_start(ar->htc_target);
-
-	if (status) {
+	ret = ath6kl_htc_start(ar->htc_target);
+	if (ret) {
 		ath6kl_cookie_cleanup(ar);
 		goto err_rxbuf_cleanup;
 	}
@@ -1532,13 +1573,13 @@ static int ath6kl_init(struct ath6kl *ar)
 	if (ar->version.abi_ver != ATH6KL_ABI_VERSION) {
 		ath6kl_err("abi version mismatch: host(0x%x), target(0x%x)\n",
 			   ATH6KL_ABI_VERSION, ar->version.abi_ver);
-		status = -EIO;
+		ret = -EIO;
 		goto err_htc_stop;
 	}
 
 	if (!timeleft || signal_pending(current)) {
 		ath6kl_err("wmi is not ready or wait was interrupted\n");
-		status = -EIO;
+		ret = -EIO;
 		goto err_htc_stop;
 	}
 
@@ -1554,8 +1595,8 @@ static int ath6kl_init(struct ath6kl *ar)
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 
 	for (i = 0; i < MAX_NUM_VIF; i++) {
-		status = ath6kl_target_config_wlan_params(ar, i);
-		if (status)
+		ret = ath6kl_target_config_wlan_params(ar, i);
+		if (ret)
 			goto err_htc_stop;
 	}
 
@@ -1565,7 +1606,7 @@ static int ath6kl_init(struct ath6kl *ar)
 	 */
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 
-	return status;
+	return ret;
 
 err_htc_stop:
 	ath6kl_htc_stop(ar->htc_target);
@@ -1585,65 +1626,6 @@ err_node_cleanup:
 	ath6kl_wmi_shutdown(ar->wmi);
 	clear_bit(WMI_ENABLED, &ar->flag);
 	ar->wmi = NULL;
-
-ath6kl_init_done:
-	return status;
-}
-
-int ath6kl_core_init(struct ath6kl *ar)
-{
-	int ret = 0;
-	struct ath6kl_bmi_target_info targ_info;
-
-	ar->ath6kl_wq = create_singlethread_workqueue("ath6kl");
-	if (!ar->ath6kl_wq)
-		return -ENOMEM;
-
-	ret = ath6kl_bmi_init(ar);
-	if (ret)
-		goto err_wq;
-
-	ret = ath6kl_hif_power_on(ar);
-	if (ret)
-		goto err_bmi_cleanup;
-
-	ret = ath6kl_bmi_get_target_info(ar, &targ_info);
-	if (ret)
-		goto err_power_off;
-
-	ar->version.target_ver = le32_to_cpu(targ_info.version);
-	ar->target_type = le32_to_cpu(targ_info.type);
-	ar->wiphy->hw_version = le32_to_cpu(targ_info.version);
-
-	ret = ath6kl_init_hw_params(ar);
-	if (ret)
-		goto err_power_off;
-
-	ret = ath6kl_configure_target(ar);
-	if (ret)
-		goto err_power_off;
-
-	ar->htc_target = ath6kl_htc_create(ar);
-
-	if (!ar->htc_target) {
-		ret = -ENOMEM;
-		goto err_power_off;
-	}
-
-	ret = ath6kl_fetch_firmwares(ar);
-	if (ret)
-		goto err_htc_cleanup;
-
-	ret = ath6kl_init_upload(ar);
-	if (ret)
-		goto err_htc_cleanup;
-
-	ret = ath6kl_init(ar);
-	if (ret)
-		goto err_htc_cleanup;
-
-	return ret;
-
 err_htc_cleanup:
 	ath6kl_htc_cleanup(ar->htc_target);
 err_power_off:

