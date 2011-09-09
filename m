Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.93]:26455 "HELO
	nm17-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759097Ab1IIOR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 10:17:26 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: Alexander Simon <an.alexsimon@googlemail.com>
Subject: Re: [PATCH v2 4/4] mac80211: Add HT operation modes for IBSS
Date: Fri, 9 Sep 2011 16:17:20 +0200
References: <2053881.ENil2Dy3QM@alex-1> <2070049.m7Ejz2Cj4P@alex-1>
In-Reply-To: <2070049.m7Ejz2Cj4P@alex-1>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109091617.21038.lindner_marek@yahoo.de> (sfid-20110909_161730_232402_69D8F190)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 29, 2011 16:32:12 you wrote:
> @@ -380,7 +382,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta
> *pubsta, u16 tid,
>  	 */
>  	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
>  	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
> -	    sdata->vif.type != NL80211_IFTYPE_AP)
> +	    sdata->vif.type != NL80211_IFTYPE_AP &&
> +	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
>  		return -EINVAL;

You should update the comment regarding IBSS mode direct above this check too.


> +		/* update HT IE. If not yet existing, create one */
> +		nskb = skb_copy(skb, GFP_ATOMIC);
> +		ht_ie = (u8 *)cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
> +					       (const u8 *)(nskb->data + 24 +
> +							sizeof(mgmt->u.beacon)),
> +					       nskb->len - 24 -
> +							sizeof(mgmt->u.beacon));
> +		if (!ht_ie)
> +			ht_ie = skb_put(nskb, 4 +
> +					      sizeof(struct ieee80211_ht_cap) +
> +					      sizeof(struct ieee80211_ht_info));

AFAIK, you can not safely assume that you have enough room left for skb_put(). 
You might trigger a skb_over_panic().


> @@ -2160,7 +2160,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>  		 */
>  		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
>  		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
> -		    sdata->vif.type != NL80211_IFTYPE_AP)
> +		    sdata->vif.type != NL80211_IFTYPE_AP &&
> +		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
>  			break;

Also requires a "comment update".

Cheers,
Marek
