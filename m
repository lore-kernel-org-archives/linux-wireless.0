Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45661 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEVIlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 04:41:08 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath9k: fix sleep timer during suspend
Date: Thu, 22 May 2014 14:11:41 +0530
Message-ID: <1400748101-1832-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140522_104113_500236_F1F86263)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On idle state, sleep timer is scheduled to put the chip into fullsleep.
But during suspend, this timer is scheduled after the chip is moved to
fullsleep forcibily. This is causing below unnecessary error messages
in kernel log during suspend.

ath: phy2: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000
!= 0x00000000
ath: phy2: RX failed to go idle in 10 ms RXSM=0xdeadbeef
ath: phy2: DMA failed to stop in 10 ms AR_CR=0xdeadbeef AR_DIAG_SW=0xdeadbeef
DMADBG_7=0xdeadbeef

Reported-by: Arkh4mKn1ght <arkh4mkn1ght@gmail.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c1e82f7..4dec09e 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -914,6 +914,7 @@ static int ath_pci_suspend(struct device *device)
 	 */
 	ath9k_stop_btcoex(sc);
 	ath9k_hw_disable(sc->sc_ah);
+	del_timer_sync(&sc->sleep_timer);
 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
 
 	return 0;
-- 
1.9.3

