Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48207 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbbG1IuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:50:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/21] staging: wilc1000: remove braces {} for single statement blocks
Date: Tue, 28 Jul 2015 17:47:37 +0900
Message-ID: <1438073261-28315-19-git-send-email-tony.cho@atmel.com> (sfid-20150728_105014_359651_3B3546E4)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Kim, Leo" <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl on
braces {} not necessary for the single statement blocks.

Signed-off-by: Kim, Leo <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 78 ++++++++++++-----------------------
 1 file changed, 26 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 10ea53a..a4589b7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -207,9 +207,8 @@ void printk_later(const char *format, ...)
 	va_start (args, format);
 	ps8current += vsprintf (ps8current, format, args);
 	va_end (args);
-	if ((ps8current - DebugBuffer) > DEGUG_BUFFER_LENGTH) {
+	if ((ps8current - DebugBuffer) > DEGUG_BUFFER_LENGTH)
 		ps8current = DebugBuffer;
-	}
 
 }
 
@@ -779,9 +778,8 @@ struct net_device *GetIfHandler(uint8_t *pMacHeader)
 		}
 	}
 	PRINT_INFO(INIT_DBG, "Invalide handle\n");
-	for (i = 0; i < 25; i++) {
+	for (i = 0; i < 25; i++)
 		PRINT_D(INIT_DBG, "%02x ", pMacHeader[i]);
-	}
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
@@ -821,9 +819,8 @@ int linux_wlan_get_num_conn_ifcs(void)
 	uint8_t ret_val = 0;
 
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-		if (memcmp(g_linux_wlan->strInterfaceInfo[i].aBSSID, null_bssid, 6)) {
+		if (memcmp(g_linux_wlan->strInterfaceInfo[i].aBSSID, null_bssid, 6))
 			ret_val++;
-		}
 	}
 	return ret_val;
 }
@@ -912,15 +909,13 @@ static int linux_wlan_txq_task(void *vp)
 					msleep(TX_BACKOFF_WEIGHT_UNIT_MS << backoff_weight);
 				} while (/*timeout*/ 0);
 				backoff_weight += TX_BACKOFF_WEIGHT_INCR_STEP;
-				if (backoff_weight > TX_BACKOFF_WEIGHT_MAX) {
+				if (backoff_weight > TX_BACKOFF_WEIGHT_MAX)
 					backoff_weight = TX_BACKOFF_WEIGHT_MAX;
-				}
 			} else {
 				if (backoff_weight > TX_BACKOFF_WEIGHT_MIN) {
 					backoff_weight -= TX_BACKOFF_WEIGHT_DECR_STEP;
-					if (backoff_weight < TX_BACKOFF_WEIGHT_MIN) {
+					if (backoff_weight < TX_BACKOFF_WEIGHT_MIN)
 						backoff_weight = TX_BACKOFF_WEIGHT_MIN;
-					}
 				}
 			}
 			/*TODO: drop packets after a certain time/number of retry count. */
@@ -1051,9 +1046,8 @@ static int linux_wlan_firmware_download(linux_wlan_t *p_nic)
 	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
 	ret = g_linux_wlan->oup.wlan_firmware_download(g_linux_wlan->wilc_firmware->data, g_linux_wlan->wilc_firmware->size);
-	if (ret < 0) {
+	if (ret < 0)
 		goto _FAIL_;
-	}
 
 	/* Freeing FW buffer */
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
@@ -1384,13 +1378,11 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 
 
 		/* not sure if the following unlocks are needed or not*/
-		if (&g_linux_wlan->rxq_event != NULL) {
+		if (&g_linux_wlan->rxq_event != NULL)
 			linux_wlan_unlock(&g_linux_wlan->rxq_event);
-		}
 
-		if (&g_linux_wlan->txq_event != NULL) {
+		if (&g_linux_wlan->txq_event != NULL)
 			linux_wlan_unlock(&g_linux_wlan->txq_event);
-		}
 
 
 	#if (RX_BH_TYPE == RX_BH_WORK_QUEUE)
@@ -1744,14 +1736,12 @@ static int linux_wlan_read_mac_addr(void *vp)
 		}
 	}
 
-	if (index == array_size) {
+	if (index == array_size)
 		PRINT_ER("random MAC\n");
-	}
 
 exit:
-	if (fp && !IS_ERR(fp)) {
+	if (fp && !IS_ERR(fp))
 		filp_close(fp, NULL);
-	}
 
 	set_fs(old_fs);
 
@@ -1783,9 +1773,8 @@ uint8_t wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi,	wilc_wlan_oup_t *nwo, li
 
 		sdio_register_driver(&wilc_bus);
 
-		while (!probe) {
+		while (!probe)
 			msleep(100);
-		}
 		probe = 0;
 		g_linux_wlan->wilc_sdio_func = local_sdio_func;
 		linux_to_wlan(nwi, nic);
@@ -1817,9 +1806,8 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 	sdio_register_driver(&wilc_bus);
 
 	/* msleep(1000); */
-	while (!probe) {
+	while (!probe)
 		msleep(100);
-	}
 	probe = 0;
 	g_linux_wlan->wilc_sdio_func = local_sdio_func;
 	linux_to_wlan(&nwi, g_linux_wlan);
@@ -1844,9 +1832,8 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 	}
 	/* Start firmware*/
 	ret = linux_wlan_start_firmware(nic);
-	if (ret < 0) {
+	if (ret < 0)
 		PRINT_ER("Failed to start firmware\n");
-	}
 __fail__:
 	return ret;
 }
@@ -1868,9 +1855,8 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 #ifdef STATIC_MACADDRESS
 		wilc_mac_thread = kthread_run(linux_wlan_read_mac_addr, NULL, "wilc_mac_thread");
-		if (wilc_mac_thread < 0) {
+		if (wilc_mac_thread < 0)
 			PRINT_ER("couldn't create Mac addr thread\n");
-		}
 #endif
 
 		linux_to_wlan(&nwi, g_linux_wlan);
@@ -2234,18 +2220,16 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	tx_data->skb  = skb;
 
 	eth_h = (struct ethhdr *)(skb->data);
-	if (eth_h->h_proto == 0x8e88) {
+	if (eth_h->h_proto == 0x8e88)
 		PRINT_D(INIT_DBG, "EAPOL transmitted\n");
-	}
 
 	/*get source and dest ip addresses*/
 	ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));
 
 	pu8UdpBuffer = (char *)ih + sizeof(struct iphdr);
-	if ((pu8UdpBuffer[1] == 68 && pu8UdpBuffer[3] == 67) || (pu8UdpBuffer[1] == 67 && pu8UdpBuffer[3] == 68)) {
+	if ((pu8UdpBuffer[1] == 68 && pu8UdpBuffer[3] == 67) || (pu8UdpBuffer[1] == 67 && pu8UdpBuffer[3] == 68))
 		PRINT_D(GENERIC_DBG, "DHCP Message transmitted, type:%x %x %x\n", pu8UdpBuffer[248], pu8UdpBuffer[249], pu8UdpBuffer[250]);
 
-	}
 	PRINT_D(TX_DBG, "Sending packet - Size = %d - Address = %p - SKB = %p\n", tx_data->size, tx_data->buff, tx_data->skb);
 
 	/* Send packet to MAC HW - for now the tx_complete function will be just status
@@ -2419,9 +2403,8 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 done:
 
-	if (buff != NULL) {
+	if (buff != NULL)
 		kfree(buff);
-	}
 
 	return s32Error;
 }
@@ -2462,14 +2445,12 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 
 		skb_reserve(skb, (unsigned int)skb->data & 0x3);
 
-		if (g_linux_wlan == NULL || wilc_netdev == NULL) {
+		if (g_linux_wlan == NULL || wilc_netdev == NULL)
 			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
-		}
 		skb->dev = wilc_netdev;
 
-		if (skb->dev == NULL) {
+		if (skb->dev == NULL)
 			PRINT_ER("skb->dev is NULL\n");
-		}
 
 		/*
 		 * for(i=0;i<40;i++)
@@ -2499,9 +2480,8 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 		ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));
 
 		pu8UdpBuffer = (char *)ih + sizeof(struct iphdr);
-		if (buff_to_send[35] == 67 && buff_to_send[37] == 68) {
+		if (buff_to_send[35] == 67 && buff_to_send[37] == 68)
 			PRINT_D(RX_DBG, "DHCP Message received\n");
-		}
 		if (buff_to_send[12] == 0x88 && buff_to_send[13] == 0x8e)
 			PRINT_D(GENERIC_DBG, "eapol received\n");
 			#endif
@@ -2513,9 +2493,8 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 		PRINT_D(RX_DBG, "netif_rx ret value is: %d\n", stats);
 	}
 		#ifndef TCP_ENHANCEMENTS
-	else {
+	else
 		PRINT_ER("Discard sending packet with len = %d\n", size);
-	}
 		#endif
 }
 
@@ -2538,9 +2517,8 @@ void WILC_WFI_mgmt_rx(uint8_t *buff, uint32_t size)
 	#ifdef WILC_P2P
 	nic = netdev_priv(g_linux_wlan->strInterfaceInfo[1].wilc_netdev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
-	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg)) {
+	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
 		WILC_WFI_p2p_rx(g_linux_wlan->strInterfaceInfo[1].wilc_netdev, buff, size);
-	}
 	#endif
 }
 
@@ -2671,17 +2649,15 @@ static int __init init_wilc_driver(void)
 		int ret;
 
 		ret = sdio_register_driver(&wilc_bus);
-		if (ret < 0) {
+		if (ret < 0)
 			PRINT_D(INIT_DBG, "init_wilc_driver: Failed register sdio driver\n");
-		}
 
 		return ret;
 	}
 #else
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
-	if (wilc_netdev_init()) {
+	if (wilc_netdev_init())
 		PRINT_ER("Couldn't initialize netdev\n");
-	}
 	return 0;
 #endif
 }
@@ -2699,9 +2675,8 @@ static void __exit exit_wilc_driver(void)
 		unregister_inetaddr_notifier(&g_dev_notifier);
 	#endif
 
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
+		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			nic[i] = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-		}
 	}
 
 
@@ -2724,9 +2699,8 @@ static void __exit exit_wilc_driver(void)
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
 			/* close all opened interfaces */
 			if (g_linux_wlan->strInterfaceInfo[i].wilc_netdev != NULL) {
-				if (nic[i]->mac_opened)	{
+				if (nic[i]->mac_opened)
 					mac_close(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
-				}
 			}
 		}
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-- 
1.9.1

