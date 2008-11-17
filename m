Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13163 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYKRIV0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 03:21:26 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 18 Nov 2008 00:21:26 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>
Subject: [PATCH] ath9k: Fix panic while unregistering rfkill
Date: Tue, 18 Nov 2008 01:19:56 +0530
Message-ID: <1226951396-3872-1-git-send-email-vasanth@atheros.com> (sfid-20081118_092131_385213_1A4732DD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 [ 6133.670329] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
 [ 6133.672802] IP: [<ffffffffa030fcf6>] ieee80211_stop_queues+0x26/0x40 [mac80211]
 [ 6133.672802] PGD 759dc067 PUD 74f1d067 PMD 0
 [ 6133.672802] Oops: 0002 [#1] PREEMPT SMP
 [ 6133.672802] last sysfs file: /sys/class/backlight/acpi_video0/brightness
 [ 6133.672802] CPU 0
 [ 6133.672802] Modules linked in: ath9k(-) mac80211 pciehp pci_hotplug arc4 ecb joydev pcmcia ppdev lp ppp_generic psmouse sg pcspkr s]
 [ 6133.735830] Pid: 4445, comm: rmmod Tainted: G        W  2.6.28-rc5-wl #1
 [ 6133.735830] RIP: 0010:[<ffffffffa030fcf6>]  [<ffffffffa030fcf6>] ieee80211_stop_queues+0x26/0x40 [mac80211]
 [ 6133.735830] RSP: 0018:ffff88007d1efd10  EFLAGS: 00010246
 [ 6133.735830] RAX: 0000000000000000 RBX: ffff880074f41aa0 RCX: 0000000000000000
 [ 6133.735830] RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff880074f40340
 [ 6133.735830] RBP: ffff880074990000 R08: 0000000000000000 R09: 000000000000224d
 [ 6133.735830] R10: 0000000000000000 R11: ffffffff8031dc70 R12: 0000000000000000
 [ 6133.735830] R13: 0000000000000001 R14: ffff880074f46c9c R15: 0000000000000000
 [ 6133.735830] FS:  00007f1e2e0bc6f0(0000) GS:ffffffff805e0b80(0000) knlGS:0000000000000000
 [ 6133.735830] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 [ 6133.735830] CR2: 0000000000000010 CR3: 0000000075593000 CR4: 00000000000006e0
 [ 6133.735830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 6133.735830] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 [ 6133.735830] Process rmmod (pid: 4445, threadinfo ffff88007d1ee000, task ffff88007c0c8000)
 [ 6133.735830] Stack:
 [ 6133.735830]  ffffffffa034d583 ffff88007c7d9410 ffff88007c7d9410 ffff88007c7d9410
 [ 6133.735830]  ffffffff80481dab ffff880074f41aa0 00000000fffffff0 0000000000000000
 [ 6133.735830]  0000000000000001 0000000000000001 ffffffffa034d8a5 ffff88007c7d9400
 [ 6133.735830] Call Trace:
 [ 6133.735830]  [<ffffffffa034d583>] ? ath_radio_disable+0x33/0x150 [ath9k]
 [ 6133.735830]  [<ffffffff80481dab>] ? __mutex_lock_slowpath+0x20b/0x2a0
 [ 6133.735830]  [<ffffffffa034d8a5>] ? ath_sw_toggle_radio+0x65/0xa0 [ath9k]
 [ 6133.735830]  [<ffffffffa019d1f4>] ? rfkill_toggle_radio+0x74/0x140 [rfkill]
 [ 6133.735830]  [<ffffffffa019d597>] ? rfkill_remove_switch+0x67/0x80 [rfkill]
 [ 6133.735830]  [<ffffffffa019d955>] ? rfkill_unregister+0x25/0x50 [rfkill]
 [ 6133.735830]  [<ffffffffa034bf75>] ? ath_detach+0xf5/0x140 [ath9k]
 [ 6133.735830]  [<ffffffffa034bfe9>] ? ath_pci_remove+0x29/0x80 [ath9k]
 [ 6133.735830]  [<ffffffff8035263c>] ? pci_device_remove+0x2c/0x60
 [ 6133.735830]  [<ffffffff803c3829>] ? __device_release_driver+0x99/0x100
 [ 6133.735830]  [<ffffffff803c3950>] ? driver_detach+0xc0/0xd0
 [ 6133.735830]  [<ffffffff803c296e>] ? bus_remove_driver+0x8e/0xd0
 [ 6133.735830]  [<ffffffff80352916>] ? pci_unregister_driver+0x36/0xa0
 [ 6133.735830]  [<ffffffffa0356ad4>] ? exit_ath_pci+0x10/0x29 [ath9k]
 [ 6133.735830]  [<ffffffff8026bb1b>] ? sys_delete_module+0x1cb/0x2d0
 [ 6133.735830]  [<ffffffff802960d9>] ? do_munmap+0x349/0x390
 [ 6133.735830]  [<ffffffff80342d01>] ? __up_write+0x21/0x150
 [ 6133.735830]  [<ffffffff8020c45b>] ? system_call_fastpath+0x16/0x1b
 [ 6133.735830] Code: c3 0f 1f 40 00 0f b7 57 5e 0f b7 47 5c 01 c2 74 30 31 c9 66 90 48 8b 57 78 0f b7 c1 48 c1 e0 07 48 03 82 00 03 00
 [ 6133.735830] RIP  [<ffffffffa030fcf6>] ieee80211_stop_queues+0x26/0x40 [mac80211]

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index b704b91..26ccfe1 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -697,13 +697,13 @@ static void ath_detach(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
 
-	ieee80211_unregister_hw(hw);
-
-	ath_deinit_leds(sc);
-
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	ath_deinit_rfkill(sc);
 #endif
+	ath_deinit_leds(sc);
+
+	ieee80211_unregister_hw(hw);
+
 	ath_rate_control_unregister();
 
 	ath_rx_cleanup(sc);
-- 
1.5.5.1

