Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43725 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZBCSHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 13:07:32 -0500
Subject: Re: [PATCH] libertas: if_spi: add ability to call board specific
	setup/teardown methods
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Mike Rapoport <mike@compulab.co.il>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <45e8e6c40902030938x3ce2aaf2o7365a4337783c8ee@mail.gmail.com>
References: <4987EC74.7040706@compulab.co.il>
	 <1233676302.11344.21.camel@localhost.localdomain>
	 <45e8e6c40902030938x3ce2aaf2o7365a4337783c8ee@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 13:05:49 -0500
Message-Id: <1233684349.11344.98.camel@localhost.localdomain> (sfid-20090203_190733_708390_FD6B3806)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-03 at 09:38 -0800, Andrey Yurovsky wrote:
> On Tue, Feb 3, 2009 at 7:51 AM, Dan Williams <dcbw@redhat.com> wrote:
> > On Tue, 2009-02-03 at 09:04 +0200, Mike Rapoport wrote:
> >> In certain cases it is required to perform board specific actions
> >> before activating libertas G-SPI interface. These actions may include
> >> power up of the chip, GPIOs setup, proper pin-strapping and SPI
> >> controller config.
> >> This patch adds ability to call board specific setup/teardown methods
> >>
> >>
> >> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> >
> > Andrey, does this look OK to you?  Seems fine to me, though what's the
> > lifetime of the platform data 'pdata' in the probe function?  Is that
> > guaranteed to be valid for the entire lifetime of the libertas SPI
> > device?
> >
> > Dan
> 
> Yes, this looks good to me.  'pdata' will span the lifetime of the
> device as it's set up in if_spi_probe and stays around until
> libertas_spi_remove
> 
> Acked-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> >> ---
> >>  drivers/net/wireless/libertas/if_spi.c |   15 +++++++++++++++
> >>  include/linux/spi/libertas_spi.h       |    7 +++++++
> >>  2 files changed, 22 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> >> index 7c02ea3..07311e7 100644
> >> --- a/drivers/net/wireless/libertas/if_spi.c
> >> +++ b/drivers/net/wireless/libertas/if_spi.c
> >> @@ -42,6 +42,7 @@ struct if_spi_packet {
> >>  struct if_spi_card {
> >>       struct spi_device               *spi;
> >>       struct lbs_private              *priv;
> >> +     struct libertas_spi_platform_data *pdata;
> >>
> >>       char                            helper_fw_name[FIRMWARE_NAME_MAX];
> >>       char                            main_fw_name[FIRMWARE_NAME_MAX];
> >> @@ -1022,6 +1023,17 @@ static int __devinit if_spi_probe(struct spi_device *spi)
> >>
> >>       lbs_deb_enter(LBS_DEB_SPI);
> >>
> >> +     if (!pdata) {
> >> +             err = -EINVAL;
> >> +             goto out;
> >> +     }
> >> +
> >> +     if (pdata->setup) {
> >> +             err = pdata->setup(spi);
> >> +             if (err)
> >> +                     goto out;
> >> +     }
> >> +
> >>       /* Allocate card structure to represent this specific device */
> >>       card = kzalloc(sizeof(struct if_spi_card), GFP_KERNEL);
> >>       if (!card) {
> >> @@ -1029,6 +1041,7 @@ static int __devinit if_spi_probe(struct spi_device *spi)
> >>               goto out;
> >>       }
> >>       spi_set_drvdata(spi, card);
> >> +     card->pdata = pdata;
> >>       card->spi = spi;
> >>       card->gpio_cs = pdata->gpio_cs;
> >>       card->prev_xfer_time = jiffies;
> >> @@ -1158,6 +1171,8 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
> >>       if_spi_terminate_spi_thread(card);
> >>       lbs_remove_card(priv); /* will call free_netdev */
> >>       gpio_free(card->gpio_cs);
> >> +     if (card->pdata->teardown)
> >> +             card->pdata->teardown(spi);
> >>       free_if_spi_card(card);
> >>       lbs_deb_leave(LBS_DEB_SPI);
> >>       return 0;
> >> diff --git a/include/linux/spi/libertas_spi.h b/include/linux/spi/libertas_spi.h
> >> index ada71b4..79506f5 100644
> >> --- a/include/linux/spi/libertas_spi.h
> >> +++ b/include/linux/spi/libertas_spi.h
> >> @@ -10,6 +10,9 @@
> >>   */
> >>  #ifndef _LIBERTAS_SPI_H_
> >>  #define _LIBERTAS_SPI_H_
> >> +
> >> +struct spi_device;
> >> +
> >>  struct libertas_spi_platform_data {
> >>       /* There are two ways to read data from the WLAN module's SPI
> >>        * interface. Setting 0 or 1 here controls which one is used.
> >> @@ -21,5 +24,9 @@ struct libertas_spi_platform_data {
> >>
> >>       /* GPIO number to use as chip select */
> >>       u16 gpio_cs;
> >> +
> >> +     /* Board specific setup/teardown */
> >> +     int (*setup)(struct spi_device *spi);
> >> +     int (*teardown)(struct spi_device *spi);
> >>  };
> >>  #endif
> >> --
> >> 1.5.6.4
> >>
> >>
> >
> >
> > _______________________________________________
> > libertas-dev mailing list
> > libertas-dev@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/libertas-dev
> >

