Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45656 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbbIGKJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 06:09:09 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/3] staging: wilc1000: remove dead codes
Date: Mon, 7 Sep 2015 19:09:29 +0900
Message-ID: <1441620571-23033-1-git-send-email-tony.cho@atmel.com> (sfid-20150907_120914_437314_3FBEE1D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the preprocessor definition from the codes, as shown in the
following, which is not used anymore.
- WILC_FULLY_HOSTING_AP

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 97 -----------------------
 drivers/staging/wilc1000/linux_wlan.c             | 13 ---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 48 -----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  5 --
 drivers/staging/wilc1000/wilc_wlan.c              | 48 -----------
 drivers/staging/wilc1000/wilc_wlan.h              |  7 --
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 28 -------
 drivers/staging/wilc1000/wilc_wlan_if.h           |  9 ---
 8 files changed, 255 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index b8d7d04..b5db23f 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -11,9 +11,6 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
-#ifdef WILC_FULLY_HOSTING_AP
-#include "wilc_host_ap.h"
-#endif
 #ifdef WILC_AP_EXTERNAL_MLME
 
 struct wilc_wfi_radiotap_hdr {
@@ -222,11 +219,9 @@ static void mgmt_tx_complete(void *priv, int status)
  *      }*/
 
 	/* incase of fully hosting mode, the freeing will be done in response to the cfg packet */
-	#ifndef WILC_FULLY_HOSTING_AP
 	kfree(pv_data->buff);
 
 	kfree(pv_data);
-	#endif
 }
 static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 {
@@ -244,11 +239,6 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 		return WILC_FAIL;
 	}
 
-	#ifdef WILC_FULLY_HOSTING_AP
-	/* add space for the pointer to tx_complete_mon_data */
-	len += sizeof(struct tx_complete_mon_data *);
-	#endif
-
 	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
 	if (mgmt_tx->buff == NULL) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
@@ -258,19 +248,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 
 	mgmt_tx->size = len;
 
-	#ifndef WILC_FULLY_HOSTING_AP
 	memcpy(mgmt_tx->buff, buf, len);
-	#else
-	memcpy(mgmt_tx->buff, buf, len - sizeof(struct tx_complete_mon_data *));
-	memcpy((mgmt_tx->buff) + (len - sizeof(struct tx_complete_mon_data *)), &mgmt_tx, sizeof(struct tx_complete_mon_data *));
-
-	/* filter data frames to handle it's PS */
-	if (filter_monitor_data_frames((mgmt_tx->buff), len) == true) {
-		return;
-	}
-
-	#endif /* WILC_FULLY_HOSTING_AP */
-
 	g_linux_wlan->oup.wlan_add_mgmt_to_tx_que(mgmt_tx, mgmt_tx->buff, mgmt_tx->size, mgmt_tx_complete);
 
 	netif_wake_queue(dev);
@@ -389,81 +367,6 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
 
 };
 
-#ifdef WILC_FULLY_HOSTING_AP
-/*
- *  @brief                      WILC_mgm_HOSTAPD_ACK
- *  @details            report the status of transmitted mgmt frames to HOSTAPD
- *  @param[in]          priv : pointer to tx_complete_mon_data struct
- *				bStatus : status of transmission
- *  @author		Abd Al-Rahman Diab
- *  @date			9 May 2013
- *  @version		1.0
- */
-void WILC_mgm_HOSTAPD_ACK(void *priv, bool bStatus)
-{
-	struct sk_buff *skb;
-	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
-
-	struct tx_complete_mon_data *pv_data = (struct tx_complete_mon_data *)priv;
-	u8 *buf =  pv_data->buff;
-
-	/* len of the original frame without the added pointer at the tail */
-	u16 u16len = (pv_data->size) - sizeof(struct tx_complete_mon_data *);
-
-
-	/*if(bStatus == 1){
-	 *      if(INFO || buf[0] == 0x10 || buf[0] == 0xb0)
-	 *      PRINT_D(HOSTAPD_DBG,"Packet sent successfully - Size = %d - Address = %p.\n",u16len,pv_data->buff);
-	 * }else{
-	 *              PRINT_D(HOSTAPD_DBG,"Couldn't send packet - Size = %d - Address = %p.\n",u16len,pv_data->buff);
-	 *      }
-	 */
-
-	/* (skb->data[9] == 0x00 || skb->data[9] == 0xb0 || skb->data[9] == 0x40 ||  skb->data[9] == 0xd0 ) */
-	{
-		skb = dev_alloc_skb(u16len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
-
-		memcpy(skb_put(skb, u16len), pv_data->buff, u16len);
-
-		cb_hdr = (struct wilc_wfi_radiotap_cb_hdr *) skb_push(skb, sizeof(*cb_hdr));
-		memset(cb_hdr, 0, sizeof(struct wilc_wfi_radiotap_cb_hdr));
-
-		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
-
-		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
-
-		cb_hdr->hdr.it_present = cpu_to_le32(
-				(1 << IEEE80211_RADIOTAP_RATE) |
-				(1 << IEEE80211_RADIOTAP_TX_FLAGS));
-
-		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
-
-
-		if (bStatus) {
-			/* success */
-			cb_hdr->tx_flags = IEEE80211_RADIOTAP_F_TX_RTS;
-		} else {
-			cb_hdr->tx_flags = IEEE80211_RADIOTAP_F_TX_FAIL;
-		}
-
-		skb->dev = wilc_wfi_mon;
-		skb_set_mac_header(skb, 0);
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		skb->pkt_type = PACKET_OTHERHOST;
-		skb->protocol = htons(ETH_P_802_2);
-		memset(skb->cb, 0, sizeof(skb->cb));
-
-		netif_rx(skb);
-	}
-
-	/* incase of fully hosting mode, the freeing will be done in response to the cfg packet */
-	kfree(pv_data->buff);
-
-	kfree(pv_data);
-
-}
-#endif /* WILC_FULLY_HOSTING_AP */
-
 /**
  *  @brief      WILC_WFI_mon_setup
  *  @details
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index afd6702..4187c7c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -39,10 +39,6 @@
 #include "linux_wlan_spi.h"
 #endif
 
-#ifdef WILC_FULLY_HOSTING_AP
-#include "wilc_host_ap.h"
-#endif
-
 #ifdef STATIC_MACADDRESS /* brandy_0724 [[ */
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
@@ -1321,12 +1317,7 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 #endif
 
 	/*for now - to be revised*/
-	#ifdef WILC_FULLY_HOSTING_AP
-	/* incase of Fully hosted AP, all non cfg pkts are processed here*/
-	nwi->net_func.rx_indicate = WILC_Process_rx_frame;
-	#else
 	nwi->net_func.rx_indicate = frmw_to_linux;
-	#endif
 	nwi->net_func.rx_complete = linux_wlan_rx_complete;
 	nwi->indicate_func.mac_indicate = linux_wlan_mac_indicate;
 }
@@ -1989,14 +1980,10 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
 	tx_data->pBssid = g_linux_wlan->strInterfaceInfo[nic->u8IfIdx].aBSSID;
-	#ifndef WILC_FULLY_HOSTING_AP
 	QueueCount = g_linux_wlan->oup.wlan_add_to_tx_que((void *)tx_data,
 							  tx_data->buff,
 							  tx_data->size,
 							  linux_wlan_tx_complete);
-	#else
-	QueueCount = WILC_Xmit_data((void *)tx_data, HOST_TO_WLAN);
-	#endif /* WILC_FULLY_HOSTING_AP */
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
 		netif_stop_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 75e1687..663d0f8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3236,19 +3236,11 @@ static int WILC_WFI_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	linux_wlan_set_bssid(dev, g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 
-	#ifndef WILC_FULLY_HOSTING_AP
 	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
 					settings->dtim_period,
 					beacon->head_len, (u8 *)beacon->head,
 					beacon->tail_len, (u8 *)beacon->tail);
-	#else
-	s32Error = host_add_beacon(priv->hWILCWFIDrv,
-					settings->beacon_interval,
-					settings->dtim_period,
-					beacon->head_len, (u8 *)beacon->head,
-					beacon->tail_len, (u8 *)beacon->tail);
-	#endif
 
 	return s32Error;
 }
@@ -3275,19 +3267,11 @@ static int  WILC_WFI_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "Setting beacon\n");
 
 
-#ifndef WILC_FULLY_HOSTING_AP
 	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
 					0,
 					0,
 					beacon->head_len, (u8 *)beacon->head,
 					beacon->tail_len, (u8 *)beacon->tail);
-#else
-	s32Error = host_add_beacon(priv->hWILCWFIDrv,
-					0,
-					0,
-					beacon->head_len, (u8 *)beacon->head,
-					beacon->tail_len, (u8 *)beacon->tail);
-#endif
 
 	return s32Error;
 }
@@ -3317,11 +3301,7 @@ static int  WILC_WFI_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	/*BugID_5188*/
 	linux_wlan_set_bssid(dev, NullBssid);
 
-	#ifndef WILC_FULLY_HOSTING_AP
 	s32Error = host_int_del_beacon(priv->hWILCWFIDrv);
-	#else
-	s32Error = host_del_beacon(priv->hWILCWFIDrv);
-	#endif
 
 	WILC_ERRORCHECK(s32Error);
 
@@ -3355,8 +3335,6 @@ static int  WILC_WFI_add_station(struct wiphy *wiphy, struct net_device *dev,
 	nic = netdev_priv(dev);
 
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
-		#ifndef WILC_FULLY_HOSTING_AP
-
 		memcpy(strStaParams.au8BSSID, mac, ETH_ALEN);
 		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
 		strStaParams.u16AssocID = params->aid;
@@ -3396,18 +3374,6 @@ static int  WILC_WFI_add_station(struct wiphy *wiphy, struct net_device *dev,
 
 		s32Error = host_int_add_station(priv->hWILCWFIDrv, &strStaParams);
 		WILC_ERRORCHECK(s32Error);
-
-		#else
-		PRINT_D(CFG80211_DBG, "Adding station parameters %d\n", params->aid);
-		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
-
-		PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][0], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][1], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][2], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][3], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][4],
-			priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][5]);
-
-		WILC_AP_AddSta(mac, params);
-		WILC_ERRORCHECK(s32Error);
-		#endif /* WILC_FULLY_HOSTING_AP */
-
 	}
 
 	WILC_CATCH(s32Error)
@@ -3449,11 +3415,7 @@ static int WILC_WFI_del_station(struct wiphy *wiphy, struct net_device *dev,
 			PRINT_D(HOSTAPD_DBG, "With mac address: %x%x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 		}
 
-		#ifndef WILC_FULLY_HOSTING_AP
 		s32Error = host_int_del_station(priv->hWILCWFIDrv, mac);
-		#else
-		WILC_AP_RemoveSta(mac);
-		#endif /* WILC_FULLY_HOSTING_AP */
 
 		WILC_ERRORCHECK(s32Error);
 	}
@@ -3489,8 +3451,6 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 	nic = netdev_priv(dev);
 
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
-		#ifndef WILC_FULLY_HOSTING_AP
-
 		memcpy(strStaParams.au8BSSID, mac, ETH_ALEN);
 		strStaParams.u16AssocID = params->aid;
 		strStaParams.u8NumRates = params->supported_rates_len;
@@ -3528,12 +3488,6 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 
 		s32Error = host_int_edit_station(priv->hWILCWFIDrv, &strStaParams);
 		WILC_ERRORCHECK(s32Error);
-
-		#else
-		WILC_AP_EditSta(mac, params);
-		WILC_ERRORCHECK(s32Error);
-		#endif /* WILC_FULLY_HOSTING_AP */
-
 	}
 	WILC_CATCH(s32Error)
 	{
@@ -3623,9 +3577,7 @@ static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 	.del_station = WILC_WFI_del_station,
 	.change_station = WILC_WFI_change_station,
 	#endif /* WILC_AP_EXTERNAL_MLME*/
-	#ifndef WILC_FULLY_HOSTING_AP
 	.get_station = WILC_WFI_get_station,
-	#endif
 	.dump_station = WILC_WFI_dump_station,
 	.change_bss = WILC_WFI_change_bss,
 	.set_wiphy_params = WILC_WFI_set_wiphy_params,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 97b663b..3c3571d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -10,11 +10,6 @@
 #define NM_WFI_CFGOPERATIONS
 #include "wilc_wfi_netdevice.h"
 
-#ifdef WILC_FULLY_HOSTING_AP
-#include "wilc_host_ap.h"
-#endif
-
-
 /* The following macros describe the bitfield map used by the firmware to determine its 11i mode */
 #define NO_ENCRYPT			0
 #define ENCRYPT_ENABLED	(1 << 0)
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4b37de5..b0ae09d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -591,31 +591,6 @@ int wilc_wlan_txq_add_mgmt_pkt(void *priv, uint8_t *buffer, uint32_t buffer_size
 	wilc_wlan_txq_add_to_tail(tqe);
 	return 1;
 }
-
-#ifdef WILC_FULLY_HOSTING_AP
-int wilc_FH_wlan_txq_add_net_pkt(void *priv, uint8_t *buffer, uint32_t buffer_size, wilc_tx_complete_func_t func)
-{
-	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
-	struct txq_entry_t *tqe;
-
-	if (p->quit)
-		return 0;
-
-	tqe = kmalloc(sizeof(struct txq_entry_t), GFP_ATOMIC);
-
-	if (tqe == NULL)
-		return 0;
-	tqe->type = WILC_FH_DATA_PKT;
-	tqe->buffer = buffer;
-	tqe->buffer_size = buffer_size;
-	tqe->tx_complete_func = func;
-	tqe->priv = priv;
-	PRINT_D(TX_DBG, "Adding mgmt packet at the Queue tail\n");
-	wilc_wlan_txq_add_to_tail(tqe);
-	/*return number of itemes in the queue*/
-	return p->txq_entries;
-}
-#endif  /* WILC_FULLY_HOSTING_AP*/
 #endif /*WILC_AP_EXTERNAL_MLME*/
 static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 {
@@ -924,11 +899,6 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 				else if (tqe->type == WILC_NET_PKT) {
 					vmm_sz = ETH_ETHERNET_HDR_OFFSET;
 				}
-#ifdef WILC_FULLY_HOSTING_AP
-				else if (tqe->type == WILC_FH_DATA_PKT)	{
-					vmm_sz = FH_TX_HOST_HDR_OFFSET;
-				}
-#endif
 #ifdef WILC_AP_EXTERNAL_MLME
 				else {
 					vmm_sz = HOST_HDR_OFFSET;
@@ -1138,11 +1108,6 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 					/* copy the bssid at the sart of the buffer */
 					memcpy(&txb[offset + 4], pBSSID, 6);
 				}
-#ifdef WILC_FULLY_HOSTING_AP
-				else if (tqe->type == WILC_FH_DATA_PKT)	{
-					buffer_offset = FH_TX_HOST_HDR_OFFSET;
-				}
-#endif
 				else {
 					buffer_offset = HOST_HDR_OFFSET;
 				}
@@ -2204,10 +2169,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/*Bug3959: transmitting mgmt frames received from host*/
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
 	oup->wlan_add_mgmt_to_tx_que = wilc_wlan_txq_add_mgmt_pkt;
-
-	#ifdef WILC_FULLY_HOSTING_AP
-	oup->wlan_add_data_to_tx_que = wilc_FH_wlan_txq_add_net_pkt;
-	#endif
 	#endif
 
 	if (!init_chip()) {
@@ -2271,12 +2232,3 @@ u16 Set_machw_change_vir_if(bool bValue)
 
 	return ret;
 }
-
-#ifdef WILC_FULLY_HOSTING_AP
-wilc_wlan_dev_t *Get_wlan_context(u16 *pu16size)
-{
-	*pu16size = sizeof(wilc_wlan_dev_t);
-	return &g_wlan;
-}
-#endif
-
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 244f710..99e07de 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -36,9 +36,6 @@
 				   ETH_CONFIG_PKT_HDR_LEN)
 #define   ACTION         0xD0
 #define   PROBE_REQ   0x40
-#ifdef WILC_FULLY_HOSTING_AP
-#define	FH_TX_HOST_HDR_OFFSET	24
-#endif
 
 /********************************************
  *
@@ -145,10 +142,6 @@
 #ifdef WILC_AP_EXTERNAL_MLME
 #define WILC_MGMT_PKT 2
 
-#ifdef WILC_FULLY_HOSTING_AP
-#define WILC_FH_DATA_PKT 4
-#endif
-
 #endif /*WILC_AP_EXTERNAL_MLME*/
 #define WILC_CFG_SET 1
 #define WILC_CFG_QUERY 0
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index c3f3aaf..d503799 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -12,11 +12,6 @@
 #include "wilc_wlan_cfg.h"
 #include "coreconfigurator.h"
 
-#ifdef WILC_FULLY_HOSTING_AP
-#include "wilc_host_ap.h"
-void WILC_mgm_HOSTAPD_ACK(void *priv, bool bStatus);
-#endif
-
 /********************************************
  *
  *      Global Data
@@ -514,17 +509,6 @@ static int wilc_wlan_cfg_indicate_rx(uint8_t *frame, int size, wilc_cfg_rsp_t *r
 	int ret = 1;
 	uint8_t msg_type;
 	uint8_t msg_id;
-	#ifdef WILC_FULLY_HOSTING_AP
-	u32 *ptru32Frame;
-	bool bStatus = frame[2];
-
-	#ifdef BIG_ENDIAN
-	ptru32Frame = (frame[4] << 24) | (frame[5] << 16) | (frame[6] << 8) | frame[7];
-	#else
-	ptru32Frame = (frame[7] << 24) | (frame[6] << 16) | (frame[5] << 8) | frame[4];
-	#endif  /* BIG_ENDIAN */
-
-	#endif  /* WILC_FULLY_HOSTING_AP */
 
 	msg_type = frame[0];
 	msg_id = frame[1];      /* seq no */
@@ -571,18 +555,6 @@ static int wilc_wlan_cfg_indicate_rx(uint8_t *frame, int size, wilc_cfg_rsp_t *r
 		host_int_ScanCompleteReceived(frame - 4, size + 4);
 		break;
 
-#ifdef WILC_FULLY_HOSTING_AP
-	case 'T':
-		PRINT_INFO(RX_DBG, "TBTT Notification Received\n");
-		process_tbtt_isr();
-		break;
-
-	case 'A':
-		PRINT_INFO(RX_DBG, "HOSTAPD ACK Notification Received\n");
-		WILC_mgm_HOSTAPD_ACK(ptru32Frame, bStatus);
-		break;
-#endif
-
 	default:
 		PRINT_INFO(RX_DBG, "Receive unknown message type[%d-%d-%d-%d-%d-%d-%d-%d]\n",
 			   frame[0], frame[1], frame[2], frame[3], frame[4],
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 021a2aa..9f9f4a9 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -16,7 +16,6 @@
 #define WILC_P2P
 #define TCP_ENHANCEMENTS
 /* #define MEMORY_STATIC */
-/* #define WILC_FULLY_HOSTING_AP */
 /* #define USE_OLD_SPI_SW */
 
 
@@ -155,9 +154,6 @@ typedef struct {
 } wilc_wlan_inp_t;
 
 struct tx_complete_data {
-	#ifdef WILC_FULLY_HOSTING_AP
-	struct tx_complete_data *next;
-	#endif
 	int size;
 	void *buff;
 	uint8_t *pBssid;
@@ -184,11 +180,6 @@ typedef struct {
 	/*Bug3959: transmitting mgmt frames received from host*/
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
 	int (*wlan_add_mgmt_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
-
-	#ifdef WILC_FULLY_HOSTING_AP
-	int (*wlan_add_data_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
-	#endif
-
 	#endif
 } wilc_wlan_oup_t;
 
-- 
1.9.1

