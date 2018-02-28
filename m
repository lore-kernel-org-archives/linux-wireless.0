Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58566 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932778AbeB1TnL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 14:43:11 -0500
Subject: Re: fixed bit rate 9Mbps set as 24Mbps in g mode(legacy)
To: KAVITA MATHUR <kavitam@cdot.in>, ath10k@lists.infradead.org,
        backports@vger.kernel.org
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
 <20180227083933.M59708@cdot.in>
 <3047f184-d600-7be7-52bc-2ed4cee37ffe@candelatech.com>
 <20180228035700.M28643@cdot.in>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <04a538f8-80fc-432d-ba6c-59a3c48e6508@candelatech.com> (sfid-20180228_204315_209040_AE022652)
Date: Wed, 28 Feb 2018 11:43:08 -0800
MIME-Version: 1.0
In-Reply-To: <20180228035700.M28643@cdot.in>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 08:03 PM, KAVITA MATHUR wrote:
>
>
>
> On Tue, 27 Feb 2018 08:41:50 -0800, Ben Greear wrote
>> On 02/27/2018 12:49 AM, KAVITA MATHUR wrote:
>>> Hi,
>>>
>>> I have configured AP in g mode and tested legacy rates.All basic rates and supported
>>> rates(1,2,5.5,11,6,9,12,18,24,36,48,54) are set except 9Mbps.
>>>
>>> When fixed bit rate 9Mbps is set, it gets set as 24 Mbps. This issue has been observed
>>> in backports-4.4.2-1 as well as latest git version of ath10k driver.
>>>
>>>
>>> Is anybody aware of this issue? How can I fix this rate 9Mbps?
>>
>> You should specify which firmware/chipset you are using, since this might
>> easily be a firmware issue.
>
>
> Chipset : QCA988x
> ath10k version : git 16 oct 2017(v4.14-rc2-1-24-gc6db471)
> firmware version : firmware-5.bin_10.2.4.70.66
> Kernel version : 3.12
>
>> And, how are you determining that 'it gets set to 24Mbps'.  Is that the
>> encoding you see in a wifi sniff, or is the driver being set to 24Mbps
>> improperly when you use iw (or whatever) to try configuring the rate?
>
> I have used command "iw wlan0 station dump" to see set data rate as well as I have
> sniffer. Measured data throughput is also as per 24Mbps.

I use more recent (and hacked) kernels/drivers, and my own wave-1 firmware.  I did have
a bug in some code I wrote because the 48Mbps rate code is '0x0', and some of
my code was ignoring it thinking it was not properly set.  I did see correct
on-air 48Mbps encoding rates though.

Possibly you have similar problems with rate-code 0x0.

Have you tried doing a capture with an ath9k or some other non-ath10k driver
to see if it is really 24Mbps on air?

>
>
>
>> Recent upstream mac80211 has broken the ability to set a single tx rate as
>> well, last I checked.
>
> Other rates are set properly except 9Mbps.By default it sets as 6Mbps, when data
> transfer starts, then it set to the mentioned fixed data rate.

Setting the tx rate through normal API will not effect management frames, and at the beginning of
the connection, perhaps no data frames have been sent/received yet, so you would
see 6Mbps reported.

Thanks,
Ben

>
> Thanks & Regards,
> Kavita
>> Thanks,
>> Ben
>>
>>>
>>>
>>> Thanks & Regards,
>>> Kavita
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe backports" in
>>>
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>
>
> Thanks & Regards,
> कविता माथुर Kavita Mathur
> वरिष्ठ अनुसंधान अभियंता  Senior Research Engineer
> सी-डॉट                      C-DOT
> इलैक्ट्रॉनिक्स सिटी फेज़ I         Electronics City Phase I
> होसूर रोड, बेंगलूरु               Hosur Road, Bengaluru – 560100
> फोन  Ph 080-28529896
> Disclaimer:
> ----------
> This email and any files transmitted with it
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
