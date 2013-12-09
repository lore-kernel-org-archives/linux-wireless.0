Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp05.online.nl ([194.134.41.35]:47155 "EHLO smtp05.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760668Ab3LISPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 13:15:21 -0500
Message-ID: <52A60603.3010606@meshcoding.com> (sfid-20131209_191525_674482_F1BF109D)
Date: Mon, 09 Dec 2013 19:03:47 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: add helper functions for tracking P2P NoA state
References: <1386604742-8560-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1386604742-8560-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/13 16:59, Felix Fietkau wrote:
[...]
> +/**
> + * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA state
> + *
> + * @next_tsf: TSF timestamp of the next absent state change
> + * @has_next_tsf: next absent state change event pending
> + *
> + * @absent: descriptor bitmask, set if GO is currently absent
> + */

why not providing the kerneldoc for all the fields? Even the more
obvious for you may not be so obvious for the next poor reader that has
to touch this code :-)

> +struct ieee80211_noa_data {
> +	u32 next_tsf;
> +	bool has_next_tsf;
> +
> +	u8 absent;
> +
> +	u8 count[IEEE80211_P2P_NOA_DESC_MAX];
> +	struct {
> +		u32 start;
> +		u32 duration;
> +		u32 interval;
> +	} desc[IEEE80211_P2P_NOA_DESC_MAX];
> +};


Cheers,

-- 
Antonio Quartulli
