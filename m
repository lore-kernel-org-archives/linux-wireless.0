Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:39015 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbYEEPRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 11:17:39 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1086908nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 08:17:38 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 3/3] rt2x00: Clean up error handling of PCI queue DMA allocation.
Date: Mon, 5 May 2008 17:24:03 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805051723.12127.IvDoorn@gmail.com>
In-Reply-To: <200805051723.12127.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805051724.03909.IvDoorn@gmail.com> (sfid-20080505_171657_145903_C36EB157)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When, for some reason, the rt2x00pci module fails to allocate DMA memory for
the queues, it tries to undo the complete initialization of the PCI device,
including freeing of the irq. This results in the following error in dmesg, as
the irq hadn't been requested yet:

[  78.123456] Trying to free already-free IRQ 17

Fix this by implementing proper error handling code, instead of just using the
full uninitialization function.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 9e5d94e..c17078e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -314,13 +314,14 @@ int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 	if (status) {
 		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
 		      pci_dev->irq, status);
-		return status;
+		goto exit;
 	}
 
 	return 0;
 
 exit:
-	rt2x00pci_uninitialize(rt2x00dev);
+	queue_for_each(rt2x00dev, queue)
+		rt2x00pci_free_queue_dma(rt2x00dev, queue);
 
 	return status;
 }
-- 
1.5.5.1

