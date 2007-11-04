Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ro-out-1112.google.com ([72.14.202.180]:54346 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597AbXKDC2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2007 22:28:16 -0400
Received: by ro-out-1112.google.com with SMTP id p4so1394413roc
        for <linux-wireless@vger.kernel.org>; Sat, 03 Nov 2007 19:28:15 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: Retry frame transmission when driver is busy.
From: Ashish Shukla <javier@cozybit.com>
Date: Sat, 03 Nov 2007 19:28:14 -0700 (PDT)
Message-ID: <472d2e3e.18b38c0a.2c31.1a76@mx.google.com> (sfid-20071104_022821_883307_38412297)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver silently discards frames when some command is pending -- returns
NETDEV_TX_OK to kernel. The following patch fixes this problem.  This
significantly improves file transfers while scanning (ticket #3341).

Signed-off-by: Javier Cardona <javier@cozybit.com>

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 83d534b..f72ebe2 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -509,22 +509,25 @@ static int libertas_close(struct net_device *dev)
 
 static int libertas_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	int ret = 0;
+	int ret = NETDEV_TX_OK;
 	wlan_private *priv = dev->priv;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
-	if (priv->dnld_sent || priv->adapter->TxLockFlag) {
-		priv->stats.tx_dropped++;
-		goto done;
-	}
-
 	netif_stop_queue(priv->dev);
 	if (priv->mesh_dev)
 		netif_stop_queue(priv->mesh_dev);
 
-	if (libertas_process_tx(priv, skb) == 0)
+	if (priv->dnld_sent || priv->adapter->TxLockFlag) {
+		ret = NETDEV_TX_BUSY;
+		goto done;
+	}
+
+	ret = libertas_process_tx(priv, skb);
+	if (ret == NETDEV_TX_OK)
 		dev->trans_start = jiffies;
+	else if (ret == -1)
+		ret = NETDEV_TX_OK;
 done:
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
 	return ret;
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index bc9c2e1..1dc92ee 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -218,6 +218,7 @@ int libertas_process_tx(wlan_private * priv, struct sk_buff *skb)
 	if (priv->dnld_sent) {
 		lbs_pr_alert( "TX error: dnld_sent = %d, not sending\n",
 		       priv->dnld_sent);
+		ret = NETDEV_TX_BUSY;
 		goto done;
 	}
 
-- 
1.5.2.4



