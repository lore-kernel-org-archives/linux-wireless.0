Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35269 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbbHROSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 10:18:18 -0400
Received: by pacgr6 with SMTP id gr6so133817302pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 07:18:17 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] staging: wilc1000: add a blank line after declaration
Date: Tue, 18 Aug 2015 23:18:11 +0900
Message-Id: <1439907491-14982-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150818_161822_489862_9A11A133)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a blank line after declaration found by checkpatch.pl
WARNING: Missing a blank line after declarations.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  8 ++++++++
 drivers/staging/wilc1000/linux_wlan.c             | 18 ++++++++++++++++++
 drivers/staging/wilc1000/linux_wlan_sdio.c        |  1 +
 drivers/staging/wilc1000/linux_wlan_spi.c         |  6 ++++++
 drivers/staging/wilc1000/wilc_msgqueue.c          |  3 +++
 drivers/staging/wilc1000/wilc_spi.c               |  4 ++++
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 20 ++++++++++++++++++++
 drivers/staging/wilc1000/wilc_wlan.c              | 13 +++++++++++++
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  3 +++
 9 files changed, 76 insertions(+)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 16a0abc..1889195 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -668,6 +668,7 @@ INLINE u16 get_asoc_id(u8 *data)
 s32 CoreConfiguratorInit(void)
 {
 	s32 s32Error = WILC_SUCCESS;
+
 	PRINT_D(CORECONFIG_DBG, "CoreConfiguratorInit()\n");
 
 	sema_init(&SemHandleSendPkt, 1);
@@ -1097,6 +1098,7 @@ void ProcessCharWid(char *pcPacket, s32 *ps32PktLen,
 	u8 *pu8val = (u8 *)ps8WidVal;
 	u8 u8val = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set CHAR val 0x%x ,NULL structure\n", u8val);
 		return;
@@ -1151,6 +1153,7 @@ void ProcessShortWid(char *pcPacket, s32 *ps32PktLen,
 	u16 *pu16val = (u16 *)ps8WidVal;
 	u16 u16val = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set SHORT val 0x%x ,NULL structure\n", u16val);
 		return;
@@ -1206,6 +1209,7 @@ void ProcessIntWid(char *pcPacket, s32 *ps32PktLen,
 	u32 *pu32val = (u32 *)ps8WidVal;
 	u32 u32val = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set INT val 0x%x , NULL structure\n", u32val);
 		return;
@@ -1322,6 +1326,7 @@ void ProcessStrWid(char *pcPacket, s32 *ps32PktLen,
 	u16 u16MsgLen = 0;
 	u16 idx    = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set STR val, NULL structure\n");
 		return;
@@ -1540,6 +1545,7 @@ s32 further_process_response(u8 *resp,
 	case WID_SHORT:
 	{
 		u16 *pu16val = (u16 *)(pstrWIDresult->ps8WidVal);
+
 		cfg_sht = MAKE_WORD16(resp[idx], resp[idx + 1]);
 		/*Set local copy of WID*/
 		/* pstrWIDresult->ps8WidVal = (s8*)(s32)cfg_sht; */
@@ -1550,6 +1556,7 @@ s32 further_process_response(u8 *resp,
 	case WID_INT:
 	{
 		u32 *pu32val = (u32 *)(pstrWIDresult->ps8WidVal);
+
 		cfg_int = MAKE_WORD32(
 				MAKE_WORD16(resp[idx], resp[idx + 1]),
 				MAKE_WORD16(resp[idx + 2], resp[idx + 3])
@@ -1980,6 +1987,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
 {
 	s32 counter = 0, ret = 0;
+
 	if (gpstrWlanOps == NULL) {
 		PRINT_D(CORECONFIG_DBG, "Net Dev is still not initialized\n");
 		return 1;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b3cc9f5..888652d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -194,6 +194,7 @@ static char *ps8current = DebugBuffer;
 void printk_later(const char *format, ...)
 {
 	va_list args;
+
 	va_start(args, format);
 	ps8current += vsprintf(ps8current, format, args);
 	va_end(args);
@@ -402,11 +403,13 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 irqreturn_t isr_bh_routine(int irq, void *userdata)
 {
 	linux_wlan_t *nic;
+
 	nic = (linux_wlan_t *)userdata;
 #else
 static void isr_bh_routine(struct work_struct *work)
 {
 	perInterface_wlan_t *nic;
+
 	nic = (perInterface_wlan_t *)container_of(work, linux_wlan_t, rx_work_queue);
 #endif
 
@@ -531,6 +534,7 @@ static void linux_wlan_msleep(uint32_t msc)
 {
 	if (msc <= 4000000) {
 		u32 u32Temp = msc * 1000;
+
 		usleep_range(u32Temp, u32Temp);
 	} else {
 		msleep(msc);
@@ -549,6 +553,7 @@ static void linux_wlan_dbg(uint8_t *buff)
 static void *linux_wlan_malloc_atomic(uint32_t sz)
 {
 	char *pntr = NULL;
+
 	pntr = kmalloc(sz, GFP_ATOMIC);
 	PRINT_D(MEM_DBG, "Allocating %d bytes at address %p\n", sz, pntr);
 	return (void *)pntr;
@@ -557,6 +562,7 @@ static void *linux_wlan_malloc_atomic(uint32_t sz)
 static void *linux_wlan_malloc(uint32_t sz)
 {
 	char *pntr = NULL;
+
 	pntr = kmalloc(sz, GFP_KERNEL);
 	PRINT_D(MEM_DBG, "Allocating %d bytes at address %p\n", sz, pntr);
 	return (void *)pntr;
@@ -573,6 +579,7 @@ void linux_wlan_free(void *vp)
 static void *internal_alloc(uint32_t size, uint32_t flag)
 {
 	char *pntr = NULL;
+
 	pntr = kmalloc(size, flag);
 	PRINT_D(MEM_DBG, "Allocating %d bytes at address %p\n", size, pntr);
 	return (void *)pntr;
@@ -604,6 +611,7 @@ static void linux_wlan_lock(void *vp)
 static int linux_wlan_lock_timeout(void *vp, u32 timeout)
 {
 	int error = -1;
+
 	PRINT_D(LOCK_DBG, "Locking %p\n", vp);
 	if (vp != NULL)
 		error = down_timeout((struct semaphore *)vp, msecs_to_jiffies(timeout));
@@ -681,6 +689,7 @@ static void linux_wlan_deinit_spin_lock(void *plock)
 static void linux_wlan_spin_lock(void *vp, unsigned long *flags)
 {
 	unsigned long lflags;
+
 	PRINT_D(SPIN_DEBUG, "Lock spin %p\n", vp);
 	if (vp != NULL) {
 		spin_lock_irqsave((spinlock_t *)vp, lflags);
@@ -692,6 +701,7 @@ static void linux_wlan_spin_lock(void *vp, unsigned long *flags)
 static void linux_wlan_spin_unlock(void *vp, unsigned long *flags)
 {
 	unsigned long lflags = *flags;
+
 	PRINT_D(SPIN_DEBUG, "Unlock spin %p\n", vp);
 	if (vp != NULL) {
 		spin_unlock_irqrestore((spinlock_t *)vp, lflags);
@@ -1535,6 +1545,7 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
 {
 
 	int ret = 0;
+
 	PRINT_D(INIT_DBG, "Initializing Threads ...\n");
 
 #if (RX_BH_TYPE == RX_BH_WORK_QUEUE)
@@ -1709,6 +1720,7 @@ extern void wilc_wlan_global_reset(void);
 uint8_t wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi,	wilc_wlan_oup_t *nwo, linux_wlan_t *nic)
 {
 	uint8_t trials = 0;
+
 	while ((core_11b_ready() && (READY_CHECK_THRESHOLD > (trials++)))) {
 		PRINT_D(INIT_DBG, "11b core not ready yet: %u\n", trials);
 		wilc_wlan_deinit(nic);
@@ -1743,6 +1755,7 @@ int repeat_power_cycle(perInterface_wlan_t *nic)
 	int ret = 0;
 	wilc_wlan_inp_t nwi;
 	wilc_wlan_oup_t nwo;
+
 	sdio_unregister_driver(&wilc_bus);
 
 	linux_wlan_device_detection(0);
@@ -1880,6 +1893,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		if (g_linux_wlan->oup.wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
 			int size;
 			char Firmware_ver[20];
+
 			size = g_linux_wlan->oup.wlan_cfg_get_value(
 					WID_FIRMWARE_VERSION,
 					Firmware_ver, sizeof(Firmware_ver));
@@ -2039,6 +2053,7 @@ int mac_open(struct net_device *ndev)
 {
 
 	linux_wlan_t *nic;
+
 	nic = netdev_priv(ndev);
 
 	/*initialize platform*/
@@ -2069,6 +2084,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 	struct WILC_WFI_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	int i = 0;
+
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
 
@@ -2120,6 +2136,7 @@ static void linux_wlan_tx_complete(void *priv, int status)
 {
 
 	struct tx_complete_data *pv_data = (struct tx_complete_data *)priv;
+
 	if (status == 1)
 		PRINT_D(TX_DBG, "Packet sent successfully - Size = %d - Address = %p - SKB = %p\n", pv_data->size, pv_data->buff, pv_data->skb);
 	else
@@ -2137,6 +2154,7 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	char *pu8UdpBuffer;
 	struct iphdr *ih;
 	struct ethhdr *eth_h;
+
 	nic = netdev_priv(ndev);
 
 	PRINT_D(INT_DBG, "\n========\n IntUH: %d - IntBH: %d - IntCld: %d\n========\n", int_rcvdU, int_rcvdB, int_clrd);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 37f31f4..62e6b62 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -194,6 +194,7 @@ void disable_sdio_interrupt(void)
 static int linux_sdio_set_speed(int speed)
 {
 	struct mmc_ios ios;
+
 	sdio_claim_host(local_sdio_func);
 
 	memcpy((void *)&ios, (void *)&local_sdio_func->card->host->ios, sizeof(struct mmc_ios));
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 236669c..c5cdab7 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -122,6 +122,7 @@ int linux_spi_write(uint8_t *b, uint32_t len)
 
 	if (len > 0 && b != NULL) {
 		struct spi_message msg;
+
 		PRINT_D(BUS_DBG, "Request writing %d bytes\n", len);
 		struct spi_transfer tr = {
 			.tx_buf = b,
@@ -155,12 +156,14 @@ int linux_spi_write(uint8_t *b, uint32_t len)
 int linux_spi_write(uint8_t *b, uint32_t len)
 {
 	int ret;
+
 	if (len > 0 && b != NULL) {
 		int i = 0;
 		int blk = len / TXRX_PHASE_SIZE;
 		int remainder = len % TXRX_PHASE_SIZE;
 
 		char *r_buffer = kzalloc(TXRX_PHASE_SIZE, GFP_KERNEL);
+
 		if (!r_buffer) {
 			PRINT_ER("Failed to allocate memory for r_buffer\n");
 		}
@@ -243,6 +246,7 @@ int linux_spi_write(uint8_t *b, uint32_t len)
 			.delay_usecs = 0,
 		};
 		char *r_buffer = kzalloc(len, GFP_KERNEL);
+
 		if (!r_buffer) {
 			PRINT_ER("Failed to allocate memory for r_buffer\n");
 		}
@@ -324,6 +328,7 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 		int remainder = rlen % TXRX_PHASE_SIZE;
 
 		char *t_buffer = kzalloc(TXRX_PHASE_SIZE, GFP_KERNEL);
+
 		if (!t_buffer) {
 			PRINT_ER("Failed to allocate memory for t_buffer\n");
 		}
@@ -403,6 +408,7 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 
 		};
 		char *t_buffer = kzalloc(rlen, GFP_KERNEL);
+
 		if (!t_buffer) {
 			PRINT_ER("Failed to allocate memory for t_buffer\n");
 		}
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 70e4fa6..f047d62 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -37,6 +37,7 @@ WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
 
 	while (pHandle->pstrMessageList != NULL) {
 		Message *pstrMessge = pHandle->pstrMessageList->pstrNext;
+
 		kfree(pHandle->pstrMessageList);
 		pHandle->pstrMessageList = pstrMessge;
 	}
@@ -82,6 +83,7 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 		pHandle->pstrMessageList  = pstrMessage;
 	} else {
 		Message *pstrTailMsg = pHandle->pstrMessageList;
+
 		while (pstrTailMsg->pstrNext != NULL) {
 			pstrTailMsg = pstrTailMsg->pstrNext;
 		}
@@ -122,6 +124,7 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 	Message *pstrMessage;
 	WILC_ErrNo s32RetStatus = WILC_SUCCESS;
 	unsigned long flags;
+
 	if ((pHandle == NULL) || (u32RecvBufferSize == 0)
 	    || (pvRecvBuffer == NULL) || (pu32ReceivedLength == NULL)) {
 		WILC_ERRORREPORT(s32RetStatus, WILC_INVALID_ARGUMENT);
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 1bf7d31..d7bb204 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1023,6 +1023,7 @@ static int spi_read(uint32_t addr, uint8_t *buf, uint32_t size)
 static int spi_clear_int(void)
 {
 	uint32_t reg;
+
 	if (!spi_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
 		return 0;
@@ -1170,6 +1171,7 @@ static void spi_default_bus_speed(void)
 static int spi_read_size(uint32_t *size)
 {
 	int ret;
+
 	if (g_spi.has_thrpt_enh) {
 		ret = spi_internal_read(0xe840 - WILC_SPI_REG_BASE, size);
 		*size = *size  & IRQ_DMA_WD_CNT_MASK;
@@ -1197,6 +1199,7 @@ _fail_:
 static int spi_read_int(uint32_t *int_status)
 {
 	int ret;
+
 	if (g_spi.has_thrpt_enh) {
 		ret = spi_internal_read(0xe840 - WILC_SPI_REG_BASE, int_status);
 	} else {
@@ -1257,6 +1260,7 @@ static int spi_clear_int_ext(uint32_t val)
 		ret = spi_internal_write(0xe844 - WILC_SPI_REG_BASE, val);
 	} else {
 		uint32_t flags;
+
 		flags = val & ((1 << MAX_NUM_INT) - 1);
 		if (flags) {
 			int i;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a6edc97..ead1291 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -144,6 +144,7 @@ bool g_wep_keys_saved;
 void clear_shadow_scan(void *pUserVoid)
 {
 	int i;
+
 	if (op_ifcs == 0) {
 		del_timer_sync(&hAgingTimer);
 		PRINT_INFO(CORECONFIG_DBG, "destroy aging timer\n");
@@ -188,6 +189,7 @@ void refresh_scan(void *pUserVoid, uint8_t all, bool bDirectScan)
 
 	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
 		tstrNetworkInfo *pstrNetworkInfo;
+
 		pstrNetworkInfo = &(astrLastScannedNtwrksShadow[i]);
 
 
@@ -217,6 +219,7 @@ void refresh_scan(void *pUserVoid, uint8_t all, bool bDirectScan)
 void reset_shadow_found(void *pUserVoid)
 {
 	int i;
+
 	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
 		astrLastScannedNtwrksShadow[i].u8Found = 0;
 
@@ -226,6 +229,7 @@ void reset_shadow_found(void *pUserVoid)
 void update_scan_time(void *pUserVoid)
 {
 	int i;
+
 	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
 		astrLastScannedNtwrksShadow[i].u32TimeRcvdInScan = jiffies;
 	}
@@ -553,6 +557,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	#endif
 	u8 NullBssid[ETH_ALEN] = {0};
+
 	connecting = 0;
 
 	priv = (struct WILC_WFI_priv *)pUserVoid;
@@ -692,6 +697,7 @@ static int WILC_WFI_CfgSetChannel(struct wiphy *wiphy,
 	u32 channelnum = 0;
 	struct WILC_WFI_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
+
 	priv = wiphy_priv(wiphy);
 
 	channelnum = ieee80211_frequency_to_channel(chandef->chan->center_freq);
@@ -1075,6 +1081,7 @@ static int WILC_WFI_disconnect(struct wiphy *wiphy, struct net_device *dev, u16
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	#endif
 	uint8_t NullBssid[ETH_ALEN] = {0};
+
 	connecting = 0;
 	priv = wiphy_priv(wiphy);
 
@@ -1527,6 +1534,7 @@ static int WILC_WFI_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 	struct WILC_WFI_priv *priv;
 	struct  key_params key_params;
 	u32 i;
+
 	priv = wiphy_priv(wiphy);
 
 
@@ -1668,6 +1676,7 @@ static int WILC_WFI_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (nic->iftype == STATION_MODE) {
 		tstrStatistics strStatistics;
+
 		host_int_get_statistics(priv->hWILCWFIDrv, &strStatistics);
 
 		/*
@@ -2198,6 +2207,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, uint8_t *buff, uint32_t size)
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	u32 i = 0;
 	s32 s32Freq;
+
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
 
@@ -2333,6 +2343,7 @@ static void WILC_WFI_mgmt_tx_complete(void *priv, int status)
 static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 {
 	struct WILC_WFI_priv *priv;
+
 	priv = (struct WILC_WFI_priv *)pUserVoid;
 
 	PRINT_D(HOSTINF_DBG, "Remain on channel ready\n");
@@ -2359,6 +2370,7 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 {
 	struct WILC_WFI_priv *priv;
+
 	priv = (struct WILC_WFI_priv *)pUserVoid;
 
 	/*BugID_5477*/
@@ -2399,6 +2411,7 @@ static int  WILC_WFI_remain_on_channel(struct wiphy *wiphy,
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
+
 	priv = wiphy_priv(wiphy);
 
 	PRINT_D(GENERIC_DBG, "Remaining on channel %d\n", chan->hw_value);
@@ -2450,6 +2463,7 @@ static int   WILC_WFI_cancel_remain_on_channel(struct wiphy *wiphy,
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
+
 	priv = wiphy_priv(wiphy);
 
 	PRINT_D(CFG80211_DBG, "Cancel remain on channel\n");
@@ -2644,6 +2658,7 @@ int   WILC_WFI_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 {
 	struct WILC_WFI_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
+
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
 
@@ -2761,6 +2776,7 @@ static int WILC_WFI_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct WILC_WFI_priv *priv;
+
 	PRINT_D(CFG80211_DBG, "Dumping station information\n");
 
 	if (idx != 0)
@@ -2790,6 +2806,7 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			    bool enabled, int timeout)
 {
 	struct WILC_WFI_priv *priv;
+
 	PRINT_D(CFG80211_DBG, " Power save Enabled= %d , TimeOut = %d\n", enabled, timeout);
 
 	if (wiphy == NULL)
@@ -3416,6 +3433,7 @@ static int WILC_WFI_del_station(struct wiphy *wiphy, struct net_device *dev,
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
 	perInterface_wlan_t *nic;
+
 	WILC_NULLCHECK(s32Error, wiphy);
 
 	priv = wiphy_priv(wiphy);
@@ -3542,6 +3560,7 @@ struct wireless_dev *WILC_WFI_add_virt_intf(struct wiphy *wiphy, const char *nam
 	perInterface_wlan_t *nic;
 	struct WILC_WFI_priv *priv;
 	struct net_device *new_ifc = NULL;
+
 	priv = wiphy_priv(wiphy);
 
 
@@ -3864,6 +3883,7 @@ int WILC_WFI_DeInitHostInt(struct net_device *net)
 	s32 s32Error = WILC_SUCCESS;
 
 	struct WILC_WFI_priv *priv;
+
 	priv = wdev_priv(net->ieee80211_ptr);
 
 	priv->gbAutoRateAdjusted = false;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7c53a2b..c48fe4a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -188,6 +188,7 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	struct txq_entry_t *tqe;
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
+
 	p->os_func.os_spin_lock(p->txq_spinlock, &flags);
 	if (p->txq_head) {
 		tqe = p->txq_head;
@@ -368,6 +369,7 @@ static __inline int remove_TCP_related(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
+
 	p->os_func.os_spin_lock(p->txq_spinlock, &flags);
 
 	p->os_func.os_spin_unlock(p->txq_spinlock, &flags);
@@ -383,6 +385,7 @@ static __inline int tcp_process(struct txq_entry_t *tqe)
 	int i;
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
+
 	p->os_func.os_spin_lock(p->txq_spinlock, &flags);
 
 	eth_hdr_ptr = &buffer[0];
@@ -398,12 +401,14 @@ static __inline int tcp_process(struct txq_entry_t *tqe)
 		if (protocol == 0x06) {
 			uint8_t *tcp_hdr_ptr;
 			uint32_t IHL, Total_Length, Data_offset;
+
 			tcp_hdr_ptr = &ip_hdr_ptr[IP_HDR_LEN];
 			IHL = (ip_hdr_ptr[0] & 0xf) << 2;
 			Total_Length = (((uint32_t)ip_hdr_ptr[2]) << 8) + ((uint32_t)ip_hdr_ptr[3]);
 			Data_offset = (((uint32_t)tcp_hdr_ptr[12] & 0xf0) >> 2);
 			if (Total_Length == (IHL + Data_offset)) { /*we want to recognize the clear Acks(packet only carry Ack infos not with data) so data size must be equal zero*/
 				uint32_t seq_no, Ack_no;
+
 				seq_no	= (((uint32_t)tcp_hdr_ptr[4]) << 24) + (((uint32_t)tcp_hdr_ptr[5]) << 16) + (((uint32_t)tcp_hdr_ptr[6]) << 8) + ((uint32_t)tcp_hdr_ptr[7]);
 
 				Ack_no	= (((uint32_t)tcp_hdr_ptr[8]) << 24) + (((uint32_t)tcp_hdr_ptr[9]) << 16) + (((uint32_t)tcp_hdr_ptr[10]) << 8) + ((uint32_t)tcp_hdr_ptr[11]);
@@ -445,6 +450,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
 		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].Bigger_Ack_num) {
 			struct txq_entry_t *tqe;
+
 			PRINT_D(TCP_ENH, "DROP ACK: %u\n", Pending_Acks_info[i].ack_num);
 			tqe = Pending_Acks_info[i].txqe;
 			if (tqe) {
@@ -778,6 +784,7 @@ INLINE void chip_wakeup(void)
 		if (wilc_get_chipid(false) >= 0x1002b0) {
 			/* Enable PALDO back right after wakeup */
 			uint32_t val32;
+
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
 			val32 |= (1 << 6);
 			g_wlan.hif_func.hif_write_reg(0x1e1c, val32);
@@ -793,6 +800,7 @@ INLINE void chip_wakeup(void)
 INLINE void chip_wakeup(void)
 {
 	uint32_t reg, trials = 0;
+
 	do {
 		if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
 			g_wlan.hif_func.hif_read_reg(1, &reg);
@@ -833,6 +841,7 @@ INLINE void chip_wakeup(void)
 		if (wilc_get_chipid(false) >= 0x1002b0) {
 			/* Enable PALDO back right after wakeup */
 			uint32_t val32;
+
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
 			val32 |= (1 << 6);
 			g_wlan.hif_func.hif_write_reg(0x1e1c, val32);
@@ -885,6 +894,7 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 	int counter;
 	int timeout;
 	uint32_t vmm_table[WILC_VMM_TBL_SIZE];
+
 	p->txq_exit = 0;
 	do {
 		if (p->quit)
@@ -1125,6 +1135,7 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 				/* and WILC_DATA_PKT_MAC_HDR*/
 				else if (tqe->type == WILC_NET_PKT) {
 					char *pBSSID = ((struct tx_complete_data *)(tqe->priv))->pBssid;
+
 					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
 					/* copy the bssid at the sart of the buffer */
 					memcpy(&txb[offset + 4], pBSSID, 6);
@@ -1225,6 +1236,7 @@ static void wilc_wlan_handle_rxq(void)
 			uint32_t header;
 			uint32_t pkt_len, pkt_offset, tp_len;
 			int is_cfg_packet;
+
 			PRINT_D(RX_DBG, "In the 2nd do-while\n");
 			memcpy(&header, &buffer[offset], 4);
 #ifdef BIG_ENDIAN
@@ -1705,6 +1717,7 @@ void wilc_wlan_global_reset(void)
 {
 
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
+
 	acquire_bus(ACQUIRE_AND_WAKEUP);
 	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, 0x0);
 	release_bus(RELEASE_ONLY);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index e2842d3..c3f3aaf 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -342,6 +342,7 @@ static void wilc_wlan_parse_response_frame(uint8_t *info, int size)
 				if (g_cfg_str[i].id == wid) {
 					if (wid == WID_SITE_SURVEY_RESULTS) {
 						static int toggle;
+
 						PRINT_INFO(GENERIC_DBG, "Site survey results received[%d]\n",
 							   size);
 
@@ -483,9 +484,11 @@ static int wilc_wlan_cfg_get_wid_value(uint16_t wid, uint8_t *buffer, uint32_t b
 
 			if (g_cfg_str[i].id == wid) {
 				uint32_t size =  g_cfg_str[i].str[0];
+
 				if (buffer_size >= size) {
 					if (g_cfg_str[i].id == WID_SITE_SURVEY_RESULTS)	{
 						static int toggle;
+
 						PRINT_INFO(GENERIC_DBG, "Site survey results value[%d]\n",
 							   size);
 						i += toggle;
-- 
1.9.1

