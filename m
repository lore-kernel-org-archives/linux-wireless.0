Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3364 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbeFZGHX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:23 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/12] staging: wilc1000: move the allocation of cmd out of wilc_enqueue_cmd()
Date: Tue, 26 Jun 2018 11:37:05 +0530
Message-ID: <1529993234-27294-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080731_849815_DAD1F3FB)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of allocating the host_if_cmd in wilc_enqueue_cmd() now moved
the allocation of cmd in the caller. Added the NULL check for
'hif_workqueue' before posting the work queue in wilc_enqueue_cmd().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 943 +++++++++++++++++-------------
 1 file changed, 544 insertions(+), 399 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 998e0ab..cb627b0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -205,6 +205,23 @@ static void *host_int_parse_join_bss_param(struct network_info *info);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt);
 
+static struct host_if_msg*
+wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *))
+{
+	struct host_if_msg *msg;
+
+	if (!work_fun)
+		return ERR_PTR(-EINVAL);
+
+	msg = kzalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return ERR_PTR(-ENOMEM);
+	msg->fn = work_fun;
+	msg->vif = vif;
+
+	return msg;
+}
+
 /*!
  *  @author		syounan
  *  @date		1 Sep 2010
@@ -213,14 +230,10 @@ static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt);
  */
 static int wilc_enqueue_cmd(struct host_if_msg *msg)
 {
-	struct host_if_msg *new_msg;
-
-	new_msg = kmemdup(msg, sizeof(*new_msg), GFP_ATOMIC);
-	if (!new_msg)
-		return -ENOMEM;
+	INIT_WORK(&msg->work, msg->fn);
+	if (!hif_workqueue || !queue_work(hif_workqueue, &msg->work))
+		return -EINVAL;
 
-	INIT_WORK(&new_msg->work, msg->fn);
-	queue_work(hif_workqueue, &new_msg->work);
 	return 0;
 }
 
@@ -896,8 +909,8 @@ static void handle_connect(struct work_struct *work)
 		result = wilc_enqueue_cmd(msg);
 		if (result)
 			goto error;
+
 		usleep_range(2 * 1000, 2 * 1000);
-		kfree(msg);
 		return;
 	}
 
@@ -2348,18 +2361,21 @@ static void listen_timer_cb(struct timer_list *t)
 						      remain_on_ch_timer);
 	struct wilc_vif *vif = hif_drv->remain_on_ch_timer_vif;
 	s32 result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
 	del_timer(&vif->hif_drv->remain_on_ch_timer);
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.fn = handle_listen_state_expired;
-	msg.vif = vif;
-	msg.body.remain_on_ch.id = vif->hif_drv->remain_on_ch.id;
+	msg = wilc_alloc_work(vif, handle_listen_state_expired);
+	if (IS_ERR(msg))
+		return;
+
+	msg->body.remain_on_ch.id = vif->hif_drv->remain_on_ch.id;
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(msg);
+	}
 }
 
 static void handle_power_management(struct work_struct *work)
@@ -2452,6 +2468,7 @@ static void handle_set_tx_pwr(struct work_struct *work)
 	complete(&hif_thread_comp);
 }
 
+/* Note: 'msg' will be free after using data */
 static void handle_get_tx_pwr(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
@@ -2471,7 +2488,6 @@ static void handle_get_tx_pwr(struct work_struct *work)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
 	complete(&hif_wait_response);
-	kfree(msg);
 	complete(&hif_thread_comp);
 }
 
@@ -2523,13 +2539,16 @@ static void timer_scan_cb(struct timer_list *t)
 {
 	struct host_if_drv *hif_drv = from_timer(hif_drv, t, scan_timer);
 	struct wilc_vif *vif = hif_drv->scan_timer_vif;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
+	int result;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.vif = vif;
-	msg.fn = handle_scan_timer;
+	msg = wilc_alloc_work(vif, handle_scan_timer);
+	if (IS_ERR(msg))
+		return;
 
-	wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
+	if (result)
+		kfree(msg);
 }
 
 static void timer_connect_cb(struct timer_list *t)
@@ -2537,19 +2556,22 @@ static void timer_connect_cb(struct timer_list *t)
 	struct host_if_drv *hif_drv = from_timer(hif_drv, t,
 						      connect_timer);
 	struct wilc_vif *vif = hif_drv->connect_timer_vif;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
+	int result;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.vif = vif;
-	msg.fn = handle_connect_timeout;
+	msg = wilc_alloc_work(vif, handle_connect_timeout);
+	if (IS_ERR(msg))
+		return;
 
-	wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
+	if (result)
+		kfree(msg);
 }
 
 int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -2558,19 +2580,21 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 		return result;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_key);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_key;
-	msg.body.key_info.type = WEP;
-	msg.body.key_info.action = REMOVEKEY;
-	msg.vif = vif;
-	msg.body.key_info.attr.wep.index = index;
+	msg->body.key_info.type = WEP;
+	msg->body.key_info.action = REMOVEKEY;
+	msg->body.key_info.attr.wep.index = index;
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "Request to remove WEP key\n");
-	else
+		kfree(msg);
+	} else {
 		wait_for_completion(&hif_drv->comp_test_key_block);
+	}
 
 	return result;
 }
@@ -2578,7 +2602,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -2587,19 +2611,21 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 		return result;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_key);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_key;
-	msg.body.key_info.type = WEP;
-	msg.body.key_info.action = DEFAULTKEY;
-	msg.vif = vif;
-	msg.body.key_info.attr.wep.index = index;
+	msg->body.key_info.type = WEP;
+	msg->body.key_info.action = DEFAULTKEY;
+	msg->body.key_info.attr.wep.index = index;
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "Default key index\n");
-	else
+		kfree(msg);
+	} else {
 		wait_for_completion(&hif_drv->comp_test_key_block);
+	}
 
 	return result;
 }
@@ -2608,7 +2634,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 			     u8 index)
 {
 	int result;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -2616,35 +2642,41 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 		return -EFAULT;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_key);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_key;
-	msg.body.key_info.type = WEP;
-	msg.body.key_info.action = ADDKEY;
-	msg.vif = vif;
-	msg.body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
-	if (!msg.body.key_info.attr.wep.key)
-		return -ENOMEM;
+	msg->body.key_info.type = WEP;
+	msg->body.key_info.action = ADDKEY;
+	msg->body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
+	if (!msg->body.key_info.attr.wep.key) {
+		result = -ENOMEM;
+		goto free_msg;
+	}
 
-	msg.body.key_info.attr.wep.key_len = len;
-	msg.body.key_info.attr.wep.index = index;
+	msg->body.key_info.attr.wep.key_len = len;
+	msg->body.key_info.attr.wep.index = index;
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result) {
-		netdev_err(vif->ndev, "STA - WEP Key\n");
-		kfree(msg.body.key_info.attr.wep.key);
-		return result;
-	}
+	result = wilc_enqueue_cmd(msg);
+	if (result)
+		goto free_key;
 
 	wait_for_completion(&hif_drv->comp_test_key_block);
 	return 0;
+
+free_key:
+	kfree(msg->body.key_info.attr.wep.key);
+
+free_msg:
+	kfree(msg);
+	return result;
 }
 
 int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 			    u8 index, u8 mode, enum AUTHTYPE auth_type)
 {
 	int result;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -2652,30 +2684,36 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 		return -EFAULT;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_key);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_key;
-	msg.body.key_info.type = WEP;
-	msg.body.key_info.action = ADDKEY_AP;
-	msg.vif = vif;
-	msg.body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
-	if (!msg.body.key_info.attr.wep.key)
-		return -ENOMEM;
+	msg->body.key_info.type = WEP;
+	msg->body.key_info.action = ADDKEY_AP;
+	msg->body.key_info.attr.wep.key = kmemdup(key, len, GFP_KERNEL);
+	if (!msg->body.key_info.attr.wep.key) {
+		result = -ENOMEM;
+		goto free_msg;
+	}
 
-	msg.body.key_info.attr.wep.key_len = len;
-	msg.body.key_info.attr.wep.index = index;
-	msg.body.key_info.attr.wep.mode = mode;
-	msg.body.key_info.attr.wep.auth_type = auth_type;
+	msg->body.key_info.attr.wep.key_len = len;
+	msg->body.key_info.attr.wep.index = index;
+	msg->body.key_info.attr.wep.mode = mode;
+	msg->body.key_info.attr.wep.auth_type = auth_type;
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result) {
-		netdev_err(vif->ndev, "AP - WEP Key\n");
-		kfree(msg.body.key_info.attr.wep.key);
-		return result;
-	}
+	result = wilc_enqueue_cmd(msg);
+	if (result)
+		goto free_key;
 
 	wait_for_completion(&hif_drv->comp_test_key_block);
 	return 0;
+
+free_key:
+	kfree(msg->body.key_info.attr.wep.key);
+
+free_msg:
+	kfree(msg);
+	return result;
 }
 
 int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
@@ -2683,7 +2721,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 		 u8 mode, u8 cipher_mode, u8 index)
 {
 	int result;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 key_len = ptk_key_len;
 
@@ -2698,43 +2736,51 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	if (tx_mic)
 		key_len += TX_MIC_KEY_LEN;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_key);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_key;
-	msg.body.key_info.type = WPA_PTK;
+	msg->body.key_info.type = WPA_PTK;
 	if (mode == AP_MODE) {
-		msg.body.key_info.action = ADDKEY_AP;
-		msg.body.key_info.attr.wpa.index = index;
+		msg->body.key_info.action = ADDKEY_AP;
+		msg->body.key_info.attr.wpa.index = index;
 	}
 	if (mode == STATION_MODE)
-		msg.body.key_info.action = ADDKEY;
+		msg->body.key_info.action = ADDKEY;
 
-	msg.body.key_info.attr.wpa.key = kmemdup(ptk, ptk_key_len, GFP_KERNEL);
-	if (!msg.body.key_info.attr.wpa.key)
-		return -ENOMEM;
+	msg->body.key_info.attr.wpa.key = kmemdup(ptk, ptk_key_len, GFP_KERNEL);
+	if (!msg->body.key_info.attr.wpa.key) {
+		result = -ENOMEM;
+		goto free_msg;
+	}
 
 	if (rx_mic)
-		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic,
+		memcpy(msg->body.key_info.attr.wpa.key + 16, rx_mic,
 		       RX_MIC_KEY_LEN);
 
 	if (tx_mic)
-		memcpy(msg.body.key_info.attr.wpa.key + 24, tx_mic,
+		memcpy(msg->body.key_info.attr.wpa.key + 24, tx_mic,
 		       TX_MIC_KEY_LEN);
 
-	msg.body.key_info.attr.wpa.key_len = key_len;
-	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
-	msg.body.key_info.attr.wpa.mode = cipher_mode;
-	msg.vif = vif;
+	msg->body.key_info.attr.wpa.key_len = key_len;
+	msg->body.key_info.attr.wpa.mac_addr = mac_addr;
+	msg->body.key_info.attr.wpa.mode = cipher_mode;
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "PTK Key\n");
-		kfree(msg.body.key_info.attr.wpa.key);
-		return result;
+		goto free_key;
 	}
 
 	wait_for_completion(&hif_drv->comp_test_key_block);
 	return 0;
+
+free_key:
+	kfree(msg->body.key_info.attr.wpa.key);
+
+free_msg:
+	kfree(msg);
+	return result;
 }
 
 int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
@@ -2743,7 +2789,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		    u8 cipher_mode)
 {
 	int result;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 key_len = gtk_key_len;
 
@@ -2751,7 +2797,10 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
-	memset(&msg, 0, sizeof(struct host_if_msg));
+
+	msg = wilc_alloc_work(vif, handle_key);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
 	if (rx_mic)
 		key_len += RX_MIC_KEY_LEN;
@@ -2760,80 +2809,88 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		key_len += TX_MIC_KEY_LEN;
 
 	if (key_rsc) {
-		msg.body.key_info.attr.wpa.seq = kmemdup(key_rsc,
-							 key_rsc_len,
-							 GFP_KERNEL);
-		if (!msg.body.key_info.attr.wpa.seq)
-			return -ENOMEM;
+		msg->body.key_info.attr.wpa.seq = kmemdup(key_rsc,
+							  key_rsc_len,
+							  GFP_KERNEL);
+		if (!msg->body.key_info.attr.wpa.seq) {
+			result = -ENOMEM;
+			goto free_msg;
+		}
 	}
 
-	msg.fn = handle_key;
-	msg.body.key_info.type = WPA_RX_GTK;
-	msg.vif = vif;
+	msg->body.key_info.type = WPA_RX_GTK;
 
 	if (mode == AP_MODE) {
-		msg.body.key_info.action = ADDKEY_AP;
-		msg.body.key_info.attr.wpa.mode = cipher_mode;
+		msg->body.key_info.action = ADDKEY_AP;
+		msg->body.key_info.attr.wpa.mode = cipher_mode;
 	}
 	if (mode == STATION_MODE)
-		msg.body.key_info.action = ADDKEY;
+		msg->body.key_info.action = ADDKEY;
 
-	msg.body.key_info.attr.wpa.key = kmemdup(rx_gtk,
-						 key_len,
-						 GFP_KERNEL);
-	if (!msg.body.key_info.attr.wpa.key) {
-		kfree(msg.body.key_info.attr.wpa.seq);
-		return -ENOMEM;
+	msg->body.key_info.attr.wpa.key = kmemdup(rx_gtk, key_len, GFP_KERNEL);
+	if (!msg->body.key_info.attr.wpa.key) {
+		result = -ENOMEM;
+		goto free_seq;
 	}
 
 	if (rx_mic)
-		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic,
+		memcpy(msg->body.key_info.attr.wpa.key + 16, rx_mic,
 		       RX_MIC_KEY_LEN);
 
 	if (tx_mic)
-		memcpy(msg.body.key_info.attr.wpa.key + 24, tx_mic,
+		memcpy(msg->body.key_info.attr.wpa.key + 24, tx_mic,
 		       TX_MIC_KEY_LEN);
 
-	msg.body.key_info.attr.wpa.index = index;
-	msg.body.key_info.attr.wpa.key_len = key_len;
-	msg.body.key_info.attr.wpa.seq_len = key_rsc_len;
+	msg->body.key_info.attr.wpa.index = index;
+	msg->body.key_info.attr.wpa.key_len = key_len;
+	msg->body.key_info.attr.wpa.seq_len = key_rsc_len;
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "RX GTK\n");
-		kfree(msg.body.key_info.attr.wpa.seq);
-		kfree(msg.body.key_info.attr.wpa.key);
-		return result;
+		goto free_key;
 	}
 
 	wait_for_completion(&hif_drv->comp_test_key_block);
 	return 0;
+
+free_key:
+	kfree(msg->body.key_info.attr.wpa.key);
+
+free_seq:
+	kfree(msg->body.key_info.attr.wpa.seq);
+
+free_msg:
+	kfree(msg);
+	return result;
 }
 
 int wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pmkid)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	int i;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_key);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_key;
-	msg.body.key_info.type = PMKSA;
-	msg.body.key_info.action = ADDKEY;
-	msg.vif = vif;
+	msg->body.key_info.type = PMKSA;
+	msg->body.key_info.action = ADDKEY;
 
 	for (i = 0; i < pmkid->numpmkid; i++) {
-		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].bssid,
+		memcpy(msg->body.key_info.attr.pmkid.pmkidlist[i].bssid,
 		       &pmkid->pmkidlist[i].bssid, ETH_ALEN);
-		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].pmkid,
+		memcpy(msg->body.key_info.attr.pmkid.pmkidlist[i].pmkid,
 		       &pmkid->pmkidlist[i].pmkid, PMKID_LEN);
 	}
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "PMKID Info\n");
+		kfree(msg);
+	}
 
 	return result;
 }
@@ -2841,17 +2898,18 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_get_mac_address);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_get_mac_address;
-	msg.body.get_mac_info.mac_addr = mac_addr;
-	msg.vif = vif;
+	msg->body.get_mac_info.mac_addr = mac_addr;
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get mac address\n");
+		kfree(msg);
 		return -EFAULT;
 	}
 
@@ -2866,7 +2924,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      u8 channel, void *join_params)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv || !connect_result) {
@@ -2879,56 +2937,75 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		return -EFAULT;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_connect);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_connect;
-	msg.body.con_info.security = security;
-	msg.body.con_info.auth_type = auth_type;
-	msg.body.con_info.ch = channel;
-	msg.body.con_info.result = connect_result;
-	msg.body.con_info.arg = user_arg;
-	msg.body.con_info.params = join_params;
-	msg.vif = vif;
+	msg->body.con_info.security = security;
+	msg->body.con_info.auth_type = auth_type;
+	msg->body.con_info.ch = channel;
+	msg->body.con_info.result = connect_result;
+	msg->body.con_info.arg = user_arg;
+	msg->body.con_info.params = join_params;
 
 	if (bssid) {
-		msg.body.con_info.bssid = kmemdup(bssid, 6, GFP_KERNEL);
-		if (!msg.body.con_info.bssid)
-			return -ENOMEM;
+		msg->body.con_info.bssid = kmemdup(bssid, 6, GFP_KERNEL);
+		if (!msg->body.con_info.bssid) {
+			result = -ENOMEM;
+			goto free_msg;
+		}
 	}
 
 	if (ssid) {
-		msg.body.con_info.ssid_len = ssid_len;
-		msg.body.con_info.ssid = kmemdup(ssid, ssid_len, GFP_KERNEL);
-		if (!msg.body.con_info.ssid)
-			return -ENOMEM;
+		msg->body.con_info.ssid_len = ssid_len;
+		msg->body.con_info.ssid = kmemdup(ssid, ssid_len, GFP_KERNEL);
+		if (!msg->body.con_info.ssid) {
+			result = -ENOMEM;
+			goto free_bssid;
+		}
 	}
 
 	if (ies) {
-		msg.body.con_info.ies_len = ies_len;
-		msg.body.con_info.ies = kmemdup(ies, ies_len, GFP_KERNEL);
-		if (!msg.body.con_info.ies)
-			return -ENOMEM;
+		msg->body.con_info.ies_len = ies_len;
+		msg->body.con_info.ies = kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!msg->body.con_info.ies) {
+			result = -ENOMEM;
+			goto free_ssid;
+		}
 	}
 	if (hif_drv->hif_state < HOST_IF_CONNECTING)
 		hif_drv->hif_state = HOST_IF_CONNECTING;
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "send message: Set join request\n");
-		return -EFAULT;
+		goto free_ies;
 	}
 
 	hif_drv->connect_timer_vif = vif;
 	mod_timer(&hif_drv->connect_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
 
+	return 0;
+
+free_ies:
+	kfree(msg->body.con_info.ies);
+
+free_ssid:
+	kfree(msg->body.con_info.ssid);
+
+free_bssid:
+	kfree(msg->body.con_info.bssid);
+
+free_msg:
+	kfree(msg);
 	return result;
 }
 
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -2936,16 +3013,17 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 		return -EFAULT;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_disconnect);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_disconnect;
-	msg.vif = vif;
-
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "Failed to send message: disconnect\n");
-	else
+		kfree(msg);
+	} else {
 		wait_for_completion(&hif_drv->comp_test_disconn_block);
+	}
 
 	return result;
 }
@@ -2978,39 +3056,41 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 {
 	int result;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
+
+	msg = wilc_alloc_work(vif, handle_set_channel);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.fn = handle_set_channel;
-	msg.body.channel_info.set_ch = channel;
-	msg.vif = vif;
+	msg->body.channel_info.set_ch = channel;
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
-		return -EINVAL;
+		kfree(msg);
 	}
 
-	return 0;
+	return result;
 }
 
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 			     u8 ifc_id)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
+
+	msg = wilc_alloc_work(vif, handle_set_wfi_drv_handler);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.fn = handle_set_wfi_drv_handler;
-	msg.body.drv.handler = index;
-	msg.body.drv.mode = mode;
-	msg.body.drv.name = ifc_id;
-	msg.vif = vif;
+	msg->body.drv.handler = index;
+	msg->body.drv.mode = mode;
+	msg->body.drv.name = ifc_id;
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
-		result = -EINVAL;
+		kfree(msg);
 	}
 
 	return result;
@@ -3019,17 +3099,17 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.fn = handle_set_operation_mode;
-	msg.body.mode.mode = mode;
-	msg.vif = vif;
+	msg  = wilc_alloc_work(vif, handle_set_operation_mode);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	result = wilc_enqueue_cmd(&msg);
+	msg->body.mode.mode = mode;
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
-		result = -EINVAL;
+		kfree(msg);
 	}
 
 	return result;
@@ -3039,7 +3119,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 			   u32 *out_val)
 {
 	s32 result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -3047,17 +3127,19 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 		return -EFAULT;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	memcpy(msg.body.mac_info.mac, mac, ETH_ALEN);
+	msg = wilc_alloc_work(vif, handle_get_inactive_time);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_get_inactive_time;
-	msg.vif = vif;
+	memcpy(msg->body.mac_info.mac, mac, ETH_ALEN);
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
-	else
+		kfree(msg);
+	} else {
 		wait_for_completion(&hif_drv->comp_inactive_time);
+	}
 
 	*out_val = inactive_time;
 
@@ -3067,17 +3149,18 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.fn = handle_get_rssi;
-	msg.vif = vif;
+	msg = wilc_alloc_work(vif, handle_get_rssi);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
-		return -EFAULT;
+		kfree(msg);
+		return result;
 	}
 
 	wait_for_completion(&hif_drv->comp_get_rssi);
@@ -3095,17 +3178,19 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
+
+	msg = wilc_alloc_work(vif, handle_get_statistics);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.fn = handle_get_statistics;
-	msg.body.data = (char *)stats;
-	msg.vif = vif;
+	msg->body.data = (char *)stats;
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host channel\n");
-		return -EFAULT;
+		kfree(msg);
+		return result;
 	}
 
 	if (stats != &vif->wilc->dummy_statistics)
@@ -3119,8 +3204,8 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      struct hidden_network *hidden_network)
 {
 	int result = 0;
-	struct host_if_msg msg;
-	struct scan_attr *scan_info = &msg.body.scan_info;
+	struct host_if_msg *msg;
+	struct scan_attr *scan_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv || !scan_result) {
@@ -3128,16 +3213,17 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 		return -EFAULT;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_scan);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_scan;
+	scan_info = &msg->body.scan_info;
 
 	if (hidden_network) {
 		scan_info->hidden_network.net_info = hidden_network->net_info;
 		scan_info->hidden_network.n_ssids = hidden_network->n_ssids;
 	}
 
-	msg.vif = vif;
 	scan_info->src = scan_source;
 	scan_info->type = scan_type;
 	scan_info->result = scan_result;
@@ -3147,44 +3233,63 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	scan_info->ch_freq_list = kmemdup(ch_freq_list,
 					  ch_list_len,
 					  GFP_KERNEL);
-	if (!scan_info->ch_freq_list)
-		return -ENOMEM;
+	if (!scan_info->ch_freq_list) {
+		result = -ENOMEM;
+		goto free_msg;
+	}
 
 	scan_info->ies_len = ies_len;
 	scan_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
-	if (!scan_info->ies)
-		return -ENOMEM;
+	if (!scan_info->ies) {
+		result = -ENOMEM;
+		goto free_freq_list;
+	}
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Error in sending message queue\n");
-		return -EINVAL;
+		goto free_ies;
 	}
 
 	hif_drv->scan_timer_vif = vif;
 	mod_timer(&hif_drv->scan_timer,
 		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
 
+	return 0;
+
+free_ies:
+	kfree(scan_info->ies);
+
+free_freq_list:
+	kfree(scan_info->ch_freq_list);
+
+free_msg:
+	kfree(msg);
 	return result;
 }
 
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_attr *cfg_param)
 {
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
+	int result;
 
 	if (!hif_drv) {
 		netdev_err(vif->ndev, "hif_drv NULL\n");
 		return -EFAULT;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.fn = handle_cfg_param;
-	msg.body.cfg_info = *cfg_param;
-	msg.vif = vif;
+	msg = wilc_alloc_work(vif, handle_cfg_param);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+
+	msg->body.cfg_info = *cfg_param;
+	result = wilc_enqueue_cmd(msg);
+	if (result)
+		kfree(msg);
 
-	return wilc_enqueue_cmd(&msg);
+	return result;
 }
 
 static void get_periodic_rssi(struct timer_list *unused)
@@ -3278,7 +3383,6 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 int wilc_deinit(struct wilc_vif *vif)
 {
 	int result = 0;
-	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv)	{
@@ -3307,14 +3411,15 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	hif_drv->hif_state = HOST_IF_IDLE;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
 	if (clients_count == 1)	{
-		msg.fn = handle_hif_exit_work;
-		msg.vif = vif;
+		struct host_if_msg *msg;
 
-		result = wilc_enqueue_cmd(&msg);
-		if (result != 0)
+		msg = wilc_alloc_work(vif, handle_hif_exit_work);
+		if (IS_ERR(msg))
+			return PTR_ERR(msg);
+
+		result = wilc_enqueue_cmd(msg);
+		if (result)
 			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
 		else
 			wait_for_completion(&hif_thread_comp);
@@ -3333,7 +3438,7 @@ int wilc_deinit(struct wilc_vif *vif)
 void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
 	s32 result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
 	struct wilc_vif *vif;
@@ -3352,27 +3457,29 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
-	msg.fn = handle_rcvd_ntwrk_info;
-	msg.vif = vif;
+	msg = wilc_alloc_work(vif, handle_rcvd_ntwrk_info);
+	if (IS_ERR(msg))
+		return;
 
-	msg.body.net_info.len = length;
-	msg.body.net_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
-	if (!msg.body.net_info.buffer)
+	msg->body.net_info.len = length;
+	msg->body.net_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
+	if (!msg->body.net_info.buffer) {
+		kfree(msg);
 		return;
+	}
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "message parameters (%d)\n", result);
-		kfree(msg.body.net_info.buffer);
+		kfree(msg->body.net_info.buffer);
+		kfree(msg);
 	}
 }
 
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
 	s32 result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
 	struct wilc_vif *vif;
@@ -3402,22 +3509,25 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	}
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
-	msg.fn = handle_rcvd_gnrl_async_info;
-	msg.vif = vif;
+	msg = wilc_alloc_work(vif, handle_rcvd_gnrl_async_info);
+	if (IS_ERR(msg)) {
+		mutex_unlock(&hif_deinit_lock);
+		return;
+	}
 
-	msg.body.async_info.len = length;
-	msg.body.async_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
-	if (!msg.body.async_info.buffer) {
+	msg->body.async_info.len = length;
+	msg->body.async_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
+	if (!msg->body.async_info.buffer) {
+		kfree(msg);
 		mutex_unlock(&hif_deinit_lock);
 		return;
 	}
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "synchronous info (%d)\n", result);
-		kfree(msg.body.async_info.buffer);
+		kfree(msg->body.async_info.buffer);
+		kfree(msg);
 	}
 
 	mutex_unlock(&hif_deinit_lock);
@@ -3426,7 +3536,6 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
 	s32 result = 0;
-	struct host_if_msg msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
 	struct wilc_vif *vif;
@@ -3444,14 +3553,17 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 
 	if (hif_drv->usr_scan_req.scan_result) {
-		memset(&msg, 0, sizeof(struct host_if_msg));
+		struct host_if_msg *msg;
 
-		msg.fn = handle_scan_complete;
-		msg.vif = vif;
+		msg = wilc_alloc_work(vif, handle_scan_complete);
+		if (IS_ERR(msg))
+			return;
 
-		result = wilc_enqueue_cmd(&msg);
-		if (result)
+		result = wilc_enqueue_cmd(msg);
+		if (result) {
 			netdev_err(vif->ndev, "complete param (%d)\n", result);
+			kfree(msg);
+		}
 	}
 }
 
@@ -3462,22 +3574,24 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   void *user_arg)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_remain_on_chan_work);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_remain_on_chan_work;
-	msg.body.remain_on_ch.ch = chan;
-	msg.body.remain_on_ch.expired = expired;
-	msg.body.remain_on_ch.ready = ready;
-	msg.body.remain_on_ch.arg = user_arg;
-	msg.body.remain_on_ch.duration = duration;
-	msg.body.remain_on_ch.id = session_id;
-	msg.vif = vif;
+	msg->body.remain_on_ch.ch = chan;
+	msg->body.remain_on_ch.expired = expired;
+	msg->body.remain_on_ch.ready = ready;
+	msg->body.remain_on_ch.arg = user_arg;
+	msg->body.remain_on_ch.duration = duration;
+	msg->body.remain_on_ch.id = session_id;
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
+		kfree(msg);
+	}
 
 	return result;
 }
@@ -3485,7 +3599,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -3495,14 +3609,17 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 
 	del_timer(&hif_drv->remain_on_ch_timer);
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.fn = handle_listen_state_expired;
-	msg.vif = vif;
-	msg.body.remain_on_ch.id = session_id;
+	msg = wilc_alloc_work(vif, handle_listen_state_expired);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	msg->body.remain_on_ch.id = session_id;
+
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
+		kfree(msg);
+	}
 
 	return result;
 }
@@ -3510,30 +3627,32 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_register_frame);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_register_frame;
 	switch (frame_type) {
 	case ACTION:
-		msg.body.reg_frame.reg_id = ACTION_FRM_IDX;
+		msg->body.reg_frame.reg_id = ACTION_FRM_IDX;
 		break;
 
 	case PROBE_REQ:
-		msg.body.reg_frame.reg_id = PROBE_REQ_IDX;
+		msg->body.reg_frame.reg_id = PROBE_REQ_IDX;
 		break;
 
 	default:
 		break;
 	}
-	msg.body.reg_frame.frame_type = frame_type;
-	msg.body.reg_frame.reg = reg;
-	msg.vif = vif;
+	msg->body.reg_frame.frame_type = frame_type;
+	msg->body.reg_frame.reg = reg;
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
+		kfree(msg);
+	}
 
 	return result;
 }
@@ -3542,13 +3661,14 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		    u32 head_len, u8 *head, u32 tail_len, u8 *tail)
 {
 	int result = 0;
-	struct host_if_msg msg;
-	struct beacon_attr *beacon_info = &msg.body.beacon_info;
+	struct host_if_msg *msg;
+	struct beacon_attr *beacon_info;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_add_beacon);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_add_beacon;
-	msg.vif = vif;
+	beacon_info = &msg->body.beacon_info;
 	beacon_info->interval = interval;
 	beacon_info->dtim_period = dtim_period;
 	beacon_info->head_len = head_len;
@@ -3569,15 +3689,15 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		beacon_info->tail = NULL;
 	}
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
 error:
 	if (result) {
 		kfree(beacon_info->head);
-
 		kfree(beacon_info->tail);
+		kfree(msg);
 	}
 
 	return result;
@@ -3586,14 +3706,17 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 int wilc_del_beacon(struct wilc_vif *vif)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	msg.fn = handle_del_beacon;
-	msg.vif = vif;
+	msg = wilc_alloc_work(vif, handle_del_beacon);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(msg);
+	}
 
 	return result;
 }
@@ -3601,27 +3724,30 @@ int wilc_del_beacon(struct wilc_vif *vif)
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 {
 	int result = 0;
-	struct host_if_msg msg;
-	struct add_sta_param *add_sta_info = &msg.body.add_sta_info;
+	struct host_if_msg *msg;
+	struct add_sta_param *add_sta_info;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
-
-	msg.fn = handle_add_station;
-	msg.vif = vif;
+	msg = wilc_alloc_work(vif, handle_add_station);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
+	add_sta_info = &msg->body.add_sta_info;
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
 	if (add_sta_info->rates_len > 0) {
 		add_sta_info->rates = kmemdup(sta_param->rates,
 					      add_sta_info->rates_len,
 					      GFP_KERNEL);
-		if (!add_sta_info->rates)
+		if (!add_sta_info->rates) {
+			kfree(msg);
 			return -ENOMEM;
+		}
 	}
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(add_sta_info->rates);
+		kfree(msg);
 	}
 	return result;
 }
@@ -3629,38 +3755,42 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 {
 	int result = 0;
-	struct host_if_msg msg;
-	struct del_sta *del_sta_info = &msg.body.del_sta_info;
+	struct host_if_msg *msg;
+	struct del_sta *del_sta_info;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_del_station);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_del_station;
-	msg.vif = vif;
+	del_sta_info = &msg->body.del_sta_info;
 
 	if (!mac_addr)
 		eth_broadcast_addr(del_sta_info->mac_addr);
 	else
 		memcpy(del_sta_info->mac_addr, mac_addr, ETH_ALEN);
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(msg);
+	}
 	return result;
 }
 
 int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 {
 	int result = 0;
-	struct host_if_msg msg;
-	struct del_all_sta *del_all_sta_info = &msg.body.del_all_sta_info;
+	struct host_if_msg *msg;
+	struct del_all_sta *del_all_sta_info;
 	u8 zero_addr[ETH_ALEN] = {0};
 	int i;
 	u8 assoc_sta = 0;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_del_all_sta);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_del_all_sta;
-	msg.vif = vif;
+	del_all_sta_info = &msg->body.del_all_sta_info;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(mac_addr[i], zero_addr, ETH_ALEN)) {
@@ -3669,16 +3799,20 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 			assoc_sta++;
 		}
 	}
-	if (!assoc_sta)
-		return result;
+	if (!assoc_sta) {
+		kfree(msg);
+		return 0;
+	}
 
 	del_all_sta_info->assoc_sta = assoc_sta;
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
-	else
+		kfree(msg);
+	} else {
 		wait_for_completion(&hif_wait_response);
+	}
 
 	return result;
 }
@@ -3687,27 +3821,30 @@ int wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *sta_param)
 {
 	int result = 0;
-	struct host_if_msg msg;
-	struct add_sta_param *add_sta_info = &msg.body.add_sta_info;
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	struct host_if_msg *msg;
+	struct add_sta_param *add_sta_info;
 
-	msg.fn = handle_edit_station;
-	msg.vif = vif;
+	msg = wilc_alloc_work(vif, handle_edit_station);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
+	add_sta_info = &msg->body.add_sta_info;
+	memcpy(add_sta_info, sta_param, sizeof(*add_sta_info));
 	if (add_sta_info->rates_len > 0) {
 		add_sta_info->rates = kmemdup(sta_param->rates,
 					      add_sta_info->rates_len,
 					      GFP_KERNEL);
-		if (!add_sta_info->rates)
+		if (!add_sta_info->rates) {
+			kfree(msg);
 			return -ENOMEM;
+		}
 	}
 
-	result = wilc_enqueue_cmd(&msg);
+	result = wilc_enqueue_cmd(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(add_sta_info->rates);
+		kfree(msg);
 	}
 
 	return result;
@@ -3716,23 +3853,23 @@ int wilc_edit_station(struct wilc_vif *vif,
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 {
 	int result = 0;
-	struct host_if_msg msg;
-	struct power_mgmt_param *pwr_mgmt_info = &msg.body.pwr_mgmt_info;
+	struct host_if_msg *msg;
 
 	if (wilc_wlan_get_num_conn_ifcs(vif->wilc) == 2 && enabled)
 		return 0;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_power_management);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_power_management;
-	msg.vif = vif;
+	msg->body.pwr_mgmt_info.enabled = enabled;
+	msg->body.pwr_mgmt_info.timeout = timeout;
 
-	pwr_mgmt_info->enabled = enabled;
-	pwr_mgmt_info->timeout = timeout;
-
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(msg);
+	}
 	return result;
 }
 
@@ -3740,20 +3877,20 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count)
 {
 	int result = 0;
-	struct host_if_msg msg;
-	struct set_multicast *multicast_filter_param = &msg.body.multicast_info;
-
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	struct host_if_msg *msg;
 
-	msg.fn = handle_set_mcast_filter;
-	msg.vif = vif;
+	msg = wilc_alloc_work(vif, handle_set_mcast_filter);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	multicast_filter_param->enabled = enabled;
-	multicast_filter_param->cnt = count;
+	msg->body.multicast_info.enabled = enabled;
+	msg->body.multicast_info.cnt = count;
 
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(msg);
+	}
 	return result;
 }
 
@@ -3925,19 +4062,20 @@ static void *host_int_parse_join_bss_param(struct network_info *info)
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_set_ip_address);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_set_ip_address;
+	msg->body.ip_info.ip_addr = ip_addr;
+	msg->body.ip_info.idx = idx;
 
-	msg.body.ip_info.ip_addr = ip_addr;
-	msg.vif = vif;
-	msg.body.ip_info.idx = idx;
-
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(msg);
+	}
 
 	return result;
 }
@@ -3945,19 +4083,20 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	int result = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_get_ip_address);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_get_ip_address;
+	msg->body.ip_info.ip_addr = ip_addr;
+	msg->body.ip_info.idx = idx;
 
-	msg.body.ip_info.ip_addr = ip_addr;
-	msg.vif = vif;
-	msg.body.ip_info.idx = idx;
-
-	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	result = wilc_enqueue_cmd(msg);
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(msg);
+	}
 
 	return result;
 }
@@ -3965,17 +4104,19 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 {
 	int ret = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_set_tx_pwr);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_set_tx_pwr;
-	msg.body.tx_power.tx_pwr = tx_power;
-	msg.vif = vif;
+	msg->body.tx_power.tx_pwr = tx_power;
 
-	ret = wilc_enqueue_cmd(&msg);
-	if (ret)
+	ret = wilc_enqueue_cmd(msg);
+	if (ret) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(msg);
+	}
 
 	return ret;
 }
@@ -3983,19 +4124,23 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 {
 	int ret = 0;
-	struct host_if_msg msg;
+	struct host_if_msg *msg;
 
-	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg = wilc_alloc_work(vif, handle_get_tx_pwr);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
-	msg.fn = handle_get_tx_pwr;
-	msg.vif = vif;
-
-	ret = wilc_enqueue_cmd(&msg);
-	if (ret)
+	ret = wilc_enqueue_cmd(msg);
+	if (ret) {
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
+		kfree(msg);
+		return ret;
+	}
 
 	wait_for_completion(&hif_wait_response);
-	*tx_power = msg.body.tx_power.tx_pwr;
 
+	*tx_power = msg->body.tx_power.tx_pwr;
+	/* free 'msg' after copying data */
+	kfree(msg);
 	return ret;
 }
-- 
2.7.4
