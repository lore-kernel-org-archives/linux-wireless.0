Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936Ab1KRIXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8N6d1022887
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:23:06 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 65/77] iwlegacy: merge iwl-debug.h into common.h
Date: Fri, 18 Nov 2011 09:22:27 +0100
Message-Id: <1321604559-10707-65-git-send-email-sgruszka@redhat.com> (sfid-20111118_092351_166386_2F03076B)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.h      |    1 -
 drivers/net/wireless/iwlegacy/4965.h      |    2 -
 drivers/net/wireless/iwlegacy/Kconfig     |    2 +-
 drivers/net/wireless/iwlegacy/common.c    |    1 -
 drivers/net/wireless/iwlegacy/common.h    |  191 +++++++++++++++++++++++++----
 drivers/net/wireless/iwlegacy/debug.c     |    2 -
 drivers/net/wireless/iwlegacy/iwl-debug.h |  175 --------------------------
 7 files changed, 165 insertions(+), 209 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-debug.h

diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index ed367bb..1a2430b 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -35,7 +35,6 @@
 extern const struct pci_device_id il3945_hw_card_ids[];
 
 #include "common.h"
-#include "iwl-debug.h"
 
 /* Highest firmware API version supported */
 #define IL3945_UCODE_API_MAX 2
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 10d0b13..a4e256b 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -30,8 +30,6 @@
 #ifndef __il_4965_h__
 #define __il_4965_h__
 
-#include "iwl-debug.h"
-
 struct il_rx_queue;
 struct il_rx_buf;
 struct il_rx_pkt;
diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
index b4be3b4..05bd375 100644
--- a/drivers/net/wireless/iwlegacy/Kconfig
+++ b/drivers/net/wireless/iwlegacy/Kconfig
@@ -29,7 +29,7 @@ config IWLEGACY_DEBUG
 		  % echo 0x43fff > /sys/class/net/wlan0/device/debug_level
 
 	  You can find the list of debug mask values in:
-		  drivers/net/wireless/iwlegacy/iwl-debug.h
+		  drivers/net/wireless/iwlegacy/common.h
 
 	  If this is your first time using this driver, you should say Y here
 	  as the debug information can assist others in helping you resolve
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 5d5efcb..627ac9b 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -40,7 +40,6 @@
 #include <linux/skbuff.h>
 #include <net/mac80211.h>
 
-#include "iwl-debug.h"
 #include "common.h"
 
 const char *il_get_cmd_string(u8 cmd)
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index be057aa..b1d237f 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -37,12 +37,15 @@
 #include "commands.h"
 #include "csr.h"
 #include "prph.h"
-#include "iwl-debug.h"
 
 struct il_host_cmd;
 struct il_cmd;
 struct il_tx_queue;
 
+#define IL_ERR(f, a...) dev_err(&il->pci_dev->dev, f, ## a)
+#define IL_WARN(f, a...) dev_warn(&il->pci_dev->dev, f, ## a)
+#define IL_INFO(f, a...) dev_info(&il->pci_dev->dev, f, ## a)
+
 #define RX_QUEUE_SIZE                         256
 #define RX_QUEUE_MASK                         255
 #define RX_QUEUE_SIZE_LOG                     8
@@ -1515,29 +1518,6 @@ static inline void il_txq_ctx_deactivate(struct il_priv *il, int txq_id)
 	clear_bit(txq_id, &il->txq_ctx_active_msk);
 }
 
-#ifdef CONFIG_IWLEGACY_DEBUG
-/*
- * il_get_debug_level: Return active debug level for device
- *
- * Using sysfs it is possible to set per device debug level. This debug
- * level will be used if set, otherwise the global debug level which can be
- * set via module parameter is used.
- */
-static inline u32 il_get_debug_level(struct il_priv *il)
-{
-	if (il->debug_level)
-		return il->debug_level;
-	else
-		return il_debug_level;
-}
-#else
-static inline u32 il_get_debug_level(struct il_priv *il)
-{
-	return il_debug_level;
-}
-#endif
-
-
 static inline struct ieee80211_hdr *
 il_tx_queue_get_hdr(struct il_priv *il,
 						 int txq_id, int idx)
@@ -2736,18 +2716,15 @@ static inline void il_disable_interrupts(struct il_priv *il)
 	 * from uCode or flow handler (Rx/Tx DMA) */
 	_il_wr(il, CSR_INT, 0xffffffff);
 	_il_wr(il, CSR_FH_INT_STATUS, 0xffffffff);
-	D_ISR("Disabled interrupts\n");
 }
 
 static inline void il_enable_rfkill_int(struct il_priv *il)
 {
-	D_ISR("Enabling rfkill interrupt\n");
 	_il_wr(il, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
 }
 
 static inline void il_enable_interrupts(struct il_priv *il)
 {
-	D_ISR("Enabling interrupts\n");
 	set_bit(S_INT_ENABLED, &il->status);
 	_il_wr(il, CSR_INT_MASK, il->inta_mask);
 }
@@ -3304,4 +3281,164 @@ extern void il3945_rate_control_unregister(void);
 extern int il_power_update_mode(struct il_priv *il, bool force);
 extern void il_power_initialize(struct il_priv *il);
 
+extern u32 il_debug_level;
+
+#ifdef CONFIG_IWLEGACY_DEBUG
+/*
+ * il_get_debug_level: Return active debug level for device
+ *
+ * Using sysfs it is possible to set per device debug level. This debug
+ * level will be used if set, otherwise the global debug level which can be
+ * set via module parameter is used.
+ */
+static inline u32 il_get_debug_level(struct il_priv *il)
+{
+	if (il->debug_level)
+		return il->debug_level;
+	else
+		return il_debug_level;
+}
+#else
+static inline u32 il_get_debug_level(struct il_priv *il)
+{
+	return il_debug_level;
+}
+#endif
+
+#define il_print_hex_error(il, p, len)					\
+do {									\
+	print_hex_dump(KERN_ERR, "iwl data: ",				\
+		       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);		\
+} while (0)
+
+#ifdef CONFIG_IWLEGACY_DEBUG
+#define IL_DBG(level, fmt, args...)					\
+do {									\
+	if (il_get_debug_level(il) & level)				\
+		dev_printk(KERN_ERR, &il->hw->wiphy->dev,		\
+			 "%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
+			__func__ , ## args);				\
+} while (0)
+
+#define il_print_hex_dump(il, level, p, len) 			\
+do {									\
+	if (il_get_debug_level(il) & level)				\
+		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
+			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
+} while (0)
+
+#else
+#define IL_DBG(level, fmt, args...)
+static inline void il_print_hex_dump(struct il_priv *il, int level,
+				      const void *p, u32 len)
+{}
+#endif				/* CONFIG_IWLEGACY_DEBUG */
+
+#ifdef CONFIG_IWLEGACY_DEBUGFS
+int il_dbgfs_register(struct il_priv *il, const char *name);
+void il_dbgfs_unregister(struct il_priv *il);
+#else
+static inline int
+il_dbgfs_register(struct il_priv *il, const char *name)
+{
+	return 0;
+}
+static inline void il_dbgfs_unregister(struct il_priv *il)
+{
+}
+#endif				/* CONFIG_IWLEGACY_DEBUGFS */
+
+/*
+ * To use the debug system:
+ *
+ * If you are defining a new debug classification, simply add it to the #define
+ * list here in the form of
+ *
+ * #define IL_DL_xxxx VALUE
+ *
+ * where xxxx should be the name of the classification (for example, WEP).
+ *
+ * You then need to either add a IL_xxxx_DEBUG() macro definition for your
+ * classification, or use IL_DBG(IL_DL_xxxx, ...) whenever you want
+ * to send output to that classification.
+ *
+ * The active debug levels can be accessed via files
+ *
+ * 	/sys/module/iwl4965/parameters/debug
+ *	/sys/module/iwl3945/parameters/debug
+ * 	/sys/class/net/wlan0/device/debug_level
+ *
+ * when CONFIG_IWLEGACY_DEBUG=y.
+ */
+
+/* 0x0000000F - 0x00000001 */
+#define IL_DL_INFO		(1 << 0)
+#define IL_DL_MAC80211		(1 << 1)
+#define IL_DL_HCMD		(1 << 2)
+#define IL_DL_STATE		(1 << 3)
+/* 0x000000F0 - 0x00000010 */
+#define IL_DL_MACDUMP		(1 << 4)
+#define IL_DL_HCMD_DUMP		(1 << 5)
+#define IL_DL_EEPROM		(1 << 6)
+#define IL_DL_RADIO		(1 << 7)
+/* 0x00000F00 - 0x00000100 */
+#define IL_DL_POWER		(1 << 8)
+#define IL_DL_TEMP		(1 << 9)
+#define IL_DL_NOTIF		(1 << 10)
+#define IL_DL_SCAN		(1 << 11)
+/* 0x0000F000 - 0x00001000 */
+#define IL_DL_ASSOC		(1 << 12)
+#define IL_DL_DROP		(1 << 13)
+#define IL_DL_TXPOWER		(1 << 14)
+#define IL_DL_AP		(1 << 15)
+/* 0x000F0000 - 0x00010000 */
+#define IL_DL_FW		(1 << 16)
+#define IL_DL_RF_KILL		(1 << 17)
+#define IL_DL_FW_ERRORS		(1 << 18)
+#define IL_DL_LED		(1 << 19)
+/* 0x00F00000 - 0x00100000 */
+#define IL_DL_RATE		(1 << 20)
+#define IL_DL_CALIB		(1 << 21)
+#define IL_DL_WEP		(1 << 22)
+#define IL_DL_TX		(1 << 23)
+/* 0x0F000000 - 0x01000000 */
+#define IL_DL_RX		(1 << 24)
+#define IL_DL_ISR		(1 << 25)
+#define IL_DL_HT		(1 << 26)
+/* 0xF0000000 - 0x10000000 */
+#define IL_DL_11H		(1 << 28)
+#define IL_DL_STATS		(1 << 29)
+#define IL_DL_TX_REPLY		(1 << 30)
+#define IL_DL_QOS		(1 << 31)
+
+#define D_INFO(f, a...)		IL_DBG(IL_DL_INFO, f, ## a)
+#define D_MAC80211(f, a...)	IL_DBG(IL_DL_MAC80211, f, ## a)
+#define D_MACDUMP(f, a...)	IL_DBG(IL_DL_MACDUMP, f, ## a)
+#define D_TEMP(f, a...)		IL_DBG(IL_DL_TEMP, f, ## a)
+#define D_SCAN(f, a...)		IL_DBG(IL_DL_SCAN, f, ## a)
+#define D_RX(f, a...)		IL_DBG(IL_DL_RX, f, ## a)
+#define D_TX(f, a...)		IL_DBG(IL_DL_TX, f, ## a)
+#define D_ISR(f, a...)		IL_DBG(IL_DL_ISR, f, ## a)
+#define D_LED(f, a...)		IL_DBG(IL_DL_LED, f, ## a)
+#define D_WEP(f, a...)		IL_DBG(IL_DL_WEP, f, ## a)
+#define D_HC(f, a...)		IL_DBG(IL_DL_HCMD, f, ## a)
+#define D_HC_DUMP(f, a...)	IL_DBG(IL_DL_HCMD_DUMP, f, ## a)
+#define D_EEPROM(f, a...)	IL_DBG(IL_DL_EEPROM, f, ## a)
+#define D_CALIB(f, a...)	IL_DBG(IL_DL_CALIB, f, ## a)
+#define D_FW(f, a...)		IL_DBG(IL_DL_FW, f, ## a)
+#define D_RF_KILL(f, a...)	IL_DBG(IL_DL_RF_KILL, f, ## a)
+#define D_DROP(f, a...)		IL_DBG(IL_DL_DROP, f, ## a)
+#define D_AP(f, a...)		IL_DBG(IL_DL_AP, f, ## a)
+#define D_TXPOWER(f, a...)	IL_DBG(IL_DL_TXPOWER, f, ## a)
+#define D_RATE(f, a...)		IL_DBG(IL_DL_RATE, f, ## a)
+#define D_NOTIF(f, a...)	IL_DBG(IL_DL_NOTIF, f, ## a)
+#define D_ASSOC(f, a...)	IL_DBG(IL_DL_ASSOC, f, ## a)
+#define D_HT(f, a...)		IL_DBG(IL_DL_HT, f, ## a)
+#define D_STATS(f, a...)	IL_DBG(IL_DL_STATS, f, ## a)
+#define D_TX_REPLY(f, a...)	IL_DBG(IL_DL_TX_REPLY, f, ## a)
+#define D_QOS(f, a...)		IL_DBG(IL_DL_QOS, f, ## a)
+#define D_RADIO(f, a...)	IL_DBG(IL_DL_RADIO, f, ## a)
+#define D_POWER(f, a...)	IL_DBG(IL_DL_POWER, f, ## a)
+#define D_11H(f, a...)		IL_DBG(IL_DL_11H, f, ## a)
+
 #endif /* __il_core_h__ */
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index 62292a6..4e2b6c8 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -28,8 +28,6 @@
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
 
-
-#include "iwl-debug.h"
 #include "common.h"
 
 /* create and remove of files */
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
deleted file mode 100644
index c58003a..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ /dev/null
@@ -1,175 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __il_debug_h__
-#define __il_debug_h__
-
-struct il_priv;
-extern u32 il_debug_level;
-
-#define IL_ERR(f, a...) dev_err(&il->pci_dev->dev, f, ## a)
-#define IL_WARN(f, a...) dev_warn(&il->pci_dev->dev, f, ## a)
-#define IL_INFO(f, a...) dev_info(&il->pci_dev->dev, f, ## a)
-
-#define il_print_hex_error(il, p, len)					\
-do {									\
-	print_hex_dump(KERN_ERR, "iwl data: ",				\
-		       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);		\
-} while (0)
-
-#ifdef CONFIG_IWLEGACY_DEBUG
-#define IL_DBG(level, fmt, args...)					\
-do {									\
-	if (il_get_debug_level(il) & level)				\
-		dev_printk(KERN_ERR, &il->hw->wiphy->dev,		\
-			 "%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
-			__func__ , ## args);				\
-} while (0)
-
-#define il_print_hex_dump(il, level, p, len) 			\
-do {									\
-	if (il_get_debug_level(il) & level)				\
-		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
-			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
-} while (0)
-
-#else
-#define IL_DBG(level, fmt, args...)
-static inline void il_print_hex_dump(struct il_priv *il, int level,
-				      const void *p, u32 len)
-{}
-#endif				/* CONFIG_IWLEGACY_DEBUG */
-
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-int il_dbgfs_register(struct il_priv *il, const char *name);
-void il_dbgfs_unregister(struct il_priv *il);
-#else
-static inline int
-il_dbgfs_register(struct il_priv *il, const char *name)
-{
-	return 0;
-}
-static inline void il_dbgfs_unregister(struct il_priv *il)
-{
-}
-#endif				/* CONFIG_IWLEGACY_DEBUGFS */
-
-/*
- * To use the debug system:
- *
- * If you are defining a new debug classification, simply add it to the #define
- * list here in the form of
- *
- * #define IL_DL_xxxx VALUE
- *
- * where xxxx should be the name of the classification (for example, WEP).
- *
- * You then need to either add a IL_xxxx_DEBUG() macro definition for your
- * classification, or use IL_DBG(IL_DL_xxxx, ...) whenever you want
- * to send output to that classification.
- *
- * The active debug levels can be accessed via files
- *
- * 	/sys/module/iwl4965/parameters/debug
- *	/sys/module/iwl3945/parameters/debug
- * 	/sys/class/net/wlan0/device/debug_level
- *
- * when CONFIG_IWLEGACY_DEBUG=y.
- */
-
-/* 0x0000000F - 0x00000001 */
-#define IL_DL_INFO		(1 << 0)
-#define IL_DL_MAC80211		(1 << 1)
-#define IL_DL_HCMD		(1 << 2)
-#define IL_DL_STATE		(1 << 3)
-/* 0x000000F0 - 0x00000010 */
-#define IL_DL_MACDUMP		(1 << 4)
-#define IL_DL_HCMD_DUMP		(1 << 5)
-#define IL_DL_EEPROM		(1 << 6)
-#define IL_DL_RADIO		(1 << 7)
-/* 0x00000F00 - 0x00000100 */
-#define IL_DL_POWER		(1 << 8)
-#define IL_DL_TEMP		(1 << 9)
-#define IL_DL_NOTIF		(1 << 10)
-#define IL_DL_SCAN		(1 << 11)
-/* 0x0000F000 - 0x00001000 */
-#define IL_DL_ASSOC		(1 << 12)
-#define IL_DL_DROP		(1 << 13)
-#define IL_DL_TXPOWER		(1 << 14)
-#define IL_DL_AP		(1 << 15)
-/* 0x000F0000 - 0x00010000 */
-#define IL_DL_FW		(1 << 16)
-#define IL_DL_RF_KILL		(1 << 17)
-#define IL_DL_FW_ERRORS		(1 << 18)
-#define IL_DL_LED		(1 << 19)
-/* 0x00F00000 - 0x00100000 */
-#define IL_DL_RATE		(1 << 20)
-#define IL_DL_CALIB		(1 << 21)
-#define IL_DL_WEP		(1 << 22)
-#define IL_DL_TX		(1 << 23)
-/* 0x0F000000 - 0x01000000 */
-#define IL_DL_RX		(1 << 24)
-#define IL_DL_ISR		(1 << 25)
-#define IL_DL_HT		(1 << 26)
-/* 0xF0000000 - 0x10000000 */
-#define IL_DL_11H		(1 << 28)
-#define IL_DL_STATS		(1 << 29)
-#define IL_DL_TX_REPLY		(1 << 30)
-#define IL_DL_QOS		(1 << 31)
-
-#define D_INFO(f, a...)		IL_DBG(IL_DL_INFO, f, ## a)
-#define D_MAC80211(f, a...)	IL_DBG(IL_DL_MAC80211, f, ## a)
-#define D_MACDUMP(f, a...)	IL_DBG(IL_DL_MACDUMP, f, ## a)
-#define D_TEMP(f, a...)		IL_DBG(IL_DL_TEMP, f, ## a)
-#define D_SCAN(f, a...)		IL_DBG(IL_DL_SCAN, f, ## a)
-#define D_RX(f, a...)		IL_DBG(IL_DL_RX, f, ## a)
-#define D_TX(f, a...)		IL_DBG(IL_DL_TX, f, ## a)
-#define D_ISR(f, a...)		IL_DBG(IL_DL_ISR, f, ## a)
-#define D_LED(f, a...)		IL_DBG(IL_DL_LED, f, ## a)
-#define D_WEP(f, a...)		IL_DBG(IL_DL_WEP, f, ## a)
-#define D_HC(f, a...)		IL_DBG(IL_DL_HCMD, f, ## a)
-#define D_HC_DUMP(f, a...)	IL_DBG(IL_DL_HCMD_DUMP, f, ## a)
-#define D_EEPROM(f, a...)	IL_DBG(IL_DL_EEPROM, f, ## a)
-#define D_CALIB(f, a...)	IL_DBG(IL_DL_CALIB, f, ## a)
-#define D_FW(f, a...)		IL_DBG(IL_DL_FW, f, ## a)
-#define D_RF_KILL(f, a...)	IL_DBG(IL_DL_RF_KILL, f, ## a)
-#define D_DROP(f, a...)		IL_DBG(IL_DL_DROP, f, ## a)
-#define D_AP(f, a...)		IL_DBG(IL_DL_AP, f, ## a)
-#define D_TXPOWER(f, a...)	IL_DBG(IL_DL_TXPOWER, f, ## a)
-#define D_RATE(f, a...)		IL_DBG(IL_DL_RATE, f, ## a)
-#define D_NOTIF(f, a...)	IL_DBG(IL_DL_NOTIF, f, ## a)
-#define D_ASSOC(f, a...)	IL_DBG(IL_DL_ASSOC, f, ## a)
-#define D_HT(f, a...)		IL_DBG(IL_DL_HT, f, ## a)
-#define D_STATS(f, a...)	IL_DBG(IL_DL_STATS, f, ## a)
-#define D_TX_REPLY(f, a...)	IL_DBG(IL_DL_TX_REPLY, f, ## a)
-#define D_QOS(f, a...)		IL_DBG(IL_DL_QOS, f, ## a)
-#define D_RADIO(f, a...)	IL_DBG(IL_DL_RADIO, f, ## a)
-#define D_POWER(f, a...)	IL_DBG(IL_DL_POWER, f, ## a)
-#define D_11H(f, a...)		IL_DBG(IL_DL_11H, f, ## a)
-
-#endif
-- 
1.7.1

