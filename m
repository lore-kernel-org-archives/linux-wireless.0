Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42936 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2CaUjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 16:39:54 -0400
Message-ID: <4F776B97.10301@candelatech.com> (sfid-20120331_223957_758471_0A67A6A5)
Date: Sat, 31 Mar 2012 13:39:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Why is throughput so bad with lots of virtual stations?
References: <4F76806E.2010101@candelatech.com> <201203311159.55238.chunkeey@googlemail.com>
In-Reply-To: <201203311159.55238.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/31/2012 02:59 AM, Christian Lamparter wrote:
> On Saturday 31 March 2012 05:56:30 Ben Greear wrote:
>> I notice that when I get, say, 200 virtual stations on a radio (ath9k),
>> the total throughput becomes about 100 packets per second.  It can run
>> several thousands of packets per second with 10 or so stations.
> is this tcp or udp "throughput"?

It was tcp, and at least part of the problem is that there are lots of
packet drops and very high latency and eventually it seems TCP basically completely hangs
(I'm trying to run a 9kbps TCP stream on each station).

 From sniffing the AP, it seems like it receives at least most of the pkts
OK.  Ath9k can drop packets on rx all over the place w/out bumping
counters, so I'm instrumenting the rx path (and some tx-path drops
as well) to try to see where packets are being lost.

> Anyway, I don't know much about your AP. But If it's mac80211 based
> then you might also run into a problem with ath9k vs mac80211 for
> every sta_info_get_bss [used by ieee80211_find_sta et. al] call.
> You see, the station hash table uses the last byte of a station's
> MAC as the "HASH" [see STA_HASH]. So for 00:11:22:33:44:55, the hash
> is "55". Now, ath9k uses a mac mask for it's VIFs as well, only it
> starts from the other direction [i.e.:] xy:11:22:33:44:55.
> [e.g.: vif1: 00:11:22:33:44:55, vif2: 04:11:22:33:44:55,
> vif3: 0c:11:22:33:44:55, ...]

I'm specifying the MAC addresses, and incrementing the last octet, so
at least that shouldn't be a problem.  Maybe the hash in general needs
to be bigger...I'll look at that.

Thanks for the info.

Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
