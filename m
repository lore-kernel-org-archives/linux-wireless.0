Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59836 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3JKXvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 19:51:47 -0400
Message-ID: <52588F0C.3000009@candelatech.com> (sfid-20131012_015150_715703_12185166)
Date: Fri, 11 Oct 2013 16:51:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath10k related kernel crash in wireless-testing (3.12.0-rc3-wl+)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My kernel is lightly patched, no patches to ath10k.

Looks like something is not checking a NULL pointer, but I did
not dig into the code.  I'm not actually running any traffic on
the ath10k device.


ath10k: Completion buffers are full
ath10k: Completion buffers are full
ath10k: MSI-X interrupt handling (8 intrs)
e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
ath10k: UART prints disabled
ath10k: firmware 1.0.0.636 booted
ath10k: htt target version 2.1

...

ath10k: Completion buffers are full
ath10k: Completion buffers are full
IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
8021q: adding VLAN 0 to HW filter on device eth1
IPv6: ADDRCONF(NETDEV_UP): sta0: link is not ready
IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
IPv6: ADDRCONF(NETDEV_UP): sta0: link is not ready
IPv6: ADDRCONF(NETDEV_UP): sta0: link is not ready
ath10k: MSI-X interrupt handling (8 intrs)
ath10k: Unable to wakeup target
ath10k: target took longer 5000 us to wake up (awake count 1)
ath10k: Failed to get pcie state addr: -16
ath10k: early firmware event indicated
BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffffa06ae46c>] ath10k_ce_completed_send_next+0x47/0x122 [ath10k_pci]
PGD d1f5b067 PUD d9c1c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs fscache nf_nat_ipv4 nf_nat 8021q ga]
CPU: 1 PID: 17 Comm: ksoftirqd/1 Tainted: G         C   3.12.0-rc3-wl+ #10
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
task: ffff8802160fdd80 ti: ffff880216306000 task.ti: ffff880216306000
RIP: 0010:[<ffffffffa06ae46c>]  [<ffffffffa06ae46c>] ath10k_ce_completed_send_next+0x47/0x122 [ath10k_pci]
RSP: 0018:ffff880216307c98  EFLAGS: 00010246
RAX: 0000000000005b5b RBX: ffff88020bfbfc50 RCX: 0000000000057400
RDX: ffff88020c7e5f20 RSI: ffff880216307d10 RDI: ffff88020bfbfc48
RBP: ffff880216307cf8 R08: ffff880216307d1c R09: ffff8800d967d438
R10: ffff88021fa92ff0 R11: 0000000000000001 R12: ffff880216307d10
R13: ffff880216307d24 R14: ffff880216307d20 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88021fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000004 CR3: 00000000d1c76000 CR4: 00000000000407e0
Stack:
  ffff880216307cc8 ffff8802160fdde8 ffff88021fa92ff0 ffff880216307d1c
  ffff88020bfbfc48 ffff88021fa92ff0 ffff880216307d08 ffff88020c7e5f20
  ffff88020bfbf800 0000000000000000 ffff88020bfbfc48 0000000000057430
Call Trace:
  [<ffffffffa06ab568>] ath10k_pci_bmi_send_done+0x1d/0x32 [ath10k_pci]
  [<ffffffff810a4915>] ? local_bh_enable_ip+0x9/0xb
  [<ffffffff8158e801>] ? _raw_spin_unlock_bh+0x1f/0x21
  [<ffffffffa06ae357>] ath10k_ce_per_engine_service+0xab/0xea [ath10k_pci]
  [<ffffffffa06ab3b4>] ath10k_pci_ce_tasklet+0x15/0x17 [ath10k_pci]
  [<ffffffff810a3e3e>] tasklet_action+0x78/0xc6
  [<ffffffff810a463c>] __do_softirq+0xc4/0x19d
  [<ffffffff810a4738>] run_ksoftirqd+0x23/0x42
  [<ffffffff810c0ea3>] smpboot_thread_fn+0x21e/0x223
  [<ffffffff810c0c85>] ? smpboot_create_threads+0x61/0x61
  [<ffffffff810ba54d>] kthread+0xb0/0xb8
  [<ffffffff810ba49d>] ? kthread_freezable_should_stop+0x5b/0x5b
  [<ffffffff815939cc>] ret_from_fork+0x7c/0xb0
  [<ffffffff810ba49d>] ? kthread_freezable_should_stop+0x5b/0x5b
Code: 38 4c 89 45 b8 48 8b 07 48 8b 80 a0 01 00 00 48 05 48 04 00 00 48 89 c7 48 89 45 c0 e8 b6 07 ee e0
RIP  [<ffffffffa06ae46c>] ath10k_ce_completed_send_next+0x47/0x122 [ath10k_pci]
  RSP <ffff880216307c98>
CR2: 0000000000000004
---[ end trace 6b10a0163cca0cc3 ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

