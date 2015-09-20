Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33981 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbbITGwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:14 -0400
Received: by padhy16 with SMTP id hy16so87436069pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:13 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/18] staging: wilc1000: remove useless comment
Date: Sun, 20 Sep 2015 15:51:19 +0900
Message-Id: <1442731885-4344-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_091655_399617_9589D8A5)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes useless comment that is containing "BugXXXX"

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 14 --------------
 drivers/staging/wilc1000/linux_mon.c              |  2 --
 drivers/staging/wilc1000/linux_wlan.c             |  5 ++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 --
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 17 ++---------------
 drivers/staging/wilc1000/wilc_wlan.h              |  6 ++----
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  1 -
 drivers/staging/wilc1000/wilc_wlan_if.h           |  4 ----
 9 files changed, 7 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fdb0b9b..0546f7a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -244,7 +244,6 @@ typedef struct _tstrHostIFGetChan {
 	u8 u8GetChan;
 } tstrHostIFGetChan;
 
-/*bug3819: Add Scan acomplete notification to host*/
 /*!
  *  @struct             tstrScanComplete
  *  @brief			hold received Async. Scan Complete message body
@@ -472,7 +471,6 @@ typedef struct _tstrWidJoinReqExt {
 } tstrWidJoinReqExt;
 #endif
 
-/*Bug4218: Parsing Join Param*/
 #ifdef WILC_PARSE_SCAN_IN_HOST
 /*Struct containg joinParam of each AP*/
 typedef struct _tstrJoinBssParam {
@@ -504,7 +502,6 @@ typedef struct _tstrJoinBssParam {
 	u8 au8Interval[4];
 	u8 au8StartTime[4];
 } tstrJoinBssParam;
-/*Bug4218: Parsing Join Param*/
 /*a linked list table containing needed join parameters entries for each AP found in most recent scan*/
 typedef struct _tstrBssTable {
 	u8 u8noBssEntries;
@@ -573,9 +570,7 @@ tstrWILC_WFIDrv *gu8FlushedJoinReqDrvHandler;
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79     /* Position the byte indicating flushing in the flushed request */
 
-/*Bug4218: Parsing Join Param*/
 #ifdef WILC_PARSE_SCAN_IN_HOST
-/*Bug4218: Parsing Join Param*/
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 #endif /*WILC_PARSE_SCAN_IN_HOST*/
 
@@ -843,7 +838,6 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 }
 
 
-/*BugId_5077*/
 /**
  *  @brief Handle_SetMacAddress
  *  @details    Setting mac address
@@ -1376,7 +1370,6 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	strWIDList[u32WidsCount].u16WIDid = WID_SCAN_CHANNEL_LIST;
 	strWIDList[u32WidsCount].enuWIDtype = WID_BIN_DATA;
 
-	/* Bug 4648: Convert channel numbers to start from 0 not 1. */
 	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL && pstrHostIFscanAttr->u8ChnlListLen > 0) {
 		int i;
 
@@ -1528,7 +1521,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 	wid_site_survey_reslts_s *pstrSurveyResults = NULL;
 	#else
 	u8 *pu8CurrByte = NULL;
-	/*Bug4218: Parsing Join Param*/
 	#ifdef WILC_PARSE_SCAN_IN_HOST
 	tstrJoinBssParam *ptstrJoinBssParam;
 	#endif /*WILC_PARSE_SCAN_IN_HOST*/
@@ -1704,7 +1696,6 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 
 	PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
 
-	/*Bug4218: Parsing Join Param*/
 	#ifdef WILC_PARSE_SCAN_IN_HOST
 	ptstrJoinBssParam = (tstrJoinBssParam *)pstrHostIFconnectAttr->pJoinParams;
 	if (ptstrJoinBssParam == NULL) {
@@ -2325,7 +2316,6 @@ static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo
 					pstrWFIDrv->strWILC_UsrScanReq.u32RcvdChCount++;
 
 					pstrNetworkInfo->bNewNetwork = true;
-					/*Bug4218: Parsing Join Param*/
 					/* add new BSS to JoinBssTable */
 				#ifdef WILC_PARSE_SCAN_IN_HOST
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
@@ -3477,7 +3467,6 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 16) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 24) & 0xFF);
 
-	/* Bug 4599 : if tail length = 0 skip copying */
 	if (pstrSetBeaconParam->pu8Tail > 0)
 		memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Tail, pstrSetBeaconParam->u32TailLen);
 	pu8CurrByte += pstrSetBeaconParam->u32TailLen;
@@ -6951,7 +6940,6 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
 	pstrSetBeaconParam->u32TailLen = u32TailLen;
 
-	/* Bug 4599 : if tail length = 0 skip allocating & copying */
 	if (u32TailLen > 0) {
 		pstrSetBeaconParam->pu8Tail = kmalloc(u32TailLen, GFP_KERNEL);
 		if (pstrSetBeaconParam->pu8Tail == NULL) {
@@ -7279,10 +7267,8 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 
 
-/*Bug4218: Parsing Join Param*/
 #ifdef WILC_PARSE_SCAN_IN_HOST
 
-/*Bug4218: Parsing Join Param*/
 /**
  *  @brief              host_int_ParseJoinBssParam
  *  @details            Parse Needed Join Parameters and save it in a new JoinBssParam entry
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 4c02b98..b1af421 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -60,7 +60,6 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 
 	PRINT_INFO(HOSTAPD_DBG, "In monitor interface receive function\n");
 
-	/* Bug 4601 */
 	if (wilc_wfi_mon == NULL)
 		return;
 
@@ -222,7 +221,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	struct sk_buff *skb2;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
 
-	/* Bug 4601 */
 	if (wilc_wfi_mon == NULL)
 		return -EFAULT;
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d7c28f3..f71f7ea 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -615,7 +615,7 @@ int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
 		goto _fail_;
 	}
 #endif
-	g_linux_wlan->wilc_firmware = wilc_firmware; /* Bug 4703 */
+	g_linux_wlan->wilc_firmware = wilc_firmware;
 
 _fail_:
 
@@ -736,7 +736,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
-	/* c_val[0] = RATE_AUTO; / * bug 4275: Enable autorate and limit it to 24Mbps * / */
+	/* c_val[0] = RATE_AUTO; */
 	c_val[0] = RATE_AUTO;
 	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto _fail_;
@@ -2009,7 +2009,6 @@ static void __exit exit_wilc_driver(void)
 		}
 	}
 
-	/* Bug 4600 : WILC_WFI_deinit_mon_interface was already called at mac_close */
 	/* WILC_WFI_deinit_mon_interface(); */
 
 	/* if(g_linux_wlan->open_ifcs==0) */
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5512dd5..04d64a8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2529,8 +2529,6 @@ int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 	pstrWFIDrv->u64P2p_MgmtTimeout = jiffies;
 
 	if (priv->bInP2PlistenState == false) {
-		/* Bug 5504: This is just to avoid connection failure when getting stuck when the supplicant
-		 *                      considers the driver falsely that it is in Listen state */
 		cfg80211_remain_on_channel_expired(priv->wdev,
 						   priv->strRemainOnChanParams.u64ListenCookie,
 						   priv->strRemainOnChanParams.pstrListenChan,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ca95728..90fe1e2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -188,7 +188,7 @@ typedef struct {
 	unsigned char eth_src_address[NUM_CONCURRENT_IFC][6];
 	/* unsigned char eth_dst_address[6]; */
 
-	const struct firmware *wilc_firmware; /* Bug 4703 */
+	const struct firmware *wilc_firmware;
 
 	struct net_device *real_ndev;
 #ifdef WILC_SDIO
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 82b32a9..ba502f1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -547,7 +547,6 @@ static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size, wi
 	return p->txq_entries;
 }
 
-/*Bug3959: transmitting mgmt frames received from host*/
 int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_complete_func_t func)
 {
 
@@ -870,9 +869,6 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 				if (tqe->type == WILC_CFG_PKT) {
 					vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
 				}
-				/*Bug3959: transmitting mgmt frames received from host*/
-				/*vmm_sz will only be equal to tqe->buffer_size + 4 bytes (HOST_HDR_OFFSET)*/
-				/* in other cases WILC_MGMT_PKT and WILC_DATA_PKT_MAC_HDR*/
 				else if (tqe->type == WILC_NET_PKT) {
 					vmm_sz = ETH_ETHERNET_HDR_OFFSET;
 				}
@@ -959,7 +955,7 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 			/**
 			 * write to vmm table
 			 **/
-			ret = p->hif_func.hif_block_tx(WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4)); /* Bug 4477 fix */
+			ret = p->hif_func.hif_block_tx(WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4));
 			if (!ret) {
 				wilc_debug(N_ERR, "ERR block TX of VMM table.\n");
 				break;
@@ -1057,8 +1053,6 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 				vmm_sz = (vmm_table[i] & 0x3ff);        /* in word unit */
 				vmm_sz *= 4;
 				header = (tqe->type << 31) | (tqe->buffer_size << 15) | vmm_sz;
-				/*Bug3959: transmitting mgmt frames received from host*/
-				/*setting bit 30 in the host header to indicate mgmt frame*/
 				if (tqe->type == WILC_MGMT_PKT)
 					header |= (1 << 30);
 				else
@@ -1071,9 +1065,6 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 				if (tqe->type == WILC_CFG_PKT) {
 					buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
 				}
-				/*Bug3959: transmitting mgmt frames received from host*/
-				/*buffer offset = HOST_HDR_OFFSET in other cases: WILC_MGMT_PKT*/
-				/* and WILC_DATA_PKT_MAC_HDR*/
 				else if (tqe->type == WILC_NET_PKT) {
 					char *pBSSID = ((struct tx_complete_data *)(tqe->priv))->pBssid;
 
@@ -1434,7 +1425,7 @@ static int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 	u8 *dma_buffer;
 	int ret = 0;
 
-	blksz = (1ul << 12); /* Bug 4703: 4KB Good enough size for most platforms = PAGE_SIZE. */
+	blksz = (1ul << 12);
 	/* Allocate a DMA coherent  buffer. */
 
 	dma_buffer = kmalloc(blksz, GFP_KERNEL);
@@ -1685,9 +1676,6 @@ static int wilc_wlan_stop(void)
 
 	} while (timeout);
 #if 1
-/******************************************************************************/
-/* This was add at Bug 4595 to reset the chip while maintaining the bus state */
-/******************************************************************************/
 	reg = ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 3) | (1 << 8) | (1 << 9) | (1 << 26) | (1 << 29) | (1 << 30) | (1 << 31)); /**/
 	/**/
 	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);                                 /**/
@@ -2106,7 +2094,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	oup->wlan_cfg_get = wilc_wlan_cfg_get;
 	oup->wlan_cfg_get_value = wilc_wlan_cfg_get_val;
 
-	/*Bug3959: transmitting mgmt frames received from host*/
 	oup->wlan_add_mgmt_to_tx_que = wilc_wlan_txq_add_mgmt_pkt;
 
 	if (!init_chip()) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 9f05b79..60da18c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -22,7 +22,6 @@
 #define ETH_ETHERNET_HDR_OFFSET   (MAX_MAC_HDR_LEN + SUB_MSDU_HEADER_LENGTH + \
 				   SNAP_HDR_LEN - ETHERNET_HDR_LEN + WORD_ALIGNMENT_PAD)
 
-/*Bug3959: transmitting mgmt frames received from host*/
 #define HOST_HDR_OFFSET		4
 #define ETHERNET_HDR_LEN          14
 #define IP_HDR_LEN                20
@@ -104,8 +103,8 @@
 #define WILC_AHB_DATA_MEM_BASE 0x30000
 #define WILC_AHB_SHARE_MEM_BASE 0xd0000
 
-#define WILC_VMM_TBL_RX_SHADOW_BASE WILC_AHB_SHARE_MEM_BASE /* Bug 4477 fix */
-#define WILC_VMM_TBL_RX_SHADOW_SIZE (256) /* Bug 4477 fix */
+#define WILC_VMM_TBL_RX_SHADOW_BASE WILC_AHB_SHARE_MEM_BASE
+#define WILC_VMM_TBL_RX_SHADOW_SIZE (256)
 
 #define WILC_GP_REG_0   0x149c
 #define WILC_GP_REG_1   0x14a0
@@ -137,7 +136,6 @@
  ********************************************/
 #define WILC_CFG_PKT	1
 #define WILC_NET_PKT 0
-/*Bug3959: transmitting mgmt frames received from host*/
 #define WILC_MGMT_PKT 2
 
 #define WILC_CFG_SET 1
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 473d756..ce16775 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -541,7 +541,6 @@ static int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp)
 		break;
 
 #endif
-/*bug3819:*/
 	case 'S':
 		PRINT_INFO(RX_DBG, "Scan Notification Received\n");
 		host_int_ScanCompleteReceived(frame - 4, size + 4);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 0e2937b..5f68b6a 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -11,7 +11,6 @@
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
 
-/*bug 3887: [AP] Allow Management frames to be passed to the host*/
 /* #define MEMORY_STATIC */
 /* #define USE_OLD_SPI_SW */
 
@@ -171,7 +170,6 @@ typedef struct {
 	int (*wlan_cfg_set)(int, u32, u8 *, u32, int, u32);
 	int (*wlan_cfg_get)(int, u32, int, u32);
 	int (*wlan_cfg_get_value)(u32, u8 *, u32);
-	/*Bug3959: transmitting mgmt frames received from host*/
 	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
 } wilc_wlan_oup_t;
 
@@ -235,7 +233,6 @@ typedef enum {
 #define MAC_CONNECTED    1
 #define MAC_DISCONNECTED 0
 
-/*bug3819: */
 #define SCAN_DONE		TRUE
 typedef enum {
 	PASSIVE_SCAN = 0,
@@ -756,7 +753,6 @@ typedef enum {
 
 	/* Custom Character WID list */
 	WID_PC_TEST_MODE          = 0x00C8,
-	/*bug3819: */
 	/* SCAN Complete notification WID*/
 	WID_SCAN_COMPLETE		= 0x00C9,
 
-- 
2.5.1

