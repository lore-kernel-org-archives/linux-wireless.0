Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2EBRAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 13:00:21 -0400
Message-ID: <1335978017.4295.0.camel@jlt3.sipsolutions.net> (sfid-20120502_190025_896172_8D67A376)
Subject: Re: [PATCH 3.4] mac80211: fix AP mode EAP tx for VLAN stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 02 May 2012 19:00:17 +0200
In-Reply-To: <1335707056-82230-1-git-send-email-nbd@openwrt.org>
References: <1335707056-82230-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-04-29 at 15:44 +0200, Felix Fietkau wrote:
> EAP frames for stations in an AP VLAN are sent on the main AP interface
> to avoid race conditions wrt. moving stations.
> For that to work properly, sta_info_get_bss must be used instead of
> sta_info_get when sending EAP packets.
> Previously this was only done for cooked monitor injected packets, so
> this patch adds a check for tx->skb->protocol to the same place.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@vger.kernel.org
> ---
>  net/mac80211/tx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 44001c7..d67d36f 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1159,7 +1159,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>  		tx->sta = rcu_dereference(sdata->u.vlan.sta);
>  		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
>  			return TX_DROP;
> -	} else if (info->flags & IEEE80211_TX_CTL_INJECTED) {
> +	} else if (info->flags & IEEE80211_TX_CTL_INJECTED ||
> +		   tx->sdata->control_port_protocol == tx->skb->protocol) {
>  		tx->sta = sta_info_get_bss(sdata, hdr->addr1);

Just the protocol check is probably sufficient, don't we set it for
injected frames anyway?

johannes

