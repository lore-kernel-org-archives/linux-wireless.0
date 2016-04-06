Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64092 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbcDFOpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:45:24 -0400
Subject: [PATCH 3/8] ath10k: move fw_version inside struct ath10k_fw_file
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 6 Apr 2016 17:45:13 +0300
Message-ID: <20160406144512.28399.42338.stgit@potku.adurom.net> (sfid-20160406_164546_714094_0409C905)
In-Reply-To: <20160406144355.28399.23733.stgit@potku.adurom.net>
References: <20160406144355.28399.23733.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for testmode.c to use ath10k_core_fetch_board_data_api_n().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |   13 +++++++++----
 drivers/net/wireless/ath/ath10k/core.h     |    3 ++-
 drivers/net/wireless/ath/ath10k/testmode.c |   12 ++++++------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c4a36661cb17..9f783d35d9f5 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1039,15 +1039,15 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 
 		switch (ie_id) {
 		case ATH10K_FW_IE_FW_VERSION:
-			if (ie_len > sizeof(ar->hw->wiphy->fw_version) - 1)
+			if (ie_len > sizeof(fw_file->fw_version) - 1)
 				break;
 
-			memcpy(ar->hw->wiphy->fw_version, data, ie_len);
-			ar->hw->wiphy->fw_version[ie_len] = '\0';
+			memcpy(fw_file->fw_version, data, ie_len);
+			fw_file->fw_version[ie_len] = '\0';
 
 			ath10k_dbg(ar, ATH10K_DBG_BOOT,
 				   "found fw version %s\n",
-				    ar->hw->wiphy->fw_version);
+				    fw_file->fw_version);
 			break;
 		case ATH10K_FW_IE_TIMESTAMP:
 			if (ie_len != sizeof(u32))
@@ -1867,6 +1867,11 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_power_down;
 	}
 
+	BUILD_BUG_ON(sizeof(ar->hw->wiphy->fw_version) !=
+		     sizeof(ar->normal_mode_fw.fw_file.fw_version));
+	memcpy(ar->hw->wiphy->fw_version, ar->normal_mode_fw.fw_file.fw_version,
+	       sizeof(ar->hw->wiphy->fw_version));
+
 	ath10k_debug_print_hwfw_info(ar);
 
 	ret = ath10k_core_pre_cal_download(ar);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ff3d92d7dc8d..3626069a4fd6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -630,6 +630,8 @@ enum ath10k_tx_pause_reason {
 struct ath10k_fw_file {
 	const struct firmware *firmware;
 
+	char fw_version[ETHTOOL_FWVERS_LEN];
+
 	const void *firmware_data;
 	size_t firmware_len;
 
@@ -892,7 +894,6 @@ struct ath10k {
 	struct {
 		/* protected by conf_mutex */
 		struct ath10k_fw_components utf_mode_fw;
-		char utf_version[32];
 		DECLARE_BITMAP(orig_fw_features, ATH10K_FW_FEATURE_COUNT);
 		enum ath10k_fw_wmi_op_version orig_wmi_op_version;
 		enum ath10k_fw_wmi_op_version op_version;
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index e80aa4eeed05..64e3d5f0d3ac 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -205,15 +205,15 @@ static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar,
 
 		switch (ie_id) {
 		case ATH10K_FW_IE_FW_VERSION:
-			if (ie_len > sizeof(ar->testmode.utf_version) - 1)
+			if (ie_len > sizeof(fw_file->fw_version) - 1)
 				break;
 
-			memcpy(ar->testmode.utf_version, data, ie_len);
-			ar->testmode.utf_version[ie_len] = '\0';
+			memcpy(fw_file->fw_version, data, ie_len);
+			fw_file->fw_version[ie_len] = '\0';
 
 			ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
 				   "testmode found fw utf version %s\n",
-				   ar->testmode.utf_version);
+				   fw_file->fw_version);
 			break;
 		case ATH10K_FW_IE_TIMESTAMP:
 			/* ignore timestamp, but don't warn about it either */
@@ -388,8 +388,8 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 
 	ar->state = ATH10K_STATE_UTF;
 
-	if (strlen(ar->testmode.utf_version) > 0)
-		ver = ar->testmode.utf_version;
+	if (strlen(ar->testmode.utf_mode_fw.fw_file.fw_version) > 0)
+		ver = ar->testmode.utf_mode_fw.fw_file.fw_version;
 	else
 		ver = "API 1";
 

