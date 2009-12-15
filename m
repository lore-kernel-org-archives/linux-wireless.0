Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57991 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761246AbZLOV65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 16:58:57 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 13:58:57 -0800
Date: Tue, 15 Dec 2009 13:58:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?utf-8?B?THVrw6HFoQ==?= Turek <8an@praha12.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute
 COVERAGE_CLASS
Message-ID: <20091215215855.GC2067@tux>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
 <1260899813-17585-2-git-send-email-8an@praha12.net>
 <20091215190051.GC2123@tux>
 <200912152156.48074.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <200912152156.48074.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 12:56:42PM -0800, Lukáš Turek wrote:
> On 15.12.2009 20:00 you wrote:
> > Does setting the coverage class make sense for all modes of operation?
> > If not it'd be good to catch those early and avoid setting them and also
> > properly document them.
>
> The coverage class is a physical device parameter, not interface parameter, so 
> it's independent on whether the interface is AP or STA, there could even be 
> multiple interfaces on one physical device.

I don't see how this makes sense. Are you saying if we have multiple interfaces
you must restrict the slot_time, ack_timeout and CTS timeout all to the same
values for all of them?

A hardware configuration can be just that -- hardware configuration but if
if such hardware knob can change depending on the BSS I don't see why this
wouldn't be a BSS parameter, specially if the AP/IBSS can send this out through
an information element.

> It's the same as RTS threshold, 
> for example.

I'd argue the same for it. We haven't yet really supported connecting to
multiple APs but this may change in the future. And say you wanted to support
an AP with one RTS threshold and connect to an AP at the same time with another
RTS threshold I think this should be possible.

> And it has to be a physical device parameter, because in the end 
> it just sets some hardware registers.

It can certainly be pegged onto the ath_hw or ath5k_hw but it doesn't
mean it can't be a per BSS setting.

> > The AP seems to pass the coverage class on country IE, so I guess
> > this means we can support this for AP mode and IBSS and only through the
> > country IE for STA. Mind you that would mean hostapd would need to kick
> > the coverage class as well and some new code on cfg80211 reg.c
> > country_ie_2_rd() to parse it.
>
> This part is not implemented yet, I wanted to do the low level setting first, 

I'd say expose it through debugfs first then instead of adding proper APIs
for userspace. If the country IE is the way to pass this information alog to
STAs there would be no need to tweak this on the user end. If you're an AP
though you are likely going to want to change this though so I see, for example
hostapd wanting to set this through nl80211. It also seems reasonable for IBSS
but IBSS won't send country IEs unless I guess we use wpa_supplicant and somehow
leverage the IE generation from hostapd.

> as the regulatory stuff is quite complex.

Hehe yeah, I skipped it :)

I haven't even read this part of the IEEE docs but I did read enough to know the
coverage_class is defined and set ont he country IE. This part at least is defined
on include/linux/ieee80211.h:

struct ieee80211_country_ie_triplet {
        union {
                struct {
                        u8 first_channel;
                        u8 num_channels;
                        s8 max_power;
                } __attribute__ ((packed)) chans;
                struct {
                        u8 reg_extension_id;
                        u8 reg_class;
                        u8 coverage_class;
                } __attribute__ ((packed)) ext;
        };
} __attribute__ ((packed));

Parsing the Country IE is also already done for you, all that would need to
be done is to allow parsing the triplets when class first_channel >
IEEE80211_COUNTRY_EXTENSION_ID, and then we can get the coverage class.

But -- like I said, I really didn't read this section, not sure how the reg_class
fits into this. Not sure if this helps:

http://wireless.kernel.org/en/developers/Documentation/ChannelList

> It's still usable for long distance 
> point-to-point links (that are now impossible with in-kernel drivers). 

Sure, I'm not saying I don't see value into adding this upstream, what
seems pointless is to start allowing mucking with settings when we haven't
been doing the same for other hw configurable parameters through a well
defined userspace API.

If we want to expose this through debugfs though that's different, go for it.

> Hostapd would then use the same API.

Well hostapd would use it for AP mode, sure and that makes sense. Can't say
it makes sense to let users configure through a well defined userspace API
if the AP instead can juse use the country IE and we can enable debugfs for
experimenting.

  Luis
