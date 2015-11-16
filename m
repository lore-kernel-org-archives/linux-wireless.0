Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:60723 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbKPOF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/19] staging/wilc1000: move wilc_wlan_inp_t into struct wilc
Date: Mon, 16 Nov 2015 15:04:59 +0100
Message-Id: <1447682710-2908925-9-git-send-email-arnd@arndb.de> (sfid-20151116_150558_422211_FC542E21)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_wlan_inp_t is an unnecessary indirection and requires linux_wlan.c
to have knowledge of the specific sdio and spi front-ends. This
removes the structure and places io_type directly inside the struct wilc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         | 21 ++++++---------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 19 +++++++++----------
 drivers/staging/wilc1000/wilc_wlan_if.h       | 11 +----------
 4 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6e1ef99fc856..0747a0eefe92 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -839,17 +839,6 @@ static int wlan_deinit_locks(struct net_device *dev)
 	return 0;
 }
 
-static void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
-{
-	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
-
-#ifdef WILC_SDIO
-	nwi->io_func.io_type = HIF_SDIO;
-#else
-	nwi->io_func.io_type = HIF_SPI;
-#endif
-}
-
 static int wlan_initialize_threads(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
@@ -893,7 +882,6 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 {
-	wilc_wlan_inp_t nwi;
 	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
 	struct wilc *wl = nic->wilc;
@@ -904,9 +892,12 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		wlan_init_locks(dev);
 
-		linux_to_wlan(&nwi, wl);
-
-		ret = wilc_wlan_init(dev, &nwi);
+#ifdef WILC_SDIO
+		wl->io_type = HIF_SDIO;
+#else
+		wl->io_type = HIF_SPI;
+#endif
+		ret = wilc_wlan_init(dev);
 		if (ret < 0) {
 			PRINT_ER("Initializing WILC_Wlan FAILED\n");
 			ret = -EIO;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3358fe3bcd0a..0c608d73a22e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -156,6 +156,7 @@ struct wilc_vif {
 };
 
 struct wilc {
+	int io_type;
 	int mac_status;
 	bool initialized;
 	#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f7359f79ff8d..2958689a13c6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -5,7 +5,7 @@
 
 typedef struct {
 	int quit;
-	wilc_wlan_io_func_t io_func;
+	int io_type;
 	struct wilc_hif_func hif_func;
 	int cfg_frame_in_use;
 	struct wilc_cfg_frame cfg_frame;
@@ -576,7 +576,7 @@ static inline void chip_wakeup(void)
 	u32 reg, clk_status_reg, trials = 0;
 	u32 sleep_time;
 
-	if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
+	if ((g_wlan.io_type & 0x1) == HIF_SPI) {
 		do {
 			g_wlan.hif_func.hif_read_reg(1, &reg);
 			g_wlan.hif_func.hif_write_reg(1, reg | BIT(1));
@@ -590,7 +590,7 @@ static inline void chip_wakeup(void)
 			} while ((wilc_get_chipid(true) == 0) && ((++trials % 3) == 0));
 
 		} while (wilc_get_chipid(true) == 0);
-	} else if ((g_wlan.io_func.io_type & 0x1) == HIF_SDIO)	 {
+	} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
 		g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 		do {
 			g_wlan.hif_func.hif_write_reg(0xf0, reg | BIT(0));
@@ -636,12 +636,12 @@ static inline void chip_wakeup(void)
 	u32 reg, trials = 0;
 
 	do {
-		if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
+		if ((g_wlan.io_type & 0x1) == HIF_SPI) {
 			g_wlan.hif_func.hif_read_reg(1, &reg);
 			g_wlan.hif_func.hif_write_reg(1, reg & ~BIT(1));
 			g_wlan.hif_func.hif_write_reg(1, reg | BIT(1));
 			g_wlan.hif_func.hif_write_reg(1, reg  & ~BIT(1));
-		} else if ((g_wlan.io_func.io_type & 0x1) == HIF_SDIO)	 {
+		} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
 			g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 			g_wlan.hif_func.hif_write_reg(0xf0, reg & ~BIT(0));
 			g_wlan.hif_func.hif_write_reg(0xf0, reg | BIT(0));
@@ -1252,10 +1252,10 @@ int wilc_wlan_start(void)
 	int ret;
 	u32 chipid;
 
-	if (p->io_func.io_type == HIF_SDIO) {
+	if (p->io_type == HIF_SDIO) {
 		reg = 0;
 		reg |= BIT(3);
-	} else if (p->io_func.io_type == HIF_SPI) {
+	} else if (p->io_type == HIF_SPI) {
 		reg = 1;
 	}
 	acquire_bus(ACQUIRE_ONLY);
@@ -1649,7 +1649,7 @@ _fail_:
 	return chipid;
 }
 
-int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
+int wilc_wlan_init(struct net_device *dev)
 {
 	int ret = 0;
 	perInterface_wlan_t *nic = netdev_priv(dev);
@@ -1660,8 +1660,7 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
 	memset((void *)&g_wlan, 0, sizeof(wilc_wlan_dev_t));
-	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func,
-	       sizeof(wilc_wlan_io_func_t));
+	g_wlan.io_type = wilc->io_type;
 
 #ifdef WILC_SDIO
 	if (!wilc_hif_sdio.hif_init(wilc, wilc_debug)) {
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 5980ece49daa..2f465f4fb063 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -72,10 +72,6 @@ typedef struct {
 	u32 block_size;
 } sdio_cmd53_t;
 
-typedef struct {
-	int io_type;
-} wilc_wlan_io_func_t;
-
 #define WILC_MAC_INDICATE_STATUS	0x1
 #define WILC_MAC_STATUS_INIT		-1
 #define WILC_MAC_STATUS_READY		0
@@ -83,10 +79,6 @@ typedef struct {
 
 #define WILC_MAC_INDICATE_SCAN		0x2
 
-typedef struct {
-	wilc_wlan_io_func_t io_func;
-} wilc_wlan_inp_t;
-
 struct tx_complete_data {
 	int size;
 	void *buff;
@@ -917,8 +909,7 @@ typedef enum {
 	WID_MAX				= 0xFFFF
 } WID_T;
 
-int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp);
-
+int wilc_wlan_init(struct net_device *dev);
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
 u32 wilc_get_chipid(u8 update);
-- 
2.1.0.rc2

