Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51153 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0JPGzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Oct 2010 02:55:51 -0400
Received: by bwz15 with SMTP id 15so1518158bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 23:55:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: fix async command buffer leak
Date: Sat, 16 Oct 2010 01:38:46 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010160138.47219.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If __carl9170_exec_cmd fails to upload an asynchronous
command to the device, the functions: carl9170_reboot
and carl9170_powersave will leak the temporary command
assembly buffer.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index c7f6193..d8607f4 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -591,16 +591,23 @@ int __carl9170_exec_cmd(struct ar9170 *ar, struct carl9170_cmd *cmd,
 			const bool free_buf)
 {
 	struct urb *urb;
+	int err = 0;
 
-	if (!IS_INITIALIZED(ar))
-		return -EPERM;
+	if (!IS_INITIALIZED(ar)) {
+		err = -EPERM;
+		goto err_free;
+	}
 
-	if (WARN_ON(cmd->hdr.len > CARL9170_MAX_CMD_LEN - 4))
-		return -EINVAL;
+	if (WARN_ON(cmd->hdr.len > CARL9170_MAX_CMD_LEN - 4)) {
+		err = -EINVAL;
+		goto err_free;
+	}
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!urb)
-		return -ENOMEM;
+	if (!urb) {
+		err = -ENOMEM;
+		goto err_free;
+	}
 
 	usb_fill_int_urb(urb, ar->udev, usb_sndintpipe(ar->udev,
 		AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,
@@ -613,6 +620,12 @@ int __carl9170_exec_cmd(struct ar9170 *ar, struct carl9170_cmd *cmd,
 	usb_free_urb(urb);
 
 	return carl9170_usb_submit_cmd_urb(ar);
+
+err_free:
+	if (free_buf)
+		kfree(cmd);
+
+	return err;
 }
 
 int carl9170_exec_cmd(struct ar9170 *ar, const enum carl9170_cmd_oids cmd,
