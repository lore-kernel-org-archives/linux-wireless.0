Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:32860 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaI2JmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 05:42:19 -0400
Subject: [PATCH v2 1/2] ath10k: add firmware crash counters
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Sep 2014 12:42:15 +0300
Message-ID: <20140929094214.12889.97523.stgit@potku.adurom.net> (sfid-20140929_114222_315736_10CCA62A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

kvalo: split into it's own patch, add debugfs file and add locking

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    7 +++++
 drivers/net/wireless/ath/ath10k/debug.c |   44 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/pci.c   |   14 ++++++++++
 3 files changed, 65 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 674e38c219e6..5a1dc98375e1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -563,6 +563,13 @@ struct ath10k {
 		bool utf_monitor;
 	} testmode;
 
+	struct {
+		/* protected by data_lock */
+		u32 fw_crash_counter;
+		u32 fw_warm_reset_counter;
+		u32 fw_cold_reset_counter;
+	} stats;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 680d5088b6f3..8d3db1c3f4a8 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -625,6 +625,47 @@ static const struct file_operations fops_fw_stats = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_debug_fw_reset_stats_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int ret, len, buf_len;
+	char *buf;
+
+	buf_len = 500;
+	buf = kmalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&ar->data_lock);
+
+	len = 0;
+	len += scnprintf(buf + len, buf_len - len,
+			 "fw_crash_counter\t\t%d\n", ar->stats.fw_crash_counter);
+	len += scnprintf(buf + len, buf_len - len,
+			 "fw_warm_reset_counter\t\t%d\n",
+			 ar->stats.fw_warm_reset_counter);
+	len += scnprintf(buf + len, buf_len - len,
+			 "fw_cold_reset_counter\t\t%d\n",
+			 ar->stats.fw_cold_reset_counter);
+
+	spin_unlock_bh(&ar->data_lock);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	kfree(buf);
+
+	return ret;
+}
+
+static const struct file_operations fops_fw_reset_stats = {
+	.open = simple_open,
+	.read = ath10k_debug_fw_reset_stats_read,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 /* This is a clean assert crash in firmware. */
 static int ath10k_debug_fw_assert(struct ath10k *ar)
 {
@@ -1331,6 +1372,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("fw_stats", S_IRUSR, ar->debug.debugfs_phy, ar,
 			    &fops_fw_stats);
 
+	debugfs_create_file("fw_reset_stats", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_fw_reset_stats);
+
 	debugfs_create_file("wmi_services", S_IRUSR, ar->debug.debugfs_phy, ar,
 			    &fops_wmi_services);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ae961c6ff74e..8a04904cccee 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1006,6 +1006,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 
 	spin_lock_bh(&ar->data_lock);
 
+	ar->stats.fw_crash_counter++;
+
 	crash_data = ath10k_debug_get_new_fw_crash_data(ar);
 
 	if (crash_data)
@@ -1692,6 +1694,12 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset\n");
 
+	spin_lock_bh(&ar->data_lock);
+
+	ar->stats.fw_warm_reset_counter++;
+
+	spin_unlock_bh(&ar->data_lock);
+
 	/* debug */
 	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 				PCIE_INTR_CAUSE_ADDRESS);
@@ -2308,6 +2316,12 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cold reset\n");
 
+	spin_lock_bh(&ar->data_lock);
+
+	ar->stats.fw_cold_reset_counter++;
+
+	spin_unlock_bh(&ar->data_lock);
+
 	/* Put Target, including PCIe, into RESET. */
 	val = ath10k_pci_reg_read32(ar, SOC_GLOBAL_RESET_ADDRESS);
 	val |= 1;

