Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9103 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYLBUNQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/11] iwlwifi: rely on API version read from firmware
Date: Tue,  2 Dec 2008 12:14:06 -0800
Message-Id: <1228248847-10424-11-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211332_078079_79ACF333)
In-Reply-To: <1228248847-10424-10-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-8-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-9-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the infrastructure to support older firmware APIs.
The API version number is stored as part of the filename, we first try to
load the most recent firmware and progressively try lower versions.
The API version is also read from the firmware self and stored as part
of the iwl_priv structure. Only firmware that is supported by driver will
be loaded. The version number read from firmware is compared
to supported versions in the driver not the API version used as part of
filename.

An example using this new infrastrucure:
   if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
        Driver interacts with Firmware API version >= 2.
   } else {
        Driver interacts with Firmware API version 1.
   }

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-core.h |   26 ++++++++++-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    8 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.h      |   14 ++++--
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   21 +++++---
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   46 ++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   62 ++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h      |   32 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   64 ++++++++++++++++++++------
 8 files changed, 217 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-core.h b/drivers/net/wireless/iwlwifi/iwl-3945-core.h
index bc12f97..edac6c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-core.h
@@ -71,9 +71,33 @@
 #define IWL_SKU_G       0x1
 #define IWL_SKU_A       0x2
 
+/**
+ * struct iwl_3945_cfg
+ * @fw_name_pre: Firmware filename prefix. The api version and extension
+ * 	(.ucode) will be added to filename before loading from disk. The
+ * 	filename is constructed as fw_name_pre<api>.ucode.
+ * @ucode_api_max: Highest version of uCode API supported by driver.
+ * @ucode_api_min: Lowest version of uCode API supported by driver.
+ *
+ * We enable the driver to be backward compatible wrt API version. The
+ * driver specifies which APIs it supports (with @ucode_api_max being the
+ * highest and @ucode_api_min the lowest). Firmware will only be loaded if
+ * it has a supported API version. The firmware's API version will be
+ * stored in @iwl_priv, enabling the driver to make runtime changes based
+ * on firmware version used.
+ *
+ * For example,
+ * if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
+ * 	Driver interacts with Firmware API version >= 2.
+ * } else {
+ * 	Driver interacts with Firmware API version 1.
+ * }
+ */
 struct iwl_3945_cfg {
 	const char *name;
-	const char *fw_name;
+	const char *fw_name_pre;
+	const unsigned int ucode_api_max;
+	const unsigned int ucode_api_min;
 	unsigned int sku;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d422600..6602729 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2509,13 +2509,17 @@ void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv)
 
 static struct iwl_3945_cfg iwl3945_bg_cfg = {
 	.name = "3945BG",
-	.fw_name = "iwlwifi-3945" IWL3945_UCODE_API ".ucode",
+	.fw_name_pre = IWL3945_FW_PRE,
+	.ucode_api_max = IWL3945_UCODE_API_MAX,
+	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
 };
 
 static struct iwl_3945_cfg iwl3945_abg_cfg = {
 	.name = "3945ABG",
-	.fw_name = "iwlwifi-3945" IWL3945_UCODE_API ".ucode",
+	.fw_name_pre = IWL3945_FW_PRE,
+	.ucode_api_max = IWL3945_UCODE_API_MAX,
+	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 972c454..d6502b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -50,11 +50,15 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-3945-debug.h"
 #include "iwl-3945-led.h"
 
-/* Change firmware file name, using "-" and incrementing number,
- *   *only* when uCode interface or architecture changes so that it
- *   is not compatible with earlier drivers.
- * This number will also appear in << 8 position of 1st dword of uCode file */
-#define IWL3945_UCODE_API "-1"
+/* Highest firmware API version supported */
+#define IWL3945_UCODE_API_MAX 1
+
+/* Lowest firmware API version supported */
+#define IWL3945_UCODE_API_MIN 1
+
+#define IWL3945_FW_PRE	"iwlwifi-3945-"
+#define _IWL3945_MODULE_FIRMWARE(api) IWL3945_FW_PRE #api ".ucode"
+#define IWL3945_MODULE_FIRMWARE(api) _IWL3945_MODULE_FIRMWARE(api)
 
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 93d3df8..87c7bb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -48,12 +48,15 @@
 static int iwl4965_send_tx_power(struct iwl_priv *priv);
 static int iwl4965_hw_get_temperature(const struct iwl_priv *priv);
 
-/* Change firmware file name, using "-" and incrementing number,
- *   *only* when uCode interface or architecture changes so that it
- *   is not compatible with earlier drivers.
- * This number will also appear in << 8 position of 1st dword of uCode file */
-#define IWL4965_UCODE_API "-2"
-#define IWL4965_MODULE_FIRMWARE "iwlwifi-4965" IWL4965_UCODE_API ".ucode"
+/* Highest firmware API version supported */
+#define IWL4965_UCODE_API_MAX 2
+
+/* Lowest firmware API version supported */
+#define IWL4965_UCODE_API_MIN 2
+
+#define IWL4965_FW_PRE "iwlwifi-4965-"
+#define _IWL4965_MODULE_FIRMWARE(api) IWL4965_FW_PRE #api ".ucode"
+#define IWL4965_MODULE_FIRMWARE(api) _IWL4965_MODULE_FIRMWARE(api)
 
 
 /* module parameters */
@@ -2336,7 +2339,9 @@ static struct iwl_ops iwl4965_ops = {
 
 struct iwl_cfg iwl4965_agn_cfg = {
 	.name = "4965AGN",
-	.fw_name = IWL4965_MODULE_FIRMWARE,
+	.fw_name_pre = IWL4965_FW_PRE,
+	.ucode_api_max = IWL4965_UCODE_API_MAX,
+	.ucode_api_min = IWL4965_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.eeprom_size = IWL4965_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
@@ -2346,7 +2351,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 };
 
 /* Module firmware */
-MODULE_FIRMWARE(IWL4965_MODULE_FIRMWARE);
+MODULE_FIRMWARE(IWL4965_MODULE_FIRMWARE(IWL4965_UCODE_API_MAX));
 
 module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f7a8df8..438e4bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -44,11 +44,21 @@
 #include "iwl-helpers.h"
 #include "iwl-5000-hw.h"
 
-#define IWL5000_UCODE_API  "-1"
-#define IWL5150_UCODE_API  "-1"
+/* Highest firmware API version supported */
+#define IWL5000_UCODE_API_MAX 1
+#define IWL5150_UCODE_API_MAX 1
 
-#define IWL5000_MODULE_FIRMWARE "iwlwifi-5000" IWL5000_UCODE_API ".ucode"
-#define IWL5150_MODULE_FIRMWARE "iwlwifi-5150" IWL5150_UCODE_API ".ucode"
+/* Lowest firmware API version supported */
+#define IWL5000_UCODE_API_MIN 1
+#define IWL5150_UCODE_API_MIN 1
+
+#define IWL5000_FW_PRE "iwlwifi-5000-"
+#define _IWL5000_MODULE_FIRMWARE(api) IWL5000_FW_PRE #api ".ucode"
+#define IWL5000_MODULE_FIRMWARE(api) _IWL5000_MODULE_FIRMWARE(api)
+
+#define IWL5150_FW_PRE "iwlwifi-5150-"
+#define _IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE #api ".ucode"
+#define IWL5150_MODULE_FIRMWARE(api) _IWL5150_MODULE_FIRMWARE(api)
 
 static const u16 iwl5000_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC3,
@@ -1532,7 +1542,9 @@ static struct iwl_mod_params iwl50_mod_params = {
 
 struct iwl_cfg iwl5300_agn_cfg = {
 	.name = "5300AGN",
-	.fw_name = IWL5000_MODULE_FIRMWARE,
+	.fw_name_pre = IWL5000_FW_PRE,
+	.ucode_api_max = IWL5000_UCODE_API_MAX,
+	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1543,7 +1555,9 @@ struct iwl_cfg iwl5300_agn_cfg = {
 
 struct iwl_cfg iwl5100_bg_cfg = {
 	.name = "5100BG",
-	.fw_name = IWL5000_MODULE_FIRMWARE,
+	.fw_name_pre = IWL5000_FW_PRE,
+	.ucode_api_max = IWL5000_UCODE_API_MAX,
+	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1554,7 +1568,9 @@ struct iwl_cfg iwl5100_bg_cfg = {
 
 struct iwl_cfg iwl5100_abg_cfg = {
 	.name = "5100ABG",
-	.fw_name = IWL5000_MODULE_FIRMWARE,
+	.fw_name_pre = IWL5000_FW_PRE,
+	.ucode_api_max = IWL5000_UCODE_API_MAX,
+	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1565,7 +1581,9 @@ struct iwl_cfg iwl5100_abg_cfg = {
 
 struct iwl_cfg iwl5100_agn_cfg = {
 	.name = "5100AGN",
-	.fw_name = IWL5000_MODULE_FIRMWARE,
+	.fw_name_pre = IWL5000_FW_PRE,
+	.ucode_api_max = IWL5000_UCODE_API_MAX,
+	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1576,7 +1594,9 @@ struct iwl_cfg iwl5100_agn_cfg = {
 
 struct iwl_cfg iwl5350_agn_cfg = {
 	.name = "5350AGN",
-	.fw_name = IWL5000_MODULE_FIRMWARE,
+	.fw_name_pre = IWL5000_FW_PRE,
+	.ucode_api_max = IWL5000_UCODE_API_MAX,
+	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1587,7 +1607,9 @@ struct iwl_cfg iwl5350_agn_cfg = {
 
 struct iwl_cfg iwl5150_agn_cfg = {
 	.name = "5150AGN",
-	.fw_name = IWL5150_MODULE_FIRMWARE,
+	.fw_name_pre = IWL5150_FW_PRE,
+	.ucode_api_max = IWL5150_UCODE_API_MAX,
+	.ucode_api_min = IWL5150_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
@@ -1596,8 +1618,8 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 };
 
-MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE);
-MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE);
+MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
 
 module_param_named(disable50, iwl50_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable50,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c906260..fc4e7e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1574,24 +1574,40 @@ static void iwl_nic_start(struct iwl_priv *priv)
 static int iwl_read_ucode(struct iwl_priv *priv)
 {
 	struct iwl_ucode *ucode;
-	int ret;
+	int ret = -EINVAL, index;
 	const struct firmware *ucode_raw;
-	const char *name = priv->cfg->fw_name;
+	const char *name_pre = priv->cfg->fw_name_pre;
+	const unsigned int api_max = priv->cfg->ucode_api_max;
+	const unsigned int api_min = priv->cfg->ucode_api_min;
+	char buf[25];
 	u8 *src;
 	size_t len;
-	u32 inst_size, data_size, init_size, init_data_size, boot_size;
+	u32 api_ver, inst_size, data_size, init_size, init_data_size, boot_size;
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
 	 * request_firmware() is synchronous, file is in memory on return. */
-	ret = request_firmware(&ucode_raw, name, &priv->pci_dev->dev);
-	if (ret < 0) {
-		IWL_ERROR("%s firmware file req failed: Reason %d\n",
-					name, ret);
-		goto error;
+	for (index = api_max; index >= api_min; index--) {
+		sprintf(buf, "%s%d%s", name_pre, index, ".ucode");
+		ret = request_firmware(&ucode_raw, buf, &priv->pci_dev->dev);
+		if (ret < 0) {
+			IWL_ERROR("%s firmware file req failed: Reason %d\n",
+				  buf, ret);
+			if (ret == -ENOENT)
+				continue;
+			else
+				goto error;
+		} else {
+			if (index < api_max)
+				IWL_ERROR("Loaded firmware %s, which is deprecated. Please use API v%u instead.\n",
+					  buf, api_max);
+			IWL_DEBUG_INFO("Got firmware '%s' file (%zd bytes) from disk\n",
+				       buf, ucode_raw->size);
+			break;
+		}
 	}
 
-	IWL_DEBUG_INFO("Got firmware '%s' file (%zd bytes) from disk\n",
-		       name, ucode_raw->size);
+	if (ret < 0)
+		goto error;
 
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size < sizeof(*ucode)) {
@@ -1604,19 +1620,39 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	ucode = (void *)ucode_raw->data;
 
 	priv->ucode_ver = le32_to_cpu(ucode->ver);
+	api_ver = IWL_UCODE_API(priv->ucode_ver);
 	inst_size = le32_to_cpu(ucode->inst_size);
 	data_size = le32_to_cpu(ucode->data_size);
 	init_size = le32_to_cpu(ucode->init_size);
 	init_data_size = le32_to_cpu(ucode->init_data_size);
 	boot_size = le32_to_cpu(ucode->boot_size);
 
-	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
-		       priv->ucode_ver);
-	IWL_DEBUG_INFO("f/w package hdr ucode version = %u.%u.%u.%u\n",
+	/* api_ver should match the api version forming part of the
+	 * firmware filename ... but we don't check for that and only rely
+	 * on the API version read from firware header from here on forward */
+
+	if (api_ver < api_min || api_ver > api_max) {
+		IWL_ERROR("Driver unable to support your firmware API. "
+			  "Driver supports v%u, firmware is v%u.\n",
+			  api_max, api_ver);
+		priv->ucode_ver = 0;
+		ret = -EINVAL;
+		goto err_release;
+	}
+	if (api_ver != api_max)
+		IWL_ERROR("Firmware has old API version. Expected v%u, "
+			  "got v%u. New firmware can be obtained "
+			  "from http://www.intellinuxwireless.org.\n",
+			  api_max, api_ver);
+
+	printk(KERN_INFO DRV_NAME " loaded firmware version %u.%u.%u.%u\n",
 		       IWL_UCODE_MAJOR(priv->ucode_ver),
 		       IWL_UCODE_MINOR(priv->ucode_ver),
 		       IWL_UCODE_API(priv->ucode_ver),
 		       IWL_UCODE_SERIAL(priv->ucode_ver));
+
+	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
+		       priv->ucode_ver);
 	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n",
 		       inst_size);
 	IWL_DEBUG_INFO("f/w package hdr runtime data size = %u\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f68883b..81ddca0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -164,9 +164,39 @@ struct iwl_mod_params {
 	int restart_fw;		/* def: 1 = restart firmware */
 };
 
+/**
+ * struct iwl_cfg
+ * @fw_name_pre: Firmware filename prefix. The api version and extension
+ * 	(.ucode) will be added to filename before loading from disk. The
+ * 	filename is constructed as fw_name_pre<api>.ucode.
+ * @ucode_api_max: Highest version of uCode API supported by driver.
+ * @ucode_api_min: Lowest version of uCode API supported by driver.
+ *
+ * We enable the driver to be backward compatible wrt API version. The
+ * driver specifies which APIs it supports (with @ucode_api_max being the
+ * highest and @ucode_api_min the lowest). Firmware will only be loaded if
+ * it has a supported API version. The firmware's API version will be
+ * stored in @iwl_priv, enabling the driver to make runtime changes based
+ * on firmware version used.
+ *
+ * For example,
+ * if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
+ * 	Driver interacts with Firmware API version >= 2.
+ * } else {
+ * 	Driver interacts with Firmware API version 1.
+ * }
+ *
+ * The ideal usage of this infrastructure is to treat a new ucode API
+ * release as a new hardware revision. That is, through utilizing the
+ * iwl_hcmd_utils_ops etc. we accommodate different command structures
+ * and flows between hardware versions (4965/5000) as well as their API
+ * versions.
+ */
 struct iwl_cfg {
 	const char *name;
-	const char *fw_name;
+	const char *fw_name_pre;
+	const unsigned int ucode_api_max;
+	const unsigned int ucode_api_min;
 	unsigned int sku;
 	int eeprom_size;
 	u16  eeprom_ver;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c003814..8e14607 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5335,25 +5335,41 @@ static void iwl3945_nic_start(struct iwl3945_priv *priv)
 static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 {
 	struct iwl3945_ucode *ucode;
-	int ret = 0;
+	int ret = -EINVAL, index;
 	const struct firmware *ucode_raw;
 	/* firmware file name contains uCode/driver compatibility version */
-	const char *name = priv->cfg->fw_name;
+	const char *name_pre = priv->cfg->fw_name_pre;
+	const unsigned int api_max = priv->cfg->ucode_api_max;
+	const unsigned int api_min = priv->cfg->ucode_api_min;
+	char buf[25];
 	u8 *src;
 	size_t len;
-	u32 inst_size, data_size, init_size, init_data_size, boot_size;
+	u32 api_ver, inst_size, data_size, init_size, init_data_size, boot_size;
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
 	 * request_firmware() is synchronous, file is in memory on return. */
-	ret = request_firmware(&ucode_raw, name, &priv->pci_dev->dev);
-	if (ret < 0) {
-		IWL_ERROR("%s firmware file req failed: Reason %d\n",
-				name, ret);
-		goto error;
+	for (index = api_max; index >= api_min; index--) {
+		sprintf(buf, "%s%u%s", name_pre, index, ".ucode");
+		ret = request_firmware(&ucode_raw, buf, &priv->pci_dev->dev);
+		if (ret < 0) {
+			IWL_ERROR("%s firmware file req failed: Reason %d\n",
+				  buf, ret);
+			if (ret == -ENOENT)
+				continue;
+			else
+				goto error;
+		} else {
+			if (index < api_max)
+				IWL_ERROR("Loaded firmware %s, which is deprecated. Please use API v%u instead.\n",
+					  buf, api_max);
+			IWL_DEBUG_INFO("Got firmware '%s' file (%zd bytes) from disk\n",
+				       buf, ucode_raw->size);
+			break;
+		}
 	}
 
-	IWL_DEBUG_INFO("Got firmware '%s' file (%zd bytes) from disk\n",
-		       name, ucode_raw->size);
+	if (ret < 0)
+		goto error;
 
 	/* Make sure that we got at least our header! */
 	if (ucode_raw->size < sizeof(*ucode)) {
@@ -5366,25 +5382,45 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	ucode = (void *)ucode_raw->data;
 
 	priv->ucode_ver = le32_to_cpu(ucode->ver);
+	api_ver = IWL_UCODE_API(priv->ucode_ver);
 	inst_size = le32_to_cpu(ucode->inst_size);
 	data_size = le32_to_cpu(ucode->data_size);
 	init_size = le32_to_cpu(ucode->init_size);
 	init_data_size = le32_to_cpu(ucode->init_data_size);
 	boot_size = le32_to_cpu(ucode->boot_size);
 
-	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
-		       priv->ucode_ver);
-	IWL_DEBUG_INFO("f/w package hdr ucode version = %u.%u.%u.%u\n",
+	/* api_ver should match the api version forming part of the
+	 * firmware filename ... but we don't check for that and only rely
+	 * on the API version read from firware header from here on forward */
+
+	if (api_ver < api_min || api_ver > api_max) {
+		IWL_ERROR("Driver unable to support your firmware API. "
+			  "Driver supports v%u, firmware is v%u.\n",
+			  api_max, api_ver);
+		priv->ucode_ver = 0;
+		ret = -EINVAL;
+		goto err_release;
+	}
+	if (api_ver != api_max)
+		IWL_ERROR("Firmware has old API version. Expected %u, "
+			  "got %u. New firmware can be obtained "
+			  "from http://www.intellinuxwireless.org.\n",
+			  api_max, api_ver);
+
+	printk(KERN_INFO DRV_NAME " loaded firmware version %u.%u.%u.%u\n",
 		       IWL_UCODE_MAJOR(priv->ucode_ver),
 		       IWL_UCODE_MINOR(priv->ucode_ver),
 		       IWL_UCODE_API(priv->ucode_ver),
 		       IWL_UCODE_SERIAL(priv->ucode_ver));
+	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
+		       priv->ucode_ver);
 	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n", inst_size);
 	IWL_DEBUG_INFO("f/w package hdr runtime data size = %u\n", data_size);
 	IWL_DEBUG_INFO("f/w package hdr init inst size = %u\n", init_size);
 	IWL_DEBUG_INFO("f/w package hdr init data size = %u\n", init_data_size);
 	IWL_DEBUG_INFO("f/w package hdr boot inst size = %u\n", boot_size);
 
+
 	/* Verify size of file vs. image size info in file's header */
 	if (ucode_raw->size < sizeof(*ucode) +
 		inst_size + data_size + init_size +
@@ -8352,7 +8388,7 @@ static void __exit iwl3945_exit(void)
 	iwl3945_rate_control_unregister();
 }
 
-MODULE_FIRMWARE("iwlwifi-3945" IWL3945_UCODE_API ".ucode");
+MODULE_FIRMWARE(IWL3945_MODULE_FIRMWARE(IWL3945_UCODE_API_MAX));
 
 module_param_named(antenna, iwl3945_param_antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-- 
1.5.4.3

