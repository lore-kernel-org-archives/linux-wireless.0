Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33203 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932077AbeFTTg7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 15:36:59 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netdev@vger.kernel.org
Cc: linux-usb@vger.kernel.org, tglx@linutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>
Subject: [PATCH 4/4] zd1211rw: use irqsave() in USB's complete callback
Date: Wed, 20 Jun 2018 21:36:48 +0200
Message-Id: <20180620193648.25136-5-bigeasy@linutronix.de> (sfid-20180620_213736_096227_8E5E2E54)
In-Reply-To: <20180620193648.25136-1-bigeasy@linutronix.de>
References: <20180620193648.25136-1-bigeasy@linutronix.de>
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

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 21 +++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wir=
eless/zydas/zd1211rw/zd_usb.c
index c30bf118c67d..c2cda3acd4af 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -371,25 +371,27 @@ static inline void handle_regs_int_override(struct ur=
b *urb)
 {
 	struct zd_usb *usb =3D urb->context;
 	struct zd_usb_interrupt *intr =3D &usb->intr;
+	unsigned long flags;
=20
-	spin_lock(&intr->lock);
+	spin_lock_irqsave(&intr->lock, flags);
 	if (atomic_read(&intr->read_regs_enabled)) {
 		atomic_set(&intr->read_regs_enabled, 0);
 		intr->read_regs_int_overridden =3D 1;
 		complete(&intr->read_regs.completion);
 	}
-	spin_unlock(&intr->lock);
+	spin_unlock_irqrestore(&intr->lock, flags);
 }
=20
 static inline void handle_regs_int(struct urb *urb)
 {
 	struct zd_usb *usb =3D urb->context;
 	struct zd_usb_interrupt *intr =3D &usb->intr;
+	unsigned long flags;
 	int len;
 	u16 int_num;
=20
 	ZD_ASSERT(in_interrupt());
-	spin_lock(&intr->lock);
+	spin_lock_irqsave(&intr->lock, flags);
=20
 	int_num =3D le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
 	if (int_num =3D=3D CR_INTERRUPT) {
@@ -425,7 +427,7 @@ static inline void handle_regs_int(struct urb *urb)
 	}
=20
 out:
-	spin_unlock(&intr->lock);
+	spin_unlock_irqrestore(&intr->lock, flags);
=20
 	/* CR_INTERRUPT might override read_reg too. */
 	if (int_num =3D=3D CR_INTERRUPT && atomic_read(&intr->read_regs_enabled))
@@ -665,6 +667,7 @@ static void rx_urb_complete(struct urb *urb)
 	struct zd_usb_rx *rx;
 	const u8 *buffer;
 	unsigned int length;
+	unsigned long flags;
=20
 	switch (urb->status) {
 	case 0:
@@ -693,14 +696,14 @@ static void rx_urb_complete(struct urb *urb)
 		/* If there is an old first fragment, we don't care. */
 		dev_dbg_f(urb_dev(urb), "*** first fragment ***\n");
 		ZD_ASSERT(length <=3D ARRAY_SIZE(rx->fragment));
-		spin_lock(&rx->lock);
+		spin_lock_irqsave(&rx->lock, flags);
 		memcpy(rx->fragment, buffer, length);
 		rx->fragment_length =3D length;
-		spin_unlock(&rx->lock);
+		spin_unlock_irqrestore(&rx->lock, flags);
 		goto resubmit;
 	}
=20
-	spin_lock(&rx->lock);
+	spin_lock_irqsave(&rx->lock, flags);
 	if (rx->fragment_length > 0) {
 		/* We are on a second fragment, we believe */
 		ZD_ASSERT(length + rx->fragment_length <=3D
@@ -710,9 +713,9 @@ static void rx_urb_complete(struct urb *urb)
 		handle_rx_packet(usb, rx->fragment,
 			         rx->fragment_length + length);
 		rx->fragment_length =3D 0;
-		spin_unlock(&rx->lock);
+		spin_unlock_irqrestore(&rx->lock, flags);
 	} else {
-		spin_unlock(&rx->lock);
+		spin_unlock_irqrestore(&rx->lock, flags);
 		handle_rx_packet(usb, buffer, length);
 	}
=20
--=20
2.17.1
