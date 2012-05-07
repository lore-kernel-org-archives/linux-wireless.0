Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41017 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757203Ab2EGRd4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 13:33:56 -0400
Message-ID: <1336412033.20924.6.camel@joe2Laptop> (sfid-20120507_193359_861058_4ECAE3CC)
Subject: Re: [PATCH] ath9k: Support ethtool getstats api.
From: Joe Perches <joe@perches.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Date: Mon, 07 May 2012 10:33:53 -0700
In-Reply-To: <1336411437-16653-1-git-send-email-greearb@candelatech.com>
References: <1336411437-16653-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-07 at 10:23 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This returns many of the values that formerly could
> only be obtained from debugfs.  This should be an
> improvement when trying to access these counters
> programatically.  Currently this support is only
> enabled when DEBUGFS is enabled because otherwise
> these stats are not accumulated.

trivia:

[]
> +#define ATH9K_SSTATS_LEN ARRAY_SIZE(ath9k_gstrings_stats)

I think there's not much value in this #define

> +static int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
> +				   struct ieee80211_vif *vif, int sset)
> +{
> +	if (sset == ETH_SS_STATS)
> +		return ATH9K_SSTATS_LEN;
> +	return 0;
> +}

Is this the only use?

