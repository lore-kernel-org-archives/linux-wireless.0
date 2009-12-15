Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:52559 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbZLOWsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 17:48:55 -0500
Message-ID: <4B28124C.10206@openwrt.org>
Date: Tue, 15 Dec 2009 23:48:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: =?UTF-8?B?THVrw6HFoSBUdXJlaw==?= <8an@praha12.net>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute COVERAGE_CLASS
References: <1260899813-17585-1-git-send-email-8an@praha12.net>	<1260899813-17585-2-git-send-email-8an@praha12.net>	<20091215190051.GC2123@tux> <200912152156.48074.8an@praha12.net> <20091215215855.GC2067@tux>
In-Reply-To: <20091215215855.GC2067@tux>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2009-12-15 10:58 PM, Luis R. Rodriguez wrote:
> On Tue, Dec 15, 2009 at 12:56:42PM -0800, Lukáš Turek wrote:
>> On 15.12.2009 20:00 you wrote:
>> > Does setting the coverage class make sense for all modes of operation?
>> > If not it'd be good to catch those early and avoid setting them and also
>> > properly document them.
>>
>> The coverage class is a physical device parameter, not interface parameter, so 
>> it's independent on whether the interface is AP or STA, there could even be 
>> multiple interfaces on one physical device.
> 
> I don't see how this makes sense. Are you saying if we have multiple interfaces
> you must restrict the slot_time, ack_timeout and CTS timeout all to the same
> values for all of them?
We could advertise this as a per-BSS parameter and let mac80211 send the
maximum of the coverage class values of all BSS interfaces to the
driver. That would allow stations connected to AP interfaces with
(bss_coverage_class < driver_coverage_class) to use more aggressive
timings than the AP is using. I'm not sure there's much to be gained
from this, though - especially with 11n.

>> It's the same as RTS threshold, 
>> for example.
> I'd argue the same for it. We haven't yet really supported connecting to
> multiple APs but this may change in the future. And say you wanted to support
> an AP with one RTS threshold and connect to an AP at the same time with another
> RTS threshold I think this should be possible.
It's not the same as the RTS threshold, as the RTS threshold is
evaluated per-packet.

>> This part is not implemented yet, I wanted to do the low level setting first, 
> I'd say expose it through debugfs first then instead of adding proper APIs
> for userspace. If the country IE is the way to pass this information alog to
> STAs there would be no need to tweak this on the user end. If you're an AP
> though you are likely going to want to change this though so I see, for example
> hostapd wanting to set this through nl80211. It also seems reasonable for IBSS
> but IBSS won't send country IEs unless I guess we use wpa_supplicant and somehow
> leverage the IE generation from hostapd.
I'm not sure merging the debugfs variant first is particularly useful.
Let's just define the API for setting the coverage class values and
merge an implementation that allows the user to override the effective
coverage class values for every interface mode. We can then sort out the
remaining implementation issues later.
I don't think merging a debugfs based setting would be a good idea. I'd
prefer starting to implement this setting for more drivers including
non-ath ones sooner rather than later.

- Felix
