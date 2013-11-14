Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:46910 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3KNOxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:53:19 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Luciano Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v5 5/5] mac80211: only set CSA beacon when at least one beacon must be transmitted
Date: Thu, 14 Nov 2013 15:53:16 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	yeohchunyeow@gmail.com, yeohchunyeow@cozybit.com
References: <1384430976-13708-1-git-send-email-luciano.coelho@intel.com> <1384430976-13708-5-git-send-email-luciano.coelho@intel.com>
In-Reply-To: <1384430976-13708-5-git-send-email-luciano.coelho@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311141553.16912.sw@simonwunderlich.de> (sfid-20131114_155322_409430_2051AEF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> @@ -3122,9 +3158,16 @@ int ieee80211_channel_switch(struct wiphy *wiphy,
> struct net_device *dev, params->chandef.chan->band)
>  			return -EINVAL;
> 
> -		err = ieee80211_ibss_csa_beacon(sdata, params);
> -		if (err < 0)
> -			return err;
> +		/* see comments and TODO in the NL80211_IFTYPE_AP block */

Since you are sending an action frame below, this TODO appears to be obsolete?

> +		if (params->count > 1) {
> +			err = ieee80211_ibss_csa_beacon(sdata, params);
> +			if (err < 0)
> +				return err;
> +			changed |= err;
> +		}
> +
> +		ieee80211_send_action_csa(sdata, params);
> +
>  		break;
>  #ifdef CONFIG_MAC80211_MESH
>  	case NL80211_IFTYPE_MESH_POINT:
> @@ -3173,8 +3220,13 @@ int ieee80211_channel_switch(struct wiphy *wiphy,
> struct net_device *dev, sdata->csa_chandef = params->chandef;
>  	sdata->vif.csa_active = true;
> 
> -	ieee80211_bss_info_change_notify(sdata, err);
> -	drv_channel_switch_beacon(sdata, &params->chandef);
> +	if (changed) {
> +		ieee80211_bss_info_change_notify(sdata, changed);
> +		drv_channel_switch_beacon(sdata, &params->chandef);
> +	} else {
> +		/* if the beacon didn't change, we can finalize immediately */
> +		ieee80211_csa_finalize(sdata);
> +	}

I think setting csa_active == true for count 0 or 1 is wrong. 

When a beacon is generated/updated in ieee80211_beacon_get_tim(), it wil call 
ieee80211_update_csa() which will throw a warning in best case, but also 
modifies random data in the beacon/presp at the position where the count offset 
points to (we have no CSA IE in this case).

I've also seen warnings in my IBSS tests (WARNING: CPU: 0 PID: 0 at 
net/mac80211/tx.c:2408 ieee80211_update_csa), when doing a CSA with count 0 
from userspace. Although likely, I'm not sure if this is related to the 
problem described above, but this function shouldn't be called at all in the 
count=0 case.

Cheers,
    Simon
