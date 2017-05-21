Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33282 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756974AbdEUUBX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 16:01:23 -0400
Received: by mail-lf0-f68.google.com with SMTP id m18so3697241lfj.0
        for <linux-wireless@vger.kernel.org>; Sun, 21 May 2017 13:01:22 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 3/9] ath10k: per target configurablity of various items
Date: Sun, 21 May 2017 21:59:05 +0200
Message-Id: <1495396751-4805-4-git-send-email-erik.stromdahl@gmail.com> (sfid-20170521_220201_424401_A67E2DFC)
In-Reply-To: <1495396751-4805-1-git-send-email-erik.stromdahl@gmail.com>
References: <1495396751-4805-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added ability to set bus type and configure the max number of
peers in the ath10k_hw_params struct.

With this functionality it is possible to have a different
hw configuration depending on bus type for the same radio
chipset.

E.g. SDIO and USB devices using the same chipset as PCIe
devices will potentially use different board files and perhaps
other configuration parameters.

One such parameter is the max number of peers.
Instead of using a default value (suitable for PCIe devices)
derived from the WMI op version, a per target value can be
used instead.

This is needed by the QCA9377 USB device in order to prevent
the target fw to crash after HTT RX ring cfg is issued.

Apparently, the QCA9377 HL device does not seem to handle the
same amount of peers as the LL devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c    | 33 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath10k/core.h    |  7 -------
 drivers/net/wireless/ath/ath10k/hw.h      | 22 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  4 ++--
 4 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 627954e..0c46004 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1621,9 +1621,19 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	for (i = 0; i < ARRAY_SIZE(ath10k_hw_params_list); i++) {
 		hw_params = &ath10k_hw_params_list[i];
 
-		if (hw_params->id == ar->target_version &&
-		    hw_params->dev_id == ar->dev_id)
-			break;
+		if (ar->is_high_latency) {
+			/* High latency devices will use different fw depending
+			 * on if it is a USB or SDIO device.
+			 */
+			if (hw_params->bus == ar->hif.bus &&
+			    hw_params->id == ar->target_version &&
+			    hw_params->dev_id == ar->dev_id)
+				break;
+		} else {
+			if (hw_params->id == ar->target_version &&
+			    hw_params->dev_id == ar->dev_id)
+				break;
+		}
 	}
 
 	if (i == ARRAY_SIZE(ath10k_hw_params_list)) {
@@ -1722,6 +1732,7 @@ static void ath10k_core_set_coverage_class_work(struct work_struct *work)
 static int ath10k_core_init_firmware_features(struct ath10k *ar)
 {
 	struct ath10k_fw_file *fw_file = &ar->normal_mode_fw.fw_file;
+	int max_num_peers;
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, fw_file->fw_features) &&
 	    !test_bit(ATH10K_FW_FEATURE_WMI_10X, fw_file->fw_features)) {
@@ -1801,7 +1812,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 
 	switch (fw_file->wmi_op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
-		ar->max_num_peers = TARGET_NUM_PEERS;
+		max_num_peers = TARGET_NUM_PEERS;
 		ar->max_num_stations = TARGET_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_NUM_MSDU_DESC;
@@ -1813,10 +1824,10 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		if (ath10k_peer_stats_enabled(ar)) {
-			ar->max_num_peers = TARGET_10X_TX_STATS_NUM_PEERS;
+			max_num_peers = TARGET_10X_TX_STATS_NUM_PEERS;
 			ar->max_num_stations = TARGET_10X_TX_STATS_NUM_STATIONS;
 		} else {
-			ar->max_num_peers = TARGET_10X_NUM_PEERS;
+			max_num_peers = TARGET_10X_NUM_PEERS;
 			ar->max_num_stations = TARGET_10X_NUM_STATIONS;
 		}
 		ar->max_num_vdevs = TARGET_10X_NUM_VDEVS;
@@ -1825,7 +1836,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_TLV:
-		ar->max_num_peers = TARGET_TLV_NUM_PEERS;
+		max_num_peers = TARGET_TLV_NUM_PEERS;
 		ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_TLV_NUM_VDEVS;
 		ar->max_num_tdls_vdevs = TARGET_TLV_NUM_TDLS_VDEVS;
@@ -1836,7 +1847,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
-		ar->max_num_peers = TARGET_10_4_NUM_PEERS;
+		max_num_peers = TARGET_10_4_NUM_PEERS;
 		ar->max_num_stations = TARGET_10_4_NUM_STATIONS;
 		ar->num_active_peers = TARGET_10_4_ACTIVE_PEERS;
 		ar->max_num_vdevs = TARGET_10_4_NUM_VDEVS;
@@ -1853,10 +1864,16 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
+	default:
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
+	if (ar->hw_params.max_num_peers)
+		ar->max_num_peers = ar->hw_params.max_num_peers;
+	else
+		ar->max_num_peers = max_num_peers;
+
 	/* Backwards compatibility for firmwares without
 	 * ATH10K_FW_IE_HTT_OP_VERSION.
 	 */
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 90069b8..cdac923 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -88,13 +88,6 @@
 
 struct ath10k;
 
-enum ath10k_bus {
-	ATH10K_BUS_PCI,
-	ATH10K_BUS_AHB,
-	ATH10K_BUS_SDIO,
-	ATH10K_BUS_USB,
-};
-
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 {
 	switch (bus) {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d342728..160377aa 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -20,6 +20,13 @@
 
 #include "targaddrs.h"
 
+enum ath10k_bus {
+	ATH10K_BUS_PCI,
+	ATH10K_BUS_AHB,
+	ATH10K_BUS_SDIO,
+	ATH10K_BUS_USB,
+};
+
 #define ATH10K_FW_DIR			"ath10k"
 
 #define QCA988X_2_0_DEVICE_ID   (0x003c)
@@ -454,6 +461,18 @@ struct ath10k_hw_params {
 
 	/* Number of bytes to be discarded for each FFT sample */
 	int spectral_bin_discard;
+
+	/* max_num_peers can be used to override the setting derived from
+	 * the WMI op version. If this value is non-zero, it will always
+	 * be used instead of the default value derived from the WMI op
+	 * version.
+	 */
+	int max_num_peers;
+
+	/* Specifies whether or not the device is a high latency device */
+	bool is_high_latency;
+
+	enum ath10k_bus bus;
 };
 
 struct htt_rx_desc;
@@ -564,6 +583,9 @@ ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
 #define TARGET_TLV_NUM_WOW_PATTERNS		22
 
+/* Target specific defines for QCA9377 high latency firmware */
+#define TARGET_QCA9377_HL_NUM_PEERS		15
+
 /* Diagnostic Window */
 #define CE_DIAG_PIPE	7
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f918802..754d445 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1406,7 +1406,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
 
 	cfg->num_vdevs = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
-	cfg->num_peers = __cpu_to_le32(TARGET_TLV_NUM_PEERS);
+	cfg->num_peers = __cpu_to_le32(ar->max_num_peers);
 
 	if (test_bit(WMI_SERVICE_RX_FULL_REORDER, ar->wmi.svc_map)) {
 		cfg->num_offload_peers = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
@@ -1417,7 +1417,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	}
 
 	cfg->num_peer_keys = __cpu_to_le32(2);
-	cfg->num_tids = __cpu_to_le32(TARGET_TLV_NUM_TIDS);
+	cfg->num_tids = __cpu_to_le32(ar->max_num_peers * 2);
 	cfg->ast_skid_limit = __cpu_to_le32(0x10);
 	cfg->tx_chain_mask = __cpu_to_le32(0x7);
 	cfg->rx_chain_mask = __cpu_to_le32(0x7);
-- 
2.7.4
