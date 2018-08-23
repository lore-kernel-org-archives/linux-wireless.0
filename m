Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f53.google.com ([209.85.208.53]:42807 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbeHWVBv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 17:01:51 -0400
Received: by mail-ed1-f53.google.com with SMTP id r10-v6so4114742edp.9
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2018 10:31:06 -0700 (PDT)
MIME-Version: 1.0
From: prabhu <d.praabhu@gmail.com>
Date: Thu, 23 Aug 2018 23:00:53 +0530
Message-ID: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com> (sfid-20180823_193110_166245_7865EE45)
Subject: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

BCM 4312 wifi card stopped working from kernel version 4.18
After boot up it tries to reconnect for few times and after that it
disconnected completely.

Here is the snippet from dmesg:
[ 70.826051] [drm:radeon_cs_parser_relocs [radeon]] *ERROR* gem object
lookup failed 0xd
[ 70.826090] [drm:radeon_cs_ioctl [radeon]] *ERROR* Failed to parse
relocation -2!
[ 238.066341] b43-phy0: Controller RESET (Out of order TX) ...
[ 238.306116] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[ 245.443095] b43-phy0: Controller restarted
[ 285.552662] wlan0: deauthenticated from 98:de:d0:4b:e6:f6 (Reason:
6=CLASS2_FRAME_FROM_NONAUTH_STA)
[ 285.639719] wlan0: authenticate with 98:de:d0:4b:e6:f6
[ 285.656291] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
[ 285.658957] wlan0: authenticated
[ 285.662386] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
[ 285.665581] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
status=0 aid=2)
[ 285.666396] wlan0: associated
[ 309.348063] b43-phy0: Controller RESET (Out of order TX) ...
[ 309.592485] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[ 316.742829] b43-phy0: Controller restarted
[ 329.268570] perf: interrupt took too long (2513 > 2500), lowering
kernel.perf_event_max_sample_rate to 79500
[ 400.542426] wlan0: deauthenticated from 98:de:d0:4b:e6:f6 (Reason:
6=CLASS2_FRAME_FROM_NONAUTH_STA)
[ 400.636523] wlan0: authenticate with 98:de:d0:4b:e6:f6
[ 400.652666] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
[ 400.655070] wlan0: authenticated
[ 400.655447] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
[ 400.658583] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
status=0 aid=2)
[ 400.659276] wlan0: associated
[ 412.256359] perf: interrupt took too long (3246 > 3141), lowering
kernel.perf_event_max_sample_rate to 61500
[ 555.832079] b43-phy0: Controller RESET (Out of order TX) ...
[ 556.082050] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[ 563.172269] b43-phy0: Controller restarted
[ 619.628212] perf: interrupt took too long (4066 > 4057), lowering
kernel.perf_event_max_sample_rate to 48900
[ 766.268349] wlan0: deauthenticated from 98:de:d0:4b:e6:f6 (Reason:
6=CLASS2_FRAME_FROM_NONAUTH_STA)
[ 766.317708] wlan0: authenticate with 98:de:d0:4b:e6:f6
[ 766.338515] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
[ 766.345731] wlan0: authenticated
[ 766.347959] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
[ 766.352674] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
status=0 aid=2)
[ 766.353351] wlan0: associated
[ 801.234010] perf: interrupt took too long (5097 > 5082), lowering
kernel.perf_event_max_sample_rate to 39000
[ 1780.122837] perf: interrupt took too long (6979 > 6371), lowering
kernel.perf_event_max_sample_rate to 28500
[ 2347.465072] b43-phy0: Controller RESET (Out of order TX) ...
[ 2347.705572] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[ 2354.735641] b43-phy0: Controller restarted
[ 2388.784785] wlan0: deauthenticated from 98:de:d0:4b:e6:f6 (Reason:
6=CLASS2_FRAME_FROM_NONAUTH_STA)
[ 2388.901388] wlan0: authenticate with 98:de:d0:4b:e6:f6
[ 2388.918575] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
[ 2388.920893] wlan0: authenticated
[ 2388.921243] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
[ 2388.924310] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
status=0 aid=2)
[ 2388.925336] wlan0: associated
[ 2973.297286] b43-phy0: Controller RESET (Out of order TX) ...
[ 2973.532792] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[ 2980.496495] b43-phy0: Controller restarted
[ 5306.648339] wlan0: deauthenticating from 98:de:d0:4b:e6:f6 by local
choice (Reason: 3=DEAUTH_LEAVING)
[ 5306.909377] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[ 5313.899248] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 5320.225907] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[ 5327.189103] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 5328.567334] wlan0: authenticate with 98:de:d0:4b:e6:f6
[ 5328.599382] wlan0: send auth to 98:de:d0:4b:e6:f6 (try 1/3)
[ 5328.601751] wlan0: authenticated
[ 5328.602238] wlan0: associate with 98:de:d0:4b:e6:f6 (try 1/3)
[ 5328.605468] wlan0: RX AssocResp from 98:de:d0:4b:e6:f6 (capab=0x431
status=0 aid=2)
[ 5328.606369] wlan0: associated
[ 5328.615757] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 5348.732714] b43-phy0: Controller RESET (Out of order TX) ...

The following commits introduce this regression in 4.18
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=66cffd6daab76caebab26eb803b92182414fc182

I verified that in two ways:
1. Downgrade the kernel to 4.17.14 - Fixes the Issue
2. Revert that commit in 4.18.4 - Fixes the Issue

Regards,
D.Prabhu
