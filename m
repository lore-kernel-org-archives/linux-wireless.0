Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:53847 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbbJTWsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/19] staging/wilc1000: move wilc_wlan_inp_t into struct wilc
Date: Wed, 21 Oct 2015 00:47:27 +0200
Message-Id: <1445381258-1455986-9-git-send-email-arnd@arndb.de> (sfid-20151021_005244_160452_3EEC5CBC)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_wlan_inp_t is an unnecessary indirection and requires linux_wlan.c
to have knowledge of the specific sdio and spi front-ends. This
removes the structure and places the members with a constant
'struct wilc1000_ops' pointer inside of 'struct wilc'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         | 67 +++++++++++++--------------
 drivers/staging/wilc1000/wilc_sdio.c          | 17 +++----
 drivers/staging/wilc1000/wilc_spi.c           | 17 +++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 22 ++++-----
 drivers/staging/wilc1000/wilc_wlan.h          |  4 +-
 drivers/staging/wilc1000/wilc_wlan_if.h       | 16 ++-----
 7 files changed, 70 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index eb4c6cba4575..53cecb892a84 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -923,31 +923,29 @@ static int wlan_deinit_locks(struct wilc *nic)
 	return 0;
 }
 
-static void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
-{
-
-	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
-
-	nwi->os_context.os_private = (void *)nic;
-
 #ifdef WILC_SDIO
-	nwi->io_func.io_type = HIF_SDIO;
-	nwi->io_func.io_init = wilc1000_sdio_init;
-	nwi->io_func.io_deinit = wilc1000_sdio_deinit;
-	nwi->io_func.u.sdio.sdio_cmd52 = wilc1000_sdio_cmd52;
-	nwi->io_func.u.sdio.sdio_cmd53 = wilc1000_sdio_cmd53;
-	nwi->io_func.u.sdio.sdio_set_max_speed = wilc1000_sdio_set_max_speed;
-	nwi->io_func.u.sdio.sdio_set_default_speed = wilc1000_sdio_set_default_speed;
-#else
-	nwi->io_func.io_type = HIF_SPI;
-	nwi->io_func.io_init = wilc1000_spi_init;
-	nwi->io_func.io_deinit = wilc1000_spi_deinit;
-	nwi->io_func.u.spi.spi_tx = wilc1000_spi_write;
-	nwi->io_func.u.spi.spi_rx = wilc1000_spi_read;
-	nwi->io_func.u.spi.spi_trx = wilc1000_spi_write_read;
-	nwi->io_func.u.spi.spi_max_speed = wilc1000_spi_set_max_speed;
+static const struct wilc1000_ops wilc1000_sdio_ops = {
+	.io_type = HIF_SDIO,
+	.io_init = wilc1000_sdio_init,
+	.io_deinit = wilc1000_sdio_deinit,
+	.u.sdio.sdio_cmd52 = wilc1000_sdio_cmd52,
+	.u.sdio.sdio_cmd53 = wilc1000_sdio_cmd53,
+	.u.sdio.sdio_set_max_speed = wilc1000_sdio_set_max_speed,
+	.u.sdio.sdio_set_default_speed = wilc1000_sdio_set_default_speed,
+};
+#endif
+
+#ifdef WILC_SPI
+static const struct wilc1000_ops wilc1000_spi_ops = {
+	.io_type = HIF_SPI,
+	.io_init = wilc1000_spi_init,
+	.io_deinit = wilc1000_spi_deinit,
+	.u.spi.spi_tx = wilc1000_spi_write,
+	.u.spi.spi_rx = wilc1000_spi_read,
+	.u.spi.spi_trx = wilc1000_spi_write_read,
+	.u.spi.spi_max_speed = wilc1000_spi_set_max_speed,
+};
 #endif
-}
 
 static int wlan_initialize_threads(perInterface_wlan_t *nic)
 {
@@ -995,7 +993,7 @@ static void wlan_deinitialize_threads(struct wilc *nic)
 #ifdef COMPLEMENT_BOOT
 
 #define READY_CHECK_THRESHOLD		30
-static u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
+static u8 wilc1000_prepare_11b_core(struct wilc *nic)
 {
 	u8 trials = 0;
 
@@ -1011,8 +1009,8 @@ static u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 			msleep(100);
 		wilc1000_probe = 0;
 		wilc1000_dev->wilc_sdio_func = wilc1000_sdio_func;
-		linux_to_wlan(nwi, nic);
-		wilc_wlan_init(nwi);
+		nic->ops = &wilc1000_sdio_ops;
+		wilc_wlan_init(nic);
 	}
 
 	if (READY_CHECK_THRESHOLD <= trials)
@@ -1025,8 +1023,6 @@ static u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi, struct wilc *nic)
 static int repeat_power_cycle(perInterface_wlan_t *nic)
 {
 	int ret = 0;
-	wilc_wlan_inp_t nwi;
-
 	sdio_unregister_driver(&wilc_bus);
 
 	sdio_register_driver(&wilc_bus);
@@ -1036,8 +1032,8 @@ static int repeat_power_cycle(perInterface_wlan_t *nic)
 		msleep(100);
 	wilc1000_probe = 0;
 	wilc1000_dev->wilc_sdio_func = wilc1000_sdio_func;
-	linux_to_wlan(&nwi, wilc1000_dev);
-	ret = wilc_wlan_init(&nwi);
+	wilc1000_dev->ops = &wilc1000_sdio_ops;
+	ret = wilc_wlan_init(wilc1000_dev);
 
 	wilc1000_dev->mac_status = WILC_MAC_STATUS_INIT;
 	#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
@@ -1067,7 +1063,6 @@ __fail__:
 
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 {
-	wilc_wlan_inp_t nwi;
 	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
 
@@ -1078,9 +1073,13 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		wlan_init_locks(wilc1000_dev);
 
-		linux_to_wlan(&nwi, wilc1000_dev);
+#ifdef WILC_SDIO
+		wilc1000_dev->ops = &wilc1000_sdio_ops;
+#else
+		wilc1000_dev->ops = &wilc1000_spi_ops;
+#endif
 
-		ret = wilc_wlan_init(&nwi);
+		ret = wilc_wlan_init(wilc1000_dev);
 		if (ret < 0) {
 			PRINT_ER("Initializing WILC_Wlan FAILED\n");
 			ret = -EIO;
@@ -1095,7 +1094,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 #if (defined WILC_SDIO) && (defined COMPLEMENT_BOOT)
-		if (wilc1000_prepare_11b_core(&nwi, wilc1000_dev)) {
+		if (wilc1000_prepare_11b_core(wilc1000_dev)) {
 			PRINT_ER("11b Core is not ready\n");
 			ret = -EIO;
 			goto _fail_threads_;
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 91b626ac8797..2d39a5386718 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -8,6 +8,7 @@
 /* //////////////////////////////////////////////////////////////////////////// */
 
 #include <linux/string.h>
+#include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
@@ -498,7 +499,7 @@ static int sdio_sync(void)
 	return 1;
 }
 
-static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
+static int sdio_init(struct wilc *inp, wilc_debug_func func)
 {
 	sdio_cmd52_t cmd;
 	int loop;
@@ -507,10 +508,10 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
 
 	g_sdio.dPrint = func;
-	g_sdio.os_context = inp->os_context.os_private;
+	g_sdio.os_context = inp;
 
-	if (inp->io_func.io_init) {
-		if (!inp->io_func.io_init(g_sdio.os_context)) {
+	if (inp->ops->io_init) {
+		if (!inp->ops->io_init(g_sdio.os_context)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
 			return 0;
 		}
@@ -518,10 +519,10 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 		return 0;
 	}
 
-	g_sdio.sdio_cmd52	= inp->io_func.u.sdio.sdio_cmd52;
-	g_sdio.sdio_cmd53	= inp->io_func.u.sdio.sdio_cmd53;
-	g_sdio.sdio_set_max_speed	= inp->io_func.u.sdio.sdio_set_max_speed;
-	g_sdio.sdio_set_default_speed	= inp->io_func.u.sdio.sdio_set_default_speed;
+	g_sdio.sdio_cmd52	= inp->ops->u.sdio.sdio_cmd52;
+	g_sdio.sdio_cmd53	= inp->ops->u.sdio.sdio_cmd53;
+	g_sdio.sdio_set_max_speed	= inp->ops->u.sdio.sdio_set_max_speed;
+	g_sdio.sdio_set_default_speed	= inp->ops->u.sdio.sdio_set_default_speed;
 
 	/**
 	 *      function 0 csa enable
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index bb7ee37171ce..4c5659b72f29 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -8,6 +8,7 @@
 /* //////////////////////////////////////////////////////////////////////////// */
 
 #include <linux/string.h>
+#include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
@@ -724,7 +725,7 @@ static int spi_sync(void)
 	return 1;
 }
 
-static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
+static int spi_init(struct wilc *inp, wilc_debug_func func)
 {
 	u32 reg;
 	u32 chipid;
@@ -743,19 +744,19 @@ static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	memset(&g_spi, 0, sizeof(wilc_spi_t));
 
 	g_spi.dPrint = func;
-	g_spi.os_context = inp->os_context.os_private;
-	if (inp->io_func.io_init) {
-		if (!inp->io_func.io_init(g_spi.os_context)) {
+	g_spi.os_context = inp;
+	if (inp->ops->io_init) {
+		if (!inp->ops->io_init(g_spi.os_context)) {
 			PRINT_ER("[wilc spi]: Failed io init bus...\n");
 			return 0;
 		}
 	} else {
 		return 0;
 	}
-	g_spi.spi_tx = inp->io_func.u.spi.spi_tx;
-	g_spi.spi_rx = inp->io_func.u.spi.spi_rx;
-	g_spi.spi_trx = inp->io_func.u.spi.spi_trx;
-	g_spi.spi_max_speed = inp->io_func.u.spi.spi_max_speed;
+	g_spi.spi_tx = inp->ops->u.spi.spi_tx;
+	g_spi.spi_rx = inp->ops->u.spi.spi_rx;
+	g_spi.spi_trx = inp->ops->u.spi.spi_trx;
+	g_spi.spi_max_speed = inp->ops->u.spi.spi_max_speed;
 
 	/**
 	 *      configure protocol
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 28610d889c0c..485df4768e78 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -156,6 +156,7 @@ struct wilc_vif {
 };
 
 struct wilc {
+	const struct wilc1000_ops *ops;
 	int mac_status;
 	int wilc1000_initialized;
 	#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a147547fb66e..7e1b892f721d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -23,7 +23,7 @@ typedef struct {
 	/**
 	 *      input interface functions
 	 **/
-	wilc_wlan_io_func_t io_func;
+	const struct wilc1000_ops *io_func;
 
 	/**
 	 *      host interface functions
@@ -651,7 +651,7 @@ static inline void chip_wakeup(void)
 	u32 reg, clk_status_reg, trials = 0;
 	u32 sleep_time;
 
-	if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
+	if ((g_wlan.io_func->io_type & 0x1) == HIF_SPI) {
 		do {
 			g_wlan.hif_func.hif_read_reg(1, &reg);
 			/* Set bit 1 */
@@ -671,7 +671,7 @@ static inline void chip_wakeup(void)
 			} while ((wilc_get_chipid(true) == 0) && ((++trials % 3) == 0));
 
 		} while (wilc_get_chipid(true) == 0);
-	} else if ((g_wlan.io_func.io_type & 0x1) == HIF_SDIO)	 {
+	} else if ((g_wlan.io_func->io_type & 0x1) == HIF_SDIO)	 {
 		g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 		do {
 			/* Set bit 1 */
@@ -731,7 +731,7 @@ static inline void chip_wakeup(void)
 	u32 reg, trials = 0;
 
 	do {
-		if ((g_wlan.io_func.io_type & 0x1) == HIF_SPI) {
+		if ((g_wlan.io_func->io_type & 0x1) == HIF_SPI) {
 			g_wlan.hif_func.hif_read_reg(1, &reg);
 			/* Make sure bit 1 is 0 before we start. */
 			g_wlan.hif_func.hif_write_reg(1, reg & ~BIT(1));
@@ -739,7 +739,7 @@ static inline void chip_wakeup(void)
 			g_wlan.hif_func.hif_write_reg(1, reg | BIT(1));
 			/* Clear bit 1*/
 			g_wlan.hif_func.hif_write_reg(1, reg  & ~BIT(1));
-		} else if ((g_wlan.io_func.io_type & 0x1) == HIF_SDIO)	 {
+		} else if ((g_wlan.io_func->io_type & 0x1) == HIF_SDIO)	 {
 			/* Make sure bit 0 is 0 before we start. */
 			g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 			g_wlan.hif_func.hif_write_reg(0xf0, reg & ~BIT(0));
@@ -1465,10 +1465,10 @@ int wilc_wlan_start(void)
 	/**
 	 *      Set the host interface
 	 **/
-	if (p->io_func.io_type == HIF_SDIO) {
+	if (p->io_func->io_type == HIF_SDIO) {
 		reg = 0;
 		reg |= BIT(3); /* bug 4456 and 4557 */
-	} else if (p->io_func.io_type == HIF_SPI) {
+	} else if (p->io_func->io_type == HIF_SPI) {
 		reg = 1;
 	}
 	acquire_bus(ACQUIRE_ONLY);
@@ -1932,7 +1932,7 @@ u8 wilc1000_core_11b_ready(void)
 }
 #endif
 
-int wilc_wlan_init(wilc_wlan_inp_t *inp)
+int wilc_wlan_init(struct wilc *inp)
 {
 
 	int ret = 0;
@@ -1944,11 +1944,11 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp)
 	/**
 	 *      store the input
 	 **/
-	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
+	g_wlan.io_func = inp->ops;
 	/***
 	 *      host interface init
 	 **/
-	if ((inp->io_func.io_type & 0x1) == HIF_SDIO) {
+	if ((inp->ops->io_type & 0x1) == HIF_SDIO) {
 		if (!wilc1000_hif_sdio.hif_init(inp, wilc_debug)) {
 			/* EIO	5 */
 			ret = -5;
@@ -1956,7 +1956,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp)
 		}
 		memcpy((void *)&g_wlan.hif_func, &wilc1000_hif_sdio, sizeof(wilc_hif_func_t));
 	} else {
-		if ((inp->io_func.io_type & 0x1) == HIF_SPI) {
+		if ((inp->ops->io_type & 0x1) == HIF_SPI) {
 			/**
 			 *      TODO:
 			 **/
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 64295a664ea9..4460c482cb7a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -251,8 +251,10 @@ struct rxq_entry_t {
  *
  ********************************************/
 
+struct wilc;
+
 typedef struct {
-	int (*hif_init)(wilc_wlan_inp_t *, wilc_debug_func);
+	int (*hif_init)(struct wilc *, wilc_debug_func);
 	int (*hif_deinit)(void *);
 	int (*hif_read_reg)(u32, u32 *);
 	int (*hif_write_reg)(u32, u32);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index be972afe6e62..bfa1291e22ed 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -71,7 +71,7 @@ typedef struct {
 	u32 block_size;
 } sdio_cmd53_t;
 
-typedef struct {
+struct wilc1000_ops {
 	int io_type;
 	int (*io_init)(void *);
 	void (*io_deinit)(void *);
@@ -89,7 +89,7 @@ typedef struct {
 			int (*spi_trx)(u8 *, u8 *, u32);
 		} spi;
 	} u;
-} wilc_wlan_io_func_t;
+};
 
 #define WILC_MAC_INDICATE_STATUS	0x1
 #define WILC_MAC_STATUS_INIT		-1
@@ -98,15 +98,6 @@ typedef struct {
 
 #define WILC_MAC_INDICATE_SCAN		0x2
 
-typedef struct {
-	void *os_private;
-} wilc_wlan_os_context_t;
-
-typedef struct {
-	wilc_wlan_os_context_t os_context;
-	wilc_wlan_io_func_t io_func;
-} wilc_wlan_inp_t;
-
 struct tx_complete_data {
 	int size;
 	void *buff;
@@ -937,7 +928,8 @@ typedef enum {
 	WID_MAX				= 0xFFFF
 } WID_T;
 
-int wilc_wlan_init(wilc_wlan_inp_t *inp);
+struct wilc;
+int wilc_wlan_init(struct wilc *inp);
 
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
-- 
2.1.0.rc2

