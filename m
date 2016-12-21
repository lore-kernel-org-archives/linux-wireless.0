Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4411 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758271AbcLUMTj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2016 07:19:39 -0500
Subject: [PATCH] ath10k: support dev_coredump for crash dump
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 21 Dec 2016 14:19:21 +0200
Message-ID: <20161221121921.25119.93932.stgit@potku.adurom.net> (sfid-20161221_131943_410519_BD3D2EDF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arun Khandavalli <akhandav@qti.qualcomm.com>

Whenever firmware crashes, and both CONFIG_ATH10K_DEBUGFS and
CONFIG_ALLOW_DEV_COREDUMP are enabled, dump information about the crash via a
devcoredump device. Dump can be read from userspace for further analysis from:

/sys/class/devcoredump/devcd*/data

As until now we have provided the firmware crash dump file via fw_crash_dump
debugfs keep it still available but deprecate and a warning print that the user
should switch to using dev_coredump.

Future improvement would be not to depend on CONFIG_ATH10K_DEBUGFS, as there
might be systems which want to get the firmware crash dump but not enable
debugfs. How to handle memory consumption is also something which needs to be
taken into account.

Signed-off-by: Arun Khandavalli <akhandav@qti.qualcomm.com>
[kvalo@qca.qualcomm.com: rebase, fixes, improve commit log]
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  |    6 ++++
 drivers/net/wireless/ath/ath10k/debug.c |   43 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/debug.h |    8 ++++++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 749e381edd38..3319db178c2e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1510,6 +1510,7 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 static void ath10k_core_restart(struct work_struct *work)
 {
 	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
+	int ret;
 
 	set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 
@@ -1561,6 +1562,11 @@ static void ath10k_core_restart(struct work_struct *work)
 	}
 
 	mutex_unlock(&ar->conf_mutex);
+
+	ret = ath10k_debug_fw_devcoredump(ar);
+	if (ret)
+		ath10k_warn(ar, "failed to send firmware crash dump via devcoredump: %d",
+			    ret);
 }
 
 static void ath10k_core_set_coverage_class_work(struct work_struct *work)
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 82a4c67f3672..e1a70dffc52a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -21,6 +21,7 @@
 #include <linux/utsname.h>
 #include <linux/crc32.h>
 #include <linux/firmware.h>
+#include <linux/devcoredump.h>
 
 #include "core.h"
 #include "debug.h"
@@ -721,7 +722,8 @@ struct ath10k_fw_crash_data *
 }
 EXPORT_SYMBOL(ath10k_debug_get_new_fw_crash_data);
 
-static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
+static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar,
+							    bool mark_read)
 {
 	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
 	struct ath10k_dump_file_data *dump_data;
@@ -790,19 +792,54 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	       sizeof(crash_data->registers));
 	sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
 
-	ar->debug.fw_crash_data->crashed_since_read = false;
+	ar->debug.fw_crash_data->crashed_since_read = !mark_read;
 
 	spin_unlock_bh(&ar->data_lock);
 
 	return dump_data;
 }
 
+int ath10k_debug_fw_devcoredump(struct ath10k *ar)
+{
+	struct ath10k_dump_file_data *dump;
+	void *dump_ptr;
+	u32 dump_len;
+
+	/* To keep the dump file available also for debugfs don't mark the
+	 * file read, only debugfs should do that.
+	 */
+	dump = ath10k_build_dump_file(ar, false);
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
+
 static int ath10k_fw_crash_dump_open(struct inode *inode, struct file *file)
 {
 	struct ath10k *ar = inode->i_private;
 	struct ath10k_dump_file_data *dump;
 
-	dump = ath10k_build_dump_file(ar);
+	ath10k_warn(ar, "fw_crash_dump debugfs file is deprecated, please use /sys/class/devcoredump instead.");
+
+	dump = ath10k_build_dump_file(ar, true);
 	if (!dump)
 		return -ENODATA;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 335512b11ca2..2368f47314ae 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -84,6 +84,9 @@ struct ath10k_fw_crash_data *
 ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
 
 void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer, int len);
+
+int ath10k_debug_fw_devcoredump(struct ath10k *ar);
+
 #define ATH10K_DFS_STAT_INC(ar, c) (ar->debug.dfs_stats.c++)
 
 void ath10k_debug_get_et_strings(struct ieee80211_hw *hw,
@@ -166,6 +169,11 @@ static inline u32 ath10k_debug_get_fw_dbglog_level(struct ath10k *ar)
 	return 0;
 }
 
+static inline int ath10k_debug_fw_devcoredump(struct ath10k *ar)
+{
+	return 0;
+}
+
 #define ATH10K_DFS_STAT_INC(ar, c) do { } while (0)
 
 #define ath10k_debug_get_et_strings NULL
