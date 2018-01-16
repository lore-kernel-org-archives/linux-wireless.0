Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:54714 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbeAPODG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:06 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/13] staging: wilc1000: rename camelCase used in functions start with WILC_WFI_Cfg
Date: Tue, 16 Jan 2018 19:32:25 +0530
Message-ID: <1516111351-5353-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150317_498940_F0CB9C17)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is cleanup patch, to fix the camelCase issue reported by
checkpatch.pl.
In this patch remane the function starts with "WILC_WFI_Cfg" to avoid
camelCase names.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 34 +++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 15d7e14..ec079cc 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1346,7 +1346,7 @@ static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
-static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
+static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32 len)
 {
 	u32 index = 0;
 	u32 i = 0, j = 0;
@@ -1382,7 +1382,7 @@ static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 	}
 }
 
-static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
+static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 len, bool oper_ch, u8 iftype)
 {
 	u32 index = 0;
 	u32 i = 0, j = 0;
@@ -1403,7 +1403,7 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 			op_channel_attr_index = index;
 		index += buf[index + 1] + 3;
 	}
-	if (wlan_channel != INVALID_CHANNEL && bOperChan) {
+	if (wlan_channel != INVALID_CHANNEL && oper_ch) {
 		if (channel_list_attr_index) {
 			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
 				if (buf[i] == 0x51) {
@@ -1481,7 +1481,7 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 							     buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < size; i++) {
 									if (buff[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buff[i + 2], 4))) {
-										WILC_WFI_CfgParseRxAction(&buff[i + 6], size - (i + 6));
+										wilc_wfi_cfg_parse_rx_action(&buff[i + 6], size - (i + 6));
 										break;
 									}
 								}
@@ -1508,7 +1508,7 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 	}
 }
 
-static void WILC_WFI_mgmt_tx_complete(void *priv, int status)
+static void wilc_wfi_mgmt_tx_complete(void *priv, int status)
 {
 	struct p2p_mgmt_data *pv_data = priv;
 
@@ -1516,11 +1516,11 @@ static void WILC_WFI_mgmt_tx_complete(void *priv, int status)
 	kfree(pv_data);
 }
 
-static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
+static void wilc_wfi_remain_on_channel_ready(void *priv_data)
 {
 	struct wilc_priv *priv;
 
-	priv = pUserVoid;
+	priv = priv_data;
 
 	priv->p2p_listen_state = true;
 
@@ -1531,13 +1531,13 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 				  GFP_KERNEL);
 }
 
-static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
+static void wilc_wfi_remain_on_channel_expired(void *data, u32 session_id)
 {
 	struct wilc_priv *priv;
 
-	priv = pUserVoid;
+	priv = data;
 
-	if (u32SessionID == priv->remain_on_ch_params.listen_session_id) {
+	if (session_id == priv->remain_on_ch_params.listen_session_id) {
 		priv->p2p_listen_state = false;
 
 		cfg80211_remain_on_channel_expired(priv->wdev,
@@ -1574,8 +1574,8 @@ static int remain_on_channel(struct wiphy *wiphy,
 	return wilc_remain_on_channel(vif,
 				priv->remain_on_ch_params.listen_session_id,
 				duration, chan->hw_value,
-				WILC_WFI_RemainOnChannelExpired,
-				WILC_WFI_RemainOnChannelReady, (void *)priv);
+				wilc_wfi_remain_on_channel_expired,
+				wilc_wfi_remain_on_channel_ready, (void *)priv);
 }
 
 static int cancel_remain_on_channel(struct wiphy *wiphy,
@@ -1665,9 +1665,9 @@ static int mgmt_tx(struct wiphy *wiphy,
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
 									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buf[i + 2], 4))) {
 										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
-											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), true, vif->iftype);
+											wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6], len - (i + 6), true, vif->iftype);
 										else
-											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), false, vif->iftype);
+											wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6], len - (i + 6), false, vif->iftype);
 										break;
 									}
 								}
@@ -1700,7 +1700,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 		wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, mgmt_tx,
 					   mgmt_tx->buff, mgmt_tx->size,
-					   WILC_WFI_mgmt_tx_complete);
+					   wilc_wfi_mgmt_tx_complete);
 	}
 	return 0;
 }
@@ -2198,7 +2198,7 @@ static const struct cfg80211_ops wilc_cfg80211_ops = {
 
 };
 
-static struct wireless_dev *WILC_WFI_CfgAlloc(void)
+static struct wireless_dev *wilc_wfi_cfg_alloc(void)
 {
 	struct wireless_dev *wdev;
 
@@ -2232,7 +2232,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	struct wireless_dev *wdev;
 	s32 ret = 0;
 
-	wdev = WILC_WFI_CfgAlloc();
+	wdev = wilc_wfi_cfg_alloc();
 	if (!wdev) {
 		netdev_err(net, "wiphy new allocate failed\n");
 		return NULL;
-- 
2.7.4
