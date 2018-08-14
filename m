Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57937 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJhU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:37:20 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 21/24] staging: wilc1000: remove unused code to set and get IP address
Date: Tue, 14 Aug 2018 12:20:13 +0530
Message-ID: <1534229416-13254-22-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_091108_416837_773F43E4)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup code to remove the variables related to setting and getting IP
address as this case was not handled from firmware side.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 105 ------------------------------
 drivers/staging/wilc1000/host_interface.h |   3 -
 drivers/staging/wilc1000/linux_wlan.c     |   3 -
 3 files changed, 111 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bffe0c8..f37ba64 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -187,11 +187,6 @@ struct join_bss_param {
 
 static u8 p2p_listen_state;
 
-static u8 set_ip[2][4];
-static u8 get_ip[2][4];
-
-static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
-
 /* 'msg' should be free by the caller for syc */
 static struct host_if_msg*
 wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *),
@@ -344,64 +339,6 @@ static void handle_set_operation_mode(struct work_struct *work)
 	kfree(msg);
 }
 
-static void handle_set_ip_address(struct work_struct *work)
-{
-	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif = msg->vif;
-	u8 *ip_addr = msg->body.ip_info.ip_addr;
-	u8 idx = msg->body.ip_info.idx;
-	int ret;
-	struct wid wid;
-	char firmware_ip_addr[4] = {0};
-
-	if (ip_addr[0] < 192)
-		ip_addr[0] = 0;
-
-	memcpy(set_ip[idx], ip_addr, IP_ALEN);
-
-	wid.id = WID_IP_ADDRESS;
-	wid.type = WID_STR;
-	wid.val = ip_addr;
-	wid.size = IP_ALEN;
-
-	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-				   wilc_get_vif_idx(vif));
-
-	host_int_get_ipaddress(vif, firmware_ip_addr, idx);
-
-	if (ret)
-		netdev_err(vif->ndev, "Failed to set IP address\n");
-	kfree(msg);
-}
-
-static void handle_get_ip_address(struct work_struct *work)
-{
-	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif = msg->vif;
-	u8 idx = msg->body.ip_info.idx;
-	int ret;
-	struct wid wid;
-
-	wid.id = WID_IP_ADDRESS;
-	wid.type = WID_STR;
-	wid.val = kmalloc(IP_ALEN, GFP_KERNEL);
-	wid.size = IP_ALEN;
-
-	ret = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
-				   wilc_get_vif_idx(vif));
-
-	memcpy(get_ip[idx], wid.val, IP_ALEN);
-
-	kfree(wid.val);
-
-	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
-		wilc_setup_ipaddress(vif, set_ip[idx], idx);
-
-	if (ret)
-		netdev_err(vif->ndev, "Failed to get IP address\n");
-	kfree(msg);
-}
-
 static void handle_get_mac_address(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
@@ -4002,48 +3939,6 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	return result;
 }
 
-int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
-{
-	int result;
-	struct host_if_msg *msg;
-
-	msg = wilc_alloc_work(vif, handle_set_ip_address, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.ip_info.ip_addr = ip_addr;
-	msg->body.ip_info.idx = idx;
-
-	result = wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
-
-	return result;
-}
-
-static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
-{
-	int result;
-	struct host_if_msg *msg;
-
-	msg = wilc_alloc_work(vif, handle_get_ip_address, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.ip_info.ip_addr = ip_addr;
-	msg->body.ip_info.idx = idx;
-
-	result = wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
-
-	return result;
-}
-
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 {
 	int ret;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 80cb298..0f0d509 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -9,8 +9,6 @@
 #include <linux/ieee80211.h>
 #include "coreconfigurator.h"
 
-#define IP_ALEN  4
-
 #define IDLE_MODE	0x00
 #define AP_MODE		0x01
 #define STATION_MODE	0x02
@@ -344,7 +342,6 @@ int wilc_edit_station(struct wilc_vif *vif,
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
-int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired expired,
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index bbaa653..74f8166 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -61,7 +61,6 @@ static int dev_state_ev_handler(struct notifier_block *this,
 		netdev_dbg(dev, "IP add=%d:%d:%d:%d\n",
 			   ip_addr_buf[0], ip_addr_buf[1],
 			   ip_addr_buf[2], ip_addr_buf[3]);
-		wilc_setup_ipaddress(vif, ip_addr_buf, vif->idx);
 
 		break;
 
@@ -83,8 +82,6 @@ static int dev_state_ev_handler(struct notifier_block *this,
 			   ip_addr_buf[0], ip_addr_buf[1],
 			   ip_addr_buf[2], ip_addr_buf[3]);
 
-		wilc_setup_ipaddress(vif, ip_addr_buf, vif->idx);
-
 		break;
 
 	default:
-- 
2.7.4
