Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46576 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1CPJHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 05:07:05 -0400
Subject: Re: [PATCH] mac80211: fix aggregation frame release during timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=8th1NyjQE4zvVcS21Dba3Ku_WhnwQS0ZR9+EH@mail.gmail.com>
References: <507B31BE-2066-4434-870D-108F7DF912A6@cs.washington.edu>
	 <1300263716.3761.1.camel@jlt3.sipsolutions.net>
	 <AANLkTikir41uU_fG91w68D4JyFMPcFYKW4QFg-Ag_EUK@mail.gmail.com>
	 <1300265348.3761.3.camel@jlt3.sipsolutions.net>
	 <AANLkTi=8th1NyjQE4zvVcS21Dba3Ku_WhnwQS0ZR9+EH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 10:08:46 +0100
Message-ID: <1300266526.3761.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-16 at 02:00 -0700, Daniel Halperin wrote:

> >> The syntax I used in our private mail was confusing and I tried to
> >> simplify. Here, hyphens are just separators between frames (since R1,
> >> R2 have two-letter identifiers). Does that clear it up?
> >
> > Oh. Right. Still though, what if it is x-R1-T-R2-y-...? This fixes
> > x-T-R1-...-y-..., but shouldn't some release be possible in the other
> > case as well?
> >
> 
> Hmm -- you've got a point. That case wasn't handled by the original
> code and my change only picks up my example but not yours.

Right. I'm happy with your change anyhow, but I think I'd prefer if you
moved the skipped test to the front (i.e. skipped && time...) since it's
much cheaper. Then again I guess it doesn't really matter here...

> One fix maybe is to also store the sequence of the frame that set the
> timer when the buffer fires, and make sure to release up to that seq?
> Or maybe the reception of an earlier frame SHOULD override the the
> later frame's timeout, because it says the early part of the window is
> "still alive".

Yeah I was thinking the same a minute ago, if we get an earlier frame
then the sender is definitely still aware that we're missing something
there, so the timeout probably shouldn't hit.

> I just don't see a good way to handle all cases (e.g.,
> x-R3-R1-y-T-z-R2-w-T) without looping over the whole buffer.  (Here,
> xyzw are skipped frames and R3 was received last.)  Again, long MAC
> delays like BT could make this false, but I have to expect in most
> cases R1/2/3 will be received pretty close to when T is.

Right. Let's just leave it as is (plus your patch that we're
discussing). It's a corner case anyway, and no good throughput can be
expected from it.

Did you ever get data on the window moving thing? Like maybe in your
earlier message where you had

> enqueued frame 31
> <got compressed block-ack only missing frame 2>

I'll go to your other email now.

johannes

