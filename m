Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9395 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298AbcAaLGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:38 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/31] iwlwifi: mvm: Add P2P client snoozing
Date: Sun, 31 Jan 2016 13:06:06 +0200
Message-Id: <1454238386-27032-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123653_710248_0535A7DE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Enable snoozing and U-APSD on P2P client. The firwmare will
support this only if the BSS vif is not associated.
Make this configurable by a constant variable and disable
it by default.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  8 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     | 39 ++++++++++++++++++++--
 4 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 4050b4a..dbf08c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -302,6 +302,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_DC2DC_SUPPORT: supports DC2DC Command
  * @IWL_UCODE_TLV_CAPA_CSUM_SUPPORT: supports TCP Checksum Offload
  * @IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS: support radio and beacon statistics
+ * @IWL_UCODE_TLV_CAPA_P2P_STANDALONE_UAPSD: support p2p standalone U-APSD
  * @IWL_UCODE_TLV_CAPA_BT_COEX_PLCR: enabled BT Coex packet level co-running
  * @IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC: ucode supports LAR updates with different
  *	sources for the MCC. This TLV bit is a future replacement to
@@ -336,6 +337,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_DC2DC_CONFIG_SUPPORT		= (__force iwl_ucode_tlv_capa_t)19,
 	IWL_UCODE_TLV_CAPA_CSUM_SUPPORT			= (__force iwl_ucode_tlv_capa_t)21,
 	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= (__force iwl_ucode_tlv_capa_t)22,
+	IWL_UCODE_TLV_CAPA_P2P_STANDALONE_UAPSD		= (__force iwl_ucode_tlv_capa_t)26,
 	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= (__force iwl_ucode_tlv_capa_t)28,
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index b00c03f..959fc4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -73,6 +73,7 @@
 #define IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
 #define IWL_MVM_SHORT_PS_TX_DATA_TIMEOUT	(2 * 1024) /* defined in TU */
 #define IWL_MVM_SHORT_PS_RX_DATA_TIMEOUT	(40 * 1024) /* defined in TU */
+#define IWL_MVM_P2P_UAPSD_STANDALONE		0
 #define IWL_MVM_P2P_LOWLATENCY_PS_ENABLE	0
 #define IWL_MVM_UAPSD_RX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
 #define IWL_MVM_UAPSD_TX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 5f3ac8c..5a92ab1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1005,6 +1005,14 @@ static inline bool iwl_mvm_is_mplut_supported(struct iwl_mvm *mvm)
 		IWL_MVM_BT_COEX_MPLUT;
 }
 
+static inline
+bool iwl_mvm_is_p2p_standalone_uapsd_supported(struct iwl_mvm *mvm)
+{
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_P2P_STANDALONE_UAPSD) &&
+		IWL_MVM_P2P_UAPSD_STANDALONE;
+}
+
 static inline bool iwl_mvm_has_new_rx_api(struct iwl_mvm *mvm)
 {
 	/* firmware flag isn't defined yet */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 9de159f..16b3e36 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -259,6 +259,26 @@ static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 		IWL_MVM_PS_HEAVY_RX_THLD_PERCENT;
 }
 
+static void iwl_mvm_p2p_standalone_iterator(void *_data, u8 *mac,
+					    struct ieee80211_vif *vif)
+{
+	bool *is_p2p_standalone = _data;
+
+	switch (ieee80211_vif_type_p2p(vif)) {
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_AP:
+		*is_p2p_standalone = false;
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (vif->bss_conf.assoc)
+			*is_p2p_standalone = false;
+		break;
+
+	default:
+		break;
+	}
+}
+
 static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 				       struct ieee80211_vif *vif)
 {
@@ -268,9 +288,6 @@ static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 		    ETH_ALEN))
 		return false;
 
-	if (vif->p2p &&
-	    !(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD))
-		return false;
 	/*
 	 * Avoid using uAPSD if P2P client is associated to GO that uses
 	 * opportunistic power save. This is due to current FW limitation.
@@ -287,6 +304,22 @@ static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 	if (iwl_mvm_phy_ctx_count(mvm) >= 2)
 		return false;
 
+	if (vif->p2p) {
+		/* Allow U-APSD only if p2p is stand alone */
+		bool is_p2p_standalone = true;
+
+		if (!iwl_mvm_is_p2p_standalone_uapsd_supported(mvm))
+			return false;
+
+		ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+					IEEE80211_IFACE_ITER_NORMAL,
+					iwl_mvm_p2p_standalone_iterator,
+					&is_p2p_standalone);
+
+		if (!is_p2p_standalone)
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.5.0

