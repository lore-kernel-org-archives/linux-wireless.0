Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14423 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbcA0C6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 21:58:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/13] staging: wilc1000: renames u8IfIdx of wilc_vif structure
Date: Wed, 27 Jan 2016 11:50:36 +0900
Message-ID: <1453863037-31073-12-git-send-email-glen.lee@atmel.com> (sfid-20160127_035820_166665_0025A08A)
In-Reply-To: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
References: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8IfIdx variable of wilc_vif structure to idx
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/linux_wlan.c             | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a425b09..ad54db2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -280,7 +280,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
  */
 int wilc_get_vif_idx(struct wilc_vif *vif)
 {
-	return vif->u8IfIdx + 1;
+	return vif->idx + 1;
 }
 
 /* We need to minus 1 from idx which is from wilc device to get real index
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5c87105..9ca33536 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -107,7 +107,7 @@ static int dev_state_ev_handler(struct notifier_block *this,
 		netdev_dbg(dev, "IP add=%d:%d:%d:%d\n",
 			   ip_addr_buf[0], ip_addr_buf[1],
 			   ip_addr_buf[2], ip_addr_buf[3]);
-		wilc_setup_ipaddress(vif, ip_addr_buf, vif->u8IfIdx);
+		wilc_setup_ipaddress(vif, ip_addr_buf, vif->idx);
 
 		break;
 
@@ -129,7 +129,7 @@ static int dev_state_ev_handler(struct notifier_block *this,
 			   ip_addr_buf[0], ip_addr_buf[1],
 			   ip_addr_buf[2], ip_addr_buf[3]);
 
-		wilc_setup_ipaddress(vif, ip_addr_buf, vif->u8IfIdx);
+		wilc_setup_ipaddress(vif, ip_addr_buf, vif->idx);
 
 		break;
 
@@ -1104,7 +1104,7 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	vif->netstats.tx_packets++;
 	vif->netstats.tx_bytes += tx_data->size;
-	tx_data->bssid = wilc->vif[vif->u8IfIdx]->bssid;
+	tx_data->bssid = wilc->vif[vif->idx]->bssid;
 	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
 						tx_data->buff, tx_data->size,
 						linux_wlan_tx_complete);
@@ -1360,7 +1360,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		else
 			strcpy(ndev->name, "p2p%d");
 
-		vif->u8IfIdx = wl->vif_num;
+		vif->idx = wl->vif_num;
 		vif->wilc = *wilc;
 		wl->vif[i] = vif;
 		wl->vif[wl->vif_num]->ndev = ndev;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 6626347..ccfd26a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2197,7 +2197,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	wilc_wlan_set_bssid(dev, wl->vif[vif->u8IfIdx]->src_addr, AP_MODE);
+	wilc_wlan_set_bssid(dev, wl->vif[vif->idx]->src_addr, AP_MODE);
 	wilc_set_power_mgmt(vif, 0, 0);
 
 	s32Error = wilc_add_beacon(vif, settings->beacon_interval,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 64fcb77..07a4ff1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -148,7 +148,7 @@ typedef struct {
 } struct_frame_reg;
 
 struct wilc_vif {
-	u8 u8IfIdx;
+	u8 idx;
 	u8 iftype;
 	int monitor_flag;
 	int mac_opened;
-- 
1.9.1

