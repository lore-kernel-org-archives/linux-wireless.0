Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34194 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZDYTcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 15:32:11 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170usb: reset device on resume
Date: Sat, 25 Apr 2009 21:32:09 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904252132.09966.chunkeey@web.de> (sfid-20090425_213220_315292_D6B160E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch takes care of an outstanding comment in
"[PATCH] ar9170usb: fix hang on resume" commit message.

>However, the device does not accept the firmware on resume.
>and it will exit with:
>
>> firmware part 1 upload failed (-71).
>> device is in a bad state. please reconnect it!

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Johannes,

does this two-liner breathe life into the device after resume?

Regards,
	Chr
---
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index fddda47..368fc2d 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -689,6 +689,7 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	aru->common.exec_cmd = ar9170_usb_exec_cmd;
 	aru->common.callback_cmd = ar9170_usb_callback_cmd;
 
+	udev->reset_resume = 1;
 	err = ar9170_usb_reset(aru);
 	if (err)
 		goto err_freehw;
@@ -805,6 +806,7 @@ static struct usb_driver ar9170_driver = {
 #ifdef CONFIG_PM
 	.suspend = ar9170_suspend,
 	.resume = ar9170_resume,
+	.reset_resume = ar9170_resume,
 #endif /* CONFIG_PM */
 };
 
