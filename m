Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3178 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab0AIBT2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 20:19:28 -0500
Message-ID: <4B47D98F.1000703@canonical.com>
Date: Fri, 08 Jan 2010 19:19:11 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Martin Pitt <martin.pitt@ubuntu.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	stefano.brivio@polimi.it, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Declare all possible firmware files.
References: <20100107183517.A322FF88D8@sepang.rtg.net> <4B463953.1030806@canonical.com> <20100108173248.GB2546@piware.de> <201001082006.02121.mb@bu3sch.de>
In-Reply-To: <201001082006.02121.mb@bu3sch.de>
Content-Type: multipart/mixed;
 boundary="------------090206060000030507030102"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090206060000030507030102
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael Buesch wrote:
> On Friday 08 January 2010 18:32:48 Martin Pitt wrote:
>> Tim Gardner [2010-01-07 12:43 -0700]:
>>> AFAIK Jockey only needs to be able to tell if _any_ of the firmware
>>> files have been installed and could therefore make an install decision
>>> based on just one firmware file name.
>> Correct.
>>
>>> Martin - if thats the case, then we need only list one firmware file in
>>> the modinfo, correct?
>> Right. If that's not practical to fix on the kernel side for some
>> reason, we could also put in a quirk into the Broadcom handler in
>> update-notifier. (Right now it just listens for FIRMWARE subsystem
>> uevents and checksc if the value of it exists as a file).
>>
>> This was originally introduced for the DVB-T driver firmware packages,
>> but if we could make it work for b43 as well, this would be nice.
> 
> I think it would be OK to list all the ucodeX.fw files, but listing all
> these initvals files seems overkill to me.
> If you still need all initval filenames, you could theoretically ask b43-fwcutter.
> That would just need a new fwcutter commandline option, as far as I can see.
> 
> As you can see, we currently only export the b43 specific firmware ID in MODULE_FIRMWARE().
> That is a unique identifier for a whole set of firmware files. b43-fwcutter also
> knows about that firmware ID.
> 
> (While we're at it, I think the FW-id that b43 announces should be updated. Because
> I think the firmware with the currently announced ID does not support all LP devices.)
> 

How about the attached version that only includes the ucode files ?

rtg

-- 
Tim Gardner tim.gardner@canonical.com

--------------090206060000030507030102
Content-Type: text/x-patch;
 name="0001-b43-Declare-at-least-one-real-firmware-file-using-MO.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename*0="0001-b43-Declare-at-least-one-real-firmware-file-using-MO.pa";
 filename*1="tch"

>From dc32dddb47b8b8e2f62c77ab64a681c1f150bf7e Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 7 Jan 2010 11:10:38 -0700
Subject: [PATCH] b43: Declare at least one real firmware file using MODULE_FIRMWARE.

BugLink: http://bugs.launchpad.net/bugs/488636

Enhances module information with the names of the firmware files
that could be used by this driver. This helps tools like Jockey to
correctly detect and/or install the firmware files relevant to
this driver.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/wireless/b43/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 4c41cfe..5745075 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -67,7 +67,12 @@ MODULE_AUTHOR("Gábor Stefanik");
 MODULE_LICENSE("GPL");
 
 MODULE_FIRMWARE(B43_SUPPORTED_FIRMWARE_ID);
-
+MODULE_FIRMWARE("b43/ucode11.fw");
+MODULE_FIRMWARE("b43/ucode13.fw");
+MODULE_FIRMWARE("b43/ucode14.fw");
+MODULE_FIRMWARE("b43/ucode15.fw");
+MODULE_FIRMWARE("b43/ucode5.fw");
+MODULE_FIRMWARE("b43/ucode9.fw");
 
 static int modparam_bad_frames_preempt;
 module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, int, 0444);
-- 
1.6.3.3


--------------090206060000030507030102--
