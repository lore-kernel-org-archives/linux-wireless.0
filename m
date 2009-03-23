Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37291 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759103AbZCWRBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 13:01:06 -0400
Subject: Re: [PATCH] Marvell CF8381 and CF8305
From: Dan Williams <dcbw@redhat.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200903231700.21627.marek.vasut@gmail.com>
References: <200903220127.21836.marek.vasut@gmail.com>
	 <200903231313.10699.hs4233@mail.mn-solutions.de>
	 <200903231659.05158.marek.vasut@gmail.com>
	 <200903231700.21627.marek.vasut@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 12:58:48 -0400
Message-Id: <1237827528.14758.31.camel@localhost.localdomain> (sfid-20090323_180110_129659_FC88D998)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-23 at 17:00 +0100, Marek Vasut wrote:
> On Monday 23 of March 2009 16:59:05 Marek Vasut wrote:
> > Here's the other patch.
> > I also added cf8305 support (if_cs.c patched this way works for it too).
> 
> here as well...inlining
> 
> From 4c7fcf79de8ba900c4a9a56e68c9da89491dff27 Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Mon, 23 Mar 2009 16:50:30 +0100
> Subject: [PATCH 2/2] Add support for CF8381 and CF8305 WiFi card.
>  Two detection functions were added for identifying CF8381 and CF8305.
>  Also, CF8305 uses only one-stage firmware, so handle this as well.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/net/wireless/libertas/if_cs.c |   35 ++++++++++++++++++++++++++++++--
>  1 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_cs.c 
> b/drivers/net/wireless/libertas/if_cs.c
> index 3f02e6a..e115c8f 100644
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -273,7 +273,28 @@ static int if_cs_poll_while_fw_download(struct if_cs_card 
> *card, uint addr, u8 r
>   */
>  #define IF_CS_PRODUCT_ID		0x0000001C
>  #define IF_CS_CF8385_B1_REV		0x12
> +#define IF_CS_CF8381_B3_REV		0x04
>  
> +/*
> + * Used to detect other cards than CF8385 since their revisions of silicon
> + * doesn't match those from CF8385, eg. CF8381 B3 works with this driver.
> + */
> +#define CF8305_MANFID		0x02db
> +#define CF8305_CARDID		0x8103
> +#define CF8381_MANFID		0x02db
> +#define CF8381_CARDID		0x6064
> +
> +static inline int if_cs_hw_is_cf8305(struct pcmcia_device *p_dev)
> +{
> +	return (p_dev->manf_id == CF8305_MANFID &&
> +		p_dev->card_id == CF8305_CARDID);
> +}
> +
> +static inline int if_cs_hw_is_cf8381(struct pcmcia_device *p_dev)
> +{
> +	return (p_dev->manf_id == CF8381_MANFID &&
> +		p_dev->card_id == CF8381_CARDID);
> +}
>  
>  /********************************************************************/
>  /* I/O and interrupt handling                                       */
> @@ -757,6 +778,7 @@ static void if_cs_release(struct pcmcia_device *p_dev)
>  static int if_cs_probe(struct pcmcia_device *p_dev)
>  {
>  	int ret = -ENOMEM;
> +	unsigned int prod_id;
>  	struct lbs_private *priv;
>  	struct if_cs_card *card;
>  	/* CIS parsing */
> @@ -859,15 +881,20 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
>  	       p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
>  
>  	/* Check if we have a current silicon */
> -	if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
> -		lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
> +	prod_id = if_cs_read8(card, IF_CS_PRODUCT_ID);
> +	if (!(if_cs_hw_is_cf8305(p_dev) ||
> +		(if_cs_hw_is_cf8381(p_dev) &&
> +		prod_id >= IF_CS_CF8381_B3_REV)) &&
> +		(prod_id < IF_CS_CF8385_B1_REV)) {
> +		lbs_pr_err("old chips like 8385 rev B1 or "
> +			"8381 rev B3 aren't supported\n");

This gets ugly fast; couldn't we instead do something like:

if (if_cs_hw_is_cf8381(p_dev) && (prod_id < IF_CS_CF8381_B3_REV)) {
	lbs_pr_err("Only 88w8381 hardware revisions B3 and later"
	           " are supported.\n"
	ret = -ENODEV;
	goto out2;
}

if (if_cs_hw_is_cf8385(p_dev) && (prod_id <= IF_CS_CF8385_B1_REV)) {
	lbs_pr_err("Only 88w8385 hardware revisions B2 and later"
	           " are supported.\n"
	ret = -ENODEV;
	goto out2;
}

instead?

>  		ret = -ENODEV;
>  		goto out2;
>  	}
>  
>  	/* Load the firmware early, before calling into libertas.ko */
>  	ret = if_cs_prog_helper(card);
> -	if (ret >= 0)
> +	if (ret >= 0 && !if_cs_hw_is_cf8305(p_dev))
>  		ret = if_cs_prog_real(card);

Again, not required with current wireless-testing.

Dan

>  	if (ret < 0)
>  		goto out2;
> @@ -950,6 +977,8 @@ static void if_cs_detach(struct pcmcia_device *p_dev)
>  /********************************************************************/
>  
>  static struct pcmcia_device_id if_cs_ids[] = {
> +	PCMCIA_DEVICE_MANF_CARD(CF8305_MANFID, CF8305_CARDID),
> +	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
>  	PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
>  	PCMCIA_DEVICE_NULL,
>  };

