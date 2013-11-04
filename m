Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44191 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3KDUx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 15:53:29 -0500
Received: by mail-ea0-f175.google.com with SMTP id l15so3041000eak.20
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 12:53:28 -0800 (PST)
Message-ID: <52780946.4080807@gmail.com> (sfid-20131104_215344_786724_AB12EA5C)
Date: Mon, 04 Nov 2013 21:53:26 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: fix HT TX descriptor settings
 regression
References: <20131031102354.GA1796@redhat.com>
In-Reply-To: <20131031102354.GA1796@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/13 11:23, Stanislaw Gruszka wrote:
> Since:
> 
> commit 36323f817af0376c78612cfdab714b0feb05fea5
> Author: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> Date:   Mon Jul 23 21:33:42 2012 +0200
> 
>     mac80211: move TX station pointer and restructure TX
> 
> we do not pass sta pointer to rt2x00queue_create_tx_descriptor_ht(),
> hence we do not correctly set station WCID and AMPDU density parameters.
> 
> Cc: stable@vger.kernel.org # 3.7+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00lib.h   | 2 +-
>  drivers/net/wireless/rt2x00/rt2x00mac.c   | 4 ++--
>  drivers/net/wireless/rt2x00/rt2x00queue.c | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index a093598..7f40ab8 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -146,7 +146,7 @@ void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length);
>   * @local: frame is not from mac80211
>   */
>  int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
> -			       bool local);
> +			       struct ieee80211_sta *sta, bool local);
>  
>  /**
>   * rt2x00queue_update_beacon - Send new beacon from mac80211
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index 7c15785..2183e79 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -90,7 +90,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
>  				  frag_skb->data, data_length, tx_info,
>  				  (struct ieee80211_rts *)(skb->data));
>  
> -	retval = rt2x00queue_write_tx_frame(queue, skb, true);
> +	retval = rt2x00queue_write_tx_frame(queue, skb, NULL, true);
>  	if (retval) {
>  		dev_kfree_skb_any(skb);
>  		rt2x00_warn(rt2x00dev, "Failed to send RTS/CTS frame\n");
> @@ -151,7 +151,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw,
>  			goto exit_fail;
>  	}
>  
> -	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
> +	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, control->sta, false)))
>  		goto exit_fail;
>  
>  	/*
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 50590b1..a5d38e8 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -635,7 +635,7 @@ static void rt2x00queue_bar_check(struct queue_entry *entry)
>  }
>  
>  int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
> -			       bool local)
> +			       struct ieee80211_sta *sta, bool local)
>  {
>  	struct ieee80211_tx_info *tx_info;
>  	struct queue_entry *entry;
> @@ -649,7 +649,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
>  	 * after that we are free to use the skb->cb array
>  	 * for our information.
>  	 */
> -	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc, NULL);
> +	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc, sta);
>  
>  	/*
>  	 * All information is retrieved from the skb->cb array,
> 


-- 
---
Gertjan
