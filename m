Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44180 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459Ab3EHQHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 12:07:49 -0400
Message-ID: <518A784A.6040704@candelatech.com> (sfid-20130508_180802_095208_BBC2BA26)
Date: Wed, 08 May 2013 09:07:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH RFC] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <517D1B45.9020302@openwrt.org> <517D3840.2060000@candelatech.com> <517D3B50.6070806@openwrt.org> <20873.58246.410990.985421@gargle.gargle.HOWL>
In-Reply-To: <20873.58246.410990.985421@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2013 10:32 PM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> The problem I have with the current stats is they're just an arbitrary
>> collection of random stuff that is probably useless for 99% of all
>> users. In many cases the way the stats are collected also makes the data
>> completely meaningless (e.g. because the source/destination address is
>> not taken into account).
>>
>> Why care about the number of packets on the air that were sent with a
>> specific rate flag? Why care about the number of beacons on the air
>> (with no filter on a set of APs or anything)? Or what about the number
>> of fragments received? To me it just looks like an incoherent set of
>> useless facts.
>
> Yes, having per-station statistics would be useful, mainly for RX and TX. Right
> now, all the counters are global and there is no way to find out how a
> particular station is performing, especially in AP mode. Since mac80211 gives us
> proper debugfs hooks for station addition/deletion, relevant stuff can be moved
> there.
>
> The 'recv' file used to be just for HW errors (DESC, CRC etc.), now it has various
> counters that should probably be node-specific.
>
> The 'xmit' file can be trimmed and information can be maintained per-station.
> This will be really useful in AP mode - especially for diagnosing aggregation, QoS, PS etc.

I think it's good to keep global counters too..otherwise it is going to be
a lot of work to gather per NIC stats, and since you would have to read for each
station, your stats might not be quite as atomic as they used to be.

But, I'm fine with adding per-station counters on top of the global
stats.

Thanks,
Ben

>
> Other than these two files, the rest are simple.
>
> Sujith
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

