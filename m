Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38184 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbeHXLv1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 07:51:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id w11-v6so6741553wrc.5
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2018 01:17:54 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2u: run device cleanup routine if resume fails
Date: Fri, 24 Aug 2018 10:17:49 +0200
Message-Id: <61ca93f6c7f8fae2714b7265cb84bc36469eecb4.1535098373.git.lorenzo.bianconi@redhat.com> (sfid-20180824_101757_003291_57C2590F)
In-Reply-To: <cover.1535098373.git.lorenzo.bianconi@redhat.com>
References: <cover.1535098373.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup {tx,rx} and mcu queues if resume operation fails

Fixes: ee676cd5017c ("mt76: add driver code for MT76x2u based devices")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
index 1428cfdee579..9594433234cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
@@ -107,16 +107,24 @@ static int __maybe_unused mt76x2u_resume(struct usb_interface *intf)
 			       mt76u_mcu_complete_urb,
 			       &usb->mcu.cmpl);
 	if (err < 0)
-		return err;
+		goto err;
 
 	err = mt76u_submit_rx_buffers(&dev->mt76);
 	if (err < 0)
-		return err;
+		goto err;
 
 	tasklet_enable(&usb->rx_tasklet);
 	tasklet_enable(&usb->tx_tasklet);
 
-	return mt76x2u_init_hardware(dev);
+	err = mt76x2u_init_hardware(dev);
+	if (err < 0)
+		goto err;
+
+	return 0;
+
+err:
+	mt76x2u_cleanup(dev);
+	return err;
 }
 
 MODULE_DEVICE_TABLE(usb, mt76x2u_device_table);
-- 
2.17.1
