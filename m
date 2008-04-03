Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63981 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbYDCA2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 20:28:13 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: mac80211: possible circular locking dependency detected
Date: Wed, 2 Apr 2008 17:27:38 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004194DDE@orsmsx416.amr.corp.intel.com> (sfid-20080403_012818_115976_287E1F78)
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was encountered with the latest wireless-testing repo when the
iwl3945 module was unloaded.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.25-rc8-wl #23
-------------------------------------------------------
rmmod/5589 is trying to acquire lock:
 ((name)){--..}, at: [<c012deec>] flush_workqueue+0x0/0x80

but task is already holding lock:
 (rtnl_mutex){--..}, at: [<c02507ee>] rtnl_lock+0xf/0x11

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (rtnl_mutex){--..}:
       [<c013c26e>] __lock_acquire+0x9c5/0xb72
       [<c013c47e>] lock_acquire+0x63/0x80
       [<c02b3296>] mutex_lock_nested+0xc2/0x231
       [<c02507ee>] rtnl_lock+0xf/0x11
       [<dca1ef61>] sta_info_debugfs_add_work+0xe7/0x100 [mac80211]
       [<c012d8a4>] run_workqueue+0xbb/0x18b
       [<c012e247>] worker_thread+0xb6/0xc2
       [<c01306ec>] kthread+0x3b/0x63
       [<c010577b>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 (&local->sta_debugfs_add){--..}:
       [<c013c26e>] __lock_acquire+0x9c5/0xb72
       [<c013c47e>] lock_acquire+0x63/0x80
       [<c012d89f>] run_workqueue+0xb6/0x18b
       [<c012e247>] worker_thread+0xb6/0xc2
       [<c01306ec>] kthread+0x3b/0x63
       [<c010577b>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 ((name)){--..}:
       [<c013c195>] __lock_acquire+0x8ec/0xb72
       [<c013c47e>] lock_acquire+0x63/0x80
       [<c012df2b>] flush_workqueue+0x3f/0x80
       [<dca1ca89>] ieee80211_stop+0x2a5/0x366 [mac80211]
       [<c0248266>] dev_close+0x45/0x5d
       [<c02482f6>] rollback_registered+0x78/0xf3
       [<c02483a8>] unregister_netdevice+0x37/0x73
       [<dca27285>] __ieee80211_if_del+0x15/0x18 [mac80211]
       [<dca1c382>] ieee80211_unregister_hw+0x72/0x125 [mac80211]
       [<dca5e7c1>] iwl3945_pci_remove+0x29a/0x311 [iwl3945]
       [<c01e37f3>] pci_device_remove+0x19/0x39
       [<c0228874>] __device_release_driver+0x60/0x7d
       [<c0228cc3>] driver_detach+0xa2/0xe3
       [<c02282a6>] bus_remove_driver+0x63/0x7f
       [<c0228d50>] driver_unregister+0x2a/0x2e
       [<c01e39ac>] pci_unregister_driver+0x21/0x64
       [<dca5e520>] iwl3945_exit+0x1c/0x23 [iwl3945]
       [<c0143e93>] sys_delete_module+0x186/0x1cb
       [<c0104a5e>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by rmmod/5589:
 #0:  (rtnl_mutex){--..}, at: [<c02507ee>] rtnl_lock+0xf/0x11

stack backtrace:
Pid: 5589, comm: rmmod Not tainted 2.6.25-rc8-wl #23
 [<c013a890>] print_circular_bug_tail+0x5b/0x66
 [<c013a1da>] ? print_circular_bug_entry+0x39/0x43
 [<c013c195>] __lock_acquire+0x8ec/0xb72
 [<c013c47e>] lock_acquire+0x63/0x80
 [<c012deec>] ? flush_workqueue+0x0/0x80
 [<c012df2b>] flush_workqueue+0x3f/0x80
 [<c012deec>] ? flush_workqueue+0x0/0x80
 [<dca1ca89>] ieee80211_stop+0x2a5/0x366 [mac80211]
 [<c02b43be>] ? _spin_unlock_bh+0x2f/0x32
 [<c0248266>] dev_close+0x45/0x5d
 [<c02482f6>] rollback_registered+0x78/0xf3
 [<c02483a8>] unregister_netdevice+0x37/0x73
 [<dca27285>] __ieee80211_if_del+0x15/0x18 [mac80211]
 [<dca1c382>] ieee80211_unregister_hw+0x72/0x125 [mac80211]
 [<dca5e7c1>] iwl3945_pci_remove+0x29a/0x311 [iwl3945]
 [<c01e37f3>] pci_device_remove+0x19/0x39
 [<c0228874>] __device_release_driver+0x60/0x7d
 [<c0228cc3>] driver_detach+0xa2/0xe3
 [<c02282a6>] bus_remove_driver+0x63/0x7f
 [<c0228d50>] driver_unregister+0x2a/0x2e
 [<c01e39ac>] pci_unregister_driver+0x21/0x64
 [<dca5e520>] iwl3945_exit+0x1c/0x23 [iwl3945]
 [<c0143e93>] sys_delete_module+0x186/0x1cb
 [<c0133ab4>] ? up_read+0x16/0x2a
 [<c0104b47>] ? restore_nocheck+0x12/0x15
 [<c0104a5e>] sysenter_past_esp+0x5f/0xa5
 =======================
