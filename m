Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbXD0OxY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 10:53:24 -0400
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
From: Dan Williams <dcbw@redhat.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070427164208.25434f11@griffin.suse.cz>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <200704251634.16604.flamingice@sourmilk.net>
	 <46312067.9090005@linux.intel.com>
	 <200704262023.52833.flamingice@sourmilk.net>
	 <1177684132.21025.36.camel@localhost.localdomain>
	 <20070427164208.25434f11@griffin.suse.cz>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 10:56:33 -0400
Message-Id: <1177685793.21025.52.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-04-27 at 16:42 +0200, Jiri Benc wrote:
> On Fri, 27 Apr 2007 10:28:52 -0400, Dan Williams wrote:
> > We shouldn't be ignoring discrete hardware functionality just because
> > it's in the firmware and also may be in the stack.  Hardware crypto like
> > somebody mentioned.  TCP offload.  etc.  Not allowing a driver writer to
> > take advantage of hardware functionality is quite short-sighted.  Having
> > a pure host-CPU software stack is not utopia; it's entirely unrealistic
> > for a variety of reasons, some of which are below [1].
> 
> I'm not saying no (see my other mail in this thread), I see some
> reasons myself, but I don't think your reasons are valid.

My point is that things are not black and white.  It's not fullmac vs.
softmac, there's a spectrum of parts in between.  I'm not advocating
making mac80211 work with every part under the sun, but it seems that
we're not being open enough to functionality that might be in hardware.
Holding a 100% software line with mac80211 is just IMHO wrong and
short-sighted.  The stack needs to be flexible WRT to the hardware
capabilities of the parts that we expect to use it.  Saying no to
hardware scanning just because it can also be done in software too is
wrong.

We're not trying to limit the capabilities of hardware artificially, but
at the same time we're not going to allow crackpot hardware stuff to
clutter up the stack.  Hardware scan is far from crackpot hardware
stuff; it's a simple, discrete function that shouldn't be hard work
with.  It's already in, right?  Ripping it out for a 100% software
agenda is wrong.  Let's take out crypto offload then too if we're going
to take a consistently 100% software line.  Again, it's not either
software or hardware; it's a spectrum of capabilities and we shouldn't
be making the stack _less_ flexible.

Dan

> > 1) power-critical situations like embedded devices where some pieces
> > must be offloaded to the wireless part
> 
> Such solutions will use fullmac. See e.g. OLPC.
> 
> > 2) lower-speed devices that may not have cycles to burn on functions
> > that the hardware can also do, even if most of the stack is software
> 
> Such solutions have no other way than using fullmac.
> 
> > 3) timing critical functions
> 
> Such as? Scanning? That's not timing critical at all. Or something
> other?
> 
> > 4) hybrid parts that are mostly softmac (ipw2100, ipw2200)
> 
> Supporting of halfmacs in a softmac stack is hardly possible. You can
> write something like a "halfsoftmac" but you need to do that for each
> such chipset again. Because (by definition) every halfmac chipset needs
> a different set of functionality from the stack.
> 
> > 5) we don't make hardware
> 
> But we are also not required to support every obscure feature of the
> hardware.
> 
> Thanks,
> 
>  Jiri
> 

