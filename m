Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36217 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbZAYM57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 07:57:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [PATCH] b43: Accessing the TSF via mac80211
Date: Sun, 25 Jan 2009 13:57:04 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
References: <20090125124151.115210@gmx.net> <200901251351.50230.mb@bu3sch.de> <200901251355.49220.mb@bu3sch.de>
In-Reply-To: <200901251355.49220.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901251357.05020.mb@bu3sch.de> (sfid-20090125_135802_111962_D36DBF75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 25 January 2009 13:55:49 Michael Buesch wrote:
> On Sunday 25 January 2009 13:51:50 Michael Buesch wrote:
> > On Sunday 25 January 2009 13:41:51 Alina Friedrichsen wrote:
> > > This allows the mac80211 high level code to access the TSF. This is e.g. needed for BSSID merges in the IBSS mode.
> > 
> > Thanks, can you also remove our private debugfs hook?
> > 
> > > Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> > > ---
> > > diff -urN wireless-testing.orig/drivers/net/wireless/b43/main.c wireless-testing/drivers/net/wireless/b43/main.c
> > > --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-01-25 06:12:13.000000000 +0100
> > > +++ wireless-testing/drivers/net/wireless/b43/main.c	2009-01-25 13:09:35.000000000 +0100
> > > @@ -3177,6 +3177,25 @@
> > >  	return 0;
> > >  }
> > >  
> > > +static u64 b43_op_get_tsf(struct ieee80211_hw *hw)
> > > +{
> > > +	struct b43_wl *wl = hw_to_b43_wl(hw);
> > > +	struct b43_wldev *dev = wl->current_dev;
> > > +	u64 tsf;
> > > +
> > 
> > You must add a check and locking here.
> > 
> > 	if (dev && (b43_status(dev) >= B43_STAT_INITIALIZED)) {
> > 		mutex_lock(&wl->mutex);
> > 		spin_lock_irq(&wl->irq_lock);
> > 
> > > +	b43_tsf_read(dev, &tsf);
> > 
> > 		spin_unlock_irq(&wl->irq_lock);
> > 		mutex_unlock(&wl->mutex);
> > 	} else
> > 		tsf = 0; //FIXME what to do on error?
> > 
> > > +	return tsf;
> > > +}
> 
> Whoops, I got it wrong :D
> This is what it should look like:
> 
> static u64 b43_op_get_tsf(struct ieee80211_hw *hw)
> {
>        struct b43_wl *wl = hw_to_b43_wl(hw);
>        struct b43_wldev *dev = wl->current_dev;
>        u64 tsf;
> 
> 	mutex_lock(&wl->mutex);
> 	spin_lock_irq(&wl->irq_lock);
> 	if (dev && (b43_status(dev) >= B43_STAT_INITIALIZED))
> 		b43_tsf_read(dev, &tsf);
> 	else
> 		tsf = 0;//FIXME? what to do on error?
> 	spin_unlock_irq(&wl->irq_lock);
> 	mutex_unlock(&wl->mutex);
> 
>        return tsf;
> }
> 

Damn, I'm not awake, yet.
The   dev = wl->current_dev   also must be inside of the mutex.

-- 
Greetings, Michael.
