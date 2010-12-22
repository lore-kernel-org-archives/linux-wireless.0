Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0LVOCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:02:08 -0500
Subject: Re: [PATCH 1/2] cfg80211: process new country regulatory flags
 (DFS)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, kathy.giori@atheros.com,
	amod.bodas@atheros.com, david.quan@atheros.com,
	michael.green@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <1292864555-28661-3-git-send-email-lrodriguez@atheros.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
	 <1292864555-28661-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 15:02:05 +0100
Message-ID: <1293026525.3531.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-20 at 12:02 -0500, Luis R. Rodriguez wrote:

> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -858,6 +858,9 @@ enum nl80211_commands {
>   *	attributes, specifying what a key should be set as default as.
>   *	See &enum nl80211_key_default_types.
>   *
> + * @NL80211_ATTR_REG_COUNTRY_FLAGS: Country specific regulatory flags.
> + *	These are @NL80211_CFLAG_DFS_*
> + *

Please also add a note "(u16)" here or so.

> +#define flag_check_print(_str) \
> +	do { \
> +		if (has_flag) \
> +			pr_info(", "); \
> +		pr_info(_str); \
> +		has_flag = true; \
> +	} while (0)
> +
> +static void print_country_flags(u16 flags)
> +{

Can you move the define into the function, and also #undef it please?

Also -- it seems that this is never reported back to be printed by iw
reg get? I think that might be needed? If you do, it should only report
the ones that the kernel knows about (i.e. mask them with the _ALL
thing)

Does it make sense to actually have this a bitmask rather than an enum?
Do we think there's some place that needs _multiple_ rules?

johannes

