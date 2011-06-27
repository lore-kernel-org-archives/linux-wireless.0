Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759628Ab1F0Mgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:36:36 -0400
Subject: Re: [PATCH v2 1/2] mac80211: propagate information about STA WME
 support down
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1309073538-24071-1-git-send-email-arik@wizery.com> (sfid-20110626_093245_471250_1B03FA96)
References: <1309073538-24071-1-git-send-email-arik@wizery.com>
	 (sfid-20110626_093245_471250_1B03FA96)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:36:38 +0200
Message-ID: <1309178198.3911.11.camel@jlt3.sipsolutions.net> (sfid-20110627_144656_858637_A17CC6CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I wonder, would it make sense to _move_ the flag instead of trying to
keep it twice? Since the flag shouldn't ever change that could even
remove some locking around it in some hotpaths...

> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 421eaa6..efa1d86 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -310,11 +310,14 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>  			} else
>  				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
>  						mgmt->sa, supp_rates,
> +						elems->wmm_info != NULL,
>  						GFP_ATOMIC);
>  		}
>  
> -		if (sta && elems->wmm_info)
> +		if (sta && elems->wmm_info) {
>  			set_sta_flags(sta, WLAN_STA_WME);
> +			sta->sta.wme = true;
> +		}

This seems duplicate now that you're passing it into ibss_add_sta().

However, it's currently sort of necessary to keep it correct:

> @@ -2652,7 +2652,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
>  			else
>  				rate_idx = status->rate_idx;
>  			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
> -					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
> +					hdr->addr2, BIT(rate_idx), false,
> +					GFP_ATOMIC);
>  		}
>  		break;
>  	case NL80211_IFTYPE_MESH_POINT:

since you're not parsing anything here. Which also seems strange, at
least you could check if it was a QoS frame?

In any case, it seems to me that the driver needs to know the WME flag
while adding the station, not only at some arbitrary point later, which
doesn't happen here.

Maybe you should make the flag be AP-mode only after all :-)

johannes

