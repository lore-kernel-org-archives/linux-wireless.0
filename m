Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15750 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2GLDFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 23:05:08 -0400
Date: Wed, 11 Jul 2012 20:05:03 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] cfg80211: support TX error rate CQM
Message-ID: <20120712030502.GA7153@pista> (sfid-20120712_050544_216199_B06D1059)
References: <1342034458-3889-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1342037610.4464.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1342037610.4464.9.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2012 at 10:13:30PM +0200, Johannes Berg wrote:
> On Wed, 2012-07-11 at 12:20 -0700, Thomas Pedersen wrote:
> > Let the user configure serveral TX error conection quality monitoring
> > parameters: % error rate, survey interval, and # of attempted packets.
> > 
> > On exceeding the TX failure rate over the given interval, the driver
> > will send a CQM notify event with the actual TX failure rate and
> > packets attempted.
> 
> It seems useful to me to also send the interval, in case somebody else
> is listening to the events or in case the interval was changed, etc.?

The fw API does not support this, but I can track the interval in the
driver.

> > + * @NL80211_ATTR_CQM_TXE_RATE: TX error rate in %. Minimum % of TX failures
> > + *	during the given %NL80211_ATTR_CQM_TXE_INTVL before an
> > + *	%NL80211_CMD_NOTIFY_CQM with reported %NL80211_ATTR_CQM_TXE_RATE and
> > + *	%NL80211_ATTR_CQM_TXE_PKTS is generated.
> 
> Is percentage fine-grained enough? I guess it is?
> 
> > + * @NL80211_ATTR_CQM_TXE_PKTS: number of TX attempts in a given
> > + *	%NL80211_ATTR_CQM_TXE_INTVL before %NL80211_ATTR_CQM_TXE_RATE is
> > + *	checked.
> 
> I'm not sure I'd say "TX attempts", that gets confusing, do you count
> retries? I guess not. Maybe say "attempted packets" or something else
> that includes TX too?

"packets attempted" seems clear?

> > + * @NL80211_ATTR_CQM_TXE_INTVL: interval in seconds. Specifies the periodic
> > + *	interval in which %NL80211_ATTR_CQM_TXE_PKTS and
> > + *	%NL80211_ATTR_CQM_TXE_RATE must be satisfied before generating an
> > + *	%NL80211_CMD_NOTIFY_CQM.
> 
> Should there be some ... sanity checking? Like ... can't set it to more
> than, say, half an hour?

OK, I'll specify a max interval then.

> > +	} else if (attrs[NL80211_ATTR_CQM_TXE_RATE] &&
> > +		   attrs[NL80211_ATTR_CQM_TXE_PKTS] &&
> > +		   attrs[NL80211_ATTR_CQM_TXE_INTVL]) {
> > +		u32 rate, pkts, intvl;
> > +		rate = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_RATE]);
> > +		pkts = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_PKTS]);
> > +		intvl = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_INTVL]);
> > +		err = nl80211_set_cqm_txe(info, rate, pkts, intvl);
> 
> You should probably check things here ... e.g. the percentage can't be
> >100? :-)

see nl80211_set_cqm_txe() :)

> Also it seems like there should be some way to *disable* it again that
> you should document?

Configure an interval of 0 should be sufficient? all 0s?

Thanks,
Thomas
