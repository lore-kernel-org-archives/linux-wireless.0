Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbbCLNFr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/49] iwlwifi: mvm: take the MAC address from HW registers
Date: Thu, 12 Mar 2015 15:04:02 +0200
Message-Id: <1426165474-25586-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140554_368634_B576A5A9)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

For some configurations, the driver should get the MAC
address from the hardware registers and not from the
regular locations. Since the parsing of the MAC address
is the same regardless of its source, continue the regular
code path (parsing) after we read the registers.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h   |   2 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |  61 +++--------
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h |   3 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h      |   8 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h    | 150 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |  73 ++++++++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  14 ++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c       |  79 +++++++-------
 drivers/net/wireless/iwlwifi/mvm/ops.c       |   2 +-
 9 files changed, 225 insertions(+), 167 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 5ea3818..81c2f48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -244,6 +244,7 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
+ * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
  * IWL_UCODE_TLV_API_HDC_PHASE_0: ucode supports finer configuration of LTR
  * @IWL_UCODE_TLV_API_BASIC_DWELL: use only basic dwell time in scan command,
  *	regardless of the band or the number of the probes. FW will calculate
@@ -261,6 +262,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
 	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
+	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= BIT(9),
 	IWL_UCODE_TLV_API_HDC_PHASE_0		= BIT(10),
 	IWL_UCODE_TLV_API_BASIC_DWELL		= BIT(13),
 	IWL_UCODE_TLV_API_SCD_CFG		= BIT(15),
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index d9423ed..54e447b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -542,7 +542,8 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 					   const struct iwl_cfg *cfg,
 					   struct iwl_nvm_data *data,
 					   const __le16 *mac_override,
-					   const __le16 *nvm_hw)
+					   const __le16 *nvm_hw,
+					   u32 mac_addr0, u32 mac_addr1)
 {
 	const u8 *hw_addr;
 
@@ -566,48 +567,17 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 	}
 
 	if (nvm_hw) {
-		/* read the MAC address from OTP */
-		if (!dev_is_pci(dev) || (data->nvm_version < 0xE08)) {
-			/* read the mac address from the WFPM location */
-			hw_addr = (const u8 *)(nvm_hw +
-					       HW_ADDR0_WFPM_FAMILY_8000);
-			data->hw_addr[0] = hw_addr[3];
-			data->hw_addr[1] = hw_addr[2];
-			data->hw_addr[2] = hw_addr[1];
-			data->hw_addr[3] = hw_addr[0];
-
-			hw_addr = (const u8 *)(nvm_hw +
-					       HW_ADDR1_WFPM_FAMILY_8000);
-			data->hw_addr[4] = hw_addr[1];
-			data->hw_addr[5] = hw_addr[0];
-		} else if ((data->nvm_version >= 0xE08) &&
-			   (data->nvm_version < 0xE0B)) {
-			/* read "reverse order"  from the PCIe location */
-			hw_addr = (const u8 *)(nvm_hw +
-					       HW_ADDR0_PCIE_FAMILY_8000);
-			data->hw_addr[5] = hw_addr[2];
-			data->hw_addr[4] = hw_addr[1];
-			data->hw_addr[3] = hw_addr[0];
-
-			hw_addr = (const u8 *)(nvm_hw +
-					       HW_ADDR1_PCIE_FAMILY_8000);
-			data->hw_addr[2] = hw_addr[3];
-			data->hw_addr[1] = hw_addr[2];
-			data->hw_addr[0] = hw_addr[1];
-		} else {
-			/* read from the PCIe location */
-			hw_addr = (const u8 *)(nvm_hw +
-					       HW_ADDR0_PCIE_FAMILY_8000);
-			data->hw_addr[5] = hw_addr[0];
-			data->hw_addr[4] = hw_addr[1];
-			data->hw_addr[3] = hw_addr[2];
-
-			hw_addr = (const u8 *)(nvm_hw +
-					       HW_ADDR1_PCIE_FAMILY_8000);
-			data->hw_addr[2] = hw_addr[1];
-			data->hw_addr[1] = hw_addr[2];
-			data->hw_addr[0] = hw_addr[3];
-		}
+		/* read the MAC address from HW resisters */
+		hw_addr = (const u8 *)&mac_addr0;
+		data->hw_addr[0] = hw_addr[3];
+		data->hw_addr[1] = hw_addr[2];
+		data->hw_addr[2] = hw_addr[1];
+		data->hw_addr[3] = hw_addr[0];
+
+		hw_addr = (const u8 *)&mac_addr1;
+		data->hw_addr[4] = hw_addr[1];
+		data->hw_addr[5] = hw_addr[0];
+
 		if (!is_valid_ether_addr(data->hw_addr))
 			IWL_ERR_DEV(dev,
 				    "mac address from hw section is not valid\n");
@@ -624,7 +594,8 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
 		   u8 tx_chains, u8 rx_chains,
-		   bool lar_fw_supported, bool is_family_8000_a_step)
+		   bool lar_fw_supported, bool is_family_8000_a_step,
+		   u32 mac_addr0, u32 mac_addr1)
 {
 	struct iwl_nvm_data *data;
 	u32 sku;
@@ -692,7 +663,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 
 		/* MAC address in family 8000 */
 		iwl_set_hw_address_family_8000(dev, cfg, data, mac_override,
-					       nvm_hw);
+					       nvm_hw, mac_addr0, mac_addr1);
 
 		iwl_init_sbands(dev, cfg, data, regulatory,
 				tx_chains, rx_chains,
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index 18c3ff2..c995d2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -79,7 +79,8 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
 		   u8 tx_chains, u8 rx_chains,
-		   bool lar_fw_supported, bool is_family_8000_a_step);
+		   bool lar_fw_supported, bool is_family_8000_a_step,
+		   u32 mac_addr0, u32 mac_addr1);
 
 /**
  * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 6095088..383af27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -371,6 +371,14 @@ enum secure_load_status_reg {
 
 #define DBGC_IN_SAMPLE			(0xa03c00)
 
+/* enable the ID buf for read */
+#define WFPM_PS_CTL_CLR			0xA0300C
+#define WFMP_MAC_ADDR_0			0xA03080
+#define WFMP_MAC_ADDR_1			0xA03084
+#define LMPM_PMG_EN			0xA01CEC
+#define RADIO_REG_SYS_MANUAL_DFT_0	0xAD4078
+#define RFIC_REG_RD			0xAD0470
+
 /* FW chicken bits */
 #define LMPM_CHICK			0xA01FF8
 enum {
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index f514fae..7e49365 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1478,6 +1478,92 @@ struct iwl_sf_cfg_cmd {
 	__le32 full_on_timeouts[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES];
 } __packed; /* SF_CFG_API_S_VER_2 */
 
+/***********************************
+ * Location Aware Regulatory (LAR) API - MCC updates
+ ***********************************/
+
+/**
+ * struct iwl_mcc_update_cmd - Request the device to update geographic
+ * regulatory profile according to the given MCC (Mobile Country Code).
+ * The MCC is two letter-code, ascii upper case[A-Z] or '00' for world domain.
+ * 'ZZ' MCC will be used to switch to NVM default profile; in this case, the
+ * MCC in the cmd response will be the relevant MCC in the NVM.
+ * @mcc: given mobile country code
+ * @source_id: the source from where we got the MCC, see iwl_mcc_source
+ * @reserved: reserved for alignment
+ */
+struct iwl_mcc_update_cmd {
+	__le16 mcc;
+	u8 source_id;
+	u8 reserved;
+} __packed; /* LAR_UPDATE_MCC_CMD_API_S */
+
+/**
+ * iwl_mcc_update_resp - response to MCC_UPDATE_CMD.
+ * Contains the new channel control profile map, if changed, and the new MCC
+ * (mobile country code).
+ * The new MCC may be different than what was requested in MCC_UPDATE_CMD.
+ * @status: 0 for success, 1 no change in channel profile, 2 invalid input.
+ * @mcc: the new applied MCC
+ * @cap: capabilities for all channels which matches the MCC
+ * @source_id: the MCC source, see iwl_mcc_source
+ * @n_channels: number of channels in @channels_data (may be 14, 39, 50 or 51
+ *		channels, depending on platform)
+ * @channels: channel control data map, DWORD for each channel. Only the first
+ *	16bits are used.
+ */
+struct iwl_mcc_update_resp {
+	__le32 status;
+	__le16 mcc;
+	u8 cap;
+	u8 source_id;
+	__le32 n_channels;
+	__le32 channels[0];
+} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S */
+
+/**
+ * struct iwl_mcc_chub_notif - chub notifies of mcc change
+ * (MCC_CHUB_UPDATE_CMD = 0xc9)
+ * The Chub (Communication Hub, CommsHUB) is a HW component that connects to
+ * the cellular and connectivity cores that gets updates of the mcc, and
+ * notifies the ucode directly of any mcc change.
+ * The ucode requests the driver to request the device to update geographic
+ * regulatory  profile according to the given MCC (Mobile Country Code).
+ * The MCC is two letter-code, ascii upper case[A-Z] or '00' for world domain.
+ * 'ZZ' MCC will be used to switch to NVM default profile; in this case, the
+ * MCC in the cmd response will be the relevant MCC in the NVM.
+ * @mcc: given mobile country code
+ * @source_id: identity of the change originator, see iwl_mcc_source
+ * @reserved1: reserved for alignment
+ */
+struct iwl_mcc_chub_notif {
+	u16 mcc;
+	u8 source_id;
+	u8 reserved1;
+} __packed; /* LAR_MCC_NOTIFY_S */
+
+enum iwl_mcc_update_status {
+	MCC_RESP_NEW_CHAN_PROFILE,
+	MCC_RESP_SAME_CHAN_PROFILE,
+	MCC_RESP_INVALID,
+	MCC_RESP_NVM_DISABLED,
+	MCC_RESP_ILLEGAL,
+	MCC_RESP_LOW_PRIORITY,
+};
+
+enum iwl_mcc_source {
+	MCC_SOURCE_OLD_FW = 0,
+	MCC_SOURCE_ME = 1,
+	MCC_SOURCE_BIOS = 2,
+	MCC_SOURCE_3G_LTE_HOST = 3,
+	MCC_SOURCE_3G_LTE_DEVICE = 4,
+	MCC_SOURCE_WIFI = 5,
+	MCC_SOURCE_RESERVED = 6,
+	MCC_SOURCE_DEFAULT = 7,
+	MCC_SOURCE_UNINITIALIZED = 8,
+	MCC_SOURCE_GET_CURRENT = 0x10
+};
+
 /* DTS measurements */
 
 enum iwl_dts_measurement_flags {
@@ -1679,68 +1765,4 @@ struct iwl_shared_mem_cfg {
 	__le32 page_buff_size;
 } __packed; /* SHARED_MEM_ALLOC_API_S_VER_1 */
 
-/***********************************
- * Location Aware Regulatory (LAR) API - MCC updates
- ***********************************/
-
-/**
- * struct iwl_mcc_update_cmd - Request the device to update geographic
- * regulatory profile according to the given MCC (Mobile Country Code).
- * The MCC is two letter-code, ascii upper case[A-Z] or '00' for world domain.
- * 'ZZ' MCC will be used to switch to NVM default profile; in this case, the
- * MCC in the cmd response will be the relevant MCC in the NVM.
- * @mcc: given mobile country code
- * @reserved: reserved for alignment
- */
-struct iwl_mcc_update_cmd {
-	__le16 mcc;
-	__le16 reserved;
-} __packed; /* LAR_UPDATE_MCC_CMD_API_S */
-
-/**
- * iwl_mcc_update_resp - response to MCC_UPDATE_CMD.
- * Contains the new channel control profile map, if changed, and the new MCC
- * (mobile country code).
- * The new MCC may be different than what was requested in MCC_UPDATE_CMD.
- * @status: 0 for success, 1 no change in channel profile, 2 invalid input.
- * @mcc: the new applied MCC
- * @n_channels: number of channels in @channels_data (may be 14, 39, 50 or 51
- *		channels, depending on platform)
- * @channels: channel control data map, DWORD for each channel. Only the first
- *	16bits are used.
- */
-struct iwl_mcc_update_resp {
-	__le32 status;
-	__le16 mcc;
-	__le16 reserved;
-	__le32 n_channels;
-	__le32 channels[0];
-} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S */
-
-/**
- * struct iwl_mcc_chub_notif - chub notifies of mcc change
- * (MCC_CHUB_UPDATE_CMD = 0xc9)
- * The Chub (Communication Hub, CommsHUB) is a HW component that connects to
- * the cellular and connectivity cores that gets updates of the mcc, and
- * notifies the ucode directly of any mcc change.
- * The ucode requests the driver to request the device to update geographic
- * regulatory  profile according to the given MCC (Mobile Country Code).
- * The MCC is two letter-code, ascii upper case[A-Z] or '00' for world domain.
- * 'ZZ' MCC will be used to switch to NVM default profile; in this case, the
- * MCC in the cmd response will be the relevant MCC in the NVM.
- * @mcc: given mobile country code
- * @reserved: reserved for alignment
- */
-struct iwl_mcc_chub_notif {
-	u16 mcc;
-	u16 reserved1;
-} __packed; /* LAR_MCC_NOTIFY_S */
-
-enum iwl_mcc_update_status {
-	MCC_RESP_NEW_CHAN_PROFILE,
-	MCC_RESP_SAME_CHAN_PROFILE,
-	MCC_RESP_INVALID,
-	MCC_RESP_NVM_DISABLED,
-};
-
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5dc3a94..303a7a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -303,7 +303,8 @@ static void iwl_mvm_reset_phy_ctxts(struct iwl_mvm *mvm)
 }
 
 struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
-						  const char *alpha2)
+						  const char *alpha2,
+						  enum iwl_mcc_source src_id)
 {
 	struct ieee80211_regdomain *regd = NULL;
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
@@ -312,39 +313,75 @@ struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 
 	IWL_DEBUG_LAR(mvm, "Getting regdomain data for %s from FW\n", alpha2);
 
-	mutex_lock(&mvm->mutex);
-
-	/* change "99" to "ZZ" for the FW */
-	if (alpha2[0] == '9' && alpha2[1] == '9')
-		alpha2 = "ZZ";
+	lockdep_assert_held(&mvm->mutex);
 
-	resp = iwl_mvm_update_mcc(mvm, alpha2);
+	resp = iwl_mvm_update_mcc(mvm, alpha2, src_id);
 	if (IS_ERR_OR_NULL(resp)) {
 		IWL_DEBUG_LAR(mvm, "Could not get update from FW %d\n",
 			      PTR_RET(resp));
-		goto out_unlock;
+		goto out;
 	}
 
 	regd = iwl_parse_nvm_mcc_info(mvm->trans->dev, mvm->cfg,
 				      __le32_to_cpu(resp->n_channels),
 				      resp->channels,
 				      __le16_to_cpu(resp->mcc));
+	/* Store the return source id */
+	src_id = resp->source_id;
 	kfree(resp);
 	if (IS_ERR_OR_NULL(regd)) {
 		IWL_DEBUG_LAR(mvm, "Could not get parse update from FW %d\n",
-			      PTR_RET(resp));
-		goto out_unlock;
+			      PTR_RET(regd));
+		goto out;
 	}
 
-	IWL_DEBUG_LAR(mvm, "setting alpha2 from FW to %s (0x%x, 0x%x)\n",
-		      regd->alpha2, regd->alpha2[0], regd->alpha2[1]);
+	IWL_DEBUG_LAR(mvm, "setting alpha2 from FW to %s (0x%x, 0x%x) src=%d\n",
+		      regd->alpha2, regd->alpha2[0], regd->alpha2[1], src_id);
 	mvm->lar_regdom_set = true;
+	mvm->mcc_src = src_id;
 
-out_unlock:
-	mutex_unlock(&mvm->mutex);
+out:
 	return regd;
 }
 
+struct ieee80211_regdomain *iwl_mvm_get_current_regdomain(struct iwl_mvm *mvm)
+{
+	return iwl_mvm_get_regdomain(mvm->hw->wiphy, "ZZ",
+				     iwl_mvm_is_wifi_mcc_supported(mvm) ?
+				     MCC_SOURCE_GET_CURRENT :
+				     MCC_SOURCE_OLD_FW);
+}
+
+int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
+{
+	enum iwl_mcc_source used_src;
+	struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *r =
+			rtnl_dereference(mvm->hw->wiphy->regd);
+
+	if (!r)
+		return 0;
+
+	/* save the last source in case we overwrite it below */
+	used_src = mvm->mcc_src;
+	if (iwl_mvm_is_wifi_mcc_supported(mvm)) {
+		/* Notify the firmware we support wifi location updates */
+		regd = iwl_mvm_get_current_regdomain(mvm);
+		if (!IS_ERR_OR_NULL(regd))
+			kfree(regd);
+	}
+
+	/* Now set our last stored MCC and source */
+	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, r->alpha2, used_src);
+	if (IS_ERR_OR_NULL(regd))
+		return -EIO;
+
+	regulatory_set_wiphy_regd(mvm->hw->wiphy, regd);
+	kfree(regd);
+
+	return 0;
+}
+
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 {
 	struct ieee80211_hw *hw = mvm->hw;
@@ -400,8 +437,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
-	hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
-				       REGULATORY_DISABLE_BEACON_HINTS;
+	hw->wiphy->regulatory_flags |= REGULATORY_ENABLE_RELAX_NO_IR;
+	if (iwl_mvm_is_lar_supported(mvm))
+		hw->wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
+	else
+		hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
+					       REGULATORY_DISABLE_BEACON_HINTS;
 
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_GO_UAPSD)
 		hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 207c3a8..5d5be37 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -811,6 +811,7 @@ struct iwl_mvm {
 	u32 ap_last_beacon_gp2;
 
 	bool lar_regdom_set;
+	enum iwl_mcc_source mcc_src;
 
 	u8 low_latency_agg_frame_limit;
 
@@ -931,6 +932,11 @@ static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
 		return tlv_lar;
 }
 
+static inline bool iwl_mvm_is_wifi_mcc_supported(struct iwl_mvm *mvm)
+{
+	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_WIFI_MCC_UPDATE;
+}
+
 static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
 {
 	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SCD_CFG;
@@ -1412,13 +1418,17 @@ int iwl_mvm_get_temp(struct iwl_mvm *mvm);
 
 /* Location Aware Regulatory */
 struct iwl_mcc_update_resp *
-iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2);
+iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
+		   enum iwl_mcc_source src_id);
 int iwl_mvm_init_mcc(struct iwl_mvm *mvm);
 int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 			       struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd);
 struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
-						  const char *alpha2);
+						  const char *alpha2,
+						  enum iwl_mcc_source src_id);
+struct ieee80211_regdomain *iwl_mvm_get_current_regdomain(struct iwl_mvm *mvm);
+int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm);
 
 /* smart fifo */
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 5a16e0d..41189e5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -70,6 +70,7 @@
 #include "iwl-eeprom-parse.h"
 #include "iwl-eeprom-read.h"
 #include "iwl-nvm-parse.h"
+#include "iwl-prph.h"
 
 /* Default NVM size to read */
 #define IWL_NVM_DEFAULT_CHUNK_SIZE (2*1024)
@@ -265,6 +266,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	struct iwl_nvm_section *sections = mvm->nvm_sections;
 	const __le16 *hw, *sw, *calib, *regulatory, *mac_override, *phy_sku;
 	bool is_family_8000_a_step = false, lar_enabled;
+	u32 mac_addr0, mac_addr1;
 
 	/* Checking for required sections */
 	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
@@ -304,6 +306,10 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	if (WARN_ON(!mvm->cfg))
 		return NULL;
 
+	/* read the mac address from WFMP registers */
+	mac_addr0 = iwl_trans_read_prph(mvm->trans, WFMP_MAC_ADDR_0);
+	mac_addr1 = iwl_trans_read_prph(mvm->trans, WFMP_MAC_ADDR_1);
+
 	hw = (const __le16 *)sections[mvm->cfg->nvm_hw_section_num].data;
 	sw = (const __le16 *)sections[NVM_SECTION_TYPE_SW].data;
 	calib = (const __le16 *)sections[NVM_SECTION_TYPE_CALIBRATION].data;
@@ -319,7 +325,8 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
 				  regulatory, mac_override, phy_sku,
 				  mvm->fw->valid_tx_ant, mvm->fw->valid_rx_ant,
-				  lar_enabled, is_family_8000_a_step);
+				  lar_enabled, is_family_8000_a_step,
+				  mac_addr0, mac_addr1);
 }
 
 #define MAX_NVM_FILE_LEN	16384
@@ -590,10 +597,12 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 }
 
 struct iwl_mcc_update_resp *
-iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2)
+iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
+		   enum iwl_mcc_source src_id)
 {
 	struct iwl_mcc_update_cmd mcc_update_cmd = {
 		.mcc = cpu_to_le16(alpha2[0] << 8 | alpha2[1]),
+		.source_id = (u8)src_id,
 	};
 	struct iwl_mcc_update_resp *mcc_resp, *resp_cp = NULL;
 	struct iwl_rx_packet *pkt;
@@ -613,8 +622,8 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2)
 
 	cmd.len[0] = sizeof(struct iwl_mcc_update_cmd);
 
-	IWL_DEBUG_LAR(mvm, "send MCC update to FW with '%c%c'\n",
-		      alpha2[0], alpha2[1]);
+	IWL_DEBUG_LAR(mvm, "send MCC update to FW with '%c%c' src = %d\n",
+		      alpha2[0], alpha2[1], src_id);
 
 	ret = iwl_mvm_send_cmd(mvm, &cmd);
 	if (ret)
@@ -632,18 +641,6 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2)
 	mcc_resp = (void *)pkt->data;
 	status = le32_to_cpu(mcc_resp->status);
 
-	if (status == MCC_RESP_INVALID) {
-		IWL_ERR(mvm,
-			"FW ERROR: MCC update with invalid parameter '%c%c'\n",
-			alpha2[0], alpha2[1]);
-		ret = -EINVAL;
-		goto exit;
-	} else if (status == MCC_RESP_NVM_DISABLED) {
-		ret = 0;
-		/* resp_cp will be NULL */
-		goto exit;
-	}
-
 	mcc = le16_to_cpu(mcc_resp->mcc);
 
 	/* W/A for a FW/NVM issue - returns 0x00 for the world domain */
@@ -677,6 +674,8 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 {
 	bool tlv_lar;
 	bool nvm_lar;
+	int retval;
+	struct ieee80211_regdomain *regd;
 
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
 		tlv_lar = mvm->fw->ucode_capa.capa[0] &
@@ -698,32 +697,24 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 	 */
 	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		/* This should only be called during vif up and hold RTNL */
-		const struct ieee80211_regdomain *r =
-				rtnl_dereference(mvm->hw->wiphy->regd);
-
-		if (r) {
-			struct iwl_mcc_update_resp *resp;
-
-			resp = iwl_mvm_update_mcc(mvm, r->alpha2);
-			if (IS_ERR_OR_NULL(resp))
-				return -EIO;
-
-			kfree(resp);
-		}
-
-		return 0;
+		return iwl_mvm_init_fw_regd(mvm);
 	}
 
 	/*
-	 * Driver regulatory hint for initial update - use the special
-	 * unknown-country "99" code. This will also clear the "custom reg"
-	 * flag and allow regdomain changes. It will happen after init since
-	 * RTNL is required.
+	 * Driver regulatory hint for initial update, this also informs the
+	 * firmware we support wifi location updates.
 	 * Disallow scans that might crash the FW while the LAR regdomain
 	 * is not set.
 	 */
 	mvm->lar_regdom_set = false;
-	return 0;
+
+	regd = iwl_mvm_get_current_regdomain(mvm);
+	if (IS_ERR_OR_NULL(regd))
+		return -EIO;
+
+	retval = regulatory_set_wiphy_regd_sync_rtnl(mvm->hw->wiphy, regd);
+	kfree(regd);
+	return retval;
 }
 
 int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
@@ -732,17 +723,29 @@ int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mcc_chub_notif *notif = (void *)pkt->data;
+	enum iwl_mcc_source src;
 	char mcc[3];
+	struct ieee80211_regdomain *regd;
+
+	lockdep_assert_held(&mvm->mutex);
 
 	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
-		return -EOPNOTSUPP;
+		return 0;
 
 	mcc[0] = notif->mcc >> 8;
 	mcc[1] = notif->mcc & 0xff;
 	mcc[2] = '\0';
+	src = notif->source_id;
 
 	IWL_DEBUG_LAR(mvm,
-		      "RX: received chub update mcc command (mcc 0x%x '%s')\n",
-		      notif->mcc, mcc);
+		      "RX: received chub update mcc cmd (mcc '%s' src %d)\n",
+		      mcc, src);
+	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc, src);
+	if (IS_ERR_OR_NULL(regd))
+		return 0;
+
+	regulatory_set_wiphy_regd(mvm->hw->wiphy, regd);
+	kfree(regd);
+
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 1072f45..c1de23c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -234,7 +234,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   iwl_mvm_rx_ant_coupling_notif, true),
 
 	RX_HANDLER(TIME_EVENT_NOTIFICATION, iwl_mvm_rx_time_event_notif, false),
-	RX_HANDLER(MCC_CHUB_UPDATE_CMD, iwl_mvm_rx_chub_update_mcc, false),
+	RX_HANDLER(MCC_CHUB_UPDATE_CMD, iwl_mvm_rx_chub_update_mcc, true),
 
 	RX_HANDLER(EOSP_NOTIFICATION, iwl_mvm_rx_eosp_notif, false),
 
-- 
1.9.1

