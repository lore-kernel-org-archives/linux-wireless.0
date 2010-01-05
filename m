Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35676 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab0AESFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:05:43 -0500
Date: Tue, 5 Jan 2010 19:45:12 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] mac80211: Select lowest rate based on basic rate
 set in AP mode
Message-ID: <20100105174512.GA12811@jm.kir.nu>
References: <20091229105919.GB18493@jm.kir.nu>
 <1262683770.20098.12.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1262683770.20098.12.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2010 at 10:29:30AM +0100, Johannes Berg wrote:
> On Tue, 2009-12-29 at 12:59 +0200, Jouni Malinen wrote:
> > +	if (basic_rates & (1 << *idx))
> > +		return; /* selected rate is a basic rate */
> > +
> > +	for (i = *idx + 1; i <= max_rate_idx; i++) {
> 
> Starting at *idx+1 only works because it's always 0 or something?

i = *idx case is covered above and this loop is just run if the selected
rate was not a basic rate. And yes, we only pick the lowest rate
currently.

> Wouldn't you want to go down from max_rate and find the highest basic
> rate or so?

That would change behavior in potentially harmful ways, i.e., we could
end up picking up too high a rate and some of the associated STAs might
not be close enough to receive the frames. This is really something that
requires much more care and should be done by the rate control algorithm
itself (e.g., check that all associated STAs are currently using a rate
higher than whatever we could pick for multicast/broadcast).

The goal of this new code is to just enforce the must-use-basic-rate
policy for multicast/broadcast frames. Picking the lowest available
options sounds like the safest bet here.

> Other than that seems fine to me, except I'm not sure I like the
> "txrc.ap" thing much, but it's probably a reasonable choice to make at
> this point (but consider mesh, IBSS?)

Cannot really say that I would like it much either, but I did not even
want to think about IBSS rules for basic rates, never mind mesh ;-).
This can obviously be changed in the future once it is clear that we
are configuring the basic_rates value properly for other modes.

-- 
Jouni Malinen                                            PGP id EFC895FA
