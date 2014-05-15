Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42368 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaEORF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:27 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so3721147wgg.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:25 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Matt Chen <matt.chen@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/24] iwlwifi: mvm: add uapsd_disable module parameter
Date: Thu, 15 May 2014 20:04:37 +0300
Message-Id: <1400173481-9047-20-git-send-email-egrumbach@gmail.com> (sfid-20140515_190601_298736_7C1C815F)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matt Chen <matt.chen@intel.com>

Some APs (e.g. TP-LINK TL-WA801N) are disabling aggregation (downlink
to station) when U-APSD is enabled, resulting in low throughput.
Add a module parameter to allow disabling U-APSD support in the driver.

Also re-enable U-APSD for -9 firmware since the firmare issues were
fixed in this release.

There are devices that won't support U-APSD even with newer
firmware, so bring the TLV flag back to detect those.

Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c       |  5 +++++
 drivers/net/wireless/iwlwifi/iwl-fw.h        |  3 ++-
 drivers/net/wireless/iwlwifi/iwl-modparams.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 13 +++++++------
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 0a3e841..f2a5c12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1243,6 +1243,7 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.bt_coex_active = true,
 	.power_level = IWL_POWER_INDEX_1,
 	.wd_disable = true,
+	.uapsd_disable = false,
 	/* the rest are 0 by default */
 };
 IWL_EXPORT_SYMBOL(iwlwifi_mod_params);
@@ -1356,6 +1357,10 @@ MODULE_PARM_DESC(wd_disable,
 module_param_named(nvm_file, iwlwifi_mod_params.nvm_file, charp, S_IRUGO);
 MODULE_PARM_DESC(nvm_file, "NVM file name");
 
+module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
+		   bool, S_IRUGO);
+MODULE_PARM_DESC(uapsd_disable, "disable U-APSD functionality (default: N)");
+
 /*
  * set bt_coex_active to true, uCode will do kill/defer
  * every time the priority line is asserted (BT is sending signals on the
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index d5ed150..0aa7c00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -74,7 +74,7 @@
  * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
  * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
  * @IWL_UCODE_TLV_FLAGS_DW_BC_TABLE: The SCD byte count table is in DWORDS
- * @IWL_UCODE_TLV_FLAGS_UAPSD: This uCode image supports uAPSD
+ * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: This uCode image supports uAPSD
  * @IWL_UCODE_TLV_FLAGS_SHORT_BL: 16 entries of black list instead of 64 in scan
  *	offload profile config command.
  * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
@@ -107,6 +107,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM	= BIT(23),
+	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 	IWL_UCODE_TLV_FLAGS_EBS_SUPPORT		= BIT(25),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
 	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index d994317..d051857 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -119,6 +119,7 @@ struct iwl_mod_params {
 #endif
 	int ant_coupling;
 	char *nvm_file;
+	bool uapsd_disable;
 };
 
 #endif /* #__iwl_modparams_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2f529eb..137228b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -276,7 +276,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_TIMING_BEACON_ONLY |
 		    IEEE80211_HW_CONNECTION_MONITOR |
-		    IEEE80211_HW_SUPPORTS_UAPSD |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 		    IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -286,8 +285,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 				    IEEE80211_RADIOTAP_MCS_HAVE_STBC;
 	hw->radiotap_vht_details |= IEEE80211_RADIOTAP_VHT_KNOWN_STBC;
 	hw->rate_control_algorithm = "iwl-mvm-rs";
-	hw->uapsd_queues = IWL_UAPSD_AC_INFO;
-	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 
 	/*
 	 * Enable 11w if advertised by firmware and software crypto
@@ -298,9 +295,13 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    !iwlwifi_mod_params.sw_crypto)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	/* Disable uAPSD due to firmware issues */
-	if (true)
-		hw->flags &= ~IEEE80211_HW_SUPPORTS_UAPSD;
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT &&
+	    IWL_UCODE_API(mvm->fw->ucode_ver) >= 9 &&
+	    !iwlwifi_mod_params.uapsd_disable) {
+		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
+		hw->uapsd_queues = IWL_UAPSD_AC_INFO;
+		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
+	}
 
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
-- 
1.8.3.2

