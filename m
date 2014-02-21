Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaBUIwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:52:34 -0500
Message-ID: <1392972748.4346.37.camel@jlt4.sipsolutions.net> (sfid-20140221_095237_770384_89420BF9)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linville@tuxdriver.com
Date: Fri, 21 Feb 2014 09:52:28 +0100
In-Reply-To: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195443_300379_ECEC4EEB)
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140212_195443_300379_ECEC4EEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-12 at 19:54 +0100, Janusz Dziedzic wrote:

> +++ b/include/net/regulatory.h
> @@ -155,6 +155,7 @@ struct ieee80211_reg_rule {
>  	struct ieee80211_freq_range freq_range;
>  	struct ieee80211_power_rule power_rule;
>  	u32 flags;
> +	u32 dfs_cac_ms;
>  };

Does that really have to be per channel? That's a significant investment
into bss size since we have a lot of channel structs.

> +	if (rule1->dfs_cac_ms > rule2->dfs_cac_ms)
> +		intersected_rule->dfs_cac_ms = rule1->dfs_cac_ms;
> +	else
> +		intersected_rule->dfs_cac_ms = rule2->dfs_cac_ms;

please just use max() or max_t() if needed (shouldn't be)

> @@ -2245,9 +2258,10 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
>  	const struct ieee80211_reg_rule *reg_rule = NULL;
>  	const struct ieee80211_freq_range *freq_range = NULL;
>  	const struct ieee80211_power_rule *power_rule = NULL;
> -	char bw[32];
> +	const int size = 32;
> +	char bw[size], cac_time[size];

I don't like that, size is const but it seems likely that sparse/smatch
may complain. I've already changed some of the below code to just use
sizeof(bw), please do that here as well.

johannes

