Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0JGR4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 13:56:23 -0400
Subject: Re: [PATCH] mac80211: Deny new BA agreements from being started
 during offchannel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
	Matt Smith <Matt.Smith@atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=iW1T7w-9akkR=DNnrGg3XD5nO=8pJ7V2_PiL4@mail.gmail.com>
References: <20101006185000.GJ7070@tux>
	 <1286391301.3655.403.camel@jlt3.sipsolutions.net>
	 <20101006191215.GM7070@tux>
	 <1286392799.3655.414.camel@jlt3.sipsolutions.net>
	 <AANLkTinOTsYKFpQkg2B7GVMF-eKykFd8LM1m8xmtXX7j@mail.gmail.com>
	 <1286435892.3657.9.camel@jlt3.sipsolutions.net>
	 <AANLkTi=iW1T7w-9akkR=DNnrGg3XD5nO=8pJ7V2_PiL4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 19:56:19 +0200
Message-ID: <1286474179.20974.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 10:21 -0700, Luis R. Rodriguez wrote:

> > But then again, come to think of it, why are you doing this anyway?
> 
> The goal is to clean up a lot of stuff we forgot to cleanup for
> offchannel operation and in the end to help with multicast/broadcast
> data. This patch just addresses one of the cleanups. The timers kicked
> off when going off channel will not make sense, so best to just deny
> ADDBA when going offchannel.

But this won't actually help in that case -- this problem happens if try
to make a BA just before we go offchannel, and then the timer fires
while we're offchannel. It'll just *very* slightly alter the timing
required to hit it.

> > I'm not convinced of the whole idea, it's all racy. I'm starting to think
> > that this patch won't help anything since we'll still be racy and start
> > BA agreements just before we block,
> 
> Establishing the BA agreement is fine, we don't want to cancel
> existing BA agreements when going offchannel, we just want to prevent
> making the timers for new ADDBA requests from going stale
> unnecessarily.

See above though.

> > _and_ if we're a station and going off-channel we'll be going into powersave
> > which means we won't actually get the addBA frame until we return.
> 
> There's a race between trying to go offchannel, sending the nullfunc
> and switching channels. When the race hits the ADDBA timer will just
> go stale. If our goal is to go offchannel we should avoid the race by
> simply denying new ADDBA requests. I just noticed that we can't
> possible receive ADDBA requests when we are scanning though, since
> ieee80211_iface_work() already has a check and bail out for
> local->scanning, but note that local->scanning will not be checked
> when doing other offchannel work.
> 
> So perhaps there is another way we can deal with this for the
> non-scanning offchannel work case that might also take care of not
> handling other queued up management frames when offchannel.

I think we need to treat TX and RX BA differently.

For TX BA, the best idea would probably be to actually make it _use_ the
work infrastructure -- after we change that to not actually stop all the
things it's doing when the channel is the operating channel, or so.

johannes

