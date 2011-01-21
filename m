Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab1AUVzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:55:06 -0500
Subject: Re: [PATCH 3/3] libertas_spi: Add support for suspend/resume
From: Dan Williams <dcbw@redhat.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
Date: Fri, 21 Jan 2011 15:55:49 -0600
In-Reply-To: <201101212327.22127.anarsoul@gmail.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
	 <1295642690-16646-4-git-send-email-anarsoul@gmail.com>
	 <201101212225.02775.marek.vasut@gmail.com>
	 <201101212327.22127.anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1295646950.1473.4.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-21 at 23:27 +0200, Vasily Khoruzhick wrote:
> On Friday 21 January 2011 23:25:02 Marek Vasut wrote:
> > On Friday 21 January 2011 21:44:50 Vasily Khoruzhick wrote:
> > > Add support for suspend/resume in if_spi.
> > 
> > Isn't there some pin to put the card asleep ? I think these LBS ones have
> > it.
> 
> Is there datasheet on these cards?

Not really, no.  With SPI and SDIO a lot of the suspend/resume handling
depends on how you wire up the card, and what you do with the SD
controller.  Often this stuff is connected to some GPIO, and that gets
handled via the platform stuff, not libertas directly (otherwise we'd
have libertas littered with board-specific code).

> > Also, do you need to do this via workqueue ? Can't you just do it in the
> > resume handler?
> 
> Hmm, is it OK to request firmware if userspace is not ready yet?

Maybe, but not safely. There's always been problems with this and the
typical thing to do is cache the firmware so you *know* you can reload
it no matter what, even before userspace has mounted the disks or
whatever.  But given that SPI is used on mainly resource-constrained
platforms, and that the libertas firmware is ~100K, that might not be
desirable.  

Dan

> > Cheers
> 
> Regards
> Vasily
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


