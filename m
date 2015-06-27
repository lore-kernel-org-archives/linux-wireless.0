Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gosford.compton.nu ([217.169.17.27]:40889 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbF0QLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2015 12:11:22 -0400
Received: from bericote.compton.nu ([2001:8b0:bd:1:1881:14ff:fe46:3cc7]:52162 ident=tom)
	by bericote.compton.nu with esmtps (TLSv1.2:DHE-RSA-AES128-SHA:128)
	(Exim 4.85)
	(envelope-from <tom@compton.nu>)
	id 1Z8s7W-0000ZN-7x
	for linux-wireless@vger.kernel.org; Sat, 27 Jun 2015 16:34:18 +0100
To: linux-wireless@vger.kernel.org
From: Tom Hughes <tom@compton.nu>
Subject: Null pointer dereference when station associates
Message-ID: <558EC27A.60804@compton.nu> (sfid-20150627_181129_907073_7F8F41EE)
Date: Sat, 27 Jun 2015 16:34:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am encountering null pointer dereference when a station associates
with my Fedora 22 box which is running as an access point. Wireless
card is:

02:00.0 Network controller: Qualcomm Atheros AR928X Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Qualcomm Atheros Device 3099
	Kernel driver in use: ath9k
	Kernel modules: ath9k

relevant software:

hostapd-2.4-2.fc22.i686
kernel-PAE-core-4.0.4-301.fc22.i686
kernel-PAE-core-4.0.5-300.fc22.i686

The machine had been running under the 4.0.4 kernel for about a month
until it hit this error yesterday. Rebooting it came up in 4.0.5 and
each time it hit the error almost immediately. Going back to 4.0.4 it 
has been stable so far.

The actual trace, from the 4.0.5 kernel is:

Jun 26 14:51:00 gosford.compton.nu hostapd[820]: wlp2s0: STA cc:fa:00:aa:4e:59 IEEE 802.11: authentication OK (open system)
Jun 26 14:51:00 gosford.compton.nu hostapd[820]: wlp2s0: STA cc:fa:00:aa:4e:59 MLME: MLME-AUTHENTICATE.indication(cc:fa:00:aa:4e:59, OPEN_SYSTEM)
Jun 26 14:51:00 gosford.compton.nu hostapd[820]: wlp2s0: STA cc:fa:00:aa:4e:59 MLME: MLME-DELETEKEYS.request(cc:fa:00:aa:4e:59)
Jun 26 14:51:00 gosford.compton.nu hostapd[820]: wlp2s0: STA cc:fa:00:aa:4e:59 IEEE 802.11: authenticated
Jun 26 14:51:00 gosford.compton.nu hostapd[820]: wlp2s0: STA cc:fa:00:aa:4e:59 IEEE 802.11: association OK (aid 1)
Jun 26 14:51:00 gosford.compton.nu hostapd[820]: wlp2s0: STA cc:fa:00:aa:4e:59 IEEE 802.11: associated (aid 1)
Jun 26 14:51:00 gosford.compton.nu hostapd[820]: wlp2s0: STA cc:fa:00:aa:4e:59 MLME: MLME-ASSOCIATE.indication(cc:fa:00:aa:4e:59)
Jun 26 14:51:00 gosford.compton.nu hostapd[820]: wlp2s0: STA cc:fa:00:aa:4e:59 MLME: MLME-DELETEKEYS.request(cc:fa:00:aa:4e:59)
Jun 26 14:51:00 gosford.compton.nu kernel: BUG: unable to handle kernel NULL pointer dereference at 0000006c
Jun 26 14:51:00 gosford.compton.nu kernel: IP: [<c0a92202>] mutex_lock+0x12/0x30
Jun 26 14:51:00 gosford.compton.nu kernel: *pdpt = 0000000034070001 *pde = 0000000000000000 
Jun 26 14:51:00 gosford.compton.nu kernel: Oops: 0002 [#1] SMP 
Jun 26 14:51:00 gosford.compton.nu kernel: Modules linked in: 8021q garp mrp pppoe pppox ppp_generic slhc ip6t_REJECT nf_nat_ftp nf_reject_ipv6 nf_conntrack_ftp nf_log_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_MASQUERADE nf_log_ipv6 nf
Jun 26 14:51:00 gosford.compton.nu kernel: CPU: 1 PID: 820 Comm: hostapd Not tainted 4.0.5-300.fc22.i686+PAE #1
Jun 26 14:51:00 gosford.compton.nu kernel: Hardware name:                  /D945GSEJT             , BIOS JT94510H.86A.0025.2009.0306.1639 03/06/2009
Jun 26 14:51:00 gosford.compton.nu kernel: task: f6a2c080 ti: f41c2000 task.ti: f41c2000
Jun 26 14:51:00 gosford.compton.nu kernel: EIP: 0060:[<c0a92202>] EFLAGS: 00210286 CPU: 1
Jun 26 14:51:00 gosford.compton.nu kernel: EIP is at mutex_lock+0x12/0x30
Jun 26 14:51:00 gosford.compton.nu kernel: EAX: 0000006c EBX: 0000006c ECX: c0f66a68 EDX: 80000000
Jun 26 14:51:00 gosford.compton.nu kernel: ESI: f41c3716 EDI: f3e843e0 EBP: f41c36b4 ESP: f41c36b0
Jun 26 14:51:00 gosford.compton.nu kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jun 26 14:51:00 gosford.compton.nu kernel: CR0: 80050033 CR2: 0000006c CR3: 34102000 CR4: 000007f0
Jun 26 14:51:00 gosford.compton.nu kernel: Stack:
Jun 26 14:51:00 gosford.compton.nu kernel:  f47e1000 f41c36d0 c0678ab4 00000012 f41c3728 00000002 f3aa5000 f73a2540
Jun 26 14:51:00 gosford.compton.nu kernel:  f41c36f0 c0679203 f3aa5000 f73a2540 f3e843e0 f3aa5000 f73a2540 f3e843e0
Jun 26 14:51:00 gosford.compton.nu kernel:  f41c3738 f8a938ae f41c3716 00000012 f8ab0237 f3aa5620 00000001 f41c3716
Jun 26 14:51:00 gosford.compton.nu kernel: Call Trace:
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0678ab4>] start_creating+0x44/0xc0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0679203>] debugfs_create_dir+0x13/0xf0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f8a938ae>] ieee80211_sta_debugfs_add+0x6e/0x490 [mac80211]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f898a7a0>] ? ath9k_del_ps_key.isra.18+0x70/0x70 [ath9k]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f8a47084>] sta_info_insert_finish+0x514/0x830 [mac80211]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c049294d>] ? __enqueue_entity+0x6d/0x80
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0443b6f>] ? native_smp_send_reschedule+0x3f/0x60
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c048a838>] ? resched_curr+0x68/0xb0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f8990012>] ? ath_buf_set_rate+0x362/0x410 [ath9k]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c049533e>] ? update_curr+0x5e/0x190
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0492afa>] ? sched_slice.isra.50+0x4a/0xb0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0490a67>] ? __update_cpu_load+0xc7/0x100
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c048ca46>] ? scheduler_tick+0x86/0xc0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c04cb57a>] ? ktime_get+0x4a/0x120
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0445c8b>] ? lapic_next_event+0x1b/0x20
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c04d399d>] ? clockevents_program_event+0x8d/0x140
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c04d5619>] ? tick_program_event+0x29/0x30
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c04c67fd>] ? hrtimer_interrupt+0x11d/0x280
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c046abfe>] ? irq_exit+0x6e/0xb0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0446978>] ? smp_apic_timer_interrupt+0x38/0x50
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0a9507c>] ? apic_timer_interrupt+0x34/0x3c
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c059498d>] ? kmem_cache_alloc_trace+0x1bd/0x1f0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f8aa203d>] ? minstrel_ht_update_rates+0x8d/0xc0 [mac80211]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f8aa28a9>] ? minstrel_ht_update_caps+0x369/0x450 [mac80211]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f8a4792e>] sta_info_insert_rcu+0x5e/0xa0 [mac80211]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f8a5f87f>] ieee80211_add_station+0xbf/0x2e0 [mac80211]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f8930ae5>] nl80211_new_station+0x355/0x3d0 [cfg80211]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<f892b140>] ? nl80211_new_key+0x250/0x250 [cfg80211]
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c09c4f69>] genl_rcv_msg+0x219/0x390
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c09c3f41>] ? netlink_unicast+0x151/0x1b0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c09c4d50>] ? genl_rcv+0x30/0x30
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c09c46fe>] netlink_rcv_skb+0x8e/0xb0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c09c4d41>] genl_rcv+0x21/0x30
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c09c3efe>] netlink_unicast+0x10e/0x1b0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c09c43fd>] netlink_sendmsg+0x45d/0x5c0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c097ceb3>] do_sock_sendmsg+0x83/0xa0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c097e937>] ___sys_sendmsg+0x1e7/0x240
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c097dce0>] ? sock_poll+0x100/0x100
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05be6d2>] ? __d_alloc+0x22/0x130
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c059498d>] ? kmem_cache_alloc_trace+0x1bd/0x1f0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0697f82>] ? selinux_file_alloc_security+0x32/0x50
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0697f82>] ? selinux_file_alloc_security+0x32/0x50
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0697f82>] ? selinux_file_alloc_security+0x32/0x50
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c068e8b4>] ? security_file_alloc+0x14/0x20
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05c24f2>] ? __fdget+0x12/0x20
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c097f334>] __sys_sendmsg+0x44/0x80
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c097ffce>] SYSC_socketcall+0x7fe/0x9c0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05557f8>] ? ondemand_readahead+0x188/0x240
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c055592a>] ? page_cache_async_readahead+0x7a/0x90
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c054bdbd>] ? filemap_fault+0xcd/0x460
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c097cce8>] ? sock_destroy_inode+0x28/0x30
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c097cce8>] ? sock_destroy_inode+0x28/0x30
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05c083f>] ? destroy_inode+0x2f/0x60
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05c0946>] ? evict+0xd6/0x150
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05bc694>] ? dentry_free+0x44/0x90
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05bc694>] ? dentry_free+0x44/0x90
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05bd1c8>] ? dput+0x1b8/0x1f0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05c4c00>] ? mntput+0x20/0x40
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c05a8598>] ? __fput+0x158/0x1d0
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0980263>] SyS_socketcall+0x13/0x20
Jun 26 14:51:01 gosford.compton.nu kernel:  [<c0a9475f>] sysenter_do_call+0x12/0x12
Jun 26 14:51:01 gosford.compton.nu kernel: Code: 00 00 c3 8d b6 00 00 00 00 31 c0 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 53 3e 8d 74 26 00 89 c3 e8 40 ef ff ff 89 d8 <f0> ff 08 79 05 e8 14 07 00 00 64 a1 98 00 e9 c0 89 43 1
Jun 26 14:51:01 gosford.compton.nu kernel: EIP: [<c0a92202>] mutex_lock+0x12/0x30 SS:ESP 0068:f41c36b0
Jun 26 14:51:01 gosford.compton.nu kernel: CR2: 000000000000006c
Jun 26 14:51:01 gosford.compton.nu kernel: ---[ end trace c87c66d31a89c7e4 ]---
Jun 26 14:51:01 gosford.compton.nu systemd[1]: hostapd.service: main process exited, code=killed, status=9/KILL
Jun 26 14:51:01 gosford.compton.nu systemd[1]: Unit hostapd.service entered failed state.

Looking at the code, it seems it faulted in start_creating in the
debugfs code because d_inode(parent) was null when it tried to lock
the inode's mutex.

Interestingly from what I can see this is trying to create a file
for the station at a path something like:

ieee80211/phy0/netdev:XXXX/stations/XXXXXX

but in my (currently working) boot under 4.0.4 there is no netdev
directory under phy0 in debugfs... but then maybe that is the problem
as well if the inode pointer was null?

I'm assuming this is actually a mac80211 problem rather than a debugfs
problem for now, which is why I'm seeking help here.

Tom

-- 
Tom Hughes (tom@compton.nu)
http://compton.nu/
