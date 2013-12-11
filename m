Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51553 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3LKMMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 07:12:38 -0500
Received: from [50.54.140.2] (50-54-140-2.evrt.wa.frontiernet.net [50.54.140.2])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id rBBCCbOk021232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 04:12:38 -0800
Message-ID: <52A856B5.2060700@candelatech.com> (sfid-20131211_131242_996754_505DF50D)
Date: Wed, 11 Dec 2013 04:12:37 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Kernel crash related to scan in 3.13-rc3-wl-ath+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a few patches to ath10k, and one patch to mac80211 that adds
an sdata_info() message, but no other patches.  I'm running a few
station interfaces on ath10k, they were not doing a good job of
getting DHCP lease and were being bounced by user-space app
periodically.


Bug that hit was this:

static inline
struct cfg80211_registered_device *wiphy_to_dev(struct wiphy *wiphy)
{
	BUG_ON(!wiphy);
	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
}


IPv6: ADDRCONF(NETDEV_UP): sta330: link is not ready
------------[ cut here ]------------
kernel BUG at /mnt/sda/home/greearb/git/linux.ath/net/wireless/core.h:92!
invalid opcode: 0000 [#1] sta326: deauthenticating from 00:03:83:3d:30:ab by local choice (reason)
PREEMPT SMP
Modules linked in: ath10k_pci ath10k_core ath5k ath9k ath9k_common ath9k_hw nf_nat_ipv4 nf_nat ve]
CPU: 0 PID: 2982 Comm: kworker/u8:2 Tainted: G        WC   3.13.0-rc3-wl-ath+ #5
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
Workqueue: phy14 ieee80211_scan_work [mac80211]
task: ffff88020d0cc380 ti: ffff880034bfc000 task.ti: ffff880034bfc000
RIP: 0010:[<ffffffffa027e022>]  [<ffffffffa027e022>] wiphy_to_dev+0x9/0x14 [cfg80211]
RSP: 0018:ffff880034bfdce8  EFLAGS: 00010246
RAX: ffff88020d0cc380 RBX: ffff88020d7b76c0 RCX: 0000000100130006
RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff880034bfdce8 R08: ffff880217004b40 R09: 0000000000000000
R10: ffffffff00000008 R11: 0000000000000292 R12: ffff8800ca7f9d00
R13: ffff8802151d4c01 R14: ffff8800ca7f9c00 R15: ffff8800ca7f9c88
FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001f1e240 CR3: 0000000001a0d000 CR4: 00000000000407f0
Stack:
  ffff880034bfdd08 ffffffffa027e380 ffff8800ca7f88a0 ffff8800ca7f9d00
  ffff880034bfdd38 ffffffffa03cc7cb 0000000000000004 ffff8800ca7f88a0
  ffff8800ca7f9d50 ffff8802151d4ce0 ffff880034bfdd98 ffffffffa03cd532
Call Trace:
  [<ffffffffa027e380>] cfg80211_scan_done+0x16/0x5e [cfg80211]
  [<ffffffffa03cc7cb>] __ieee80211_scan_completed+0xd5/0x1ab [mac80211]
  [<ffffffffa03cd532>] ieee80211_scan_work+0x417/0x42e [mac80211]
  [<ffffffff810c01a9>] process_one_work+0x1d7/0x2fc
  [<ffffffff810c013f>] ? process_one_work+0x16d/0x2fc
  [<ffffffff810bd4e4>] ? spin_lock_irq+0x9/0xb
  [<ffffffff810c06a1>] worker_thread+0x12e/0x1fb
  [<ffffffff810c0573>] ? rescuer_thread+0x27b/0x27b
  [<ffffffff810c5aca>] kthread+0xb5/0xbd
  [<ffffffff815a91e8>] ? _raw_spin_unlock_irq+0x28/0x42
  [<ffffffff810c5a15>] ? __kthread_parkme+0x5c/0x5c
  [<ffffffff815ae00c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810c5a15>] ? __kthread_parkme+0x5c/0x5c
Code: d6 48 8d 71 08 48 01 d0 4c 89 c1 48 89 c7 4c 89 c8 f3 a4 eb 0b 41 83 e8 04 be 04 00 00 00 e
RIP  [<ffffffffa027e022>] wiphy_to_dev+0x9/0x14 [cfg80211]
  RSP <ffff880034bfdce8>
---[ end trace 81847a827847ddaf ]---
BUG: unable to handle kernel paging request at ffffffffffffffa8
IP: [<ffffffff810c5f40>] kthread_data+0xb/0x11
PGD 1a10067 PUD 1a12067 PMD 0
Oops: 0000 [#2] PREEMPT SMP
Modules linked in: ath10k_pci ath10k_core ath5k ath9k ath9k_common ath9k_hw nf_nat_ipv4 nf_nat ve]
CPU: 2 PID: 2982 Comm: kworker/u8:2 Tainted: G      D WC   3.13.0-rc3-wl-ath+ #5
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
task: ffff88020d0cc380 ti: ffff880034bfc000 task.ti: ffff880034bfc000
RIP: 0010:[<ffffffff810c5f40>]  [<ffffffff810c5f40>] kthread_data+0xb/0x11
RSP: 0018:ffff880034bfd998  EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff88021fb13ac0 RCX: ffff88021fb13b70
RDX: 0000000000000005 RSI: 0000000000000002 RDI: ffff88020d0cc380
RBP: ffff880034bfd998 R08: ffffffff81c5a300 R09: 000000000000b635
R10: ffffffff810dfbc6 R11: 000000000000b522 R12: 0000000000000002
R13: 0000000000000001 R14: 0000000000000002 R15: ffff88020d0cc370
FS:  0000000000000000(0000) GS:ffff88021fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000028 CR3: 0000000214c4d000 CR4: 00000000000407e0
Stack:
  ffff880034bfd9b8 ffffffff810c0b68 ffff88021fb13ac0 ffff88020d0cc798
  ffff880034bfda28 ffffffff815a52d0 ffff880034bfdfd8 ffff88020d0cc380
  0000000000013ac0 0000000000013ac0 ffff88020b44ce00 ffff88020d0cc380
Call Trace:
  [<ffffffff810c0b68>] wq_worker_sleeping+0xf/0x87
  [<ffffffff815a52d0>] __schedule+0x14a/0x5d8
  [<ffffffff815a5852>] schedule+0x6a/0x6c
  [<ffffffff810ad8ae>] do_exit+0x91f/0x921
  [<ffffffff815aa670>] oops_end+0xa9/0xb2
  [<ffffffff8100d0e5>] die+0x55/0x60
  [<ffffffff815aa0a0>] do_trap+0x69/0x135
  [<ffffffff8100af5b>] do_invalid_op+0x93/0x9c
  [<ffffffffa027e022>] ? wiphy_to_dev+0x9/0x14 [cfg80211]
  [<ffffffff810e0b49>] ? trace_hardirqs_off_caller+0x37/0xa6
  [<ffffffff812cda7d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
  [<ffffffff815a98e7>] ? restore_args+0x30/0x30
  [<ffffffff815af46e>] invalid_op+0x1e/0x30
  [<ffffffffa027e022>] ? wiphy_to_dev+0x9/0x14 [cfg80211]
  [<ffffffff81175c84>] ? kfree+0xbf/0xd1
  [<ffffffffa027e380>] cfg80211_scan_done+0x16/0x5e [cfg80211]
  [<ffffffffa03cc7cb>] __ieee80211_scan_completed+0xd5/0x1ab [mac80211]
  [<ffffffffa03cd532>] ieee80211_scan_work+0x417/0x42e [mac80211]
  [<ffffffff810c01a9>] process_one_work+0x1d7/0x2fc
  [<ffffffff810c013f>] ? process_one_work+0x16d/0x2fc
  [<ffffffff810bd4e4>] ? spin_lock_irq+0x9/0xb
  [<ffffffff810c06a1>] worker_thread+0x12e/0x1fb
  [<ffffffff810c0573>] ? rescuer_thread+0x27b/0x27b
  [<ffffffff810c5aca>] kthread+0xb5/0xbd
  [<ffffffff815a91e8>] ? _raw_spin_unlock_irq+0x28/0x42
  [<ffffffff810c5a15>] ? __kthread_parkme+0x5c/0x5c
  [<ffffffff815ae00c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810c5a15>] ? __kthread_parkme+0x5c/0x5c
Code: 65 48 8b 04 25 c0 c8 00 00 48 8b 80 c0 03 00 00 48 89 e5 5d 48 8b 40 98 48 c1 e8 02 83 e0 0
RIP  [<ffffffff810c5f40>] kthread_data+0xb/0x11
  RSP <ffff880034bfd998>
CR2: ffffffffffffffa8

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

