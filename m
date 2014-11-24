Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43226 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaKXQmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 11:42:04 -0500
Subject: [PATCH v2 1/2] ath10k: add register access debugfs interface
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 24 Nov 2014 18:41:59 +0200
Message-ID: <20141124164159.29422.98462.stgit@potku.adurom.net> (sfid-20141124_174208_118950_2B1C8296)
In-Reply-To: <20141124164037.29422.14033.stgit@potku.adurom.net>
References: <20141124164037.29422.14033.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yanbo Li <yanbol@qti.qualcomm.com>

Debugfs files reg_addr and reg_val are used for reading and writing to the
firmware (target) registers. reg_addr contains the address to be accessed,
which also needs to be set first, and reg_value is when used for reading and
writing the actual value in ASCII.

To read a value from the firmware register 0x100000:

# echo 0x100000 > reg_addr
# cat reg_value
0x00100000:0x000002d3

To write value 0x2400 to address 0x100000:

# echo 0x100000 > reg_addr
# echo  0x2400 > reg_value
#

Signed-off-by: Yanbo Li <yanbol@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    2 +
 drivers/net/wireless/ath/ath10k/debug.c |  102 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hif.h   |   26 ++++++++
 drivers/net/wireless/ath/ath10k/pci.c   |    2 +
 4 files changed, 132 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8f86bd34e823..5cb4fe97b4ff 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -321,6 +321,8 @@ struct ath10k_debug {
 	u32 fw_dbglog_mask;
 	u32 pktlog_filter;
 
+	u32 reg_addr;
+
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f10721da4980..b500cd619c05 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -928,6 +928,102 @@ static const struct file_operations fops_fw_crash_dump = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_reg_addr_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 buf[32];
+	unsigned int len = 0;
+	u32 reg_addr;
+
+	spin_lock_bh(&ar->data_lock);
+	reg_addr = ar->debug.reg_addr;
+	spin_unlock_bh(&ar->data_lock);
+
+	len += scnprintf(buf + len, sizeof(buf) - len, "0x%x\n", reg_addr);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_reg_addr_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 reg_addr;
+	int ret;
+
+	ret = kstrtou32_from_user(user_buf, count, 0, &reg_addr);
+	if (ret)
+		return ret;
+
+	if (!IS_ALIGNED(reg_addr, 4))
+		return -EFAULT;
+
+	spin_lock_bh(&ar->data_lock);
+	ar->debug.reg_addr = reg_addr;
+	spin_unlock_bh(&ar->data_lock);
+
+	return count;
+}
+
+static const struct file_operations fops_reg_addr = {
+	.read = ath10k_reg_addr_read,
+	.write = ath10k_reg_addr_write,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t ath10k_reg_value_read(struct file *file,
+				     char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 buf[48];
+	unsigned int len;
+	u32 reg_addr, reg_val;
+
+	spin_lock_bh(&ar->data_lock);
+	reg_addr = ar->debug.reg_addr;
+	spin_unlock_bh(&ar->data_lock);
+
+	reg_val = ath10k_hif_read32(ar, reg_addr);
+	len = scnprintf(buf, sizeof(buf), "0x%08x:0x%08x\n", reg_addr, reg_val);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_reg_value_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 reg_addr, reg_val;
+	int ret;
+
+	spin_lock_bh(&ar->data_lock);
+	reg_addr = ar->debug.reg_addr;
+	spin_unlock_bh(&ar->data_lock);
+
+	ret = kstrtou32_from_user(user_buf, count, 0, &reg_val);
+	if (ret)
+		return ret;
+
+	ath10k_hif_write32(ar, reg_addr, reg_val);
+
+	return count;
+}
+
+static const struct file_operations fops_reg_value = {
+	.read = ath10k_reg_value_read,
+	.write = ath10k_reg_value_write,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static int ath10k_debug_htt_stats_req(struct ath10k *ar)
 {
 	u64 cookie;
@@ -1629,6 +1725,12 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("fw_crash_dump", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_fw_crash_dump);
 
+	debugfs_create_file("reg_addr", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_reg_addr);
+
+	debugfs_create_file("reg_value", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_reg_value);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 30301f5b6051..bad071906540 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include "core.h"
+#include "debug.h"
 
 struct ath10k_hif_sg_item {
 	u16 transfer_id;
@@ -84,6 +85,10 @@ struct ath10k_hif_ops {
 
 	u16 (*get_free_queue_number)(struct ath10k *ar, u8 pipe_id);
 
+	u32 (*read32)(struct ath10k *ar, u32 address);
+
+	void (*write32)(struct ath10k *ar, u32 address, u32 value);
+
 	/* Power up the device and enter BMI transfer mode for FW download */
 	int (*power_up)(struct ath10k *ar);
 
@@ -187,4 +192,25 @@ static inline int ath10k_hif_resume(struct ath10k *ar)
 	return ar->hif.ops->resume(ar);
 }
 
+static inline u32 ath10k_hif_read32(struct ath10k *ar, u32 address)
+{
+	if (!ar->hif.ops->read32) {
+		ath10k_warn(ar, "hif read32 not supported\n");
+		return 0xdeaddead;
+	}
+
+	return ar->hif.ops->read32(ar, address);
+}
+
+static inline void ath10k_hif_write32(struct ath10k *ar,
+				      u32 address, u32 data)
+{
+	if (!ar->hif.ops->write32) {
+		ath10k_warn(ar, "hif write32 not supported\n");
+		return;
+	}
+
+	ar->hif.ops->write32(ar, address, data);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3a6b8a5ca96c..328ab6c5d053 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1998,6 +1998,8 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.get_free_queue_number	= ath10k_pci_hif_get_free_queue_number,
 	.power_up		= ath10k_pci_hif_power_up,
 	.power_down		= ath10k_pci_hif_power_down,
+	.read32			= ath10k_pci_read32,
+	.write32		= ath10k_pci_write32,
 #ifdef CONFIG_PM
 	.suspend		= ath10k_pci_hif_suspend,
 	.resume			= ath10k_pci_hif_resume,

