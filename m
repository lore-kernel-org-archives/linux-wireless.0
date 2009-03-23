Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZCWXK4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 19:10:56 -0400
Subject: Re: [PATCH] Marvell CF8381
From: Dan Williams <dcbw@redhat.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200903232258.57323.marek.vasut@gmail.com>
References: <200903220127.21836.marek.vasut@gmail.com>
	 <200903231327.18890.hs4233@mail.mn-solutions.de>
	 <1237824927.14758.20.camel@localhost.localdomain>
	 <200903232258.57323.marek.vasut@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 19:08:30 -0400
Message-Id: <1237849710.26204.17.camel@localhost.localdomain> (sfid-20090324_001058_476770_95A85285)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-23 at 22:58 +0100, Marek Vasut wrote:
> On Monday 23 of March 2009 17:15:27 Dan Williams wrote:
> > On Mon, 2009-03-23 at 13:27 +0100, Holger Schurig wrote:
> > > > -       priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
> > > > +       priv->regioncode = (le16_to_cpu(cmd.regioncode) &
> > >
> > > 0xFF00) >> 8;
> > >
> > > Hmm, the change that this breaks 8385 is quite high, maybe 100
> > > percent.
> >
> > The cf8385-5.0.16.p0-26306 (gumstix) driver has:
> >
> > 	Adapter->RegionCode = wlan_le16_to_cpu(hwspec->RegionCode) >> 8;
> >
> > So it appears there's precedent for this even on 8385 parts.
> >
> > Dan
> >
> > > It could simply be the case that your firmware returns the value
> > > in a different order than mine. So we either need to test for the
> > > firmware version or for the hardware before getting the value via
> > > one or the other method.
> > >
> > > Maybe it's worthwhile to create some hw_is_8381() function and
> > > then do the things that need to be differently based on it's
> > > return value?
> > >
> > >
> > >
> > > The documentation for CMG_GET_HW_SPEC that I have says
> > >
> > > RegionCode   UINT16    Set to 0
> > >
> > > so I see no indicator that we have two 8 bit values here. But
> > > we've seen bugs in docs before :-)
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> > > in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Ok, so this should be it. I dropped the 8305 support since I found I have some 
> issues with it still.
> 
> From 3ac8f34db9c4d96197fbdc2776ebbcd571e3fbbe Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Mon, 23 Mar 2009 22:55:51 +0100
> Subject: [PATCH] Add support for CF8381 WiFi card.
>  A detection function was added for identifying CF8381.
> 
> Signed-off-by: <marek.vasut@gmail.com>
> ---
>  drivers/net/wireless/libertas/if_cs.c |   24 +++++++++++++++++++++++-
>  1 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_cs.c 
> b/drivers/net/wireless/libertas/if_cs.c
> index 3f02e6a..56b6475 100644
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -273,7 +273,20 @@ static int if_cs_poll_while_fw_download(struct if_cs_card 
> *card, uint addr, u8 r
>   */
>  #define IF_CS_PRODUCT_ID               0x0000001C
>  #define IF_CS_CF8385_B1_REV            0x12
> +#define IF_CS_CF8381_B3_REV            0x04
> 
> +/*
> + * Used to detect other cards than CF8385 since their revisions of silicon
> + * doesn't match those from CF8385, eg. CF8381 B3 works with this driver.
> + */
> +#define CF8381_MANFID          0x02db
> +#define CF8381_CARDID          0x6064
> +
> +static inline int if_cs_hw_is_cf8381(struct pcmcia_device *p_dev)
> +{
> +       return (p_dev->manf_id == CF8381_MANFID &&
> +               p_dev->card_id == CF8381_CARDID);
> +}
> 
>  /********************************************************************/
>  /* I/O and interrupt handling                                       */
> @@ -757,6 +770,7 @@ static void if_cs_release(struct pcmcia_device *p_dev)
>  static int if_cs_probe(struct pcmcia_device *p_dev)
>  {
>         int ret = -ENOMEM;
> +       unsigned int prod_id;
>         struct lbs_private *priv;
>         struct if_cs_card *card;
>         /* CIS parsing */
> @@ -859,7 +873,14 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
>                p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
> 
>         /* Check if we have a current silicon */
> -       if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
> +       prod_id = if_cs_read8(card, IF_CS_PRODUCT_ID);
> +       if (if_cs_hw_is_cf8381(p_dev) && prod_id < IF_CS_CF8381_B3_REV) {
> +               lbs_pr_err("old chips like 8381 rev B3 aren't supported\n");
> +               ret = -ENODEV;
> +               goto out2;
> +       }
> +
> +       if (prod_id < IF_CS_CF8385_B1_REV) {

You'll still want to implement a if_cs_hw_is_cf8385() here though;
otherwise, wouldn't 8381 get caught by this 8385 check and get rejected?

Dan

>                 lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
>                 ret = -ENODEV;
>                 goto out2;
> @@ -950,6 +971,7 @@ static void if_cs_detach(struct pcmcia_device *p_dev)
>  /********************************************************************/
> 
>  static struct pcmcia_device_id if_cs_ids[] = {
> +       PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
>         PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
>         PCMCIA_DEVICE_NULL,
>  };
> --
> 1.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

