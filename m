Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2LLWFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:05:50 -0500
Message-ID: <1355349972.9708.20.camel@jlt4.sipsolutions.net> (sfid-20121212_230553_865872_730B5BDB)
Subject: Re: [RFC 4/6] mac80211: Allow disabling SGI-20.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Dec 2012 23:06:12 +0100
In-Reply-To: <1355349295-30960-4-git-send-email-greearb@candelatech.com> (sfid-20121212_225648_739548_AE867F17)
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
	 <1355349295-30960-4-git-send-email-greearb@candelatech.com>
	 (sfid-20121212_225648_739548_AE867F17)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 13:54 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This allows user-space (wpa_supplicant) to disable
> short guard interval (SGI) for 20Mhz.  The SGI-40
> disable option is already handled.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  net/mac80211/ht.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index a71d891..8a6d68f 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -62,6 +62,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
>  	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SUP_WIDTH_20_40);
>  	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_40);
>  
> +	/* Allow user to disable SGI-20 (SGI-40 is handled above) */
> +	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_20);

And you tested this? And it actually did something, despite
mac80211_ht_capa_mod_mask not including it??

johannes

