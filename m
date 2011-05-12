Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43071 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab1ELUJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 16:09:19 -0400
Received: by mail-ey0-f178.google.com with SMTP id 25so628398eya.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 13:09:18 -0700 (PDT)
Subject: Re: [PATCH 4/7] wl12xx: prevent scheduling while suspending (WoW
 enabled)
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1305229949.3461.41.camel@jlt3.sipsolutions.net>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
	 <1305104068-32240-5-git-send-email-eliad@wizery.com>
	 <1305229737.12586.1027.camel@cumari>
	 (sfid-20110512_214911_703763_A3F7A170)  <1305229949.3461.41.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 23:09:15 +0300
Message-ID: <1305230955.12586.1037.camel@cumari> (sfid-20110512_220923_163174_AA4D8C09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-12 at 21:52 +0200, Johannes Berg wrote:
> On Thu, 2011-05-12 at 22:48 +0300, Luciano Coelho wrote:
> 
> > > diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> > > index 9ca71ce..308855a 100644
> > > --- a/drivers/net/wireless/wl12xx/main.c
> > > +++ b/drivers/net/wireless/wl12xx/main.c
> > > @@ -1338,6 +1338,28 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
> > >  	struct wl1271 *wl = hw->priv;
> > >  	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
> > >  	wl->wow_enabled = !!wow;
> > > +	if (wl->wow_enabled) {
> > > +		/* flush any remaining work */
> > > +		wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
> > > +		flush_delayed_work(&wl->scan_complete_work);
> > > +
> > > +		/*
> > > +		 * disable and re-enable interrupts in order to flush
> > > +		 * the threaded_irq
> > > +		 */
> > > +		wl1271_disable_interrupts(wl);
> > > +
> > > +		/*
> > > +		 * set suspended flag to avoid triggering a new threaded_irq
> > > +		 * work. no need for spinlock as interrupts are disabled.
> > > +		 */
> > > +		set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
> > 
> > The set_bit() function is atomic, so you wouldn't need the spinlock here
> > anyway.  Couldn't you use __set_bit() instead, to avoid the expense of
> > using an atomic function when it's not necessary?
> 
> That's only possible if the spinlock is held for all modifications of
> the variable. If there are any modifications that don't hold it, then
> you need the atomic version.

Ah, you're right.   wl->flags is being modified in other places too (ie.
other bits are being set/cleared in other parts of the code), so there
could be some conflicts.  I had just considered the flag as an
independent boolean, which it obviously isn't.

My next comment about changing to __set_bit() can also be disregarded.

-- 
Cheers,
Luca.

