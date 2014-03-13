Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40649 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaCMIYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 04:24:34 -0400
Subject: [PATCH v2] ath10k: add soft/hard firmware crash option to
 simulate_fw_crash
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Mar 2014 10:24:31 +0200
Message-ID: <20140313082431.10798.10888.stgit@potku.adurom.net> (sfid-20140313_092442_044675_6EE45EBF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marek Puzyniak <marek.puzyniak@tieto.com>

Command WMI_FORCE_FW_HANG_CMDID is not supported in firmware 10.1.
In order to have firmware crash simulation functionality also
in firmware 10.1 driver can force firmware crash by performing not allowed
operation. Driver can deliberately crash firmware when setting vdev param for
vdev id out of range.  This patch introduces two keywords to simulate_fw_crash:

'soft' which will cause firmware crash that is recoverable
       by warm firmware reset but supported only in main firmware.
'hard' which will cause firmware crash recoverable by cold
       firmware reset, this option works for both firmwares.

Commands to trigger firmware soft/hard crash:

echo 'soft' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
echo 'hard' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash

kvalo: use strncmp(), remove '\n' before checking the command and
document how buf is null terminated

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   51 +++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6debd281350a..3da70c74b3fa 100644
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
@@ -467,11 +478,9 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 
 	mutex_lock(&ar->conf_mutex);
 
+	/* Don't copy over the last byte, keep it initialised to zero to
+	 * make sure that the buffer is properly null terminated. */
 	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
-	if (strcmp(buf, "crash") && strcmp(buf, "crash\n")) {
-		ret = -EINVAL;
-		goto exit;
-	}
 
 	if (ar->state != ATH10K_STATE_ON &&
 	    ar->state != ATH10K_STATE_RESTARTED) {
@@ -479,14 +488,30 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 		goto exit;
 	}
 
-	ath10k_info("simulating firmware crash\n");
+	/* drop the possible '\n' from the end */
+	if (buf[count - 1] == '\n') {
+		buf[count - 1] = 0;
+		count--;
+	}
 
-	ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
-	if (ret)
-		ath10k_warn("failed to force fw hang (%d)\n", ret);
+	if (!strncmp(buf, "soft", sizeof(buf))) {
+		ath10k_info("simulating soft firmware crash\n");
+		ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
+	} else if (!strncmp(buf, "hard", sizeof(buf))) {
+		ath10k_info("simulating hard firmware crash\n");
+		ret = ath10k_wmi_vdev_set_param(ar, TARGET_NUM_VDEVS + 1,
+					ar->wmi.vdev_param->rts_threshold, 0);
+	} else {
+		ret = -EINVAL;
+		goto exit;
+	}
 
-	if (ret == 0)
-		ret = count;
+	if (ret) {
+		ath10k_warn("failed to simulate firmware crash: %d\n", ret);
+		goto exit;
+	}
+
+	ret = count;
 
 exit:
 	mutex_unlock(&ar->conf_mutex);

