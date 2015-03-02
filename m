Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54734 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbbCBUmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 15:42:07 -0500
Date: Mon, 2 Mar 2015 21:42:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC 00/14] shrink skb cb to 44 bytes
Message-ID: <20150302204203.GD9762@breakpoint.cc> (sfid-20150302_214212_919854_22A4A738)
References: <1425318028-26531-1-git-send-email-fw@strlen.de>
 <1425325763.5130.123.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425325763.5130.123.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > remarks/known issues:
> > - adds __packet attribute to a few structures.
> >   Its needed to not have padding at end of the structure, else
> >   we get build assertion errors even if all members fit into cb[].
> > - checkpatch isn't happy yet.
> > - dccp changes are untested (its on my todo list)
> > - rxrpc change is untested (on todo list).
> > - wireless changes are untested, I don't own any of the affected hw.
> > 
> > The idea is to figure out what needs to be done to make build_skb() and
> > friends only touch the first 3 cachelines of the skb on all architectures.
> > 
> > We'd need to reduce skbuff by 40 bytes to achieve this for allyesconfig.
> > 
> > Other sk_buff reduction ideas being worked:
> > 
> > - move truesize to shinfo (which has 4 byte hole)
> > - turn ->data into offset on 64bit platforms (intrusive, > 1000 files
> >   affected)
> > - move pointers that are ususally not needed (nf_bridge, secpath) to the end,
> >   with flag field that tells us when pointer is valid (so we don't have
> >   to memset() them unconditionally at allocation time).
> > - seems we could already to this for the inner header fields since the're only
> >   valid once ->encapsulation / inner_protocol_type is set.
> > 
> > Comments and more ideas welcome.
> 
> Size of skb->cb[] is not the major factor. Trying to gain 4 or 8 bytes
> is not going to improve performance a lot.

Thats right, goal is to have build_skb etc. only touch 3 cachelines,
and have those layers that need some particular feature initialise it on
demand.

We could move skb->cb to end of skb, so that its not covered by the
initial allocation memset anymore.

Obviously that won't buy us anything at this point since gro needs
to zero it out (GRO skb cb is 48 bytes).

> The real problem is that we clear it in skb_alloc()/build_skb(), instead
> of each layer doing so at demand, and only the part that matters for
> this layer.

Thats right.  Do you think its worth to already move cb[] near the end
of skb and alter build_skb to not clear it anymore?

Which of the ideas, in your opinion, is worth pursuing first (if any)?

I'd love to get rid of nf_bridge* pointer and use percpu storage
area for it but I did not yet find a simple way to deal with when
skb that uses this percpu state leaves bridge code and is then dropped
or queued later -- we need to make sure that another skb isn't accidentally
believed to have valid nf_bridge context.

kfree_skb doesn't seem to be a nice place to add bridge crap to, and
neither is netif_rx...
