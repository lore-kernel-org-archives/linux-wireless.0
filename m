Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33167 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967592AbaLLMh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:37:59 -0500
Message-ID: <1418387875.2470.31.camel@sipsolutions.net> (sfid-20141212_133802_236643_3ABB9588)
Subject: Re: [PATCH v8 1/4] cfg80211: allow usermode to query wiphy specific
 regdom
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 12 Dec 2014 13:37:55 +0100
In-Reply-To: <1417622897-30768-1-git-send-email-arik@wizery.com> (sfid-20141203_170816_721996_A0EB392E)
References: <1417622897-30768-1-git-send-email-arik@wizery.com>
	 (sfid-20141203_170816_721996_A0EB392E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-03 at 18:08 +0200, Arik Nemtsov wrote:

>   * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
> - * 	regulatory domain.
> + *	regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
> + *	has a private regulatory domain, it will be returned. Otherwise, the
> + *	global regdomain will be returned.
> + *	A device will have a private regulatory domain if it uses the
> + *	regulatory_hint() API. Even when a private regdomain is used the channel
> + *	information will still be mended according to further hints from
> + *	the regulatory core to help with compliance.

I think you need to document the new availability of the dump version of
this now.

> +	if (!regdom && !cfg80211_regdomain) {

I'm not sure why sparse doesn't warn here, but I think that should
probably use rcu_access_pointer(cfg80211_regdomain).

More realistically, the regdomain can never be NULL I think, so is that
even needed? OTOH, if it can be NULL, then you must make this check
after the rcu_dereference, which would make this code easier to follow.

> +		nlmsg_free(msg);
> +		return -EINVAL;
> +	}
> +
> +	if (!wiphy && reg_last_request_cell_base() &&
> +	    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
> +			NL80211_USER_REG_HINT_CELL_BASE))
> +		goto nla_put_failure;
> +
> +	rcu_read_lock();
> +
> +	if (!regdom)
> +		regdom = rcu_dereference(cfg80211_regdomain);

i.e. move the check into this if here

johannes

