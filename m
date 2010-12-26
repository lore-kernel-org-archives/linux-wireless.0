Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45094 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0LZT5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 14:57:07 -0500
Received: by bwz15 with SMTP id 15so9183399bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Dec 2010 11:57:06 -0800 (PST)
Message-Id: <E1PWwiD-0003TF-Lf@debian64.daheim>
Subject: [PATCH 3/3] carl9170: fix usb pm suspend->resume woes
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, angus_rt@hotmail.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 26 Dec 2010 18:22:29 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch revamps some common code-paths which are
shared between (re-)initialization and suspend/resume
subroutines. It also adds some helpful comments
about quirks and associated difficulties.

It's quite big, but it should fix #25382:
<https://bugzilla.kernel.org/show_bug.cgi?id=25382>

And hopefully the code is robust enough to deal with
all possible suspend/resume scenarios without requiring
the user to do any sort of manual and possibly
dangerous work.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/usb.c |   53 +++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 2d947a3..537732e 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -834,7 +834,7 @@ static int carl9170_usb_load_firmware(struct ar9170 *ar)
 	if (err)
 		goto err_out;
 
-	/* firmware restarts cmd counter */
+	/* now, start the command response counter */
 	ar->cmd_seq = -1;
 
 	return 0;
@@ -851,7 +851,12 @@ int carl9170_usb_restart(struct ar9170 *ar)
 	if (ar->intf->condition != USB_INTERFACE_BOUND)
 		return 0;
 
-	/* Disable command response sequence counter. */
+	/*
+	 * Disable the command response sequence counter check.
+	 * We already know that the device/firmware is in a bad state.
+	 * So, no extra points are awarded to anyone who reminds the
+	 * driver about that.
+	 */
 	ar->cmd_seq = -2;
 
 	err = carl9170_reboot(ar);
@@ -903,6 +908,15 @@ static int carl9170_usb_init_device(struct ar9170 *ar)
 {
 	int err;
 
+	/*
+	 * The carl9170 firmware let's the driver know when it's
+	 * ready for action. But we have to be prepared to gracefully
+	 * handle all spurious [flushed] messages after each (re-)boot.
+	 * Thus the command response counter remains disabled until it
+	 * can be safely synchronized.
+	 */
+	ar->cmd_seq = -2;
+
 	err = carl9170_usb_send_rx_irq_urb(ar);
 	if (err)
 		goto err_out;
@@ -911,14 +925,21 @@ static int carl9170_usb_init_device(struct ar9170 *ar)
 	if (err)
 		goto err_unrx;
 
+	err = carl9170_usb_open(ar);
+	if (err)
+		goto err_unrx;
+
 	mutex_lock(&ar->mutex);
 	err = carl9170_usb_load_firmware(ar);
 	mutex_unlock(&ar->mutex);
 	if (err)
-		goto err_unrx;
+		goto err_stop;
 
 	return 0;
 
+err_stop:
+	carl9170_usb_stop(ar);
+
 err_unrx:
 	carl9170_usb_cancel_urbs(ar);
 
@@ -964,10 +985,6 @@ static void carl9170_usb_firmware_finish(struct ar9170 *ar)
 	if (err)
 		goto err_freefw;
 
-	err = carl9170_usb_open(ar);
-	if (err)
-		goto err_unrx;
-
 	err = carl9170_register(ar);
 
 	carl9170_usb_stop(ar);
@@ -1043,7 +1060,6 @@ static int carl9170_usb_probe(struct usb_interface *intf,
 	atomic_set(&ar->rx_work_urbs, 0);
 	atomic_set(&ar->rx_anch_urbs, 0);
 	atomic_set(&ar->rx_pool_urbs, 0);
-	ar->cmd_seq = -2;
 
 	usb_get_dev(ar->udev);
 
@@ -1090,10 +1106,6 @@ static int carl9170_usb_suspend(struct usb_interface *intf,
 
 	carl9170_usb_cancel_urbs(ar);
 
-	/*
-	 * firmware automatically reboots for usb suspend.
-	 */
-
 	return 0;
 }
 
@@ -1106,12 +1118,20 @@ static int carl9170_usb_resume(struct usb_interface *intf)
 		return -ENODEV;
 
 	usb_unpoison_anchored_urbs(&ar->rx_anch);
+	carl9170_set_state(ar, CARL9170_STOPPED);
 
-	err = carl9170_usb_init_device(ar);
-	if (err)
-		goto err_unrx;
+	/*
+	 * The USB documentation demands that [for suspend] all traffic
+	 * to and from the device has to stop. This would be fine, but
+	 * there's a catch: the device[usb phy] does not come back.
+	 *
+	 * Upon resume the firmware will "kill" itself and the
+	 * boot-code sorts out the magic voodoo.
+	 * Not very nice, but there's not much what could go wrong.
+	 */
+	msleep(1100);
 
-	err = carl9170_usb_open(ar);
+	err = carl9170_usb_init_device(ar);
 	if (err)
 		goto err_unrx;
 
@@ -1133,6 +1153,7 @@ static struct usb_driver carl9170_driver = {
 #ifdef CONFIG_PM
 	.suspend = carl9170_usb_suspend,
 	.resume = carl9170_usb_resume,
+	.reset_resume = carl9170_usb_resume,
 #endif /* CONFIG_PM */
 };
 
-- 
1.7.2.3

