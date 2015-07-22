Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33566 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbbGVSR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:57 -0400
Received: by wicmv11 with SMTP id mv11so92407958wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/15] staging: vt6655: always set 32 bit dma mask
Date: Wed, 22 Jul 2015 19:16:45 +0100
Message-Id: <1437589007-5479-13-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201806_435646_E218ACEC)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device is limited to 32 bit address space.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c82bf48..c97353b 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1747,6 +1747,12 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
+	if (dma_set_mask(&pcid->dev, DMA_BIT_MASK(32))) {
+		dev_err(&pcid->dev, ": Failed to set dma 32 bit mask\n");
+		device_free_info(priv);
+		return -ENODEV;
+	}
+
 	INIT_WORK(&priv->interrupt_work, vnt_interrupt_work);
 
 	/* do reset */
-- 
2.1.4

