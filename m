Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:40857 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3D0T1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 15:27:33 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 01/14] cw1200: v6: Low-level hardware I/O access
Date: Sat, 27 Apr 2013 15:27:14 -0400
Message-Id: <1367090847-11937-2-git-send-email-pizza@shaftnet.org> (sfid-20130427_212738_790731_527E8F97)
In-Reply-To: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
References: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/hwio.c | 311 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/hwio.h | 247 +++++++++++++++++++++++++++++
 2 files changed, 558 insertions(+)
 create mode 100644 drivers/net/wireless/cw1200/hwio.c
 create mode 100644 drivers/net/wireless/cw1200/hwio.h

diff --git a/drivers/net/wireless/cw1200/hwio.c b/drivers/net/wireless/cw1200/hwio.c
new file mode 100644
index 0000000..1af7b3d
--- /dev/null
+++ b/drivers/net/wireless/cw1200/hwio.c
@@ -0,0 +1,311 @@
+/*
+ * Low-level device IO routines for ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * Based on:
+ * ST-Ericsson UMAC CW1200 driver, which is
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Ajitpal Singh <ajitpal.singh@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+
+#include "cw1200.h"
+#include "hwio.h"
+#include "sbus.h"
+
+ /* Sdio addr is 4*spi_addr */
+#define SPI_REG_ADDR_TO_SDIO(spi_reg_addr) ((spi_reg_addr) << 2)
+#define SDIO_ADDR17BIT(buf_id, mpf, rfu, reg_id_ofs) \
+				((((buf_id)    & 0x1F) << 7) \
+				| (((mpf)        & 1) << 6) \
+				| (((rfu)        & 1) << 5) \
+				| (((reg_id_ofs) & 0x1F) << 0))
+#define MAX_RETRY		3
+
+
+static int __cw1200_reg_read(struct cw1200_common *priv, u16 addr,
+			     void *buf, size_t buf_len, int buf_id)
+{
+	u16 addr_sdio;
+	u32 sdio_reg_addr_17bit;
+
+	/* Check if buffer is aligned to 4 byte boundary */
+	if (WARN_ON(((unsigned long)buf & 3) && (buf_len > 4))) {
+		pr_err("buffer is not aligned.\n");
+		return -EINVAL;
+	}
+
+	/* Convert to SDIO Register Address */
+	addr_sdio = SPI_REG_ADDR_TO_SDIO(addr);
+	sdio_reg_addr_17bit = SDIO_ADDR17BIT(buf_id, 0, 0, addr_sdio);
+
+	return priv->sbus_ops->sbus_memcpy_fromio(priv->sbus_priv,
+						  sdio_reg_addr_17bit,
+						  buf, buf_len);
+}
+
+static int __cw1200_reg_write(struct cw1200_common *priv, u16 addr,
+				const void *buf, size_t buf_len, int buf_id)
+{
+	u16 addr_sdio;
+	u32 sdio_reg_addr_17bit;
+
+	/* Convert to SDIO Register Address */
+	addr_sdio = SPI_REG_ADDR_TO_SDIO(addr);
+	sdio_reg_addr_17bit = SDIO_ADDR17BIT(buf_id, 0, 0, addr_sdio);
+
+	return priv->sbus_ops->sbus_memcpy_toio(priv->sbus_priv,
+						sdio_reg_addr_17bit,
+						buf, buf_len);
+}
+
+static inline int __cw1200_reg_read_32(struct cw1200_common *priv,
+					u16 addr, u32 *val)
+{
+	int i = __cw1200_reg_read(priv, addr, val, sizeof(*val), 0);
+	*val = le32_to_cpu(*val);
+	return i;
+}
+
+static inline int __cw1200_reg_write_32(struct cw1200_common *priv,
+					u16 addr, u32 val)
+{
+	val = cpu_to_le32(val);
+	return __cw1200_reg_write(priv, addr, &val, sizeof(val), 0);
+}
+
+static inline int __cw1200_reg_read_16(struct cw1200_common *priv,
+					u16 addr, u16 *val)
+{
+	int i = __cw1200_reg_read(priv, addr, val, sizeof(*val), 0);
+	*val = le16_to_cpu(*val);
+	return i;
+}
+
+static inline int __cw1200_reg_write_16(struct cw1200_common *priv,
+					u16 addr, u16 val)
+{
+	val = cpu_to_le16(val);
+	return __cw1200_reg_write(priv, addr, &val, sizeof(val), 0);
+}
+
+int cw1200_reg_read(struct cw1200_common *priv, u16 addr, void *buf,
+			size_t buf_len)
+{
+	int ret;
+	priv->sbus_ops->lock(priv->sbus_priv);
+	ret = __cw1200_reg_read(priv, addr, buf, buf_len, 0);
+	priv->sbus_ops->unlock(priv->sbus_priv);
+	return ret;
+}
+
+int cw1200_reg_write(struct cw1200_common *priv, u16 addr, const void *buf,
+			size_t buf_len)
+{
+	int ret;
+	priv->sbus_ops->lock(priv->sbus_priv);
+	ret = __cw1200_reg_write(priv, addr, buf, buf_len, 0);
+	priv->sbus_ops->unlock(priv->sbus_priv);
+	return ret;
+}
+
+int cw1200_data_read(struct cw1200_common *priv, void *buf, size_t buf_len)
+{
+	int ret, retry = 1;
+	int buf_id_rx = priv->buf_id_rx;
+
+	priv->sbus_ops->lock(priv->sbus_priv);
+
+	while (retry <= MAX_RETRY) {
+		ret = __cw1200_reg_read(priv,
+					ST90TDS_IN_OUT_QUEUE_REG_ID, buf,
+					buf_len, buf_id_rx + 1);
+		if (!ret) {
+			buf_id_rx = (buf_id_rx + 1) & 3;
+			priv->buf_id_rx = buf_id_rx;
+			break;
+		} else {
+			retry++;
+			mdelay(1);
+			pr_err("error :[%d]\n", ret);
+		}
+	}
+
+	priv->sbus_ops->unlock(priv->sbus_priv);
+	return ret;
+}
+
+int cw1200_data_write(struct cw1200_common *priv, const void *buf,
+			size_t buf_len)
+{
+	int ret, retry = 1;
+	int buf_id_tx = priv->buf_id_tx;
+
+	priv->sbus_ops->lock(priv->sbus_priv);
+
+	while (retry <= MAX_RETRY) {
+		ret = __cw1200_reg_write(priv,
+					 ST90TDS_IN_OUT_QUEUE_REG_ID, buf,
+					 buf_len, buf_id_tx);
+		if (!ret) {
+			buf_id_tx = (buf_id_tx + 1) & 31;
+			priv->buf_id_tx = buf_id_tx;
+			break;
+		} else {
+			retry++;
+			mdelay(1);
+			pr_err("error :[%d]\n", ret);
+		}
+	}
+
+	priv->sbus_ops->unlock(priv->sbus_priv);
+	return ret;
+}
+
+int cw1200_indirect_read(struct cw1200_common *priv, u32 addr, void *buf,
+			 size_t buf_len, u32 prefetch, u16 port_addr)
+{
+	u32 val32 = 0;
+	int i, ret;
+
+	if ((buf_len / 2) >= 0x1000) {
+		pr_err("Can't read more than 0xfff words.\n");
+		return -EINVAL;
+		goto out;
+	}
+
+	priv->sbus_ops->lock(priv->sbus_priv);
+	/* Write address */
+	ret = __cw1200_reg_write_32(priv, ST90TDS_SRAM_BASE_ADDR_REG_ID, addr);
+	if (ret < 0) {
+		pr_err("Can't write address register.\n");
+		goto out;
+	}
+
+	/* Read CONFIG Register Value - We will read 32 bits */
+	ret = __cw1200_reg_read_32(priv, ST90TDS_CONFIG_REG_ID, &val32);
+	if (ret < 0) {
+		pr_err("Can't read config register.\n");
+		goto out;
+	}
+
+	/* Set PREFETCH bit */
+	ret = __cw1200_reg_write_32(priv, ST90TDS_CONFIG_REG_ID,
+					val32 | prefetch);
+	if (ret < 0) {
+		pr_err("Can't write prefetch bit.\n");
+		goto out;
+	}
+
+	/* Check for PRE-FETCH bit to be cleared */
+	for (i = 0; i < 20; i++) {
+		ret = __cw1200_reg_read_32(priv, ST90TDS_CONFIG_REG_ID, &val32);
+		if (ret < 0) {
+			pr_err("Can't check prefetch bit.\n");
+			goto out;
+		}
+		if (!(val32 & prefetch))
+			break;
+
+		mdelay(i);
+	}
+
+	if (val32 & prefetch) {
+		pr_err("Prefetch bit is not cleared.\n");
+		goto out;
+	}
+
+	/* Read data port */
+	ret = __cw1200_reg_read(priv, port_addr, buf, buf_len, 0);
+	if (ret < 0) {
+		pr_err("Can't read data port.\n");
+		goto out;
+	}
+
+out:
+	priv->sbus_ops->unlock(priv->sbus_priv);
+	return ret;
+}
+
+int cw1200_apb_write(struct cw1200_common *priv, u32 addr, const void *buf,
+			size_t buf_len)
+{
+	int ret;
+
+	if ((buf_len / 2) >= 0x1000) {
+		pr_err("Can't write more than 0xfff words.\n");
+		return -EINVAL;
+	}
+
+	priv->sbus_ops->lock(priv->sbus_priv);
+
+	/* Write address */
+	ret = __cw1200_reg_write_32(priv, ST90TDS_SRAM_BASE_ADDR_REG_ID, addr);
+	if (ret < 0) {
+		pr_err("Can't write address register.\n");
+		goto out;
+	}
+
+	/* Write data port */
+	ret = __cw1200_reg_write(priv, ST90TDS_SRAM_DPORT_REG_ID,
+					buf, buf_len, 0);
+	if (ret < 0) {
+		pr_err("Can't write data port.\n");
+		goto out;
+	}
+
+out:
+	priv->sbus_ops->unlock(priv->sbus_priv);
+	return ret;
+}
+
+int __cw1200_irq_enable(struct cw1200_common *priv, int enable)
+{
+	u32 val32;
+	u16 val16;
+	int ret;
+
+	if (HIF_8601_SILICON == priv->hw_type) {
+		ret = __cw1200_reg_read_32(priv, ST90TDS_CONFIG_REG_ID, &val32);
+		if (ret < 0) {
+			pr_err("Can't read config register.\n");
+			return ret;
+		}
+
+		if (enable)
+			val32 |= ST90TDS_CONF_IRQ_RDY_ENABLE;
+		else
+			val32 &= ~ST90TDS_CONF_IRQ_RDY_ENABLE;
+
+		ret = __cw1200_reg_write_32(priv, ST90TDS_CONFIG_REG_ID, val32);
+		if (ret < 0) {
+			pr_err("Can't write config register.\n");
+			return ret;
+		}
+	} else {
+		ret = __cw1200_reg_read_16(priv, ST90TDS_CONFIG_REG_ID, &val16);
+		if (ret < 0) {
+			pr_err("Can't read control register.\n");
+			return ret;
+		}
+
+		if (enable)
+			val16 |= ST90TDS_CONT_IRQ_RDY_ENABLE;
+		else
+			val16 &= ~ST90TDS_CONT_IRQ_RDY_ENABLE;
+
+		ret = __cw1200_reg_write_16(priv, ST90TDS_CONFIG_REG_ID, val16);
+		if (ret < 0) {
+			pr_err("Can't write control register.\n");
+			return ret;
+		}
+	}
+	return 0;
+}
diff --git a/drivers/net/wireless/cw1200/hwio.h b/drivers/net/wireless/cw1200/hwio.h
new file mode 100644
index 0000000..7ee73fe
--- /dev/null
+++ b/drivers/net/wireless/cw1200/hwio.h
@@ -0,0 +1,247 @@
+/*
+ * Low-level API for mac80211 ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
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
+#ifndef CW1200_HWIO_H_INCLUDED
+#define CW1200_HWIO_H_INCLUDED
+
+/* extern */ struct cw1200_common;
+
+#define CW1200_CUT_11_ID_STR		(0x302E3830)
+#define CW1200_CUT_22_ID_STR1		(0x302e3132)
+#define CW1200_CUT_22_ID_STR2		(0x32302e30)
+#define CW1200_CUT_22_ID_STR3		(0x3335)
+#define CW1200_CUT_ID_ADDR		(0xFFF17F90)
+#define CW1200_CUT2_ID_ADDR		(0xFFF1FF90)
+
+/* Download control area */
+/* boot loader start address in SRAM */
+#define DOWNLOAD_BOOT_LOADER_OFFSET	(0x00000000)
+/* 32K, 0x4000 to 0xDFFF */
+#define DOWNLOAD_FIFO_OFFSET		(0x00004000)
+/* 32K */
+#define DOWNLOAD_FIFO_SIZE		(0x00008000)
+/* 128 bytes, 0xFF80 to 0xFFFF */
+#define DOWNLOAD_CTRL_OFFSET		(0x0000FF80)
+#define DOWNLOAD_CTRL_DATA_DWORDS	(32-6)
+
+struct download_cntl_t {
+	/* size of whole firmware file (including Cheksum), host init */
+	u32 image_size;
+	/* downloading flags */
+	u32 flags;
+	/* No. of bytes put into the download, init & updated by host */
+	u32 put;
+	/* last traced program counter, last ARM reg_pc */
+	u32 trace_pc;
+	/* No. of bytes read from the download, host init, device updates */
+	u32 get;
+	/* r0, boot losader status, host init to pending, device updates */
+	u32 status;
+	/* Extra debug info, r1 to r14 if status=r0=DOWNLOAD_EXCEPTION */
+	u32 debug_data[DOWNLOAD_CTRL_DATA_DWORDS];
+};
+
+#define	DOWNLOAD_IMAGE_SIZE_REG		\
+	(DOWNLOAD_CTRL_OFFSET + offsetof(struct download_cntl_t, image_size))
+#define	DOWNLOAD_FLAGS_REG		\
+	(DOWNLOAD_CTRL_OFFSET + offsetof(struct download_cntl_t, flags))
+#define DOWNLOAD_PUT_REG		\
+	(DOWNLOAD_CTRL_OFFSET + offsetof(struct download_cntl_t, put))
+#define DOWNLOAD_TRACE_PC_REG		\
+	(DOWNLOAD_CTRL_OFFSET + offsetof(struct download_cntl_t, trace_pc))
+#define	DOWNLOAD_GET_REG		\
+	(DOWNLOAD_CTRL_OFFSET + offsetof(struct download_cntl_t, get))
+#define	DOWNLOAD_STATUS_REG		\
+	(DOWNLOAD_CTRL_OFFSET + offsetof(struct download_cntl_t, status))
+#define DOWNLOAD_DEBUG_DATA_REG		\
+	(DOWNLOAD_CTRL_OFFSET + offsetof(struct download_cntl_t, debug_data))
+#define DOWNLOAD_DEBUG_DATA_LEN		(108)
+
+#define DOWNLOAD_BLOCK_SIZE		(1024)
+
+/* For boot loader detection */
+#define DOWNLOAD_ARE_YOU_HERE		(0x87654321)
+#define DOWNLOAD_I_AM_HERE		(0x12345678)
+
+/* Download error code */
+#define DOWNLOAD_PENDING		(0xFFFFFFFF)
+#define DOWNLOAD_SUCCESS		(0)
+#define DOWNLOAD_EXCEPTION		(1)
+#define DOWNLOAD_ERR_MEM_1		(2)
+#define DOWNLOAD_ERR_MEM_2		(3)
+#define DOWNLOAD_ERR_SOFTWARE		(4)
+#define DOWNLOAD_ERR_FILE_SIZE		(5)
+#define DOWNLOAD_ERR_CHECKSUM		(6)
+#define DOWNLOAD_ERR_OVERFLOW		(7)
+#define DOWNLOAD_ERR_IMAGE		(8)
+#define DOWNLOAD_ERR_HOST		(9)
+#define DOWNLOAD_ERR_ABORT		(10)
+
+
+#define SYS_BASE_ADDR_SILICON		(0)
+#define PAC_BASE_ADDRESS_SILICON	(SYS_BASE_ADDR_SILICON + 0x09000000)
+#define PAC_SHARED_MEMORY_SILICON	(PAC_BASE_ADDRESS_SILICON)
+
+#define CW1200_APB(addr)		(PAC_SHARED_MEMORY_SILICON + (addr))
+
+/* ***************************************************************
+*Device register definitions
+*************************************************************** */
+/* WBF - SPI Register Addresses */
+#define ST90TDS_ADDR_ID_BASE		(0x0000)
+/* 16/32 bits */
+#define ST90TDS_CONFIG_REG_ID		(0x0000)
+/* 16/32 bits */
+#define ST90TDS_CONTROL_REG_ID		(0x0001)
+/* 16 bits, Q mode W/R */
+#define ST90TDS_IN_OUT_QUEUE_REG_ID	(0x0002)
+/* 32 bits, AHB bus R/W */
+#define ST90TDS_AHB_DPORT_REG_ID	(0x0003)
+/* 16/32 bits */
+#define ST90TDS_SRAM_BASE_ADDR_REG_ID   (0x0004)
+/* 32 bits, APB bus R/W */
+#define ST90TDS_SRAM_DPORT_REG_ID	(0x0005)
+/* 32 bits, t_settle/general */
+#define ST90TDS_TSET_GEN_R_W_REG_ID	(0x0006)
+/* 16 bits, Q mode read, no length */
+#define ST90TDS_FRAME_OUT_REG_ID	(0x0007)
+#define ST90TDS_ADDR_ID_MAX		(ST90TDS_FRAME_OUT_REG_ID)
+
+/* WBF - Control register bit set */
+/* next o/p length, bit 11 to 0 */
+#define ST90TDS_CONT_NEXT_LEN_MASK	(0x0FFF)
+#define ST90TDS_CONT_WUP_BIT		(BIT(12))
+#define ST90TDS_CONT_RDY_BIT		(BIT(13))
+#define ST90TDS_CONT_IRQ_ENABLE		(BIT(14))
+#define ST90TDS_CONT_RDY_ENABLE		(BIT(15))
+#define ST90TDS_CONT_IRQ_RDY_ENABLE	(BIT(14)|BIT(15))
+
+/* SPI Config register bit set */
+#define ST90TDS_CONFIG_FRAME_BIT	(BIT(2))
+#define ST90TDS_CONFIG_WORD_MODE_BITS	(BIT(3)|BIT(4))
+#define ST90TDS_CONFIG_WORD_MODE_1	(BIT(3))
+#define ST90TDS_CONFIG_WORD_MODE_2	(BIT(4))
+#define ST90TDS_CONFIG_ERROR_0_BIT	(BIT(5))
+#define ST90TDS_CONFIG_ERROR_1_BIT	(BIT(6))
+#define ST90TDS_CONFIG_ERROR_2_BIT	(BIT(7))
+/* TBD: Sure??? */
+#define ST90TDS_CONFIG_CSN_FRAME_BIT	(BIT(7))
+#define ST90TDS_CONFIG_ERROR_3_BIT	(BIT(8))
+#define ST90TDS_CONFIG_ERROR_4_BIT	(BIT(9))
+/* QueueM */
+#define ST90TDS_CONFIG_ACCESS_MODE_BIT	(BIT(10))
+/* AHB bus */
+#define ST90TDS_CONFIG_AHB_PRFETCH_BIT	(BIT(11))
+#define ST90TDS_CONFIG_CPU_CLK_DIS_BIT	(BIT(12))
+/* APB bus */
+#define ST90TDS_CONFIG_PRFETCH_BIT	(BIT(13))
+/* cpu reset */
+#define ST90TDS_CONFIG_CPU_RESET_BIT	(BIT(14))
+#define ST90TDS_CONFIG_CLEAR_INT_BIT	(BIT(15))
+
+/* For CW1200 the IRQ Enable and Ready Bits are in CONFIG register */
+#define ST90TDS_CONF_IRQ_ENABLE		(BIT(16))
+#define ST90TDS_CONF_RDY_ENABLE		(BIT(17))
+#define ST90TDS_CONF_IRQ_RDY_ENABLE	(BIT(16)|BIT(17))
+
+int cw1200_data_read(struct cw1200_common *priv,
+		     void *buf, size_t buf_len);
+int cw1200_data_write(struct cw1200_common *priv,
+		      const void *buf, size_t buf_len);
+
+int cw1200_reg_read(struct cw1200_common *priv, u16 addr,
+		    void *buf, size_t buf_len);
+int cw1200_reg_write(struct cw1200_common *priv, u16 addr,
+		     const void *buf, size_t buf_len);
+
+static inline int cw1200_reg_read_16(struct cw1200_common *priv,
+				     u16 addr, u16 *val)
+{
+	u32 tmp;
+	int i;
+	i = cw1200_reg_read(priv, addr, &tmp, sizeof(tmp));
+	tmp = le32_to_cpu(tmp);
+	*val = tmp & 0xffff;
+	return i;
+}
+
+static inline int cw1200_reg_write_16(struct cw1200_common *priv,
+				      u16 addr, u16 val)
+{
+	u32 tmp = val;
+	tmp = cpu_to_le32(tmp);
+	return cw1200_reg_write(priv, addr, &tmp, sizeof(tmp));
+}
+
+static inline int cw1200_reg_read_32(struct cw1200_common *priv,
+				     u16 addr, u32 *val)
+{
+	int i = cw1200_reg_read(priv, addr, val, sizeof(*val));
+	*val = le32_to_cpu(*val);
+	return i;
+}
+
+static inline int cw1200_reg_write_32(struct cw1200_common *priv,
+				      u16 addr, u32 val)
+{
+	val = cpu_to_le32(val);
+	return cw1200_reg_write(priv, addr, &val, sizeof(val));
+}
+
+int cw1200_indirect_read(struct cw1200_common *priv, u32 addr, void *buf,
+			 size_t buf_len, u32 prefetch, u16 port_addr);
+int cw1200_apb_write(struct cw1200_common *priv, u32 addr, const void *buf,
+		     size_t buf_len);
+
+static inline int cw1200_apb_read(struct cw1200_common *priv, u32 addr,
+				  void *buf, size_t buf_len)
+{
+	return cw1200_indirect_read(priv, addr, buf, buf_len,
+				    ST90TDS_CONFIG_PRFETCH_BIT,
+				    ST90TDS_SRAM_DPORT_REG_ID);
+}
+
+static inline int cw1200_ahb_read(struct cw1200_common *priv, u32 addr,
+				  void *buf, size_t buf_len)
+{
+	return cw1200_indirect_read(priv, addr, buf, buf_len,
+				    ST90TDS_CONFIG_AHB_PRFETCH_BIT,
+				    ST90TDS_AHB_DPORT_REG_ID);
+}
+
+static inline int cw1200_apb_read_32(struct cw1200_common *priv,
+				     u32 addr, u32 *val)
+{
+	int i = cw1200_apb_read(priv, addr, val, sizeof(*val));
+	*val = le32_to_cpu(*val);
+	return i;
+}
+
+static inline int cw1200_apb_write_32(struct cw1200_common *priv,
+				      u32 addr, u32 val)
+{
+	val = cpu_to_le32(val);
+	return cw1200_apb_write(priv, addr, &val, sizeof(val));
+}
+static inline int cw1200_ahb_read_32(struct cw1200_common *priv,
+				     u32 addr, u32 *val)
+{
+	int i = cw1200_ahb_read(priv, addr, val, sizeof(*val));
+	*val = le32_to_cpu(*val);
+	return i;
+}
+
+#endif /* CW1200_HWIO_H_INCLUDED */
-- 
1.8.1.4

