Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZAWRkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:40:33 -0500
Date: Fri, 23 Jan 2009 11:40:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2] rtl8187: Fix driver to return TX retry info for
 RTL8187L
Message-ID: <497a0106.W1r0wOftsbEmHCjp%Larry.Finger@lwfinger.net> (sfid-20090123_184037_734447_9E4126A3)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current code for the RTL8187 is not returning valid retry information, =
thus the
rate-setting mechanism is not functioning. As a further complication, t=
his info
is only obtained by reading a register, which cannot be read while in i=
nterrupt
context.

This patch implements the TX status return to mac80211 through the use =
of a
work queue.

One additional problem is that the driver currently enables the rate fa=
llback
mechanism of the device, which conflicts with the mac80211 rate-setting
algorithm. This version of the patch disables rate fallback.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Tested-by: Mart=C3=ADn Ernesto Barreyro <barreyromartin@gmail.com>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---

John,

This patch fixes a long-standing bug for the RTL8187 that has been pres=
ent
since the driver was made to work with mac80211. Technically, it is not=
 a
regression, but it would be nice if we could get it into 2.6.29 so that=
 it
could be pushed to stable. I have not Cc'd stable as the patch will nee=
d
rebasing to work with 2.6.28, or older.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
@@ -100,6 +100,8 @@ struct rtl8187_priv {
 	struct usb_device *udev;
 	u32 rx_conf;
 	struct usb_anchor anchored;
+	struct delayed_work work;
+	struct ieee80211_hw *dev;
 	u16 txpwr_base;
 	u8 asic_rev;
 	u8 is_rtl8187b;
@@ -117,7 +119,7 @@ struct rtl8187_priv {
 	struct {
 		__le64 buf;
 		struct sk_buff_head queue;
-	} b_tx_status;
+	} b_tx_status; /* This queue is used by both -b and non-b devices */
 };
=20
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -177,25 +177,33 @@ static void rtl8187_tx_cb(struct urb *ur
 					  sizeof(struct rtl8187_tx_hdr));
 	ieee80211_tx_info_clear_status(info);
=20
-	if (!urb->status &&
-	    !(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-	    priv->is_rtl8187b) {
-		skb_queue_tail(&priv->b_tx_status.queue, skb);
-
-		/* queue is "full", discard last items */
-		while (skb_queue_len(&priv->b_tx_status.queue) > 5) {
-			struct sk_buff *old_skb;
-
-			dev_dbg(&priv->udev->dev,
-				"transmit status queue full\n");
-
-			old_skb =3D skb_dequeue(&priv->b_tx_status.queue);
-			ieee80211_tx_status_irqsafe(hw, old_skb);
-		}
-	} else {
-		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) && !urb->status)
+	if (!(urb->status) && !(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+		if (priv->is_rtl8187b) {
+			skb_queue_tail(&priv->b_tx_status.queue, skb);
+
+			/* queue is "full", discard last items */
+			while (skb_queue_len(&priv->b_tx_status.queue) > 5) {
+				struct sk_buff *old_skb;
+
+				dev_dbg(&priv->udev->dev,
+					"transmit status queue full\n");
+
+				old_skb =3D skb_dequeue(&priv->b_tx_status.queue);
+				ieee80211_tx_status_irqsafe(hw, old_skb);
+			}
+			return;
+		} else {
 			info->flags |=3D IEEE80211_TX_STAT_ACK;
+		}
+	}
+	if (priv->is_rtl8187b)
 		ieee80211_tx_status_irqsafe(hw, skb);
+	else {
+		/* Retry information for the RTI8187 is only available by
+		 * reading a register in the device. We are in interrupt mode
+		 * here, thus queue the skb and finish on a work queue. */
+		skb_queue_tail(&priv->b_tx_status.queue, skb);
+		queue_delayed_work(hw->workqueue, &priv->work, 0);
 	}
 }
=20
@@ -644,7 +652,7 @@ static int rtl8187_init_hw(struct ieee80
=20
 	rtl818x_iowrite32(priv, &priv->map->INT_TIMEOUT, 0);
 	rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
-	rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, 0x81);
+	rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, 0);
=20
 	// TODO: set RESP_RATE and BRSR properly
 	rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (8 << 4) | 0);
@@ -764,9 +772,6 @@ static int rtl8187b_init_hw(struct ieee8
 	rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
=20
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFE0, 0x0FFF, 1);
-	reg =3D rtl818x_ioread8(priv, &priv->map->RATE_FALLBACK);
-	reg |=3D RTL818X_RATE_FALLBACK_ENABLE;
-	rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, reg);
=20
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
@@ -854,6 +859,34 @@ static int rtl8187b_init_hw(struct ieee8
 	return 0;
 }
=20
+static void rtl8187_work(struct work_struct *work)
+{
+	/* The RTL8187 returns the retry count through register 0xFFFA. In
+	 * addition, it appears to be a cumulative retry count, not the
+	 * value for the current TX packet. When multiple TX entries are
+	 * queued, the retry count will be valid for the last one in the queu=
e.
+	 * The "error" should not matter for purposes of rate setting. */
+	struct rtl8187_priv *priv =3D container_of(work, struct rtl8187_priv,
+				    work.work);
+	struct ieee80211_tx_info *info;
+	struct ieee80211_hw *dev =3D priv->dev;
+	static u16 retry;
+	u16 tmp;
+
+	mutex_lock(&priv->conf_mutex);
+	tmp =3D rtl818x_ioread16(priv, (__le16 *)0xFFFA);
+	while (skb_queue_len(&priv->b_tx_status.queue) > 0) {
+		struct sk_buff *old_skb;
+
+		old_skb =3D skb_dequeue(&priv->b_tx_status.queue);
+		info =3D IEEE80211_SKB_CB(old_skb);
+		info->status.rates[0].count =3D tmp - retry + 1;
+		ieee80211_tx_status_irqsafe(dev, old_skb);
+	}
+	retry =3D tmp;
+	mutex_unlock(&priv->conf_mutex);
+}
+
 static int rtl8187_start(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv =3D dev->priv;
@@ -868,6 +901,7 @@ static int rtl8187_start(struct ieee8021
 	mutex_lock(&priv->conf_mutex);
=20
 	init_usb_anchor(&priv->anchored);
+	priv->dev =3D dev;
=20
 	if (priv->is_rtl8187b) {
 		reg =3D RTL818X_RX_CONF_MGMT |
@@ -935,6 +969,7 @@ static int rtl8187_start(struct ieee8021
 	reg |=3D RTL818X_CMD_TX_ENABLE;
 	reg |=3D RTL818X_CMD_RX_ENABLE;
 	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
+	INIT_DELAYED_WORK(&priv->work, rtl8187_work);
 	mutex_unlock(&priv->conf_mutex);
=20
 	return 0;
@@ -965,6 +1000,8 @@ static void rtl8187_stop(struct ieee8021
 		dev_kfree_skb_any(skb);
=20
 	usb_kill_anchored_urbs(&priv->anchored);
+	if (!priv->is_rtl8187b)
+		cancel_delayed_work_sync(&priv->work);
 	mutex_unlock(&priv->conf_mutex);
 }
=20
---
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
