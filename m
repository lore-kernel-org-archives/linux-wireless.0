Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2FCPCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 11:02:19 -0400
Message-ID: <1338735736.4972.0.camel@jlt3.sipsolutions.net> (sfid-20120603_170231_946292_6C1AEEC5)
Subject: Re: IWLWIFI should depend on SUSPEND
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 03 Jun 2012 17:02:16 +0200
In-Reply-To: <20120603091643.GA2191@wolfgang> (sfid-20120603_111701_060866_620EFB8E)
References: <20120519201958.GA2313@wolfgang>
	 <1337540836.4585.1.camel@jlt3.sipsolutions.net>
	 <1338384543.4511.18.camel@jlt3.sipsolutions.net>
	 <20120603091643.GA2191@wolfgang> (sfid-20120603_111701_060866_620EFB8E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-03 at 11:16 +0200, Sebastian Kemper wrote:
> On Wed, May 30, 2012 at 03:29:03PM +0200, Johannes Berg wrote:
> > Could you try this patch please?
> > 
> > johannes
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
> > b/drivers/net/wireless/iwlwifi/iwl-mac80211.c index ab2f4d7..06546f7
> > 100644 --- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c +++
> > b/drivers/net/wireless/iwlwifi/iwl-mac80211.c @@ -199,6 +199,7 @@ int
> > iwlagn_mac_setup_register(struct iwl_priv *priv,
> > WIPHY_FLAG_DISABLE_BEACON_HINTS | WIPHY_FLAG_IBSS_RSN;
> >  
> > +#ifdef CONFIG_PM if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
> > priv->trans->ops->wowlan_suspend &&
> > device_can_wakeup(priv->trans->dev)) { @@ -217,6 +218,7 @@ int
> > iwlagn_mac_setup_register(struct iwl_priv *priv,
> > hw->wiphy->wowlan.pattern_max_len = IWLAGN_WOWLAN_MAX_PATTERN_LEN; }
> > +#endif
> >  
> >  	if (iwlwifi_mod_params.power_save) hw->wiphy->flags |=
> >  	WIPHY_FLAG_PS_ON_BY_DEFAULT;
> 
> Hello Johannes,
> 
> the patch doesn't apply on top of 3.2.18 (kernel I currently use),
> neither on 3.3.7.

Oh, so this goes back much further than I thought.

Well, the easiest is probably if you find the wowlan.pattern_max_len
stuff etc. and put #ifdef around the whole wowlan block manually, like
in my patch.

johannes

