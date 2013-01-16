Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab3APWdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:33:37 -0500
Message-ID: <1358375638.15012.29.camel@jlt4.sipsolutions.net> (sfid-20130116_233341_109779_5F2063A6)
Subject: Re: [PATCH V8 2/2] cfg80211/nl80211: Enable drivers to implement
 MAC address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	djindal@qti.qualcomm.com
Date: Wed, 16 Jan 2013 23:33:58 +0100
In-Reply-To: <1357707372-12273-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1357707372-12273-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1357707372-12273-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 10:26 +0530, Vasanthakumar Thiagarajan wrote:

> +/**
> + * enum nl80211_acl_policy_attr - The access control policy which needs to be
> + *	applied on a MAC list set by %NL80211_CMD_START_AP and
> + *	%NL80211_CMD_SET_MAC_ACL. To be used with %NL80211_ATTR_ACL_POLICY.

This is not valid kernel-doc, the short description must fit on the line
and you can have extra description later.

> +	if (WARN_ON((wiphy->max_acl_mac_addrs) &&

extra parentheses?

> +/* This function returns an error or the number of nested attributes */
> +static int validate_acl_mac_addrs(struct nlattr *nl_attr)
> +{
> +	struct nlattr *attr;
> +	int n_entries = 0, tmp;
> +
> +	nla_for_each_nested(attr, nl_attr, tmp) {
> +		if (nla_len(attr) != ETH_ALEN)
> +			return -EINVAL;
> +
> +		if (!is_valid_ether_addr(nla_data(attr)))
> +			return -EINVAL;

Does that make sense? If somebody wants to fill the list with invalid
addresses, maybe they should be able to? especially if it's a blacklist
and the client is, for some reason, already using an invalid address?

> +/*
> + * This function parses ACL information and allocates memory for ACL data.
> + * On successful return, the calling function is responsible to free the
> + * ACL buffer returned by this function.
> + */
> +static int parse_acl_data(struct wiphy *wiphy, struct genl_info *info,
> +			  struct cfg80211_acl_data **acl)

Please use ERR_PTR() and family and return the structure.

> +	err = rdev->ops->set_mac_acl(&rdev->wiphy, dev, acl);

tracing please.

johannes

