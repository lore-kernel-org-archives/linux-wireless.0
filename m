Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42345 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2EXDDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 23:03:30 -0400
Received: by yhmm54 with SMTP id m54so7337141yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 20:03:29 -0700 (PDT)
Message-ID: <4FBDA4FE.6040603@lwfinger.net> (sfid-20120524_050333_872200_23E57C12)
Date: Wed, 23 May 2012 22:03:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mourad De Clerck <bugs-wireless@aquazul.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails for b43 using linux 3.4?
References: <4FBD7772.6070305@aquazul.com>
In-Reply-To: <4FBD7772.6070305@aquazul.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2012 06:49 PM, Mourad De Clerck wrote:
> Hi,
>
> I'm probably missing something obvious, but when going from 3.3 to 3.4 the b43
> driver throws up an error, saying it can't find the firmware - but it really
> _is_ there.
>
>
> Here's the error:
>
> b43-phy0 ERROR: Firmware file "b43/ucode16_mimo.fw" not found
> b43-phy0 ERROR: Firmware file "b43-open/ucode16_mimo.fw" not found
> b43-phy0 ERROR: You must go to
> http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and download the
> correct firmware for this driver version. Please carefully read all instructions
> on this website.
>
>
> Here's the firmware it claims doesn't exist:
>
> $ sha1sum /lib/firmware/b43/ucode16_mimo.fw
> 825a4bc63e3a96bb20fd8551add947435d47ad46 /lib/firmware/b43/ucode16_mimo.fw
>
> This is from Debian's firmware-b43-installer package, version 1:015-14.
>
>
> The network card in question:
>
> 02:00.0 Network controller [0280]: Broadcom Corporation BCM4322 802.11a/b/g/n
> Wireless LAN Controller [14e4:432b] (rev 01)
>
>
> The only obvious change is 6b6fa5868eec26bdc6a83543cebb8cf832a2645a by Larry
> Finger. I don't know if it matters, but b43 is statically compiled in the kernel.

I was able to reproduce your result when b43 is built into the kernel, and it 
was not intentional. Recent modifications in udev make synchronous firmware 
loads fail when the firmware loading is initiated from the probe routine. The 
usual solution to switch to asynchronous firmware loading is a poor option for 
b43 as it loads multiple firmware files, and the number depends on the model. 
Accordingly, I selected a solution that initiates the firmware load from a work 
queue. The problem is that user space is not yet started when b43 asks for the 
firmware. Such a condition is not needed when b43 is a module as the user-space 
routines are started as they are needed to get the module from the disk. I see 2 
ways to resolve the problem.

It would be possible to switch to a delayed work queue. I have rejected this 
solution for the moment, as the delay would still be there even if the driver 
were a module.

The second solution is to make multiple tries of the read of the first firmware 
file. If the driver is a module, the first read will succeed, thus there is no 
penalty for that case. If the read fails, the code sleeps for 2000 ms, then 
retries the read. On my system, the 3rd try works, thus the loop count is set to 10.

Please try the patch below on your system. If it works, please report the number 
in the line from the dmesg output that states "********** loop count at exit 2".

Larry
===================================================================
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -2185,6 +2185,7 @@ static int b43_try_request_fw(struct b43
   	const char *filename;
   	u32 tmshigh;
   	int err;
+	int i;

   	/* Files for HT and LCN were found by trying one by one */

@@ -2223,9 +2224,18 @@ static int b43_try_request_fw(struct b43
   			goto err_no_ucode;
   		}
   	}
-	err = b43_do_request_fw(ctx, filename, &fw->ucode);
+	/* If b43 is builtin rather than as a module, user space will not
+	 * be able to supply firmware yet. Retry with a delay
+	 */
+	for (i = 0; i < 10; i++) {
+		err = b43_do_request_fw(ctx, filename, &fw->ucode);
+		if (!err)
+			break;
+		msleep(2000);
+	}
   	if (err)
   		goto err_load;
+	pr_info("********** loop count at exit %d\n", i);

   	/* Get PCM code */
   	if ((rev >= 5) && (rev <= 10))

