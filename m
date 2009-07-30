Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:34518 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbZG3UMX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 16:12:23 -0400
Subject: Re: [PATCH 05/14 w-t and 2.6.31] iwlagn: do not send key clear
 commands when rfkill enabled
From: reinette chatre <reinette.chatre@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
	 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
	 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
	 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
	 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
	 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 13:12:22 -0700
Message-Id: <1248984742.1216.1101.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This patch did not make it to Linus's repo. Could you please consider it
for 2.6.31? We would like to have this patch in 2.6.31 because it fixes
a regression that is tracked in
http://bugzilla.kernel.org/show_bug.cgi?id=13742

Thank you

Reinette

On Fri, 2009-07-17 at 09:30 -0700, Chatre, Reinette wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> Do all key clearing except sending sommands to device when rfkill
> enabled. When rfkill enabled the interface is brought down and will
> be brought back up correctly after rfkill is enabled again.
> 
> Same change is not needed for iwl3945 as it ignores return code when
> sending key clearing command to device.
> 
> This fixes http://bugzilla.kernel.org/show_bug.cgi?id=13742
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Frans Pop <elendil@planet.nl>
> ---
>  drivers/net/wireless/iwlwifi/iwl-sta.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
> index 2addf73..ffd5c61 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> @@ -566,6 +566,8 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&priv->sta_lock, flags);
> +	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
> +		      keyconf->keyidx);
>  
>  	if (!test_and_clear_bit(keyconf->keyidx, &priv->ucode_key_table))
>  		IWL_ERR(priv, "index %d not used in uCode key table.\n",
> @@ -573,6 +575,11 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
>  
>  	priv->default_wep_key--;
>  	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
> +	if (iwl_is_rfkill(priv)) {
> +		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
> +		spin_unlock_irqrestore(&priv->sta_lock, flags);
> +		return 0;
> +	}
>  	ret = iwl_send_static_wepkey_cmd(priv, 1);
>  	IWL_DEBUG_WEP(priv, "Remove default WEP key: idx=%d ret=%d\n",
>  		      keyconf->keyidx, ret);
> @@ -853,6 +860,11 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
>  	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
>  	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
>  
> +	if (iwl_is_rfkill(priv)) {
> +		IWL_DEBUG_WEP(priv, "Not sending REPLY_ADD_STA command because RFKILL enabled. \n");
> +		spin_unlock_irqrestore(&priv->sta_lock, flags);
> +		return 0;
> +	}
>  	ret =  iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
>  	spin_unlock_irqrestore(&priv->sta_lock, flags);
>  	return ret;

