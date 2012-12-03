Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45083 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab2LCOBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 09:01:39 -0500
Date: Mon, 3 Dec 2012 08:46:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@adurom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless: allow Atheros card to not depend on ath.ko
Message-ID: <20121203134643.GA26027@tuxdriver.com> (sfid-20121203_150157_972441_1A31D4E2)
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <20121128141319.GA9118@tuxdriver.com>
 <1967408.WlU5HIbjCs@lx-vladimir>
 <2070615.GY0XtkW6tW@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2070615.GY0XtkW6tW@lx-vladimir>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's in wireless-next ATM...

commit 23c1d7f65975762386760e36c00f149059e537e2
Author: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date:   Wed Nov 28 18:57:19 2012 +0200

    wireless: allow Atheros card to not depend on ath.ko
    
    There are 2 different things:
    - sub-menu for "Atheros Wireless cards" family
    - module ath.ko with common Atheros code
    
    Until now, they both used to depend on the same Kconfig variable ATH_COMMON.
    Thus, being "Atheros card" and "depending on ath.ko" was the same.
    
    To allow module to belong to the
    "Atheros Wireless cards" family but not use ath.ko,
    2 conditions above need to be separated.
    
    So, this patch introduce new Kconfig variable ATH_CARDS for belonging
    to the "Atheros Wireless Cards" family; while ATH_COMMON becomes hidden
    variable to express dependency on common Atheros code in ath.ko. Modules
    that depend on this common code now express it by setting ATH_COMMON.
    
    Right now, ath6kl do not depend on common code and thus do not set ATH_COMMON.
    
    Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

On Mon, Dec 03, 2012 at 03:03:00PM +0200, Vladimir Kondratiev wrote:
> Hi,
> 
> Any input?
> 
> Luis: does it reflect reality with Atheros drivers dependency now?
> 
> Thanks, Vladimir
> 
> On Wednesday, November 28, 2012 06:57:19 PM Vladimir Kondratiev wrote:
> > 
> > There are 2 different things:
> > - sub-menu for "Atheros Wireless cards" family
> > - module ath.ko with common Atheros code
> > 
> > Until now, they both used to depend on the same Kconfig variable ATH_COMMON.
> > Thus, being "Atheros card" and "depending on ath.ko" was the same.
> > 
> > To allow module to belong to the
> > "Atheros Wireless cards" family but not use ath.ko,
> > 2 conditions above need to be separated.
> > 
> > So, this patch introduce new Kconfig variable ATH_CARDS for belonging
> > to the "Atheros Wireless Cards" family; while ATH_COMMON becomes hidden
> > variable to express dependency on common Atheros code in ath.ko. Modules
> > that depend on this common code now express it by setting ATH_COMMON.
> > 
> > Right now, ath6kl do not depend on common code and thus do not set ATH_COMMON.
> > 
> > Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/Kconfig          |    7 +++++--
> >  drivers/net/wireless/ath/ar5523/Kconfig   |    1 +
> >  drivers/net/wireless/ath/ath5k/Kconfig    |    1 +
> >  drivers/net/wireless/ath/ath9k/Kconfig    |    1 +
> >  drivers/net/wireless/ath/carl9170/Kconfig |    1 +
> >  5 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/Kconfig 
> > b/drivers/net/wireless/ath/Kconfig
> > index c25dcf1..1a67a4f 100644
> > --- a/drivers/net/wireless/ath/Kconfig
> > +++ b/drivers/net/wireless/ath/Kconfig
> > @@ -1,4 +1,7 @@
> > -menuconfig ATH_COMMON
> > +config ATH_COMMON
> > +	tristate
> > +
> > +menuconfig ATH_CARDS
> >  	tristate "Atheros Wireless Cards"
> >  	depends on CFG80211 && (!UML || BROKEN)
> >  	---help---
> > @@ -14,7 +17,7 @@ menuconfig ATH_COMMON
> >  
> >  	  http://wireless.kernel.org/en/users/Drivers/Atheros
> >  
> > -if ATH_COMMON
> > +if ATH_CARDS
> >  
> >  config ATH_DEBUG
> >  	bool "Atheros wireless debugging"
> > diff --git a/drivers/net/wireless/ath/ar5523/Kconfig 
> > b/drivers/net/wireless/ath/ar5523/Kconfig
> > index 11d99ee..0d320cc 100644
> > --- a/drivers/net/wireless/ath/ar5523/Kconfig
> > +++ b/drivers/net/wireless/ath/ar5523/Kconfig
> > @@ -1,6 +1,7 @@
> >  config AR5523
> >         tristate "Atheros AR5523 wireless driver support"
> >         depends on MAC80211 && USB
> > +       select ATH_COMMON
> >         select FW_LOADER
> >         ---help---
> >           This module add support for AR5523 based USB dongles such as D-Link
> > diff --git a/drivers/net/wireless/ath/ath5k/Kconfig 
> > b/drivers/net/wireless/ath/ath5k/Kconfig
> > index 338c5c4..c9f81a3 100644
> > --- a/drivers/net/wireless/ath/ath5k/Kconfig
> > +++ b/drivers/net/wireless/ath/ath5k/Kconfig
> > @@ -1,6 +1,7 @@
> >  config ATH5K
> >  	tristate "Atheros 5xxx wireless cards support"
> >  	depends on (PCI || ATHEROS_AR231X) && MAC80211
> > +	select ATH_COMMON
> >  	select MAC80211_LEDS
> >  	select LEDS_CLASS
> >  	select NEW_LEDS
> > diff --git a/drivers/net/wireless/ath/ath9k/Kconfig 
> > b/drivers/net/wireless/ath/ath9k/Kconfig
> > index c7aa664..5fc15bf 100644
> > --- a/drivers/net/wireless/ath/ath9k/Kconfig
> > +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> > @@ -17,6 +17,7 @@ config ATH9K_BTCOEX_SUPPORT
> >  config ATH9K
> >  	tristate "Atheros 802.11n wireless cards support"
> >  	depends on MAC80211
> > +	select ATH_COMMON
> >  	select ATH9K_HW
> >  	select MAC80211_LEDS
> >  	select LEDS_CLASS
> > diff --git a/drivers/net/wireless/ath/carl9170/Kconfig 
> > b/drivers/net/wireless/ath/carl9170/Kconfig
> > index 267d5dc..13a2045 100644
> > --- a/drivers/net/wireless/ath/carl9170/Kconfig
> > +++ b/drivers/net/wireless/ath/carl9170/Kconfig
> > @@ -1,6 +1,7 @@
> >  config CARL9170
> >  	tristate "Linux Community AR9170 802.11n USB support"
> >  	depends on USB && MAC80211 && EXPERIMENTAL
> > +	select ATH_COMMON
> >  	select FW_LOADER
> >  	select CRC32
> >  	help
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
