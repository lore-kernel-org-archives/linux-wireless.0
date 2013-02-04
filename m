Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3BDR35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:29:57 -0500
Message-ID: <1359999018.17993.13.camel@jlt4.sipsolutions.net> (sfid-20130204_183001_248712_2BDAE537)
Subject: Re: [PATCH] mac80211: Fix PN corruption in case of multiple virtual
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Amit Shakya <amit.shakya@stericsson.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 Feb 2013 18:30:18 +0100
In-Reply-To: <201302041814.11894.chunkeey@googlemail.com> (sfid-20130204_181415_037008_8DCF254D)
References: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com>
	 <1359991708.10311.15.camel@jlt4.sipsolutions.net>
	 <201302041814.11894.chunkeey@googlemail.com>
	 (sfid-20130204_181415_037008_8DCF254D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 18:14 +0100, Christian Lamparter wrote:
> On Monday, February 04, 2013 04:28:28 PM Johannes Berg wrote:
> > On Mon, 2013-02-04 at 16:48 +0530, Amit Shakya wrote:
> > > @@ -2790,7 +2791,20 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
> > >  
> > >     rx->local->running_rx_handler = true;
> > >  
> > > -   while ((skb = __skb_dequeue(&rx->local->rx_skb_queue))) {
> > > +   skb_queue_walk_safe(&rx->local->rx_skb_queue, skb, tmp) {
> > > +           if (!skb)
> > > +                   break;
> > > +           hdr = (struct ieee80211_hdr *) skb->data;
> > > +           /*
> > > +           * Additional check to ensure that the packets corresponding
> > > +           * to same sta entry as in rx->sta are de-queued. The queue
> > > +           * can have different interface packets in case of multiple vifs
> > > +           */
> > > +           if ((rx->sta && hdr) && (ieee80211_is_data(hdr->frame_control))
> > > +                   && (memcmp(rx->sta->sta.addr, hdr->addr2, ETH_ALEN)))
> > > +                                   continue;
> > > +           __skb_unlink(skb, &rx->local->rx_skb_queue);
> > 
> > Christian, is there any reason to not just have the queue be on the
> > stack, and use a separate spinlock in the local struct to lock out the
> > unwanted concurrency?

> Let's see.
> 
> The original "AMPDU rx reorder timeout timer" had the rx_skb_queue (frames)
> on the stack. But that didn't work because the rx-path isn't thread-safe. This
> issue was addressed by "mac80211: serialize rx path workers" (24a8fda). 

It seems this actually caused the problem, because this part:

    Only one active rx handler worker [ieee80211_rx_handlers]
    is needed. All other threads which have lost the race of
    "runnning_rx_handler" can now simply "return", knowing that
    the thread who had the "edge" will also take care of their
    workload.

forgot to account for the fact that the on-stack versions of "struct
ieee80211_rx_data" can be different. Right?

> Interestingly, the RFC [1] of this patch mentioned the reason why I/we didn't
> go for a rx-path lock:
> "       1. Locking is easy to implement but hard to maintain.
>            Furthermore, Johannes worked very hard to get rid
>            of as many as possible."
> 
> > It seems to me that should work just as well, since there are never frames
> > on the rx_skb_queue for very long, right?
> Yes it should. At least we didn't find anything wrong with it back then.

But ... that doesn't necessarily mean an RX path lock, does it? 

I mean, in order to fix the above, we *do* have to make the RX
tasklet/timer wait for each other. So it's not really a big difference
between what we do now and having one of them block, is it? I guess that
they can still do all the local work, and then call the RX handlers with
the lock held? Hmm. That does kinda mean an RX path lock :-)

I guess it's the only way I see, since we can't really disable RX from
drivers when the timer starts running.

johannes


