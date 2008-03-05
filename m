Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371AbYCECKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/11] iwlwifi: Take the fw file name from the iwl_cfg.
Date: Tue,  4 Mar 2008 18:09:31 -0800
Message-Id: <1204682972-26004-11-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021129_005692_9D0038CF)
In-Reply-To: <1204682972-26004-10-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-7-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-8-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-9-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds fw_name to iwl_cfg. This allows run time selection
of needed fw/ucode file

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    7 +------
 6 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b909764..49b7811 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2526,11 +2526,13 @@ void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv)
 
 static struct iwl_3945_cfg iwl3945_bg_cfg = {
 	.name = "3945BG",
+	.fw_name = "iwlwifi-3945" IWL3945_UCODE_API ".ucode",
 	.sku = IWL_SKU_G,
 };
 
 static struct iwl_3945_cfg iwl3945_abg_cfg = {
 	.name = "3945ABG",
+	.fw_name = "iwlwifi-3945" IWL3945_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index fa89da2..a238e83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -45,6 +45,12 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-3945-hw.h"
 #include "iwl-3945-debug.h"
 
+/* Change firmware file name, using "-" and incrementing number,
+ *   *only* when uCode interface or architecture changes so that it
+ *   is not compatible with earlier drivers.
+ * This number will also appear in << 8 position of 1st dword of uCode file */
+#define IWL3945_UCODE_API "-1"
+
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
  *   1)  Not associated (4965, no beacon statistics being sent to driver)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8cf1b9c..3e122a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4823,6 +4823,7 @@ void iwl4965_hw_cancel_deferred_work(struct iwl4965_priv *priv)
 
 static struct iwl_cfg iwl4965_agn_cfg = {
 	.name = "4965AGN",
+	.fw_name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 0bfd1b4..057fa15 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -45,6 +45,13 @@ extern struct pci_device_id iwl4965_hw_card_ids[];
 #include "iwl-prph.h"
 #include "iwl-4965-debug.h"
 
+/* Change firmware file name, using "-" and incrementing number,
+ *   *only* when uCode interface or architecture changes so that it
+ *   is not compatible with earlier drivers.
+ * This number will also appear in << 8 position of 1st dword of uCode file */
+#define IWL4965_UCODE_API "-1"
+
+
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
  *   1)  Not associated (4965, no beacon statistics being sent to driver)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0cdc7f8..a130f5d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -96,11 +96,6 @@ int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-/* Change firmware file name, using "-" and incrementing number,
- *   *only* when uCode interface or architecture changes so that it
- *   is not compatible with earlier drivers.
- * This number will also appear in << 8 position of 1st dword of uCode file */
-#define IWL3945_UCODE_API "-1"
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
@@ -5621,7 +5616,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	int ret = 0;
 	const struct firmware *ucode_raw;
 	/* firmware file name contains uCode/driver compatibility version */
-	const char *name = "iwlwifi-3945" IWL3945_UCODE_API ".ucode";
+	const char *name = priv->cfg->fw_name;
 	u8 *src;
 	size_t len;
 	u32 ver, inst_size, data_size, init_size, init_data_size, boot_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index af97e0b..d362c4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -95,11 +95,6 @@ int iwl4965_param_amsdu_size_8K;   /* def: enable 8K amsdu size */
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-/* Change firmware file name, using "-" and incrementing number,
- *   *only* when uCode interface or architecture changes so that it
- *   is not compatible with earlier drivers.
- * This number will also appear in << 8 position of 1st dword of uCode file */
-#define IWL4965_UCODE_API "-1"
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
@@ -6019,7 +6014,7 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	struct iwl4965_ucode *ucode;
 	int ret;
 	const struct firmware *ucode_raw;
-	const char *name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode";
+	const char *name = priv->cfg->fw_name;
 	u8 *src;
 	size_t len;
 	u32 ver, inst_size, data_size, init_size, init_data_size, boot_size;
-- 
1.5.3.4

