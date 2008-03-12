Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51370 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYCMAEE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:04:04 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/5] iwlwifi: Add debugfs to iwl core
Date: Wed, 12 Mar 2008 16:58:52 -0700
Message-Id: <1205366332-12652-6-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000412_594276_982D69F0)
In-Reply-To: <1205366332-12652-5-git-send-email-reinette.chatre@intel.com>
References: <1205366332-12652-1-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-2-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-3-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-4-git-send-email-reinette.chatre@intel.com>
 <1205366332-12652-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds debugfs support to iwl core
currently only iwl4965 is supported

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    6 +
 drivers/net/wireless/iwlwifi/Makefile       |    4 +
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |   31 +++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |  319 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   14 +-
 7 files changed, 377 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-debugfs.c

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index acb8079..1ab14ed 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -76,6 +76,12 @@ config IWLWIFI_DEBUG
 	  as the debug information can assist others in helping you resolve
 	  any problems you may encounter.
 
+config IWLWIFI_DEBUGFS
+        bool "Iwlwifi debugfs support"
+        depends on IWLCORE && IWLWIFI_DEBUG && MAC80211_DEBUGFS
+        ---help---
+	  Enable creation of debugfs files for the iwlwifi drivers.
+
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 59d9c90..86ac1fc 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,6 +1,10 @@
 obj-$(CONFIG_IWLCORE)	+= iwlcore.o
 iwlcore-objs 		= iwl-core.o iwl-eeprom.o
 
+ifeq ($(CONFIG_IWLWIFI_DEBUGFS),y)
+	iwlcore-objs += iwl-debugfs.o
+endif
+
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index aded601..cec62ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1212,7 +1212,11 @@ struct iwl_priv {
 	/* debugging info */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
-#endif
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	/* debugfs */
+	struct iwl_debugfs *dbgfs;
+#endif /* CONFIG_IWLWIFI_DEBUGFS */
+#endif /* CONFIG_IWLWIFI_DEBUG */
 
 	struct work_struct txpower_work;
 #ifdef CONFIG_IWL4965_SENSITIVITY
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4645d19..3a9fc90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 
+struct iwl_priv; /* FIXME: remove */
 #include "iwl-debug.h"
 #include "iwl-eeprom.h"
 #include "iwl-core.h"
@@ -37,7 +38,7 @@
 MODULE_DESCRIPTION("iwl core");
 MODULE_VERSION(IWLWIFI_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
-MODULE_LICENSE("GPL/BSD");
+MODULE_LICENSE("GPL");
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 u32 iwl_debug_level;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 0677006..c60724c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -49,8 +49,27 @@ static inline void iwl_print_hex_dump(int level, void *p, u32 len)
 	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
 			p, len, 1);
 }
-#else
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+struct iwl_debugfs {
+	const char *name;
+	struct dentry *dir_drv;
+	struct dentry *dir_data;
+	struct dir_data_files{
+		struct dentry *file_sram;
+		struct dentry *file_stations;
+		struct dentry *file_rx_statistics;
+		struct dentry *file_tx_statistics;
+	} dbgfs_data_files;
+	u32 sram_offset;
+	u32 sram_len;
+};
+
+int iwl_dbgfs_register(struct iwl_priv *priv, const char *name);
+void iwl_dbgfs_unregister(struct iwl_priv *priv);
+#endif
+
+#else
 static inline void IWL_DEBUG(int level, const char *fmt, ...)
 {
 }
@@ -64,6 +83,16 @@ static inline void iwl_print_hex_dump(int level, void *p, u32 len)
 
 
 
+#ifndef CONFIG_IWLWIFI_DEBUGFS
+static inline int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
+{
+	return 0;
+}
+static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
+{
+}
+#endif				/* CONFIG_IWLWIFI_DEBUGFS */
+
 /*
  * To use the debug system;
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
new file mode 100644
index 0000000..c659bd3
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -0,0 +1,319 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+
+#include <linux/ieee80211.h>
+#include <net/mac80211.h>
+
+
+#include "iwl-4965.h"
+#include "iwl-debug.h"
+#include "iwl-4965-io.h"
+
+
+/* create and remove of files */
+#define DEBUGFS_ADD_DIR(name, parent) do {                              \
+	dbgfs->dir_##name = debugfs_create_dir(#name, parent);          \
+	if (!(dbgfs->dir_##name))                                       \
+		goto err; 						\
+} while (0)
+
+#define DEBUGFS_ADD_FILE(name, parent) do {                             \
+	dbgfs->dbgfs_##parent##_files.file_##name =                     \
+	debugfs_create_file(#name, 0644, dbgfs->dir_##parent, priv,     \
+				&iwl_dbgfs_##name##_ops);               \
+	if (!(dbgfs->dbgfs_##parent##_files.file_##name))               \
+		goto err;                                               \
+} while (0)
+
+#define DEBUGFS_REMOVE(name)  do {              \
+	debugfs_remove(name);                   \
+	name = NULL;                            \
+} while (0);
+
+/* file operation */
+#define DEBUGFS_READ_FUNC(name)                                         \
+static ssize_t iwl_dbgfs_##name##_read(struct file *file,               \
+					char __user *user_buf,          \
+					size_t count, loff_t *ppos);
+
+#define DEBUGFS_WRITE_FUNC(name)                                        \
+static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
+					const char __user *user_buf,    \
+					size_t count, loff_t *ppos);
+
+
+static int iwl_dbgfs_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+#define DEBUGFS_READ_FILE_OPS(name)                                     \
+	DEBUGFS_READ_FUNC(name);                                        \
+static const struct file_operations iwl_dbgfs_##name##_ops = {          \
+	.read = iwl_dbgfs_##name##_read,                       		\
+	.open = iwl_dbgfs_open_file_generic,                    	\
+};
+
+#define DEBUGFS_READ_WRITE_FILE_OPS(name)                               \
+	DEBUGFS_READ_FUNC(name);                                        \
+	DEBUGFS_WRITE_FUNC(name);                                       \
+static const struct file_operations iwl_dbgfs_##name##_ops = {          \
+	.write = iwl_dbgfs_##name##_write,                              \
+	.read = iwl_dbgfs_##name##_read,                                \
+	.open = iwl_dbgfs_open_file_generic,                            \
+};
+
+
+static ssize_t iwl_dbgfs_tx_statistics_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char buf[256];
+	int pos = 0;
+
+	pos += sprintf(buf+pos, "mgmt: %u\n", priv->tx_stats[0].cnt);
+	pos += sprintf(buf+pos, "ctrl: %u\n", priv->tx_stats[1].cnt);
+	pos += sprintf(buf+pos, "data: %u\n", priv->tx_stats[2].cnt);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char buf[256];
+	int pos = 0;
+
+	pos += sprintf(buf+pos, "mgmt: %u\n", priv->rx_stats[0].cnt);
+	pos += sprintf(buf+pos, "ctrl: %u\n", priv->rx_stats[1].cnt);
+	pos += sprintf(buf+pos, "data: %u\n", priv->rx_stats[2].cnt);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+#define BYTE1_MASK 0x000000ff;
+#define BYTE2_MASK 0x0000ffff;
+#define BYTE3_MASK 0x00ffffff;
+static ssize_t iwl_dbgfs_sram_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	u32 val;
+	char buf[1024];
+	ssize_t ret;
+	int i;
+	int pos = 0;
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+
+	printk(KERN_DEBUG "offset is: 0x%x\tlen is: 0x%x\n",
+	priv->dbgfs->sram_offset, priv->dbgfs->sram_len);
+
+	iwl4965_grab_nic_access(priv);
+	for (i = priv->dbgfs->sram_len; i > 0; i -= 4) {
+		val = iwl4965_read_targ_mem(priv, priv->dbgfs->sram_offset + \
+					priv->dbgfs->sram_len - i);
+		if (i < 4) {
+			switch (i) {
+			case 1:
+				val &= BYTE1_MASK;
+				break;
+			case 2:
+				val &= BYTE2_MASK;
+				break;
+			case 3:
+				val &= BYTE3_MASK;
+				break;
+			}
+		}
+		pos += sprintf(buf+pos, "0x%08x ", val);
+	}
+	pos += sprintf(buf+pos, "\n");
+	iwl4965_release_nic_access(priv);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_sram_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[64];
+	int buf_size;
+	u32 offset, len;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	if (sscanf(buf, "%x,%x", &offset, &len) == 2) {
+		priv->dbgfs->sram_offset = offset;
+		priv->dbgfs->sram_len = len;
+	} else {
+		priv->dbgfs->sram_offset = 0;
+		priv->dbgfs->sram_len = 0;
+	}
+
+	return count;
+}
+
+static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	struct iwl4965_station_entry *station;
+	int max_sta = priv->hw_setting.max_stations;
+	char *buf;
+	int i, j, pos = 0;
+	ssize_t ret;
+	/* Add 30 for initial string */
+	const size_t bufsz = 30 + sizeof(char) * 500 * (priv->num_stations);
+	DECLARE_MAC_BUF(mac);
+
+	buf = kmalloc(bufsz, GFP_KERNEL);
+	if(!buf)
+		return -ENOMEM;
+
+	pos += sprintf(buf+pos, "num of stations: %d\n\n",
+			priv->num_stations);
+
+	for (i = 0; i < max_sta; i++) {
+		station = &priv->stations[i];
+		if (station->used) {
+			pos += sprintf(buf+pos, "station %d:\ngeneral data:\n",
+					i+1);
+			print_mac(mac, station->sta.sta.addr);
+			pos += sprintf(buf+pos, "id: %u\n",
+					station->sta.sta.sta_id);
+			pos += sprintf(buf+pos, "mode: %u\n",
+					station->sta.mode);
+			pos += sprintf(buf+pos, "flags: 0x%x\n",
+					station->sta.station_flags_msk);
+			pos += sprintf(buf+pos, "ps_status: %u\n",
+					station->ps_status);
+
+			pos += sprintf(buf+pos, "tid data:\n");
+
+			pos += sprintf(buf+pos, "seq_num\t\ttxq_id\t");
+			pos += sprintf(buf+pos, "frame_count\twait_for_ba\t");
+			pos += sprintf(buf+pos, "start_idx\tbitmap0\t");
+			pos += sprintf(buf+pos, "bitmap1\trate_n_flags\n");
+
+			for (j = 0; j < MAX_TID_COUNT; j++) {
+				pos += sprintf(buf+pos, "[%d]:\t\t%u\t",
+						j, station->tid[j].seq_number);
+				pos += sprintf(buf+pos, "%u\t\t%u\t\t%u\t\t",
+						station->tid[j].agg.txq_id,
+						station->tid[j].agg.frame_count,
+						station->tid[j].agg.wait_for_ba);
+				pos += sprintf(buf+pos, "%u\t%llu\t%u\n",
+						station->tid[j].agg.start_idx,
+						station->tid[j].agg.bitmap,
+						station->tid[j].agg.rate_n_flags);
+			}
+			pos += sprintf(buf+pos, "\n");
+		}
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+
+DEBUGFS_READ_WRITE_FILE_OPS(sram);
+DEBUGFS_READ_FILE_OPS(stations);
+DEBUGFS_READ_FILE_OPS(rx_statistics);
+DEBUGFS_READ_FILE_OPS(tx_statistics);
+
+/*
+ * Create the debugfs files and directories
+ *
+ */
+int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
+{
+	struct iwl_debugfs *dbgfs;
+
+	dbgfs = kzalloc(sizeof(struct iwl_debugfs), GFP_KERNEL);
+	if (!dbgfs) {
+		goto err;
+	}
+
+	priv->dbgfs = dbgfs;
+	dbgfs->name = name;
+	dbgfs->dir_drv = debugfs_create_dir(name, NULL);
+	if (!dbgfs->dir_drv || IS_ERR(dbgfs->dir_drv)){
+		goto err;
+	}
+
+	DEBUGFS_ADD_DIR(data, dbgfs->dir_drv);
+	DEBUGFS_ADD_FILE(sram, data);
+	DEBUGFS_ADD_FILE(stations, data);
+	DEBUGFS_ADD_FILE(rx_statistics, data);
+	DEBUGFS_ADD_FILE(tx_statistics, data);
+
+	return 0;
+
+err:
+	IWL_ERROR("Can't open the debugfs directory\n");
+	iwl_dbgfs_unregister(priv);
+	return -ENOENT;
+}
+EXPORT_SYMBOL(iwl_dbgfs_register);
+
+/**
+ * Remove the debugfs files and directories
+ *
+ */
+void iwl_dbgfs_unregister(struct iwl_priv *priv)
+{
+	if (!(priv->dbgfs))
+		return;
+
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_rx_statistics);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_tx_statistics);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
+	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
+	DEBUGFS_REMOVE(priv->dbgfs->dir_drv);
+	kfree(priv->dbgfs);
+	priv->dbgfs = NULL;
+}
+EXPORT_SYMBOL(iwl_dbgfs_unregister);
+
+
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4f6ed69..396940e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8690,6 +8690,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_release_irq;
 	}
 
+	err = iwl_dbgfs_register(priv, DRV_NAME);
+	if (err) {
+		IWL_ERROR("failed to create debugfs files\n");
+		goto out_remove_sysfs;
+	}
 	/* nic init */
 	iwl4965_set_bit(priv, CSR_GIO_CHICKEN_BITS,
                     CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
@@ -8700,13 +8705,13 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
                           CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
         if (err < 0) {
                 IWL_DEBUG_INFO("Failed to init the card\n");
-		goto out_remove_sysfs;
+		goto out_remove_dbgfs;
         }
 	/* Read the EEPROM */
 	err = iwl_eeprom_init(priv);
 	if (err) {
 		IWL_ERROR("Unable to init EEPROM\n");
-		goto out_remove_sysfs;
+		goto out_remove_dbgfs;
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
 	iwl_eeprom_get_mac(priv, priv->mac_addr);
@@ -8716,7 +8721,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = iwl4965_init_channel_map(priv);
 	if (err) {
 		IWL_ERROR("initializing regulatory failed: %d\n", err);
-		goto out_remove_sysfs;
+		goto out_remove_dbgfs;
 	}
 
 	err = iwl4965_init_geos(priv);
@@ -8743,6 +8748,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	iwl4965_free_geos(priv);
  out_free_channel_map:
 	iwl4965_free_channel_map(priv);
+ out_remove_dbgfs:
+	iwl_dbgfs_unregister(priv);
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 
@@ -8787,6 +8794,7 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 		}
 	}
 
+	iwl_dbgfs_unregister(priv);
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 
 	iwl4965_dealloc_ucode_pci(priv);
-- 
1.5.3.4

