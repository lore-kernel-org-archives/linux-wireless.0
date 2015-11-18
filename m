Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20554 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:08:44 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/16] staging: wilc1000: pass struct wilc to the functions which use hif_func
Date: Wed, 18 Nov 2015 15:11:25 +0900
Message-ID: <1447827097-9436-5-git-send-email-glen.lee@atmel.com> (sfid-20151118_070847_508680_9463B7BE)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch passes struct wilc to the functions which use hif_func inside.
The function pointers of wilc_hif_func will pass wilc also in the later
patch. Pass wilc to the functions if necessary.

Flollowings are modified functions.
chip_wakeup
wilc_chip_sleep_manually
chip_allow_sleep
wilc_get_chipid
wilc_unknown_isr_ext
wilc_pllupdate_isr_ext
wilc_sleeptimer_isr_ext

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c |  3 +-
 drivers/staging/wilc1000/linux_wlan.c     |  5 +--
 drivers/staging/wilc1000/wilc_wlan.c      | 56 +++++++++++++++----------------
 drivers/staging/wilc1000/wilc_wlan.h      |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h   |  3 +-
 5 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 640cb6b..2531d20 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2834,6 +2834,7 @@ static int hostIFthread(void *pvArg)
 	u32 u32Ret;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv;
+	struct wilc *wilc = (struct wilc*)pvArg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
@@ -2906,7 +2907,7 @@ static int hostIFthread(void *pvArg)
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
 			if (!wilc_wlan_get_num_conn_ifcs(wilc_dev))
-				wilc_chip_sleep_manually();
+				wilc_chip_sleep_manually(wilc);
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ab17110..43458e6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -514,7 +514,8 @@ static int wilc1000_firmware_download(struct net_device *dev)
 	return 0;
 }
 
-static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_nic)
+static int linux_wlan_init_test_config(struct net_device *dev,
+				       struct wilc *wilc)
 {
 	unsigned char c_val[64];
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
@@ -532,7 +533,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n",
 		mac_add[0], mac_add[1], mac_add[2],
 		mac_add[3], mac_add[4], mac_add[5]);
-	wilc_get_chipid(0);
+	wilc_get_chipid(wilc, 0);
 
 	*(int *)c_val = 1;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 114ea95..e30a34d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -35,9 +35,9 @@ typedef struct {
 static wilc_wlan_dev_t g_wlan;
 
 #ifdef WILC_OPTIMIZE_SLEEP_INT
-static inline void chip_allow_sleep(void);
+static inline void chip_allow_sleep(struct wilc *wilc);
 #endif
-static inline void chip_wakeup(void);
+static inline void chip_wakeup(struct wilc *wilc);
 static u32 dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
 
 /* FIXME: replace with dev_debug() */
@@ -65,7 +65,7 @@ static inline void acquire_bus(struct wilc *wilc, BUS_ACQUIRE_T acquire)
 	#endif
 	{
 		if (acquire == ACQUIRE_AND_WAKEUP)
-			chip_wakeup();
+			chip_wakeup(wilc);
 	}
 }
 
@@ -73,7 +73,7 @@ static inline void release_bus(struct wilc *wilc, BUS_RELEASE_T release)
 {
 	#ifdef WILC_OPTIMIZE_SLEEP_INT
 	if (release == RELEASE_ALLOW_SLEEP)
-		chip_allow_sleep();
+		chip_allow_sleep(wilc);
 	#endif
 	mutex_unlock(&wilc->hif_cs);
 }
@@ -562,7 +562,7 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 
-static inline void chip_allow_sleep(void)
+static inline void chip_allow_sleep(struct wilc *wilc)
 {
 	u32 reg = 0;
 
@@ -571,7 +571,7 @@ static inline void chip_allow_sleep(void)
 	g_wlan.hif_func.hif_write_reg(0xf0, reg & ~BIT(0));
 }
 
-static inline void chip_wakeup(void)
+static inline void chip_wakeup(struct wilc *wilc)
 {
 	u32 reg, clk_status_reg, trials = 0;
 	u32 sleep_time;
@@ -584,12 +584,12 @@ static inline void chip_wakeup(void)
 
 			do {
 				usleep_range(2 * 1000, 2 * 1000);
-				if ((wilc_get_chipid(true) == 0))
+				if ((wilc_get_chipid(wilc, true) == 0))
 					wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
 
-			} while ((wilc_get_chipid(true) == 0) && ((++trials % 3) == 0));
+			} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 0));
 
-		} while (wilc_get_chipid(true) == 0);
+		} while (wilc_get_chipid(wilc, true) == 0);
 	} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
 		g_wlan.hif_func.hif_read_reg(0xf0, &reg);
 		do {
@@ -616,7 +616,7 @@ static inline void chip_wakeup(void)
 		reg &= ~BIT(0);
 		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
 
-		if (wilc_get_chipid(false) >= 0x1002b0) {
+		if (wilc_get_chipid(wilc, false) >= 0x1002b0) {
 			u32 val32;
 
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
@@ -631,7 +631,7 @@ static inline void chip_wakeup(void)
 	chip_ps_state = CHIP_WAKEDUP;
 }
 #else
-static inline void chip_wakeup(void)
+static inline void chip_wakeup(struct wilc *wilc)
 {
 	u32 reg, trials = 0;
 
@@ -651,19 +651,19 @@ static inline void chip_wakeup(void)
 		do {
 			mdelay(3);
 
-			if ((wilc_get_chipid(true) == 0))
+			if ((wilc_get_chipid(wilc, true) == 0))
 				wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
 
-		} while ((wilc_get_chipid(true) == 0) && ((++trials % 3) == 0));
+		} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 0));
 
-	} while (wilc_get_chipid(true) == 0);
+	} while (wilc_get_chipid(wilc, true) == 0);
 
 	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
 		g_wlan.hif_func.hif_read_reg(0x1C0C, &reg);
 		reg &= ~BIT(0);
 		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
 
-		if (wilc_get_chipid(false) >= 0x1002b0) {
+		if (wilc_get_chipid(wilc, false) >= 0x1002b0) {
 			u32 val32;
 
 			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
@@ -678,19 +678,19 @@ static inline void chip_wakeup(void)
 	chip_ps_state = CHIP_WAKEDUP;
 }
 #endif
-void wilc_chip_sleep_manually(void)
+void wilc_chip_sleep_manually(struct wilc *wilc)
 {
 	if (chip_ps_state != CHIP_WAKEDUP)
 		return;
-	acquire_bus(wilc_dev, ACQUIRE_ONLY);
+	acquire_bus(wilc, ACQUIRE_ONLY);
 
 #ifdef WILC_OPTIMIZE_SLEEP_INT
-	chip_allow_sleep();
+	chip_allow_sleep(wilc);
 #endif
 	g_wlan.hif_func.hif_write_reg(0x10a8, 1);
 
 	chip_ps_state = CHIP_SLEEPING_MANUAL;
-	release_bus(wilc_dev, RELEASE_ONLY);
+	release_bus(wilc, RELEASE_ONLY);
 }
 
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
@@ -1056,12 +1056,12 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 	PRINT_D(RX_DBG, "THREAD: Exiting RX thread\n");
 }
 
-static void wilc_unknown_isr_ext(void)
+static void wilc_unknown_isr_ext(struct wilc *wilc)
 {
 	g_wlan.hif_func.hif_clear_int_ext(0);
 }
 
-static void wilc_pllupdate_isr_ext(u32 int_stats)
+static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 {
 	int trials = 10;
 
@@ -1072,13 +1072,13 @@ static void wilc_pllupdate_isr_ext(u32 int_stats)
 	else
 		mdelay(WILC_PLL_TO_SPI);
 
-	while (!(ISWILC1000(wilc_get_chipid(true)) && --trials)) {
+	while (!(ISWILC1000(wilc_get_chipid(wilc, true)) && --trials)) {
 		PRINT_D(TX_DBG, "PLL update retrying\n");
 		mdelay(1);
 	}
 }
 
-static void wilc_sleeptimer_isr_ext(u32 int_stats1)
+static void wilc_sleeptimer_isr_ext(struct wilc *wilc, u32 int_stats1)
 {
 	g_wlan.hif_func.hif_clear_int_ext(SLEEP_INT_CLR);
 #ifndef WILC_OPTIMIZE_SLEEP_INT
@@ -1165,7 +1165,7 @@ void wilc_handle_isr(struct wilc *wilc)
 	g_wlan.hif_func.hif_read_int(&int_status);
 
 	if (int_status & PLL_INT_EXT)
-		wilc_pllupdate_isr_ext(int_status);
+		wilc_pllupdate_isr_ext(wilc, int_status);
 
 	if (int_status & DATA_INT_EXT) {
 		wilc_wlan_handle_isr_ext(wilc, int_status);
@@ -1174,10 +1174,10 @@ void wilc_handle_isr(struct wilc *wilc)
 	#endif
 	}
 	if (int_status & SLEEP_INT_EXT)
-		wilc_sleeptimer_isr_ext(int_status);
+		wilc_sleeptimer_isr_ext(wilc, int_status);
 
 	if (!(int_status & (ALL_INT_EXT))) {
-		wilc_unknown_isr_ext();
+		wilc_unknown_isr_ext(wilc);
 	}
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 }
@@ -1587,7 +1587,7 @@ static u32 init_chip(struct net_device *dev)
 
 	acquire_bus(wilc, ACQUIRE_ONLY);
 
-	chipid = wilc_get_chipid(true);
+	chipid = wilc_get_chipid(wilc, true);
 
 	if ((chipid & 0xfff) != 0xa0) {
 		ret = g_wlan.hif_func.hif_read_reg(0x1118, &reg);
@@ -1613,7 +1613,7 @@ static u32 init_chip(struct net_device *dev)
 	return ret;
 }
 
-u32 wilc_get_chipid(u8 update)
+u32 wilc_get_chipid(struct wilc *wilc, u8 update)
 {
 	static u32 chipid;
 	u32 tempchipid = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index ee13771e..334abafe 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -295,7 +295,7 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drv_handler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
-void wilc_chip_sleep_manually(void);
+void wilc_chip_sleep_manually(struct wilc *wilc);
 
 void wilc_enable_tcp_ack_filter(bool value);
 int wilc_wlan_get_num_conn_ifcs(struct wilc *);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 2f465f4..618903c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -909,9 +909,10 @@ typedef enum {
 	WID_MAX				= 0xFFFF
 } WID_T;
 
+struct wilc;
 int wilc_wlan_init(struct net_device *dev);
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
-u32 wilc_get_chipid(u8 update);
+u32 wilc_get_chipid(struct wilc *wilc, u8 update);
 
 #endif
-- 
1.9.1

