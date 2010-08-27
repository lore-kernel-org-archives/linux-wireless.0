Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab0H0Q4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/27] iwlagn: detect PAN capability
Date: Fri, 27 Aug 2010 09:59:46 -0700
Message-Id: <1282928395-32762-19-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Detect whether or not the ucode is PAN
capable and adjust the valid contexts
accordingly. To be able to do this, add
the PAN context to the array as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   25 +++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 ++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 55d1cd4..bad97f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1718,6 +1718,7 @@ static void iwl_nic_start(struct iwl_priv *priv)
 struct iwlagn_ucode_capabilities {
 	u32 max_probe_length;
 	u32 standard_phy_calibration_size;
+	bool pan;
 };
 
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
@@ -1955,6 +1956,11 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 			capa->max_probe_length =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
+		case IWL_UCODE_TLV_PAN:
+			if (tlv_len)
+				goto invalid_tlv_len;
+			capa->pan = true;
+			break;
 		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
 			if (tlv_len != sizeof(u32))
 				goto invalid_tlv_len;
@@ -2230,10 +2236,11 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->_agn.inst_evtlog_size = priv->cfg->max_event_log_size;
 	priv->_agn.inst_errlog_ptr = pieces.inst_errlog_ptr;
 
-	if (priv->valid_contexts == BIT(IWL_RXON_CTX_BSS))
-		priv->sta_key_max_num = STA_KEY_MAX_NUM;
-	else
+	if (ucode_capa.pan) {
+		priv->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
+	} else
+		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 
 	/* Copy images into buffers for card's bus-master reads ... */
 
@@ -4226,7 +4233,17 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
 	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
-	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 1);
+
+	priv->contexts[IWL_RXON_CTX_PAN].rxon_cmd = REPLY_WIPAN_RXON;
+	priv->contexts[IWL_RXON_CTX_PAN].rxon_timing_cmd = REPLY_WIPAN_RXON_TIMING;
+	priv->contexts[IWL_RXON_CTX_PAN].rxon_assoc_cmd = REPLY_WIPAN_RXON_ASSOC;
+	priv->contexts[IWL_RXON_CTX_PAN].qos_cmd = REPLY_WIPAN_QOS_PARAM;
+	priv->contexts[IWL_RXON_CTX_PAN].ap_sta_id = IWL_AP_ID_PAN;
+	priv->contexts[IWL_RXON_CTX_PAN].wep_key_cmd = REPLY_WIPAN_WEPKEY;
+	priv->contexts[IWL_RXON_CTX_PAN].bcast_sta_id = IWLAGN_PAN_BCAST_ID;
+	priv->contexts[IWL_RXON_CTX_PAN].station_flags = STA_FLG_PAN_STATION;
+
+	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e1565f7..99b6b81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -582,6 +582,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_INIT_DATA		= 4,
 	IWL_UCODE_TLV_BOOT		= 5,
 	IWL_UCODE_TLV_PROBE_MAX_LEN	= 6, /* a u32 value */
+	IWL_UCODE_TLV_PAN		= 7,
 	IWL_UCODE_TLV_RUNT_EVTLOG_PTR	= 8,
 	IWL_UCODE_TLV_RUNT_EVTLOG_SIZE	= 9,
 	IWL_UCODE_TLV_RUNT_ERRLOG_PTR	= 10,
@@ -1103,6 +1104,7 @@ struct iwl_force_reset {
 
 enum iwl_rxon_context_id {
 	IWL_RXON_CTX_BSS,
+	IWL_RXON_CTX_PAN,
 
 	NUM_IWL_RXON_CTX
 };
-- 
1.7.0.4

