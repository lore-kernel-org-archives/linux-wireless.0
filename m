Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51390 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841AbZDGTwx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:52:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: changing number of queues in ops->start
Date: Tue, 7 Apr 2009 21:51:15 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200904072024.41910.mb@bu3sch.de> <200904072140.23318.mb@bu3sch.de> <1239133589.7475.3.camel@johannes.local>
In-Reply-To: <1239133589.7475.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904072151.15583.mb@bu3sch.de> (sfid-20090407_215256_922906_5E918C30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 07 April 2009 21:46:29 Johannes Berg wrote:
> On Tue, 2009-04-07 at 21:40 +0200, Michael Buesch wrote:
> 
> > Ok I see. So you say it's OK to lower hw->queues after ieee80211_register.
> 
> Let's say it's acceptable ;)
> 
> > Should I reset hw->queues back to the value ieee80211_register was called with, before
> > I call unregister/free? Are there resources allocated by the number of queues?
> 
> There are resources allocated, notably the qdiscs etc. in
> alloc_ether_mq() or whatever it's called in register_hw(). But the
> networking core should keep track of those so it shouldn't matter what
> the value is. OTOH if it can switch back and forth the pending packets
> are done per queue... for example ieee80211_clear_tx_pending will be
> called at unregister times, so if it's possible to be up with 4 queues,
> and later be up with 1, you will want to unregister with 4.

Ok, sounds like a huge hack to me. :) I'll think about it.

-- 
Greetings, Michael.
