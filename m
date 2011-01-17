Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:23391 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1AQGEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 01:04:37 -0500
Subject: Re: [PATCH] wl12xx: Cleanup PLT mode when module is removed
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295011013.1960.269.camel@pimenta>
References: <1295005726-10323-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1295011013.1960.269.camel@pimenta>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 08:04:29 +0200
Message-ID: <1295244269.18570.106.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-14 at 15:16 +0200, ext Luciano Coelho wrote:
> Hi Juuso,
> 
> On Fri, 2011-01-14 at 12:48 +0100, juuso.oikarinen@nokia.com wrote:
> > diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> > index 9076555..863e660 100644
> > --- a/drivers/net/wireless/wl12xx/main.c
> > +++ b/drivers/net/wireless/wl12xx/main.c
> > @@ -917,12 +917,10 @@ out:
> >  	return ret;
> >  }
> >  
> > -int wl1271_plt_stop(struct wl1271 *wl)
> > +int __wl1271_plt_stop(struct wl1271 *wl)
> >  {
> >  	int ret = 0;
> >  
> > -	mutex_lock(&wl->mutex);
> > -
> >  	wl1271_notice("power down");
> >  
> >  	if (wl->state != WL1271_STATE_PLT) {
> > @@ -938,12 +936,21 @@ int wl1271_plt_stop(struct wl1271 *wl)
> >  	wl->state = WL1271_STATE_OFF;
> >  	wl->rx_counter = 0;
> >  
> > -out:
> >  	mutex_unlock(&wl->mutex);
> > -
> >  	cancel_work_sync(&wl->irq_work);
> >  	cancel_work_sync(&wl->recovery_work);
> > +	mutex_lock(&wl->mutex);
> > +out:
> > +	return ret;
> > +}
> 
> Again we have this kind of unlock-lock case.  Wouldn't it be better to
> move the cancel_work calls outside this function and call them after
> __wl1271_plt_stop() has returned? Yeah, there will be duplicate code if
> we do this, but I think it's a bit safer, isn't it?
> 

Heh, I did consider this too. But I did come to the conclusion that in
this case it is safer to unlock/lock than to duplicate the code -
duplicating this type of code has its risks too, and in this case
nothing is actually performed after the last mutex-lock - except for
unlocking in again.

I'll change this to benefit both PoVs: I'll create a separate function
to cancel the works, and just call that function from two places. That
way, the to-be cancelled work items are in a single place.

-Juuso


