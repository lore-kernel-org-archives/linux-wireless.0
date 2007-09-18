Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbXIRRGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 13:06:55 -0400
Date: Tue, 18 Sep 2007 10:06:47 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: msi support
Message-ID: <20070918100647.6f764850@freepuppy.rosehill.hemminger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The atheros on my Fujitsu b6210 supports MSI.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/drivers/net/wireless/ath5k_base.c	2007-09-18 09:10:05.000000000 -0700
+++ b/drivers/net/wireless/ath5k_base.c	2007-09-18 09:10:08.000000000 -0700
@@ -2315,6 +2315,8 @@ static int __devinit ath_pci_probe(struc
 
 	pci_set_drvdata(pdev, hw);
 
+	pci_enable_msi(pdev);
+
 	ret = request_irq(pdev->irq, ath_intr, IRQF_SHARED, "ath", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
@@ -2345,6 +2347,7 @@ err_ah:
 err_irq:
 	free_irq(pdev->irq, sc);
 err_free:
+	pci_disable_msi(pdev);
 	ieee80211_free_hw(hw);
 err_map:
 	pci_iounmap(pdev, mem);
@@ -2364,6 +2367,7 @@ static void __devexit ath_pci_remove(str
 	ath_detach(pdev, hw);
 	ath5k_hw_detach(sc->ah);
 	free_irq(pdev->irq, sc);
+	pci_disable_msi(pdev);
 	pci_iounmap(pdev, sc->iobase);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
