Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:49373 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab3GVMJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:09:03 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4] ath10k: create debugfs interface to trigger fw crash
Date: Mon, 22 Jul 2013 14:08:51 +0200
Message-ID: <1374494931-18913-1-git-send-email-michal.kazior@tieto.com> (sfid-20130722_140912_765838_DFB6F82D)
In-Reply-To: <878v1122id.fsf@kamboji.qca.qualcomm.com>
References: <878v1122id.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful for testing. To perform a
forced firmware crash write 'crash' to
'simulate_fw_crash' debugfs file. E.g.

  echo crash > /sys/kernel/debug/ieee80211/phy1/ath10k/simulate_fw_crash

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3: return an appropriate errno instead of using ath10k_warn()

 drivers/net/wireless/ath/ath10k/debug.c |   57 +++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 65279f5..3d65594 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -445,6 +445,60 @@ static const struct file_operations fops_fw_stats = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
+					     char __user *user_buf,
+					     size_t count, loff_t *ppos)
+{
+	const char buf[] = "To simulate firmware crash write the keyword"
+			   " `crash` to this file.\nThis will force firmware"
+			   " to report a crash to the host system.\n";
+	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+}
+
+static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
+					      const char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32] = {};
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+	if (strcmp(buf, "crash") && strcmp(buf, "crash\n")) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (ar->state != ATH10K_STATE_ON &&
+	    ar->state != ATH10K_STATE_RESTARTED) {
+		ret = -ENETDOWN;
+		goto exit;
+	}
+
+	ath10k_info("simulating firmware crash\n");
+
+	ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
+	if (ret)
+		ath10k_warn("failed to force fw hang (%d)\n", ret);
+
+	if (ret == 0)
+		ret = count;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static const struct file_operations fops_simulate_fw_crash = {
+	.read = ath10k_read_simulate_fw_crash,
+	.write = ath10k_write_simulate_fw_crash,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.debugfs_phy = debugfs_create_dir("ath10k",
@@ -461,6 +515,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("wmi_services", S_IRUSR, ar->debug.debugfs_phy, ar,
 			    &fops_wmi_services);
 
+	debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_simulate_fw_crash);
+
 	return 0;
 }
 #endif /* CONFIG_ATH10K_DEBUGFS */
-- 
1.7.9.5

