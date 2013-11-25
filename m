Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3KYQen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:34:43 -0500
Message-ID: <1385397279.4443.50.camel@jlt4.sipsolutions.net> (sfid-20131125_173447_888238_DA5099AF)
Subject: Re: [PATCH 1/2] cfg80211: Add support for QoS mapping
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 17:34:39 +0100
In-Reply-To: <20131125162311.GA31482@jouni.qca.qualcomm.com>
References: <20131120102828.GA26154@jouni.qca.qualcomm.com>
	 <1385395707.4443.37.camel@jlt4.sipsolutions.net>
	 <20131125162311.GA31482@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-25 at 18:23 +0200, Jouni Malinen wrote:
> On Mon, Nov 25, 2013 at 05:08:27PM +0100, Johannes Berg wrote:
> > On Wed, 2013-11-20 at 12:28 +0200, Jouni Malinen wrote:
> > 
> > > +struct cfg80211_qos_map {
> > > +	bool valid;
> > 
> > why do we need a validity flag? isn't NULL pointer enough?
> 
> For cfg80211, NULL would be fine. I guess the mac80211 use case could be
> handled outside this structure.

mac80211 could also just kmemdup() it and only keep a pointer (RCU
protected?), that'd indeed be more efficient if nobody is using it,
which is probably still the majority of APs?

> > > +	int     (*set_qos_map)(struct wiphy *wiphy,
> > > +			       struct net_device *dev,
> > > +			       struct cfg80211_qos_map *qos_map);
> > 
> > I wonder if this is necessary? The driver could just have a flag for
> > "support QoS mapping" and having such support requires using
> > classify8021d(). OTOH, that function needs to gain a parameter anyway,
> > so it's not really worth it. Also, it's something that could be changed
> > purely internal to the kernel, so I guess I'm not worried about it much.
> 
> Hmm.. How else would the caller (that driver or mac80211 receiving this
> call..) of classify8021d() get these parameters?

We'd have to pass the wdev instead of the qos_map, and then we could
store it all in the wdev and handle it all in cfg80211. But then again
many other drivers might actually need it for firmware or whatever, so I
guess it makes sense. We can also see, this isn't really related to the
userland API.

> > > + * @NL80211_CMD_SET_QOS_MAP: Set Interworking QoS mapping for IP DSCP values.
> > > + *	The QoS mapping information is included in %NL80211_ATTR_QOS_MAP. If
> > > + *	that attribute is not included, QoS mapping is disabled.
> > 
> > Might be useful to say that this is only valid while associated?
> 
> When else can you send an IP packet? I don't have anything against
> adding that here, but it sounds pretty obvious to me.

Yes, obviously, but also not. If we say this, then we should also say
that it's cleared on disassoc/stop_ap and things like that, I guess? I
generally dislike state that can survive between associations (unless
the device is roaming itself, but in this case presumably it'd have to
handle it all by itself then) or across stop_ap/start_ap.

> > In fact, why is this even a new operation? Can this change during the
> > lifetime of the BSS? If not, then it might be worth just putting the
> > attribute into START_AP and ASSOCIATE/CONNECT etc?
> 
> Yes, this can change during an association (configurable operation on
> AP; a new Action frame from AP to STA for notifying about the change).

Ok.

johannes

