Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27133 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030617AbbKEFg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:59 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 36/38] staging: wilc1000: rename s32Error of mac_ioctl function
Date: Thu, 5 Nov 2015 14:36:37 +0900
Message-ID: <1446701799-24870-36-git-send-email-glen.lee@atmel.com> (sfid-20151105_063705_131739_68A4EA71)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename s32Error variable of mac_ioctl function to ret
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f2de20b..f1dcdfb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1344,7 +1344,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	u32 size = 0, length = 0;
 	perInterface_wlan_t *nic;
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
+	s32 ret = 0;
 	struct wilc *wilc;
 
 	nic = netdev_priv(ndev);
@@ -1368,8 +1368,9 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
 				priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
-				s32Error = host_int_get_rssi(priv->hWILCWFIDrv, &(rssi));
-				if (s32Error)
+				ret = host_int_get_rssi(priv->hWILCWFIDrv,
+							&rssi);
+				if (ret)
 					PRINT_ER("Failed to send get rssi param's message queue ");
 				PRINT_INFO(GENERIC_DBG, "RSSI :%d\n", rssi);
 
@@ -1379,7 +1380,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 				if (copy_to_user(wrq->u.data.pointer, buff, size)) {
 					PRINT_ER("%s: failed to copy data to user buffer\n", __func__);
-					s32Error = -EFAULT;
+					ret = -EFAULT;
 					goto done;
 				}
 			}
@@ -1390,7 +1391,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	default:
 	{
 		PRINT_INFO(GENERIC_DBG, "Command - %d - has been received\n", cmd);
-		s32Error = -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
 		goto done;
 	}
 	}
@@ -1399,7 +1400,7 @@ done:
 
 	kfree(buff);
 
-	return s32Error;
+	return ret;
 }
 
 void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
-- 
1.9.1

