Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab0CaQhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 12:37:46 -0400
Subject: Re: [PATCH 1/2 v3] mac80211: Handle mesh action frames in
 ieee80211_rx_h_action
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Steve Derosier <steve@cozybit.com>,
	devel@lists.open80211s.org
In-Reply-To: <1269885621-10257-1-git-send-email-javier@cozybit.com>
References: <1269844239.4131.3.camel@jlt3.sipsolutions.net>
	 <1269885621-10257-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 18:37:41 +0200
Message-ID: <1270053461.16210.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 11:00 -0700, Javier Cardona wrote:
> This fixes the problem introduced in commit
> 8404080568613d93ad7cf0a16dfb68 which broke mesh peer link establishment.
> 
> changes:
> v2 	Added missing break (Johannes)
> v3 	Broke original patch into two (Johannes)
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>

Cc: stable@kernel.org
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mesh.c |    3 ---
>  net/mac80211/rx.c   |    5 +++++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 61080c5..7a6bebc 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -749,9 +749,6 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
>  
>  	switch (fc & IEEE80211_FCTL_STYPE) {
>  	case IEEE80211_STYPE_ACTION:
> -		if (skb->len < IEEE80211_MIN_ACTION_SIZE)
> -			return RX_DROP_MONITOR;
> -		/* fall through */
>  	case IEEE80211_STYPE_PROBE_RESP:
>  	case IEEE80211_STYPE_BEACON:
>  		skb_queue_tail(&ifmsh->skb_queue, skb);
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 1da57c8..1e03972 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1964,6 +1964,11 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>  			goto handled;
>  		}
>  		break;
> +	case MESH_PLINK_CATEGORY:
> +	case MESH_PATH_SEL_CATEGORY:
> +		if (ieee80211_vif_is_mesh(&sdata->vif))
> +			return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
> +		break;
>  	}
>  
>  	/*


