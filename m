Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:35231 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbbCWJwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 05:52:43 -0400
Message-ID: <550FE268.10601@broadcom.com> (sfid-20150323_105423_074701_C319AF95)
Date: Mon, 23 Mar 2015 10:52:40 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO8cmdlbiBCYXVzYQ==?= <juergen.Bausa@online.de>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	 	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	 	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>	  <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>	  <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>	  <loom.20150317T214603-379@post.gmane.org>	 <1426634407.11120.50.camel@redhat.com>	 <loom.20150318T222315-999@post.gmane.org> <1426714179.26901.37.camel@redhat.com> <5509F0B5.7030601@broadcom.com> <loom.20150319T215852-35@post.gmane.org> <550B4241.4040101@broadcom.com> <loom.20150321T213803-13@post.gmane.org> <550EBF89.7030702@broadcom.com> <loom.20150322T210447-841@post.gmane.org>
In-Reply-To: <loom.20150322T210447-841@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/15 21:14, Jürgen Bausa wrote:
> Arend van Spriel<arend@...>  writes:
>
>>
>> On 03/21/15 21:38, Jürgen Bausa wrote:
>>> 1. the nvram file under /sys/firmware/efi/efivars/ has a wrong MAC address.
>>> I changed it to the correct one. However, I am not sure if this is really
>>> necassary.
>>
>> That MAC address is only used for device that do have mac address in the
>> device so you can ignore that one.
>
> You are right, found it out mayself in the meantime. There is no need to
> change the MAC address.
>
>>
>>> 2. Found the following on the web:
>>>
>>>> rmmod brcmfmac
>>>> rmmod brcmutil
>>>> echo on>   /sys/bus/platform/drivers/sdhci-acpi/INT33BB\:00/power/control
>>>> modprobe brcmfmac
>>>
>>> After this, I can connect to wlan!
>>
>> Ah, I was wondering what type of sdio host controller was used. When
>> sdio host controller uses runtime-pm it affect communication with wlan
>> device. I recently posted a patch for that [1].
>
> So, do I understand correctly, that with your patch the above workaround
> will no longer be needed? In which kernel will your patch be included? As
> wifi is working now, I would avoid installing the patch and instead wait for
> the next kernel.

Indeed. The patch basically does the same thing as the workaround. It is 
applied to wireless-drivers-next tree so it will be in 4.1 kernel. So it 
will take a while before that gets released by Linus. 4.1-rc1 will 
probably take approx. 6-7 wks.

>>
>>> Does this give you enough information to find out, what the problem is? Or
>>> do you still need DBG output from the driver? if so, just tell me and I will
>>> try to compile and install the kernel with DBG turnded on. Its not a big
>>> deal but I stopped working on it as I found this workaround.
>>>
>>> At the momment I am trying to put these commands to rc,local. With limited
>>> success until now, But this may be caused by the fact, that they are
>>> executed too early. Will add some sleep.
>>
>> Might be the driver is already loaded before root file system is loaded
>> (from initramfs).
>
> I now got it working. Just put 'sleeep 20' before the commands and now it
> works perfectly.

Holding the boot for 20s is steep, but I guess a working device trumps a 
fast boot ;-)

>>
>>> Another thing I found out is, that the system sometimes comes up without
>>> wlan0. It seems I have it only on every second boot. However, this could be
>>> just by incident and it is not exactly every second boot but about 50 % of
>>> all boots.
>>
>> Is that after reboot or really after powerup. Curious whether there is a
>> difference between the two regarding this issue.
>>
>
> It was after reboot and at cold boot.
>
> However, this problem seems to be gone. wlan0 is up on every boot. In the
> meantime i upgraded to rc4. Could this be the reason?

Nothing in brcmfmac is changed that would explain this. Maybe something 
was fixed in sdio host controller, but it is all speculation.

> Do you still need some dbg information from my machine? If so, just tell me
> and I will install a kernel with the needed options. Otherwise, I will stay
> with the current situation.

If you are happy and the issue seems resolved there is no need. Thanks.

>>> Ok, thanks. Will the driver also enable bluetooth? As I read, the
>>> bcm43341 also has Bluetooth capabilities.
>>
>> It has, but no clue what host interface is used. Anyway, it will have
>> a separate driver.
>
> Do you now, if there is some development going on for the bluetooth driver?
> Who could I conact?

I am not sure what host-interface is used to bt part. Is it usb or uart? 
I know there are plans to mainline the bt uart driver, but not sure when 
that will make its way into the kernel. If it is usb you should be able 
to use btusb driver, but you need firmware. They added support for 
handling firmware in btusb recently.

Regards,
Arend
