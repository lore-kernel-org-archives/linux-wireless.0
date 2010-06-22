Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57615 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756236Ab0FVOyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 10:54:35 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: kalle.valo@iki.fi
Subject: [PATCH 2/2] at76c50x-usb: Extract bssid from authentication frame
Date: Tue, 22 Jun 2010 16:55:17 +0200
Cc: linux-wireless@vger.kernel.org
References: <201006221651.24853.Sebastian.Smolorz@gmx.de>
In-Reply-To: <201006221651.24853.Sebastian.Smolorz@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006221655.17697.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver at76c50x-usb is unable to authenticate with an AP since
kernel 2.6.31 for the following reason: The join command of the firmware
needs to be sent with the right bssid before any transmission can start.
Before kernel 2.6.31 mac80211 informed its drivers about the changing
bssid early enough for at76c50x-usb but during the development of 2.6.31
mac80211's behaviour changed. Now a new bssid is set after the
association.

This patch changes the tx routine of the driver at76c50x-usb in such a
way that a new bssid is extracted from an authentication frame and the
join command with that bssid is processed.

Signed-off-by: Sebastian Smolorz <sesmo@gmx.net>
---
 drivers/net/wireless/at76c50x-usb.c |   36 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/at76c50x-usb.h |    1 +
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index cb3d4b7..98328b7 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -7,6 +7,7 @@
  * Copyright (c) 2004 Balint Seeber <n0_5p4m_p13453@hotmail.com>
  * Copyright (c) 2007 Guido Guenther <agx@sigxcpu.org>
  * Copyright (c) 2007 Kalle Valo <kalle.valo@iki.fi>
+ * Copyright (c) 2010 Sebastian Smolorz <sesmo@gmx.net>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -1685,6 +1686,22 @@ static int at76_join(struct at76_priv *priv)
 	return 0;
 }
 
+static void at76_work_join_bssid(struct work_struct *work)
+{
+	struct at76_priv *priv = container_of(work, struct at76_priv,
+					      work_join_bssid);
+
+	if (priv->device_unplugged)
+		return;
+
+	mutex_lock(&priv->mtx);
+
+	if (is_valid_ether_addr(priv->bssid))
+		at76_join(priv);
+
+	mutex_unlock(&priv->mtx);
+}
+
 static void at76_mac80211_tx_callback(struct urb *urb)
 {
 	struct at76_priv *priv = urb->context;
@@ -1722,6 +1739,7 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct at76_priv *priv = hw->priv;
 	struct at76_tx_buffer *tx_buffer = priv->bulk_out_buffer;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 	int padding, submit_len, ret;
 
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
@@ -1732,6 +1750,21 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return NETDEV_TX_BUSY;
 	}
 
+	/* The following code lines are important when the device is going to
+	 * authenticate with a new bssid. The driver must send CMD_JOIN before
+	 * an authentication frame is transmitted. For this to succeed, the
+	 * correct bssid of the AP must be known. As mac80211 does not inform
+	 * drivers about the bssid prior to the authentication process the
+	 * following workaround is necessary. If the TX frame is an
+	 * authentication frame extract the bssid and send the CMD_JOIN. */
+	if (mgmt->frame_control & cpu_to_le16(IEEE80211_STYPE_AUTH)) {
+		if (compare_ether_addr(priv->bssid, mgmt->bssid)) {
+			memcpy(priv->bssid, mgmt->bssid, ETH_ALEN);
+			ieee80211_queue_work(hw, &priv->work_join_bssid);
+			return NETDEV_TX_BUSY;
+		}
+	}
+
 	ieee80211_stop_queues(hw);
 
 	at76_ledtrig_tx_activity();	/* tell ledtrigger we send a packet */
@@ -1806,6 +1839,7 @@ static void at76_mac80211_stop(struct ieee80211_hw *hw)
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
 
 	cancel_delayed_work(&priv->dwork_hw_scan);
+	cancel_work_sync(&priv->work_join_bssid);
 	cancel_work_sync(&priv->work_set_promisc);
 
 	mutex_lock(&priv->mtx);
@@ -2107,6 +2141,7 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	mutex_init(&priv->mtx);
 	INIT_WORK(&priv->work_set_promisc, at76_work_set_promisc);
 	INIT_WORK(&priv->work_submit_rx, at76_work_submit_rx);
+	INIT_WORK(&priv->work_join_bssid, at76_work_join_bssid);
 	INIT_DELAYED_WORK(&priv->dwork_hw_scan, at76_dwork_hw_scan);
 
 	tasklet_init(&priv->rx_tasklet, at76_rx_tasklet, 0);
@@ -2508,5 +2543,6 @@ MODULE_AUTHOR("Balint Seeber <n0_5p4m_p13453@hotmail.com>");
 MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>");
 MODULE_AUTHOR("Guido Guenther <agx@sigxcpu.org>");
 MODULE_AUTHOR("Kalle Valo <kalle.valo@iki.fi>");
+MODULE_AUTHOR("Sebastian Smolorz <sesmo@gmx.net>");
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/at76c50x-usb.h b/drivers/net/wireless/at76c50x-usb.h
index 1ec5ccf..db89d72 100644
--- a/drivers/net/wireless/at76c50x-usb.h
+++ b/drivers/net/wireless/at76c50x-usb.h
@@ -387,6 +387,7 @@ struct at76_priv {
 	/* work queues */
 	struct work_struct work_set_promisc;
 	struct work_struct work_submit_rx;
+	struct work_struct work_join_bssid;
 	struct delayed_work dwork_hw_scan;
 
 	struct tasklet_struct rx_tasklet;
-- 
1.6.4.4

