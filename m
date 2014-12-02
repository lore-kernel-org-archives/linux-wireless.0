Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58789 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaLBSLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:25 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so17585682wgh.23
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:23 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/26] iwlwifi: move firmware file format definitions to correct header
Date: Tue,  2 Dec 2014 20:10:52 +0200
Message-Id: <1417543877-24193-1-git-send-email-egrumbach@gmail.com> (sfid-20141202_191130_243770_BAE7B904)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware file-format is described in iwl-fw-file.h, while the
internal handling structures and functions are in iwl-fw.h.

Fix the separation between the files by moving file format
definitions to iwl-fw-file.h.

Also add a missing description for a kernel-doc member, and it's
not needed to include iwl-fw-file.h again from the code (thanks
to Liad Kaufman).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     |   3 -
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 183 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw.h      | 181 +---------------------------
 3 files changed, 184 insertions(+), 183 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index d9fa8e0..249ed3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -78,9 +78,6 @@
 #include "iwl-config.h"
 #include "iwl-modparams.h"
 
-/* private includes */
-#include "iwl-fw-file.h"
-
 /******************************************************************************
  *
  * module boiler plate
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 401f7be..df5613a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -179,4 +179,187 @@ struct iwl_ucode_capa {
 	__le32 api_capa;
 } __packed;
 
+/**
+ * enum iwl_ucode_tlv_flag - ucode API flags
+ * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
+ *	was a separate TLV but moved here to save space.
+ * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behaviour on hidden SSID,
+ *	treats good CRC threshold as a boolean
+ * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
+ * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
+ * @IWL_UCODE_TLV_FLAGS_DW_BC_TABLE: The SCD byte count table is in DWORDS
+ * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: This uCode image supports uAPSD
+ * @IWL_UCODE_TLV_FLAGS_SHORT_BL: 16 entries of black list instead of 64 in scan
+ *	offload profile config command.
+ * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
+ *	(rather than two) IPv6 addresses
+ * @IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID: not sending a probe with the SSID element
+ *	from the probe request template.
+ * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL: new NS offload (small version)
+ * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE: new NS offload (large version)
+ * @IWL_UCODE_TLV_FLAGS_P2P_PM: P2P client supports PM as a stand alone MAC
+ * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_DCM: support power save on BSS station and
+ *	P2P client interfaces simultaneously if they are in different bindings.
+ * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_SCM: support power save on BSS station and
+ *	P2P client interfaces simultaneously if they are in same bindings.
+ * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: General support for uAPSD
+ * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
+ * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
+ * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
+ * @IWL_UCODE_TLV_FLAGS_EBS_SUPPORT: this uCode image supports EBS.
+ */
+enum iwl_ucode_tlv_flag {
+	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
+	IWL_UCODE_TLV_FLAGS_NEWSCAN		= BIT(1),
+	IWL_UCODE_TLV_FLAGS_MFP			= BIT(2),
+	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
+	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
+	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
+	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
+	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
+	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL	= BIT(15),
+	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE	= BIT(16),
+	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
+	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
+	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM	= BIT(23),
+	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
+	IWL_UCODE_TLV_FLAGS_EBS_SUPPORT		= BIT(25),
+	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
+	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
+	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
+};
+
+/**
+ * enum iwl_ucode_tlv_api - ucode api
+ * @IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID: wowlan config includes tid field.
+ * @IWL_UCODE_TLV_CAPA_EXTENDED_BEACON: Support Extended beacon notification
+ * @IWL_UCODE_TLV_API_BT_COEX_SPLIT: new API for BT Coex
+ * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
+ * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
+ * @IWL_UCODE_TLV_API_LMAC_SCAN: This ucode uses LMAC unified scan API.
+ * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
+ * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
+ *	longer than the passive one, which is essential for fragmented scan.
+ */
+enum iwl_ucode_tlv_api {
+	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
+	IWL_UCODE_TLV_CAPA_EXTENDED_BEACON	= BIT(1),
+	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
+	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
+	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
+	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
+	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
+	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
+};
+
+/**
+ * enum iwl_ucode_tlv_capa - ucode capabilities
+ * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
+ * @IWL_UCODE_TLV_CAPA_LAR_SUPPORT: supports Location Aware Regulatory
+ * @IWL_UCODE_TLV_CAPA_UMAC_SCAN: supports UMAC scan.
+ * @IWL_UCODE_TLV_CAPA_TDLS_SUPPORT: support basic TDLS functionality
+ * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
+ *	tx power value into TPC Report action frame and Link Measurement Report
+ *	action frame
+ * @IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT: supports updating current
+ *	channel in DS parameter set element in probe requests.
+ * @IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT: supports adding TPC Report IE in
+ *	probe requests.
+ * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period requests
+ * @IWL_UCODE_TLV_CAPA_DQA_SUPPORT: supports dynamic queue allocation (DQA),
+ *	which also implies support for the scheduler configuration command
+ * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switching
+ * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
+ */
+enum iwl_ucode_tlv_capa {
+	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
+	IWL_UCODE_TLV_CAPA_LAR_SUPPORT			= BIT(1),
+	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= BIT(2),
+	IWL_UCODE_TLV_CAPA_TDLS_SUPPORT			= BIT(6),
+	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= BIT(8),
+	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= BIT(9),
+	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
+	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= BIT(11),
+	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= BIT(12),
+	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= BIT(13),
+	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
+};
+
+/* The default calibrate table size if not specified by firmware file */
+#define IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE	18
+#define IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE		19
+#define IWL_MAX_PHY_CALIBRATE_TBL_SIZE			253
+
+/* The default max probe length if not specified by the firmware file */
+#define IWL_DEFAULT_MAX_PROBE_LENGTH	200
+
+/*
+ * For 16.0 uCode and above, there is no differentiation between sections,
+ * just an offset to the HW address.
+ */
+#define IWL_UCODE_SECTION_MAX 12
+#define IWL_API_ARRAY_SIZE	1
+#define IWL_CAPABILITIES_ARRAY_SIZE	1
+#define CPU1_CPU2_SEPARATOR_SECTION	0xFFFFCCCC
+
+/* uCode version contains 4 values: Major/Minor/API/Serial */
+#define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
+#define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
+#define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
+#define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
+
+/*
+ * Calibration control struct.
+ * Sent as part of the phy configuration command.
+ * @flow_trigger: bitmap for which calibrations to perform according to
+ *		flow triggers.
+ * @event_trigger: bitmap for which calibrations to perform according to
+ *		event triggers.
+ */
+struct iwl_tlv_calib_ctrl {
+	__le32 flow_trigger;
+	__le32 event_trigger;
+} __packed;
+
+enum iwl_fw_phy_cfg {
+	FW_PHY_CFG_RADIO_TYPE_POS = 0,
+	FW_PHY_CFG_RADIO_TYPE = 0x3 << FW_PHY_CFG_RADIO_TYPE_POS,
+	FW_PHY_CFG_RADIO_STEP_POS = 2,
+	FW_PHY_CFG_RADIO_STEP = 0x3 << FW_PHY_CFG_RADIO_STEP_POS,
+	FW_PHY_CFG_RADIO_DASH_POS = 4,
+	FW_PHY_CFG_RADIO_DASH = 0x3 << FW_PHY_CFG_RADIO_DASH_POS,
+	FW_PHY_CFG_TX_CHAIN_POS = 16,
+	FW_PHY_CFG_TX_CHAIN = 0xf << FW_PHY_CFG_TX_CHAIN_POS,
+	FW_PHY_CFG_RX_CHAIN_POS = 20,
+	FW_PHY_CFG_RX_CHAIN = 0xf << FW_PHY_CFG_RX_CHAIN_POS,
+};
+
+#define IWL_UCODE_MAX_CS		1
+
+/**
+ * struct iwl_fw_cipher_scheme - a cipher scheme supported by FW.
+ * @cipher: a cipher suite selector
+ * @flags: cipher scheme flags (currently reserved for a future use)
+ * @hdr_len: a size of MPDU security header
+ * @pn_len: a size of PN
+ * @pn_off: an offset of pn from the beginning of the security header
+ * @key_idx_off: an offset of key index byte in the security header
+ * @key_idx_mask: a bit mask of key_idx bits
+ * @key_idx_shift: bit shift needed to get key_idx
+ * @mic_len: mic length in bytes
+ * @hw_cipher: a HW cipher index used in host commands
+ */
+struct iwl_fw_cipher_scheme {
+	__le32 cipher;
+	u8 flags;
+	u8 hdr_len;
+	u8 pn_len;
+	u8 pn_off;
+	u8 key_idx_off;
+	u8 key_idx_mask;
+	u8 key_idx_shift;
+	u8 mic_len;
+	u8 hw_cipher;
+} __packed;
+
 #endif  /* __iwl_fw_file_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 959a25a..eaf1ff0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -70,118 +70,6 @@
 #include "iwl-fw-file.h"
 
 /**
- * enum iwl_ucode_tlv_flag - ucode API flags
- * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
- *	was a separate TLV but moved here to save space.
- * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behaviour on hidden SSID,
- *	treats good CRC threshold as a boolean
- * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
- * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
- * @IWL_UCODE_TLV_FLAGS_DW_BC_TABLE: The SCD byte count table is in DWORDS
- * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: This uCode image supports uAPSD
- * @IWL_UCODE_TLV_FLAGS_SHORT_BL: 16 entries of black list instead of 64 in scan
- *	offload profile config command.
- * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
- *	(rather than two) IPv6 addresses
- * @IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID: not sending a probe with the SSID element
- *	from the probe request template.
- * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL: new NS offload (small version)
- * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE: new NS offload (large version)
- * @IWL_UCODE_TLV_FLAGS_P2P_PM: P2P client supports PM as a stand alone MAC
- * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_DCM: support power save on BSS station and
- *	P2P client interfaces simultaneously if they are in different bindings.
- * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_SCM: support power save on BSS station and
- *	P2P client interfaces simultaneously if they are in same bindings.
- * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: General support for uAPSD
- * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
- * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
- * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
- * @IWL_UCODE_TLV_FLAGS_EBS_SUPPORT: this uCode image supports EBS.
- */
-enum iwl_ucode_tlv_flag {
-	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
-	IWL_UCODE_TLV_FLAGS_NEWSCAN		= BIT(1),
-	IWL_UCODE_TLV_FLAGS_MFP			= BIT(2),
-	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
-	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
-	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
-	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
-	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
-	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL	= BIT(15),
-	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE	= BIT(16),
-	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
-	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
-	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM	= BIT(23),
-	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
-	IWL_UCODE_TLV_FLAGS_EBS_SUPPORT		= BIT(25),
-	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
-	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
-	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
-};
-
-/**
- * enum iwl_ucode_tlv_api - ucode api
- * @IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID: wowlan config includes tid field.
- * @IWL_UCODE_TLV_CAPA_EXTENDED_BEACON: Support Extended beacon notification
- * @IWL_UCODE_TLV_API_BT_COEX_SPLIT: new API for BT Coex
- * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
- * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
- * @IWL_UCODE_TLV_API_LMAC_SCAN: This ucode uses LMAC unified scan API.
- * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
- * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
- *	longer than the passive one, which is essential for fragmented scan.
- */
-enum iwl_ucode_tlv_api {
-	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
-	IWL_UCODE_TLV_CAPA_EXTENDED_BEACON	= BIT(1),
-	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
-	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
-	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
-	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
-	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
-	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
-};
-
-/**
- * enum iwl_ucode_tlv_capa - ucode capabilities
- * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
- * @IWL_UCODE_TLV_CAPA_UMAC_SCAN: supports UMAC scan.
- * @IWL_UCODE_TLV_CAPA_TDLS_SUPPORT: support basic TDLS functionality
- * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
- *	tx power value into TPC Report action frame and Link Measurement Report
- *	action frame
- * @IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT: supports updating current
- *	channel in DS parameter set element in probe requests.
- * @IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT: supports adding TPC Report IE in
- *	probe requests.
- * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period requests
- * @IWL_UCODE_TLV_CAPA_DQA_SUPPORT: supports dynamic queue allocation (DQA),
- *	which also implies support for the scheduler configuration command
- * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switching
- * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
- */
-enum iwl_ucode_tlv_capa {
-	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
-	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= BIT(2),
-	IWL_UCODE_TLV_CAPA_TDLS_SUPPORT			= BIT(6),
-	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= BIT(8),
-	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= BIT(9),
-	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
-	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= BIT(11),
-	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= BIT(12),
-	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= BIT(13),
-	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
-};
-
-/* The default calibrate table size if not specified by firmware file */
-#define IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE	18
-#define IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE		19
-#define IWL_MAX_PHY_CALIBRATE_TBL_SIZE			253
-
-/* The default max probe length if not specified by the firmware file */
-#define IWL_DEFAULT_MAX_PROBE_LENGTH	200
-
-/**
  * enum iwl_ucode_type
  *
  * The type of ucode.
@@ -208,14 +96,6 @@ enum iwl_ucode_sec {
 	IWL_UCODE_SECTION_DATA,
 	IWL_UCODE_SECTION_INST,
 };
-/*
- * For 16.0 uCode and above, there is no differentiation between sections,
- * just an offset to the HW address.
- */
-#define IWL_UCODE_SECTION_MAX 12
-#define IWL_API_ARRAY_SIZE	1
-#define IWL_CAPABILITIES_ARRAY_SIZE	1
-#define CPU1_CPU2_SEPARATOR_SECTION	0xFFFFCCCC
 
 struct iwl_ucode_capabilities {
 	u32 max_probe_length;
@@ -243,66 +123,6 @@ struct iwl_sf_region {
 	u32 size;
 };
 
-/* uCode version contains 4 values: Major/Minor/API/Serial */
-#define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
-#define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
-#define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
-#define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
-
-/*
- * Calibration control struct.
- * Sent as part of the phy configuration command.
- * @flow_trigger: bitmap for which calibrations to perform according to
- *		flow triggers.
- * @event_trigger: bitmap for which calibrations to perform according to
- *		event triggers.
- */
-struct iwl_tlv_calib_ctrl {
-	__le32 flow_trigger;
-	__le32 event_trigger;
-} __packed;
-
-enum iwl_fw_phy_cfg {
-	FW_PHY_CFG_RADIO_TYPE_POS = 0,
-	FW_PHY_CFG_RADIO_TYPE = 0x3 << FW_PHY_CFG_RADIO_TYPE_POS,
-	FW_PHY_CFG_RADIO_STEP_POS = 2,
-	FW_PHY_CFG_RADIO_STEP = 0x3 << FW_PHY_CFG_RADIO_STEP_POS,
-	FW_PHY_CFG_RADIO_DASH_POS = 4,
-	FW_PHY_CFG_RADIO_DASH = 0x3 << FW_PHY_CFG_RADIO_DASH_POS,
-	FW_PHY_CFG_TX_CHAIN_POS = 16,
-	FW_PHY_CFG_TX_CHAIN = 0xf << FW_PHY_CFG_TX_CHAIN_POS,
-	FW_PHY_CFG_RX_CHAIN_POS = 20,
-	FW_PHY_CFG_RX_CHAIN = 0xf << FW_PHY_CFG_RX_CHAIN_POS,
-};
-
-#define IWL_UCODE_MAX_CS		1
-
-/**
- * struct iwl_fw_cipher_scheme - a cipher scheme supported by FW.
- * @cipher: a cipher suite selector
- * @flags: cipher scheme flags (currently reserved for a future use)
- * @hdr_len: a size of MPDU security header
- * @pn_len: a size of PN
- * @pn_off: an offset of pn from the beginning of the security header
- * @key_idx_off: an offset of key index byte in the security header
- * @key_idx_mask: a bit mask of key_idx bits
- * @key_idx_shift: bit shift needed to get key_idx
- * @mic_len: mic length in bytes
- * @hw_cipher: a HW cipher index used in host commands
- */
-struct iwl_fw_cipher_scheme {
-	__le32 cipher;
-	u8 flags;
-	u8 hdr_len;
-	u8 pn_len;
-	u8 pn_off;
-	u8 key_idx_off;
-	u8 key_idx_mask;
-	u8 key_idx_shift;
-	u8 mic_len;
-	u8 hw_cipher;
-} __packed;
-
 /**
  * struct iwl_fw_cscheme_list - a cipher scheme list
  * @size: a number of entries
@@ -329,6 +149,7 @@ struct iwl_fw_cscheme_list {
  * @inst_errlog_ptr: error log offfset for runtime ucode.
  * @mvm_fw: indicates this is MVM firmware
  * @cipher_scheme: optional external cipher scheme.
+ * @human_readable: human readable version
  */
 struct iwl_fw {
 	u32 ucode_ver;
-- 
1.9.1

