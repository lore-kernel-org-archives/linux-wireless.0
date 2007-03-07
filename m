Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:45367 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965719AbXCGW4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 17:56:17 -0500
Message-ID: <45EF4305.5060606@lwfinger.net>
Date: Wed, 07 Mar 2007 16:56:05 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: Problem with USB1.1 Host cores with the mb tree for bcm43xx_mac80211
References: <45EF2015.8000802@lwfinger.net> <200703072328.06195.mb@bu3sch.de>
In-Reply-To: <200703072328.06195.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 07 March 2007 21:27, Larry Finger wrote:
>> If you have a BCM4311 and are seeing an oops that looks like this when loading bcm43xx_mac80211:
>>
>> ssb: Switching to ChipCommon core, index 0
>> ssb: Switching to PCI-E core, index 3
>> ssb: Switching to USB 1.1 Host core, index 2
>>
>> Unable to handle kernel NULL pointer dereference at 00000000000002d0 RIP:
>>  [<ffffffff8812fcfd>] :usbcore:usb_create_hcd+0x3b/0xe8
>> PGD 3e792067 PUD 3ed66067 PMD 0
>> Oops: 0002 [1] SMP
>> ...
>>
>> there is a temporary, unofficial patch at
>> ftp://lwfinger.dynalias.org/patches/mac80211_usb_problem.patch. Although it works, it attacks the
>> symptom, not the cause, and will never be adopted into the code. Once a proper fix is applied, it
>> will no longer be needed.
> 
> A patch to disable the USB core on non-embedded devices is in my tree now.
> The actual bug is still there, but nobody (except OpenWRT developers ;) )
> should be able to hit it anymore now. :)

Your patch works here. Thanks,

Larry

