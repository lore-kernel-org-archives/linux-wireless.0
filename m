Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33823 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbbEFJEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 05:04:01 -0400
Received: by pacyx8 with SMTP id yx8so3778355pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2015 02:04:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEcPm-bkgCh6Wkzr716RpRqd8Pc81754oCvSKXtWWAqOEA@mail.gmail.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
 <1419834253-18331-6-git-send-email-eliad@wizery.com> <5512A9BC.5010902@pengutronix.de>
 <CAB3XZEfw5EurqA2jZypAj4LkQwwAiVeKd5wKKsxpOAh-RrCq0w@mail.gmail.com>
 <5512B6F2.8090407@pengutronix.de> <CAB3XZEdyq6FJUTwXm40EUYemmLvuHfZ8JsUvHyCvS3twFhw=Dw@mail.gmail.com>
 <CAGm1_kvrBShO4CNefJfyrRc9FRr4hvV2QL=QZvoS=_9JFV8jMA@mail.gmail.com> <CAB3XZEcPm-bkgCh6Wkzr716RpRqd8Pc81754oCvSKXtWWAqOEA@mail.gmail.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Wed, 6 May 2015 11:03:40 +0200
Message-ID: <CAGm1_kswkuWtY5eWdH90g3p6N3GbubWr55KY2qR6Q+KskCzU3Q@mail.gmail.com> (sfid-20150506_110409_632952_35111687)
Subject: Re: [PATCH 06/13] wlcore: enable sleep during AP mode operation
To: Eliad Peller <eliad@wizery.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kobi Leibovitch <kobi.lev100@gmail.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	"Machani, Yaniv" <yanivma@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 6, 2015 at 10:32 AM, Eliad Peller <eliad@wizery.com> wrote:
> hi Yegor,
>
> On Mon, May 4, 2015 at 12:16 PM, Yegor Yefremov
> <yegorslists@googlemail.com> wrote:
>> On Wed, Mar 25, 2015 at 2:45 PM, Eliad Peller <eliad@wizery.com> wrote:
>>> On Wed, Mar 25, 2015 at 3:24 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>>>> On 03/25/2015 01:58 PM, Eliad Peller wrote:
>>>>> hi Marc,
>>>>>
>>>>> On Wed, Mar 25, 2015 at 2:27 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>>>>>> On 12/29/2014 07:24 AM, Eliad Peller wrote:
>>>>>>> From: Kobi L <kobi.lev100@gmail.com>
>>>>>>>
>>>>>>> Enable ELP authorization in AP mode and enable the use
>>>>>>> of the wakeup bit in the ELP register.
>>>>>>>
>>>>>>> Introduce AP role sleep configuration which is disabled
>>>>>>> by default. When configured, it allows the AP to sleep
>>>>>>> when ELP is authorized for it.
>>>>>>>
>>>>>>> Signed-off-by: Kobi Leibovitch <kobi.lev100@gmail.com>
>>>>>>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>>>>>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>
>>>>>> This patch requires a new firmware, loading of "wl18xx-conf.bin" from
>>>>>> [1] fails with:
>>>>>>
>>>>>>> wlcore: ERROR configuration binary file size is wrong, expected 1226 got 1221
>>>>>>
>>>>> thanks. seems you're right.
>>>>>
>>>>> anyway, note that this file is not actual fw, but only the default
>>>>> configuration params.
>>>>> you can just delete it, and the driver will load just fine.
>>>>> you can then recreate it with something like:
>>>>> cat /sys/kernel/debug/ieee80211/phy0/wlcore/wl18xx/conf >
>>>>> /lib/firmware/ti-connectivity/wl18xx-conf.bin
>>>>>
>>>>> actually, i don't think it makes much sense to have this file in the
>>>>> linux-firmware git at all.
>>>>> i'll try handling it.
>>>>
>>>> Thanks, there are more file with size of ~1k, are they optional, too?
>>>> What's the "error" message if these optional files are not present?
>>>>
>>> AFAIK, the other nvs files are basically required for proper operation.
>>>
>>>> From working with $CUSTOMERS I gained the impression, messages like
>>>> "error failed to load...." for optional file don't shine the best light
>>>> on Linux, a neutral "using default values" is far better.
>>> i agree :)
>>
>> Added Yaniv Machani in CC.
>>
>> Any update on the wl18xx-conf.bin issue? This file is still in
>> linux-firmware repo.
>>
> thanks for the reminder :)
>
> just sent a patch to fallback to default conf in case of invalid/outdated conf.

Great.

@Yaniv: but how to create a new conf with 1226 bytes for existing ini file?

Yegor
