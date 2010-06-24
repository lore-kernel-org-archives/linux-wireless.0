Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59200 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab0FXRN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 13:13:57 -0400
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
From: reinette chatre <reinette.chatre@intel.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C2383E2.8000909@gmail.com>
References: <4C198EF0.5080807@gmail.com>
	 <1277225293.25793.2257.camel@rchatre-DESK>  <4C2383E2.8000909@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 10:13:56 -0700
Message-ID: <1277399636.25793.2389.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Richard,

On Thu, 2010-06-24 at 09:12 -0700, Richard Farina wrote:
> reinette chatre wrote:
> > On Wed, 2010-06-16 at 19:56 -0700, Richard Farina wrote:
> >   
> >> The repeated line appears ad infinitum filling my dmesg buffer.  This of 
> >> hangcheck timer seem to trigger with every large file transfer on my 
> >> intel 5100.  What would you like me to do to provide a more useful 
> >> output as this is currently extremely easy to reproduce.  Kernel 2.6.34 
> >> using compat-wireless stable 2.6.35-rc2
> >>
> >> Thanks,
> >> Rick Farina
> >>
> >> phy0: failed to reallocate TX buffer
> >> phy0: failed to reallocate TX buffer
> >> phy0: failed to reallocate TX buffer
> >> phy0: failed to reallocate TX buffer
> >> phy0: failed to reallocate TX buffer
> >> phy0: failed to reallocate TX buffer
> >> phy0: failed to reallocate TX buffer
> >>     
> >
> > First mac80211 runs out of memory ... it cannot even allocate enough
> > memory for a skb header.
> >
> >   
> >> net_ratelimit: 22 callbacks suppressed
> >> __alloc_pages_slowpath: 3799 callbacks suppressed
> >> swapper: page allocation failure. order:1, mode:0x4020
> >> Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
> >> Call Trace:
> >>  <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
> >>  [<ffffffff816732e9>] ? skb_release_data+0xc4/0xc9
> >>  [<ffffffffa04701e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
> >>     
> >
> > Next driver runs out of memory.
> >
> > Note that the above are all atomic allocations that fail and should be
> > able to recover. 
> >
> > Is your system low on memory? Are you running applications that take a
> > lot of memory? Does your wifi connection drop or otherwise suffer at the
> > time you see these messages?
> >
> >   
> I have 4GB of RAM on this system, I often run a VM which wastes like 
> half that but that still leaves 2GB for linux and I'm running XFCE4 so 
> not exactly a memory hog. It's possible that firefox leaks ram until I'm 
> out but that would be a LOT of leak, much more than I usually see.

There has been an issue with atomic memory allocations ever since
2.6.31. This used to be easy to trigger with iwlagn, but we fixed a
number of issues. There are still issue with any atomic memory
allocation (not just iwlagn) and this issue is still open. You can find
more information at https://bugzilla.kernel.org/show_bug.cgi?id=14141

> Yeah, as you may guess these errors cause my wifi connection to slow 
> drastically.

The driver, when unable to allocate memory atomically, will reattempt
the allocation later when it can use GFP_KERNEL. I think there may be
ways in which we can try to optimize this since right now it will only
schedule this when there are about 8 buffers remaining. I was looking at
your trace again and even though you state "Kernel 2.6.34 using
compat-wireless stable 2.6.35-rc2" ... the trace you provide does not
seem to match the driver code from 2.6.35-rc2. Could you please confirm
which version of driver you are running so that I can prepare a patch?

>  If I had to guess, since this happens when I make a large 
> file transfer it is likely that something related is leaking RAM.  I'm 
> using wget or axel to download and NFS to dump the files on a NAS.  I'll 
> try to trigger this again

Does this happen every time you run this test? I would like to get an
idea whether we will get a clear indication whether our changes will
help or not.

>  and watch memory usage to see if I can find 
> something other than the driver that could be leaking.  Failing that, 
> what do I need to enable to find a leak in the driver?

Perhaps kmemleak?

Reinette



