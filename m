Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64427 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1AJTLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 14:11:21 -0500
Received: by fxm20 with SMTP id 20so19160522fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 11:11:20 -0800 (PST)
Message-ID: <4D2B59EA.4000200@lwfinger.net>
Date: Mon, 10 Jan 2011 13:11:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Locking problem reported for mainline
References: <4D2A9309.7000500@lwfinger.net> <201101101913.17311.chunkeey@googlemail.com>
In-Reply-To: <201101101913.17311.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2011 12:13 PM, Christian Lamparter wrote:
> Does this patch help?
> 
> ---
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a6701ed..8f13a83 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -549,7 +549,9 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
>  	tid_agg_rx->reorder_buf[index] = NULL;
>  	status = IEEE80211_SKB_RXCB(skb);
>  	status->rx_flags |= IEEE80211_RX_DEFERRED_RELEASE;
> -	skb_queue_tail(&local->rx_skb_queue, skb);
> +	spin_lock(&rx->local->rx_skb_queue.lock);
> +	__skb_queue_tail(&local->rx_skb_queue, skb);
> +	spin_unlock(&rx->local->rx_skb_queue.lock);
>  
>  no_frame:
>  	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
> @@ -780,7 +782,9 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>  		return;
>  
>   dont_reorder:spin_lock(&rx->local->rx_skb_queue.lock);
> -	skb_queue_tail(&local->rx_skb_queue, skb);
> +	spin_lock(&rx->local->rx_skb_queue.lock);
> +	__skb_queue_tail(&local->rx_skb_queue, skb);
> +	spin_unlock(&rx->local->rx_skb_queue.lock);
>  }
>  
>  static ieee80211_rx_result debug_noinline

Did not compile. In ieee80211_release_reorder_frame at lines 552 and 554, rx is
not defined.

Larry
