Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59051 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbZJLMOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:14:16 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 13/16] wl1271: Remove outdated SPI functions
Date: Mon, 12 Oct 2009 15:08:54 +0300
Message-Id: <1255349337-9776-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

With the change to the new firmware, there was a change to firmware memory
partitioning. Along with that change, the translation of all partitions was
unified, and separate functions for reg and mem access became unnecessary.

Cleanup the unnecessary functions.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c  |   63 +++++++++++----------
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   19 +++---
 drivers/net/wireless/wl12xx/wl1271_event.c |    8 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |   12 ++--
 drivers/net/wireless/wl12xx/wl1271_ps.c    |    4 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c    |   10 ++--
 drivers/net/wireless/wl12xx/wl1271_spi.c   |   85 +++++++++-------------------
 drivers/net/wireless/wl12xx/wl1271_spi.h   |   36 +++++-------
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   10 ++--
 9 files changed, 107 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index b586577..a27601d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -93,19 +93,19 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 	u32 cpu_ctrl;
 
 	/* 10.5.0 run the firmware (I) */
-	cpu_ctrl = wl1271_reg_read32(wl, ACX_REG_ECPU_CONTROL);
+	cpu_ctrl = wl1271_spi_read32(wl, ACX_REG_ECPU_CONTROL);
 
 	/* 10.5.1 run the firmware (II) */
 	cpu_ctrl |= flag;
-	wl1271_reg_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
+	wl1271_spi_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
 }
 
 static void wl1271_boot_fw_version(struct wl1271 *wl)
 {
 	struct wl1271_static_data static_data;
 
-	wl1271_spi_mem_read(wl, wl->cmd_box_addr,
-			    &static_data, sizeof(static_data));
+	wl1271_spi_read(wl, wl->cmd_box_addr,
+			&static_data, sizeof(static_data), false);
 
 	strncpy(wl->chip.fw_ver, static_data.fw_version,
 		sizeof(wl->chip.fw_ver));
@@ -164,7 +164,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		memcpy(chunk, p, CHUNK_SIZE);
 		wl1271_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
 			     p, addr);
-		wl1271_spi_mem_write(wl, addr, chunk, CHUNK_SIZE);
+		wl1271_spi_write(wl, addr, chunk, CHUNK_SIZE, false);
 
 		chunk_num++;
 	}
@@ -175,7 +175,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	memcpy(chunk, p, fw_data_len % CHUNK_SIZE);
 	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%zd B) 0x%p to 0x%x",
 		     fw_data_len % CHUNK_SIZE, p, addr);
-	wl1271_spi_mem_write(wl, addr, chunk, fw_data_len % CHUNK_SIZE);
+	wl1271_spi_write(wl, addr, chunk, fw_data_len % CHUNK_SIZE, false);
 
 	kfree(chunk);
 	return 0;
@@ -262,7 +262,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 			wl1271_debug(DEBUG_BOOT,
 				     "nvs burst write 0x%x: 0x%x",
 				     dest_addr, val);
-			wl1271_reg_write32(wl, dest_addr, val);
+			wl1271_spi_write32(wl, dest_addr, val);
 
 			nvs_ptr += 4;
 			dest_addr += 4;
@@ -289,7 +289,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	/* FIXME: In wl1271, we upload everything at once.
 	   No endianness handling needed here?! The ref driver doesn't do
 	   anything about it at this point */
-	wl1271_spi_mem_write(wl, CMD_MBOX_ADDRESS, nvs_aligned, nvs_len);
+	wl1271_spi_write(wl, CMD_MBOX_ADDRESS, nvs_aligned, nvs_len, false);
 
 	kfree(nvs_aligned);
 	return 0;
@@ -298,9 +298,9 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 static void wl1271_boot_enable_interrupts(struct wl1271 *wl)
 {
 	enable_irq(wl->irq);
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK,
 			   WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
-	wl1271_reg_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
+	wl1271_spi_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
 }
 
 static int wl1271_boot_soft_reset(struct wl1271 *wl)
@@ -309,12 +309,13 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	u32 boot_data;
 
 	/* perform soft reset */
-	wl1271_reg_write32(wl, ACX_REG_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
+	wl1271_spi_write32(wl, ACX_REG_SLV_SOFT_RESET,
+			   ACX_SLV_SOFT_RESET_BIT);
 
 	/* SOFT_RESET is self clearing */
 	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
 	while (1) {
-		boot_data = wl1271_reg_read32(wl, ACX_REG_SLV_SOFT_RESET);
+		boot_data = wl1271_spi_read32(wl, ACX_REG_SLV_SOFT_RESET);
 		wl1271_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
 		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
 			break;
@@ -330,10 +331,10 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	}
 
 	/* disable Rx/Tx */
-	wl1271_reg_write32(wl, ENABLE, 0x0);
+	wl1271_spi_write32(wl, ENABLE, 0x0);
 
 	/* disable auto calibration on start*/
-	wl1271_reg_write32(wl, SPARE_A2, 0xffff);
+	wl1271_spi_write32(wl, SPARE_A2, 0xffff);
 
 	return 0;
 }
@@ -345,7 +346,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 
 	wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 
-	chip_id = wl1271_reg_read32(wl, CHIP_ID_B);
+	chip_id = wl1271_spi_read32(wl, CHIP_ID_B);
 
 	wl1271_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
 
@@ -358,7 +359,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	loop = 0;
 	while (loop++ < INIT_LOOP) {
 		udelay(INIT_LOOP_DELAY);
-		interrupt = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		interrupt = wl1271_spi_read32(wl,
+					      ACX_REG_INTERRUPT_NO_CLEAR);
 
 		if (interrupt == 0xffffffff) {
 			wl1271_error("error reading hardware complete "
@@ -367,7 +369,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		}
 		/* check that ACX_INTR_INIT_COMPLETE is enabled */
 		else if (interrupt & WL1271_ACX_INTR_INIT_COMPLETE) {
-			wl1271_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
+			wl1271_spi_write32(wl, ACX_REG_INTERRUPT_ACK,
 					   WL1271_ACX_INTR_INIT_COMPLETE);
 			break;
 		}
@@ -380,10 +382,10 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	}
 
 	/* get hardware config command mail box */
-	wl->cmd_box_addr = wl1271_reg_read32(wl, REG_COMMAND_MAILBOX_PTR);
+	wl->cmd_box_addr = wl1271_spi_read32(wl, REG_COMMAND_MAILBOX_PTR);
 
 	/* get hardware config event mail box */
-	wl->event_box_addr = wl1271_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->event_box_addr = wl1271_spi_read32(wl, REG_EVENT_MAILBOX_PTR);
 
 	/* set the working partition to its "running" mode offset */
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
@@ -458,9 +460,9 @@ int wl1271_boot(struct wl1271 *wl)
 		wl1271_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
 	}
 
-	wl1271_reg_write32(wl, PLL_PARAMETERS, clk);
+	wl1271_spi_write32(wl, PLL_PARAMETERS, clk);
 
-	pause = wl1271_reg_read32(wl, PLL_PARAMETERS);
+	pause = wl1271_spi_read32(wl, PLL_PARAMETERS);
 
 	wl1271_debug(DEBUG_BOOT, "pause1 0x%x", pause);
 
@@ -469,10 +471,10 @@ int wl1271_boot(struct wl1271 *wl)
 					   * 0x3ff (magic number ).  How does
 					   * this work?! */
 	pause |= WU_COUNTER_PAUSE_VAL;
-	wl1271_reg_write32(wl, WU_COUNTER_PAUSE, pause);
+	wl1271_spi_write32(wl, WU_COUNTER_PAUSE, pause);
 
 	/* Continue the ELP wake up sequence */
-	wl1271_reg_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	wl1271_spi_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
 	udelay(500);
 
 	wl1271_set_partition(wl, &part_table[PART_DRPW]);
@@ -482,18 +484,18 @@ int wl1271_boot(struct wl1271 *wl)
 	   before taking DRPw out of reset */
 
 	wl1271_debug(DEBUG_BOOT, "DRPW_SCRATCH_START %08x", DRPW_SCRATCH_START);
-	clk = wl1271_reg_read32(wl, DRPW_SCRATCH_START);
+	clk = wl1271_spi_read32(wl, DRPW_SCRATCH_START);
 
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
 	/* 2 */
 	clk |= (REF_CLOCK << 1) << 4;
-	wl1271_reg_write32(wl, DRPW_SCRATCH_START, clk);
+	wl1271_spi_write32(wl, DRPW_SCRATCH_START, clk);
 
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
 
 	/* Disable interrupts */
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
 
 	ret = wl1271_boot_soft_reset(wl);
 	if (ret < 0)
@@ -508,21 +510,22 @@ int wl1271_boot(struct wl1271 *wl)
 	 * ACX_EEPROMLESS_IND_REG */
 	wl1271_debug(DEBUG_BOOT, "ACX_EEPROMLESS_IND_REG");
 
-	wl1271_reg_write32(wl, ACX_EEPROMLESS_IND_REG, ACX_EEPROMLESS_IND_REG);
+	wl1271_spi_write32(wl, ACX_EEPROMLESS_IND_REG,
+			   ACX_EEPROMLESS_IND_REG);
 
-	tmp = wl1271_reg_read32(wl, CHIP_ID_B);
+	tmp = wl1271_spi_read32(wl, CHIP_ID_B);
 
 	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
 
 	/* 6. read the EEPROM parameters */
-	tmp = wl1271_reg_read32(wl, SCR_PAD2);
+	tmp = wl1271_spi_read32(wl, SCR_PAD2);
 
 	ret = wl1271_boot_write_irq_polarity(wl);
 	if (ret < 0)
 		goto out;
 
 	/* FIXME: Need to check whether this is really what we want */
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK,
 			   WL1271_ACX_ALL_EVENTS_VECTOR);
 
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index ef92834..f727744 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -55,13 +55,13 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
 
 	WARN_ON(len % 4 != 0);
 
-	wl1271_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
+	wl1271_spi_write(wl, wl->cmd_box_addr, buf, len, false);
 
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
 
 	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
 
-	intr = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+	intr = wl1271_spi_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	while (!(intr & WL1271_ACX_INTR_CMD_COMPLETE)) {
 		if (time_after(jiffies, timeout)) {
 			wl1271_error("command complete timeout");
@@ -71,10 +71,10 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
 
 		msleep(1);
 
-		intr = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		intr = wl1271_spi_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	}
 
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_ACK,
 			   WL1271_ACX_INTR_CMD_COMPLETE);
 
 out:
@@ -302,7 +302,7 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
 		 * The answer would be a wl1271_command, where the
 		 * parameter array contains the actual answer.
 		 */
-		wl1271_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
+		wl1271_spi_read(wl, wl->cmd_box_addr, buf, buf_len, false);
 
 		cmd_answer = buf;
 
@@ -341,7 +341,7 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	}
 
 	/* the interrogate command got in, we can read the answer */
-	wl1271_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
+	wl1271_spi_read(wl, wl->cmd_box_addr, buf, len, false);
 
 	acx = buf;
 	if (acx->cmd.status != CMD_STATUS_SUCCESS)
@@ -496,7 +496,7 @@ int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 	}
 
 	/* the read command got in, we can now read the answer */
-	wl1271_spi_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
+	wl1271_spi_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd), false);
 
 	if (cmd->header.status != CMD_STATUS_SUCCESS)
 		wl1271_error("error in read command result: %d",
@@ -591,7 +591,8 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 		goto out;
 	}
 
-	wl1271_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
+	wl1271_spi_read(wl, wl->cmd_box_addr, params, sizeof(*params),
+			false);
 
 	if (params->header.status != CMD_STATUS_SUCCESS) {
 		wl1271_error("Scan command error: %d",
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index f329276..4189e97 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -98,7 +98,7 @@ int wl1271_event_unmask(struct wl1271 *wl)
 
 void wl1271_event_mbox_config(struct wl1271 *wl)
 {
-	wl->mbox_ptr[0] = wl1271_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->mbox_ptr[0] = wl1271_spi_read32(wl, REG_EVENT_MAILBOX_PTR);
 	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
 
 	wl1271_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
@@ -116,8 +116,8 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 		return -EINVAL;
 
 	/* first we read the mbox descriptor */
-	wl1271_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
-			    sizeof(struct event_mailbox));
+	wl1271_spi_read(wl, wl->mbox_ptr[mbox_num], &mbox,
+			sizeof(struct event_mailbox), false);
 
 	/* process the descriptor */
 	ret = wl1271_event_process(wl, &mbox);
@@ -125,7 +125,7 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 		return ret;
 
 	/* then we let the firmware know it can go on...*/
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 8ac9bc1..5ef0bd5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -82,8 +82,8 @@ static void wl1271_fw_status(struct wl1271 *wl,
 	u32 total = 0;
 	int i;
 
-	wl1271_spi_reg_read(wl, FW_STATUS_ADDR, status,
-			    sizeof(*status), false);
+	wl1271_spi_read(wl, FW_STATUS_ADDR, status,
+			sizeof(*status), false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
@@ -126,7 +126,7 @@ static void wl1271_irq_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
 
 	wl1271_fw_status(wl, wl->fw_status);
 	intr = wl->fw_status->intr;
@@ -168,7 +168,7 @@ static void wl1271_irq_work(struct work_struct *work)
 	}
 
 out_sleep:
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK,
 			   WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
 	wl1271_ps_elp_sleep(wl);
 
@@ -279,7 +279,7 @@ static void wl1271_fw_wakeup(struct wl1271 *wl)
 	u32 elp_reg;
 
 	elp_reg = ELPCTRL_WAKE_UP;
-	wl1271_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
+	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
 }
 
 static int wl1271_setup(struct wl1271 *wl)
@@ -322,7 +322,7 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 	/* whal_FwCtrl_BootSm() */
 
 	/* 0. read chip id from CHIP_ID */
-	wl->chip.id = wl1271_reg_read32(wl, CHIP_ID_B);
+	wl->chip.id = wl1271_spi_read32(wl, CHIP_ID_B);
 
 	/* 1. check if chip id is valid */
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index fb821c9..bb8745d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -43,7 +43,7 @@ void wl1271_elp_work(struct work_struct *work)
 		goto out;
 
 	wl1271_debug(DEBUG_PSM, "chip to elp");
-	wl1271_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
+	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
 	wl->elp = true;
 
 out:
@@ -86,7 +86,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
 		wl->elp_compl = &compl;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	wl1271_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
+	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
 
 	if (!pending) {
 		ret = wait_for_completion_timeout(
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 1d98653..7979b69 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -132,7 +132,7 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 	}
 
 	buf = skb_put(skb, length);
-	wl1271_spi_reg_read(wl, WL1271_SLV_MEM_DATA, buf, length, true);
+	wl1271_spi_read(wl, WL1271_SLV_MEM_DATA, buf, length, true);
 
 	/* the data read starts with the descriptor */
 	desc = (struct wl1271_rx_descriptor *) buf;
@@ -176,9 +176,9 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 			wl->rx_mem_pool_addr.addr + 4;
 
 		/* Choose the block we want to read */
-		wl1271_spi_reg_write(wl, WL1271_SLV_REG_DATA,
-				     &wl->rx_mem_pool_addr,
-				     sizeof(wl->rx_mem_pool_addr), false);
+		wl1271_spi_write(wl, WL1271_SLV_REG_DATA,
+				 &wl->rx_mem_pool_addr,
+				 sizeof(wl->rx_mem_pool_addr), false);
 
 		wl1271_rx_handle_data(wl, buf_size);
 
@@ -186,5 +186,5 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	}
 
-	wl1271_reg_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
+	wl1271_spi_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 7a7890b..4800fdf 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -183,13 +183,13 @@ int wl1271_set_partition(struct wl1271 *wl,
 		     p->mem3.start, p->mem3.size);
 
 	/* write partition info to the chipset */
-	wl1271_write32(wl, HW_PART0_START_ADDR, p->mem.start);
-	wl1271_write32(wl, HW_PART0_SIZE_ADDR, p->mem.size);
-	wl1271_write32(wl, HW_PART1_START_ADDR, p->reg.start);
-	wl1271_write32(wl, HW_PART1_SIZE_ADDR, p->reg.size);
-	wl1271_write32(wl, HW_PART2_START_ADDR, p->mem2.start);
-	wl1271_write32(wl, HW_PART2_SIZE_ADDR, p->mem2.size);
-	wl1271_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
+	wl1271_raw_write32(wl, HW_PART0_START_ADDR, p->mem.start);
+	wl1271_raw_write32(wl, HW_PART0_SIZE_ADDR, p->mem.size);
+	wl1271_raw_write32(wl, HW_PART1_START_ADDR, p->reg.start);
+	wl1271_raw_write32(wl, HW_PART1_SIZE_ADDR, p->reg.size);
+	wl1271_raw_write32(wl, HW_PART2_START_ADDR, p->mem2.start);
+	wl1271_raw_write32(wl, HW_PART2_SIZE_ADDR, p->mem2.size);
+	wl1271_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
 
 	return 0;
 }
@@ -257,8 +257,8 @@ void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
 	wl1271_error("SPI read busy-word timeout!\n");
 }
 
-void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf,
-		     size_t len, bool fixed)
+void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
+			 size_t len, bool fixed)
 {
 	struct spi_transfer t[3];
 	struct spi_message m;
@@ -302,8 +302,8 @@ void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf,
 	wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
 }
 
-void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf,
-		      size_t len, bool fixed)
+void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
+			  size_t len, bool fixed)
 {
 	struct spi_transfer t[2];
 	struct spi_message m;
@@ -336,77 +336,47 @@ void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf,
 	wl1271_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
 
-void wl1271_spi_mem_read(struct wl1271 *wl, int addr, void *buf,
-			 size_t len)
+void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf, size_t len,
+		     bool fixed)
 {
 	int physical;
 
 	physical = wl1271_translate_addr(wl, addr);
 
-	wl1271_spi_read(wl, physical, buf, len, false);
+	wl1271_spi_raw_read(wl, physical, buf, len, fixed);
 }
 
-void wl1271_spi_mem_write(struct wl1271 *wl, int addr, void *buf,
-			  size_t len)
+void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf, size_t len,
+		      bool fixed)
 {
 	int physical;
 
 	physical = wl1271_translate_addr(wl, addr);
 
-	wl1271_spi_write(wl, physical, buf, len, false);
+	wl1271_spi_raw_write(wl, physical, buf, len, fixed);
 }
 
-void wl1271_spi_reg_read(struct wl1271 *wl, int addr, void *buf, size_t len,
-			 bool fixed)
+u32 wl1271_spi_read32(struct wl1271 *wl, int addr)
 {
-	int physical;
-
-	physical = wl1271_translate_addr(wl, addr);
-
-	wl1271_spi_read(wl, physical, buf, len, fixed);
-}
-
-void wl1271_spi_reg_write(struct wl1271 *wl, int addr, void *buf, size_t len,
-			  bool fixed)
-{
-	int physical;
-
-	physical = wl1271_translate_addr(wl, addr);
-
-	wl1271_spi_write(wl, physical, buf, len, fixed);
+	return wl1271_raw_read32(wl, wl1271_translate_addr(wl, addr));
 }
 
-u32 wl1271_mem_read32(struct wl1271 *wl, int addr)
+void wl1271_spi_write32(struct wl1271 *wl, int addr, u32 val)
 {
-	return wl1271_read32(wl, wl1271_translate_addr(wl, addr));
-}
-
-void wl1271_mem_write32(struct wl1271 *wl, int addr, u32 val)
-{
-	wl1271_write32(wl, wl1271_translate_addr(wl, addr), val);
-}
-
-u32 wl1271_reg_read32(struct wl1271 *wl, int addr)
-{
-	return wl1271_read32(wl, wl1271_translate_addr(wl, addr));
-}
-
-void wl1271_reg_write32(struct wl1271 *wl, int addr, u32 val)
-{
-	wl1271_write32(wl, wl1271_translate_addr(wl, addr), val);
+	wl1271_raw_write32(wl, wl1271_translate_addr(wl, addr), val);
 }
 
 void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
 {
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
-	wl1271_reg_write32(wl, OCP_POR_CTR, addr);
+	wl1271_spi_write32(wl, OCP_POR_CTR, addr);
 
 	/* write value to OCP_POR_WDATA */
-	wl1271_reg_write32(wl, OCP_DATA_WRITE, val);
+	wl1271_spi_write32(wl, OCP_DATA_WRITE, val);
 
 	/* write 1 to OCP_CMD */
-	wl1271_reg_write32(wl, OCP_CMD, OCP_CMD_WRITE);
+	wl1271_spi_write32(wl, OCP_CMD, OCP_CMD_WRITE);
 }
 
 u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
@@ -416,14 +386,14 @@ u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
 
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
-	wl1271_reg_write32(wl, OCP_POR_CTR, addr);
+	wl1271_spi_write32(wl, OCP_POR_CTR, addr);
 
 	/* write 2 to OCP_CMD */
-	wl1271_reg_write32(wl, OCP_CMD, OCP_CMD_READ);
+	wl1271_spi_write32(wl, OCP_CMD, OCP_CMD_READ);
 
 	/* poll for data ready */
 	do {
-		val = wl1271_reg_read32(wl, OCP_DATA_READ);
+		val = wl1271_spi_read32(wl, OCP_DATA_READ);
 		timeout--;
 	} while (!(val & OCP_READY_MASK) && timeout);
 
@@ -440,4 +410,3 @@ u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
 		return 0xffff;
 	}
 }
-
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.h b/drivers/net/wireless/wl12xx/wl1271_spi.h
index 4f1608e..cb7df1c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.h
@@ -85,24 +85,18 @@
 #define OCP_STATUS_RESP_ERROR 0x30000
 
 /* Raw target IO, address is not translated */
-void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf,
+void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 		      size_t len, bool fixed);
-void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf,
+void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 		     size_t len, bool fixed);
 
-/* Memory target IO, address is tranlated to partition 0 */
-void wl1271_spi_mem_read(struct wl1271 *wl, int addr, void *buf, size_t len);
-void wl1271_spi_mem_write(struct wl1271 *wl, int addr, void *buf, size_t len);
-u32 wl1271_mem_read32(struct wl1271 *wl, int addr);
-void wl1271_mem_write32(struct wl1271 *wl, int addr, u32 val);
-
-/* Registers IO */
-void wl1271_spi_reg_read(struct wl1271 *wl, int addr, void *buf, size_t len,
-			 bool fixed);
-void wl1271_spi_reg_write(struct wl1271 *wl, int addr, void *buf, size_t len,
-			  bool fixed);
-u32 wl1271_reg_read32(struct wl1271 *wl, int addr);
-void wl1271_reg_write32(struct wl1271 *wl, int addr, u32 val);
+/* Translated target IO */
+void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf, size_t len,
+		     bool fixed);
+void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf, size_t len,
+		      bool fixed);
+u32 wl1271_spi_read32(struct wl1271 *wl, int addr);
+void wl1271_spi_write32(struct wl1271 *wl, int addr, u32 val);
 
 /* Top Register IO */
 void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
@@ -114,19 +108,19 @@ void wl1271_spi_init(struct wl1271 *wl);
 int wl1271_set_partition(struct wl1271 *wl,
 			 struct wl1271_partition_set *p);
 
-static inline u32 wl1271_read32(struct wl1271 *wl, int addr)
+static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
 {
-	wl1271_spi_read(wl, addr, &wl->buffer_32,
-			sizeof(wl->buffer_32), false);
+	wl1271_spi_raw_read(wl, addr, &wl->buffer_32,
+			    sizeof(wl->buffer_32), false);
 
 	return wl->buffer_32;
 }
 
-static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
+static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
 {
 	wl->buffer_32 = val;
-	wl1271_spi_write(wl, addr, &wl->buffer_32,
-			 sizeof(wl->buffer_32), false);
+	wl1271_spi_raw_write(wl, addr, &wl->buffer_32,
+			     sizeof(wl->buffer_32), false);
 }
 
 #endif /* __WL1271_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 56a7f36..4560458 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -154,11 +154,11 @@ static int wl1271_tx_send_packet(struct wl1271 *wl, struct sk_buff *skb,
 	len = WL1271_TX_ALIGN(skb->len);
 
 	/* perform a fixed address block write with the packet */
-	wl1271_spi_reg_write(wl, WL1271_SLV_MEM_DATA, skb->data, len, true);
+	wl1271_spi_write(wl, WL1271_SLV_MEM_DATA, skb->data, len, true);
 
 	/* write packet new counter into the write access register */
 	wl->tx_packets_count++;
-	wl1271_reg_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
+	wl1271_spi_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
 	wl1271_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u (%u words)",
@@ -331,8 +331,8 @@ void wl1271_tx_complete(struct wl1271 *wl, u32 count)
 	wl1271_debug(DEBUG_TX, "tx_complete received, packets: %d", count);
 
 	/* read the tx results from the chipset */
-	wl1271_spi_mem_read(wl, memmap->tx_result,
-			    wl->tx_res_if, sizeof(*wl->tx_res_if));
+	wl1271_spi_read(wl, memmap->tx_result,
+			wl->tx_res_if, sizeof(*wl->tx_res_if), false);
 
 	/* verify that the result buffer is not getting overrun */
 	if (count > TX_HW_RESULT_QUEUE_LEN) {
@@ -353,7 +353,7 @@ void wl1271_tx_complete(struct wl1271 *wl, u32 count)
 	}
 
 	/* write host counter to chipset (to ack) */
-	wl1271_mem_write32(wl, memmap->tx_result +
+	wl1271_spi_write32(wl, memmap->tx_result +
 			   offsetof(struct wl1271_tx_hw_res_if,
 				    tx_result_host_counter),
 			   wl->tx_res_if->tx_result_fw_counter);
-- 
1.5.6.5

