Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53602 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1ALQoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 11:44:39 -0500
Received: by fxm20 with SMTP id 20so716816fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 08:44:38 -0800 (PST)
Message-ID: <4D2DDA8B.8010501@lwfinger.net>
Date: Wed, 12 Jan 2011 10:44:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Miles Lane <miles.lane@gmail.com>, Sujith <m.sujith@gmail.com>
Subject: Re: [PATCH] mac80211: fix lockdep warning
References: <1294836033.3639.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1294836033.3639.24.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2011 06:40 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since the introduction of the fixes for the
> reorder timer, mac80211 will cause lockdep
> warnings because lockdep confuses
> local->skb_queue and local->rx_skb_queue
> and treats their lock as the same.
> 
> However, their locks are different, and are
> valid in different contexts (the former is
> used in IRQ context, the latter in BH only)
> and the only thing to be done is mark the
> former as a different lock class so that
> lockdep can tell the difference.
> 
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-by: Sujith <m.sujith@gmail.com>
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Tested-by: Sujith <m.sujith@gmail.com>
> Tested-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/main.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> --- wireless-testing.orig/net/mac80211/main.c	2011-01-12 09:58:07.000000000 +0100
> +++ wireless-testing/net/mac80211/main.c	2011-01-12 10:02:03.000000000 +0100
> @@ -39,6 +39,8 @@ module_param(ieee80211_disable_40mhz_24g
>  MODULE_PARM_DESC(ieee80211_disable_40mhz_24ghz,
>  		 "Disable 40MHz support in the 2.4GHz band");
>  
> +static struct lock_class_key ieee80211_rx_skb_queue_class;
> +
>  void ieee80211_configure_filter(struct ieee80211_local *local)
>  {
>  	u64 mc;
> @@ -569,7 +571,15 @@ struct ieee80211_hw *ieee80211_alloc_hw(
>  	spin_lock_init(&local->filter_lock);
>  	spin_lock_init(&local->queue_stop_reason_lock);
>  
> -	skb_queue_head_init(&local->rx_skb_queue);
> +	/*
> +	 * The rx_skb_queue is only accessed from tasklets,
> +	 * but other SKB queues are used from within IRQ
> +	 * context. Therefore, this one needs a different
> +	 * locking class so our direct, non-irq-safe use of
> +	 * the queue's lock doesn't throw lockdep warnings.
> +	 */
> +	skb_queue_head_init_class(&local->rx_skb_queue,
> +				  &ieee80211_rx_skb_queue_class);
>  
>  	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
>  
> 
> 

This one works for me. Thanks for sorting this out.

Larry
