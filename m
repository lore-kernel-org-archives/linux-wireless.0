Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49438 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbdAMIVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 03:21:23 -0500
Message-ID: <1484295655.19860.9.camel@sipsolutions.net> (sfid-20170113_092125_976236_41C83C78)
Subject: Re: [PATCH] mac80211: initialize SMPS field in HT capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: onelektra@gmx.net
Date: Fri, 13 Jan 2017 09:20:55 +0100
In-Reply-To: <20170111223322.14698-1-nbd@nbd.name>
References: <20170111223322.14698-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 23:33 +0100, Felix Fietkau wrote:
> ibss and mesh modes copy the ht capabilites from the band without
> overriding the SMPS state. Unfortunately the default value 0 for the
> SMPS field means static SMPS instead of disabled.
> 
> This results in HT ibss and mesh setups using only single-stream
> rates,
> even though SMPS is not supposed to be active.
> 
> Initialize SMPS to disabled for all bands on ieee80211_hw_register to
> ensure that the value is sane where it is not overriden with the real
> SMPS state.

Hmm. I guess the only other place affected by it will be scanning?

> Reported-by: Elektra Wagenrad <onelektra@gmx.net>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/mac80211/main.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 1822c77f2b1c..c269046aa02b 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -913,10 +913,15 @@ int ieee80211_register_hw(struct ieee80211_hw
> *hw)
>  		supp_ht = supp_ht || sband->ht_cap.ht_supported;
>  		supp_vht = supp_vht || sband->vht_cap.vht_supported;
>  
> -		if (sband->ht_cap.ht_supported)
> -			local->rx_chains =
> -				max(ieee80211_mcs_to_chains(&sband-
> >ht_cap.mcs),
> -				    local->rx_chains);
> +		if (!sband->ht_cap.ht_supported)
> +			continue;
> +
> +		local->rx_chains =
> +			max(ieee80211_mcs_to_chains(&sband-
> >ht_cap.mcs),
> +			    local->rx_chains);
> +
> +		sband->ht_cap.cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
> +			             IEEE80211_HT_CAP_SM_PS_SHIFT;

This ... looks fishy. I know it's not, since it sets both bits, but
still.

Additionally, ath10k appears to be setting this to
WLAN_HT_CAP_SM_PS_DYNAMIC already, so apparently it's expecting
something to happen with that value? Is it really correct then to be
overwriting it?

johannes
