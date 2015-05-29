Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37854 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbbE2LRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:17:07 -0400
Message-ID: <1432898224.2104.12.camel@sipsolutions.net> (sfid-20150529_131712_553518_EB3074C9)
Subject: Re: [PATCH RFC next 2/2] net: rfkill: gpio: simplify code flow
From: Johannes Berg <johannes@sipsolutions.net>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: linux-wireless@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 29 May 2015 13:17:04 +0200
In-Reply-To: <1432806373-17372-3-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1432806373-17372-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1432806373-17372-3-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-28 at 11:46 +0200, Uwe Kleine-König wrote:
> When assigning directly to the pointer contained in the driver data the
> local variable can be dropped together with the extra assignment to it.

I'm not really sure I see the big benefit of this? It doesn't really
seem to make the code much easier to read/follow.

I also don't really see the (perceived) objection with "dynamic memory"
though since that memory is freed pretty much immediately as soon as we
return a non-zero value from this function ... the function itself
allocates the memory, and clearly we return without it ever being able
to use it, so ...

Anyway - I might apply this for the few removed lines of code, but only
with a better commit log.

johannes

