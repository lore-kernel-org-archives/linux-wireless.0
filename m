Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969AbXD0SGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 14:06:03 -0400
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
From: Dan Williams <dcbw@redhat.com>
To: Andy Green <andy@warmcat.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <463213D7.9070604@warmcat.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <200704251634.16604.flamingice@sourmilk.net>
	 <46312067.9090005@linux.intel.com>
	 <200704262023.52833.flamingice@sourmilk.net>
	 <1177684132.21025.36.camel@localhost.localdomain>
	 <20070427164208.25434f11@griffin.suse.cz>
	 <1177685793.21025.52.camel@localhost.localdomain>
	 <463213D7.9070604@warmcat.com>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 14:09:19 -0400
Message-Id: <1177697359.30796.19.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-04-27 at 16:16 +0100, Andy Green wrote:
> Dan Williams wrote:
> 
> > we're not being open enough to functionality that might be in hardware.
> > Holding a 100% software line with mac80211 is just IMHO wrong and
> > short-sighted.  The stack needs to be flexible WRT to the hardware
> 
> Yeah but this isn't "in hardware" -- it's in firmware: software that

I know that.  But to the driver, it might as well be in hardware.  The
driver and stack doesn't care where the functionality lives (silicon or
firmware) as long as the firmware does what's needed.

> runs of a different, vendor-specific, CPU.  Let's not talk about magic
> and impressive "hardware" when the truth is we only talk about the same
> software action on another CPU.  The problems with this particular
> offload to firmware:
> 
>  - it is vendor-specific

So is everything a driver does because the vendors make the hardware and
firmware.  We never get anywhere by being vendor-hostile.  We also never
get anywhere by kissing vendor ass.  We need to toe a line in between.

>  - it is not time-critical.  In fact it just sits there for tens of ms.
>  The extra us lost going through mac80211 when it wants to change the
> frequency should not be measurable.  It's not like it is some special
> DSP in there that is computing PI faster than the main CPU in the box
> can.  It is just changing the frequency now and then, which can
> perfectly well be done in the stack

I'm using hw_scan as a vehicle for my larger point.  But the point is
still valid even if hw_scan is not time critical.

>  - it is not exploitable in other ways.  If we want to talk about
> "short-sighted", let's talk about managing what can be very generic RF
> hardware in a way that can never do anything but IEEE802.11a/b/g actions

We can't and shouldn't try to coerce every piece of hardware into a 100%
userspace-controllable SDR.  While that would pretty much solve all
_our_ problems (but not everyone else's), it's a pipe-dream and
unrealistic.

> > capabilities of the parts that we expect to use it.  Saying no to
> > hardware scanning just because it can also be done in software too is
> > wrong.
> 
> To be clear, this isn't a "hardware" action, just an opaque software API
> specific to that chipset, and that runs on a CPU in the chipset.
> 
> > with.  It's already in, right?  Ripping it out for a 100% software
> > agenda is wrong.  Let's take out crypto offload then too if we're going
> 
> The iwlwifi proposal is for an opaque vendor-specific firmware API, that
> is also "100% software".  Don't get confused by the bogus magic alleged
> "hardware" nomenclature.

I've been burned by wifi firmware/hardware a lot in the past.  All
firmware is a black box API.  But the reality of life is that we're not
going to open all vendor firmware overnight, and I can't actually think
of any vendor that provides the source and build tools for their
firmware.  That's a reality we have to deal with.  We can and should
encourage openness; but hostility gets us nowhere.

Just because it's a black box _doesn't_ mean we make it impossible to
utilize specific features that some hardware has, like crypto offload or
hwscan.  _That's_ the short-sighted part.  We need to keep flexibility
in the stack to make this sort of thing possible and let people
experiment with it.

Dan

> > to take a consistently 100% software line.  Again, it's not either
> > software or hardware; it's a spectrum of capabilities and we shouldn't
> > be making the stack _less_ flexible.
> 
> Yeah let's make the stack completely flexible and either keep control of
> the scan action in the stack, or eventually move it to usermode, in both
> cases doing the scan action well ONCE for ALL drivers.
> 
> -Andy

