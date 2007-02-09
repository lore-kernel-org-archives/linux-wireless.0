Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59927
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946123AbXBIFum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 00:50:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] d80211: remove hosttime from ieee80211_rx_status
Date: Fri, 9 Feb 2007 06:50:11 +0100
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200702082359.47085.flamingice@sourmilk.net>
In-Reply-To: <200702082359.47085.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200702090650.11910.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 February 2007 05:59, Michael Wu wrote:
> d80211: remove hosttime from ieee80211_rx_status
> 
> Nobody fills hosttime in ieee80211_rx_status. Removing it allows
> ieee80211_rx_status to fit in skb->cb.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> ---

I'd like to see some kind of
BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
somewhere in the code to prevent unintentional future bugs.

>  include/net/d80211.h   |    1 -
>  net/d80211/ieee80211.c |   25 +++++--------------------
>  2 files changed, 5 insertions(+), 21 deletions(-)
> 
> diff --git a/include/net/d80211.h b/include/net/d80211.h
> index 326def5..0b7b963 100644
> --- a/include/net/d80211.h
> +++ b/include/net/d80211.h
> @@ -225,7 +225,6 @@ struct ieee80211_tx_control {
>   * (the subset supported by hardware) to the 802.11 code with each received
>   * frame. */
>  struct ieee80211_rx_status {
> -        u64 hosttime;
>  	u64 mactime;
>          int freq; /* receive frequency in Mhz */
>          int channel;
> diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
> index bbcefa9..7a92bfe 100644
> --- a/net/d80211/ieee80211.c
> +++ b/net/d80211/ieee80211.c
> @@ -2627,7 +2627,7 @@ ieee80211_fill_frame_info(struct ieee802
>                  struct timespec ts;
>  		struct ieee80211_rate *rate;
>  
> -                jiffies_to_timespec(status->hosttime, &ts);
> +		jiffies_to_timespec(jiffies, &ts);
>  		fi->hosttime = cpu_to_be64((u64) ts.tv_sec * 1000000 +
>  					   ts.tv_nsec / 1000);
>  		fi->mactime = cpu_to_be64(status->mactime);
> @@ -4019,25 +4019,11 @@ static void ieee80211_stat_refresh(unsig
>  void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb,
>  			  struct ieee80211_rx_status *status)
>  {
> -	struct ieee80211_rx_status *saved;
>  	struct ieee80211_local *local = hw_to_local(hw);
>  
>  	skb->dev = local->mdev;
> -	saved = kmalloc(sizeof(struct ieee80211_rx_status), GFP_ATOMIC);
> -	if (unlikely(!saved)) {
> -		if (net_ratelimit())
> -			printk(KERN_WARNING "%s: Not enough memory, "
> -			       "dropping packet", skb->dev->name);
> -		/* should be dev_kfree_skb_irq, but due to this function being
> -		 * named _irqsafe instead of just _irq we can't be sure that
> -		 * people won't call it from non-irq contexts */
> -		dev_kfree_skb_any(skb);
> -		return;
> -	}
> -	memcpy(saved, status, sizeof(struct ieee80211_rx_status));
> -	/* copy pointer to saved status into skb->cb for use by tasklet */
> -	memcpy(skb->cb, &saved, sizeof(saved));
> -
> +	/* copy status into skb->cb for use by tasklet */
> +	memcpy(skb->cb, status, sizeof(struct ieee80211_rx_status));
>  	skb->pkt_type = ieee80211_rx_msg;
>  	skb_queue_tail(&local->skb_queue, skb);
>  	tasklet_schedule(&local->tasklet);
> @@ -4096,13 +4082,12 @@ static void ieee80211_tasklet_handler(un
>  	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
>                  switch (skb->pkt_type) {
>  		case ieee80211_rx_msg:
> -			/* get pointer to saved status out of skb->cb */
> -			memcpy(&rx_status, skb->cb, sizeof(rx_status));
> +			/* status is in skb->cb */
> +			rx_status = (struct ieee80211_rx_status *) skb->cb;
>  			/* Clear skb->type in order to not confuse kernel
>  			 * netstack. */
>  			skb->pkt_type = 0;
>  			__ieee80211_rx(local_to_hw(local), skb, rx_status);
> -			kfree(rx_status);
>  			break;
>  		case ieee80211_tx_status_msg:
>  			/* get pointer to saved status out of skb->cb */
> 
