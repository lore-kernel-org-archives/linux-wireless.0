Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42689 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3FDKHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:07:35 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: RE: [PATCH v8] cfg80211: P2P find phase offload
Date: Tue, 4 Jun 2013 10:07:31 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A01ACFCDFB@HASMSX105.ger.corp.intel.com> (sfid-20130604_120739_138156_FECD4028)
References: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1370328271-9523-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
In-Reply-To: <1370328271-9523-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vladimir,

>  /**
> + * struct cfg80211_p2p_find_params - parameters for P2P find
> + * @probe_ie: extra IE's for probe frames
> + * @probe_ie_len: length, bytes, of @probe_ie
> + * @probe_resp_ie: extra IE's for probe response frames
> + * @probe_resp_ie_len: length, bytes, of @probe_resp_ie
> + *	Driver/firmware may add additional IE's as well as modify
> + *	provided ones; typical IE's to be added are
> + *	WLAN_EID_EXT_SUPP_RATES, WLAN_EID_DS_PARAMS,
> + *	WLAN_EID_HT_CAPABILITY.
> + * @min_discoverable_interval: and
> + * @max_discoverable_interval: min/max for random multiplier of 100TU's
> + *	for the listen state duration
> + * @n_channels: number of channels to operate on
> + * @channels: channels to operate on
> + */
> +struct cfg80211_p2p_find_params {

The parameters are missing the listen channel (which is needed to the listen phase).

> +	const u8 *probe_ie;
> +	size_t probe_ie_len;
> +	const u8 *probe_resp_ie;
> +	size_t probe_resp_ie_len;
> +	u32 min_discoverable_interval;
> +	u32 max_discoverable_interval;

I do not see a real value for the max/min_discoverable_interval. Is there a use case of specifying these limits and not using the default ones?

> +
> +	int n_channels;
> +	struct ieee80211_channel **channels;
> +};
> +
> +/**
>   * struct cfg80211_ops - backend description for wireless configuration
>   *
>   * This struct is registered by fullmac card drivers and/or wireless stacks @@ -
> 2037,6 +2065,17 @@ struct cfg80211_update_ft_ies_params {
>   *	driver can take the most appropriate actions.
>   * @crit_proto_stop: Indicates critical protocol no longer needs increased link
>   *	reliability. This operation can not fail.
> + *
> + * @start_p2p_find: start P2P find phase
> + *	Parameters include IEs for probe/probe-resp frames;
> + *	and channels to operate on.
> + *	Parameters are not retained after call, driver need to copy data if
> + *	it need it later.
> + *	P2P find can't run concurrently with ROC or scan, and driver should
> + *	check this.

It might be good to define the exact semantics of p2p_find with regards to ROC/Scan, i.e., when p2p_find is requested during ROC/scan, should the driver save the request and handle it when the other operation is done, or should it return EBUSY or something similar (and also what are the semantics when requesting ROC/scan while p2p_find is in progress).

> 
> +static int nl80211_start_p2p_find(struct sk_buff *skb, struct genl_info
> +*info) {
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct wireless_dev *wdev = info->user_ptr[1];
> +	struct wiphy *wiphy = &rdev->wiphy;
> +	/*
> +	 * Defaults, as defined in the spec
> +	 * Ref: Wi-Fi Peer-to-Peer (P2P) Technical Specification v1.1
> +	 * Clause: 3.1.2.1.3 Find Phase
> +	 */
> +	struct cfg80211_p2p_find_params params = {
> +		.min_discoverable_interval = 1,
> +		.max_discoverable_interval = 3,
> +	};
> +	struct nlattr *attr_freq = info-
> >attrs[NL80211_ATTR_SCAN_FREQUENCIES];
> +	struct nlattr *attr;
> +	int err, tmp, n_channels, i = 0;
> +	struct ieee80211_channel **channels = NULL;
> +
> +	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
> +		return -EOPNOTSUPP;
> +
> +	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
> +		return -EINVAL;
> +
> +	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE_PROBE_RESP]))
> +		return -EINVAL;
> +
> +	if (!rdev->ops->start_p2p_find || !rdev->ops->stop_p2p_find)
> +		return -EOPNOTSUPP;
> +
> +	if (rdev->scan_req)
> +		return -EBUSY;
> +
> +	if (attr_freq) {
> +		n_channels = validate_scan_freqs(attr_freq);
> +		if (!n_channels)
> +			return -EINVAL;
> +
> +		channels = kzalloc(n_channels * sizeof(*channels),
> GFP_KERNEL);
> +		if (!channels)
> +			return -ENOMEM;
> +
> +		/* user specified, bail out if channel not found */
> +		nla_for_each_nested(attr, attr_freq, tmp) {
> +			struct ieee80211_channel *chan;
> +
> +			chan = ieee80211_get_channel(wiphy,
> nla_get_u32(attr));
> +
> +			if (!chan) {
> +				err = -EINVAL;
> +				goto out_free;
> +			}
> +
> +			/* ignore disabled channels */
> +			if (chan->flags & IEEE80211_CHAN_DISABLED)
> +				continue;
> +
> +			params.channels[i] = chan;
> +			i++;
> +		}
> +		if (!i) {
> +			err = -EINVAL;
> +			goto out_free;
> +		}
> +
> +		params.n_channels = i;
> +		params.channels = channels;
> +	}
> +

Do we need to set the default channels if the attribute is not set (or require that this attribute will be part of the command).

> +	attr = info->attrs[NL80211_ATTR_IE];
> +	if (attr) {
> +		params.probe_ie_len = nla_len(attr);
> +		params.probe_ie = nla_data(attr);
> +	}
> +
> +	attr = info->attrs[NL80211_ATTR_IE_PROBE_RESP];
> +	if (attr) {
> +		params.probe_resp_ie_len = nla_len(attr);
> +		params.probe_resp_ie = nla_data(attr);
> +	}

Is it valid to get Probe response IEs even if the driver did not report support for it?

Regards,

Ilan.
