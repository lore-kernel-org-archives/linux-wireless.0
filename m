Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:54087 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752759Ab2FCJQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 05:16:32 -0400
Date: Sun, 3 Jun 2012 11:16:43 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: IWLWIFI should depend on SUSPEND
Message-ID: <20120603091643.GA2191@wolfgang> (sfid-20120603_111636_242591_DF8BE591)
References: <20120519201958.GA2313@wolfgang>
 <1337540836.4585.1.camel@jlt3.sipsolutions.net>
 <1338384543.4511.18.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338384543.4511.18.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2012 at 03:29:03PM +0200, Johannes Berg wrote:
> Could you try this patch please?
> 
> johannes
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> b/drivers/net/wireless/iwlwifi/iwl-mac80211.c index ab2f4d7..06546f7
> 100644 --- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c +++
> b/drivers/net/wireless/iwlwifi/iwl-mac80211.c @@ -199,6 +199,7 @@ int
> iwlagn_mac_setup_register(struct iwl_priv *priv,
> WIPHY_FLAG_DISABLE_BEACON_HINTS | WIPHY_FLAG_IBSS_RSN;
>  
> +#ifdef CONFIG_PM if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
> priv->trans->ops->wowlan_suspend &&
> device_can_wakeup(priv->trans->dev)) { @@ -217,6 +218,7 @@ int
> iwlagn_mac_setup_register(struct iwl_priv *priv,
> hw->wiphy->wowlan.pattern_max_len = IWLAGN_WOWLAN_MAX_PATTERN_LEN; }
> +#endif
>  
>  	if (iwlwifi_mod_params.power_save) hw->wiphy->flags |=
>  	WIPHY_FLAG_PS_ON_BY_DEFAULT;

Hello Johannes,

the patch doesn't apply on top of 3.2.18 (kernel I currently use),
neither on 3.3.7.

Regards
Sebastian
