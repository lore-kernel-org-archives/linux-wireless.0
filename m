Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:35100 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757417AbdELOLL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 10:11:11 -0400
Received: by mail-qt0-f179.google.com with SMTP id v27so29752870qtg.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 07:11:11 -0700 (PDT)
MIME-Version: 1.0
From: Sergey Naumov <sknaumov@gmail.com>
Date: Fri, 12 May 2017 17:11:10 +0300
Message-ID: <CAH3pVZMe4p_0eq+19mnPgjaXxPTUYeA6cUOe0K1kK4TohH6tgw@mail.gmail.com> (sfid-20170512_161148_697381_B02E8B2E)
Subject: iw reg get since iw-4.x
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All.

I see that since iw-4.x "iw reg get" reports multiple region
information - per-phy and global. Moreover, per-phy information could
be marked as "self-managed".

Could somebody clarify when a driver uses phy-specific region and when
- the global one?

Looking at a list of channels from "iw phy phyX info" I can conclude
that if "self-managed" is true, then phy-specific region is used,
otherwise - the global one. Is it a correct assumption? If yes, then
why phy-specific regions are reported at all for non-self-managed
devices, and why the global region is reported for self-managed ones?

I think it would be natural to use new "iw phy phyX reg get" command
to report region information that is actually used, but unfortunately
this command returns exactly the same as "iw reg get":

root@OpenWrt:~# iw --version
iw version 4.9
root@OpenWrt:~# iw phy phy0 reg get
global
country RU: DFS-ETSI
        (2402 - 2482 @ 40), (N/A, 20), (N/A)
        (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
        (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
        (5650 - 5730 @ 80), (N/A, 30), (0 ms), DFS
        (5735 - 5835 @ 80), (N/A, 30), (N/A)
        (57000 - 66000 @ 2160), (N/A, 40), (N/A)

phy#1
country US: DFS-FCC
        (2402 - 2472 @ 40), (N/A, 30), (N/A)
        (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
        (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
        (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
        (5735 - 5835 @ 80), (N/A, 30), (N/A)
        (57240 - 63720 @ 2160), (N/A, 40), (N/A)

phy#0
country US: DFS-FCC
        (2402 - 2472 @ 40), (N/A, 30), (N/A)
        (5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
        (5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
        (5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
        (5735 - 5835 @ 80), (N/A, 30), (N/A)
        (57240 - 63720 @ 2160), (N/A, 40), (N/A)

Thanks in advance,
Sergey.
