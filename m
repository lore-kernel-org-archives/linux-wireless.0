Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54780 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbbCCJ2w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:28:52 -0500
Message-ID: <1425374929.2450.25.camel@sipsolutions.net> (sfid-20150303_102901_278791_7092392B)
Subject: Re: [PATCH 3/3] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Mar 2015 10:28:49 +0100
In-Reply-To: <1424533961-3869-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150221_165308_246956_55F2621E)
References: <1424533961-3869-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1424533961-3869-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150221_165308_246956_55F2621E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-02-21 at 16:52 +0100, Janusz Dziedzic wrote:

> @@ -1055,17 +1074,36 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>  
>  			memcpy(&htcap_ie, elems->ht_cap_elem, sizeof(htcap_ie));
>  
> -			/*
> -			 * fall back to HT20 if we don't use or use
> -			 * the other extension channel
> -			 */
> -			if (chandef.center_freq1 !=
> -			    sdata->u.ibss.chandef.center_freq1)
> -				htcap_ie.cap_info &=
> -					cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
> -
>  			rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(
>  						sdata, sband, &htcap_ie, sta);
> +
> +			if (elems->vht_operation && elems->vht_cap_elem &&
> +			    width != NL80211_CHAN_WIDTH_20 &&
> +			    width != NL80211_CHAN_WIDTH_40) {
> +				/* we both use VHT */
> +				vht_cap = sta->sta.vht_cap;
> +				vht_oper = elems->vht_operation;
> +
> +				ieee80211_vht_oper_to_chandef(channel, vht_oper,
> +							      &chandef);
> +				memcpy(&vhtcap_ie, elems->vht_cap_elem,
> +				       sizeof(vhtcap_ie));
> +				ieee80211_vht_cap_ie_to_sta_vht_cap(sdata,
> +								    sband,
> +								    &vhtcap_ie,
> +								    sta);
> +				if (memcmp(&vht_cap, &sta->sta.vht_cap,
> +					   sizeof(vht_cap)))
> +						rates_updated |= true;

Some refactoring would be great, with expressions and argument lists
like this.

> +                       if (!
> cfg80211_chandef_compatible(&sdata->u.ibss.chandef,
> +                                                        &chandef))
> +                               /* TODO handle incompatible chandefs
> */
> +                               WARN_ON_ONCE(1);

That seems like an unaddressed TODO? I don't think you should warn on a
remote problem.

johannes

