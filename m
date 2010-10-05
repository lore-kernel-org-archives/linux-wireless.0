Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36520 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab0JETgZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 15:36:25 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 12:36:17 -0700
Date: Tue, 5 Oct 2010 12:36:23 -0700
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
Message-ID: <20101005193623.GC11831@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
 <1286198080.3620.34.camel@jlt3.sipsolutions.net>
 <20101004163605.GC2105@tux>
 <1286210392.3620.40.camel@jlt3.sipsolutions.net>
 <20101004180458.GP2105@tux>
 <1286217898.3620.54.camel@jlt3.sipsolutions.net>
 <20101004205551.GR2105@tux>
 <1286265582.3641.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286265582.3641.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 05, 2010 at 12:59:42AM -0700, Johannes Berg wrote:
> On Mon, 2010-10-04 at 13:55 -0700, Luis R. Rodriguez wrote:
> 
> > > We don't need to go out of PS state to just TX, but we'd need to be
> > > careful to TX with asleep bit.
> > 
> > I got what you meant here.
> > 
> > > That said, we don't TX data frames then.
> > 
> > But not here. Right now I am going to assume that we actually are
> > transmitting some frames for the delba when we try to tear down
> > the BA agreements with the old AP and the new AP are on the
> > same band, we just likely transmit it on the wrong channel.
> 
> Yes, but delBA aren't data frames. The queue stop etc. doesn't pertain
> to them.

Got it.

> > Ah and also we did call ieee80211_offchannel_stop_beaconing() prior
> > to processing work_work stuff so that should take care of stopping
> > beaconing but that also turns off all TX queues... so yeah you're
> > right. The race here was just within work items assuming they can
> > transmit on other channels than the wk->chan.
> 
> Did any work item actually assume that? Except maybe for your patch 1 in
> this set?

So far I just see the assoc request doing that.

> > > > Also this seems buggy, we do not take into consideration how much offchannel
> > > > work we are doing in consideration against the current AP's DTIM interval as
> > > > we do when going offchannel for scan work. We should merge that code for
> > > > this offchannel work_work loop.
> > > 
> > > True, we don't do _any_ timing here.
> > 
> > We can resolve that later, I'll add that to the TODO list.
> 
> Come to think of it -- some p2p stuff in the supplicant might time out
> if we do this,

Its no different than the case of a DTIM 1 case when we do bgscan
and need to scan through some passive scan channels.

> I think we need to cut the drivers/mac80211 some more
> slack in the supplicant and not assume the remain-on-channel will start
> quickly.

Not sure I follow, do you mean that as per API we want to document
offchannel operation may loose broadcast/multicast data frames?

  Luis
