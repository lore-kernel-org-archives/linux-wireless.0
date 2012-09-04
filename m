Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2IDIiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 04:38:03 -0400
Message-ID: <1346747916.3737.23.camel@jlt4.sipsolutions.net> (sfid-20120904_103838_286409_7664F48B)
Subject: Re: [RFC 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 04 Sep 2012 10:38:36 +0200
In-Reply-To: <1346675037-17858-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346675037-17858-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1346675037-17858-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-03 at 17:53 +0530, Vasanthakumar Thiagarajan wrote:

> +++ b/include/linux/nl80211.h
> @@ -169,7 +169,8 @@
>   *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
>   *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
>   *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
> - *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
> + *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_INACTIVITY_TIMEOUT
> + *	and %NL80211_ATTR_MAC_ACL.
>   *	The channel to use can be set on the interface or be given using the
>   *	%NL80211_ATTR_WIPHY_FREQ and %NL80211_ATTR_WIPHY_CHANNEL_TYPE attrs.
>   * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
> @@ -573,6 +574,16 @@
>   * @NL80211_CMD_STOP_P2P_DEVICE: Stop the given P2P Device, identified by
>   *	its %NL80211_ATTR_WDEV identifier.
>   *
> + * @NL80211_CMD_SET_MAC_ACL: sets a list of mac addresses for access control.
> + *	This is to be used with the drivers advertising the support of mac
> + *	address based access control. The list of mac addresses defined by
> + *	%NL80211_ATTR_MAC_ADDRS would replace any existing acl list in driver
> + *	for a particular acl policy specified by %NL80211_ATTR_ACL_POLICY.
> + *	When the passed list of mac address is empty for a particular acl
> + *	policy,	driver has to clear corresponding acl list. This command is
> + *	used in AP/P2P GO mode. Driver has to make sure its acl lists are
> + *	cleared during %NL80211_CMD_START_AP and NL80211_CMD_STOP_AP.

This is a bit strange & racy. Why require a flag first to enable/disable
the feature, and then a second call to set up the list? It seems you
should pass the initial list to the start_ap() call to start with, and
it's disabled at the beginning if no list is given...

> + * @NL80211_ATTR_MAC_ACL: Flag attribute to enable or disable mac address
> + *	based access control in driver, needs to be used with the drivers
> + *	which advertise this support.

Then it seems you should get rid of this attribute entirely.

> + * @NL80211_ATTR_MAC_ADDRS: Nested attribute with mac addresses used for ACL.

Probably should have more explanation of how it's nested, at least that
it's an array?

> @@ -3015,6 +3049,8 @@ enum nl80211_ap_sme_features {
>   *	in the interface combinations, even when it's only used for scan
>   *	and remain-on-channel. This could be due to, for example, the
>   *	remain-on-channel implementation requiring a channel context.
> + * @NL80211_FEATURE_MAC_ACL: Driver does MAC address based access control
> + *	in AP/P2P GO mode.

Should probably document, and enforce, that this is only valid if the
device has AP_SME (NL80211_ATTR_DEVICE_AP_SME is present)?

In fact, it seems it should be the first NL80211_ATTR_DEVICE_AP_SME
feature, rather than an nl80211 feature flag.

> +static int validate_acl_mac_addrs(struct nlattr *nl_attr)
> +{
> +	struct nlattr *attr;
> +	int n_entries = 0, tmp;
> +
> +	nla_for_each_nested(attr, nl_attr, tmp) {
> +		if (nla_len(attr) != ETH_ALEN)
> +			return -1;
> +
> +		if (is_multicast_ether_addr(nla_data(attr)))
> +			return -1;

It seems better to return a proper error code here.

You should also document that this function must either return an error
or the number of nested attributes and can't skip anything etc.
Otherwise your other code below can cause major issues.

> +static int nl80211_set_mac_acl(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	struct cfg80211_acl_params *params;
> +	struct nlattr *attr;
> +	int n_mac_addrs = 0, i = 0, tmp, err;
> +
> +	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
> +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
> +		return -EOPNOTSUPP;

This also needs to check that the interface is operating already in AP
mode.

>  static int nl80211_parse_beacon(struct genl_info *info,
>  				struct cfg80211_beacon_data *bcn)
>  {
> @@ -2607,6 +2694,13 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>  	if (err)
>  		return err;
>  
> +	if (info->attrs[NL80211_ATTR_MAC_ACL]) {
> +		if (!(rdev->wiphy.features & NL80211_FEATURE_MAC_ACL))
> +			return -EOPNOTSUPP;
> +		params.acl_mac =
> +			!!nla_get_u8(info->attrs[NL80211_ATTR_MAC_ACL]);

Ewww. Some validation would be good. But I said get rid of this
anyway :)

johannes

