Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60590 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0G1Vjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 17:39:41 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 14:39:41 -0700
Date: Wed, 28 Jul 2010 14:39:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Bruno Randolf <br1@einfach.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
Message-ID: <20100728213939.GB8033@tux>
References: <20100727094732.27186.30900.stgit@tt-desk>
 <4C4F0BB1.6030002@openwrt.org>
 <AANLkTi=QWMwVTqOqL3wNUnLAWHDw60HmYXtngXJrQOu+@mail.gmail.com>
 <201007281106.06813.br1@einfach.org>
 <AANLkTimBu2=9XhzKwUi1ZpRmGWA+C4GCDgXqp-YJVLxt@mail.gmail.com>
 <4C506DF7.9020907@openwrt.org>
 <AANLkTi=HyyA0oqVRRsh2_ad_0zLGCSBQ6CK=fCg=g=ad@mail.gmail.com>
 <4C50A08B.2080002@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C50A08B.2080002@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 02:26:35PM -0700, Felix Fietkau wrote:
> On 2010-07-28 11:15 PM, Luis R. Rodriguez wrote:
> > On Wed, Jul 28, 2010 at 10:50 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> >> For AR9285 we will already deviate from treating this as a chainmask,
> >> because it has one chain with rx diversity.
> > 
> > Good point but the single stream 802.11n case just needs to be
> > documented as well, it'll be like that for other single stream 802.11n
> > devices, if there are others, not sure if Atheros has the only ones in
> > the market or what.
> > 
> >> Please accept this API
> > 
> > If you really need some knobs without detailed review and discussion
> > shoot for debugfs, otherwise I will take my time reviewing carefully
> > all the details because once its API then.. well its set in stone and
> > we have to deal with it. I realize I'm being a real big fucking pain
> > in the ass with this but.. I believe these discussions have also been
> > helpful.
> > 
> >> I'm sure the API can be used to handle everything related to 802.11n
> >> antenna/chain selection properly. :)
> > 
> > Sure, but who deals with the 11n stuff? Right now this patches just
> > pass two variables, TX and RX antenna mask, and has no special case
> > handling for the different 802.11n cases, nor does it document who
> > should handle that.
> > 
> >   * STBC (11n 9.6.0.c, 9.7g, etc)
> >   * TX Beamforming (11n 19.19)
> >   * Antenna selection (11n 19.20)
> > 
> > IMHO we should be thinking about this if we want to define an API that
> > *all* 802.11 drivers can use if the API will be used for 802.11n as
> > well.
>
> We don't need any special case handling for this at all. Drivers already
> calculate their HT capabilities based on the number of available chains.
> Once the antenna selection stuff is actually used, they will have some
> internal information about which chains have how many antennas.
> 
> The reason why we can ignore *all* of this stuff for the API is simple:
> We only need to refactor the code to calculate these settings based on
> effective chainmask / antenna mask instead of pure hardware capability.
> 
> The effective chainmask / antenna mask is basically the same as the
> hardware settings, except that it gets masked with the values that are
> configured through this API. That leaves us with something that's easy
> to configure, easy to implement for drivers, and doesn't need special
> case stuff for various 802.11n features.

Consider the case of an already associated STA in 3x3 mode, and someone
uses this API to limit it to a 1 stream 1x1 chaimask setting using
only one antenna. How would the AP find out about this RX setting
from the STA? Are we going to deny mucking with this prior to association?
What about if you're the AP?

If you are using STBC and the user tunes the device to 1 stream 1x1 chainmask
settings, who deals with the required adaptations?

  Luis
