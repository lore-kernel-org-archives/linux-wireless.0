Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbYAYPxB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 10:53:01 -0500
Subject: Re: [PATCH] libertas: fix interrupt while removing driver
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200801251415.48216.hs4233@mail.mn-solutions.de>
References: <200801251415.48216.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 10:48:04 -0500
Message-Id: <1201276084.1163.6.camel@localhost.localdomain> (sfid-20080125_155305_338506_F2B38BAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-01-25 at 14:15 +0100, Holger Schurig wrote:
> Previously I've got an interrupt while removing the driver.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> Index: wireless-2.6/drivers/net/wireless/libertas/if_cs.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2008-01-25 13:54:08.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/if_cs.c	2008-01-25 13:54:50.000000000 +0100
> @@ -249,14 +249,14 @@ static irqreturn_t if_cs_interrupt(int i
>  	lbs_deb_enter(LBS_DEB_CS);
>  
>  	int_cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
> -	if(int_cause == 0x0) {
> +	if (int_cause == 0x0) {
>  		/* Not for us */
>  		return IRQ_NONE;
>  
>  	} else if (int_cause == 0xffff) {
>  		/* Read in junk, the card has probably been removed */
>  		card->priv->surpriseremoved = 1;
> -
> +		return IRQ_HANDLED;
>  	} else {
>  		if (int_cause & IF_CS_H_IC_TX_OVER)
>  			lbs_host_to_card_done(card->priv);
> @@ -715,8 +715,8 @@ static void if_cs_release(struct pcmcia_
>  
>  	lbs_deb_enter(LBS_DEB_CS);
>  
> -	pcmcia_disable_device(p_dev);
>  	free_irq(p_dev->irq.AssignedIRQ, card);
> +	pcmcia_disable_device(p_dev);
>  	if (card->iobase)
>  		ioport_unmap(card->iobase);
>  

