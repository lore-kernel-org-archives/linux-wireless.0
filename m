Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZK3QQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 11:16:37 -0500
Subject: Re: [PATCH v3 2/2] iwmc3200wifi: rx aggregation support
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1259555157-10866-2-git-send-email-yi.zhu@intel.com>
References: <1259555157-10866-1-git-send-email-yi.zhu@intel.com>
	 <1259555157-10866-2-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 17:16:36 +0100
Message-ID: <1259597796.2182.10.camel@caravaggio>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

On Mon, 2009-11-30 at 12:25 +0800, Zhu Yi wrote:
>  static void iwm_rx_process_packet(struct iwm_priv *iwm,
>  				  struct iwm_rx_packet *packet,
>  				  struct iwm_rx_ticket_node *ticket_node)
> @@ -1548,22 +1579,31 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
>  	switch (le16_to_cpu(ticket_node->ticket->action)) {
>  	case IWM_RX_TICKET_RELEASE:
>  		IWM_DBG_RX(iwm, DBG, "RELEASE packet\n");
> +
> +		skb->dev = iwm_to_ndev(iwm);
> +		skb->protocol = eth_type_trans(skb, ndev);
> +		skb->ip_summed = CHECKSUM_NONE;
> +		memset(skb->cb, 0, sizeof(skb->cb));
> +
I dont think you want to do that processing before calling
iwm_rx_adjust_packet() and probably not even before
ieee80211_data_to_8023(). You need 802.3 frames for it to be relevant.
Moreover, you probably want to do it for every skb on the skb queue you
get from the amsdu processing.

Cheers,
Samuel.


>  		classify8023(skb);
>  		iwm_rx_adjust_packet(iwm, packet, ticket_node);
> +
> +		if (le16_to_cpu(ticket_node->ticket->flags) &
> +		    IWM_RX_TICKET_AMSDU_MSK) {
> +			iwm_rx_process_amsdu(iwm, skb);
> +			break;
> +		}
> +
>  		ret = ieee80211_data_to_8023(skb, ndev->dev_addr, wdev->iftype);
>  		if (ret < 0) {
>  			IWM_DBG_RX(iwm, DBG, "Couldn't convert 802.11 header - "
>  				   "%d\n", ret);
> +			kfree_skb(packet->skb);
>  			break;
>  		}
>  
>  		IWM_HEXDUMP(iwm, DBG, RX, "802.3: ", skb->data, skb->len);
>  
> -		skb->dev = iwm_to_ndev(iwm);
> -		skb->protocol = eth_type_trans(skb, ndev);
> -		skb->ip_summed = CHECKSUM_NONE;
> -		memset(skb->cb, 0, sizeof(skb->cb));
> -
>  		ndev->stats.rx_packets++;
>  		ndev->stats.rx_bytes += skb->len;
>  


