Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:65140 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0KRGOq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 01:14:46 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAI6EjWj007488
	for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 08:14:45 +0200
Subject: Re: [PATCH] wl12xx: Unset bssid filter, ssid and bssid from
 firmware on disassoc
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290058053.2522.186.camel@wimaxnb.nmp.nokia.com>
References: <1290000541-17828-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1290008460.12140.64.camel@chilepepper>
	 <1290058053.2522.186.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 08:14:16 +0200
Message-ID: <1290060856.28892.12.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 07:27 +0200, Juuso Oikarinen wrote:
> On Wed, 2010-11-17 at 17:41 +0200, Luciano Coelho wrote:
> > On Wed, 2010-11-17 at 15:29 +0200, juuso.oikarinen@nokia.com wrote:
> > > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > > 
> > > On the disassociation event from the mac80211, the wl12xx driver does not
> > > clear the chipset configuration related to the AP - i.e. it does not perform
> > > a DISCONNECT and then a JOIN with zero SSID and dummy BSSID. Also, it does not
> > > unset the BSSID filter.
> > > 
> > > Often this is not a problem, as the above is performed upon entering idle
> > > state. But if a scenario arises where a new association is attempted without
> > > cycling through idle state, the new association will fail.
> > > 
> > > Fix this by resetting the firmware state on disassociation.
> > > 
> > > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > > ---
> > >  drivers/net/wireless/wl12xx/main.c |    4 ++++
> > >  1 files changed, 4 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> > > index 31f0e2f..c523778 100644
> > > --- a/drivers/net/wireless/wl12xx/main.c
> > > +++ b/drivers/net/wireless/wl12xx/main.c
> > > @@ -2012,6 +2012,10 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
> > >  			/* Disable the keep-alive feature */
> > >  			ret = wl1271_acx_keep_alive_mode(wl, false);
> > >  
> > > +			/* restore the bssid filter and go to dummy bssid */
> > > +			wl1271_handle_idle(wl, true);
> > > +			wl1271_handle_idle(wl, false);
> > > +
> > 
> > Hmmm... This looks quite hacky.  Can 't you create functions with that
> > "restore the bssid" and "go to dummy bssid" and call them instead? If
> > you do so, you don't have to artificially go to idle and leave idle
> > immediately...
> > 
> 
> We can, but their content will be the same. Here we are not
> "artificially" entering/leaving idle, we're just performing the same
> steps towards the firmware as we would on idle entry and idle exit.
> 
> If you like, we can rename the handle_idle function to something more
> generic.

No, I meant that you could create functions with names that mirror the
things you want to do and call them here *and* in wl1271_handle_idle(),
so you won't have duplicate code and it will be quite clear what you
want to do here.  What I mean by artificially entering idle is that in
the wl1271_handle_idle() function you even set the IDLE bit and so on.
In this case you don't need that.

This is really a small thing, so I won't fight much for it, but I think
it could be clearer...

-- 
Cheers,
Luca.

