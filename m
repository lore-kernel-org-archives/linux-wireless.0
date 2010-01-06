Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:33060 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0AFLd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 06:33:56 -0500
Date: Wed, 6 Jan 2010 12:33:55 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
Message-ID: <20100106113349.GB1735@mail.wantstofly.org>
References: <1262710858.28653.5.camel@johannes.local>
Mime-Version: 1.0
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

Tested-by: Lennert Buytenhek <buytenh@marvell.com>

(I haven't run into the issue that Larry described so far.)
