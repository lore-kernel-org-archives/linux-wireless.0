Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:54094 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab0FGNSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 09:18:32 -0400
Subject: Re: Locking in new ARP query filtering patch
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext reinette chatre <reinette.chatre@intel.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1275802426.1835.4408.camel@rchatre-DESK>
References: <1275802426.1835.4408.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 16:18:24 +0300
Message-ID: <1275916704.5277.30365.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-06-06 at 07:33 +0200, ext reinette chatre wrote:
> Hi Juuso,
> 
> The new "mac80211: Add support for hardware ARP query filtering" is
> triggering some issues in my environment. I am not familiar with details
> of mac80211 locking and can thus not say if it is an issue with this
> patch itself or something in iwlwifi that is exposed by it. Could you
> please help take a look?

> When running with "mac80211: Add support for hardware ARP query
> filtering" I get the following lockdep warning when unloading iwl3945.
> The issue was bisected to this patch and when reverted this warning
> disappears. I also got a kernel BUG in what appears to be the locking
> code, which also did not appear since I reverted this patch.

Hi Reinette,

I'm also very green with mac80211 locking, but as you see I am currently
in the process of getting a crash course, and it hurts :P

I submitted a RFC PATCH attempting to fix the interlocking issue - as
per Johannes's analysis of the bug - and submitted another PATCH to fix
the BUG.

It's better to check Johannes's response to the patches first, but if he
doesn't say they're totally wrong, I'd appreciate if you could try them
out in your environment to see if your problems get solved.

And thanks for pointing these out.

-Juuso

> Here is the lockdep warning:
> [   92.026800] =======================================================
> [   92.030507] [ INFO: possible circular locking dependency detected ]
> [   92.030507] 2.6.34-04781-g2b2c009 #85
> [   92.030507] -------------------------------------------------------
> [   92.030507] modprobe/5225 is trying to acquire lock:
> [   92.030507]  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<ffffffff8105b5c0>] flush_workq
> ueue+0x0/0xb0
> [   92.030507]
> [   92.030507] but task is already holding lock:
> [   92.030507]  (rtnl_mutex){+.+.+.}, at: [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20
> [   92.030507]
> [   92.030507] which lock already depends on the new lock.
> [   92.030507]
> [   92.030507]
> [   92.030507] the existing dependency chain (in reverse order) is:
> [   92.030507]
> [   92.030507] -> #2 (rtnl_mutex){+.+.+.}:
> [   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
> [   92.030507]        [<ffffffff81341754>] mutex_lock_nested+0x44/0x300
> [   92.030507]        [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20
> [   92.030507]        [<ffffffffa022d47c>] ieee80211_assoc_done+0x6c/0xe0 [mac80211]
> [   92.030507]        [<ffffffffa022f2ad>] ieee80211_work_work+0x31d/0x1280 [mac80211]
> [   92.030507]        [<ffffffff8105a520>] worker_thread+0x230/0x370
> [   92.030507]        [<ffffffff8105ecc6>] kthread+0x96/0xb0
> [   92.030507]        [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
> [   92.030507]
> [   92.030507] -> #1 ((&local->work_work)){+.+.+.}:
> [   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
> [   92.030507]        [<ffffffff8105a51a>] worker_thread+0x22a/0x370
> [   92.030507]        [<ffffffff8105ecc6>] kthread+0x96/0xb0
> [   92.030507]        [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
> [   92.030507]
> [   92.030507] -> #0 ((wiphy_name(local->hw.wiphy))){+.+.+.}:
> [   92.030507]        [<ffffffff81075fdc>] __lock_acquire+0x1c0c/0x1d50
> [   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
> [   92.030507]        [<ffffffff8105b60e>] flush_workqueue+0x4e/0xb0
> [   92.030507]        [<ffffffffa023ff7b>] ieee80211_stop_device+0x2b/0xb0 [mac80211]
> [   92.030507]        [<ffffffffa0231635>] ieee80211_stop+0x3e5/0x680 [mac80211]
> [   92.030507]        [<ffffffff812acdfc>] __dev_close+0x4c/0x80
> [   92.030507]        [<ffffffff812ace4a>] dev_close+0x1a/0x50
> [   92.030507]        [<ffffffff812acf4a>] rollback_registered_many+0xca/0x2e0
> [   92.030507]        [<ffffffff812ad176>] unregister_netdevice_many+0x16/0x70
> [   92.030507]        [<ffffffffa0230713>] ieee80211_remove_interfaces+0xb3/0xf0 [mac80211]
> [   92.030507]        [<ffffffffa02200ae>] ieee80211_unregister_hw+0x4e/0x110 [mac80211]
> [   92.030507]        [<ffffffffa0308e00>] iwl3945_pci_remove+0x90/0x79a [iwl3945]
> [   92.030507]        [<ffffffff811d5c02>] pci_device_remove+0x32/0x60
> [   92.030507]        [<ffffffff8124f11a>] __device_release_driver+0x7a/0xe0
> [   92.030507]        [<ffffffff8124f238>] driver_detach+0xb8/0xc0
> [   92.030507]        [<ffffffff8124e034>] bus_remove_driver+0x94/0x100
> [   92.030507]        [<ffffffff8124f858>] driver_unregister+0x58/0x90
> [   92.030507]        [<ffffffff811d5eb8>] pci_unregister_driver+0x48/0xc0
> [   92.030507]        [<ffffffffa030951a>] iwl3945_exit+0x10/0x17 [iwl3945]
> [   92.030507]        [<ffffffff810800f7>] sys_delete_module+0x167/0x250
> [   92.030507]        [<ffffffff81002c6b>] system_call_fastpath+0x16/0x1b
> [   92.030507]   
> [   92.030507] other info that might help us debug this:
> [   92.030507]   
> [   92.030507] 1 lock held by modprobe/5225:
> [   92.030507]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20
> [   92.030507]   
> [   92.030507] stack backtrace:
> [   92.030507] Pid: 5225, comm: modprobe Not tainted 2.6.34-04781-g2b2c009 #85
> [   92.030507] Call Trace:
> [   92.030507]  [<ffffffff81073d41>] print_circular_bug+0x101/0x110
> [   92.030507]  [<ffffffff81075fdc>] __lock_acquire+0x1c0c/0x1d50
> [   92.030507]  [<ffffffff813432eb>] ? _raw_spin_unlock_irq+0x2b/0x40
> [   92.030507]  [<ffffffff81073215>] ? trace_hardirqs_on_caller+0x135/0x180
> [   92.030507]  [<ffffffff8105b14e>] ? __cancel_work_timer+0xfe/0x230
> [   92.030507]  [<ffffffff810761fb>] lock_acquire+0xdb/0x110
> [   92.030507]  [<ffffffff8105b5c0>] ? flush_workqueue+0x0/0xb0
> [   92.030507]  [<ffffffff8105b60e>] flush_workqueue+0x4e/0xb0
> [   92.030507]  [<ffffffff8105b5c0>] ? flush_workqueue+0x0/0xb0
> [   92.030507]  [<ffffffffa023ff7b>] ieee80211_stop_device+0x2b/0xb0 [mac80211]
> [   92.030507]  [<ffffffffa0231635>] ieee80211_stop+0x3e5/0x680 [mac80211]
> [   92.030507]  [<ffffffffa02312ae>] ? ieee80211_stop+0x5e/0x680 [mac80211]
> [   92.030507]  [<ffffffff812c1e55>] ? dev_deactivate+0x1c5/0x1f0
> [   92.030507]  [<ffffffff812acdfc>] __dev_close+0x4c/0x80
> [   92.030507]  [<ffffffff812ace4a>] dev_close+0x1a/0x50
> [   92.030507]  [<ffffffff812acf4a>] rollback_registered_many+0xca/0x2e0
> [   92.030507]  [<ffffffff812ad176>] unregister_netdevice_many+0x16/0x70
> [   92.030507]  [<ffffffffa0230713>] ieee80211_remove_interfaces+0xb3/0xf0 [mac80211]
> [   92.030507]  [<ffffffffa02200ae>] ieee80211_unregister_hw+0x4e/0x110 [mac80211]
> [   92.030507]  [<ffffffffa0308e00>] iwl3945_pci_remove+0x90/0x79a [iwl3945]
> [   92.030507]  [<ffffffff81063cfe>] ? up_read+0x1e/0x40
> [   92.030507]  [<ffffffff811d5c02>] pci_device_remove+0x32/0x60
> [   92.030507]  [<ffffffff8124f11a>] __device_release_driver+0x7a/0xe0
> [   92.030507]  [<ffffffff8124f238>] driver_detach+0xb8/0xc0
> [   92.030507]  [<ffffffff8124e034>] bus_remove_driver+0x94/0x100
> [   92.030507]  [<ffffffff8124f858>] driver_unregister+0x58/0x90
> [   92.030507]  [<ffffffff811d5eb8>] pci_unregister_driver+0x48/0xc0
> [   92.030507]  [<ffffffffa030951a>] iwl3945_exit+0x10/0x17 [iwl3945]
> [   92.030507]  [<ffffffff810800f7>] sys_delete_module+0x167/0x250
> [   92.030507]  [<ffffffff81343729>] ? retint_swapgs+0xe/0x13
> [   92.030507]  [<ffffffff81073215>] ? trace_hardirqs_on_caller+0x135/0x180
> [   92.030507]  [<ffffffff81342a02>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   92.030507]  [<ffffffff81002c6b>] system_call_fastpath+0x16/0x1b
> 
> 
> Here is the BUG:
> 
> [  132.460013] kernel BUG at /home/wifi/iwlwifi-2.6/net/mac80211/main.c:380!
> [  132.460013] invalid opcode: 0000 [#1] SMP
> [  132.460013] last sysfs file: /sys/devices/virtual/misc/rfkill/dev
> [  132.460013] CPU 0
> [  132.460013] Modules linked in: iwl3945(+) iwlcore mac80211 cfg80211 rfkill binfmt_misc ipv
> 6 sbs sbshc psmouse serio_raw pcspkr evdev pegasus mii battery container video output ac proc
> essor intel_agp button ext3 jbd mbcache sg sd_mod sr_mod cdrom ahci libahci libata ehci_hcd s
> csi_mod uhci_hcd usbcore thermal fan thermal_sys
> [  132.460013]
> [  132.460013] Pid: 5186, comm: modprobe Not tainted 2.6.35-rc1-wl-63997-gca0217c #206 To be
> filled by O.E.M./Montevina platform
> [  132.460013] RIP: 0010:[<ffffffffa022fac2>]  [<ffffffffa022fac2>] ieee80211_alloc_hw+0x502/
> 0x520 [mac80211]
> [  132.460013] RSP: 0018:ffff88003a9c7c78  EFLAGS: 00010246
> [  132.460013] RAX: ffff880039c61960 RBX: ffff880039c602e0 RCX: 0000000000000001
> [  132.460013] RDX: ffffffffa02177a0 RSI: ffffffffa02177a8 RDI: ffffffffa0217a34
> [  132.460013] RBP: ffff88003a9c7c98 R08: 0000000000000008 R09: ffffffff815461f8
> [  132.460013] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880039c605a0
> [  132.460013] R13: ffffffffa0318fc0 R14: ffff88003b616000 R15: ffff88003a8e8000
> [  132.460013] FS:  00007f24191876f0(0000) GS:ffff880002000000(0000) knlGS:0000000000000000
> [  132.460013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  132.460013] CR2: 00007ffef6721080 CR3: 000000003aae4000 CR4: 00000000000006f0
> [  132.460013] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  132.460013] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  132.460013] Process modprobe (pid: 5186, threadinfo ffff88003a9c6000, task ffff880039a24c9
> 0)
> [  132.460013] Stack:
> [  132.460013]  ffffffffa0319480 ffffffffa0319480 ffff88003b616000 ffff88003b616000
> [  132.460013] <0> ffff88003a9c7cb8 ffffffffa02af53e ffffffffa0319480 ffff88003b616088
> [  132.460013] <0> ffff88003a9c7d38 ffffffffa02fe1a7 0000000000000246 ffffffffa0318f48
> [  132.460013] Call Trace:
> [  132.460013]  [<ffffffffa02af53e>] iwl_alloc_all+0x1e/0x50 [iwlcore]
> [  132.460013]  [<ffffffffa02fe1a7>] iwl3945_pci_probe+0x27/0x1640 [iwl3945]
> [  132.460013]  [<ffffffff813446b6>] ? _raw_spin_unlock+0x26/0x30
> [  132.460013]  [<ffffffff811d48c0>] ? pci_match_device+0x20/0xd0
> [  132.460013]  [<ffffffff811d4772>] local_pci_probe+0x12/0x20
> [  132.460013]  [<ffffffff811d5880>] pci_device_probe+0x80/0xa0
> [  132.460013]  [<ffffffff8124fa5b>] ? driver_sysfs_add+0x6b/0x90
> [  132.460013]  [<ffffffff8124fb95>] driver_probe_device+0x95/0x1d0
> [  132.460013]  [<ffffffff8124fd6b>] __driver_attach+0x9b/0xb0
> [  132.460013]  [<ffffffff8124fcd0>] ? __driver_attach+0x0/0xb0
> [  132.460013]  [<ffffffff8124f23b>] bus_for_each_dev+0x6b/0xa0
> [  132.460013]  [<ffffffff8124f9ec>] driver_attach+0x1c/0x20
> [  132.460013]  [<ffffffff8124e995>] bus_add_driver+0x1b5/0x300
> [  132.460013]  [<ffffffffa0145000>] ? iwl3945_init+0x0/0x80 [iwl3945]
> [  132.460013]  [<ffffffff8125007c>] driver_register+0x7c/0x170
> [  132.460013]  [<ffffffffa0145000>] ? iwl3945_init+0x0/0x80 [iwl3945]
> [  132.460013]  [<ffffffff811d5b3a>] __pci_register_driver+0x6a/0xf0
> [  132.460013]  [<ffffffffa0145000>] ? iwl3945_init+0x0/0x80 [iwl3945]
> [  132.460013]  [<ffffffffa014504a>] iwl3945_init+0x4a/0x80 [iwl3945]
> [  132.460013]  [<ffffffff810001d8>] do_one_initcall+0x38/0x190
> [  132.460013]  [<ffffffff810800d4>] sys_init_module+0xe4/0x260
> [  132.460013]  [<ffffffff81002c6b>] system_call_fastpath+0x16/0x1b
> [  132.460013] Code: c7 c6 9d 12 27 a0 49 89 84 24 a0 03 00 00 49 89 84 24 a8 03 00 00 e8 6e
> 60 f9 e0 4c 89 e0 5b 41 5c 41 5d 41 5e c9 c3 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb f
> e 0f 0b eb fe 0f 0b eb fe 0f
> [  132.460013] RIP  [<ffffffffa022fac2>] ieee80211_alloc_hw+0x502/0x520 [mac80211]
> [  132.460013]  RSP <ffff88003a9c7c78>
> [  132.822653] ---[ end trace 4026d119e16fef57 ]---
> 
> The code in which the above appears is:
> (gdb) l *(ieee80211_alloc_hw+0x502)
> 0xaf2 is in ieee80211_alloc_hw (/home/wifi/iwlwifi-2.6/net/mac80211/main.c:380).
> 375	
> 376		ifmgd = &sdata->u.mgd;
> 377		mutex_lock(&ifmgd->mtx);
> 378		if (ifmgd->associated)
> 379			ieee80211_set_arp_filter(sdata);
> 380		mutex_unlock(&ifmgd->mtx);
> 381	
> 382		return NOTIFY_DONE;
> 383	}
> 384	#endif
> (gdb) q
> 
> Thank you
> 
> Reinette
> 
> 


