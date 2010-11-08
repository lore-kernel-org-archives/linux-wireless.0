Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:63923 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0KHPTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 10:19:50 -0500
Date: Mon, 8 Nov 2010 07:19:40 -0800
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH 3/3] wl1251: use wl12xx_platform_data to pass data
Message-ID: <20101108151939.GG9264@atomide.com>
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
 <1288822429-24541-4-git-send-email-notasas@gmail.com>
 <874obtzauz.fsf@purkki.adurom.net>
 <1289207688.8423.14.camel@chilepepper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1289207688.8423.14.camel@chilepepper>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Luciano Coelho <luciano.coelho@nokia.com> [101108 01:05]:
> On Sun, 2010-11-07 at 11:28 +0100, ext Kalle Valo wrote:
> > Grazvydas Ignotas <notasas@gmail.com> writes:
> > 
> > > Make use the newly added method to pass platform data for wl1251 too.
> > > This allows to eliminate some redundant code.
> > >
> > > Cc: Tony Lindgren <tony@atomide.com>
> > > Cc: Ohad Ben-Cohen <ohad@wizery.com>
> > > Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> > 
> > For the wl1251 part:
> > 
> > Acked-by: Kalle Valo <kvalo@adurom.com>
> > 
> > > ---
> > > This touches arch/arm/mach-omap2/* but I think it should go through
> > > the wireless tree to avoid cross-tree dependencies, if Tony and others
> > > are ok with this.
> > 
> > I agree, better to push this through the wireless tree.
> > 
> > >  arch/arm/mach-omap2/board-omap3pandora.c |   32 +++++++-------------------
> > >  drivers/net/wireless/wl1251/sdio.c       |   35 +----------------------------
> > >  drivers/net/wireless/wl12xx/Kconfig      |    2 +-
> > 
> > We need to CC Luciano for the wl12xx change.
> > 
> > > --- a/drivers/net/wireless/wl12xx/Kconfig
> > > +++ b/drivers/net/wireless/wl12xx/Kconfig
> > > @@ -42,5 +42,5 @@ config WL1271_SDIO
> > >  
> > >  config WL12XX_PLATFORM_DATA
> > >  	bool
> > > -	depends on WL1271_SDIO != n
> > > +	depends on WL1271_SDIO != n || WL1251_SDIO != n
> > >  	default y
> > 
> > Oh, I didn't take this into account when I moved wl1251 out from the
> > wl12xx directory. Now wl1251 has a dependency to wl12xx stuff. 
> > 
> > Oh well, it's a small issue. I guess we can live with that :)
> 
> Yeah, I didn't realize this either.  I think we can live with that, but
> at some point we should clean this up and either have separate platform
> data for wl1251 and wl12xx or move the the platform data one level up,
> to wireless.  But for now:
> 
> Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
> 
> And I agree with pushing this through wireless-testing as well, if it's
> okay with Tony and John.

Yes, ack from me too:

Acked-by: Tony Lindgren <tony@atomide.com>
