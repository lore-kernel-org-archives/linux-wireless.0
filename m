Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5071 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759702Ab0HFOwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 10:52:08 -0400
Subject: Re: [PATCH 3/8] iwlwifi: separate thermal throttling function
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1281100480.3853.424.camel@jlt3.sipsolutions.net>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1280590452-10655-4-git-send-email-wey-yi.w.guy@intel.com>
	 <1281100480.3853.424.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Fri, 06 Aug 2010 07:51:31 -0700
Message-Id: <1281106291.22150.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks very much to catch this bug. 

John, please do not take the "thermal throttling" patch, I will fix it
up and re-submit.

Thanks

On Fri, 2010-08-06 at 06:14 -0700, Johannes Berg wrote:
> > @@ -325,9 +283,15 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
> >  	else if (priv->cfg->supports_idle &&
> >  		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
> >  		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_5, 20);
> > -	else if (tt->state >= IWL_TI_1)
> > -		iwl_static_sleep_cmd(priv, &cmd, tt->tt_power_mode, dtimper);
> > -	else if (!enabled)
> > +	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
> > +		 priv->cfg->ops->lib->tt_ops.tt_power_mode) {
> > +		if (priv->cfg->ops->lib->tt_ops.lower_power_detection(priv)) {
> > +			/* in thermal throttling low power state */
> > +			iwl_static_sleep_cmd(priv, &cmd,
> > +			    priv->cfg->ops->lib->tt_ops.tt_power_mode(priv),
> > +			    dtimper);
> > +		}
> > +	} else if (!enabled)
> >  		iwl_power_sleep_cam_cmd(priv, &cmd);
> >  	else if (priv->power_data.debug_sleep_level_override >= 0)
> >  		iwl_static_sleep_cmd(priv, &cmd,
> 
> This is very very broken because it adds an often-used code path that
> will not initialise "cmd" at all. It needs to be
> 
> ...
> else if (priv->...lower_power_detection &&
>          priv->...tt_power_mode &&
>          priv->...lower_power_detection(priv))
>         iwl_static_sleep_cmd(...)
> else if (!enabled)
> ...
> 
> johannes
> 

