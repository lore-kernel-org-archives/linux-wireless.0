Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60944 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaAMQVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 11:21:25 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so6696269wgh.34
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 08:21:24 -0800 (PST)
Message-ID: <1389630069.2590.2.camel@canaries32-MCP7A> (sfid-20140113_172137_632283_010542A6)
Subject: [PATCH 3/6] staging: vt6656: sparse fixes ethtool_ioctl Use struct
 ifreq *
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 16:21:09 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace useraddr with direct point to struct ifreq->ifr_data

sparse warnings
main_usb.c:1443:44: warning: cast removes address space of expression
main_usb.c:1454:37: warning: incorrect type in argument 2 (different address spaces)
main_usb.c:1454:37:    expected void const [noderef] <asn:1>*from
main_usb.c:1454:37:    got void *useraddr
main_usb.c:1462:34: warning: incorrect type in argument 1 (different address spaces)
main_usb.c:1462:34:    expected void [noderef] <asn:1>*to
main_usb.c:1462:34:    got void *useraddr

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 59c2430..9e5ed30 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -219,7 +219,7 @@ static bool device_init_defrag_cb(struct vnt_private *pDevice);
 static void device_init_diversity_timer(struct vnt_private *pDevice);
 static int  device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev);
 
-static int  ethtool_ioctl(struct net_device *dev, void *useraddr);
+static int  ethtool_ioctl(struct net_device *dev, struct ifreq *);
 static void device_free_tx_bufs(struct vnt_private *pDevice);
 static void device_free_rx_bufs(struct vnt_private *pDevice);
 static void device_free_int_bufs(struct vnt_private *pDevice);
@@ -1440,18 +1440,18 @@ static int device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		break;
 
 	case SIOCETHTOOL:
-		return ethtool_ioctl(dev, (void *) rq->ifr_data);
+		return ethtool_ioctl(dev, rq);
 
 	}
 
 	return rc;
 }
 
-static int ethtool_ioctl(struct net_device *dev, void *useraddr)
+static int ethtool_ioctl(struct net_device *dev, struct ifreq *rq)
 {
 	u32 ethcmd;
 
-	if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
+	if (copy_from_user(&ethcmd, rq->ifr_data, sizeof(ethcmd)))
 		return -EFAULT;
 
         switch (ethcmd) {
@@ -1459,7 +1459,7 @@ static int ethtool_ioctl(struct net_device *dev, void *useraddr)
 		struct ethtool_drvinfo info = {ETHTOOL_GDRVINFO};
 		strncpy(info.driver, DEVICE_NAME, sizeof(info.driver)-1);
 		strncpy(info.version, DEVICE_VERSION, sizeof(info.version)-1);
-		if (copy_to_user(useraddr, &info, sizeof(info)))
+		if (copy_to_user(rq->ifr_data, &info, sizeof(info)))
 			return -EFAULT;
 		return 0;
 	}
-- 
1.8.5.2

