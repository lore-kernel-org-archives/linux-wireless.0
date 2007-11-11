Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808AbXKKUUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 15:20:40 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 05/14] mac80211: adding 802.11n essential A-MPDU addBAcapability
Date: Sun, 11 Nov 2007 22:20:35 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04008797@hasmsx411.ger.corp.intel.com> (sfid-20071111_202043_649683_FC312247)
In-Reply-To: <1194626075.4793.128.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> As this series of patches only adds HT handling with no aggregations,
>> (A-MPDU aggregations acceptance is not obligatory according to
802.11n draft)
>> we are currently sending back a refusal upon this request.

> Heh. In the Kconfig you just wrote that it handles AMPDU and AMSDU
> aggregation which I'd expect to imply deaggregation too. Nothing
> serious, just seemed a bit weird! :)
> And isn't one of the two (I always forget which one) rather a feature
of
> the hardware?

Well, aggregation handling is the next step if these patches are
acceptable... :)

You are right, A-MPDU is really in the bottom of the data plane
architecture, so in most cases _creating_ it will be an HW feature,
while A-MSDU should be implemented in a much higher level place in the
flow.
Two reasons why I placed A-MPDU handling in the mac80211:
- A-MPDU demands a "session" level management (add BACK, del BACK, BAR),
which looks to me more mac80211 oriented
- A-MPDU extends the "Access Category" of 11e into "Traffic Identifier"
(TID) to give finer granularity of frames priority. As mac80211 already
handles prioritization in wme.c, it looked like a good starting point.

>> +#ifdef CONFIG_MAC80211_HT
>> +/* mgmt header + 1 byte action code */
>> +#define IEEE80211_MIN_ACTION_SIZE (24 + 1)
>> +
>> +#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
>> +#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
>> +#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
>> +#endif /* CONFIG_MAC80211_HT */

> Leave out the ifdefs please when they only protect definitions or
such,
> i.e. nothing that will generate code/allocate structure space.

Will be removed

>> +	capab |= (u16)(buf_size << 6);	/* bit 15:6 max size of
aggergation */

> typo: aggregation. Interesting what an email program with a spell
> checker makes you notice :) (No, I'm not suggesting you run a spell
> checker, I'm rather saying that I probably wouldn't have noticed
> otherwise)

Thanks :), will fix. Makes me wonder if i better use firefox as my
editor :)

>> +static void ieee80211_sta_process_addba_request(struct net_device
*dev,


>> +	/* TODO - add here aggregation support */

> I think that comment is misleading. We don't add aggregation support
> here but rather when adding it we must change this code, but anyway.
> Don't bother.

I can remove that, just a reference for development convenience. 

>> +			printk(KERN_DEBUG "%s: received unsupported
BACK\n",
>> +					dev->name);

> net_ratelimit() please, otherwise people can flood our logs by just
> sending us strange frames.

Perfectly right, will add net_ratelimit.

> Btw. I'd like to remove code from ieee80211_sta.c rather than add this
> much. Do you see any way to partition your code differently? The
> ieee80211_sta.c file is a huge file and barely understandable when you
> just read it... I was at one time working on extracting the scan code
> out from it and keep only MLME stuff in there. My goal was to be able
to

As mentioned above - one can treat A-MPDU session as a kind of MLME, so
this is a rather interesting point. Currently I'll keep the code there,
and if you see it burdens ieee80211_sta.c just tell me.

> not compile ieee80211_sta.c unless the user wanted the in-kernel MLME,
> but maybe I should rather put the MLME into a new file then. I'd
> appreciate if you could give it (partitioning the code otherwise) a
> thought, but I promise I won't be disappointed if you don't want to do
> it.

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
