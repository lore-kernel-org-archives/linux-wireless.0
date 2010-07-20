Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2943 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab0GTOvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 10:51:21 -0400
Date: Tue, 20 Jul 2010 10:52:00 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH/RFC 3/3] ath5k: trace resets
Message-ID: <20100720145200.GB7049@hash.localnet>
References: <1279395336-856-1-git-send-email-me@bobcopeland.com> <1279395336-856-4-git-send-email-me@bobcopeland.com> <201007201420.49305.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201007201420.49305.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 20, 2010 at 02:20:49PM +0900, Bruno Randolf wrote:
> > @@ -931,6 +930,7 @@ ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done,
> >  void
> >  ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
> >  {
> > +#if 0

(The above, by the way, is a mistake I'll fix; I forgot to remove it after
doing patch 1/3.)

> again, here my same concerns: printing the reasons for resets is something 
> which is useful on embedded boards and production setups which can't have 
> tracing enabled. which is why i want to object against this change!

What Johannes said wrt performance: during tracing, only the binary
representations of the data are written to the trace ring buffer, so
unlike the current debug code, we aren't doing printk formatting until
the trace buffer is read.  You can save the raw binary data from the
trace and do formatting on another machine.

Another advantage is better granularity: if you only care about watching
tx on the cab queue, you can dynamically filter based on the tracepoint
arguments, something like:

  # echo "qnum == 6" > /debug/tracing/events/ath5k/ath5k_tx/filter

With the debug printks, you have to hack the driver or grep and hope
the printk buffer didn't overflow and spill what you were looking for.

One thing I do need to look into is reducing the size, right now
text size went up by about 4k when adding these tracepoints.

> also adding a reason argument to the reset function just for tracing seems to 
> be... umm... not so nice... couldn't you add the tracepoints before? 

Yeah, it's kind of hacky, but not without precedent; ieee80211_wake_queues
does something similar.  But I'm not tied to it, adding another tracepoint
for when and why the reset was scheduled would be OK, or maybe we just
drop the reason and plan on using ftrace to figure that out.  It's still
worth keeping tracepoints when reset actually runs and finishes since that
is the most useful information for tracking down race conditions.

> and: didn't we want to split channel change out of reset anyhow?

Of course.  When we do so we probably won't need the frequency argument,
but I think that's otherwise orthogonal to this...

-- 
Bob Copeland %% www.bobcopeland.com

