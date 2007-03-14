Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:51766 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030658AbXCNGpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 02:45:43 -0400
Date: Wed, 14 Mar 2007 07:41:18 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFT] [PATCH] bcm43xx: ACI fixes
Message-ID: <20070314074118.466bb9f0@localhost>
In-Reply-To: <45F78498.8080608@lwfinger.net>
References: <20070312010420.353a59c0@localhost>
	<45F78498.8080608@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 14 Mar 2007 00:14:00 -0500
Larry Finger <larry.finger@lwfinger.net> wrote:

> Stefano,
> 
> As noted earlier on the list, I have started testing this patch. In
> setting the various interference modes, I have found some bugs in other
> places that were not previously tested. Thanks for this contribution.
> 
> I have some comments below.
> 
> Stefano Brivio wrote:
> > Please test the following patch. It syncs ACI (Adjacent Channels
> > Interference) code to specs. I can't test it right now. Will port to
> > mac80211 branch ASAP.
> > 
> > 
> > Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> > ----
> > 
> > diff --git a/drivers/net/wireless/bcm43xx/bcm43xx.h
> > b/drivers/net/wireless/bcm43xx/bcm43xx.h index 95ff175..7023327 100644
> > --- a/drivers/net/wireless/bcm43xx/bcm43xx.h
> > +++ b/drivers/net/wireless/bcm43xx/bcm43xx.h
> > @@ -398,6 +398,9 @@
> >  #define BCM43xx_DEFAULT_SHORT_RETRY_LIMIT	7
> >  #define BCM43xx_DEFAULT_LONG_RETRY_LIMIT	4
> >  
> > +/* Statscounter offsets. */
> > +#define BCM43xx_SC_ACI		0x2E
> > +
> >  /* FIXME: the next line is a guess as to what the maximum RSSI value
> > might be */ #define RX_RSSI_MAX				60
> >  
> > @@ -550,7 +553,11 @@ struct bcm43xx_phyinfo {
> >  	u8 connected:1,
> >  	   calibrated:1,
> >  	   is_locked:1, /* used in bcm43xx_phy_{un}lock() */
> > -	   dyn_tssi_tbl:1; /* used in
> > bcm43xx_phy_init_tssi2dbm_table() */
> > +	   dyn_tssi_tbl:1, /* used in
> > bcm43xx_phy_init_tssi2dbm_table() */
> > +	   g_interfmode:1; /* bit 4000 in PHY_G_CRS, used in periodic
> > tasks */
> > +	u8 g_interfmode_timer; /* how much time ago g_interfmode was
> > unset */
> > +	u16 g_sc_saved; /* used in periodic tasks for ACI */
> > +
> >  	/* LO Measurement Data.
> >  	 * Use bcm43xx_get_lopair() to get a value.
> >  	 */
> > @@ -629,7 +636,9 @@ struct bcm43xx_radioinfo {
> >  	/* ACI (adjacent channel interference) flags. */
> >  	u8 aci_enable:1,
> >  	   aci_wlan_automatic:1,
> > -	   aci_hw_rssi:1;
> > +	   aci_hw_rssi:1,
> > +	   aci_delay:5;
> Should this be a bit field? Why not just make it a u8?

We only need 5 bits, as aci_delay will never be > 20.

> > +	u8 aci_start;
> >  };
> >  
> >  /* Data structures for DMA transmission, per 80211 core. */
> > @@ -699,6 +708,18 @@ struct bcm43xx_noise_calculation {
> >  	s8 samples[8][4];
> >  };
> >  
> > +/* Statscounter data (currently ACI only). */
> > +struct bcm43xx_statscounter_saved {
> > +	u16 aci;
> > +};
> > +
> > +/* Values for ACI moving average calculation. */
> > +struct bcm43xx_aci_saved {
> > +	u16 value[8];
> > +	u8 next:3,
> > +	   set:3;
> As I will explain later, I don't think 'set' is needed. I also recommend
> having 'next' be a plain u8.

Both values will never be > 7.

> > +};
> > +
> >  struct bcm43xx_stats {
> >  	u8 noise;
> >  	struct iw_statistics wstats;
> > @@ -812,6 +833,10 @@ struct bcm43xx_private {
> >  	u32 irq_savedstate;
> >  	/* Link Quality calculation context. */
> >  	struct bcm43xx_noise_calculation noisecalc;
> > +	/* Statscounter tracking. */
> > +	struct bcm43xx_statscounter_saved sc;
> > +	/* ACI tracking. */
> > +	struct bcm43xx_aci_saved aci;
> >  	/* if > 0 MAC is suspended. if == 0 MAC is enabled. */
> >  	int mac_suspended;
> >  
> > diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> > b/drivers/net/wireless/bcm43xx/bcm43xx_main.c index e594af4..27ec519
> > 100644 --- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> > +++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> > @@ -3059,6 +3059,44 @@ static void bcm43xx_pcie_mdio_write(stru
> >  	bcm43xx_write32(bcm, BCM43xx_PCIECORE_MDIO_CTL, 0);
> >  }
> >  
> > +/* We don't use any statscounter other than ACI for now */
> > +static u16 bcm43xx_sc_read(struct bcm43xx_private *bcm)
> > +{
> > +	struct bcm43xx_statscounter_saved *sc = &bcm->sc;
> > +	u16 tmp;
> > +
> > +	tmp = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, 0x80 +
> > BCM43xx_SC_ACI)
> > +		- sc->aci;
> > +	if (tmp)
> > +		sc->aci += tmp;
> > +
> > +	return tmp;
> > +}
> > +
> > +static u16 bcm43xx_aci_moving_average(struct bcm43xx_private *bcm)
> > +{
> > +	struct bcm43xx_aci_saved *aci = &bcm->aci;
> > +
> > +	u8 i;
> > +	u16 avg;
> > +	u32 sum = 0;
> > +
> > +	aci->value[aci->next] = bcm43xx_sc_read(bcm);
> > +	if (unlikely(aci->set < 7))
> > +		aci->set++;
> I don't think the variable aci->set is needed as the divisor is alway 8
> in the calculation of the average below. Any error in the average
> shouldn't be important as it will occur only in the first cycle through
> the value buffer. The for loop below should end at i < 8. There will be
> extra calculations only during the first buffer cycle.

Well, first cycle would last 8 seconds. I think that it's quite relevant.

> > +	for (i = 0; i < aci->set; i++)
> > +		sum += aci->value[i];
> > +	avg = sum / (u16)8;
> Why the cast here? I didn't get any gcc warnings without it. I expect
> this ends up as a shift right anyway.

Right.

> > +	if ((sum % 8) > 3)
> > +		avg++;
> > +	if (aci->next < 7)
> > +		aci->next++;
> > +	else
> > +		aci->next = 0;
> Why not auto-increment aci->next in the line where bcm43xx_sc_read is
> called. Then you only need to test for next > 7 and reset it to zero then.

It looks to be the same thing to me. Anyway, ok, your way is more elegant.


--
Ciao
Stefano
