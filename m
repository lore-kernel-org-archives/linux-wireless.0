Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbYFELeu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 07:34:50 -0400
Subject: Re: [PATCH 1/3] libertas: fix interrupt issue
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200806051306.15592.hs4233@mail.mn-solutions.de>
References: <200806051306.15592.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 07:34:28 -0400
Message-Id: <1212665668.25730.0.camel@localhost.localdomain> (sfid-20080605_133454_154671_81498BA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-05 at 13:06 +0200, Holger Schurig wrote:
> This helps against lost interrupts and aids in debugging this.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-05-30 11:26:35.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-05-30 11:30:09.000000000 +0200
> @@ -379,6 +379,8 @@ static irqreturn_t if_cs_interrupt(int i
>  
>  	/* Ask card interrupt cause register if there is something for us */
>  	cause = if_cs_read16(card, IF_CS_CARD_INT_CAUSE);
> +	lbs_deb_cs("cause 0x%04x\n", cause);
> +
>  	if (cause == 0) {
>  		/* Not for us */
>  		return IRQ_NONE;
> @@ -390,10 +392,6 @@ static irqreturn_t if_cs_interrupt(int i
>  		return IRQ_HANDLED;
>  	}
>  
> -	/* Clear interrupt cause */
> -	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, cause & IF_CS_BIT_MASK);
> -	lbs_deb_cs("cause 0x%04x\n", cause);
> -
>  	if (cause & IF_CS_BIT_RX) {
>  		struct sk_buff *skb;
>  		lbs_deb_cs("rx packet\n");
> @@ -434,6 +432,9 @@ static irqreturn_t if_cs_interrupt(int i
>  		lbs_queue_event(priv, event >> 8 & 0xff);
>  	}
>  
> +	/* Clear interrupt cause */
> +	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, cause & IF_CS_BIT_MASK);
> +
>  	lbs_deb_leave(LBS_DEB_CS);
>  	return IRQ_HANDLED;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

