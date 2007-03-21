Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45567
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbXCUQSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 12:18:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Change radio_init2050 to match specs
Date: Wed, 21 Mar 2007 17:17:52 +0100
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Joseph Jezak <josejx@gentoo.org>
References: <460048f1.Sz+VinhM/N8KG294%Larry.Finger@lwfinger.net> <200703211501.48178.mb@bu3sch.de> <46014F75.7080609@lwfinger.net>
In-Reply-To: <46014F75.7080609@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200703211717.53055.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 March 2007 16:29, Larry Finger wrote:
> Michael Buesch wrote:
> > On Tuesday 20 March 2007 21:49, Larry Finger wrote:
> >> The code in the mac80211 version of radio_init2050 differs from the specs
> >> in two places.
> >>
> >> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >> ---
> >>
> >> Index: wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> >> ===================================================================
> >> --- wireless-mb.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> >> +++ wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> >> @@ -3444,9 +3444,9 @@ static u16 radio2050_rfover_val(struct b
> >>  			if (phy_register == BCM43xx_PHY_RFOVER) {
> >>  				return 0x9B3;
> >>  			} else if (phy_register == BCM43xx_PHY_RFOVERVAL) {
> >> -				extlna |= (i << 8);
> >>  				if (extlna)
> >>  					extlna |= 0x8000;
> >> +				extlna |= (i << 8);
> > 
> > What's the difference?
> 
> The nonzero test for extlna should be made on the table value, not the table value or'd with i << 8.

Eh, wait.
The spec is not clear (at least to me) on this point:

# OR the loop position value left shifted by 8 with the External LNA Control Value
# If the External LNA Value isn't 0
   1. OR the value with 0x8000 
# OR this value with the table values below which are marked with Yes

>From my understanding current code is correct.
But I see that one could interpret the spec in your way as well.
Joseph?

-- 
Greetings Michael.
