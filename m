Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbXEBMHe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 08:07:34 -0400
Subject: Re: [PATCH] libertas: fix for wireless Kconfig changes
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: jeff@garzik.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20070501135454.GD8604@tuxdriver.com>
References: <20070429002844.GA11225@tuxdriver.com>
	 <1178020418.21671.3.camel@localhost.localdomain>
	 <20070501135454.GD8604@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 08:10:55 -0400
Message-Id: <1178107855.31220.21.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-05-01 at 09:54 -0400, John W. Linville wrote:
> On Tue, May 01, 2007 at 07:53:38AM -0400, Dan Williams wrote:
> > On Sat, 2007-04-28 at 20:28 -0400, John W. Linville wrote:
> > > Need to change the libertas Kconfig entry to match changes made for
> > > other wireless drivers.
> > > 
> > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > > ---
> > > diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> > > index c4b3dc2..cb09e6b 100644
> > > --- a/drivers/net/wireless/Kconfig
> > > +++ b/drivers/net/wireless/Kconfig
> > > @@ -267,7 +267,7 @@ config IPW2200_DEBUG
> > >  
> > >  config LIBERTAS_USB
> > >  	tristate "Marvell Libertas 8388 802.11a/b/g cards"
> > > -	depends on NET_RADIO && USB
> > > +	depends on USB && WLAN_80211
> > >  	select FW_LOADER
> > >  	---help---
> > >  	  A driver for Marvell Libertas 8388 USB devices.
> > 
> > Will apply, we need to pull in wireless-dev first to get the NET_RADIO
> > name change.
> 
> No, that is already in Linus' tree via Jeff's tree.
> 
> Jeff, I figured you would just apply the patch.  If you'd prefer I
> can send a pull request, but I don't have anything else pending ATM.

Really?  Marcelo said he pulled 2.6.21 into the libertas tree but that
didn't appear to touch drivers/net/wireless/Kconfig at all...

Dan


