Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:1556 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754678AbeCHPwN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:13 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/10] staging: wilc1000: rename label 'ERRORHANDLER' to avoid uppercase name
Date: Wed, 7 Mar 2018 07:43:52 +0530
Message-ID: <1520388839-7048-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165216_532924_2E37B846)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid use of uppercase for label names, to follow linux
coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 54 +++++++++++++++----------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e3ef7b8..d0c17cd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -779,13 +779,13 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	    hif_drv->hif_state < HOST_IF_CONNECTED) {
 		netdev_err(vif->ndev, "Already scan\n");
 		result = -EBUSY;
-		goto ERRORHANDLER;
+		goto error;
 	}
 
 	if (wilc_optaining_ip || wilc_connecting) {
 		netdev_err(vif->ndev, "Don't do obss scan\n");
 		result = -EBUSY;
-		goto ERRORHANDLER;
+		goto error;
 	}
 
 	hif_drv->usr_scan_req.rcvd_ch_cnt = 0;
@@ -859,7 +859,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	if (result)
 		netdev_err(vif->ndev, "Failed to send scan parameters\n");
 
-ERRORHANDLER:
+error:
 	if (result) {
 		del_timer(&hif_drv->scan_timer);
 		handle_scan_done(vif, SCAN_EVENT_ABORTED);
@@ -936,7 +936,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 	if (!bss_param) {
 		netdev_err(vif->ndev, "Required BSSID not found\n");
 		result = -ENOENT;
-		goto ERRORHANDLER;
+		goto error;
 	}
 
 	if (conn_attr->bssid) {
@@ -1027,7 +1027,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 	}
 	if (!wid_list[wid_cnt].val) {
 		result = -EFAULT;
-		goto ERRORHANDLER;
+		goto error;
 	}
 
 	cur_byte = wid_list[wid_cnt].val;
@@ -1127,12 +1127,12 @@ static s32 handle_connect(struct wilc_vif *vif,
 	if (result) {
 		netdev_err(vif->ndev, "failed to send config packet\n");
 		result = -EFAULT;
-		goto ERRORHANDLER;
+		goto error;
 	} else {
 		hif_drv->hif_state = HOST_IF_WAITING_CONN_RESP;
 	}
 
-ERRORHANDLER:
+error:
 	if (result) {
 		struct connect_info conn_info;
 
@@ -2010,7 +2010,7 @@ static void handle_add_beacon(struct wilc_vif *vif, struct beacon_attr *param)
 	wid.size = param->head_len + param->tail_len + 16;
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
-		goto ERRORHANDLER;
+		goto error;
 
 	cur_byte = wid.val;
 	*cur_byte++ = (param->interval & 0xFF);
@@ -2045,7 +2045,7 @@ static void handle_add_beacon(struct wilc_vif *vif, struct beacon_attr *param)
 	if (result)
 		netdev_err(vif->ndev, "Failed to send add beacon\n");
 
-ERRORHANDLER:
+error:
 	kfree(wid.val);
 	kfree(param->head);
 	kfree(param->tail);
@@ -2117,7 +2117,7 @@ static void handle_add_station(struct wilc_vif *vif,
 
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
-		goto ERRORHANDLER;
+		goto error;
 
 	cur_byte = wid.val;
 	cur_byte += WILC_HostIf_PackStaParam(cur_byte, param);
@@ -2127,7 +2127,7 @@ static void handle_add_station(struct wilc_vif *vif,
 	if (result != 0)
 		netdev_err(vif->ndev, "Failed to send add station\n");
 
-ERRORHANDLER:
+error:
 	kfree(param->rates);
 	kfree(wid.val);
 }
@@ -2147,7 +2147,7 @@ static void handle_del_all_sta(struct wilc_vif *vif,
 
 	wid.val = kmalloc((param->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
 	if (!wid.val)
-		goto ERRORHANDLER;
+		goto error;
 
 	curr_byte = wid.val;
 
@@ -2167,7 +2167,7 @@ static void handle_del_all_sta(struct wilc_vif *vif,
 	if (result)
 		netdev_err(vif->ndev, "Failed to send add station\n");
 
-ERRORHANDLER:
+error:
 	kfree(wid.val);
 
 	complete(&hif_wait_response);
@@ -2185,7 +2185,7 @@ static void handle_del_station(struct wilc_vif *vif, struct del_sta *param)
 
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
-		goto ERRORHANDLER;
+		goto error;
 
 	cur_byte = wid.val;
 
@@ -2196,7 +2196,7 @@ static void handle_del_station(struct wilc_vif *vif, struct del_sta *param)
 	if (result)
 		netdev_err(vif->ndev, "Failed to send add station\n");
 
-ERRORHANDLER:
+error:
 	kfree(wid.val);
 }
 
@@ -2213,7 +2213,7 @@ static void handle_edit_station(struct wilc_vif *vif,
 
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
-		goto ERRORHANDLER;
+		goto error;
 
 	cur_byte = wid.val;
 	cur_byte += WILC_HostIf_PackStaParam(cur_byte, param);
@@ -2223,7 +2223,7 @@ static void handle_edit_station(struct wilc_vif *vif,
 	if (result)
 		netdev_err(vif->ndev, "Failed to send edit station\n");
 
-ERRORHANDLER:
+error:
 	kfree(param->rates);
 	kfree(wid.val);
 }
@@ -2249,16 +2249,16 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->remain_on_ch_pending = 1;
 		result = -EBUSY;
-		goto ERRORHANDLER;
+		goto error;
 	}
 	if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 		result = -EBUSY;
-		goto ERRORHANDLER;
+		goto error;
 	}
 
 	if (wilc_optaining_ip || wilc_connecting) {
 		result = -EBUSY;
-		goto ERRORHANDLER;
+		goto error;
 	}
 
 	u8remain_on_chan_flag = true;
@@ -2268,7 +2268,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val) {
 		result = -ENOMEM;
-		goto ERRORHANDLER;
+		goto error;
 	}
 
 	wid.val[0] = u8remain_on_chan_flag;
@@ -2279,7 +2279,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 	if (result != 0)
 		netdev_err(vif->ndev, "Failed to set remain on channel\n");
 
-ERRORHANDLER:
+error:
 	{
 		P2P_LISTEN_STATE = 1;
 		hif_drv->remain_on_ch_timer_vif = vif;
@@ -2425,7 +2425,7 @@ static void handle_set_mcast_filter(struct wilc_vif *vif,
 	wid.size = sizeof(struct set_multicast) + (hif_set_mc->cnt * ETH_ALEN);
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
-		goto ERRORHANDLER;
+		goto error;
 
 	cur_byte = wid.val;
 	*cur_byte++ = (hif_set_mc->enabled & 0xFF);
@@ -2447,7 +2447,7 @@ static void handle_set_mcast_filter(struct wilc_vif *vif,
 	if (result)
 		netdev_err(vif->ndev, "Failed to send setup multicast\n");
 
-ERRORHANDLER:
+error:
 	kfree(wid.val);
 }
 
@@ -3693,7 +3693,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 	beacon_info->head = kmemdup(head, head_len, GFP_KERNEL);
 	if (!beacon_info->head) {
 		result = -ENOMEM;
-		goto ERRORHANDLER;
+		goto error;
 	}
 	beacon_info->tail_len = tail_len;
 
@@ -3701,7 +3701,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		beacon_info->tail = kmemdup(tail, tail_len, GFP_KERNEL);
 		if (!beacon_info->tail) {
 			result = -ENOMEM;
-			goto ERRORHANDLER;
+			goto error;
 		}
 	} else {
 		beacon_info->tail = NULL;
@@ -3711,7 +3711,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
-ERRORHANDLER:
+error:
 	if (result) {
 		kfree(beacon_info->head);
 
-- 
2.7.4
