Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57649 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1JZCzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 22:55:24 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: Implement support for power parameter control from userspace
Date: Tue, 25 Oct 2011 19:52:41 -0700
Message-ID: <1319597561-20454-2-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111026_045527_195129_AB2E18EB)
In-Reply-To: <1319597561-20454-1-git-send-email-rpanjwan@qca.qualcomm.com>
References: <1319597561-20454-1-git-send-email-rpanjwan@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to allow user space based control of power parameters, we use
available debugfs infrastructure. With these features user can control
power consumption by adjusting various sleep/wake up related parameters.
The feature has been added for testing purposes. All 5 parameters are
mandatory in correct order. They have to be written to the power_params
file. These are:

1) idle_period
2) no_of_pspoll
3) dtim_policy
4) tx_wakeup_policy
5) no_tx_to_wakeup

Example:

echo "200 1 0 1 1" > power_params

Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   65 +++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 67254ca..dbf2aa6 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1520,6 +1520,68 @@ static const struct file_operations fops_listen_int = {
 	.llseek = default_llseek,
 };
 
+
+static ssize_t ath6kl_power_params_write(struct file *file,
+						const char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	u8 buf[100];
+	unsigned int len = 0;
+	char *sptr, *token;
+	u16 idle_period, ps_poll_num, dtim,
+		tx_wakeup, num_tx;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+	sptr = buf;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou16(token, 0, &idle_period))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou16(token, 0, &ps_poll_num))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou16(token, 0, &dtim))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou16(token, 0, &tx_wakeup))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou16(token, 0, &num_tx))
+		return -EINVAL;
+
+	ath6kl_wmi_pmparams_cmd(ar->wmi, idle_period, ps_poll_num,
+						dtim, tx_wakeup, num_tx, 0);
+
+	return count;
+}
+
+
+static const struct file_operations fops_power_params = {
+	.write = ath6kl_power_params_write,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
@@ -1605,6 +1667,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("listen_interval", S_IWUSR, ar->debugfs_phy, ar,
 						&fops_listen_int);
 
+	debugfs_create_file("power_params", S_IWUSR, ar->debugfs_phy, ar,
+						&fops_power_params);
+
 	return 0;
 }
 
-- 
1.7.0.4

