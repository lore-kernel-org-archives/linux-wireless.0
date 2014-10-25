Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64596 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaJYS53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 14:57:29 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so3126265wgg.32
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 11:57:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/31] staging: vt6655: mac80211 conversion: device_print_info remove netdevice.
Date: Sat, 25 Oct 2014 09:20:21 +0100
Message-Id: <1414225241-5480-12-git-send-email-tvboxspy@gmail.com> (sfid-20141025_205731_810510_8E5D5991)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use dev_info for device name and pcid->irq for irq number.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index b0f94a8..5ece184 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -809,12 +809,11 @@ static const struct net_device_ops device_netdev_ops = {
 
 static void device_print_info(struct vnt_private *pDevice)
 {
-	struct net_device *dev = pDevice->dev;
+	dev_info(&pDevice->pcid->dev, "%s\n", get_chip_name(pDevice->chip_id));
 
-	pr_info("%s: %s\n", dev->name, get_chip_name(pDevice->chip_id));
-	pr_info("%s: MAC=%pM IO=0x%lx Mem=0x%lx IRQ=%d\n",
-		dev->name, dev->dev_addr, (unsigned long)pDevice->ioaddr,
-		(unsigned long)pDevice->PortOffset, pDevice->dev->irq);
+	dev_info(&pDevice->pcid->dev, "MAC=%pM IO=0x%lx Mem=0x%lx IRQ=%d\n",
+		 pDevice->abyCurrentNetAddr, (unsigned long)pDevice->ioaddr,
+		 (unsigned long)pDevice->PortOffset, pDevice->pcid->irq);
 }
 
 static void vt6655_init_info(struct pci_dev *pcid,
-- 
1.9.1

