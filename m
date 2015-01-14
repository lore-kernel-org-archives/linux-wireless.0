Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58130 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbbANIwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 03:52:30 -0500
Message-ID: <1421225542.1950.25.camel@sipsolutions.net> (sfid-20150114_095240_852067_BA7B5D9C)
Subject: Re: [RFC 1/2] cfg80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 14 Jan 2015 09:52:22 +0100
In-Reply-To: <1421138124-7661-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150113_093619_851055_18DEF9A2)
References: <1421138124-7661-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150113_093619_851055_18DEF9A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-13 at 09:35 +0100, Janusz Dziedzic wrote:


> + * @IBSS_PARAMS_DISABLE_HT:  Disable HT (802.11n)
> + * @IBSS_PARAMS_DISABLE_VHT:  Disable VHT

If you list 11n (don't think you need to) maybe also ist 11ac? :)
Or just remove 11n.

> + * @flags See &enum cfg80211_ibss_params_flags

missing :

>   * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
>   *	will be used in ht_capa.  Un-supported values will be ignored.
>   * @ht_capa_mask:  The bits of ht_capa which are to be used.
> + * @vht_capa:  VHT Capability overrides

why two spaces? :)

>  /**
>   * enum nl80211_ext_feature_index - bit index of extended features.
> + * @NL80211_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
>   *
>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
>   */
>  enum nl80211_ext_feature_index {
> +	NL80211_FEATURE_VHT_IBSS,

Yay, first bit :)

> @@ -7258,6 +7268,9 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
>  			return err;
>  	}
>  
> +	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
> +		ibss.flags |= IBSS_PARAMS_DISABLE_HT;

That should perhaps be a separate patch? Also - it seems you need to
check somewhere that people aren't configuring 80 MHz with disable-VHT?
And similar for HT actually - is this new?

johannes

