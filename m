Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.inescn.pt ([192.35.246.20]:50758 "EHLO trubo.inescn.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbbCMRJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 13:09:00 -0400
Message-ID: <20150313180825.60326lqvicjf9dvt@horde.inescporto.pt> (sfid-20150313_180907_547894_923F3F83)
Date: Fri, 13 Mar 2015 18:08:25 +0100
From: =?iso-8859-1?b?TeFyaW8=?= Lopes <mjlopes@inescporto.pt>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Specific tx rates with ath10k
References: <5501DAF7.1000800@candelatech.com>
	<20150313103721.13586092dzqt9w41@horde.inescporto.pt>
	<55030897.4050606@candelatech.com>
In-Reply-To: <55030897.4050606@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not on that specific setup. I'm using OpenWRT (ath9k & ath10k) and  
Ubuntu 14 (ath9k only).

There are some equipment that send broadcast traffic as unicast in  
order to reduce airtime. I don't know which, just remembered about  
that on some published papers.
I would be very usefull to transmit broadcast traffic as real  
broadcast traffic at HT/VHT speeds in order to reduce air time, which  
speed is based on last sent unicast frame speed or build a pessimist  
rate adaptation algoritm with a sort of link with rate adaptation  
algoritm used for unicast traffic.


Quoting Ben Greear <greearb@candelatech.com>:

> On 03/13/2015 02:37 AM, Mário Lopes wrote:
>> Hi.
>>
>> You can change to fixed bitrate for all types of traffic for  
>> 802.11g/a modes, even on ath10k:
>> for 2.4 GHz @ 54 Mbit/s - iw dev wiface set bitrates legacy-2.4 54
>> for 5 GHz @ 54 Mbit/s - iw dev wiface set bitrates legacy-5 54
>
> Have you actually tried this with an ath10k AP and seen that beacons
> and broadcast go out at 54Mbps?
>
> If so, please let me know what firmware version you are using.
>
>> Setting fixed speed for HT and VHT modes currently only takes  
>> effect on unicast traffic, I would like that this could be applied  
>> to other types of traffic in a
>> future ath9k/ath10k driver.
>
> I know beacons won't go out at HT speeds, at least not with the
> logic that I tried in the firmware...but I have not checked to
> see if my patch allows setting broadcast to HT speeds....
>
> Thanks,
> Ben
>
>>
>>
>> Quoting Ben Greear <greearb@candelatech.com>:
>>
>>> Ath10k firmware gives ability to set specific fixed rate-control rates
>>> for beacons/mgt, multicast, broadcast, and regular traffic.
>>>
>>> The ath10k driver only sets regular traffic currently.
>>>
>>> I had previously hacked my firmware to just set all rate types when
>>> ath10k driver requested to set the rate.
>>>
>>> But, that is not what my customer needs.
>>>
>>> So, I am now planning to add some debugfs entries to allow users to set
>>> beacon/mgt, multicast and broadcast rates individually (I don't  
>>> have time or interest
>>> right now to try patching things top to bottom to try to get this feature
>>> into mac80211 stack or 'iw').
>>>
>>> My question is, for when user just runs a command like this:
>>>
>>> ./local/sbin/iw dev vap1 set bitrates legacy-2.4 6 ht-mcs-2.4
>>>
>>> What is the desired behaviour?
>>>
>>> Set all rates (beacons/mgt, bcast, multicast, regular) to the same
>>> fixed speed, or just a certain subset of these traffic types?
>>>
>>> I can make my firmware do whatever combination is required, and then
>>> users can over-ride the values by using debugfs.....
>>>
>>> As a note, ath10k firmware will NOT send beacons at HT speeds, so
>>> if you fix an HT rate, then firmware will ignore that for the beacons/mgt
>>> ratecontrol type.
>>>
>>> Thanks,
>>> Ben
>>>
>>> --
>>> Ben Greear <greearb@candelatech.com>
>>> Candela Technologies Inc  http://www.candelatech.com
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe  
>>> linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>> ----------------------------------------------------------------
>> This message was sent using IMP, the Internet Messaging Program.
>>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
