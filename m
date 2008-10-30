Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:40365 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbYJ3PmX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:42:23 -0400
Date: Thu, 30 Oct 2008 17:41:23 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 5/5] mac80211_hwsim: Make sure beacon_timer gets
	deleted
Message-ID: <20081030154123.GB3923@jm.kir.nu> (sfid-20081030_164228_528130_E8127B13)
References: <20081030145920.233178987@localhost> <20081030150254.961883544@localhost> <1225379320.3690.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225379320.3690.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 04:08:40PM +0100, Johannes Berg wrote:
> On Thu, 2008-10-30 at 16:59 +0200, Jouni Malinen wrote:
> > Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
> > @@ -290,6 +290,7 @@
> >  {
> >  	struct mac80211_hwsim_data *data = hw->priv;
> >  	data->started = 0;
> > +	del_timer(&data->beacon_timer);
> 
> should that be del_timer_sync, just in case? Not sure how that works
> with the rearming thing, I never really understood rearming timers.

No idea.. I have to admit I don't care that much in this particular
case (hwsim is a test driver), but if someone can explain how this is
supposed to be done properly, I would be happy to fix this ;-).

That started=0 will prevent future timer handlers from using add_timer,
but a currently running handler may miss that and as such,
del_timer_sync() might not be enough. I would assume calling
del_timer_sync() here twice would take care of that corner case, but
that looks somewhat funny.

John, can you at least apply the first four patches from this series? I
would be fine with getting the fifth one in as-is, too, since it does at
least make it quite a bit less likely to hit the kernel panic. We can
then update this if someone can tell what the recommended way of killing
this type of timer is.

-- 
Jouni Malinen                                            PGP id EFC895FA
