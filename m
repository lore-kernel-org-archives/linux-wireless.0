Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2LSMQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 07:16:31 -0500
Message-ID: <1355919410.9954.14.camel@jlt4.sipsolutions.net> (sfid-20121219_131634_800014_2F80BE0F)
Subject: Re: [PATCH V3 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 19 Dec 2012 13:16:50 +0100
In-Reply-To: <1355748553-19560-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1355748553-19560-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1355748553-19560-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-17 at 18:19 +0530, Vasanthakumar Thiagarajan wrote:

>  /**
> + * struct cfg80211_acl_data - Access control data
> + * @acl_policy: Access control policy to be applied on the station's
> +	entry specified by mac_addr
> + * @n_acl_entries: Number of mac address entries passed
> + * @mac_addrs: List of mac addresses of stations to be used for acl
> + */
> +struct cfg80211_acl_data {
> +	enum nl80211_acl_policy_attr acl_policy;
> +	int n_acl_entries;
> +
> +	/* Keep it last */
> +	struct mac_address mac_addrs[0];

just [] would make more sense?

> +/**
> + * struct cfg80211_acl_settings - Access control configuration
> + * @acl_data: Acl data for various acl policies
> + * @mac_acl_list: Number of acl configurations
> + */
> +struct cfg80211_acl_settings {
> +	struct cfg80211_acl_data *acl_data[NL80211_ACL_POLICY_MAX + 1];
> +	int num_acl_list;
> +};

This ... doesn't make sense? Why not have the array and remove
num_acl_list here and the policy from the array entry?

> + * @max_acl_mac_addrs: Maximum number of mac addresses that the device
> + *	supports for ACL. Driver having ACL based on MAC address support
> + *	has to fill this. This limit is common for both (white and black)
> + *	the acl policies.
> + *
> + * @acl_types: Bit masks of supported acl policies

Still doesn't make sense. Drivers might support a whitelist _or_ a
blacklist, but not both, right?

> + * @NL80211_CONN_FAIL_ACL_NOTIFY: Connection failed because the client's
> +	mac address is not part of any acl list.

That description doesn't really make sense, presumably the default (if
there's no list) is allowing the connection.

> +/*
> + * This functoion parses acl information and fills the configuration.

typo function

> +	memset(avail_acl, 0, sizeof(avail_acl));
> +	nla_for_each_nested(nla_acl, acl_attr, tmp_acl) {
> +

better move the blank line one up?

> +		if (n_acl > NL80211_ACL_POLICY_MAX) {
> +			err = -EINVAL;
> +			goto free_acl;
> +		}
> +
> +		if (nla_parse_nested(tb, NL80211_ACL_ATTR_MAX, nla_acl,
> +				     mac_acl_policy))
> +			continue;
> +
> +		if (!tb[NL80211_ACL_ATTR_POLICY])
> +			continue;

shouldn't those be errors?

> +		acl_policy = nla_get_u8(tb[NL80211_ACL_ATTR_POLICY]);
> +		if (!(rdev->wiphy.acl_types & BIT(acl_policy)) ||
> +		    acl_policy > NL80211_ACL_POLICY_MAX)
> +			continue;

ditto

> +		/* Skip multiple acl information for the same acl policy */
> +		if (avail_acl[acl_policy])
> +			continue;

ditto

> +		if (!tb[NL80211_ACL_ATTR_MAC_ADDRS])
> +			continue;

that maybe as well?

> +		n_entries =
> +			validate_acl_mac_addrs(tb[NL80211_ACL_ATTR_MAC_ADDRS]);
> +		if (n_entries < 0 || n_entries > rdev->wiphy.max_acl_mac_addrs)
> +			continue;

ditto

> +		acl->acl_data[n_acl] =
> +			kzalloc(sizeof(struct cfg80211_acl_data) +
> +				(n_entries * sizeof(struct mac_address)),
> +				GFP_KERNEL);
> +		if (!acl->acl_data[n_acl]) {
> +			err = -ENOMEM;
> +			goto free_acl;
> +		}
> +
> +		j = 0;
> +		nla_for_each_nested(attr, tb[NL80211_ACL_ATTR_MAC_ADDRS], tmp) {
> +			memcpy(acl->acl_data[n_acl]->mac_addrs[j].addr,
> +			       nla_data(attr), ETH_ALEN);
> +			j++;
> +		}
> +
> +		acl->acl_data[n_acl]->n_acl_entries = j;
> +		acl->acl_data[n_acl]->acl_policy = acl_policy;
> +		avail_acl[acl_policy] = 1;
> +		n_acl++;
> +	}
> +
> +	if (!n_acl)
> +		return -EINVAL;
> +
> +	acl->num_acl_list = n_acl;
> +
> +	return 0;

Where is the data freed?

> @@ -2645,13 +2808,14 @@ static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
>  	}
>  }
>  
> +

??

>  static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>  	struct net_device *dev = info->user_ptr[1];
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
>  	struct cfg80211_ap_settings params;
> -	int err;
> +	int err, i;
>  
>  	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
>  	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
> @@ -2752,6 +2916,16 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>  	if (err)
>  		return err;
>  
> +	if (info->attrs[NL80211_ATTR_MAC_ACL_LISTS]) {
> +		if (!rdev->wiphy.acl_types)
> +			return -EOPNOTSUPP;
> +
> +		err = parse_acl_information(rdev,
> +				info->attrs[NL80211_ATTR_MAC_ACL_LISTS],
> +				&params.acl);
> +		if (err)
> +			return err;
> +	}
>  	err = rdev_start_ap(rdev, dev, &params);

that blank line should be here .... do I really have to review your
whitespace?

johannes

