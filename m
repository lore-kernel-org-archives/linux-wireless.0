Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6520 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2AKMzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 07:55:40 -0500
Message-ID: <4F0D86C6.1040304@qca.qualcomm.com> (sfid-20120111_135543_861656_385964E9)
Date: Wed, 11 Jan 2012 14:55:34 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thirumalai <tpachamu@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 3/4] ath6kl: Add uAPSD support in rx path.
References: <1326095135-1633-1-git-send-email-tpachamu@qca.qualcomm.com>
In-Reply-To: <1326095135-1633-1-git-send-email-tpachamu@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 09:45 AM, Thirumalai wrote:
> If uAPSD trigger is received, send out the packets in uAPSD
> queue. Set more data bit if the queue is not empty else
> update the uAPSD bitmap for the station.
> 
> Signed-off-by: Thirumalai <tpachamu@qca.qualcomm.com>

[...]

> +	/*
> +	 * If the APSD q for this STA is not empty, dequeue and
> +	 * send a pkt from the head of the q. Also update the
> +	 * More data bit in the WMI_DATA_HDR if there are
> +	 * more pkts for this STA in the APSD q.
> +	 * If there are no more pkts for this STA,
> +	 * update the APSD bitmap for this STA.
> +	 */
> +
> +	num_frames_to_deliver = (conn->apsd_info >> 4) & 0xF;

Defines would be nice for values 4 and 0xF.

> +
> +	/*
> +	 * Number of frames to send in a service period is
> +	 * indicated by the station
> +	 * in the QOS_INFO of the association request
> +	 * If it is zero, send all frames
> +	 */
> +	if (!num_frames_to_deliver)
> +		num_frames_to_deliver = 0xFFFF;

And for 0xFFFF.

> +
> +	spin_lock_bh(&conn->psq_lock);
> +	is_apsdq_empty  = skb_queue_empty(&conn->apsdq);

Extra space after is_apsdq_empty.

> -				while ((skbuff = skb_dequeue(&conn->psq))
> -				       != NULL) {
> +				skbuff = skb_dequeue(&conn->psq);
> +				while (skbuff != NULL) {
> +					spin_unlock_bh(&conn->psq_lock);
> +					ath6kl_data_tx(skbuff, vif->ndev);
> +					spin_lock_bh(&conn->psq_lock);
> +					skbuff = skb_dequeue(&conn->psq);
> +				}

I would say the original style is better:

while ((skbuff = skb_dequeue(&conn->psq))

> +
> +				is_apsdq_empty = skb_queue_empty(&conn->apsdq);
> +				skbuff = skb_dequeue(&conn->apsdq);
> +				while (skbuff != NULL) {
>  					spin_unlock_bh(&conn->psq_lock);
>  					ath6kl_data_tx(skbuff, vif->ndev);
>  					spin_lock_bh(&conn->psq_lock);
> +					skbuff = skb_dequeue(&conn->apsdq);
>  				}

Same here.

Kalle
