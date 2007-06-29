Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764547AbXF2Nfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 09:35:41 -0400
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH 1/5] airo: disable the PCI device when unloading module
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Date: Fri, 29 Jun 2007 15:33:30 +0200
Message-ID: <20070629133330.6658.44086.stgit@localhost.localdomain>
In-Reply-To: <20070629131841.6658.76381.stgit@localhost.localdomain>
References: <20070629131841.6658.76381.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
index 2d3a180..57da70b 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5597,8 +5597,10 @@ static int __devinit airo_pci_probe(struct pci_dev *pdev,
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
@@ -5610,6 +5612,8 @@ static void __devexit airo_pci_remove(struct pci_dev *pdev)
 
 	airo_print_info(dev->name, "Unregistering...");
 	stop_airo_card(dev, 1);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
 }
 
 static int airo_pci_suspend(struct pci_dev *pdev, pm_message_t state)

