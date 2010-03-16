Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0CQAxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 20:53:55 -0400
Subject: Re: [RFC PATCHv2 1/2] cfg80211: Add connection quality monitoring
 support to nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268657751-1042-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268657751-1042-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 14:51:18 -0700
Message-ID: <1268776278.8918.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-15 at 14:55 +0200, Juuso Oikarinen wrote:

> + * @NL80211_ATTR_CQM: connection quality monitor configuration in a
> + *	nested attribute with %NL80211_ATTR_CQM_* sub-attributes.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -842,6 +851,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_PS_STATE,
>  
> +	NL80211_ATTR_CQM,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -1583,4 +1594,29 @@ enum nl80211_ps_state {
>  	NL80211_PS_ENABLED,
>  };
>  
> +/**
> + * enum nl80211_attr_cqm - connection quality monitor attributes
> + * @__NL80211_ATTR_CQM_INVALID: invalid
> + * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm
> + * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm

You really like abbreviations? I think it wouldn't hurt to make these
more verbose :)

> + * @NL80211_ATTR_CQM_RSSI_LEVEL: Current level in relation to threshold
> + * @__NL80211_ATTR_CQM_AFTER_LAST: internal
> + * @NL80211_ATTR_CQM_MAX: highest key attribute
> + */
> +enum nl80211_attr_cqm {
> +	__NL80211_ATTR_CQM_INVALID,
> +	NL80211_ATTR_CQM_RSSI_THOLD,
> +	NL80211_ATTR_CQM_RSSI_HYST,
> +	NL80211_ATTR_CQM_RSSI_LEVEL,
> +
> +	/* keep last */
> +	__NL80211_ATTR_CQM_AFTER_LAST,
> +	NL80211_ATTR_CQM_MAX = __NL80211_ATTR_CQM_AFTER_LAST - 1
> +};
> +
> +enum nl80211_cqm_level {

Docs? But then again, see further down.

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 3d134a1..5f48472 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1007,6 +1007,7 @@ struct cfg80211_pmksa {
>   *	RSN IE. It allows for faster roaming between WPA2 BSSIDs.
>   * @del_pmksa: Delete a cached PMKID.
>   * @flush_pmksa: Flush all cached PMKIDs.
> + * @set_cqm_config: Configure cqm RSSI notification threshold.

abbreviations in the method are one thing, but in the docs?

> +/**
> + * cfg80211_cqm_notify - notification of a connection quality monitoring event
> + * @dev: network device
> + * @rssi_level: current level of the RSSI
> + * @gfp: context flags
> + *
> + * This function is called, when a configured connection quality monitoring
> + * event occurs.
> + */
> +void cfg80211_cqm_notify(struct net_device *dev,
> +			 enum nl80211_cqm_level rssi_level, gfp_t gfp);

I think you should just pass the RSSI value instead of this odd level.
If you can't do that, then at least rename cqm_level to
cqm_rssi_threshold_reached or something?

> +static struct nla_policy
> +nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX+1] __read_mostly = {
> +	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U8 },
> +	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U8 },
> +	[NL80211_ATTR_CQM_RSSI_LEVEL] = { .type = NLA_U32 },
> +};

Using a u8 for RSSI isn't really a great thing to do, I think. Can't we
just use s32 (aka u32)?

johannes

