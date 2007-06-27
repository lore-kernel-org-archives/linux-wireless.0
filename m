Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805AbXF0VSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 17:18:09 -0400
Message-ID: <4682D3F3.9050202@redhat.com>
Date: Wed, 27 Jun 2007 23:17:39 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Subject: [PATCH 3/4] airo: disable the PCI device when unloading module
References: <4682D323.2010605@redhat.com>
In-Reply-To: <4682D323.2010605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix an assymetry between pci_{enable,disable}_device. airo did not disable
the PCI device when unloading the module. This caused suspend failures
after modprobe -r airo && modprobe airo.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

---
 drivers/net/wireless/airo.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 63a4aaa..d46d27a 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5603,8 +5603,10 @@ static int __devinit airo_pci_probe(struct pci_dev *pdev,
 			dev = _init_airo_card(pdev->irq, pdev->resource[0].start, 0, pdev, &pdev->dev);
 	else
 			dev = _init_airo_card(pdev->irq, pdev->resource[2].start, 0, pdev, &pdev->dev);
-	if (!dev)
+	if (!dev) {
+		pci_disable_device(pdev);
 		return -ENODEV;
+	}
 
 	pci_set_drvdata(pdev, dev);
 	return 0;
@@ -5616,6 +5618,8 @@ static void __devexit airo_pci_remove(struct pci_dev *pdev)
 
 	airo_print_info(dev->name, "Unregistering...");
 	stop_airo_card(dev, 1);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
 }
 
 static int airo_pci_suspend(struct pci_dev *pdev, pm_message_t state)


