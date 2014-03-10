Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44474 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbaCJPOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 11:14:06 -0400
Message-ID: <531DD6B0.4030101@openwrt.org> (sfid-20140310_161428_202794_EE619298)
Date: Mon, 10 Mar 2014 16:13:52 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Michael Braun <michael-dev@fami-braun.de>,
	ath9k-devel@qca.qualcomm.com
CC: projekt-wlan@fem.tu-ilmenau.de, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC] ath9k: use more than one slot per bss for
 multicast in staggered mode
References: <1394462435-23329-1-git-send-email-michael-dev@fami-braun.de>
In-Reply-To: <1394462435-23329-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-03-10 15:40, Michael Braun wrote:
> Before, ath9k divided time in ATH_BCBUF many equally sized slots.
> Each bss then was assigned to a single slot, leaving some or more slots empty.
> The beacons of a bss were sent at the beginning of the slot for this bss,
> and then the buffered multicast packets might be sent out.
> 
> As multicast packets are sent a lowest bitrate, wireless throughput
> of multicast packets is very limited, and thus the time available
> is crucial to avoid buffer overflow, which I frequently observed.
I think in setups where you need to be able to send more multicast
packets, you should consider increasing the multicast rate.

> This patch changes the behaviour of ath9k in two ways:
>  1. the time available when processing a slot is increased
>     to cover all subsequent unoccupied slots as well.
>     This size is tracked in the variable named "slotwidth".
I think we should not allow multicast transmission to eat up too much
airtime during the beacon interval. If APs are flooded with multicast
packets, it must not drown out useful unicast traffic.

>  2. during each slot, buffered packets from *all* bss are
>     sent out in a round-robin fashing, skipping those
>     bss where stations are currently not listing.
>     That could be either due to
>       - last dtim did not containt the relevant flag or
>       - a multicast packet not containing the "more data"
>         flag was sent out.
>     The state is tracked in multicastWakeup, which is
>     true iff the stations in this bss should already
>     be woken up.
That does not seem like a good idea to me. Powersave clients waking up
to receive multicast packets should be allowed to go to sleep again as
soon as possible. Keeping them awake unnecessarily by not clearing the
"more data" bit at the last packet make them eat more power.

> I currently don't know whether a non-buffered multicast packet
> can slip between buffered packets (or between dtim notification
> and the first buffered packet), so that an STA receives a
> multicast packet without MOREDATA set while there a still
> buffered packets to be received and just short before being
> delivered on-air.
The CAB queue gets enabled after a beacon and then takes priority over
all other queues. No packets will slip in between once its transmission
starts.

- Felix
