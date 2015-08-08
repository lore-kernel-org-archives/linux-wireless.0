Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36492 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819AbbHHMMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 08:12:50 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 4/4] staging: wilc1000: Remove braces for single statement 'if' and 'else'
Date: Sat,  8 Aug 2015 17:41:36 +0530
Message-Id: <1439035896-15213-5-git-send-email-csgorentla@gmail.com> (sfid-20150808_141421_764406_453F271D)
In-Reply-To: <1439035896-15213-4-git-send-email-csgorentla@gmail.com>
References: <1439035896-15213-1-git-send-email-csgorentla@gmail.com>
 <1439035896-15213-2-git-send-email-csgorentla@gmail.com>
 <1439035896-15213-3-git-send-email-csgorentla@gmail.com>
 <1439035896-15213-4-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the checkpatch.pl warning - braces {} are not necessary for any arm
of this statement

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       | 10 ++++-----
 drivers/staging/wilc1000/host_interface.c         | 19 ++++++++---------
 drivers/staging/wilc1000/linux_wlan.c             | 25 +++++++++--------------
 drivers/staging/wilc1000/wilc_debugfs.c           | 10 ++++-----
 drivers/staging/wilc1000/wilc_memory.c            |  5 ++---
 drivers/staging/wilc1000/wilc_spi.c               | 15 ++++++--------
 drivers/staging/wilc1000/wilc_strutils.c          |  5 ++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 20 ++++++++----------
 drivers/staging/wilc1000/wilc_wlan.c              | 20 ++++++++----------
 9 files changed, 52 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 93942b2..72ff7d4 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -706,11 +706,10 @@ u8 *get_tim_elm(u8 *pu8msa, u16 u16RxLen, u16 u16TagParamOffset)
 
 	/* Search for the TIM Element Field and return if the element is found */
 	while (u16index < (u16RxLen - FCS_LEN)) {
-		if (pu8msa[u16index] == ITIM) {
+		if (pu8msa[u16index] == ITIM)
 			return &pu8msa[u16index];
-		} else {
+		else
 			u16index += (IE_HDR_LEN + pu8msa[u16index + 1]);
-		}
 	}
 
 	return 0;
@@ -1527,11 +1526,10 @@ s32 further_process_response(u8 *resp,
 	u8 cfg_str[256] = {0};
 	tenuWIDtype enuWIDtype = WID_UNDEF;
 
-	if (process_wid_num) {
+	if (process_wid_num)
 		enuWIDtype = get_wid_type(g_wid_num);
-	} else {
+	else
 		enuWIDtype = gastrWIDs[cnt].enuWIDtype;
-	}
 
 
 	switch (enuWIDtype) {
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8b36683..cc549c2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1350,11 +1350,10 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 	/*keep the state as is , no need to change it*/
 	/* gWFiDrvHandle->enuHostIFstate = HOST_IF_SCANNING; */
 
-	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
+	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED)
 		gbScanWhileConnected = true;
-	} else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)	  {
+	else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)
 		gbScanWhileConnected = false;
-	}
 
 	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
 
@@ -2849,11 +2848,10 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			 * |------------|---------|-------|------------|---------------|----------------|
 			 |	6 bytes	 | 8 byte  |1 byte |  1 byte	|   16 bytes	|	  8 bytes	 |*/
 
-			if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
+			if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED)
 				WILC_memcpy(pu8keybuf, pstrWFIDrv->au8AssociatedBSSID, ETH_ALEN);
-			} else {
+			else
 				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
-			}
 
 			WILC_memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq, 8);
 
@@ -4024,11 +4022,10 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 
 	strWID.u16WIDid = (u16)WID_POWER_MANAGEMENT;
 
-	if (strPowerMgmtParam->bIsEnabled == true)	{
+	if (strPowerMgmtParam->bIsEnabled == true)
 		s8PowerMode = MIN_FAST_PS;
-	} else {
+	else
 		s8PowerMode = NO_POWERSAVE;
-	}
 	PRINT_D(HOSTINF_DBG, "Handling power mgmt to %d\n", s8PowerMode);
 	strWID.ps8WidVal = &s8PowerMode;
 	strWID.s32ValueSize = sizeof(char);
@@ -5479,9 +5476,9 @@ s32 host_int_set_join_req(WILC_WFIDrvHandle hWFIDrv, u8 *pu8bssid,
 		WILC_memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
-	if (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTING) {
+	if (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTING)
 		pstrWFIDrv->enuHostIFstate = HOST_IF_CONNECTING;
-	} else
+	else
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", pstrWFIDrv->enuHostIFstate);
 
 	/* send the message */
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 92aa671..1384846 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -422,11 +422,10 @@ static void isr_bh_routine(struct work_struct *work)
 
 	int_rcvdB++;
 	PRINT_D(INT_DBG, "Interrupt received BH\n");
-	if (g_linux_wlan->oup.wlan_handle_rx_isr != 0) {
+	if (g_linux_wlan->oup.wlan_handle_rx_isr != 0)
 		g_linux_wlan->oup.wlan_handle_rx_isr();
-	} else {
+	else
 		PRINT_ER("wlan_handle_rx_isr() hasn't been initialized\n");
-	}
 
 #if (RX_BH_TYPE == RX_BH_THREADED_IRQ)
 	return IRQ_HANDLED;
@@ -450,11 +449,10 @@ static int isr_bh_routine(void *vp)
 		}
 		int_rcvdB++;
 		PRINT_D(INT_DBG, "Interrupt received BH\n");
-		if (g_linux_wlan->oup.wlan_handle_rx_isr != 0) {
+		if (g_linux_wlan->oup.wlan_handle_rx_isr != 0)
 			g_linux_wlan->oup.wlan_handle_rx_isr();
-		} else {
+		else
 			PRINT_ER("wlan_handle_rx_isr() hasn't been initialized\n");
-		}
 	}
 
 	return 0;
@@ -607,22 +605,20 @@ static int linux_wlan_lock_timeout(void *vp, u32 timeout)
 {
 	int error = -1;
 	PRINT_D(LOCK_DBG, "Locking %p\n", vp);
-	if (vp != NULL)	{
+	if (vp != NULL)
 		error = down_timeout((struct semaphore *)vp, msecs_to_jiffies(timeout));
-	} else {
+	else
 		PRINT_ER("Failed, mutex is NULL\n");
-	}
 	return error;
 }
 
 void linux_wlan_unlock(void *vp)
 {
 	PRINT_D(LOCK_DBG, "Unlocking %p\n", vp);
-	if (vp != NULL)	{
+	if (vp != NULL)
 		up((struct semaphore *)vp);
-	} else {
+	else
 		PRINT_ER("Failed, mutex is NULL\n");
-	}
 }
 
 static void linux_wlan_init_mutex(char *lockName, void *plock, int count)
@@ -2125,11 +2121,10 @@ static void linux_wlan_tx_complete(void *priv, int status)
 {
 
 	struct tx_complete_data *pv_data = (struct tx_complete_data *)priv;
-	if (status == 1) {
+	if (status == 1)
 		PRINT_D(TX_DBG, "Packet sent successfully - Size = %d - Address = %p - SKB = %p\n", pv_data->size, pv_data->buff, pv_data->skb);
-	} else {
+	else
 		PRINT_D(TX_DBG, "Couldn't send packet - Size = %d - Address = %p - SKB = %p\n", pv_data->size, pv_data->buff, pv_data->skb);
-	}
 	/* Free the SK Buffer, its work is done */
 	dev_kfree_skb(pv_data->skb);
 	linux_wlan_free(pv_data);
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index c328208..be2e901 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -62,11 +62,10 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char *buf, size_t
 
 	flag = buffer[0] - '0';
 
-	if (flag > 0) {
+	if (flag > 0)
 		flag = DEBUG | ERR;
-	} else if (flag < 0) {
+	else if (flag < 0)
 		flag = 100;
-	}
 
 	if (flag > DBG_LEVEL_ALL) {
 		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&DEBUG_LEVEL));
@@ -75,11 +74,10 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char *buf, size_t
 
 	atomic_set(&DEBUG_LEVEL, (int)flag);
 
-	if (flag == 0) {
+	if (flag == 0)
 		printk("Debug-level disabled\n");
-	} else {
+	else
 		printk("Debug-level enabled\n");
-	}
 	return count;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_memory.c b/drivers/staging/wilc1000/wilc_memory.c
index c70707f..34ef13e 100644
--- a/drivers/staging/wilc1000/wilc_memory.c
+++ b/drivers/staging/wilc1000/wilc_memory.c
@@ -9,11 +9,10 @@
 void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
 		       char *pcFileName, u32 u32LineNo)
 {
-	if (u32Size > 0) {
+	if (u32Size > 0)
 		return kmalloc(u32Size, GFP_ATOMIC);
-	} else {
+	else
 		return NULL;
-	}
 }
 
 /*!
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index abea5df..1bf7d31 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -374,11 +374,10 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 		return result;
 	}
 
-	if (!g_spi.crc_off) {
+	if (!g_spi.crc_off)
 		wb[len - 1] = (crc7(0x7f, (const uint8_t *)&wb[0], len - 1)) << 1;
-	} else {
+	else
 		len -= 1;
-	}
 
 #define NUM_SKIP_BYTES (1)
 #define NUM_RSP_BYTES (2)
@@ -522,11 +521,10 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 			if (sz > 0) {
 				int nbytes;
 
-				if (sz <= (DATA_PKT_SZ - ix)) {
+				if (sz <= (DATA_PKT_SZ - ix))
 					nbytes = sz;
-				} else {
+				else
 					nbytes = DATA_PKT_SZ - ix;
-				}
 
 				/**
 				 * Read bytes
@@ -557,11 +555,10 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 			while (sz > 0) {
 				int nbytes;
 
-				if (sz <= DATA_PKT_SZ) {
+				if (sz <= DATA_PKT_SZ)
 					nbytes = sz;
-				} else {
+				else
 					nbytes = DATA_PKT_SZ;
-				}
 
 				/**
 				 * read data response only on the next DMA cycles not
diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index 3600706..a32b9c1 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -41,11 +41,10 @@ s32 WILC_strncmp(const char *pcStr1, const char *pcStr2,
 		s32Result = 1;
 	} else {
 		s32Result = strncmp(pcStr1, pcStr2, u32Count);
-		if (s32Result < 0) {
+		if (s32Result < 0)
 			s32Result = -1;
-		} else if (s32Result > 0)    {
+		else if (s32Result > 0)
 			s32Result = 1;
-		}
 	}
 
 	return s32Result;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index cbfb207..da2f475 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -443,11 +443,10 @@ static void CfgScanResult(tenuScanEvent enuScanEvent, tstrNetworkInfo *pstrNetwo
 			PRINT_D(CFG80211_DBG, "Refreshing Scan ...\n");
 			refresh_scan(priv, 1, false);
 
-			if (priv->u32RcvdChCount > 0) {
+			if (priv->u32RcvdChCount > 0)
 				PRINT_D(CFG80211_DBG, "%d Network(s) found\n", priv->u32RcvdChCount);
-			} else {
+			else
 				PRINT_D(CFG80211_DBG, "No networks found\n");
-			}
 
 			down(&(priv->hSemScanReq));
 
@@ -1685,11 +1684,10 @@ static int WILC_WFI_get_station(struct wiphy *wiphy, struct net_device *dev,
 		sinfo->txrate.legacy = strStatistics.u8LinkSpeed * 10;
 
 #ifdef TCP_ENHANCEMENTS
-		if ((strStatistics.u8LinkSpeed > TCP_ACK_FILTER_LINK_SPEED_THRESH) && (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED)) {
+		if ((strStatistics.u8LinkSpeed > TCP_ACK_FILTER_LINK_SPEED_THRESH) && (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED))
 			Enable_TCP_ACK_Filter(true);
-		} else if (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED)   {
+		else if (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED)
 			Enable_TCP_ACK_Filter(false);
-		}
 #endif
 
 		PRINT_D(CORECONFIG_DBG, "*** stats[%d][%d][%d][%d][%d]\n", sinfo->signal, sinfo->rx_packets, sinfo->tx_packets,
@@ -2058,11 +2056,10 @@ void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 		}
 		#endif  /* USE_SUPPLICANT_GO_INTENT */
 
-		if (buf[index] ==  CHANLIST_ATTR_ID) {
+		if (buf[index] ==  CHANLIST_ATTR_ID)
 			channel_list_attr_index = index;
-		} else if (buf[index] ==  OPERCHAN_ATTR_ID)   {
+		else if (buf[index] ==  OPERCHAN_ATTR_ID)
 			op_channel_attr_index = index;
-		}
 		index += buf[index + 1] + 3; /* ID,Length byte */
 	}
 
@@ -2144,11 +2141,10 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 		}
 		#endif
 
-		if (buf[index] ==  CHANLIST_ATTR_ID) {
+		if (buf[index] ==  CHANLIST_ATTR_ID)
 			channel_list_attr_index = index;
-		} else if (buf[index] ==  OPERCHAN_ATTR_ID)   {
+		else if (buf[index] ==  OPERCHAN_ATTR_ID)
 			op_channel_attr_index = index;
-		}
 		index += buf[index + 1] + 3; /* ID,Length byte */
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index bd5c256..192f36c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -463,11 +463,10 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 	Pending_Acks = 0;
 	Opened_TCP_session = 0;
 
-	if (PendingAcks_arrBase == 0) {
+	if (PendingAcks_arrBase == 0)
 		PendingAcks_arrBase = MAX_TCP_SESSION;
-	} else {
+	else
 		PendingAcks_arrBase = 0;
-	}
 
 
 	p->os_func.os_spin_unlock(p->txq_spinlock, &p->txq_spinlock_flags);
@@ -1110,11 +1109,10 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 				/*Bug3959: transmitting mgmt frames received from host*/
 				/*setting bit 30 in the host header to indicate mgmt frame*/
 #ifdef WILC_AP_EXTERNAL_MLME
-				if (tqe->type == WILC_MGMT_PKT)	{
+				if (tqe->type == WILC_MGMT_PKT)
 					header |= (1 << 30);
-				} else {
+				else
 					header &= ~(1 << 30);
-				}
 #endif
 
 #ifdef BIG_ENDIAN
@@ -1541,11 +1539,10 @@ static int wilc_wlan_firmware_download(const uint8_t *buffer, uint32_t buffer_si
 		acquire_bus(ACQUIRE_ONLY);
 		offset += 8;
 		while (((int)size) && (offset < buffer_size)) {
-			if (size <= blksz) {
+			if (size <= blksz)
 				size2 = size;
-			} else {
+			else
 				size2 = blksz;
-			}
 			/* Copy firmware into a DMA coherent buffer */
 			memcpy(dma_buffer, &buffer[offset], size2);
 			ret = p->hif_func.hif_block_tx(addr, dma_buffer, size2);
@@ -2302,11 +2299,10 @@ u16 Set_machw_change_vir_if(bool bValue)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
 	}
 
-	if (bValue) {
+	if (bValue)
 		reg |= (BIT31);
-	} else {
+	else
 		reg &= ~(BIT31);
-	}
 
 	ret = (&g_wlan)->hif_func.hif_write_reg(WILC_CHANGING_VIR_IF, reg);
 
-- 
2.5.0

