Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44012 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0CJGlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 01:41:36 -0500
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current
 wireless-testing
From: reinette chatre <reinette.chatre@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <33ED094E-EFBC-4BAD-B9F4-4C81BCEE9537@cs.washington.edu>
References: <201002281534.11656.helmut.schaa@googlemail.com>
	 <201003011927.53208.helmut.schaa@googlemail.com>
	 <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com>
	 <201003022047.10196.helmut.schaa@googlemail.com>
	 <1267640304.15761.121.camel@rchatre-DESK>
	 <03690D90-3C5E-4E37-8BC6-7EE6FE0B4E1D@cs.washington.edu>
	 <1267651173.15761.155.camel@rchatre-DESK>
	 <0A6DB552-23FC-46ED-9326-60EB0370C062@cs.washington.edu>
	 <C2DE0F0B-F62A-47BC-A719-E8A598146776@cs.washington.edu>
	 <43e72e891003040931n2dbd3c9cgdfbdcf1091adfe67@mail.gmail.com>
	 <33ED094E-EFBC-4BAD-B9F4-4C81BCEE9537@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 22:41:35 -0800
Message-ID: <1268203295.2446.30.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Tue, 2010-03-09 at 14:05 -0800, Daniel Halperin wrote:

> It turns out that disabling WIPHY_FLAG_STRICT_REGULATORY:
> 
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2632,7 +2632,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv)
>                 BIT(NL80211_IFTYPE_STATION) |
>                 BIT(NL80211_IFTYPE_ADHOC);
>  
> -       hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY |
> +       hw->wiphy->flags |= //WIPHY_FLAG_STRICT_REGULATORY |
>                             WIPHY_FLAG_DISABLE_BEACON_HINTS;
>  
>         /*
> 
> also fixes the problem; in reality this is a hack. It does seem to keep the proper driver-set regulatory limits even when I switch modes or channels or CRDA domains. This is because iwl_mac_setup_register() happens after the eeprom is read in iwl-agn.c, and thus the regulatory flags (chan->orig_flags) are pegged and thus stay set properly throughout the run. But it seems like the right approach is actually to do what ath/regd.c does and apply the custom regulatory domain.

For this I think we need to set WIPHY_FLAG_CUSTOM_REGULATORY instead of
WIPHY_FLAG_STRICT_REGULATORY. Looking closer it actually look as though
this is a typo that slipped in with "cfg80211: convert bools to flags"
where "hw->wiphy->custom_regulatory = true" was translated to
"hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY" by mistake.

Can you please try by replacing WIPHY_FLAG_STRICT_REGULATORY with
WIPHY_FLAG_CUSTOM_REGULATORY instead?

Reinette


