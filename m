Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:60433 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3IJL32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:29:28 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00AQ6QKWBH30@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:29:20 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Alexey Khoroshilov' <khoroshilov@ispras.ru>,
	'Kumar Amit Mehta' <gmate.amit@gmail.com>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 10/12] wireless: orinoco: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:29:19 +0900
Message-id: <00bb01ceae18$fdc38360$f94a8a20$%han@samsung.com> (sfid-20130910_132931_889961_0A9141E0)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/orinoco/orinoco_nortel.c |    2 --
 drivers/net/wireless/orinoco/orinoco_pci.c    |    2 --
 drivers/net/wireless/orinoco/orinoco_plx.c    |    2 --
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    2 --
 4 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
index d73fdf6..ffb2469 100644
--- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -234,7 +234,6 @@ static int orinoco_nortel_init_one(struct pci_dev *pdev,
 	free_irq(pdev->irq, priv);
 
  fail_irq:
-	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
 
  fail_alloc:
@@ -265,7 +264,6 @@ static void orinoco_nortel_remove_one(struct pci_dev *pdev)
 
 	orinoco_if_del(priv);
 	free_irq(pdev->irq, priv);
-	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
 	pci_iounmap(pdev, card->attr_io);
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
index 677bf14..5ae1191 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -184,7 +184,6 @@ static int orinoco_pci_init_one(struct pci_dev *pdev,
 	free_irq(pdev->irq, priv);
 
  fail_irq:
-	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
 
  fail_alloc:
@@ -205,7 +204,6 @@ static void orinoco_pci_remove_one(struct pci_dev *pdev)
 
 	orinoco_if_del(priv);
 	free_irq(pdev->irq, priv);
-	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
 	pci_release_regions(pdev);
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
index 2559dbd..bbd36d1 100644
--- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -273,7 +273,6 @@ static int orinoco_plx_init_one(struct pci_dev *pdev,
 	free_irq(pdev->irq, priv);
 
  fail_irq:
-	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
 
  fail_alloc:
@@ -301,7 +300,6 @@ static void orinoco_plx_remove_one(struct pci_dev *pdev)
 
 	orinoco_if_del(priv);
 	free_irq(pdev->irq, priv);
-	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
 	pci_iounmap(pdev, card->attr_io);
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
index 42afeee..04b08de 100644
--- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -170,7 +170,6 @@ static int orinoco_tmd_init_one(struct pci_dev *pdev,
 	free_irq(pdev->irq, priv);
 
  fail_irq:
-	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
 
  fail_alloc:
@@ -195,7 +194,6 @@ static void orinoco_tmd_remove_one(struct pci_dev *pdev)
 
 	orinoco_if_del(priv);
 	free_irq(pdev->irq, priv);
-	pci_set_drvdata(pdev, NULL);
 	free_orinocodev(priv);
 	pci_iounmap(pdev, priv->hw.iobase);
 	pci_iounmap(pdev, card->bridge_io);
-- 
1.7.10.4


