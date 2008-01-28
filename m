Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbYA1Qko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:40:44 -0500
Subject: Re: [PATCH] libertas: misc cleanups in compact-flash code
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200801281724.21321.hs4233@mail.mn-solutions.de>
References: <200801281724.21321.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 11:36:34 -0500
Message-Id: <1201538194.14441.2.camel@localhost.localdomain> (sfid-20080128_164049_127298_FD847F00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-01-28 at 17:24 +0100, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> Index: wireless-2.6/drivers/net/wireless/libertas/if_cs.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2008-01-25 13:57:44.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/if_cs.c	2008-01-25 13:58:30.000000000 +0100
> @@ -396,11 +396,9 @@ static struct sk_buff *if_cs_receive_dat
>  	if (len == 0 || len > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
>  		lbs_pr_err("card data buffer has invalid # of bytes (%d)\n", len);
>  		priv->stats.rx_dropped++;
> -		printk(KERN_INFO "##HS %s:%d TODO\n", __FUNCTION__, __LINE__);
>  		goto dat_err;
>  	}
>  
> -	//TODO: skb = dev_alloc_skb(len+ETH_FRAME_LEN+MRVDRV_SNAP_HEADER_LEN+EXTRA_LEN);
>  	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + 2);
>  	if (!skb)
>  		goto out;
> @@ -912,6 +910,7 @@ static void if_cs_detach(struct pcmcia_d
>  	if_cs_disable_ints(card);
>  	if_cs_release(p_dev);
>  	kfree(card);
> +	card = NULL;

This seems kind of pointless; card is a local variable and isn't used
anywhere after this.

Dan
 
>  	lbs_deb_leave(LBS_DEB_CS);
>  }

