Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60722 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbcDFOqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:46:01 -0400
Subject: [PATCH 5/8] ath10k: move wmi_op_version to struct ath10k_fw_file
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 6 Apr 2016 17:45:41 +0300
Message-ID: <20160406144541.28399.11348.stgit@potku.adurom.net> (sfid-20160406_164607_208072_C8780A84)
In-Reply-To: <20160406144355.28399.23733.stgit@potku.adurom.net>
References: <20160406144355.28399.23733.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for testmode.c to use ath10k_core_fetch_board_data_api_n().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |   20 ++++++++++----------
 drivers/net/wireless/ath/ath10k/core.h     |    5 ++---
 drivers/net/wireless/ath/ath10k/debug.c    |    2 +-
 drivers/net/wireless/ath/ath10k/mac.c      |    2 +-
 drivers/net/wireless/ath/ath10k/testmode.c |   17 ++++++-----------
 drivers/net/wireless/ath/ath10k/wmi.c      |    4 ++--
 6 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bb8c8b2f785b..6d995219a497 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1106,10 +1106,10 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 
 			version = (__le32 *)data;
 
-			ar->wmi.op_version = le32_to_cpup(version);
+			fw_file->wmi_op_version = le32_to_cpup(version);
 
 			ath10k_dbg(ar, ATH10K_DBG_BOOT, "found fw ie wmi op version %d\n",
-				   ar->wmi.op_version);
+				   fw_file->wmi_op_version);
 			break;
 		case ATH10K_FW_IE_HTT_OP_VERSION:
 			if (ie_len != sizeof(u32))
@@ -1438,9 +1438,9 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		return -EINVAL;
 	}
 
-	if (ar->wmi.op_version >= ATH10K_FW_WMI_OP_VERSION_MAX) {
+	if (fw_file->wmi_op_version >= ATH10K_FW_WMI_OP_VERSION_MAX) {
 		ath10k_err(ar, "unsupported WMI OP version (max %d): %d\n",
-			   ATH10K_FW_WMI_OP_VERSION_MAX, ar->wmi.op_version);
+			   ATH10K_FW_WMI_OP_VERSION_MAX, fw_file->wmi_op_version);
 		return -EINVAL;
 	}
 
@@ -1496,19 +1496,19 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	/* Backwards compatibility for firmwares without
 	 * ATH10K_FW_IE_WMI_OP_VERSION.
 	 */
-	if (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_UNSET) {
+	if (fw_file->wmi_op_version == ATH10K_FW_WMI_OP_VERSION_UNSET) {
 		if (test_bit(ATH10K_FW_FEATURE_WMI_10X, fw_file->fw_features)) {
 			if (test_bit(ATH10K_FW_FEATURE_WMI_10_2,
 				     fw_file->fw_features))
-				ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_2;
+				fw_file->wmi_op_version = ATH10K_FW_WMI_OP_VERSION_10_2;
 			else
-				ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
+				fw_file->wmi_op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
 		} else {
-			ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_MAIN;
+			fw_file->wmi_op_version = ATH10K_FW_WMI_OP_VERSION_MAIN;
 		}
 	}
 
-	switch (ar->wmi.op_version) {
+	switch (fw_file->wmi_op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
 		ar->max_num_peers = TARGET_NUM_PEERS;
 		ar->max_num_stations = TARGET_NUM_STATIONS;
@@ -1570,7 +1570,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	 * ATH10K_FW_IE_HTT_OP_VERSION.
 	 */
 	if (ar->htt.op_version == ATH10K_FW_HTT_OP_VERSION_UNSET) {
-		switch (ar->wmi.op_version) {
+		switch (fw_file->wmi_op_version) {
 		case ATH10K_FW_WMI_OP_VERSION_MAIN:
 			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_MAIN;
 			break;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 649fb940eb9f..640733d6d7cc 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -139,7 +139,6 @@ struct ath10k_mem_chunk {
 };
 
 struct ath10k_wmi {
-	enum ath10k_fw_wmi_op_version op_version;
 	enum ath10k_htc_ep_id eid;
 	struct completion service_ready;
 	struct completion unified_ready;
@@ -634,6 +633,8 @@ struct ath10k_fw_file {
 
 	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
 
+	enum ath10k_fw_wmi_op_version wmi_op_version;
+
 	const void *firmware_data;
 	size_t firmware_len;
 
@@ -894,8 +895,6 @@ struct ath10k {
 	struct {
 		/* protected by conf_mutex */
 		struct ath10k_fw_components utf_mode_fw;
-		enum ath10k_fw_wmi_op_version orig_wmi_op_version;
-		enum ath10k_fw_wmi_op_version op_version;
 
 		/* protected by data_lock */
 		bool utf_monitor;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 07b15ffce220..f9e9a83eb7d0 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -178,7 +178,7 @@ void ath10k_debug_print_boot_info(struct ath10k *ar)
 	ath10k_info(ar, "htt-ver %d.%d wmi-op %d htt-op %d cal %s max-sta %d raw %d hwcrypto %d\n",
 		    ar->htt.target_version_major,
 		    ar->htt.target_version_minor,
-		    ar->wmi.op_version,
+		    ar->normal_mode_fw.fw_file.wmi_op_version,
 		    ar->htt.op_version,
 		    ath10k_cal_mode_str(ar->cal_mode),
 		    ar->max_num_stations,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5a78ab9624d7..8db397146eaf 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7760,7 +7760,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	 */
 	ar->hw->offchannel_tx_hw_queue = IEEE80211_MAX_QUEUES - 1;
 
-	switch (ar->wmi.op_version) {
+	switch (ar->running_fw->fw_file.wmi_op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
 		ar->hw->wiphy->iface_combinations = ath10k_if_comb;
 		ar->hw->wiphy->n_iface_combinations =
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index c2173a6d5676..2fcc7105e247 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -230,9 +230,9 @@ static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar,
 			if (ie_len != sizeof(u32))
 				break;
 			version = (__le32 *)data;
-			ar->testmode.op_version = le32_to_cpup(version);
+			fw_file->wmi_op_version = le32_to_cpup(version);
 			ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode found fw ie wmi op version %d\n",
-				   ar->testmode.op_version);
+				   fw_file->wmi_op_version);
 			break;
 		default:
 			ath10k_warn(ar, "Unknown testmode FW IE: %u\n",
@@ -283,7 +283,7 @@ static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar,
 	 * correct WMI interface.
 	 */
 
-	ar->testmode.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
+	fw_file->wmi_op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
 	fw_file->firmware_data = fw_file->firmware->data;
 	fw_file->firmware_len = fw_file->firmware->size;
 
@@ -359,17 +359,14 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 	ar->testmode.utf_monitor = true;
 	spin_unlock_bh(&ar->data_lock);
 
-	ar->testmode.orig_wmi_op_version = ar->wmi.op_version;
-	ar->wmi.op_version = ar->testmode.op_version;
-
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode wmi version %d\n",
-		   ar->wmi.op_version);
+		   ar->testmode.utf_mode_fw.fw_file.wmi_op_version);
 
 	ret = ath10k_hif_power_up(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to power up hif (testmode): %d\n", ret);
 		ar->state = ATH10K_STATE_OFF;
-		goto err_fw_features;
+		goto err_release_utf_mode_fw;
 	}
 
 	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_UTF,
@@ -396,9 +393,7 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 err_power_down:
 	ath10k_hif_power_down(ar);
 
-err_fw_features:
-	ar->wmi.op_version = ar->testmode.orig_wmi_op_version;
-
+err_release_utf_mode_fw:
 	release_firmware(ar->testmode.utf_mode_fw.fw_file.firmware);
 	ar->testmode.utf_mode_fw.fw_file.firmware = NULL;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 786f0635de53..21229ecc3d1a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7866,7 +7866,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 
 int ath10k_wmi_attach(struct ath10k *ar)
 {
-	switch (ar->wmi.op_version) {
+	switch (ar->running_fw->fw_file.wmi_op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
 		ar->wmi.ops = &wmi_10_4_ops;
 		ar->wmi.cmd = &wmi_10_4_cmd_map;
@@ -7908,7 +7908,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
 		ath10k_err(ar, "unsupported WMI op version: %d\n",
-			   ar->wmi.op_version);
+			   ar->running_fw->fw_file.wmi_op_version);
 		return -EINVAL;
 	}
 

