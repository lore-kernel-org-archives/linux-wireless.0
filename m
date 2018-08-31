Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37514 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbeHaUAG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 16:00:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] rsi: fix memory alignment issue in ARM32 platforms
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535369715-14254-1-git-send-email-siva8118@gmail.com>
References: <1535369715-14254-1-git-send-email-siva8118@gmail.com>
To: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Sasidhar Mudigonda <sasidhar.mudigonda@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Konduri <sanjay.konduri@redpinesignals.com>
Message-Id: <20180831155158.A678060540@smtp.codeaurora.org> (sfid-20180831_175203_218484_8E5EFAE2)
Date: Fri, 31 Aug 2018 15:51:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Siva Rebbagondla <siva8118@gmail.com> wrote:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> 
> During testing in ARM32 platforms, observed below kernel panic, as driver
> accessing data beyond the allocated memory while submitting URB to USB.
> 
> Fix: Resolved this by specifying correct length by considering 64 bit
> alignment. so that, USB bus driver will access only allocated memory.
> 
> Unit-test: Tested and confirm that driver bring up and scanning,
> connection and data transfer works fine with this fix.
> 
> ...skipping...
> [   25.389450] Unable to handle kernel paging request at virtual
> 	       address 5aa11422
> [   25.403078] Internal error: Oops: 5 [#1] SMP ARM
> [   25.407703] Modules linked in: rsi_usb
> [   25.411473] CPU: 1 PID: 317 Comm: RX-Thread Not tainted 4.18.0-rc7 #1
> [   25.419221] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [   25.425764] PC is at skb_release_data+0x90/0x168
> [   25.430393] LR is at skb_release_all+0x28/0x2c
> [   25.434842] pc : [<807435b0>] lr : [<80742ba0>] psr: 200e0013 5aa1141e
> [   25.464633] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32 ISA ARM Segment none
> [   25.477524] Process RX-Thread (pid: 317, stack limit = 0x(ptrval))
> [   25.483709] Stack: (0xedf69ed8 to 0xedf6a000)
> [   25.569907] Backtrace:
> [   25.572368] [<80743520>] (skb_release_data) from [<80742ba0>]
> 	       (skb_release_all+0x28/0x2c)
> [   25.580555] r9:7f00258c r8:00000001 r7:ee355000 r6:eddab0d0
> 	       r5:eddab000 r4:eddbb840
> [   25.588308] [<80742b78>] (skb_release_all) from [<807432cc>]
> 	       (consume_skb+0x30/0x50)
> [   25.596055] r5:eddab000 r4:eddbb840
> [   25.599648] [<8074329c>] (consume_skb) from [<7f00117c>]
> 	       (rsi_usb_rx_thread+0x64/0x12c [rsi_usb])
> [   25.608524] r5:eddab000 r4:eddbb840
> [   25.612116] [<7f001118>] (rsi_usb_rx_thread [rsi_usb]) from
> 	       [<80142750>] (kthread+0x11c/0x15c)
> [   25.620735] r10:ee9ff9e0 r9:edcde3b8 r8:ee355000 r7:edf68000
> 	       r6:edd3a780 r5:00000000
> [   25.628567] r4:edcde380
> [   25.631110] [<80142634>] (kthread) from [<801010e8>]
> 	       (ret_from_fork+0x14/0x2c)
> [   25.638336] Exception stack(0xedf69fb0 to 0xedf69ff8)
> [   25.682929] ---[ end trace 8236a5496f5b5d3b ]---
> 
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

2 patches applied to wireless-drivers-next.git, thanks.

baa8caf4ab7a rsi: fix memory alignment issue in ARM32 platforms
4c62764d0fc2 rsi: improve kernel thread handling to fix kernel panic

-- 
https://patchwork.kernel.org/patch/10577019/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
