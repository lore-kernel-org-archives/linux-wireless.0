Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34802 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab1DERBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/25] iwlagn: add feature flags
Date: Tue,  5 Apr 2011 09:42:02 -0700
Message-Id: <1302021732-21250-16-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some new devices and microcode files will a greater
variety of features, so the TLV-per-feature approach
we took before will quickly make things harder to
manage and increase the file size.

Add a new TLV that has feature flags. Currently, it
will contain:
 1) a PAN feature flag, which moves from a separate
    TLV
 2) a new BT stats bit that indicates whether the
    microcode image uses bluetooth statistics
 3) a new MFP flag for management frame protection
    which can be enabled once the device/microcode
    supports it

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   29 ++++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   17 +++++++++++++++++
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cebcfb1..7ff95ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1189,7 +1189,7 @@ static void iwl_nic_start(struct iwl_priv *priv)
 struct iwlagn_ucode_capabilities {
 	u32 max_probe_length;
 	u32 standard_phy_calibration_size;
-	bool pan;
+	u32 flags;
 };
 
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
@@ -1416,7 +1416,23 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 		case IWL_UCODE_TLV_PAN:
 			if (tlv_len)
 				goto invalid_tlv_len;
-			capa->pan = true;
+			capa->flags |= IWL_UCODE_TLV_FLAGS_PAN;
+			break;
+		case IWL_UCODE_TLV_FLAGS:
+			/* must be at least one u32 */
+			if (tlv_len < sizeof(u32))
+				goto invalid_tlv_len;
+			/* and a proper number of u32s */
+			if (tlv_len % sizeof(u32))
+				goto invalid_tlv_len;
+			/*
+			 * This driver only reads the first u32 as
+			 * right now no more features are defined,
+			 * if that changes then either the driver
+			 * will not work with the new firmware, or
+			 * it'll not take advantage of new features.
+			 */
+			capa->flags = le32_to_cpup((__le32 *)tlv_data);
 			break;
 		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
 			if (tlv_len != sizeof(u32))
@@ -1679,12 +1695,16 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			priv->cfg->base_params->max_event_log_size;
 	priv->_agn.inst_errlog_ptr = pieces.inst_errlog_ptr;
 
-	if (ucode_capa.pan) {
+	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 	} else
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 
+	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BTSTATS ||
+	    (priv->cfg->bt_params && priv->cfg->bt_params->bt_statistics))
+		priv->bt_statistics = true;
+
 	/* Copy images into buffers for card's bus-master reads ... */
 
 	/* Runtime instructions (first block of data in file) */
@@ -2824,6 +2844,9 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
+	if (capa->flags & IWL_UCODE_TLV_FLAGS_MFP)
+		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
+
 	hw->sta_data_size = sizeof(struct iwl_station_priv);
 	hw->vif_data_size = sizeof(struct iwl_vif_priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 696b056..7b9f64e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -723,7 +723,7 @@ static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 
 static inline bool iwl_bt_statistics(struct iwl_priv *priv)
 {
-	return priv->cfg->bt_params && priv->cfg->bt_params->bt_statistics;
+	return priv->bt_statistics;
 }
 
 extern bool bt_coex_active;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3a12a45..f69b9e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -534,6 +534,22 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_INIT_ERRLOG_PTR	= 13,
 	IWL_UCODE_TLV_ENHANCE_SENS_TBL	= 14,
 	IWL_UCODE_TLV_PHY_CALIBRATION_SIZE = 15,
+	/* 16 and 17 reserved for future use */
+	IWL_UCODE_TLV_FLAGS		= 18,
+};
+
+/**
+ * enum iwl_ucode_tlv_flag - ucode API flags
+ * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
+ *	was a separate TLV but moved here to save space.
+ * @IWL_UCODE_TLV_FLAGS_BTSTATS: This uCode image uses BT statistics, which
+ *	may be true even if the device doesn't have BT.
+ * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
+ */
+enum iwl_ucode_tlv_flag {
+	IWL_UCODE_TLV_FLAGS_PAN		= BIT(0),
+	IWL_UCODE_TLV_FLAGS_BTSTATS	= BIT(1),
+	IWL_UCODE_TLV_FLAGS_MFP		= BIT(2),
 };
 
 struct iwl_ucode_tlv {
@@ -1410,6 +1426,7 @@ struct iwl_priv {
 	bool bt_ch_announce;
 	bool bt_full_concurrent;
 	bool bt_ant_couple_ok;
+	bool bt_statistics;
 	__le32 kill_ack_mask;
 	__le32 kill_cts_mask;
 	__le16 bt_valid;
-- 
1.7.0.4

