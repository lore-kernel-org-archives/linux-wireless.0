Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:35426 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYLIOOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 09:14:37 -0500
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] p54usb: rewriting rx/tx routines to make use of usb_anchor's facilities
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
From: Christian Lamparter <chunkeey@web.de>
Date: Tue, 9 Dec 2008 15:14:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200812091514.37634.chunkeey@web.de> (sfid-20081209_151443_732191_F1E1E380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern found several flaws in p54usb's implementation and annotated=
:=20
"usb_kill_urb() and similar routines do not expect an URB's completion
routine to deallocate it. =A0This is almost obvious -- if the URB is de=
allocated
before the completion routine returns then there's no way for usb_kill_=
urb
to detect when the URB actually is complete."

This patch addresses all known limitations in the old implementation an=
d fixes
khub's "use-after-freed" hang, when SLUB debug's poisoning option is en=
abled.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Cc: stable@kernel.org
---
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p=
54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-12-07 21:21:04.017774898 +=
0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-12-08 14:17:51.863521490 +=
0100
@@ -86,13 +86,13 @@ static void p54u_rx_cb(struct urb *urb)
 	struct ieee80211_hw *dev =3D info->dev;
 	struct p54u_priv *priv =3D dev->priv;
=20
+	skb_unlink(skb, &priv->rx_queue);
+
 	if (unlikely(urb->status)) {
-		info->urb =3D NULL;
-		usb_free_urb(urb);
+		dev_kfree_skb_irq(skb);
 		return;
 	}
=20
-	skb_unlink(skb, &priv->rx_queue);
 	skb_put(skb, urb->actual_length);
=20
 	if (priv->hw_type =3D=3D P54U_NET2280)
@@ -105,7 +105,6 @@ static void p54u_rx_cb(struct urb *urb)
 	if (p54_rx(dev, skb)) {
 		skb =3D dev_alloc_skb(priv->common.rx_mtu + 32);
 		if (unlikely(!skb)) {
-			usb_free_urb(urb);
 			/* TODO check rx queue length and refill *somewhere* */
 			return;
 		}
@@ -115,7 +114,6 @@ static void p54u_rx_cb(struct urb *urb)
 		info->dev =3D dev;
 		urb->transfer_buffer =3D skb_tail_pointer(skb);
 		urb->context =3D skb;
-		skb_queue_tail(&priv->rx_queue, skb);
 	} else {
 		if (priv->hw_type =3D=3D P54U_NET2280)
 			skb_push(skb, priv->common.tx_hdr_len);
@@ -130,11 +128,14 @@ static void p54u_rx_cb(struct urb *urb)
 			WARN_ON(1);
 			urb->transfer_buffer =3D skb_tail_pointer(skb);
 		}
-
-		skb_queue_tail(&priv->rx_queue, skb);
 	}
-
-	usb_submit_urb(urb, GFP_ATOMIC);
+	skb_queue_tail(&priv->rx_queue, skb);
+	usb_anchor_urb(urb, &priv->submitted);
+	if (usb_submit_urb(urb, GFP_ATOMIC)) {
+		skb_unlink(skb, &priv->rx_queue);
+		usb_unanchor_urb(urb);
+		dev_kfree_skb_irq(skb);
+	}
 }
=20
 static void p54u_tx_reuse_skb_cb(struct urb *urb)
@@ -144,18 +145,6 @@ static void p54u_tx_reuse_skb_cb(struct=20
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0)))->priv;
=20
 	skb_pull(skb, priv->common.tx_hdr_len);
-	usb_free_urb(urb);
-}
-
-static void p54u_tx_cb(struct urb *urb)
-{
-	usb_free_urb(urb);
-}
-
-static void p54u_tx_free_cb(struct urb *urb)
-{
-	kfree(urb->transfer_buffer);
-	usb_free_urb(urb);
 }
=20
 static void p54u_tx_free_skb_cb(struct urb *urb)
@@ -165,25 +154,36 @@ static void p54u_tx_free_skb_cb(struct u
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
=20
 	p54_free_skb(dev, skb);
-	usb_free_urb(urb);
+}
+
+static void p54u_tx_dummy_cb(struct urb *urb) { }
+
+static void p54u_free_urbs(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv =3D dev->priv;
+	usb_kill_anchored_urbs(&priv->submitted);
 }
=20
 static int p54u_init_urbs(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv =3D dev->priv;
-	struct urb *entry;
+	struct urb *entry =3D NULL;
 	struct sk_buff *skb;
 	struct p54u_rx_info *info;
+	int ret =3D 0;
=20
 	while (skb_queue_len(&priv->rx_queue) < 32) {
 		skb =3D __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
-		if (!skb)
-			break;
+		if (!skb) {
+			ret =3D -ENOMEM;
+			goto err;
+		}
 		entry =3D usb_alloc_urb(0, GFP_KERNEL);
 		if (!entry) {
-			kfree_skb(skb);
-			break;
+			ret =3D -ENOMEM;
+			goto err;
 		}
+
 		usb_fill_bulk_urb(entry, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
 				  skb_tail_pointer(skb),
@@ -192,26 +192,25 @@ static int p54u_init_urbs(struct ieee802
 		info->urb =3D entry;
 		info->dev =3D dev;
 		skb_queue_tail(&priv->rx_queue, skb);
-		usb_submit_urb(entry, GFP_KERNEL);
+
+		usb_anchor_urb(entry, &priv->submitted);
+		ret =3D usb_submit_urb(entry, GFP_KERNEL);
+		if (ret) {
+			skb_unlink(skb, &priv->rx_queue);
+			usb_unanchor_urb(entry);
+			goto err;
+		}
+		usb_free_urb(entry);
+		entry =3D NULL;
 	}
=20
 	return 0;
-}
=20
-static void p54u_free_urbs(struct ieee80211_hw *dev)
-{
-	struct p54u_priv *priv =3D dev->priv;
-	struct p54u_rx_info *info;
-	struct sk_buff *skb;
-
-	while ((skb =3D skb_dequeue(&priv->rx_queue))) {
-		info =3D (struct p54u_rx_info *) skb->cb;
-		if (!info->urb)
-			continue;
-
-		usb_kill_urb(info->urb);
-		kfree_skb(skb);
-	}
+ err:
+	usb_free_urb(entry);
+	kfree_skb(skb);
+	p54u_free_urbs(dev);
+	return ret;
 }
=20
 static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb=
,
@@ -219,6 +218,7 @@ static void p54u_tx_3887(struct ieee8021
 {
 	struct p54u_priv *priv =3D dev->priv;
 	struct urb *addr_urb, *data_urb;
+	int err =3D 0;
=20
 	addr_urb =3D usb_alloc_urb(0, GFP_ATOMIC);
 	if (!addr_urb)
@@ -233,15 +233,31 @@ static void p54u_tx_3887(struct ieee8021
 	usb_fill_bulk_urb(addr_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  &((struct p54_hdr *)skb->data)->req_id, 4,
-			  p54u_tx_cb, dev);
+			  p54u_tx_dummy_cb, dev);
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  skb->data, skb->len,
 			  free_on_tx ? p54u_tx_free_skb_cb :
 				       p54u_tx_reuse_skb_cb, skb);
=20
-	usb_submit_urb(addr_urb, GFP_ATOMIC);
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+	usb_anchor_urb(addr_urb, &priv->submitted);
+	err =3D usb_submit_urb(addr_urb, GFP_ATOMIC);
+	if (err) {
+		usb_unanchor_urb(addr_urb);
+		goto out;
+	}
+
+	usb_anchor_urb(addr_urb, &priv->submitted);
+	err =3D usb_submit_urb(data_urb, GFP_ATOMIC);
+	if (err)
+		usb_unanchor_urb(data_urb);
+
+ out:
+	usb_free_urb(addr_urb);
+	usb_free_urb(data_urb);
+
+	if (err)
+		p54_free_skb(dev, skb);
 }
=20
 static __le32 p54u_lm87_chksum(const __le32 *data, size_t length)
@@ -281,7 +297,13 @@ static void p54u_tx_lm87(struct ieee8021
 			  free_on_tx ? p54u_tx_free_skb_cb :
 				       p54u_tx_reuse_skb_cb, skb);
=20
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+	usb_anchor_urb(data_urb, &priv->submitted);
+	if (usb_submit_urb(data_urb, GFP_ATOMIC)) {
+		usb_unanchor_urb(data_urb);
+		skb_pull(skb, sizeof(*hdr));
+		p54_free_skb(dev, skb);
+	}
+	usb_free_urb(data_urb);
 }
=20
 static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *=
skb,
@@ -291,6 +313,7 @@ static void p54u_tx_net2280(struct ieee8
 	struct urb *int_urb, *data_urb;
 	struct net2280_tx_hdr *hdr;
 	struct net2280_reg_write *reg;
+	int err =3D 0;
=20
 	reg =3D kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
@@ -320,15 +343,42 @@ static void p54u_tx_net2280(struct ieee8
=20
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
-		p54u_tx_free_cb, dev);
-	usb_submit_urb(int_urb, GFP_ATOMIC);
+		p54u_tx_dummy_cb, dev);
+
+	/*
+	 * This flag triggers a code path in the USB subsystem that will
+	 * free what's inside the transfer_buffer after the callback routine
+	 * has completed.
+	 */
+	int_urb->transfer_flags |=3D URB_FREE_BUFFER;
=20
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
 			  skb->data, skb->len,
 			  free_on_tx ? p54u_tx_free_skb_cb :
 				       p54u_tx_reuse_skb_cb, skb);
-	usb_submit_urb(data_urb, GFP_ATOMIC);
+
+	usb_anchor_urb(int_urb, &priv->submitted);
+	err =3D usb_submit_urb(int_urb, GFP_ATOMIC);
+	if (err) {
+		usb_unanchor_urb(int_urb);
+		goto out;
+	}
+
+	usb_anchor_urb(data_urb, &priv->submitted);
+	err =3D usb_submit_urb(data_urb, GFP_ATOMIC);
+	if (err) {
+		usb_unanchor_urb(data_urb);
+		goto out;
+	}
+ out:
+	usb_free_urb(int_urb);
+	usb_free_urb(data_urb);
+
+	if (err) {
+		skb_pull(skb, sizeof(*hdr));
+		p54_free_skb(dev, skb);
+	}
 }
=20
 static int p54u_write(struct p54u_priv *priv,
@@ -886,6 +936,7 @@ static int __devinit p54u_probe(struct u
 		goto err_free_dev;
=20
 	skb_queue_head_init(&priv->rx_queue);
+	init_usb_anchor(&priv->submitted);
=20
 	p54u_open(dev);
 	err =3D p54_read_eeprom(dev);
diff -Nurp a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p=
54/p54usb.h
--- a/drivers/net/wireless/p54/p54usb.h	2008-12-07 21:21:04.017774898 +=
0100
+++ b/drivers/net/wireless/p54/p54usb.h	2008-12-07 22:04:45.956897502 +=
0100
@@ -133,6 +133,7 @@ struct p54u_priv {
=20
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
+	struct usb_anchor submitted;
 };
=20
 #endif /* P54USB_H */
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
