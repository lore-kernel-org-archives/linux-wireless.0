Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33208 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932431AbeFTThA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 15:37:00 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netdev@vger.kernel.org
Cc: linux-usb@vger.kernel.org, tglx@linutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        libertas-dev@lists.infradead.org
Subject: [PATCH 3/4] libertas: use irqsave() in USB's complete callback
Date: Wed, 20 Jun 2018 21:36:47 +0200
Message-Id: <20180620193648.25136-4-bigeasy@linutronix.de> (sfid-20180620_213717_387759_AA443936)
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

I am removing the
	BUG_ON(!in_interrupt());

check because it serves no purpose. Running the completion callback in
BH context makes in_interrupt() still return true but the interrupts
could be enabled. The important part is that ->driver_lock is acquired
with disabled interrupts which is the case now.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/w=
ireless/marvell/libertas/if_usb.c
index ffea610f67e2..c67a8e7be310 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -614,6 +614,7 @@ static inline void process_cmdrequest(int recvlength, u=
int8_t *recvbuff,
 				      struct if_usb_card *cardp,
 				      struct lbs_private *priv)
 {
+	unsigned long flags;
 	u8 i;
=20
 	if (recvlength > LBS_CMD_BUFFER_SIZE) {
@@ -623,9 +624,7 @@ static inline void process_cmdrequest(int recvlength, u=
int8_t *recvbuff,
 		return;
 	}
=20
-	BUG_ON(!in_interrupt());
-
-	spin_lock(&priv->driver_lock);
+	spin_lock_irqsave(&priv->driver_lock, flags);
=20
 	i =3D (priv->resp_idx =3D=3D 0) ? 1 : 0;
 	BUG_ON(priv->resp_len[i]);
@@ -635,7 +634,7 @@ static inline void process_cmdrequest(int recvlength, u=
int8_t *recvbuff,
 	kfree_skb(skb);
 	lbs_notify_command_response(priv, i);
=20
-	spin_unlock(&priv->driver_lock);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
=20
 	lbs_deb_usbd(&cardp->udev->dev,
 		    "Wake up main thread to handle cmd response\n");
--=20
2.17.1
