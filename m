Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:56246 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3DZJvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 05:51:20 -0400
Received: by mail-ob0-f170.google.com with SMTP id eh20so3391007obb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 02:51:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1698401.RCfH1UvLZM@pebbles>
References: <1698401.RCfH1UvLZM@pebbles>
Date: Fri, 26 Apr 2013 11:51:19 +0200
Message-ID: <CACna6rwW7fMcCLPt9yW6scpVEzvfKsRv7JgDFe6eju0Q9H3Hbg@mail.gmail.com> (sfid-20130426_115125_502046_0107BD2D)
Subject: Re: Throughput regression in b43 caused by spurious avoidance implementation
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Stefan_Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/24 Stefan Brüns <stefan.bruens@rwth-aachen.de>:
> Hi everyone,
>
> as I have been plagued by the performance regression in b43 between linux 3.2
> and 3.3, I have bisected it:
>
> git bisect good
> 49d55cef5b1925a5c1efb6aaddaa40fc7c693335 is the first bad commit
> commit 49d55cef5b1925a5c1efb6aaddaa40fc7c693335
> Author: Rafał Miłecki <zajec5@gmail.com>
> Date:   Sun Dec 11 13:16:51 2011 +0100
>
>     b43: N-PHY: implement spurious tone avoidance
>
>     Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Hi Stefan,

I'm not sure if you're still interested in this, as half a year has
passed since your report :( Anyway we've managed to resolve most
problems with BCM4322.

I took me 3 attempts to debug this issue and the last one that succeed
took me few days. I was quite tricky to debug & bisect everything, as
there were 4 regressions in b43 driver and I couldn't really distinct
them at the beginning.

After all there were 3 patches applied to the kernel that you may be
interested in:

1) b43: N-PHY: increase initial value of "mind" in RSSI calibration
It has been applied in 3.4.39 and 3.8.6 stables

2) b43: N-PHY: use more bits for offset in RSSI calibration
It has been applied in 3.4.39 and 3.8.6 stables

3) ssb: implement spurious tone avoidance
It has been applied in 3.4.42 and 3.8.9 stables

Unfortunately there is one more regression I've bisected but didn't
manage to fix yet. It's related to the scanning on channel 13. It was
reported in:

1) Scanning regression since "cfg80211: use DS or HT operation IEs to
determine BSS channel"
http://www.spinics.net/lists/linux-wireless/msg105359.html
http://marc.info/?t=136431795000003&r=1&w=4

2) [No subject]
http://lists.infradead.org/pipermail/b43-dev/2013-April/003041.html

-- 
Rafał
