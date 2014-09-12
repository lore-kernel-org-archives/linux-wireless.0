Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39686 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaILGkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 02:40:24 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3.18] ath9k: Fix beacon processing in offchannel
Date: Fri, 12 Sep 2014 12:10:48 +0530
Message-Id: <1410504048-14904-1-git-send-email-sujith@msujith.org> (sfid-20140912_084028_180717_E977B7B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When interfaces of different types are present
in a context and an offchannel request is received
on a STA interface, we end up trying to process
beacons received when we are offchannel. This hits
the below warning since offchannel will not have proper
beacon parameters.

Fix this by not processing beacons received when we
are offchannel.

------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at ../drivers/net/wireless/ath/ath9k/recv.c:552 ath_rx_tasklet+0xf8f/0x1020 [ath9k]()
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G           O   3.17.0-rc4-wl-debug #16
Hardware name: LENOVO 28427ZQ/INVALID, BIOS 6JET58WW (1.16 ) 09/17/2009
 0000000000000000 15916787056abba3 ffff88013b603d08 ffffffff8156af94
 ffff88013b603d50 ffff88013b603d40 ffffffff81070dbd ffff8800a84bb300
 ffff8800b05db358 ffff8800a84cc578 ffff8800a84bb300 ffff8800b05daa40
Call Trace:
 <IRQ>  [<ffffffff8156af94>] dump_stack+0x4d/0x6f
 [<ffffffff81070dbd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81070e3c>] warn_slowpath_fmt+0x5c/0x80
 [<ffffffff81572143>] ? _raw_spin_lock_irqsave+0x83/0xa0
 [<ffffffffa09d04a6>] ? ath_rx_tasklet+0x9f6/0x1020 [ath9k]
 [<ffffffffa09d0a3f>] ath_rx_tasklet+0xf8f/0x1020 [ath9k]
 [<ffffffffa09cd4f4>] ath9k_tasklet+0xf4/0x310 [ath9k]
 [<ffffffff81075a97>] tasklet_action+0xe7/0xf0
 [<ffffffff8107508a>] __do_softirq+0x12a/0x340
 [<ffffffff8107544e>] irq_exit+0x9e/0xc0
 [<ffffffff81575e56>] do_IRQ+0x56/0xe0
 [<ffffffff81573c72>] common_interrupt+0x72/0x72
 <EOI>  [<ffffffff81421037>] ? cpuidle_enter_state+0x67/0x1a0
 [<ffffffff81421257>] cpuidle_enter+0x17/0x20
 [<ffffffff810b3ebe>] cpu_startup_entry+0x3ce/0x420
 [<ffffffff81048563>] start_secondary+0x233/0x2c0
---[ end trace f15c3e33ba78d840 ]---
------------[ cut here ]------------

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 957a877..dea8e1b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -537,6 +537,7 @@ static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
 static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	bool skip_beacon = false;
 
 	if (skb->len < 24 + 8 + 2 + 2)
 		return;
@@ -547,7 +548,14 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_dbg(common, PS,
 			"Reconfigure beacon timers based on synchronized timestamp\n");
-		if (!(WARN_ON_ONCE(sc->cur_chan->beacon.beacon_interval == 0)))
+
+		if (ath9k_is_chanctx_enabled()) {
+			if (sc->cur_chan == &sc->offchannel.chan)
+				skip_beacon = true;
+		}
+
+		if (!skip_beacon &&
+		    !(WARN_ON_ONCE(sc->cur_chan->beacon.beacon_interval == 0)))
 			ath9k_set_beacon(sc);
 
 		ath9k_p2p_beacon_sync(sc);
-- 
2.1.0

