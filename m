Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41396 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab0G1WFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 18:05:48 -0400
Message-ID: <4C50A9B9.5070708@openwrt.org>
Date: Thu, 29 Jul 2010 00:05:45 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Bruno Randolf <br1@einfach.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
References: <20100727094732.27186.30900.stgit@tt-desk> <4C4F0BB1.6030002@openwrt.org> <AANLkTi=QWMwVTqOqL3wNUnLAWHDw60HmYXtngXJrQOu+@mail.gmail.com> <201007281106.06813.br1@einfach.org> <AANLkTimBu2=9XhzKwUi1ZpRmGWA+C4GCDgXqp-YJVLxt@mail.gmail.com> <4C506DF7.9020907@openwrt.org> <AANLkTi=HyyA0oqVRRsh2_ad_0zLGCSBQ6CK=fCg=g=ad@mail.gmail.com> <4C50A08B.2080002@openwrt.org> <20100728213939.GB8033@tux>
In-Reply-To: <20100728213939.GB8033@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-28 11:39 PM, Luis R. Rodriguez wrote:
> On Wed, Jul 28, 2010 at 02:26:35PM -0700, Felix Fietkau wrote:
>> We don't need any special case handling for this at all. Drivers already
>> calculate their HT capabilities based on the number of available chains.
>> Once the antenna selection stuff is actually used, they will have some
>> internal information about which chains have how many antennas.
>> 
>> The reason why we can ignore *all* of this stuff for the API is simple:
>> We only need to refactor the code to calculate these settings based on
>> effective chainmask / antenna mask instead of pure hardware capability.
>> 
>> The effective chainmask / antenna mask is basically the same as the
>> hardware settings, except that it gets masked with the values that are
>> configured through this API. That leaves us with something that's easy
>> to configure, easy to implement for drivers, and doesn't need special
>> case stuff for various 802.11n features.
> 
> Consider the case of an already associated STA in 3x3 mode, and someone
> uses this API to limit it to a 1 stream 1x1 chaimask setting using
> only one antenna. How would the AP find out about this RX setting
> from the STA? Are we going to deny mucking with this prior to association?
> What about if you're the AP?
> 
> If you are using STBC and the user tunes the device to 1 stream 1x1 chainmask
> settings, who deals with the required adaptations?
I think we should simply not accept runtime modifications of this stuff.
The user should bring down the interface, change the value, then bring
it back up again. That allows the driver to recalculate all the HT stuff
based on the updated chainmask/antenna mask without special cases.

- Felix
