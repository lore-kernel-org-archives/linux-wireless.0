Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab0JEH7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 03:59:45 -0400
Subject: Re: [PATCH v2 2/3] mac80211: wait until completely disassociated
 before new association
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
In-Reply-To: <20101004205551.GR2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
	 <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
	 <1286198080.3620.34.camel@jlt3.sipsolutions.net>
	 <20101004163605.GC2105@tux>
	 <1286210392.3620.40.camel@jlt3.sipsolutions.net>
	 <20101004180458.GP2105@tux>
	 <1286217898.3620.54.camel@jlt3.sipsolutions.net>
	 <20101004205551.GR2105@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 09:59:42 +0200
Message-ID: <1286265582.3641.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 13:55 -0700, Luis R. Rodriguez wrote:

> > We don't need to go out of PS state to just TX, but we'd need to be
> > careful to TX with asleep bit.
> 
> I got what you meant here.
> 
> > That said, we don't TX data frames then.
> 
> But not here. Right now I am going to assume that we actually are
> transmitting some frames for the delba when we try to tear down
> the BA agreements with the old AP and the new AP are on the
> same band, we just likely transmit it on the wrong channel.

Yes, but delBA aren't data frames. The queue stop etc. doesn't pertain
to them.

> Ah and also we did call ieee80211_offchannel_stop_beaconing() prior
> to processing work_work stuff so that should take care of stopping
> beaconing but that also turns off all TX queues... so yeah you're
> right. The race here was just within work items assuming they can
> transmit on other channels than the wk->chan.

Did any work item actually assume that? Except maybe for your patch 1 in
this set?

> > > Also this seems buggy, we do not take into consideration how much offchannel
> > > work we are doing in consideration against the current AP's DTIM interval as
> > > we do when going offchannel for scan work. We should merge that code for
> > > this offchannel work_work loop.
> > 
> > True, we don't do _any_ timing here.
> 
> We can resolve that later, I'll add that to the TODO list.

Come to think of it -- some p2p stuff in the supplicant might time out
if we do this, I think we need to cut the drivers/mac80211 some more
slack in the supplicant and not assume the remain-on-channel will start
quickly.

johannes

