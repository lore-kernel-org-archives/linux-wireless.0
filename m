Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:47834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753362AbZBDB2u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 20:28:50 -0500
Subject: patch staging-at76_usb-fix-bugs-introduced-by-staging-at76_usb-cleanup-dma-on-stack-issues.patch added to gregkh-2.6 tree
To: jandryuk@gmail.com, gregkh@suse.de, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, oliver@neukum.org, oneukum@suse.de
From: <gregkh@suse.de>
Date: Tue, 03 Feb 2009 17:26:39 -0800
In-Reply-To: <20090130140503.GC3485@tuxdriver.com>
Message-ID: <1233710799859@kroah.org> (sfid-20090204_022855_635850_BDE60297)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    Subject: Staging: at76_usb: fix bugs introduced by "Staging: at76_usb: cleanup dma on stack issues"

to my gregkh-2.6 tree.  Its filename is

    staging-at76_usb-fix-bugs-introduced-by-staging-at76_usb-cleanup-dma-on-stack-issues.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From linville@tuxdriver.com  Tue Feb  3 17:06:34 2009
From: Jason Andryuk <jandryuk@gmail.com>
Date: Fri, 30 Jan 2009 09:05:03 -0500
Subject: Staging: at76_usb: fix bugs introduced by "Staging: at76_usb: cleanup dma on stack issues"
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, gregkh@suse.de, kalle.valo@iki.fi
Message-ID: <20090130140503.GC3485@tuxdriver.com>
Content-Disposition: inline


Tracking down the firmware loading problem led to this commit.

$ git bisect bad
0d1d1424330cc1934f2b2742f0cfa2c31e6a250b is first bad commit
commit 0d1d1424330cc1934f2b2742f0cfa2c31e6a250b
Author: Oliver Neukum <oliver@neukum.org>
Date:   Thu Dec 18 13:16:40 2008 +0100

    Staging: at76_usb: cleanup dma on stack issues

    - no DMA on stack
    - cleanup unclear endianness issue

    Signed-off-by: Oliver Neukum <oneukum@suse.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 c4fee9ea0fef25926229d810d19dc2f89cca9401
8b165a35d16280d2413b2700a6080ef290ca1009 M	drivers

The "no DMA on stack" conversion was incomplete with respect to
updating the arguments passed to usb_control_msg.  The value 40 is
hardcoded as it was prior to conversion.

The driver can now load firmware, but is not fully functional.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/at76_usb/at76_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -649,7 +649,7 @@ static int at76_get_op_mode(struct usb_d
 		return -ENOMEM;
 	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x33,
 			      USB_TYPE_VENDOR | USB_DIR_IN |
-			      USB_RECIP_INTERFACE, 0x01, 0, &op_mode, 1,
+			      USB_RECIP_INTERFACE, 0x01, 0, op_mode, 1,
 			      USB_CTRL_GET_TIMEOUT);
 	saved = *op_mode;
 	kfree(op_mode);
@@ -782,7 +782,7 @@ static inline int at76_get_cmd_status(st
 	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x22,
 			      USB_TYPE_VENDOR | USB_DIR_IN |
 			      USB_RECIP_INTERFACE, cmd, 0, stat_buf,
-			      sizeof(stat_buf), USB_CTRL_GET_TIMEOUT);
+			      40, USB_CTRL_GET_TIMEOUT);
 	if (ret >= 0)
 		ret = stat_buf[5];
 	kfree(stat_buf);


Patches currently in gregkh-2.6 which might be from jandryuk@gmail.com are

staging/staging-at76_usb-fix-bugs-introduced-by-staging-at76_usb-cleanup-dma-on-stack-issues.patch
