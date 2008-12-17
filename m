Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbYLQI7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:45 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Wu, Fengguang" <fengguang.wu@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/8] iwlwifi: use type uint for module param debug
Date: Wed, 17 Dec 2008 16:52:30 +0800
Message-Id: <1229503954-30347-5-git-send-email-yi.zhu@intel.com> (sfid-20081217_095949_358966_6F0EA230)
In-Reply-To: <1229503954-30347-4-git-send-email-yi.zhu@intel.com>
References: <1229503954-30347-1-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-2-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-3-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wu, Fengguang <fengguang.wu@intel.com>

This enables one to change the debug level at bit 31.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a7e6e32..3a78d86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2354,7 +2354,7 @@ module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
 module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, 0444);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(debug, iwl4965_mod_params.debug, int, 0444);
+module_param_named(debug, iwl4965_mod_params.debug, uint, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(
 	disable_hw_scan, iwl4965_mod_params.disable_hw_scan, int, 0444);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 2344de9..7f3a921 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1623,7 +1623,7 @@ MODULE_PARM_DESC(disable50,
 module_param_named(swcrypto50, iwl50_mod_params.sw_crypto, bool, 0444);
 MODULE_PARM_DESC(swcrypto50,
 		  "using software crypto engine (default 0 [hardware])\n");
-module_param_named(debug50, iwl50_mod_params.debug, int, 0444);
+module_param_named(debug50, iwl50_mod_params.debug, uint, 0444);
 MODULE_PARM_DESC(debug50, "50XX debug output mask");
 module_param_named(queues_num50, iwl50_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num50, "number of hw queues in 50xx series");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 08b842f..7c3a20a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -154,7 +154,7 @@ struct iwl_ops {
 struct iwl_mod_params {
 	int disable;		/* def: 0 = enable radio */
 	int sw_crypto;		/* def: 0 = using hardware encryption */
-	int debug;		/* def: 0 = minimal debug log messages */
+	u32 debug;		/* def: 0 = minimal debug log messages */
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
 	int num_of_ampdu_queues;/* def: HW dependent */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 161d812..dad8e6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -65,7 +65,7 @@ static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
 
 /* module parameters */
 static int iwl3945_param_disable_hw_scan; /* def: 0 = use 3945's h/w scan */
-static int iwl3945_param_debug;    /* def: 0 = minimal debug log messages */
+static u32 iwl3945_param_debug;    /* def: 0 = minimal debug log messages */
 static int iwl3945_param_disable;  /* def: 0 = enable radio */
 static int iwl3945_param_antenna;  /* def: 0 = both antennas (use diversity) */
 int iwl3945_param_hwcrypto;        /* def: 0 = use software encryption */
@@ -8361,7 +8361,7 @@ MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
 module_param_named(hwcrypto, iwl3945_param_hwcrypto, int, 0444);
 MODULE_PARM_DESC(hwcrypto,
 		 "using hardware crypto engine (default 0 [software])\n");
-module_param_named(debug, iwl3945_param_debug, int, 0444);
+module_param_named(debug, iwl3945_param_debug, uint, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(disable_hw_scan, iwl3945_param_disable_hw_scan, int, 0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
-- 
1.5.3.6

