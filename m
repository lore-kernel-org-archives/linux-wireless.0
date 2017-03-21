Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53466 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757508AbdCUSgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 14:36:45 -0400
Message-ID: <1490121387.19767.154.camel@linux.intel.com> (sfid-20170321_193918_899956_6B0450F0)
Subject: Re: [PATCH v2 1/5] NFC: st21nfca: Fix obvious typo when check error
 code
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Christophe Ricard <christophe.ricard@gmail.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 21 Mar 2017 20:36:27 +0200
In-Reply-To: <01ecc522-3b0e-a7af-1025-c249a79664dc@gmail.com>
References: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
         <1489765790.19767.62.camel@linux.intel.com>
         <01ecc522-3b0e-a7af-1025-c249a79664dc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-03-20 at 19:29 -0700, Christophe Ricard wrote:
> Hi Andy,
> 
> The patch looks good to me.

Thanks for the answer and looking into it.
Does it apply to the whole series?

> The device got enumerated via ACPI on development platforms for 
> integration tests purposes.

It would be ideally good if you can test this series for real.
I'm in doubt someone tested any further than looking into DSDT in ACPI
case or on other hand it might be enumerated but didn't work as supposed
(no enable GPIO, see below fix for the details).

> 
> Best Regards
> 
> Christophe
> 
> On 17/03/2017 08:49, Andy Shevchenko wrote:
> > On Tue, 2017-03-07 at 12:25 +0200, Andy Shevchenko wrote:
> > > We return -ENODEV if ACPI provides a GPIO resource. Looks really
> > > wrong.
> > > If it has even been tested?
> > 
> > Any comments on this clean up?
> > 
> > Next patch which is dependent to this is related to ACPI
> > enumeration.
> > After GPIO ACPI library gets stricter the driver wouldn't work
> > without
> > ACPI related changes.
> > 
> > By the way, is this device have ever been enumerated via ACPI?
> > 
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > ---
> > >   drivers/nfc/st21nfca/i2c.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/nfc/st21nfca/i2c.c
> > > b/drivers/nfc/st21nfca/i2c.c
> > > index 5a82f553906c..737384d287aa 100644
> > > --- a/drivers/nfc/st21nfca/i2c.c
> > > +++ b/drivers/nfc/st21nfca/i2c.c
> > > @@ -514,9 +514,9 @@ static int
> > > st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
> > >   	/* Get EN GPIO from ACPI */
> > >   	gpiod_ena = devm_gpiod_get_index(dev,
> > > ST21NFCA_GPIO_NAME_EN,
> > > 1,
> > >   					 GPIOD_OUT_LOW);
> > > -	if (!IS_ERR(gpiod_ena)) {
> > > +	if (IS_ERR(gpiod_ena)) {
> > >   		nfc_err(dev, "Unable to get ENABLE GPIO\n");
> > > -		return -ENODEV;
> > > +		return PTR_ERR(gpiod_ena);
> > >   	}
> > >   
> > >   	phy->gpio_ena = desc_to_gpio(gpiod_ena);
> 
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
