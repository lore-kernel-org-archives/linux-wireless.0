Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44185 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbaKDOuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:50:21 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so13077103wgh.11
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:50:20 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6655: change tx wake queue
Date: Tue,  4 Nov 2014 14:49:46 +0000
Message-Id: <1415112586-5808-1-git-send-email-tvboxspy@gmail.com> (sfid-20141104_155030_189667_B28F5F8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wake queue in the dwIsr loop of device_intr instead of device_tx_srv.

This fixes an issue when ISR_TXDMA0 or ISR_AC0DMA does not occur
device_tx_srv is not called and the queue gets stuck in stopped
condition.

On test if the queue is stuck another MACvTransmitAC0 or MACvTransmit0
in vnt_tx_packet will clear it.

Check on vif that both buffers are available and the queue is stopped.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f0b336b..35d69a9 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1181,10 +1181,6 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 			}
 			device_free_tx_buf(pDevice, pTD);
 			pDevice->iTDUsed[uIdx]--;
-
-			/* Make sure queue is available */
-			if (AVAIL_TD(pDevice, uIdx))
-				ieee80211_wake_queues(pDevice->hw);
 		}
 	}
 
@@ -1357,6 +1353,14 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 			}
 		}
 
+		/* If both buffers available wake the queue */
+		if (pDevice->vif) {
+			if (AVAIL_TD(pDevice, TYPE_TXDMA0) &&
+			    AVAIL_TD(pDevice, TYPE_AC0DMA) &&
+			    ieee80211_queue_stopped(pDevice->hw, 0))
+				ieee80211_wake_queues(pDevice->hw);
+		}
+
 		MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
 
 		MACvReceive0(pDevice->PortOffset);
-- 
2.1.0

