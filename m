Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173AbYCSTnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:42 -0400
Subject: Re: [PATCH] libertas: fix spinlock recursion bug
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803191524.21866.hs4233@mail.mn-solutions.de>
References: <200803191524.21866.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 11:02:46 -0400
Message-Id: <1205938966.26119.37.camel@localhost.localdomain> (sfid-20080319_194519_562531_6C81A9A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-19 at 15:24 +0100, Holger Schurig wrote:
> This fixes a bug detected by CONFIG_DEBUG_SPINLOCK:
> 
> if_cs_get_int_status() is only called from lbs_thread(), via
> priv->hw_get_int_status. However, lbs_thread() has already taken the
> priv->driver_lock. So it's a fault to take the same lock again here.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> CONFIG_DEBUG_SPINLOCK,
> ---
> 
> John, this patch might also go into linux-2.6.25-rcX
> 
> Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-03-19 13:46:47.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-03-19 13:46:53.000000000 +0100
> @@ -677,9 +677,7 @@ sbi_get_int_status_exit:
>  
>  	/* Card has a command result for us */
>  	if (*ireg & IF_CS_C_S_CMD_UPLD_RDY) {
> -		spin_lock(&priv->driver_lock);
>  		ret = if_cs_receive_cmdres(priv, priv->upld_buf, &priv->upld_len);
> -		spin_unlock(&priv->driver_lock);
>  		if (ret < 0)
>  			lbs_pr_err("could not receive cmd from card\n");
>  	}

