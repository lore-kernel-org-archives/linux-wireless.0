Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:47854 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaEXMer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 08:34:47 -0400
Received: by mail-qc0-f177.google.com with SMTP id i17so9622632qcy.22
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 05:34:46 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 24 May 2014 13:34:46 +0100
Message-ID: <CANy8jx+RY-_wbX5JqdF_xwyP+2XQ-V9Ae95Y5MOzd=fyir8KTw@mail.gmail.com> (sfid-20140524_143452_434308_04279CE3)
Subject: max_erip/tx_power not being set correctly
From: John Walker <john@x109.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wireless Development

I hope you can help.A bug seems to have been introduced in 3.10.34ish
(3.10.32 is ok) linux kernel where a statically compiled regulator
db.txt file does not set max_erip /tx_power correctly.

It was first noticed that the power output of a RaspberyPi hostapd AP
was only outputting -55dBm, while previously it was at -30dbm. This
was measured with a phone app, wifi analyzer at 1 m distance.

Any post 3.10.33 & late 3.12 kernels show the following when cfg80211
is loaded. One can see that the max_erip is not set:

cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 0 KHz), (2000 mBi, 0 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 0 KHz), (2000 mBi, 0 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (2000 mBi, 0 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (2000 mBi, 0 mBm)
cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (2000 mBi, 0 mBm)
cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (2000 mBi, 0 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (2000 mBi, 0 mBm)
cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm)
cfg80211: Calling CRDA for country: GB
cfg80211: Regulatory domain changed to country: GB
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (2000 mBi, 0 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (2000 mBi, 0 mBm)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (2000 mBi, 0 mBm)
cfg80211:   (5490000 KHz - 5710000 KHz @ 80000 KHz), (2700 mBi, 0 mBm)
cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (4000 mBi, 0 mBm)

iw list shows:
[snip]
    Frequencies:
            * 2412 MHz [1] (0.0 dBm)
            * 2417 MHz [2] (0.0 dBm)
            * 2422 MHz [3] (0.0 dBm)
            * 2427 MHz [4] (0.0 dBm)
            * 2432 MHz [5] (0.0 dBm)
            * 2437 MHz [6] (0.0 dBm)
            * 2442 MHz [7] (0.0 dBm)
            * 2447 MHz [8] (0.0 dBm)
            * 2452 MHz [9] (0.0 dBm)
            * 2457 MHz [10] (0.0 dBm)
            * 2462 MHz [11] (0.0 dBm)
            * 2467 MHz [12] (0.0 dBm)
            * 2472 MHz [13] (0.0 dBm)
            * 2484 MHz [14] (disabled)

iw reg get shows:
(3.12.20)
country GB: DFS-UNSET
    (2402 - 2482 @ 40), (20, 0)
    (5170 - 5250 @ 80), (20, 0)
    (5250 - 5330 @ 80), (20, 0)
    (5490 - 5710 @ 80), (27, 0)
    (57240 - 65880 @ 2160), (40, 0)

When I've returned to a 3.10.32 kernel, the tx output power is
restored to -30dBm, all the cfg80211 and iw list values are restored.
I've also tested an old db.txt file from the start of the year against
3.12.19, but it makes no difference.

iw list from 3.10.32
[snip]
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

iw reg get
country GB: DFS-UNSET
    (2402 - 2482 @ 40), (N/A, 20)
    (5170 - 5250 @ 80), (N/A, 20)
    (5250 - 5330 @ 80), (N/A, 20), DFS
    (5490 - 5710 @ 80), (N/A, 27), DFS
    (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR


The iw version is 3.14

I hope you can help, and many thanks

John
