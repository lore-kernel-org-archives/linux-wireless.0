Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41236 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934127AbdEOS0M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 14:26:12 -0400
To: ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: BUG related to NAPI and ath10k in 4.9 + hacks kernel.
Message-ID: <ea83250f-03d0-c07e-b2a1-09717724f40e@candelatech.com> (sfid-20170515_202616_668792_3B6784E4)
Date: Mon, 15 May 2017 11:26:11 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is from a test system running my hacked 4.9 kernel, with 9888 ath10k
NIC which often fails during startup.  The firmware did fail to boot this time,
and maybe it left things in a weird state.  Then, the whole OS crashed with BUG.


------------[ cut here ]------------
kernel BUG at /home/greearb/git/linux-4.9.dev.y/include/linux/netdevice.h:515!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: nf_conntrack_netlink nf_conntrack nfnetlink nf_defrag_ipv4 bridge ath10k_pci ath10k_core 8021q garp mrp stp llc bnep bluetooth fuse macv]
CPU: 1 PID: 3651 Comm: wpa_supplicant Not tainted 4.9.27+ #35
Hardware name: To be filled by O.E.M. To be filled by O.E.M./ChiefRiver, BIOS 4.6.5 06/07/2013
task: ffff8802111f0000 task.stack: ffffc90001fb4000
RIP: 0010:[<ffffffffa1498d33>]  [<ffffffffa1498d33>] ath10k_pci_hif_power_up+0x173/0x180 [ath10k_pci]
RSP: 0018:ffffc90001fb7c30  EFLAGS: 00010246
RAX: 0000000000000008 RBX: ffff880212bc2bc0 RCX: 0000000000082004
RDX: ffffc9000d282000 RSI: ffffc9000d282000 RDI: 000000000fd0a000
RBP: ffffc90001fb7c40 R08: 0000000000200000 R09: 0000000000000101
R10: 0000000000000d00 R11: 0000000000000003 R12: 0000000000082000
R13: ffff880212beaef8 R14: 0000000000000000 R15: ffff8802134c1118
FS:  00007f476575c800(0000) GS:ffff88021e240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3da950b490 CR3: 0000000212b5a000 CR4: 00000000001406e0
Stack:
  ffff880212bc2bc0 ffff880212bc0700 ffffc90001fb7c68 ffffffffa1429281
  ffff8802134c0000 ffff880212bc0700 0000000000000000 ffffc90001fb7c90
  ffffffffa07cb818 ffff8802134c0000 ffff880212bc0700 0000000000000000
Call Trace:
  [<ffffffffa1429281>] ath10k_start+0x51/0x5c0 [ath10k_core]
  [<ffffffffa07cb818>] drv_start+0x38/0x140 [mac80211]
  [<ffffffffa07e2cc5>] ieee80211_do_open+0x2c5/0x990 [mac80211]
  [<ffffffffa07e33e0>] ieee80211_open+0x50/0x60 [mac80211]
  [<ffffffff817a9f2a>] __dev_open+0xaa/0x120
  [<ffffffff817aa208>] __dev_change_flags+0x98/0x160
  [<ffffffff817aa2f4>] dev_change_flags+0x24/0x60
  [<ffffffff8182388e>] devinet_ioctl+0x5ee/0x6c0
  [<ffffffff8182535b>] inet_ioctl+0x4b/0x70
  [<ffffffff81787430>] sock_do_ioctl+0x20/0x50
  [<ffffffff81787936>] sock_ioctl+0x1d6/0x2a0
  [<ffffffff8128d24b>] do_vfs_ioctl+0x8b/0x5b0
  [<ffffffff8178adbd>] ? __sys_recvmsg+0x3d/0x70
  [<ffffffff8128d7e4>] SyS_ioctl+0x74/0x80
  [<ffffffff8188a83b>] entry_SYSCALL_64_fastpath+0x1e/0xad
Code: ff ff ff 89 c2 48 89 df 48 c7 c6 10 d3 49 a1 e8 34 1d f9 ff 48 89 df e8 2c f9 ff ff 44 89 e0 c6 83 0e 74 02 00 01 5b 41 5c 5d c3 <0f> 0b 66 66 2e 0f
RIP  [<ffffffffa1498d33>] ath10k_pci_hif_power_up+0x173/0x180 [ath10k_pci]
  RSP <ffffc90001fb7c30>
---[ end trace b6dede286ed70e39 ]---


The BUG in question is this:

/**
  *      napi_enable - enable NAPI scheduling
  *      @n: NAPI context
  *
  * Resume NAPI from being scheduled on this context.
  * Must be paired with napi_disable.
  */
static inline void napi_enable(struct napi_struct *n)
{
         BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
         smp_mb__before_atomic();
         clear_bit(NAPI_STATE_SCHED, &n->state);
         clear_bit(NAPI_STATE_NPSVC, &n->state);
}


Any ideas what might be the cause of this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
