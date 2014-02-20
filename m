Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39371 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaBTLzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 06:55:51 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so29074eek.13
        for <linux-wireless@vger.kernel.org>; Thu, 20 Feb 2014 03:55:50 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] ath10k: add soft/hard firmware crash option to simulate_fw_crash
Date: Thu, 20 Feb 2014 12:55:30 +0100
Message-Id: <1392897330-4678-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20140220_125605_425771_1AEA5281)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Command WMI_FORCE_FW_HANG_CMDID is not supported in firmware 10.1.
In order to have firmware crash simulation functionality also
in firmware 10.1 driver can force firmware crash by performing
not allowed operation. Driver can deliberately crash firmware
when setting vdev param for vdev id out of range.
This patch introduces two keywords to simulate_fw_crash:
'soft' which will cause firmware crash that is recoverable
       by warm firmware reset but supported only in main firmware.
'hard' which will cause firmware crash recoverable by cold
       firmware reset, this option works for both firmwares.

Commands to trigger firmware soft/hard crash:
echo 'soft' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
echo 'hard' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---

This was patch: ath10k:change simulate_fw_crash to work with 10.1 firmware
but after review updates I changed commit message.

Previous patch was updated to support two keywords 'soft','hard' in order to
distinguish different kind of firmware crashes.

 drivers/net/wireless/ath/ath10k/debug.c | 43 ++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6debd28..20f4c4b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -451,12 +451,23 @@ static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
 					     char __user *user_buf,
 					     size_t count, loff_t *ppos)
 {
-	const char buf[] = "To simulate firmware crash write the keyword"
-			   " `crash` to this file.\nThis will force firmware"
-			   " to report a crash to the host system.\n";
+	const char buf[] = "To simulate firmware crash write one of the"
+			   " keywords to this file:\n `soft` - this will send"
+			   " WMI_FORCE_FW_HANG_ASSERT to firmware if FW"
+			   " supports that command.\n `hard` - this will send"
+			   " to firmware command with illegal parameters"
+			   " causing firmware crash.\n";
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 }
 
+/* Simulate firmware crash:
+ * 'soft': Call wmi command causing firmware hang. This firmware hang is
+ * recoverable by warm firmware reset.
+ * 'hard': Force firmware crash by setting any vdev parameter for not allowed
+ * vdev id. This is hard firmware crash because it is recoverable only by cold
+ * firmware reset.
+ */
 static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 					      const char __user *user_buf,
 					      size_t count, loff_t *ppos)
@@ -464,14 +475,11 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 	struct ath10k *ar = file->private_data;
 	char buf[32] = {};
 	int ret;
+	const char *mode;
 
 	mutex_lock(&ar->conf_mutex);
 
 	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
-	if (strcmp(buf, "crash") && strcmp(buf, "crash\n")) {
-		ret = -EINVAL;
-		goto exit;
-	}
 
 	if (ar->state != ATH10K_STATE_ON &&
 	    ar->state != ATH10K_STATE_RESTARTED) {
@@ -479,15 +487,22 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 		goto exit;
 	}
 
-	ath10k_info("simulating firmware crash\n");
-
-	ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
-	if (ret)
-		ath10k_warn("failed to force fw hang (%d)\n", ret);
+	if (!strcmp(buf, "soft") || !strcmp(buf, "soft\n")) {
+		mode = "soft";
+		ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
+	} else if (!strcmp(buf, "hard") || !strcmp(buf, "hard\n")) {
+		mode = "hard";
+		ret = ath10k_wmi_vdev_set_param(ar, TARGET_NUM_VDEVS + 1,
+					ar->wmi.vdev_param->rts_threshold, 0);
+	} else {
+		ret = -EINVAL;
+		goto exit;
+	}
 
-	if (ret == 0)
+	if (ret == 0) {
 		ret = count;
-
+		ath10k_info("simulating firmware %s crash\n", mode);
+	}
 exit:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
-- 
1.8.1.2

