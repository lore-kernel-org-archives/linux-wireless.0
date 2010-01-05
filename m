Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:37471 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0AESgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:36:40 -0500
Date: Tue, 5 Jan 2010 19:36:39 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
Message-ID: <20100105183639.GT1735@mail.wantstofly.org>
References: <1262710858.28653.5.camel@johannes.local> <20100105171603.GX6361@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100105171603.GX6361@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2010 at 12:16:03PM -0500, John W. Linville wrote:

> > Since I removed the master netdev, we've been
> > keeping internal queues only, and even before
> > that we never told the networking stack above
> > the virtual interfaces about congestion. This
> > means that packets are queued in mac80211 and
> > the upper layers never know, possibly leading
> > to memory exhaustion and other problems.
> > 
> > This patch makes all interfaces multiqueue and
> > uses ndo_select_queue to put the packets into
> > queues per AC. Additionally, when the driver
> > stops a queue, we now stop all corresponding
> > queues for the virtual interfaces as well.
> > 
> > The injection case will use VO by default for
> > non-data frames, and BE for data frames, but
> > downgrade any data frames according to ACM. It
> > needs to be fleshed out in the future to allow
> > chosing the queue/AC in radiotap.
> > 
> > Reported-by: Lennert Buytenhek <buytenh@marvell.com>
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > Cc: stable@kernel.org [2.6.32]
> > ---
> > I know it's late, and large, but still would be good to have in .33
> > since the issue is fairly serious.
> 
> Obviously I'd like to see some testing.  Lennert, does this patch
> resolve the issues you raised?

I got an earlier version of this patch from Johannes and tested that,
and that seemed to work as intended.  I'll re-try with this version
of the patch, and I'll ask to have some QA done on it as well.

(FWIW, I think that the approach taken by this patch is the right way
to go.)
