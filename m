Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58179 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYLNSSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2008 13:18:13 -0500
Date: Sun, 14 Dec 2008 12:18:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Fix crash on unload when using SLUB debug
Message-ID: <49454de1.nqVNMn5dd1fg/Vjg%Larry.Finger@lwfinger.net> (sfid-20081214_191822_977828_75FDEE0E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>

After the code was modified to use urb anchors ("rtl8187: Use usb anchor
facilities to manage urbs"), rtl8187 began generating an intermittent GPF
on shutdown when using SLUB with debugging enabled. Furthermore, rebooting
the system with a ping running caused a GPF every time. There are two problems:
(1) incorrect locking in the rtl8187_rx_cb() routine, a pre-existing bug that
apparently had not been triggered before, and (2) duplicate freeing of receive
skbs that was probably introduced with the change to anchors.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---

John,

As the patch that exposed the first bug will be in 2.6.29, this one needs to be
in 2.6.29 as well.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -294,15 +294,16 @@ static void rtl8187_rx_cb(struct urb *ur
 	int rate, signal;
 	u32 flags;
 	u32 quality;
+	unsigned long f;
 
-	spin_lock(&priv->rx_queue.lock);
+	spin_lock_irqsave(&priv->rx_queue.lock, f);
 	if (skb->next)
 		__skb_unlink(skb, &priv->rx_queue);
 	else {
-		spin_unlock(&priv->rx_queue.lock);
+		spin_unlock_irqrestore(&priv->rx_queue.lock, f);
 		return;
 	}
-	spin_unlock(&priv->rx_queue.lock);
+	spin_unlock_irqrestore(&priv->rx_queue.lock, f);
 	skb_put(skb, urb->actual_length);
 
 	if (unlikely(urb->status)) {
@@ -942,7 +943,6 @@ static int rtl8187_start(struct ieee8021
 static void rtl8187_stop(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
-	struct rtl8187_rx_info *info;
 	struct sk_buff *skb;
 	u32 reg;
 
@@ -961,10 +961,6 @@ static void rtl8187_stop(struct ieee8021
 	rtl818x_iowrite8(priv, &priv->map->CONFIG4, reg | RTL818X_CONFIG4_VCOOFF);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
-	while ((skb = skb_dequeue(&priv->rx_queue))) {
-		info = (struct rtl8187_rx_info *)skb->cb;
-		kfree_skb(skb);
-	}
 	while ((skb = skb_dequeue(&priv->b_tx_status.queue)))
 		dev_kfree_skb_any(skb);
 
