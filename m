Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38435 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab1EXOIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 10:08:37 -0400
Received: by wya21 with SMTP id 21so5002972wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 07:08:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikvwq+0GYDxgEXNfhkcntjmpOdpPQ@mail.gmail.com>
References: <4DD6E9B5.3020905@candelatech.com>
	<BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>
	<4DDA913B.1060002@candelatech.com>
	<4DDAA9ED.1050606@candelatech.com>
	<4DDAACF3.3050705@candelatech.com>
	<BANLkTikvwq+0GYDxgEXNfhkcntjmpOdpPQ@mail.gmail.com>
Date: Tue, 24 May 2011 19:38:34 +0530
Message-ID: <BANLkTinWnLryxtqTF3b0rr0f8VO=Y2Jkmw@mail.gmail.com> (sfid-20110524_160840_754697_3A48BEB5)
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Brian Prodoehl <bprodoehl@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 24, 2011 at 6:30 PM, Brian Prodoehl <bprodoehl@gmail.com> wrote:
> On Mon, May 23, 2011 at 2:52 PM, Ben Greear <greearb@candelatech.com> wrote:
>> On 05/23/2011 11:39 AM, Ben Greear wrote:
>>>
>>> On 05/23/2011 09:54 AM, Ben Greear wrote:
>>>>
>>>> On 05/23/2011 04:28 AM, Mohammed Shafi wrote:
>>>>>
>>>>> On Sat, May 21, 2011 at 3:52 AM, Ben Greear<greearb@candelatech.com>
>>>>> wrote:
>>>>>>
>>>>>> This is on 2.6.39-wl+
>>>>>>
>>>>>> All the 5Ghz channels are showing as passive scanning, which
>>>>>> makes them unusable for APs if nothing else.
>>>>>
>>>>> for me channels 36,40,44,48 are ok in 5ghz. used the latest
>>>>> wireless-testing just brought the card up as station mode.
>>>>
>>>> Most of my systems show the same, at least most of the time.
>>>>
>>>>
>>>>>> Any idea why this is happening?
>>>>>
>>>>> don't know, may be regulatory.
>>>>
>>>> After a reboot and an idle weekend, mine also look normal.
>>>> So, it's something transient it appears.
>>>
>>> Err, I mis-spoke..the 9380 system still shows passive
>>> scanning everywhere...
>>
>> Busted one:
>>
>> ath: EEPROM regdomain: 0x6a
>> ath: EEPROM indicates we should expect a direct regpair map
>> ath: Country alpha2 being used: 00
>> ath: Regpair used: 0x6a
>>
>> cfg80211: Calling CRDA for country: US
>> cfg80211: Regulatory domain changed to country: US
>> cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain,
>> max_eirp)
>> cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
>> cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
>> cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
>>
>>
>> Bleh, seems my Sparklan 127 NIC is set to world-roam :(
>>
>> What a total pain in the arse!
>> Ben
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>
>
> Strange.  This is what I get out of my WPEA-127N:
>
> ath: EEPROM regdomain: 0x0
> ath: EEPROM indicates default country code should be used
> ath: doing EEPROM country->regdmn map search
> ath: country maps to regdmn code: 0x3a
> ath: Country alpha2 being used: US
> ath: Regpair used: 0x3a
>
> Here's how my 5GHz channels look:
>                Frequencies:
>                        * 5180 MHz [36] (17.0 dBm)
>                        * 5200 MHz [40] (17.0 dBm)
>                        * 5220 MHz [44] (17.0 dBm)
>                        * 5240 MHz [48] (17.0 dBm)
>                        * 5260 MHz [52] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5280 MHz [56] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5300 MHz [60] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5320 MHz [64] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5500 MHz [100] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5520 MHz [104] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5540 MHz [108] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5560 MHz [112] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5580 MHz [116] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5600 MHz [120] (disabled)
>                        * 5620 MHz [124] (disabled)
>                        * 5640 MHz [128] (disabled)
>                        * 5660 MHz [132] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5680 MHz [136] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5700 MHz [140] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5745 MHz [149] (30.0 dBm)
>                        * 5765 MHz [153] (30.0 dBm)
>                        * 5785 MHz [157] (30.0 dBm)
>                        * 5805 MHz [161] (30.0 dBm)
>                        * 5825 MHz [165] (30.0 dBm)
>
> This is running 2.6.37 with compat-wireless from sometime in March,
> probably.  I'll try with 2.6.39 and latest compat-wireless when I get
> a chance.
>

I got the similar result with latest wireless testing

> -Brian
>



-- 
shafi
