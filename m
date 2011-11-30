Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41111 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1K3GIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 01:08:07 -0500
Received: by eaak14 with SMTP id k14so191983eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 22:08:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED56E02.6040601@lwfinger.net>
References: <4ED3A6E8.4050000@aol.com>
	<CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com>
	<CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com>
	<4ED3B33E.8020309@lwfinger.net>
	<4ED3FA65.7010104@aol.com>
	<CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com>
	<4ED51DB5.5090202@aol.com>
	<4ED52FBD.5030302@lwfinger.net>
	<4ED5535E.50605@aol.com>
	<4ED56E02.6040601@lwfinger.net>
Date: Wed, 30 Nov 2011 07:08:05 +0100
Message-ID: <CACna6rxEW9Bc6vZRPR=t=zfnA3RJoWO4Rd6m7SuY2+6_uoxuLg@mail.gmail.com> (sfid-20111130_070812_155418_004207C8)
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: AndrewL733 <AndrewL733@aol.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/30 Larry Finger <Larry.Finger@lwfinger.net>:
> On 11/29/2011 03:49 PM, AndrewL733 wrote:
>>
>> On 11/29/2011 02:17 PM, Larry Finger wrote:
>>>
>>> That path is derived from the current kernel version. It should get it
>>> right.
>>>
>>> You should already have the directory /lib/modules/3.1.2-1.1-desktop. The
>>> command 'mv /lib/modules/3.1.2-1-desktop/updates to
>>> /lib/modules/3.1.2-1.1-desktop/.' followed by 'depmod -a' should be OK.
>>>
>>> Larry
>>
>> I found that at least with Mandriva, simply putting the new b43 modules in
>> /lib/modules/{my kernel}/updates and then running depmod (or depmod -a)
>> did not
>> work.  After doing that, when I ran "modinfo b43", the result was still
>> pointing
>> to the in-kernel b43 modules and not the one in "updates".  However,
>> renaming
>> the "updates" directory to "extra" and then running "depmod" again DID
>> work.
>> So, putting out-of-kernel modules in a directory named "updates" did not
>> work!
>>
>> I have never seen out-of-kernel modules in "updates".  I compile many
>> out-of-kernel modules (Myricom, ATTO, 3ware, LSI, Intel) and their
>> installers
>> always, always, put the new modules in the "extra" directory and never in
>> an
>> "updates" directory.
>>
>> Why does compat-wireless install these in the "updates" directory?
>
> Because that works with MOST distros.
>
>>>
>>> But now, to do things the "Mandriva way", I am supposed to launch the
>>> "Mandriva Control Center"  (drakconf), go to the "Manage you network
>>> devices"
>>> section and "add" the wlan0 interface to my system. (The idea is to then
>>> allow
>>> Network Manager to manage the connection moving forward, but first you
>>> have to
>>> enable the connection.) When I try to add wlan0 to my network
>>> configuration, I
>>> get a dialog box asking me which firmware file to use?  Basically, it
>>> wants me
>>> to navigate to /lib/firmware/b43/ and select one of the "ucode" files.
>>>  With
>>> the previous Macbook Pro 8,2, I think I selected ucode13.fw and it worked
>>> fine.  But what is the correct way to select the proper firmware without
>>> guessing?
>>>
>>> When I was trying to load the "distro b43" driver, dmesg was telling me
>>> the
>>> driver needed "FW13".  Does that mean anything?
>
> No.
>
>> Okay, I got impatient and decided to just tell the Mandriva network device
>> manager to associate /lib/firmware/b43/ucode13.fw with my wlan0.  But how
>> do I
>> know if that's really the correct firmware for the Broadcom 4331 (rev 02)
>> chipset?  I'm finding that the wireless connection goes down once in a
>> while.
>> So far, I have only tried with one access point and maybe the access point
>> itself is flaky, but it would be nice how to know which firmware to use.
>> Is the
>> choice supposed to happen automagically when the b43 driver is loaded?  Is
>> there
>> some table somewhere that says which ucodeXX.fw goes with which chipset?
>
> The table is found at http://bcm-v4.sipsolutions.net/802.11/Init/Firmware.
> For my distro and most others, it is done automagically. The kernel reads
> the version of the 802.11 core and looks up the firmware using logic derived
> from this table. In the dmesg output, you will find a place where the
> versions of the various cores is printed. Using ucode13.fw is certainly not
> right for a 4331. I'm surprised that it works at all.

I'm quite sure it's some Mandriva... well - dumb... configuration that
doesn't affect driver at all.

b43 uses ucode29_mimo for BCM4331

-- 
Rafał
