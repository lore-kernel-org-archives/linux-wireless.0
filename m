Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15015 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbcAMC16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 21:27:58 -0500
Message-ID: <5695B72D.4060609@atmel.com> (sfid-20160113_032802_264413_DFB473B5)
Date: Wed, 13 Jan 2016 11:32:13 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tony Cho <tony.cho@atmel.com>, <leo.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: Re: [PATCH 09/26] staging: wilc1000: use unified firmware
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com> <1452584395-24910-10-git-send-email-glen.lee@atmel.com> <CAGRGNgXMezjrT3Uec_MMQ0goCHyPjhDF4OjD=kJ-ukeCiTARGg@mail.gmail.com>
In-Reply-To: <CAGRGNgXMezjrT3Uec_MMQ0goCHyPjhDF4OjD=kJ-ukeCiTARGg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2016년 01월 13일 08:18, Julian Calaby wrote:
> Hi Glen,
>
> On Tue, Jan 12, 2016 at 6:39 PM, Glen Lee <glen.lee@atmel.com> wrote:
>> Use a unified firmware for all mode of operations which are station, ap and
>> p2p. Two firmware are introduced for 1002 and 1003 chipset.
>>
>> Signed-off-by: Glen Lee <glen.lee@atmel.com>
>> ---
>>   drivers/staging/wilc1000/Makefile     |  5 ++---
>>   drivers/staging/wilc1000/linux_wlan.c | 18 +++++++++---------
>>   2 files changed, 11 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
>> index 20a5cb9..90c3760 100644
>> --- a/drivers/staging/wilc1000/Makefile
>> +++ b/drivers/staging/wilc1000/Makefile
>> @@ -1,8 +1,7 @@
>>   obj-$(CONFIG_WILC1000) += wilc1000.o
>>
>> -ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
>> -               -DAP_FIRMWARE=\"atmel/wilc1000_ap_fw.bin\" \
>> -               -DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
>> +ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
>> +               -DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
> You can probably put these defines in a header somewhere instead of here.

Hi Julian,

It's better to define in header as you say. I'll do this later.

>
> Also, are these firmwares publicly available and have they been
> submitted to linux-firmware?

Not yet. We will patch new firmware as soon as possible.

Thanks,

Glen lee.

>
> Thanks,
>

