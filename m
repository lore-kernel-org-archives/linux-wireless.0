Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56207 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab3GPH4C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:56:02 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 3/3] ath10k: create debugfs interface to trigger fw crash
Date: Tue, 16 Jul 2013 09:54:37 +0200
Message-ID: <1373961277-14784-4-git-send-email-michal.kazior@tieto.com> (sfid-20130716_095659_752795_3A7688BB)
In-Reply-To: <1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
References: <1372148011-28234-1-git-send-email-michal.kazior@tieto.com>
 <1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
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
 drivers/net/wireless/ath/ath10k/debug.c |   54 +++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 65279f5..4021bea 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -445,6 +445,57 @@ static const struct file_operations fops_fw_stats = {
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
+		ath10k_warn("write keyword `crash` to simulate firmware crash\n");
+		goto exit;
+	}
+
+	if (ar->state != ATH10K_STATE_ON &&
+	    ar->state != ATH10K_STATE_RESTARTED) {
+		ath10k_warn("firmware isn't loaded yet, nothing to crash\n");
+		goto exit;
+	}
+
+	ath10k_info("simulating firmware crash\n");
+
+	ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
+	if (ret)
+		ath10k_warn("failed to force fw hang (%d)\n", ret);
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return count;
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
@@ -461,6 +512,9 @@ int ath10k_debug_create(struct ath10k *ar)
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

