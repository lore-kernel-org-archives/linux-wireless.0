Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36238 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbbIOFHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:09 -0400
Received: by padhk3 with SMTP id hk3so164818938pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:08 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/18] staging: wilc1000: use u32 instead of uint32_t
Date: Tue, 15 Sep 2015 14:06:16 +0900
Message-Id: <1442293588-15323-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070731_337972_DBACFD46)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces uint32_t with u32 that is a preferred kernel type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         |   4 +-
 drivers/staging/wilc1000/linux_mon.c              |   4 +-
 drivers/staging/wilc1000/linux_wlan.c             |  10 +-
 drivers/staging/wilc1000/linux_wlan_spi.c         |   6 +-
 drivers/staging/wilc1000/linux_wlan_spi.h         |   4 +-
 drivers/staging/wilc1000/wilc_sdio.c              |  64 +++++-----
 drivers/staging/wilc1000/wilc_spi.c               |  66 +++++-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   6 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 148 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wlan.h              |  30 ++---
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  30 ++---
 drivers/staging/wilc1000/wilc_wlan_cfg.h          |   6 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |  52 ++++----
 14 files changed, 216 insertions(+), 216 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3bab93c..59327aa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3380,7 +3380,7 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatistics)
 {
 	tstrWID strWIDList[5];
-	uint32_t u32WidsCount = 0, s32Error = 0;
+	u32 u32WidsCount = 0, s32Error = 0;
 
 	strWIDList[u32WidsCount].u16WIDid = WID_LINKSPEED;
 	strWIDList[u32WidsCount].enuWIDtype = WID_CHAR;
@@ -7460,7 +7460,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	return s32Error;
 }
 #endif /*WILC_AP_EXTERNAL_MLME*/
-uint32_t wilc_get_chipid(u8);
+u32 wilc_get_chipid(u8);
 
 s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index a38d293..01e8be1 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -54,9 +54,9 @@ u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 #define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
-void WILC_WFI_monitor_rx(u8 *buff, uint32_t size)
+void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 {
-	uint32_t header, pkt_offset;
+	u32 header, pkt_offset;
 	struct sk_buff *skb = NULL;
 	struct wilc_wfi_radiotap_hdr *hdr;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f3036eb..6eafd0b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -110,11 +110,11 @@ static struct semaphore close_exit_sync;
 
 static int wlan_deinit_locks(linux_wlan_t *nic);
 static void wlan_deinitialize_threads(linux_wlan_t *nic);
-extern void WILC_WFI_monitor_rx(u8 *buff, uint32_t size);
-extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, uint32_t size);
+extern void WILC_WFI_monitor_rx(u8 *buff, u32 size);
+extern void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 
 static void linux_wlan_tx_complete(void *priv, int status);
-void frmw_to_linux(u8 *buff, uint32_t size, uint32_t pkt_offset);
+void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 static int  mac_init_fn(struct net_device *ndev);
 int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
 int  mac_open(struct net_device *ndev);
@@ -1963,7 +1963,7 @@ done:
 	return s32Error;
 }
 
-void frmw_to_linux(u8 *buff, uint32_t size, uint32_t pkt_offset)
+void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
 {
 
 	unsigned int frame_len = 0;
@@ -2042,7 +2042,7 @@ void frmw_to_linux(u8 *buff, uint32_t size, uint32_t pkt_offset)
 		#endif
 }
 
-void WILC_WFI_mgmt_rx(u8 *buff, uint32_t size)
+void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 {
 	int i = 0;
 	perInterface_wlan_t *nic;
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index d0802fd..3e24256 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -38,7 +38,7 @@
  #define MAX_SPEED 6000000
 #endif /* WILC_ASIC_A0 */
 
-static uint32_t SPEED = MIN_SPEED;
+static u32 SPEED = MIN_SPEED;
 
 struct spi_device *wilc_spi_dev;
 void linux_spi_deinit(void *vp);
@@ -115,7 +115,7 @@ int linux_spi_init(void *vp)
 
 #if defined(TXRX_PHASE_SIZE)
 
-int linux_spi_write(u8 *b, uint32_t len)
+int linux_spi_write(u8 *b, u32 len)
 {
 	int ret;
 
@@ -194,7 +194,7 @@ int linux_spi_write(u8 *b, uint32_t len)
 }
 
 #else
-int linux_spi_write(u8 *b, uint32_t len)
+int linux_spi_write(u8 *b, u32 len)
 {
 
 	int ret;
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
index 2b52738..d8eed0f 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ b/drivers/staging/wilc1000/linux_wlan_spi.h
@@ -7,8 +7,8 @@ extern struct spi_driver wilc_bus;
 
 int linux_spi_init(void *vp);
 void linux_spi_deinit(void *vp);
-int linux_spi_write(u8 *b, uint32_t len);
-int linux_spi_read(u8 *rb, uint32_t rlen);
+int linux_spi_write(u8 *b, u32 len);
+int linux_spi_read(u8 *rb, u32 rlen);
 int linux_spi_write_read(unsigned char *wb, unsigned char *rb, unsigned int rlen);
 int linux_spi_set_max_speed(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index fb0b894..820aac5 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -15,7 +15,7 @@
 typedef struct {
 	void *os_context;
 	wilc_wlan_os_func_t os_func;
-	uint32_t block_size;
+	u32 block_size;
 	int (*sdio_cmd52)(sdio_cmd52_t *);
 	int (*sdio_cmd53)(sdio_cmd53_t *);
 	int (*sdio_set_max_speed)(void);
@@ -29,8 +29,8 @@ typedef struct {
 static wilc_sdio_t g_sdio;
 
 #ifdef WILC_SDIO_IRQ_GPIO
-static int sdio_write_reg(uint32_t addr, uint32_t data);
-static int sdio_read_reg(uint32_t addr, uint32_t *data);
+static int sdio_write_reg(u32 addr, u32 data);
+static int sdio_read_reg(u32 addr, u32 *data);
 #endif
 
 /********************************************
@@ -39,7 +39,7 @@ static int sdio_read_reg(uint32_t addr, uint32_t *data);
  *
  ********************************************/
 
-static int sdio_set_func0_csa_address(uint32_t adr)
+static int sdio_set_func0_csa_address(u32 adr)
 {
 	sdio_cmd52_t cmd;
 
@@ -75,7 +75,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_set_func0_csa_address_byte0(uint32_t adr)
+static int sdio_set_func0_csa_address_byte0(u32 adr)
 {
 	sdio_cmd52_t cmd;
 
@@ -97,7 +97,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_set_func0_block_size(uint32_t block_size)
+static int sdio_set_func0_block_size(u32 block_size)
 {
 	sdio_cmd52_t cmd;
 
@@ -129,7 +129,7 @@ _fail_:
  *
  ********************************************/
 
-static int sdio_set_func1_block_size(uint32_t block_size)
+static int sdio_set_func1_block_size(u32 block_size)
 {
 	sdio_cmd52_t cmd;
 
@@ -157,7 +157,7 @@ _fail_:
 static int sdio_clear_int(void)
 {
 #ifndef WILC_SDIO_IRQ_GPIO
-	/* uint32_t sts; */
+	/* u32 sts; */
 	sdio_cmd52_t cmd;
 
 	cmd.read_write = 0;
@@ -169,7 +169,7 @@ static int sdio_clear_int(void)
 
 	return cmd.data;
 #else
-	uint32_t reg;
+	u32 reg;
 
 	if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
 		g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
@@ -182,9 +182,9 @@ static int sdio_clear_int(void)
 
 }
 
-uint32_t sdio_xfer_cnt(void)
+u32 sdio_xfer_cnt(void)
 {
-	uint32_t cnt = 0;
+	u32 cnt = 0;
 	sdio_cmd52_t cmd;
 
 	cmd.read_write = 0;
@@ -243,7 +243,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_write_reg(uint32_t addr, uint32_t data)
+static int sdio_write_reg(u32 addr, u32 data)
 {
 #ifdef BIG_ENDIAN
 	data = BYTE_SWAP(data);
@@ -292,9 +292,9 @@ _fail_:
 	return 0;
 }
 
-static int sdio_write(uint32_t addr, u8 *buf, uint32_t size)
+static int sdio_write(u32 addr, u8 *buf, u32 size)
 {
-	uint32_t block_size = g_sdio.block_size;
+	u32 block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
 	int nblk, nleft;
 
@@ -376,7 +376,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_read_reg(uint32_t addr, uint32_t *data)
+static int sdio_read_reg(u32 addr, u32 *data)
 {
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
 		sdio_cmd52_t cmd;
@@ -423,9 +423,9 @@ _fail_:
 	return 0;
 }
 
-static int sdio_read(uint32_t addr, u8 *buf, uint32_t size)
+static int sdio_read(u32 addr, u8 *buf, u32 size)
 {
-	uint32_t block_size = g_sdio.block_size;
+	u32 block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
 	int nblk, nleft;
 
@@ -520,7 +520,7 @@ static int sdio_deinit(void *pv)
 
 static int sdio_sync(void)
 {
-	uint32_t reg;
+	u32 reg;
 
 	/**
 	 *      Disable power sequencer
@@ -538,7 +538,7 @@ static int sdio_sync(void)
 
 #ifdef WILC_SDIO_IRQ_GPIO
 	{
-		uint32_t reg;
+		u32 reg;
 		int ret;
 
 		/**
@@ -580,7 +580,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 {
 	sdio_cmd52_t cmd;
 	int loop;
-	uint32_t chipid;
+	u32 chipid;
 
 	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
 
@@ -712,10 +712,10 @@ static void sdio_set_default_speed(void)
 	g_sdio.sdio_set_default_speed();
 }
 
-static int sdio_read_size(uint32_t *size)
+static int sdio_read_size(u32 *size)
 {
 
-	uint32_t tmp;
+	u32 tmp;
 	sdio_cmd52_t cmd;
 
 	/**
@@ -741,10 +741,10 @@ static int sdio_read_size(uint32_t *size)
 	return 1;
 }
 
-static int sdio_read_int(uint32_t *int_status)
+static int sdio_read_int(u32 *int_status)
 {
 
-	uint32_t tmp;
+	u32 tmp;
 	sdio_cmd52_t cmd;
 
 	sdio_read_size(&tmp);
@@ -784,7 +784,7 @@ static int sdio_read_int(uint32_t *int_status)
 	}
 #else
 	{
-		uint32_t irq_flags;
+		u32 irq_flags;
 
 		cmd.read_write = 0;
 		cmd.function = 0;
@@ -803,16 +803,16 @@ static int sdio_read_int(uint32_t *int_status)
 	return 1;
 }
 
-static int sdio_clear_int_ext(uint32_t val)
+static int sdio_clear_int_ext(u32 val)
 {
 	int ret;
 
 	if (g_sdio.has_thrpt_enh3) {
-		uint32_t reg;
+		u32 reg;
 
 #ifdef WILC_SDIO_IRQ_GPIO
 		{
-			uint32_t flags;
+			u32 flags;
 
 			flags = val & ((1 << MAX_NUN_INT_THRPT_ENH2) - 1);
 			reg = flags;
@@ -850,7 +850,7 @@ static int sdio_clear_int_ext(uint32_t val)
 		{
 			/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
 			/* Cannot clear multiple interrupts. Must clear each interrupt individually */
-			uint32_t flags;
+			u32 flags;
 
 			flags = val & ((1 << MAX_NUM_INT) - 1);
 			if (flags) {
@@ -890,7 +890,7 @@ static int sdio_clear_int_ext(uint32_t val)
 #endif /* WILC_SDIO_IRQ_GPIO */
 
 		{
-			uint32_t vmm_ctl;
+			u32 vmm_ctl;
 
 			vmm_ctl = 0;
 			/* select VMM table 0 */
@@ -927,7 +927,7 @@ _fail_:
 
 static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 {
-	uint32_t reg;
+	u32 reg;
 
 	if (nint > MAX_NUM_INT) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Too many interupts (%d)...\n", nint);
@@ -956,7 +956,7 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 
 #ifdef WILC_SDIO_IRQ_GPIO
 	{
-		uint32_t reg;
+		u32 reg;
 		int ret, i;
 
 		/**
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index c31e17a..fd3ef97 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -16,9 +16,9 @@
  */
 typedef struct {
 	void *os_context;
-	int (*spi_tx)(u8 *, uint32_t);
-	int (*spi_rx)(u8 *, uint32_t);
-	int (*spi_trx)(u8 *, u8 *, uint32_t);
+	int (*spi_tx)(u8 *, u32);
+	int (*spi_rx)(u8 *, u32);
+	int (*spi_trx)(u8 *, u8 *, u32);
 	int (*spi_max_speed)(void);
 	wilc_debug_func dPrint;
 	int crc_off;
@@ -28,8 +28,8 @@ typedef struct {
 
 static wilc_spi_t g_spi;
 
-static int spi_read(uint32_t, u8 *, uint32_t);
-static int spi_write(uint32_t, u8 *, uint32_t);
+static int spi_read(u32, u8 *, u32);
+static int spi_write(u32, u8 *, u32);
 
 /********************************************
  *
@@ -77,7 +77,7 @@ static u8 crc7_byte(u8 crc, u8 data)
 	return crc7_syndrome_table[(crc << 1) ^ data];
 }
 
-static u8 crc7(u8 crc, const u8 *buffer, uint32_t len)
+static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 {
 	while (len--)
 		crc = crc7_byte(crc, *buffer++);
@@ -114,7 +114,7 @@ static u8 crc7(u8 crc, const u8 *buffer, uint32_t len)
 #define DATA_PKT_SZ_8K				(8 * 1024)
 #define DATA_PKT_SZ					DATA_PKT_SZ_8K
 
-static int spi_cmd(u8 cmd, uint32_t adr, uint32_t data, uint32_t sz, u8 clockless)
+static int spi_cmd(u8 cmd, u32 adr, u32 data, u32 sz, u8 clockless)
 {
 	u8 bc[9];
 	int len = 5;
@@ -271,11 +271,11 @@ _fail_:
 	return result;
 }
 
-static int spi_cmd_complete(u8 cmd, uint32_t adr, u8 *b, uint32_t sz, u8 clockless)
+static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 {
 	u8 wb[32], rb[32];
 	u8 wix, rix;
-	uint32_t len2;
+	u32 len2;
 	u8 rsp;
 	int len = 0;
 	int result = N_OK;
@@ -610,7 +610,7 @@ _error_:
 	return result;
 }
 
-static int spi_data_read(u8 *b, uint32_t sz)
+static int spi_data_read(u8 *b, u32 sz)
 {
 	int retry, ix, nbytes;
 	int result = N_OK;
@@ -678,7 +678,7 @@ static int spi_data_read(u8 *b, uint32_t sz)
 	return result;
 }
 
-static int spi_data_write(u8 *b, uint32_t sz)
+static int spi_data_write(u8 *b, u32 sz)
 {
 	int ix, nbytes;
 	int result = 1;
@@ -755,7 +755,7 @@ static int spi_data_write(u8 *b, uint32_t sz)
  *
  ********************************************/
 
-static int spi_internal_write(uint32_t adr, uint32_t dat)
+static int spi_internal_write(u32 adr, u32 dat)
 {
 	int result;
 
@@ -787,7 +787,7 @@ static int spi_internal_write(uint32_t adr, uint32_t dat)
 	return result;
 }
 
-static int spi_internal_read(uint32_t adr, uint32_t *data)
+static int spi_internal_read(u32 adr, u32 *data)
 {
 	int result;
 
@@ -834,7 +834,7 @@ static int spi_internal_read(uint32_t adr, uint32_t *data)
  *
  ********************************************/
 
-static int spi_write_reg(uint32_t addr, uint32_t data)
+static int spi_write_reg(u32 addr, u32 data)
 {
 	int result = N_OK;
 	u8 cmd = CMD_SINGLE_WRITE;
@@ -877,7 +877,7 @@ static int spi_write_reg(uint32_t addr, uint32_t data)
 
 }
 
-static int spi_write(uint32_t addr, u8 *buf, uint32_t size)
+static int spi_write(u32 addr, u8 *buf, u32 size)
 {
 	int result;
 	u8 cmd = CMD_DMA_EXT_WRITE;
@@ -922,7 +922,7 @@ static int spi_write(uint32_t addr, u8 *buf, uint32_t size)
 	return 1;
 }
 
-static int spi_read_reg(uint32_t addr, uint32_t *data)
+static int spi_read_reg(u32 addr, u32 *data)
 {
 	int result = N_OK;
 	u8 cmd = CMD_SINGLE_READ;
@@ -968,7 +968,7 @@ static int spi_read_reg(uint32_t addr, uint32_t *data)
 	return 1;
 }
 
-static int spi_read(uint32_t addr, u8 *buf, uint32_t size)
+static int spi_read(u32 addr, u8 *buf, u32 size)
 {
 	u8 cmd = CMD_DMA_EXT_READ;
 	int result;
@@ -1020,7 +1020,7 @@ static int spi_read(uint32_t addr, u8 *buf, uint32_t size)
 
 static int spi_clear_int(void)
 {
-	uint32_t reg;
+	u32 reg;
 
 	if (!spi_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
@@ -1041,7 +1041,7 @@ static int spi_deinit(void *pv)
 
 static int spi_sync(void)
 {
-	uint32_t reg;
+	u32 reg;
 	int ret;
 
 	/**
@@ -1079,8 +1079,8 @@ static int spi_sync(void)
 
 static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 {
-	uint32_t reg;
-	uint32_t chipid;
+	u32 reg;
+	u32 chipid;
 
 	static int isinit;
 
@@ -1165,7 +1165,7 @@ static void spi_default_bus_speed(void)
 {
 }
 
-static int spi_read_size(uint32_t *size)
+static int spi_read_size(u32 *size)
 {
 	int ret;
 
@@ -1173,8 +1173,8 @@ static int spi_read_size(uint32_t *size)
 		ret = spi_internal_read(0xe840 - WILC_SPI_REG_BASE, size);
 		*size = *size  & IRQ_DMA_WD_CNT_MASK;
 	} else {
-		uint32_t tmp;
-		uint32_t byte_cnt;
+		u32 tmp;
+		u32 byte_cnt;
 
 		ret = spi_read_reg(WILC_VMM_TO_HOST_SIZE, &byte_cnt);
 		if (!ret) {
@@ -1193,15 +1193,15 @@ _fail_:
 
 
 
-static int spi_read_int(uint32_t *int_status)
+static int spi_read_int(u32 *int_status)
 {
 	int ret;
 
 	if (g_spi.has_thrpt_enh) {
 		ret = spi_internal_read(0xe840 - WILC_SPI_REG_BASE, int_status);
 	} else {
-		uint32_t tmp;
-		uint32_t byte_cnt;
+		u32 tmp;
+		u32 byte_cnt;
 
 		ret = spi_read_reg(WILC_VMM_TO_HOST_SIZE, &byte_cnt);
 		if (!ret) {
@@ -1215,7 +1215,7 @@ static int spi_read_int(uint32_t *int_status)
 
 			j = 0;
 			do {
-				uint32_t irq_flags;
+				u32 irq_flags;
 
 				happended = 0;
 
@@ -1228,7 +1228,7 @@ static int spi_read_int(uint32_t *int_status)
 				}
 
 				{
-					uint32_t unkmown_mask;
+					u32 unkmown_mask;
 
 					unkmown_mask = ~((1ul << g_spi.nint) - 1);
 
@@ -1249,14 +1249,14 @@ _fail_:
 	return ret;
 }
 
-static int spi_clear_int_ext(uint32_t val)
+static int spi_clear_int_ext(u32 val)
 {
 	int ret;
 
 	if (g_spi.has_thrpt_enh) {
 		ret = spi_internal_write(0xe844 - WILC_SPI_REG_BASE, val);
 	} else {
-		uint32_t flags;
+		u32 flags;
 
 		flags = val & ((1 << MAX_NUM_INT) - 1);
 		if (flags) {
@@ -1283,7 +1283,7 @@ static int spi_clear_int_ext(uint32_t val)
 		}
 
 		{
-			uint32_t tbl_ctl;
+			u32 tbl_ctl;
 
 			tbl_ctl = 0;
 			/* select VMM table 0 */
@@ -1317,7 +1317,7 @@ _fail_:
 
 static int spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 {
-	uint32_t reg;
+	u32 reg;
 	int ret, i;
 
 	if (nint > MAX_NUM_INT) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4126acd..2671cdf 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -162,7 +162,7 @@ void clear_shadow_scan(void *pUserVoid)
 
 }
 
-uint32_t get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
+u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
 {
 	u8 i;
 	int rssi_v = 0;
@@ -301,7 +301,7 @@ int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
 	int8_t ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
-	uint32_t ap_index = 0;
+	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
 	if (u32LastScannedNtwrksCountShadow >= MAX_NUM_SCANNED_NETWORKS_SHADOW) {
@@ -2198,7 +2198,7 @@ void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
  *  @version		1.0
  */
 
-void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, uint32_t size)
+void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 {
 
 	struct wilc_priv *priv;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index eb160d5..51f9413 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -111,7 +111,7 @@ void WILC_WFI_WiphyFree(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
 int WILC_WFI_DeInitHostInt(struct net_device *net);
 int WILC_WFI_InitHostInt(struct net_device *net);
-void WILC_WFI_monitor_rx(u8 *buff, uint32_t size);
+void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 int WILC_WFI_deinit_mon_interface(void);
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c76134a..7496c1f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -19,8 +19,8 @@
 extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
 extern wilc_cfg_func_t mac_cfg;
-extern void WILC_WFI_mgmt_rx(u8 *buff, uint32_t size);
-uint32_t wilc_get_chipid(u8 update);
+extern void WILC_WFI_mgmt_rx(u8 *buff, u32 size);
+u32 wilc_get_chipid(u8 update);
 u16 Set_machw_change_vir_if(bool bValue);
 
 
@@ -48,7 +48,7 @@ typedef struct {
 	wilc_cfg_func_t cif_func;
 	int cfg_frame_in_use;
 	wilc_cfg_frame_t cfg_frame;
-	uint32_t cfg_frame_offset;
+	u32 cfg_frame_offset;
 	int cfg_seq_no;
 	void *cfg_wait;
 
@@ -56,16 +56,16 @@ typedef struct {
 	 *      RX buffer
 	 **/
 	#ifdef MEMORY_STATIC
-	uint32_t rx_buffer_size;
+	u32 rx_buffer_size;
 	u8 *rx_buffer;
-	uint32_t rx_buffer_offset;
+	u32 rx_buffer_offset;
 	#endif
 	/**
 	 *      TX buffer
 	 **/
-	uint32_t tx_buffer_size;
+	u32 tx_buffer_size;
 	u8 *tx_buffer;
-	uint32_t tx_buffer_offset;
+	u32 tx_buffer_offset;
 
 	/**
 	 *      TX queue
@@ -106,9 +106,9 @@ INLINE void chip_wakeup(void);
  *
  ********************************************/
 
-static uint32_t dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
+static u32 dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
 
-static void wilc_debug(uint32_t flag, char *fmt, ...)
+static void wilc_debug(u32 flag, char *fmt, ...)
 {
 	char buf[256];
 	va_list args;
@@ -278,21 +278,21 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 
 }
 
-uint32_t Statisitcs_totalAcks = 0, Statisitcs_DroppedAcks = 0;
+u32 Statisitcs_totalAcks = 0, Statisitcs_DroppedAcks = 0;
 
 #ifdef	TCP_ACK_FILTER
 struct Ack_session_info;
 struct Ack_session_info {
-	uint32_t Ack_seq_num;
-	uint32_t Bigger_Ack_num;
+	u32 Ack_seq_num;
+	u32 Bigger_Ack_num;
 	u16 src_port;
 	u16 dst_port;
 	u16 status;
 };
 
 typedef struct {
-	uint32_t ack_num;
-	uint32_t Session_index;
+	u32 ack_num;
+	u32 Session_index;
 	struct txq_entry_t  *txqe;
 } Pending_Acks_info_t /*Ack_info_t*/;
 
@@ -312,9 +312,9 @@ struct Ack_session_info *Alloc_head;
 struct Ack_session_info Acks_keep_track_info[2 * MAX_TCP_SESSION];
 Pending_Acks_info_t Pending_Acks_info[MAX_PENDING_ACKS];
 
-uint32_t PendingAcks_arrBase;
-uint32_t Opened_TCP_session;
-uint32_t Pending_Acks;
+u32 PendingAcks_arrBase;
+u32 Opened_TCP_session;
+u32 Pending_Acks;
 
 
 
@@ -324,7 +324,7 @@ static __inline int Init_TCP_tracking(void)
 	return 0;
 
 }
-static __inline int add_TCP_track_session(uint32_t src_prt, uint32_t dst_prt, uint32_t seq)
+static __inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
 	Acks_keep_track_info[Opened_TCP_session].Ack_seq_num = seq;
 	Acks_keep_track_info[Opened_TCP_session].Bigger_Ack_num = 0;
@@ -336,7 +336,7 @@ static __inline int add_TCP_track_session(uint32_t src_prt, uint32_t dst_prt, ui
 	return 0;
 }
 
-static __inline int Update_TCP_track_session(uint32_t index, uint32_t Ack)
+static __inline int Update_TCP_track_session(u32 index, u32 Ack)
 {
 
 	if (Ack > Acks_keep_track_info[index].Bigger_Ack_num) {
@@ -345,7 +345,7 @@ static __inline int Update_TCP_track_session(uint32_t index, uint32_t Ack)
 	return 0;
 
 }
-static __inline int add_TCP_Pending_Ack(uint32_t Ack, uint32_t Session_index, struct txq_entry_t  *txqe)
+static __inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_entry_t  *txqe)
 {
 	Statisitcs_totalAcks++;
 	if (Pending_Acks < MAX_PENDING_ACKS) {
@@ -395,18 +395,18 @@ static __inline int tcp_process(struct txq_entry_t *tqe)
 
 		if (protocol == 0x06) {
 			u8 *tcp_hdr_ptr;
-			uint32_t IHL, Total_Length, Data_offset;
+			u32 IHL, Total_Length, Data_offset;
 
 			tcp_hdr_ptr = &ip_hdr_ptr[IP_HDR_LEN];
 			IHL = (ip_hdr_ptr[0] & 0xf) << 2;
-			Total_Length = (((uint32_t)ip_hdr_ptr[2]) << 8) + ((uint32_t)ip_hdr_ptr[3]);
-			Data_offset = (((uint32_t)tcp_hdr_ptr[12] & 0xf0) >> 2);
+			Total_Length = (((u32)ip_hdr_ptr[2]) << 8) + ((u32)ip_hdr_ptr[3]);
+			Data_offset = (((u32)tcp_hdr_ptr[12] & 0xf0) >> 2);
 			if (Total_Length == (IHL + Data_offset)) { /*we want to recognize the clear Acks(packet only carry Ack infos not with data) so data size must be equal zero*/
-				uint32_t seq_no, Ack_no;
+				u32 seq_no, Ack_no;
 
-				seq_no	= (((uint32_t)tcp_hdr_ptr[4]) << 24) + (((uint32_t)tcp_hdr_ptr[5]) << 16) + (((uint32_t)tcp_hdr_ptr[6]) << 8) + ((uint32_t)tcp_hdr_ptr[7]);
+				seq_no	= (((u32)tcp_hdr_ptr[4]) << 24) + (((u32)tcp_hdr_ptr[5]) << 16) + (((u32)tcp_hdr_ptr[6]) << 8) + ((u32)tcp_hdr_ptr[7]);
 
-				Ack_no	= (((uint32_t)tcp_hdr_ptr[8]) << 24) + (((uint32_t)tcp_hdr_ptr[9]) << 16) + (((uint32_t)tcp_hdr_ptr[10]) << 8) + ((uint32_t)tcp_hdr_ptr[11]);
+				Ack_no	= (((u32)tcp_hdr_ptr[8]) << 24) + (((u32)tcp_hdr_ptr[9]) << 16) + (((u32)tcp_hdr_ptr[10]) << 8) + ((u32)tcp_hdr_ptr[11]);
 
 
 				for (i = 0; i < Opened_TCP_session; i++) {
@@ -437,8 +437,8 @@ static __inline int tcp_process(struct txq_entry_t *tqe)
 static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 {
 
-	uint32_t i = 0;
-	uint32_t Dropped = 0;
+	u32 i = 0;
+	u32 Dropped = 0;
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 
 	spin_lock_irqsave(p->txq_spinlock, p->txq_spinlock_flags);
@@ -494,7 +494,7 @@ bool is_TCP_ACK_Filter_Enabled(void)
 }
 #endif
 
-static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, uint32_t buffer_size)
+static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	struct txq_entry_t *tqe;
@@ -531,7 +531,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, uint32_t buffer_size)
 	return 1;
 }
 
-static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, uint32_t buffer_size, wilc_tx_complete_func_t func)
+static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_complete_func_t func)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	struct txq_entry_t *tqe;
@@ -563,7 +563,7 @@ static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, uint32_t buffer_siz
 }
 /*Bug3959: transmitting mgmt frames received from host*/
 #if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, uint32_t buffer_size, wilc_tx_complete_func_t func)
+int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_complete_func_t func)
 {
 
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
@@ -680,7 +680,7 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(void)
 
 INLINE void chip_allow_sleep(void)
 {
-	uint32_t reg = 0;
+	u32 reg = 0;
 
 	/* Clear bit 1 */
 	g_wlan.hif_func.hif_read_reg(0xf0, &reg);
@@ -690,8 +690,8 @@ INLINE void chip_allow_sleep(void)
 
 INLINE void chip_wakeup(void)
 {
-	uint32_t reg, clk_status_reg, trials = 0;
-	uint32_t sleep_time;
+	u32 reg, clk_status_reg, trials = 0;
+	u32 sleep_time;
 
 	if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
 		do {
@@ -753,7 +753,7 @@ INLINE void chip_wakeup(void)
 
 		if (wilc_get_chipid(false) >= 0x1002b0) {
 			/* Enable PALDO back right after wakeup */
-			uint32_t val32;
+			u32 val32;
 
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
 			val32 |= (1 << 6);
@@ -769,7 +769,7 @@ INLINE void chip_wakeup(void)
 #else
 INLINE void chip_wakeup(void)
 {
-	uint32_t reg, trials = 0;
+	u32 reg, trials = 0;
 
 	do {
 		if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
@@ -810,7 +810,7 @@ INLINE void chip_wakeup(void)
 
 		if (wilc_get_chipid(false) >= 0x1002b0) {
 			/* Enable PALDO back right after wakeup */
-			uint32_t val32;
+			u32 val32;
 
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
 			val32 |= (1 << 6);
@@ -850,20 +850,20 @@ void chip_sleep_manually(u32 u32SleepTime)
  *      Tx, Rx queue handle functions
  *
  ********************************************/
-static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
+static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int i, entries = 0;
-	uint32_t sum;
-	uint32_t reg;
+	u32 sum;
+	u32 reg;
 	u8 *txb = p->tx_buffer;
-	uint32_t offset = 0;
+	u32 offset = 0;
 	int vmm_sz = 0;
 	struct txq_entry_t *tqe;
 	int ret = 0;
 	int counter;
 	int timeout;
-	uint32_t vmm_table[WILC_VMM_TBL_SIZE];
+	u32 vmm_table[WILC_VMM_TBL_SIZE];
 
 	p->txq_exit = 0;
 	do {
@@ -1071,7 +1071,7 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 		do {
 			tqe = wilc_wlan_txq_remove_from_head();
 			if (tqe != NULL && (vmm_table[i] != 0)) {
-				uint32_t header, buffer_offset;
+				u32 header, buffer_offset;
 
 #ifdef BIG_ENDIAN
 				vmm_table[i] = BYTE_SWAP(vmm_table[i]);
@@ -1193,8 +1193,8 @@ static void wilc_wlan_handle_rxq(void)
 
 
 		do {
-			uint32_t header;
-			uint32_t pkt_len, pkt_offset, tp_len;
+			u32 header;
+			u32 pkt_len, pkt_offset, tp_len;
 			int is_cfg_packet;
 
 			PRINT_D(RX_DBG, "In the 2nd do-while\n");
@@ -1300,7 +1300,7 @@ static void wilc_unknown_isr_ext(void)
 {
 	g_wlan.hif_func.hif_clear_int_ext(0);
 }
-static void wilc_pllupdate_isr_ext(uint32_t int_stats)
+static void wilc_pllupdate_isr_ext(u32 int_stats)
 {
 
 	int trials = 10;
@@ -1317,7 +1317,7 @@ static void wilc_pllupdate_isr_ext(uint32_t int_stats)
 	}
 }
 
-static void wilc_sleeptimer_isr_ext(uint32_t int_stats1)
+static void wilc_sleeptimer_isr_ext(u32 int_stats1)
 {
 	g_wlan.hif_func.hif_clear_int_ext(SLEEP_INT_CLR);
 #ifndef WILC_OPTIMIZE_SLEEP_INT
@@ -1325,15 +1325,15 @@ static void wilc_sleeptimer_isr_ext(uint32_t int_stats1)
 #endif
 }
 
-static void wilc_wlan_handle_isr_ext(uint32_t int_status)
+static void wilc_wlan_handle_isr_ext(u32 int_status)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 #ifdef MEMORY_STATIC
-	uint32_t offset = p->rx_buffer_offset;
+	u32 offset = p->rx_buffer_offset;
 #endif
 	u8 *buffer = NULL;
-	uint32_t size;
-	uint32_t retries = 0;
+	u32 size;
+	u32 retries = 0;
 	int ret = 0;
 	struct rxq_entry_t *rqe;
 
@@ -1345,7 +1345,7 @@ static void wilc_wlan_handle_isr_ext(uint32_t int_status)
 	size = ((int_status & 0x7fff) << 2);
 
 	while (!size && retries < 10) {
-		uint32_t time = 0;
+		u32 time = 0;
 		/*looping more secure*/
 		/*zero size make a crashe because the dma will not happen and that will block the firmware*/
 		wilc_debug(N_ERR, "RX Size equal zero ... Trying to read it again for %d time\n", time++);
@@ -1423,7 +1423,7 @@ _end_:
 
 void wilc_handle_isr(void)
 {
-	uint32_t int_status;
+	u32 int_status;
 
 	acquire_bus(ACQUIRE_AND_WAKEUP);
 	g_wlan.hif_func.hif_read_int(&int_status);
@@ -1459,11 +1459,11 @@ void wilc_handle_isr(void)
  *      Firmware download
  *
  ********************************************/
-static int wilc_wlan_firmware_download(const u8 *buffer, uint32_t buffer_size)
+static int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
-	uint32_t offset;
-	uint32_t addr, size, size2, blksz;
+	u32 offset;
+	u32 addr, size, size2, blksz;
 	u8 *dma_buffer;
 	int ret = 0;
 
@@ -1535,9 +1535,9 @@ _fail_1:
 static int wilc_wlan_start(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
-	uint32_t reg = 0;
+	u32 reg = 0;
 	int ret;
-	uint32_t chipid;
+	u32 chipid;
 
 	/**
 	 *      Set the host interface
@@ -1665,7 +1665,7 @@ void wilc_wlan_global_reset(void)
 static int wilc_wlan_stop(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
-	uint32_t reg = 0;
+	u32 reg = 0;
 	int ret;
 	u8 timeout = 10;
 	/**
@@ -1742,7 +1742,7 @@ static void wilc_wlan_cleanup(void)
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	struct txq_entry_t *tqe;
 	struct rxq_entry_t *rqe;
-	uint32_t reg = 0;
+	u32 reg = 0;
 	int ret;
 
 	p->quit = 1;
@@ -1797,7 +1797,7 @@ static void wilc_wlan_cleanup(void)
 
 }
 
-static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
+static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	wilc_cfg_frame_t *cfg = &p->cfg_frame;
@@ -1834,10 +1834,10 @@ static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
 	return 0;
 }
 
-static int wilc_wlan_cfg_set(int start, uint32_t wid, u8 *buffer, uint32_t buffer_size, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size, int commit, u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
-	uint32_t offset;
+	u32 offset;
 	int ret_size;
 
 
@@ -1873,10 +1873,10 @@ static int wilc_wlan_cfg_set(int start, uint32_t wid, u8 *buffer, uint32_t buffe
 
 	return ret_size;
 }
-static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
-	uint32_t offset;
+	u32 offset;
 	int ret_size;
 
 
@@ -1912,7 +1912,7 @@ static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHa
 	return ret_size;
 }
 
-static int wilc_wlan_cfg_get_val(uint32_t wid, u8 *buffer, uint32_t buffer_size)
+static int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int ret;
@@ -1935,10 +1935,10 @@ void wilc_bus_set_default_speed(void)
 	/* Restore bus speed to default.  */
 	g_wlan.hif_func.hif_set_default_bus_speed();
 }
-uint32_t init_chip(void)
+u32 init_chip(void)
 {
-	uint32_t chipid;
-	uint32_t reg, ret = 0;
+	u32 chipid;
+	u32 reg, ret = 0;
 
 	acquire_bus(ACQUIRE_ONLY);
 
@@ -1980,13 +1980,13 @@ uint32_t init_chip(void)
 
 }
 
-uint32_t wilc_get_chipid(u8 update)
+u32 wilc_get_chipid(u8 update)
 {
-	static uint32_t chipid;
+	static u32 chipid;
 	/* SDIO can't read into global variables */
 	/* Use this variable as a temp, then copy to the global */
-	uint32_t tempchipid = 0;
-	uint32_t rfrevid;
+	u32 tempchipid = 0;
+	u32 rfrevid;
 
 	if (chipid == 0 || update != 0) {
 		g_wlan.hif_func.hif_read_reg(0x1000, &tempchipid);
@@ -2019,7 +2019,7 @@ _fail_:
 #ifdef COMPLEMENT_BOOT
 u8 core_11b_ready(void)
 {
-	uint32_t reg_val;
+	u32 reg_val;
 
 	acquire_bus(ACQUIRE_ONLY);
 	g_wlan.hif_func.hif_write_reg(0x16082c, 1);
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 0f26c13..18bc11c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -227,7 +227,7 @@
  *      Debug Type
  *
  ********************************************/
-typedef void (*wilc_debug_func)(uint32_t, char *, ...);
+typedef void (*wilc_debug_func)(u32, char *, ...);
 
 /********************************************
  *
@@ -262,17 +262,17 @@ struct rxq_entry_t {
 typedef struct {
 	int (*hif_init)(wilc_wlan_inp_t *, wilc_debug_func);
 	int (*hif_deinit)(void *);
-	int (*hif_read_reg)(uint32_t, uint32_t *);
-	int (*hif_write_reg)(uint32_t, uint32_t);
-	int (*hif_block_rx)(uint32_t, u8 *, uint32_t);
-	int (*hif_block_tx)(uint32_t, u8 *, uint32_t);
+	int (*hif_read_reg)(u32, u32 *);
+	int (*hif_write_reg)(u32, u32);
+	int (*hif_block_rx)(u32, u8 *, u32);
+	int (*hif_block_tx)(u32, u8 *, u32);
 	int (*hif_sync)(void);
 	int (*hif_clear_int)(void);
-	int (*hif_read_int)(uint32_t *);
-	int (*hif_clear_int_ext)(uint32_t);
-	int (*hif_read_size)(uint32_t *);
-	int (*hif_block_tx_ext)(uint32_t, u8 *, uint32_t);
-	int (*hif_block_rx_ext)(uint32_t, u8 *, uint32_t);
+	int (*hif_read_int)(u32 *);
+	int (*hif_clear_int_ext)(u32);
+	int (*hif_read_size)(u32 *);
+	int (*hif_block_tx_ext)(u32, u8 *, u32);
+	int (*hif_block_rx_ext)(u32, u8 *, u32);
 	int (*hif_sync_ext)(int);
 	void (*hif_set_max_bus_speed)(void);
 	void (*hif_set_default_bus_speed)(void);
@@ -295,18 +295,18 @@ typedef struct {
 } wilc_cfg_frame_t;
 
 typedef struct {
-	int (*wlan_tx)(u8 *, uint32_t, wilc_tx_complete_func_t);
+	int (*wlan_tx)(u8 *, u32, wilc_tx_complete_func_t);
 } wilc_wlan_cfg_func_t;
 
 typedef struct {
 	int type;
-	uint32_t seq_no;
+	u32 seq_no;
 } wilc_cfg_rsp_t;
 
 typedef struct {
-	int (*cfg_wid_set)(u8 *, uint32_t, u16, u8 *, int);
-	int (*cfg_wid_get)(u8 *, uint32_t, u16);
-	int (*cfg_wid_get_val)(u16, u8 *, uint32_t);
+	int (*cfg_wid_set)(u8 *, u32, u16, u8 *, int);
+	int (*cfg_wid_get)(u8 *, u32, u16);
+	int (*cfg_wid_get_val)(u16, u8 *, u32);
 	int (*rx_indicate)(u8 *, int, wilc_cfg_rsp_t *);
 	int (*cfg_init)(wilc_debug_func);
 } wilc_cfg_func_t;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index f5bbbe8..473d756 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -160,7 +160,7 @@ static wilc_cfg_str_t g_cfg_str[] = {
  *
  ********************************************/
 
-static int wilc_wlan_cfg_set_byte(u8 *frame, uint32_t offset, u16 id, u8 val8)
+static int wilc_wlan_cfg_set_byte(u8 *frame, u32 offset, u16 id, u8 val8)
 {
 	u8 *buf;
 
@@ -176,7 +176,7 @@ static int wilc_wlan_cfg_set_byte(u8 *frame, uint32_t offset, u16 id, u8 val8)
 	return 4;
 }
 
-static int wilc_wlan_cfg_set_hword(u8 *frame, uint32_t offset, u16 id, u16 val16)
+static int wilc_wlan_cfg_set_hword(u8 *frame, u32 offset, u16 id, u16 val16)
 {
 	u8 *buf;
 
@@ -194,7 +194,7 @@ static int wilc_wlan_cfg_set_hword(u8 *frame, uint32_t offset, u16 id, u16 val16
 	return 5;
 }
 
-static int wilc_wlan_cfg_set_word(u8 *frame, uint32_t offset, u16 id, uint32_t val32)
+static int wilc_wlan_cfg_set_word(u8 *frame, u32 offset, u16 id, u32 val32)
 {
 	u8 *buf;
 
@@ -214,7 +214,7 @@ static int wilc_wlan_cfg_set_word(u8 *frame, uint32_t offset, u16 id, uint32_t v
 	return 7;
 }
 
-static int wilc_wlan_cfg_set_str(u8 *frame, uint32_t offset, u16 id, u8 *str, uint32_t size)
+static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset, u16 id, u8 *str, u32 size)
 {
 	u8 *buf;
 
@@ -233,10 +233,10 @@ static int wilc_wlan_cfg_set_str(u8 *frame, uint32_t offset, u16 id, u8 *str, ui
 	return (size + 3);
 }
 
-static int wilc_wlan_cfg_set_bin(u8 *frame, uint32_t offset, u16 id, u8 *b, uint32_t size)
+static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
 {
 	u8 *buf;
-	uint32_t i;
+	u32 i;
 	u8 checksum = 0;
 
 	if ((offset + size + 5) >= MAX_CFG_FRAME_SIZE)
@@ -268,7 +268,7 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, uint32_t offset, u16 id, u8 *b, uint
 
 static void wilc_wlan_parse_response_frame(u8 *info, int size)
 {
-	uint32_t wid, len = 0, i = 0;
+	u32 wid, len = 0, i = 0;
 	static int seq;
 
 	while (size > 0) {
@@ -364,7 +364,7 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 static int wilc_wlan_parse_info_frame(u8 *info, int size)
 {
 	wilc_mac_cfg_t *pd = (wilc_mac_cfg_t *)&g_mac;
-	uint32_t wid, len;
+	u32 wid, len;
 	int type = WILC_CFG_RSP_STATUS;
 
 	wid = info[0] | (info[1] << 8);
@@ -385,7 +385,7 @@ static int wilc_wlan_parse_info_frame(u8 *info, int size)
  *
  ********************************************/
 
-static int wilc_wlan_cfg_set_wid(u8 *frame, uint32_t offset, u16 id, u8 *buf, int size)
+static int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
 {
 	u8 type = (id >> 12) & 0xf;
 	int ret = 0;
@@ -398,7 +398,7 @@ static int wilc_wlan_cfg_set_wid(u8 *frame, uint32_t offset, u16 id, u8 *buf, in
 			ret = wilc_wlan_cfg_set_hword(frame, offset, id, *((u16 *)buf));
 	} else if (type == 2) {                 /* word command */
 		if (size >= 4)
-			ret = wilc_wlan_cfg_set_word(frame, offset, id, *((uint32_t *)buf));
+			ret = wilc_wlan_cfg_set_word(frame, offset, id, *((u32 *)buf));
 	} else if (type == 3) {                 /* string command */
 		ret = wilc_wlan_cfg_set_str(frame, offset, id, buf, size);
 	} else if (type == 4) {                 /* binary command */
@@ -410,7 +410,7 @@ static int wilc_wlan_cfg_set_wid(u8 *frame, uint32_t offset, u16 id, u8 *buf, in
 	return ret;
 }
 
-static int wilc_wlan_cfg_get_wid(u8 *frame, uint32_t offset, u16 id)
+static int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id)
 {
 	u8 *buf;
 
@@ -425,13 +425,13 @@ static int wilc_wlan_cfg_get_wid(u8 *frame, uint32_t offset, u16 id)
 	return 2;
 }
 
-static int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, uint32_t buffer_size)
+static int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 {
-	uint32_t type = (wid >> 12) & 0xf;
+	u32 type = (wid >> 12) & 0xf;
 	int i, ret = 0;
 
 	if (wid == WID_STATUS) {
-		*((uint32_t *)buffer) = g_mac.mac_status;
+		*((u32 *)buffer) = g_mac.mac_status;
 		return 4;
 	}
 
@@ -478,7 +478,7 @@ static int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, uint32_t buffer_size
 				break;
 
 			if (g_cfg_str[i].id == wid) {
-				uint32_t size =  g_cfg_str[i].str[0];
+				u32 size =  g_cfg_str[i].str[0];
 
 				if (buffer_size >= size) {
 					if (g_cfg_str[i].id == WID_SITE_SURVEY_RESULTS)	{
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 5af0617..ef88358 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -21,12 +21,12 @@ typedef struct {
 } wilc_cfg_hword_t;
 
 typedef struct {
-	uint32_t id;
-	uint32_t val;
+	u32 id;
+	u32 val;
 } wilc_cfg_word_t;
 
 typedef struct {
-	uint32_t id;
+	u32 id;
 	u8 *str;
 } wilc_cfg_str_t;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index a29d486..b64f93a 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -62,24 +62,24 @@
  ********************************************/
 
 typedef struct {
-	uint32_t read_write: 1;
-	uint32_t function: 3;
-	uint32_t raw: 1;
-	uint32_t address: 17;
-	uint32_t data: 8;
+	u32 read_write: 1;
+	u32 function: 3;
+	u32 raw: 1;
+	u32 address: 17;
+	u32 data: 8;
 } sdio_cmd52_t;
 
 typedef struct {
 	/* struct { */
-	uint32_t read_write: 1;
-	uint32_t function: 3;
-	uint32_t block_mode: 1;
-	uint32_t increment: 1;
-	uint32_t address: 17;
-	uint32_t count: 9;
+	u32 read_write: 1;
+	u32 function: 3;
+	u32 block_mode: 1;
+	u32 increment: 1;
+	u32 address: 17;
+	u32 count: 9;
 	/* } bit; */
 	u8 *buffer;
-	uint32_t block_size;
+	u32 block_size;
 } sdio_cmd53_t;
 
 typedef struct {
@@ -100,15 +100,15 @@ typedef struct {
 		} sdio;
 		struct {
 			int (*spi_max_speed)(void);
-			int (*spi_tx)(u8 *, uint32_t);
-			int (*spi_rx)(u8 *, uint32_t);
-			int (*spi_trx)(u8 *, u8 *, uint32_t);
+			int (*spi_tx)(u8 *, u32);
+			int (*spi_rx)(u8 *, u32);
+			int (*spi_trx)(u8 *, u8 *, u32);
 		} spi;
 	} u;
 } wilc_wlan_io_func_t;
 
 typedef struct {
-	void (*rx_indicate)(u8 *, uint32_t, uint32_t);
+	void (*rx_indicate)(u8 *, u32, u32);
 	void (*rx_complete)(void);
 } wilc_wlan_net_func_t;
 
@@ -127,7 +127,7 @@ typedef struct {
 
 	struct mutex *hif_critical_section;
 
-	uint32_t tx_buffer_size;
+	u32 tx_buffer_size;
 	void *txq_critical_section;
 
 	/*Added by Amr - BugID_4720*/
@@ -137,7 +137,7 @@ typedef struct {
 	void *txq_wait_event;
 
 #if defined(MEMORY_STATIC)
-	uint32_t rx_buffer_size;
+	u32 rx_buffer_size;
 #endif
 	void *rxq_critical_section;
 	void *rxq_wait_event;
@@ -166,20 +166,20 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF (-2)
 
 typedef struct {
-	int (*wlan_firmware_download)(const u8 *, uint32_t);
+	int (*wlan_firmware_download)(const u8 *, u32);
 	int (*wlan_start)(void);
 	int (*wlan_stop)(void);
-	int (*wlan_add_to_tx_que)(void *, u8 *, uint32_t, wilc_tx_complete_func_t);
-	int (*wlan_handle_tx_que)(uint32_t *);
+	int (*wlan_add_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
+	int (*wlan_handle_tx_que)(u32 *);
 	void (*wlan_handle_rx_que)(void);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
-	int (*wlan_cfg_set)(int, uint32_t, u8 *, uint32_t, int, uint32_t);
-	int (*wlan_cfg_get)(int, uint32_t, int, uint32_t);
-	int (*wlan_cfg_get_value)(uint32_t, u8 *, uint32_t);
+	int (*wlan_cfg_set)(int, u32, u8 *, u32, int, u32);
+	int (*wlan_cfg_get)(int, u32, int, u32);
+	int (*wlan_cfg_get_value)(u32, u8 *, u32);
 	/*Bug3959: transmitting mgmt frames received from host*/
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, uint32_t, wilc_tx_complete_func_t);
+	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
 	#endif
 } wilc_wlan_oup_t;
 
@@ -939,7 +939,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup);
 
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
-uint32_t wilc_get_chipid(u8 update);
+u32 wilc_get_chipid(u8 update);
 
 
 #endif
-- 
2.5.1

