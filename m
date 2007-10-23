Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57360
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbXJWBPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 21:15:09 -0400
Date: Mon, 22 Oct 2007 18:15:30 -0700 (PDT)
Message-Id: <20071022.181530.28790082.davem@davemloft.net> (sfid-20071023_021515_883496_E9810441)
To: drzeus@drzeus.cx
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: [PATCH] libertas: make if_sdio align packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071022190532.5077ce3d@poseidon.drzeus.cx>
References: <20071022190532.5077ce3d@poseidon.drzeus.cx>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pierre Ossman <drzeus@drzeus.cx>
Date: Mon, 22 Oct 2007 19:05:32 +0200

> +	/*
> +	 * The IP stack is littered with silly assumptions on alignment,
> +	 * so we need to do a bit of layering violation here and make
> +	 * assumptions about the size of the headers between us and the
> +	 * IP stack.
> +	 */
> +	skb_reserve(skb, NET_IP_ALIGN);
> +

Please remove this comment.

Where else could we possibly ensure that post-link-level headers are
aligned properly, taking into account DMA engine restrictions and
whatnot, other than in the driver itself?

It's not about IP, even though the macro has "IP" in it's name.  It's
meant to ensure reasonable alignment after the link-level header,
regardless of upper-level protocol.  So your layering violation
commentary is simply rediculious and frankly starting to annoy the
crap out of me.

As you were also shown, all of THIS is fully documented in a huge
comment above the definition of NET_IP_ALIGN.

The irony in all of this is that NET_IP_ALIGN is in fact fully
documented even in books such as O'Reilly's Understanding Linux
Network Internals.  See chapter 10, sub-section 4.

The skb_reserve() sequence that was so terribly difficult for you to
discover is used in just about every network driver, and even used in
the drivers/net/pci-skeleton.c, a skeleton PCI ethernet driver that is
there exactly to show people how to do things properly.  It uses the
constant '2' instead of NET_IP_ALIGN, which should obviously be
corrected.

All of your complaining is simply because you didn't put much
effort into looking around to see what the existing practice
was and therefore you got surprising results.  We have nearly
a hundred ethernet drivers you could have studied to see how
things are supposed to be done.

I'm sorry for flaming you so much, but you are showing zero respect
for existing practice in the kernel networking and you behave as if
you're the only person in the world who has to deal with these issues.
You accuse us openly of mis-architecting the Linux networking with
these so-called "layering violations" and having maintained the stack
for more than 10 years I start to take things like that quite
personally.
