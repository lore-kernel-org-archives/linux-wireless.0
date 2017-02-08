Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41108 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932344AbdBHIWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 03:22:32 -0500
Message-ID: <1486542145.4603.8.camel@sipsolutions.net> (sfid-20170208_092244_925566_8B439F15)
Subject: Re: [PATCH] mac80211: Remove VHT Capabilities/Operation IEs from
 mesh beacon if VHT was disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2017 09:22:25 +0100
In-Reply-To: <1485993928-3822-1-git-send-email-masashi.honma@gmail.com> (sfid-20170202_010539_896076_48F54BDC)
References: <1485993928-3822-1-git-send-email-masashi.honma@gmail.com>
         (sfid-20170202_010539_896076_48F54BDC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch removes VHT Capabilities/Operation IEs when the
> wpa_supplicant.conf includes disable_vht=1. We recognize the local
> peer
> as 11ac ready, when it has more than 80MHz band width. Because
> net/mac80211/util.c#ieee80211_build_preq_ies_band() uses 80MHz
> threshold
> for VHT Capabilities IE inclusion.

I believe this is incorrect the way you've written it, we shouldn't
disable VHT because 80 MHz isn't *used* right now.

The code you reference checks if 80 MHz was technically *supported*,
and that's really only because we otherwise can't connect to a BSS
network that supports VHT, since the AP might switch from 20/40 to
80/160, and we can't say that we don't support 80 (since we have to
support it if we support VHT.)

>  	sband = local->hw.wiphy->bands[band];
>  	if (!sband->vht_cap.vht_supported ||
> -	    sdata->vif.bss_conf.chandef.width ==
> NL80211_CHAN_WIDTH_20_NOHT ||
> -	    sdata->vif.bss_conf.chandef.width ==
> NL80211_CHAN_WIDTH_5 ||
> -	    sdata->vif.bss_conf.chandef.width ==
> NL80211_CHAN_WIDTH_10)
> +	    !(sdata->vif.bss_conf.chandef.width ==
> NL80211_CHAN_WIDTH_80 ||
> +	    sdata->vif.bss_conf.chandef.width ==
> NL80211_CHAN_WIDTH_80P80 ||
> +	    sdata->vif.bss_conf.chandef.width ==
> NL80211_CHAN_WIDTH_160))
>  		return 0;
> 

But using the current bandwidth as you do now seems incorrect to me.

johannes
