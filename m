Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43074 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0EYV6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 17:58:55 -0400
Received: by fxm5 with SMTP id 5so3765904fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 14:58:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.35] ar9170usb: fix read from freed driver context
Date: Tue, 25 May 2010 23:58:47 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005252358.48435.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit "ar9170: wait for asynchronous firmware loading"
introduced a bug, which is triggered by fatal errors
while the driver is initializing the device.

BUG: unable to handle kernel paging request at 6b6b6bf7
IP: [<c117b567>] kobject_put+0x7/0x70
*pde = 00000000 
Oops: 0000 [#1] PREEMPT 
last sysfs file: /sys/devices/platform/hdaps/position
Modules linked in: ar9170usb [...]

Pid: 6246, comm: firmware/ar9170 Not tainted 2.6.34-wl #54
EIP: 0060:[<c117b567>] EFLAGS: 00010206 CPU: 0
EIP is at kobject_put+0x7/0x70
EAX: 6b6b6bd7 EBX: f4d3d0e0 ECX: f5ba9124 EDX: f6af2a7c
ESI: 00000000 EDI: f4d3d0e0 EBP: 00000000 ESP: f5e98f9c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process firmware/ar9170 (pid: 6246)
Stack:
 c12532ed 00000246 f5bfaa70 f8487353 f4d3d0e0
Call Trace:
 [<c12532ed>] ? device_release_driver+0x1d/0x30
 [<f8487353>] ? ar9170_usb_firmware_failed+0x43/0x70 [ar9170usb]
 [<c125983c>] ? request_firmware_work_func+0x2c/0x70
 [<c1259810>] ? request_firmware_work_func+0x0/0x70
 [<c10413f4>] ? kthread+0x74/0x80
 [<c1041380>] ? kthread+0x0/0x80
 [<c1003136>] ? kernel_thread_helper+0x6/0x10
Code: 40 d3 f2 ff 85 c0 89 c3 74 0a ba 44 86 4c c1 e8 [...]
EIP: [<c117b567>] kobject_put+0x7/0x70 SS:ESP 0068:f5e98f9c
CR2: 000000006b6b6bf7
---[ end trace e81abb992434b410 ]---

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 82ab532..a93dc18 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -739,17 +739,27 @@ err_out:
 static void ar9170_usb_firmware_failed(struct ar9170_usb *aru)
 {
 	struct device *parent = aru->udev->dev.parent;
+	struct usb_device *udev;
+
+	/*
+	 * Store a copy of the usb_device pointer locally.
+	 * This is because device_release_driver initiates
+	 * ar9170_usb_disconnect, which in turn frees our
+	 * driver context (aru).
+	 */
+	udev = aru->udev;
 
 	complete(&aru->firmware_loading_complete);
 
 	/* unbind anything failed */
 	if (parent)
 		device_lock(parent);
-	device_release_driver(&aru->udev->dev);
+
+	device_release_driver(&udev->dev);
 	if (parent)
 		device_unlock(parent);
 
-	usb_put_dev(aru->udev);
+	usb_put_dev(udev);
 }
 
 static void ar9170_usb_firmware_finish(const struct firmware *fw, void *context)
