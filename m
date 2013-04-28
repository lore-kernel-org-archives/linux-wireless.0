Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55954 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3D1OzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Apr 2013 10:55:12 -0400
Message-ID: <517D3840.2060000@candelatech.com> (sfid-20130428_165518_091074_A137AC26)
Date: Sun, 28 Apr 2013 07:54:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH RFC] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <517D1B45.9020302@openwrt.org>
In-Reply-To: <517D1B45.9020302@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/28/2013 05:51 AM, Felix Fietkau wrote:
> On 2013-04-27 5:25 PM, Oleksij Rempel wrote:
>> Collect statistics about recived duplicate and STBC packets.
>> This information should help see if STBC is actually working.
>>
>> Tested on ar9285;
>>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> I thought about this patch some more, and I'm wondering what's the point
> in doing this? These statistics are going to be completely useless for
> most people and they'll waste some memory/cpu cycles, especially on
> small-cache devices. I think it's much more useful to simply pass the
> information to mac80211 via rx flags and get them added to the radiotap
> header.
> I'd like to keep the number of 'poor man's debug hacks' in the driver to
> a minimum, and there are some other things that I think should be
> removed: rx_frags and rx_beacons in struct ath_rx_stats, the tx/rx MAC
> sampling hack, and pretty much anything else that can be just as easily
> accessed from mac80211 through regular interfaces.

Does that mean we can just put the stats in mac80211, or do we have
to be running a sniffer to gather the stats?

Thanks,
Ben

>
> - Felix
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


