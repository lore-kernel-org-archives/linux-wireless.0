Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36126 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbIOFHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:03 -0400
Received: by padhk3 with SMTP id hk3so164816249pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:02 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/18] staging: wilc1000: use u8 instead of uint8_t
Date: Tue, 15 Sep 2015 14:06:14 +0900
Message-Id: <1442293588-15323-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070728_999225_2A1EDE1A)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces uint8_t with u8 that is a preferred kernel type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         |   2 +-
 drivers/staging/wilc1000/linux_mon.c              |   2 +-
 drivers/staging/wilc1000/linux_wlan.c             |  30 ++--
 drivers/staging/wilc1000/linux_wlan_spi.c         |   4 +-
 drivers/staging/wilc1000/linux_wlan_spi.h         |   4 +-
 drivers/staging/wilc1000/wilc_sdio.c              |  24 +--
 drivers/staging/wilc1000/wilc_spi.c               | 178 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  14 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  10 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  58 +++----
 drivers/staging/wilc1000/wilc_wlan.h              |  32 ++--
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 118 +++++++-------
 drivers/staging/wilc1000/wilc_wlan_cfg.h          |   2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |  26 ++--
 15 files changed, 253 insertions(+), 253 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 59a1a9d..3bab93c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7460,7 +7460,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	return s32Error;
 }
 #endif /*WILC_AP_EXTERNAL_MLME*/
-uint32_t wilc_get_chipid(uint8_t);
+uint32_t wilc_get_chipid(u8);
 
 s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 6bee710..a38d293 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -54,7 +54,7 @@ u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 #define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
-void WILC_WFI_monitor_rx(uint8_t *buff, uint32_t size)
+void WILC_WFI_monitor_rx(u8 *buff, uint32_t size)
 {
 	uint32_t header, pkt_offset;
 	struct sk_buff *skb = NULL;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e95db24..f3036eb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -110,11 +110,11 @@ static struct semaphore close_exit_sync;
 
 static int wlan_deinit_locks(linux_wlan_t *nic);
 static void wlan_deinitialize_threads(linux_wlan_t *nic);
-extern void WILC_WFI_monitor_rx(uint8_t *buff, uint32_t size);
-extern void WILC_WFI_p2p_rx(struct net_device *dev, uint8_t *buff, uint32_t size);
+extern void WILC_WFI_monitor_rx(u8 *buff, uint32_t size);
+extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, uint32_t size);
 
 static void linux_wlan_tx_complete(void *priv, int status);
-void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset);
+void frmw_to_linux(u8 *buff, uint32_t size, uint32_t pkt_offset);
 static int  mac_init_fn(struct net_device *ndev);
 int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
 int  mac_open(struct net_device *ndev);
@@ -485,7 +485,7 @@ static void deinit_irq(linux_wlan_t *nic)
 /*
  *      OS functions
  */
-static void linux_wlan_dbg(uint8_t *buff)
+static void linux_wlan_dbg(u8 *buff)
 {
 	PRINT_D(INIT_DBG, "%d\n", *buff);
 }
@@ -529,9 +529,9 @@ static void linux_wlan_mac_indicate(int flag)
 
 }
 
-struct net_device *GetIfHandler(uint8_t *pMacHeader)
+struct net_device *GetIfHandler(u8 *pMacHeader)
 {
-	uint8_t *Bssid, *Bssid1;
+	u8 *Bssid, *Bssid1;
 	int i = 0;
 
 	Bssid  = pMacHeader + 10;
@@ -559,7 +559,7 @@ struct net_device *GetIfHandler(uint8_t *pMacHeader)
 	return NULL;
 }
 
-int linux_wlan_set_bssid(struct net_device *wilc_netdev, uint8_t *pBSSID)
+int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 {
 	int i = 0;
 	int ret = -1;
@@ -580,9 +580,9 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, uint8_t *pBSSID)
 /*Function to get number of connected interfaces*/
 int linux_wlan_get_num_conn_ifcs(void)
 {
-	uint8_t i = 0;
-	uint8_t null_bssid[6] = {0};
-	uint8_t ret_val = 0;
+	u8 i = 0;
+	u8 null_bssid[6] = {0};
+	u8 ret_val = 0;
 
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
 		if (memcmp(g_linux_wlan->strInterfaceInfo[i].aBSSID, null_bssid, 6))
@@ -1380,13 +1380,13 @@ static void wlan_deinitialize_threads(linux_wlan_t *nic)
 #ifdef COMPLEMENT_BOOT
 
 extern volatile int probe;
-extern uint8_t core_11b_ready(void);
+extern u8 core_11b_ready(void);
 
 #define READY_CHECK_THRESHOLD		30
 extern void wilc_wlan_global_reset(void);
-uint8_t wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi,	wilc_wlan_oup_t *nwo, linux_wlan_t *nic)
+u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi,	wilc_wlan_oup_t *nwo, linux_wlan_t *nic)
 {
-	uint8_t trials = 0;
+	u8 trials = 0;
 
 	while ((core_11b_ready() && (READY_CHECK_THRESHOLD > (trials++)))) {
 		PRINT_D(INIT_DBG, "11b core not ready yet: %u\n", trials);
@@ -1963,7 +1963,7 @@ done:
 	return s32Error;
 }
 
-void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
+void frmw_to_linux(u8 *buff, uint32_t size, uint32_t pkt_offset)
 {
 
 	unsigned int frame_len = 0;
@@ -2042,7 +2042,7 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 		#endif
 }
 
-void WILC_WFI_mgmt_rx(uint8_t *buff, uint32_t size)
+void WILC_WFI_mgmt_rx(u8 *buff, uint32_t size)
 {
 	int i = 0;
 	perInterface_wlan_t *nic;
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 3b3ba8a..d0802fd 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -115,7 +115,7 @@ int linux_spi_init(void *vp)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int linux_spi_write(uint8_t *b, uint32_t len)
+int linux_spi_write(u8 *b, uint32_t len)
 {
 	int ret;
 
@@ -194,7 +194,7 @@ int linux_spi_write(uint8_t *b, uint32_t len)
 }
 
 #else
-int linux_spi_write(uint8_t *b, uint32_t len)
+int linux_spi_write(u8 *b, uint32_t len)
 {
 
 	int ret;
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 0ecad47..2b52738 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -7,8 +7,8 @@ extern struct spi_driver wilc_bus;
 
 int linux_spi_init(void *vp);
 void linux_spi_deinit(void *vp);
-int linux_spi_write(uint8_t *b, uint32_t len);
-int linux_spi_read(uint8_t *rb, uint32_t rlen);
+int linux_spi_write(u8 *b, uint32_t len);
+int linux_spi_read(u8 *rb, uint32_t rlen);
 int linux_spi_write_read(unsigned char *wb, unsigned char *rb, unsigned int rlen);
 int linux_spi_set_max_speed(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 79aa4a1..fb0b894 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -50,21 +50,21 @@ static int sdio_set_func0_csa_address(uint32_t adr)
 	cmd.function = 0;
 	cmd.raw = 0;
 	cmd.address = 0x10c;
-	cmd.data = (uint8_t)adr;
+	cmd.data = (u8)adr;
 	if (!g_sdio.sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10c data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10d;
-	cmd.data = (uint8_t)(adr >> 8);
+	cmd.data = (u8)(adr >> 8);
 	if (!g_sdio.sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10d data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10e;
-	cmd.data = (uint8_t)(adr >> 16);
+	cmd.data = (u8)(adr >> 16);
 	if (!g_sdio.sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10e data...\n");
 		goto _fail_;
@@ -86,7 +86,7 @@ static int sdio_set_func0_csa_address_byte0(uint32_t adr)
 	cmd.function = 0;
 	cmd.raw = 0;
 	cmd.address = 0x10c;
-	cmd.data = (uint8_t)adr;
+	cmd.data = (u8)adr;
 	if (!g_sdio.sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10c data...\n");
 		goto _fail_;
@@ -105,14 +105,14 @@ static int sdio_set_func0_block_size(uint32_t block_size)
 	cmd.function = 0;
 	cmd.raw = 0;
 	cmd.address = 0x10;
-	cmd.data = (uint8_t)block_size;
+	cmd.data = (u8)block_size;
 	if (!g_sdio.sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10 data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x11;
-	cmd.data = (uint8_t)(block_size >> 8);
+	cmd.data = (u8)(block_size >> 8);
 	if (!g_sdio.sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x11 data...\n");
 		goto _fail_;
@@ -137,13 +137,13 @@ static int sdio_set_func1_block_size(uint32_t block_size)
 	cmd.function = 0;
 	cmd.raw = 0;
 	cmd.address = 0x110;
-	cmd.data = (uint8_t)block_size;
+	cmd.data = (u8)block_size;
 	if (!g_sdio.sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x110 data...\n");
 		goto _fail_;
 	}
 	cmd.address = 0x111;
-	cmd.data = (uint8_t)(block_size >> 8);
+	cmd.data = (u8)(block_size >> 8);
 	if (!g_sdio.sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x111 data...\n");
 		goto _fail_;
@@ -276,7 +276,7 @@ static int sdio_write_reg(uint32_t addr, uint32_t data)
 		cmd.block_mode = 0;
 		cmd.increment = 1;
 		cmd.count = 4;
-		cmd.buffer = (uint8_t *)&data;
+		cmd.buffer = (u8 *)&data;
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
 		if (!g_sdio.sdio_cmd53(&cmd)) {
@@ -292,7 +292,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
+static int sdio_write(uint32_t addr, u8 *buf, uint32_t size)
 {
 	uint32_t block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
@@ -402,7 +402,7 @@ static int sdio_read_reg(uint32_t addr, uint32_t *data)
 		cmd.block_mode = 0;
 		cmd.increment = 1;
 		cmd.count = 4;
-		cmd.buffer = (uint8_t *)data;
+		cmd.buffer = (u8 *)data;
 
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
@@ -423,7 +423,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
+static int sdio_read(uint32_t addr, u8 *buf, uint32_t size)
 {
 	uint32_t block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index d9ccca9..d600417 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -16,9 +16,9 @@
  */
 typedef struct {
 	void *os_context;
-	int (*spi_tx)(uint8_t *, uint32_t);
-	int (*spi_rx)(uint8_t *, uint32_t);
-	int (*spi_trx)(uint8_t *, uint8_t *, uint32_t);
+	int (*spi_tx)(u8 *, uint32_t);
+	int (*spi_rx)(u8 *, uint32_t);
+	int (*spi_trx)(u8 *, u8 *, uint32_t);
 	int (*spi_max_speed)(void);
 	wilc_debug_func dPrint;
 	int crc_off;
@@ -28,8 +28,8 @@ typedef struct {
 
 static wilc_spi_t g_spi;
 
-static int spi_read(uint32_t, uint8_t *, uint32_t);
-static int spi_write(uint32_t, uint8_t *, uint32_t);
+static int spi_read(uint32_t, u8 *, uint32_t);
+static int spi_write(uint32_t, u8 *, uint32_t);
 
 /********************************************
  *
@@ -37,7 +37,7 @@ static int spi_write(uint32_t, uint8_t *, uint32_t);
  *
  ********************************************/
 
-static const uint8_t crc7_syndrome_table[256] = {
+static const u8 crc7_syndrome_table[256] = {
 	0x00, 0x09, 0x12, 0x1b, 0x24, 0x2d, 0x36, 0x3f,
 	0x48, 0x41, 0x5a, 0x53, 0x6c, 0x65, 0x7e, 0x77,
 	0x19, 0x10, 0x0b, 0x02, 0x3d, 0x34, 0x2f, 0x26,
@@ -72,12 +72,12 @@ static const uint8_t crc7_syndrome_table[256] = {
 	0x46, 0x4f, 0x54, 0x5d, 0x62, 0x6b, 0x70, 0x79
 };
 
-static uint8_t crc7_byte(uint8_t crc, uint8_t data)
+static u8 crc7_byte(u8 crc, u8 data)
 {
 	return crc7_syndrome_table[(crc << 1) ^ data];
 }
 
-static uint8_t crc7(uint8_t crc, const uint8_t *buffer, uint32_t len)
+static u8 crc7(u8 crc, const u8 *buffer, uint32_t len)
 {
 	while (len--)
 		crc = crc7_byte(crc, *buffer++);
@@ -114,26 +114,26 @@ static uint8_t crc7(uint8_t crc, const uint8_t *buffer, uint32_t len)
 #define DATA_PKT_SZ_8K				(8 * 1024)
 #define DATA_PKT_SZ					DATA_PKT_SZ_8K
 
-static int spi_cmd(uint8_t cmd, uint32_t adr, uint32_t data, uint32_t sz, uint8_t clockless)
+static int spi_cmd(u8 cmd, uint32_t adr, uint32_t data, uint32_t sz, u8 clockless)
 {
-	uint8_t bc[9];
+	u8 bc[9];
 	int len = 5;
 	int result = N_OK;
 
 	bc[0] = cmd;
 	switch (cmd) {
 	case CMD_SINGLE_READ:                           /* single word (4 bytes) read */
-		bc[1] = (uint8_t)(adr >> 16);
-		bc[2] = (uint8_t)(adr >> 8);
-		bc[3] = (uint8_t)adr;
+		bc[1] = (u8)(adr >> 16);
+		bc[2] = (u8)(adr >> 8);
+		bc[3] = (u8)adr;
 		len = 5;
 		break;
 
 	case CMD_INTERNAL_READ:                 /* internal register read */
-		bc[1] = (uint8_t)(adr >> 8);
+		bc[1] = (u8)(adr >> 8);
 		if (clockless)
 			bc[1] |= (1 << 7);
-		bc[2] = (uint8_t)adr;
+		bc[2] = (u8)adr;
 		bc[3] = 0x00;
 		len = 5;
 		break;
@@ -161,45 +161,45 @@ static int spi_cmd(uint8_t cmd, uint32_t adr, uint32_t data, uint32_t sz, uint8_
 
 	case CMD_DMA_WRITE:                                     /* dma write */
 	case CMD_DMA_READ:                                      /* dma read */
-		bc[1] = (uint8_t)(adr >> 16);
-		bc[2] = (uint8_t)(adr >> 8);
-		bc[3] = (uint8_t)adr;
-		bc[4] = (uint8_t)(sz >> 8);
-		bc[5] = (uint8_t)(sz);
+		bc[1] = (u8)(adr >> 16);
+		bc[2] = (u8)(adr >> 8);
+		bc[3] = (u8)adr;
+		bc[4] = (u8)(sz >> 8);
+		bc[5] = (u8)(sz);
 		len = 7;
 		break;
 
 	case CMD_DMA_EXT_WRITE:         /* dma extended write */
 	case CMD_DMA_EXT_READ:                  /* dma extended read */
-		bc[1] = (uint8_t)(adr >> 16);
-		bc[2] = (uint8_t)(adr >> 8);
-		bc[3] = (uint8_t)adr;
-		bc[4] = (uint8_t)(sz >> 16);
-		bc[5] = (uint8_t)(sz >> 8);
-		bc[6] = (uint8_t)(sz);
+		bc[1] = (u8)(adr >> 16);
+		bc[2] = (u8)(adr >> 8);
+		bc[3] = (u8)adr;
+		bc[4] = (u8)(sz >> 16);
+		bc[5] = (u8)(sz >> 8);
+		bc[6] = (u8)(sz);
 		len = 8;
 		break;
 
 	case CMD_INTERNAL_WRITE:                /* internal register write */
-		bc[1] = (uint8_t)(adr >> 8);
+		bc[1] = (u8)(adr >> 8);
 		if (clockless)
 			bc[1] |= (1 << 7);
-		bc[2] = (uint8_t)(adr);
-		bc[3] = (uint8_t)(data >> 24);
-		bc[4] = (uint8_t)(data >> 16);
-		bc[5] = (uint8_t)(data >> 8);
-		bc[6] = (uint8_t)(data);
+		bc[2] = (u8)(adr);
+		bc[3] = (u8)(data >> 24);
+		bc[4] = (u8)(data >> 16);
+		bc[5] = (u8)(data >> 8);
+		bc[6] = (u8)(data);
 		len = 8;
 		break;
 
 	case CMD_SINGLE_WRITE:                  /* single word write */
-		bc[1] = (uint8_t)(adr >> 16);
-		bc[2] = (uint8_t)(adr >> 8);
-		bc[3] = (uint8_t)(adr);
-		bc[4] = (uint8_t)(data >> 24);
-		bc[5] = (uint8_t)(data >> 16);
-		bc[6] = (uint8_t)(data >> 8);
-		bc[7] = (uint8_t)(data);
+		bc[1] = (u8)(adr >> 16);
+		bc[2] = (u8)(adr >> 8);
+		bc[3] = (u8)(adr);
+		bc[4] = (u8)(data >> 24);
+		bc[5] = (u8)(data >> 16);
+		bc[6] = (u8)(data >> 8);
+		bc[7] = (u8)(data);
 		len = 9;
 		break;
 
@@ -210,7 +210,7 @@ static int spi_cmd(uint8_t cmd, uint32_t adr, uint32_t data, uint32_t sz, uint8_
 
 	if (result) {
 		if (!g_spi.crc_off)
-			bc[len - 1] = (crc7(0x7f, (const uint8_t *)&bc[0], len - 1)) << 1;
+			bc[len - 1] = (crc7(0x7f, (const u8 *)&bc[0], len - 1)) << 1;
 		else
 			len -= 1;
 
@@ -223,9 +223,9 @@ static int spi_cmd(uint8_t cmd, uint32_t adr, uint32_t data, uint32_t sz, uint8_
 	return result;
 }
 
-static int spi_cmd_rsp(uint8_t cmd)
+static int spi_cmd_rsp(u8 cmd)
 {
-	uint8_t rsp;
+	u8 rsp;
 	int result = N_OK;
 
 	/**
@@ -271,29 +271,29 @@ _fail_:
 	return result;
 }
 
-static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz, uint8_t clockless)
+static int spi_cmd_complete(u8 cmd, uint32_t adr, u8 *b, uint32_t sz, u8 clockless)
 {
-	uint8_t wb[32], rb[32];
-	uint8_t wix, rix;
+	u8 wb[32], rb[32];
+	u8 wix, rix;
 	uint32_t len2;
-	uint8_t rsp;
+	u8 rsp;
 	int len = 0;
 	int result = N_OK;
 
 	wb[0] = cmd;
 	switch (cmd) {
 	case CMD_SINGLE_READ:                           /* single word (4 bytes) read */
-		wb[1] = (uint8_t)(adr >> 16);
-		wb[2] = (uint8_t)(adr >> 8);
-		wb[3] = (uint8_t)adr;
+		wb[1] = (u8)(adr >> 16);
+		wb[2] = (u8)(adr >> 8);
+		wb[3] = (u8)adr;
 		len = 5;
 		break;
 
 	case CMD_INTERNAL_READ:                 /* internal register read */
-		wb[1] = (uint8_t)(adr >> 8);
+		wb[1] = (u8)(adr >> 8);
 		if (clockless == 1)
 			wb[1] |= (1 << 7);
-		wb[2] = (uint8_t)adr;
+		wb[2] = (u8)adr;
 		wb[3] = 0x00;
 		len = 5;
 		break;
@@ -321,30 +321,30 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 
 	case CMD_DMA_WRITE:                                     /* dma write */
 	case CMD_DMA_READ:                                      /* dma read */
-		wb[1] = (uint8_t)(adr >> 16);
-		wb[2] = (uint8_t)(adr >> 8);
-		wb[3] = (uint8_t)adr;
-		wb[4] = (uint8_t)(sz >> 8);
-		wb[5] = (uint8_t)(sz);
+		wb[1] = (u8)(adr >> 16);
+		wb[2] = (u8)(adr >> 8);
+		wb[3] = (u8)adr;
+		wb[4] = (u8)(sz >> 8);
+		wb[5] = (u8)(sz);
 		len = 7;
 		break;
 
 	case CMD_DMA_EXT_WRITE:         /* dma extended write */
 	case CMD_DMA_EXT_READ:                  /* dma extended read */
-		wb[1] = (uint8_t)(adr >> 16);
-		wb[2] = (uint8_t)(adr >> 8);
-		wb[3] = (uint8_t)adr;
-		wb[4] = (uint8_t)(sz >> 16);
-		wb[5] = (uint8_t)(sz >> 8);
-		wb[6] = (uint8_t)(sz);
+		wb[1] = (u8)(adr >> 16);
+		wb[2] = (u8)(adr >> 8);
+		wb[3] = (u8)adr;
+		wb[4] = (u8)(sz >> 16);
+		wb[5] = (u8)(sz >> 8);
+		wb[6] = (u8)(sz);
 		len = 8;
 		break;
 
 	case CMD_INTERNAL_WRITE:                /* internal register write */
-		wb[1] = (uint8_t)(adr >> 8);
+		wb[1] = (u8)(adr >> 8);
 		if (clockless == 1)
 			wb[1] |= (1 << 7);
-		wb[2] = (uint8_t)(adr);
+		wb[2] = (u8)(adr);
 		wb[3] = b[3];
 		wb[4] = b[2];
 		wb[5] = b[1];
@@ -353,9 +353,9 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 		break;
 
 	case CMD_SINGLE_WRITE:                  /* single word write */
-		wb[1] = (uint8_t)(adr >> 16);
-		wb[2] = (uint8_t)(adr >> 8);
-		wb[3] = (uint8_t)(adr);
+		wb[1] = (u8)(adr >> 16);
+		wb[2] = (u8)(adr >> 8);
+		wb[3] = (u8)(adr);
 		wb[4] = b[3];
 		wb[5] = b[2];
 		wb[6] = b[1];
@@ -373,7 +373,7 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 	}
 
 	if (!g_spi.crc_off)
-		wb[len - 1] = (crc7(0x7f, (const uint8_t *)&wb[0], len - 1)) << 1;
+		wb[len - 1] = (crc7(0x7f, (const u8 *)&wb[0], len - 1)) << 1;
 	else
 		len -= 1;
 
@@ -454,7 +454,7 @@ static int spi_cmd_complete(uint8_t cmd, uint32_t adr, uint8_t *b, uint32_t sz,
 	    || (cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
 		int retry;
 		/* uint16_t crc1, crc2; */
-		uint8_t crc[2];
+		u8 crc[2];
 		/**
 		 * Data Respnose header
 		 **/
@@ -610,12 +610,12 @@ _error_:
 	return result;
 }
 
-static int spi_data_read(uint8_t *b, uint32_t sz)
+static int spi_data_read(u8 *b, uint32_t sz)
 {
 	int retry, ix, nbytes;
 	int result = N_OK;
-	uint8_t crc[2];
-	uint8_t rsp;
+	u8 crc[2];
+	u8 rsp;
 
 	/**
 	 *      Data
@@ -678,12 +678,12 @@ static int spi_data_read(uint8_t *b, uint32_t sz)
 	return result;
 }
 
-static int spi_data_write(uint8_t *b, uint32_t sz)
+static int spi_data_write(u8 *b, uint32_t sz)
 {
 	int ix, nbytes;
 	int result = 1;
-	uint8_t cmd, order, crc[2] = {0};
-	/* uint8_t rsp; */
+	u8 cmd, order, crc[2] = {0};
+	/* u8 rsp; */
 
 	/**
 	 *      Data
@@ -778,7 +778,7 @@ static int spi_internal_write(uint32_t adr, uint32_t dat)
 #ifdef BIG_ENDIAN
 	dat = BYTE_SWAP(dat);
 #endif
-	result = spi_cmd_complete(CMD_INTERNAL_WRITE, adr, (uint8_t *)&dat, 4, 0);
+	result = spi_cmd_complete(CMD_INTERNAL_WRITE, adr, (u8 *)&dat, 4, 0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed internal write cmd...\n");
 	}
@@ -807,13 +807,13 @@ static int spi_internal_read(uint32_t adr, uint32_t *data)
 	/**
 	 *      Data
 	 **/
-	result = spi_data_read((uint8_t *)data, 4);
+	result = spi_data_read((u8 *)data, 4);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed internal read data...\n");
 		return 0;
 	}
 #else
-	result = spi_cmd_complete(CMD_INTERNAL_READ, adr, (uint8_t *)data, 4, 0);
+	result = spi_cmd_complete(CMD_INTERNAL_READ, adr, (u8 *)data, 4, 0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed internal read cmd...\n");
 		return 0;
@@ -837,8 +837,8 @@ static int spi_internal_read(uint32_t adr, uint32_t *data)
 static int spi_write_reg(uint32_t addr, uint32_t data)
 {
 	int result = N_OK;
-	uint8_t cmd = CMD_SINGLE_WRITE;
-	uint8_t clockless = 0;
+	u8 cmd = CMD_SINGLE_WRITE;
+	u8 clockless = 0;
 
 
 #if defined USE_OLD_SPI_SW
@@ -867,7 +867,7 @@ static int spi_write_reg(uint32_t addr, uint32_t data)
 		clockless = 1;
 	}
 
-	result = spi_cmd_complete(cmd, addr, (uint8_t *)&data, 4, clockless);
+	result = spi_cmd_complete(cmd, addr, (u8 *)&data, 4, clockless);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed cmd, write reg (%08x)...\n", addr);
 	}
@@ -877,10 +877,10 @@ static int spi_write_reg(uint32_t addr, uint32_t data)
 
 }
 
-static int spi_write(uint32_t addr, uint8_t *buf, uint32_t size)
+static int spi_write(uint32_t addr, u8 *buf, uint32_t size)
 {
 	int result;
-	uint8_t cmd = CMD_DMA_EXT_WRITE;
+	u8 cmd = CMD_DMA_EXT_WRITE;
 
 	/**
 	 *      has to be greated than 4
@@ -925,8 +925,8 @@ static int spi_write(uint32_t addr, uint8_t *buf, uint32_t size)
 static int spi_read_reg(uint32_t addr, uint32_t *data)
 {
 	int result = N_OK;
-	uint8_t cmd = CMD_SINGLE_READ;
-	uint8_t clockless = 0;
+	u8 cmd = CMD_SINGLE_READ;
+	u8 clockless = 0;
 
 #if defined USE_OLD_SPI_SW
 	result = spi_cmd(cmd, addr, 0, 4, 0);
@@ -940,7 +940,7 @@ static int spi_read_reg(uint32_t addr, uint32_t *data)
 		return 0;
 	}
 
-	result = spi_data_read((uint8_t *)data, 4);
+	result = spi_data_read((u8 *)data, 4);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed data read...\n");
 		return 0;
@@ -953,7 +953,7 @@ static int spi_read_reg(uint32_t addr, uint32_t *data)
 		clockless = 1;
 	}
 
-	result = spi_cmd_complete(cmd, addr, (uint8_t *)data, 4, clockless);
+	result = spi_cmd_complete(cmd, addr, (u8 *)data, 4, clockless);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed cmd, read reg (%08x)...\n", addr);
 		return 0;
@@ -968,9 +968,9 @@ static int spi_read_reg(uint32_t addr, uint32_t *data)
 	return 1;
 }
 
-static int spi_read(uint32_t addr, uint8_t *buf, uint32_t size)
+static int spi_read(uint32_t addr, u8 *buf, uint32_t size)
 {
-	uint8_t cmd = CMD_DMA_EXT_READ;
+	u8 cmd = CMD_DMA_EXT_READ;
 	int result;
 
 	if (size <= 4)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 237be2b..4126acd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -164,9 +164,9 @@ void clear_shadow_scan(void *pUserVoid)
 
 uint32_t get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 {
-	uint8_t i;
+	u8 i;
 	int rssi_v = 0;
-	uint8_t num_rssi = (pstrNetworkInfo->strRssi.u8Full) ? NUM_RSSI : (pstrNetworkInfo->strRssi.u8Index);
+	u8 num_rssi = (pstrNetworkInfo->strRssi.u8Full) ? NUM_RSSI : (pstrNetworkInfo->strRssi.u8Index);
 
 	for (i = 0; i < num_rssi; i++)
 		rssi_v += pstrNetworkInfo->strRssi.as8RSSI[i];
@@ -175,7 +175,7 @@ uint32_t get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 	return rssi_v;
 }
 
-void refresh_scan(void *pUserVoid, uint8_t all, bool bDirectScan)
+void refresh_scan(void *pUserVoid, u8 all, bool bDirectScan)
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
@@ -302,7 +302,7 @@ void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, vo
 {
 	int8_t ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
 	uint32_t ap_index = 0;
-	uint8_t rssi_index = 0;
+	u8 rssi_index = 0;
 
 	if (u32LastScannedNtwrksCountShadow >= MAX_NUM_SCANNED_NETWORKS_SHADOW) {
 		PRINT_D(CFG80211_DBG, "Shadow network reached its maximum limit\n");
@@ -525,7 +525,7 @@ int WILC_WFI_Set_PMKSA(u8 *bssid, struct wilc_priv *priv)
 
 
 }
-int linux_wlan_set_bssid(struct net_device *wilc_netdev, uint8_t *pBSSID);
+int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
 
 
 /**
@@ -1079,7 +1079,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	#ifdef WILC_P2P
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	#endif
-	uint8_t NullBssid[ETH_ALEN] = {0};
+	u8 NullBssid[ETH_ALEN] = {0};
 
 	connecting = 0;
 	priv = wiphy_priv(wiphy);
@@ -2198,7 +2198,7 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
  *  @version		1.0
  */
 
-void WILC_WFI_p2p_rx (struct net_device *dev, uint8_t *buff, uint32_t size)
+void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, uint32_t size)
 {
 
 	struct wilc_priv *priv;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 3c3571d..eb160d5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -111,7 +111,7 @@ void WILC_WFI_WiphyFree(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
 int WILC_WFI_DeInitHostInt(struct net_device *net);
 int WILC_WFI_InitHostInt(struct net_device *net);
-void WILC_WFI_monitor_rx(uint8_t *buff, uint32_t size);
+void WILC_WFI_monitor_rx(u8 *buff, uint32_t size);
 int WILC_WFI_deinit_mon_interface(void);
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 30ca3e0..6ea5c87f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -171,8 +171,8 @@ typedef struct {
 } struct_frame_reg;
 
 typedef struct {
-	uint8_t aSrcAddress[ETH_ALEN];
-	uint8_t aBSSID[ETH_ALEN];
+	u8 aSrcAddress[ETH_ALEN];
+	u8 aBSSID[ETH_ALEN];
 	tstrWILC_WFIDrv *drvHandler;
 	struct net_device *wilc_netdev;
 } tstrInterfaceInfo;
@@ -184,9 +184,9 @@ typedef struct {
 	#endif
 	wilc_wlan_oup_t oup;
 	int close;
-	uint8_t u8NoIfcs;
+	u8 u8NoIfcs;
 	tstrInterfaceInfo strInterfaceInfo[NUM_CONCURRENT_IFC];
-	uint8_t open_ifcs;
+	u8 open_ifcs;
 	struct mutex txq_cs;
 
 	/*Added by Amr - BugID_4720*/
@@ -229,7 +229,7 @@ typedef struct {
 } linux_wlan_t;
 
 typedef struct {
-	uint8_t u8IfIdx;
+	u8 u8IfIdx;
 	u8 iftype;
 	int monitor_flag;
 	int mac_opened;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 39716ba..c287301 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -19,8 +19,8 @@
 extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
 extern wilc_cfg_func_t mac_cfg;
-extern void WILC_WFI_mgmt_rx(uint8_t *buff, uint32_t size);
-uint32_t wilc_get_chipid(uint8_t update);
+extern void WILC_WFI_mgmt_rx(u8 *buff, uint32_t size);
+uint32_t wilc_get_chipid(u8 update);
 u16 Set_machw_change_vir_if(bool bValue);
 
 
@@ -57,14 +57,14 @@ typedef struct {
 	 **/
 	#ifdef MEMORY_STATIC
 	uint32_t rx_buffer_size;
-	uint8_t *rx_buffer;
+	u8 *rx_buffer;
 	uint32_t rx_buffer_offset;
 	#endif
 	/**
 	 *      TX buffer
 	 **/
 	uint32_t tx_buffer_size;
-	uint8_t *tx_buffer;
+	u8 *tx_buffer;
 	uint32_t tx_buffer_offset;
 
 	/**
@@ -374,8 +374,8 @@ static __inline int remove_TCP_related(void)
 static __inline int tcp_process(struct txq_entry_t *tqe)
 {
 	int ret;
-	uint8_t *eth_hdr_ptr;
-	uint8_t *buffer = tqe->buffer;
+	u8 *eth_hdr_ptr;
+	u8 *buffer = tqe->buffer;
 	unsigned short h_proto;
 	int i;
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
@@ -386,15 +386,15 @@ static __inline int tcp_process(struct txq_entry_t *tqe)
 	eth_hdr_ptr = &buffer[0];
 	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
 	if (h_proto == 0x0800) { /* IP */
-		uint8_t *ip_hdr_ptr;
-		uint8_t protocol;
+		u8 *ip_hdr_ptr;
+		u8 protocol;
 
 		ip_hdr_ptr = &buffer[ETHERNET_HDR_LEN];
 		protocol = ip_hdr_ptr[9];
 
 
 		if (protocol == 0x06) {
-			uint8_t *tcp_hdr_ptr;
+			u8 *tcp_hdr_ptr;
 			uint32_t IHL, Total_Length, Data_offset;
 
 			tcp_hdr_ptr = &ip_hdr_ptr[IP_HDR_LEN];
@@ -494,7 +494,7 @@ bool is_TCP_ACK_Filter_Enabled(void)
 }
 #endif
 
-static int wilc_wlan_txq_add_cfg_pkt(uint8_t *buffer, uint32_t buffer_size)
+static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, uint32_t buffer_size)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	struct txq_entry_t *tqe;
@@ -531,7 +531,7 @@ static int wilc_wlan_txq_add_cfg_pkt(uint8_t *buffer, uint32_t buffer_size)
 	return 1;
 }
 
-static int wilc_wlan_txq_add_net_pkt(void *priv, uint8_t *buffer, uint32_t buffer_size, wilc_tx_complete_func_t func)
+static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, uint32_t buffer_size, wilc_tx_complete_func_t func)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	struct txq_entry_t *tqe;
@@ -563,7 +563,7 @@ static int wilc_wlan_txq_add_net_pkt(void *priv, uint8_t *buffer, uint32_t buffe
 }
 /*Bug3959: transmitting mgmt frames received from host*/
 #if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-int wilc_wlan_txq_add_mgmt_pkt(void *priv, uint8_t *buffer, uint32_t buffer_size, wilc_tx_complete_func_t func)
+int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, uint32_t buffer_size, wilc_tx_complete_func_t func)
 {
 
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
@@ -856,7 +856,7 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 	int i, entries = 0;
 	uint32_t sum;
 	uint32_t reg;
-	uint8_t *txb = p->tx_buffer;
+	u8 *txb = p->tx_buffer;
 	uint32_t offset = 0;
 	int vmm_sz = 0;
 	struct txq_entry_t *tqe;
@@ -981,7 +981,7 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 			/**
 			 * write to vmm table
 			 **/
-			ret = p->hif_func.hif_block_tx(WILC_VMM_TBL_RX_SHADOW_BASE, (uint8_t *)vmm_table, ((i + 1) * 4)); /* Bug 4477 fix */
+			ret = p->hif_func.hif_block_tx(WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4)); /* Bug 4477 fix */
 			if (!ret) {
 				wilc_debug(N_ERR, "ERR block TX of VMM table.\n");
 				break;
@@ -1166,7 +1166,7 @@ static void wilc_wlan_handle_rxq(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int offset = 0, size, has_packet = 0;
-	uint8_t *buffer;
+	u8 *buffer;
 	struct rxq_entry_t *rqe;
 
 	p->rxq_exit = 0;
@@ -1331,7 +1331,7 @@ static void wilc_wlan_handle_isr_ext(uint32_t int_status)
 #ifdef MEMORY_STATIC
 	uint32_t offset = p->rx_buffer_offset;
 #endif
-	uint8_t *buffer = NULL;
+	u8 *buffer = NULL;
 	uint32_t size;
 	uint32_t retries = 0;
 	int ret = 0;
@@ -1459,12 +1459,12 @@ void wilc_handle_isr(void)
  *      Firmware download
  *
  ********************************************/
-static int wilc_wlan_firmware_download(const uint8_t *buffer, uint32_t buffer_size)
+static int wilc_wlan_firmware_download(const u8 *buffer, uint32_t buffer_size)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
 	uint32_t addr, size, size2, blksz;
-	uint8_t *dma_buffer;
+	u8 *dma_buffer;
 	int ret = 0;
 
 	blksz = (1ul << 12); /* Bug 4703: 4KB Good enough size for most platforms = PAGE_SIZE. */
@@ -1667,7 +1667,7 @@ static int wilc_wlan_stop(void)
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t reg = 0;
 	int ret;
-	uint8_t timeout = 10;
+	u8 timeout = 10;
 	/**
 	 *      TODO: stop the firmware, need a re-download
 	 **/
@@ -1815,12 +1815,12 @@ static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
 		cfg->wid_header[0] = 'Q';
 	}
 	cfg->wid_header[1] = seq_no;    /* sequence number */
-	cfg->wid_header[2] = (uint8_t)total_len;
-	cfg->wid_header[3] = (uint8_t)(total_len >> 8);
-	cfg->wid_header[4] = (uint8_t)driver_handler;
-	cfg->wid_header[5] = (uint8_t)(driver_handler >> 8);
-	cfg->wid_header[6] = (uint8_t)(driver_handler >> 16);
-	cfg->wid_header[7] = (uint8_t)(driver_handler >> 24);
+	cfg->wid_header[2] = (u8)total_len;
+	cfg->wid_header[3] = (u8)(total_len >> 8);
+	cfg->wid_header[4] = (u8)driver_handler;
+	cfg->wid_header[5] = (u8)(driver_handler >> 8);
+	cfg->wid_header[6] = (u8)(driver_handler >> 16);
+	cfg->wid_header[7] = (u8)(driver_handler >> 24);
 	p->cfg_seq_no = seq_no;
 
 	/**
@@ -1834,7 +1834,7 @@ static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
 	return 0;
 }
 
-static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_set(int start, uint32_t wid, u8 *buffer, uint32_t buffer_size, int commit, uint32_t drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
@@ -1912,7 +1912,7 @@ static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHa
 	return ret_size;
 }
 
-static int wilc_wlan_cfg_get_val(uint32_t wid, uint8_t *buffer, uint32_t buffer_size)
+static int wilc_wlan_cfg_get_val(uint32_t wid, u8 *buffer, uint32_t buffer_size)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int ret;
@@ -1980,7 +1980,7 @@ uint32_t init_chip(void)
 
 }
 
-uint32_t wilc_get_chipid(uint8_t update)
+uint32_t wilc_get_chipid(u8 update)
 {
 	static uint32_t chipid;
 	/* SDIO can't read into global variables */
@@ -2017,7 +2017,7 @@ _fail_:
 }
 
 #ifdef COMPLEMENT_BOOT
-uint8_t core_11b_ready(void)
+u8 core_11b_ready(void)
 {
 	uint32_t reg_val;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 99e07de..d7fd07b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -240,7 +240,7 @@ struct txq_entry_t {
 	struct txq_entry_t *prev;
 	int type;
 	int tcp_PendingAck_index;
-	uint8_t *buffer;
+	u8 *buffer;
 	int buffer_size;
 	void *priv;
 	int status;
@@ -249,7 +249,7 @@ struct txq_entry_t {
 
 struct rxq_entry_t {
 	struct rxq_entry_t *next;
-	uint8_t *buffer;
+	u8 *buffer;
 	int buffer_size;
 };
 
@@ -264,15 +264,15 @@ typedef struct {
 	int (*hif_deinit)(void *);
 	int (*hif_read_reg)(uint32_t, uint32_t *);
 	int (*hif_write_reg)(uint32_t, uint32_t);
-	int (*hif_block_rx)(uint32_t, uint8_t *, uint32_t);
-	int (*hif_block_tx)(uint32_t, uint8_t *, uint32_t);
+	int (*hif_block_rx)(uint32_t, u8 *, uint32_t);
+	int (*hif_block_tx)(uint32_t, u8 *, uint32_t);
 	int (*hif_sync)(void);
 	int (*hif_clear_int)(void);
 	int (*hif_read_int)(uint32_t *);
 	int (*hif_clear_int_ext)(uint32_t);
 	int (*hif_read_size)(uint32_t *);
-	int (*hif_block_tx_ext)(uint32_t, uint8_t *, uint32_t);
-	int (*hif_block_rx_ext)(uint32_t, uint8_t *, uint32_t);
+	int (*hif_block_tx_ext)(uint32_t, u8 *, uint32_t);
+	int (*hif_block_rx_ext)(uint32_t, u8 *, uint32_t);
 	int (*hif_sync_ext)(int);
 	void (*hif_set_max_bus_speed)(void);
 	void (*hif_set_default_bus_speed)(void);
@@ -287,15 +287,15 @@ typedef struct {
 #define MAX_CFG_FRAME_SIZE 1468
 
 typedef struct {
-	uint8_t ether_header[14];
-	uint8_t ip_header[20];
-	uint8_t udp_header[8];
-	uint8_t wid_header[8];
-	uint8_t frame[MAX_CFG_FRAME_SIZE];
+	u8 ether_header[14];
+	u8 ip_header[20];
+	u8 udp_header[8];
+	u8 wid_header[8];
+	u8 frame[MAX_CFG_FRAME_SIZE];
 } wilc_cfg_frame_t;
 
 typedef struct {
-	int (*wlan_tx)(uint8_t *, uint32_t, wilc_tx_complete_func_t);
+	int (*wlan_tx)(u8 *, uint32_t, wilc_tx_complete_func_t);
 } wilc_wlan_cfg_func_t;
 
 typedef struct {
@@ -304,10 +304,10 @@ typedef struct {
 } wilc_cfg_rsp_t;
 
 typedef struct {
-	int (*cfg_wid_set)(uint8_t *, uint32_t, uint16_t, uint8_t *, int);
-	int (*cfg_wid_get)(uint8_t *, uint32_t, uint16_t);
-	int (*cfg_wid_get_val)(uint16_t, uint8_t *, uint32_t);
-	int (*rx_indicate)(uint8_t *, int, wilc_cfg_rsp_t *);
+	int (*cfg_wid_set)(u8 *, uint32_t, uint16_t, u8 *, int);
+	int (*cfg_wid_get)(u8 *, uint32_t, uint16_t);
+	int (*cfg_wid_get_val)(uint16_t, u8 *, uint32_t);
+	int (*rx_indicate)(u8 *, int, wilc_cfg_rsp_t *);
 	int (*cfg_init)(wilc_debug_func);
 } wilc_cfg_func_t;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 21ed14d..8223b5f 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -22,23 +22,23 @@ typedef struct {
 	wilc_debug_func dPrint;
 
 	int mac_status;
-	uint8_t mac_address[7];
-	uint8_t ip_address[5];
-	uint8_t bssid[7];
-	uint8_t ssid[34];
-	uint8_t firmware_version[129];
-	uint8_t supp_rate[24];
-	uint8_t wep_key[28];
-	uint8_t i_psk[66];
-	uint8_t hardwareProductVersion[33];
-	uint8_t phyversion[17];
-	uint8_t supp_username[21];
-	uint8_t supp_password[64];
-	uint8_t assoc_req[256];
-	uint8_t assoc_rsp[256];
-	uint8_t firmware_info[8];
-	uint8_t scan_result[256];
-	uint8_t scan_result1[256];
+	u8 mac_address[7];
+	u8 ip_address[5];
+	u8 bssid[7];
+	u8 ssid[34];
+	u8 firmware_version[129];
+	u8 supp_rate[24];
+	u8 wep_key[28];
+	u8 i_psk[66];
+	u8 hardwareProductVersion[33];
+	u8 phyversion[17];
+	u8 supp_username[21];
+	u8 supp_password[64];
+	u8 assoc_req[256];
+	u8 assoc_rsp[256];
+	u8 firmware_info[8];
+	u8 scan_result[256];
+	u8 scan_result1[256];
 } wilc_mac_cfg_t;
 
 static wilc_mac_cfg_t g_mac;
@@ -160,72 +160,72 @@ static wilc_cfg_str_t g_cfg_str[] = {
  *
  ********************************************/
 
-static int wilc_wlan_cfg_set_byte(uint8_t *frame, uint32_t offset, uint16_t id, uint8_t val8)
+static int wilc_wlan_cfg_set_byte(u8 *frame, uint32_t offset, uint16_t id, u8 val8)
 {
-	uint8_t *buf;
+	u8 *buf;
 
 	if ((offset + 4) >= MAX_CFG_FRAME_SIZE)
 		return 0;
 
 	buf = &frame[offset];
 
-	buf[0] = (uint8_t)id;
-	buf[1] = (uint8_t)(id >> 8);
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
 	buf[2] = 1;
 	buf[3] = val8;
 	return 4;
 }
 
-static int wilc_wlan_cfg_set_hword(uint8_t *frame, uint32_t offset, uint16_t id, uint16_t val16)
+static int wilc_wlan_cfg_set_hword(u8 *frame, uint32_t offset, uint16_t id, uint16_t val16)
 {
-	uint8_t *buf;
+	u8 *buf;
 
 	if ((offset + 5) >= MAX_CFG_FRAME_SIZE)
 		return 0;
 
 	buf = &frame[offset];
 
-	buf[0] = (uint8_t)id;
-	buf[1] = (uint8_t)(id >> 8);
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
 	buf[2] = 2;
-	buf[3] = (uint8_t)val16;
-	buf[4] = (uint8_t)(val16 >> 8);
+	buf[3] = (u8)val16;
+	buf[4] = (u8)(val16 >> 8);
 
 	return 5;
 }
 
-static int wilc_wlan_cfg_set_word(uint8_t *frame, uint32_t offset, uint16_t id, uint32_t val32)
+static int wilc_wlan_cfg_set_word(u8 *frame, uint32_t offset, uint16_t id, uint32_t val32)
 {
-	uint8_t *buf;
+	u8 *buf;
 
 	if ((offset + 7) >= MAX_CFG_FRAME_SIZE)
 		return 0;
 
 	buf = &frame[offset];
 
-	buf[0] = (uint8_t)id;
-	buf[1] = (uint8_t)(id >> 8);
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
 	buf[2] = 4;
-	buf[3] = (uint8_t)val32;
-	buf[4] = (uint8_t)(val32 >> 8);
-	buf[5] = (uint8_t)(val32 >> 16);
-	buf[6] = (uint8_t)(val32 >> 24);
+	buf[3] = (u8)val32;
+	buf[4] = (u8)(val32 >> 8);
+	buf[5] = (u8)(val32 >> 16);
+	buf[6] = (u8)(val32 >> 24);
 
 	return 7;
 }
 
-static int wilc_wlan_cfg_set_str(uint8_t *frame, uint32_t offset, uint16_t id, uint8_t *str, uint32_t size)
+static int wilc_wlan_cfg_set_str(u8 *frame, uint32_t offset, uint16_t id, u8 *str, uint32_t size)
 {
-	uint8_t *buf;
+	u8 *buf;
 
 	if ((offset + size + 3) >= MAX_CFG_FRAME_SIZE)
 		return 0;
 
 	buf = &frame[offset];
 
-	buf[0] = (uint8_t)id;
-	buf[1] = (uint8_t)(id >> 8);
-	buf[2] = (uint8_t)size;
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
+	buf[2] = (u8)size;
 
 	if ((str != NULL) && (size != 0))
 		memcpy(&buf[3], str, size);
@@ -233,20 +233,20 @@ static int wilc_wlan_cfg_set_str(uint8_t *frame, uint32_t offset, uint16_t id, u
 	return (size + 3);
 }
 
-static int wilc_wlan_cfg_set_bin(uint8_t *frame, uint32_t offset, uint16_t id, uint8_t *b, uint32_t size)
+static int wilc_wlan_cfg_set_bin(u8 *frame, uint32_t offset, uint16_t id, u8 *b, uint32_t size)
 {
-	uint8_t *buf;
+	u8 *buf;
 	uint32_t i;
-	uint8_t checksum = 0;
+	u8 checksum = 0;
 
 	if ((offset + size + 5) >= MAX_CFG_FRAME_SIZE)
 		return 0;
 
 	buf = &frame[offset];
-	buf[0] = (uint8_t)id;
-	buf[1] = (uint8_t)(id >> 8);
-	buf[2] = (uint8_t)size;
-	buf[3] = (uint8_t)(size >> 8);
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
+	buf[2] = (u8)size;
+	buf[3] = (u8)(size >> 8);
 
 	if ((b != NULL) && (size != 0)) {
 		memcpy(&buf[4], b, size);
@@ -266,7 +266,7 @@ static int wilc_wlan_cfg_set_bin(uint8_t *frame, uint32_t offset, uint16_t id, u
  *
  ********************************************/
 
-static void wilc_wlan_parse_response_frame(uint8_t *info, int size)
+static void wilc_wlan_parse_response_frame(u8 *info, int size)
 {
 	uint32_t wid, len = 0, i = 0;
 	static int seq;
@@ -361,7 +361,7 @@ static void wilc_wlan_parse_response_frame(uint8_t *info, int size)
 	}
 }
 
-static int wilc_wlan_parse_info_frame(uint8_t *info, int size)
+static int wilc_wlan_parse_info_frame(u8 *info, int size)
 {
 	wilc_mac_cfg_t *pd = (wilc_mac_cfg_t *)&g_mac;
 	uint32_t wid, len;
@@ -385,9 +385,9 @@ static int wilc_wlan_parse_info_frame(uint8_t *info, int size)
  *
  ********************************************/
 
-static int wilc_wlan_cfg_set_wid(uint8_t *frame, uint32_t offset, uint16_t id, uint8_t *buf, int size)
+static int wilc_wlan_cfg_set_wid(u8 *frame, uint32_t offset, uint16_t id, u8 *buf, int size)
 {
-	uint8_t type = (id >> 12) & 0xf;
+	u8 type = (id >> 12) & 0xf;
 	int ret = 0;
 
 	if (type == 0) {                                        /* byte command */
@@ -410,22 +410,22 @@ static int wilc_wlan_cfg_set_wid(uint8_t *frame, uint32_t offset, uint16_t id, u
 	return ret;
 }
 
-static int wilc_wlan_cfg_get_wid(uint8_t *frame, uint32_t offset, uint16_t id)
+static int wilc_wlan_cfg_get_wid(u8 *frame, uint32_t offset, uint16_t id)
 {
-	uint8_t *buf;
+	u8 *buf;
 
 	if ((offset + 2) >= MAX_CFG_FRAME_SIZE)
 		return 0;
 
 	buf = &frame[offset];
 
-	buf[0] = (uint8_t)id;
-	buf[1] = (uint8_t)(id >> 8);
+	buf[0] = (u8)id;
+	buf[1] = (u8)(id >> 8);
 
 	return 2;
 }
 
-static int wilc_wlan_cfg_get_wid_value(uint16_t wid, uint8_t *buffer, uint32_t buffer_size)
+static int wilc_wlan_cfg_get_wid_value(uint16_t wid, u8 *buffer, uint32_t buffer_size)
 {
 	uint32_t type = (wid >> 12) & 0xf;
 	int i, ret = 0;
@@ -504,11 +504,11 @@ static int wilc_wlan_cfg_get_wid_value(uint16_t wid, uint8_t *buffer, uint32_t b
 	return ret;
 }
 
-static int wilc_wlan_cfg_indicate_rx(uint8_t *frame, int size, wilc_cfg_rsp_t *rsp)
+static int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp)
 {
 	int ret = 1;
-	uint8_t msg_type;
-	uint8_t msg_id;
+	u8 msg_type;
+	u8 msg_id;
 
 	msg_type = frame[0];
 	msg_id = frame[1];      /* seq no */
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 8906611..bcff29c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -27,7 +27,7 @@ typedef struct {
 
 typedef struct {
 	uint32_t id;
-	uint8_t *str;
+	u8 *str;
 } wilc_cfg_str_t;
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 9f9f4a9..a29d486 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -78,12 +78,12 @@ typedef struct {
 	uint32_t address: 17;
 	uint32_t count: 9;
 	/* } bit; */
-	uint8_t *buffer;
+	u8 *buffer;
 	uint32_t block_size;
 } sdio_cmd53_t;
 
 typedef struct {
-	void (*os_debug)(uint8_t *);
+	void (*os_debug)(u8 *);
 	int (*os_wait)(void *, u32);
 } wilc_wlan_os_func_t;
 
@@ -100,15 +100,15 @@ typedef struct {
 		} sdio;
 		struct {
 			int (*spi_max_speed)(void);
-			int (*spi_tx)(uint8_t *, uint32_t);
-			int (*spi_rx)(uint8_t *, uint32_t);
-			int (*spi_trx)(uint8_t *, uint8_t *, uint32_t);
+			int (*spi_tx)(u8 *, uint32_t);
+			int (*spi_rx)(u8 *, uint32_t);
+			int (*spi_trx)(u8 *, u8 *, uint32_t);
 		} spi;
 	} u;
 } wilc_wlan_io_func_t;
 
 typedef struct {
-	void (*rx_indicate)(uint8_t *, uint32_t, uint32_t);
+	void (*rx_indicate)(u8 *, uint32_t, uint32_t);
 	void (*rx_complete)(void);
 } wilc_wlan_net_func_t;
 
@@ -156,7 +156,7 @@ typedef struct {
 struct tx_complete_data {
 	int size;
 	void *buff;
-	uint8_t *pBssid;
+	u8 *pBssid;
 	struct sk_buff *skb;
 };
 
@@ -166,20 +166,20 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF (-2)
 
 typedef struct {
-	int (*wlan_firmware_download)(const uint8_t *, uint32_t);
+	int (*wlan_firmware_download)(const u8 *, uint32_t);
 	int (*wlan_start)(void);
 	int (*wlan_stop)(void);
-	int (*wlan_add_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
+	int (*wlan_add_to_tx_que)(void *, u8 *, uint32_t, wilc_tx_complete_func_t);
 	int (*wlan_handle_tx_que)(uint32_t *);
 	void (*wlan_handle_rx_que)(void);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
-	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
+	int (*wlan_cfg_set)(int, uint32_t, u8 *, uint32_t, int, uint32_t);
 	int (*wlan_cfg_get)(int, uint32_t, int, uint32_t);
-	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
+	int (*wlan_cfg_get_value)(uint32_t, u8 *, uint32_t);
 	/*Bug3959: transmitting mgmt frames received from host*/
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-	int (*wlan_add_mgmt_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
+	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, uint32_t, wilc_tx_complete_func_t);
 	#endif
 } wilc_wlan_oup_t;
 
@@ -939,7 +939,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup);
 
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
-uint32_t wilc_get_chipid(uint8_t update);
+uint32_t wilc_get_chipid(u8 update);
 
 
 #endif
-- 
2.5.1

