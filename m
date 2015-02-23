Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33155 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbbBWQJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 11:09:15 -0500
Message-ID: <1424707739.3075.19.camel@sipsolutions.net> (sfid-20150223_170918_359044_10C22D97)
Subject: Re: [PATCH] mac80211-hwsim:  Don't enqueue pkts that do not want
 txstatus.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Feb 2015 17:08:59 +0100
In-Reply-To: <1423592732-17256-1-git-send-email-greearb@candelatech.com>
References: <1423592732-17256-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-10 at 10:25 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, skb is not cleaned up until there is some timeout
> and the tx-queue quickly becomes overly full.

> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -928,10 +928,14 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
>  	genlmsg_end(skb, msg_head);
>  	genlmsg_unicast(&init_net, skb, dst_portid);
>  
> -	/* Enqueue the packet */
> -	skb_queue_tail(&data->pending, my_skb);
>  	data->tx_pkts++;
>  	data->tx_bytes += my_skb->len;
> +
> +	/* Enqueue the packet if we are expecting a tx-status response */
> +	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
> +		skb_queue_tail(&data->pending, my_skb);
> +	else
> +		ieee80211_free_txskb(hw, my_skb);

This doesn't really seem right - essentially it means that whatever you
just gave to userspace is now completely useless?

It seems skb_orphan() could/should be put here.

johannes

