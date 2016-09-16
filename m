Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34497 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752877AbcIPK6p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 06:58:45 -0400
Received: by mail-pf0-f169.google.com with SMTP id p64so26510233pfb.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2016 03:58:45 -0700 (PDT)
Subject: Re: [PATCH v2 1/9] cfg80211: add start / stop NAN commands
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-2-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6bfd6007-8650-3c75-2e90-c2c94202e2b9@broadcom.com> (sfid-20160916_125849_460397_1412B4B6)
Date: Fri, 16 Sep 2016 12:58:32 +0200
MIME-Version: 1.0
In-Reply-To: <20160916083321.5840-2-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-9-2016 10:33, Luca Coelho wrote:
> From: Ayala Beker <ayala.beker@intel.com>
> 
> This allows user space to start/stop NAN interface.
> A NAN interface is like P2P device in a few aspects: it
> doesn't have a netdev associated to it.
> Add the new interface type and prevent operations that
> can't be executed on NAN interface like scan.
> 
> Define several attributes that may be configured by user space
> when starting NAN functionality (master preference and dual
> band operation)
> 
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  include/net/cfg80211.h       | 21 +++++++++-
>  include/uapi/linux/nl80211.h | 52 +++++++++++++++++++++++++
>  net/mac80211/cfg.c           |  2 +
>  net/mac80211/chan.c          |  3 ++
>  net/mac80211/iface.c         |  4 ++
>  net/mac80211/offchannel.c    |  1 +
>  net/mac80211/rx.c            |  3 ++
>  net/mac80211/util.c          |  1 +
>  net/wireless/chan.c          |  2 +
>  net/wireless/core.c          | 34 ++++++++++++++++
>  net/wireless/core.h          |  3 ++
>  net/wireless/mlme.c          |  1 +
>  net/wireless/nl80211.c       | 93 ++++++++++++++++++++++++++++++++++++++++++--
>  net/wireless/rdev-ops.h      | 20 ++++++++++
>  net/wireless/trace.h         | 27 +++++++++++++
>  net/wireless/util.c          |  6 ++-
>  16 files changed, 267 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index d5e7f69..ca64d69 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2293,6 +2293,19 @@ struct cfg80211_qos_map {
>  };

[...]

> +/**
> + * enum nl80211_nan_dual_band_conf - NAN dual band configuration
> + *
> + * Defines the NAN dual band mode of operation

Does it make sense to have such a notion of bands in use. And what does
5.2GHz mean. Is this a subband within 5G channels? Probably I should
read the NAN spec to understand what is meant here. I would consider
5.2G as lower 5G, ie. discovery on channel 44 but not sure if that is
meant here.

> + * @NL80211_NAN_BAND_DEFAULT: device default mode
> + * @NL80211_NAN_BAND_SINGLE: 2.4GHz only mode
> + * @NL80211_NAN_BAND_DUAL: 2.4GHz and 5.2GHz mode
> +  */
> +enum nl80211_nan_dual_band_conf {
> +	NL80211_NAN_BAND_DEFAULT,
> +	NL80211_NAN_BAND_SINGLE,
> +	NL80211_NAN_BAND_DUAL,
> +
> +	/* keep last */
> +	__NL80211_NAN_BAND_AFTER_LAST,
> +	NL80211_NAN_BAND_MAX =
> +	__NL80211_NAN_BAND_AFTER_LAST - 1,
> +};
> +
>  #endif /* __LINUX_NL80211_H */
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index e29ff57..a74027f 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -257,6 +257,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
>  	case NL80211_IFTYPE_WDS:
>  	case NL80211_IFTYPE_MONITOR:
>  	case NL80211_IFTYPE_P2P_DEVICE:
> +	case NL80211_IFTYPE_NAN:
>  	case NL80211_IFTYPE_UNSPECIFIED:
>  	case NUM_NL80211_IFTYPES:

Huh? What is this doing here? Not yours but weird still.

>  	case NL80211_IFTYPE_P2P_CLIENT:
> @@ -2036,6 +2037,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
>  		     !(req->flags & NL80211_SCAN_FLAG_AP)))
>  			return -EOPNOTSUPP;
>  		break;
> +	case NL80211_IFTYPE_NAN:
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index 74142d0..acb50f8 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -274,6 +274,7 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
>  				    ieee80211_get_max_required_bw(sdata));
>  			break;
>  		case NL80211_IFTYPE_P2P_DEVICE:
> +		case NL80211_IFTYPE_NAN:
>  			continue;
>  		case NL80211_IFTYPE_ADHOC:
>  		case NL80211_IFTYPE_WDS:
> @@ -718,6 +719,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
>  
>  		switch (sdata->vif.type) {
>  		case NL80211_IFTYPE_P2P_DEVICE:
> +		case NL80211_IFTYPE_NAN:
>  			continue;
>  		case NL80211_IFTYPE_STATION:
>  			if (!sdata->u.mgd.associated)
> @@ -981,6 +983,7 @@ ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
>  	case NL80211_IFTYPE_P2P_GO:
>  	case NL80211_IFTYPE_P2P_DEVICE:
>  	case NUM_NL80211_IFTYPES:

I think NUM_NL80211_IFTYPES should not be in the switch. If it must I
would leave it as last one here.

> +	case NL80211_IFTYPE_NAN:
>  		WARN_ON(1);
>  		break;
>  	}

Regards,
Arend
