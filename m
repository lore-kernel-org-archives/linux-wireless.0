Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49575 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421AbXLPWcm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:32:42 -0500
Subject: Re: b43 problem with led trigger registration
From: Richard Purdie <rpurdie@openedhand.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1197843464.6769.43.camel@johannes.berg>
References: <1197822019.4138.2.camel@johannes.berg>
	 <1197837505.6769.25.camel@johannes.berg>
	 <1197837799.4653.21.camel@localhost.localdomain>
	 <200712162157.00759.mb@bu3sch.de>
	 <1197842962.4653.27.camel@localhost.localdomain>
	 <1197843464.6769.43.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 22:32:39 +0000
Message-Id: <1197844359.4653.39.camel@localhost.localdomain> (sfid-20071216_223245_378640_2B2DA91C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-12-16 at 23:17 +0100, Johannes Berg wrote:
> > Eeek, yes, its the LED core's fault.
> > dc47206e552c0850ad11f7e9a1fca0a3c92f5d65 is needed for various reasons
> > but that means the patch below is also needed. Its been compile tested,
> > once its runtime tested I'll push asap.
> 
> Any reason you're using an rw semaphore rather than a simple mutex?
> Nothing here is a hot-path, is it, and the led registrations are
> mutually exclusive anyway, no?

With a rw lock, the for loop of the trigger registration can happen in
parallel with other trigger registrations. This case isn't a hot path as
such but it keeps consistent style with other parts of the LED core
where rw locks are used in hot paths.

It could be replaced with a mutex instead though...

Richard


