Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759659Ab1D2QBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 12:01:00 -0400
Subject: Re: [PATCH wireless-2.6 v2] iwlagn: fix "Received BA when not
 expected"
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110429155105.GB5537@redhat.com>
References: <20110429155105.GB5537@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 18:00:53 +0200
Message-ID: <1304092853.21342.2.camel@jlt3.sipsolutions.net> (sfid-20110429_180106_263451_72068A90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-29 at 17:51 +0200, Stanislaw Gruszka wrote:
> Need to use broadcast sta_id for management frames, otherwise we broke
> BA session in the firmware and get messages like that:
> 
> "Received BA when not expected"
> 
> or (on older kernels):
> 
> "BA scd_flow 0 does not match txq_id 10"
> 
> This fix regression introduced in 2.6.35 during station management
> code rewrite by:
> 
> commit 2a87c26bbe9587baeb9e56d3ce0b4971bd777643
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Apr 30 11:30:45 2010 -0700
> 
>     iwlwifi: use iwl_find_station less
> 
> Patch partially resolve:
> https://bugzilla.kernel.org/show_bug.cgi?id=16691
> However, there are still 11n performance problems on 4965 and 5xxx
> devices that need to be investigated.
> 
> Cc: stable@kernel.org # 2.6.35+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Clearly, the behaviour here was modified by me.That wasn't intentional,
but I still want to find out why it breaks anything. But that'll have to
wait, I have too much other stuff to fix up right now :(

Thanks.

johannes

> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> index 494de0e..4afae14 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> @@ -582,12 +582,17 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>  
>  	hdr_len = ieee80211_hdrlen(fc);
>  
> -	/* Find index into station table for destination station */
> -	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
> -	if (sta_id == IWL_INVALID_STATION) {
> -		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
> -			       hdr->addr1);
> -		goto drop_unlock;
> +	/* For management frames use broadcast id to do not break aggregation */
> +	if (!ieee80211_is_data(fc))
> +		sta_id = ctx->bcast_sta_id;
> +	else {
> +		/* Find index into station table for destination station */
> +		sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
> +		if (sta_id == IWL_INVALID_STATION) {
> +			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
> +				       hdr->addr1);
> +			goto drop_unlock;
> +		}
>  	}
>  
>  	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);


