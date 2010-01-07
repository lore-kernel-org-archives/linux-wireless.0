Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:63399 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0AGPns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 10:43:48 -0500
Received: by iwn32 with SMTP id 32so2405488iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 07:43:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B458BBC.6040200@free.fr>
References: <4B3DBB6B.4010107@free.fr> <43e72e891001011524r190950c8pdfc89e765afb205d@mail.gmail.com>
	<4B3F1010.3070906@free.fr> <43e72e891001021004r2c9cf855p52b007a88123bba7@mail.gmail.com>
	<43e72e891001061739t5ded13e7u6b16c73f1b26b246@mail.gmail.com>
	<4B458BBC.6040200@free.fr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 Jan 2010 07:43:26 -0800
Message-ID: <43e72e891001070743q5f16a1e7y94e1c3b0c0bbcbb6@mail.gmail.com>
Subject: Re: Issue connecting to an HT40 AP that sends a Country IE
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 6, 2010 at 11:22 PM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:
> Luis R. Rodriguez a écrit :
>>
>> On Sat, Jan 2, 2010 at 10:04 AM, Luis R. Rodriguez <mcgrof@gmail.com>
>> wrote:
>>
>>>
>>> The issue should  be that a frequency rule is being created for each
>>> channel and although 40 MHz is being specified as max bandwidth
>>> logistically only 20 MHz fits into that frequency rule. So what the
>>> intersection needs to learn is how to merge rules or at least
>>> understand them together. It may be easier to parse insaneIEs like the
>>> ones your AP generates and re-generate one with actual ranges with
>>> contiguity channels merged. And then use that one for the
>>> intersection.
>>>
>>
>> I have a patch in mind now for this, can you please apply this patch
>> on iw, scan and send me the output of the scan for your AP?
>>
>>  Luis
>>
>
> Here is the result for the said AP :
>
> BSS 00:15:6d:e8:88:84 (on wlan0)
>       TSF: 627428313658 usec (7d, 06:17:08)
>       freq: 5180
>       beacon interval: 100
>       capability: ESS Privacy ShortSlotTime (0x0411)
>       signal: -76.00 dBm
>       last seen: 7604 ms ago
>       SSID: BEN_nsm5
>       Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0
>       DS Parameter set: channel 36
>       Country: FR     Environment: Indoor only
>       Country IE triplets:
>               Channels [36 - 36]
>               Channels [40 - 40]
>               Channels [44 - 44]
>               Channels [48 - 48]
>               Channels [52 - 52]
>               Channels [56 - 56]
>               Channels [60 - 60]
>               Channels [64 - 64]
>               Channels [100 - 100]
>               Channels [104 - 104]
>               Channels [108 - 108]
>               Channels [112 - 112]
>               Channels [116 - 116]
>               Channels [120 - 120]
>               Channels [124 - 124]
>               Channels [128 - 128]
>               Channels [132 - 132]
>               Channels [136 - 136]
>               Channels [140 - 140]
>       Power constraint: 0 dB
>       RSN:     * Version: 1
>                * Group cipher: CCMP
>                * Pairwise ciphers: CCMP
>                * Authentication suites: PSK
>                * Capabilities: (0x0000)
>       WMM:     * Parameter version 1
>                * u-APSD
>                * BE: CW 15-1023, AIFSN 3
>                * BK: CW 15-1023, AIFSN 7
>                * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
>                * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
>       HT capabilities:
>               Capabilities: 0x4e
>                       HT20/HT40
>                       SM Power Save disabled
>                       RX HT40 SGI
>                       No RX STBC
>                       Max AMSDU length: 7935 bytes
>                       No DSSS/CCK HT40
>               Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>               Minimum RX AMPDU time spacing: 1/2 usec (0x02)
>               HT RX MCS rate indexes supported: 0-15
>               HT TX MCS rate indexes are undefined
>
> iw version 0.9.18-11-g89ea706-dirty
>
> As a quick patch, I have commented 2 lines "bw_flags =
> IEEE80211_CHAN_NO_HT40" in net/wireless/reg.c
>
> I'll try to do a patch for the kernel that does the following action :
> - parse the max_power field

I have this already in my queue

> - merge rules if the max_power field is the same for both rules

I also have this but I wanted to test it against your AP's IE, which
is why I asked for this output.

> - use max_bandwidth_khz as a capability feature (ie it could be larger than
>  end_freq - start_freq)

Not sure I get this.

> - when trying to enable HT40, we might obey 2 reg rules (if they have not
> been merge). In this case, we should intersect rules again.

My patch merges contiguous country IE subbands. I guess I'll post as
RFC for now.

> Does this logic is fine?

Yeah you certainly found an issue, unfortunately my patch for the
subband fix is too big for it to be considered for stable and I cannot
think of a smaller way to resolve it.

  Luis
