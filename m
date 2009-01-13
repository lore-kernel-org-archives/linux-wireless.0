Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63745 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbZAMRpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 12:45:50 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 09:45:50 -0800
Date: Tue, 13 Jan 2009 09:45:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hugh Dickins <hugh@veritas.com>
CC: Bob Copeland <me@bobcopeland.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"Bradley M. Kuhn" <bkuhn@ebb.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Message-ID: <20090113174525.GQ4416@tesla> (sfid-20090113_184556_571374_AACF0A75)
References: <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com> <Pine.LNX.4.64.0901081740350.19523@blonde.anvils> <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com> <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com> <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet> <20090110201547.GA11261@hash.localnet> <Pine.LNX.4.64.0901131509080.9571@blonde.anvils> <20090113154204.M52697@bobcopeland.com> <Pine.LNX.4.64.0901131636190.23199@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <Pine.LNX.4.64.0901131636190.23199@blonde.anvils>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 08:40:21AM -0800, Hugh Dickins wrote:
> On Tue, 13 Jan 2009, Bob Copeland wrote:
> > On Tue, 13 Jan 2009 15:35:29 +0000 (GMT), Hugh Dickins wrote
> >
> > I'll go ahead and push this upstream then today or tomorrow;
> 
> Great, thanks - should include a Cc: stable@kernel.org I think.
> 
> > let me know if you run into any problems with more testing.
> 
> Sure, will do.
> 
> > > > Changes-licensed-under: 3-Clause-BSD
> > >
> > > Hmm, I haven't noticed anyone doing that before: hope you're not
> > > starting a trend!  I think you'll find (Documentation/SubmittingPatches)
> > > that your Signed-off-by agrees to the Developer's Certificate of Origin
> > > 1.1, which would put your patch under the same open source licence(s) as
> > > drivers/net/wireless/ath5k/base.c already contains - that's the usual
> > > case.
> >
> > I agree with all of the above, but the SFLC suggests we do it anyway.

Lets not open a can a worms here, but I just want to clarify a few things.

To be fair, as stated before, SFLC suggested we just ensure people are aware of
the licenses involved and in order to keep files under permissive licenses we
just need a way to ensure the contributors are actually submitting their changes
under the file's specified license.

We did review Documentation/SubmittingPatches but this was deemed not
sufficient as from what I recall you cannot gaurantee all contributors
would have read that and understood clearly what is implied under this
discussion.

The Changes-licensed-under tag was just my own suggestion to the problem
to help the BSD family and that did suffice the legal criteria so we went
with it.

> > http://kerneltrap.org/Linux/Wireless_Project_Suggests_Changes-licensed-under_Tag
> 
> Interesting, thanks a lot for the pointer.
> I agree very much with Steve and Krzysztof.
> 
> I'd be inclined to think that adding such a line in some patches
> would only tend towards making those which omit such a line more
> questionable for use under the BSD licence i.e. would weaken the
> BSD position rather than strengthening it as intended - though
> the Signed-off-by should override even that tendency.

You just need to ensure your contributors have read and understood
Documentation/SubmittingPatches.

> But it's certainly not an issue for my attention!

For ath9k we've taken a bit different approach, and I should note SFLC was
not involved with this, we tend to ensure wireless contributors and
developers have read the "Developer's Certificate of Origin 1.1" and any
new contributors get an e-mail from us asking them to read it [1]. This
also proves a bit difficult as some seasoned developers take offense to
such e-mails while some new developers speculate to our intentions and
may develop crazy conspiracy theories.

http://lkml.org/lkml/2008/11/25/289

  Luis
