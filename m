Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59322 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaF3QTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 12:19:52 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so6382969wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 09:19:51 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 7/7] rtl818x_pci: fix pci probe returns success when it fails
Date: Mon, 30 Jun 2014 18:19:40 +0200
Message-Id: <1404145180-16248-1-git-send-email-andrea.merello@gmail.com> (sfid-20140630_181954_521440_48375977)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several exit path from the PCI probe function.
Some of them, that are taken in case of errors, forget to set the "err"
variable, that is returned by the probe function.
This can lead to the kernel thinking the probe function succeeds while it
didn't, and this in turn causes extra calls to the "remove" function.

This patch fix this problem by ensuring "err" variable is assigned to a proper
non-zero value in each exit path.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 68304a9..4b904f70 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1756,6 +1756,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 
 	if (!priv->map) {
 		dev_err(&pdev->dev, "Cannot map device memory/PIO\n");
+		err = -ENOMEM;
 		goto err_free_dev;
 	}
 
@@ -1816,6 +1817,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	default:
 		printk(KERN_ERR "%s (rtl8180): Unknown chip! (0x%x)\n",
 		       pci_name(pdev), reg >> 25);
+		err = -ENODEV;
 		goto err_iounmap;
 	}
 
@@ -1866,12 +1868,14 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	default:
 		printk(KERN_ERR "%s (rtl8180): Unknown RF! (0x%x)\n",
 		       pci_name(pdev), priv->rf_type);
+		err = -ENODEV;
 		goto err_iounmap;
 	}
 
 	if (!priv->rf) {
 		printk(KERN_ERR "%s (rtl8180): %s RF frontend not supported!\n",
 		       pci_name(pdev), rf_name);
+		err = -ENODEV;
 		goto err_iounmap;
 	}
 
-- 
1.9.1

