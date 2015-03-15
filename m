Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:5123 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbCOVPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 17:15:01 -0400
Message-ID: <5505F651.3060607@broadcom.com> (sfid-20150315_221511_088462_96D4D362)
Date: Sun, 15 Mar 2015 22:14:57 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=FCrgen_Bausa?= <juergen.Bausa@online.de>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir> <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com> <loom.20150315T213441-211@post.gmane.org>
In-Reply-To: <loom.20150315T213441-211@post.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/15 21:38, Jürgen Bausa wrote:
> Arend van Spriel<arend@...>  writes:
>
>>
>> On 03/14/15 23:13, Ochal Christophe wrote:
>>> All,
>>>
>>> On 03/14/2015 09:39 PM, Stefan Lippers-Hollmann wrote:
>>>> You don't need to run windows for that, the nvram (calibration data,
>>>> probably the MAC address and related device specific data) is stored
>>>> in your mainboard's firmware - and exposed to userspace (under linux)
>>>> via /sys/firmware/efi/efivars/. You just need to identify the correct
>>>> file and copy it to a place where linux expects to find it
>>>> (/lib/firmware/brcm/brcmfmac43340-sdio.txt). Regards Stefan
>>>> Lippers-Hollmann
>>>
>>> Thanks for the hint, that did it, I'm online!
>>
>> Apparently my hint was not clear enough. Good to hear it works for you.
>>
>
> Dear Arend,
>
> would be nice, if you could make it clear.
>
> I am in the exact some position (asus x205 with linux 4.0 rc3) but my
> /sys/firmware/efi/efivars/ is empty. I am running debian jessie with a
> kernel taken from ubuntu. Am I missing something? Even loading efivars via
> modprobe doesnt change a thing.

Maybe you need to mount it. This is what I found [1]:

$ sudo mount -t efivarfs none /sys/firmware/efi/efivars

Regards,
Arend

[1] http://firmware.intel.com/blog/accessing-uefi-variables-linux

> Juergen
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

