Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38281 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeEFHdb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 May 2018 03:33:31 -0400
From: Nathan Chancellor <natechancellor@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 1/3] staging: wilc1000: Remove unused variables
Date: Sun,  6 May 2018 00:33:31 -0700
Message-Id: <20180506073333.3770-1-natechancellor@gmail.com> (sfid-20180506_093432_939687_3DE117E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GCC warns these variables are all set but never used so remove them.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 12 ------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 ------
 2 files changed, 18 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 28edd904b33a..3fd4c8e62da6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1432,13 +1432,7 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	u8 msg_type = 0;
-	u8 msg_id = 0;
-	u16 msg_len = 0;
-	u16 wid_id = (u16)WID_NIL;
-	u8 wid_len  = 0;
 	u8 mac_status;
-	u8 mac_status_reason_code;
-	u8 mac_status_additional_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!rcvd_info->buffer) {
@@ -1472,13 +1466,7 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 			return -EFAULT;
 		}
 
-		msg_id = rcvd_info->buffer[1];
-		msg_len = MAKE_WORD16(rcvd_info->buffer[2], rcvd_info->buffer[3]);
-		wid_id = MAKE_WORD16(rcvd_info->buffer[4], rcvd_info->buffer[5]);
-		wid_len = rcvd_info->buffer[6];
 		mac_status  = rcvd_info->buffer[7];
-		mac_status_reason_code = rcvd_info->buffer[8];
-		mac_status_additional_info = rcvd_info->buffer[9];
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 			host_int_parse_assoc_resp_info(vif, mac_status);
 		} else if ((mac_status == MAC_STATUS_DISCONNECTED) &&
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8be3c4c57579..76b4afaef423 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -917,12 +917,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	const u8 *tx_mic = NULL;
 	u8 mode = NO_ENCRYPT;
 	u8 op_mode;
-	struct wilc *wl;
 	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(netdev);
-	wl = vif->wilc;
 
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -1885,12 +1883,10 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_ap_settings *settings)
 {
 	struct cfg80211_beacon_data *beacon = &settings->beacon;
-	struct wilc_priv *priv;
 	s32 ret = 0;
 	struct wilc *wl;
 	struct wilc_vif *vif;
 
-	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
 
@@ -2016,14 +2012,12 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			  const u8 *mac, struct station_parameters *params)
 {
 	s32 ret = 0;
-	struct wilc_priv *priv;
 	struct add_sta_param sta_params = { {0} };
 	struct wilc_vif *vif;
 
 	if (!wiphy)
 		return -EFAULT;
 
-	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-- 
2.17.0
