Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25847 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab0JDUzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 16:55:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 13:55:44 -0700
Date: Mon, 4 Oct 2010 13:55:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH v2 2/3] mac80211: wait until completely disassociated
 before new association
Message-ID: <20101004205551.GR2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
 <1286198080.3620.34.camel@jlt3.sipsolutions.net>
 <20101004163605.GC2105@tux>
 <1286210392.3620.40.camel@jlt3.sipsolutions.net>
 <20101004180458.GP2105@tux>
 <1286217898.3620.54.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286217898.3620.54.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 11:44:58AM -0700, Johannes Berg wrote:
> On Mon, 2010-10-04 at 11:04 -0700, Luis R. Rodriguez wrote:
> > On Mon, Oct 04, 2010 at 09:39:52AM -0700, Johannes Berg wrote:
> > > On Mon, 2010-10-04 at 09:36 -0700, Luis R. Rodriguez wrote:
> > > 
> > > > > > +wait:
> > > > > >  	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
> > > > > >  	run_again(local, wk->timeout);
> > > > > 
> > > > > But you'll be staying off-channel for the wait period, so what does this
> > > > > really help?
> > > > 
> > > > I totally missed this what locks us offchannel here, I though we just re-arm
> > > > the timer, and come back offchannel at a later time. What is it that locks
> > > > us offchannel until the timer runs again?
> > > 
> > > I believe we stay off-channel as long as the work item is active, after
> > > it has been activated, no?
> > 
> > Well I don't see that, the problem here was the assumption that within a work
> > item we can try to transmit a frame for our home channel without changing it.
> 
> Yes, that's true, but we do try to stop most things ... we just miss
> some :-)

That's one way of putting it, that's fine, I was under the impression
we did want to send the data though, but if the goal is to *stop* this
that's fine too.

> > If that is desired we must move back to the home channel as I did, but I can
> > see how we'd need more work than what I did, we'd need to start the queues,
> > get out of PS state with the AP and then TX... unless TX already handles
> > that for us.
> 
> We don't need to go out of PS state to just TX, but we'd need to be
> careful to TX with asleep bit.

I got what you meant here.

> That said, we don't TX data frames then.

But not here. Right now I am going to assume that we actually are
transmitting some frames for the delba when we try to tear down
the BA agreements with the old AP and the new AP are on the
same band, we just likely transmit it on the wrong channel.

> > ieee80211_work_work() just iterates over all work items, and then bails out.
> > The work loop is protected against local->mtx, and if we call work_work
> > when we either add new work, purge work, or hit a timer. We *try* to prevent
> > frames from being sent on the home channel by calling
> > ieee80211_offchannel_stop_station() but notice how we only stop the queues
> > for NL80211_IFTYPE_STATION interfaces.
> 
> No, we just stop the station ones differently from all the others.

Ah and also we did call ieee80211_offchannel_stop_beaconing() prior
to processing work_work stuff so that should take care of stopping
beaconing but that also turns off all TX queues... so yeah you're
right. The race here was just within work items assuming they can
transmit on other channels than the wk->chan.

> > Also this seems buggy, we do not take into consideration how much offchannel
> > work we are doing in consideration against the current AP's DTIM interval as
> > we do when going offchannel for scan work. We should merge that code for
> > this offchannel work_work loop.
> 
> True, we don't do _any_ timing here.

We can resolve that later, I'll add that to the TODO list.

  Luis
