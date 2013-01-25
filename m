Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3AYRjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 12:39:04 -0500
Message-ID: <1359135561.4655.18.camel@jlt4.sipsolutions.net> (sfid-20130125_183908_419361_F93EF1E3)
Subject: Re: [PATCH V9 2/2] cfg80211/nl80211: Enable drivers to implement
 MAC address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 25 Jan 2013 18:39:21 +0100
In-Reply-To: <1358488125-6154-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1358488125-6154-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1358488125-6154-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm applying this because I've sat on it for such a long time, but I
think you can do better. I've fixed these issues with your patch:

> + * @NL80211_ATTR_ACL_POLICY: ACL policy, see &enum nl80211_acl_policy_attr.

You missed documenting the data type of this, I've changed it to u32 and
added the documentation.

> +/**
> + * enum nl80211_acl_policy_attr - access control policy
> + *
> + * Access control policy is applied on a MAC list set by
> + * %NL80211_CMD_START_AP and %NL80211_CMD_SET_MAC_ACL, to
> + * be used with %NL80211_ATTR_ACL_POLICY.
> + *
> + * @NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED: Deny stations which are
> + *	listed in ACL, i.e. allow all the stations which are not listed
> + *	in ACL to authenticate.
> + * @NL80211_ACL_POLICY_DENY_UNLESS_LISTED: Allow the stations which are listed
> + *	in ACL, i.e. deny all the stations which are not listed in ACL.
> + * @__NL80211_ACL_POLICY_AFTER_LAST: Internal use
> + * @NL80211_ACL_POLICY_MAX: Highest acl policy attribute
> + */
> +enum nl80211_acl_policy_attr {
> +	NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED,
> +	NL80211_ACL_POLICY_DENY_UNLESS_LISTED,

You're modelling this like an attribute, yet it's really just an enum
value, you should model it like enum nl80211_connect_failed_reason
(which you even touched the docs for.)

No need for all the overhead necessary for attributes.

Oh, and IF it actually had been attribute, then you'd have to reserve
index 0, so you'd have it wrong.


> +       if (WARN_ON(wiphy->max_acl_mac_addrs &&
> +                   (!(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME) ||
> +                   !rdev->ops->set_mac_acl)))
> +               return -EINVAL;

bad indentation

> +       if ((dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
> +           nla_put_u32(msg, NL80211_ATTR_MAC_ACL_MAX,
> +                       dev->wiphy.max_acl_mac_addrs))
> +               goto nla_put_failure;

(Almost?) all attributes are left out if they're not supported, so this
should be too.

johannes

