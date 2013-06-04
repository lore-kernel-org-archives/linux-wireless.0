Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23252 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3FDLYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:24:23 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
Date: Tue, 4 Jun 2013 14:24:19 +0300
Message-ID: <2446389.or6hSZ58yP@lx-vladimir> (sfid-20130604_132426_637656_B87D340A)
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A01ACFCDFB@HASMSX105.ger.corp.intel.com>
References: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1370328271-9523-2-git-send-email-qca_vkondrat@qca.qualcomm.com> <CB3B3D4774441E42AA3EA0E1BA8230A01ACFCDFB@HASMSX105.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, June 04, 2013 10:07:31 AM Peer, Ilan wrote:
> Hi Vladimir,
> 
> > + * @min_discoverable_interval: and
> > + * @max_discoverable_interval: min/max for random multiplier of 100TU's
> > + *	for the listen state duration
> > + * @n_channels: number of channels to operate on
> > + * @channels: channels to operate on
> > + */
> > +struct cfg80211_p2p_find_params {
> 
> The parameters are missing the listen channel (which is needed to the listen phase).

There are n_channels and channels that define set of social channels
to operate on. It applies to both listen and search.

> > +	u32 min_discoverable_interval;
> > +	u32 max_discoverable_interval;
> 
> I do not see a real value for the max/min_discoverable_interval. Is there a use case of specifying these limits and not using the default ones?

Spec says these parameters may be changed.
Practical use, suggested by spec:

- search-only P2P device may set
min_discoverable_interval = max_discoverable_interval = 0
- listen-most P2P device may set min_discoverable_interval >> 0 and
max_discoverable_interval >= min_discoverable_interval

> > + *
> > + * @start_p2p_find: start P2P find phase
> > + *	Parameters include IEs for probe/probe-resp frames;
> > + *	and channels to operate on.
> > + *	Parameters are not retained after call, driver need to copy data if
> > + *	it need it later.
> > + *	P2P find can't run concurrently with ROC or scan, and driver should
> > + *	check this.
> 
> It might be good to define the exact semantics of p2p_find with regards to ROC/Scan, i.e., when p2p_find is requested during ROC/scan, should the driver save the request and handle it when the other operation is done, or should it return EBUSY or something similar (and also what are the semantics when requesting ROC/scan while p2p_find is in progress).

My opinion is ROC/scan collision with p2p_find is indication of error
in the supplicant; and proper response would be -EBUSY. Actually, code
in nl80211 check for scan (see below), but ROC is harder to detect.
I'll add explanation to the comment - anyway Johannes wants me to fix
for genlmsg_end() never returning negative value.

> > +
> > +	if (rdev->scan_req)
> > +		return -EBUSY;

> > +
> > +	if (attr_freq) {
> > +		n_channels = validate_scan_freqs(attr_freq);
> > +		if (!n_channels)
> > +			return -EINVAL;
> > +
> > +		channels = kzalloc(n_channels * sizeof(*channels),
> > GFP_KERNEL);
> > +		if (!channels)
> > +			return -ENOMEM;
> > +
> > +		/* user specified, bail out if channel not found */
> > +		nla_for_each_nested(attr, attr_freq, tmp) {
> > +			struct ieee80211_channel *chan;
> > +
> > +			chan = ieee80211_get_channel(wiphy,
> > nla_get_u32(attr));
> > +
> > +			if (!chan) {
> > +				err = -EINVAL;
> > +				goto out_free;
> > +			}
> > +
> > +			/* ignore disabled channels */
> > +			if (chan->flags & IEEE80211_CHAN_DISABLED)
> > +				continue;
> > +
> > +			params.channels[i] = chan;
> > +			i++;
> > +		}
> > +		if (!i) {
> > +			err = -EINVAL;
> > +			goto out_free;
> > +		}
> > +
> > +		params.n_channels = i;
> > +		params.channels = channels;
> > +	}
> > +
> 
> Do we need to set the default channels if the attribute is not set (or require that this attribute will be part of the command).

Logic is the following:
- supplicant may omit channel list at all, this mean
"use all social channels", kind of default behavior
- supplicant may specify channel subset, in this case it should be not empty.

I'll comment it too.

> > +
> > +	attr = info->attrs[NL80211_ATTR_IE_PROBE_RESP];
> > +	if (attr) {
> > +		params.probe_resp_ie_len = nla_len(attr);
> > +		params.probe_resp_ie = nla_data(attr);
> > +	}
> 
> Is it valid to get Probe response IEs even if the driver did not report support for it?

One can't do p2p_find if it does not reply to P2P discovery probes.
It is unrelated to answering probes in AP mode - driver may leave this
to supplicant.

Thanks, Vladimir
