Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32975 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936582AbdEYR2q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:28:46 -0400
Received: by mail-wm0-f68.google.com with SMTP id b84so38850756wmh.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 10:28:45 -0700 (PDT)
From: Marko Stankovic <dartnorris@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marko Stankovic <dartnorris@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 1/2] staging: wilc1000: remove excessive blank lines
Date: Thu, 25 May 2017 19:28:30 +0200
Message-Id: <20170525172831.14596-1-dartnorris@gmail.com> (sfid-20170525_192850_331195_26CBC098)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the multiple blank lines issue reported by checkpatch.pl

Signed-off-by: Marko Stankovic <dartnorris@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 807aada308e3..98316a45abd1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -84,7 +84,6 @@ static const struct wiphy_wowlan_support wowlan_support = {
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 
-
 #define IS_MANAGMEMENT				0x100
 #define IS_MANAGMEMENT_CALLBACK			0x080
 #define IS_MGMT_STATUS_SUCCES			0x040
@@ -163,7 +162,6 @@ static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
 	.n_bitrates = ARRAY_SIZE(ieee80211_bitrates),
 };
 
-
 struct add_key_params {
 	u8 key_idx;
 	bool pairwise;
@@ -281,7 +279,6 @@ static void remove_network_from_shadow(unsigned long arg)
 	unsigned long now = jiffies;
 	int i, j;
 
-
 	for (i = 0; i < last_scanned_cnt; i++) {
 		if (time_after(now, last_scanned_shadow[i].time_scan +
 			       (unsigned long)(SCAN_RESULT_EXPIRE))) {
@@ -526,7 +523,6 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 			memcpy(priv->au8AssociatedBss, pstrConnectInfo->bssid, ETH_ALEN);
 
-
 			for (i = 0; i < last_scanned_cnt; i++) {
 				if (memcmp(last_scanned_shadow[i].bssid,
 					   pstrConnectInfo->bssid,
@@ -626,7 +622,6 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				return -ENOMEM;
 			strHiddenNetwork.n_ssids = request->n_ssids;
 
-
 			for (i = 0; i < request->n_ssids; i++) {
 				if (request->ssids[i].ssid_len != 0) {
 					strHiddenNetwork.net_info[i].ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
@@ -927,8 +922,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				priv->wilc_ptk[key_index]->seq = NULL;
 			}
 
-
-
 			if (!pairwise) {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
 					u8gmode = ENCRYPT_ENABLED | WPA | TKIP;
@@ -968,7 +961,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				else
 					u8pmode = priv->wilc_groupkey | AES;
 
-
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
 					pu8TxMic = params->key + 24;
 					pu8RxMic = params->key + 16;
@@ -1153,7 +1145,6 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	priv = wiphy_priv(wiphy);
 
-
 	if (!pairwise) {
 		key_params.key = priv->wilc_gtk[key_index]->key;
 		key_params.cipher = priv->wilc_gtk[key_index]->cipher;
@@ -1298,7 +1289,6 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	vif = netdev_priv(priv->dev);
 
-
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 			    ETH_ALEN)) {
@@ -1511,7 +1501,6 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 						}
 					}
 
-
 					if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP) && (wilc_ie))	{
 						cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size - 7, 0);
 						return;
@@ -1533,7 +1522,6 @@ static void WILC_WFI_mgmt_tx_complete(void *priv, int status)
 {
 	struct p2p_mgmt_data *pv_data = priv;
 
-
 	kfree(pv_data->buff);
 	kfree(pv_data);
 }
@@ -1653,7 +1641,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 		memcpy(mgmt_tx->buff, buf, len);
 		mgmt_tx->size = len;
 
-
 		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 			wilc_set_mac_chnl_num(vif, chan->hw_value);
 			curr_channel = chan->hw_value;
@@ -1832,7 +1819,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	if (wilc_enable_ps)
 		wilc_set_power_mgmt(vif, enabled, timeout);
 
-
 	return 0;
 }
 
@@ -2094,7 +2080,6 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->wdev->netdev);
 
-
 	if (type == NL80211_IFTYPE_MONITOR) {
 		new_ifc = WILC_WFI_init_mon_interface(name, vif->ndev);
 		if (new_ifc) {
-- 
2.11.0
