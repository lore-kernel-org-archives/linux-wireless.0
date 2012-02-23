Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50295 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2BWQw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 11:52:58 -0500
Received: by bkcjm19 with SMTP id jm19so1245161bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 08:52:57 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in power-save mode.
Date: Thu, 23 Feb 2012 17:52:44 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr>
In-Reply-To: <1330012414-26559-1-git-send-email-cavallar@lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201202231752.44125.chunkeey@googlemail.com> (sfid-20120223_175301_802948_F896606C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, February 23, 2012 04:53:34 PM Nicolas Cavallari wrote:
> On Access Point mode, when transmitting a packet, if the destination
> station is in powersave mode, we abort transmitting the packet to the
> device queue, but we do not reclaim the allocated memory.  Given enough
> packets, we can go in a state where there is no packet on the device
> queue, but we think the device has no memory left, so no packet gets
> transmitted, connections breaks and the AP stops working.
> 
> This undo the allocation done in the TX path when the station is in
> power-save mode.
> 
> Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Cc: stable <stable@vger.kernel.org>

> ---
> While this seems to fix my problem, there could still be problems remaining
> in this code path.  Particularly carl9170_tx_status will do lots of things
> like incrementing counters and waking up mac80211 queues...
That should be alright. As a rule of thumb, for every call to
carl9170_tx_accounting [called by carl9170_op_tx tx handler]
we need to call carl9170_tx_status. If the station is still in
ps mode, mac80211 will cache the station's frames and sets
the TIM bits. 

> 
> diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
> index 771e1a9..8d52ddd 100644
> --- a/drivers/net/wireless/ath/carl9170/tx.c
> +++ b/drivers/net/wireless/ath/carl9170/tx.c
> @@ -1253,6 +1253,7 @@ static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
>  			atomic_dec(&ar->tx_ampdu_upload);
>  
>  		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
> +		carl9170_release_dev_space(ar, skb);
>  		carl9170_tx_status(ar, skb, false);
>  		return true;
>  	}
> 
