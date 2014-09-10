Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:57344 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJP7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 11:59:31 -0400
Subject: [PATCH v2] ath10k: support firmware crash-by-assert
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 Sep 2014 18:59:28 +0300
Message-ID: <20140910155928.30418.45160.stgit@potku.adurom.net> (sfid-20140910_175934_851291_3F760653)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

10.1 firmware does not have an official way to
cause assert on purpose, but it can be done with
carefully crafted WMI command.  This is a different
kind of crash from the 'hard' crash, which is
a bad memory dereference.

Different crashes decode in different manners, so
this will help the crash-report testing as well as
offer better ways to test firmware failure and
recovery.

kvalo: move the wmi command creation to debug.c, modify
the info print

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f948a4d8ee59..c5d01058c2a3 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -565,6 +565,26 @@ static const struct file_operations fops_fw_stats = {
 	.llseek = default_llseek,
 };
 
+/* This is a clean assert crash in firmware. */
+static int ath10k_debug_fw_assert(struct ath10k *ar)
+{
+	struct wmi_vdev_install_key_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd) + 16);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_vdev_install_key_cmd *)skb->data;
+	memset(cmd, 0, sizeof(*cmd));
+
+	/* big enough number so that firmware asserts */
+	cmd->vdev_id = __cpu_to_le32(0x7ffe);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->vdev_install_key_cmdid);
+}
+
 static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
 					     char __user *user_buf,
 					     size_t count, loff_t *ppos)
@@ -574,7 +594,10 @@ static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
 			   " WMI_FORCE_FW_HANG_ASSERT to firmware if FW"
 			   " supports that command.\n `hard` - this will send"
 			   " to firmware command with illegal parameters"
-			   " causing firmware crash.\n";
+			   " causing firmware crash.\n"
+			   "`assert` - this will send special illegal parameter"
+			   " to firmware to cause assert failure"
+			   " and crash.\n";
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 }
@@ -623,6 +646,9 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 		 */
 		ret = ath10k_wmi_vdev_set_param(ar, 0x7fff,
 					ar->wmi.vdev_param->rts_threshold, 0);
+	} else if (!strcmp(buf, "assert")) {
+		ath10k_info(ar, "simulating firmware assert crash\n");
+		ret = ath10k_debug_fw_assert(ar);
 	} else {
 		ret = -EINVAL;
 		goto exit;

