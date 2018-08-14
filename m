Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41341 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJgu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:50 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/24] staging: wilc1000: move static variable 'terminated_handle' to wilc_vif struct
Date: Tue, 14 Aug 2018 12:20:04 +0530
Message-ID: <1534229416-13254-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085104_491860_AEAF9162)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the use of static variable 'terminated_handle' and instead move
in wilc_vif struct.
After moving this variable to wilc_vif struct its not required to keep
'terminated_handle', so changed it to boolean type.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 11 +++++------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d5d81843..f71f451f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -185,7 +185,6 @@ struct join_bss_param {
 	u8 start_time[4];
 };
 
-static struct host_if_drv *terminated_handle;
 static u8 p2p_listen_state;
 static struct timer_list periodic_rssi;
 static struct wilc_vif *periodic_rssi_vif;
@@ -3505,7 +3504,7 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	mutex_lock(&vif->wilc->hif_deinit_lock);
 
-	terminated_handle = hif_drv;
+	vif->is_termination_progress = true;
 
 	del_timer_sync(&hif_drv->scan_timer);
 	del_timer_sync(&hif_drv->connect_timer);
@@ -3543,7 +3542,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	kfree(hif_drv);
 
 	vif->wilc->clients_count--;
-	terminated_handle = NULL;
+	vif->is_termination_progress = false;
 	mutex_unlock(&vif->wilc->hif_deinit_lock);
 	return result;
 }
@@ -3565,7 +3564,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	hif_drv = vif->hif_drv;
 
-	if (!hif_drv || hif_drv == terminated_handle) {
+	if (!hif_drv || vif->is_termination_progress) {
 		netdev_err(vif->ndev, "driver not init[%p]\n", hif_drv);
 		return;
 	}
@@ -3611,7 +3610,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 	hif_drv = vif->hif_drv;
 
-	if (!hif_drv || hif_drv == terminated_handle) {
+	if (!hif_drv || vif->is_termination_progress) {
 		mutex_unlock(&wilc->hif_deinit_lock);
 		return;
 	}
@@ -3662,7 +3661,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	hif_drv = vif->hif_drv;
 
-	if (!hif_drv || hif_drv == terminated_handle)
+	if (!hif_drv || vif->is_termination_progress)
 		return;
 
 	if (hif_drv->usr_scan_req.scan_result) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index eb00e42..ba606d0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -121,6 +121,7 @@ struct wilc_vif {
 	struct timer_list during_ip_timer;
 	bool obtaining_ip;
 	u8 mc_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
+	bool is_termination_progress;
 };
 
 struct wilc {
-- 
2.7.4
