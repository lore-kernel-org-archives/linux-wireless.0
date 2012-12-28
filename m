Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2L1NIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 08:08:52 -0500
Message-ID: <1356700150.9922.7.camel@jlt4.sipsolutions.net> (sfid-20121228_140855_318609_D19D18E7)
Subject: Re: [PATCH V4 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 28 Dec 2012 14:09:10 +0100
In-Reply-To: <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-28 at 15:51 +0530, Vasanthakumar Thiagarajan wrote:

> + * @acl_type: ACL policy that driver supports,
> + *	see &enum nl80211_acl_policy_attr.

That doesn't make a lot of sense, in particular not the way you use it.
What if a driver supports a blacklist but not a whitelist? It seems that
it should be a bitfield. Also setting a default that isn't "unsupported"
is a bad idea.

> +	NL80211_ATTR_ACL_POLICY,
> +
> +	NL80211_ATTR_MAC_ADDRS,
> +
> +	NL80211_ATTR_MAC_ACL_MAX,
> +
> +	NL80211_ATTR_ACL_TYPE,

> +	if (WARN_ON((wiphy->acl_type <= NL80211_ACL_POLICY_MAX) &&

So basically you could remove the acl_type field completely.


I think maybe if you want to continue supporting the white- & blacklist
you should change it back to nested attributes, but treat the blacklist
there as an optimisation and ignore it for feature advertising.

johannes

