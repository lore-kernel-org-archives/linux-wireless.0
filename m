Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33129 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbaJ2RpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:05 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so2489386wgg.18
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 11/34] staging: vt6655: mac80211 conversion: device_print_info remove netdevice.
Date: Wed, 29 Oct 2014 17:43:46 +0000
Message-Id: <1414604649-9105-12-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185359_907833_1501B6D3)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
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
2.1.0

