Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:33086 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbeDJT5H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 15:57:07 -0400
Received: by mail-it0-f45.google.com with SMTP id x144-v6so15806453itc.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 12:57:07 -0700 (PDT)
MIME-Version: 1.0
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
Date: Tue, 10 Apr 2018 21:57:06 +0200
Message-ID: <CAE4vF2fCTEmEX8i+XVpvTJ1sRYDHDLr+fYFAM2PzTQTqkCoXVQ@mail.gmail.com> (sfid-20180410_215711_358040_2BCFD2E2)
Subject: second wifi card enforce CN reg dom
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi.

I am trying to capture on 2 channels at the same time with 2 cards.

One card is TP-Link TL-W722N v1 using ath9k_htc and the second one is
an Alfa AWUS051NH v2 using rt2800usb.

I have tried this, first, on raspberry pi 0 W  using archlinux-arm and
reproduced the issue on a netbook using archlinux x64 too using latest
kernel and drivers. (seems to happen on ubuntu 17.10 on dell laptop
too)

So when the Alfa card is used alone using the default reg dom FR, one
can change to 112 channel for example (using iw dev wlan1 set channel
112)

But once the tp-link is plugged in, reg dom seems to become CN and one
can't change the alfa card to 112 channel.

iw reg get output change from
global
country FR: DFS-ETSI
(2402 - 2482 @ 40), (N/A, 20), (N/A)
(5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
(5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
(5490 - 5710 @ 160), (N/A, 27), (0 ms), DFS
(57000 - 66000 @ 2160), (N/A, 40), (N/A)
to
global
country 98: DFS-UNSET
(2402 - 2482 @ 40), (N/A, 20), (N/A)
(5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
(5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
(57240 - 59400 @ 2160), (N/A, 28), (N/A)
(59400 - 63720 @ 2160), (N/A, 40), (N/A)
(63720 - 65880 @ 2160), (N/A, 28), (N/A)

phy#2
country CN: DFS-FCC
(2402 - 2482 @ 40), (N/A, 20), (N/A)
(5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
(5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
(5735 - 5835 @ 80), (N/A, 30), (N/A)
(57240 - 59400 @ 2160), (N/A, 28), (N/A)
(59400 - 63720 @ 2160), (N/A, 44), (N/A)
(63720 - 65880 @ 2160), (N/A, 28), (N/A)


and all the channels above 100 are marked as disabled in iw list
output (after the plug not before) for the alfa card

It is as if the TL-WN722N has CN reg dom hard-coded and that switches
it globally to CN too ???

Is this a bug in ath9k_htc ? a bug with the TL-WN722N card ??
