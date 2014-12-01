Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15486 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaLAOpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 09:45:30 -0500
Subject: [PATCH v3 2/7] ath10k: add ATH10K_FW_IE_WMI_OP_VERSION
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 1 Dec 2014 16:45:07 +0200
Message-ID: <20141201144507.18248.9856.stgit@potku.adurom.net> (sfid-20141201_154534_281529_1885044E)
In-Reply-To: <20141201144400.18248.62714.stgit@potku.adurom.net>
References: <20141201144400.18248.62714.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using feature flags, add new 32 bit variable for managing different
WMI versions. This makes it firmware interface tests a bit less convoluted,
especially when we add one more interface.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   30 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/core.h |    8 +++++---
 drivers/net/wireless/ath/ath10k/hw.h   |   10 ++++++++++
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index bd6315952ad0..f8ddc8087db9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -447,7 +447,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	int ie_id, i, index, bit, ret;
 	struct ath10k_fw_ie *hdr;
 	const u8 *data;
-	__le32 *timestamp;
+	__le32 *timestamp, *version;
 
 	/* first fetch the firmware file (firmware-*.bin) */
 	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
@@ -562,6 +562,17 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ar->otp_len = ie_len;
 
 			break;
+		case ATH10K_FW_IE_WMI_OP_VERSION:
+			if (ie_len != sizeof(u32))
+				break;
+
+			version = (__le32 *)data;
+
+			ar->wmi.op_version = le32_to_cpup(version);
+
+			ath10k_dbg(ar, ATH10K_DBG_BOOT, "found fw ie wmi op version %d\n",
+				   ar->wmi.op_version);
+			break;
 		default:
 			ath10k_warn(ar, "Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
@@ -801,11 +812,24 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	}
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		ar->max_num_peers = TARGET_10X_NUM_PEERS;
-		ar->max_num_stations = TARGET_10X_NUM_STATIONS;
+		if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
+			ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_2;
+		else
+			ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
 	} else {
+		ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_MAIN;
+	}
+
+	switch (ar->wmi.op_version) {
+	case ATH10K_FW_WMI_OP_VERSION_MAIN:
 		ar->max_num_peers = TARGET_NUM_PEERS;
 		ar->max_num_stations = TARGET_NUM_STATIONS;
+		break;
+	case ATH10K_FW_WMI_OP_VERSION_10_1:
+	case ATH10K_FW_WMI_OP_VERSION_10_2:
+		ar->max_num_peers = TARGET_10X_NUM_PEERS;
+		ar->max_num_stations = TARGET_10X_NUM_STATIONS;
+		break;
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 514c219263a5..92b04fe73151 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -120,6 +120,7 @@ struct ath10k_mem_chunk {
 };
 
 struct ath10k_wmi {
+	unsigned int op_version;
 	enum ath10k_htc_ep_id eid;
 	struct completion service_ready;
 	struct completion unified_ready;
@@ -369,7 +370,7 @@ enum ath10k_fw_features {
 	/* wmi_mgmt_rx_hdr contains extra RSSI information */
 	ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX = 0,
 
-	/* firmware from 10X branch */
+	/* Firmware from 10X branch. Deprecated, don't use in new code. */
 	ATH10K_FW_FEATURE_WMI_10X = 1,
 
 	/* firmware support tx frame management over WMI, otherwise it's HTT */
@@ -378,8 +379,9 @@ enum ath10k_fw_features {
 	/* Firmware does not support P2P */
 	ATH10K_FW_FEATURE_NO_P2P = 3,
 
-	/* Firmware 10.2 feature bit. The ATH10K_FW_FEATURE_WMI_10X feature bit
-	 * is required to be set as well.
+	/* Firmware 10.2 feature bit. The ATH10K_FW_FEATURE_WMI_10X feature
+	 * bit is required to be set as well. Deprecated, don't use in new
+	 * code.
 	 */
 	ATH10K_FW_FEATURE_WMI_10_2 = 4,
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index dfedfd0e0f34..04aaf9af3ca0 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -58,6 +58,16 @@ enum ath10k_fw_ie_type {
 	ATH10K_FW_IE_FEATURES = 2,
 	ATH10K_FW_IE_FW_IMAGE = 3,
 	ATH10K_FW_IE_OTP_IMAGE = 4,
+
+	/* WMI "operations" interface version, 32 bit value. Supported from
+	 * FW API 4 and above. */
+	ATH10K_FW_IE_WMI_OP_VERSION = 5,
+};
+
+enum ath10k_fw_wmi_op_version {
+	ATH10K_FW_WMI_OP_VERSION_MAIN = 0,
+	ATH10K_FW_WMI_OP_VERSION_10_1 = 1,
+	ATH10K_FW_WMI_OP_VERSION_10_2 = 2,
 };
 
 /* Known pecularities:

