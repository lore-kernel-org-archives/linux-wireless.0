Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34993 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab0KNUYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 15:24:00 -0500
Received: by gyh4 with SMTP id 4so2669093gyh.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 12:24:00 -0800 (PST)
Message-ID: <4CE0455A.50709@lwfinger.net>
Date: Sun, 14 Nov 2010 14:23:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James Womack <james.c.womack@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8187se panic
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org> <4CDEEEE4.80801@lwfinger.net> <ibokag$481$1@dough.gmane.org> <4CE00BEE.8060100@lwfinger.net> <ibpauk$v12$1@dough.gmane.org>
In-Reply-To: <ibpauk$v12$1@dough.gmane.org>
Content-Type: multipart/mixed;
 boundary="------------080308010200060304050706"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080308010200060304050706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/14/2010 12:49 PM, James Womack wrote:
> Hey, I tried patching the kernel I downloaded, but the dry runs both
> presented errors detailed below:
> 
> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run <
> /home/james/rtl8187se_change_panic_to_warn
> patching file drivers/staging/rtl8187se/r8185b_init.c
> Hunk #1 succeeded at 356 with fuzz 2 (offset 92 lines).
> Hunk #2 FAILED at 302.
> 1 out of 2 hunks FAILED -- saving rejects to file
> drivers/staging/rtl8187se/r8185b_init.c.rej
> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run <
> /home/james/rtl8187se_
> rtl8187se_change_panic_to_warn  rtl8187se_lock_pci_remove
> james@mercury:/usr/src/linux-source-2.6.32$ patch -p1 --dry-run <
> /home/james/rtl8187se_lock_pci_remove
> patching file drivers/staging/rtl8187se/r8180_core.c
> patch unexpectedly ends in middle of line
> patch: **** unexpected end of file in patch
> james@mercury:/usr/src/linux-source-2.6.32$
> 
> Do I need to do anything to the kernel source before applying the patches?

You needed a different version of the patch for 2.6.32. Apply the attached
version. You only need the one patch.

Larry

--------------080308010200060304050706
Content-Type: text/plain;
 name="rtl8187se_change_panic_to_warn"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8187se_change_panic_to_warn"

This driver issues a kernel panic over conditions that do not
justify such drastic action. Change these to log entries with
a stack dump.

This patch fixes the system crash reported in
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/674285.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-Tested-by: Robie Basik <rb-oss-3@justgohome.co.uk>
Cc: Stable <stable@kernel.org>
---

Greg,

As this fix keeps the kernel from panicking over a trivial condition,
it should be pushed as soon as possible.

Larry
---

Index: linux-2.6/drivers/staging/rtl8187se/r8185b_init.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8185b_init.c
+++ linux-2.6/drivers/staging/rtl8187se/r8185b_init.c
@@ -356,8 +356,12 @@ HwHSSIThreeWire(
 			}
 			udelay(10);
 		}
-		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT)
-			panic("HwThreeWire(): CmdReg: %#X RE|WE bits are not clear!!\n", u1bTmp);
+		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT) {
+			printk(KERN_ERR "rtl8187se: HwThreeWire(): CmdReg:"
+			       " %#X RE|WE bits are not clear!!\n", u1bTmp);
+			dump_stack();
+			return 0;
+		}
 
 		// RTL8187S HSSI Read/Write Function
 		u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
@@ -397,13 +401,23 @@ HwHSSIThreeWire(
 				int idx;
 				int ByteCnt = nDataBufBitCnt / 8;
                                 //printk("%d\n",nDataBufBitCnt);
-				if ((nDataBufBitCnt % 8) != 0)
-				panic("HwThreeWire(): nDataBufBitCnt(%d) should be multiple of 8!!!\n",
-				nDataBufBitCnt);
-
-			       if (nDataBufBitCnt > 64)
-				panic("HwThreeWire(): nDataBufBitCnt(%d) should <= 64!!!\n",
-				nDataBufBitCnt);
+				if ((nDataBufBitCnt % 8) != 0) {
+					printk(KERN_ERR "rtl8187se: "
+					       "HwThreeWire(): nDataBufBitCnt(%d)"
+					       " should be multiple of 8!!!\n",
+					       nDataBufBitCnt);
+					dump_stack();
+					nDataBufBitCnt += 8;
+					nDataBufBitCnt &= ~7;
+				}
+
+			       if (nDataBufBitCnt > 64) {
+					printk(KERN_ERR "rtl8187se: HwThreeWire():"
+					       " nDataBufBitCnt(%d) should <= 64!!!\n",
+					       nDataBufBitCnt);
+					dump_stack();
+					nDataBufBitCnt = 64;
+				}
 
 				for(idx = 0; idx < ByteCnt; idx++)
 				{

--------------080308010200060304050706--
