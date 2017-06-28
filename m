Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4565 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbdF1QzO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 12:55:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] ath9k: fixed an invalid pointer dereference
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1498094669-6510-1-git-send-email-miaoqing@codeaurora.org>
References: <1498094669-6510-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <sssa@qti.qualcomm.com>, <giulio.genovese@gmail.com>,
        Miaoqing Pan <miaoqing@codeaurora.org>
Message-ID: <7b8401607efc4a26825013c283ad52fa@euamsexm01a.eu.qualcomm.com> (sfid-20170628_185518_032959_55A3F8A3)
Date: Wed, 28 Jun 2017 18:55:06 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing pan <miaoqing@codeaurora.org> wrote:

> The bug was triggered when do suspend/resuming continuously
> on Dell XPS L322X/0PJHXN version 9333 (2013) with kernel
> 4.12.0-041200rc4-generic. But can't reproduce on DELL
> E5440 + AR9300 PCIE chips.
> 
> The warning is caused by accessing invalid pointer sc->rng_task.
> sc->rng_task is not be cleared after kthread_stop(sc->rng_task)
> be called in ath9k_rng_stop(). Because the kthread is stopped
> before ath9k_rng_kthread() be scheduled.
> 
> So set sc->rng_task to null after kthread_stop(sc->rng_task) to
> resolve this issue.
> 
> WARNING: CPU: 0 PID: 984 at linux/kernel/kthread.c:71 kthread_stop+0xf1/0x100
> CPU: 0 PID: 984 Comm: NetworkManager Not tainted 4.12.0-041200rc4-generic #201706042031
> Hardware name: Dell Inc.          Dell System XPS L322X/0PJHXN, BIOS A09 05/15/2013
> task: ffff950170fdda00 task.stack: ffffa22c01538000
> RIP: 0010:kthread_stop+0xf1/0x100
> RSP: 0018:ffffa22c0153b5b0 EFLAGS: 00010246
> RAX: ffffffffa6257800 RBX: ffff950171b79560 RCX: 0000000000000000
> RDX: 0000000080000000 RSI: 000000007fffffff RDI: ffff9500ac9a9680
> RBP: ffffa22c0153b5c8 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffa22c0153b648 R11: ffff9501768004b8 R12: ffff9500ac9a9680
> R13: ffff950171b79f70 R14: ffff950171b78780 R15: ffff9501749dc018
> FS:  00007f0d6bfd5540(0000) GS:ffff95017f200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc190161a08 CR3: 0000000232906000 CR4: 00000000001406f0
> Call Trace:
>   ath9k_rng_stop+0x1a/0x20 [ath9k]
>   ath9k_stop+0x3b/0x1d0 [ath9k]
>   drv_stop+0x33/0xf0 [mac80211]
>   ieee80211_stop_device+0x43/0x50 [mac80211]
>   ieee80211_do_stop+0x4f2/0x810 [mac80211]
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=196043
> Reported-by: Giulio Genovese <giulio.genovese@gmail.com>
> Tested-by: Giulio Genovese <giulio.genovese@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

3 patches applied to ath-next branch of ath.git, thanks.

07246c115801 ath9k: fix an invalid pointer dereference in ath9k_rng_stop()
473becac4b31 ath9k: avoid potential freezing during random generator read
f23cdfb3fe8f ath9k: Use mutex_lock to avoid potential race in start/stop rng

-- 
https://patchwork.kernel.org/patch/9803211/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
