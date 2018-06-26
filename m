Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:10207 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbeFZGH0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:26 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/12] staging: wilc1000: added 'work_comp' completion as part of host_if_msg
Date: Tue, 26 Jun 2018 11:37:06 +0530
Message-ID: <1529993234-27294-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080733_497591_57C5B315)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added 'work_comp' completion in 'host_if_msg'. It allows handling the
sync call to wait for sepecific completion event.
The commands can be run in sync way waiting for their specific
completion event.
Added is_sync flag in wilc_create_work_queue() to handle the sync call to
host interface.

After adding completion as part of host_if_msg now
below completion are not required
 comp_test_key_block;
 comp_test_disconn_block
 comp_get_rssi
 comp_inactive_time
 hif_wait_response

Modified wilc_get_statistics() API to handle get statistic in sync &
async way.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 256 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |   7 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   2 +-
 3 files changed, 132 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cb627b0..27516f7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -149,6 +149,8 @@ struct host_if_msg {
 	struct wilc_vif *vif;
 	struct work_struct work;
 	void (*fn)(struct work_struct *ws);
+	struct completion work_comp;
+	bool is_sync;
 };
 
 struct join_bss_param {
@@ -186,7 +188,6 @@ static u8 p2p_listen_state;
 static struct workqueue_struct *hif_workqueue;
 static struct completion hif_thread_comp;
 static struct completion hif_driver_comp;
-static struct completion hif_wait_response;
 static struct mutex hif_deinit_lock;
 static struct timer_list periodic_rssi;
 static struct wilc_vif *periodic_rssi_vif;
@@ -205,8 +206,10 @@ static void *host_int_parse_join_bss_param(struct network_info *info);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt);
 
+/* 'msg' should be free by the caller for syc */
 static struct host_if_msg*
-wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *))
+wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *),
+		bool is_sync)
 {
 	struct host_if_msg *msg;
 
@@ -218,6 +221,9 @@ wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *))
 		return ERR_PTR(-ENOMEM);
 	msg->fn = work_fun;
 	msg->vif = vif;
+	msg->is_sync = is_sync;
+	if (is_sync)
+		init_completion(&msg->work_comp);
 
 	return msg;
 }
@@ -434,8 +440,8 @@ static void handle_get_mac_address(struct work_struct *work)
 
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get mac address\n");
-	complete(&hif_wait_response);
-	kfree(msg);
+	complete(&msg->work_comp);
+	/* free 'msg' data later, in caller */
 	complete(&hif_thread_comp);
 }
 
@@ -1618,7 +1624,7 @@ static void handle_key(struct work_struct *work)
 						      wilc_get_vif_idx(vif));
 		}
 out_wep:
-		complete(&hif_drv->comp_test_key_block);
+		complete(&msg->work_comp);
 		break;
 
 	case WPA_RX_GTK:
@@ -1682,7 +1688,7 @@ static void handle_key(struct work_struct *work)
 			kfree(key_buf);
 		}
 out_wpa_rx_gtk:
-		complete(&hif_drv->comp_test_key_block);
+		complete(&msg->work_comp);
 		kfree(hif_key->attr.wpa.key);
 		kfree(hif_key->attr.wpa.seq);
 		break;
@@ -1739,19 +1745,21 @@ static void handle_key(struct work_struct *work)
 		}
 
 out_wpa_ptk:
-		complete(&hif_drv->comp_test_key_block);
+		complete(&msg->work_comp);
 		kfree(hif_key->attr.wpa.key);
 		break;
 
 	case PMKSA:
 		result = wilc_pmksa_key_copy(vif, hif_key);
+		/*free 'msg', this case it not a sync call*/
+		kfree(msg);
 		break;
 	}
 
 	if (result)
 		netdev_err(vif->ndev, "Failed to send key config packet\n");
 
-	kfree(msg);
+	/* free 'msg' data in caller sync call */
 	complete(&hif_thread_comp);
 }
 
@@ -1825,8 +1833,8 @@ static void handle_disconnect(struct work_struct *work)
 
 out:
 
-	complete(&hif_drv->comp_test_disconn_block);
-	kfree(msg);
+	complete(&msg->work_comp);
+	/* free 'msg' in caller after receiving completion */
 	complete(&hif_thread_comp);
 }
 
@@ -1856,8 +1864,8 @@ static void handle_get_rssi(struct work_struct *work)
 	if (result)
 		netdev_err(vif->ndev, "Failed to get RSSI value\n");
 
-	complete(&vif->hif_drv->comp_get_rssi);
-	kfree(msg);
+	complete(&msg->work_comp);
+	/* free 'msg' data in caller */
 	complete(&hif_thread_comp);
 }
 
@@ -1912,9 +1920,12 @@ static void handle_get_statistics(struct work_struct *work)
 	else if (stats->link_speed != DEFAULT_LINK_SPEED)
 		wilc_enable_tcp_ack_filter(false);
 
-	if (stats != &vif->wilc->dummy_statistics)
-		complete(&hif_wait_response);
-	kfree(msg);
+	/* free 'msg' for async command, for sync caller will free it */
+	if (msg->is_sync)
+		complete(&msg->work_comp);
+	else
+		kfree(msg);
+
 	complete(&hif_thread_comp);
 }
 
@@ -1925,7 +1936,6 @@ static void handle_get_inactive_time(struct work_struct *work)
 	struct sta_inactive_t *hif_sta_inactive = &msg->body.mac_info;
 	s32 result = 0;
 	struct wid wid;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	wid.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	wid.type = WID_STR;
@@ -1957,9 +1967,8 @@ static void handle_get_inactive_time(struct work_struct *work)
 		netdev_err(vif->ndev, "Failed to get inactive time\n");
 
 out:
-	complete(&hif_drv->comp_inactive_time);
-
-	kfree(msg);
+	/* free 'msg' data in caller */
+	complete(&msg->work_comp);
 	complete(&hif_thread_comp);
 }
 
@@ -2143,8 +2152,8 @@ static void handle_del_all_sta(struct work_struct *work)
 error:
 	kfree(wid.val);
 
-	complete(&hif_wait_response);
-	kfree(msg);
+	/* free 'msg' data in caller */
+	complete(&msg->work_comp);
 	complete(&hif_thread_comp);
 }
 
@@ -2365,7 +2374,7 @@ static void listen_timer_cb(struct timer_list *t)
 
 	del_timer(&vif->hif_drv->remain_on_ch_timer);
 
-	msg = wilc_alloc_work(vif, handle_listen_state_expired);
+	msg = wilc_alloc_work(vif, handle_listen_state_expired, false);
 	if (IS_ERR(msg))
 		return;
 
@@ -2487,7 +2496,7 @@ static void handle_get_tx_pwr(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
-	complete(&hif_wait_response);
+	complete(&msg->work_comp);
 	complete(&hif_thread_comp);
 }
 
@@ -2513,8 +2522,8 @@ static void handle_hif_exit_work(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 
-	kfree(msg);
-	complete(&hif_thread_comp);
+	/* free 'msg' data in caller */
+	complete(&msg->work_comp);
 }
 
 static void handle_scan_complete(struct work_struct *work)
@@ -2542,7 +2551,7 @@ static void timer_scan_cb(struct timer_list *t)
 	struct host_if_msg *msg;
 	int result;
 
-	msg = wilc_alloc_work(vif, handle_scan_timer);
+	msg = wilc_alloc_work(vif, handle_scan_timer, false);
 	if (IS_ERR(msg))
 		return;
 
@@ -2559,7 +2568,7 @@ static void timer_connect_cb(struct timer_list *t)
 	struct host_if_msg *msg;
 	int result;
 
-	msg = wilc_alloc_work(vif, handle_connect_timeout);
+	msg = wilc_alloc_work(vif, handle_connect_timeout, false);
 	if (IS_ERR(msg))
 		return;
 
@@ -2580,7 +2589,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 		return result;
 	}
 
-	msg = wilc_alloc_work(vif, handle_key);
+	msg = wilc_alloc_work(vif, handle_key, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -2589,13 +2598,12 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 	msg->body.key_info.attr.wep.index = index;
 
 	result = wilc_enqueue_cmd(msg);
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Request to remove WEP key\n");
-		kfree(msg);
-	} else {
-		wait_for_completion(&hif_drv->comp_test_key_block);
-	}
+	else
+		wait_for_completion(&msg->work_comp);
 
+	kfree(msg);
 	return result;
 }
 
@@ -2611,7 +2619,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 		return result;
 	}
 
-	msg = wilc_alloc_work(vif, handle_key);
+	msg = wilc_alloc_work(vif, handle_key, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -2620,13 +2628,12 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 	msg->body.key_info.attr.wep.index = index;
 
 	result = wilc_enqueue_cmd(msg);
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Default key index\n");
-		kfree(msg);
-	} else {
-		wait_for_completion(&hif_drv->comp_test_key_block);
-	}
+	else
+		wait_for_completion(&msg->work_comp);
 
+	kfree(msg);
 	return result;
 }
 
@@ -2642,7 +2649,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 		return -EFAULT;
 	}
 
-	msg = wilc_alloc_work(vif, handle_key);
+	msg = wilc_alloc_work(vif, handle_key, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -2661,7 +2668,8 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	if (result)
 		goto free_key;
 
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	wait_for_completion(&msg->work_comp);
+	kfree(msg);
 	return 0;
 
 free_key:
@@ -2684,7 +2692,7 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 		return -EFAULT;
 	}
 
-	msg = wilc_alloc_work(vif, handle_key);
+	msg = wilc_alloc_work(vif, handle_key, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -2705,7 +2713,8 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	if (result)
 		goto free_key;
 
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	wait_for_completion(&msg->work_comp);
+	kfree(msg);
 	return 0;
 
 free_key:
@@ -2736,7 +2745,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	if (tx_mic)
 		key_len += TX_MIC_KEY_LEN;
 
-	msg = wilc_alloc_work(vif, handle_key);
+	msg = wilc_alloc_work(vif, handle_key, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -2772,7 +2781,8 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 		goto free_key;
 	}
 
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	wait_for_completion(&msg->work_comp);
+	kfree(msg);
 	return 0;
 
 free_key:
@@ -2798,7 +2808,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		return -EFAULT;
 	}
 
-	msg = wilc_alloc_work(vif, handle_key);
+	msg = wilc_alloc_work(vif, handle_key, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -2851,7 +2861,8 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		goto free_key;
 	}
 
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	wait_for_completion(&msg->work_comp);
+	kfree(msg);
 	return 0;
 
 free_key:
@@ -2872,7 +2883,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 	struct host_if_msg *msg;
 	int i;
 
-	msg = wilc_alloc_work(vif, handle_key);
+	msg = wilc_alloc_work(vif, handle_key, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -2900,20 +2911,20 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_get_mac_address);
+	msg = wilc_alloc_work(vif, handle_get_mac_address, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
 	msg->body.get_mac_info.mac_addr = mac_addr;
 
 	result = wilc_enqueue_cmd(msg);
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to send get mac address\n");
-		kfree(msg);
-		return -EFAULT;
-	}
+	else
+		wait_for_completion(&msg->work_comp);
+
+	kfree(msg);
 
-	wait_for_completion(&hif_wait_response);
 	return result;
 }
 
@@ -2937,7 +2948,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		return -EFAULT;
 	}
 
-	msg = wilc_alloc_work(vif, handle_connect);
+	msg = wilc_alloc_work(vif, handle_connect, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3013,18 +3024,17 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 		return -EFAULT;
 	}
 
-	msg = wilc_alloc_work(vif, handle_disconnect);
+	msg = wilc_alloc_work(vif, handle_disconnect, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
 	result = wilc_enqueue_cmd(msg);
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to send message: disconnect\n");
-		kfree(msg);
-	} else {
-		wait_for_completion(&hif_drv->comp_test_disconn_block);
-	}
+	else
+		wait_for_completion(&msg->work_comp);
 
+	kfree(msg);
 	return result;
 }
 
@@ -3058,7 +3068,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	int result;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_set_channel);
+	msg = wilc_alloc_work(vif, handle_set_channel, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3079,7 +3089,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_set_wfi_drv_handler);
+	msg = wilc_alloc_work(vif, handle_set_wfi_drv_handler, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3101,7 +3111,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg  = wilc_alloc_work(vif, handle_set_operation_mode);
+	msg  = wilc_alloc_work(vif, handle_set_operation_mode, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3127,21 +3137,20 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 		return -EFAULT;
 	}
 
-	msg = wilc_alloc_work(vif, handle_get_inactive_time);
+	msg = wilc_alloc_work(vif, handle_get_inactive_time, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
 	memcpy(msg->body.mac_info.mac, mac, ETH_ALEN);
 
 	result = wilc_enqueue_cmd(msg);
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
-		kfree(msg);
-	} else {
-		wait_for_completion(&hif_drv->comp_inactive_time);
-	}
+	else
+		wait_for_completion(&msg->work_comp);
 
 	*out_val = inactive_time;
+	kfree(msg);
 
 	return result;
 }
@@ -3150,37 +3159,36 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 {
 	int result = 0;
 	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	msg = wilc_alloc_work(vif, handle_get_rssi);
+	if (!rssi_level) {
+		netdev_err(vif->ndev, "RSS pointer value is null\n");
+		return -EFAULT;
+	}
+
+	msg = wilc_alloc_work(vif, handle_get_rssi, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
 	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
-		kfree(msg);
-		return result;
-	}
-
-	wait_for_completion(&hif_drv->comp_get_rssi);
-
-	if (!rssi_level) {
-		netdev_err(vif->ndev, "RSS pointer value is null\n");
-		return -EFAULT;
+	} else {
+		wait_for_completion(&msg->work_comp);
+		*rssi_level = rssi;
 	}
 
-	*rssi_level = rssi;
+	kfree(msg);
 
 	return result;
 }
 
-int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
+int
+wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats, bool is_sync)
 {
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_get_statistics);
+	msg = wilc_alloc_work(vif, handle_get_statistics, is_sync);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3193,8 +3201,11 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 		return result;
 	}
 
-	if (stats != &vif->wilc->dummy_statistics)
-		wait_for_completion(&hif_wait_response);
+	if (is_sync) {
+		wait_for_completion(&msg->work_comp);
+		kfree(msg);
+	}
+
 	return result;
 }
 
@@ -3213,7 +3224,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 		return -EFAULT;
 	}
 
-	msg = wilc_alloc_work(vif, handle_scan);
+	msg = wilc_alloc_work(vif, handle_scan, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3280,7 +3291,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 		return -EFAULT;
 	}
 
-	msg = wilc_alloc_work(vif, handle_cfg_param);
+	msg = wilc_alloc_work(vif, handle_cfg_param, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3302,7 +3313,7 @@ static void get_periodic_rssi(struct timer_list *unused)
 	}
 
 	if (vif->hif_drv->hif_state == HOST_IF_CONNECTED)
-		wilc_get_statistics(vif, &vif->wilc->dummy_statistics);
+		wilc_get_statistics(vif, &vif->wilc->dummy_statistics, false);
 
 	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
@@ -3317,8 +3328,6 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	init_completion(&hif_wait_response);
-
 	hif_drv  = kzalloc(sizeof(*hif_drv), GFP_KERNEL);
 	if (!hif_drv)
 		return -ENOMEM;
@@ -3339,11 +3348,6 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		mutex_init(&hif_deinit_lock);
 	}
 
-	init_completion(&hif_drv->comp_test_key_block);
-	init_completion(&hif_drv->comp_test_disconn_block);
-	init_completion(&hif_drv->comp_get_rssi);
-	init_completion(&hif_drv->comp_inactive_time);
-
 	if (clients_count == 0) {
 		hif_workqueue = create_singlethread_workqueue("WILC_wq");
 		if (!hif_workqueue) {
@@ -3414,7 +3418,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	if (clients_count == 1)	{
 		struct host_if_msg *msg;
 
-		msg = wilc_alloc_work(vif, handle_hif_exit_work);
+		msg = wilc_alloc_work(vif, handle_hif_exit_work, true);
 		if (IS_ERR(msg))
 			return PTR_ERR(msg);
 
@@ -3422,8 +3426,8 @@ int wilc_deinit(struct wilc_vif *vif)
 		if (result)
 			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
 		else
-			wait_for_completion(&hif_thread_comp);
-
+			wait_for_completion(&msg->work_comp);
+		kfree(msg);
 		destroy_workqueue(hif_workqueue);
 	}
 
@@ -3457,7 +3461,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	}
 
-	msg = wilc_alloc_work(vif, handle_rcvd_ntwrk_info);
+	msg = wilc_alloc_work(vif, handle_rcvd_ntwrk_info, false);
 	if (IS_ERR(msg))
 		return;
 
@@ -3509,7 +3513,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	}
 
-	msg = wilc_alloc_work(vif, handle_rcvd_gnrl_async_info);
+	msg = wilc_alloc_work(vif, handle_rcvd_gnrl_async_info, false);
 	if (IS_ERR(msg)) {
 		mutex_unlock(&hif_deinit_lock);
 		return;
@@ -3555,7 +3559,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 	if (hif_drv->usr_scan_req.scan_result) {
 		struct host_if_msg *msg;
 
-		msg = wilc_alloc_work(vif, handle_scan_complete);
+		msg = wilc_alloc_work(vif, handle_scan_complete, false);
 		if (IS_ERR(msg))
 			return;
 
@@ -3576,7 +3580,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_remain_on_chan_work);
+	msg = wilc_alloc_work(vif, handle_remain_on_chan_work, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3609,7 +3613,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 
 	del_timer(&hif_drv->remain_on_ch_timer);
 
-	msg = wilc_alloc_work(vif, handle_listen_state_expired);
+	msg = wilc_alloc_work(vif, handle_listen_state_expired, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3629,7 +3633,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_register_frame);
+	msg = wilc_alloc_work(vif, handle_register_frame, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3664,7 +3668,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 	struct host_if_msg *msg;
 	struct beacon_attr *beacon_info;
 
-	msg = wilc_alloc_work(vif, handle_add_beacon);
+	msg = wilc_alloc_work(vif, handle_add_beacon, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3708,7 +3712,7 @@ int wilc_del_beacon(struct wilc_vif *vif)
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_del_beacon);
+	msg = wilc_alloc_work(vif, handle_del_beacon, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3727,7 +3731,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 	struct host_if_msg *msg;
 	struct add_sta_param *add_sta_info;
 
-	msg = wilc_alloc_work(vif, handle_add_station);
+	msg = wilc_alloc_work(vif, handle_add_station, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3758,7 +3762,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	struct host_if_msg *msg;
 	struct del_sta *del_sta_info;
 
-	msg = wilc_alloc_work(vif, handle_del_station);
+	msg = wilc_alloc_work(vif, handle_del_station, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3786,7 +3790,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	int i;
 	u8 assoc_sta = 0;
 
-	msg = wilc_alloc_work(vif, handle_del_all_sta);
+	msg = wilc_alloc_work(vif, handle_del_all_sta, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3807,12 +3811,12 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	del_all_sta_info->assoc_sta = assoc_sta;
 	result = wilc_enqueue_cmd(msg);
 
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
-		kfree(msg);
-	} else {
-		wait_for_completion(&hif_wait_response);
-	}
+	else
+		wait_for_completion(&msg->work_comp);
+
+	kfree(msg);
 
 	return result;
 }
@@ -3824,7 +3828,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 	struct host_if_msg *msg;
 	struct add_sta_param *add_sta_info;
 
-	msg = wilc_alloc_work(vif, handle_edit_station);
+	msg = wilc_alloc_work(vif, handle_edit_station, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3858,7 +3862,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	if (wilc_wlan_get_num_conn_ifcs(vif->wilc) == 2 && enabled)
 		return 0;
 
-	msg = wilc_alloc_work(vif, handle_power_management);
+	msg = wilc_alloc_work(vif, handle_power_management, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3879,7 +3883,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_set_mcast_filter);
+	msg = wilc_alloc_work(vif, handle_set_mcast_filter, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -4064,7 +4068,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_set_ip_address);
+	msg = wilc_alloc_work(vif, handle_set_ip_address, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -4085,7 +4089,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	int result = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_get_ip_address);
+	msg = wilc_alloc_work(vif, handle_get_ip_address, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -4106,7 +4110,7 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 	int ret = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_set_tx_pwr);
+	msg = wilc_alloc_work(vif, handle_set_tx_pwr, false);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -4126,20 +4130,18 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 	int ret = 0;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_get_tx_pwr);
+	msg = wilc_alloc_work(vif, handle_get_tx_pwr, true);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
 	ret = wilc_enqueue_cmd(msg);
 	if (ret) {
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
-		kfree(msg);
-		return ret;
+	} else {
+		wait_for_completion(&msg->work_comp);
+		*tx_power = msg->body.tx_power.tx_pwr;
 	}
 
-	wait_for_completion(&hif_wait_response);
-
-	*tx_power = msg->body.tx_power.tx_pwr;
 	/* free 'msg' after copying data */
 	kfree(msg);
 	return ret;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 068b587..0ea22ab 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -273,10 +273,6 @@ struct host_if_drv {
 	struct cfg_param_attr cfg_values;
 	/*lock to protect concurrent setting of cfg params*/
 	struct mutex cfg_values_lock;
-	struct completion comp_test_key_block;
-	struct completion comp_test_disconn_block;
-	struct completion comp_get_rssi;
-	struct completion comp_inactive_time;
 
 	struct timer_list scan_timer;
 	struct wilc_vif *scan_timer_vif;
@@ -359,7 +355,8 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 			     u8 ifc_id);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
-int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
+int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats,
+			bool is_sync);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
 int wilc_get_vif_idx(struct wilc_vif *vif);
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e248702..1f09925 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1148,7 +1148,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	} else if (vif->iftype == STATION_MODE) {
 		struct rf_info stats;
 
-		wilc_get_statistics(vif, &stats);
+		wilc_get_statistics(vif, &stats, true);
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
 				 BIT(NL80211_STA_INFO_RX_PACKETS) |
-- 
2.7.4
