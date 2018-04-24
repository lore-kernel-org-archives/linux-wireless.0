Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:63720 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbeDXRHd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:07:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/2] staging: wilc1000: remove registering of ndo_do_ioctl callback
Date: Tue, 24 Apr 2018 22:37:02 +0530
Message-ID: <1524589623-1534-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180424_190735_917061_E5CE4200)
In-Reply-To: <1524589623-1534-1-git-send-email-ajay.kathat@microchip.com>
References: <1524589623-1534-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove registering of ndo_do_ioctl in wilc_netdev_ops structure.
As RSSI information is already avaliable through cfg80211, so remove
the IOCTL call use to fetch the same information. Wext support is not
present in the driver. Its also done to address the TODO list item
mentioned below:

"use wext-core handling instead of private SIOCSIWPRIV implementation"

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 63 -----------------------------------
 1 file changed, 63 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 38a83bd..08871f5 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -37,7 +37,6 @@ static void wlan_deinitialize_threads(struct net_device *dev);
 static void linux_wlan_tx_complete(void *priv, int status);
 static int  mac_init_fn(struct net_device *ndev);
 static struct net_device_stats *mac_stats(struct net_device *dev);
-static int  mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd);
 static int wilc_mac_open(struct net_device *ndev);
 static int wilc_mac_close(struct net_device *ndev);
 static void wilc_set_multicast_list(struct net_device *dev);
@@ -49,7 +48,6 @@ static const struct net_device_ops wilc_netdev_ops = {
 	.ndo_open = wilc_mac_open,
 	.ndo_stop = wilc_mac_close,
 	.ndo_start_xmit = wilc_mac_xmit,
-	.ndo_do_ioctl = mac_ioctl,
 	.ndo_get_stats = mac_stats,
 	.ndo_set_rx_mode  = wilc_set_multicast_list,
 
@@ -1049,67 +1047,6 @@ static int wilc_mac_close(struct net_device *ndev)
 	return 0;
 }
 
-static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
-{
-	u8 *buff = NULL;
-	s8 rssi;
-	u32 size = 0;
-	struct wilc_vif *vif;
-	s32 ret = 0;
-	struct wilc *wilc;
-
-	vif = netdev_priv(ndev);
-	wilc = vif->wilc;
-
-	if (!wilc->initialized)
-		return 0;
-
-	switch (cmd) {
-	case SIOCSIWPRIV:
-	{
-		struct iwreq *wrq = (struct iwreq *)req;
-
-		size = wrq->u.data.length;
-
-		if (size && wrq->u.data.pointer) {
-			buff = memdup_user(wrq->u.data.pointer,
-					   wrq->u.data.length);
-			if (IS_ERR(buff))
-				return PTR_ERR(buff);
-
-			if (strncasecmp(buff, "RSSI", size) == 0) {
-				ret = wilc_get_rssi(vif, &rssi);
-				netdev_info(ndev, "RSSI :%d\n", rssi);
-
-				rssi += 5;
-
-				snprintf(buff, size, "rssi %d", rssi);
-
-				if (copy_to_user(wrq->u.data.pointer, buff, size)) {
-					netdev_err(ndev, "failed to copy\n");
-					ret = -EFAULT;
-					goto done;
-				}
-			}
-		}
-	}
-	break;
-
-	default:
-	{
-		netdev_info(ndev, "Command - %d - has been received\n", cmd);
-		ret = -EOPNOTSUPP;
-		goto done;
-	}
-	}
-
-done:
-
-	kfree(buff);
-
-	return ret;
-}
-
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 {
 	unsigned int frame_len = 0;
-- 
2.7.4
