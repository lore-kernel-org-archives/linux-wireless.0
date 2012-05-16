Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759681Ab2EPUyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:54:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>
Subject: [PATCH 6/9] iwlwifi: implement dynamic opmode loading
Date: Wed, 16 May 2012 22:54:27 +0200
Message-Id: <1337201670-21604-7-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225451_214372_1643411D)
In-Reply-To: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
References: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

This is the next step in splitting up the driver,
making the uCode API dependent pieces of it live
in separate modules. Right now there's only one
so it's not user-selectable, but we're actively
working on more.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    5 ++
 drivers/net/wireless/iwlwifi/Makefile       |   32 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.c    |    6 ++
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |    5 ++
 drivers/net/wireless/iwlwifi/iwl-drv.c      |  112 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-io.c       |   19 +++++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h  |    3 +
 8 files changed, 172 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 2463c06..727fbb5 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -6,6 +6,7 @@ config IWLWIFI
 	select LEDS_CLASS
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
+	select IWLDVM
 	---help---
 	  Select to build the driver supporting the:
 
@@ -41,6 +42,10 @@ config IWLWIFI
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwlwifi.
 
+config IWLDVM
+	tristate "Intel Wireless WiFi"
+	depends on IWLWIFI
+
 menu "Debugging Options"
 	depends on IWLWIFI
 
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index d615eac..f284ea8 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,27 +1,31 @@
+# DVM
+obj-$(CONFIG_IWLDVM)   += iwldvm.o
+iwldvm-objs		:= iwl-agn.o iwl-agn-rs.o iwl-mac80211.o
+iwldvm-objs		+= iwl-ucode.o iwl-agn-tx.o
+iwldvm-objs		+= iwl-agn-lib.o iwl-agn-calib.o
+iwldvm-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-rx.o
+iwldvm-objs		+= iwl-eeprom.o iwl-power.o
+iwldvm-objs		+= iwl-scan.o iwl-led.o
+iwldvm-objs		+= iwl-agn-rxon.o iwl-agn-devices.o
+iwldvm-objs		+= iwl-notif-wait.o
+
+iwldvm-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
+iwldvm-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-testmode.o
+
+CFLAGS_iwl-devtrace.o := -I$(src)
+
 # WIFI
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
-iwlwifi-objs		:= iwl-agn.o iwl-agn-rs.o iwl-mac80211.o
-iwlwifi-objs		+= iwl-ucode.o iwl-agn-tx.o iwl-debug.o
-iwlwifi-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
-iwlwifi-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-rx.o
-
-iwlwifi-objs		+= iwl-eeprom.o iwl-power.o
-iwlwifi-objs		+= iwl-scan.o iwl-led.o
-iwlwifi-objs		+= iwl-agn-rxon.o iwl-agn-devices.o
 iwlwifi-objs		+= iwl-5000.o
 iwlwifi-objs		+= iwl-6000.o
 iwlwifi-objs		+= iwl-1000.o
 iwlwifi-objs		+= iwl-2000.o
+iwlwifi-objs		+= iwl-io.o
 iwlwifi-objs		+= iwl-pci.o
 iwlwifi-objs		+= iwl-drv.o
-iwlwifi-objs		+= iwl-notif-wait.o
+iwlwifi-objs		+= iwl-debug.o
 iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
-
-iwlwifi-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
-iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-testmode.o
-
-CFLAGS_iwl-devtrace.o := -I$(src)
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ec36e2b..5149e6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -78,7 +78,6 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("iwlagn");
 
 void iwl_update_chain_flags(struct iwl_priv *priv)
 {
@@ -2344,24 +2343,25 @@ static int __init iwl_init(void)
 		goto error_rc_register;
 	}
 
-	ret = iwl_pci_register_driver();
-	if (ret)
-		goto error_pci_register;
+	ret = iwl_opmode_register("iwldvm", &iwl_dvm_ops);
+	if (ret) {
+		pr_err("Unable to register op_mode: %d\n", ret);
+		goto error_opmode_register;
+	}
 	return ret;
 
-error_pci_register:
+error_opmode_register:
 	iwlagn_rate_control_unregister();
 error_rc_register:
 	kmem_cache_destroy(iwl_tx_cmd_pool);
 	return ret;
 }
+module_init(iwl_init);
 
 static void __exit iwl_exit(void)
 {
-	iwl_pci_unregister_driver();
+	iwl_opmode_deregister("iwldvm");
 	iwlagn_rate_control_unregister();
 	kmem_cache_destroy(iwl_tx_cmd_pool);
 }
-
 module_exit(iwl_exit);
-module_init(iwl_init);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.c b/drivers/net/wireless/iwlwifi/iwl-debug.c
index 2d1b428..0f8fcd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.c
@@ -62,6 +62,7 @@
  *****************************************************************************/
 
 #include <linux/interrupt.h>
+#include <linux/export.h>
 #include "iwl-debug.h"
 #include "iwl-devtrace.h"
 
@@ -81,8 +82,11 @@ void __iwl_ ##fn(struct device *dev, const char *fmt, ...)	\
 }
 
 __iwl_fn(warn)
+EXPORT_SYMBOL_GPL(__iwl_warn);
 __iwl_fn(info)
+EXPORT_SYMBOL_GPL(__iwl_info);
 __iwl_fn(crit)
+EXPORT_SYMBOL_GPL(__iwl_crit);
 
 void __iwl_err(struct device *dev, bool rfkill_prefix, bool trace_only,
 		const char *fmt, ...)
@@ -103,6 +107,7 @@ void __iwl_err(struct device *dev, bool rfkill_prefix, bool trace_only,
 	trace_iwlwifi_err(&vaf);
 	va_end(args);
 }
+EXPORT_SYMBOL_GPL(__iwl_err);
 
 #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
 void __iwl_dbg(struct device *dev,
@@ -125,4 +130,5 @@ void __iwl_dbg(struct device *dev,
 	trace_iwlwifi_dbg(level, in_interrupt(), function, &vaf);
 	va_end(args);
 }
+EXPORT_SYMBOL_GPL(__iwl_dbg);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index 91f45e7..70191dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -42,4 +42,9 @@ EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_error);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_cont_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_wrap_event);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_info);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_warn);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_crit);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_err);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dbg);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index d742900..cdfdfae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -77,8 +77,33 @@
 /* private includes */
 #include "iwl-fw-file.h"
 
+/******************************************************************************
+ *
+ * module boiler plate
+ *
+ ******************************************************************************/
+
+/*
+ * module name, copyright, version, etc.
+ */
+#define DRV_DESCRIPTION	"Intel(R) Wireless WiFi driver for Linux"
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+#define VD "d"
+#else
+#define VD
+#endif
+
+#define DRV_VERSION     IWLWIFI_VERSION VD
+
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_VERSION(DRV_VERSION);
+MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
+MODULE_LICENSE("GPL");
+
 /**
  * struct iwl_drv - drv common data
+ * @list: list of drv structures using this opmode
  * @fw: the iwl_fw structure
  * @op_mode: the running op_mode
  * @trans: transport layer
@@ -89,6 +114,7 @@
  * @request_firmware_complete: the firmware has been obtained from user space
  */
 struct iwl_drv {
+	struct list_head list;
 	struct iwl_fw fw;
 
 	struct iwl_op_mode *op_mode;
@@ -102,7 +128,17 @@ struct iwl_drv {
 	struct completion request_firmware_complete;
 };
 
+#define DVM_OP_MODE	0
+#define MVM_OP_MODE	1
 
+static struct iwlwifi_opmode_table {
+	const char *name;			/* name: iwldvm, iwlmvm, etc */
+	const struct iwl_op_mode_ops *ops;	/* pointer to op_mode ops */
+	struct list_head drv;		/* list of devices using this op_mode */
+} iwlwifi_opmode_table[] = {		/* ops set when driver is initialized */
+	{ .name = "iwldvm", .ops = NULL },
+	{ .name = "iwlmvm", .ops = NULL },
+};
 
 /*
  * struct fw_sec: Just for the image parsing proccess.
@@ -721,7 +757,6 @@ static int validate_sec_sizes(struct iwl_drv *drv,
 	return 0;
 }
 
-
 /**
  * iwl_ucode_callback - callback when firmware was loaded
  *
@@ -733,6 +768,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	struct iwl_drv *drv = context;
 	struct iwl_fw *fw = &drv->fw;
 	struct iwl_ucode_header *ucode;
+	struct iwlwifi_opmode_table *op;
 	int err;
 	struct iwl_firmware_pieces pieces;
 	const unsigned int api_max = drv->cfg->ucode_api_max;
@@ -863,10 +899,17 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 	complete(&drv->request_firmware_complete);
 
-	drv->op_mode = iwl_dvm_ops.start(drv->trans, drv->cfg, &drv->fw);
+	op = &iwlwifi_opmode_table[DVM_OP_MODE];
 
-	if (!drv->op_mode)
-		goto out_free_fw;
+	/* add this device to the list of devices using this op_mode */
+	list_add_tail(&drv->list, &op->drv);
+
+	if (op->ops) {
+		const struct iwl_op_mode_ops *ops = op->ops;
+		drv->op_mode = ops->start(drv->trans, drv->cfg, &drv->fw);
+	} else {
+		request_module_nowait("%s", op->name);
+	}
 
 	return;
 
@@ -938,6 +981,67 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.auto_agg = true,
 	/* the rest are 0 by default */
 };
+EXPORT_SYMBOL_GPL(iwlwifi_mod_params);
+
+int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops)
+{
+	int i;
+	struct iwl_drv *drv;
+
+	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++) {
+		if (strcmp(iwlwifi_opmode_table[i].name, name))
+			continue;
+		iwlwifi_opmode_table[i].ops = ops;
+		list_for_each_entry(drv, &iwlwifi_opmode_table[i].drv, list)
+			drv->op_mode = ops->start(drv->trans, drv->cfg,
+						  &drv->fw);
+		return 0;
+	}
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(iwl_opmode_register);
+
+void iwl_opmode_deregister(const char *name)
+{
+	int i;
+	struct iwl_drv *drv;
+
+	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++) {
+		if (strcmp(iwlwifi_opmode_table[i].name, name))
+			continue;
+		iwlwifi_opmode_table[i].ops = NULL;
+
+		/* call the stop routine for all devices */
+		list_for_each_entry(drv, &iwlwifi_opmode_table[i].drv, list) {
+			if (drv->op_mode) {
+				iwl_op_mode_stop(drv->op_mode);
+				drv->op_mode = NULL;
+			}
+		}
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(iwl_opmode_deregister);
+
+static int __init iwl_drv_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++)
+		INIT_LIST_HEAD(&iwlwifi_opmode_table[i].drv);
+
+	pr_info(DRV_DESCRIPTION ", " DRV_VERSION "\n");
+	pr_info(DRV_COPYRIGHT "\n");
+
+	return iwl_pci_register_driver();
+}
+module_init(iwl_drv_init);
+
+static void __exit iwl_drv_exit(void)
+{
+	iwl_pci_unregister_driver();
+}
+module_exit(iwl_drv_exit);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 module_param_named(debug, iwlwifi_mod_params.debug_level, uint,
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 081dd34..ee93274 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -27,6 +27,7 @@
  *****************************************************************************/
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/export.h>
 
 #include "iwl-io.h"
 #include"iwl-csr.h"
@@ -52,6 +53,7 @@ void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 	__iwl_set_bit(trans, reg, mask);
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(iwl_set_bit);
 
 void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
@@ -61,6 +63,7 @@ void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 	__iwl_clear_bit(trans, reg, mask);
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(iwl_clear_bit);
 
 int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 		 u32 bits, u32 mask, int timeout)
@@ -76,6 +79,7 @@ int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 
 	return -ETIMEDOUT;
 }
+EXPORT_SYMBOL_GPL(iwl_poll_bit);
 
 int iwl_grab_nic_access_silent(struct iwl_trans *trans)
 {
@@ -117,6 +121,7 @@ int iwl_grab_nic_access_silent(struct iwl_trans *trans)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(iwl_grab_nic_access_silent);
 
 bool iwl_grab_nic_access(struct iwl_trans *trans)
 {
@@ -130,6 +135,7 @@ bool iwl_grab_nic_access(struct iwl_trans *trans)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(iwl_grab_nic_access);
 
 void iwl_release_nic_access(struct iwl_trans *trans)
 {
@@ -144,6 +150,7 @@ void iwl_release_nic_access(struct iwl_trans *trans)
 	 */
 	mmiowb();
 }
+EXPORT_SYMBOL_GPL(iwl_release_nic_access);
 
 u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
 {
@@ -158,6 +165,7 @@ u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
 
 	return value;
 }
+EXPORT_SYMBOL_GPL(iwl_read_direct32);
 
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 {
@@ -170,6 +178,7 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(iwl_write_direct32);
 
 int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 			int timeout)
@@ -185,6 +194,7 @@ int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 
 	return -ETIMEDOUT;
 }
+EXPORT_SYMBOL_GPL(iwl_poll_direct_bit);
 
 static inline u32 __iwl_read_prph(struct iwl_trans *trans, u32 reg)
 {
@@ -211,6 +221,7 @@ u32 iwl_read_prph(struct iwl_trans *trans, u32 reg)
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 	return val;
 }
+EXPORT_SYMBOL_GPL(iwl_read_prph);
 
 void iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
 {
@@ -223,6 +234,7 @@ void iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(iwl_write_prph);
 
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 {
@@ -236,6 +248,7 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(iwl_set_bits_prph);
 
 void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 reg,
 			    u32 bits, u32 mask)
@@ -250,6 +263,7 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 reg,
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(iwl_set_bits_mask_prph);
 
 void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 {
@@ -264,6 +278,7 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(iwl_clear_bits_prph);
 
 void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 			      void *buf, int words)
@@ -281,6 +296,7 @@ void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 	}
 	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(_iwl_read_targ_mem_words);
 
 u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr)
 {
@@ -290,6 +306,7 @@ u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr)
 
 	return value;
 }
+EXPORT_SYMBOL_GPL(iwl_read_targ_mem);
 
 int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 				void *buf, int words)
@@ -310,8 +327,10 @@ int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 
 	return result;
 }
+EXPORT_SYMBOL_GPL(_iwl_write_targ_mem_words);
 
 int iwl_write_targ_mem(struct iwl_trans *trans, u32 addr, u32 val)
 {
 	return _iwl_write_targ_mem_words(trans, addr, &val, 1);
 }
+EXPORT_SYMBOL_GPL(iwl_write_targ_mem);
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 4ef742b..cec133c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -145,6 +145,9 @@ struct iwl_op_mode_ops {
 	void (*wimax_active)(struct iwl_op_mode *op_mode);
 };
 
+int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops);
+void iwl_opmode_deregister(const char *name);
+
 /**
  * struct iwl_op_mode - operational mode
  *
-- 
1.7.10

