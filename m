Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:51395 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0AETgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 14:36:44 -0500
Date: Tue, 5 Jan 2010 20:36:42 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
Message-ID: <20100105193642.GV1735@mail.wantstofly.org>
References: <1262710858.28653.5.camel@johannes.local> <20100105171603.GX6361@tuxdriver.com> <4B438E08.9080307@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B438E08.9080307@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2010 at 08:07:52PM +0100, Felix Fietkau wrote:

> >> Since I removed the master netdev, we've been
> >> keeping internal queues only, and even before
> >> that we never told the networking stack above
> >> the virtual interfaces about congestion. This
> >> means that packets are queued in mac80211 and
> >> the upper layers never know, possibly leading
> >> to memory exhaustion and other problems.
> >> 
> >> This patch makes all interfaces multiqueue and
> >> uses ndo_select_queue to put the packets into
> >> queues per AC. Additionally, when the driver
> >> stops a queue, we now stop all corresponding
> >> queues for the virtual interfaces as well.
> >> 
> >> The injection case will use VO by default for
> >> non-data frames, and BE for data frames, but
> >> downgrade any data frames according to ACM. It
> >> needs to be fleshed out in the future to allow
> >> chosing the queue/AC in radiotap.
> >> 
> >> Reported-by: Lennert Buytenhek <buytenh@marvell.com>
> >> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >> Cc: stable@kernel.org [2.6.32]
> >> ---
> >> I know it's late, and large, but still would be good to have in .33
> >> since the issue is fairly serious.
> > 
> > Obviously I'd like to see some testing.  Lennert, does this patch
> > resolve the issues you raised?
>
> I tested this patch on embedded hardware, and it makes a huge
> difference there. It fixes some serious TCP throughput drops and
> latency spikes that I observed with ath9k earlier.

Good to hear.  While you're testing anyway, could you check whether
shortening the wlan0 tx queue length to, say, 100 entries (ifconfig
wlan0 txqueuelen 100) has any further effect on latency, or on CPU
usage?
