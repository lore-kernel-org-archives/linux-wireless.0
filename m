Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:10891 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab0D3VFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 17:05:55 -0400
Received: by fg-out-1718.google.com with SMTP id 19so73268fgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Apr 2010 14:05:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170: wait for asynchronous firmware loading
Date: Thu, 29 Apr 2010 17:53:33 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004291753.33414.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression introduced by the following patch:
"ar9170: load firmware asynchronously"

When we kick off a firmware loading request and then unbind,
or disconnect the usb device right away, we get into trouble:

> ------------[ cut here ]------------
> WARNING: at lib/kref.c:44 kref_get+0x1c/0x20()
> Hardware name: 18666GU
> Modules linked in: ar9170usb [...]
> Pid: 6588, comm: firmware/ar9170 Not tainted 2.6.34-rc5-wl #43
> Call Trace:
> [<c102b05e>] ? warn_slowpath_common+0x6e/0xb0
> [<c117c93c>] ? kref_get+0x1c/0x20
> [<c102b0b3>] ? warn_slowpath_null+0x13/0x20
> [<c117c93c>] ? kref_get+0x1c/0x20
> [<c117bb2f>] ? kobject_get+0xf/0x20
> [<c124d630>] ? get_device+0x10/0x20
> [<c124e5a0>] ? device_add+0x60/0x530
> [<c117b8b5>] ? kobject_init+0x25/0xa0
> [<c12569f9>] ? _request_firmware+0x139/0x3e0
> [<c1256cc0>] ? request_firmware_work_func+0x20/0x70
> [<c1256ca0>] ? request_firmware_work_func+0x0/0x70
> [<c103ff24>] ? kthread+0x74/0x80
> [<c103feb0>] ? kthread+0x0/0x80
> [<c1003136>] ? kernel_thread_helper+0x6/0x10
>---[ end trace 2d50bd818f64a1b7 ]---
- followed by a random Oops -

Avoid that by waiting for the firmware loading to finish
(whether successfully or not) before the unbind in
ar9170_usb_disconnect.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Bug-fixed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index c1c7c42..7bae7fd 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -737,12 +737,16 @@ static void ar9170_usb_firmware_failed(struct ar9170_usb *aru)
 {
 	struct device *parent = aru->udev->dev.parent;
 
+	complete(&aru->firmware_loading_complete);
+
 	/* unbind anything failed */
 	if (parent)
 		down(&parent->sem);
 	device_release_driver(&aru->udev->dev);
 	if (parent)
 		up(&parent->sem);
+
+	usb_put_dev(aru->udev);
 }
 
 static void ar9170_usb_firmware_finish(const struct firmware *fw, void *context)
@@ -771,6 +775,8 @@ static void ar9170_usb_firmware_finish(const struct firmware *fw, void *context)
 	if (err)
 		goto err_unrx;
 
+	complete(&aru->firmware_loading_complete);
+	usb_put_dev(aru->udev);
 	return;
 
  err_unrx:
@@ -868,6 +874,7 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	init_usb_anchor(&aru->tx_pending);
 	init_usb_anchor(&aru->tx_submitted);
 	init_completion(&aru->cmd_wait);
+	init_completion(&aru->firmware_loading_complete);
 	spin_lock_init(&aru->tx_urb_lock);
 
 	aru->tx_pending_urbs = 0;
@@ -887,6 +894,7 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	if (err)
 		goto err_freehw;
 
+	usb_get_dev(aru->udev);
 	return request_firmware_nowait(THIS_MODULE, 1, "ar9170.fw",
 				       &aru->udev->dev, GFP_KERNEL, aru,
 				       ar9170_usb_firmware_step2);
@@ -906,6 +914,9 @@ static void ar9170_usb_disconnect(struct usb_interface *intf)
 		return;
 
 	aru->common.state = AR9170_IDLE;
+
+	wait_for_completion(&aru->firmware_loading_complete);
+
 	ar9170_unregister(&aru->common);
 	ar9170_usb_cancel_urbs(aru);
 
diff --git a/drivers/net/wireless/ath/ar9170/usb.h b/drivers/net/wireless/ath/ar9170/usb.h
index a2ce3b1..919b060 100644
--- a/drivers/net/wireless/ath/ar9170/usb.h
+++ b/drivers/net/wireless/ath/ar9170/usb.h
@@ -71,6 +71,7 @@ struct ar9170_usb {
 	unsigned int tx_pending_urbs;
 
 	struct completion cmd_wait;
+	struct completion firmware_loading_complete;
 	int readlen;
 	u8 *readbuf;
 
