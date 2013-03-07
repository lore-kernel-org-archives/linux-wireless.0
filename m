Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:51406 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3CGOLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 09:11:03 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] P2P find offload
Date: Thu, 7 Mar 2013 16:10:37 +0200
Message-ID: <1628850.y8u4o7KRXH@lx-vladimir> (sfid-20130307_151108_220549_1D130905)
In-Reply-To: <1362650938.8694.21.camel@jlt4.sipsolutions.net>
References: <3408094.SIuA27EmQ5@lx-vladimir> <7076584.7eoLUXqF3A@lx-vladimir> <1362650938.8694.21.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 07, 2013 11:08:58 AM Johannes Berg wrote:
> > +	int n_channels;
> > +	/* Up to 4 social channels: 3 in 2.4GHz band + 1 in 60GHz band */
> > +	struct ieee80211_channel *channels[4];
> 
> Hmm, is 4 really a good limit? If you wanted to implement progressive
> search as part of the find, for example, you'd need more? It seems like
> a pretty arbitrary limit -- should it be advertised to userspace?
It is P2P spec. P2P find operates on social channels; there are 3 social
channels on 2.4 band and 1 on 60. No social channels on 5.2.

I can rework to do dynamic allocation, but does it worth the effort?

> 
> > + * start_p2p_find: start P2P find phase
> > + *	Parameters include IEs for probe/probe resp and channels to operate on
> 
> The parameters?
> 
> you could spell out "resp" ...
> 
> Also needs a period (".") at the end or so, if the sentence runs on in
> the next line it doesn't make sense.
Yes, I'll fix this
> 
> > + *	Parameters are not retained after call, driver need to copy data if
> > + *	it need it later.
> > + * stop_p2p_find: stop P2P find phase
> > + *
> 
> don't need that blank line
Sure
> 
> > +	i = 0;
> > +	if (attr_freq) {
> 
> i can be inside the if()?
Moved to initializer

> 
> > +		/* user specified, bail out if channel not found */
> > +		nla_for_each_nested(attr, attr_freq, tmp) {
> > +			struct ieee80211_channel *chan;
> > +
> > +			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
> > +
> > +			if (!chan)
> > +				return -EINVAL;
> > +
> > +			/* ignore disabled channels */
> > +			if (chan->flags & IEEE80211_CHAN_DISABLED)
> > +				continue;
> 
> I think you should reject them, also if they have passive scan or
> various other flags set, I think?
Passive channel may be used as social for the listening; and may be
actively scanned if beacon found on the channel. Scan do not filter
based on these flags, I suppose same reason apply here.

> 
> > +			params.channels[i] = chan;
> > +			i++;
> > +		}
> > +		if (!i)
> > +			return -EINVAL;
> > +	}
> > +
> > +	params.n_channels = i;
> 
> if you also move that assignment
> 
> > +	i = 0;
> 
> Not needed.
Sure
> 
> > +	attr = info->attrs[NL80211_ATTR_IE];
> > +	if (attr) {
> 
> This is not typically done in nl80211, I'd prefer not having the
> variable I think.
It is to reasonable fit code into 80 columns. Let me know if this
argument don't play for you, I'll revert to variables.

> 
> > +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > +	if (!msg)
> > +		return -ENOMEM;
> > +
> > +	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
> > +			     NL80211_CMD_START_P2P_FIND);
> 
> Err? What's the value of sending a reply back here? It would seem maybe
> appropriate to send one when it *actually* started, but you haven't
> implemented that.
> 
> > +	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
> > +			     NL80211_CMD_STOP_P2P_FIND);
> 
> same here ...
Yes, agree. I'll add indications, like ROC do.

> 
> You're also entirely missing feature advertising, so userspace can only
> guess whether it's supported or not ...
Will do

>Also ...
>
> I really don't think this should be supported on IBSS/AP/... netdevs.
> Seems like the only reasonable ones are P2P_DEVICE and STATION, although
> it would probably be good to have feature advertising for both, or
> document that if P2P_DEVICE is supported at all then this doesn't have
> to be supported on STATION interfaces, or so.
Yes, sure. will add checks
> 
> And then ... should this really be allowed to be concurrent with
> scanning/remain-on-channel? You haven't done any checking or
> documentation, so users and driver authors are left to guess.
I check for scan, but not for ROC. Btw, scan also don't check for ROC.
And, ROC don't check for scan.
I'll document that driver should do all checks for ROC/scan.
>  
> johannes
> 

Thanks, Vladimir

