Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57907 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJgx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 13/24] staging: wilc1000: move 'periodic_rssi' as part of 'wilc_vif' struct
Date: Tue, 14 Aug 2018 12:20:05 +0530
Message-ID: <1534229416-13254-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085107_741243_3C41B385)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor code to move 'periodic_rssi' as part of wilc_vif struct.Move
'dummy_statistics' from 'wilc' struct to 'wilc_vif' to maintain for
each interface separatly.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 19 ++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  3 ++-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f71f451f..a440f84 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -186,8 +186,6 @@ struct join_bss_param {
 };
 
 static u8 p2p_listen_state;
-static struct timer_list periodic_rssi;
-static struct wilc_vif *periodic_rssi_vif;
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
@@ -3417,9 +3415,9 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 	return result;
 }
 
-static void get_periodic_rssi(struct timer_list *unused)
+static void get_periodic_rssi(struct timer_list *t)
 {
-	struct wilc_vif *vif = periodic_rssi_vif;
+	struct wilc_vif *vif = from_timer(vif, t, periodic_rssi);
 
 	if (!vif->hif_drv) {
 		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
@@ -3427,9 +3425,9 @@ static void get_periodic_rssi(struct timer_list *unused)
 	}
 
 	if (vif->hif_drv->hif_state == HOST_IF_CONNECTED)
-		wilc_get_statistics(vif, &vif->wilc->dummy_statistics, false);
+		wilc_get_statistics(vif, &vif->dummy_statistics, false);
 
-	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
+	mod_timer(&vif->periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
 
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
@@ -3463,12 +3461,11 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 			kfree(hif_drv);
 			return -ENOMEM;
 		}
-
-		periodic_rssi_vif = vif;
-		timer_setup(&periodic_rssi, get_periodic_rssi, 0);
-		mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 	}
 
+	timer_setup(&vif->periodic_rssi, get_periodic_rssi, 0);
+	mod_timer(&vif->periodic_rssi, jiffies + msecs_to_jiffies(5000));
+
 	timer_setup(&hif_drv->scan_timer, timer_scan_cb, 0);
 	timer_setup(&hif_drv->connect_timer, timer_connect_cb, 0);
 	timer_setup(&hif_drv->remain_on_ch_timer, listen_timer_cb, 0);
@@ -3508,7 +3505,7 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	del_timer_sync(&hif_drv->scan_timer);
 	del_timer_sync(&hif_drv->connect_timer);
-	del_timer_sync(&periodic_rssi);
+	del_timer_sync(&vif->periodic_rssi);
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
 	wilc_set_wfi_drv_handler(vif, 0, 0, 0);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ba606d0..cdb90c3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -122,6 +122,8 @@ struct wilc_vif {
 	bool obtaining_ip;
 	u8 mc_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 	bool is_termination_progress;
+	struct timer_list periodic_rssi;
+	struct rf_info dummy_statistics;
 };
 
 struct wilc {
@@ -171,7 +173,6 @@ struct wilc {
 	struct device *dev;
 	bool suspend_event;
 
-	struct rf_info dummy_statistics;
 	bool enable_ps;
 	int clients_count;
 	struct workqueue_struct *hif_workqueue;
-- 
2.7.4
