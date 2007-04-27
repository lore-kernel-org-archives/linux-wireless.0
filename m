Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbXD0OZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 10:25:44 -0400
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <200704262023.52833.flamingice@sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <200704251634.16604.flamingice@sourmilk.net>
	 <46312067.9090005@linux.intel.com>
	 <200704262023.52833.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 10:28:52 -0400
Message-Id: <1177684132.21025.36.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-04-26 at 20:23 -0400, Michael Wu wrote: 
> On Thursday 26 April 2007 17:57, James Ketrenos wrote:
> > With a penalty to battery life and an increase in the amount of time a scan
> > takes.  There are improvements that can be made to make the software
> > scanning faster, but at a penalty of added complexity on both the driver
> > and the stack side -- for no *real* gain for users that have cards that can
> > offload the scan.
> >
> Sure there is. Smaller firmware means firmware that's less likely to 
> malfunction, which seems to be an issue. I don't see what you're saying about 
> added complexity on the driver side. Eliminating the hw_scan callback reduces 
> driver complexity. The increase in complexity on the stack side is offset by 
> the fact that no driver/firmware/hardware needs to implement their own clever 
> scanning algorithm.

If it's done right, it doesn't increase stack/driver complexity at all.
Obviously not everything can/should be done in software on the host CPU.
We all disliked Intel's binary regulatory daemon, and now that it's back
in firmware we're all happy.  That's reality.

We shouldn't be ignoring discrete hardware functionality just because
it's in the firmware and also may be in the stack.  Hardware crypto like
somebody mentioned.  TCP offload.  etc.  Not allowing a driver writer to
take advantage of hardware functionality is quite short-sighted.  Having
a pure host-CPU software stack is not utopia; it's entirely unrealistic
for a variety of reasons, some of which are below [1].

Obviously somebody needs to figure out why software scan is so slow.
Scan time matters; it should be as fast as possible without sacrificing
correctness or regulatory safety.  But that doesn't mean dismissing
hardware scan just because it can also be done in the stack.

Let's be clear.  Is mac80211 (a) _the_ Linux wireless stack that
non-fullmac vendors should target so Linux has a consistent wireless
story?  Or is it (b) a pure software stack for only thin parts like
Atheros and everyone who doesn't have hardware exactly like Atheros can
just go away and play somewhere else?  If it's (a), then we shouldn't be
saying no to James.  If it's (b), then why aren't we doing (a) instead?

Dan

1) power-critical situations like embedded devices where some pieces
must be offloaded to the wireless part

2) lower-speed devices that may not have cycles to burn on functions
that the hardware can also do, even if most of the stack is software

3) timing critical functions

4) hybrid parts that are mostly softmac (ipw2100, ipw2200)

5) we don't make hardware

> > > the use of the hw_scan callback breaks the AP autoconfiguration code
> > > in ieee80211_sta.c due to its inadequate design.
> >
> > Is it breaking it just due to the auto-configuration code not knowing when
> > to configure things?
> >
> Yes, because ..
> 
> > > Calling hw_scan starts a
> > > hardware scan, but there is no way to know when the scan is completed.
> >
> > That needs to be improved.
> >
> This is exactly the issue.
> 
> > > Even if that problem were addressed, I still wouldn't like it as the
> > > design of the hw_scan callback is deficient in a number of other ways and
> > > is completely inapplicable to all other hardware/firmware softmac designs
> > > that I know.
> >
> > Given that there are things we can do as a result of the hw_scan that we
> > can't do on the host without imposing greater system load and slower scan
> > results, I really don't want to lose the ability to support hardware
> > offloading of scanning.
> >
> How fast is hardware scanning? What part of software scanning is slowing 
> things down? What's the big bottleneck that justifies moving this to 
> hardware? Are you sure it cannot be eliminated? Why haven't any other vendors 
> chosen to offload scanning like this?
> 
> > Could you voice some of the "other ways" the current hw_scan callback is
> > deficient?
> >
> Sure. In addition to not being able to find out when the scan is completed..
> 
> - There is no way to specify what channels to scan.
> - There is no way to specify a passive scan.
> - The probe frame that is used is fixed with the exception of the SSID.
> - There is no corresponding interface for the userspace MLME.
> 
> This isn't very important, however. I am more interested in what problems in 
> software scanning need to be solved by moving to hardware scanning.
> 
> > I'm fine with us overhauling how hw_scan works and integrates with the
> > stack, but an all out ban on hardware scan offload just doesn't make sense.
> >  The host can do all RC4 and AES encrypt/decrypt too but certainly we would
> > prefer the hardware to do that for us, right?
> >
> The host can do TCP/IP too but certainly we would prefer the hardware to do 
> that for us, right?
> 
> Well, referring to TOE is unfair, but it makes the point that only some things 
> make sense in hardware. Softmac is the result of removing the things that 
> don't.
> 
> > In the short term, I would rather we leave hw_scan in the code and have the
> > users that currently rely on hw_scan just have to manually configure the AP
> > selection until such time as the in-kernel-AP-selection-policy code works
> > with hw offloaded scan.
> >
> What incentive does that give to fix the code? Leaving broken things in for 
> the sake of out-of-tree drivers does not appeal to me.
> 
> -Michael Wu

