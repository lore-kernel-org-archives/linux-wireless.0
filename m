Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3HTVAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 17:00:04 -0400
Message-ID: <1377032397.13829.40.camel@jlt4.sipsolutions.net> (sfid-20130820_230013_318188_D7B2AFAE)
Subject: Re: [PATCH 01/16] wcn36xx: Add main.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Tue, 20 Aug 2013 22:59:57 +0200
In-Reply-To: <1377020479-16935-2-git-send-email-k.eugene.e@gmail.com> (sfid-20130820_194139_161691_2D6AE83A)
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	 <1377020479-16935-2-git-send-email-k.eugene.e@gmail.com>
	 (sfid-20130820_194139_161691_2D6AE83A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a cursory review ...


> +		.cap = IEEE80211_HT_CAP_GRN_FLD
> +			| IEEE80211_HT_CAP_SGI_20

wouldn't that usually be written as

GRN_FLD |
SGI_20 |
...

(multiple similar places)

> +#ifdef CONFIG_PM
> +
> +static const struct wiphy_wowlan_support wowlan_support = {
> +	.flags = WIPHY_WOWLAN_ANY,
> +	.n_patterns = 0,

that n_patterns is pretty useless.


> +#define WCN36XX_SUPPORTED_FILTERS (0)
> +
> +static void wcn36xx_configure_filter(struct ieee80211_hw *hw,
> +				       unsigned int changed,
> +				       unsigned int *total, u64 multicast)
> +{
> +	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac configure filter");
> +
> +	changed &= WCN36XX_SUPPORTED_FILTERS;

That's pointless

> +		if (IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags) {
> +			sta_priv->is_data_encrypted = true;
> +			/* Reconfigure bss with encrypt_type */
> +			if (NL80211_IFTYPE_STATION == vif->type)
> +				wcn36xx_smd_config_bss(wcn,
> +						       vif,
> +						       sta,
> +						       sta->addr,
> +						       true);

It seems to me this should not be here but you should have mac80211 set
something in e.g. bss_conf that indicates encryption?


> +	/* Not supported so far*/
> +	case IEEE80211_AMPDU_TX_STOP_CONT:
> +		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
> +		break;
> +	case IEEE80211_AMPDU_TX_STOP_FLUSH:
> +	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
> +		break;

You can't just "not support" them - you have to at least stop the
aggregation session, see the commit that introduced this.

> +	static const u32 cipher_suites[] = {
> +		WLAN_CIPHER_SUITE_TKIP,
> +		WLAN_CIPHER_SUITE_CCMP,
> +	};

You actually don't want to support WEP, not even in software? Otherwise
just leave this out and mac80211 will add it.

> +	wcn->hw->wiphy->iface_combinations = &if_comb;
> +	wcn->hw->wiphy->n_iface_combinations = 1;

Your code with "wcn->current_vif = " etc. *really* doesn't look like you
support combinations. Are you positive this is OK?

> +	wcn->hw->wiphy->max_scan_ssids = 1;

Really? You don't even have hardware scan, so why?

johannes

