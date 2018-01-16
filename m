Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:51006 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbeAPODJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:09 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/13] staging: wilc1000: rename pstrWFIDrv to wfi_drv to avoid camelCase naming
Date: Tue, 16 Jan 2018 19:32:26 +0530
Message-ID: <1516111351-5353-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150318_146330_F8B416B0)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is cleanup patch, it fixes "Avoid CamelCase: <pstrWFIDrv>"
issue found by checkpatch.pl

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 36 +++++++++++------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ec079cc..1c5782e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -656,19 +656,19 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	enum AUTHTYPE tenuAuth_type = ANY;
 
 	struct wilc_priv *priv;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *wfi_drv;
 	struct network_info *pstrNetworkInfo = NULL;
 	struct wilc_vif *vif;
 
 	wilc_connecting = 1;
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
-	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
+	wfi_drv = (struct host_if_drv *)priv->hif_drv;
 
 	if (!(strncmp(sme->ssid, "DIRECT-", 7)))
-		pstrWFIDrv->p2p_connect = 1;
+		wfi_drv->p2p_connect = 1;
 	else
-		pstrWFIDrv->p2p_connect = 0;
+		wfi_drv->p2p_connect = 0;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
 		if ((sme->ssid_len == last_scanned_shadow[i].ssid_len) &&
@@ -787,7 +787,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	curr_channel = pstrNetworkInfo->ch;
 
-	if (!pstrWFIDrv->p2p_connect)
+	if (!wfi_drv->p2p_connect)
 		wlan_channel = pstrNetworkInfo->ch;
 
 	wilc_wlan_set_bssid(dev, pstrNetworkInfo->bssid, STATION_MODE);
@@ -812,7 +812,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 {
 	s32 ret = 0;
 	struct wilc_priv *priv;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *wfi_drv;
 	struct wilc_vif *vif;
 	struct wilc *wilc;
 	u8 NullBssid[ETH_ALEN] = {0};
@@ -831,15 +831,15 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 		return 0;
 	}
 
-	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
-	if (!pstrWFIDrv->p2p_connect)
+	wfi_drv = (struct host_if_drv *)priv->hif_drv;
+	if (!wfi_drv->p2p_connect)
 		wlan_channel = INVALID_CHANNEL;
 	wilc_wlan_set_bssid(priv->dev, NullBssid, STATION_MODE);
 
 	p2p_local_random = 0x01;
 	p2p_recv_random = 0x00;
 	wilc_ie = false;
-	pstrWFIDrv->p2p_timeout = 0;
+	wfi_drv->p2p_timeout = 0;
 
 	ret = wilc_disconnect(vif, reason_code);
 	if (ret != 0) {
@@ -1425,12 +1425,12 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 {
 	struct wilc_priv *priv;
 	u32 header, pkt_offset;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *wfi_drv;
 	u32 i = 0;
 	s32 s32Freq;
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
+	wfi_drv = (struct host_if_drv *)priv->hif_drv;
 
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
 
@@ -1451,7 +1451,7 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 		s32Freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
 
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
-			if (priv->cfg_scanning && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->p2p_timeout)) {
+			if (priv->cfg_scanning && time_after_eq(jiffies, (unsigned long)wfi_drv->p2p_timeout)) {
 				netdev_dbg(dev, "Receiving action wrong ch\n");
 				return;
 			}
@@ -1604,14 +1604,14 @@ static int mgmt_tx(struct wiphy *wiphy,
 	const struct ieee80211_mgmt *mgmt;
 	struct p2p_mgmt_data *mgmt_tx;
 	struct wilc_priv *priv;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *wfi_drv;
 	u32 i;
 	struct wilc_vif *vif;
 	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(p2p_local_random);
 
 	vif = netdev_priv(wdev->netdev);
 	priv = wiphy_priv(wiphy);
-	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
+	wfi_drv = (struct host_if_drv *)priv->hif_drv;
 
 	*cookie = (unsigned long)buf;
 	priv->tx_cookie = *cookie;
@@ -1695,7 +1695,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 				}
 			}
 
-			pstrWFIDrv->p2p_timeout = (jiffies + msecs_to_jiffies(wait));
+			wfi_drv->p2p_timeout = (jiffies + msecs_to_jiffies(wait));
 		}
 
 		wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, mgmt_tx,
@@ -1710,11 +1710,11 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 			       u64 cookie)
 {
 	struct wilc_priv *priv;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *wfi_drv;
 
 	priv = wiphy_priv(wiphy);
-	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
-	pstrWFIDrv->p2p_timeout = jiffies;
+	wfi_drv = (struct host_if_drv *)priv->hif_drv;
+	wfi_drv->p2p_timeout = jiffies;
 
 	if (!priv->p2p_listen_state) {
 		cfg80211_remain_on_channel_expired(priv->wdev,
-- 
2.7.4
