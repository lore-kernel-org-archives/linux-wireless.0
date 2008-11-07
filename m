Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:49428 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYKGSJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 13:09:23 -0500
Received: by rn-out-0910.google.com with SMTP id k40so375725rnd.17
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2008 10:09:21 -0800 (PST)
Subject: Re: [PATCH 11/13] iwl3945 : Simplify iwl3945_send_beacon_cmd
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1226080726-24860-12-git-send-email-reinette.chatre@intel.com>
References: <> <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-12-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 10:09:20 -0800
Message-Id: <1226081360.11596.25.camel@brick> (sfid-20081107_190927_671920_FB8A9A71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-11-07 at 09:58 -0800, Reinette Chatre wrote:
> From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>
> 
> Moved rate_msk calculation to iwl3945_rate_get_lowest_plcp.
> 
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   26 ++++++++++++++------------
>  1 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 51f1c81..dec9e04 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -1420,9 +1420,16 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
>  	return priv->ibss_beacon->len;
>  }
>  
> -static u8 iwl3945_rate_get_lowest_plcp(int rate_mask)
> +static u8 iwl3945_rate_get_lowest_plcp(struct iwl3945_priv *priv)
>  {
>  	u8 i;
> +	int rate_mask;
> +
> +	/* Set rate mask*/
> +	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
> +		rate_mask = priv->active_rate_basic & 0xF;
> +	else
> +		rate_mask = priv->active_rate_basic & 0xFF0;

Perhaps a helpful define for these two magic mask values is called for.


Cheers,

Harvey

