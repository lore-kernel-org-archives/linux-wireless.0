Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57758 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760568Ab0J1WJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 18:09:51 -0400
Received: by wyf28 with SMTP id 28so2446241wyf.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 15:09:50 -0700 (PDT)
Message-ID: <4CC9F4BE.7070500@lwfinger.net>
Date: Thu, 28 Oct 2010 17:10:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek rtl8188 support?
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com> <201009212120.07914.s.L-H@gmx.de> <4CC9C067.9040105@lwfinger.net> <201010282348.16673.s.L-H@gmx.de>
In-Reply-To: <201010282348.16673.s.L-H@gmx.de>
Content-Type: multipart/mixed;
 boundary="------------040307030906090806060208"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040307030906090806060208
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/28/2010 04:48 PM, Stefan Lippers-Hollmann wrote:
> 
> I assume you refer to rtl8712u.bin in your r8712u_firmware tree:
> http://git.kernel.org/?p=linux/kernel/git/lwfinger/r8712u_firmware.git;a=blob_plain;f=rtl8712u.bin
> 200fd952db3cc9259b1fd05e3e51966f  *rtl8712u.bin
> 
>> you want to grab the new firmware package, I can send you a copy of the patch.
> 
> I'd very much like to test the patch(2) needed for rtl8712, if possible.

Attached is the patch. You should place rtl8712u.bin in
/lib/modules/rtl8712u/rtl8712u.bin.

Larry

--------------040307030906090806060208
Content-Type: text/x-patch;
 name="0001-staging-r8712u-Switch-driver-to-use-external-firmwar.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-staging-r8712u-Switch-driver-to-use-external-firmwar.pa";
 filename*1="tch"

>From 2559d624a3bfc47e6ba9d1cf5157c5c7b1cbf80e Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 26 Oct 2010 10:59:11 -0500
Subject: [PATCH 1/2] staging: r8712u: Switch driver to use external firmware from linux-firmware

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/TODO       |    2 --
 drivers/staging/rtl8712/hal_init.c |   22 +++++++++++++++++-----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
index 5c88821..ed22b0b 100644
--- a/drivers/staging/rtl8712/TODO
+++ b/drivers/staging/rtl8712/TODO
@@ -4,8 +4,6 @@ TODO:
 - switch to use MAC80211
 - checkpatch.pl fixes - only a few remain
 - sparse fixes
-- switch from large inline firmware file to use the firmware interface
-  and add the file to the linux-firmware package.
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
 Larry Finger <Larry.Finger@lwfinger.net> and
diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 32088a6..014fbbc 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -31,7 +31,6 @@
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "rtl871x_byteorder.h"
-#include "farray.h"
 #include "usb_osintf.h"
 
 #define FWBUFF_ALIGN_SZ 512
@@ -40,11 +39,24 @@
 static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
 		    const u8 **ppmappedfw)
 {
-	u32 len;
+	int rc;
+	const char firmware_file[] = "rtl8712u/rtl8712u.bin";
+	const struct firmware **praw = (const struct firmware **)
+				       (pphfwfile_hdl);
+	struct dvobj_priv *pdvobjpriv = (struct dvobj_priv *)
+					(&padapter->dvobjpriv);
+	struct usb_device *pusbdev = pdvobjpriv->pusbdev;
 
-	*ppmappedfw = f_array;
-	len = sizeof(f_array);
-	return len;
+	printk(KERN_INFO "r8712u: Loading firmware from \"%s\"\n",
+	       firmware_file);
+	rc = request_firmware(praw, firmware_file, &pusbdev->dev);
+	if (rc < 0) {
+		printk(KERN_ERR "r8712u: Unable to load firmware\n");
+		printk(KERN_ERR "r8712u: Install latest linux-firmware\n");
+		return 0;
+	}
+	*ppmappedfw = (u8 *)((*praw)->data);
+	return (*praw)->size;
 }
 
 static void fill_fwpriv(struct _adapter *padapter, struct fw_priv *pfwpriv)
-- 
1.7.1


--------------040307030906090806060208--
