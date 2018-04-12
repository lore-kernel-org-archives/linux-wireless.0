Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:40201 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752713AbeDLHAu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 03:00:50 -0400
Received: by mail-it0-f49.google.com with SMTP id u62-v6so5755265ita.5
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 00:00:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE4vF2fCTEmEX8i+XVpvTJ1sRYDHDLr+fYFAM2PzTQTqkCoXVQ@mail.gmail.com>
References: <CAE4vF2fCTEmEX8i+XVpvTJ1sRYDHDLr+fYFAM2PzTQTqkCoXVQ@mail.gmail.com>
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
Date: Thu, 12 Apr 2018 09:00:49 +0200
Message-ID: <CAE4vF2f2oXEvOJWDXPjmiWZTC=HOq5+xE_R64-_VvH6zc-Vw+A@mail.gmail.com> (sfid-20180412_090054_939813_E8E9F5ED)
Subject: Re: second wifi card enforce CN reg dom
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nobody cares about this ?

Should I report this as a bug to the LKML ? or elsewhere ? to
ath9k_htc dev ? to crda dev ?

Please.

2018-04-10 21:57 GMT+02:00 solsTiCe d'Hiver <solstice.dhiver@gmail.com>:
> hi.
>
> I am trying to capture on 2 channels at the same time with 2 cards.
>
> One card is TP-Link TL-W722N v1 using ath9k_htc and the second one is
> an Alfa AWUS051NH v2 using rt2800usb.
>
> I have tried this, first, on raspberry pi 0 W  using archlinux-arm and
> reproduced the issue on a netbook using archlinux x64 too using latest
> kernel and drivers. (seems to happen on ubuntu 17.10 on dell laptop
> too)
>
> So when the Alfa card is used alone using the default reg dom FR, one
> can change to 112 channel for example (using iw dev wlan1 set channel
> 112)
>
> But once the tp-link is plugged in, reg dom seems to become CN and one
> can't change the alfa card to 112 channel.
>
> iw reg get output change from
> global
> country FR: DFS-ETSI
> (2402 - 2482 @ 40), (N/A, 20), (N/A)
> (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
> (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
> (5490 - 5710 @ 160), (N/A, 27), (0 ms), DFS
> (57000 - 66000 @ 2160), (N/A, 40), (N/A)
> to
> global
> country 98: DFS-UNSET
> (2402 - 2482 @ 40), (N/A, 20), (N/A)
> (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
> (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
> (57240 - 59400 @ 2160), (N/A, 28), (N/A)
> (59400 - 63720 @ 2160), (N/A, 40), (N/A)
> (63720 - 65880 @ 2160), (N/A, 28), (N/A)
>
> phy#2
> country CN: DFS-FCC
> (2402 - 2482 @ 40), (N/A, 20), (N/A)
> (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
> (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
> (5735 - 5835 @ 80), (N/A, 30), (N/A)
> (57240 - 59400 @ 2160), (N/A, 28), (N/A)
> (59400 - 63720 @ 2160), (N/A, 44), (N/A)
> (63720 - 65880 @ 2160), (N/A, 28), (N/A)
>
>
> and all the channels above 100 are marked as disabled in iw list
> output (after the plug not before) for the alfa card
>
> It is as if the TL-WN722N has CN reg dom hard-coded and that switches
> it globally to CN too ???
>
> Is this a bug in ath9k_htc ? a bug with the TL-WN722N card ??
