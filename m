Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gosford.compton.nu ([217.169.17.27]:47071 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2F0SZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 14:25:28 -0400
From: Tom Hughes <tom@compton.nu>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	Tom Hughes <tom@compton.nu>
Subject: [PATCH] ath9k: fix panic caused by returning a descriptor we have queued for reuse
Date: Wed, 27 Jun 2012 18:21:15 +0100
Message-Id: <1340817675-26911-1-git-send-email-tom@compton.nu> (sfid-20120627_202532_228038_A539A3AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 3a2923e83c introduced a bug when a corrupt descriptor
is encountered - although the following descriptor is discarded
and returned to the queue for reuse the associated frame is
also returned for processing. This leads to a panic:

BUG: unable to handle kernel NULL pointer dereference at 000000000000003a
IP: [<ffffffffa02599a5>] ath_rx_tasklet+0x165/0x1b00 [ath9k]
Call Trace:
<IRQ>
[<ffffffff812d7fa0>] ? map_single+0x60/0x60
[<ffffffffa028f044>] ? ath9k_ioread32+0x34/0x90 [ath9k]
[<ffffffffa0292eec>] athk9k_tasklet+0xdc/0x160 [ath9k]
[<ffffffff8105e133>] tasklet_action+0x63/0xd0
[<ffffffff8105dbc0>] __do_softirq+0xc0/0x1e0
[<ffffffff8101a873>] ? native_sched_clock+0x13/0x80
[<ffffffff815f9d5c>] call_softirq+0x1c/0x30
[<ffffffff810151f5>] do_softirq+0x75/0xb0
[<ffffffff8105df95>] irq_exit+0xb5/0xc0
[<ffffffff815fa5b3>] do_IRQ+0x63/0xe0
[<ffffffff815f0cea>] common_interrupt+0x6a/0x6a
<EOI>
[<ffffffff8131840a>] ? intel_idle+0xea/0x150
[<ffffffff813183eb>] ? intel_idle+0xcb/0x150
[<ffffffff814a1db9>] cpuidle_enter+0x19/0x20
[<ffffffff814a23d9>] cpuidle_idle_call+0xa9/0x240
[<ffffffff8101c4bf>] cpu_idle+0xaf/0x120
[<ffffffff815cda8e>] rest_init+0x72/0x74
[<ffffffff81cf4c1a>] start_kernel+0x3b7/0x3c4
[<ffffffff81cf4662>] ? repair_env_string+0x5e/0x5e
[<ffffffff81cf4346>] x86_64_start_reservations+0x131/0x135
[<ffffffff81cf444a>] x86_64_start_kernel+0x100/0x10f

Making sure bf is cleared to NULL in this case restores the
old behaviour.

Signed-off-by: Tom Hughes <tom@compton.nu>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 05185fc..6a7dd26 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -658,9 +658,9 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
 			__skb_unlink(skb, &rx_edma->rx_fifo);
 			list_add_tail(&bf->list, &sc->rx.rxbuf);
 			ath_rx_edma_buf_link(sc, qtype);
-		} else {
-			bf = NULL;
 		}
+
+		bf = NULL;
 	}
 
 	*dest = bf;
-- 
1.7.10.2

