Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53188 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaATLUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 06:20:08 -0500
Received: by mail-ob0-f180.google.com with SMTP id wp4so1905119obc.39
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 03:20:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DC1761.9080608@openwrt.org>
References: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com>
	<20140117100613.GD1425@redhat.com>
	<A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com>
	<1390133995.6945.11.camel@X1Carbon.localdomain>
	<03574886-F38F-461C-97FC-B10DCCCF30E8@gmail.com>
	<52DC1761.9080608@openwrt.org>
Date: Mon, 20 Jan 2014 12:20:05 +0100
Message-ID: <CABikg9zdW7GjaaghfW3fLcPKEiF0-3P5Ht2DY9hx6r0-XcguRw@mail.gmail.com> (sfid-20140120_122011_608835_F097FE53)
Subject: Re: USB rt2x00 driver regression
From: Sergei Antonov <saproj@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 January 2014 19:20, Gabor Juhos <juhosg@openwrt.org> wrote:
> Hi Sergei,
>
> <...>
>
>>>>>> It worked well with older kernels and does not with newer kernels.
>>>>>> Specifically it fails to find any AP when scanning.
>>>>>> The first bad commit is:
>>>>>>
>>>>>> commit 76773f301f2210dcc20c466aebda7118062673eb
>>>>>> Author: Gabor Juhos <juhosg@openwrt.org>
>>>>>> Date:   Sat Aug 17 14:09:30 2013 +0200
>>>>>>
>>>>>>   rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices
>>>>>>
>>>>>>   According to the Ralink driver, there is an MCU
>>>>>>   command which can be used to send the frequency
>>>>>>   offset value directly to the USB device without
>>>>>>   going through the RFCSR writing sequence.
>>>>>>
>>>>>>   Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
>>>>>>   driver.
>>>>>>
>>>>>>   Reference:
>>>>>>     RTMPAdjustFrequencyOffset function in common/rt_rf.c
>>>>>>
>>>>>>   Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>>>>>>   Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>>>>>
>>>>>> After I removed this special USB handling (see the patch) the adapter
>>>>>> works again.
>>>>>
>>>>> Thanks for bisecting! Could you check if following patch fixes the
>>>>> issue?
>>>>
>>>> It does not fix the issue. The same broken behavior remains.
>>> I couldn't understand one string in original RTMPAdjustFrequencyOffset. Could you try follow patch ?
>> Tried your patch with and without Stanislaw's patch. No success.
>
> I guess that this is a timing issue. Maybe the RT5390 device does not finish the
> MCU command before the scan runs.
>
> The Ralink reference driver calls the frequency adjustment code from the
> NICInitRT5390RFRegisters function but the equivalent call is missing from the
> rt2x00 driver. Additionaly, the Ralink driver uses 1 ms delay after calling the
> frequency adjustment code which is also missing from rt2x00.
>
> The attached patch set adds the missing code to rt2x00. Please test whether it
> fixes the problem or not.

It does not work.

The minimal change that fixes the problem is removing 'return;' after
rt2800_mcu_request() allowing the standard freq. adjustment code to
execute.
