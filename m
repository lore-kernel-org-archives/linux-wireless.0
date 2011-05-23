Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53806 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab1EWSwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 14:52:41 -0400
Message-ID: <4DDAACF3.3050705@candelatech.com> (sfid-20110523_205244_557613_4A69A2C9)
Date: Mon, 23 May 2011 11:52:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com> <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com>
In-Reply-To: <4DDAA9ED.1050606@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 11:39 AM, Ben Greear wrote:
> On 05/23/2011 09:54 AM, Ben Greear wrote:
>> On 05/23/2011 04:28 AM, Mohammed Shafi wrote:
>>> On Sat, May 21, 2011 at 3:52 AM, Ben Greear<greearb@candelatech.com>
>>> wrote:
>>>> This is on 2.6.39-wl+
>>>>
>>>> All the 5Ghz channels are showing as passive scanning, which
>>>> makes them unusable for APs if nothing else.
>>>
>>> for me channels 36,40,44,48 are ok in 5ghz. used the latest
>>> wireless-testing just brought the card up as station mode.
>>
>> Most of my systems show the same, at least most of the time.
>>
>>
>>>> Any idea why this is happening?
>>>
>>> don't know, may be regulatory.
>>
>> After a reboot and an idle weekend, mine also look normal.
>> So, it's something transient it appears.
>
> Err, I mis-spoke..the 9380 system still shows passive
> scanning everywhere...

Busted one:

ath: EEPROM regdomain: 0x6a
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: 00
ath: Regpair used: 0x6a

cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)


Bleh, seems my Sparklan 127 NIC is set to world-roam :(

What a total pain in the arse!
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

