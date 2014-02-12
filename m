Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36345 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaBLTYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:24:47 -0500
Received: by mail-wi0-f173.google.com with SMTP id hn9so7496787wib.12
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:24:46 -0800 (PST)
Message-ID: <1392232957.4053.8.camel@canaries32-MCP7A> (sfid-20140212_202450_484944_87085A04)
Subject: [PATCH 3/3] staging: vt6656: camel case and clean up
 devie_set_multi
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Feb 2014 19:22:37 +0000
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean up

Camel case changes
pDevice -> priv
pMgmt -> mgmt
byTmpMode -> tmp

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 91 ++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e682c9d..eca7d24 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1350,62 +1350,63 @@ static int Read_config_file(struct vnt_private *pDevice)
 
 static void device_set_multi(struct net_device *dev)
 {
-	struct vnt_private *pDevice = netdev_priv(dev);
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_private *priv = netdev_priv(dev);
+	struct vnt_manager *mgmt = &priv->vnt_mgmt;
 	struct netdev_hw_addr *ha;
 	u64 mc_filter = 0;
-	u8 byTmpMode = 0;
+	u8 tmp = 0;
 	int rc;
 
-	spin_lock_irq(&pDevice->lock);
-    rc = CONTROLnsRequestIn(pDevice,
-                            MESSAGE_TYPE_READ,
-                            MAC_REG_RCR,
-                            MESSAGE_REQUEST_MACREG,
-                            1,
-                            &byTmpMode
-                            );
-    if (rc == 0) pDevice->byRxMode = byTmpMode;
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRxMode in= %x\n", pDevice->byRxMode);
-
-    if (dev->flags & IFF_PROMISC) { /* set promiscuous mode */
-        DBG_PRT(MSG_LEVEL_ERR,KERN_NOTICE "%s: Promiscuous mode enabled.\n", dev->name);
-	/* unconditionally log net taps */
-        pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST|RCR_UNICAST);
-    }
-    else if ((netdev_mc_count(dev) > pDevice->multicast_limit) ||
-	     (dev->flags & IFF_ALLMULTI)) {
-	mc_filter = ~0x0;
-	MACvWriteMultiAddr(pDevice, mc_filter);
+	spin_lock_irq(&priv->lock);
 
-        pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
-    }
-    else {
-	netdev_for_each_mc_addr(ha, dev) {
-		int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
+	rc = CONTROLnsRequestIn(priv, MESSAGE_TYPE_READ,
+		MAC_REG_RCR, MESSAGE_REQUEST_MACREG, 1, &tmp);
+	if (rc == 0)
+		priv->byRxMode = tmp;
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "priv->byRxMode in= %x\n",
+							priv->byRxMode);
+
+	if (dev->flags & IFF_PROMISC) { /* set promiscuous mode */
+		DBG_PRT(MSG_LEVEL_ERR, KERN_NOTICE
+			"%s: Promiscuous mode enabled.\n", dev->name);
+		/* unconditionally log net taps */
+		priv->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST|RCR_UNICAST);
+	} else if ((netdev_mc_count(dev) > priv->multicast_limit) ||
+			(dev->flags & IFF_ALLMULTI)) {
+		mc_filter = ~0x0;
+		MACvWriteMultiAddr(priv, mc_filter);
+
+		priv->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
+	} else {
+		netdev_for_each_mc_addr(ha, dev) {
+			int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
 
-		mc_filter |= 1ULL << (bit_nr & 0x3f);
+			mc_filter |= 1ULL << (bit_nr & 0x3f);
+		}
+
+		MACvWriteMultiAddr(priv, mc_filter);
+
+		priv->byRxMode &= ~(RCR_UNICAST);
+		priv->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
 	}
 
-	MACvWriteMultiAddr(pDevice, mc_filter);
+	if (mgmt->eConfigMode == WMAC_CONFIG_AP) {
+		/*
+		 * If AP mode, don't enable RCR_UNICAST since HW only compares
+		 * addr1 with local MAC
+		 */
+		priv->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
+		priv->byRxMode &= ~(RCR_UNICAST);
+	}
 
-        pDevice->byRxMode &= ~(RCR_UNICAST);
-        pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
-    }
+	ControlvWriteByte(priv, MESSAGE_REQUEST_MACREG,
+					MAC_REG_RCR, priv->byRxMode);
 
-    if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
-	/*
-	 * If AP mode, don't enable RCR_UNICAST since HW only compares
-	 * addr1 with local MAC
-	 */
-        pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
-        pDevice->byRxMode &= ~(RCR_UNICAST);
-    }
-    ControlvWriteByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_RCR, pDevice->byRxMode);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRxMode out= %x\n", pDevice->byRxMode);
-	spin_unlock_irq(&pDevice->lock);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"priv->byRxMode out= %x\n", priv->byRxMode);
 
+	spin_unlock_irq(&priv->lock);
 }
 
 static struct net_device_stats *device_get_stats(struct net_device *dev)
-- 
1.8.5.3

