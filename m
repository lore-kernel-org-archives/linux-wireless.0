Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:57619 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbYJKAtV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:49:21 -0400
Date: Sat, 11 Oct 2008 03:48:28 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix scan RX processing oops
Message-ID: <20081011004828.GB15802@jm.kir.nu> (sfid-20081011_024924_605990_BE25AF16)
References: <20081011002955.GA15802@jm.kir.nu> <1223685486.29811.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223685486.29811.17.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 11, 2008 at 02:38:06AM +0200, Johannes Berg wrote:
> > -	ieee80211_rx_bss_put(sdata->local, bss);
> > +	if (bss)
> > +		ieee80211_rx_bss_put(sdata->local, bss);
> 
> I keep falling into that trap, maybe the put function should just handle
> NULL instead...

I though about that for half a second or so ;-) and ended up doing this
instead after checking that other ieee80211_rx_bss_put() calls were only
passing in non-NULL values. Anyway, I would be fine with _put() being
able to handle NULL, too.


PS.

I don't know what exactly was triggering this oops (or well, what was
triggering ieee80211_bss_info_update() to return NULL to be more exact),
but it was happening very consistently in our office (but not anywhere
else I've been this week). It was kind of funny to see that oops at the
very moment when I was convincing people in a meeting that we can change
mac80211 and should do so if it is the best location for something and
makes it easier to implement something in a driver.. ;-)

-- 
Jouni Malinen                                            PGP id EFC895FA
