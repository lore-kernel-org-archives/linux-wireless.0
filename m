Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12562 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbeIDLEE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:04 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 10/26] staging: wilc1000: refactor code to avoid use of wilc_set_multicast_list global
Date: Tue, 4 Sep 2018 12:09:26 +0530
Message-ID: <1536043182-19735-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084029_409970_EB71F970)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the code to avoid use of 'wilc_set_multicast_list' global
variable. Allocate the memory required to keep the multicast mac address
and pass it to the worker thread.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 drivers/staging/wilc1000/host_interface.h |  5 ++---
 drivers/staging/wilc1000/linux_wlan.c     | 28 ++++++++++++++++------------
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d930f06..f5617ac 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -90,6 +90,7 @@ struct beacon_attr {
 struct set_multicast {
 	bool enabled;
 	u32 cnt;
+	u8 *mc_list;
 };
 
 struct del_all_sta {
@@ -193,8 +194,6 @@ static struct mutex hif_deinit_lock;
 static struct timer_list periodic_rssi;
 static struct wilc_vif *periodic_rssi_vif;
 
-u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
-
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
 static u8 set_ip[2][4];
@@ -2587,8 +2586,8 @@ static void handle_set_mcast_filter(struct work_struct *work)
 	*cur_byte++ = ((hif_set_mc->cnt >> 16) & 0xFF);
 	*cur_byte++ = ((hif_set_mc->cnt >> 24) & 0xFF);
 
-	if (hif_set_mc->cnt > 0)
-		memcpy(cur_byte, wilc_multicast_mac_addr_list,
+	if (hif_set_mc->cnt > 0 && hif_set_mc->mc_list)
+		memcpy(cur_byte, hif_set_mc->mc_list,
 		       ((hif_set_mc->cnt) * ETH_ALEN));
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
@@ -2597,6 +2596,7 @@ static void handle_set_mcast_filter(struct work_struct *work)
 		netdev_err(vif->ndev, "Failed to send setup multicast\n");
 
 error:
+	kfree(hif_set_mc->mc_list);
 	kfree(wid.val);
 	kfree(msg);
 }
@@ -3988,8 +3988,8 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	return result;
 }
 
-int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
-				u32 count)
+int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled, u32 count,
+				u8 *mc_list)
 {
 	int result;
 	struct host_if_msg *msg;
@@ -4000,6 +4000,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 
 	msg->body.multicast_info.enabled = enabled;
 	msg->body.multicast_info.cnt = count;
+	msg->body.multicast_info.mc_list = mc_list;
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d026f44..4dd8510 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -341,8 +341,8 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
 int wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *sta_param);
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
-int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
-				u32 count);
+int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled, u32 count,
+				u8 *mc_list);
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
@@ -362,7 +362,6 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power);
 int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power);
 
 extern u8 wilc_connected_ssid[6];
-extern u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 extern int wilc_connecting;
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 283bb74..1cea065 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -806,34 +806,38 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	struct netdev_hw_addr *ha;
 	struct wilc_vif *vif = netdev_priv(dev);
 	int i = 0;
+	u8 *mc_list;
+	int res;
 
 	if (dev->flags & IFF_PROMISC)
 		return;
 
 	if (dev->flags & IFF_ALLMULTI ||
 	    dev->mc.count > WILC_MULTICAST_TABLE_SIZE) {
-		wilc_setup_multicast_filter(vif, false, 0);
+		wilc_setup_multicast_filter(vif, false, 0, NULL);
 		return;
 	}
 
 	if (dev->mc.count == 0) {
-		wilc_setup_multicast_filter(vif, true, 0);
+		wilc_setup_multicast_filter(vif, true, 0, NULL);
 		return;
 	}
 
+	mc_list = kmalloc(dev->mc.count * ETH_ALEN, GFP_KERNEL);
+	if (!mc_list)
+		return;
+
 	netdev_for_each_mc_addr(ha, dev) {
-		memcpy(wilc_multicast_mac_addr_list[i], ha->addr, ETH_ALEN);
-		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i,
-			   wilc_multicast_mac_addr_list[i][0],
-			   wilc_multicast_mac_addr_list[i][1],
-			   wilc_multicast_mac_addr_list[i][2],
-			   wilc_multicast_mac_addr_list[i][3],
-			   wilc_multicast_mac_addr_list[i][4],
-			   wilc_multicast_mac_addr_list[i][5]);
-		i++;
+		memcpy(mc_list + i, ha->addr, ETH_ALEN);
+		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i/ETH_ALEN,
+			   mc_list[i], mc_list[i + 1], mc_list[i + 2],
+			   mc_list[i + 3], mc_list[i + 4], mc_list[i + 5]);
+		i += ETH_ALEN;
 	}
 
-	wilc_setup_multicast_filter(vif, true, (dev->mc.count));
+	res = wilc_setup_multicast_filter(vif, true, dev->mc.count, mc_list);
+	if (res)
+		kfree(mc_list);
 }
 
 static void linux_wlan_tx_complete(void *priv, int status)
-- 
2.7.4
