Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3364 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbeFZGHa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:30 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/12] staging: wilc1000: remove 'hif_thread_comp' completions
Date: Tue, 26 Jun 2018 11:37:07 +0530
Message-ID: <1529993234-27294-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080734_058311_A261AC20)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove 'hif_thread_comp' completions as its not required after adding
completion event as part work data to handle each sync call.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 35 -------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 27516f7..17c20b9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -186,7 +186,6 @@ static struct host_if_drv *terminated_handle;
 bool wilc_optaining_ip;
 static u8 p2p_listen_state;
 static struct workqueue_struct *hif_workqueue;
-static struct completion hif_thread_comp;
 static struct completion hif_driver_comp;
 static struct mutex hif_deinit_lock;
 static struct timer_list periodic_rssi;
@@ -286,7 +285,6 @@ static void handle_set_channel(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set channel\n");
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_set_wfi_drv_handler(struct work_struct *work)
@@ -334,7 +332,6 @@ static void handle_set_wfi_drv_handler(struct work_struct *work)
 
 free_msg:
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_set_operation_mode(struct work_struct *work)
@@ -359,7 +356,6 @@ static void handle_set_operation_mode(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_set_ip_address(struct work_struct *work)
@@ -390,7 +386,6 @@ static void handle_set_ip_address(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set IP address\n");
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_get_ip_address(struct work_struct *work)
@@ -419,7 +414,6 @@ static void handle_get_ip_address(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get IP address\n");
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_get_mac_address(struct work_struct *work)
@@ -442,7 +436,6 @@ static void handle_get_mac_address(struct work_struct *work)
 		netdev_err(vif->ndev, "Failed to get mac address\n");
 	complete(&msg->work_comp);
 	/* free 'msg' data later, in caller */
-	complete(&hif_thread_comp);
 }
 
 static void handle_cfg_param(struct work_struct *work)
@@ -739,7 +732,6 @@ static void handle_cfg_param(struct work_struct *work)
 unlock:
 	mutex_unlock(&hif_drv->cfg_values_lock);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_scan(struct work_struct *work)
@@ -857,7 +849,6 @@ static void handle_scan(struct work_struct *work)
 	kfree(hdn_ntwk_wid_val);
 
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
@@ -1163,7 +1154,6 @@ static void handle_connect(struct work_struct *work)
 
 	kfree(cur_byte);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_connect_timeout(struct work_struct *work)
@@ -1235,7 +1225,6 @@ static void handle_connect_timeout(struct work_struct *work)
 
 out:
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_rcvd_ntwrk_info(struct work_struct *work)
@@ -1304,7 +1293,6 @@ static void handle_rcvd_ntwrk_info(struct work_struct *work)
 	}
 
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
@@ -1495,7 +1483,6 @@ static void handle_rcvd_gnrl_async_info(struct work_struct *work)
 
 free_msg:
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static int wilc_pmksa_key_copy(struct wilc_vif *vif, struct key_attr *hif_key)
@@ -1760,7 +1747,6 @@ static void handle_key(struct work_struct *work)
 		netdev_err(vif->ndev, "Failed to send key config packet\n");
 
 	/* free 'msg' data in caller sync call */
-	complete(&hif_thread_comp);
 }
 
 static void handle_disconnect(struct work_struct *work)
@@ -1835,7 +1821,6 @@ static void handle_disconnect(struct work_struct *work)
 
 	complete(&msg->work_comp);
 	/* free 'msg' in caller after receiving completion */
-	complete(&hif_thread_comp);
 }
 
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
@@ -1866,7 +1851,6 @@ static void handle_get_rssi(struct work_struct *work)
 
 	complete(&msg->work_comp);
 	/* free 'msg' data in caller */
-	complete(&hif_thread_comp);
 }
 
 static void handle_get_statistics(struct work_struct *work)
@@ -1925,8 +1909,6 @@ static void handle_get_statistics(struct work_struct *work)
 		complete(&msg->work_comp);
 	else
 		kfree(msg);
-
-	complete(&hif_thread_comp);
 }
 
 static void handle_get_inactive_time(struct work_struct *work)
@@ -1969,7 +1951,6 @@ static void handle_get_inactive_time(struct work_struct *work)
 out:
 	/* free 'msg' data in caller */
 	complete(&msg->work_comp);
-	complete(&hif_thread_comp);
 }
 
 static void handle_add_beacon(struct work_struct *work)
@@ -2026,7 +2007,6 @@ static void handle_add_beacon(struct work_struct *work)
 	kfree(param->head);
 	kfree(param->tail);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_del_beacon(struct work_struct *work)
@@ -2047,7 +2027,6 @@ static void handle_del_beacon(struct work_struct *work)
 	if (result)
 		netdev_err(vif->ndev, "Failed to send delete beacon\n");
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static u32 wilc_hif_pack_sta_param(u8 *buff, struct add_sta_param *param)
@@ -2109,7 +2088,6 @@ static void handle_add_station(struct work_struct *work)
 	kfree(param->rates);
 	kfree(wid.val);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_del_all_sta(struct work_struct *work)
@@ -2154,7 +2132,6 @@ static void handle_del_all_sta(struct work_struct *work)
 
 	/* free 'msg' data in caller */
 	complete(&msg->work_comp);
-	complete(&hif_thread_comp);
 }
 
 static void handle_del_station(struct work_struct *work)
@@ -2183,7 +2160,6 @@ static void handle_del_station(struct work_struct *work)
 error:
 	kfree(wid.val);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_edit_station(struct work_struct *work)
@@ -2215,7 +2191,6 @@ static void handle_edit_station(struct work_struct *work)
 	kfree(param->rates);
 	kfree(wid.val);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static int handle_remain_on_chan(struct wilc_vif *vif,
@@ -2316,7 +2291,6 @@ static void handle_register_frame(struct work_struct *work)
 
 out:
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_listen_state_expired(struct work_struct *work)
@@ -2361,7 +2335,6 @@ static void handle_listen_state_expired(struct work_struct *work)
 
 free_msg:
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void listen_timer_cb(struct timer_list *t)
@@ -2411,7 +2384,6 @@ static void handle_power_management(struct work_struct *work)
 	if (result)
 		netdev_err(vif->ndev, "Failed to send power management\n");
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_set_mcast_filter(struct work_struct *work)
@@ -2453,7 +2425,6 @@ static void handle_set_mcast_filter(struct work_struct *work)
 error:
 	kfree(wid.val);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_set_tx_pwr(struct work_struct *work)
@@ -2474,7 +2445,6 @@ static void handle_set_tx_pwr(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set TX PWR\n");
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 /* Note: 'msg' will be free after using data */
@@ -2497,7 +2467,6 @@ static void handle_get_tx_pwr(struct work_struct *work)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
 	complete(&msg->work_comp);
-	complete(&hif_thread_comp);
 }
 
 static void handle_scan_timer(struct work_struct *work)
@@ -2506,7 +2475,6 @@ static void handle_scan_timer(struct work_struct *work)
 
 	handle_scan_done(msg->vif, SCAN_EVENT_ABORTED);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_remain_on_chan_work(struct work_struct *work)
@@ -2515,7 +2483,6 @@ static void handle_remain_on_chan_work(struct work_struct *work)
 
 	handle_remain_on_chan(msg->vif, &msg->body.remain_on_ch);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void handle_hif_exit_work(struct work_struct *work)
@@ -2541,7 +2508,6 @@ static void handle_scan_complete(struct work_struct *work)
 	if (msg->vif->hif_drv->remain_on_ch_pending)
 		handle_remain_on_chan(msg->vif, &msg->body.remain_on_ch);
 	kfree(msg);
-	complete(&hif_thread_comp);
 }
 
 static void timer_scan_cb(struct timer_list *t)
@@ -3343,7 +3309,6 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	wilc_optaining_ip = false;
 
 	if (clients_count == 0) {
-		init_completion(&hif_thread_comp);
 		init_completion(&hif_driver_comp);
 		mutex_init(&hif_deinit_lock);
 	}
-- 
2.7.4
