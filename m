Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.fh-giessen.de ([212.201.18.42]:54920 "EHLO
        mout1.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752348AbcLLSu3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 13:50:29 -0500
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
To: kvalo@codeaurora.org, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        marc.zyngier@arm.com, Janusz.Dziedzic@tieto.com,
        rmanohar@qti.qualcomm.com, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, rmanohar@qca.qualcomm.com,
        bharat.kumar.gogada@xilinx.com
Cc: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Subject: [PATCH] ath9k: unlock rcu read when returning early
Date: Mon, 12 Dec 2016 19:50:01 +0100
Message-Id: <20161212185001.3857-1-tobias.johannes.klausmann@mni.thm.de> (sfid-20161212_195048_674213_585F6A48)
In-Reply-To: <1cFMHb-00BdWd-Ks>
References: <1cFMHb-00BdWd-Ks>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Starting with ath9k: use ieee80211_tx_status_noskb where possible
[d94a461d7a7df68991fb9663531173f60ef89c68] the driver uses rcu_read_lock() &&
rcu_read_unlock() yet on returning early in ath_tx_edma_tasklet() the unlock is
missing leading to stalls and suspicious RCU usage:

 ===============================
 [ INFO: suspicious RCU usage. ]
 4.9.0-rc8 #11 Not tainted
 -------------------------------
 kernel/rcu/tree.c:705 Illegal idle entry in RCU read-side critical section.!

 other info that might help us debug this:

 RCU used illegally from idle CPU!
 rcu_scheduler_active = 1, debug_locks = 0
 RCU used illegally from extended quiescent state!
 1 lock held by swapper/7/0:
 #0:
  (
 rcu_read_lock
 ){......}
 , at:
 [<ffffffffa06ed110>] ath_tx_edma_tasklet+0x0/0x450 [ath9k]

 stack backtrace:
 CPU: 7 PID: 0 Comm: swapper/7 Not tainted 4.9.0-rc8 #11
 Hardware name: Acer Aspire V3-571G/VA50_HC_CR, BIOS V2.21 12/16/2013
  ffff88025efc3f38 ffffffff8132b1e5 ffff88017ede4540 0000000000000001
  ffff88025efc3f68 ffffffff810a25f7 ffff88025efcee60 ffff88017edebdd8
  ffff88025eeb5400 0000000000000091 ffff88025efc3f88 ffffffff810c3cd4
 Call Trace:
  <IRQ>
  [<ffffffff8132b1e5>] dump_stack+0x68/0x93
  [<ffffffff810a25f7>] lockdep_rcu_suspicious+0xd7/0x110
  [<ffffffff810c3cd4>] rcu_eqs_enter_common.constprop.85+0x154/0x200
  [<ffffffff810c5a54>] rcu_irq_exit+0x44/0xa0
  [<ffffffff81058631>] irq_exit+0x61/0xd0
  [<ffffffff81018d25>] do_IRQ+0x65/0x110
  [<ffffffff81672189>] common_interrupt+0x89/0x89
  <EOI>
  [<ffffffff814ffe11>] ? cpuidle_enter_state+0x151/0x200
  [<ffffffff814ffee2>] cpuidle_enter+0x12/0x20
  [<ffffffff8109a6ae>] call_cpuidle+0x1e/0x40
  [<ffffffff8109a8f6>] cpu_startup_entry+0x146/0x220
  [<ffffffff810336f8>] start_secondary+0x148/0x170

Signed-off-by: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 52bfbb988611..857d5ae09a1d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2787,6 +2787,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		fifo_list = &txq->txq_fifo[txq->txq_tailidx];
 		if (list_empty(fifo_list)) {
 			ath_txq_unlock(sc, txq);
+			rcu_read_unlock();
 			return;
 		}
 
-- 
2.11.0
