Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:6410 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab0BDH3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 02:29:50 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: cfg80211 support
Date: Thu, 4 Feb 2010 08:28:14 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Samuel Ortiz <sameo@linux.intel.com>
References: <20100202000934.GA19847@sortiz.org> <201002031632.10425.holgerschurig@gmail.com> <1265229000.21707.4.camel@localhost.localdomain>
In-Reply-To: <1265229000.21707.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002040828.14406.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I had an application running that was pinging and showed the
> > signal level. Then I moved out-of-reach of the AP.
> > This happened:
> 
> The command timeout code is just screwed all around.  We've
> already seen that some commands just take longer than we're
> expecting them to.  I think we should just get rid of the
> command retry stuff completely and return EBUSY when trying to
> submit additional commands if the firmware hasn't replied yet.

I think the same.

I think in my case --- which I haven't debugged completely 
yet  --- user-space code was going wild. The firmware command 
001f (get RSSI) failed. Which is to be expected, because the 
firmware noticed that there's no longer a connection to an AP.

However, user-space nl80211 code seems to have been buggy and 
issued the same command in a loop. This flooded the the 
command-execution logic in libertas, and it couldn't cope with 
it.

AFAIK the error I had had nothing to do with the cfg80211-code 
inside the libertas driver. Or maybe it is, I'll write a little 
program that floods libertas via cfg80211 with commands in a 
tight loop, let's see what happens. :-)


Getting rid of the command-retry and returning an error instead 
seems to be a sane thing.

> I don't think I've *ever* seen recovery from this situation
> unless the firmware finally sends the command reply back, which
> has happened in some cases with SD8686.  IMHO the command retry
> stuff causes more problems than it's worth, given that it never
> actually fixes anything or recovers from the timeout.
> 
> If the firmware is hung, the only way to get the device back is
> to power-cycle it or possibly do a USB reset.  Retrying a
> command just doesn't work.

In my case, I could do a "pccardctl eject" / "pccardctl insert" 
sequence :-)   Not nice. Maybe we need a signal from 
core-libertas to the libertas-drivers, so that they decide what 
to do.

-- 
http://www.holgerschurig.de
