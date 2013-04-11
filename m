Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3DKOFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 10:05:42 -0400
Message-ID: <1365689136.8272.54.camel@jlt4.sipsolutions.net> (sfid-20130411_160545_628563_D06982BF)
Subject: Re: [PATCH v4 1/2] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Thu, 11 Apr 2013 16:05:36 +0200
In-Reply-To: <1919054.NIDM1uk7ud@lx-vladimir>
References: <1363863994-32510-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1365671487.8272.27.camel@jlt4.sipsolutions.net>
	 <1919054.NIDM1uk7ud@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-11 at 13:10 +0300, Vladimir Kondratiev wrote:

> > For the wiphy size limitation thing, you need to put this into
> > 
> > if (split) {
> > CMD(...)
> > CMD(...)
> > }

> OK, so do I need to handle this 'if (split)' or you will do so?

Please do. I'll handle the conflict later.

> > I think we (Intel) would also require to use the P2P_DEVICE for this
> > call, so maybe we should document in the nl80211 command that if
> > P2P_DEVICE is supported, this command is only supported on the
> > _P2P_DEVICE and not on _STATION? Anyway that'd be my assumption
> right
> > now that it gets used on whichever is used for P2P Device
> functionality,
> > so that shouldn't change anything in the supplicant just clarify the
> API
> > a bit.

> I see now similar functionality called in _STATION mode. Do we need
> supplicant
> changes for this? What is the concept with iftype, when device
> becoming
> _P2P_DEVICE - when discovery started or just before group formation?
> I can't draw conclusion looking on other driver's code. Is there some
> guide?

Well, I'll have to elaborate a bit.

So right now, P2P-Device functionality is implemented over the station
interface (typically "wlan0"). This means that the P2P Device address is
always the same as the wlan0 interface address, which is one reason for
wanting to change it. Another is that internal handling, at least in our
driver, becomes quite a bit simpler when the P2P_DEVICE
"interface" (doesn't have a netdev) is exposed in this way.

There are some patches from David Spinadel for wpa_supplicant on the way
to make it create and use a P2P_DEVICE virtual interface (wdev) for use
for all P2P functionality. This interface can also be assigned a
separate MAC address, which is then the P2P Device address.

At that point, drivers that support P2P_DEVICE functionality should use
only that wdev for P2P-Device related functionality (discovery, GO
negotiation, ...)

> > Btw, do you have supplicant patches already?

> I had initial discussion with Jouni about this design; but no patches
> yet.

Ok, I'd be interested in this -- particularly because we're also (more
even) interested in offloading the extended listen phase for timing and
power consumption reasons.

> > Is there value in supporting this call w/o any frequencies set? It
> seems
> > to me that the driver would be confused if it got no channels at
> all?
> 
> I assume no frequences is "all supported", as for scan. In this case,
> "all supported social channels"

Does that make much sense? For scan I think this makes more sense, but
as the social channels are pretty much fixed I'd say it doesn't? OTOH, I
guess they differ for 60 GHz...

Note that this also works differently -- for scan cfg80211 builds the
channel list while here you don't, so you need to be very careful in the
driver about this. For that reason I'd prefer cfg80211 to build the
list, or just reject an empty one.

Btw, since only social channels are used etc. should we really ignore
channels that aren't supported, rather than rejecting them?

> Like say that passing empty array is same as not passing array at all?
> I thought that if one passes array of frequencies, it says "use only
> this"
> like caller know what to do; and in this case I'd reject empty list.

Yeah, this makes some sense. The part I'm not sure about is not passing
anything, see above.

johannes

