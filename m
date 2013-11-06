Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33697 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab3KFVvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 16:51:07 -0500
Message-ID: <527AB9B1.7080909@candelatech.com> (sfid-20131106_225127_258817_A4DDE8CC)
Date: Wed, 06 Nov 2013 13:50:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Subject: BUG in wiphy_unregister (ath tree, 3.12.0-rc5)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found this while hacking on ath10k, probably during module unload.

(gdb) l *(wiphy_unregister+0xcd)
0x748 is in wiphy_unregister (/mnt/sda/home/greearb/git/linux.ath/net/wireless/core.c:653).
648			rfkill_unregister(rdev->rfkill);
649	
650		rtnl_lock();
651		rdev->wiphy.registered = false;
652	
653		BUG_ON(!list_empty(&rdev->wdev_list));
654	
655		/*
656		 * First remove the hardware from everywhere, this makes
657		 * it impossible to find from userspace.


------------[ cut here ]------------
kernel BUG at /mnt/sda/home/greearb/git/linux.ath/net/wireless/core.c:653!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: ath10k_pci(-) ath10k_core ath5k ath9k ath9k_common ath9k_hw nf_nat_ipv4 nf_nat veth 8021]
CPU: 3 PID: 12451 Comm: rmmod Tainted: G        WC   3.12.0-rc5-wl+ #2
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
task: ffff88020d478000 ti: ffff8800cb8b0000 task.ti: ffff8800cb8b0000
RIP: 0010:[<ffffffffa028b748>]  [<ffffffffa028b748>] wiphy_unregister+0xcd/0x1fc [cfg80211]
RSP: 0018:ffff8800cb8b1cf8  EFLAGS: 00010293
RAX: ffff8802153c8088 RBX: ffff8802153c8000 RCX: 0000000284142006
RDX: 0000000000000006 RSI: 0000000000000003 RDI: ffff8800cb8b0000
RBP: ffff8800cb8b1d58 R08: 0000000000000002 R09: 0000000000000000
R10: ffffffff814e7d11 R11: ffffffff81498427 R12: ffff8802153c8380
R13: 0000000000000000 R14: 000000000236a010 R15: 0000000000000002
FS:  00007f39b6285740(0000) GS:ffff88021fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffa10d6b000 CR3: 00000000cf2db000 CR4: 00000000000407e0
Stack:
 0000000000000200 ffff8800cf2016f8 ffff8800cb8b1d58 ffffffff810b4018
 0000000000000002 ffff880200000000 ffff8802153ca280 ffff8802153c88a0
 ffff8802153ca280 ffff880032d12520 000000000236a010 0000000000000002
Call Trace:
 [<ffffffff810b4018>] ? destroy_workqueue+0x174/0x1d1
 [<ffffffffa03291dd>] ieee80211_unregister_hw+0xdd/0x105 [mac80211]
 [<ffffffffa0830ade>] ath10k_mac_unregister+0x15/0x47 [ath10k_core]
 [<ffffffffa0832360>] ath10k_core_unregister+0xe/0x22 [ath10k_core]
 [<ffffffffa084e100>] ath10k_pci_remove+0x59/0x97 [ath10k_pci]
 [<ffffffff812e2fd6>] pci_device_remove+0x41/0x8f
 [<ffffffff8139fe79>] __device_release_driver+0x86/0xdc
 [<ffffffff813a0843>] driver_detach+0x79/0xa6
 [<ffffffff8139fd37>] bus_remove_driver+0xca/0xef
 [<ffffffffa0851f4c>] ? ath10k_ce_init+0x52b/0x52b [ath10k_pci]
 [<ffffffff813a0de9>] driver_unregister+0x42/0x49
 [<ffffffffa0851f4c>] ? ath10k_ce_init+0x52b/0x52b [ath10k_pci]
 [<ffffffff812e2af2>] pci_unregister_driver+0x1d/0x82
 [<ffffffffa0851f4c>] ? ath10k_ce_init+0x52b/0x52b [ath10k_pci]
 [<ffffffffa0851f5c>] ath10k_pci_exit+0x10/0x12 [ath10k_pci]
 [<ffffffff810f7a4f>] SyS_delete_module+0x1ee/0x260
 [<ffffffff810e4e66>] ? current_kernel_time+0xd/0x31
 [<ffffffff8118db16>] ? mntput_no_expire+0x1d/0x143
 [<ffffffff815967fd>] system_call_fastpath+0x1a/0x1f
Code: e0 48 8b 7b 30 48 85 ff 74 05 e8 58 d6 2e e1 e8 ce c5 25 e1 48 8d 83 88 00 00 00 48 39 83 88 00 00 00
RIP  [<ffffffffa028b748>] wiphy_unregister+0xcd/0x1fc [cfg80211]
 RSP <ffff8800cb8b1cf8>
---[ end trace 2c04c3e4cfaea150 ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

