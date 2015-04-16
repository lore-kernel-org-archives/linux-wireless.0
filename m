Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55633 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbDPCYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 22:24:19 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<kvalo@qca.qualcomm.com>, Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix soft lockup - CPU stuck
Date: Thu, 16 Apr 2015 10:24:10 +0800
Message-ID: <1429151050-22488-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150416_042423_459299_2F2229E6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

BUG: soft lockup - CPU#0 stuck for 22s! [hostapd:965]
CPU: 0 PID: 965 Comm: hostapd Not tainted 3.14.0 #1
task: 82e29c40 ti: 82fb2000 task.ti: 82fb2000
$ 0   : 00000000 00000000 83281f90 00004018
$ 4   : 832a0010 b810403c 00004030 00000600
$ 8   : 8036a980 ffd23940 00000000 00000000
$12   : 00000060 00000007 00000000 0000000c
$16   : 832a0010 00023f40 00000002 00000000
$20   : 832a0010 832a0298 832ba994 832bb83c
$24   : 00000002 800aa2d4
$28   : 82fb2000 82fb3c08 832bbf0c 8339edc4
Hi    : 00000006
Lo    : 009b9500
epc   : 8339ede0 ath9k_hw_enable_interrupts+0xf8/0x194 [ath9k_hw]
Not tainted
ra    : 8339edc4 ath9k_hw_enable_interrupts+0xdc/0x194 [ath9k_hw]
Status: 1000fc03	KERNEL EXL IE
Cause : 5080d400
PrId  : 00019374 (MIPS 24Kc)
	Kernel panic - not syncing: softlockup: hung tasks

The original intention of commit e3f31175a3("ath9k: fix race condition
in irq processing during hardware reset") is to avoid the IRQ storms,it
disabled the IRQ entirely for the duration of the reset, but it introducted
a new IRQ storms in handle_level_irq() when call ath9k_hw_enable_interrupts(),
meanwhile the irq is disabled by disable_irq(). Remove disable_irq/enable_irq
paire, instead of diabling tasklet to re-enable IRQ during the reset.

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b0badef..06560b5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -285,7 +285,6 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 	__ath_cancel_work(sc);
 
-	disable_irq(sc->irq);
 	tasklet_disable(&sc->intr_tq);
 	tasklet_disable(&sc->bcon_tasklet);
 	spin_lock_bh(&sc->sc_pcu_lock);
@@ -332,7 +331,6 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 		r = -EIO;
 
 out:
-	enable_irq(sc->irq);
 	spin_unlock_bh(&sc->sc_pcu_lock);
 	tasklet_enable(&sc->bcon_tasklet);
 	tasklet_enable(&sc->intr_tq);
@@ -475,7 +473,8 @@ void ath9k_tasklet(unsigned long data)
 	ath9k_btcoex_handle_interrupt(sc, status);
 
 	/* re-enable hardware interrupt */
-	ath9k_hw_enable_interrupts(ah);
+	if (!test_bit(ATH_OP_HW_RESET, &common->op_flags))
+		ath9k_hw_enable_interrupts(ah);
 out:
 	spin_unlock(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
@@ -603,8 +602,8 @@ int ath_reset(struct ath_softc *sc, struct ath9k_channel *hchan)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int r;
 
-	ath9k_hw_kill_interrupts(sc->sc_ah);
 	set_bit(ATH_OP_HW_RESET, &common->op_flags);
+	ath9k_hw_kill_interrupts(sc->sc_ah);
 
 	ath9k_ps_wakeup(sc);
 	r = ath_reset_internal(sc, hchan);
@@ -624,8 +623,8 @@ void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
 #ifdef CONFIG_ATH9K_DEBUGFS
 	RESET_STAT_INC(sc, type);
 #endif
-	ath9k_hw_kill_interrupts(sc->sc_ah);
 	set_bit(ATH_OP_HW_RESET, &common->op_flags);
+	ath9k_hw_kill_interrupts(sc->sc_ah);
 	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 }
 
-- 
1.9.1

