Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33019 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdGFOlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:41:50 -0400
Received: by mail-pf0-f193.google.com with SMTP id e199so570343pfh.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:41:50 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 04/21] rsi: chip reset for SDIO interface
Date: Thu,  6 Jul 2017 20:07:07 +0530
Message-Id: <1499351844-2046-5-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164154_008205_92475A1B)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

We need to reset the chip in teardown path so that it can work
next time when driver is loaded. This patch adds support for
this reset configuration for SDIO.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 80 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_hal.h      | 33 ++++++++++++++
 drivers/net/wireless/rsi/rsi_sdio.h     |  1 +
 3 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b5ac503..ebfd29c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -933,6 +933,84 @@ static int rsi_probe(struct sdio_func *pfunction,
 	return 1;
 }
 
+static void ulp_read_write(struct rsi_hw *adapter, u16 addr, u32 data,
+			   u16 len_in_bits)
+{
+	rsi_sdio_master_reg_write(adapter, RSI_GSPI_DATA_REG1,
+				  ((addr << 6) | ((data >> 16) & 0xffff)), 2);
+	rsi_sdio_master_reg_write(adapter, RSI_GSPI_DATA_REG0,
+				  (data & 0xffff), 2);
+	rsi_sdio_master_reg_write(adapter, RSI_GSPI_CTRL_REG0,
+				  RSI_GSPI_CTRL_REG0_VALUE, 2);
+	rsi_sdio_master_reg_write(adapter, RSI_GSPI_CTRL_REG1,
+				  ((len_in_bits - 1) | RSI_GSPI_TRIG), 2);
+	msleep(20);
+}
+
+/*This function resets and re-initializes the chip.*/
+static void rsi_reset_chip(struct rsi_hw *adapter)
+{
+	__le32 data;
+	u8 sdio_interrupt_status = 0;
+	u8 request = 1;
+	int ret;
+
+	rsi_dbg(INFO_ZONE, "Writing disable to wakeup register\n");
+	ret =  rsi_sdio_write_register(adapter, 0, SDIO_WAKEUP_REG, &request);
+	if (ret < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to write SDIO wakeup register\n", __func__);
+		return;
+	}
+	msleep(20);
+	ret =  rsi_sdio_read_register(adapter, RSI_FN1_INT_REGISTER,
+				      &sdio_interrupt_status);
+	if (ret < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to Read Intr Status Register\n",
+			__func__);
+		return;
+	}
+	rsi_dbg(INFO_ZONE, "%s: Intr Status Register value = %d\n",
+		__func__, sdio_interrupt_status);
+
+	/* Put Thread-Arch processor on hold */
+	if (rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to set ms word to common reg\n",
+			__func__);
+		return;
+	}
+
+	data = TA_HOLD_THREAD_VALUE;
+	if (rsi_sdio_write_register_multiple(adapter, TA_HOLD_THREAD_REG |
+					     RSI_SD_REQUEST_MASTER,
+					     (u8 *)&data, 4)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to hold Thread-Arch processor threads\n",
+			__func__);
+		return;
+	}
+
+	/* This msleep will ensure Thread-Arch processor to go to hold
+	 * and any pending dma transfers to rf spi in device to finish.
+	 */
+	msleep(100);
+
+	ulp_read_write(adapter, RSI_ULP_RESET_REG, RSI_ULP_WRITE_0, 32);
+	ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_1, RSI_ULP_WRITE_2, 32);
+	ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_2, RSI_ULP_WRITE_0, 32);
+	ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_1, RSI_ULP_WRITE_50,
+		       32);
+	ulp_read_write(adapter, RSI_WATCH_DOG_DELAY_TIMER_2, RSI_ULP_WRITE_0,
+		       32);
+	ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_ENABLE,
+		       RSI_ULP_TIMER_ENABLE, 32);
+	/* This msleep will be sufficient for the ulp
+	 * read write operations to complete for chip reset.
+	 */
+	msleep(500);
+}
+
 /**
  * rsi_disconnect() - This function performs the reverse of the probe function.
  * @pfunction: Pointer to the sdio_func structure.
@@ -956,7 +1034,7 @@ static void rsi_disconnect(struct sdio_func *pfunction)
 	sdio_release_irq(pfunction);
 	sdio_disable_func(pfunction);
 	rsi_91x_deinit(adapter);
-	/* Resetting to take care of the case, where-in driver is re-loaded */
+	rsi_reset_chip(adapter);
 	rsi_reset_card(pfunction);
 	sdio_release_host(pfunction);
 }
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 902dc54..3179e86 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -52,6 +52,39 @@
 #define FW_LOADING_SUCCESSFUL		'S'
 #define LOADING_INITIATED		'1'
 
+#define RSI_ULP_RESET_REG		0x161
+#define RSI_WATCH_DOG_TIMER_1		0x16c
+#define RSI_WATCH_DOG_TIMER_2		0x16d
+#define RSI_WATCH_DOG_DELAY_TIMER_1		0x16e
+#define RSI_WATCH_DOG_DELAY_TIMER_2		0x16f
+#define RSI_WATCH_DOG_TIMER_ENABLE		0x170
+
+#define RSI_ULP_WRITE_0			00
+#define RSI_ULP_WRITE_2			02
+#define RSI_ULP_WRITE_50		50
+
+#define RSI_RESTART_WDT			BIT(11)
+#define RSI_BYPASS_ULP_ON_WDT		BIT(1)
+
+#define RSI_ULP_TIMER_ENABLE		((0xaa000) | RSI_RESTART_WDT |	\
+					 RSI_BYPASS_ULP_ON_WDT)
+#define RSI_RF_SPI_PROG_REG_BASE_ADDR	0x40080000
+
+#define RSI_GSPI_CTRL_REG0		(RSI_RF_SPI_PROG_REG_BASE_ADDR)
+#define RSI_GSPI_CTRL_REG1		(RSI_RF_SPI_PROG_REG_BASE_ADDR + 0x2)
+#define RSI_GSPI_DATA_REG0		(RSI_RF_SPI_PROG_REG_BASE_ADDR + 0x4)
+#define RSI_GSPI_DATA_REG1		(RSI_RF_SPI_PROG_REG_BASE_ADDR + 0x6)
+#define RSI_GSPI_DATA_REG2		(RSI_RF_SPI_PROG_REG_BASE_ADDR + 0x8)
+
+#define RSI_GSPI_CTRL_REG0_VALUE		0x340
+
+#define RSI_GSPI_DMA_MODE			BIT(13)
+
+#define RSI_GSPI_2_ULP			BIT(12)
+#define RSI_GSPI_TRIG			BIT(7)
+#define RSI_GSPI_READ			BIT(6)
+#define RSI_GSPI_RF_SPI_ACTIVE		BIT(8)
+
 /* Boot loader commands */
 #define SEND_RPS_FILE			'2'
 
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 9fb73f6..f11f818 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -58,6 +58,7 @@ enum sdio_interrupt_type {
 #define SDIO_READ_START_LVL                     0x000FC
 #define SDIO_READ_FIFO_CTL                      0x000FD
 #define SDIO_WRITE_FIFO_CTL                     0x000FE
+#define SDIO_WAKEUP_REG				0x000FF
 #define SDIO_FUN1_INTR_CLR_REG                  0x0008
 #define SDIO_REG_HIGH_SPEED                     0x0013
 
-- 
2.7.4
