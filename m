Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:53713 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751438AbaGLTiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 15:38:08 -0400
Message-ID: <53C18E9C.8040309@dpets.co.uk> (sfid-20140712_213813_372560_B077482E)
Date: Sat, 12 Jul 2014 20:38:04 +0100
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192se static driver in 3.14 kernel not working
References: <53BE5E49.6040603@dpets.co.uk> <53BEAA6E.8000304@lwfinger.net> <53BEADA2.6040403@dpets.co.uk> <53BEC127.7020609@lwfinger.net> <53BFA9A1.2020503@dpets.co.uk> <53C0056A.9000003@lwfinger.net>
In-Reply-To: <53C0056A.9000003@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/14 16:40, Larry Finger wrote:
> On 07/11/2014 04:08 AM, John Talbut wrote:
>> On 10/07/14 17:36, Larry Finger wrote:
>>> On 07/10/2014 10:13 AM, John Talbut wrote:
>>>> On 10/07/14 15:59, Larry Finger wrote:
>>>>> On 07/10/2014 04:35 AM, John Talbut wrote:
>>>>>> It seems that we have a different problem with this driver from
>>>>>> others I
>>>>>> mentioned in a recent thread.
>>>>>>
>>>>>> I have compiled a kernel from the 3.14.7 from linux-source-3.14 from
>>>>>> Debian for
>>>>>> use on a Samsung N120 netbook.
>>>>>>
>>>>>> Included in the .config are:
>>>>>>
>>>>>> CONFIG_WLAN=y
>>>>>> CONFIG_RTL_CARDS=y
>>>>>> CONFIG_RTL8192SE=y
>>>>>>
>>>>>> There are no LKMs or initramfs.
>>>>>>
>>>>>> The wireless does not work at all.  dmesg shows the pci device but
>>>>>> there is no
>>>>>> sign of the wireless driver.
>>>>>>
>>>>>> With a 2.6 kernel set up similarly the wireless works.
>>>>>
>>>>> Please post the entire .config.
>>>>>
>>>>> Larry
>>>>>
>>>> Attached
>>>
>>> I was a little surprised to see
>>>
>>> # CONFIG_IWLWIFI is not set
>>>
>>> I thought that was essential, but it seems not.
>>>
>>> I had to make some changes in your config for my 64-bit hardware with
>>> EFI, and completly different disk interface hardware. I still have not
>>> gotten that configuration to boot, but it gets far enough to log that
>>> the firmware was not found. The failure could be due to my incomplete
>>> configuration for my hardware, but I'm not sure.
>>>
>>> Does your dmesg log show anything about firmware. It will be early in
>>> the boot. Mine was at the 2 second mark.
>>>
>>> How does the wireless work with a 2.6 kernel? My records show that
>>> rtl8192se was added to kernel 3.0.
>>>
>>> Larry
>>>
>> Hi Larry
>>
>> Thanks for looking into this.  It was a staging driver in the 2.6
>> kernel.  I am
>> attaching a dmesg for a boot with this kernel.  The wireless is at
>> around 1.3
>> seconds.
>>
>> As far as I can recall there was no mention of wireless or firmware
>> with the
>> 3.14 kernel.  The computer belongs to a friend in Didcot,  I am now
>> back home in
>> Coalville.  I have asked her to send me a copy of a dmesg file when
>> she can, but
>> it will not be until later today.
>
> I think I understand now, based on what you said above, and the
> following in the dmesg output:
>
> [    1.289464] Linux kernel driver for 8192 based WLAN cards
> [    1.289468] Copyright (c) 2007-2008, Realsil Wlan
> [    1.289533] rtl819xE 0000:02:00.0: PCI INT A -> GSI 16 (level, low)
> -> IRQ 16
> [    1.289544] rtl819xE 0000:02:00.0: setting latency timer to 64
>
> Unfortunately, Realtek produced two cards (RTL8192E and RTL8192SE) that
> have PCI ID 0x10ec, 0x8192, but use totally different drivers. The one
> that produces the above output is r8192e_pci, and still is in staging.
> The other named rtl8192se is in the regular wireless tree and was not
> added to the kernel until 3.0.
>
> Many distro kernels enable both as modules. When the PCI bus is scanned,
> both drivers are loaded, and the code in the initialization section uses
> secondary info to accept or reject the hardware. For your friend's
> hardware, you will need to remove rtl8192se from your config, and add
> the driver in staging.
>
Thank you for clarifying this.  It would have saved me a lot of time and 
from bothering you if this information had been more widely available 
(not your fault, I am sure).  To this end I have added some information 
to the Debian Wiki at https://wiki.debian.org/rtl819x.  Maybe you could 
check this.

I note that the Subsystem for the N120, presumably RTL8192E card, is 
Askey Computer Corp. Device 7160.  Would this be a way of identifying 
the card?

The 2.6.32 kernel in use on the N120 is compiled statically.  The 
rtl8192e driver works most of the time, we were hoping to get an 
improvement with an in tree driver.  I see that between the 2.6.32 and 
the 2.6.39 kernels a patch was included 
(https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/staging/rtl8192e/Kconfig?id=84ba253b07a3d8e58160690320e9cfbe199bb88e) 
that meant that this driver can now only be build as a loadable module. 
  This seems to be a workaround and I am wondering whether to report as 
a bug that this cannot be compiled statically - at least so as to record 
the situation.

Is it likely that an in tree driver will be provided for the RTL8192E 
device?  I don't know if I have got this wrong, but I had the impression 
that staging drivers were supposed to be used when there was an active 
intention to produce an in tree driver.

Anyway, thanks again.

John
