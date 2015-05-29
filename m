Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49412 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbbE2Mmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 08:42:32 -0400
Date: Fri, 29 May 2015 14:42:30 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH RFC next 2/2] net: rfkill: gpio: simplify code flow
Message-ID: <20150529124230.GJ18985@pengutronix.de> (sfid-20150529_144236_117524_D7D74FFE)
References: <1432806373-17372-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1432806373-17372-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1432898224.2104.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1432898224.2104.12.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 29, 2015 at 01:17:04PM +0200, Johannes Berg wrote:
> On Thu, 2015-05-28 at 11:46 +0200, Uwe Kleine-König wrote:
> > When assigning directly to the pointer contained in the driver data the
> > local variable can be dropped together with the extra assignment to it.
> 
> I'm not really sure I see the big benefit of this? It doesn't really
> seem to make the code much easier to read/follow.
> 
> I also don't really see the (perceived) objection with "dynamic memory"
> though since that memory is freed pretty much immediately as soon as we
> return a non-zero value from this function ... the function itself
> allocates the memory, and clearly we return without it ever being able
> to use it, so ...
> 
> Anyway - I might apply this for the few removed lines of code, but only
> with a better commit log.
Alternatively squash it into patch 1/2 and add:

	While touching the code simplify it a bit to not need a local
	variable for the gpio descriptors.

?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
