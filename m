Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752789AbcKIBeF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 20:34:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] mwifiex: prevent register accesses after host is sleeping
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161109013405.097F46135B@smtp.codeaurora.org> (sfid-20161109_023424_758907_B8AEADA4)
Date: Wed,  9 Nov 2016 01:34:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> Following is mwifiex driver-firmware host sleep handshake.
> It involves three threads. suspend handler, interrupt handler, interrupt
> processing in main work queue.
> 
> 1) Enter suspend handler
> 2) Download HS_CFG command
> 3) Response from firmware for HS_CFG
> 4) Suspend thread waits until handshake completes(i.e hs_activate becomes
>    true)
> 5) SLEEP from firmware
> 6) SLEEP confirm downloaded to firmware.
> 7) SLEEP confirm response from firmware
> 8) Driver processes SLEEP confirm response and set hs_activate to wake up
> suspend thread
> 9) Exit suspend handler
> 10) Read sleep cookie in loop and wait until it indicates firmware is
> sleep.
> 11) After processing SLEEP confirm response, we are at the end of interrupt
> processing routine. Recheck if there are interrupts received while we were
> processing them.
> 
> During suspend-resume stress test, it's been observed that we may end up
> acessing PCIe hardware(in 10 and 11) when PCIe bus is closed which leads
> to a kernel crash.
> 
> This patch solves the problem with below changes.
> a) action 10 above can be done before 8
> b) Skip 11 if hs_activated is true. SLEEP confirm response
> is the last interrupt from firmware. No need to recheck for
> pending interrupts.
> c) Add flush_workqueue() in suspend handler.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Tested-by: Brian Norris <briannorris@chromium.org>

8 patches applied to wireless-drivers-next.git, thanks.

ec815dd2a5f1 mwifiex: prevent register accesses after host is sleeping
5190f2e40591 mwifiex: report error to PCIe for suspend failure
c44c040300d7 mwifiex: Fix NULL pointer dereference in skb_dequeue()
113630b581d6 mwifiex: vendor_ie length check for parse WMM IEs
a936ea543657 mwifiex: add memrw command information in README
77f486c8bb39 mwifiex: update tx_pkts_queued for requeued packets
49abe5c83cd0 mwifiex: fix command timeout problem seen in stress tests
3d8bd85c2c9e mwifiex: fix p2p device doesn't find in scan problem

-- 
https://patchwork.kernel.org/patch/9353809/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
