Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53647 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaKOLFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 06:05:09 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so21450472wgg.5
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2014 03:05:08 -0800 (PST)
Date: Sat, 15 Nov 2014 12:05:00 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Jouni Malinen <j@w1.fi>, Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: skip legacy rate mask handling for VHT rates
Message-ID: <20141115110459.GA24766@magnum.frso.rivierawaves.com> (sfid-20141115_120528_098911_640016C7)
References: <1416019734-17509-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1416019734-17509-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2014 at 03:48:54AM +0100, Felix Fietkau wrote:
> The rate mask code currently assumes that a rate is legacy if
> IEEE80211_TX_RC_MCS is not set. This might be the cause of bogus VHT
> rates being reported with minstrel_ht.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  net/mac80211/rate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> index 6081329..f6fea67f 100644
> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -385,7 +385,7 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
>  			*rate = alt_rate;
>  			return;
>  		}
> -	} else {
> +	} else if (!(rate->flags & IEEE80211_TX_RC_VHT_MCS)) {
>  		/* handle legacy rates */
>  		if (rate_idx_match_legacy_mask(rate, sband->n_bitrates, mask))
>  			return;

Does it fix things on your side Jouni ?
 
Karl
