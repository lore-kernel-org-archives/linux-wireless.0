Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da02.ext.nokia.com ([147.243.128.26]:47632 "EHLO
	mgw-da02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1AQG0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 01:26:43 -0500
Subject: Re: [PATCH] wl12xx: Cleanup PLT mode when module is removed
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295244269.18570.106.camel@wimaxnb.nmp.nokia.com>
References: <1295005726-10323-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1295011013.1960.269.camel@pimenta>
	 <1295244269.18570.106.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 08:26:34 +0200
Message-ID: <1295245594.18570.119.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 08:04 +0200, ext Juuso Oikarinen wrote:
> On Fri, 2011-01-14 at 15:16 +0200, ext Luciano Coelho wrote:
> > Hi Juuso,
> > 
> > On Fri, 2011-01-14 at 12:48 +0100, juuso.oikarinen@nokia.com wrote:
> > > diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> > > index 9076555..863e660 100644
> > > --- a/drivers/net/wireless/wl12xx/main.c
> > > +++ b/drivers/net/wireless/wl12xx/main.c
> > > @@ -917,12 +917,10 @@ out:
> > >  	return ret;
> > >  }


> > 
> > Again we have this kind of unlock-lock case.  Wouldn't it be better to
> > move the cancel_work calls outside this function and call them after
> > __wl1271_plt_stop() has returned? Yeah, there will be duplicate code if
> > we do this, but I think it's a bit safer, isn't it?
> > 
> 
> Heh, I did consider this too. But I did come to the conclusion that in
> this case it is safer to unlock/lock than to duplicate the code -
> duplicating this type of code has its risks too, and in this case
> nothing is actually performed after the last mutex-lock - except for
> unlocking in again.
> 
> I'll change this to benefit both PoVs: I'll create a separate function
> to cancel the works, and just call that function from two places. That
> way, the to-be cancelled work items are in a single place.
> 

And then I realise we can't easily do that. In the typical case (user
space stops plt mode) there is no work after the last mutex lock, but in
this module-removal scenario there is.

To solve that, we'd have to extend the knowledge about the plt mode onto
the bus specific modules (sdio/spi) because they call the wl12xx
unregister_hw function with the mutex already held.

So in essence, I would like to keep the current patch :o

-Juuso

