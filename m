Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60722 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbcDFOqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:46:03 -0400
Subject: [PATCH 6/8] ath10k: move htt_op_version to struct ath10k_fw_file
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 6 Apr 2016 17:45:54 +0300
Message-ID: <20160406144553.28399.39763.stgit@potku.adurom.net> (sfid-20160406_164609_151774_94E67446)
In-Reply-To: <20160406144355.28399.23733.stgit@potku.adurom.net>
References: <20160406144355.28399.23733.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for testmode.c to use ath10k_core_fetch_board_data_api_n().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |   12 ++++++------
 drivers/net/wireless/ath/ath10k/core.h     |    1 +
 drivers/net/wireless/ath/ath10k/debug.c    |    2 +-
 drivers/net/wireless/ath/ath10k/htt.c      |    2 +-
 drivers/net/wireless/ath/ath10k/htt.h      |    1 -
 drivers/net/wireless/ath/ath10k/mac.c      |    2 +-
 drivers/net/wireless/ath/ath10k/testmode.c |    1 +
 7 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6d995219a497..4b1fc4b99205 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1117,10 +1117,10 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 
 			version = (__le32 *)data;
 
-			ar->htt.op_version = le32_to_cpup(version);
+			fw_file->htt_op_version = le32_to_cpup(version);
 
 			ath10k_dbg(ar, ATH10K_DBG_BOOT, "found fw ie htt op version %d\n",
-				   ar->htt.op_version);
+				   fw_file->htt_op_version);
 			break;
 		case ATH10K_FW_IE_FW_CODE_SWAP_IMAGE:
 			ath10k_dbg(ar, ATH10K_DBG_BOOT,
@@ -1569,18 +1569,18 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	/* Backwards compatibility for firmwares without
 	 * ATH10K_FW_IE_HTT_OP_VERSION.
 	 */
-	if (ar->htt.op_version == ATH10K_FW_HTT_OP_VERSION_UNSET) {
+	if (fw_file->htt_op_version == ATH10K_FW_HTT_OP_VERSION_UNSET) {
 		switch (fw_file->wmi_op_version) {
 		case ATH10K_FW_WMI_OP_VERSION_MAIN:
-			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_MAIN;
+			fw_file->htt_op_version = ATH10K_FW_HTT_OP_VERSION_MAIN;
 			break;
 		case ATH10K_FW_WMI_OP_VERSION_10_1:
 		case ATH10K_FW_WMI_OP_VERSION_10_2:
 		case ATH10K_FW_WMI_OP_VERSION_10_2_4:
-			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_10_1;
+			fw_file->htt_op_version = ATH10K_FW_HTT_OP_VERSION_10_1;
 			break;
 		case ATH10K_FW_WMI_OP_VERSION_TLV:
-			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
+			fw_file->htt_op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
 			break;
 		case ATH10K_FW_WMI_OP_VERSION_10_4:
 		case ATH10K_FW_WMI_OP_VERSION_UNSET:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 640733d6d7cc..b779e059a9c3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -634,6 +634,7 @@ struct ath10k_fw_file {
 	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
 
 	enum ath10k_fw_wmi_op_version wmi_op_version;
+	enum ath10k_fw_htt_op_version htt_op_version;
 
 	const void *firmware_data;
 	size_t firmware_len;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f9e9a83eb7d0..bcf6da2ffe95 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -179,7 +179,7 @@ void ath10k_debug_print_boot_info(struct ath10k *ar)
 		    ar->htt.target_version_major,
 		    ar->htt.target_version_minor,
 		    ar->normal_mode_fw.fw_file.wmi_op_version,
-		    ar->htt.op_version,
+		    ar->normal_mode_fw.fw_file.htt_op_version,
 		    ath10k_cal_mode_str(ar->cal_mode),
 		    ar->max_num_stations,
 		    test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags),
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index ee79512b1fcc..130cd9502021 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -183,7 +183,7 @@ int ath10k_htt_init(struct ath10k *ar)
 		8 + /* llc snap */
 		2; /* ip4 dscp or ip6 priority */
 
-	switch (ar->htt.op_version) {
+	switch (ar->running_fw->fw_file.htt_op_version) {
 	case ATH10K_FW_HTT_OP_VERSION_10_4:
 		ar->htt.t2h_msg_types = htt_10_4_t2h_msg_types;
 		ar->htt.t2h_msg_types_max = HTT_10_4_T2H_NUM_MSGS;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index ee7c8f8f8073..911c535d0863 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1562,7 +1562,6 @@ struct ath10k_htt {
 	u8 target_version_major;
 	u8 target_version_minor;
 	struct completion target_version_received;
-	enum ath10k_fw_htt_op_version op_version;
 	u8 max_num_amsdu;
 	u8 max_num_ampdu;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8db397146eaf..5f0c86b47e68 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3339,7 +3339,7 @@ bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
 	 */
 	return (ar->htt.target_version_major >= 3 &&
 		ar->htt.target_version_minor >= 4 &&
-		ar->htt.op_version == ATH10K_FW_HTT_OP_VERSION_TLV);
+		ar->running_fw->fw_file.htt_op_version == ATH10K_FW_HTT_OP_VERSION_TLV);
 }
 
 static int ath10k_mac_tx_wmi_mgmt(struct ath10k *ar, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 2fcc7105e247..2d9a3f56213f 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -284,6 +284,7 @@ static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar,
 	 */
 
 	fw_file->wmi_op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
+	fw_file->htt_op_version = ATH10K_FW_HTT_OP_VERSION_10_1;
 	fw_file->firmware_data = fw_file->firmware->data;
 	fw_file->firmware_len = fw_file->firmware->size;
 

