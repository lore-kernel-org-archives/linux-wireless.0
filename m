Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33378 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbZEUWf1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 18:35:27 -0400
Subject: Re: [PATCH 4/4 v2] libertas: read SD8688 firmware status from new
 register
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <1242930754-27771-1-git-send-email-bzhao@marvell.com>
References: <1242930754-27771-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 18:35:07 -0400
Message-Id: <1242945307.6444.21.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-21 at 11:32 -0700, Bing Zhao wrote:
> The scratch pad register is used to store firmware status after
> firmware is downloaded and initialized. After firmware status is
> verified OK, the same register is used to store RX packet length.
> Hence the firmware status code is no longer valid afterwards.
> 
> SD8688 firmware introduces a new register for firmware status
> which will never be overwritten.
> 
> Also add scratch_reg variable to if_sdio_card structure and
> initialize it based on the model of the card during probe.
> 
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_sdio.c |   35 +++++++++++++++++++++++-------
>  drivers/net/wireless/libertas/if_sdio.h |    1 +
>  2 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 478d766..a7e3fc1 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -100,6 +100,7 @@ struct if_sdio_card {
>  
>  	int			model;
>  	unsigned long		ioport;
> +	unsigned int		scratch_reg;
>  
>  	const char		*helper;
>  	const char		*firmware;
> @@ -119,19 +120,21 @@ struct if_sdio_card {
>  /* I/O                                                              */
>  /********************************************************************/
>  
> +/*
> + *  For SD8385/SD8686, this function reads firmware status after
> + *  the image is downloaded, or reads RX packet length when
> + *  interrupt (with IF_SDIO_H_INT_UPLD bit set) is received.
> + *  For SD8688, this function reads firmware status only.
> + */
>  static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
>  {
> -	int ret, reg;
> +	int ret;
>  	u16 scratch;
>  
> -	if (card->model == IF_SDIO_MODEL_8385)
> -		reg = IF_SDIO_SCRATCH_OLD;
> -	else
> -		reg = IF_SDIO_SCRATCH;
> -
> -	scratch = sdio_readb(card->func, reg, &ret);
> +	scratch = sdio_readb(card->func, card->scratch_reg, &ret);
>  	if (!ret)
> -		scratch |= sdio_readb(card->func, reg + 1, &ret) << 8;
> +		scratch |= sdio_readb(card->func, card->scratch_reg + 1,
> +					&ret) << 8;
>  
>  	if (err)
>  		*err = ret;
> @@ -706,6 +709,8 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
>  	if (ret)
>  		goto out;
>  
> +	lbs_deb_sdio("firmware status = %#x\n", scratch);
> +
>  	if (scratch == IF_SDIO_FIRMWARE_OK) {
>  		lbs_deb_sdio("firmware already loaded\n");
>  		goto success;
> @@ -893,6 +898,20 @@ static int if_sdio_probe(struct sdio_func *func,
>  
>  	card->func = func;
>  	card->model = model;
> +
> +	switch (card->model) {
> +	case IF_SDIO_MODEL_8385:
> +		card->scratch_reg = IF_SDIO_SCRATCH_OLD;
> +		break;
> +	case IF_SDIO_MODEL_8686:
> +		card->scratch_reg = IF_SDIO_SCRATCH;
> +		break;
> +	case IF_SDIO_MODEL_8688:
> +	default: /* for newer chipsets */
> +		card->scratch_reg = IF_SDIO_FW_STATUS;
> +		break;
> +	}
> +
>  	spin_lock_init(&card->lock);
>  	card->workqueue = create_workqueue("libertas_sdio");
>  	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
> diff --git a/drivers/net/wireless/libertas/if_sdio.h b/drivers/net/wireless/libertas/if_sdio.h
> index d3a4fbe..60c9b2f 100644
> --- a/drivers/net/wireless/libertas/if_sdio.h
> +++ b/drivers/net/wireless/libertas/if_sdio.h
> @@ -42,6 +42,7 @@
>  
>  #define IF_SDIO_SCRATCH		0x34
>  #define IF_SDIO_SCRATCH_OLD	0x80fe
> +#define IF_SDIO_FW_STATUS	0x40
>  #define   IF_SDIO_FIRMWARE_OK	0xfedc
>  
>  #define IF_SDIO_RX_LEN		0x42

