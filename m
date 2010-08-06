Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762095Ab0HFV5G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 17:57:06 -0400
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
Content-Type: multipart/mixed; boundary="=-jETx3uECddoZwh9wo7SA"
Date: Fri, 06 Aug 2010 14:56:28 -0700
Message-Id: <1281131788.26320.5.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jETx3uECddoZwh9wo7SA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi John,

Based on ours previous conversation, I understand the thermal throttling
patch is not being merge it, since it has a stupid bug I create and
being identify by Johannes, is it ok for you to merge the attached patch
with the original patch work while you ready to push?

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

--=-jETx3uECddoZwh9wo7SA
Content-Disposition: attachment; filename*0=0001-iwlwifi-fix-thermal-throttling-related-power-manage.patc; filename*1=h
Content-Type: text/x-patch; name="0001-iwlwifi-fix-thermal-throttling-related-power-manage.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 98ec32fb40c92ce0175a3246660f4ae7969308d7 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Fri, 6 Aug 2010 12:39:14 -0700
Subject: [PATCH 1/1] iwlwifi: fix thermal throttling related power manageent operation

The current approach is very broken because it adds an
often-used code path that will not initialise "cmd" at all.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Shanyu Zhao <shanyu.zhao.intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index da1f2ae..63c0ab4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -284,13 +284,11 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_5, 20);
 	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
-		 priv->cfg->ops->lib->tt_ops.tt_power_mode) {
-		if (priv->cfg->ops->lib->tt_ops.lower_power_detection(priv)) {
-			/* in thermal throttling low power state */
-			iwl_static_sleep_cmd(priv, &cmd,
-			    priv->cfg->ops->lib->tt_ops.tt_power_mode(priv),
-			    dtimper);
-		}
+		 priv->cfg->ops->lib->tt_ops.tt_power_mode &&
+		 priv->cfg->ops->lib->tt_ops.lower_power_detection(priv)) {
+		/* in thermal throttling low power state */
+		iwl_static_sleep_cmd(priv, &cmd,
+		    priv->cfg->ops->lib->tt_ops.tt_power_mode(priv), dtimper);
 	} else if (!enabled)
 		iwl_power_sleep_cam_cmd(priv, &cmd);
 	else if (priv->power_data.debug_sleep_level_override >= 0)
-- 
1.5.6.3


--=-jETx3uECddoZwh9wo7SA--

