Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54778 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbeB1O6U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:58:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtl8187: Fix NULL pointer dereference in priv->conf_mutex
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1518679365-15697-1-git-send-email-ssreedharan@mvista.com>
References: <1518679365-15697-1-git-send-email-ssreedharan@mvista.com>
To: Sudhir Sreedharan <ssreedharan@mvista.com>
Cc: herton@canonical.com, htl10@users.sourceforge.net,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudhir Sreedharan <ssreedharan@mvista.com>,
        stable@vger.kernel.org
Message-Id: <20180228145820.3D42F60867@smtp.codeaurora.org> (sfid-20180228_155840_472455_0FC69D74)
Date: Wed, 28 Feb 2018 14:58:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sudhir Sreedharan <ssreedharan@mvista.com> wrote:

> This can be reproduced by bind/unbind the driver multiple times
> in AM3517 board.
> 
> Analysis revealed that rtl8187_start() was invoked before probe
> finishes(ie. before the mutex is initialized).
> 
>  INFO: trying to register non-static key.
>  the code is fine but needs lockdep annotation.
>  turning off the locking correctness validator.
>  CPU: 0 PID: 821 Comm: wpa_supplicant Not tainted 4.9.80-dirty #250
>  Hardware name: Generic AM3517 (Flattened Device Tree)
>  [<c010e0d8>] (unwind_backtrace) from [<c010beac>] (show_stack+0x10/0x14)
>  [<c010beac>] (show_stack) from [<c017401c>] (register_lock_class+0x4f4/0x55c)
>  [<c017401c>] (register_lock_class) from [<c0176fe0>] (__lock_acquire+0x74/0x1938)
>  [<c0176fe0>] (__lock_acquire) from [<c0178cfc>] (lock_acquire+0xfc/0x23c)
>  [<c0178cfc>] (lock_acquire) from [<c08aa2f8>] (mutex_lock_nested+0x50/0x3b0)
>  [<c08aa2f8>] (mutex_lock_nested) from [<c05f5bf8>] (rtl8187_start+0x2c/0xd54)
>  [<c05f5bf8>] (rtl8187_start) from [<c082dea0>] (drv_start+0xa8/0x320)
>  [<c082dea0>] (drv_start) from [<c084d1d4>] (ieee80211_do_open+0x2bc/0x8e4)
>  [<c084d1d4>] (ieee80211_do_open) from [<c069be94>] (__dev_open+0xb8/0x120)
>  [<c069be94>] (__dev_open) from [<c069c11c>] (__dev_change_flags+0x88/0x14c)
>  [<c069c11c>] (__dev_change_flags) from [<c069c1f8>] (dev_change_flags+0x18/0x48)
>  [<c069c1f8>] (dev_change_flags) from [<c0710b08>] (devinet_ioctl+0x738/0x840)
>  [<c0710b08>] (devinet_ioctl) from [<c067925c>] (sock_ioctl+0x164/0x2f4)
>  [<c067925c>] (sock_ioctl) from [<c02883f8>] (do_vfs_ioctl+0x8c/0x9d0)
>  [<c02883f8>] (do_vfs_ioctl) from [<c0288da8>] (SyS_ioctl+0x6c/0x7c)
>  [<c0288da8>] (SyS_ioctl) from [<c0107760>] (ret_fast_syscall+0x0/0x1c)
>  Unable to handle kernel NULL pointer dereference at virtual address 00000000
>  pgd = cd1ec000
>  [00000000] *pgd=8d1de831, *pte=00000000, *ppte=00000000
>  Internal error: Oops: 817 [#1] PREEMPT ARM
>  Modules linked in:
>  CPU: 0 PID: 821 Comm: wpa_supplicant Not tainted 4.9.80-dirty #250
>  Hardware name: Generic AM3517 (Flattened Device Tree)
>  task: ce73eec0 task.stack: cd1ea000
>  PC is at mutex_lock_nested+0xe8/0x3b0
>  LR is at mutex_lock_nested+0xd0/0x3b0
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>

Patch applied to wireless-drivers-next.git, thanks.

7972326a26b5 rtl8187: Fix NULL pointer dereference in priv->conf_mutex

-- 
https://patchwork.kernel.org/patch/10220507/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
