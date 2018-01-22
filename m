Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:59780 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbeAVKW5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 05:22:57 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 01/14] staging: wilc1000: remove unnecessary use of parentheses
Date: Mon, 22 Jan 2018 15:52:14 +0530
Message-ID: <1516616547-24654-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180122_112301_503087_47719A2A)
In-Reply-To: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Unnecessary parentheses around" issue found by checkpatch.pl
script.Remove the unnecessary parentheses to follow linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  2 +-
 drivers/staging/wilc1000/host_interface.c         | 34 +++++++++++------------
 drivers/staging/wilc1000/linux_wlan.c             |  8 +++---
 drivers/staging/wilc1000/wilc_sdio.c              |  4 +--
 drivers/staging/wilc1000/wilc_spi.c               | 20 ++++++-------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 26 ++++++++---------
 drivers/staging/wilc1000/wilc_wlan.c              |  2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  6 ++--
 8 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 8cf886d..e98fc8e 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -201,7 +201,7 @@ static inline u16 get_cap_info(u8 *data)
 
 	st = get_sub_type(data);
 
-	if ((st == BEACON) || (st == PROBE_RSP))
+	if (st == BEACON || st == PROBE_RSP)
 		index += TIME_STAMP_LEN + BEACON_INTERVAL_LEN;
 
 	cap_info  = data[index];
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4ff1a59..46e2d55 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -394,7 +394,7 @@ static void handle_set_operation_mode(struct wilc_vif *vif,
 	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
 
-	if ((hif_op_mode->mode) == IDLE_MODE)
+	if (hif_op_mode->mode == IDLE_MODE)
 		complete(&hif_driver_comp);
 
 	if (ret)
@@ -760,8 +760,8 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	hif_drv->usr_scan_req.scan_result = scan_info->result;
 	hif_drv->usr_scan_req.arg = scan_info->arg;
 
-	if ((hif_drv->hif_state >= HOST_IF_SCANNING) &&
-	    (hif_drv->hif_state < HOST_IF_CONNECTED)) {
+	if (hif_drv->hif_state >= HOST_IF_SCANNING &&
+	    hif_drv->hif_state < HOST_IF_CONNECTED) {
 		netdev_err(vif->ndev, "Already scan\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
@@ -1025,7 +1025,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	pu8CurrByte += MAX_SSID_LEN;
 	*(pu8CurrByte++) = INFRASTRUCTURE;
 
-	if ((pstrHostIFconnectAttr->ch >= 1) && (pstrHostIFconnectAttr->ch <= 14)) {
+	if (pstrHostIFconnectAttr->ch >= 1 && pstrHostIFconnectAttr->ch <= 14) {
 		*(pu8CurrByte++) = pstrHostIFconnectAttr->ch;
 	} else {
 		netdev_err(vif->ndev, "Channel out of range\n");
@@ -1258,8 +1258,8 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		wilc_parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
-		if ((!pstrNetworkInfo) ||
-		    (!hif_drv->usr_scan_req.scan_result)) {
+		if (!pstrNetworkInfo ||
+		    !hif_drv->usr_scan_req.scan_result) {
 			netdev_err(vif->ndev, "driver is null\n");
 			result = -EINVAL;
 			goto done;
@@ -1340,8 +1340,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 		return -ENODEV;
 	}
 
-	if ((hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
-	    (hif_drv->hif_state == HOST_IF_CONNECTED) ||
+	if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP ||
+	    hif_drv->hif_state == HOST_IF_CONNECTED ||
 	    hif_drv->usr_scan_req.scan_result) {
 		if (!pstrRcvdGnrlAsyncInfo->buffer ||
 		    !hif_drv->usr_conn_req.conn_result) {
@@ -1400,8 +1400,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 				}
 			}
 
-			if ((u8MacStatus == MAC_CONNECTED) &&
-			    (strConnectInfo.status != SUCCESSFUL_STATUSCODE))	{
+			if (u8MacStatus == MAC_CONNECTED &&
+			    strConnectInfo.status != SUCCESSFUL_STATUSCODE)	{
 				netdev_err(vif->ndev, "Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
 				eth_zero_addr(wilc_connected_ssid);
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
@@ -1412,8 +1412,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			if (hif_drv->usr_conn_req.bssid) {
 				memcpy(strConnectInfo.bssid, hif_drv->usr_conn_req.bssid, 6);
 
-				if ((u8MacStatus == MAC_CONNECTED) &&
-				    (strConnectInfo.status == SUCCESSFUL_STATUSCODE))	{
+				if (u8MacStatus == MAC_CONNECTED &&
+				    strConnectInfo.status == SUCCESSFUL_STATUSCODE)	{
 					memcpy(hif_drv->assoc_bssid,
 					       hif_drv->usr_conn_req.bssid, ETH_ALEN);
 				}
@@ -1434,8 +1434,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 							  NULL,
 							  hif_drv->usr_conn_req.arg);
 
-			if ((u8MacStatus == MAC_CONNECTED) &&
-			    (strConnectInfo.status == SUCCESSFUL_STATUSCODE))	{
+			if (u8MacStatus == MAC_CONNECTED &&
+			    strConnectInfo.status == SUCCESSFUL_STATUSCODE)	{
 				wilc_set_power_mgmt(vif, 0, 0);
 
 				hif_drv->hif_state = HOST_IF_CONNECTED;
@@ -1864,8 +1864,8 @@ void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
 {
 	if (!vif->hif_drv)
 		return;
-	if ((vif->hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
-	    (vif->hif_drv->hif_state == HOST_IF_CONNECTING))
+	if (vif->hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP ||
+	    vif->hif_drv->hif_state == HOST_IF_CONNECTING)
 		wilc_disconnect(vif, 1);
 }
 
@@ -2414,7 +2414,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 
 	wid.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	wid.type = WID_BIN;
-	wid.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->cnt) * ETH_ALEN);
+	wid.size = sizeof(struct set_multicast) + (strHostIfSetMulti->cnt * ETH_ALEN);
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index da1fe43..3c3f1863 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -911,13 +911,13 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if (dev->flags & IFF_PROMISC)
 		return;
 
-	if ((dev->flags & IFF_ALLMULTI) ||
-	    (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
+	if (dev->flags & IFF_ALLMULTI ||
+	    dev->mc.count > WILC_MULTICAST_TABLE_SIZE) {
 		wilc_setup_multicast_filter(vif, false, 0);
 		return;
 	}
 
-	if ((dev->mc.count) == 0) {
+	if (dev->mc.count == 0) {
 		wilc_setup_multicast_filter(vif, true, 0);
 		return;
 	}
@@ -1030,7 +1030,7 @@ static int wilc_mac_close(struct net_device *ndev)
 	if (!hif_drv)
 		return 0;
 
-	if ((wl->open_ifcs) > 0)
+	if (wl->open_ifcs > 0)
 		wl->open_ifcs--;
 	else
 		return 0;
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index bd2b29b..bb65b37 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -375,7 +375,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 
 	data = cpu_to_le32(data);
 
-	if ((addr >= 0xf0) && (addr <= 0xff)) {
+	if (addr >= 0xf0 && addr <= 0xff) {
 		struct sdio_cmd52 cmd;
 
 		cmd.read_write = 1;
@@ -515,7 +515,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	int ret;
 
-	if ((addr >= 0xf0) && (addr <= 0xff)) {
+	if (addr >= 0xf0 && addr <= 0xff) {
 		struct sdio_cmd52 cmd;
 
 		cmd.read_write = 0;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index ff2ba10..8f71a60 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -390,11 +390,11 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 #define NUM_DATA_BYTES (4)
 #define NUM_CRC_BYTES (2)
 #define NUM_DUMMY_BYTES (3)
-	if ((cmd == CMD_RESET) ||
-	    (cmd == CMD_TERMINATE) ||
-	    (cmd == CMD_REPEAT)) {
+	if (cmd == CMD_RESET ||
+	    cmd == CMD_TERMINATE ||
+	    cmd == CMD_REPEAT) {
 		len2 = len + (NUM_SKIP_BYTES + NUM_RSP_BYTES + NUM_DUMMY_BYTES);
-	} else if ((cmd == CMD_INTERNAL_READ) || (cmd == CMD_SINGLE_READ)) {
+	} else if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ) {
 		if (!g_spi.crc_off) {
 			len2 = len + (NUM_RSP_BYTES + NUM_DATA_HDR_BYTES + NUM_DATA_BYTES
 				      + NUM_CRC_BYTES + NUM_DUMMY_BYTES);
@@ -425,9 +425,9 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	/**
 	 * Command/Control response
 	 **/
-	if ((cmd == CMD_RESET) ||
-	    (cmd == CMD_TERMINATE) ||
-	    (cmd == CMD_REPEAT)) {
+	if (cmd == CMD_RESET ||
+	    cmd == CMD_TERMINATE ||
+	    cmd == CMD_REPEAT) {
 		rix++;         /* skip 1 byte */
 	}
 
@@ -453,8 +453,8 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		return N_FAIL;
 	}
 
-	if ((cmd == CMD_INTERNAL_READ) || (cmd == CMD_SINGLE_READ) ||
-	    (cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
+	if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ ||
+	    cmd == CMD_DMA_READ || cmd == CMD_DMA_EXT_READ) {
 		int retry;
 		/* u16 crc1, crc2; */
 		u8 crc[2];
@@ -480,7 +480,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			return N_RESET;
 		}
 
-		if ((cmd == CMD_INTERNAL_READ) || (cmd == CMD_SINGLE_READ)) {
+		if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ) {
 			/**
 			 * Read bytes
 			 **/
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 47c7e2e..fb4a142 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -495,8 +495,8 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 
 		connect_status = conn_info->status;
 
-		if ((mac_status == MAC_DISCONNECTED) &&
-		    (conn_info->status == SUCCESSFUL_STATUSCODE)) {
+		if (mac_status == MAC_DISCONNECTED &&
+		    conn_info->status == SUCCESSFUL_STATUSCODE) {
 			connect_status = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, null_bssid,
 					    STATION_MODE);
@@ -548,9 +548,9 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 
 		if (!wfi_drv->p2p_connect)
 			wlan_channel = INVALID_CHANNEL;
-		if ((wfi_drv->IFC_UP) && (dev == wl->vif[1]->ndev))
+		if (wfi_drv->IFC_UP && dev == wl->vif[1]->ndev)
 			disconn_info->reason = 3;
-		else if ((!wfi_drv->IFC_UP) && (dev == wl->vif[1]->ndev))
+		else if (!wfi_drv->IFC_UP && dev == wl->vif[1]->ndev)
 			disconn_info->reason = 1;
 
 		cfg80211_disconnected(dev, disconn_info->reason, disconn_info->ie,
@@ -671,7 +671,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		wfi_drv->p2p_connect = 0;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		if ((sme->ssid_len == last_scanned_shadow[i].ssid_len) &&
+		if (sme->ssid_len == last_scanned_shadow[i].ssid_len &&
 		    memcmp(last_scanned_shadow[i].ssid,
 			   sme->ssid,
 			   sme->ssid_len) == 0) {
@@ -932,7 +932,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				memcpy(priv->wilc_gtk[key_index]->key, params->key, params->key_len);
 				kfree(priv->wilc_gtk[key_index]->seq);
 
-				if ((params->seq_len) > 0) {
+				if (params->seq_len > 0) {
 					priv->wilc_gtk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
 					memcpy(priv->wilc_gtk[key_index]->seq, params->seq, params->seq_len);
 				}
@@ -964,12 +964,12 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				kfree(priv->wilc_ptk[key_index]->seq);
 
-				if ((params->seq_len) > 0)
+				if (params->seq_len > 0)
 					priv->wilc_ptk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
 
 				memcpy(priv->wilc_ptk[key_index]->key, params->key, params->key_len);
 
-				if ((params->seq_len) > 0)
+				if (params->seq_len > 0)
 					memcpy(priv->wilc_ptk[key_index]->seq, params->seq, params->seq_len);
 
 				priv->wilc_ptk[key_index]->cipher = params->cipher;
@@ -1082,7 +1082,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		kfree(g_key_wep_params.key);
 		g_key_wep_params.key = NULL;
 
-		if ((priv->wilc_gtk[key_index]) != NULL) {
+		if (priv->wilc_gtk[key_index] != NULL) {
 			kfree(priv->wilc_gtk[key_index]->key);
 			priv->wilc_gtk[key_index]->key = NULL;
 			kfree(priv->wilc_gtk[key_index]->seq);
@@ -1092,7 +1092,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 			priv->wilc_gtk[key_index] = NULL;
 		}
 
-		if ((priv->wilc_ptk[key_index]) != NULL) {
+		if (priv->wilc_ptk[key_index] != NULL) {
 			kfree(priv->wilc_ptk[key_index]->key);
 			priv->wilc_ptk[key_index]->key = NULL;
 			kfree(priv->wilc_ptk[key_index]->seq);
@@ -1216,8 +1216,8 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		sinfo->tx_failed = stats.tx_fail_cnt;
 		sinfo->txrate.legacy = stats.link_speed * 10;
 
-		if ((stats.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH) &&
-		    (stats.link_speed != DEFAULT_LINK_SPEED))
+		if (stats.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
+		    stats.link_speed != DEFAULT_LINK_SPEED)
 			wilc_enable_tcp_ack_filter(true);
 		else if (stats.link_speed != DEFAULT_LINK_SPEED)
 			wilc_enable_tcp_ack_filter(false);
@@ -1893,7 +1893,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_ap_settings *settings)
 {
-	struct cfg80211_beacon_data *beacon = &(settings->beacon);
+	struct cfg80211_beacon_data *beacon = &settings->beacon;
 	struct wilc_priv *priv;
 	s32 ret = 0;
 	struct wilc *wl;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ac76bc7..acaeafc 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -693,7 +693,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		i = 0;
 		do {
 			tqe = wilc_wlan_txq_remove_from_head(dev);
-			if (tqe && (vmm_table[i] != 0)) {
+			if (tqe && vmm_table[i] != 0) {
 				u32 header, buffer_offset;
 
 				vmm_table[i] = cpu_to_le32(vmm_table[i]);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 19e4f85..aeb5417 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -235,7 +235,7 @@ static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset, u16 id, u8 *str, u32 siz
 	buf[2] = (u8)size;
 	buf[3] = (u8)(size >> 8);
 
-	if ((str) && (size != 0))
+	if (str && size != 0)
 		memcpy(&buf[4], str, size);
 
 	return (size + 4);
@@ -256,7 +256,7 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
 	buf[2] = (u8)size;
 	buf[3] = (u8)(size >> 8);
 
-	if ((b) && (size != 0)) {
+	if ((b) && size != 0) {
 		memcpy(&buf[4], b, size);
 		for (i = 0; i < size; i++)
 			checksum += buf[i + 4];
@@ -370,7 +370,7 @@ static int wilc_wlan_parse_info_frame(u8 *info, int size)
 
 	len = info[2];
 
-	if ((len == 1) && (wid == WID_STATUS)) {
+	if (len == 1 && wid == WID_STATUS) {
 		pd->mac_status = info[3];
 		type = WILC_CFG_RSP_STATUS;
 	}
-- 
2.7.4
