Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48324 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZEUOlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 10:41:01 -0400
Subject: RE: [PATCH 4/4] libertas: read SD8688 firmware status from new
 register
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F704301E8616CA2@SC-VEXCH1.marvell.com>
References: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
	 <1242787701-10685-4-git-send-email-bzhao@marvell.com>
	 <1242859576.7048.41.camel@localhost.localdomain>
	 <477F20668A386D41ADCC57781B1F704301E8616CA2@SC-VEXCH1.marvell.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 10:40:52 -0400
Message-Id: <1242916852.14369.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-20 at 16:50 -0700, Bing Zhao wrote:
> Hi Dan,
> 
> > -----Original Message-----
> > From: Dan Williams [mailto:dcbw@redhat.com]
> > Sent: Wednesday, May 20, 2009 3:46 PM
> > To: Bing Zhao
> > Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org
> > Subject: Re: [PATCH 4/4] libertas: read SD8688 firmware status from new register
> > 
> > On Tue, 2009-05-19 at 19:48 -0700, Bing Zhao wrote:
> > > The scratch pad register is used to store firmware status after
> > > firmware is downloaded and initialized. After firmware status is
> > > verified OK, the same register is used to store RX packet length.
> > > Hence the firmware status code is no longer valid afterwards.
> > >
> > > SD8688 firmware introduces a new register for firmware status
> > > which will never be overwritten.
> > 
> > This could become confusing :)  read_rx_len() already has a switch
> > statement, but since read_rx_len() can also call into read_scratch() for
> > the 8385 and 8686, that *also* has a switch selector.  I can't think of
> > a great way to break it up though without copying a chunk of code around
> > or making useless wrapper functions.
> > 
> 
> Do you think this change makes things better?

Yeah, that's better.  Also saves some processing time because the
scratch reg doesn't have to be set each time a frame comes in.

Want to resubmit with the Signed-off-by and description just for fun? :)

Dan

> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 18132d4..a7e3fc1 100644
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
> @@ -127,25 +128,13 @@ struct if_sdio_card {
>   */
>  static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
>  {
> -	int ret, reg;
> +	int ret;
>  	u16 scratch;
>  
> -	switch (card->model) {
> -	case IF_SDIO_MODEL_8385:
> -		reg = IF_SDIO_SCRATCH_OLD;
> -		break;
> -	case IF_SDIO_MODEL_8686:
> -		reg = IF_SDIO_SCRATCH;
> -		break;
> -	case IF_SDIO_MODEL_8688:
> -	default: /* for newer chipsets */
> -		reg = IF_SDIO_FW_STATUS;
> -		break;
> -	}
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
> @@ -909,6 +898,20 @@ static int if_sdio_probe(struct sdio_func *func,
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
> 
> 
> 
> Thanks,
> 
> Bing
> 
> 
> > Acked-by: Dan Williams <dcbw@redhat.com>
> > 
> > Dan
> > 
> > > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > > ---
> > >  drivers/net/wireless/libertas/if_sdio.c |   20 ++++++++++++++++++--
> > >  drivers/net/wireless/libertas/if_sdio.h |    1 +
> > >  2 files changed, 19 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> > > index 478d766..18132d4 100644
> > > --- a/drivers/net/wireless/libertas/if_sdio.c
> > > +++ b/drivers/net/wireless/libertas/if_sdio.c
> > > @@ -119,15 +119,29 @@ struct if_sdio_card {
> > >  /* I/O                                                              */
> > >  /********************************************************************/
> > >
> > > +/*
> > > + *  For SD8385/SD8686, this function reads firmware status after
> > > + *  the image is downloaded, or reads RX packet length when
> > > + *  interrupt (with IF_SDIO_H_INT_UPLD bit set) is received.
> > > + *  For SD8688, this function reads firmware status only.
> > > + */
> > >  static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
> > >  {
> > >  	int ret, reg;
> > >  	u16 scratch;
> > >
> > > -	if (card->model == IF_SDIO_MODEL_8385)
> > > +	switch (card->model) {
> > > +	case IF_SDIO_MODEL_8385:
> > >  		reg = IF_SDIO_SCRATCH_OLD;
> > > -	else
> > > +		break;
> > > +	case IF_SDIO_MODEL_8686:
> > >  		reg = IF_SDIO_SCRATCH;
> > > +		break;
> > > +	case IF_SDIO_MODEL_8688:
> > > +	default: /* for newer chipsets */
> > > +		reg = IF_SDIO_FW_STATUS;
> > > +		break;
> > > +	}
> > >
> > >  	scratch = sdio_readb(card->func, reg, &ret);
> > >  	if (!ret)
> > > @@ -706,6 +720,8 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
> > >  	if (ret)
> > >  		goto out;
> > >
> > > +	lbs_deb_sdio("firmware status = %#x\n", scratch);
> > > +
> > >  	if (scratch == IF_SDIO_FIRMWARE_OK) {
> > >  		lbs_deb_sdio("firmware already loaded\n");
> > >  		goto success;
> > > diff --git a/drivers/net/wireless/libertas/if_sdio.h b/drivers/net/wireless/libertas/if_sdio.h
> > > index d3a4fbe..60c9b2f 100644
> > > --- a/drivers/net/wireless/libertas/if_sdio.h
> > > +++ b/drivers/net/wireless/libertas/if_sdio.h
> > > @@ -42,6 +42,7 @@
> > >
> > >  #define IF_SDIO_SCRATCH		0x34
> > >  #define IF_SDIO_SCRATCH_OLD	0x80fe
> > > +#define IF_SDIO_FW_STATUS	0x40
> > >  #define   IF_SDIO_FIRMWARE_OK	0xfedc
> > >
> > >  #define IF_SDIO_RX_LEN		0x42
> 
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev

