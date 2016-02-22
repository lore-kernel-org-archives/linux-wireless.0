Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29885 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbcBVERd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:17:33 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V3 17/24] staging: wilc1000: host_interface.c: replace PRINT_ER with netdev_err
Date: Mon, 22 Feb 2016 13:12:02 +0900
Message-ID: <1456114329-7036-18-git-send-email-leo.kim@atmel.com> (sfid-20160222_051737_524331_A69677EE)
In-Reply-To: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
References: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch replaces PRINT_ER with netdev_err.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 284 +++++++++++++++---------------
 1 file changed, 142 insertions(+), 142 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a827e06..0c09df4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -335,7 +335,7 @@ static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
 		up(&hif_sema_driver);
 
 	if (result) {
-		PRINT_ER("Failed to set driver handler\n");
+		netdev_err(vif->ndev, "Failed to set driver handler\n");
 		return -EINVAL;
 	}
 
@@ -360,7 +360,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 		up(&hif_sema_driver);
 
 	if (result) {
-		PRINT_ER("Failed to set driver handler\n");
+		netdev_err(vif->ndev, "Failed to set driver handler\n");
 		return -EINVAL;
 	}
 
@@ -389,7 +389,7 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	host_int_get_ipaddress(vif, firmware_ip_addr, idx);
 
 	if (result) {
-		PRINT_ER("Failed to set IP address\n");
+		netdev_err(vif->ndev, "Failed to set IP address\n");
 		return -EINVAL;
 	}
 
@@ -417,7 +417,7 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 		wilc_setup_ipaddress(vif, set_ip[idx], idx);
 
 	if (result != 0) {
-		PRINT_ER("Failed to get IP address\n");
+		netdev_err(vif->ndev, "Failed to get IP address\n");
 		return -EINVAL;
 	}
 
@@ -462,7 +462,7 @@ static s32 handle_get_mac_address(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
-		PRINT_ER("Failed to get mac address\n");
+		netdev_err(vif->ndev, "Failed to get mac address\n");
 		result = -EFAULT;
 	}
 	up(&hif_sema_wait_response);
@@ -488,7 +488,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->cfg_attr_info.bss_type;
 		} else {
-			PRINT_ER("check value 6 over\n");
+			netdev_err(vif->ndev, "check value 6 over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -504,7 +504,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->cfg_attr_info.auth_type;
 		} else {
-			PRINT_ER("Impossible value \n");
+			netdev_err(vif->ndev, "Impossible value \n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -519,7 +519,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.auth_timeout = cfg_param_attr->cfg_attr_info.auth_timeout;
 		} else {
-			PRINT_ER("Range(1 ~ 65535) over\n");
+			netdev_err(vif->ndev, "Range(1 ~ 65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -533,7 +533,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->cfg_attr_info.power_mgmt_mode;
 		} else {
-			PRINT_ER("Invalid power mode\n");
+			netdev_err(vif->ndev, "Invalid power mode\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -548,7 +548,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->cfg_attr_info.short_retry_limit;
 		} else {
-			PRINT_ER("Range(1~256) over\n");
+			netdev_err(vif->ndev, "Range(1~256) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -563,7 +563,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->cfg_attr_info.long_retry_limit;
 		} else {
-			PRINT_ER("Range(1~256) over\n");
+			netdev_err(vif->ndev, "Range(1~256) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -578,7 +578,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.frag_threshold = cfg_param_attr->cfg_attr_info.frag_threshold;
 		} else {
-			PRINT_ER("Threshold Range fail\n");
+			netdev_err(vif->ndev, "Threshold Range fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -593,7 +593,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.rts_threshold = cfg_param_attr->cfg_attr_info.rts_threshold;
 		} else {
-			PRINT_ER("Threshold Range fail\n");
+			netdev_err(vif->ndev, "Threshold Range fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -607,7 +607,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.preamble_type = cfg_param_attr->cfg_attr_info.preamble_type;
 		} else {
-			PRINT_ER("Preamle Range(0~2) over\n");
+			netdev_err(vif->ndev, "Preamle Range(0~2) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -621,7 +621,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->cfg_attr_info.short_slot_allowed;
 		} else {
-			PRINT_ER("Short slot(2) over\n");
+			netdev_err(vif->ndev, "Short slot(2) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -635,7 +635,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->cfg_attr_info.txop_prot_disabled;
 		} else {
-			PRINT_ER("TXOP prot disable\n");
+			netdev_err(vif->ndev, "TXOP prot disable\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -650,7 +650,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.beacon_interval = cfg_param_attr->cfg_attr_info.beacon_interval;
 		} else {
-			PRINT_ER("Beacon interval(1~65535) fail\n");
+			netdev_err(vif->ndev, "Beacon interval(1~65535)fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -665,7 +665,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.dtim_period = cfg_param_attr->cfg_attr_info.dtim_period;
 		} else {
-			PRINT_ER("DTIM range(1~255) fail\n");
+			netdev_err(vif->ndev, "DTIM range(1~255) fail\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -679,7 +679,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(char);
 			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->cfg_attr_info.site_survey_enabled;
 		} else {
-			PRINT_ER("Site survey disable\n");
+			netdev_err(vif->ndev, "Site survey disable\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -694,7 +694,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->cfg_attr_info.site_survey_scan_time;
 		} else {
-			PRINT_ER("Site survey scan time(1~65535) over\n");
+			netdev_err(vif->ndev, "Site scan time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -709,7 +709,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.active_scan_time = cfg_param_attr->cfg_attr_info.active_scan_time;
 		} else {
-			PRINT_ER("Active scan time(1~65535) over\n");
+			netdev_err(vif->ndev, "Active time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -724,7 +724,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->cfg_attr_info.passive_scan_time;
 		} else {
-			PRINT_ER("Passive scan time(1~65535) over\n");
+			netdev_err(vif->ndev, "Passive time(1~65535) over\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -745,7 +745,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			wid_list[wid_cnt].size = sizeof(u16);
 			hif_drv->cfg_values.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
-			PRINT_ER("out of TX rate\n");
+			netdev_err(vif->ndev, "out of TX rate\n");
 			result = -EINVAL;
 			goto ERRORHANDLER;
 		}
@@ -756,7 +756,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 				      wid_cnt, wilc_get_vif_idx(vif));
 
 	if (result)
-		PRINT_ER("Error in setting CFG params\n");
+		netdev_err(vif->ndev, "Error in setting CFG params\n");
 
 ERRORHANDLER:
 	up(&hif_drv->sem_cfg_values);
@@ -789,13 +789,13 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 
 	if ((hif_drv->hif_state >= HOST_IF_SCANNING) &&
 	    (hif_drv->hif_state < HOST_IF_CONNECTED)) {
-		PRINT_ER("Already scan\n");
+		netdev_err(vif->ndev, "Already scan\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
 	if (wilc_optaining_ip || wilc_connecting) {
-		PRINT_ER("Don't do obss scan\n");
+		netdev_err(vif->ndev, "Don't do obss scan\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
@@ -871,7 +871,7 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 
 	if (result)
-		PRINT_ER("Failed to send scan parameters config packet\n");
+		netdev_err(vif->ndev, "Failed to send scan parameters\n");
 
 ERRORHANDLER:
 	if (result) {
@@ -911,13 +911,13 @@ static s32 Handle_ScanDone(struct wilc_vif *vif,
 					      wilc_get_vif_idx(vif));
 
 		if (result) {
-			PRINT_ER("Failed to set abort running scan\n");
+			netdev_err(vif->ndev, "Failed to set abort running\n");
 			result = -EFAULT;
 		}
 	}
 
 	if (!hif_drv) {
-		PRINT_ER("Driver handler is NULL\n");
+		netdev_err(vif->ndev, "Driver handler is NULL\n");
 		return result;
 	}
 
@@ -943,13 +943,13 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 	if (memcmp(pstrHostIFconnectAttr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
 		result = 0;
-		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
+		netdev_err(vif->ndev, "Discard connect request\n");
 		return result;
 	}
 
 	ptstrJoinBssParam = pstrHostIFconnectAttr->params;
 	if (!ptstrJoinBssParam) {
-		PRINT_ER("Required BSSID not found\n");
+		netdev_err(vif->ndev, "Required BSSID not found\n");
 		result = -ENOENT;
 		goto ERRORHANDLER;
 	}
@@ -1057,7 +1057,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	if ((pstrHostIFconnectAttr->ch >= 1) && (pstrHostIFconnectAttr->ch <= 14)) {
 		*(pu8CurrByte++) = pstrHostIFconnectAttr->ch;
 	} else {
-		PRINT_ER("Channel out of range\n");
+		netdev_err(vif->ndev, "Channel out of range\n");
 		*(pu8CurrByte++) = 0xFF;
 	}
 	*(pu8CurrByte++)  = (ptstrJoinBssParam->cap_info) & 0xFF;
@@ -1140,7 +1140,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 				      u32WidsCount,
 				      wilc_get_vif_idx(vif));
 	if (result) {
-		PRINT_ER("failed to send config packet\n");
+		netdev_err(vif->ndev, "failed to send config packet\n");
 		result = -EFAULT;
 		goto ERRORHANDLER;
 	} else {
@@ -1177,7 +1177,7 @@ ERRORHANDLER:
 			strConnectInfo.pu8ReqIEs = NULL;
 
 		} else {
-			PRINT_ER("Connect callback function pointer is NULL\n");
+			netdev_err(vif->ndev, "Connect callback is NULL\n");
 		}
 	}
 
@@ -1234,7 +1234,7 @@ static s32 Handle_FlushConnect(struct wilc_vif *vif)
 				      u32WidsCount,
 				      wilc_get_vif_idx(join_req_vif));
 	if (result) {
-		PRINT_ER("failed to send config packet\n");
+		netdev_err(vif->ndev, "failed to send config packet\n");
 		result = -EINVAL;
 	}
 
@@ -1250,7 +1250,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("Driver handler is NULL\n");
+		netdev_err(vif->ndev, "Driver handler is NULL\n");
 		return result;
 	}
 
@@ -1283,7 +1283,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 		kfree(strConnectInfo.pu8ReqIEs);
 		strConnectInfo.pu8ReqIEs = NULL;
 	} else {
-		PRINT_ER("Connect callback function pointer is NULL\n");
+		netdev_err(vif->ndev, "Connect callback is NULL\n");
 	}
 
 	wid.id = (u16)WID_DISCONNECT;
@@ -1294,7 +1294,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		PRINT_ER("Failed to send dissconect config packet\n");
+		netdev_err(vif->ndev, "Failed to send dissconect\n");
 
 	hif_drv->usr_conn_req.ssid_len = 0;
 	kfree(hif_drv->usr_conn_req.ssid);
@@ -1336,7 +1336,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 		wilc_parse_network_info(pstrRcvdNetworkInfo->buffer, &pstrNetworkInfo);
 		if ((!pstrNetworkInfo) ||
 		    (!hif_drv->usr_scan_req.scan_result)) {
-			PRINT_ER("driver is null\n");
+			netdev_err(vif->ndev, "driver is null\n");
 			result = -EINVAL;
 			goto done;
 		}
@@ -1418,7 +1418,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("Driver handler is NULL\n");
+		netdev_err(vif->ndev, "Driver handler is NULL\n");
 		return -ENODEV;
 	}
 
@@ -1427,14 +1427,14 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	    hif_drv->usr_scan_req.scan_result) {
 		if (!pstrRcvdGnrlAsyncInfo->buffer ||
 		    !hif_drv->usr_conn_req.conn_result) {
-			PRINT_ER("driver is null\n");
+			netdev_err(vif->ndev, "driver is null\n");
 			return -EINVAL;
 		}
 
 		u8MsgType = pstrRcvdGnrlAsyncInfo->buffer[0];
 
 		if ('I' != u8MsgType) {
-			PRINT_ER("Received Message format incorrect.\n");
+			netdev_err(vif->ndev, "Received Message incorrect.\n");
 			return -EFAULT;
 		}
 
@@ -1463,7 +1463,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 					s32Err = wilc_parse_assoc_resp_info(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
 								    &pstrConnectRespInfo);
 					if (s32Err) {
-						PRINT_ER("wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
+						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
 						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->status;
 
@@ -1486,10 +1486,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus != SUCCESSFUL_STATUSCODE))	{
-				PRINT_ER("Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
+				netdev_err(vif->ndev, "Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
 				eth_zero_addr(wilc_connected_ssid);
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
-				PRINT_ER("Received MAC status is MAC_DISCONNECTED\n");
+				netdev_err(vif->ndev, "Received MAC status is MAC_DISCONNECTED\n");
 				eth_zero_addr(wilc_connected_ssid);
 			}
 
@@ -1568,7 +1568,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 								  &strDisconnectNotifInfo,
 								  hif_drv->usr_conn_req.arg);
 			} else {
-				PRINT_ER("Connect result callback function is NULL\n");
+				netdev_err(vif->ndev, "Connect result NULL\n");
 			}
 
 			eth_zero_addr(hif_drv->assoc_bssid);
@@ -1742,7 +1742,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			if (hif_drv->hif_state == HOST_IF_CONNECTED)
 				memcpy(pu8keybuf, hif_drv->assoc_bssid, ETH_ALEN);
 			else
-				PRINT_ER("Couldn't handle WPARxGtk while state is not HOST_IF_CONNECTED\n");
+				netdev_err(vif->ndev, "Couldn't handle\n");
 
 			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
@@ -1802,7 +1802,7 @@ _WPARxGtk_end_case_:
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
-				PRINT_ER("No buffer to send PTK Key\n");
+				netdev_err(vif->ndev, "No buffer send PTK\n");
 				ret = -ENOMEM;
 				goto _WPAPtk_end_case_;
 			}
@@ -1834,7 +1834,7 @@ _WPAPtk_end_case_:
 	case PMKSA:
 		pu8keybuf = kmalloc((pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
 		if (!pu8keybuf) {
-			PRINT_ER("No buffer to send PMKSA Key\n");
+			netdev_err(vif->ndev, "No buffer to send PMKSA Key\n");
 			return -ENOMEM;
 		}
 
@@ -1858,7 +1858,7 @@ _WPAPtk_end_case_:
 	}
 
 	if (result)
-		PRINT_ER("Failed to send key config packet\n");
+		netdev_err(vif->ndev, "Failed to send key config packet\n");
 
 	return result;
 }
@@ -1885,7 +1885,7 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
-		PRINT_ER("Failed to send dissconect config packet\n");
+		netdev_err(vif->ndev, "Failed to send dissconect\n");
 	} else {
 		tstrDisconnectNotifInfo strDisconnectNotifInfo;
 
@@ -1914,7 +1914,7 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 							  &strDisconnectNotifInfo,
 							  hif_drv->usr_conn_req.arg);
 		} else {
-			PRINT_ER("usr_conn_req.conn_result = NULL\n");
+			netdev_err(vif->ndev, "conn_result = NULL\n");
 		}
 
 		scan_while_connected = false;
@@ -1969,7 +1969,7 @@ static s32 Handle_GetChnl(struct wilc_vif *vif)
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
-		PRINT_ER("Failed to get channel number\n");
+		netdev_err(vif->ndev, "Failed to get channel number\n");
 		result = -EFAULT;
 	}
 
@@ -1989,7 +1989,7 @@ static void Handle_GetRssi(struct wilc_vif *vif)
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
-		PRINT_ER("Failed to get RSSI value\n");
+		netdev_err(vif->ndev, "Failed to get RSSI value\n");
 		result = -EFAULT;
 	}
 
@@ -2011,7 +2011,7 @@ static void Handle_GetLinkspeed(struct wilc_vif *vif)
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
-		PRINT_ER("Failed to get LINKSPEED value\n");
+		netdev_err(vif->ndev, "Failed to get LINKSPEED value\n");
 		result = -EFAULT;
 	}
 
@@ -2058,7 +2058,7 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 
 	if (result)
-		PRINT_ER("Failed to send scan parameters config packet\n");
+		netdev_err(vif->ndev, "Failed to send scan parameters\n");
 
 	if (pstrStatistics->link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH &&
 	    pstrStatistics->link_speed != DEFAULT_LINK_SPEED)
@@ -2091,7 +2091,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
-		PRINT_ER("Failed to SET incative time\n");
+		netdev_err(vif->ndev, "Failed to SET incative time\n");
 		return -EFAULT;
 	}
 
@@ -2104,7 +2104,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
-		PRINT_ER("Failed to get incative time\n");
+		netdev_err(vif->ndev, "Failed to get incative time\n");
 		return -EFAULT;
 	}
 
@@ -2158,7 +2158,7 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		PRINT_ER("Failed to send add beacon config packet\n");
+		netdev_err(vif->ndev, "Failed to send add beacon\n");
 
 ERRORHANDLER:
 	kfree(wid.val);
@@ -2185,7 +2185,7 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		PRINT_ER("Failed to send delete beacon config packet\n");
+		netdev_err(vif->ndev, "Failed to send delete beacon\n");
 }
 
 static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
@@ -2256,7 +2256,7 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result != 0)
-		PRINT_ER("Failed to send add station config packet\n");
+		netdev_err(vif->ndev, "Failed to send add station\n");
 
 ERRORHANDLER:
 	kfree(pstrStationParam->rates);
@@ -2296,7 +2296,7 @@ static void Handle_DelAllSta(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		PRINT_ER("Failed to send add station config packet\n");
+		netdev_err(vif->ndev, "Failed to send add station\n");
 
 ERRORHANDLER:
 	kfree(wid.val);
@@ -2326,7 +2326,7 @@ static void Handle_DelStation(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		PRINT_ER("Failed to send add station config packet\n");
+		netdev_err(vif->ndev, "Failed to send add station\n");
 
 ERRORHANDLER:
 	kfree(wid.val);
@@ -2353,7 +2353,7 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		PRINT_ER("Failed to send edit station config packet\n");
+		netdev_err(vif->ndev, "Failed to send edit station\n");
 
 ERRORHANDLER:
 	kfree(pstrStationParam->rates);
@@ -2409,7 +2409,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result != 0)
-		PRINT_ER("Failed to set remain on channel\n");
+		netdev_err(vif->ndev, "Failed to set remain on channel\n");
 
 ERRORHANDLER:
 	{
@@ -2453,7 +2453,7 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
-		PRINT_ER("Failed to frame register config packet\n");
+		netdev_err(vif->ndev, "Failed to frame register\n");
 		result = -EINVAL;
 	}
 
@@ -2476,7 +2476,7 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 		wid.val = kmalloc(wid.size, GFP_KERNEL);
 
 		if (!wid.val) {
-			PRINT_ER("Failed to allocate memory\n");
+			netdev_err(vif->ndev, "Failed to allocate memory\n");
 			return -ENOMEM;
 		}
 
@@ -2486,7 +2486,7 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
 		if (result != 0) {
-			PRINT_ER("Failed to set remain on channel\n");
+			netdev_err(vif->ndev, "Failed to set remain channel\n");
 			goto _done_;
 		}
 
@@ -2519,7 +2519,7 @@ static void ListenTimerCB(unsigned long arg)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 }
 
 static void Handle_PowerManagement(struct wilc_vif *vif,
@@ -2542,7 +2542,7 @@ static void Handle_PowerManagement(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		PRINT_ER("Failed to send power management config packet\n");
+		netdev_err(vif->ndev, "Failed to send power management\n");
 }
 
 static void Handle_SetMulticastFilter(struct wilc_vif *vif,
@@ -2577,7 +2577,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		PRINT_ER("Failed to send setup multicast config packet\n");
+		netdev_err(vif->ndev, "Failed to send setup multicast\n");
 
 ERRORHANDLER:
 	kfree(wid.val);
@@ -2847,7 +2847,7 @@ static int hostIFthread(void *pvArg)
 			handle_get_tx_pwr(msg.vif, &msg.body.tx_power.tx_pwr);
 			break;
 		default:
-			PRINT_ER("[Host Interface] undefined Received Msg ID\n");
+			netdev_err(vif->ndev, "[Host Interface] undefined\n");
 			break;
 		}
 	}
@@ -2900,7 +2900,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 
 	if (!hif_drv) {
 		result = -EFAULT;
-		PRINT_ER("Failed to send setup multicast config packet\n");
+		netdev_err(vif->ndev, "Failed to send setup multicast\n");
 		return result;
 	}
 
@@ -2914,7 +2914,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
+		netdev_err(vif->ndev, "Request to remove WEP key\n");
 	down(&hif_drv->sem_test_key_block);
 
 	return result;
@@ -2928,7 +2928,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 
 	if (!hif_drv) {
 		result = -EFAULT;
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return result;
 	}
 
@@ -2942,7 +2942,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("Error in sending message queue : Default key index\n");
+		netdev_err(vif->ndev, "Default key index\n");
 	down(&hif_drv->sem_test_key_block);
 
 	return result;
@@ -2956,7 +2956,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -2975,7 +2975,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("Error in sending message queue :WEP Key\n");
+		netdev_err(vif->ndev, "STA - WEP Key\n");
 	down(&hif_drv->sem_test_key_block);
 
 	return result;
@@ -2989,7 +2989,7 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3011,7 +3011,7 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	if (result)
-		PRINT_ER("Error in sending message queue :WEP Key\n");
+		netdev_err(vif->ndev, "AP - WEP Key\n");
 	down(&hif_drv->sem_test_key_block);
 
 	return result;
@@ -3027,7 +3027,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	u8 key_len = ptk_key_len;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3066,7 +3066,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	if (result)
-		PRINT_ER("Error in sending message queue:  PTK Key\n");
+		netdev_err(vif->ndev, "PTK Key\n");
 
 	down(&hif_drv->sem_test_key_block);
 
@@ -3084,7 +3084,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	u8 key_len = gtk_key_len;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -3134,7 +3134,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("Error in sending message queue:  RX GTK\n");
+		netdev_err(vif->ndev, "RX GTK\n");
 
 	down(&hif_drv->sem_test_key_block);
 
@@ -3150,7 +3150,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 	int i;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3170,7 +3170,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
+		netdev_err(vif->ndev, "PMKID Info\n");
 
 	return result;
 }
@@ -3188,7 +3188,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("Failed to send get mac address\n");
+		netdev_err(vif->ndev, "Failed to send get mac address\n");
 		return -EFAULT;
 	}
 
@@ -3207,12 +3207,12 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv || !connect_result) {
-		PRINT_ER("Driver is null\n");
+		netdev_err(vif->ndev, "Driver is null\n");
 		return -EFAULT;
 	}
 
 	if (!join_params) {
-		PRINT_ER("Unable to Join - JoinParams is NULL\n");
+		netdev_err(vif->ndev, "Unable to Join - JoinParams is NULL\n");
 		return -EFAULT;
 	}
 
@@ -3252,7 +3252,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("Failed to send message queue: Set join request\n");
+		netdev_err(vif->ndev, "send message: Set join request\n");
 		return -EFAULT;
 	}
 
@@ -3270,7 +3270,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("Driver is null\n");
+		netdev_err(vif->ndev, "Driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3281,7 +3281,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("Failed to send message queue: disconnect\n");
+		netdev_err(vif->ndev, "Failed to send message: disconnect\n");
 
 	down(&hif_drv->sem_test_disconn_block);
 
@@ -3298,7 +3298,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("Driver is null\n");
+		netdev_err(vif->ndev, "Driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3311,7 +3311,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
-		PRINT_ER("Failed to send association response config packet\n");
+		netdev_err(vif->ndev, "Failed to send association response\n");
 		return -EINVAL;
 	}
 
@@ -3326,7 +3326,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3337,7 +3337,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("wilc mq send fail\n");
+		netdev_err(vif->ndev, "wilc mq send fail\n");
 		return -EINVAL;
 	}
 
@@ -3357,7 +3357,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("wilc mq send fail\n");
+		netdev_err(vif->ndev, "wilc mq send fail\n");
 		result = -EINVAL;
 	}
 
@@ -3376,7 +3376,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("wilc mq send fail\n");
+		netdev_err(vif->ndev, "wilc mq send fail\n");
 		result = -EINVAL;
 	}
 
@@ -3391,7 +3391,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3403,7 +3403,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("Failed to send get host channel param's message queue ");
+		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 
 	down(&hif_drv->sem_inactive_time);
 
@@ -3424,14 +3424,14 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("Failed to send get host channel param's message queue ");
+		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 		return -EFAULT;
 	}
 
 	down(&hif_drv->sem_get_rssi);
 
 	if (!rssi_level) {
-		PRINT_ER("RSS pointer value is null");
+		netdev_err(vif->ndev, "RSS pointer value is null\n");
 		return -EFAULT;
 	}
 
@@ -3452,7 +3452,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("Failed to send get host channel param's message queue ");
+		netdev_err(vif->ndev, "Failed to send get host channel\n");
 		return -EFAULT;
 	}
 
@@ -3472,7 +3472,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv || !scan_result) {
-		PRINT_ER("hif_drv or scan_result = NULL\n");
+		netdev_err(vif->ndev, "hif_drv or scan_result = NULL\n");
 		return -EFAULT;
 	}
 
@@ -3505,7 +3505,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
-		PRINT_ER("Error in sending message queue\n");
+		netdev_err(vif->ndev, "Error in sending message queue\n");
 		return -EINVAL;
 	}
 
@@ -3524,7 +3524,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("hif_drv NULL\n");
+		netdev_err(vif->ndev, "hif_drv NULL\n");
 		return -EFAULT;
 	}
 
@@ -3543,7 +3543,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 	struct wilc_vif *vif = (struct wilc_vif *)arg;
 
 	if (!vif->hif_drv) {
-		PRINT_ER("Driver handler is NULL\n");
+		netdev_err(vif->ndev, "Driver handler is NULL\n");
 		return;
 	}
 
@@ -3598,7 +3598,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		result = wilc_mq_create(&hif_msg_q);
 
 		if (result < 0) {
-			PRINT_ER("Failed to creat MQ\n");
+			netdev_err(vif->ndev, "Failed to creat MQ\n");
 			goto _fail_;
 		}
 
@@ -3606,7 +3606,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 						 "WILC_kthread");
 
 		if (IS_ERR(hif_thread_handler)) {
-			PRINT_ER("Failed to creat Thread\n");
+			netdev_err(vif->ndev, "Failed to creat Thread\n");
 			result = -EFAULT;
 			goto _fail_mq_;
 		}
@@ -3650,7 +3650,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv)	{
-		PRINT_ER("hif_drv = NULL\n");
+		netdev_err(vif->ndev, "hif_drv = NULL\n");
 		return -EFAULT;
 	}
 
@@ -3685,7 +3685,7 @@ int wilc_deinit(struct wilc_vif *vif)
 
 		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (result != 0)
-			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", result);
+			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
 
 		down(&hif_sema_thread);
 
@@ -3716,7 +3716,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	hif_drv = vif->hif_drv;
 
 	if (!hif_drv || hif_drv == terminated_handle)	{
-		PRINT_ER("NetworkInfo received but driver not init[%p]\n", hif_drv);
+		netdev_err(vif->ndev, "driver not init[%p]\n", hif_drv);
 		return;
 	}
 
@@ -3731,7 +3731,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", result);
+		netdev_err(vif->ndev, "message parameters (%d)\n", result);
 }
 
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
@@ -3760,7 +3760,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	}
 
 	if (!hif_drv->usr_conn_req.conn_result) {
-		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
+		netdev_err(vif->ndev, "there is no current Connect Request\n");
 		up(&hif_sema_deinit);
 		return;
 	}
@@ -3776,7 +3776,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", result);
+		netdev_err(vif->ndev, "synchronous info (%d)\n", result);
 
 	up(&hif_sema_deinit);
 }
@@ -3807,7 +3807,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 
 		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (result)
-			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", result);
+			netdev_err(vif->ndev, "complete param (%d)\n", result);
 	}
 }
 
@@ -3822,7 +3822,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3839,7 +3839,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc mq send fail\n");
+		netdev_err(vif->ndev, "wilc mq send fail\n");
 
 	return result;
 }
@@ -3851,7 +3851,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3864,7 +3864,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc mq send fail\n");
+		netdev_err(vif->ndev, "wilc mq send fail\n");
 
 	return result;
 }
@@ -3876,7 +3876,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3901,7 +3901,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc mq send fail\n");
+		netdev_err(vif->ndev, "wilc mq send fail\n");
 
 	return result;
 }
@@ -3915,7 +3915,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3945,7 +3945,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc mq send fail\n");
+		netdev_err(vif->ndev, "wilc mq send fail\n");
 
 ERRORHANDLER:
 	if (result) {
@@ -3964,7 +3964,7 @@ int wilc_del_beacon(struct wilc_vif *vif)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -3973,7 +3973,7 @@ int wilc_del_beacon(struct wilc_vif *vif)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
 	return result;
 }
@@ -3986,7 +3986,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -4006,7 +4006,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 	return result;
 }
 
@@ -4018,7 +4018,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -4034,7 +4034,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 	return result;
 }
 
@@ -4049,7 +4049,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	u8 assoc_sta = 0;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -4071,7 +4071,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
 	down(&hif_sema_wait_response);
 
@@ -4087,7 +4087,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -4107,7 +4107,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
 	return result;
 }
@@ -4120,7 +4120,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -4137,7 +4137,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 	return result;
 }
 
@@ -4150,7 +4150,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -4164,7 +4164,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 	return result;
 }
 
@@ -4329,7 +4329,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -4343,7 +4343,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
 	return result;
 }
@@ -4355,7 +4355,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		PRINT_ER("driver is null\n");
+		netdev_err(vif->ndev, "driver is null\n");
 		return -EFAULT;
 	}
 
@@ -4369,7 +4369,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-		PRINT_ER("wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
 	return result;
 }
-- 
1.9.1

