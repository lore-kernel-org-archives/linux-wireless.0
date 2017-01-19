Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:34805 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdASUxI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 15:53:08 -0500
Date: Thu, 19 Jan 2017 21:52:56 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
        michel.stempin@wanadoo.fr, Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 13/14] rt2x00: rt2800lib: add support for RT3352 with
 20MHz crystal
Message-ID: <20170119205256.GB21298@makrotopia.org> (sfid-20170119_215315_633870_0EE266C9)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116031541.GA32313@makrotopia.org>
 <20170118142958.GA14573@redhat.com>
 <20170119133010.GH1798@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170119133010.GH1798@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 19, 2017 at 02:30:14PM +0100, Daniel Golle wrote:
> Hi Stanislaw,
> 
> On Wed, Jan 18, 2017 at 03:30:02PM +0100, Stanislaw Gruszka wrote:
> > On Mon, Jan 16, 2017 at 04:15:56AM +0100, Daniel Golle wrote:
> > > Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> > > Signed-off-by: Mathias Kresin <dev@kresin.me>
> > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > > ---
> > >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 50 +++++++++++++++++++++++++-
> > >  drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  2 ++
> > >  2 files changed, 51 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > index 93c97eade334..cb1457595f05 100644
> > > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > @@ -36,6 +36,7 @@
> > >  #include <linux/kernel.h>
> > >  #include <linux/module.h>
> > >  #include <linux/slab.h>
> > > +#include <linux/clk.h>
> > >  
> > >  #include "rt2x00.h"
> > >  #include "rt2800lib.h"
> > > @@ -7675,6 +7676,27 @@ static const struct rf_channel rf_vals_5592_xtal40[] = {
> > >  	{196, 83, 0, 12, 1},
> > >  };
> > >  
> > > +/*
> > > + * RF value list for rt3xxx with Xtal20MHz
> > > + * Supports: 2.4 GHz (all) (RF3322)
> > > + */
> > > +static const struct rf_channel rf_vals_xtal20mhz_3x[] = {
> > Please locate this values in alphabetical order (i.e. after _3x and 
> > before _5592 ).
> 
> Sure, sorry, that ended up in the wrong order when rebase the patches.
> 
> > 
> > >  	struct hw_mode_spec *spec = &rt2x00dev->spec;
> > > @@ -7764,7 +7786,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> > >  	case RF5390:
> > >  	case RF5392:
> > >  		spec->num_channels = 14;
> > > -		spec->channels = rf_vals_3x;
> > > +		if (spec->clk_is_20mhz)
> > > +			spec->channels = rf_vals_xtal20mhz_3x;
> > > +		else
> > > +			spec->channels = rf_vals_3x;
> > >  		break;
> > 
> > How does vendor drivers recognize xtal (I assume rf_vals_xtal20mhz_3x 
> > values were taken from vendor driver) ? It should be possible to get
> > clock frequency from device register like is is done on RF5592, without
> > adding additional clock recognition code. But if such code is needed
> > I prefer that low level board/platform routines do it and place clock
> > frequency for rt2x00 in rt2x00dev->dev->platform_data.

I researched and found this has already been implemented in the ramips
platform code, see

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/tree/arch/mips/ralink/rt305x.c#n194

The patch submitted uses this existing infrastructure which *does*
auto-probe the clock from the SoC's SYSCTRL register.
I'll re-submit a v3 with the alphabetic order above fixed, ok?


Cheers


Daniel
