Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:15397 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751089AbdHOIXP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 04:23:15 -0400
Subject: [PATCH 2/6] ath10k: refactor firmware crashdump code to coredump.c
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 15 Aug 2017 11:23:03 +0300
Message-ID: <150278538298.22482.10986802411848917689.stgit@potku.adurom.net> (sfid-20170815_102320_511292_8D6E1E21)
In-Reply-To: <150278532045.22482.14490702801292107536.stgit@potku.adurom.net>
References: <150278532045.22482.14490702801292107536.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to add RAM dump support. No functional changes, only moving code
and renaming function names.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Makefile   |    1 
 drivers/net/wireless/ath/ath10k/core.c     |    3 
 drivers/net/wireless/ath/ath10k/coredump.c |  161 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/coredump.h |  121 +++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.c    |  222 ----------------------------
 drivers/net/wireless/ath/ath10k/debug.h    |   16 --
 drivers/net/wireless/ath/ath10k/pci.c      |    3 
 7 files changed, 287 insertions(+), 240 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/coredump.c
 create mode 100644 drivers/net/wireless/ath/ath10k/coredump.h

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 899b9b79f4ce..769478b567a2 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -20,6 +20,7 @@ ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
 ath10k_core-$(CONFIG_THERMAL) += thermal.o
 ath10k_core-$(CONFIG_MAC80211_DEBUGFS) += debugfs_sta.o
 ath10k_core-$(CONFIG_PM) += wow.o
+ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += coredump.o
 
 obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
 ath10k_pci-y += pci.o \
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9b4c4facf725..caecfca4a38a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -32,6 +32,7 @@
 #include "htt.h"
 #include "testmode.h"
 #include "wmi-ops.h"
+#include "coredump.h"
 
 unsigned int ath10k_debug_mask;
 static unsigned int ath10k_cryptmode_param;
@@ -1746,7 +1747,7 @@ static void ath10k_core_restart(struct work_struct *work)
 
 	mutex_unlock(&ar->conf_mutex);
 
-	ret = ath10k_debug_fw_devcoredump(ar);
+	ret = ath10k_coredump_submit(ar);
 	if (ret)
 		ath10k_warn(ar, "failed to send firmware crash dump via devcoredump: %d",
 			    ret);
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
new file mode 100644
index 000000000000..b4631e573851
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -0,0 +1,161 @@
+/*
+ * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "coredump.h"
+
+#include <linux/devcoredump.h>
+#include <linux/utsname.h>
+
+#include "debug.h"
+
+struct ath10k_fw_crash_data *ath10k_coredump_new(struct ath10k *ar)
+{
+	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	crash_data->crashed_since_read = true;
+	guid_gen(&crash_data->guid);
+	getnstimeofday(&crash_data->timestamp);
+
+	return crash_data;
+}
+EXPORT_SYMBOL(ath10k_coredump_new);
+
+static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar,
+							   bool mark_read)
+{
+	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
+	struct ath10k_ce_crash_hdr *ce_hdr;
+	struct ath10k_dump_file_data *dump_data;
+	struct ath10k_tlv_dump_data *dump_tlv;
+	size_t hdr_len = sizeof(*dump_data);
+	size_t len, sofar = 0;
+	unsigned char *buf;
+
+	len = hdr_len;
+	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
+	len += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
+		CE_COUNT * sizeof(ce_hdr->entries[0]);
+
+	sofar += hdr_len;
+
+	/* This is going to get big when we start dumping FW RAM and such,
+	 * so go ahead and use vmalloc.
+	 */
+	buf = vzalloc(len);
+	if (!buf)
+		return NULL;
+
+	spin_lock_bh(&ar->data_lock);
+
+	if (!crash_data->crashed_since_read) {
+		spin_unlock_bh(&ar->data_lock);
+		vfree(buf);
+		return NULL;
+	}
+
+	dump_data = (struct ath10k_dump_file_data *)(buf);
+	strlcpy(dump_data->df_magic, "ATH10K-FW-DUMP",
+		sizeof(dump_data->df_magic));
+	dump_data->len = cpu_to_le32(len);
+
+	dump_data->version = cpu_to_le32(ATH10K_FW_CRASH_DUMP_VERSION);
+
+	guid_copy(&dump_data->guid, &crash_data->guid);
+	dump_data->chip_id = cpu_to_le32(ar->chip_id);
+	dump_data->bus_type = cpu_to_le32(0);
+	dump_data->target_version = cpu_to_le32(ar->target_version);
+	dump_data->fw_version_major = cpu_to_le32(ar->fw_version_major);
+	dump_data->fw_version_minor = cpu_to_le32(ar->fw_version_minor);
+	dump_data->fw_version_release = cpu_to_le32(ar->fw_version_release);
+	dump_data->fw_version_build = cpu_to_le32(ar->fw_version_build);
+	dump_data->phy_capability = cpu_to_le32(ar->phy_capability);
+	dump_data->hw_min_tx_power = cpu_to_le32(ar->hw_min_tx_power);
+	dump_data->hw_max_tx_power = cpu_to_le32(ar->hw_max_tx_power);
+	dump_data->ht_cap_info = cpu_to_le32(ar->ht_cap_info);
+	dump_data->vht_cap_info = cpu_to_le32(ar->vht_cap_info);
+	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
+
+	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
+		sizeof(dump_data->fw_ver));
+
+	dump_data->kernel_ver_code = 0;
+	strlcpy(dump_data->kernel_ver, init_utsname()->release,
+		sizeof(dump_data->kernel_ver));
+
+	dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
+	dump_data->tv_nsec = cpu_to_le64(crash_data->timestamp.tv_nsec);
+
+	/* Gather crash-dump */
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_REGISTERS);
+	dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->registers));
+	memcpy(dump_tlv->tlv_data, &crash_data->registers,
+	       sizeof(crash_data->registers));
+	sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
+
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_CE_DATA);
+	dump_tlv->tlv_len = cpu_to_le32(sizeof(*ce_hdr) +
+					CE_COUNT * sizeof(ce_hdr->entries[0]));
+	ce_hdr = (struct ath10k_ce_crash_hdr *)(dump_tlv->tlv_data);
+	ce_hdr->ce_count = cpu_to_le32(CE_COUNT);
+	memset(ce_hdr->reserved, 0, sizeof(ce_hdr->reserved));
+	memcpy(ce_hdr->entries, crash_data->ce_crash_data,
+	       CE_COUNT * sizeof(ce_hdr->entries[0]));
+	sofar += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
+		 CE_COUNT * sizeof(ce_hdr->entries[0]);
+
+	ar->debug.fw_crash_data->crashed_since_read = !mark_read;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	return dump_data;
+}
+
+int ath10k_coredump_submit(struct ath10k *ar)
+{
+	struct ath10k_dump_file_data *dump;
+	void *dump_ptr;
+	u32 dump_len;
+
+	/* To keep the dump file available also for debugfs don't mark the
+	 * file read, only debugfs should do that.
+	 */
+	dump = ath10k_coredump_build(ar, false);
+	if (!dump) {
+		ath10k_warn(ar, "no crash dump data found for devcoredump");
+		return -ENODATA;
+	}
+
+	/* Make a copy of the dump file for dev_coredumpv() as during the
+	 * transition period we need to own the original file. Once
+	 * fw_crash_dump debugfs file is removed no need to have a copy
+	 * anymore.
+	 */
+	dump_len = le32_to_cpu(dump->len);
+	dump_ptr = vzalloc(dump_len);
+
+	if (!dump_ptr)
+		return -ENOMEM;
+
+	memcpy(dump_ptr, dump, dump_len);
+
+	dev_coredumpv(ar->dev, dump_ptr, dump_len, GFP_KERNEL);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath10k/coredump.h b/drivers/net/wireless/ath/ath10k/coredump.h
new file mode 100644
index 000000000000..2d2f45b5aa37
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/coredump.h
@@ -0,0 +1,121 @@
+/*
+ * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _COREDUMP_H_
+#define _COREDUMP_H_
+
+#include "core.h"
+
+#define ATH10K_FW_CRASH_DUMP_VERSION 1
+
+/**
+ * enum ath10k_fw_crash_dump_type - types of data in the dump file
+ * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
+ */
+enum ath10k_fw_crash_dump_type {
+	ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
+	ATH10K_FW_CRASH_DUMP_CE_DATA = 1,
+
+	ATH10K_FW_CRASH_DUMP_MAX,
+};
+
+struct ath10k_tlv_dump_data {
+	/* see ath10k_fw_crash_dump_type above */
+	__le32 type;
+
+	/* in bytes */
+	__le32 tlv_len;
+
+	/* pad to 32-bit boundaries as needed */
+	u8 tlv_data[];
+} __packed;
+
+struct ath10k_dump_file_data {
+	/* dump file information */
+
+	/* "ATH10K-FW-DUMP" */
+	char df_magic[16];
+
+	__le32 len;
+
+	/* file dump version */
+	__le32 version;
+
+	/* some info we can get from ath10k struct that might help */
+
+	guid_t guid;
+
+	__le32 chip_id;
+
+	/* 0 for now, in place for later hardware */
+	__le32 bus_type;
+
+	__le32 target_version;
+	__le32 fw_version_major;
+	__le32 fw_version_minor;
+	__le32 fw_version_release;
+	__le32 fw_version_build;
+	__le32 phy_capability;
+	__le32 hw_min_tx_power;
+	__le32 hw_max_tx_power;
+	__le32 ht_cap_info;
+	__le32 vht_cap_info;
+	__le32 num_rf_chains;
+
+	/* firmware version string */
+	char fw_ver[ETHTOOL_FWVERS_LEN];
+
+	/* Kernel related information */
+
+	/* time-of-day stamp */
+	__le64 tv_sec;
+
+	/* time-of-day stamp, nano-seconds */
+	__le64 tv_nsec;
+
+	/* LINUX_VERSION_CODE */
+	__le32 kernel_ver_code;
+
+	/* VERMAGIC_STRING */
+	char kernel_ver[64];
+
+	/* room for growth w/out changing binary format */
+	u8 unused[128];
+
+	/* struct ath10k_tlv_dump_data + more */
+	u8 data[0];
+} __packed;
+
+#ifdef CONFIG_DEV_COREDUMP
+
+int ath10k_coredump_submit(struct ath10k *ar);
+struct ath10k_fw_crash_data *ath10k_coredump_new(struct ath10k *ar);
+
+#else /* CONFIG_DEV_COREDUMP */
+
+static inline int ath10k_coredump_submit(struct ath10k *ar)
+{
+	return 0;
+}
+
+static inline struct ath10k_fw_crash_data *ath10k_coredump_new(struct ath10k *ar)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_DEV_COREDUMP */
+
+#endif /* _COREDUMP_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 266bb697d960..28f96359ee73 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -18,10 +18,8 @@
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/vmalloc.h>
-#include <linux/utsname.h>
 #include <linux/crc32.h>
 #include <linux/firmware.h>
-#include <linux/devcoredump.h>
 
 #include "core.h"
 #include "debug.h"
@@ -33,86 +31,6 @@
 
 #define ATH10K_DEBUG_CAL_DATA_LEN 12064
 
-#define ATH10K_FW_CRASH_DUMP_VERSION 1
-
-/**
- * enum ath10k_fw_crash_dump_type - types of data in the dump file
- * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
- */
-enum ath10k_fw_crash_dump_type {
-	ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
-	ATH10K_FW_CRASH_DUMP_CE_DATA = 1,
-
-	ATH10K_FW_CRASH_DUMP_MAX,
-};
-
-struct ath10k_tlv_dump_data {
-	/* see ath10k_fw_crash_dump_type above */
-	__le32 type;
-
-	/* in bytes */
-	__le32 tlv_len;
-
-	/* pad to 32-bit boundaries as needed */
-	u8 tlv_data[];
-} __packed;
-
-struct ath10k_dump_file_data {
-	/* dump file information */
-
-	/* "ATH10K-FW-DUMP" */
-	char df_magic[16];
-
-	__le32 len;
-
-	/* file dump version */
-	__le32 version;
-
-	/* some info we can get from ath10k struct that might help */
-
-	guid_t guid;
-
-	__le32 chip_id;
-
-	/* 0 for now, in place for later hardware */
-	__le32 bus_type;
-
-	__le32 target_version;
-	__le32 fw_version_major;
-	__le32 fw_version_minor;
-	__le32 fw_version_release;
-	__le32 fw_version_build;
-	__le32 phy_capability;
-	__le32 hw_min_tx_power;
-	__le32 hw_max_tx_power;
-	__le32 ht_cap_info;
-	__le32 vht_cap_info;
-	__le32 num_rf_chains;
-
-	/* firmware version string */
-	char fw_ver[ETHTOOL_FWVERS_LEN];
-
-	/* Kernel related information */
-
-	/* time-of-day stamp */
-	__le64 tv_sec;
-
-	/* time-of-day stamp, nano-seconds */
-	__le64 tv_nsec;
-
-	/* LINUX_VERSION_CODE */
-	__le32 kernel_ver_code;
-
-	/* VERMAGIC_STRING */
-	char kernel_ver[64];
-
-	/* room for growth w/out changing binary format */
-	u8 unused[128];
-
-	/* struct ath10k_tlv_dump_data + more */
-	u8 data[0];
-} __packed;
-
 void ath10k_info(struct ath10k *ar, const char *fmt, ...)
 {
 	struct va_format vaf = {
@@ -711,146 +629,6 @@ static const struct file_operations fops_chip_id = {
 	.llseek = default_llseek,
 };
 
-struct ath10k_fw_crash_data *
-ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
-{
-	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
-
-	lockdep_assert_held(&ar->data_lock);
-
-	crash_data->crashed_since_read = true;
-	guid_gen(&crash_data->guid);
-	getnstimeofday(&crash_data->timestamp);
-
-	return crash_data;
-}
-EXPORT_SYMBOL(ath10k_debug_get_new_fw_crash_data);
-
-static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar,
-							    bool mark_read)
-{
-	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
-	struct ath10k_ce_crash_hdr *ce_hdr;
-	struct ath10k_dump_file_data *dump_data;
-	struct ath10k_tlv_dump_data *dump_tlv;
-	size_t hdr_len = sizeof(*dump_data);
-	size_t len, sofar = 0;
-	unsigned char *buf;
-
-	len = hdr_len;
-	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
-	len += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
-		CE_COUNT * sizeof(ce_hdr->entries[0]);
-
-	sofar += hdr_len;
-
-	/* This is going to get big when we start dumping FW RAM and such,
-	 * so go ahead and use vmalloc.
-	 */
-	buf = vzalloc(len);
-	if (!buf)
-		return NULL;
-
-	spin_lock_bh(&ar->data_lock);
-
-	if (!crash_data->crashed_since_read) {
-		spin_unlock_bh(&ar->data_lock);
-		vfree(buf);
-		return NULL;
-	}
-
-	dump_data = (struct ath10k_dump_file_data *)(buf);
-	strlcpy(dump_data->df_magic, "ATH10K-FW-DUMP",
-		sizeof(dump_data->df_magic));
-	dump_data->len = cpu_to_le32(len);
-
-	dump_data->version = cpu_to_le32(ATH10K_FW_CRASH_DUMP_VERSION);
-
-	guid_copy(&dump_data->guid, &crash_data->guid);
-	dump_data->chip_id = cpu_to_le32(ar->chip_id);
-	dump_data->bus_type = cpu_to_le32(0);
-	dump_data->target_version = cpu_to_le32(ar->target_version);
-	dump_data->fw_version_major = cpu_to_le32(ar->fw_version_major);
-	dump_data->fw_version_minor = cpu_to_le32(ar->fw_version_minor);
-	dump_data->fw_version_release = cpu_to_le32(ar->fw_version_release);
-	dump_data->fw_version_build = cpu_to_le32(ar->fw_version_build);
-	dump_data->phy_capability = cpu_to_le32(ar->phy_capability);
-	dump_data->hw_min_tx_power = cpu_to_le32(ar->hw_min_tx_power);
-	dump_data->hw_max_tx_power = cpu_to_le32(ar->hw_max_tx_power);
-	dump_data->ht_cap_info = cpu_to_le32(ar->ht_cap_info);
-	dump_data->vht_cap_info = cpu_to_le32(ar->vht_cap_info);
-	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
-
-	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
-		sizeof(dump_data->fw_ver));
-
-	dump_data->kernel_ver_code = 0;
-	strlcpy(dump_data->kernel_ver, init_utsname()->release,
-		sizeof(dump_data->kernel_ver));
-
-	dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
-	dump_data->tv_nsec = cpu_to_le64(crash_data->timestamp.tv_nsec);
-
-	/* Gather crash-dump */
-	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
-	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_REGISTERS);
-	dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->registers));
-	memcpy(dump_tlv->tlv_data, &crash_data->registers,
-	       sizeof(crash_data->registers));
-	sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
-
-	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
-	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_CE_DATA);
-	dump_tlv->tlv_len = cpu_to_le32(sizeof(*ce_hdr) +
-					CE_COUNT * sizeof(ce_hdr->entries[0]));
-	ce_hdr = (struct ath10k_ce_crash_hdr *)(dump_tlv->tlv_data);
-	ce_hdr->ce_count = cpu_to_le32(CE_COUNT);
-	memset(ce_hdr->reserved, 0, sizeof(ce_hdr->reserved));
-	memcpy(ce_hdr->entries, crash_data->ce_crash_data,
-	       CE_COUNT * sizeof(ce_hdr->entries[0]));
-	sofar += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
-		 CE_COUNT * sizeof(ce_hdr->entries[0]);
-
-	ar->debug.fw_crash_data->crashed_since_read = !mark_read;
-
-	spin_unlock_bh(&ar->data_lock);
-
-	return dump_data;
-}
-
-int ath10k_debug_fw_devcoredump(struct ath10k *ar)
-{
-	struct ath10k_dump_file_data *dump;
-	void *dump_ptr;
-	u32 dump_len;
-
-	/* To keep the dump file available also for debugfs don't mark the
-	 * file read, only debugfs should do that.
-	 */
-	dump = ath10k_build_dump_file(ar, false);
-	if (!dump) {
-		ath10k_warn(ar, "no crash dump data found for devcoredump");
-		return -ENODATA;
-	}
-
-	/* Make a copy of the dump file for dev_coredumpv() as during the
-	 * transition period we need to own the original file. Once
-	 * fw_crash_dump debugfs file is removed no need to have a copy
-	 * anymore.
-	 */
-	dump_len = le32_to_cpu(dump->len);
-	dump_ptr = vzalloc(dump_len);
-
-	if (!dump_ptr)
-		return -ENOMEM;
-
-	memcpy(dump_ptr, dump, dump_len);
-
-	dev_coredumpv(ar->dev, dump_ptr, dump_len, GFP_KERNEL);
-
-	return 0;
-}
-
 static ssize_t ath10k_reg_addr_read(struct file *file,
 				    char __user *user_buf,
 				    size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 548ad5483a4a..de6b3618b155 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -84,13 +84,8 @@ void ath10k_debug_unregister(struct ath10k *ar);
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_debug_tpc_stats_process(struct ath10k *ar,
 				    struct ath10k_tpc_stats *tpc_stats);
-struct ath10k_fw_crash_data *
-ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
-
 void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len);
 
-int ath10k_debug_fw_devcoredump(struct ath10k *ar);
-
 #define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
 
 void ath10k_debug_get_et_strings(struct ieee80211_hw *hw,
@@ -157,12 +152,6 @@ static inline void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer,
 {
 }
 
-static inline struct ath10k_fw_crash_data *
-ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
-{
-	return NULL;
-}
-
 static inline u64 ath10k_debug_get_fw_dbglog_mask(struct ath10k *ar)
 {
 	return 0;
@@ -173,11 +162,6 @@ static inline u32 ath10k_debug_get_fw_dbglog_level(struct ath10k *ar)
 	return 0;
 }
 
-static inline int ath10k_debug_fw_devcoredump(struct ath10k *ar)
-{
-	return 0;
-}
-
 #define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 
 #define ath10k_debug_get_et_strings NULL
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0a5b88e80214..3e25a6bfb2bd 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -23,6 +23,7 @@
 
 #include "core.h"
 #include "debug.h"
+#include "coredump.h"
 
 #include "targaddrs.h"
 #include "bmi.h"
@@ -1469,7 +1470,7 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 
 	ar->stats.fw_crash_counter++;
 
-	crash_data = ath10k_debug_get_new_fw_crash_data(ar);
+	crash_data = ath10k_coredump_new(ar);
 
 	if (crash_data)
 		scnprintf(guid, sizeof(guid), "%pUl", &crash_data->guid);
