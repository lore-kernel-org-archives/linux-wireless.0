Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaBSLDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:03:30 -0500
Message-ID: <1392807806.4733.14.camel@jlt4.sipsolutions.net> (sfid-20140219_120333_181371_EB06538E)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linville@tuxdriver.com
Date: Wed, 19 Feb 2014 12:03:26 +0100
In-Reply-To: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195443_300379_ECEC4EEB)
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140212_195443_300379_ECEC4EEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-12 at 19:54 +0100, Janusz Dziedzic wrote:

> -#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
> -{							\
> -	.freq_range.start_freq_khz = MHZ_TO_KHZ(start),	\
> -	.freq_range.end_freq_khz = MHZ_TO_KHZ(end),	\
> -	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),	\
> -	.power_rule.max_antenna_gain = DBI_TO_MBI(gain),\
> -	.power_rule.max_eirp = DBM_TO_MBM(eirp),	\
> -	.flags = reg_flags,				\
> +#define REG_RULE_EXT(start, end, bw, gain, eirp, dfs_cac, reg_flags)	\
> +{									\
> +	.freq_range.start_freq_khz = MHZ_TO_KHZ(start),			\
> +	.freq_range.end_freq_khz = MHZ_TO_KHZ(end),			\
> +	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),			\
> +	.power_rule.max_antenna_gain = DBI_TO_MBI(gain),		\
> +	.power_rule.max_eirp = DBM_TO_MBM(eirp),			\
> +	.flags = reg_flags,						\
> +	.dfs_cac_ms = dfs_cac,						\
>  }
>  
> +#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
> +	REG_RULE_EXT(start, end, bw, gain, eirp, 0, reg_flags)

I don't see any users of this, is that really useful?

johannes

