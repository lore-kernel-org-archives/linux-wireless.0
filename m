Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40301 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423AbcBRHbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 02:31:40 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 11/24] staging: wilc1000: host_interface.c: removes unnecessary log messages
Date: Thu, 18 Feb 2016 16:27:22 +0900
Message-ID: <1455780455-21365-11-git-send-email-leo.kim@atmel.com> (sfid-20160218_085810_506762_7907A4CE)
In-Reply-To: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
References: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log message and relate variables.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7b9dbc0..ee45103 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2106,8 +2106,6 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 	stamac = wid.val;
 	memcpy(stamac, strHostIfStaInactiveT->mac, ETH_ALEN);
 
-	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
-
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
@@ -2129,8 +2127,6 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 		return -EFAULT;
 	}
 
-	PRINT_D(CFG80211_DBG, "Getting inactive time : %d\n", inactive_time);
-
 	up(&hif_drv->sem_inactive_time);
 
 	return result;
@@ -3048,7 +3044,6 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	u8 key_len = ptk_key_len;
-	int i;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -3076,20 +3071,11 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	if (!msg.body.key_info.attr.wpa.key)
 		return -ENOMEM;
 
-	if (rx_mic) {
+	if (rx_mic)
 		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic, RX_MIC_KEY_LEN);
-		if (INFO) {
-			for (i = 0; i < RX_MIC_KEY_LEN; i++)
-				PRINT_INFO(CFG80211_DBG, "PairwiseRx[%d] = %x\n", i, rx_mic[i]);
-		}
-	}
-	if (tx_mic) {
+
+	if (tx_mic)
 		memcpy(msg.body.key_info.attr.wpa.key + 24, tx_mic, TX_MIC_KEY_LEN);
-		if (INFO) {
-			for (i = 0; i < TX_MIC_KEY_LEN; i++)
-				PRINT_INFO(CFG80211_DBG, "PairwiseTx[%d] = %x\n", i, tx_mic[i]);
-		}
-	}
 
 	msg.body.key_info.attr.wpa.key_len = key_len;
 	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
@@ -4096,20 +4082,11 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	for (i = 0; i < MAX_NUM_STA; i++) {
 		if (memcmp(mac_addr[i], zero_addr, ETH_ALEN)) {
 			memcpy(del_all_sta_info->del_all_sta[i], mac_addr[i], ETH_ALEN);
-			PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n",
-				del_all_sta_info->del_all_sta[i][0],
-				del_all_sta_info->del_all_sta[i][1],
-				del_all_sta_info->del_all_sta[i][2],
-				del_all_sta_info->del_all_sta[i][3],
-				del_all_sta_info->del_all_sta[i][4],
-				del_all_sta_info->del_all_sta[i][5]);
 			assoc_sta++;
 		}
 	}
-	if (!assoc_sta) {
-		PRINT_D(CFG80211_DBG, "NO ASSOCIATED STAS\n");
+	if (!assoc_sta)
 		return result;
-	}
 
 	del_all_sta_info->assoc_sta = assoc_sta;
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

