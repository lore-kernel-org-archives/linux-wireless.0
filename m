Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59358 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0CSUWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 16:22:50 -0400
Date: Fri, 19 Mar 2010 16:21:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>, stable@kernel.org
Subject: Re: [PATCH] ssb: do not read SPROM if it does not exist
Message-ID: <20100319202120.GD9552@tuxdriver.com>
References: <4BA266FB.1080507@lwfinger.net> <1269025687-9817-1-git-send-email-linville@tuxdriver.com> <201003192041.47211.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201003192041.47211.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 19, 2010 at 08:41:47PM +0100, Michael Buesch wrote:
> On Friday 19 March 2010 20:08:07 John W. Linville wrote:
> > +	switch (bus->chip_id) {
> > +	case 0x4312:
> > +		return SSB_CHIPCO_CHST_4312_SPROM_PRESENT(bus->chipco.status);
> 
> Not sure why we want to hide the logic in defines. But I don't care much, either.

To me it just seems clearer than a bunch of long and ugly bit
operations that differ in the details but are logically accomplishing
the same thing.
 
> > +	case 0x4322:
> > +		return SSB_CHIPCO_CHST_4322_SPROM_PRESENT(bus->chipco.status);
> > +	case 0x4325:
> > +		return SSB_CHIPCO_CHST_4325_SPROM_PRESENT(bus->chipco.status);
> > +	default:
> > +		break;
> > +	}
> > +	if (bus->chip_rev >= 31)
> 
> This check is wrong.
> You need to check the chipcommon core revision. Not the chip revision.

I'm sorry, I had trouble figuring-out what you meant (since chip_rev
comes from a chipcommon register).  I think you mean this:

-       if (bus->chip_rev >= 31)
+       if (bus->chipco.dev->id.revision >= 31)

Is that right?

John

> > +		return bus->chipco.capabilities & SSB_CHIPCO_CAP_SPROM;
> > +
> > +	return true;
> > +}
> > diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> > index 24f9885..3b4da23 100644
> > --- a/include/linux/ssb/ssb.h
> > +++ b/include/linux/ssb/ssb.h
> > @@ -394,6 +394,9 @@ extern int ssb_bus_sdiobus_register(struct ssb_bus *bus,
> >  
> >  extern void ssb_bus_unregister(struct ssb_bus *bus);
> >  
> > +/* Does the device have an SPROM? */
> > +extern bool ssb_is_sprom_available(struct ssb_bus *bus);
> > +
> >  /* Set a fallback SPROM.
> >   * See kdoc at the function definition for complete documentation. */
> >  extern int ssb_arch_set_fallback_sprom(const struct ssb_sprom *sprom);
> > diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
> > index 4e27acf..4e5726d 100644
> > --- a/include/linux/ssb/ssb_driver_chipcommon.h
> > +++ b/include/linux/ssb/ssb_driver_chipcommon.h
> > @@ -30,6 +30,7 @@
> >  #define   SSB_CHIPCO_CAP_UARTCLK_INT	0x00000008	/* UARTs are driven by internal divided clock */
> >  #define  SSB_CHIPCO_CAP_UARTGPIO	0x00000020	/* UARTs on GPIO 15-12 */
> >  #define  SSB_CHIPCO_CAP_EXTBUS		0x000000C0	/* External buses present */
> > +#define  SSB_CHIPCO_CAP_SPROM		0x40000000	/* SPROM present */
> >  #define  SSB_CHIPCO_CAP_FLASHT		0x00000700	/* Flash Type */
> 
> Probably keep ordering of capabilities correct.

Oops, sorry...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
