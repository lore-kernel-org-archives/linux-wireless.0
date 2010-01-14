Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57433 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab0ANEdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 23:33:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 20:33:46 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19278.41649.580507.869202@gargle.gargle.HOWL>
Date: Thu, 14 Jan 2010 10:20:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <proski@gnu.org>
Subject: [PATCH] ath9k: Fix panic on driver load
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device has to be marked as invalid before
registering the ISR. HW initialization takes place
after the ISR has been registered, and the invalid
flag is eventually cleared in the ->stop() callback.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c  |    3 +++
 drivers/net/wireless/ath/ath9k/init.c |    2 --
 drivers/net/wireless/ath/ath9k/pci.c  |    3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index f24b1f4..9e62a56 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -121,6 +121,9 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc->mem = mem;
 	sc->irq = irq;
 
+	/* Will be cleared in ath9k_start() */
+	sc->sc_flags |= SC_OP_INVALID;
+
 	ret = request_irq(irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 16d1efb..5f78d7a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -534,8 +534,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	int ret = 0, i;
 	int csz = 0;
 
-	sc->sc_flags |= SC_OP_INVALID;
-
 	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
 	if (!ah)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 95b9a07..4ae7b5f 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -198,6 +198,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
 
+	/* Will be cleared in ath9k_start() */
+	sc->sc_flags |= SC_OP_INVALID;
+
 	ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
-- 
1.6.6

