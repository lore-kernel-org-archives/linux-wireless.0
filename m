Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39792 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab3D1PIF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Apr 2013 11:08:05 -0400
Message-ID: <517D3B50.6070806@openwrt.org> (sfid-20130428_170809_219506_DDC76AE6)
Date: Sun, 28 Apr 2013 17:08:00 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH RFC] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <517D1B45.9020302@openwrt.org> <517D3840.2060000@candelatech.com>
In-Reply-To: <517D3840.2060000@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-28 4:54 PM, Ben Greear wrote:
> On 04/28/2013 05:51 AM, Felix Fietkau wrote:
>> On 2013-04-27 5:25 PM, Oleksij Rempel wrote:
>>> Collect statistics about recived duplicate and STBC packets.
>>> This information should help see if STBC is actually working.
>>>
>>> Tested on ar9285;
>>>
>>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> I thought about this patch some more, and I'm wondering what's the point
>> in doing this? These statistics are going to be completely useless for
>> most people and they'll waste some memory/cpu cycles, especially on
>> small-cache devices. I think it's much more useful to simply pass the
>> information to mac80211 via rx flags and get them added to the radiotap
>> header.
>> I'd like to keep the number of 'poor man's debug hacks' in the driver to
>> a minimum, and there are some other things that I think should be
>> removed: rx_frags and rx_beacons in struct ath_rx_stats, the tx/rx MAC
>> sampling hack, and pretty much anything else that can be just as easily
>> accessed from mac80211 through regular interfaces.
> 
> Does that mean we can just put the stats in mac80211, or do we have
> to be running a sniffer to gather the stats?
Right now you'd have to use a sniffer, but if you really care about
getting specific stats it might make sense to write a kernel module that
attaches to a monitor interface and gathers them (maybe even with
support for gathering arbitrary stats by attaching bpf filters).

The problem I have with the current stats is they're just an arbitrary
collection of random stuff that is probably useless for 99% of all
users. In many cases the way the stats are collected also makes the data
completely meaningless (e.g. because the source/destination address is
not taken into account).

Why care about the number of packets on the air that were sent with a
specific rate flag? Why care about the number of beacons on the air
(with no filter on a set of APs or anything)? Or what about the number
of fragments received? To me it just looks like an incoherent set of
useless facts.

- Felix
