Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42339
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934248AbXC1LAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 07:00:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rx racing against removing interfaces?
Date: Wed, 28 Mar 2007 12:59:55 +0200
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1174950322.25887.59.camel@johannes.berg> <200703281252.23834.mb@bu3sch.de>
In-Reply-To: <200703281252.23834.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703281259.55764.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 March 2007 12:52, Michael Buesch wrote:
> On Tuesday 27 March 2007 01:05, Johannes Berg wrote:
> > Isn't there a race there when you remove interfaces and at the same time
> > __ieee80211_rx is running? I don't see anything that should stop that,
> > and if it happens we'll probably blow up pretty spectacularly with
> > accesses to a freed netdev, or even sending it frames...
> 
> Well, IMHO __ieee80211_rx should be internal to mac80211 and not be exported.
> (Same goes for the IRQ-unsafe txstatus report). We can't (and we really don't
> want to) call synchronously into the stack from any driver. We want to
> defer the packet processing work to a tasklet. So we always want to
> call the _irqsafe functions. Why do we? Because of locking issues.
> 1) There's no need to hold the lowlevel driver IRQ spinlock while
> processing the packet in the upper layers. We want to release it. Easiest
> and non-racy way to do this is to use the _irqsafe function and its tasklet.
> 2) We want to prevent recursion back into the driver through a callback,
> which would result in lock recursion (we had these problems in softmac, as
> it is synchronous in most rx parts).
> 
> So why do I tell you this?
> I think there's no way we can call __ieee80211_rx after removing the
> interface, as the tasklet should be stopped first. But someone should
> verify if I'm right here.
> But anyway, the driver shouldn't be able to call __ieee80211_rx after the
> device is down, too, as the driver has to make sure IRQs are stopped
> when the device is brought down.
> 
> So we have kind of implicit locking here, but I think it's ok.


Oh, you mean virtual interfaces.. yeah, there's probably a race. I don't
know the locking there.
But my comment about the non-irqsafe-variants-should-be-hidden still applies :)

-- 
Greetings Michael.
