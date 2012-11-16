Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2KPNkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 08:40:19 -0500
Message-ID: <1353073251.9490.17.camel@jlt4.sipsolutions.net> (sfid-20121116_144022_814380_3C585BA3)
Subject: Re: [PATCH v7 1/2] wireless: Driver for 60GHz card wil6210
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 16 Nov 2012 14:40:51 +0100
In-Reply-To: <16914852.FhZEtcXc7Y@lx-vladimir>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352809427-29682-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352836449.9466.24.camel@jlt4.sipsolutions.net>
	 <16914852.FhZEtcXc7Y@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-14 at 13:09 +0200, Vladimir Kondratiev wrote:

> 60g is in the very beginning, hardware is almost non existent. This
> driver is for on of the first cards to be released; card itself is far
> from being ready.

Well, yeah, I know :)

Eventually though, hardware will show up, and then somebody might try to
run it with a 3.8 kernel (if this driver gets there) and while it will
be discovered things will be much different than the actual APIs that
come later, since AP mode is really PCP etc. I think that could be
problematic.

> > > + /* group key is not used */
> > > + if (!pairwise)
> > > + return 0;

> > Return an error then?

> I don't know. Group keys are just ignored in 60g band since all data
> transmissions are directed, there is simply no multicast at the MAC
> level. So is it error if supplicant passes group key? Now it is what
> supplicant does, and by ignoring group keys I allow it to proceed with
> secure connection establishment.

Doesn't the supplicant have to do something differently anyway to
establish keys with all stations etc? So it could know about this and
not program any GTKs.

> > > +static int wil_cfg80211_set_default_key(struct wiphy *wiphy,
> > > + struct net_device *ndev,
> > > + u8 key_index, bool unicast,
> > > + bool multicast)

> This is to suppress warning in wiphy_new():
> 
> WARN_ON(ops->add_key && (!ops->del_key || !ops->set_default_key));

Oh. Maybe that warning doesn't make sense any more then?

> > This seems a bit strange, why export the blobs that came from the
> > filesystem to start with (request_firmware)?

> This is to access firmware internal variables. Those who know firmware
> layout benefit from this.

Ah, ok, makes sense.

> > I don't think so? The interface shouldn't come up with any
> > configuration, that's what start_ap() is used for.

> Yes, it should be when things will work as it need to.
> 
> But, for now, I have only limited subset of controls implemented in
> driver/firmware API, and supplicant/hostapd need to be updated as well
> to know about 60g. Now, hostapd won't call my start_ap. To be able to
> start AP now, I use something like:
> 
>  
> 
> ifconfig $WLAN down
> iw $WLAN set type __ap
> echo -n $SSID > /sys/class/net/$WLAN/device/attrs/ssid
> echo -n $SECURE > /sys/class/net/$WLAN/device/attrs/secure_pcp
> iw $WLAN set freq $FREQ
> sudo ifconfig $WLAN up $IP

This might be fine for experimentation, but I don't think it should go
upstream this way, see my comment above about hardware showing up etc.

johannes

