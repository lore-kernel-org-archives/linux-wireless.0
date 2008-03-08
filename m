Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:49479 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbYCHTzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 14:55:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] b43: pull out helpers for writing noise table
Date: Sat, 8 Mar 2008 20:54:23 +0100
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1204972838.23455.47.camel@brick> <200803081448.11670.mb@bu3sch.de> <1205005387.3335.2.camel@localhost.localdomain>
In-Reply-To: <1205005387.3335.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803082054.24197.mb@bu3sch.de> (sfid-20080308_195519_830492_C422E8BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 March 2008 20:43:07 Dan Williams wrote:
> On Sat, 2008-03-08 at 14:48 +0100, Michael Buesch wrote:
> > Uhm, well. Why? Any problems with that code?
> 
> It's a nice cleanup.  Nothing wrong with getting rid of the same code
> duplicated 6 times.

Yeah, well. Thing is that I really don't like messing with the PHY code. :)
If we introduce a regression with one of these cleanups, it's really really hard
to debug and fix.

This one seems OK, though.

But next time please contact me first before you want to to cleanups to
the PHY code.

Example: The patch that cleaned up the PHY workarounds code introduced
a few really hard to debug regressions that took me weeks to fix.
So I will rather NACK patches, that are only for the sake of "hey this
looks nicer" or "this makes the code 3 bytes smaller".

Anyway, thanks for the patch.

> > On Saturday 08 March 2008 11:40:38 Harvey Harrison wrote:
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > > ---
> > >  drivers/net/wireless/b43/wa.c |   44 +++++++++++++++++++++-------------------
> > >  1 files changed, 23 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
> > > index e632125..eff35ad 100644
> > > --- a/drivers/net/wireless/b43/wa.c
> > > +++ b/drivers/net/wireless/b43/wa.c
> > > @@ -204,6 +204,22 @@ static void b43_wa_rt(struct b43_wldev *dev) /* Rotor table */
> > >  		b43_ofdmtab_write32(dev, B43_OFDMTAB_ROTOR, i, b43_tab_rotor[i]);
> > >  }
> > >  
> > > +static void b43_write_null_nst(struct b43_wldev *dev)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > +		b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE, i, 0);
> > > +}
> > > +
> > > +static void b43_write_nst(struct b43_wldev *dev, const u16 *nst)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > +		b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE, i, nst[i]);
> > > +}
> > > +
> > >  static void b43_wa_nst(struct b43_wldev *dev) /* Noise scale table */
> > >  {
> > >  	struct b43_phy *phy = &dev->phy;
> > > @@ -211,35 +227,21 @@ static void b43_wa_nst(struct b43_wldev *dev) /* Noise scale table */
> > >  
> > >  	if (phy->type == B43_PHYTYPE_A) {
> > >  		if (phy->rev <= 1)
> > > -			for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > -				b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE,
> > > -							i, 0);
> > > +			b43_write_null_nst(dev);
> > >  		else if (phy->rev == 2)
> > > -			for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > -				b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE,
> > > -							i, b43_tab_noisescalea2[i]);
> > > +			b43_write_nst(dev, b43_tab_noisescalea2);
> > >  		else if (phy->rev == 3)
> > > -			for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > -				b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE,
> > > -							i, b43_tab_noisescalea3[i]);
> > > +			b43_write_nst(dev, b43_tab_noisescalea3);
> > >  		else
> > > -			for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > -				b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE,
> > > -							i, b43_tab_noisescaleg3[i]);
> > > +			b43_write_nst(dev, b43_tab_noisescaleg3);
> > >  	} else {
> > >  		if (phy->rev >= 6) {
> > >  			if (b43_phy_read(dev, B43_PHY_ENCORE) & B43_PHY_ENCORE_EN)
> > > -				for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > -					b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE,
> > > -						i, b43_tab_noisescaleg3[i]);
> > > +				b43_write_nst(dev, b43_tab_noisescaleg3);
> > >  			else
> > > -				for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > -					b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE,
> > > -						i, b43_tab_noisescaleg2[i]);
> > > +				b43_write_nst(dev, b43_tab_noisescaleg2);
> > >  		} else {
> > > -			for (i = 0; i < B43_TAB_NOISESCALE_SIZE; i++)
> > > -				b43_ofdmtab_write16(dev, B43_OFDMTAB_NOISESCALE,
> > > -							i, b43_tab_noisescaleg1[i]);
> > > +			b43_write_nst(dev, b43_tab_noisescaleg1);
> > >  		}
> > >  	}
> > >  }
> > 
> > 
> > 
> 
> 
> 



-- 
Greetings Michael.
