Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35693 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbcDFIke (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:40:34 -0400
Message-ID: <1459932027.17504.27.camel@sipsolutions.net> (sfid-20160406_104038_939626_90C63607)
Subject: Re: [PATCHv3 RESEND 03/11] cfg80211: add add_nan_func / rm_nan_func
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 10:40:27 +0200
In-Reply-To: <1459244109-16038-3-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-3-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 12:35 +0300, Emmanuel Grumbach wrote:

> + * @cookie: user defined cookie (will be returned with
> notifications)

Didn't we change it to not be user defined?

> + * @NL80211_NAN_FUNC_TTL: number of DWs this function should stay
> active. 0 is
> + *	equivalent to no TTL at all. This is a u32.

I think it should rather be "if the attribute is not specified, no TTL
is used", with 0 being an invalid value.

> + * @NL80211_NAN_FUNC_RX_MATCH_FILTER: Receive Matching filter. This
> is a nested
> + *	attribute. It is a list of binary values.

That probably needs to say what kind if "binary values"?

> + * @NL80211_NAN_FUNC_TX_MATCH_FILTER: Transmit Matching filter. This
> is a
> + *	nested attribute. It is a list of binary values.

Ditto.

> + * @NL80211_NAN_SRF_INCLUDE: true if the include bit of the SRF set.
> + *	This is a flag.
> + * @NL80211_NAN_SRF_TYPE_BF: true if the SRF is a Bloom Filter SRF.
> If false
> + *	the SRF will be &NL80211_ATTR_MAC_ADDRS. This is a flag.

"true" and "false" aren't really states for a flag, it can be
"specified" or "not specified", or maybe "present" and "not present".

> + * @NL80211_NAN_SRF_BF: Bloom Filter. Relevant and mandatory if
> + *	&NL80211_NAN_SRF_TYPE_BF is true. This attribute is
> binary.

Likewise.
However, why do you even need two attributes? It doesn't seem relevant
to specify the NAN_SRF_BF attribute when NAN_SRF_TYPE_BF isn't set?

> + * @NL80211_NAN_SRF_BF_IDX: index of the Bloom Filter. Relevant and
> + *	mandatory if &NL80211_NAN_SRF_TYPE_BF is true. This is a
> u8.

Likewise - what do you need the SRF_TYPE_BF flag for at all?

> + * @NL80211_NAN_SRF_MAC_ADDRS: list of MAC addresses for the SRF.
> Relevant and
> + *	mandatory if &NL80211_NAN_SRF_TYPE_BF is false. This is a
> nested
> + *	attribute. Each nested attribute is a MAC address.

And this is obviously the opposite - so both SRF_MAC_ADDRS and
SRF_BR/BF_IDX can't be specified together. No need for the flag?


> +	if (tx) {
> +		func->num_tx_filters = (u8)n_entries;
> +		func->tx_filters = filter;
> +	} else {
> +		func->num_rx_filters = (u8)n_entries;
> +		func->rx_filters = filter;

No need for those casts.

johannes
