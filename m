Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33200 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932162AbeFTTg6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 15:36:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netdev@vger.kernel.org
Cc: linux-usb@vger.kernel.org, tglx@linutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/4] libertas_tf: use irqsave() in USB's complete callback
Date: Wed, 20 Jun 2018 21:36:46 +0200
Message-Id: <20180620193648.25136-3-bigeasy@linutronix.de> (sfid-20180620_213724_833114_E6C56719)
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
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/ne=
t/wireless/marvell/libertas_tf/if_usb.c
index 5153922e7ce1..e92fc5001171 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -603,6 +603,8 @@ static inline void process_cmdrequest(int recvlength, u=
int8_t *recvbuff,
 				      struct if_usb_card *cardp,
 				      struct lbtf_private *priv)
 {
+	unsigned long flags;
+
 	if (recvlength > LBS_CMD_BUFFER_SIZE) {
 		lbtf_deb_usbd(&cardp->udev->dev,
 			     "The receive buffer is too large\n");
@@ -610,14 +612,12 @@ static inline void process_cmdrequest(int recvlength,=
 uint8_t *recvbuff,
 		return;
 	}
=20
-	BUG_ON(!in_interrupt());
-
-	spin_lock(&priv->driver_lock);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 	memcpy(priv->cmd_resp_buff, recvbuff + MESSAGE_HEADER_LEN,
 	       recvlength - MESSAGE_HEADER_LEN);
 	kfree_skb(skb);
 	lbtf_cmd_response_rx(priv);
-	spin_unlock(&priv->driver_lock);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
=20
 /**
--=20
2.17.1
