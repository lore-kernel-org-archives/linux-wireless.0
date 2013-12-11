Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43184 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3LKQ3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 11:29:03 -0500
Received: by mail-ie0-f179.google.com with SMTP id x13so11387676ief.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 08:29:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A856B5.2060700@candelatech.com>
References: <52A856B5.2060700@candelatech.com>
Date: Wed, 11 Dec 2013 18:29:00 +0200
Message-ID: <CAB3XZEdxQo07yW2g7_6PQUspb8Knd5wrjEaOmvB2Q3M3xNOvow@mail.gmail.com> (sfid-20131211_172907_845348_B2E2905D)
Subject: Re: Kernel crash related to scan in 3.13-rc3-wl-ath+
From: Eliad Peller <eliad@wizery.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 11, 2013 at 2:12 PM, Ben Greear <greearb@candelatech.com> wrote:
> I have a few patches to ath10k, and one patch to mac80211 that adds
> an sdata_info() message, but no other patches.  I'm running a few
> station interfaces on ath10k, they were not doing a good job of
> getting DHCP lease and were being bounced by user-space app
> periodically.
>
>
> Bug that hit was this:
>
> static inline
> struct cfg80211_registered_device *wiphy_to_dev(struct wiphy *wiphy)
> {
>         BUG_ON(!wiphy);
>         return container_of(wiphy, struct cfg80211_registered_device,
> wiphy);
> }
>
>
> IPv6: ADDRCONF(NETDEV_UP): sta330: link is not ready
> ------------[ cut here ]------------
> kernel BUG at /mnt/sda/home/greearb/git/linux.ath/net/wireless/core.h:92!
> invalid opcode: 0000 [#1] sta326: deauthenticating from 00:03:83:3d:30:ab by
> local choice (reason)
> PREEMPT SMP
> Modules linked in: ath10k_pci ath10k_core ath5k ath9k ath9k_common ath9k_hw
> nf_nat_ipv4 nf_nat ve]
> CPU: 0 PID: 2982 Comm: kworker/u8:2 Tainted: G        WC
> 3.13.0-rc3-wl-ath+ #5
> Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER,
> BIOS 4.6.5 05/02/2012
> Workqueue: phy14 ieee80211_scan_work [mac80211]
> task: ffff88020d0cc380 ti: ffff880034bfc000 task.ti: ffff880034bfc000
> RIP: 0010:[<ffffffffa027e022>]  [<ffffffffa027e022>] wiphy_to_dev+0x9/0x14
> [cfg80211]
> RSP: 0018:ffff880034bfdce8  EFLAGS: 00010246
> RAX: ffff88020d0cc380 RBX: ffff88020d7b76c0 RCX: 0000000100130006
> RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff880034bfdce8 R08: ffff880217004b40 R09: 0000000000000000
> R10: ffffffff00000008 R11: 0000000000000292 R12: ffff8800ca7f9d00
> R13: ffff8802151d4c01 R14: ffff8800ca7f9c00 R15: ffff8800ca7f9c88
> FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000001f1e240 CR3: 0000000001a0d000 CR4: 00000000000407f0
> Stack:
>  ffff880034bfdd08 ffffffffa027e380 ffff8800ca7f88a0 ffff8800ca7f9d00
>  ffff880034bfdd38 ffffffffa03cc7cb 0000000000000004 ffff8800ca7f88a0
>  ffff8800ca7f9d50 ffff8802151d4ce0 ffff880034bfdd98 ffffffffa03cd532
> Call Trace:
>  [<ffffffffa027e380>] cfg80211_scan_done+0x16/0x5e [cfg80211]
>  [<ffffffffa03cc7cb>] __ieee80211_scan_completed+0xd5/0x1ab [mac80211]
>  [<ffffffffa03cd532>] ieee80211_scan_work+0x417/0x42e [mac80211]
>  [<ffffffff810c01a9>] process_one_work+0x1d7/0x2fc
>  [<ffffffff810c013f>] ? process_one_work+0x16d/0x2fc
>  [<ffffffff810bd4e4>] ? spin_lock_irq+0x9/0xb
>  [<ffffffff810c06a1>] worker_thread+0x12e/0x1fb
>  [<ffffffff810c0573>] ? rescuer_thread+0x27b/0x27b
>  [<ffffffff810c5aca>] kthread+0xb5/0xbd
>  [<ffffffff815a91e8>] ? _raw_spin_unlock_irq+0x28/0x42
>  [<ffffffff810c5a15>] ? __kthread_parkme+0x5c/0x5c
>  [<ffffffff815ae00c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff810c5a15>] ? __kthread_parkme+0x5c/0x5c

it looks a bit similar to the one i got here:
http://www.spinics.net/lists/linux-wireless/msg115739.html

can you give it a shot (if this is reproducible)?

Eliad.
