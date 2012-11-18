Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4313 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2KRQf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 11:35:58 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v7 1/2] wireless: Driver for 60GHz card wil6210
Date: Sun, 18 Nov 2012 18:35:53 +0200
Message-ID: <28796403.U0TmaR8kpO@lx-vladimir> (sfid-20121118_173602_529191_1C75D875)
In-Reply-To: <1353073251.9490.17.camel@jlt4.sipsolutions.net>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <16914852.FhZEtcXc7Y@lx-vladimir> <1353073251.9490.17.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, November 16, 2012 02:40:51 PM Johannes Berg wrote:
> On Wed, 2012-11-14 at 13:09 +0200, Vladimir Kondratiev wrote:
> > 60g is in the very beginning, hardware is almost non existent. This
> > driver is for on of the first cards to be released; card itself is far
> > from being ready.
> 
> Well, yeah, I know :)
> 
> Eventually though, hardware will show up, and then somebody might try to
> run it with a 3.8 kernel (if this driver gets there) and while it will
> be discovered things will be much different than the actual APIs that
> come later, since AP mode is really PCP etc. I think that could be
> problematic.

I understand this point. Sure, we will need to add native PBSS support.

All this is bootstrap time problem. What I really have is test mode.
I try to mimic "true" modes when I can do close enough.

Perhaps, in the beginning we need to agree whether such "test mode" driver
may be integrated, or I need to drop this effort till 60g business will
reach mature state.

Current state is that I have thin path working. I can assemble setup with
2 entities, one acting as PCP and 2-nd as client. PCP and STA are not 100%
spec compliant. But, saying all that, this will work and provide test bed
for experiments and future development.

I want to start with this simple driver supporting very basic
1:1 connectivity. I want to say this is like AP <-> STA.
Yes, it is true, deep inside current implementation uses FromDS/ToDS 0/0
as it is for PBSS. But, for the rest of system, I can say almost without
cheating, this is infrastructure BSS capable of 1 client.

Regarding start_ap() below, I need to patch wpa_supplicant/hostapd
to support 60g flows. It is not ready yet. I can drop AP mode
from driver till I am ready with tools, but this will make STA mode useless
as well since there is no other AP out there.

Same about set_key() - if I return error for group key, wpa_supplicant
in its current state will not authenticate.

Another option I see - drop everything but monitor mode. This will be "proper"
driver with no compromises.

What would you say?

Thanks, Vladimir

> 
> > > > + /* group key is not used */
> > > > + if (!pairwise)
> > > > + return 0;
> > > 
> > > Return an error then?
> > 
> > I don't know. Group keys are just ignored in 60g band since all data
> > transmissions are directed, there is simply no multicast at the MAC
> > level. So is it error if supplicant passes group key? Now it is what
> > supplicant does, and by ignoring group keys I allow it to proceed with
> > secure connection establishment.
> 
> Doesn't the supplicant have to do something differently anyway to
> establish keys with all stations etc? So it could know about this and
> not program any GTKs.

> 
> > > > +static int wil_cfg80211_set_default_key(struct wiphy *wiphy,
> > > > + struct net_device *ndev,
> > > > + u8 key_index, bool unicast,
> > > > + bool multicast)
> > 
> > This is to suppress warning in wiphy_new():
> > 
> > WARN_ON(ops->add_key && (!ops->del_key || !ops->set_default_key));
> 
> Oh. Maybe that warning doesn't make sense any more then?


> > > I don't think so? The interface shouldn't come up with any
> > > configuration, that's what start_ap() is used for.
> > 
> > Yes, it should be when things will work as it need to.
> > 
> > But, for now, I have only limited subset of controls implemented in
> > driver/firmware API, and supplicant/hostapd need to be updated as well
> > to know about 60g. Now, hostapd won't call my start_ap. To be able to
> > start AP now, I use something like:
> > 
> > 
> > 
> > ifconfig $WLAN down
> > iw $WLAN set type __ap
> > echo -n $SSID > /sys/class/net/$WLAN/device/attrs/ssid
> > echo -n $SECURE > /sys/class/net/$WLAN/device/attrs/secure_pcp
> > iw $WLAN set freq $FREQ
> > sudo ifconfig $WLAN up $IP
> 
> This might be fine for experimentation, but I don't think it should go
> upstream this way, see my comment above about hardware showing up etc.
> 
> johannes
