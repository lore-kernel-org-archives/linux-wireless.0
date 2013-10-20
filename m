Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:32902 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3JTJxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Oct 2013 05:53:49 -0400
Received: by mail-lb0-f175.google.com with SMTP id y6so4464805lbh.20
        for <linux-wireless@vger.kernel.org>; Sun, 20 Oct 2013 02:53:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA2SeNJRSPB=Hus8y1bYJ-O1Hgkd=gvNhUKnF9atqwuhd2m0aA@mail.gmail.com>
References: <CAA2SeNJRSPB=Hus8y1bYJ-O1Hgkd=gvNhUKnF9atqwuhd2m0aA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 20 Oct 2013 11:53:27 +0200
Message-ID: <CAB=NE6WSNZ10pNfKN5-o0cnVYkZbt4gGAzPOcO=Dtw5aUj+wGA@mail.gmail.com> (sfid-20131020_115410_242413_7B3D886C)
Subject: Re: Active scanning on DFS channels
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 18, 2013 at 5:53 PM, Lorenzo Bianconi
<lorenzo.bianconi83@gmail.com> wrote:
> Hi all,
>
> According to regdb.txt, DFS channels are not marked with passive scan flag:
>
> country US: DFS-FCC
>         (2402 - 2472 @ 40), (3, 27)
>         (5170 - 5250 @ 80), (3, 17)
>         (5250 - 5330 @ 80), (3, 20), DFS
>         (5490 - 5600 @ 80), (3, 20), DFS
>         (5650 - 5710 @ 40), (3, 20), DFS
>         (5735 - 5835 @ 80), (3, 30)
>
> Therefore STA device will perform active scanning on DFS channels even
> if the channel is not CAC checked and available yet.

This is certainly an issue, at least for the atheros drivers the ath
module ensures to alway set the passive-scan and no-ibss flags for DFS
frequencies, but we should at this point just standardize on this.

> Should we perform
> passive scan on radar channel setting new state to SCAN_DECISION and
> not to SCAN_SEND_PROBE in ieee80211_scan_state_set_channel()?

There's a few thing we need to do and I'm working on it.

  1) no-ibss and passive-scan flags should be merged to a no-ir flag

  2) beaconing should not be allowed if you have no-ir flag or radar
flag set but your device doesn't support DFS. If your wiphy supports
DFS and if CAC was cleared you can use that channel. If you had an AP
and a STA on the same wiphy and if the AP had DFS support and cleared
a CAC on a channel, the STA can resuse that information to do an
active scan, but it doesn't make sense to share CAC information across
different radios on the same system as we technically have no
guarantee they are on the same location, you never know.

I'm working on 1) right now.

  Luis
