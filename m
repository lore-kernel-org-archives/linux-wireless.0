Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:34385 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751412AbXLUVAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 16:00:51 -0500
Date: Fri, 21 Dec 2007 21:57:58 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	sam <sam@ravnborg.org>, Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
Message-ID: <20071221215758.4f962a39@morte> (sfid-20071221_210054_825614_75E999FE)
In-Reply-To: <1198269816.16241.82.camel@johannes.berg>
References: <1198253375.16241.76.camel@johannes.berg>
	<20071221210017.36f34fe3@morte>
	<1198269816.16241.82.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Dec 2007 21:43:36 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> > What about avoiding to force any algorithm to y, and instead always build a
> > dummy (a few lines of code which would just set the rate to the lowest
> > available) rate control algorithm into mac80211?
> 
> Why?

I think that rc80211-simple is broken. A user may just want not to have a
real rate control algorithm (i.e. no need for rates above the lowest one or
certainty of perfect signal). Currently, that user would choose
rc80211-simple, I guess, and well, this is almost fine, as he could
manually set a rate. But let's say it's an embedded device, and small
footprint is a must. Why would he need to use any RC algorithm (even other
than rc80211-simple, as your Kconfig changes allow for this) then? mac80211
currently fails if no RC algorithms are available. So, I'd say, let's fix
mac80211, so that it can work without any RC algorithm. And the default in
this case could just be to set the lowest rate. That's what I called a
dummy RC algorithm.


--
Ciao
Stefano
