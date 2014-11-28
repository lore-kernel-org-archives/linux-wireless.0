Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41395 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbaK1Nxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 08:53:35 -0500
Message-ID: <1417182803.27562.10.camel@sipsolutions.net> (sfid-20141128_145349_040693_18F1E6FE)
Subject: Re: [PATCH v5 3/4] cfg80211: allow wiphy specific regdomain
 management
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Jonathan Doron <jond@wizery.com>
Date: Fri, 28 Nov 2014 14:53:23 +0100
In-Reply-To: <1417074298-12254-3-git-send-email-arik@wizery.com> (sfid-20141127_084501_289050_7C295FB8)
References: <1417074298-12254-1-git-send-email-arik@wizery.com>
	 <1417074298-12254-3-git-send-email-arik@wizery.com>
	 (sfid-20141127_084501_289050_7C295FB8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-27 at 09:44 +0200, Arik Nemtsov wrote:
> @@ -3183,6 +3187,8 @@ struct wiphy {
>  
>  	const struct ieee80211_regdomain __rcu *regd;
>  
> +	const struct ieee80211_regdomain *requested_regd;

It's passed to the function:

>  /**
> + * regulatory_set_wiphy_regd - set regdom info for self managed drivers
> + * @wiphy: the wireless device we want to process the regulatory domain on
> + * @rd: the regulatory domain informatoin to use for this wiphy
> + *
> + * Set the regulatory domain information for self-managed wiphys, only they
> + * may use this function. See %REGULATORY_WIPHY_SELF_MANAGED for more
> + * information.
> + *
> + * Return: 0 on success. -EINVAL, -EPERM
> + */
> +int regulatory_set_wiphy_regd(struct wiphy *wiphy,
> +			      struct ieee80211_regdomain *rd);

so why should it be stored in the publically visible wiphy, rather than
the rdev struct?

> + * @NL80211_CMD_WIPHY_REG_CHANGE: Similar to %NL80211_CMD_REG_CHANGE, but used
> + *	for indicating changes for devices with wiphy-specific regdom management

... but used as an event to indicate ... ?


> +++ b/net/wireless/core.c
> @@ -557,6 +557,14 @@ int wiphy_register(struct wiphy *wiphy)
>  	    BIT(NL80211_IFTYPE_MONITOR)))
>  		wiphy->regulatory_flags |= REGULATORY_IGNORE_STALE_KICKOFF;
>  
> +	if (WARN_ON((wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
> +		    (wiphy->regulatory_flags &
> +		     (REGULATORY_CUSTOM_REG | REGULATORY_STRICT_REG |
> +		      REGULATORY_COUNTRY_IE_FOLLOW_POWER |
> +		      REGULATORY_COUNTRY_IE_IGNORE |
> +		      REGULATORY_DISABLE_BEACON_HINTS))))
> +		return -EINVAL;

I think you could align all of those under each other

wiphy->regulatory_flags & (... |
                           ... |
                           ...

etc to show clearly the nesting of the condition

> +void nl80211_send_reg_change_event(struct regulatory_request *request)
> +void nl80211_send_wiphy_reg_change_event(struct regulatory_request *request)

Seems like you could share more between these functions by just passing
the nl80211 cmd ID as well as the regdomain?

> @@ -1370,6 +1373,9 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
>  	sband = wiphy->bands[reg_beacon->chan.band];
>  	chan = &sband->channels[chan_idx];
>  
> +	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
> +		return;

Isn't there already a flag - you said in the docs that this flag implied
the "ignore beacons" flag so why not just set that flag?


> @@ -2432,6 +2479,9 @@ static void restore_regulatory_settings(bool reset_user)
>  	world_alpha2[1] = cfg80211_world_regdom->alpha2[1];
>  
>  	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +		if (rdev->wiphy.regulatory_flags &
> +						REGULATORY_WIPHY_SELF_MANAGED)
> +			continue;

I don't think that's any better than going >80 cols here :)

johannes

