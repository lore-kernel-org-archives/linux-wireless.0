Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbcC3OF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:56 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/43] iwlwifi: make uapsd_disable module param a bitmap
Date: Wed, 30 Mar 2016 17:04:48 +0300
Message-Id: <1459346715-7954-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160611_429261_37F4F759)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to disable uapsd for BSS only, or P2P client
separately. Remove the now unneeded
IWL_MVM_P2P_UAPSD_STANDALONE constant.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 10 ++++++----
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h | 10 ++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 ++-
 5 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index f899666..2cd9c31 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1561,7 +1561,7 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.d0i3_disable = true,
 	.d0i3_entry_delay = 1000,
 #ifndef CONFIG_IWLWIFI_UAPSD
-	.uapsd_disable = true,
+	.uapsd_disable = IWL_DISABLE_UAPSD_BSS | IWL_DISABLE_UAPSD_P2P_CLIENT,
 #endif /* CONFIG_IWLWIFI_UAPSD */
 	/* the rest are 0 by default */
 };
@@ -1681,11 +1681,13 @@ module_param_named(lar_disable, iwlwifi_mod_params.lar_disable,
 MODULE_PARM_DESC(lar_disable, "disable LAR functionality (default: N)");
 
 module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
-		   bool, S_IRUGO | S_IWUSR);
+		   uint, S_IRUGO | S_IWUSR);
 #ifdef CONFIG_IWLWIFI_UAPSD
-MODULE_PARM_DESC(uapsd_disable, "disable U-APSD functionality (default: N)");
+MODULE_PARM_DESC(uapsd_disable,
+		 "disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 0)");
 #else
-MODULE_PARM_DESC(uapsd_disable, "disable U-APSD functionality (default: Y)");
+MODULE_PARM_DESC(uapsd_disable,
+		 "disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 3)");
 #endif
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index d1a5dd1..6c5c2f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -92,6 +92,11 @@ enum iwl_amsdu_size {
 	IWL_AMSDU_12K = 2,
 };
 
+enum iwl_uapsd_disable {
+	IWL_DISABLE_UAPSD_BSS		= BIT(0),
+	IWL_DISABLE_UAPSD_P2P_CLIENT	= BIT(1),
+};
+
 /**
  * struct iwl_mod_params
  *
@@ -109,7 +114,8 @@ enum iwl_amsdu_size {
  * @debug_level: levels are IWL_DL_*
  * @ant_coupling: antenna coupling in dB, default = 0
  * @nvm_file: specifies a external NVM file
- * @uapsd_disable: disable U-APSD, default = 1
+ * @uapsd_disable: disable U-APSD, see %enum iwl_uapsd_disable, default =
+ *	IWL_DISABLE_UAPSD_BSS | IWL_DISABLE_UAPSD_P2P_CLIENT
  * @d0i3_disable: disable d0i3, default = 1,
  * @d0i3_entry_delay: time to wait after no refs are taken before
  *	entering D0i3 (in msecs)
@@ -131,7 +137,7 @@ struct iwl_mod_params {
 #endif
 	int ant_coupling;
 	char *nvm_file;
-	bool uapsd_disable;
+	u32 uapsd_disable;
 	bool d0i3_disable;
 	unsigned int d0i3_entry_delay;
 	bool lar_disable;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 4b560e4..b96b1c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -75,7 +75,6 @@
 #define IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
 #define IWL_MVM_SHORT_PS_TX_DATA_TIMEOUT	(2 * 1024) /* defined in TU */
 #define IWL_MVM_SHORT_PS_RX_DATA_TIMEOUT	(40 * 1024) /* defined in TU */
-#define IWL_MVM_P2P_UAPSD_STANDALONE		0
 #define IWL_MVM_P2P_LOWLATENCY_PS_ENABLE	0
 #define IWL_MVM_UAPSD_RX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
 #define IWL_MVM_UAPSD_TX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index cff9c16..1a3481b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2345,7 +2345,8 @@ static void iwl_mvm_check_uapsd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return;
 	}
 
-	if (iwlwifi_mod_params.uapsd_disable) {
+	if (!vif->p2p &&
+	    (iwlwifi_mod_params.uapsd_disable & IWL_DISABLE_UAPSD_BSS)) {
 		vif->driver_flags &= ~IEEE80211_VIF_SUPPORTS_UAPSD;
 		return;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 2e0a882..02ef1d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1072,7 +1072,8 @@ bool iwl_mvm_is_p2p_standalone_uapsd_supported(struct iwl_mvm *mvm)
 {
 	return fw_has_capa(&mvm->fw->ucode_capa,
 			   IWL_UCODE_TLV_CAPA_P2P_STANDALONE_UAPSD) &&
-		IWL_MVM_P2P_UAPSD_STANDALONE;
+		!(iwlwifi_mod_params.uapsd_disable &
+		  IWL_DISABLE_UAPSD_P2P_CLIENT);
 }
 
 static inline bool iwl_mvm_has_new_rx_api(struct iwl_mvm *mvm)
-- 
2.5.0

