Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab0HFNOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 09:14:48 -0400
Subject: Re: [PATCH 3/8] iwlwifi: separate thermal throttling function
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1280590452-10655-4-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1280590452-10655-4-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 15:14:40 +0200
Message-ID: <1281100480.3853.424.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> @@ -325,9 +283,15 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
>  	else if (priv->cfg->supports_idle &&
>  		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
>  		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_5, 20);
> -	else if (tt->state >= IWL_TI_1)
> -		iwl_static_sleep_cmd(priv, &cmd, tt->tt_power_mode, dtimper);
> -	else if (!enabled)
> +	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
> +		 priv->cfg->ops->lib->tt_ops.tt_power_mode) {
> +		if (priv->cfg->ops->lib->tt_ops.lower_power_detection(priv)) {
> +			/* in thermal throttling low power state */
> +			iwl_static_sleep_cmd(priv, &cmd,
> +			    priv->cfg->ops->lib->tt_ops.tt_power_mode(priv),
> +			    dtimper);
> +		}
> +	} else if (!enabled)
>  		iwl_power_sleep_cam_cmd(priv, &cmd);
>  	else if (priv->power_data.debug_sleep_level_override >= 0)
>  		iwl_static_sleep_cmd(priv, &cmd,

This is very very broken because it adds an often-used code path that
will not initialise "cmd" at all. It needs to be

...
else if (priv->...lower_power_detection &&
         priv->...tt_power_mode &&
         priv->...lower_power_detection(priv))
        iwl_static_sleep_cmd(...)
else if (!enabled)
...

johannes

