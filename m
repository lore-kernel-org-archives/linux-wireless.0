Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3LCNZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 08:25:33 -0500
Message-ID: <1386077130.4393.21.camel@jlt4.sipsolutions.net> (sfid-20131203_142537_442351_B9A4DE15)
Subject: Re: [PATCHv3] cfg80211: add support for frequency interference event
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajesh Chauhan <rajeshc@qca.qualcomm.com>
Cc: rodrigue@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	jouni@qca.qualcomm.com, hbahini@qca.qualcomm.com,
	jjohnson@qca.qualcomm.com, schang@qca.qualcomm.com,
	xunl@qca.qualcomm.com, sameert@qca.qualcomm.com,
	c_arifh@qca.qualcomm.com
Date: Tue, 03 Dec 2013 14:25:30 +0100
In-Reply-To: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-11 at 11:32 -0800, Rajesh Chauhan wrote:

> + * This structure provides frequency range(s) that should be avoided
> + *	because of interference.

extra tab that should be a space only

> + * @interference_source: enum nl80211_freq_interference_source_type
> + *	is used to specify source of interference.

Do we expect that different sources would be treated differently? If
not, what use is this?

> + * @start_freq: start of frequency range. Frequency is specified in
> + *	KHz and is center frequency in 20 MHz channel bandwidth
> + * @end_freq: end of frequency range. Frequency is specified in KHz
> + *	and is center frequency in 20 MHz channel bandwidth

Why would those be required to be center frequencies of some wireless
channels? That doesn't make much sense, e.g. if you have raw
interference data from a modem, no?

>  /**
> + * cfg80211_avoid_frequency_event - frequency interference event
> + * @netdev: network device
> + * @freq_list: frequency range(s) information
> + * @gfp: allocation flags
> + *
> + * Wireless driver calls this function to notify userspace about frequency
> + * range(s) that should be avoided because of interference.
> + */
> +void cfg80211_avoid_frequency_event(struct net_device *netdev,
> +		   struct cfg80211_avoid_frequency_list *freq_list, gfp_t gfp);

Indentation. Also, that freq_list parameter should probably be const?

> + * @NL80211_CMD_AVOID_FREQUENCIES_EVENT: Send range(s) of interfering
> + *	frequencies that should be avoided, from the wireless driver to the
> + *	user space. If SoftAP/P2P-GO is operating on interfering frequency
> + *	then user space should stop and resart them avoiding interfering

typo: restart

> + *	frequency range(s). User space may decide to continue operation on
> + *	interfering frequency, but in such case, there might be impact on
> + *	performance.

Also, I think describing policy here ("userspace should stop and
restart") is wrong. This should be up to userspace. It could
alternatively do a real CSA for example.

> + * @NL80211_ATTR_AVOID_FREQUENCIES: Avoid frequencies container
> information

That should probably describe in more detail how the information in it
is formatted.

> +/**,
> + * enum nl80211_avoid_frequency_attr - avoid frequency attributes
> + * @__NL80211_FREQUENCY_ATTR_INVALID: attribute number 0 is reserved
> + * @NL80211_AVOID_FREQUENCY_ATTR_INTERFERENCE_SOURCE_TYPE: interference
> + *	source
> + * @NL80211_AVOID_FREQUENCY_ATTR_START_FREQ: Start of frequency range.
> + *	Frequency is specified in KHz and is center frequency in 20 MHz
> + *	channel bandwidth.
> + * @NL80211_AVOID_FREQUENCY_ATTR_END_FREQ: End of frequency range.
> + *	Frequency is specified in KHz and is center frequency in 20 MHz
> + *	channel bandwidth.
> + * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use

missing docs for the other remaining enum members


> +void cfg80211_avoid_frequency_event(struct net_device *netdev,
> +		struct cfg80211_avoid_frequency_list *freq_list, gfp_t gfp)

indentation

> +	struct wiphy *wiphy;
> +	struct cfg80211_registered_device *rdev;
> +	struct sk_buff *msg;
> +	void *hdr;
> +	struct nlattr *nl_ranges, *nl_range;
> +	int err = -EINVAL;

wtf? that value is never used - don't randomly initialize variables. Is
the variable itself even used?

> +	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_AVOID_FREQUENCIES_EVENT);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return;
> +	}
> +
> +	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
> +		goto nla_put_failure;

wdev index is missing, however, see above.

> +	for (i = 0; i < freq_list->n_freq_ranges; i++) {
> +		nl_range = nla_nest_start(msg, i);

0 is invalid, I'm pretty sure.

> +	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
> +				nl80211_mlme_mcgrp.id, gfp);

This is no longer the right API

johannes

