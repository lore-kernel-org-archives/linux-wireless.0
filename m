Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbeBTO6o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:44 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/12] staging: wilc1000: rename pstrStationParam to avoid camelCase
Date: Tue, 20 Feb 2018 20:27:59 +0530
Message-ID: <1519138681-1982-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155847_409254_7E580B37)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 46 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8ec33b3..8528ff8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2061,40 +2061,38 @@ static void handle_del_beacon(struct wilc_vif *vif)
 }
 
 static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
-				    struct add_sta_param *pstrStationParam)
+				    struct add_sta_param *param)
 {
 	u8 *cur_byte;
 
 	cur_byte = pu8Buffer;
 
-	memcpy(cur_byte, pstrStationParam->bssid, ETH_ALEN);
+	memcpy(cur_byte, param->bssid, ETH_ALEN);
 	cur_byte +=  ETH_ALEN;
 
-	*cur_byte++ = pstrStationParam->aid & 0xFF;
-	*cur_byte++ = (pstrStationParam->aid >> 8) & 0xFF;
+	*cur_byte++ = param->aid & 0xFF;
+	*cur_byte++ = (param->aid >> 8) & 0xFF;
 
-	*cur_byte++ = pstrStationParam->rates_len;
-	if (pstrStationParam->rates_len > 0)
-		memcpy(cur_byte, pstrStationParam->rates,
-		       pstrStationParam->rates_len);
-	cur_byte += pstrStationParam->rates_len;
+	*cur_byte++ = param->rates_len;
+	if (param->rates_len > 0)
+		memcpy(cur_byte, param->rates, param->rates_len);
+	cur_byte += param->rates_len;
 
-	*cur_byte++ = pstrStationParam->ht_supported;
-	memcpy(cur_byte, &pstrStationParam->ht_capa,
-	       sizeof(struct ieee80211_ht_cap));
+	*cur_byte++ = param->ht_supported;
+	memcpy(cur_byte, &param->ht_capa, sizeof(struct ieee80211_ht_cap));
 	cur_byte += sizeof(struct ieee80211_ht_cap);
 
-	*cur_byte++ = pstrStationParam->flags_mask & 0xFF;
-	*cur_byte++ = (pstrStationParam->flags_mask >> 8) & 0xFF;
+	*cur_byte++ = param->flags_mask & 0xFF;
+	*cur_byte++ = (param->flags_mask >> 8) & 0xFF;
 
-	*cur_byte++ = pstrStationParam->flags_set & 0xFF;
-	*cur_byte++ = (pstrStationParam->flags_set >> 8) & 0xFF;
+	*cur_byte++ = param->flags_set & 0xFF;
+	*cur_byte++ = (param->flags_set >> 8) & 0xFF;
 
 	return cur_byte - pu8Buffer;
 }
 
 static void handle_add_station(struct wilc_vif *vif,
-			       struct add_sta_param *pstrStationParam)
+			       struct add_sta_param *param)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2102,14 +2100,14 @@ static void handle_add_station(struct wilc_vif *vif,
 
 	wid.id = (u16)WID_ADD_STA;
 	wid.type = WID_BIN;
-	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->rates_len;
+	wid.size = WILC_ADD_STA_LENGTH + param->rates_len;
 
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
 
 	cur_byte = wid.val;
-	cur_byte += WILC_HostIf_PackStaParam(cur_byte, pstrStationParam);
+	cur_byte += WILC_HostIf_PackStaParam(cur_byte, param);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2117,7 +2115,7 @@ static void handle_add_station(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to send add station\n");
 
 ERRORHANDLER:
-	kfree(pstrStationParam->rates);
+	kfree(param->rates);
 	kfree(wid.val);
 }
 
@@ -2190,7 +2188,7 @@ static void handle_del_station(struct wilc_vif *vif, struct del_sta *param)
 }
 
 static void handle_edit_station(struct wilc_vif *vif,
-				struct add_sta_param *pstrStationParam)
+				struct add_sta_param *param)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2198,14 +2196,14 @@ static void handle_edit_station(struct wilc_vif *vif,
 
 	wid.id = (u16)WID_EDIT_STA;
 	wid.type = WID_BIN;
-	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->rates_len;
+	wid.size = WILC_ADD_STA_LENGTH + param->rates_len;
 
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
 		goto ERRORHANDLER;
 
 	cur_byte = wid.val;
-	cur_byte += WILC_HostIf_PackStaParam(cur_byte, pstrStationParam);
+	cur_byte += WILC_HostIf_PackStaParam(cur_byte, param);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2213,7 +2211,7 @@ static void handle_edit_station(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to send edit station\n");
 
 ERRORHANDLER:
-	kfree(pstrStationParam->rates);
+	kfree(param->rates);
 	kfree(wid.val);
 }
 
-- 
2.7.4
