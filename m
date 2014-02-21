Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbaBUIhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:37:06 -0500
Message-ID: <1392971822.4346.25.camel@jlt4.sipsolutions.net> (sfid-20140221_093712_320527_A285DBD3)
Subject: Re: [PATCH v3 3/7] cfg80211: refactor cfg80211_can_use_iftype_chan()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Fri, 21 Feb 2014 09:37:02 +0100
In-Reply-To: <1392906986-12275-4-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-4-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:

> +/**
> + * cfg80211_check_combinations() - check interface combinations

I don't think those parentheses are right?

> + *
> + * @wiphy: the wiphy
> + * @num_different_channels: the number of different channels we want
> + *	to use for verification
> + * @num_interfaces: the number of different interfaces we want to use
> + *	for verification
> + * @used_iftypes: a bitmap where each bit corresponds to an interface
> + *	type, as in the definition of &struct
> + *	ieee80211_iface_limit.@types.
> + * @radar_detect: a bitmap where each bit corresponds to a channel
> + *	width where radar detection is needed, as in the definition of
> + *	&struct ieee80211_iface_combination.@radar_detect_widths

Doesn't that need to be something like hweight(radar_detect) == 1?

> + * @iftype_num: array with the numbers of interfaces of each interface
> + *	type.  The index is the interface type as specified in &enum
> + *	nl80211_iftype.
> + *
> + * This function can be called by the driver to check whether a
> + * combination of interfaces and their types are allowed according to
> + * the interface combinations.
> + */
> +int cfg80211_check_combinations(struct wiphy *wiphy,
> +				const int num_different_channels,
> +				const int num_interfaces,
> +				const u32 used_iftypes,
> +				const u8 radar_detect,
> +				const int *iftype_num);

I think that array should be const int iftype_num[NUM_NL80211_IFTYPES],
I'm pretty sure that works as a function argument as well and would
serve as a bit of documentation (and possibly even compiler warnings if
somebody has an array that's too short)

johannes

