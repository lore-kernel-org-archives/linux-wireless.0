Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab2GDJm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 05:42:28 -0400
Message-ID: <1341394944.4482.9.camel@jlt3.sipsolutions.net> (sfid-20120704_114232_395823_C379DC2C)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Date: Wed, 04 Jul 2012 11:42:24 +0200
In-Reply-To: <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Please split this series -- I won't apply the Atheros driver patches :-)


> + * @NL80211_ATTR_USER_REG_HINT_TYPE: type of regulatory hint passed from
> + *	userspace. If unset it is assumed the hint comes directly from
> + *	a user. If set code could specify exactly what type of source
> + *	was used to provide the hint. For the different types of
> + *	allowed user regulatory hints see nl80211_user_reg_hint_type.

Please mention what the data type is, but see below


> + * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
> + *	to work properly to suppport receiving regulatory hints from
> + *	cellular base stations.

Typo "support", but I don't understand the reasoning behind this flag?
First you hide away behind the certification Kconfig thing ...? Maybe
you just need to explain better exactly what the cell-base-station
regulatory hint does.


> +	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U8 },

Not much point in using a u8, I think you should just use a u32.

> -	r = regulatory_hint_user(data);
> +	if (info->attrs[NL80211_ATTR_USER_REG_HINT_TYPE])
> +		user_reg_hint_type =
> +		  nla_get_u8(info->attrs[NL80211_ATTR_USER_REG_HINT_TYPE]);

Need to verify that it's a valid number, I think, otherwise you can pass
random junk like 0x42 into the regulatory framework.

> @@ -3869,6 +3877,11 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
>  			cfg80211_regdomain->dfs_region)))
>  		goto nla_put_failure;
>  
> +	if (reg_last_request_cell_base() &&

Is that really worthwhile as a function call like this rather than some
sort of _get_hint_type()?

> +#ifdef CONFIG_CFG80211_CERTIFICATION_ONUS

So I'm not really convinced about this. It seems this Kconfig should
better be a Kconfig that enables other Kconfig only, not enabling other
features. How else would anyone be able to do due diligence and check
what exactly this enables that they need to test?

johannes

