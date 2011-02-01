Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1BANzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 08:55:20 -0500
Subject: Re: [PATCH v2] mac80211:  Recalculate channel-type on iface
 removal.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296502209-32533-1-git-send-email-greearb@candelatech.com>
References: <1296502209-32533-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 14:55:16 +0100
Message-ID: <1296568516.3989.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 11:30 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When a vif goes away, it could cause the super-chan
> to be recalculated differently, so do that calculation
> on iface removal.

Seems fine to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> v2:  Just deal with channel-change calc, not the WARN_ON_ONCE
>   stuff.  Will get that later in separate patch.
> 
> :100644 100644 605c222... abf5f8e... M	net/mac80211/iface.c
>  net/mac80211/iface.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 605c222..abf5f8e 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -382,6 +382,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  	struct sk_buff *skb, *tmp;
>  	u32 hw_reconf_flags = 0;
>  	int i;
> +	enum nl80211_channel_type orig_ct;
>  
>  	if (local->scan_sdata == sdata)
>  		ieee80211_scan_cancel(local);
> @@ -542,8 +543,14 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		hw_reconf_flags = 0;
>  	}
>  
> +	/* Re-calculate channel-type, in case there are multiple vifs
> +	 * on different channel types.
> +	 */
> +	orig_ct = local->_oper_channel_type;
> +	ieee80211_set_channel_type(local, NULL, NL80211_CHAN_NO_HT);
> +
>  	/* do after stop to avoid reconfiguring when we stop anyway */
> -	if (hw_reconf_flags)
> +	if (hw_reconf_flags || (orig_ct != local->_oper_channel_type))
>  		ieee80211_hw_config(local, hw_reconf_flags);
>  
>  	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);


