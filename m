Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbbLAJ7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:24 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/41] iwlwifi: generalize d0i3_entry_timeout module parameter
Date: Tue,  1 Dec 2015 11:58:37 +0200
Message-Id: <1448963947-24302-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105932_179829_6BD65B48)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The PCIe transport will also need a d0i3_entry_timeout_ms parameter,
so move the existing one from the slave transports to iwlwifi, so it
can be reused.  While at it, rename the parameter to something
shorter, namely d0i3_entry_delay.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 5 +++++
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 48f090a..eedd0d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1539,6 +1539,7 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.bt_coex_active = true,
 	.power_level = IWL_POWER_INDEX_1,
 	.d0i3_disable = true,
+	.d0i3_entry_delay = 1000,
 #ifndef CONFIG_IWLWIFI_UAPSD
 	.uapsd_disable = true,
 #endif /* CONFIG_IWLWIFI_UAPSD */
@@ -1704,3 +1705,7 @@ MODULE_PARM_DESC(power_level,
 module_param_named(fw_monitor, iwlwifi_mod_params.fw_monitor, bool, S_IRUGO);
 MODULE_PARM_DESC(fw_monitor,
 		 "firmware monitor - to debug FW (default: false - needs lots of memory)");
+
+module_param_named(d0i3_timeout, iwlwifi_mod_params.d0i3_entry_delay,
+		   uint, S_IRUGO);
+MODULE_PARM_DESC(d0i3_timeout, "Timeout to D0i3 entry when idle (ms)");
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index 3436c00..9baf9ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -109,6 +109,8 @@ enum iwl_amsdu_size {
  * @debug_level: levels are IWL_DL_*
  * @ant_coupling: antenna coupling in dB, default = 0
  * @d0i3_disable: disable d0i3, default = 1,
+ * @d0i3_entry_delay: time to wait after no refs are taken before
+ *	entering D0i3 (in msecs)
  * @lar_disable: disable LAR (regulatory), default = 0
  * @fw_monitor: allow to use firmware monitor
  */
@@ -128,6 +130,7 @@ struct iwl_mod_params {
 	char *nvm_file;
 	bool uapsd_disable;
 	bool d0i3_disable;
+	unsigned int d0i3_entry_delay;
 	bool lar_disable;
 	bool fw_monitor;
 };
-- 
2.5.0

