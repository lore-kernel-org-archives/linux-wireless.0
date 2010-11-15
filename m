Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64684 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab0KOQhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 11:37:06 -0500
Received: by wyb28 with SMTP id 28so4584836wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 08:37:04 -0800 (PST)
From: Florian Fainelli <florian@openwrt.org>
To: Wojciech Dubowik <dubowoj@neratec.com>
Subject: Re: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
Date: Mon, 15 Nov 2010 17:37:13 +0100
Cc: Bob Copeland <me@bobcopeland.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
References: <9968918.321289836178712.JavaMail.wlan@CHBU500181>
In-Reply-To: <9968918.321289836178712.JavaMail.wlan@CHBU500181>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011151737.13737.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 November 2010 16:49:47 Wojciech Dubowik wrote:
> > On Mon, Nov 15, 2010 at 02:16:06PM +0100, Wojciech Dubowik wrote:
> > > What about such changes compared to original patch? It's then
> > 
> > possible to
> > 
> > > compile both modules at the same time. Of course linking won't work
> > 
> > because
> > 
> > > I would need to separate functions like in ath9k.
> > 
> > Is there a plan to add a config entry for ATHEROS_AR231X (or did
> > I miss it?)  Someone will one day run their Kconfig checker and
> > report it missing.
> 
> Openwrt has whole implementation but I have no idea why it's not
> in the official kernel.
> 
> Actually the same applies to ath9k because ATHEROS_AR71XX definition
> needed for AHB is not specified in latest kernel.
> http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg03660.html

Support for Atheros AR71xx chips has been submitted for review a couple of 
days ago: http://www.linux-mips.org/archives/linux-mips/2010-11/msg00085.html

the Kconfig symbol name should be changed accordingly when the patches are 
accepted.

> 
> > > --- a/drivers/net/wireless/ath/ath5k/Kconfig
> > > +++ b/drivers/net/wireless/ath/ath5k/Kconfig
> > > @@ -1,9 +1,11 @@
> > > 
> > >  config ATH5K
> > >  
> > >         tristate "Atheros 5xxx wireless cards support"
> > > 
> > > -       depends on PCI && MAC80211
> > > +       depends on (PCI || ATHEROS_AR231X) && MAC80211
> > > 
> > >         select MAC80211_LEDS
> > >         select LEDS_CLASS
> > >         select NEW_LEDS
> > > 
> > > +       select ATH5K_AHB if ATHEROS_AR231X
> > > +       select ATH5K_PCI if PCI
> > 
> > I like this better, but there probably needs to be a mutual
> > exclusion so that randconfig builds don't break.  Then you don't
> > get to build both still, but the resulting Makefile is a bit more
> > normal.  And then if someone shows up saying that they really do
> > have some AR231X device with PCI, then it's more obvious what they
> > need to do to fix it (i.e. separate bus interfaces from core).
> > 
> > Something like?
> > select ATH5K_PCI if (PCI && !ATHEROS_AR231X)
> > or
> > depends on ((PCI && !ATHEROS_AR231X) || (!PCI && ATHEROS_AR231X)) ...
> 
> I will make it exclusive and post in the the series if there are
> no more comments.
> 
> Wojtek
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
