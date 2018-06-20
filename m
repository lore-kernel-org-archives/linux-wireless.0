Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33198 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932154AbeFTTg6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 15:36:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netdev@vger.kernel.org
Cc: linux-usb@vger.kernel.org, tglx@linutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH 1/4] ath9k: use irqsave() in USB's complete callback
Date: Wed, 20 Jun 2018 21:36:45 +0200
Message-Id: <20180620193648.25136-2-bigeasy@linutronix.de> (sfid-20180620_213703_648273_91684E21)
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

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |  7 ++++---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  9 +++++----
 drivers/net/wireless/ath/ath9k/wmi.c          | 11 ++++++-----
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireles=
s/ath/ath9k/hif_usb.c
index cb0eef13af1c..fb649d85b8fc 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -138,6 +138,7 @@ static void hif_usb_mgmt_cb(struct urb *urb)
 {
 	struct cmd_buf *cmd =3D (struct cmd_buf *)urb->context;
 	struct hif_device_usb *hif_dev;
+	unsigned long flags;
 	bool txok =3D true;
=20
 	if (!cmd || !cmd->skb || !cmd->hif_dev)
@@ -158,14 +159,14 @@ static void hif_usb_mgmt_cb(struct urb *urb)
 		 * If the URBs are being flushed, no need to complete
 		 * this packet.
 		 */
-		spin_lock(&hif_dev->tx.tx_lock);
+		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 		if (hif_dev->tx.flags & HIF_USB_TX_FLUSH) {
-			spin_unlock(&hif_dev->tx.tx_lock);
+			spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 			dev_kfree_skb_any(cmd->skb);
 			kfree(cmd);
 			return;
 		}
-		spin_unlock(&hif_dev->tx.tx_lock);
+		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
=20
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wi=
reless/ath/ath9k/htc_drv_txrx.c
index 585736a837ed..799010ed04e0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1107,25 +1107,26 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff =
*skb,
 	struct ath_hw *ah =3D priv->ah;
 	struct ath_common *common =3D ath9k_hw_common(ah);
 	struct ath9k_htc_rxbuf *rxbuf =3D NULL, *tmp_buf =3D NULL;
+	unsigned long flags;
=20
-	spin_lock(&priv->rx.rxbuflock);
+	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
 	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
 		if (!tmp_buf->in_process) {
 			rxbuf =3D tmp_buf;
 			break;
 		}
 	}
-	spin_unlock(&priv->rx.rxbuflock);
+	spin_unlock_irqrestore(&priv->rx.rxbuflock, flags);
=20
 	if (rxbuf =3D=3D NULL) {
 		ath_dbg(common, ANY, "No free RX buffer\n");
 		goto err;
 	}
=20
-	spin_lock(&priv->rx.rxbuflock);
+	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
 	rxbuf->skb =3D skb;
 	rxbuf->in_process =3D true;
-	spin_unlock(&priv->rx.rxbuflock);
+	spin_unlock_irqrestore(&priv->rx.rxbuflock, flags);
=20
 	tasklet_schedule(&priv->rx_tasklet);
 	return;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/at=
h/ath9k/wmi.c
index b0b5579b7560..d1f6710ca63b 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -209,6 +209,7 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buf=
f *skb,
 {
 	struct wmi *wmi =3D priv;
 	struct wmi_cmd_hdr *hdr;
+	unsigned long flags;
 	u16 cmd_id;
=20
 	if (unlikely(wmi->stopped))
@@ -218,20 +219,20 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_b=
uff *skb,
 	cmd_id =3D be16_to_cpu(hdr->command_id);
=20
 	if (cmd_id & 0x1000) {
-		spin_lock(&wmi->wmi_lock);
+		spin_lock_irqsave(&wmi->wmi_lock, flags);
 		__skb_queue_tail(&wmi->wmi_event_queue, skb);
-		spin_unlock(&wmi->wmi_lock);
+		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 		tasklet_schedule(&wmi->wmi_event_tasklet);
 		return;
 	}
=20
 	/* Check if there has been a timeout. */
-	spin_lock(&wmi->wmi_lock);
+	spin_lock_irqsave(&wmi->wmi_lock, flags);
 	if (be16_to_cpu(hdr->seq_no) !=3D wmi->last_seq_id) {
-		spin_unlock(&wmi->wmi_lock);
+		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 		goto free_skb;
 	}
-	spin_unlock(&wmi->wmi_lock);
+	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
=20
 	/* WMI command response */
 	ath9k_wmi_rsp_callback(wmi, skb);
--=20
2.17.1
