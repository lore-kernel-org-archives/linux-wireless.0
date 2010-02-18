Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:19703 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0BRL2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:51 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 20/22] wl1271: Renamed IO functions
Date: Thu, 18 Feb 2010 13:25:55 +0200
Message-Id: <1266492357-462-21-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

In preparation for integration of SDIO implementation renamed some IO
functions from wl1271_spi_* form to wl1271_*.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c  |   70 +++++++++++++--------------
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   15 +++---
 drivers/net/wireless/wl12xx/wl1271_event.c |    9 ++--
 drivers/net/wireless/wl12xx/wl1271_io.c    |   24 +++++-----
 drivers/net/wireless/wl12xx/wl1271_io.h    |   29 +++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c  |   12 ++--
 drivers/net/wireless/wl12xx/wl1271_ps.c    |    1 +
 drivers/net/wireless/wl12xx/wl1271_rx.c    |   11 ++--
 drivers/net/wireless/wl12xx/wl1271_spi.h   |   30 ------------
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   17 ++++---
 10 files changed, 109 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index fb3090c..2be76ee 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -27,6 +27,7 @@
 #include "wl1271_reg.h"
 #include "wl1271_boot.h"
 #include "wl1271_spi.h"
+#include "wl1271_io.h"
 #include "wl1271_event.h"
 
 static struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
@@ -93,19 +94,19 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 	u32 cpu_ctrl;
 
 	/* 10.5.0 run the firmware (I) */
-	cpu_ctrl = wl1271_spi_read32(wl, ACX_REG_ECPU_CONTROL);
+	cpu_ctrl = wl1271_read32(wl, ACX_REG_ECPU_CONTROL);
 
 	/* 10.5.1 run the firmware (II) */
 	cpu_ctrl |= flag;
-	wl1271_spi_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
+	wl1271_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
 }
 
 static void wl1271_boot_fw_version(struct wl1271 *wl)
 {
 	struct wl1271_static_data static_data;
 
-	wl1271_spi_read(wl, wl->cmd_box_addr,
-			&static_data, sizeof(static_data), false);
+	wl1271_read(wl, wl->cmd_box_addr, &static_data, sizeof(static_data),
+		    false);
 
 	strncpy(wl->chip.fw_ver, static_data.fw_version,
 		sizeof(wl->chip.fw_ver));
@@ -164,7 +165,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		memcpy(chunk, p, CHUNK_SIZE);
 		wl1271_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
 			     p, addr);
-		wl1271_spi_write(wl, addr, chunk, CHUNK_SIZE, false);
+		wl1271_write(wl, addr, chunk, CHUNK_SIZE, false);
 
 		chunk_num++;
 	}
@@ -175,7 +176,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	memcpy(chunk, p, fw_data_len % CHUNK_SIZE);
 	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%zd B) 0x%p to 0x%x",
 		     fw_data_len % CHUNK_SIZE, p, addr);
-	wl1271_spi_write(wl, addr, chunk, fw_data_len % CHUNK_SIZE, false);
+	wl1271_write(wl, addr, chunk, fw_data_len % CHUNK_SIZE, false);
 
 	kfree(chunk);
 	return 0;
@@ -256,7 +257,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 			wl1271_debug(DEBUG_BOOT,
 				     "nvs burst write 0x%x: 0x%x",
 				     dest_addr, val);
-			wl1271_spi_write32(wl, dest_addr, val);
+			wl1271_write32(wl, dest_addr, val);
 
 			nvs_ptr += 4;
 			dest_addr += 4;
@@ -290,7 +291,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	/* FIXME: In wl1271, we upload everything at once.
 	   No endianness handling needed here?! The ref driver doesn't do
 	   anything about it at this point */
-	wl1271_spi_write(wl, CMD_MBOX_ADDRESS, nvs_aligned, nvs_len, false);
+	wl1271_write(wl, CMD_MBOX_ADDRESS, nvs_aligned, nvs_len, false);
 
 	kfree(nvs_aligned);
 	return 0;
@@ -299,9 +300,9 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 static void wl1271_boot_enable_interrupts(struct wl1271 *wl)
 {
 	enable_irq(wl->irq);
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK,
-			   WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
-	wl1271_spi_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
+	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
+		       WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
+	wl1271_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
 }
 
 static int wl1271_boot_soft_reset(struct wl1271 *wl)
@@ -310,13 +311,12 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	u32 boot_data;
 
 	/* perform soft reset */
-	wl1271_spi_write32(wl, ACX_REG_SLV_SOFT_RESET,
-			   ACX_SLV_SOFT_RESET_BIT);
+	wl1271_write32(wl, ACX_REG_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
 
 	/* SOFT_RESET is self clearing */
 	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
 	while (1) {
-		boot_data = wl1271_spi_read32(wl, ACX_REG_SLV_SOFT_RESET);
+		boot_data = wl1271_read32(wl, ACX_REG_SLV_SOFT_RESET);
 		wl1271_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
 		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
 			break;
@@ -332,10 +332,10 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	}
 
 	/* disable Rx/Tx */
-	wl1271_spi_write32(wl, ENABLE, 0x0);
+	wl1271_write32(wl, ENABLE, 0x0);
 
 	/* disable auto calibration on start*/
-	wl1271_spi_write32(wl, SPARE_A2, 0xffff);
+	wl1271_write32(wl, SPARE_A2, 0xffff);
 
 	return 0;
 }
@@ -347,7 +347,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 
 	wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 
-	chip_id = wl1271_spi_read32(wl, CHIP_ID_B);
+	chip_id = wl1271_read32(wl, CHIP_ID_B);
 
 	wl1271_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
 
@@ -360,8 +360,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	loop = 0;
 	while (loop++ < INIT_LOOP) {
 		udelay(INIT_LOOP_DELAY);
-		interrupt = wl1271_spi_read32(wl,
-					      ACX_REG_INTERRUPT_NO_CLEAR);
+		interrupt = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 
 		if (interrupt == 0xffffffff) {
 			wl1271_error("error reading hardware complete "
@@ -370,8 +369,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		}
 		/* check that ACX_INTR_INIT_COMPLETE is enabled */
 		else if (interrupt & WL1271_ACX_INTR_INIT_COMPLETE) {
-			wl1271_spi_write32(wl, ACX_REG_INTERRUPT_ACK,
-					   WL1271_ACX_INTR_INIT_COMPLETE);
+			wl1271_write32(wl, ACX_REG_INTERRUPT_ACK,
+				       WL1271_ACX_INTR_INIT_COMPLETE);
 			break;
 		}
 	}
@@ -383,10 +382,10 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	}
 
 	/* get hardware config command mail box */
-	wl->cmd_box_addr = wl1271_spi_read32(wl, REG_COMMAND_MAILBOX_PTR);
+	wl->cmd_box_addr = wl1271_read32(wl, REG_COMMAND_MAILBOX_PTR);
 
 	/* get hardware config event mail box */
-	wl->event_box_addr = wl1271_spi_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->event_box_addr = wl1271_read32(wl, REG_EVENT_MAILBOX_PTR);
 
 	/* set the working partition to its "running" mode offset */
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
@@ -459,9 +458,9 @@ int wl1271_boot(struct wl1271 *wl)
 		wl1271_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
 	}
 
-	wl1271_spi_write32(wl, PLL_PARAMETERS, clk);
+	wl1271_write32(wl, PLL_PARAMETERS, clk);
 
-	pause = wl1271_spi_read32(wl, PLL_PARAMETERS);
+	pause = wl1271_read32(wl, PLL_PARAMETERS);
 
 	wl1271_debug(DEBUG_BOOT, "pause1 0x%x", pause);
 
@@ -470,10 +469,10 @@ int wl1271_boot(struct wl1271 *wl)
 					   * 0x3ff (magic number ).  How does
 					   * this work?! */
 	pause |= WU_COUNTER_PAUSE_VAL;
-	wl1271_spi_write32(wl, WU_COUNTER_PAUSE, pause);
+	wl1271_write32(wl, WU_COUNTER_PAUSE, pause);
 
 	/* Continue the ELP wake up sequence */
-	wl1271_spi_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	wl1271_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
 	udelay(500);
 
 	wl1271_set_partition(wl, &part_table[PART_DRPW]);
@@ -483,18 +482,18 @@ int wl1271_boot(struct wl1271 *wl)
 	   before taking DRPw out of reset */
 
 	wl1271_debug(DEBUG_BOOT, "DRPW_SCRATCH_START %08x", DRPW_SCRATCH_START);
-	clk = wl1271_spi_read32(wl, DRPW_SCRATCH_START);
+	clk = wl1271_read32(wl, DRPW_SCRATCH_START);
 
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
 	/* 2 */
 	clk |= (REF_CLOCK << 1) << 4;
-	wl1271_spi_write32(wl, DRPW_SCRATCH_START, clk);
+	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
 
 	/* Disable interrupts */
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
 
 	ret = wl1271_boot_soft_reset(wl);
 	if (ret < 0)
@@ -509,23 +508,22 @@ int wl1271_boot(struct wl1271 *wl)
 	 * ACX_EEPROMLESS_IND_REG */
 	wl1271_debug(DEBUG_BOOT, "ACX_EEPROMLESS_IND_REG");
 
-	wl1271_spi_write32(wl, ACX_EEPROMLESS_IND_REG,
-			   ACX_EEPROMLESS_IND_REG);
+	wl1271_write32(wl, ACX_EEPROMLESS_IND_REG, ACX_EEPROMLESS_IND_REG);
 
-	tmp = wl1271_spi_read32(wl, CHIP_ID_B);
+	tmp = wl1271_read32(wl, CHIP_ID_B);
 
 	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
 
 	/* 6. read the EEPROM parameters */
-	tmp = wl1271_spi_read32(wl, SCR_PAD2);
+	tmp = wl1271_read32(wl, SCR_PAD2);
 
 	ret = wl1271_boot_write_irq_polarity(wl);
 	if (ret < 0)
 		goto out;
 
 	/* FIXME: Need to check whether this is really what we want */
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK,
-			   WL1271_ACX_ALL_EVENTS_VECTOR);
+	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
+		       WL1271_ACX_ALL_EVENTS_VECTOR);
 
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
 	 * to upload_fw) */
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 54b5124..36a64e0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -30,6 +30,7 @@
 #include "wl1271.h"
 #include "wl1271_reg.h"
 #include "wl1271_spi.h"
+#include "wl1271_io.h"
 #include "wl1271_acx.h"
 #include "wl12xx_80211.h"
 #include "wl1271_cmd.h"
@@ -57,13 +58,13 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 	WARN_ON(len % 4 != 0);
 
-	wl1271_spi_write(wl, wl->cmd_box_addr, buf, len, false);
+	wl1271_write(wl, wl->cmd_box_addr, buf, len, false);
 
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
+	wl1271_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
 
 	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
 
-	intr = wl1271_spi_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+	intr = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	while (!(intr & WL1271_ACX_INTR_CMD_COMPLETE)) {
 		if (time_after(jiffies, timeout)) {
 			wl1271_error("command complete timeout");
@@ -73,13 +74,13 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 		msleep(1);
 
-		intr = wl1271_spi_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		intr = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	}
 
 	/* read back the status code of the command */
 	if (res_len == 0)
 		res_len = sizeof(struct wl1271_cmd_header);
-	wl1271_spi_read(wl, wl->cmd_box_addr, cmd, res_len, false);
+	wl1271_read(wl, wl->cmd_box_addr, cmd, res_len, false);
 
 	status = le16_to_cpu(cmd->status);
 	if (status != CMD_STATUS_SUCCESS) {
@@ -87,8 +88,8 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		ret = -EIO;
 	}
 
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_ACK,
-			   WL1271_ACX_INTR_CMD_COMPLETE);
+	wl1271_write32(wl, ACX_REG_INTERRUPT_ACK,
+		       WL1271_ACX_INTR_CMD_COMPLETE);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 2803e70..7468ef1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -24,6 +24,7 @@
 #include "wl1271.h"
 #include "wl1271_reg.h"
 #include "wl1271_spi.h"
+#include "wl1271_io.h"
 #include "wl1271_event.h"
 #include "wl1271_ps.h"
 #include "wl12xx_80211.h"
@@ -214,7 +215,7 @@ int wl1271_event_unmask(struct wl1271 *wl)
 
 void wl1271_event_mbox_config(struct wl1271 *wl)
 {
-	wl->mbox_ptr[0] = wl1271_spi_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->mbox_ptr[0] = wl1271_read32(wl, REG_EVENT_MAILBOX_PTR);
 	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
 
 	wl1271_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
@@ -232,8 +233,8 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 		return -EINVAL;
 
 	/* first we read the mbox descriptor */
-	wl1271_spi_read(wl, wl->mbox_ptr[mbox_num], &mbox,
-			sizeof(struct event_mailbox), false);
+	wl1271_read(wl, wl->mbox_ptr[mbox_num], &mbox,
+		    sizeof(struct event_mailbox), false);
 
 	/* process the descriptor */
 	ret = wl1271_event_process(wl, &mbox);
@@ -241,7 +242,7 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 		return ret;
 
 	/* then we let the firmware know it can go on...*/
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
+	wl1271_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.c b/drivers/net/wireless/wl12xx/wl1271_io.c
index dcb588b..00f98bd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.c
+++ b/drivers/net/wireless/wl12xx/wl1271_io.c
@@ -124,10 +124,10 @@ void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
 void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
 		     size_t len, bool fixed)
 {
-	wl1271_spi_read(wl, addr, buf, len, fixed);
+	wl1271_spi_raw_read(wl, addr, buf, len, fixed);
 }
 
-void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf, size_t len,
+void wl1271_read(struct wl1271 *wl, int addr, void *buf, size_t len,
 		     bool fixed)
 {
 	int physical;
@@ -137,8 +137,8 @@ void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf, size_t len,
 	wl1271_spi_raw_read(wl, physical, buf, len, fixed);
 }
 
-void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf, size_t len,
-		      bool fixed)
+void wl1271_write(struct wl1271 *wl, int addr, void *buf, size_t len,
+		  bool fixed)
 {
 	int physical;
 
@@ -147,12 +147,12 @@ void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf, size_t len,
 	wl1271_spi_raw_write(wl, physical, buf, len, fixed);
 }
 
-u32 wl1271_spi_read32(struct wl1271 *wl, int addr)
+u32 wl1271_read32(struct wl1271 *wl, int addr)
 {
 	return wl1271_raw_read32(wl, wl1271_translate_addr(wl, addr));
 }
 
-void wl1271_spi_write32(struct wl1271 *wl, int addr, u32 val)
+void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
 {
 	wl1271_raw_write32(wl, wl1271_translate_addr(wl, addr), val);
 }
@@ -161,13 +161,13 @@ void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
 {
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
-	wl1271_spi_write32(wl, OCP_POR_CTR, addr);
+	wl1271_write32(wl, OCP_POR_CTR, addr);
 
 	/* write value to OCP_POR_WDATA */
-	wl1271_spi_write32(wl, OCP_DATA_WRITE, val);
+	wl1271_write32(wl, OCP_DATA_WRITE, val);
 
 	/* write 1 to OCP_CMD */
-	wl1271_spi_write32(wl, OCP_CMD, OCP_CMD_WRITE);
+	wl1271_write32(wl, OCP_CMD, OCP_CMD_WRITE);
 }
 
 u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
@@ -177,14 +177,14 @@ u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
 
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
-	wl1271_spi_write32(wl, OCP_POR_CTR, addr);
+	wl1271_write32(wl, OCP_POR_CTR, addr);
 
 	/* write 2 to OCP_CMD */
-	wl1271_spi_write32(wl, OCP_CMD, OCP_CMD_READ);
+	wl1271_write32(wl, OCP_CMD, OCP_CMD_READ);
 
 	/* poll for data ready */
 	do {
-		val = wl1271_spi_read32(wl, OCP_DATA_READ);
+		val = wl1271_read32(wl, OCP_DATA_READ);
 	} while (!(val & OCP_READY_MASK) && --timeout);
 
 	if (!timeout) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index 2dc6abb..859d571 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -34,4 +34,33 @@ void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
 void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
 		     size_t len, bool fixed);
 
+/* Translated target IO */
+void wl1271_read(struct wl1271 *wl, int addr, void *buf, size_t len,
+		     bool fixed);
+void wl1271_write(struct wl1271 *wl, int addr, void *buf, size_t len,
+		      bool fixed);
+u32 wl1271_read32(struct wl1271 *wl, int addr);
+void wl1271_write32(struct wl1271 *wl, int addr, u32 val);
+
+/* Top Register IO */
+void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
+u16 wl1271_top_reg_read(struct wl1271 *wl, int addr);
+
+int wl1271_set_partition(struct wl1271 *wl,
+			 struct wl1271_partition_set *p);
+
+static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
+{
+	wl1271_raw_read(wl, addr, &wl->buffer_32,
+			    sizeof(wl->buffer_32), false);
+
+	return wl->buffer_32;
+}
+
+static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
+{
+	wl->buffer_32 = val;
+	wl1271_raw_write(wl, addr, &wl->buffer_32,
+			     sizeof(wl->buffer_32), false);
+}
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index aa8f79c..4696895 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -38,6 +38,7 @@
 #include "wl12xx_80211.h"
 #include "wl1271_reg.h"
 #include "wl1271_spi.h"
+#include "wl1271_io.h"
 #include "wl1271_event.h"
 #include "wl1271_tx.h"
 #include "wl1271_rx.h"
@@ -386,8 +387,7 @@ static void wl1271_fw_status(struct wl1271 *wl,
 	u32 total = 0;
 	int i;
 
-	wl1271_spi_read(wl, FW_STATUS_ADDR, status,
-			sizeof(*status), false);
+	wl1271_read(wl, FW_STATUS_ADDR, status, sizeof(*status), false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
@@ -434,7 +434,7 @@ static void wl1271_irq_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
 
 	wl1271_fw_status(wl, wl->fw_status);
 	intr = le32_to_cpu(wl->fw_status->intr);
@@ -476,8 +476,8 @@ static void wl1271_irq_work(struct work_struct *work)
 	}
 
 out_sleep:
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK,
-			   WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
+	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
+		       WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
 	wl1271_ps_elp_sleep(wl);
 
 out:
@@ -664,7 +664,7 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 	/* whal_FwCtrl_BootSm() */
 
 	/* 0. read chip id from CHIP_ID */
-	wl->chip.id = wl1271_spi_read32(wl, CHIP_ID_B);
+	wl->chip.id = wl1271_read32(wl, CHIP_ID_B);
 
 	/* 1. check if chip id is valid */
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index 29f6700..e2b1ebf 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -24,6 +24,7 @@
 #include "wl1271_reg.h"
 #include "wl1271_ps.h"
 #include "wl1271_spi.h"
+#include "wl1271_io.h"
 
 #define WL1271_WAKEUP_TIMEOUT 500
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index e8eee88..6730f5b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -26,6 +26,7 @@
 #include "wl1271_reg.h"
 #include "wl1271_rx.h"
 #include "wl1271_spi.h"
+#include "wl1271_io.h"
 
 static u8 wl1271_rx_get_mem_block(struct wl1271_fw_status *status,
 				  u32 drv_rx_counter)
@@ -166,7 +167,7 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 	}
 
 	buf = skb_put(skb, length);
-	wl1271_spi_read(wl, WL1271_SLV_MEM_DATA, buf, length, true);
+	wl1271_read(wl, WL1271_SLV_MEM_DATA, buf, length, true);
 
 	/* the data read starts with the descriptor */
 	desc = (struct wl1271_rx_descriptor *) buf;
@@ -210,15 +211,13 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 			wl->rx_mem_pool_addr.addr + 4;
 
 		/* Choose the block we want to read */
-		wl1271_spi_write(wl, WL1271_SLV_REG_DATA,
-				 &wl->rx_mem_pool_addr,
-				 sizeof(wl->rx_mem_pool_addr), false);
+		wl1271_write(wl, WL1271_SLV_REG_DATA, &wl->rx_mem_pool_addr,
+			     sizeof(wl->rx_mem_pool_addr), false);
 
 		wl1271_rx_handle_data(wl, buf_size);
 
 		wl->rx_counter++;
 		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
-		wl1271_spi_write32(wl, RX_DRIVER_COUNTER_ADDRESS,
-				   wl->rx_counter);
+		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 	}
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.h b/drivers/net/wireless/wl12xx/wl1271_spi.h
index cb7df1c..a803596 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.h
@@ -90,37 +90,7 @@ void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 		     size_t len, bool fixed);
 
-/* Translated target IO */
-void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf, size_t len,
-		     bool fixed);
-void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf, size_t len,
-		      bool fixed);
-u32 wl1271_spi_read32(struct wl1271 *wl, int addr);
-void wl1271_spi_write32(struct wl1271 *wl, int addr, u32 val);
-
-/* Top Register IO */
-void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
-u16 wl1271_top_reg_read(struct wl1271 *wl, int addr);
-
 /* INIT and RESET words */
 void wl1271_spi_reset(struct wl1271 *wl);
 void wl1271_spi_init(struct wl1271 *wl);
-int wl1271_set_partition(struct wl1271 *wl,
-			 struct wl1271_partition_set *p);
-
-static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
-{
-	wl1271_spi_raw_read(wl, addr, &wl->buffer_32,
-			    sizeof(wl->buffer_32), false);
-
-	return wl->buffer_32;
-}
-
-static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
-{
-	wl->buffer_32 = val;
-	wl1271_spi_raw_write(wl, addr, &wl->buffer_32,
-			     sizeof(wl->buffer_32), false);
-}
-
 #endif /* __WL1271_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index f9e0638..811e739 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -26,6 +26,7 @@
 
 #include "wl1271.h"
 #include "wl1271_spi.h"
+#include "wl1271_io.h"
 #include "wl1271_reg.h"
 #include "wl1271_ps.h"
 #include "wl1271_tx.h"
@@ -165,11 +166,11 @@ static int wl1271_tx_send_packet(struct wl1271 *wl, struct sk_buff *skb,
 	len = WL1271_TX_ALIGN(skb->len);
 
 	/* perform a fixed address block write with the packet */
-	wl1271_spi_write(wl, WL1271_SLV_MEM_DATA, skb->data, len, true);
+	wl1271_write(wl, WL1271_SLV_MEM_DATA, skb->data, len, true);
 
 	/* write packet new counter into the write access register */
 	wl->tx_packets_count++;
-	wl1271_spi_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
+	wl1271_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
 	wl1271_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u (%u words)",
@@ -375,8 +376,8 @@ void wl1271_tx_complete(struct wl1271 *wl, u32 count)
 	wl1271_debug(DEBUG_TX, "tx_complete received, packets: %d", count);
 
 	/* read the tx results from the chipset */
-	wl1271_spi_read(wl, le32_to_cpu(memmap->tx_result),
-			wl->tx_res_if, sizeof(*wl->tx_res_if), false);
+	wl1271_read(wl, le32_to_cpu(memmap->tx_result),
+		    wl->tx_res_if, sizeof(*wl->tx_res_if), false);
 
 	/* verify that the result buffer is not getting overrun */
 	if (count > TX_HW_RESULT_QUEUE_LEN) {
@@ -397,10 +398,10 @@ void wl1271_tx_complete(struct wl1271 *wl, u32 count)
 	}
 
 	/* write host counter to chipset (to ack) */
-	wl1271_spi_write32(wl, le32_to_cpu(memmap->tx_result) +
-			   offsetof(struct wl1271_tx_hw_res_if,
-				    tx_result_host_counter),
-			   le32_to_cpu(wl->tx_res_if->tx_result_fw_counter));
+	wl1271_write32(wl, le32_to_cpu(memmap->tx_result) +
+		       offsetof(struct wl1271_tx_hw_res_if,
+		       tx_result_host_counter),
+		       le32_to_cpu(wl->tx_res_if->tx_result_fw_counter));
 }
 
 /* caller must hold wl->mutex */
-- 
1.6.3.3

