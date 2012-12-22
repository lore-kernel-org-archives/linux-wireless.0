Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:42352 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2LVXST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 18:18:19 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 05/17] cw1200: v2: firmware loading
Date: Sat, 22 Dec 2012 18:18:20 -0500
Message-Id: <1356218312-13616-6-git-send-email-pizza@shaftnet.org> (sfid-20121223_001825_122764_653C8A4F)
In-Reply-To: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
References: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/cw1200/fwio.c | 536 ++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/fwio.h |  41 ++++
 2 files changed, 577 insertions(+)
 create mode 100644 drivers/staging/cw1200/fwio.c
 create mode 100644 drivers/staging/cw1200/fwio.h

diff --git a/drivers/staging/cw1200/fwio.c b/drivers/staging/cw1200/fwio.c
new file mode 100644
index 0000000..9b858be
--- /dev/null
+++ b/drivers/staging/cw1200/fwio.c
@@ -0,0 +1,536 @@
+/*
+ * Firmware I/O code for mac80211 ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * Based on:
+ * ST-Ericsson UMAC CW1200 driver which is
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Ajitpal Singh <ajitpal.singh@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/vmalloc.h>
+#include <linux/sched.h>
+#include <linux/firmware.h>
+
+#include "cw1200.h"
+#include "fwio.h"
+#include "hwio.h"
+#include "sbus.h"
+#include "bh.h"
+
+static int cw1200_get_hw_type(u32 config_reg_val, int *major_revision)
+{
+	int hw_type = -1;
+	u32 silicon_type = (config_reg_val >> 24) & 0x3;
+	u32 silicon_vers = (config_reg_val >> 31) & 0x1;
+
+	/* Check if we have CW1200 or STLC9000 */
+	if ((silicon_type == 0x1) || (silicon_type == 0x2)) {
+		*major_revision = silicon_type;
+		if (silicon_vers)
+			hw_type = HIF_8601_VERSATILE;
+		else
+			hw_type = HIF_8601_SILICON;
+	} else {
+		*major_revision = 1;
+		hw_type = HIF_9000_SILICON_VERSTAILE;
+	}
+
+	return hw_type;
+}
+
+static int cw1200_load_firmware_cw1200(struct cw1200_common *priv)
+{
+	int ret, block, num_blocks;
+	unsigned i;
+	u32 val32;
+	u32 put = 0, get = 0;
+	u8 *buf = NULL;
+	const char *fw_path;
+	const struct firmware *firmware = NULL;
+
+	/* Macroses are local. */
+#define APB_WRITE(reg, val) \
+	do { \
+		ret = cw1200_apb_write_32(priv, CW12000_APB(reg), (val)); \
+		if (ret < 0) { \
+			pr_err("%s: can't write %s at line %d.\n", \
+				__func__, #reg, __LINE__); \
+			goto error; \
+		} \
+	} while (0)
+#define APB_READ(reg, val) \
+	do { \
+		ret = cw1200_apb_read_32(priv, CW12000_APB(reg), &(val)); \
+		if (ret < 0) { \
+			pr_err("%s: can't read %s at line %d.\n", \
+				__func__, #reg, __LINE__); \
+			goto error; \
+		} \
+	} while (0)
+#define REG_WRITE(reg, val) \
+	do { \
+		ret = cw1200_reg_write_32(priv, (reg), (val)); \
+		if (ret < 0) { \
+			pr_err("%s: can't write %s at line %d.\n", \
+				__func__, #reg, __LINE__); \
+			goto error; \
+		} \
+	} while (0)
+#define REG_READ(reg, val) \
+	do { \
+		ret = cw1200_reg_read_32(priv, (reg), &(val)); \
+		if (ret < 0) { \
+			pr_err("%s: can't read %s at line %d.\n", \
+				__func__, #reg, __LINE__); \
+			goto error; \
+		} \
+	} while (0)
+
+	switch (priv->hw_revision) {
+	case CW1200_HW_REV_CUT10:
+		fw_path = FIRMWARE_CUT10;
+		if (!priv->sdd_path)
+			priv->sdd_path = SDD_FILE_10;
+		break;
+	case CW1200_HW_REV_CUT11:
+		fw_path = FIRMWARE_CUT11;
+		if (!priv->sdd_path)
+			priv->sdd_path = SDD_FILE_11;
+		break;
+	case CW1200_HW_REV_CUT20:
+		fw_path = FIRMWARE_CUT20;
+		if (!priv->sdd_path)
+			priv->sdd_path = SDD_FILE_20;
+		break;
+	case CW1200_HW_REV_CUT22:
+		fw_path = FIRMWARE_CUT22;
+		if (!priv->sdd_path)
+			priv->sdd_path = SDD_FILE_22;
+		break;
+	default:
+		pr_err("%s: invalid silicon revision %d.\n",
+			__func__, priv->hw_revision);
+		return -EINVAL;
+	}
+
+	/* Initialize common registers */
+	APB_WRITE(DOWNLOAD_IMAGE_SIZE_REG, DOWNLOAD_ARE_YOU_HERE);
+	APB_WRITE(DOWNLOAD_PUT_REG, 0);
+	APB_WRITE(DOWNLOAD_GET_REG, 0);
+	APB_WRITE(DOWNLOAD_STATUS_REG, DOWNLOAD_PENDING);
+	APB_WRITE(DOWNLOAD_FLAGS_REG, 0);
+
+	/* Write the NOP Instruction */
+	REG_WRITE(ST90TDS_SRAM_BASE_ADDR_REG_ID, 0xFFF20000);
+	REG_WRITE(ST90TDS_AHB_DPORT_REG_ID, 0xEAFFFFFE);
+
+	/* Release CPU from RESET */
+	REG_READ(ST90TDS_CONFIG_REG_ID, val32);
+	val32 &= ~ST90TDS_CONFIG_CPU_RESET_BIT;
+	REG_WRITE(ST90TDS_CONFIG_REG_ID, val32);
+
+	/* Enable Clock */
+	val32 &= ~ST90TDS_CONFIG_CPU_CLK_DIS_BIT;
+	REG_WRITE(ST90TDS_CONFIG_REG_ID, val32);
+
+#ifdef CONFIG_CW1200_ETF
+	if (etf_mode)
+		fw_path = etf_firmware;
+#endif
+
+	/* Load a firmware file */
+	ret = request_firmware(&firmware, fw_path, priv->pdev);
+	if (ret) {
+		pr_err("%s: can't load firmware file %s.\n",
+		       __func__, fw_path);
+		goto error;
+	}
+	BUG_ON(!firmware->data);
+
+	buf = kmalloc(DOWNLOAD_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
+	if (!buf) {
+		pr_err("%s: can't allocate firmware buffer.\n", __func__);
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/* Check if the bootloader is ready */
+	for (i = 0; i < 100; i += 1 + i / 2) {
+		APB_READ(DOWNLOAD_IMAGE_SIZE_REG, val32);
+		if (val32 == DOWNLOAD_I_AM_HERE)
+			break;
+		mdelay(i);
+	} /* End of for loop */
+
+	if (val32 != DOWNLOAD_I_AM_HERE) {
+		pr_err("%s: bootloader is not ready.\n", __func__);
+		ret = -ETIMEDOUT;
+		goto error;
+	}
+
+	/* Calculcate number of download blocks */
+	num_blocks = (firmware->size - 1) / DOWNLOAD_BLOCK_SIZE + 1;
+
+	/* Updating the length in Download Ctrl Area */
+	val32 = firmware->size; /* Explicit cast from size_t to u32 */
+	APB_WRITE(DOWNLOAD_IMAGE_SIZE_REG, val32);
+
+	/* Firmware downloading loop */
+	for (block = 0; block < num_blocks ; block++) {
+		size_t tx_size;
+		size_t block_size;
+
+		/* check the download status */
+		APB_READ(DOWNLOAD_STATUS_REG, val32);
+		if (val32 != DOWNLOAD_PENDING) {
+			pr_err("%s: bootloader reported error %d.\n",
+			       __func__, val32);
+			ret = -EIO;
+			goto error;
+		}
+
+		/* loop until put - get <= 24K */
+		for (i = 0; i < 100; i++) {
+			APB_READ(DOWNLOAD_GET_REG, get);
+			if ((put - get) <=
+			    (DOWNLOAD_FIFO_SIZE - DOWNLOAD_BLOCK_SIZE))
+				break;
+			mdelay(i);
+		}
+
+		if ((put - get) > (DOWNLOAD_FIFO_SIZE - DOWNLOAD_BLOCK_SIZE)) {
+			pr_err("%s: Timeout waiting for FIFO.\n",
+			       __func__);
+			return -ETIMEDOUT;
+		}
+
+		/* calculate the block size */
+		tx_size = block_size = min((size_t)(firmware->size - put),
+			(size_t)DOWNLOAD_BLOCK_SIZE);
+
+		memcpy(buf, &firmware->data[put], block_size);
+		if (block_size < DOWNLOAD_BLOCK_SIZE) {
+			memset(&buf[block_size],
+				0, DOWNLOAD_BLOCK_SIZE - block_size);
+			tx_size = DOWNLOAD_BLOCK_SIZE;
+		}
+
+		/* send the block to sram */
+		ret = cw1200_apb_write(priv,
+			CW12000_APB(DOWNLOAD_FIFO_OFFSET +
+				(put & (DOWNLOAD_FIFO_SIZE - 1))),
+			buf, tx_size);
+		if (ret < 0) {
+			pr_err("%s: can't write block at line %d.\n",
+			       __func__, __LINE__);
+			goto error;
+		}
+
+		/* update the put register */
+		put += block_size;
+		APB_WRITE(DOWNLOAD_PUT_REG, put);
+	} /* End of firmware download loop */
+
+	/* Wait for the download completion */
+	for (i = 0; i < 300; i += 1 + i / 2) {
+		APB_READ(DOWNLOAD_STATUS_REG, val32);
+		if (val32 != DOWNLOAD_PENDING)
+			break;
+		mdelay(i);
+	}
+	if (val32 != DOWNLOAD_SUCCESS) {
+		pr_err("%s: wait for download completion failed. Read: 0x%.8X\n", __func__, val32);
+		ret = -ETIMEDOUT;
+		goto error;
+	} else {
+		pr_info("Firmware download completed.\n");
+		ret = 0;
+	}
+
+error:
+	kfree(buf);
+	if (firmware)
+		release_firmware(firmware);
+	return ret;
+
+#undef APB_WRITE
+#undef APB_READ
+#undef REG_WRITE
+#undef REG_READ
+}
+
+
+static int config_reg_read(struct cw1200_common *priv, u32 *val)
+{
+	switch (priv->hw_type) {
+	case HIF_9000_SILICON_VERSTAILE: {
+		u16 val16;
+		int ret = cw1200_reg_read_16(priv, ST90TDS_CONFIG_REG_ID, &val16);
+		if (ret < 0)
+			return ret;
+		*val = val16;
+		return 0;
+	}
+	case HIF_8601_VERSATILE:
+	case HIF_8601_SILICON:
+	default:
+		cw1200_reg_read_32(priv, ST90TDS_CONFIG_REG_ID, val);
+		break;
+	}
+	return 0;
+}
+
+static int config_reg_write(struct cw1200_common *priv, u32 val)
+{
+	switch (priv->hw_type) {
+	case HIF_9000_SILICON_VERSTAILE:
+		return cw1200_reg_write_16(priv, ST90TDS_CONFIG_REG_ID, (u16)val);
+	case HIF_8601_VERSATILE:
+	case HIF_8601_SILICON:
+	default:
+		return cw1200_reg_write_32(priv, ST90TDS_CONFIG_REG_ID, val);
+		break;
+	}
+	return 0;
+}
+
+int cw1200_load_firmware(struct cw1200_common *priv)
+{
+	int ret;
+	int i;
+	u32 val32;
+	u16 val16;
+	int major_revision;
+
+	BUG_ON(!priv);
+
+	/* Read CONFIG Register */
+	ret = cw1200_reg_read_32(priv, ST90TDS_CONFIG_REG_ID, &val32);
+	if (ret < 0) {
+		pr_err("%s: can't read config register.\n", __func__);
+		goto out;
+	}
+
+	if (val32 == 0 || val32 == 0xffffffff) {
+		pr_err("%s: bad config register value (0x%08x)\n", __func__, val32);
+		ret = -EIO;
+		goto out;
+	}
+
+	priv->hw_type = cw1200_get_hw_type(val32, &major_revision);
+	if (priv->hw_type < 0) {
+		pr_err("%s: can't deduct hardware type.\n", __func__);
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	/* Set DPLL Reg value, and read back to confirm writes work */
+	ret = cw1200_reg_write_32(priv, ST90TDS_TSET_GEN_R_W_REG_ID, cw1200_dpll_from_clk(priv->hw_refclk));
+	if (ret < 0) {
+		pr_err("%s: can't write DPLL register.\n", __func__);
+		goto out;
+	}
+
+	msleep(20);
+
+	ret = cw1200_reg_read_32(priv,
+		ST90TDS_TSET_GEN_R_W_REG_ID, &val32);
+	if (ret < 0) {
+		pr_err("%s: can't read DPLL register.\n", __func__);
+		goto out;
+	}
+
+	if (val32 != cw1200_dpll_from_clk(priv->hw_refclk)) {
+		pr_err("%s: unable to initialise DPLL register. Wrote 0x%.8X, read 0x%.8X.\n",
+			__func__, cw1200_dpll_from_clk(priv->hw_refclk), val32);
+		ret = -EIO;
+		goto out;
+	}
+
+	/* Set wakeup bit in device */
+	ret = cw1200_reg_read_16(priv, ST90TDS_CONTROL_REG_ID, &val16);
+	if (ret < 0) {
+		pr_err("%s: set_wakeup: can't read control register.\n", __func__);
+		goto out;
+	}
+
+	ret = cw1200_reg_write_16(priv, ST90TDS_CONTROL_REG_ID,
+		val16 | ST90TDS_CONT_WUP_BIT);
+	if (ret < 0) {
+		pr_err("%s: set_wakeup: can't write control register.\n", __func__);
+		goto out;
+	}
+
+	/* Wait for wakeup */
+	for (i = 0 ; i < 300 ; i += 1 + i / 2) {
+		ret = cw1200_reg_read_16(priv,
+			ST90TDS_CONTROL_REG_ID, &val16);
+		if (ret < 0) {
+			pr_err("%s: wait_for_wakeup: can't read control register.\n", __func__);
+			goto out;
+		}
+
+		if (val16 & ST90TDS_CONT_RDY_BIT) {
+			break;
+		}
+		msleep(i);
+	}
+
+	if ((val16 & ST90TDS_CONT_RDY_BIT) == 0) {
+		pr_err("%s: wait_for_wakeup: device is not responding.\n",
+			__func__);
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	if (major_revision == 1) {
+		/* CW1200 Hardware detection logic : Check for CUT1.1 */
+		ret = cw1200_ahb_read_32(priv, CW1200_CUT_ID_ADDR, &val32);
+		if (ret) {
+			pr_err("%s: HW detection: can't read CUT ID.\n",
+			       __func__);
+			goto out;
+		}
+
+		switch (val32) {
+		case CW1200_CUT_11_ID_STR:
+			pr_info("Cut 1.1 silicon is detected.\n");
+			priv->hw_revision = CW1200_HW_REV_CUT11;
+			break;
+		default:
+			pr_info("Cut 1.0 silicon is detected.\n");
+			priv->hw_revision = CW1200_HW_REV_CUT10;
+			break;
+		}
+	} else if (major_revision == 2) {
+		u32 ar1, ar2, ar3;
+		ret = cw1200_ahb_read_32(priv, CW1200_CUT2_ID_ADDR, &ar1);
+		if (ret) {
+			pr_err("%s: (1) HW detection: can't read CUT ID.\n",
+			       __func__);
+			goto out;
+		}
+		ret = cw1200_ahb_read_32(priv, CW1200_CUT2_ID_ADDR + 4, &ar2);
+		if (ret) {
+			pr_err("%s: (2) HW detection: can't read CUT ID.\n",
+			       __func__);
+			goto out;
+		}
+
+		ret = cw1200_ahb_read_32(priv, CW1200_CUT2_ID_ADDR + 8, &ar3);
+		if (ret) {
+			pr_err(
+				"%s: (3) HW detection: can't read CUT ID.\n",
+				__func__);
+			goto out;
+		}
+
+		if (ar1 == CW1200_CUT_22_ID_STR1 &&
+		    ar2 == CW1200_CUT_22_ID_STR2 &&
+		    ar3 == CW1200_CUT_22_ID_STR3) {
+			pr_info("Cut 2.2 silicon is detected.\n");
+			priv->hw_revision = CW1200_HW_REV_CUT22;
+		} else {
+			pr_info("Cut 2.0 silicon is detected.\n");
+			priv->hw_revision = CW1200_HW_REV_CUT20;
+		}
+	} else {
+		pr_err("%s: unsupported silicon major revision %d.\n",
+		       __func__, major_revision);
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	/* Checking for access mode */
+	ret = config_reg_read(priv, &val32);
+	if (ret < 0) {
+		pr_err("%s: check_access_mode: can't read config register.\n", __func__);
+		goto out;
+	}
+
+	if (!(val32 & ST90TDS_CONFIG_ACCESS_MODE_BIT)) {
+		pr_err("%s: check_access_mode: device is already in QUEUE mode.\n", __func__);
+			ret = -EINVAL;
+			goto out;
+	}
+
+	switch (priv->hw_type)  {
+	case HIF_8601_SILICON:
+		pr_info("%s: CW1200 detected.\n", __func__);
+		ret = cw1200_load_firmware_cw1200(priv);
+		break;
+	case HIF_8601_VERSATILE:
+		/* TODO: Not implemented yet!
+		   ret = cw1200_load_firmware_cw1100(priv);
+		*/
+		ret = -ENOTSUPP;
+		goto out;
+	case HIF_9000_SILICON_VERSTAILE:
+		/* TODO: Not implemented yet!
+		   ret = cw1200_load_firmware_stlc9000(priv);
+		*/
+		ret = -ENOTSUPP;
+		goto out;
+	default:
+		pr_err("%s: Unknown hardware: %d.\n",
+		       __func__, priv->hw_type);
+		ret = -ENOTSUPP;
+		goto out;
+	}
+	if (ret < 0) {
+		pr_err("%s: can't download firmware.\n", __func__);
+		goto out;
+	}
+
+#ifndef CONFIG_CW1200_POLL_IRQ
+	/* Register Interrupt Handler */
+	ret = priv->sbus_ops->irq_subscribe(priv->sbus_priv);
+	if (ret < 0) {
+		pr_err("%s: can't register IRQ handler.\n", __func__);
+		goto out;
+	}
+#endif
+
+	priv->sbus_ops->lock(priv->sbus_priv);
+	ret = __cw1200_irq_enable(priv, 1);
+	priv->sbus_ops->unlock(priv->sbus_priv);
+	if (ret < 0) {
+		goto unsubscribe;
+	}
+
+	/* Configure device for MESSSAGE MODE */
+	ret = config_reg_read(priv, &val32);
+	if (ret < 0) {
+		pr_err("%s: set_mode: can't read config register.\n",
+		       __func__);
+		goto unsubscribe;
+	}
+	ret = config_reg_write(priv, val32 & ~ST90TDS_CONFIG_ACCESS_MODE_BIT);
+	if (ret < 0) {
+		pr_err("%s: set_mode: can't write config register.\n",
+		       __func__);
+		goto unsubscribe;
+	}
+
+	/* Unless we read the CONFIG Register we are
+	 * not able to get an interrupt */
+	mdelay(10);
+	config_reg_read(priv, &val32);
+
+out:
+	return ret;
+
+unsubscribe:
+#ifndef CONFIG_CW1200_POLL_IRQ
+	priv->sbus_ops->irq_unsubscribe(priv->sbus_priv);
+#endif
+	return ret;
+}
diff --git a/drivers/staging/cw1200/fwio.h b/drivers/staging/cw1200/fwio.h
new file mode 100644
index 0000000..5ec972f
--- /dev/null
+++ b/drivers/staging/cw1200/fwio.h
@@ -0,0 +1,41 @@
+/*
+ * Firmware API for mac80211 ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * Based on:
+ * ST-Ericsson UMAC CW1200 driver which is
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Ajitpal Singh <ajitpal.singh@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FWIO_H_INCLUDED
+#define FWIO_H_INCLUDED
+
+#define FIRMWARE_CUT22		"wsm_22.bin"
+#define FIRMWARE_CUT20		"wsm_20.bin"
+#define FIRMWARE_CUT11		"wsm_11.bin"
+#define FIRMWARE_CUT10		"wsm_10.bin"
+#define SDD_FILE_22		"sdd_22.bin"
+#define SDD_FILE_20		"sdd_20.bin"
+#define SDD_FILE_11		"sdd_11.bin"
+#define SDD_FILE_10		"sdd_10.bin"
+
+#define CW1200_HW_REV_CUT10	(10)
+#define CW1200_HW_REV_CUT11	(11)
+#define CW1200_HW_REV_CUT20	(20)
+#define CW1200_HW_REV_CUT22	(22)
+
+int cw1200_load_firmware(struct cw1200_common *priv);
+
+/* SDD definitions */
+#define SDD_PTA_CFG_ELT_ID 0xEB
+#define SDD_REFERENCE_FREQUENCY_ELT_ID 0xc5
+u32 cw1200_dpll_from_clk(u16 clk);
+
+#endif
-- 
1.7.11.7

