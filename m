Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2KZKti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:49:38 -0500
Message-ID: <1353927000.9488.23.camel@jlt4.sipsolutions.net> (sfid-20121126_114941_498501_F1ECCF32)
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de, victorgld@gmail.com
Date: Mon, 26 Nov 2012 11:50:00 +0100
In-Reply-To: <50AB9EA3.6070804@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	     <1350226137-13704-7-git-send-email-victorg@ti.com>
	    <1350414472.10177.17.camel@jlt4.sipsolutions.net>
	   <50842563.4010201@ti.com>
	 <1350910599.10166.4.camel@jlt4.sipsolutions.net>
	   <50922AA9.4030509@ti.com>
	 <1352128994.9466.19.camel@jlt4.sipsolutions.net>  <50A2617B.3060807@ti.com>
	 <1352892233.9510.26.camel@jlt4.sipsolutions.net> <50AB9EA3.6070804@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 17:15 +0200, Victor Goldenshtein wrote:

> > Initially, I thought that for radar detection, you need to reserve the
> > channel context (in mac80211), make sure it's the only channel context
> > and prohibit other channel contexts from being added, until radar
> > detection is done.
> >
> 
> I thought the same, but to prohibit other channel contexts from being 
> added as long as we on DFS channel (not just until the end of the CAC).

Yes, that's a good plan, however, you're missing the fact that you need
to define "as long as we['re] on [the] DFS channel". You forgot that
this isn't a well-defined sentence with channel contexts. As soon as the
CAC operation stops, there's no way to know that we're still on the same
channel, nor do we know if we event *want to*.

So it seems you need different operations:

 1) start CAC (as today)
 2) event - CAC complete - but don't relinquish channel lock here!
 3a) abort CAC - relinquish channel lock, in case userspace no longer
     cares
 3b) start AP - which moves the channel from being CAC owned to AP owned

Note that you'd also implicitly have to call the CAC abort case (3a) in
case userspace crashes inbetween, so the netlink socket has to own this
similar to the management frame RX handling etc.

> > However, then I realised that that still doesn't work -- once initial
> > radar detection is done, it needs to continue while the AP is active. If
> > the channel context was going to be relinquished, or even just the
> > channel changed for a few seconds, it would be unsafe. So as a result,
> > the radar detect operation has to somehow be coupled to the start AP
> > operation and prohibit channel changes and additional channel contexts
> > during the entire operation time.
> >
> 
> What would be "unsafe" here if from the beginning we will allow only one 
> channel context ?

Well it seems I was a step ahead of you, I was thinking of the gap
between "CAC ended" and "start AP", see above.

johannes


