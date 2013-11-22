Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34515 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3KVKqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 05:46:07 -0500
Received: by mail-wi0-f169.google.com with SMTP id hm6so1358547wib.2
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 02:46:05 -0800 (PST)
Date: Fri, 22 Nov 2013 11:45:28 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH v3] mac80211_hwsim: claim CSA support for AP
Message-ID: <20131122104527.GD8527@magnum.frso.rivierawaves.com> (sfid-20131122_114611_816038_16B0576F)
References: <1385111186-19551-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1385111186-19551-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 22, 2013 at 10:06:26AM +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index a11dc7c..cc30acd 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -168,6 +168,7 @@ struct hwsim_vif_priv {
>  	u8 bssid[ETH_ALEN];
>  	bool assoc;
>  	bool bcn_en;
> +	int csa_bcn_cnt;
>  	u16 aid;
>  };
>  
> @@ -1058,6 +1059,18 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
>  
>  	mac80211_hwsim_tx_frame(hw, skb,
>  				rcu_dereference(vif->chanctx_conf)->def.chan);
> +
> +	if (vif->csa_active) {
> +		struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
> +
> +		vp->csa_bcn_cnt++;
> +		if (ieee80211_csa_is_complete(vif)) {
> +			wiphy_debug(hw->wiphy,
> +				    "%s CSA complete after %d beacons\n",
> +				    __func__, vp->csa_bcn_cnt);
> +			ieee80211_csa_finish(vif);
> +		}
> +	}
>  }
>  

Hmm, I thought the CSA code would make ieee80211_beacon_get_tim return
NULL (or do something alike) after the last ieee80211_beacon_get_tim
returned a beacon with a null CSA count until the config is done - but
it seems it doesn't - in that case this change would be race prone.
Did I miss something ?
 
Karl
