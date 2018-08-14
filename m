Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41331 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731824AbeHNJgk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:40 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/24] staging: wilc1000: move static variable clients_count to 'wilc' structure
Date: Tue, 14 Aug 2018 12:20:01 +0530
Message-ID: <1534229416-13254-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085054_337689_5C3B295D)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid use of static variable 'clients_count' and move it part of 'wilc'
structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 9 ++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6225e67..d930f06 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -199,7 +199,6 @@ static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
-static u32 clients_count;
 
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 
@@ -3456,7 +3455,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	vif->obtaining_ip = false;
 
-	if (clients_count == 0) {
+	if (wilc->clients_count == 0) {
 		init_completion(&hif_driver_comp);
 		mutex_init(&hif_deinit_lock);
 
@@ -3490,7 +3489,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	mutex_unlock(&hif_drv->cfg_values_lock);
 
-	clients_count++;
+	wilc->clients_count++;
 
 	return 0;
 }
@@ -3526,7 +3525,7 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	hif_drv->hif_state = HOST_IF_IDLE;
 
-	if (clients_count == 1)	{
+	if (vif->wilc->clients_count == 1) {
 		struct host_if_msg *msg;
 
 		msg = wilc_alloc_work(vif, handle_hif_exit_work, true);
@@ -3544,7 +3543,7 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	kfree(hif_drv);
 
-	clients_count--;
+	vif->wilc->clients_count--;
 	terminated_handle = NULL;
 	mutex_unlock(&hif_deinit_lock);
 	return result;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 8e56a28..8cccbbc 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -171,6 +171,7 @@ struct wilc {
 
 	struct rf_info dummy_statistics;
 	bool enable_ps;
+	int clients_count;
 };
 
 struct wilc_wfi_mon_priv {
-- 
2.7.4
