Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:15242 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933278AbeCHPw2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:28 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/10] staging: wilc1000: rename variables prefix using datatype 'u8'
Date: Wed, 7 Mar 2018 07:43:56 +0530
Message-ID: <1520388839-7048-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165231_158145_09D3943F)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename variables with datatype 'u8' in their name to follow the linux
coding style.

Renamed following variables:
u8abort_running_scan
pu8Buffer
pu8keybuf
pu8msa
u8remain_on_chan_flag

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |  28 +++---
 drivers/staging/wilc1000/host_interface.c   | 135 ++++++++++++++--------------
 2 files changed, 81 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 2e2187b..db66b1c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -148,19 +148,19 @@ static inline u8 get_from_ds(u8 *header)
 	return ((header[1] & 0x02) >> 1);
 }
 
-static inline void get_address1(u8 *pu8msa, u8 *addr)
+static inline void get_address1(u8 *msa, u8 *addr)
 {
-	memcpy(addr, pu8msa + 4, 6);
+	memcpy(addr, msa + 4, 6);
 }
 
-static inline void get_address2(u8 *pu8msa, u8 *addr)
+static inline void get_address2(u8 *msa, u8 *addr)
 {
-	memcpy(addr, pu8msa + 10, 6);
+	memcpy(addr, msa + 10, 6);
 }
 
-static inline void get_address3(u8 *pu8msa, u8 *addr)
+static inline void get_address3(u8 *msa, u8 *addr)
 {
-	memcpy(addr, pu8msa + 16, 6);
+	memcpy(addr, msa + 16, 6);
 }
 
 static inline void get_BSSID(u8 *data, u8 *bssid)
@@ -238,30 +238,30 @@ static inline u16 get_asoc_id(u8 *data)
 	return asoc_id;
 }
 
-static u8 *get_tim_elm(u8 *pu8msa, u16 rx_len, u16 tag_param_offset)
+static u8 *get_tim_elm(u8 *msa, u16 rx_len, u16 tag_param_offset)
 {
 	u16 index;
 
 	index = tag_param_offset;
 
 	while (index < (rx_len - FCS_LEN)) {
-		if (pu8msa[index] == ITIM)
-			return &pu8msa[index];
-		index += (IE_HDR_LEN + pu8msa[index + 1]);
+		if (msa[index] == ITIM)
+			return &msa[index];
+		index += (IE_HDR_LEN + msa[index + 1]);
 	}
 
 	return NULL;
 }
 
-static u8 get_current_channel_802_11n(u8 *pu8msa, u16 rx_len)
+static u8 get_current_channel_802_11n(u8 *msa, u16 rx_len)
 {
 	u16 index;
 
 	index = TAG_PARAM_OFFSET;
 	while (index < (rx_len - FCS_LEN)) {
-		if (pu8msa[index] == IDSPARMS)
-			return pu8msa[index + 2];
-		index += pu8msa[index + 1] + IE_HDR_LEN;
+		if (msa[index] == IDSPARMS)
+			return msa[index + 2];
+		index += msa[index + 1] + IE_HDR_LEN;
 	}
 
 	return 0;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4050128..5bf3bcc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -883,15 +883,15 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 {
 	s32 result = 0;
-	u8 u8abort_running_scan;
+	u8 abort_running_scan;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (evt == SCAN_EVENT_ABORTED) {
-		u8abort_running_scan = 1;
+		abort_running_scan = 1;
 		wid.id = (u16)WID_ABORT_RUNNING_SCAN;
 		wid.type = WID_CHAR;
-		wid.val = (s8 *)&u8abort_running_scan;
+		wid.val = (s8 *)&abort_running_scan;
 		wid.size = sizeof(char);
 
 		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
@@ -1552,7 +1552,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 	struct wid wid;
 	struct wid wid_list[5];
 	u8 i;
-	u8 *pu8keybuf;
+	u8 *key_buf;
 	s8 s8idxarray[1];
 	s8 ret = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1571,15 +1571,15 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 			wid_list[1].size = sizeof(char);
 			wid_list[1].val = (s8 *)&hif_key->attr.wep.auth_type;
 
-			pu8keybuf = kmalloc(hif_key->attr.wep.key_len + 2,
-					    GFP_KERNEL);
-			if (!pu8keybuf)
+			key_buf = kmalloc(hif_key->attr.wep.key_len + 2,
+					  GFP_KERNEL);
+			if (!key_buf)
 				return -ENOMEM;
 
-			pu8keybuf[0] = hif_key->attr.wep.index;
-			pu8keybuf[1] = hif_key->attr.wep.key_len;
+			key_buf[0] = hif_key->attr.wep.index;
+			key_buf[1] = hif_key->attr.wep.key_len;
 
-			memcpy(&pu8keybuf[2], hif_key->attr.wep.key,
+			memcpy(&key_buf[2], hif_key->attr.wep.key,
 			       hif_key->attr.wep.key_len);
 
 			kfree(hif_key->attr.wep.key);
@@ -1587,31 +1587,31 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 			wid_list[2].id = (u16)WID_WEP_KEY_VALUE;
 			wid_list[2].type = WID_STR;
 			wid_list[2].size = hif_key->attr.wep.key_len + 2;
-			wid_list[2].val = (s8 *)pu8keybuf;
+			wid_list[2].val = (s8 *)key_buf;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      wid_list, 3,
 						      wilc_get_vif_idx(vif));
-			kfree(pu8keybuf);
+			kfree(key_buf);
 		} else if (hif_key->action & ADDKEY) {
-			pu8keybuf = kmalloc(hif_key->attr.wep.key_len + 2, GFP_KERNEL);
-			if (!pu8keybuf)
+			key_buf = kmalloc(hif_key->attr.wep.key_len + 2, GFP_KERNEL);
+			if (!key_buf)
 				return -ENOMEM;
-			pu8keybuf[0] = hif_key->attr.wep.index;
-			memcpy(pu8keybuf + 1, &hif_key->attr.wep.key_len, 1);
-			memcpy(pu8keybuf + 2, hif_key->attr.wep.key,
+			key_buf[0] = hif_key->attr.wep.index;
+			memcpy(key_buf + 1, &hif_key->attr.wep.key_len, 1);
+			memcpy(key_buf + 2, hif_key->attr.wep.key,
 			       hif_key->attr.wep.key_len);
 			kfree(hif_key->attr.wep.key);
 
 			wid.id = (u16)WID_ADD_WEP_KEY;
 			wid.type = WID_STR;
-			wid.val = (s8 *)pu8keybuf;
+			wid.val = (s8 *)key_buf;
 			wid.size = hif_key->attr.wep.key_len + 2;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
-			kfree(pu8keybuf);
+			kfree(key_buf);
 		} else if (hif_key->action & REMOVEKEY) {
 			wid.id = (u16)WID_REMOVE_WEP_KEY;
 			wid.type = WID_STR;
@@ -1638,18 +1638,18 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 
 	case WPA_RX_GTK:
 		if (hif_key->action & ADDKEY_AP) {
-			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
-			if (!pu8keybuf) {
+			key_buf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
+			if (!key_buf) {
 				ret = -ENOMEM;
 				goto out_wpa_rx_gtk;
 			}
 
 			if (hif_key->attr.wpa.seq)
-				memcpy(pu8keybuf + 6, hif_key->attr.wpa.seq, 8);
+				memcpy(key_buf + 6, hif_key->attr.wpa.seq, 8);
 
-			memcpy(pu8keybuf + 14, &hif_key->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 15, &hif_key->attr.wpa.key_len, 1);
-			memcpy(pu8keybuf + 16, hif_key->attr.wpa.key,
+			memcpy(key_buf + 14, &hif_key->attr.wpa.index, 1);
+			memcpy(key_buf + 15, &hif_key->attr.wpa.key_len, 1);
+			memcpy(key_buf + 16, hif_key->attr.wpa.key,
 			       hif_key->attr.wpa.key_len);
 
 			wid_list[0].id = (u16)WID_11I_MODE;
@@ -1659,43 +1659,43 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 
 			wid_list[1].id = (u16)WID_ADD_RX_GTK;
 			wid_list[1].type = WID_STR;
-			wid_list[1].val = (s8 *)pu8keybuf;
+			wid_list[1].val = (s8 *)key_buf;
 			wid_list[1].size = RX_MIC_KEY_MSG_LEN;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      wid_list, 2,
 						      wilc_get_vif_idx(vif));
 
-			kfree(pu8keybuf);
+			kfree(key_buf);
 			complete(&hif_drv->comp_test_key_block);
 		} else if (hif_key->action & ADDKEY) {
-			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
-			if (!pu8keybuf) {
+			key_buf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
+			if (!key_buf) {
 				ret = -ENOMEM;
 				goto out_wpa_rx_gtk;
 			}
 
 			if (hif_drv->hif_state == HOST_IF_CONNECTED)
-				memcpy(pu8keybuf, hif_drv->assoc_bssid, ETH_ALEN);
+				memcpy(key_buf, hif_drv->assoc_bssid, ETH_ALEN);
 			else
 				netdev_err(vif->ndev, "Couldn't handle\n");
 
-			memcpy(pu8keybuf + 6, hif_key->attr.wpa.seq, 8);
-			memcpy(pu8keybuf + 14, &hif_key->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 15, &hif_key->attr.wpa.key_len, 1);
-			memcpy(pu8keybuf + 16, hif_key->attr.wpa.key,
+			memcpy(key_buf + 6, hif_key->attr.wpa.seq, 8);
+			memcpy(key_buf + 14, &hif_key->attr.wpa.index, 1);
+			memcpy(key_buf + 15, &hif_key->attr.wpa.key_len, 1);
+			memcpy(key_buf + 16, hif_key->attr.wpa.key,
 			       hif_key->attr.wpa.key_len);
 
 			wid.id = (u16)WID_ADD_RX_GTK;
 			wid.type = WID_STR;
-			wid.val = (s8 *)pu8keybuf;
+			wid.val = (s8 *)key_buf;
 			wid.size = RX_MIC_KEY_MSG_LEN;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 
-			kfree(pu8keybuf);
+			kfree(key_buf);
 			complete(&hif_drv->comp_test_key_block);
 		}
 out_wpa_rx_gtk:
@@ -1708,16 +1708,16 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 
 	case WPA_PTK:
 		if (hif_key->action & ADDKEY_AP) {
-			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
-			if (!pu8keybuf) {
+			key_buf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
+			if (!key_buf) {
 				ret = -ENOMEM;
 				goto out_wpa_ptk;
 			}
 
-			memcpy(pu8keybuf, hif_key->attr.wpa.mac_addr, 6);
-			memcpy(pu8keybuf + 6, &hif_key->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 7, &hif_key->attr.wpa.key_len, 1);
-			memcpy(pu8keybuf + 8, hif_key->attr.wpa.key,
+			memcpy(key_buf, hif_key->attr.wpa.mac_addr, 6);
+			memcpy(key_buf + 6, &hif_key->attr.wpa.index, 1);
+			memcpy(key_buf + 7, &hif_key->attr.wpa.key_len, 1);
+			memcpy(key_buf + 8, hif_key->attr.wpa.key,
 			       hif_key->attr.wpa.key_len);
 
 			wid_list[0].id = (u16)WID_11I_MODE;
@@ -1727,36 +1727,36 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 
 			wid_list[1].id = (u16)WID_ADD_PTK;
 			wid_list[1].type = WID_STR;
-			wid_list[1].val = (s8 *)pu8keybuf;
+			wid_list[1].val = (s8 *)key_buf;
 			wid_list[1].size = PTK_KEY_MSG_LEN + 1;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      wid_list, 2,
 						      wilc_get_vif_idx(vif));
-			kfree(pu8keybuf);
+			kfree(key_buf);
 			complete(&hif_drv->comp_test_key_block);
 		} else if (hif_key->action & ADDKEY) {
-			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
-			if (!pu8keybuf) {
+			key_buf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
+			if (!key_buf) {
 				netdev_err(vif->ndev, "No buffer send PTK\n");
 				ret = -ENOMEM;
 				goto out_wpa_ptk;
 			}
 
-			memcpy(pu8keybuf, hif_key->attr.wpa.mac_addr, 6);
-			memcpy(pu8keybuf + 6, &hif_key->attr.wpa.key_len, 1);
-			memcpy(pu8keybuf + 7, hif_key->attr.wpa.key,
+			memcpy(key_buf, hif_key->attr.wpa.mac_addr, 6);
+			memcpy(key_buf + 6, &hif_key->attr.wpa.key_len, 1);
+			memcpy(key_buf + 7, hif_key->attr.wpa.key,
 			       hif_key->attr.wpa.key_len);
 
 			wid.id = (u16)WID_ADD_PTK;
 			wid.type = WID_STR;
-			wid.val = (s8 *)pu8keybuf;
+			wid.val = (s8 *)key_buf;
 			wid.size = PTK_KEY_MSG_LEN;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
-			kfree(pu8keybuf);
+			kfree(key_buf);
 			complete(&hif_drv->comp_test_key_block);
 		}
 
@@ -1768,26 +1768,26 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 		break;
 
 	case PMKSA:
-		pu8keybuf = kmalloc((hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
-		if (!pu8keybuf)
+		key_buf = kmalloc((hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
+		if (!key_buf)
 			return -ENOMEM;
 
-		pu8keybuf[0] = hif_key->attr.pmkid.numpmkid;
+		key_buf[0] = hif_key->attr.pmkid.numpmkid;
 
 		for (i = 0; i < hif_key->attr.pmkid.numpmkid; i++) {
-			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
-			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), hif_key->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
+			memcpy(key_buf + ((PMKSA_KEY_LEN * i) + 1), hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
+			memcpy(key_buf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), hif_key->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
 		}
 
 		wid.id = (u16)WID_PMKID_INFO;
 		wid.type = WID_STR;
-		wid.val = (s8 *)pu8keybuf;
+		wid.val = (s8 *)key_buf;
 		wid.size = (hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
 
-		kfree(pu8keybuf);
+		kfree(key_buf);
 		break;
 	}
 
@@ -2081,12 +2081,11 @@ static void handle_del_beacon(struct wilc_vif *vif)
 		netdev_err(vif->ndev, "Failed to send delete beacon\n");
 }
 
-static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
-				    struct add_sta_param *param)
+static u32 WILC_HostIf_PackStaParam(u8 *buff, struct add_sta_param *param)
 {
 	u8 *cur_byte;
 
-	cur_byte = pu8Buffer;
+	cur_byte = buff;
 
 	memcpy(cur_byte, param->bssid, ETH_ALEN);
 	cur_byte +=  ETH_ALEN;
@@ -2109,7 +2108,7 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	*cur_byte++ = param->flags_set & 0xFF;
 	*cur_byte++ = (param->flags_set >> 8) & 0xFF;
 
-	return cur_byte - pu8Buffer;
+	return cur_byte - buff;
 }
 
 static void handle_add_station(struct wilc_vif *vif,
@@ -2240,7 +2239,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 				 struct remain_ch *hif_remain_ch)
 {
 	s32 result = 0;
-	u8 u8remain_on_chan_flag;
+	u8 remain_on_chan_flag;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -2269,7 +2268,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 		goto error;
 	}
 
-	u8remain_on_chan_flag = true;
+	remain_on_chan_flag = true;
 	wid.id = (u16)WID_REMAIN_ON_CHAN;
 	wid.type = WID_STR;
 	wid.size = 2;
@@ -2279,7 +2278,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 		goto error;
 	}
 
-	wid.val[0] = u8remain_on_chan_flag;
+	wid.val[0] = remain_on_chan_flag;
 	wid.val[1] = (s8)hif_remain_ch->ch;
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
@@ -2339,13 +2338,13 @@ static int handle_register_frame(struct wilc_vif *vif,
 static u32 handle_listen_state_expired(struct wilc_vif *vif,
 				       struct remain_ch *hif_remain_ch)
 {
-	u8 u8remain_on_chan_flag;
+	u8 remain_on_chan_flag;
 	struct wid wid;
 	s32 result = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (P2P_LISTEN_STATE) {
-		u8remain_on_chan_flag = false;
+		remain_on_chan_flag = false;
 		wid.id = (u16)WID_REMAIN_ON_CHAN;
 		wid.type = WID_STR;
 		wid.size = 2;
@@ -2354,7 +2353,7 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 		if (!wid.val)
 			return -ENOMEM;
 
-		wid.val[0] = u8remain_on_chan_flag;
+		wid.val[0] = remain_on_chan_flag;
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
 		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-- 
2.7.4
