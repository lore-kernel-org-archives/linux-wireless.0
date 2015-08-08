Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34319 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818AbbHHMMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 08:12:45 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 3/4] staging: wilc1000: Remove ' ' before quoted '\n'
Date: Sat,  8 Aug 2015 17:41:35 +0530
Message-Id: <1439035896-15213-4-git-send-email-csgorentla@gmail.com> (sfid-20150808_141309_377998_30C766D1)
In-Reply-To: <1439035896-15213-3-git-send-email-csgorentla@gmail.com>
References: <1439035896-15213-1-git-send-email-csgorentla@gmail.com>
 <1439035896-15213-2-git-send-email-csgorentla@gmail.com>
 <1439035896-15213-3-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the checkpatch.pl warning - 
'unnecessary whitespace before a quoted newline'.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 20 +++++------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 42 +++++++++++------------
 drivers/staging/wilc1000/wilc_wlan.c              | 10 +++---
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  8 ++---
 4 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 0a8052e..92aa671 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -296,7 +296,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = (char *) (&(dev_iface->ifa_address));
-		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d \n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
+		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
 		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
@@ -318,7 +318,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "[%s] Down IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = null_ip;
-		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d \n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
+		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
 
 		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
@@ -1020,7 +1020,7 @@ static int linux_wlan_firmware_download(linux_wlan_t *p_nic)
 	release_firmware(g_linux_wlan->wilc_firmware);
 	g_linux_wlan->wilc_firmware = NULL;
 
-	PRINT_D(INIT_DBG, "Download Succeeded \n");
+	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
 _FAIL_:
 	return ret;
@@ -1774,7 +1774,7 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 	#endif
 
 	if (linux_wlan_get_firmware(nic)) {
-		PRINT_ER("Can't get firmware \n");
+		PRINT_ER("Can't get firmware\n");
 		ret = -1;
 		goto __fail__;
 	}
@@ -1859,7 +1859,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 #endif
 
 		if (linux_wlan_get_firmware(nic)) {
-			PRINT_ER("Can't get firmware \n");
+			PRINT_ER("Can't get firmware\n");
 			ret = -EIO;
 			goto _fail_irq_enable_;
 		}
@@ -2080,13 +2080,13 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	if (!dev)
 		return;
 
-	PRINT_D(INIT_DBG, "Setting Multicast List with count = %d. \n", dev->mc.count);
+	PRINT_D(INIT_DBG, "Setting Multicast List with count = %d.\n", dev->mc.count);
 
 	if (dev->flags & IFF_PROMISC) {
 		/* Normally, we should configure the chip to retrive all packets
 		 * but we don't wanna support this right now */
 		/* TODO: add promiscuous mode support */
-		PRINT_D(INIT_DBG, "Set promiscuous mode ON, retrive all packets \n");
+		PRINT_D(INIT_DBG, "Set promiscuous mode ON, retrive all packets\n");
 		return;
 	}
 
@@ -2145,7 +2145,7 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct ethhdr *eth_h;
 	nic = netdev_priv(ndev);
 
-	PRINT_D(INT_DBG, "\n========\n IntUH: %d - IntBH: %d - IntCld: %d \n========\n", int_rcvdU, int_rcvdB, int_clrd);
+	PRINT_D(INT_DBG, "\n========\n IntUH: %d - IntBH: %d - IntCld: %d\n========\n", int_rcvdU, int_rcvdB, int_clrd);
 	PRINT_D(TX_DBG, "Sending packet just received from TCP/IP\n");
 
 	/* Stop the network interface queue */
@@ -2551,7 +2551,7 @@ int wilc_netdev_init(void)
 
 	#ifndef WILC_SDIO
 	if (!linux_spi_init(&g_linux_wlan->wilc_spidev)) {
-		PRINT_ER("Can't initialize SPI \n");
+		PRINT_ER("Can't initialize SPI\n");
 		return -1; /* ERROR */
 	}
 	g_linux_wlan->wilc_spidev = wilc_spi_dev;
@@ -2636,7 +2636,7 @@ static void __exit exit_wilc_driver(void)
 			}
 		}
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			PRINT_D(INIT_DBG, "Unregistering netdev %p \n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
+			PRINT_D(INIT_DBG, "Unregistering netdev %p\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 			unregister_netdev(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 			#ifdef USE_WIRELESS
 			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4918481..cbfb207 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -239,7 +239,7 @@ void remove_network_from_shadow(void *pUserVoid)
 
 	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
 		if (time_after(now, astrLastScannedNtwrksShadow[i].u32TimeRcvdInScan + (unsigned long)(SCAN_RESULT_EXPIRE))) {
-			PRINT_D(CFG80211_DBG, "Network expired in ScanShadow: %s \n", astrLastScannedNtwrksShadow[i].au8ssid);
+			PRINT_D(CFG80211_DBG, "Network expired in ScanShadow: %s\n", astrLastScannedNtwrksShadow[i].au8ssid);
 
 			if (astrLastScannedNtwrksShadow[i].pu8IEs != NULL) {
 				WILC_FREE(astrLastScannedNtwrksShadow[i].pu8IEs);
@@ -393,7 +393,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 				WILC_NULLCHECK(s32Error, channel);
 
 				PRINT_INFO(CFG80211_DBG, "Network Info:: CHANNEL Frequency: %d, RSSI: %d, CapabilityInfo: %d,"
-					   "BeaconPeriod: %d \n", channel->center_freq, (((s32)pstrNetworkInfo->s8rssi) * 100),
+					   "BeaconPeriod: %d\n", channel->center_freq, (((s32)pstrNetworkInfo->s8rssi) * 100),
 					   pstrNetworkInfo->u16CapInfo, pstrNetworkInfo->u16BeaconPeriod);
 
 				if (pstrNetworkInfo->bNewNetwork == true) {
@@ -429,7 +429,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 					/* So this network is discovered before, we'll just update its RSSI */
 					for (i = 0; i < priv->u32RcvdChCount; i++) {
 						if (memcmp(astrLastScannedNtwrksShadow[i].au8bssid, pstrNetworkInfo->au8bssid, 6) == 0) {
-							PRINT_D(CFG80211_DBG, "Update RSSI of %s \n", astrLastScannedNtwrksShadow[i].au8ssid);
+							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", astrLastScannedNtwrksShadow[i].au8ssid);
 
 							astrLastScannedNtwrksShadow[i].s8rssi = pstrNetworkInfo->s8rssi;
 							astrLastScannedNtwrksShadow[i].u32TimeRcvdInScan = jiffies;
@@ -439,14 +439,14 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 				}
 			}
 		} else if (enuScanEvent == SCAN_EVENT_DONE)    {
-			PRINT_D(CFG80211_DBG, "Scan Done[%p] \n", priv->dev);
-			PRINT_D(CFG80211_DBG, "Refreshing Scan ... \n");
+			PRINT_D(CFG80211_DBG, "Scan Done[%p]\n", priv->dev);
+			PRINT_D(CFG80211_DBG, "Refreshing Scan ...\n");
 			refresh_scan(priv, 1, false);
 
 			if (priv->u32RcvdChCount > 0) {
-				PRINT_D(CFG80211_DBG, "%d Network(s) found \n", priv->u32RcvdChCount);
+				PRINT_D(CFG80211_DBG, "%d Network(s) found\n", priv->u32RcvdChCount);
 			} else {
-				PRINT_D(CFG80211_DBG, "No networks found \n");
+				PRINT_D(CFG80211_DBG, "No networks found\n");
 			}
 
 			down(&(priv->hSemScanReq));
@@ -464,7 +464,7 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 		else if (enuScanEvent == SCAN_EVENT_ABORTED) {
 			down(&(priv->hSemScanReq));
 
-			PRINT_D(CFG80211_DBG, "Scan Aborted \n");
+			PRINT_D(CFG80211_DBG, "Scan Aborted\n");
 			if (priv->pstrScanReq != NULL) {
 
 				update_scan_time(priv);
@@ -582,7 +582,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 				u8WLANChannel = INVALID_CHANNEL;
 			#endif
 
-			PRINT_ER("Unspecified failure: Connection status %d : MAC status = %d \n", u16ConnectStatus, u8MacStatus);
+			PRINT_ER("Unspecified failure: Connection status %d : MAC status = %d\n", u16ConnectStatus, u8MacStatus);
 		}
 
 		if (u16ConnectStatus == WLAN_STATUS_SUCCESS) {
@@ -768,17 +768,17 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 					WILC_memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen = request->ssids[i].ssid_len;
 				} else {
-					PRINT_D(CFG80211_DBG, "Received one NULL SSID \n");
+					PRINT_D(CFG80211_DBG, "Received one NULL SSID\n");
 					strHiddenNetwork.u8ssidnum -= 1;
 				}
 			}
-			PRINT_D(CFG80211_DBG, "Trigger Scan Request \n");
+			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
 			s32Error = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
 						 CfgScanResult, (void *)priv, &strHiddenNetwork);
 		} else {
-			PRINT_D(CFG80211_DBG, "Trigger Scan Request \n");
+			PRINT_D(CFG80211_DBG, "Trigger Scan Request\n");
 			s32Error = host_int_scan(priv->hWILCWFIDrv, USER_SCAN, ACTIVE_SCAN,
 						 au8ScanChanList, request->n_channels,
 						 (const u8 *)request->ie, request->ie_len,
@@ -787,7 +787,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 
 	} else {
 		PRINT_ER("Requested num of scanned channels is greater than the max, supported"
-			 " channels \n");
+			 " channels\n");
 	}
 
 	if (s32Error != WILC_SUCCESS) {
@@ -840,7 +840,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	} else
 		pstrWFIDrv->u8P2PConnect = 0;
 	#endif
-	PRINT_INFO(CFG80211_DBG, "Required SSID = %s\n , AuthType = %d \n", sme->ssid, sme->auth_type);
+	PRINT_INFO(CFG80211_DBG, "Required SSID = %s\n , AuthType = %d\n", sme->ssid, sme->auth_type);
 
 	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
 		if ((sme->ssid_len == astrLastScannedNtwrksShadow[i].u8SsidLen) &&
@@ -1045,7 +1045,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 					 tenuAuth_type, pstrNetworkInfo->u8channel,
 					 pstrNetworkInfo->pJoinParams);
 	if (s32Error != WILC_SUCCESS) {
-		PRINT_ER("host_int_set_join_req(): Error(%d) \n", s32Error);
+		PRINT_ER("host_int_set_join_req(): Error(%d)\n", s32Error);
 		s32Error = -ENOENT;
 		goto done;
 	}
@@ -1573,7 +1573,7 @@ static int WILC_WFI_set_default_key(struct wiphy *wiphy, struct net_device *netd
 
 	priv = wiphy_priv(wiphy);
 
-	PRINT_D(CFG80211_DBG, "Setting default key with idx = %d \n", key_index);
+	PRINT_D(CFG80211_DBG, "Setting default key with idx = %d\n", key_index);
 
 	if (key_index != priv->WILC_WFI_wep_default) {
 
@@ -1810,7 +1810,7 @@ static int WILC_WFI_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	priv = wiphy_priv(wiphy);
 
 	pstrCfgParamVal.u32SetCfgFlag = 0;
-	PRINT_D(CFG80211_DBG, "Setting Wiphy params \n");
+	PRINT_D(CFG80211_DBG, "Setting Wiphy params\n");
 
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
 		PRINT_D(CFG80211_DBG, "Setting WIPHY_PARAM_RETRY_SHORT %d\n",
@@ -2335,7 +2335,7 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 	struct WILC_WFI_priv *priv;
 	priv = (struct WILC_WFI_priv *)pUserVoid;
 
-	PRINT_D(HOSTINF_DBG, "Remain on channel ready \n");
+	PRINT_D(HOSTINF_DBG, "Remain on channel ready\n");
 
 	priv->bInP2PlistenState = true;
 
@@ -2363,7 +2363,7 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 
 	/*BugID_5477*/
 	if (u32SessionID == priv->strRemainOnChanParams.u32ListenSessionID) {
-		PRINT_D(GENERIC_DBG, "Remain on channel expired \n");
+		PRINT_D(GENERIC_DBG, "Remain on channel expired\n");
 
 		priv->bInP2PlistenState = false;
 
@@ -3210,7 +3210,7 @@ static int WILC_WFI_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	PRINT_D(HOSTAPD_DBG, "Starting ap\n");
 
-	PRINT_D(HOSTAPD_DBG, "Interval = %d \n DTIM period = %d\n Head length = %zu Tail length = %zu\n",
+	PRINT_D(HOSTAPD_DBG, "Interval = %d\n DTIM period = %d\n Head length = %zu Tail length = %zu\n",
 		settings->beacon_interval, settings->dtim_period, beacon->head_len, beacon->tail_len);
 
 	s32Error = WILC_WFI_CfgSetChannel(wiphy, &settings->chandef);
@@ -3426,7 +3426,7 @@ static int WILC_WFI_del_station(struct wiphy *wiphy, struct net_device *dev,
 
 
 		if (mac == NULL) {
-			PRINT_D(HOSTAPD_DBG, "All associated stations \n");
+			PRINT_D(HOSTAPD_DBG, "All associated stations\n");
 			s32Error = host_int_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
 		} else {
 			PRINT_D(HOSTAPD_DBG, "With mac address: %x%x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 75782a2..bd5c256 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -447,7 +447,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
 		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].Bigger_Ack_num) {
 			struct txq_entry_t *tqe;
-			PRINT_D(TCP_ENH, "DROP ACK: %u \n", Pending_Acks_info[i].ack_num);
+			PRINT_D(TCP_ENH, "DROP ACK: %u\n", Pending_Acks_info[i].ack_num);
 			tqe = Pending_Acks_info[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(tqe);
@@ -992,7 +992,7 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 				/**
 				 *      wait for vmm table is ready
 				 **/
-				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait... \n");
+				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
 				release_bus(RELEASE_ALLOW_SLEEP);
 				p->os_func.os_sleep(3); /* wait 3 ms */
 				acquire_bus(ACQUIRE_AND_WAKEUP);
@@ -1059,7 +1059,7 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 			}
 
 			if (entries == 0) {
-				PRINT_WRN(GENERIC_DBG, "[wilc txq]: no more buffer in the chip (reg: %08x), retry later [[ %d, %x ]] \n", reg, i, vmm_table[i - 1]);
+				PRINT_WRN(GENERIC_DBG, "[wilc txq]: no more buffer in the chip (reg: %08x), retry later [[ %d, %x ]]\n", reg, i, vmm_table[i - 1]);
 
 				/* undo the transaction. */
 				ret = p->hif_func.hif_read_reg(WILC_HOST_TX_CTRL, &reg);
@@ -1209,7 +1209,7 @@ static void wilc_wlan_handle_rxq(void)
 
 	do {
 		if (p->quit) {
-			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function \n");
+			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function\n");
 			p->os_func.os_signal(p->cfg_wait);
 			break;
 		}
@@ -1326,7 +1326,7 @@ static void wilc_wlan_handle_rxq(void)
 	} while (1);
 
 	p->rxq_exit = 1;
-	PRINT_D(RX_DBG, "THREAD: Exiting RX thread \n");
+	PRINT_D(RX_DBG, "THREAD: Exiting RX thread\n");
 	return;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 04d0327..c10dffe 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -551,7 +551,7 @@ static int wilc_wlan_cfg_indicate_rx(uint8_t *frame, int size, wilc_cfg_rsp_t *r
 
 	case 'L':
 #ifndef SWITCH_LOG_TERMINAL
-		PRINT_ER("Unexpected firmware log message received \n");
+		PRINT_ER("Unexpected firmware log message received\n");
 #else
 		PRINT_D(FIRM_DBG, "\nFIRMWARE LOGS :\n<<\n%s\n>>\n", frame);
 		break;
@@ -566,18 +566,18 @@ static int wilc_wlan_cfg_indicate_rx(uint8_t *frame, int size, wilc_cfg_rsp_t *r
 #endif
 /*bug3819:*/
 	case 'S':
-		PRINT_INFO(RX_DBG, "Scan Notification Received \n");
+		PRINT_INFO(RX_DBG, "Scan Notification Received\n");
 		host_int_ScanCompleteReceived(frame - 4, size + 4);
 		break;
 
 #ifdef WILC_FULLY_HOSTING_AP
 	case 'T':
-		PRINT_INFO(RX_DBG, "TBTT Notification Received \n");
+		PRINT_INFO(RX_DBG, "TBTT Notification Received\n");
 		process_tbtt_isr();
 		break;
 
 	case 'A':
-		PRINT_INFO(RX_DBG, "HOSTAPD ACK Notification Received \n");
+		PRINT_INFO(RX_DBG, "HOSTAPD ACK Notification Received\n");
 		WILC_mgm_HOSTAPD_ACK(ptru32Frame, bStatus);
 		break;
 #endif
-- 
2.5.0

