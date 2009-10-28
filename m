Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:53551 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbZJ1SsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 14:48:07 -0400
Received: by iwn10 with SMTP id 10so808749iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2009 11:48:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091028183726.GA4952@tux>
References: <20091028183726.GA4952@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 28 Oct 2009 11:47:51 -0700
Message-ID: <43e72e890910281147vf4282e0o7f74c5a841ecfb8e@mail.gmail.com>
Subject: Re: odd state reached when AP deauths you after assoc
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2009 at 11:37 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> I ran into this when ath5k with wpa_supplicant with config file with
> a wrong password against a Cisco AP. It seems the Cisco AP auths you
> and lets you assoc but later it deauths you -- I guess after it
> determines you are auth credentials failed. When this happens I get:
>
> mcgrof@tux ~ $ iw dev wlan0 link
> Authenticated with 00:0b:85:5b:8d:6c (on wlan0)
> Not connected.

So here is the log when using a wrong password against a cisco AP:

[ 1858.773080] phy0: device now idle
[ 1858.776409] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1858.905642] phy0: device no longer idle - scanning
[ 1860.057062] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy0
[ 1860.233974] cfg80211: Found new beacon on frequency: 5200 MHz (Ch 40) on phy0
[ 1860.289658] cfg80211: Found new beacon on frequency: 5220 MHz (Ch 44) on phy0
[ 1860.401686] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy0
[ 1862.426385] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
149) on phy0
[ 1862.667996] cfg80211: Found new beacon on frequency: 5785 MHz (Ch
157) on phy0
[ 1862.772666] cfg80211: Found new beacon on frequency: 5805 MHz (Ch
161) on phy0
[ 1863.016600] wlan0: direct probe to AP 00:0b:85:5b:a6:ec (try 1)
[ 1863.025332] wlan0: direct probe responded
[ 1863.025340] wlan0: authenticate with AP 00:0b:85:5b:a6:ec (try 1)
[ 1863.029490] wlan0: authenticated
[ 1863.029675] wlan0: associate with AP 00:0b:85:5b:a6:ec (try 1)
[ 1863.044240] wlan0: RX AssocResp from 00:0b:85:5b:a6:ec (capab=0x431
status=0 aid=59)
[ 1863.044248] wlan0: associated
[ 1863.044258] phy0: Allocated STA 00:0b:85:5b:a6:ec
[ 1863.045048] phy0: Inserted STA 00:0b:85:5b:a6:ec
[ 1863.045566] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 1863.046086] cfg80211: Calling CRDA for country: US
[ 1863.053060] wlan0: dropped frame to 00:0b:85:5b:a6:ec (unauthorized port)
[ 1863.053242] cfg80211: Received country IE:
[ 1863.053247] cfg80211: Regulatory domain: US
[ 1863.053252]  (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1863.053260]  (2402000 KHz - 2477000 KHz @ 40000 KHz), (10000 mBi, 10000 mBm)
[ 1863.053265] cfg80211: CRDA thinks this should applied:
[ 1863.053269] cfg80211: Regulatory domain: US
[ 1863.053273]  (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1863.053281]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[ 1863.053288]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[ 1863.053294]  (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1863.053301]  (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1863.053307]  (5651000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1863.053314]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[ 1863.053319] cfg80211: We intersect both of these and get:
[ 1863.053323] cfg80211: Regulatory domain: 98
[ 1863.053327]  (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1863.053334]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[ 1863.053344] cfg80211: Disabling channel 2467 MHz on phy0 due to Country IE
[ 1863.053349] cfg80211: Disabling channel 2472 MHz on phy0 due to Country IE
[ 1863.053355] cfg80211: Disabling channel 2484 MHz on phy0 due to Country IE
[ 1863.053361] cfg80211: Leaving channel 5180 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053367] cfg80211: Leaving channel 5200 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053373] cfg80211: Leaving channel 5220 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053379] cfg80211: Leaving channel 5240 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053386] cfg80211: Leaving channel 5260 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053392] cfg80211: Leaving channel 5280 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053398] cfg80211: Leaving channel 5300 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053404] cfg80211: Leaving channel 5320 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053411] cfg80211: Leaving channel 5500 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053417] cfg80211: Leaving channel 5520 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053423] cfg80211: Leaving channel 5540 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053429] cfg80211: Leaving channel 5560 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053435] cfg80211: Leaving channel 5580 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053441] cfg80211: Leaving channel 5600 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053447] cfg80211: Leaving channel 5620 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053454] cfg80211: Leaving channel 5640 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053460] cfg80211: Leaving channel 5660 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053466] cfg80211: Leaving channel 5680 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053472] cfg80211: Leaving channel 5700 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053478] cfg80211: Leaving channel 5745 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053485] cfg80211: Leaving channel 5765 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053491] cfg80211: Leaving channel 5785 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053497] cfg80211: Leaving channel 5805 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053503] cfg80211: Leaving channel 5825 MHz intact on phy0 - no
rule found in band on Country IE
[ 1863.053519] cfg80211: Current regulatory domain updated by AP to: US
[ 1863.053524]  (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1863.053531]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[ 1863.296154] wlan0: dropped frame to 00:0b:85:5b:a6:ec (unauthorized port)
[ 1864.296183] wlan0: dropped frame to 00:0b:85:5b:a6:ec (unauthorized port)
[ 1866.881205] wlan0: deauthenticated from 00:0b:85:5b:a6:ec (Reason: 1)
[ 1866.881228] phy0: device now idle
[ 1866.881265] phy0: Removed STA 00:0b:85:5b:a6:ec
[ 1866.913511] phy0: Destroyed STA 00:0b:85:5b:a6:ec
[ 1867.013816] phy0: device no longer idle - scanning
[ 1870.268556] phy0: device now idle
[ 1870.272935] phy0: device no longer idle - in use
[ 1870.272957] wlan0: direct probe to AP 00:0b:85:5b:8d:6c (try 1)
[ 1870.468116] wlan0: direct probe to AP 00:0b:85:5b:8d:6c (try 2)
[ 1870.668115] wlan0: direct probe to AP 00:0b:85:5b:8d:6c (try 3)
[ 1870.672686] wlan0: direct probe responded
[ 1870.672693] wlan0: authenticate with AP 00:0b:85:5b:8d:6c (try 1)
[ 1870.674428] wlan0: authenticated
[ 1870.674602] wlan0: associate with AP 00:0b:85:5b:8d:6c (try 1)
[ 1870.677800] wlan0: RX AssocResp from 00:0b:85:5b:8d:6c (capab=0x421
status=17 aid=0)
[ 1870.677807] wlan0: AP denied association (code=17)
[ 1870.679901] wlan0: RX AssocResp from 00:0b:85:5b:8d:6c (capab=0x421
status=17 aid=0)
[ 1870.679908] wlan0: AP denied association (code=17)
[ 1873.297089] wlan0: no IPv6 routers present

This puts the device into a funky state.

This can also be reached even if the AP does not deauth you but instead just
denies association:

This puts the device into a funky state.

This can also be reached even if the AP does not deauth you but instead just
denies association:

[ 1958.579149] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
149) on phy0
[ 1958.820612] cfg80211: Found new beacon on frequency: 5785 MHz (Ch
157) on phy0
[ 1958.953174] cfg80211: Found new beacon on frequency: 5805 MHz (Ch
161) on phy0
[ 1959.167831] wlan0: direct probe to AP 00:0b:85:5b:8d:6c (try 1)
[ 1959.180785] wlan0: direct probe responded
[ 1959.180793] wlan0: authenticate with AP 00:0b:85:5b:8d:6c (try 1)
[ 1959.189268] wlan0: authenticated
[ 1959.189414] wlan0: associate with AP 00:0b:85:5b:8d:6c (try 1)
[ 1959.201056] wlan0: RX AssocResp from 00:0b:85:5b:8d:6c (capab=0x401
status=17 aid=0)
[ 1959.201063] wlan0: AP denied association (code=17)

  Luis
