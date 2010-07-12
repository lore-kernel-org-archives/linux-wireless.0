Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58778 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab0GLPaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 11:30:13 -0400
Date: Mon, 12 Jul 2010 11:20:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Rate control & USB
Message-ID: <20100712152058.GB2442@tuxdriver.com>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
 <4C3B321F.2020609@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C3B321F.2020609@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 12, 2010 at 05:17:51PM +0200, Felix Fietkau wrote:
> On 2010-07-12 12:48 PM, Ivo Van Doorn wrote:
> > The problem here is that we have lost the per-sta statistics. However using the
> > single TX status reports, we can count the number of frames which are sent for
> > a given STA during the poll interval. We can then determine the percentage of
> > frames sent for that STA, We can then add the percentage of the retry and ACK
> > count to each STA. Throughout poll interval the rate algorithm would send all
> > frames to the same STA with the same TX rate, but between polls, the rate will
> > be updated.
> > 
> > Overall these changes will not make the optimal use of PID or
> > Minstrel, but it would
> > at least improve the situation for USB.
> > 
> > Any thoughts about this solution?
> I don't know how minstrel could work with this approach. Before it
> starts to use a rate, it has to sample it first. How can you sample
> rates with your tx status feedback approach?

You would have to commit to that rate for at least one polling period, no?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
