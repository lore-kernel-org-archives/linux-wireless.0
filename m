Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46871 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755818AbeDYRTn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:43 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 08/21] staging: wilc1000: remove unused variable scan_while_connected
Date: Wed, 25 Apr 2018 22:48:13 +0530
Message-ID: <1524676706-13179-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191953_084939_9C46F734)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unused variable.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 12414f4..1b282b0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -242,8 +242,6 @@ u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
-static bool scan_while_connected;
-
 static s8 rssi;
 static u8 set_ip[2][4];
 static u8 get_ip[2][4];
@@ -839,11 +837,6 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	wid_list[index].val = (s8 *)&scan_info->src;
 	index++;
 
-	if (hif_drv->hif_state == HOST_IF_CONNECTED)
-		scan_while_connected = true;
-	else if (hif_drv->hif_state == HOST_IF_IDLE)
-		scan_while_connected = false;
-
 	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
 				      index,
 				      wilc_get_vif_idx(vif));
@@ -1182,8 +1175,6 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 
 	hif_drv->hif_state = HOST_IF_IDLE;
 
-	scan_while_connected = false;
-
 	memset(&info, 0, sizeof(struct connect_info));
 
 	if (hif_drv->usr_conn_req.conn_result) {
@@ -1410,7 +1401,6 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 			  jiffies + msecs_to_jiffies(10000));
 	} else {
 		hif_drv->hif_state = HOST_IF_IDLE;
-		scan_while_connected = false;
 	}
 
 	kfree(conn_info.resp_ies);
@@ -1452,7 +1442,6 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 
 	host_int_free_user_conn_req(hif_drv);
 	hif_drv->hif_state = HOST_IF_IDLE;
-	scan_while_connected = false;
 }
 
 static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
@@ -1830,8 +1819,6 @@ static void handle_disconnect(struct wilc_vif *vif)
 		netdev_err(vif->ndev, "conn_result = NULL\n");
 	}
 
-	scan_while_connected = false;
-
 	hif_drv->hif_state = HOST_IF_IDLE;
 
 	eth_zero_addr(hif_drv->assoc_bssid);
@@ -3339,8 +3326,6 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	scan_while_connected = false;
-
 	init_completion(&hif_wait_response);
 
 	hif_drv  = kzalloc(sizeof(*hif_drv), GFP_KERNEL);
@@ -3436,8 +3421,6 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	hif_drv->hif_state = HOST_IF_IDLE;
 
-	scan_while_connected = false;
-
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (clients_count == 1)	{
-- 
2.7.4
