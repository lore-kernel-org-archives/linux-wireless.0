Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54815 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1JSAUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 20:20:16 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: Implement support for background scan control from userspace
Date: Tue, 18 Oct 2011 17:20:06 -0700
Message-ID: <1318983606-8959-2-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111019_022021_509199_2ECCCF12)
In-Reply-To: <1318983606-8959-1-git-send-email-rpanjwan@qca.qualcomm.com>
References: <1318983606-8959-1-git-send-email-rpanjwan@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to allow user space based control of background scan interval,
we use available debugfs infrastructure. The feature has been added for
testing purposes. The user has to write the bgscan interval (in secs) to
the bgscan_interval file in ath6kl debug directory. To disable bgscan,
a '0' is to be written to the bgscan_interval file.

Example:

echo "2" > bgscan_interval

This will make the background scan interval as 2 seconds

Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   37 +++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index e109f29..3eaa291 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1455,6 +1455,40 @@ static const struct file_operations fops_delete_qos = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_bgscan_int_write(struct file *file,
+				const char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	u16 bgscan_int;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtou16(buf, 0, &bgscan_int))
+		return -EINVAL;
+
+	if (bgscan_int)
+		ath6kl_wmi_scanparams_cmd(ar->wmi, 0, 0, bgscan_int, 0, 0, 0, 3,
+			0, 0, 0);
+	else
+		ath6kl_wmi_scanparams_cmd(ar->wmi, 0, 0, 0xffff, 0, 0, 0, 3, 0,
+			0, 0);
+
+	return count;
+}
+
+static const struct file_operations fops_bgscan_int = {
+	.write = ath6kl_bgscan_int_write,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
@@ -1534,6 +1568,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("delete_qos", S_IWUSR, ar->debugfs_phy, ar,
 				&fops_delete_qos);
 
+	debugfs_create_file("bgscan_interval", S_IWUSR,
+				ar->debugfs_phy, ar, &fops_bgscan_int);
+
 	return 0;
 }
 
-- 
1.7.0.4

