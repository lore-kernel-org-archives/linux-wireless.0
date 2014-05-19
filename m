Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01-fr.bfs.de ([193.174.231.67]:51161 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbaESHnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 03:43:37 -0400
Message-ID: <5379B61D.7070501@bfs.de> (sfid-20140519_094357_238414_F8EA7F92)
Date: Mon, 19 May 2014 09:43:25 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: "John W. Linville" <linville@tuxdriver.com>,
	kernel-janitors@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/13] libertas: make return of 0 explicit
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr> <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 19.05.2014 06:31, schrieb Julia Lawall:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete unnecessary local variable whose value is always 0 and that hides
> the fact that the result is always 0.
> 
> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> local idexpression ret;
> expression e;
> position p;
> @@
> 
> -ret = 0;
> ... when != ret = e
> return 
> - ret
> + 0
>   ;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Alternatively, was an error code intended in the bad length case, as is
> done in process_brxed_802_11_packet?
> 
>  drivers/net/wireless/libertas/rx.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
> index c7366b0..807c5b8 100644
> --- a/drivers/net/wireless/libertas/rx.c
> +++ b/drivers/net/wireless/libertas/rx.c
> @@ -55,7 +55,6 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
>   */
>  int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
>  {
> -	int ret = 0;
>  	struct net_device *dev = priv->dev;
>  	struct rxpackethdr *p_rx_pkt;
>  	struct rxpd *p_rx_pd;
> @@ -86,7 +85,6 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
>  	if (skb->len < (ETH_HLEN + 8 + sizeof(struct rxpd))) {
>  		lbs_deb_rx("rx err: frame received with bad length\n");
>  		dev->stats.rx_length_errors++;
> -		ret = 0;
>  		dev_kfree_skb(skb);
>  		goto done;
>  	}
> @@ -154,10 +152,9 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
>  	else
>  		netif_rx_ni(skb);
>  
> -	ret = 0;
>  done:
> -	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
> -	return ret;
> +	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", 0);
> +	return 0;
>  }

i guess lbs_deb_leave_args() is obsolet now.

re,
 wh


>  EXPORT_SYMBOL_GPL(lbs_process_rxed_packet);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
