Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3CGKJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:09:06 -0500
Message-ID: <1362650938.8694.21.camel@jlt4.sipsolutions.net> (sfid-20130307_110912_537897_94701872)
Subject: Re: [RFC] P2P find offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Mar 2013 11:08:58 +0100
In-Reply-To: <7076584.7eoLUXqF3A@lx-vladimir>
References: <3408094.SIuA27EmQ5@lx-vladimir>
	 <1362412079.21028.34.camel@jlt4.sipsolutions.net>
	 <1686131.738LDv7O6j@lx-vladimir> <7076584.7eoLUXqF3A@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-07 at 11:31 +0200, Vladimir Kondratiev wrote:

>  /**
> + * struct cfg80211_p2p_find_params - parameters for P2P find
> + * @probe_ie: IE's for probe frames
> + * @probe_ie_len: length, bytes, of @probe_ie
> + * @probe_resp_ie: IE's for probe response frames
> + * @probe_resp_ie_len: length, bytes, of @probe_resp_ie
> + * @n_channels: number of channels to operate on
> + * @channels: channels to operate on
> + */
> +struct cfg80211_p2p_find_params {
> +	const u8 *probe_ie;
> +	size_t probe_ie_len;
> +	const u8 *probe_resp_ie;
> +	size_t probe_resp_ie_len;
> +
> +	int n_channels;
> +	/* Up to 4 social channels: 3 in 2.4GHz band + 1 in 60GHz band */
> +	struct ieee80211_channel *channels[4];

Hmm, is 4 really a good limit? If you wanted to implement progressive
search as part of the find, for example, you'd need more? It seems like
a pretty arbitrary limit -- should it be advertised to userspace?

> + * start_p2p_find: start P2P find phase
> + *	Parameters include IEs for probe/probe resp and channels to operate on

The parameters?

you could spell out "resp" ...

Also needs a period (".") at the end or so, if the sentence runs on in
the next line it doesn't make sense.

> + *	Parameters are not retained after call, driver need to copy data if
> + *	it need it later.
> + * stop_p2p_find: stop P2P find phase
> + *

don't need that blank line

> +	i = 0;
> +	if (attr_freq) {

i can be inside the if()?

> +		/* user specified, bail out if channel not found */
> +		nla_for_each_nested(attr, attr_freq, tmp) {
> +			struct ieee80211_channel *chan;
> +
> +			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
> +
> +			if (!chan)
> +				return -EINVAL;
> +
> +			/* ignore disabled channels */
> +			if (chan->flags & IEEE80211_CHAN_DISABLED)
> +				continue;

I think you should reject them, also if they have passive scan or
various other flags set, I think?

> +			params.channels[i] = chan;
> +			i++;
> +		}
> +		if (!i)
> +			return -EINVAL;
> +	}
> +
> +	params.n_channels = i;

if you also move that assignment

> +	i = 0;

Not needed.

> +	attr = info->attrs[NL80211_ATTR_IE];
> +	if (attr) {

This is not typically done in nl80211, I'd prefer not having the
variable I think.

> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
> +			     NL80211_CMD_START_P2P_FIND);

Err? What's the value of sending a reply back here? It would seem maybe
appropriate to send one when it *actually* started, but you haven't
implemented that.

> +	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
> +			     NL80211_CMD_STOP_P2P_FIND);

same here ...

You're also entirely missing feature advertising, so userspace can only
guess whether it's supported or not ...

johannes

