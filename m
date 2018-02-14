Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37897 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967355AbeBNLel (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 06:34:41 -0500
Received: by mail-wm0-f45.google.com with SMTP id 141so21330169wme.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Feb 2018 03:34:41 -0800 (PST)
From: cantabile <cantabile.desu@gmail.com>
Subject: [PATCH] mt7601u: Fix system freeze after resuming from hibernation
To: linux-wireless@vger.kernel.org
Cc: kubakici@wp.pl
Message-ID: <d9ca2742-7f85-afe3-2de6-6637eb56d9b3@gmail.com> (sfid-20180214_123445_162708_FC7E44FF)
Date: Wed, 14 Feb 2018 13:34:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware running on the device sometimes survives a reboot 
(firmware_running returns 1). When this happens the driver never calls 
request_firmware, which means the kernel's firmware handling code 
doesn't know this firmware should be cached before hibernating. Upon 
resuming from several hours of hibernation, the firmware is no longer 
running on the device, so the driver calls request_firmware. Since the 
firmware was never cached, it needs to be loaded from disk, and this is 
when the system freezes, somewhere in the xfs driver. Fix this by always 
requesting the firmware, whether it's already running on the device or not.

Signed-off-by: John Smith <cantabile.desu@gmail.com>
---
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -420,13 +420,15 @@
  	mt7601u_wr(dev, MT_USB_DMA_CFG, (MT_USB_DMA_CFG_RX_BULK_EN |
  					 MT_USB_DMA_CFG_TX_BULK_EN));

-	if (firmware_running(dev))
-		return 0;
-
  	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
  	if (ret)
  		return ret;

+	if (firmware_running(dev)) {
+		release_firmware(fw);
+		return 0;
+	}
+
  	if (!fw || !fw->data || fw->size < sizeof(*hdr))
  		goto err_inv_fw;
