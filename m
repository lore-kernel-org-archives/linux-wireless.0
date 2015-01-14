Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbbANIy1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 03:54:27 -0500
Message-ID: <1421225664.1950.27.camel@sipsolutions.net> (sfid-20150114_095436_056175_718B4353)
Subject: Re: [RFC 2/2] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 14 Jan 2015 09:54:24 +0100
In-Reply-To: <1421138124-7661-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150113_093621_137245_E694964D)
References: <1421138124-7661-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421138124-7661-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150113_093621_137245_E694964D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-13 at 09:35 +0100, Janusz Dziedzic wrote:

> +++ b/net/mac80211/main.c
> @@ -549,6 +549,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
>  		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
>  				   NL80211_FEATURE_AP_SCAN;
>  
> +	wiphy_ext_feature_set(wiphy, NL80211_FEATURE_VHT_IBSS);

Maybe we should leave this to the driver?

And it should certainly depend on actual VHT capability, I'd say? Seems
confusing if we ended up with a driver that doesn't have VHT but says it
has VHT_IBSS :)

> +++ b/net/mac80211/util.c
> @@ -2329,6 +2329,41 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
>  	return pos + sizeof(struct ieee80211_ht_operation);
>  }
>  
> +u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +				const struct cfg80211_chan_def *chandef)

For now that'll only be used by IBSS (perhaps mesh in the future?), but
maybe it should just be in ibss.c until it's used more?

johannes


