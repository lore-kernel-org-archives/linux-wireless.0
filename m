Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684Ab0BDVtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 16:49:46 -0500
Subject: Re: [PATCH] libertas: cfg80211 support
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <201002040828.14406.holgerschurig@gmail.com>
References: <20100202000934.GA19847@sortiz.org>
	 <201002031632.10425.holgerschurig@gmail.com>
	 <1265229000.21707.4.camel@localhost.localdomain>
	 <201002040828.14406.holgerschurig@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 13:49:49 -0800
Message-ID: <1265320189.4290.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-04 at 08:28 +0100, Holger Schurig wrote:
> > > I had an application running that was pinging and showed the
> > > signal level. Then I moved out-of-reach of the AP.
> > > This happened:
> > 
> > The command timeout code is just screwed all around.  We've
> > already seen that some commands just take longer than we're
> > expecting them to.  I think we should just get rid of the
> > command retry stuff completely and return EBUSY when trying to
> > submit additional commands if the firmware hasn't replied yet.
> 
> I think the same.
> 
> I think in my case --- which I haven't debugged completely 
> yet  --- user-space code was going wild. The firmware command 
> 001f (get RSSI) failed. Which is to be expected, because the 
> firmware noticed that there's no longer a connection to an AP.
> 
> However, user-space nl80211 code seems to have been buggy and 
> issued the same command in a loop. This flooded the the 
> command-execution logic in libertas, and it couldn't cope with 
> it.
> 
> AFAIK the error I had had nothing to do with the cfg80211-code 
> inside the libertas driver. Or maybe it is, I'll write a little 
> program that floods libertas via cfg80211 with commands in a 
> tight loop, let's see what happens. :-)
> 
> 
> Getting rid of the command-retry and returning an error instead 
> seems to be a sane thing.
> 
> > I don't think I've *ever* seen recovery from this situation
> > unless the firmware finally sends the command reply back, which
> > has happened in some cases with SD8686.  IMHO the command retry
> > stuff causes more problems than it's worth, given that it never
> > actually fixes anything or recovers from the timeout.
> > 
> > If the firmware is hung, the only way to get the device back is
> > to power-cycle it or possibly do a USB reset.  Retrying a
> > command just doesn't work.
> 
> In my case, I could do a "pccardctl eject" / "pccardctl insert" 
> sequence :-)   Not nice. Maybe we need a signal from 
> core-libertas to the libertas-drivers, so that they decide what 
> to do.

There should be some reset logic in there for each bus type; it was only
ever hooked up for USB because it's easy to do a USB reset.  SDIO and
SPI are somewhat harder because often it's board-specific thing.  Not
sure what to do there; we did try writing various SDIO registers that
were supposed to reset the card but that never worked.

Dan


