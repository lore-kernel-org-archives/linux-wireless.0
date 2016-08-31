Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:33575 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935178AbcHaPJU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 11:09:20 -0400
Message-ID: <1472656150.4176.7.camel@perches.com> (sfid-20160831_170938_911055_600A5F3E)
Subject: Re: [PATCH] mwifiex: scan: Simplify code
From: Joe Perches <joe@perches.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        akarwar@marvell.com, nishants@marvell.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 31 Aug 2016 08:09:10 -0700
In-Reply-To: <1472644259-15605-1-git-send-email-christophe.jaillet@wanadoo.fr>
References: <1472644259-15605-1-git-send-email-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-31 at 13:50 +0200, Christophe JAILLET wrote:
> This patch:
>    - improves code layout
>    - removes a useless memset(0) for some memory allocated with kzalloc
>    - removes a useless if. We know that 'if (chan_band_tlv)' will succeed
>      because it has been tested a few lines above

True, the code above it is also confusing as it's

#ifdef CONFIG_PM
	if (priv->wdev.wiphy->wowlan_config)
		nd_config = priv->wdev.wiphy->wowlan_config->nd_config;
#endif

	if (nd_config) {
		adapter->nd_info =
			kzalloc(sizeof(struct cfg80211_wowlan_nd_match) +
				sizeof(struct cfg80211_wowlan_nd_match *) *
				scan_rsp->number_of_sets, GFP_ATOMIC);

		if (adapter->nd_info)
			adapter->nd_info->n_matches = scan_rsp->number_of_sets;
	}
where nd_config is a pointer already initialized to NULL
so the #endif seems misplaced.

> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
[]
> @@ -2179,18 +2179,14 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,

>  
>  		if (chan_band_tlv && adapter->nd_info) {
>  			adapter->nd_info->matches[idx] =
> -				kzalloc(sizeof(*pmatch) +
> -				sizeof(u32), GFP_ATOMIC);
> +				kzalloc(sizeof(*pmatch) + sizeof(u32),
> +					GFP_ATOMIC);
>  
>  			pmatch = adapter->nd_info->matches[idx];
>  
>  			if (pmatch) {
> -				memset(pmatch, 0, sizeof(*pmatch));
> -				if (chan_band_tlv) {
> -					pmatch->n_channels = 1;
> -					pmatch->channels[0] =
> -						chan_band->chan_number;
> -				}
> +				pmatch->n_channels = 1;
> +				pmatch->channels[0] = chan_band->chan_number;
>  			}
>  		}

Maybe it'd be better to move the pmatch declaration to this block
and alloc to pmatch then assign adapter->nd_info->matches[idx]
later.

I think the #ifdef CONFIG_PM use in this routine is incomplete.
