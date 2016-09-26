Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751252AbcIZLTN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 07:19:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] mwifiex: fix unaligned read in mwifiex_config_scan()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1471057200-58166-2-git-send-email-pgynther@google.com>
References: <1471057200-58166-2-git-send-email-pgynther@google.com>
To: Petri Gynther <pgynther@google.com>
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net,
        joe@perches.com, akarwar@marvell.com,
        Petri Gynther <pgynther@google.com>
Message-Id: <20160926111912.AE5BD6155C@smtp.codeaurora.org> (sfid-20160926_131918_092962_06214609)
Date: Mon, 26 Sep 2016 11:19:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Petri Gynther <pgynther@google.com> wrote:
> $ iwconfig mlan0 essid MySSID
> [   36.930000] Path: /sbin/iwconfig
> [   36.930000] CPU: 0 PID: 203 Comm: iwconfig Not tainted 4.7.0 #2
> [   36.940000] task: 866f83a0 ti: 866a6000 task.ti: 866a6000
> [   36.940000]
> [ECR   ]: 0x00230400 => Misaligned r/w from 0x8677f403
> [   36.960000] [EFA   ]: 0x8677f403
> [   36.960000] [BLINK ]: mwifiex_scan_networks+0x17a/0x198c [mwifiex]
> [   36.960000] [ERET  ]: mwifiex_scan_networks+0x18a/0x198c [mwifiex]
> [   36.980000] [STAT32]: 0x00000206 : K         E2 E1
> [   36.980000] BTA: 0x700736e2   SP: 0x866a7d0c  FP: 0x5faddc84
> [   37.000000] LPS: 0x806a37ec  LPE: 0x806a37fa LPC: 0x00000000
> [   37.000000] r00: 0x8677f401  r01: 0x8668aa08 r02: 0x00000001
> r03: 0x00000000 r04: 0x8668b600 r05: 0x8677f406
> r06: 0x8702b600 r07: 0x00000000 r08: 0x8702b600
> r09: 0x00000000 r10: 0x870b3b00 r11: 0x00000000
> r12: 0x00000000
> [   37.040000]
> [   37.040000] Stack Trace:
> [   37.040000]   mwifiex_scan_networks+0x18a/0x198c [mwifiex]
> 
> Root cause:
> mwifiex driver calls is_zero_ether_addr() against byte-aligned address:
> 
> drivers/net/wireless/marvell/mwifiex/fw.h:
> struct mwifiex_scan_cmd_config {
>         /*
>          *  BSS mode to be sent in the firmware command
>          */
>         u8 bss_mode;
> 
>         /* Specific BSSID used to filter scan results in the firmware */
>         u8 specific_bssid[ETH_ALEN];
> 
>         ...
> } __packed;
> 
> drivers/net/wireless/marvell/mwifiex/scan.c:
> mwifiex_config_scan(..., struct mwifiex_scan_cmd_config *scan_cfg_out, ...)
>         ...
>         if (adapter->ext_scan &&
>             !is_zero_ether_addr(scan_cfg_out->specific_bssid)) {
>             ...
>         }
> 
> Since firmware-related struct mwifiex_scan_cmd_config cannot be changed,
> we need to use the new function is_zero_ether_addr_unaligned() here.
> 
> This is v2 of the original patch:
> [PATCH] Modify is_zero_ether_addr() to handle byte-aligned addresses
> 
> Per Joe's suggestion -- instead of modifying is_zero_ether_addr() --
> add is_zero_ether_addr_unaligned() and use it where needed.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Joe Perches <joe@perches.com>
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Petri Gynther <pgynther@google.com>

Patch set to Rejected.

Reason: As is_zero_ether_addr_unaligned() patch is not applied I can't take
this. Please resend if that patch is accepted.

-- 
https://patchwork.kernel.org/patch/9306999/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
