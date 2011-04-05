Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab1DERBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/25] iwlagn: remove bootstrap code
Date: Tue,  5 Apr 2011 09:41:57 -0700
Message-Id: <1302021732-21250-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only 4965 had a bootstrap microcode image, so
the agn driver can completely ignore that and
we can remove some code from it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 -
 drivers/net/wireless/iwlwifi/iwl-6000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   36 +++---------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 -
 6 files changed, 4 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index ad50063..53a6702 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -141,7 +141,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
 
-	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 5e375d8..9f97389 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -147,7 +147,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
 
-	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0e1f0b5..653bb8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -185,7 +185,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
 
-	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
@@ -231,7 +230,6 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
 
-	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4d545e6..1e55f81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -176,7 +176,6 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
 
-	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8fd9a60..f959cf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1179,7 +1179,6 @@ static void iwl_dealloc_ucode_pci(struct iwl_priv *priv)
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init);
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init_data);
-	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_boot);
 }
 
 static void iwl_nic_start(struct iwl_priv *priv)
@@ -1237,8 +1236,8 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 }
 
 struct iwlagn_firmware_pieces {
-	const void *inst, *data, *init, *init_data, *boot;
-	size_t inst_size, data_size, init_size, init_data_size, boot_size;
+	const void *inst, *data, *init, *init_data;
+	size_t inst_size, data_size, init_size, init_data_size;
 
 	u32 build;
 
@@ -1269,7 +1268,6 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 		pieces->data_size = le32_to_cpu(ucode->u.v2.data_size);
 		pieces->init_size = le32_to_cpu(ucode->u.v2.init_size);
 		pieces->init_data_size = le32_to_cpu(ucode->u.v2.init_data_size);
-		pieces->boot_size = le32_to_cpu(ucode->u.v2.boot_size);
 		src = ucode->u.v2.data;
 		break;
 	case 0:
@@ -1285,7 +1283,6 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 		pieces->data_size = le32_to_cpu(ucode->u.v1.data_size);
 		pieces->init_size = le32_to_cpu(ucode->u.v1.init_size);
 		pieces->init_data_size = le32_to_cpu(ucode->u.v1.init_data_size);
-		pieces->boot_size = le32_to_cpu(ucode->u.v1.boot_size);
 		src = ucode->u.v1.data;
 		break;
 	}
@@ -1293,7 +1290,7 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 	/* Verify size of file vs. image size info in file's header */
 	if (ucode_raw->size != hdr_size + pieces->inst_size +
 				pieces->data_size + pieces->init_size +
-				pieces->init_data_size + pieces->boot_size) {
+				pieces->init_data_size) {
 
 		IWL_ERR(priv,
 			"uCode file size %d does not match expected size\n",
@@ -1309,8 +1306,6 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 	src += pieces->init_size;
 	pieces->init_data = src;
 	src += pieces->init_data_size;
-	pieces->boot = src;
-	src += pieces->boot_size;
 
 	return 0;
 }
@@ -1411,8 +1406,7 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 			pieces->init_data_size = tlv_len;
 			break;
 		case IWL_UCODE_TLV_BOOT:
-			pieces->boot = tlv_data;
-			pieces->boot_size = tlv_len;
+			IWL_ERR(priv, "Found unexpected BOOT ucode\n");
 			break;
 		case IWL_UCODE_TLV_PROBE_MAX_LEN:
 			if (tlv_len != sizeof(u32))
@@ -1612,8 +1606,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		       pieces.init_size);
 	IWL_DEBUG_INFO(priv, "f/w package hdr init data size = %Zd\n",
 		       pieces.init_data_size);
-	IWL_DEBUG_INFO(priv, "f/w package hdr boot inst size = %Zd\n",
-		       pieces.boot_size);
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (pieces.inst_size > priv->hw_params.max_inst_size) {
@@ -1640,12 +1632,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		goto try_again;
 	}
 
-	if (pieces.boot_size > priv->hw_params.max_bsm_size) {
-		IWL_ERR(priv, "uCode boot instr len %Zd too large to fit in\n",
-			pieces.boot_size);
-		goto try_again;
-	}
-
 	/* Allocate ucode buffers for card's bus-master loading ... */
 
 	/* Runtime instructions and 2 copies of data:
@@ -1676,15 +1662,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			goto err_pci_alloc;
 	}
 
-	/* Bootstrap (instructions only, no data) */
-	if (pieces.boot_size) {
-		priv->ucode_boot.len = pieces.boot_size;
-		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_boot);
-
-		if (!priv->ucode_boot.v_addr)
-			goto err_pci_alloc;
-	}
-
 	/* Now that we can no longer fail, copy information */
 
 	/*
@@ -1747,11 +1724,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		       pieces.init_data_size);
 	}
 
-	/* Bootstrap instructions */
-	IWL_DEBUG_INFO(priv, "Copying (but not loading) boot instr len %Zd\n",
-			pieces.boot_size);
-	memcpy(priv->ucode_boot.v_addr, pieces.boot, pieces.boot_size);
-
 	/*
 	 * figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 70f1785..c3a9ec8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -640,7 +640,6 @@ struct iwl_hw_params {
 	u8  max_beacon_itrvl;	/* in 1024 ms */
 	u32 max_inst_size;
 	u32 max_data_size;
-	u32 max_bsm_size;
 	u32 ct_kill_threshold; /* value in hw-dependent units */
 	u32 ct_kill_exit_threshold; /* value in hw-dependent units */
 				    /* for 1000, 6000 series and up */
@@ -1263,7 +1262,6 @@ struct iwl_priv {
 	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
 	struct fw_desc ucode_init;	/* initialization inst */
 	struct fw_desc ucode_init_data;	/* initialization data */
-	struct fw_desc ucode_boot;	/* bootstrap inst */
 	enum ucode_type ucode_type;
 	u8 ucode_write_complete;	/* the image write is complete */
 	char firmware_name[25];
-- 
1.7.0.4

