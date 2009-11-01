Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43153 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753373AbZKAUYW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 15:24:22 -0500
Message-ID: <4AEDEE7C.4010406@gmx.net>
Date: Sun, 01 Nov 2009 21:24:28 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
CC: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <20091101183553.GB24436@one-eyed-alien.net>
In-Reply-To: <20091101183553.GB24436@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Dharm schrieb:
> On Sun, Nov 01, 2009 at 07:29:20PM +0100, Josua Dietze wrote:
>   
>> Frank Schaefer schrieb:
>>
>>     
>>> I really think the mode-switching should be done in the kernel and not
>>> in user-space for reasons of usability.
>>>       
>> What is wrong with an udev rule entry? By the way, did the "eject" 
>> command line tool work as well?
>>     
>
> And I think it should be done in userspace for issues of maintainability
> and useability.  It is much easier for users to upgrade their udev then
> their kernel.
>   
Maintainability for whom ? The kernel-devs or the distro-people and the
users ? ;)

Please think about the users. They don't know that they have to create
udev-rules or have to install additional packages like usb_modeswitch
(which is nevertheless a great tool !).
And even if they know, they don't want to do that. So it's up to the
distros to do this automatically, which will in reality never come true
for all devices and distros.

Do you know the microdia-webcam-driver which recently got into the
kernel as sn9c20x-gspcav-sub-driver ?
It's a great and functional driver which supports lots of webcams, but
in fact its useless for most users (at least the ones who don't know
LD_PRELOAD-hack)...

Please don't understand me wrong: I agree that we should keep the kernel
slim and do as much as possible in userspace and I can see the benefits
of the userspace-approach.
But we have to make compromises and I think a kernel-space-apporach
would be the best compromise in this case. Just my two cents.

>>> Another benfit is that it binds the mode-switching to the driver. If the
>>> driver is blacklisted/not used, there will be no mode-switching.
>>>       
>> But how would you access the storage part of the device then?
>>     
>
> And doing the switch in userspace would solve this problem also.
>
> Finally, if we do this in userspace, device vendors might actually get a
> clue and start providing a small linux app or script to do the mode switch
> on their virtual storage device, just like they do for windows.
>
> Matt
>   
As I said in reply to Josua, this depends on device-type. For
windows-driver-storage-devices we don't need such a tool.

Frank
