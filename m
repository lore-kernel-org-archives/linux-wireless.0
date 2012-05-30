Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2E3NbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 09:31:22 -0400
Message-ID: <1338384543.4511.18.camel@jlt3.sipsolutions.net> (sfid-20120530_163646_640212_C8EA8DFB)
Subject: Re: IWLWIFI should depend on SUSPEND
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 30 May 2012 15:29:03 +0200
In-Reply-To: <1337540836.4585.1.camel@jlt3.sipsolutions.net> (sfid-20120520_210755_672970_92507325)
References: <20120519201958.GA2313@wolfgang>
	 (sfid-20120519_221944_090598_23FED733) <1337540836.4585.1.camel@jlt3.sipsolutions.net>
	 (sfid-20120520_210755_672970_92507325)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-05-20 at 21:07 +0200, Johannes Berg wrote:
> On Sat, 2012-05-19 at 22:19 +0200, Sebastian Kemper wrote:
> > Hello everybody,
> > 
> > iwlwifi doesn't start without suspend support in the kernel. The last
> > thing it says when suspend is missing is this:
> > 
> > iwlwifi 0000:03:00.0: Failed to register hw (error -22)
> > iwlwifi 0000:03:00.0: PCI INT A disabled
> 
> I was going to say it's a mac80211 bug due to this code:
> 
>         if ((hw->wiphy->wowlan.flags || hw->wiphy->wowlan.n_patterns)
> #ifdef CONFIG_PM
>             && (!local->ops->suspend || !local->ops->resume)
> #endif
>             )
>                 return -EINVAL;
> 
> But then I thought about it and think it makes sense, if you don't have
> suspend then you can't have WoWLAN, so the driver shouldn't advertise it
> in that case, which makes it an iwlwifi bug again, we should ifdef the
> wowlan support correctly.

Could you try this patch please?

johannes

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index ab2f4d7..06546f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -199,6 +199,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
+#ifdef CONFIG_PM
 	if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
 	    priv->trans->ops->wowlan_suspend &&
 	    device_can_wakeup(priv->trans->dev)) {
@@ -217,6 +218,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		hw->wiphy->wowlan.pattern_max_len =
 					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
 	}
+#endif
 
 	if (iwlwifi_mod_params.power_save)
 		hw->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;


