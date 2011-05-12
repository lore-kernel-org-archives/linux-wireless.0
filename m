Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab1ELTwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 15:52:31 -0400
Subject: Re: [PATCH 4/7] wl12xx: prevent scheduling while suspending (WoW
 enabled)
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1305229737.12586.1027.camel@cumari> (sfid-20110512_214911_703763_A3F7A170)
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
	 <1305104068-32240-5-git-send-email-eliad@wizery.com>
	 <1305229737.12586.1027.camel@cumari> (sfid-20110512_214911_703763_A3F7A170)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 21:52:29 +0200
Message-ID: <1305229949.3461.41.camel@jlt3.sipsolutions.net> (sfid-20110512_215234_600979_4D3E7AFE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-12 at 22:48 +0300, Luciano Coelho wrote:

> > diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> > index 9ca71ce..308855a 100644
> > --- a/drivers/net/wireless/wl12xx/main.c
> > +++ b/drivers/net/wireless/wl12xx/main.c
> > @@ -1338,6 +1338,28 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
> >  	struct wl1271 *wl = hw->priv;
> >  	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
> >  	wl->wow_enabled = !!wow;
> > +	if (wl->wow_enabled) {
> > +		/* flush any remaining work */
> > +		wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
> > +		flush_delayed_work(&wl->scan_complete_work);
> > +
> > +		/*
> > +		 * disable and re-enable interrupts in order to flush
> > +		 * the threaded_irq
> > +		 */
> > +		wl1271_disable_interrupts(wl);
> > +
> > +		/*
> > +		 * set suspended flag to avoid triggering a new threaded_irq
> > +		 * work. no need for spinlock as interrupts are disabled.
> > +		 */
> > +		set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
> 
> The set_bit() function is atomic, so you wouldn't need the spinlock here
> anyway.  Couldn't you use __set_bit() instead, to avoid the expense of
> using an atomic function when it's not necessary?

That's only possible if the spinlock is held for all modifications of
the variable. If there are any modifications that don't hold it, then
you need the atomic version.

johannes

