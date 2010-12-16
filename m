Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30988 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0LPDYU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 22:24:20 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 19:24:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] ath: fix NULL pointer dereference on reg_notifier()
Date: Wed, 15 Dec 2010 19:24:12 -0800
Message-ID: <1292469852-2987-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1292469852-2987-1-git-send-email-lrodriguez@atheros.com>
References: <1292469852-2987-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The reg_notifier() was recently updated as being capable of
having the request passed as NULL, fix ath to follow this API
change. Without this we end up oopsing:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffffa02fb8cb>] ath_reg_notifier_apply+0x5b/0xa0 [ath]
PGD b4c4c067 PUD b4c4d067 PMD 0
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1b.0/uevent
CPU 1
Modules linked in: <etc>
Pid: 436, comm: modprobe Not tainted 2.6.37-rc5-wl+ #36 6460DWU/6460DWU
RIP: 0010:[<ffffffffa02fb8cb>]  [<ffffffffa02fb8cb>] ath_reg_notifier_apply+0x5b/0xa0 [ath]
RSP: 0018:ffff8800b6f6baa8  EFLAGS: 00010246
RAX: ffff8800b527b254 RBX: ffff8800b532c180 RCX: 0000000000000018
RDX: ffff8800b530c108 RSI: 0000000000000000 RDI: ffff8800b532c180
RBP: ffff8800b6f6baa8 R08: ffff8800b532f268 R09: 0000000000000235
R10: 00000000000016ad R11: 0000000000000018 R12: 0000000000000000
R13: 0000000000000016 R14: ffff8800b532f268 R15: 0000000000000011
FS:  00007f0c53104700(0000) GS:ffff8800bed00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000004 CR3: 00000000b6531000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 436, threadinfo ffff8800b6f6a000, task ffff8800b404dc40)
Stack:
 ffff8800b6f6bac8 ffffffffa03ea651 ffff8800b532c180 ffff8800b527b254
 ffff8800b6f6bb38 ffffffffa01835ca ffffffffa019ed00 00000000a019ed80
 0000000000000002 ffff880000000002 ffffffffa0366140 0000000010aee572
Call Trace:
 [<ffffffffa03ea651>] ath9k_reg_notifier+0x41/0x50 [ath9k]
 [<ffffffffa01835ca>] wiphy_update_regulatory+0x4ba/0x5a0 [cfg80211]
 [<ffffffffa0366140>] ? ieee80211_register_hw+0xa0/0x5b0 [mac80211]
 [<ffffffffa0366140>] ? ieee80211_register_hw+0xa0/0x5b0 [mac80211]
 [<ffffffffa017f994>] wiphy_register+0x1d4/0x360 [cfg80211]
 [<ffffffff8114b918>] ? __kmalloc+0x108/0x1c0
 [<ffffffffa0366223>] ieee80211_register_hw+0x183/0x5b0 [mac80211]
 [<ffffffffa03eb49b>] ath9k_init_device+0x66b/0x850 [ath9k]
 [<ffffffffa03f9dd6>] ath_pci_probe+0x2f6/0x3c0 [ath9k]
 [<ffffffff81037529>] ? default_spin_lock_flags+0x9/0x10
 [<ffffffff812e19cf>] local_pci_probe+0x5f/0xd0
 [<ffffffff812e2bf1>] pci_device_probe+0x101/0x120
 [<ffffffff81390aca>] ? driver_sysfs_add+0x7a/0xb0
 [<ffffffff81390c26>] driver_probe_device+0x96/0x1c0
 [<ffffffff81390deb>] __driver_attach+0x9b/0xa0
 [<ffffffff81390d50>] ? __driver_attach+0x0/0xa0
 [<ffffffff81390008>] bus_for_each_dev+0x68/0x90
 [<ffffffff81390a4e>] driver_attach+0x1e/0x20
 [<ffffffff81390309>] bus_add_driver+0xe9/0x290
 [<ffffffffa0407000>] ? ath9k_init+0x0/0x4d [ath9k]
 [<ffffffff81391130>] driver_register+0x80/0x150
 [<ffffffffa0407000>] ? ath9k_init+0x0/0x4d [ath9k]
 [<ffffffffa0407000>] ? ath9k_init+0x0/0x4d [ath9k]
 [<ffffffff812e2e76>] __pci_register_driver+0x56/0xd0
 [<ffffffffa03f9ec3>] ath_pci_init+0x23/0x30 [ath9k]
 [<ffffffffa040702b>] ath9k_init+0x2b/0x4d [ath9k]
 [<ffffffff81002053>] do_one_initcall+0x43/0x190
 [<ffffffff8109fb5b>] sys_init_module+0xbb/0x200
 [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b
Code: <who even reads this anyway? haha, ok you do>
RIP  [<ffffffffa02fb8cb>] ath_reg_notifier_apply+0x5b/0xa0 [ath]
 RSP <ffff8800b6f6baa8>
CR2: 0000000000000004
---[ end trace 6d03d3c7eda9f06b ]---

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/regd.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 3f4244f..2b14775 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -342,6 +342,14 @@ int ath_reg_notifier_apply(struct wiphy *wiphy,
 	/* We always apply this */
 	ath_reg_apply_radar_flags(wiphy);
 
+	/*
+	 * This would happen when we have sent a custom regulatory request
+	 * a world regulatory domain and the scheduler hasn't yet processed
+	 * any pending requests in the queue.
+	 */
+	if (!request)
+		return 0;
+
 	switch (request->initiator) {
 	case NL80211_REGDOM_SET_BY_DRIVER:
 	case NL80211_REGDOM_SET_BY_CORE:
-- 
1.7.3.2.90.gd4c43

