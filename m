Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42894 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3GIQE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 12:04:58 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: Re: [PATCH v13 2/2] cfg80211: P2P find phase offload
Date: Tue, 9 Jul 2013 19:04:54 +0300
Message-ID: <1798954.bErCmKeDh5@lx-vladimir> (sfid-20130709_180502_425448_D8913000)
In-Reply-To: <1373383341.8241.8.camel@jlt4.sipsolutions.net>
References: <1372331863-14083-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <9095491.AkZl2nGOCe@lx-vladimir> <1373383341.8241.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, July 09, 2013 05:22:21 PM Johannes Berg wrote:
> 
> A few nits, since you're going to have to resend anyway (this patch is
> also line-wrapped)
> 
> 
> > NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD
> 
> Is that actually needed at all? Now that we have the "replied" flag in
> the first patch, it seems like this wouldn't be used at all?

I was thinking about it; and argument to keep this flag is:
It is hint for wpa_s, indicating that it may be that frame was answered by
card and not reported. Imagine card that answer everything in firmware and
don't report any probes at all. Without this hint, wpa_s may mis-interpret
this as complete silence.

But, to be honest, I am not absolutely sure it is required. If Jouni say he
don't need this indication, I'll remove it.

Jouni: could you please comment?

> 
> >  			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
> > +			CMD(start_p2p_find, START_P2P_FIND);
> > +			CMD(stop_p2p_find, STOP_P2P_FIND);
> 
> That'll probably have to be changed when mac80211 supports this, but we
> don't have to worry about it right now.
> 
> > +}
> > +static int nl80211_start_p2p_find(struct sk_buff *skb, struct genl_info 
> > *info)
> 
> There should be a blank line between the two functions

:) checkpatch was silent about it

> 
> > +	params.channels = kzalloc(n_channels * sizeof(*params.channels),
> > +				  GFP_KERNEL);
> 
> kcalloc? Probably doesn't matter much though.
Good point. Why not?

> 
> > +	attr = info->attrs[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL];
> > +	if (attr)
> > +		params.min_discoverable_interval = nla_get_u32(attr);
> > +
> > +	attr = info->attrs[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL];
> > +	if (attr)
> > +		params.max_discoverable_interval = nla_get_u32(attr);
> 
> No validation at all? What if I pass 7/3 for min/max (yes, in that
> order)?
Yes, need to validate all data from user space.
> 
> johannes
> 
