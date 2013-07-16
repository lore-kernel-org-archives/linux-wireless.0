Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42644 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3GPHjL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:39:11 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 09/10] ath10k: store firmware files in memory
Date: Tue, 16 Jul 2013 09:38:58 +0200
Message-ID: <1373960339-8525-10-git-send-email-michal.kazior@tieto.com> (sfid-20130716_093923_913914_C883456C)
In-Reply-To: <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different FW versions may provide different
functions thus mean different hw capabilities
advertised to mac80211.

It is safe to swap firmware files on disk during
driver/device runtime without worries.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  157 +++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/core.h |    4 +
 2 files changed, 109 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1d4c245..c37f79f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -247,19 +247,11 @@ static int ath10k_push_board_ext_data(struct ath10k *ar,
 
 static int ath10k_download_board_data(struct ath10k *ar)
 {
+	const struct firmware *fw = ar->board_data;
 	u32 board_data_size = QCA988X_BOARD_DATA_SZ;
 	u32 address;
-	const struct firmware *fw;
 	int ret;
 
-	fw = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir,
-				  ar->hw_params.fw.board);
-	if (IS_ERR(fw)) {
-		ath10k_err("could not fetch board data fw file (%ld)\n",
-			   PTR_ERR(fw));
-		return PTR_ERR(fw);
-	}
-
 	ret = ath10k_push_board_ext_data(ar, fw);
 	if (ret) {
 		ath10k_err("could not push board ext data (%d)\n", ret);
@@ -286,32 +278,20 @@ static int ath10k_download_board_data(struct ath10k *ar)
 	}
 
 exit:
-	release_firmware(fw);
 	return ret;
 }
 
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
-	const struct firmware *fw;
-	u32 address;
+	const struct firmware *fw = ar->otp;
+	u32 address = ar->hw_params.patch_load_addr;
 	u32 exec_param;
 	int ret;
 
 	/* OTP is optional */
 
-	if (ar->hw_params.fw.otp == NULL) {
-		ath10k_info("otp file not defined\n");
-		return 0;
-	}
-
-	address = ar->hw_params.patch_load_addr;
-
-	fw = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir,
-				  ar->hw_params.fw.otp);
-	if (IS_ERR(fw)) {
-		ath10k_warn("could not fetch otp (%ld)\n", PTR_ERR(fw));
+	if (!ar->otp)
 		return 0;
-	}
 
 	ret = ath10k_bmi_fast_download(ar, address, fw->data, fw->size);
 	if (ret) {
@@ -327,28 +307,17 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	}
 
 exit:
-	release_firmware(fw);
 	return ret;
 }
 
 static int ath10k_download_fw(struct ath10k *ar)
 {
-	const struct firmware *fw;
+	const struct firmware *fw = ar->firmware;
 	u32 address;
 	int ret;
 
-	if (ar->hw_params.fw.fw == NULL)
-		return -EINVAL;
-
 	address = ar->hw_params.patch_load_addr;
 
-	fw = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir,
-				  ar->hw_params.fw.fw);
-	if (IS_ERR(fw)) {
-		ath10k_err("could not fetch fw (%ld)\n", PTR_ERR(fw));
-		return PTR_ERR(fw);
-	}
-
 	ret = ath10k_bmi_fast_download(ar, address, fw->data, fw->size);
 	if (ret) {
 		ath10k_err("could not write fw (%d)\n", ret);
@@ -356,7 +325,74 @@ static int ath10k_download_fw(struct ath10k *ar)
 	}
 
 exit:
-	release_firmware(fw);
+	return ret;
+}
+
+static void ath10k_core_free_firmware_files(struct ath10k *ar)
+{
+	if (ar->board_data && !IS_ERR(ar->board_data))
+		release_firmware(ar->board_data);
+
+	if (ar->otp && !IS_ERR(ar->otp))
+		release_firmware(ar->otp);
+
+	if (ar->firmware && !IS_ERR(ar->firmware))
+		release_firmware(ar->firmware);
+
+	ar->board_data = NULL;
+	ar->otp = NULL;
+	ar->firmware = NULL;
+}
+
+static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
+{
+	int ret = 0;
+
+	if (ar->hw_params.fw.fw == NULL) {
+		ath10k_err("firmware file not defined\n");
+		return -EINVAL;
+	}
+
+	if (ar->hw_params.fw.board == NULL) {
+		ath10k_err("board data file not defined");
+		return -EINVAL;
+	}
+
+	ar->board_data = ath10k_fetch_fw_file(ar,
+					      ar->hw_params.fw.dir,
+					      ar->hw_params.fw.board);
+	if (IS_ERR(ar->board_data)) {
+		ret = PTR_ERR(ar->board_data);
+		ath10k_err("could not fetch board data (%d)\n", ret);
+		goto err;
+	}
+
+	ar->firmware = ath10k_fetch_fw_file(ar,
+					    ar->hw_params.fw.dir,
+					    ar->hw_params.fw.fw);
+	if (IS_ERR(ar->firmware)) {
+		ret = PTR_ERR(ar->firmware);
+		ath10k_err("could not fetch firmware (%d)\n", ret);
+		goto err;
+	}
+
+	/* OTP may be undefined. If so, don't fetch it at all */
+	if (ar->hw_params.fw.otp == NULL)
+		return 0;
+
+	ar->otp = ath10k_fetch_fw_file(ar,
+				       ar->hw_params.fw.dir,
+				       ar->hw_params.fw.otp);
+	if (IS_ERR(ar->otp)) {
+		ret = PTR_ERR(ar->otp);
+		ath10k_err("could not fetch otp (%d)\n", ret);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	ath10k_core_free_firmware_files(ar);
 	return ret;
 }
 
@@ -502,23 +538,10 @@ EXPORT_SYMBOL(ath10k_core_destroy);
 
 int ath10k_core_start(struct ath10k *ar)
 {
-	struct bmi_target_info target_info;
 	int status;
 
 	ath10k_bmi_start(ar);
 
-	memset(&target_info, 0, sizeof(target_info));
-	status = ath10k_bmi_get_target_info(ar, &target_info);
-	if (status)
-		goto err;
-
-	ar->target_version = target_info.version;
-	ar->hw->wiphy->hw_version = target_info.version;
-
-	status = ath10k_init_hw_params(ar);
-	if (status)
-		goto err;
-
 	if (ath10k_init_configure_target(ar)) {
 		status = -EINVAL;
 		goto err;
@@ -617,7 +640,8 @@ EXPORT_SYMBOL(ath10k_core_stop);
  * hook will try to init it again) before registering */
 static int ath10k_core_probe_fw(struct ath10k *ar)
 {
-	int ret;
+	struct bmi_target_info target_info;
+	int ret = 0;
 
 	ret = ath10k_hif_power_up(ar);
 	if (ret) {
@@ -625,9 +649,35 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		return ret;
 	}
 
+	memset(&target_info, 0, sizeof(target_info));
+	ret = ath10k_bmi_get_target_info(ar, &target_info);
+	if (ret) {
+		ath10k_err("could not get target info (%d)\n", ret);
+		ath10k_hif_power_down(ar);
+		return ret;
+	}
+
+	ar->target_version = target_info.version;
+	ar->hw->wiphy->hw_version = target_info.version;
+
+	ret = ath10k_init_hw_params(ar);
+	if (ret) {
+		ath10k_err("could not get hw params (%d)\n", ret);
+		ath10k_hif_power_down(ar);
+		return ret;
+	}
+
+	ret = ath10k_core_fetch_firmware_files(ar);
+	if (ret) {
+		ath10k_err("could not fetch firmware files (%d)\n", ret);
+		ath10k_hif_power_down(ar);
+		return ret;
+	}
+
 	ret = ath10k_core_start(ar);
 	if (ret) {
 		ath10k_err("could not init core (%d)\n", ret);
+		ath10k_core_free_firmware_files(ar);
 		ath10k_hif_power_down(ar);
 		return ret;
 	}
@@ -650,7 +700,7 @@ int ath10k_core_register(struct ath10k *ar)
 	status = ath10k_mac_register(ar);
 	if (status) {
 		ath10k_err("could not register to mac80211 (%d)\n", status);
-		return status;
+		goto err_release_fw;
 	}
 
 	status = ath10k_debug_create(ar);
@@ -663,6 +713,8 @@ int ath10k_core_register(struct ath10k *ar)
 
 err_unregister_mac:
 	ath10k_mac_unregister(ar);
+err_release_fw:
+	ath10k_core_free_firmware_files(ar);
 	return status;
 }
 EXPORT_SYMBOL(ath10k_core_register);
@@ -673,6 +725,7 @@ void ath10k_core_unregister(struct ath10k *ar)
 	 * Otherwise we will fail to submit commands to FW and mac80211 will be
 	 * unhappy about callback failures. */
 	ath10k_mac_unregister(ar);
+	ath10k_core_free_firmware_files(ar);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 5c94ea0..413f1c5 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -300,6 +300,10 @@ struct ath10k {
 		} fw;
 	} hw_params;
 
+	const struct firmware *board_data;
+	const struct firmware *otp;
+	const struct firmware *firmware;
+
 	struct {
 		struct completion started;
 		struct completion completed;
-- 
1.7.9.5

