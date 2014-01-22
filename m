Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:47716 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaAVV4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 16:56:40 -0500
Received: by mail-ie0-f181.google.com with SMTP id tq11so179486ieb.26
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 13:56:40 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 22 Jan 2014 16:56:39 -0500
Message-ID: <CAKKnJbe=eBMzB3Bp7qkYvwSTr0x=g-bZkz9dQ6HUihZE5rc5iw@mail.gmail.com> (sfid-20140122_225643_699210_FDECEAE8)
Subject: wlcore-spi crash
From: Charles <hobbesc7@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am building the TI wireless drivers from backports-3.12-1 for a 3.2 kernel.

When I modprobe wlcore-spi I get a kernel crash.  Has anyone
encountered this?  I found a similar problem here:
http://marc.info/?l=linux-wireless&m=135212370625698&w=2

I tried adding the patch mentioned there to backports-3.12-1, but I
get this build error: "error: 'struct wl1271' has no member named
'set_power'"

Here's the crash:

[   98.325693] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   98.334171] pgd = c0004000
[   98.337031] [00000000] *pgd=00000000
[   98.340791] Internal error: Oops: 80000007 [#1]
[   98.345524] Modules linked in: wlcore_spi(O) wl12xx(O) wlcore(O)
mac80211(O) cfg80211(O) compat(O) autofs4
[   98.355661] CPU: 0    Tainted: G           O  (3.2.0)
[   98.364120] PC is at 0x0
[   98.366846] LR is at wl12xx_set_power_on+0x30/0x150 [wlcore]
[   98.372764] pc : [<00000000>]    lr : [<bf0b213c>]    psr: 60000013
[   98.372772] sp : cf445f28  ip : cf445ec8  fp : cf445f44
[   98.384761] r10: c061c478  r9 : 00000000  r8 : cf6bd500
[   98.390219] r7 : cf6bdac0  r6 : 00000000  r5 : cf2a4000  r4 : cf411480
[   98.397039] r3 : 00000000  r2 : cf49bb6c  r1 : 00000001  r0 : cf2a4008
[   98.403861] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[   98.411500] Control: 10c5387d  Table: 8f3dc019  DAC: 00000015
[   98.417503] Process firmware/ti-con (pid: 1330, stack limit = 0xcf4442f0)
[   98.424595] Stack: (0xcf445f28 to 0xcf446000)
[   98.429153] 5f20:                   c0076214 c0075c0c cf411480
cf2a4000 cf445f94 cf445f48
[   98.437706] 5f40: bf0b8dc0 bf0b2118 cf2a4150 cf411480 cf445f94
cf445f60 c025c3ec c024e14c
[   98.446258] 5f60: c061cff0 cf444000 cf445fac cf470140 00000000
c025c5e4 00000013 00000000
[   98.454809] 5f80: 00000000 00000000 cf445fbc cf445f98 c025c62c
bf0b8ca4 00000001 00000000
[   98.463362] 5fa0: cf445fbc cf6bd500 cf34db7c cf470140 cf445ff4
cf445fc0 c005554c c025c5f0
[   98.471913] 5fc0: cf34db7c 00000000 cf470140 00000000 cf445fd0
cf445fd0 00000000 cf34db7c
[   98.480463] 5fe0: c00554c0 c0040108 00000000 cf445ff8 c0040108
c00554cc 00000000 00000000
[   98.489002] Backtrace:
[   98.491616] [<bf0b210c>] (wl12xx_set_power_on+0x0/0x150 [wlcore])
from [<bf0b8dc0>] (wlcore_nvs_cb+0x128/0x944 [wlcore])
[   98.502974]  r5:cf2a4000 r4:cf411480
[   98.506766] [<bf0b8c98>] (wlcore_nvs_cb+0x0/0x944 [wlcore]) from
[<c025c62c>] (request_firmware_work_func+0x48/0x7c)
[   98.517787] [<c025c5e4>] (request_firmware_work_func+0x0/0x7c) from
[<c005554c>] (kthread+0x8c/0x94)
[   98.527326]  r5:cf470140 r4:cf34db7c
[   98.531089] [<c00554c0>] (kthread+0x0/0x94) from [<c0040108>]
(do_exit+0x0/0x66c)
[   98.538902]  r6:c0040108 r5:c00554c0 r4:cf34db7c
[   98.543743] Code: bad PC value
[   98.547128] ---[ end trace 9f4a33769e1819b4 ]---
