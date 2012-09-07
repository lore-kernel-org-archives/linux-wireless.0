Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44474 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IGRhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:37:17 -0400
Received: by eaac11 with SMTP id c11so1016592eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 10:37:15 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: add key flag for management keys
Date: Fri, 7 Sep 2012 19:37:09 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
References: <1347038794-29039-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1347038794-29039-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201209071937.09316.chunkeey@googlemail.com> (sfid-20120907_193721_475342_ACAF666E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 September 2012 19:26:34 Johannes Berg wrote:
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 03fe6d1..b45f410 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -170,6 +170,38 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
>  		}
>  	}
>  
> +	switch (sdata->vif.type) {
> +	case NL80211_IFTYPE_STATION:
> +		if (sdata->u.mgd.mfp != IEEE80211_MFP_DISABLED)
> +			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
> +		break;
> +	case NL80211_IFTYPE_AP:
> +	case NL80211_IFTYPE_AP_VLAN:
> +		/* Keys without a station are used for TX only */
> +		if (key->sta && test_sta_flag(key->sta, WLAN_STA_MFP))
> +			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
> +		break;
> +	case NL80211_IFTYPE_ADHOC:
> +		/* no MFP (yet) */
> +		break;
> +	case NL80211_IFTYPE_MESH_POINT:
> +#ifdef CONFIG_MAC80211_MESH
> +		if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
> +			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
> +		break;
> +#endif
> +	case NL80211_IFTYPE_WDS:
> +	case NL80211_IFTYPE_MONITOR:
> +	case NL80211_IFTYPE_P2P_DEVICE:
> +	case NL80211_IFTYPE_UNSPECIFIED:
> +	case NUM_NL80211_IFTYPES:
> +	case NL80211_IFTYPE_P2P_CLIENT:
> +	case NL80211_IFTYPE_P2P_GO:
> +		/* shouldn't happen */
> +		WARN_ON(1);
> +		break;
> +	}
> +
Is there a reason not to use default: ? 

	...
#ifdef CONFIG_MAC80211_MESH
	case NL80211_IFTYPE_MESH_POINT:
		if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
	break;
#endif
	default:
		/* shouldn't happen */
		WARN_ON(1);
		break;
}

Regards,
	Chr
