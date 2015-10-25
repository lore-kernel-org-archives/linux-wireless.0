Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbJYMBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/16] iwlwifi: mvm: use short timeouts in P2P low latency if supported
Date: Sun, 25 Oct 2015 14:01:06 +0200
Message-Id: <1445774476-24792-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130136_118791_8CAC736B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Those timeouts are used for AM-to-PSM transition.
We already have those pairs defined for default and WOWLAN use cases.
We expect that by using shorter threshold for low latency P2P,
e.g. for Miracast video scenario, we might save a considerable amount of power.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h   |  2 ++
 drivers/net/wireless/iwlwifi/mvm/constants.h |  3 +++
 drivers/net/wireless/iwlwifi/mvm/power.c     | 26 +++++++++++++++++++-------
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 847d58b..08303db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -307,6 +307,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
  * @IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT: supports gscan
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
+ * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -332,6 +333,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
 	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
+	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index aa9ae1d..5c21231 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -71,6 +71,9 @@
 #define IWL_MVM_DEFAULT_PS_RX_DATA_TIMEOUT	(100 * USEC_PER_MSEC)
 #define IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
 #define IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
+#define IWL_MVM_SHORT_PS_TX_DATA_TIMEOUT	(2 * 1024) /* defined in TU */
+#define IWL_MVM_SHORT_PS_RX_DATA_TIMEOUT	(40 * 1024) /* defined in TU */
+#define IWL_MVM_P2P_LOWLATENCY_PS_ENABLE	0
 #define IWL_MVM_UAPSD_RX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
 #define IWL_MVM_UAPSD_TX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
 #define IWL_MVM_UAPSD_QUEUES		(IEEE80211_WMM_IE_STA_QOSINFO_AC_VO |\
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 7c354fe..bed9696 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -377,8 +377,13 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
 
-	if (!vif->bss_conf.ps || !mvmvif->pm_enabled ||
-	    (iwl_mvm_vif_low_latency(mvmvif) && vif->p2p))
+	if (!vif->bss_conf.ps || !mvmvif->pm_enabled)
+		return;
+
+	if (iwl_mvm_vif_low_latency(mvmvif) && vif->p2p &&
+	    (!fw_has_capa(&mvm->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS) ||
+	     !IWL_MVM_P2P_LOWLATENCY_PS_ENABLE))
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
@@ -392,16 +397,23 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 
 	iwl_mvm_power_config_skip_dtim(mvm, vif, cmd, host_awake);
 
-	if (host_awake) {
+	if (!host_awake) {
 		cmd->rx_data_timeout =
-			cpu_to_le32(IWL_MVM_DEFAULT_PS_RX_DATA_TIMEOUT);
+			cpu_to_le32(IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT);
 		cmd->tx_data_timeout =
-			cpu_to_le32(IWL_MVM_DEFAULT_PS_TX_DATA_TIMEOUT);
+			cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
+	} else if (iwl_mvm_vif_low_latency(mvmvif) && vif->p2p &&
+		   fw_has_capa(&mvm->fw->ucode_capa,
+			       IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS)) {
+		cmd->tx_data_timeout =
+			cpu_to_le32(IWL_MVM_SHORT_PS_TX_DATA_TIMEOUT);
+		cmd->rx_data_timeout =
+			cpu_to_le32(IWL_MVM_SHORT_PS_RX_DATA_TIMEOUT);
 	} else {
 		cmd->rx_data_timeout =
-			cpu_to_le32(IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT);
+			cpu_to_le32(IWL_MVM_DEFAULT_PS_RX_DATA_TIMEOUT);
 		cmd->tx_data_timeout =
-			cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
+			cpu_to_le32(IWL_MVM_DEFAULT_PS_TX_DATA_TIMEOUT);
 	}
 
 	if (iwl_mvm_power_allow_uapsd(mvm, vif))
-- 
2.1.4

