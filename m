Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56068 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2LSNa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 08:30:29 -0500
Message-ID: <50D1C156.9030606@qca.qualcomm.com> (sfid-20121219_143032_452801_231574BD)
Date: Wed, 19 Dec 2012 18:59:58 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
References: <1355748553-19560-1-git-send-email-vthiagar@qca.qualcomm.com>  <1355748553-19560-2-git-send-email-vthiagar@qca.qualcomm.com> <1355919410.9954.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355919410.9954.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wednesday 19 December 2012 05:46 PM, Johannes Berg wrote:
> On Mon, 2012-12-17 at 18:19 +0530, Vasanthakumar Thiagarajan wrote:
>
>>   /**
>> + * struct cfg80211_acl_data - Access control data
>> + * @acl_policy: Access control policy to be applied on the station's
>> +	entry specified by mac_addr
>> + * @n_acl_entries: Number of mac address entries passed
>> + * @mac_addrs: List of mac addresses of stations to be used for acl
>> + */
>> +struct cfg80211_acl_data {
>> +	enum nl80211_acl_policy_attr acl_policy;
>> +	int n_acl_entries;
>> +
>> +	/* Keep it last */
>> +	struct mac_address mac_addrs[0];
>
> just [] would make more sense?

Ok.

>
>> +/**
>> + * struct cfg80211_acl_settings - Access control configuration
>> + * @acl_data: Acl data for various acl policies
>> + * @mac_acl_list: Number of acl configurations
>> + */
>> +struct cfg80211_acl_settings {
>> +	struct cfg80211_acl_data *acl_data[NL80211_ACL_POLICY_MAX + 1];
>> +	int num_acl_list;
>> +};
>
> This ... doesn't make sense? Why not have the array and remove
> num_acl_list here and the policy from the array entry?

The assumption is, there can be more than one list with respective
acl policy will be sent from user space.

>
>> + * @max_acl_mac_addrs: Maximum number of mac addresses that the device
>> + *	supports for ACL. Driver having ACL based on MAC address support
>> + *	has to fill this. This limit is common for both (white and black)
>> + *	the acl policies.
>> + *
>> + * @acl_types: Bit masks of supported acl policies
>
> Still doesn't make sense. Drivers might support a whitelist _or_ a
> blacklist, but not both, right?

I'm sorry that it is still not clear to me that both the lists can
not co-exist. It seems is reasonable that there can be
explicit white and black list configured, the stations which do
not have their entries in either of the lists needs to be notified
to user space for possible user feedback.

>
>> + * @NL80211_CONN_FAIL_ACL_NOTIFY: Connection failed because the client's
>> +	mac address is not part of any acl list.
>
> That description doesn't really make sense, presumably the default (if
> there's no list) is allowing the connection.

I think this can be implementation specific where some drivers
will allow the connections when the entry is not present in
any list which some notify the user for the feed back?.
The comment needs to be changed, i guess.

>> +
>> +		if (!tb[NL80211_ACL_ATTR_POLICY])
>> +			continue;
>
> shouldn't those be errors?

As there can be more than one list passed from userspace,
it makes sense to proceed with the next one when the current
one is not valid.

>> +		acl->acl_data[n_acl] =
>> +			kzalloc(sizeof(struct cfg80211_acl_data) +
>> +				(n_entries * sizeof(struct mac_address)),
>> +				GFP_KERNEL);
>> +		if (!acl->acl_data[n_acl]) {
>> +			err = -ENOMEM;
>> +			goto free_acl;
>> +		}
>> +
>> +		j = 0;
>> +		nla_for_each_nested(attr, tb[NL80211_ACL_ATTR_MAC_ADDRS], tmp) {
>> +			memcpy(acl->acl_data[n_acl]->mac_addrs[j].addr,
>> +			       nla_data(attr), ETH_ALEN);
>> +			j++;
>> +		}
>> +
>> +		acl->acl_data[n_acl]->n_acl_entries = j;
>> +		acl->acl_data[n_acl]->acl_policy = acl_policy;
>> +		avail_acl[acl_policy] = 1;
>> +		n_acl++;
>> +	}
>> +
>> +	if (!n_acl)
>> +		return -EINVAL;
>> +
>> +	acl->num_acl_list = n_acl;
>> +
>> +	return 0;
>
> Where is the data freed?

The data is freed by the calling function after it is
processed in the driver.

>>   static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>>   {
>>   	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>>   	struct net_device *dev = info->user_ptr[1];
>>   	struct wireless_dev *wdev = dev->ieee80211_ptr;
>>   	struct cfg80211_ap_settings params;
>> -	int err;
>> +	int err, i;
>>
>>   	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP&&
>>   	dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
>> @@ -2752,6 +2916,16 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>>   	if (err)
>>   		return err;
>>
>> +	if (info->attrs[NL80211_ATTR_MAC_ACL_LISTS]) {
>> +		if (!rdev->wiphy.acl_types)
>> +			return -EOPNOTSUPP;
>> +
>> +		err = parse_acl_information(rdev,
>> +				info->attrs[NL80211_ATTR_MAC_ACL_LISTS],
>> +				&params.acl);
>> +		if (err)
>> +			return err;
>> +	}
>>   	err = rdev_start_ap(rdev, dev,&params);
>
> that blank line should be here .... do I really have to review your
> whitespace?

I'm really sorry about the whitespace mistakes. thanks for
the review.

Vasanth
