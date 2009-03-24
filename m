Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbZCXK2x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 06:28:53 -0400
Subject: Re: [PATCH] Marvell CF8381
From: Dan Williams <dcbw@redhat.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200903240042.41054.marek.vasut@gmail.com>
References: <200903220127.21836.marek.vasut@gmail.com>
	 <200903232258.57323.marek.vasut@gmail.com>
	 <1237849710.26204.17.camel@localhost.localdomain>
	 <200903240042.41054.marek.vasut@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 06:26:27 -0400
Message-Id: <1237890387.25734.9.camel@localhost.localdomain> (sfid-20090324_112856_591775_B04D20F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-03-24 at 00:42 +0100, Marek Vasut wrote:
> Ok, here is another version, hopefully last one.
> 
> From a7522df9d610702cfc3066861a2e315552e29086 Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Tue, 24 Mar 2009 00:40:44 +0100
> Subject: [PATCH] Add support for CF8381 WiFi card.
>  A detection function was added for identifying CF8381.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_cs.c |   34 +++++++++++++++++++++++++++++++-
>  1 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_cs.c 
> b/drivers/net/wireless/libertas/if_cs.c
> index 3f02e6a..1da23e5 100644
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -273,7 +273,28 @@ static int if_cs_poll_while_fw_download(struct if_cs_card 
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
> +#define CF8385_MANFID          0x02df
> +#define CF8385_CARDID          0x8103
> +
> +static inline int if_cs_hw_is_cf8381(struct pcmcia_device *p_dev)
> +{
> +       return (p_dev->manf_id == CF8381_MANFID &&
> +               p_dev->card_id == CF8381_CARDID);
> +}
> +
> +static inline int if_cs_hw_is_cf8385(struct pcmcia_device *p_dev)
> +{
> +       return (p_dev->manf_id == CF8385_MANFID &&
> +               p_dev->card_id == CF8385_CARDID);
> +}
> 
>  /********************************************************************/
>  /* I/O and interrupt handling                                       */
> @@ -757,6 +778,7 @@ static void if_cs_release(struct pcmcia_device *p_dev)
>  static int if_cs_probe(struct pcmcia_device *p_dev)
>  {
>         int ret = -ENOMEM;
> +       unsigned int prod_id;
>         struct lbs_private *priv;
>         struct if_cs_card *card;
>         /* CIS parsing */
> @@ -859,7 +881,14 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
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
> +       if (if_cs_hw_is_cf8385(p_dev) && prod_id < IF_CS_CF8385_B1_REV) {
>                 lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
>                 ret = -ENODEV;
>                 goto out2;
> @@ -950,7 +979,8 @@ static void if_cs_detach(struct pcmcia_device *p_dev)
>  /********************************************************************/
> 
>  static struct pcmcia_device_id if_cs_ids[] = {
> -       PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
> +       PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
> +       PCMCIA_DEVICE_MANF_CARD(CF8385_MANFID, CF8385_CARDID),
>         PCMCIA_DEVICE_NULL,
>  };
>  MODULE_DEVICE_TABLE(pcmcia, if_cs_ids);
> --
> 1.6.2
> 

