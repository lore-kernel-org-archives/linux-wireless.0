Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42325 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbcDNIkm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 04:40:42 -0400
Message-ID: <1460623232.2358.6.camel@sipsolutions.net> (sfid-20160414_104047_726442_ADA8C3E7)
Subject: Re: [PATCH v3 2/3] mac80211_hwsim: Add iface comb for DFS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Date: Thu, 14 Apr 2016 10:40:32 +0200
In-Reply-To: <1383653034-6679-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_130424_907681_CEAEBD68)
References: <1383653034-6679-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131105_130424_907681_CEAEBD68)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I know this is a LONG time ago, but nonetheless...

> -static struct ieee80211_iface_combination hwsim_if_comb = {
> -	.limits = hwsim_if_limits,
> -	.n_limits = ARRAY_SIZE(hwsim_if_limits),
> -	.max_interfaces = 2048,
> -	.num_different_channels = 1,
> +static const struct ieee80211_iface_limit hwsim_if_dfs_limits[] = {
> +	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) },
> +};
> +
> +static struct ieee80211_iface_combination hwsim_if_comb[] = {
> +	{
> +		.limits = hwsim_if_limits,
> +		.n_limits = ARRAY_SIZE(hwsim_if_limits),
> +		.max_interfaces = 2048,
> +		.num_different_channels = 1,
> +	},
> +	{
> +		.limits = hwsim_if_dfs_limits,
> +		.n_limits = ARRAY_SIZE(hwsim_if_dfs_limits),
> +		.max_interfaces = 8,
> +		.num_different_channels = 1,
> +		.radar_detect_widths =
> BIT(NL80211_CHAN_WIDTH_20_NOHT) |
> +				       BIT(NL80211_CHAN_WIDTH_20) |
> +				       BIT(NL80211_CHAN_WIDTH_40) |
> +				       BIT(NL80211_CHAN_WIDTH_80) |
> +				       BIT(NL80211_CHAN_WIDTH_160),
> +	}
>  };

I don't, at least today, but I don't see relevant changes since then,
understand why this was two combinations, one with fewer interfaces.

It seems that radar detection is mostly independent of the interface
types, at least as far as the code is concerned.

Are there some other considerations, that prevent declaring
radar_detect_widths together with the regular hwsim_if_limits? It
obviously cannot actually be *used* for all?

johannes
