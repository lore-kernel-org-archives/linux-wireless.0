Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15102 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3KYQXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:23:18 -0500
Date: Mon, 25 Nov 2013 18:23:11 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] cfg80211: Add support for QoS mapping
Message-ID: <20131125162311.GA31482@jouni.qca.qualcomm.com> (sfid-20131125_172321_835505_3B36128F)
References: <20131120102828.GA26154@jouni.qca.qualcomm.com>
 <1385395707.4443.37.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1385395707.4443.37.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 25, 2013 at 05:08:27PM +0100, Johannes Berg wrote:
> On Wed, 2013-11-20 at 12:28 +0200, Jouni Malinen wrote:
> 
> > +struct cfg80211_qos_map {
> > +	bool valid;
> 
> why do we need a validity flag? isn't NULL pointer enough?

For cfg80211, NULL would be fine. I guess the mac80211 use case could be
handled outside this structure.

> > + * @set_qos_map: Set QoS mapping information to the driver
> >   */
> >  struct cfg80211_ops {
> >  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
> > @@ -2428,6 +2476,9 @@ struct cfg80211_ops {
> >  	int	(*channel_switch)(struct wiphy *wiphy,
> >  				  struct net_device *dev,
> >  				  struct cfg80211_csa_settings *params);
> > +	int     (*set_qos_map)(struct wiphy *wiphy,
> > +			       struct net_device *dev,
> > +			       struct cfg80211_qos_map *qos_map);
> 
> I wonder if this is necessary? The driver could just have a flag for
> "support QoS mapping" and having such support requires using
> classify8021d(). OTOH, that function needs to gain a parameter anyway,
> so it's not really worth it. Also, it's something that could be changed
> purely internal to the kernel, so I guess I'm not worried about it much.

Hmm.. How else would the caller (that driver or mac80211 receiving this
call..) of classify8021d() get these parameters?

> > + * @NL80211_CMD_SET_QOS_MAP: Set Interworking QoS mapping for IP DSCP values.
> > + *	The QoS mapping information is included in %NL80211_ATTR_QOS_MAP. If
> > + *	that attribute is not included, QoS mapping is disabled.
> 
> Might be useful to say that this is only valid while associated?

When else can you send an IP packet? I don't have anything against
adding that here, but it sounds pretty obvious to me.

> In fact, why is this even a new operation? Can this change during the
> lifetime of the BSS? If not, then it might be worth just putting the
> attribute into START_AP and ASSOCIATE/CONNECT etc?

Yes, this can change during an association (configurable operation on
AP; a new Action frame from AP to STA for notifying about the change).

> > +		if (len & 1 || len < IEEE80211_QOS_MAP_LEN_MIN ||
> 
> I think len%2 would be easier to read? Not that it makes a big
> difference, but fundamentally this isn't a bitop thing, it's a "length
> must be even" thing.

Sure, that's fine.

> > @@ -9564,6 +9606,14 @@ static struct genl_ops nl80211_ops[] = {
> >  		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
> >  				  NL80211_FLAG_NEED_RTNL,
> >  	},
> > +	{
> > +		.cmd = NL80211_CMD_SET_QOS_MAP,
> 
> You forgot to advertise availability of the operation, but then again
> see above - is it even needed?

I think it is needed and yes, it could be useful to advertise
availability.

-- 
Jouni Malinen                                            PGP id EFC895FA
