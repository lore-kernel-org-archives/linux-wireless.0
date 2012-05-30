Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26587 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab2E3Ruk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 13:50:40 -0400
Message-ID: <4FC65DEA.9040609@qca.qualcomm.com> (sfid-20120530_195044_216345_B5B2B4ED)
Date: Wed, 30 May 2012 20:50:34 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <coelho@ti.com>
Subject: Re: [RFC] cfg80211: don't allow WoWLAN support without CONFIG_PM
References: <1338385542.4511.19.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338385542.4511.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 04:45 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When CONFIG_PM is enabled, no device can possibly
> support WoWLAN since it can't go to sleep to start
> with. Due to this, mac80211 had even rejected the
> hardware registration. By making all the code and
> data for WoWLAN depend on CONFIG_PM we can promote
> this runtime error to a compile-time error.
> 
> Add #ifdef around all WoWLAN code to remove it in
> systems that don't need it as they never suspend.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Luciano Coelho <coelho@ti.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

For the ath6kl part:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -3517,6 +3517,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
>  	wiphy->cipher_suites = cipher_suites;
>  	wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
>  
> +#ifdef CONFIG_PM
>  	wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
>  			      WIPHY_WOWLAN_DISCONNECT |
>  			      WIPHY_WOWLAN_GTK_REKEY_FAILURE  |
> @@ -3526,6 +3527,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
>  	wiphy->wowlan.n_patterns = WOW_MAX_FILTERS_PER_LIST;
>  	wiphy->wowlan.pattern_min_len = 1;
>  	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
> +#endif

To be honest I'm not really fond of ifdefs in the code, but that's just
me :)

Kalle
