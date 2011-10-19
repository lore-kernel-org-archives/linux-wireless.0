Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30856 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1JSAgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 20:36:32 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Implement support for listen interval from userspace
Date: Tue, 18 Oct 2011 17:36:31 -0700
Message-ID: <1318984591-10037-2-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111019_023636_586020_3F2C22FD)
In-Reply-To: <1318984591-10037-1-git-send-email-rpanjwan@qca.qualcomm.com>
References: <1318984591-10037-1-git-send-email-rpanjwan@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to allow user space based control of listen interval, we use
available debugfs infrastructure. Listen interval implies how frequently
we want the WLAN chip to wake up and synchronize the beacons in case it
is in sleep mode. The user has to write the listen interval (in msecs) to
the listen_interval file in ath6kl debug directory. The minimum value is
15 and maximum is 5000.

Example:

echo "30" > listen_interval

This will make the listen interval approximately 30 msecs.

Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   50 +++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 3eaa291..41f36d2 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1488,6 +1488,53 @@ static const struct file_operations fops_bgscan_int = {
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
+static ssize_t ath6kl_listen_int_write(struct file *file,
+						const char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	u16 listen_int;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtou16(buf, 0, &listen_int))
+		return -EINVAL;
+
+	if ((listen_int >= 15) && (listen_int <= 5000)) {
+		ar->listen_intvl_t = listen_int;
+		ath6kl_wmi_listeninterval_cmd(ar->wmi, ar->listen_intvl_t, 0);
+	} else {
+		return -EINVAL;
+	}
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
+	len = snprintf(buf, sizeof(buf), "%u\n", ar->listen_intvl_t);
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
 
 int ath6kl_debug_init(struct ath6kl *ar)
 {
@@ -1571,6 +1618,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("bgscan_interval", S_IWUSR,
 				ar->debugfs_phy, ar, &fops_bgscan_int);
 
+	debugfs_create_file("listen_interval", S_IWUSR, ar->debugfs_phy, ar,
+						&fops_listen_int);
+
 	return 0;
 }
 
-- 
1.7.0.4

