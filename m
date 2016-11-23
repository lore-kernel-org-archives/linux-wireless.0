Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61661 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933205AbcKWN4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 08:56:33 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix null deref on wmi-tlv when trying spectral scan
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1479129923-11083-1-git-send-email-michal.kazior@tieto.com>
References: <1479129923-11083-1-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Michal Kazior" <michal.kazior@tieto.com>
Message-ID: <2e9894d7806f4ad0b4937b6a369923c5@euamsexm01a.eu.qualcomm.com> (sfid-20161123_145637_082140_0D4A75D6)
Date: Wed, 23 Nov 2016 14:56:26 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> wrote:
> WMI ops wrappers did not properly check for null
> function pointers for spectral scan. This caused
> null dereference crash with WMI-TLV based firmware
> which doesn't implement spectral scan.
> 
> The crash could be triggered with:
> 
>   ip link set dev wlan0 up
>   echo background > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
> 
> The crash looked like this:
> 
>   [  168.031989] BUG: unable to handle kernel NULL pointer dereference at           (null)
>   [  168.037406] IP: [<          (null)>]           (null)
>   [  168.040395] PGD cdd4067 PUD fa0f067 PMD 0
>   [  168.043303] Oops: 0010 [#1] SMP
>   [  168.045377] Modules linked in: ath10k_pci(O) ath10k_core(O) ath mac80211 cfg80211 [last unloaded: cfg80211]
>   [  168.051560] CPU: 1 PID: 1380 Comm: bash Tainted: G        W  O    4.8.0 #78
>   [  168.054336] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
>   [  168.059183] task: ffff88000c460c00 task.stack: ffff88000d4bc000
>   [  168.061736] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
>   ...
>   [  168.100620] Call Trace:
>   [  168.101910]  [<ffffffffa03b9566>] ? ath10k_spectral_scan_config+0x96/0x200 [ath10k_core]
>   [  168.104871]  [<ffffffff811386e2>] ? filemap_fault+0xb2/0x4a0
>   [  168.106696]  [<ffffffffa03b97e6>] write_file_spec_scan_ctl+0x116/0x280 [ath10k_core]
>   [  168.109618]  [<ffffffff812da3a1>] full_proxy_write+0x51/0x80
>   [  168.111443]  [<ffffffff811957b8>] __vfs_write+0x28/0x120
>   [  168.113090]  [<ffffffff812f1a2d>] ? security_file_permission+0x3d/0xc0
>   [  168.114932]  [<ffffffff8109b912>] ? percpu_down_read+0x12/0x60
>   [  168.116680]  [<ffffffff811965f8>] vfs_write+0xb8/0x1a0
>   [  168.118293]  [<ffffffff81197966>] SyS_write+0x46/0xa0
>   [  168.119912]  [<ffffffff818f2972>] entry_SYSCALL_64_fastpath+0x1a/0xa4
>   [  168.121737] Code:  Bad RIP value.
>   [  168.123318] RIP  [<          (null)>]           (null)
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Patch applied to ath-next branch of ath.git, thanks.

18ae68fff392 ath10k: fix null deref on wmi-tlv when trying spectral scan

-- 
https://patchwork.kernel.org/patch/9427495/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
