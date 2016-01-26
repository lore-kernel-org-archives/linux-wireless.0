Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39693 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbcAZN1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:27:23 -0500
Message-ID: <1453814840.2759.52.camel@sipsolutions.net> (sfid-20160126_142726_220880_CD250ED1)
Subject: Re: [PATCH v2] mac80211: Parse legacy and HT rate in injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>, linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 26 Jan 2016 14:27:20 +0100
In-Reply-To: <1453728154-20070-1-git-send-email-sven@narfation.org>
References: <1453728154-20070-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
>  	CALL_TXH(ieee80211_tx_h_select_key);
> -	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
> +	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL) &&
> +	    !(info->control.flags & IEEE80211_TX_CTRL_RATE_INJECT))
>  		CALL_TXH(ieee80211_tx_h_rate_ctrl);

This seems a bit problematic. ieee80211_tx_h_rate_ctrl() also sets up
some protection, e.g.

        info->control.use_rts = txrc.rts;
        info->control.use_cts_prot = tx->sdata->vif.bss_conf.use_cts_prot;

and preamble settings

        info->control.short_preamble = txrc.short_preamble;

Are you sure you want to skip that entirely?

> +		info->control.rates[0].flags = rate_flags;
> +		if (rate_retries + 1 > local->hw.max_rate_tries)
> +			info->control.rates[0].count = local-
> >hw.max_rate_tries;
> +		else
> +			info->control.rates[0].count = rate_retries
> + 1;

max() or max_t()?

>  	/* process and remove the injection radiotap header */
> -	if (!ieee80211_parse_tx_radiotap(skb))
> +	if (!ieee80211_parse_tx_radiotap(skb, local))
>  		goto fail;

I'd prefer adding "local" as the first argument since that's far more
commonly done in mac80211.


johannes
