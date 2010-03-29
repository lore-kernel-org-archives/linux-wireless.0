Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:50822 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0C2UT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 16:19:56 -0400
Received: by fxm23 with SMTP id 23so1194924fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 13:19:54 -0700 (PDT)
Message-ID: <4BB10B62.9070408@googlemail.com>
Date: Mon, 29 Mar 2010 22:19:46 +0200
From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
References: <4BB0FD96.5020402@lwfinger.net> <4BB10110.9090202@googlemail.com> <20100329194745.GH4984@tuxdriver.com>
In-Reply-To: <20100329194745.GH4984@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/10 21:47, John W. Linville wrote:
> On Mon, Mar 29, 2010 at 09:35:44PM +0200, René Bolldorf wrote:
>> On 03/29/10 21:20, Larry Finger wrote:
>>> Ren�,
>>>
>>> When you have a wireless problem, please post it to
>>> linux-wireless@vger.kernel.org. The Linux Kernel Mailing List may or may not be
>>> appropriate.
>>>
>>> To help in diagnosing your problem, please apply this patch and post the output
>>> line that it produces. On my system, it shows
>>>
>>> ssb: chip_id 0x4312, status 0x10
>>>
>> and on my: ssb: chip_id 0x4312, status 0x12
>>> Please also post the output of 'lspci -nnv | grep 14e4'.
>> Yep:
>> 01:00.0 Network controller [0280]: Broadcom Corporation BCM4312
>> 802.11b/g [14e4:4315] (rev 01)
>
> OK, I'm new to the thread -- what exactly is the issue?  Was your
> device working previously?
>
> John

The problem is since commit fcb54b0bf7d3fe730c2b72e224bc616e358f24cb, my 
b43 (4312)
device doesn't work because i get the message "No SPROM available" and 
then the device get's disabled.

My colleague have the same problem. I have made a patch for that but it 
seems thats not work for all 4312 devices. I and my colleage have the 
same netbook for testing purposes so the patch work while we have the 
same chip status.

The problem is I think: Larry had written his output is ssb: chip_id 
0x4312, status 0x10, he have a different chip status.
What to do? Any ideas?

=============

diff --git a/include/linux/ssb/ssb_driver_chipcommon.h 
b/include/linux/ssb/ssb_driver_chipcommon.h
index 2cdf249..1e0b9cd 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -386,6 +386,7 @@


  /** Chip specific Chip-Status register contents. */
+#define SSB_CHIPCO_CHST_4312_SPROM_EXISTS	0x00000025
  #define SSB_CHIPCO_CHST_4322_SPROM_EXISTS	0x00000040 /* SPROM present */
  #define SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL	0x00000003
  #define SSB_CHIPCO_CHST_4325_DEFCIS_SEL		0 /* OTP is powered up, use 
def. CIS, no SPROM */
@@ -403,7 +404,7 @@
  /** Macros to determine SPROM presence based on Chip-Status register. */
  #define SSB_CHIPCO_CHST_4312_SPROM_PRESENT(status) \
  	((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
-		SSB_CHIPCO_CHST_4325_OTP_SEL)
+		SSB_CHIPCO_CHST_4312_SPROM_EXISTS)
  #define SSB_CHIPCO_CHST_4322_SPROM_PRESENT(status) \
  	(status & SSB_CHIPCO_CHST_4322_SPROM_EXISTS)
  #define SSB_CHIPCO_CHST_4325_SPROM_PRESENT(status) \
so my won't work then.
