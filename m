Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:39545 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0KWFvW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 00:51:22 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAN5onef028810
	for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 07:51:19 +0200
Subject: Re: [PATCH] wl12xx: Fix kernel crash related to hw recovery and
 interface shutdown
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290430346.3322.4.camel@chilepepper>
References: <1290086342-12015-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1290430346.3322.4.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 07:51:10 +0200
Message-ID: <1290491470.4284.9.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-22 at 14:52 +0200, Luciano Coelho wrote:
> On Thu, 2010-11-18 at 15:19 +0200, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > It is possible that the op_remove_interface function  is invoked exactly at
> > the same time has hw recovery is started. In this case it is possible for the
> > interface to be already removed in the op_remove_interface call, which
> > currently leads to a kernel warning and a subsequent kernel crash.
> > 
> > Fix this by ignoring the op_remove_interface call if the interface is already
> > down at that point.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> 
> [...]
> 
> > diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> > index 31f0e2f..11b0477 100644
> > --- a/drivers/net/wireless/wl12xx/main.c
> > +++ b/drivers/net/wireless/wl12xx/main.c
> > @@ -1157,10 +1157,16 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
> >  	struct wl1271 *wl = hw->priv;
> >  
> >  	mutex_lock(&wl->mutex);
> > -	WARN_ON(wl->vif != vif);
> > -	__wl1271_op_remove_interface(wl);
> > -	mutex_unlock(&wl->mutex);
> > +	/*
> > +	 * wl->vif can be null here if someone shuts down the interface
> > +	 * just when hardware recovery has been started.
> > +	 */
> > +	if (wl->vif) {
> > +		WARN_ON(wl->vif != vif);
> > +		__wl1271_op_remove_interface(wl);
> > +	}
> 
> Should you still remove the interface if the vif you received is wrong?
> Surely, something is totally wrong if you get a different vif, but maybe
> removing the interface here will just confuse things even more?

Dunno if it would be better to remove or leave unremoved - probably does
not matter. If the vif is wrong, there is some serious bug somewhere,
and probably the result is serious instability anyway.

The WARN_ON is there just to validate the assumption the driver makes
about the vif, and this function call. If there is a bug somewhere, or
the assumption somehow changes, the warning will be a clear indication
of it.

-Juuso

>  
> > +	mutex_unlock(&wl->mutex);
> >  	cancel_work_sync(&wl->recovery_work);
> >  }
> >  
> 
> 


