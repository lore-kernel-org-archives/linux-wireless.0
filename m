Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:35966 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbeAVKXT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 05:23:19 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 08/14] staging: wilc1000: rename pu8CurrByte variable to avoid camelCase
Date: Mon, 22 Jan 2018 15:52:21 +0530
Message-ID: <1516616547-24654-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180122_112322_533469_714AF77A)
In-Reply-To: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue reported by checkpatch.pl script.
rename variable name from "pu8CurrByte" to "cur_byte"

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 232 +++++++++++++++---------------
 1 file changed, 116 insertions(+), 116 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 496c72f..43f8559 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -908,7 +908,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid_list[8];
 	u32 wid_cnt = 0, dummyval = 0;
-	u8 *pu8CurrByte = NULL;
+	u8 *cur_byte = NULL;
 	struct join_bss_param *ptstrJoinBssParam;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -1016,90 +1016,90 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		goto ERRORHANDLER;
 	}
 
-	pu8CurrByte = wid_list[wid_cnt].val;
+	cur_byte = wid_list[wid_cnt].val;
 
 	if (pstrHostIFconnectAttr->ssid) {
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssid_len);
-		pu8CurrByte[pstrHostIFconnectAttr->ssid_len] = '\0';
+		memcpy(cur_byte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssid_len);
+		cur_byte[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
-	pu8CurrByte += MAX_SSID_LEN;
-	*(pu8CurrByte++) = INFRASTRUCTURE;
+	cur_byte += MAX_SSID_LEN;
+	*(cur_byte++) = INFRASTRUCTURE;
 
 	if (pstrHostIFconnectAttr->ch >= 1 && pstrHostIFconnectAttr->ch <= 14) {
-		*(pu8CurrByte++) = pstrHostIFconnectAttr->ch;
+		*(cur_byte++) = pstrHostIFconnectAttr->ch;
 	} else {
 		netdev_err(vif->ndev, "Channel out of range\n");
-		*(pu8CurrByte++) = 0xFF;
+		*(cur_byte++) = 0xFF;
 	}
-	*(pu8CurrByte++)  = (ptstrJoinBssParam->cap_info) & 0xFF;
-	*(pu8CurrByte++)  = ((ptstrJoinBssParam->cap_info) >> 8) & 0xFF;
+	*(cur_byte++)  = (ptstrJoinBssParam->cap_info) & 0xFF;
+	*(cur_byte++)  = ((ptstrJoinBssParam->cap_info) >> 8) & 0xFF;
 
 	if (pstrHostIFconnectAttr->bssid)
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->bssid, 6);
-	pu8CurrByte += 6;
+		memcpy(cur_byte, pstrHostIFconnectAttr->bssid, 6);
+	cur_byte += 6;
 
 	if (pstrHostIFconnectAttr->bssid)
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->bssid, 6);
-	pu8CurrByte += 6;
+		memcpy(cur_byte, pstrHostIFconnectAttr->bssid, 6);
+	cur_byte += 6;
 
-	*(pu8CurrByte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
-	*(pu8CurrByte++)  = ((ptstrJoinBssParam->beacon_period) >> 8) & 0xFF;
-	*(pu8CurrByte++)  =  ptstrJoinBssParam->dtim_period;
+	*(cur_byte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
+	*(cur_byte++)  = ((ptstrJoinBssParam->beacon_period) >> 8) & 0xFF;
+	*(cur_byte++)  =  ptstrJoinBssParam->dtim_period;
 
-	memcpy(pu8CurrByte, ptstrJoinBssParam->supp_rates, MAX_RATES_SUPPORTED + 1);
-	pu8CurrByte += (MAX_RATES_SUPPORTED + 1);
+	memcpy(cur_byte, ptstrJoinBssParam->supp_rates, MAX_RATES_SUPPORTED + 1);
+	cur_byte += (MAX_RATES_SUPPORTED + 1);
 
-	*(pu8CurrByte++)  =  ptstrJoinBssParam->wmm_cap;
-	*(pu8CurrByte++)  = ptstrJoinBssParam->uapsd_cap;
+	*(cur_byte++)  =  ptstrJoinBssParam->wmm_cap;
+	*(cur_byte++)  = ptstrJoinBssParam->uapsd_cap;
 
-	*(pu8CurrByte++)  = ptstrJoinBssParam->ht_capable;
+	*(cur_byte++)  = ptstrJoinBssParam->ht_capable;
 	hif_drv->usr_conn_req.ht_capable = ptstrJoinBssParam->ht_capable;
 
-	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_found;
-	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_grp_policy;
-	*(pu8CurrByte++) =  ptstrJoinBssParam->mode_802_11i;
+	*(cur_byte++)  =  ptstrJoinBssParam->rsn_found;
+	*(cur_byte++)  =  ptstrJoinBssParam->rsn_grp_policy;
+	*(cur_byte++) =  ptstrJoinBssParam->mode_802_11i;
 
-	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_pcip_policy, sizeof(ptstrJoinBssParam->rsn_pcip_policy));
-	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_pcip_policy);
+	memcpy(cur_byte, ptstrJoinBssParam->rsn_pcip_policy, sizeof(ptstrJoinBssParam->rsn_pcip_policy));
+	cur_byte += sizeof(ptstrJoinBssParam->rsn_pcip_policy);
 
-	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_auth_policy, sizeof(ptstrJoinBssParam->rsn_auth_policy));
-	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_auth_policy);
+	memcpy(cur_byte, ptstrJoinBssParam->rsn_auth_policy, sizeof(ptstrJoinBssParam->rsn_auth_policy));
+	cur_byte += sizeof(ptstrJoinBssParam->rsn_auth_policy);
 
-	memcpy(pu8CurrByte, ptstrJoinBssParam->rsn_cap, sizeof(ptstrJoinBssParam->rsn_cap));
-	pu8CurrByte += sizeof(ptstrJoinBssParam->rsn_cap);
+	memcpy(cur_byte, ptstrJoinBssParam->rsn_cap, sizeof(ptstrJoinBssParam->rsn_cap));
+	cur_byte += sizeof(ptstrJoinBssParam->rsn_cap);
 
-	*(pu8CurrByte++) = REAL_JOIN_REQ;
-	*(pu8CurrByte++) = ptstrJoinBssParam->noa_enabled;
+	*(cur_byte++) = REAL_JOIN_REQ;
+	*(cur_byte++) = ptstrJoinBssParam->noa_enabled;
 
 	if (ptstrJoinBssParam->noa_enabled) {
-		*(pu8CurrByte++) = (ptstrJoinBssParam->tsf) & 0xFF;
-		*(pu8CurrByte++) = ((ptstrJoinBssParam->tsf) >> 8) & 0xFF;
-		*(pu8CurrByte++) = ((ptstrJoinBssParam->tsf) >> 16) & 0xFF;
-		*(pu8CurrByte++) = ((ptstrJoinBssParam->tsf) >> 24) & 0xFF;
+		*(cur_byte++) = (ptstrJoinBssParam->tsf) & 0xFF;
+		*(cur_byte++) = ((ptstrJoinBssParam->tsf) >> 8) & 0xFF;
+		*(cur_byte++) = ((ptstrJoinBssParam->tsf) >> 16) & 0xFF;
+		*(cur_byte++) = ((ptstrJoinBssParam->tsf) >> 24) & 0xFF;
 
-		*(pu8CurrByte++) = ptstrJoinBssParam->opp_enabled;
-		*(pu8CurrByte++) = ptstrJoinBssParam->idx;
+		*(cur_byte++) = ptstrJoinBssParam->opp_enabled;
+		*(cur_byte++) = ptstrJoinBssParam->idx;
 
 		if (ptstrJoinBssParam->opp_enabled)
-			*(pu8CurrByte++) = ptstrJoinBssParam->ct_window;
+			*(cur_byte++) = ptstrJoinBssParam->ct_window;
 
-		*(pu8CurrByte++) = ptstrJoinBssParam->cnt;
+		*(cur_byte++) = ptstrJoinBssParam->cnt;
 
-		memcpy(pu8CurrByte, ptstrJoinBssParam->duration, sizeof(ptstrJoinBssParam->duration));
-		pu8CurrByte += sizeof(ptstrJoinBssParam->duration);
+		memcpy(cur_byte, ptstrJoinBssParam->duration, sizeof(ptstrJoinBssParam->duration));
+		cur_byte += sizeof(ptstrJoinBssParam->duration);
 
-		memcpy(pu8CurrByte, ptstrJoinBssParam->interval, sizeof(ptstrJoinBssParam->interval));
-		pu8CurrByte += sizeof(ptstrJoinBssParam->interval);
+		memcpy(cur_byte, ptstrJoinBssParam->interval, sizeof(ptstrJoinBssParam->interval));
+		cur_byte += sizeof(ptstrJoinBssParam->interval);
 
-		memcpy(pu8CurrByte, ptstrJoinBssParam->start_time, sizeof(ptstrJoinBssParam->start_time));
-		pu8CurrByte += sizeof(ptstrJoinBssParam->start_time);
+		memcpy(cur_byte, ptstrJoinBssParam->start_time, sizeof(ptstrJoinBssParam->start_time));
+		cur_byte += sizeof(ptstrJoinBssParam->start_time);
 	}
 
-	pu8CurrByte = wid_list[wid_cnt].val;
+	cur_byte = wid_list[wid_cnt].val;
 	wid_cnt++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-		memcpy(join_req, pu8CurrByte, join_req_size);
+		memcpy(join_req, cur_byte, join_req_size);
 		join_req_vif = vif;
 	}
 
@@ -1161,7 +1161,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	kfree(pstrHostIFconnectAttr->ies);
 	pstrHostIFconnectAttr->ies = NULL;
 
-	kfree(pu8CurrByte);
+	kfree(cur_byte);
 	return result;
 }
 
@@ -1992,7 +1992,7 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *pu8CurrByte;
+	u8 *cur_byte;
 
 	wid.id = (u16)WID_ADD_BEACON;
 	wid.type = WID_BIN;
@@ -2001,33 +2001,33 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = wid.val;
-	*pu8CurrByte++ = (pstrSetBeaconParam->interval & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->interval >> 8) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->interval >> 16) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->interval >> 24) & 0xFF);
+	cur_byte = wid.val;
+	*cur_byte++ = (pstrSetBeaconParam->interval & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->interval >> 8) & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->interval >> 16) & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->interval >> 24) & 0xFF);
 
-	*pu8CurrByte++ = (pstrSetBeaconParam->dtim_period & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->dtim_period >> 8) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->dtim_period >> 16) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->dtim_period >> 24) & 0xFF);
+	*cur_byte++ = (pstrSetBeaconParam->dtim_period & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->dtim_period >> 8) & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->dtim_period >> 16) & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->dtim_period >> 24) & 0xFF);
 
-	*pu8CurrByte++ = (pstrSetBeaconParam->head_len & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->head_len >> 8) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->head_len >> 16) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->head_len >> 24) & 0xFF);
+	*cur_byte++ = (pstrSetBeaconParam->head_len & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->head_len >> 8) & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->head_len >> 16) & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->head_len >> 24) & 0xFF);
 
-	memcpy(pu8CurrByte, pstrSetBeaconParam->head, pstrSetBeaconParam->head_len);
-	pu8CurrByte += pstrSetBeaconParam->head_len;
+	memcpy(cur_byte, pstrSetBeaconParam->head, pstrSetBeaconParam->head_len);
+	cur_byte += pstrSetBeaconParam->head_len;
 
-	*pu8CurrByte++ = (pstrSetBeaconParam->tail_len & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 8) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
-	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
+	*cur_byte++ = (pstrSetBeaconParam->tail_len & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->tail_len >> 8) & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
+	*cur_byte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
 
 	if (pstrSetBeaconParam->tail)
-		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
-	pu8CurrByte += pstrSetBeaconParam->tail_len;
+		memcpy(cur_byte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
+	cur_byte += pstrSetBeaconParam->tail_len;
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2044,7 +2044,7 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *pu8CurrByte;
+	u8 *cur_byte;
 
 	wid.id = (u16)WID_DEL_BEACON;
 	wid.type = WID_CHAR;
@@ -2054,7 +2054,7 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 	if (!wid.val)
 		return;
 
-	pu8CurrByte = wid.val;
+	cur_byte = wid.val;
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2065,34 +2065,34 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 				    struct add_sta_param *pstrStationParam)
 {
-	u8 *pu8CurrByte;
+	u8 *cur_byte;
 
-	pu8CurrByte = pu8Buffer;
+	cur_byte = pu8Buffer;
 
-	memcpy(pu8CurrByte, pstrStationParam->bssid, ETH_ALEN);
-	pu8CurrByte +=  ETH_ALEN;
+	memcpy(cur_byte, pstrStationParam->bssid, ETH_ALEN);
+	cur_byte +=  ETH_ALEN;
 
-	*pu8CurrByte++ = pstrStationParam->aid & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->aid >> 8) & 0xFF;
+	*cur_byte++ = pstrStationParam->aid & 0xFF;
+	*cur_byte++ = (pstrStationParam->aid >> 8) & 0xFF;
 
-	*pu8CurrByte++ = pstrStationParam->rates_len;
+	*cur_byte++ = pstrStationParam->rates_len;
 	if (pstrStationParam->rates_len > 0)
-		memcpy(pu8CurrByte, pstrStationParam->rates,
+		memcpy(cur_byte, pstrStationParam->rates,
 		       pstrStationParam->rates_len);
-	pu8CurrByte += pstrStationParam->rates_len;
+	cur_byte += pstrStationParam->rates_len;
 
-	*pu8CurrByte++ = pstrStationParam->ht_supported;
-	memcpy(pu8CurrByte, &pstrStationParam->ht_capa,
+	*cur_byte++ = pstrStationParam->ht_supported;
+	memcpy(cur_byte, &pstrStationParam->ht_capa,
 	       sizeof(struct ieee80211_ht_cap));
-	pu8CurrByte += sizeof(struct ieee80211_ht_cap);
+	cur_byte += sizeof(struct ieee80211_ht_cap);
 
-	*pu8CurrByte++ = pstrStationParam->flags_mask & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->flags_mask >> 8) & 0xFF;
+	*cur_byte++ = pstrStationParam->flags_mask & 0xFF;
+	*cur_byte++ = (pstrStationParam->flags_mask >> 8) & 0xFF;
 
-	*pu8CurrByte++ = pstrStationParam->flags_set & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->flags_set >> 8) & 0xFF;
+	*cur_byte++ = pstrStationParam->flags_set & 0xFF;
+	*cur_byte++ = (pstrStationParam->flags_set >> 8) & 0xFF;
 
-	return pu8CurrByte - pu8Buffer;
+	return cur_byte - pu8Buffer;
 }
 
 static void Handle_AddStation(struct wilc_vif *vif,
@@ -2100,7 +2100,7 @@ static void Handle_AddStation(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *pu8CurrByte;
+	u8 *cur_byte;
 
 	wid.id = (u16)WID_ADD_STA;
 	wid.type = WID_BIN;
@@ -2110,8 +2110,8 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = wid.val;
-	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
+	cur_byte = wid.val;
+	cur_byte += WILC_HostIf_PackStaParam(cur_byte, pstrStationParam);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2169,7 +2169,7 @@ static void Handle_DelStation(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *pu8CurrByte;
+	u8 *cur_byte;
 
 	wid.id = (u16)WID_REMOVE_STA;
 	wid.type = WID_BIN;
@@ -2179,9 +2179,9 @@ static void Handle_DelStation(struct wilc_vif *vif,
 	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = wid.val;
+	cur_byte = wid.val;
 
-	ether_addr_copy(pu8CurrByte, pstrDelStaParam->mac_addr);
+	ether_addr_copy(cur_byte, pstrDelStaParam->mac_addr);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2197,7 +2197,7 @@ static void Handle_EditStation(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *pu8CurrByte;
+	u8 *cur_byte;
 
 	wid.id = (u16)WID_EDIT_STA;
 	wid.type = WID_BIN;
@@ -2207,8 +2207,8 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = wid.val;
-	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
+	cur_byte = wid.val;
+	cur_byte += WILC_HostIf_PackStaParam(cur_byte, pstrStationParam);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2294,7 +2294,7 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *pu8CurrByte;
+	u8 *cur_byte;
 
 	wid.id = (u16)WID_REGISTER_FRAME;
 	wid.type = WID_STR;
@@ -2302,11 +2302,11 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 	if (!wid.val)
 		return -ENOMEM;
 
-	pu8CurrByte = wid.val;
+	cur_byte = wid.val;
 
-	*pu8CurrByte++ = pstrHostIfRegisterFrame->reg;
-	*pu8CurrByte++ = pstrHostIfRegisterFrame->reg_id;
-	memcpy(pu8CurrByte, &pstrHostIfRegisterFrame->frame_type, sizeof(u16));
+	*cur_byte++ = pstrHostIfRegisterFrame->reg;
+	*cur_byte++ = pstrHostIfRegisterFrame->reg_id;
+	memcpy(cur_byte, &pstrHostIfRegisterFrame->frame_type, sizeof(u16));
 
 	wid.size = sizeof(u16) + 2;
 
@@ -2410,7 +2410,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 {
 	s32 result = 0;
 	struct wid wid;
-	u8 *pu8CurrByte;
+	u8 *cur_byte;
 
 	wid.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	wid.type = WID_BIN;
@@ -2419,19 +2419,19 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = wid.val;
-	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
-	*pu8CurrByte++ = 0;
-	*pu8CurrByte++ = 0;
-	*pu8CurrByte++ = 0;
+	cur_byte = wid.val;
+	*cur_byte++ = (strHostIfSetMulti->enabled & 0xFF);
+	*cur_byte++ = 0;
+	*cur_byte++ = 0;
+	*cur_byte++ = 0;
 
-	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 16) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 24) & 0xFF);
+	*cur_byte++ = (strHostIfSetMulti->cnt & 0xFF);
+	*cur_byte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
+	*cur_byte++ = ((strHostIfSetMulti->cnt >> 16) & 0xFF);
+	*cur_byte++ = ((strHostIfSetMulti->cnt >> 24) & 0xFF);
 
 	if ((strHostIfSetMulti->cnt) > 0)
-		memcpy(pu8CurrByte, wilc_multicast_mac_addr_list,
+		memcpy(cur_byte, wilc_multicast_mac_addr_list,
 		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-- 
2.7.4
