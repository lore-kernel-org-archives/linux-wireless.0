Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:43374 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751971AbZLRUH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 15:07:57 -0500
Message-ID: <20091218200753.30718.qmail@stuge.se>
Date: Fri, 18 Dec 2009 21:07:53 +0100
From: Peter Stuge <peter@stuge.se>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] No probe response from AP after 500ms,
	disconnecting.
References: <20091216172356.15849.qmail@stuge.se> <20091216174112.GD11461@tux> <20091216222157.28840.qmail@stuge.se> <20091216234308.GA425@tux> <20091218115708.14617.qmail@stuge.se> <20091218161854.GA6231@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091218161854.GA6231@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Thanks for the reply!


Luis R. Rodriguez wrote:
> This seems like your old comments from an old e-mail, but I guess
> you include them since you now include linux-wireless.

Yeah, I tried to summarize previous and new findings for new readers.


> > Manually disabling power management for the interface (iwconfig eth1
> > power off) makes it much more stable but I've still seen the error
> > twice. The first time after about a day and then again after a few
> > hours. I've been running with power management off since then, a
> > couple of days, so far without seeing the problem again.
> 
> Neat.

Well, I am in no way convinced that the problem is gone just because
I haven't seen it for a few days. I haven't rebooted this machine
since the last issues, only unloaded/reloaded the ath modules after
each patch/compile cycle, that might matter too..


> > I have applied these 6 patches posted by Sujith this week:
> > 
> > ath9k: Fix bug in assigning sequence number
> > ath9k: Clarify Interrupt mitigation
> > ath9k: Stop ANI when doing a reset
> > ath9k: Remove ANI lock
> > ath9k: Fix TX poll routine
> > ath9k: Fix TX queue draining

..
> > I applied the above 6 patches from Sujith. It's difficult to know if
> > I got the ones you mean without a more specific description. :)
> > 
> > The patches posted by you to linux-wireless@ on 2009-12-16 are
> > included in my wireless-testing/master kernel already:
> > 
> > ath9k: Fix TX hang poll routine
..
> > ath9k: fix processing of TX PS null data frames
..
> > ath9k: Fix maximum tx fifo settings for single stream devices
..
> > ath9k: fix tx status reporting
..
> > mac80211: Fix dynamic power save for scanning.
> 
> So these would apply to stable, but wireless-testing should have had
> these already.

Right; "are included in my wireless-testing/master kernel already"..


> > So far I have not seen the issue with PM off and 6 above patches
> > applied, that is what I am running with right now and I'll let you
> > know what happens. (With PM on the issue is still frequent.)
> 
> OK so far this narrows down to a specific AR5416 issue with PM on
> by default only.

I'm not sure about "by default". The kernel I am running has the
workaround committed which disables PM by default. If I manually
enable PM I will quickly see the issue.


> They are different hardware, newer hardware families (>= AR9280)
> are single chip and quite a few changes went into them, so thinking
> of them as equal would be wrong.

Right, no, they are certainly not equal. But parts of them are - or
maybe more importantly, parts of the driver are.


> They certain share a lot but for example the radios are completely
> different.

Yeah - I imagine there were some changes when the radios went onto
the same chip.

I don't know if this problem lies closer to RF or Linux. Can we
narrow it down somehow?


> Now sure, the issue can be the similar but it doesn't mean that it
> is not fixed for some chipsets, ignoring that would be unfair for
> those users of the newer harware families.

Oh yes - I didn't mean that progressive patches should be blocked in
any way, but just to keep an open mind until the issue is completely
solved. :)


> > > Try sucking in Sujith's recent posted patches, although none of
> > > those are PS fixes,
> > 
> > Did I get the right ones?
> 
> Those are indeed needed but Sujith posted some new patch fixes but
> not related to PS. Some of these fixes are to be merged in the next
> next 2.6.32.y so might as well go ahead and apply then if using stable
> or even wireless-testing. So no, you mised them. Here they are:
> 
> http://marc.info/?l=linux-wireless&r=3&b=200912&w=2
> 
> Patchwork has them in git am'able form:
> 
> http://patchwork.kernel.org/project/linux-wireless/list/

The latest patches from Sujith are dated 2009-12-14 and are the ANI,
TX queue, TX hang, etc patches that I listed above saying that I had
applied them. They are in my running driver.


> > > and you can also follow the instructions I gave Justin to help
> > > debug things.
> > 
> > I tried to do that already. The debug log I attached didn't have too
> > much info leading up to the disconnect though. Feel free to get the
> > longer one.
> > 
> > Is there anything else can I do?
> 
> Try with the above, although I doubt they will help AR5416.

So what could give us more information? If the debug output is not
enough I'm happy to sprinkle printks over the driver in strategic
places, but I need some hints on where to do it.

What is the general operation of the driver? (I have some experience
with writing Linux drivers so feel free to get technical.) RX
descriptors and DMA? Is beacon reception special in any way from
reception of other packets? Would it be useful to try monitor mode
with PM enabled?

I am continuously using low TX and moderate RX bandwidth (internet
radio over a TCP VPN) - would it be helpful to load the card with
exclusively unidirectional transfers such as UDP, to see if the
problem becomes more or less frequent?

Although the issue can be seen as missing beacons maybe it is a
general problem with RX that is only visible in the log when the time
comes to expect a beacon?


Where to look further?


//Peter
