Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35955 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaH1PQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 11:16:26 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k: Support firmware crash-by-assert.
Date: Thu, 28 Aug 2014 08:15:57 -0700
Message-Id: <1409238957-30625-1-git-send-email-greearb@candelatech.com> (sfid-20140828_171629_182189_845F9C81)
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

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |  8 +++++++-
 drivers/net/wireless/ath/ath10k/wmi.c   | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h   |  1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8da3d57..01ff6fb 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -580,7 +580,10 @@ static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
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
@@ -629,6 +632,9 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 		 */
 		ret = ath10k_wmi_vdev_set_param(ar, 0x7fff,
 					ar->wmi.vdev_param->rts_threshold, 0);
+	} else if (!strcmp(buf, "assert")) {
+		/* This is a clean assert crash. */
+		ret = ath10k_wmi_vdev_assert(ar, 0x7ffe);
 	} else {
 		ret = -EINVAL;
 		goto exit;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 5d96926..ac32b22 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3725,6 +3725,26 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 				   ar->wmi.cmd->vdev_install_key_cmdid);
 }
 
+int ath10k_wmi_vdev_assert(struct ath10k *ar, u32 crashme)
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
+	cmd->vdev_id = __cpu_to_le32(crashme);
+
+	ath10k_info(ar,
+		    "simulating firmware ASSERT with bad install_key vdev-id: 0x%x\n",
+		    cmd->vdev_id);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->vdev_install_key_cmdid);
+}
+
 int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
 				  const struct wmi_vdev_spectral_conf_arg *arg)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index eae0105..45836cc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4774,6 +4774,7 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 			      u32 param_id, u32 param_value);
 int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 				const struct wmi_vdev_install_key_arg *arg);
+int ath10k_wmi_vdev_assert(struct ath10k *ar, u32 crashme);
 int ath10k_wmi_vdev_spectral_conf(struct ath10k *ar,
 				  const struct wmi_vdev_spectral_conf_arg *arg);
 int ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
-- 
1.7.11.7

