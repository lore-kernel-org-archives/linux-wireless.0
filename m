Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3DVNwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:52:53 -0400
Message-ID: <1366638766.8637.16.camel@jlt4.sipsolutions.net> (sfid-20130422_155256_694895_0728FBF1)
Subject: Re: [PATCH v5 1/3] mac80211: improve the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, karl.beldan@gmail.com
Date: Mon, 22 Apr 2013 15:52:46 +0200
In-Reply-To: <1366625393-11647-1-git-send-email-nbd@openwrt.org>
References: <1366625393-11647-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-22 at 12:09 +0200, Felix Fietkau wrote:

> @@ -692,16 +692,38 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>  	 */
>  	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
>  
> -	if (unlikely(info->control.rates[0].idx < 0))
> -		return TX_DROP;
> +	if (tx->sta && !info->control.skip_table)
> +		ratetbl = rcu_dereference(tx->sta->sta.rates);
> +
> +	if (unlikely(info->control.rates[0].idx < 0)) {
> +		if (ratetbl) {
> +			struct ieee80211_tx_rate rate = {
> +				.idx = ratetbl->rate[0].idx,
> +				.flags = ratetbl->rate[0].flags,
> +				.count = ratetbl->rate[0].count
> +			};
> +
> +			if (ratetbl->rate[0].idx < 0)
> +				return TX_DROP;

This can't happen, idx is unsigned. Did you intend idx to be signed?

johannes

