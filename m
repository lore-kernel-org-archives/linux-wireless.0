Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:20417 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbCVNLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 09:11:39 -0400
Message-ID: <550EBF89.7030702@broadcom.com> (sfid-20150322_141142_951101_847E4510)
Date: Sun, 22 Mar 2015 14:11:37 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=FCrgen_Bausa?= <juergen.Bausa@online.de>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	 	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	 	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>	  <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>	  <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>	  <loom.20150317T214603-379@post.gmane.org>	 <1426634407.11120.50.camel@redhat.com>	 <loom.20150318T222315-999@post.gmane.org> <1426714179.26901.37.camel@redhat.com> <5509F0B5.7030601@broadcom.com> <loom.20150319T215852-35@post.gmane.org> <550B4241.4040101@broadcom.com> <loom.20150321T213803-13@post.gmane.org>
In-Reply-To: <loom.20150321T213803-13@post.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/15 21:38, Jürgen Bausa wrote:
> Arend van Spriel<arend@...>  writes:
>
>>
>>
>> CONFIG_BRCM_TRACING is another way to get debug output, but I guess that
>> is not enabled either.
>>
>
> Just found this via google to enable wlan:
>
> 1. the nvram file under /sys/firmware/efi/efivars/ has a wrong MAC address.
> I changed it to the correct one. However, I am not sure if this is really
> necassary.

That MAC address is only used for device that do have mac address in the 
device so you can ignore that one.

> 2. Found the following on the web:
>
>> rmmod brcmfmac
>> rmmod brcmutil
>> echo on>  /sys/bus/platform/drivers/sdhci-acpi/INT33BB\:00/power/control
>> modprobe brcmfmac
>
> After this, I can connect to wlan!

Ah, I was wondering what type of sdio host controller was used. When 
sdio host controller uses runtime-pm it affect communication with wlan 
device. I recently posted a patch for that [1].

> Does this give you enough information to find out, what the problem is? Or
> do you still need DBG output from the driver? if so, just tell me and I will
> try to compile and install the kernel with DBG turnded on. Its not a big
> deal but I stopped working on it as I found this workaround.
>
> At the momment I am trying to put these commands to rc,local. With limited
> success until now, But this may be caused by the fact, that they are
> executed too early. Will add some sleep.

Might be the driver is already loaded before root file system is loaded 
(from initramfs).

> Another thing I found out is, that the system sometimes comes up without
> wlan0. It seems I have it only on every second boot. However, this could be
> just by incident and it is not exactly every second boot but about 50 % of
> all boots.

Is that after reboot or really after powerup. Curious whether there is a 
difference between the two regarding this issue.

Regards,
Arend

[1] https://patchwork.kernel.org/patch/6038511/

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

