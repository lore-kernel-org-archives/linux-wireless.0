Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbXJILS1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 07:18:27 -0400
Subject: Re: [PATCH, take 2] libertas: fixes for slow hardware
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200710091041.57159.hs4233@mail.mn-solutions.de>
References: <200710081118.27468.hs4233@mail.mn-solutions.de>
	 <1191849316.2703.26.camel@localhost.localdomain>
	 <200710091041.57159.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 07:18:45 -0400
Message-Id: <1191928725.599.2.camel@localhost.localdomain> (sfid-20071009_121834_166493_55D91AF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-09 at 10:41 +0200, Holger Schurig wrote:
> Fixes for slow hardware.
> 
> Signed-off-by: Vitaly V. Bursov <vitalyvb@ukr.net>
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: libertas-2.6/drivers/net/wireless/libertas/if_cs.c
> ===================================================================
> --- libertas-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2007-10-09 11:40:37.000000000 +0200
> +++ libertas-2.6/drivers/net/wireless/libertas/if_cs.c	2007-10-09 11:40:50.000000000 +0200
> @@ -148,11 +148,11 @@ static int if_cs_poll_while_fw_download(
>  {
>  	int i;
>  
> -	for (i = 0; i < 500; i++) {
> +	for (i = 0; i < 1000; i++) {
>  		u8 val = if_cs_read8(card, addr);
>  		if (val == reg)
>  			return i;
> -		udelay(100);
> +		udelay(500);
>  	}
>  	return -ETIME;
>  }
> @@ -878,6 +878,9 @@ static int if_cs_probe(struct pcmcia_dev
>  		goto out3;
>  	}
>  
> +	/* Clear any interrupt cause that happend while sending
> +	 * firmware/initializing card */
> +	if_cs_write16(card, IF_CS_C_INT_CAUSE, IF_CS_C_IC_MASK);
>  	if_cs_enable_ints(card);
>  
>  	/* And finally bring the card up */
> 

