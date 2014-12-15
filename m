Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10749 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaLOFMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 00:12:42 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/5] ath10k: add 10.2.4 firmware support
Date: Mon, 15 Dec 2014 10:41:10 +0530
Message-ID: <1418620274-3081-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141215_061244_632445_DEC7038B)
In-Reply-To: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.2.4 firmware uses bitmask in wmi_resource_config to configure
10.2 firmware features like airtime fairness and rx batch mode instead
of maintaining separete bool entry. This allows new features that can be
configure during init time without breaking backward compatibility.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 +++++++-
 drivers/net/wireless/ath/ath10k/core.h | 5 +++++
 drivers/net/wireless/ath/ath10k/hw.h   | 1 +
 drivers/net/wireless/ath/ath10k/wmi.c  | 1 +
 drivers/net/wireless/ath/ath10k/wmi.h  | 7 ++++++-
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 577a3d7..c05841e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -894,7 +894,12 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	 */
 	if (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_UNSET) {
 		if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-			if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
+			if (test_bit(ATH10K_FW_FEATURE_WMI_10_2_4,
+				     ar->fw_features))
+				ar->wmi.op_version =
+					ATH10K_FW_WMI_OP_VERSION_10_2_4;
+			else if (test_bit(ATH10K_FW_FEATURE_WMI_10_2,
+					  ar->fw_features))
 				ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_2;
 			else
 				ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
@@ -911,6 +916,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
+	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->max_num_peers = TARGET_10X_NUM_PEERS;
 		ar->max_num_stations = TARGET_10X_NUM_STATIONS;
 		ar->htt.max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 613355c..8083b91 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -387,6 +387,11 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_WMI_10_2 = 4,
 
+	/* Firmware 10.2.4 supports bitmask in resource config to configure
+	 * Airtime fairness and rx batch mode
+	 */
+	ATH10K_FW_FEATURE_WMI_10_2_4 = 5,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 809c252..892b6f0 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -72,6 +72,7 @@ enum ath10k_fw_wmi_op_version {
 	ATH10K_FW_WMI_OP_VERSION_10_1 = 2,
 	ATH10K_FW_WMI_OP_VERSION_10_2 = 3,
 	ATH10K_FW_WMI_OP_VERSION_TLV = 4,
+	ATH10K_FW_WMI_OP_VERSION_10_2_4 = 5,
 
 	/* keep last */
 	ATH10K_FW_WMI_OP_VERSION_MAX,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fa486f6..c42382c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4748,6 +4748,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 int ath10k_wmi_attach(struct ath10k *ar)
 {
 	switch (ar->wmi.op_version) {
+	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 		ar->wmi.cmd = &wmi_10_2_cmd_map;
 		ar->wmi.ops = &wmi_10_2_ops;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 97f902f..ce517bf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1940,6 +1940,11 @@ struct wmi_resource_config_10x {
 	__le32 max_frag_entries;
 } __packed;
 
+enum wmi_10_2_feature_mask {
+	WMI_10_2_RX_BATCH_MODE = BIT(0),
+	WMI_10_2_ATF_CONFIG    = BIT(1),
+};
+
 struct wmi_resource_config_10_2 {
 	struct wmi_resource_config_10x common;
 	__le32 max_peer_ext_stats;
@@ -1948,7 +1953,7 @@ struct wmi_resource_config_10_2 {
 	__le32 be_min_free;
 	__le32 vi_min_free;
 	__le32 vo_min_free;
-	__le32 rx_batchmode; /* 0-disable, 1-enable */
+	__le32 feature_mask;
 } __packed;
 
 #define NUM_UNITS_IS_NUM_VDEVS   0x1
-- 
2.1.3

