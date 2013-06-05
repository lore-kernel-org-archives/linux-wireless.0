Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out11.han.skanova.net ([195.67.226.200]:40762 "EHLO
	smtp-out11.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab3FELY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 07:24:26 -0400
Message-ID: <51AF1E67.8030407@emagii.com> (sfid-20130605_132429_207581_79F0ED29)
Date: Wed, 05 Jun 2013 13:17:59 +0200
From: Ulf Samuelsson <linux-wireless@emagii.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
Subject: Re: ath6kl_sdio blocked by RFKILL
References: <51A4C6D6.1020002@emagii.com> <8738t2nh6a.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8738t2nh6a.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-01 14:34, Kalle Valo wrote:
> Ulf Samuelsson <ntp@emagii.com> writes:
>
>> Have built the ath6kl_sdio driver for an Cortex-A5 chip using the
>> linux-3.6.9 kernel
>> File system built using Yocto  and Busybox RF-Kill.
>>
>> Kernel Config contains:
>>
>> CONFIG_RFKILL=m
>> CONFIG_RFKILL_LEDS=y
>> CONFIG_RFKILL_INPUT=y
>> # CONFIG_RFKILL_GPIO is not set
>>
>> When I do
>>
>> # ifconfig wlan0 up.
>>
>> I get the error message:
>>
>> ifconfig: SIOCSIFFLAGS: Operation not possible due to RF-kill
>>
>> If I run "rfkill list" I get
>>
>> 1: phy1: wlan
>>          Soft blocked: yes
>>          Hard blocked: no
>>
>>
>> If I try to unblock using "rfkill unblock all" or "wifi" or "wlan",
>> the soft block remains.
> Have you tried "rfkill unblock 1"?
>

Yes, I have now been able to reproduce on another board.

The System has an MMC connector, and if I boot with my SD51 SDIO card in 
the connector, then

"rfkill unblock <x>"

won't work, with x = {all,wifi,1 ...}

If I boot without the SD51 card beeing inserted, and then insert if 
after theboot has been completed,
then rfkill works as expected.

The MMC host driver is  built as a module, maybe it shouldn't.

BR
Ulf Samuelsson
