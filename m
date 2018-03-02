Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:10316 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425508AbeCBOXo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:44 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/13] staging: wilc1000: rename pstrHostIFkeyAttr to avoid camelCase issue
Date: Fri, 2 Mar 2018 19:52:43 +0530
Message-ID: <1520000569-27738-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152347_959624_A1EA55F4)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 119 +++++++++++++++---------------
 1 file changed, 59 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a7fa004..5ebb0aa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1538,8 +1538,7 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 	return result;
 }
 
-static int handle_key(struct wilc_vif *vif,
-		      struct key_attr *pstrHostIFkeyAttr)
+static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -1550,76 +1549,76 @@ static int handle_key(struct wilc_vif *vif,
 	s8 ret = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	switch (pstrHostIFkeyAttr->type) {
+	switch (hif_key->type) {
 	case WEP:
 
-		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
+		if (hif_key->action & ADDKEY_AP) {
 			wid_list[0].id = (u16)WID_11I_MODE;
 			wid_list[0].type = WID_CHAR;
 			wid_list[0].size = sizeof(char);
-			wid_list[0].val = (s8 *)&pstrHostIFkeyAttr->attr.wep.mode;
+			wid_list[0].val = (s8 *)&hif_key->attr.wep.mode;
 
 			wid_list[1].id = WID_AUTH_TYPE;
 			wid_list[1].type = WID_CHAR;
 			wid_list[1].size = sizeof(char);
-			wid_list[1].val = (s8 *)&pstrHostIFkeyAttr->attr.wep.auth_type;
+			wid_list[1].val = (s8 *)&hif_key->attr.wep.auth_type;
 
-			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2,
+			pu8keybuf = kmalloc(hif_key->attr.wep.key_len + 2,
 					    GFP_KERNEL);
 			if (!pu8keybuf)
 				return -ENOMEM;
 
-			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
-			pu8keybuf[1] = pstrHostIFkeyAttr->attr.wep.key_len;
+			pu8keybuf[0] = hif_key->attr.wep.index;
+			pu8keybuf[1] = hif_key->attr.wep.key_len;
 
-			memcpy(&pu8keybuf[2], pstrHostIFkeyAttr->attr.wep.key,
-			       pstrHostIFkeyAttr->attr.wep.key_len);
+			memcpy(&pu8keybuf[2], hif_key->attr.wep.key,
+			       hif_key->attr.wep.key_len);
 
-			kfree(pstrHostIFkeyAttr->attr.wep.key);
+			kfree(hif_key->attr.wep.key);
 
 			wid_list[2].id = (u16)WID_WEP_KEY_VALUE;
 			wid_list[2].type = WID_STR;
-			wid_list[2].size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
+			wid_list[2].size = hif_key->attr.wep.key_len + 2;
 			wid_list[2].val = (s8 *)pu8keybuf;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      wid_list, 3,
 						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
-		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
-			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2, GFP_KERNEL);
+		} else if (hif_key->action & ADDKEY) {
+			pu8keybuf = kmalloc(hif_key->attr.wep.key_len + 2, GFP_KERNEL);
 			if (!pu8keybuf)
 				return -ENOMEM;
-			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
-			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->attr.wep.key_len, 1);
-			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->attr.wep.key,
-			       pstrHostIFkeyAttr->attr.wep.key_len);
-			kfree(pstrHostIFkeyAttr->attr.wep.key);
+			pu8keybuf[0] = hif_key->attr.wep.index;
+			memcpy(pu8keybuf + 1, &hif_key->attr.wep.key_len, 1);
+			memcpy(pu8keybuf + 2, hif_key->attr.wep.key,
+			       hif_key->attr.wep.key_len);
+			kfree(hif_key->attr.wep.key);
 
 			wid.id = (u16)WID_ADD_WEP_KEY;
 			wid.type = WID_STR;
 			wid.val = (s8 *)pu8keybuf;
-			wid.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
+			wid.size = hif_key->attr.wep.key_len + 2;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
-		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
+		} else if (hif_key->action & REMOVEKEY) {
 			wid.id = (u16)WID_REMOVE_WEP_KEY;
 			wid.type = WID_STR;
 
-			s8idxarray[0] = (s8)pstrHostIFkeyAttr->attr.wep.index;
+			s8idxarray[0] = (s8)hif_key->attr.wep.index;
 			wid.val = s8idxarray;
 			wid.size = 1;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
-		} else if (pstrHostIFkeyAttr->action & DEFAULTKEY) {
+		} else if (hif_key->action & DEFAULTKEY) {
 			wid.id = (u16)WID_KEY_ID;
 			wid.type = WID_CHAR;
-			wid.val = (s8 *)&pstrHostIFkeyAttr->attr.wep.index;
+			wid.val = (s8 *)&hif_key->attr.wep.index;
 			wid.size = sizeof(char);
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
@@ -1630,25 +1629,25 @@ static int handle_key(struct wilc_vif *vif,
 		break;
 
 	case WPA_RX_GTK:
-		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
+		if (hif_key->action & ADDKEY_AP) {
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				ret = -ENOMEM;
 				goto out_wpa_rx_gtk;
 			}
 
-			if (pstrHostIFkeyAttr->attr.wpa.seq)
-				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
+			if (hif_key->attr.wpa.seq)
+				memcpy(pu8keybuf + 6, hif_key->attr.wpa.seq, 8);
 
-			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
-			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
-			       pstrHostIFkeyAttr->attr.wpa.key_len);
+			memcpy(pu8keybuf + 14, &hif_key->attr.wpa.index, 1);
+			memcpy(pu8keybuf + 15, &hif_key->attr.wpa.key_len, 1);
+			memcpy(pu8keybuf + 16, hif_key->attr.wpa.key,
+			       hif_key->attr.wpa.key_len);
 
 			wid_list[0].id = (u16)WID_11I_MODE;
 			wid_list[0].type = WID_CHAR;
 			wid_list[0].size = sizeof(char);
-			wid_list[0].val = (s8 *)&pstrHostIFkeyAttr->attr.wpa.mode;
+			wid_list[0].val = (s8 *)&hif_key->attr.wpa.mode;
 
 			wid_list[1].id = (u16)WID_ADD_RX_GTK;
 			wid_list[1].type = WID_STR;
@@ -1661,7 +1660,7 @@ static int handle_key(struct wilc_vif *vif,
 
 			kfree(pu8keybuf);
 			complete(&hif_drv->comp_test_key_block);
-		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
+		} else if (hif_key->action & ADDKEY) {
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				ret = -ENOMEM;
@@ -1673,11 +1672,11 @@ static int handle_key(struct wilc_vif *vif,
 			else
 				netdev_err(vif->ndev, "Couldn't handle\n");
 
-			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
-			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
-			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
-			       pstrHostIFkeyAttr->attr.wpa.key_len);
+			memcpy(pu8keybuf + 6, hif_key->attr.wpa.seq, 8);
+			memcpy(pu8keybuf + 14, &hif_key->attr.wpa.index, 1);
+			memcpy(pu8keybuf + 15, &hif_key->attr.wpa.key_len, 1);
+			memcpy(pu8keybuf + 16, hif_key->attr.wpa.key,
+			       hif_key->attr.wpa.key_len);
 
 			wid.id = (u16)WID_ADD_RX_GTK;
 			wid.type = WID_STR;
@@ -1692,31 +1691,31 @@ static int handle_key(struct wilc_vif *vif,
 			complete(&hif_drv->comp_test_key_block);
 		}
 out_wpa_rx_gtk:
-		kfree(pstrHostIFkeyAttr->attr.wpa.key);
-		kfree(pstrHostIFkeyAttr->attr.wpa.seq);
+		kfree(hif_key->attr.wpa.key);
+		kfree(hif_key->attr.wpa.seq);
 		if (ret)
 			return ret;
 
 		break;
 
 	case WPA_PTK:
-		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
+		if (hif_key->action & ADDKEY_AP) {
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!pu8keybuf) {
 				ret = -ENOMEM;
 				goto out_wpa_ptk;
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
-			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
-			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->attr.wpa.key,
-			       pstrHostIFkeyAttr->attr.wpa.key_len);
+			memcpy(pu8keybuf, hif_key->attr.wpa.mac_addr, 6);
+			memcpy(pu8keybuf + 6, &hif_key->attr.wpa.index, 1);
+			memcpy(pu8keybuf + 7, &hif_key->attr.wpa.key_len, 1);
+			memcpy(pu8keybuf + 8, hif_key->attr.wpa.key,
+			       hif_key->attr.wpa.key_len);
 
 			wid_list[0].id = (u16)WID_11I_MODE;
 			wid_list[0].type = WID_CHAR;
 			wid_list[0].size = sizeof(char);
-			wid_list[0].val = (s8 *)&pstrHostIFkeyAttr->attr.wpa.mode;
+			wid_list[0].val = (s8 *)&hif_key->attr.wpa.mode;
 
 			wid_list[1].id = (u16)WID_ADD_PTK;
 			wid_list[1].type = WID_STR;
@@ -1728,7 +1727,7 @@ static int handle_key(struct wilc_vif *vif,
 						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 			complete(&hif_drv->comp_test_key_block);
-		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
+		} else if (hif_key->action & ADDKEY) {
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				netdev_err(vif->ndev, "No buffer send PTK\n");
@@ -1736,10 +1735,10 @@ static int handle_key(struct wilc_vif *vif,
 				goto out_wpa_ptk;
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
-			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
-			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->attr.wpa.key,
-			       pstrHostIFkeyAttr->attr.wpa.key_len);
+			memcpy(pu8keybuf, hif_key->attr.wpa.mac_addr, 6);
+			memcpy(pu8keybuf + 6, &hif_key->attr.wpa.key_len, 1);
+			memcpy(pu8keybuf + 7, hif_key->attr.wpa.key,
+			       hif_key->attr.wpa.key_len);
 
 			wid.id = (u16)WID_ADD_PTK;
 			wid.type = WID_STR;
@@ -1754,28 +1753,28 @@ static int handle_key(struct wilc_vif *vif,
 		}
 
 out_wpa_ptk:
-		kfree(pstrHostIFkeyAttr->attr.wpa.key);
+		kfree(hif_key->attr.wpa.key);
 		if (ret)
 			return ret;
 
 		break;
 
 	case PMKSA:
-		pu8keybuf = kmalloc((pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
+		pu8keybuf = kmalloc((hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
 		if (!pu8keybuf)
 			return -ENOMEM;
 
-		pu8keybuf[0] = pstrHostIFkeyAttr->attr.pmkid.numpmkid;
+		pu8keybuf[0] = hif_key->attr.pmkid.numpmkid;
 
-		for (i = 0; i < pstrHostIFkeyAttr->attr.pmkid.numpmkid; i++) {
-			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), pstrHostIFkeyAttr->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
-			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
+		for (i = 0; i < hif_key->attr.pmkid.numpmkid; i++) {
+			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
+			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), hif_key->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
 		}
 
 		wid.id = (u16)WID_PMKID_INFO;
 		wid.type = WID_STR;
 		wid.val = (s8 *)pu8keybuf;
-		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
+		wid.size = (hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
-- 
2.7.4
