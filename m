Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab3A1Jiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:38:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 37/37] iwlwifi: add the MVM driver (add to driver)
Date: Mon, 28 Jan 2013 10:37:44 +0100
Message-Id: <1359365864-4259-38-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103906_704245_A8362A90)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer firmware revisions have a completely new
firmware API. This is the new driver for this
new API.

I've listed the people who directly contributed
code, but many others from various teams have
contributed in other ways.

Change-Id: Id62a7ce1b80ec762c9a902b93188d3502837b77b
Cc: Alexander Bondar <alexander.bondar@intel.com>
Cc: Amit Beka <amit.beka@intel.com>
Cc: Amnon Paz <amnonx.paz@intel.com>
Cc: Assaf Krauss <assaf.krauss@intel.com>
Cc: David Spinadel <david.spinadel@intel.com>
Cc: Dor Shaish <dor.shaish@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Cc: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig     | 14 +++++++++++++-
 drivers/net/wireless/iwlwifi/Makefile    |  1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h |  2 ++
 drivers/net/wireless/iwlwifi/iwl-drv.c   | 15 ++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-fw.h    |  1 +
 5 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 5cf4323..ba319cb 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -43,8 +43,20 @@ config IWLWIFI
 	  module will be called iwlwifi.
 
 config IWLDVM
-	tristate "Intel Wireless WiFi"
+	tristate "Intel Wireless WiFi DVM Firmware support"
 	depends on IWLWIFI
+	help
+	  This is the driver supporting the DVM firmware which is
+	  currently the only firmware available for existing devices.
+
+config IWLMVM
+	tristate "Intel Wireless WiFi MVM Firmware support"
+	depends on IWLWIFI
+	help
+	  This is the driver supporting the MVM firmware which is
+	  currently only available for 7000 series devices.
+
+	  Say yes if you have such a device.
 
 menu "Debugging Options"
 	depends on IWLWIFI
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 2d4d47a..6c78000 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -17,5 +17,6 @@ ccflags-y += -D__CHECK_ENDIAN__ -I$(src)
 
 
 obj-$(CONFIG_IWLDVM)	+= dvm/
+obj-$(CONFIG_IWLMVM)	+= mvm/
 
 CFLAGS_iwl-devtrace.o := -I$(src)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index b59ec4c..8cf5db7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -116,6 +116,7 @@ do {                                            			\
 #define IWL_DL_HCMD		0x00000004
 #define IWL_DL_STATE		0x00000008
 /* 0x000000F0 - 0x00000010 */
+#define IWL_DL_TE		0x00000020
 #define IWL_DL_EEPROM		0x00000040
 #define IWL_DL_RADIO		0x00000080
 /* 0x00000F00 - 0x00000100 */
@@ -156,6 +157,7 @@ do {                                            			\
 #define IWL_DEBUG_LED(p, f, a...)	IWL_DEBUG(p, IWL_DL_LED, f, ## a)
 #define IWL_DEBUG_WEP(p, f, a...)	IWL_DEBUG(p, IWL_DL_WEP, f, ## a)
 #define IWL_DEBUG_HC(p, f, a...)	IWL_DEBUG(p, IWL_DL_HCMD, f, ## a)
+#define IWL_DEBUG_TE(p, f, a...)	IWL_DEBUG(p, IWL_DL_TE, f, ## a)
 #define IWL_DEBUG_EEPROM(d, f, a...)	IWL_DEBUG_DEV(d, IWL_DL_EEPROM, f, ## a)
 #define IWL_DEBUG_CALIB(p, f, a...)	IWL_DEBUG(p, IWL_DL_CALIB, f, ## a)
 #define IWL_DEBUG_FW(p, f, a...)	IWL_DEBUG(p, IWL_DL_FW, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index c675196..6f228bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -139,8 +139,10 @@ struct iwl_drv {
 #endif
 };
 
-#define DVM_OP_MODE	0
-#define MVM_OP_MODE	1
+enum {
+	DVM_OP_MODE =	0,
+	MVM_OP_MODE =	1,
+};
 
 /* Protects the table contents, i.e. the ops pointer & drv list */
 static struct mutex iwlwifi_opmode_table_mtx;
@@ -149,8 +151,8 @@ static struct iwlwifi_opmode_table {
 	const struct iwl_op_mode_ops *ops;	/* pointer to op_mode ops */
 	struct list_head drv;		/* list of devices using this op_mode */
 } iwlwifi_opmode_table[] = {		/* ops set when driver is initialized */
-	{ .name = "iwldvm", .ops = NULL },
-	{ .name = "iwlmvm", .ops = NULL },
+	[DVM_OP_MODE] = { .name = "iwldvm", .ops = NULL },
+	[MVM_OP_MODE] = { .name = "iwlmvm", .ops = NULL },
 };
 
 /*
@@ -963,7 +965,10 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 
 	mutex_lock(&iwlwifi_opmode_table_mtx);
-	op = &iwlwifi_opmode_table[DVM_OP_MODE];
+	if (fw->mvm_fw)
+		op = &iwlwifi_opmode_table[MVM_OP_MODE];
+	else
+		op = &iwlwifi_opmode_table[DVM_OP_MODE];
 
 	/* add this device to the list of devices using this op_mode */
 	list_add_tail(&drv->list, &op->drv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 1ad31a9..de3c24a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -166,6 +166,7 @@ struct iwl_tlv_calib_ctrl {
  * @inst_evtlog_ptr: event log offset for runtime ucode.
  * @inst_evtlog_size: event log size for runtime ucode.
  * @inst_errlog_ptr: error log offfset for runtime ucode.
+ * @mvm_fw: indicates this is MVM firmware
  */
 struct iwl_fw {
 	u32 ucode_ver;
-- 
1.8.0

