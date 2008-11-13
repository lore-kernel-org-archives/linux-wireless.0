Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16858 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbYKMMal (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 07:30:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 04:30:41 -0800
Date: Thu, 13 Nov 2008 18:00:37 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <jouni.malinen@atheros.com>,
	<lrodriguez@atheros.com>
Subject: [PATCH 04/05] ath9k: IRQ should be disabled before calling
	free_irq()
Message-ID: <20081113123037.GE7688@senthil-lnx.users.atheros.com> (sfid-20081113_133044_075787_357B32EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k frees irq even before IRQs are disabled and existing IRQs
are flushed when rfkill_register() fails.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 97f0b47..ce5c0f7 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -811,9 +811,9 @@ static int ath_start_rfkill_poll(struct ath_softc *sc)
 			rfkill_free(sc->rf_kill.rfkill);
 
 			/* Deinitialize the device */
+			ath_detach(sc);
 			if (sc->pdev->irq)
 				free_irq(sc->pdev->irq, sc);
-			ath_detach(sc);
 			pci_iounmap(sc->pdev, sc->mem);
 			pci_release_region(sc->pdev, 0);
 			pci_disable_device(sc->pdev);
-- 
1.5.5

