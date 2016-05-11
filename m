Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53944 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbcEKRCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:42 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 03/21] ath10k:  Allow changing ath10k debug mask at runtime.
Date: Wed, 11 May 2016 10:02:15 -0700
Message-Id: <1462986153-16318-4-git-send-email-greearb@candelatech.com> (sfid-20160511_190259_705944_B04762CD)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Using debugfs.  More convenient than module options
in some cases.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 62 +++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index e251155..d552a4a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -870,6 +870,65 @@ static const struct file_operations fops_reg_addr = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_debug_level(struct file *file,
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	int sz;
+	const char buf[] =
+		"To change debug level, set value adding up desired flags:\n"
+		"PCI:                0x1\n"
+		"WMI:                0x2\n"
+		"HTC:                0x4\n"
+		"HTT:                0x8\n"
+		"MAC:               0x10\n"
+		"BOOT:              0x20\n"
+		"PCI-DUMP:          0x40\n"
+		"HTT-DUMP:          0x80\n"
+		"MGMT:             0x100\n"
+		"DATA:             0x200\n"
+		"BMI:              0x400\n"
+		"REGULATORY:       0x800\n"
+		"TESTMODE:        0x1000\n"
+		"INFO-AS-DBG: 0x40000000\n"
+		"FW:          0x80000000\n"
+		"ALL:         0xFFFFFFFF\n";
+	char wbuf[sizeof(buf) + 60];
+	sz = snprintf(wbuf, sizeof(wbuf), "Current debug level: 0x%x\n\n%s",
+		      ath10k_debug_mask, buf);
+	wbuf[sizeof(wbuf) - 1] = 0;
+
+	return simple_read_from_buffer(user_buf, count, ppos, wbuf, sz);
+}
+
+/* Set logging level.
+ */
+static ssize_t ath10k_write_debug_level(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int ret;
+	unsigned long mask;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &mask);
+	if (ret)
+		return ret;
+
+	ath10k_warn(ar, "Setting debug-mask to: 0x%lx  old: 0x%x\n",
+		    mask, ath10k_debug_mask);
+	ath10k_debug_mask = mask;
+	return count;
+}
+
+static const struct file_operations fops_debug_level = {
+	.read = ath10k_read_debug_level,
+	.write = ath10k_write_debug_level,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t ath10k_reg_value_read(struct file *file,
 				     char __user *user_buf,
 				     size_t count, loff_t *ppos)
@@ -2375,6 +2434,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("mem_value", S_IRUSR | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_mem_value);
 
+	debugfs_create_file("debug_level", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_debug_level);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
-- 
2.4.3

