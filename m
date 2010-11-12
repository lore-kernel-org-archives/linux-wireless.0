Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43662 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab0KLGFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 01:05:22 -0500
Received: by qyk30 with SMTP id 30so1614335qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 22:05:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
References: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
Date: Fri, 12 Nov 2010 01:05:21 -0500
Message-ID: <AANLkTimKdqoWx2FtvJ9HG3Yj0ofROMDNo30=FJv1vVGG@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Fix regulatory bug with multiple cards with a
 delayed CRDA response
From: Mark Mentovai <mark@moxienet.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> When two cards are connected with the same regulatory domain
> if CRDA had a delayed response then cfg80211's own set regulatory
> domain would still be the world regulatory domain. There was a bug
> on cfg80211's ignore_request() when analyzing incoming driver
> regulatory hints as it was only checking against the currently
> set cfg80211 regulatory domain and not for any other new
> pending requests. This is easily fixed by also checking against
> the pending request.

Luis, thanks for taking a look at this bug.

Capsule summary: you’ve overloaded -EALREADY, which until now seemed
to mean “that’s the regdomain I’m already using,” to now also mean
“I’m going to be using that regdomain soon but I’m waiting on CRDA.”
The two cases need to be handled differently.

In my case, this patch makes things a little bit worse. I tested it
with compat_wireless 20101110. I’ve included what I see after boot
below the explanation.

Your patch changes things so that, according to the steps in my
original message, steps 3 and 4 become:

3. The second card’s driver calls regulatory_hint to provide US as a
driver hint. ignore_request sees that the last request came from a
driver and that the current and last request sought to set the same
hint, so it returns -EALREADY. This triggers the “if the regulatory
domain being requested by the driver” block, which calls reg_copy_regd
on the apparent assumption that cfg80211_regdomain contains the
regdomain that the wiphy actually wants, although it doesn’t, and it’s
very wrong to do this copy. cfg80211_regdomain is still on 00, because
CRDA hasn’t responded to the first card’s request yet.

4. When CRDA finally responds to the first card’s request from #2, it
gets plumbed to set_regdom, which calls __set_regdom. __set_regdom
sees that it’s not intersecting, and enters the block where it would
normally copy reg_copy_regd to set the wiphy’s regd, but the wiphy it
uses is the one saved from last_request (in step 3), and it already
had something copied to it (also in step 3). Since __set_regdom checks
for this and bails out with -EALREADY in the “userspace could have
sent two replies with only one kernel request” case. Because
__set_regdom fails, set_regdom returns early and never makes it to the
update_all_wiphy_regulatory or print_regdomain steps. The regdomain
remains unchanged. I’m still stuck at 00.

What about using something other than -EALREADY to signal “that
request is already pending?” On its face, this works, but I think
there’s a deeper flaw that also needs to be addressed. I’m concerned
that the wiphys that fall into this state won’t see a reg_copy_regd
call at all. The idea is that any such wiphy shouldn’t really be
ignored, but it should be joined to a group of wiphys waiting on the
pending request, and when the request is satisfied, the regd field
should be populated for each of them.

With your patch:

# iw reg get
country 00:
        (2402 - 2472 @ 40), (3, 20)
        (2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
        (2474 - 2494 @ 20), (3, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
        (5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
        (5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
# iw list (relevant bits)
Wiphy phy1
        Band 1:
                Frequencies:
                        * 5180 MHz [36] (17.0 dBm) (passive scanning, no IBSS)
                        * 5200 MHz [40] (17.0 dBm) (passive scanning, no IBSS)
                        * 5220 MHz [44] (17.0 dBm) (passive scanning, no IBSS)
                        * 5240 MHz [48] (17.0 dBm) (passive scanning, no IBSS)
                        * 5260 MHz [52] (disabled)
                        * 5280 MHz [56] (disabled)
                        * 5300 MHz [60] (disabled)
                        * 5320 MHz [64] (disabled)
                        * 5500 MHz [100] (disabled)
                        * 5520 MHz [104] (disabled)
                        * 5540 MHz [108] (disabled)
                        * 5560 MHz [112] (disabled)
                        * 5580 MHz [116] (disabled)
                        * 5600 MHz [120] (disabled)
                        * 5620 MHz [124] (disabled)
                        * 5640 MHz [128] (disabled)
                        * 5660 MHz [132] (disabled)
                        * 5680 MHz [136] (disabled)
                        * 5700 MHz [140] (disabled)
                        * 5745 MHz [149] (20.0 dBm) (passive scanning, no IBSS)
                        * 5765 MHz [153] (20.0 dBm) (passive scanning, no IBSS)
                        * 5785 MHz [157] (20.0 dBm) (passive scanning, no IBSS)
                        * 5805 MHz [161] (20.0 dBm) (passive scanning, no IBSS)
                        * 5825 MHz [165] (20.0 dBm) (passive scanning, no IBSS)
Wiphy phy0
        Band 1:
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (20.0 dBm) (passive scanning, no IBSS)
                        * 2472 MHz [13] (20.0 dBm) (passive scanning, no IBSS)
                        * 2484 MHz [14] (20.0 dBm) (passive scanning, no IBSS)
# dmesg (relevant bits)
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
PCI: Enabling device 0000:00:11.0 (0000 -> 0002)
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xb0000000, irq=48
PCI: Enabling device 0000:00:12.0 (0000 -> 0002)
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
cfg80211: Calling CRDA for country: US
ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
Registered led device: ath9k-phy1::radio
Registered led device: ath9k-phy1::assoc
Registered led device: ath9k-phy1::tx
Registered led device: ath9k-phy1::rx
ieee80211 phy1: Atheros AR9280 Rev:2 mem=0xb0010000, irq=49
(Nothing else from cfg80211, although I was hoping for “cfg80211:
Regulatory domain changed to country: US” and the new frequency
table.)

Incidentally, the workaround I’ve been using for the past few days
targeted the very same line your patch touches, although I used 0
instead of a special error flag. This resulted in an unnecessary extra
call out to CRDA, but more importantly, it had the “doesn’t set the
wiphy’s regd” problem, which is why I didn’t mention it.
