Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56761 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1JZA0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 20:26:55 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH v3] ath6kl: Implement support for listen interval from userspace
Date: Tue, 25 Oct 2011 17:26:29 -0700
Message-ID: <1319588789-17632-2-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111026_022659_114505_88DA36AE)
In-Reply-To: <1319588789-17632-1-git-send-email-rpanjwan@qca.qualcomm.com>
References: <1319588789-17632-1-git-send-email-rpanjwan@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to allow user space based control of listen interval, we use
available debugfs infrastructure. Listen interval implies how frequently
we want the WLAN chip to wake up and synchronize the beacons in case it
is in sleep mode. The command requires two parameters in the following order:

1) listen_interval_time
2) listen_interval_beacons

The user has to write the listen interval_time (in msecs) and
listen_interval_beacons (in no. of beacons) to the listen_interval file in
ath6kl debug directory.

Example:

echo "30 1" > listen_interval

Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   63 +++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 3eaa291..2f865a0 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1489,6 +1489,69 @@ static const struct file_operations fops_bgscan_int = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_listen_int_write(struct file *file,
+						const char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	u16 listen_int_t, listen_int_b;
+	char buf[32];
+	char *sptr, *token;
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	sptr = buf;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+
+	if (kstrtou16(token, 0, &listen_int_t))
+		return -EINVAL;
+
+	if (kstrtou16(sptr, 0, &listen_int_b))
+		return -EINVAL;
+
+	if ((listen_int_t < 15) || (listen_int_t > 5000))
+		return -EINVAL;
+
+	if ((listen_int_b < 1) || (listen_int_b > 50))
+		return -EINVAL;
+
+	ar->listen_intvl_t = listen_int_t;
+	ar->listen_intvl_b = listen_int_b;
+	ath6kl_wmi_listeninterval_cmd(ar->wmi, ar->listen_intvl_t,
+							ar->listen_intvl_b);
+
+	return count;
+}
+
+static ssize_t ath6kl_listen_int_read(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	char buf[16];
+	int len;
+
+	len = snprintf(buf, sizeof(buf), "%u %u\n", ar->listen_intvl_t,
+					ar->listen_intvl_b);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_listen_int = {
+	.read = ath6kl_listen_int_read,
+	.write = ath6kl_listen_int_write,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
-- 
1.7.0.4

