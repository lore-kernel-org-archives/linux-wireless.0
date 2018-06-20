Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33219 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932154AbeFTTjV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 15:39:21 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-wireless@vger.kernel.org
Cc: linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: nfcmrvl_usb: use irqsave() in USB's complete callback
Date: Wed, 20 Jun 2018 21:39:06 +0200
Message-Id: <20180620193906.25227-1-bigeasy@linutronix.de> (sfid-20180620_213926_692660_EB97BFFE)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The USB completion callback does not disable interrupts while acquiring
the lock. We want to remove the local_irq_disable() invocation from
__usb_hcd_giveback_urb() and therefore it is required for the callback
handler to disable the interrupts while acquiring the lock.
The callback may be invoked either in IRQ or BH context depending on the
USB host controller.
Use the _irqsave() variant of the locking primitives.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/nfc/nfcmrvl/usb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index bd35eab652be..945cc903d8f1 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -160,13 +160,14 @@ static void nfcmrvl_tx_complete(struct urb *urb)
 	struct nci_dev *ndev =3D (struct nci_dev *)skb->dev;
 	struct nfcmrvl_private *priv =3D nci_get_drvdata(ndev);
 	struct nfcmrvl_usb_drv_data *drv_data =3D priv->drv_data;
+	unsigned long flags;
=20
 	nfc_info(priv->dev, "urb %p status %d count %d\n",
 		 urb, urb->status, urb->actual_length);
=20
-	spin_lock(&drv_data->txlock);
+	spin_lock_irqsave(&drv_data->txlock, flags);
 	drv_data->tx_in_flight--;
-	spin_unlock(&drv_data->txlock);
+	spin_unlock_irqrestore(&drv_data->txlock, flags);
=20
 	kfree(urb->setup_packet);
 	kfree_skb(skb);
--=20
2.17.1
