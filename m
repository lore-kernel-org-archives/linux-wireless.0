Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab0LaNkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Dec 2010 08:40:40 -0500
Received: by ewy5 with SMTP id 5so5410119ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 31 Dec 2010 05:40:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=c1XvwzJjZx+WH0uSSxn8++CCFJ-pJkxa4MtaQ@mail.gmail.com>
References: <AANLkTimYqrqUK2EjnyvkwvsFM+6b7ZMTGjBQrWFT712T@mail.gmail.com>
	<AANLkTikeehA_cMHndCRidknqVc7Y49_JmPbt4+Np6jDx@mail.gmail.com>
	<201012310027.14433.chunkeey@googlemail.com>
	<AANLkTi=c1XvwzJjZx+WH0uSSxn8++CCFJ-pJkxa4MtaQ@mail.gmail.com>
Date: Fri, 31 Dec 2010 08:40:38 -0500
Message-ID: <AANLkTikTHecf=yDcUgaJ-2RbzVzX5hpr_xbBTDgtiKeb@mail.gmail.com>
Subject: Re: Get slow speed when using ar9170usb driver.
From: Chin Shi Hong <cshong87@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 30, 2010 at 9:54 PM, Chin Shi Hong <cshong87@gmail.com> wrote:
> On Fri, Dec 31, 2010 at 7:27 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
>> On Thursday 30 December 2010 16:55:18 Chin Shi Hong wrote:
>>> Dear All,
>>
>> Hello,
>>
>>> Wireless adapter model: TP-LINK WN821NC (USB 300Mbps Wireless N adapter)
>>> Output of lsusb: Bus 001 Device 007: ID 0cf3:1002 Atheros
>>> Communications, Inc. TP-Link TL-WN821N v2 [Atheros AR9001U-(2)NG]
>>> Wireless router: TP-LINK W8960N (300Mbps Wireless N router)
>>
>> That's weird, according to TP-Link's website there wasn't any WN821NC
>> with a WN821N v2. They "only" let you download the driver for
>> WN821N v3. v3 very different from the previous v2 generation, it has
>> new chips (AR7015+AR9287?) and needs the ath9k_htc driver.
>
> WN821NC is actually WN821N shipped with USB cradle. WN821N itself does
> not ship with any USB Cradle. The character 'C' in WN821NC mean
> "Cradle". If you purchase WN821N, you will not get any USB Cradle.
> But, if you purchase WN821NC, what you get is actually WN821N + USB
> Cradle.
>
>> Are you sure, you didn't get ripped off here and someone else
>> has "your" v3?
>
> According to the information printed at the back of my wireless
> adapter, it is WN821N v2.
>
>>> Driver name ar9170usb
>>> Linux distro: Ubuntu 10.10 64 bit
>>> Kernel version: 2.6.35-24-generic
>>>
>>> If I use Ndiswrapper + Windows XP driver, I can get full 300Mbps.
>> Have you measured that (with iperf/netperf)? Or is it just the
>> "Connection Information" pop-up which simply displays "speed: 300 Mbits" ?
>
> The 300Mbps is just "display". But, when I test my speed on Windows XP
> with jperf, it ever reach maximum 2xxMbps.
>
>>> At the same distance, if I use ar9170usb driver, I can only get
>>> maximum 54Mbps speed.
>> That's true. here's ar9170usb wiki page:
>> <http://wireless.kernel.org/en/users/Drivers/ar9170#features> => working
>>        "802.11 a/b/g"
>>
>> Also, the old stack (in 2.6.35) does not have minstrel_ht
>> (rate control algorithm for 11n) so ar9170usb is limited to
>> the legacy b/g rates.
>>
>> Furthermore, the old driver lacks any support for aggregation, so the
>> uplink throughput (even with the fastest 300 mbits rate and under
>> "perfect" lab conditions) would struggle to get to 40 mbit and beyond.
>>
>> --
>>
>> The quickest way around limitations is via backports:
>> visit <http://wireless.kernel.org/en/users/Download>
>> and get compat-wireless:
>>
>> <http://wireless.kernel.org/en/users/Download#Getting_compat-wireless_on_Ubuntu>
>>
>> Then, you can migrate to carl9170 (a new driver with a new firmware)
>> for more information, see:
>> <http://wireless.kernel.org/en/users/Drivers/carl9170>
>>
>> However, this "new" driver+fw is still in development. You definitely
>> want to keep your compat-wireless package up-to-date.
>>
>> Best Regards,
>>        Christian
>>
>
> Will try carl9170 again later.
>
> Regards,
>

carl9170 not work. Error when trying to run "sudo modprobe carl9170":
"FATAL: Error inserting carl9170
(/lib/modules/2.6.35-22-generic/updates/drivers/net/wireless/ath/carl9170/carl9170.ko):
Invalid argument".

regards,
