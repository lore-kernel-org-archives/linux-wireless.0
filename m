Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50164 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0KLABL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 19:01:11 -0500
Received: by iwn10 with SMTP id 10so2770401iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 16:01:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikf13HMEtVkpTftKrZenvPwPcHbuhgqmh2m-UYU@mail.gmail.com>
References: <185731CC-606D-407D-80F4-33FEF08ED35D@moxienet.com>
 <AANLkTik35wHXiznjGm7nc9HBYUy7iQk65FVSq7T2Gw8u@mail.gmail.com> <AANLkTikf13HMEtVkpTftKrZenvPwPcHbuhgqmh2m-UYU@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Nov 2010 16:00:48 -0800
Message-ID: <AANLkTin_5Nhwby79eYY972ZFh-0Tr4MaauSn4LAtsn-7@mail.gmail.com>
Subject: Re: Regulatory/CRDA Race
To: Mark Mentovai <mark@moxienet.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 3:36 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Nov 9, 2010 at 1:19 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Mon, Nov 8, 2010 at 11:40 AM, Mark Mentovai <mark@moxienet.com> wrote:
>>> Following up on the old-ish “[ath5k-devel] Race condition in CRDA calls?” thread…
>>>
>>> I independently experienced this problem, debugged it, and came to the same conclusion. There is in fact a race between regulatory requests being made via regulatory_hint and CRDA actually updating regulatory data. I see this on a system with two cards that come up one after the other during boot.
>>>
>>> 1. cfg80211 calls CRDA to update the world regulatory domain and CRDA does so. The regulatory domain is now 00.
>>>
>>> 2. The first card’s driver (in my case, ath9k) calls regulatory_hint to provide US as a driver hint. ignore_request decides against intersection because the last request came from the core. There’s a CRDA call, but CRDA isn’t quick enough to respond. The regulatory domain is still 00, because CRDA hasn’t changed it yet.
>>>
>>> 3. The second card’s driver (also ath9k) calls regulatory_hint to provide US as a driver hint. ignore_request sees that the last request came from a driver (instead of the core) and since the regulatory domain is changing from 00 to US, decides that intersection must be performed.
>>>
>>> 4. When CRDA finally responds to the request from #2 or #3, cfg80211 sees that last_request->intersect is true, and intersects. The regulatory domain is set to the intersection of 00 and US.
>>>
>>> The race here is between CRDA providing data and the second card’s request being made via regulatory_hint. regulatory_hint and ignore_request assume that last_request is in sync with the currently-set regulatory domain, but there is no such synchronization.
>>>
>>> Here’s my openwrt-devel post describing the above in a slightly different level of detail:https://lists.openwrt.org/pipermail/openwrt-devel/2010-November/008570.html.--
>>
>> I'll take a look at this once I get done with the
>> compat-wireless-2.6.37 release. Thanks for the report.
>
> I'm looking at this now, can you do me a favor and test against
> today's wireless-testing to verify the issue is still present? I'll be
> digging at this in the mean time.

I can reproduce this easily now with:

mcgrof@flash ~ $ sudo cat /sbin/crda
#!/bin/bash
echo $COUNTRY >> /tmp/log
sleep 2
/sbin/crda.orig


mcgrof@flash ~ $ iw reg get
country 98:
        (2402 - 2472 @ 40), (N/A, 20)
        (2457 - 2482 @ 20), (N/A, 20), PASSIVE-SCAN, NO-IBSS
        (2474 - 2482 @ 8), (N/A, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
        (5170 - 5250 @ 40), (N/A, 20), PASSIVE-SCAN, NO-IBSS

You don't even have to use ath9k, just use mac80211_hwsim with:

modprobe mac80211_hwsim regtest=2

I get (I'm trimming irrelevant output)

Wiphy phy1
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
                        * 2467 MHz [12] (20.0 dBm)
                        * 2472 MHz [13] (20.0 dBm)
                        * 2484 MHz [14] (disabled)
        Band 2:
                Frequencies:
                        * 5180 MHz [36] (20.0 dBm)
                        * 5200 MHz [40] (20.0 dBm)
                        * 5220 MHz [44] (20.0 dBm)
                        * 5240 MHz [48] (20.0 dBm)
                        * 5260 MHz [52] (20.0 dBm) (radar detection)
                        * 5280 MHz [56] (20.0 dBm) (radar detection)
                        * 5300 MHz [60] (20.0 dBm) (radar detection)
                        * 5320 MHz [64] (20.0 dBm) (radar detection)
                        * 5500 MHz [100] (20.0 dBm) (radar detection)
                        * 5520 MHz [104] (20.0 dBm) (radar detection)
                        * 5540 MHz [108] (20.0 dBm) (radar detection)
                        * 5560 MHz [112] (20.0 dBm) (radar detection)
                        * 5580 MHz [116] (20.0 dBm) (radar detection)
                        * 5600 MHz [120] (20.0 dBm) (radar detection)
                        * 5620 MHz [124] (20.0 dBm) (radar detection)
                        * 5640 MHz [128] (20.0 dBm) (radar detection)
                        * 5660 MHz [132] (20.0 dBm) (radar detection)
                        * 5680 MHz [136] (20.0 dBm) (radar detection)
                        * 5700 MHz [140] (20.0 dBm) (radar detection)
                        * 5745 MHz [149] (disabled)
                        * 5765 MHz [153] (disabled)
                        * 5785 MHz [157] (disabled)
                        * 5805 MHz [161] (disabled)
                        * 5825 MHz [165] (disabled)
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
                        * 2484 MHz [14] (disabled)
        Band 2:
                Frequencies:
                        * 5180 MHz [36] (20.0 dBm) (passive scanning, no IBSS)
                        * 5200 MHz [40] (20.0 dBm) (passive scanning, no IBSS)
                        * 5220 MHz [44] (20.0 dBm) (passive scanning, no IBSS)
                        * 5240 MHz [48] (20.0 dBm) (passive scanning, no IBSS)
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
                        * 5745 MHz [149] (disabled)
                        * 5765 MHz [153] (disabled)
                        * 5785 MHz [157] (disabled)
                        * 5805 MHz [161] (disabled)
                        * 5825 MHz [165] (disabled)

  Luis
