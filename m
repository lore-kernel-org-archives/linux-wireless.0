Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4399 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193AbXD0UWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:22:11 -0400
Date: Fri, 27 Apr 2007 15:52:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: Dan Williams <dcbw@redhat.com>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070427195249.GB6431@tuxdriver.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704251634.16604.flamingice@sourmilk.net> <46312067.9090005@linux.intel.com> <200704262023.52833.flamingice@sourmilk.net> <1177684132.21025.36.camel@localhost.localdomain> <20070427164208.25434f11@griffin.suse.cz> <1177685793.21025.52.camel@localhost.localdomain> <20070427172004.32b7bf4a@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070427172004.32b7bf4a@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 27, 2007 at 05:20:04PM +0200, Jiri Benc wrote:
> On Fri, 27 Apr 2007 10:56:33 -0400, Dan Williams wrote:
> > My point is that things are not black and white.  It's not fullmac vs.
> > softmac, there's a spectrum of parts in between.  I'm not advocating
> > making mac80211 work with every part under the sun, but it seems that
> > we're not being open enough to functionality that might be in hardware.
> > Holding a 100% software line with mac80211 is just IMHO wrong and
> > short-sighted.  The stack needs to be flexible WRT to the hardware
> > capabilities of the parts that we expect to use it.  Saying no to
> > hardware scanning just because it can also be done in software too is
> > wrong.
> 
> Agreed.
 
Ditto.

> > We're not trying to limit the capabilities of hardware artificially, but
> > at the same time we're not going to allow crackpot hardware stuff to
> > clutter up the stack.  Hardware scan is far from crackpot hardware
> > stuff; it's a simple, discrete function that shouldn't be hard work
> > with.  It's already in, right?  Ripping it out for a 100% software
> > agenda is wrong.  Let's take out crypto offload then too if we're going
> > to take a consistently 100% software line.  Again, it's not either
> > software or hardware; it's a spectrum of capabilities and we shouldn't
> > be making the stack _less_ flexible.
> 
> The problem is that Michael during fixing of the stack for mainline
> inclusion encountered a problem with the current implementation of the
> hw scanning. We need to fix that problem.
> 
> The proposed solution (removing of the hw_scan callback) obviously
> fixes the problem. Now, let's find something that fixes the problem as
> well but doesn't remove the functionality. James already proposed a
> solution that could work if a support for user space MLME is added. Do
> you have an idea how to add it?

I just want to chime-in here in concurrence with Dan and Jiri.  I think
it makes sense to allow the stack to take advantage of reasonable
features offered by the hardware (or firmware).  If supporting
such features requires the addition and support of reams of code or
awkward algorithms, then that support will be rejected or will at
least require strong justification backed by real numbers.  If such
support requires minimal changes, then we will rely on our judgment
and whatever data is readily available -- the same as always.

I am definitely _not_ interested in conducting some witch hunt to
enforce a "software only" design purity.  And it troubles me that
Intel seems to have been singled-out as some sort of bad actor in this
thread.  I hope that I am misreading some of those remarks.

John
-- 
John W. Linville
linville@tuxdriver.com
