Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34469 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab0JOWvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 18:51:40 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath5k:  Properly initialize ath_common->cc_lock.
Date: Fri, 15 Oct 2010 15:51:32 -0700
Message-Id: <1287183092-3220-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, lockdep splats, at the least:

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 0, comm: swapper Not tainted 2.6.36-rc8-wl+ #32
Call Trace:
 [<c075d940>] ? printk+0xf/0x17
 [<c045507a>] register_lock_class+0x5a/0x29e
 [<c0456af5>] __lock_acquire+0xa2/0xb8c
 [<c0455be2>] ? mark_lock+0x1e/0x1de
 [<c041a540>] ? acpi_get_override_irq+0x85/0x8c
 [<c0455536>] ? trace_hardirqs_off+0xb/0xd
 [<c0457639>] lock_acquire+0x5a/0x78
 [<f8126835>] ? ath5k_ani_calibration+0x24/0x52b [ath5k]
 [<c075f6ed>] _raw_spin_lock_bh+0x20/0x2f
 [<f8126835>] ? ath5k_ani_calibration+0x24/0x52b [ath5k]
 [<f8126835>] ath5k_ani_calibration+0x24/0x52b [ath5k]
 [<c0438f99>] ? tasklet_action+0x3b/0xc6
 [<f8123c2b>] ath5k_tasklet_ani+0x18/0x22 [ath5k]
 [<c0438fd1>] tasklet_action+0x73/0xc6
 [<c043945f>] __do_softirq+0x86/0x111
 [<c0439520>] do_softirq+0x36/0x5a
 [<c0439659>] irq_exit+0x35/0x69
 [<c0403fb9>] do_IRQ+0x86/0x9a
 [<c04034ee>] common_interrupt+0x2e/0x40
 [<c045007b>] ? do_adjtimex+0x223/0x55e
 [<c0408245>] ? mwait_idle+0x5c/0x6c
 [<c040227f>] cpu_idle+0x4e/0x6b
 [<c074b6e9>] rest_init+0x8d/0x92
 [<c09758ea>] start_kernel+0x320/0x325
 [<c09750d0>] i386_start_kernel+0xd0/0xd7

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 f1ae75d... 8251946... M	drivers/net/wireless/ath/ath5k/base.c
 drivers/net/wireless/ath/ath5k/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index f1ae75d..8251946 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3580,6 +3580,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	common->ah = sc->ah;
 	common->hw = hw;
 	common->cachelsz = csz << 2; /* convert to bytes */
+	spin_lock_init(&common->cc_lock);
 
 	/* Initialize device */
 	ret = ath5k_hw_attach(sc);
-- 
1.7.2.2

