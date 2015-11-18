Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20847 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbbKRGJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:57 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/16] staging: wilc1000: use wilc instead of wilc_dev and remove wilc_dev
Date: Wed, 18 Nov 2015 15:11:37 +0900
Message-ID: <1447827097-9436-17-git-send-email-glen.lee@atmel.com> (sfid-20151118_071409_440346_09E1165C)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes wilc_dev with wilc in the function call
wilc_wlan_get_num_conn_ifcs, and remove wilc_dev and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c     | 2 +-
 drivers/staging/wilc1000/linux_wlan.c         | 5 +----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 43b77b7..e366366 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2919,7 +2919,7 @@ static int hostIFthread(void *pvArg)
 			del_timer(&hif_drv->scan_timer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
-			if (!wilc_wlan_get_num_conn_ifcs(wilc_dev))
+			if (!wilc_wlan_get_num_conn_ifcs(wilc))
 				wilc_chip_sleep_manually(wilc);
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index cd471ab..73954f4 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -43,8 +43,6 @@ static int  mac_init_fn(struct net_device *ndev);
 static struct net_device_stats *mac_stats(struct net_device *dev);
 static int  mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd);
 static void wilc_set_multicast_list(struct net_device *dev);
-struct wilc *wilc_dev;
-EXPORT_SYMBOL_GPL(wilc_dev);
 
 bool wilc_enable_ps = true;
 
@@ -1432,7 +1430,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 	sema_init(&close_exit_sync, 0);
 
-	wl = kzalloc(sizeof(*wilc_dev), GFP_KERNEL);
+	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
 	if (!wl)
 		return -ENOMEM;
 
@@ -1495,7 +1493,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		nic->iftype = STATION_MODE;
 		nic->mac_opened = 0;
 	}
-	wilc_dev = *wilc = wl;
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 4c8de8b..212d607 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -205,7 +205,6 @@ struct WILC_WFI_mon_priv {
 
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 
-extern struct wilc *wilc_dev;
 extern struct net_device *WILC_WFI_devs[];
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
-- 
1.9.1

