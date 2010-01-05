Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36655 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0AERa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 12:30:29 -0500
Date: Tue, 5 Jan 2010 12:16:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
Message-ID: <20100105171603.GX6361@tuxdriver.com>
References: <1262710858.28653.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1262710858.28653.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2010 at 06:00:58PM +0100, Johannes Berg wrote:
> Since I removed the master netdev, we've been
> keeping internal queues only, and even before
> that we never told the networking stack above
> the virtual interfaces about congestion. This
> means that packets are queued in mac80211 and
> the upper layers never know, possibly leading
> to memory exhaustion and other problems.
> 
> This patch makes all interfaces multiqueue and
> uses ndo_select_queue to put the packets into
> queues per AC. Additionally, when the driver
> stops a queue, we now stop all corresponding
> queues for the virtual interfaces as well.
> 
> The injection case will use VO by default for
> non-data frames, and BE for data frames, but
> downgrade any data frames according to ACM. It
> needs to be fleshed out in the future to allow
> chosing the queue/AC in radiotap.
> 
> Reported-by: Lennert Buytenhek <buytenh@marvell.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: stable@kernel.org [2.6.32]
> ---
> I know it's late, and large, but still would be good to have in .33
> since the issue is fairly serious.

Obviously I'd like to see some testing.  Lennert, does this patch
resolve the issues you raised?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
