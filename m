Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46945 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0AETIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 14:08:06 -0500
Message-ID: <4B438E08.9080307@openwrt.org>
Date: Tue, 05 Jan 2010 20:07:52 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
References: <1262710858.28653.5.camel@johannes.local> <20100105171603.GX6361@tuxdriver.com>
In-Reply-To: <20100105171603.GX6361@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-05 6:16 PM, John W. Linville wrote:
> On Tue, Jan 05, 2010 at 06:00:58PM +0100, Johannes Berg wrote:
>> Since I removed the master netdev, we've been
>> keeping internal queues only, and even before
>> that we never told the networking stack above
>> the virtual interfaces about congestion. This
>> means that packets are queued in mac80211 and
>> the upper layers never know, possibly leading
>> to memory exhaustion and other problems.
>> 
>> This patch makes all interfaces multiqueue and
>> uses ndo_select_queue to put the packets into
>> queues per AC. Additionally, when the driver
>> stops a queue, we now stop all corresponding
>> queues for the virtual interfaces as well.
>> 
>> The injection case will use VO by default for
>> non-data frames, and BE for data frames, but
>> downgrade any data frames according to ACM. It
>> needs to be fleshed out in the future to allow
>> chosing the queue/AC in radiotap.
>> 
>> Reported-by: Lennert Buytenhek <buytenh@marvell.com>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> Cc: stable@kernel.org [2.6.32]
>> ---
>> I know it's late, and large, but still would be good to have in .33
>> since the issue is fairly serious.
> 
> Obviously I'd like to see some testing.  Lennert, does this patch
> resolve the issues you raised?
I tested this patch on embedded hardware, and it makes a huge difference
there. It fixes some serious TCP throughput drops and latency spikes
that I observed with ath9k earlier.
I think this should be merged ASAP.

- Felix
