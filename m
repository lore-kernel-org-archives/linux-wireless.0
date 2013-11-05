Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1203 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab3KEIxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 03:53:13 -0500
Message-ID: <5278B1EC.8020000@broadcom.com> (sfid-20131105_095317_947875_69F4FBD2)
Date: Tue, 5 Nov 2013 09:53:00 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Alexander Varnin" <fenixk19@mail.ru>,
	"Bing Zhao" <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: mwifiex_sdio on chromebook
References: <5276491F.20207@mail.ru>
 <477F20668A386D41ADCC57781B1F70430F45757E63@SC-VEXCH1.marvell.com>
 <527703E6.8040504@mail.ru>
 <477F20668A386D41ADCC57781B1F70430F45758053@SC-VEXCH1.marvell.com>
 <5278AE8E.9060203@mail.ru>
In-Reply-To: <5278AE8E.9060203@mail.ru>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2013 09:38 AM, Alexander Varnin wrote:
> 04.11.2013 23:46, Bing Zhao пишет:
>> Hi Alexander,
>>
>>>> Your Chromebook supports SDIO high speed mode (SDIO 2.0 spec). So
>>>> 50MHz is correct.
>>> Ok, but mainline kernel doesn't try this frequency. It tries 400kHz at
>>> most.
>>>
>>>> What are you trying to do here? Are you trying to run a mainline kernel on your Chromebook?
>>> Yes. I've got kernel 3.4 from Google Chrome OS. It works ok for
>>> mwifiex_sdio. But I want to run mainline kernel. As of 3.11 it is able
>>> to boot on Chromebook, but WiFi doesn't work.
>> I don't know why you want to do that, but the mainline kernel won't work on your Chromebook unless you port all platform specific changes over from chromeos-3.4 tree.
>>
>>>> You said mmc_attach_sdio function fails. The mwifiex_sdio driver and
>>>> the firmware will not be loaded at all.
>>> Ok, that is clear.
>>>
>>>> CONFIG_MMC_DEBUG=y, and collect the debug logs.
>>> This way seems not very useful, because there is also internal and
>>> external storage on mmc bus, so log quickly get garbaged with it. Dmesg
>>> seems to be overflowed and forgets early initialization. I have made a
>>> dirty hack to collect some useful info about initialization. I am
>>> attaching it. Please check, if I need to add something. Will it be
>>> useful this way?
>> As said above, this won’t work because the Chromebook specific changes aren't present in mainline kernel. Anyway you can take a look at the chromium OS developer guide.
>>
>> http://www.chromium.org/chromium-os/developer-guide
>>
>> Thanks,
>> Bing
>>
>
> It is ported at most already and mainline kernel works good on
> Chromebook. It is just peripheral problem.

Not sure how chromium os architecture looks like, but you mean to say 
*you* ported code in chromium user-space to work with upstream/mainline 
kernel API's?

Regards,
Arend

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


