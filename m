Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbXHSSaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:25 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:25 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/30] rt2x00: Check return value of usb_control_msg()
Date: Sun, 19 Aug 2007 20:21:55 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192021.55413.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 91de0ebc5c8e4c6799b4de5b34301a0884c085d2 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 12:52:33 +0200
Subject: [PATCH 03/30] rt2x00: Check return value of usb_control_msg()

Check the return value of usb_control_msg and try
to determine the best course of action:
 - Bail out immediately
 - Increase timeout value
 - Try again

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00usb.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00usb.c b/drivers/net/wireless/rt2x00usb.c
index 38804d7..05ae870 100644
--- a/drivers/net/wireless/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00usb.c
@@ -47,6 +47,7 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	int status;
 	unsigned int i;
+	unsigned int time = timeout;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		status = usb_control_msg(usb_dev,
@@ -54,9 +55,20 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 					  usb_rcvctrlpipe(usb_dev, 0) :
 					  usb_sndctrlpipe(usb_dev, 0)),
 					 request, type, value, offset,
-					 buffer, buffer_length, timeout);
+					 buffer, buffer_length, time);
+
 		if (status >= 0)
 			return 0;
+
+		/*
+		 * Check for errors,
+		 * -ETIMEDOUT: We need a bit more time to complete.
+		 * -ENODEV: Device has disappeared, no point continuing.
+		 */
+		if (status == -ETIMEDOUT)
+			time *= 2;
+		else if (status == -ENODEV)
+			break;
 	}
 
 	ERROR(rt2x00dev,
-- 
1.5.3.rc5

