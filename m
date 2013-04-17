Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44678 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab3DQP1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:27:51 -0400
Received: by mail-wi0-f174.google.com with SMTP id m6so2769176wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 08:27:50 -0700 (PDT)
Date: Wed, 17 Apr 2013 17:23:39 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2 3/5] mac80211: improve the rate control API
Message-ID: <20130417152339.GA4319@magnum.frso.rivierawaves.com> (sfid-20130417_172755_667922_66FA11D4)
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org>
 <1366112326-92981-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366112326-92981-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 16, 2013 at 01:38:44PM +0200, Felix Fietkau wrote:
> @@ -692,16 +692,38 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>  	 */
>  	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
>  
> -	if (unlikely(info->control.rates[0].idx < 0))
> -		return TX_DROP;
> +	if (tx->sta)
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
> +
> +			tx->rate = rate;
tx->rate = ratetbl->rate[0];

 
Karl
