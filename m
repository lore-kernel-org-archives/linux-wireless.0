Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39571 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbYIVIwo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 04:52:44 -0400
Date: Mon, 22 Sep 2008 14:22:39 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
CC: Steven Noonan <steven@uplinklabs.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] ath9k: Fix IRQ nobody cared issue with ath9k
Message-ID: <20080922085239.GA6379@senthil-lnx.users.atheros.com> (sfid-20080922_105249_587608_D5CA7492)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IRQs should be disabled before calling free_irq. Also flush pending
IRQs. Pasted the kernel log message for reference.

kernel: irq 17: nobody cared (try booting with the "irqpoll" option)
kernel:  [<c0252d2c>] __report_bad_irq+0x2e/0x6f
kernel:  [<c0252f22>] note_interrupt+0x1b5/0x207
kernel:  [<c025258b>] ? handle_IRQ_event+0x21/0x48
kernel:  [<c02534cb>] handle_fasteoi_irq+0x8e/0xad
kernel:  [<c0205650>] do_IRQ+0x6c/0x84
kernel:  [<c020425f>] common_interrupt+0x23/0x28
kernel:  [<c034f6f6>] ? acpi_idle_enter_simple+0x198/0x205
kernel:  [<c044686c>] ? menu_select+0x5c/0x78
kernel:  [<c0445a95>] cpuidle_idle_call+0x59/0x89
kernel:  [<c02029d7>] cpu_idle+0xae/0xcf
kernel:  [<c0543102>] rest_init+0x4e/0x50
kernel:  =======================
kernel: handlers:
kernel: [<f88fdd26>] (ath_isr+0x0/0x13a [ath9k])
kernel: Disabling IRQ #17

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Tested-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/net/wireless/ath9k/core.c |    4 ++--
 drivers/net/wireless/ath9k/main.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index c262ef2..b23f51e 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -288,8 +288,6 @@ static int ath_stop(struct ath_softc *sc)
 	 * hardware is gone (invalid).
 	 */
 
-	if (!(sc->sc_flags & SC_OP_INVALID))
-		ath9k_hw_set_interrupts(ah, 0);
 	ath_draintxq(sc, false);
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_stoprecv(sc);
@@ -1183,6 +1181,8 @@ void ath_deinit(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s\n", __func__);
 
+	tasklet_kill(&sc->intr_tq);
+	tasklet_kill(&sc->bcon_tasklet);
 	ath_stop(sc);
 	if (!(sc->sc_flags & SC_OP_INVALID))
 		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 1ba1800..7c7b4bf 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1784,10 +1784,17 @@ static void ath_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
+	enum ath9k_int status;
 
-	if (pdev->irq)
+	if (pdev->irq) {
+		ath9k_hw_set_interrupts(sc->sc_ah, 0);
+		/* clear the ISR */
+		ath9k_hw_getisr(sc->sc_ah, &status);
+		sc->sc_flags |= SC_OP_INVALID;
 		free_irq(pdev->irq, sc);
+	}
 	ath_detach(sc);
+
 	pci_iounmap(pdev, sc->mem);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-- 
1.5.5

