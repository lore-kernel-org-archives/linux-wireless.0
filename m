Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:43249 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3IAIWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 04:22:24 -0400
Subject: [PATCH v2 2/2] ath10k: add chip_id file to debugfs
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Sep 2013 11:22:21 +0300
Message-ID: <20130901082221.1930.55810.stgit@localhost6.localdomain6> (sfid-20130901_102238_834866_4B548790)
In-Reply-To: <20130901082007.1930.79088.stgit@localhost6.localdomain6>
References: <20130901082007.1930.79088.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that's it's possible to query chip id from ath10k anytime.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index fcb40cc..09f535a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -498,6 +498,25 @@ static const struct file_operations fops_simulate_fw_crash = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_chip_id(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned int len;
+	char buf[50];
+
+	len = scnprintf(buf, sizeof(buf), "0x%08x\n", ar->chip_id);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_chip_id = {
+	.read = ath10k_read_chip_id,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.debugfs_phy = debugfs_create_dir("ath10k",
@@ -517,6 +536,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_simulate_fw_crash);
 
+	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_chip_id);
+
 	return 0;
 }
 #endif /* CONFIG_ATH10K_DEBUGFS */

