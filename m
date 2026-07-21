Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDF6353A96
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784629366; cv=none; b=rkD8cq92rCW/JLYo2VGJF6rht1WVXyHnjHAmISPBoDXfXTpsqo5+MAc1MYKuObHtpKKpwWDJcgM+ZE0pMi6tgZRiyK1eITAqXY5rqwO8jzRAfNyjONWnz7Zj8Tnb0RizN18EkZPs/enCDQozcGZj75yD5Cyj5ecEeOv6W67iH/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784629366; c=relaxed/simple;
	bh=u9qn4jsf1g5DwQFm8jCDUH1C8s1b2srGwCKPeLhZ37U=;
	h=References:Date:Message-Id:In-Reply-To:From:Subject:Content-Type:
	 To:Cc:Mime-Version; b=IsGs3irtjDp7Jeak2bRgsLppyvlLE5ZAMefGdpnotkT/Mzc7utpmuhV4Myr3w2smMSxTLmcKYc59mYiyrei4HRdq6MbiV55RAV9AkzbvOspnIyTZbs7HLLhSdu9wJuL9xJkKiF+5CrHbbGJAWEoQDvfApQiX4sOzd+PFJ8h3Hxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com; spf=none smtp.mailfrom=bedmex.com; dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b=ZwUaZ/LX; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bedmex.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bedmex.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bedmex-com.20200927.dkim.feishu.cn header.i=@bedmex-com.20200927.dkim.feishu.cn header.b="ZwUaZ/LX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=bedmex-com.20200927.dkim.feishu.cn; t=1784629333;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=oX6QD9YKdIRxJBlS1whGuSAqfPvksRk0Z0wQpixvmSM=;
 b=ZwUaZ/LXZHSU1BhCEx3zrkY30B9PeIOK+vMus6InbIb1gKH3gReuqhgNGt3KsUEJwo43qF
 Tlntno/vhlQJN3Jcp8O26R+/JfeZZXJTudugdixQPePTVWdYoZnppanO9UNlV2fVxc8+Qq
 hRGSg6xhs+YEnrIATnaZfjZ44NSoIBWBoU/a4tl5arZOrxk9Z2Wx4AMLjvawJ5dY/iU1My
 HrVe7vNTdh03IoJKN6d5m6AfKX6pxM8WCgMEX5UH/fY2qSpIEzTABLS3T/QGoLRbvV6fBt
 Wh/p27/hZdeRakIMyDC2awwZtgeFq9h5T7aWFJPaqbmFjvVarl/Nyoj/ivalZg==
Content-Transfer-Encoding: quoted-printable
References: <cover.1784544076.git.yanli.yang@bedmex.com>
Received: from bmxpxe-virtual-desktop.. ([36.141.79.164]) by smtp.feishu.cn with ESMTPS; Tue, 21 Jul 2026 18:22:09 +0800
X-Mailer: git-send-email 2.34.1
Date: Tue, 21 Jul 2026 18:21:01 +0800
Message-Id: <691fde347c31fb3bcde9ec08536ba00dac4b78e8.1784544076.git.yanli.yang@bedmex.com>
In-Reply-To: <cover.1784544076.git.yanli.yang@bedmex.com>
X-Original-From: Yanli Yang <yanli.yang@bedmex.com>
From: "Yanli Yang" <yanli.yang@bedmex.com>
Subject: [RFC PATCH wireless-next 2/4] wifi: aic: add FullMAC firmware and platform interface
X-Lms-Return-Path: <lba+26a5f4852+48cd0b+vger.kernel.org+yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
To: <linux-wireless@vger.kernel.org>
Cc: "Johannes Berg" <johannes@sipsolutions.net>, 
	"Zhirun Liu" <zhirunliu@aicsemi.com>, <dijiaxu@aicsemi.com>, 
	<chunqiuliu@aicsemi.com>, <liheng.wei@bedmex.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

From: Zhirun Liu <zhirunliu@aicsemi.com>

Add the FullMAC IPC and LMAC protocol definitions, command
serialization, firmware request and confirmation handling, platform
bring-up, interrupt helpers and BSP integration.

Signed-off-by: Zhirun Liu <zhirunliu@aicsemi.com>
Signed-off-by: Yanli Yang <yanli.yang@bedmex.com>
---
 .../aic/aic8800_fdrv/aic_bsp_export.h         |   62 +
 .../net/wireless/aic/aic8800_fdrv/aic_bus.h   |  191 +
 .../wireless/aic/aic8800_fdrv/aicwf_debug.h   |   37 +
 .../net/wireless/aic/aic8800_fdrv/hal_desc.h  |  362 ++
 .../wireless/aic/aic8800_fdrv/ipc_compat.h    |   25 +
 .../net/wireless/aic/aic8800_fdrv/ipc_host.c  |   42 +
 .../net/wireless/aic/aic8800_fdrv/ipc_host.h  |  169 +
 .../wireless/aic/aic8800_fdrv/ipc_shared.h    |  781 ++++
 .../net/wireless/aic/aic8800_fdrv/lmac_mac.h  |  470 ++
 .../net/wireless/aic/aic8800_fdrv/lmac_msg.h  | 3124 ++++++++++++++
 .../wireless/aic/aic8800_fdrv/lmac_types.h    |   37 +
 drivers/net/wireless/aic/aic8800_fdrv/md5.c   |  175 +
 drivers/net/wireless/aic/aic8800_fdrv/md5.h   |   82 +
 .../wireless/aic/aic8800_fdrv/reg_access.h    |  146 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_cmds.c |  471 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_cmds.h |   99 +
 .../wireless/aic/aic8800_fdrv/rwnx_compat.h   |   93 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_defs.h |  744 ++++
 .../wireless/aic/aic8800_fdrv/rwnx_events.h   |  938 ++++
 .../net/wireless/aic/aic8800_fdrv/rwnx_irqs.c |   44 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_irqs.h |   12 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.c   | 1742 ++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_msg_rx.h   |    8 +
 .../wireless/aic/aic8800_fdrv/rwnx_msg_tx.c   | 3815 +++++++++++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_msg_tx.h   |  285 ++
 .../wireless/aic/aic8800_fdrv/rwnx_platform.c | 2946 +++++++++++++
 .../wireless/aic/aic8800_fdrv/rwnx_platform.h |  186 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_prof.h |  142 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_strs.c |  268 ++
 .../net/wireless/aic/aic8800_fdrv/rwnx_strs.h |   31 +
 .../wireless/aic/aic8800_fdrv/rwnx_utils.c    |   36 +
 .../wireless/aic/aic8800_fdrv/rwnx_utils.h    |  131 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.c   |  182 +
 .../net/wireless/aic/aic8800_fdrv/rwnx_v7.h   |   21 +
 .../wireless/aic/aic8800_fdrv/rwnx_version.h  |   14 +
 .../aic/aic8800_fdrv/rwnx_version_gen.h       |    5 +
 .../wireless/aic/aic8800_fdrv/rwnx_wakelock.c |  109 +
 .../wireless/aic/aic8800_fdrv/rwnx_wakelock.h |   24 +
 38 files changed, 18049 insertions(+)
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_bsp_export.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aic_bus.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/aicwf_debug.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/hal_desc.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_host.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_host.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/ipc_shared.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_mac.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_msg.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/lmac_types.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/md5.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/md5.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/reg_access.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_defs.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_events.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_irqs.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_irqs.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_platform.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_platform.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_prof.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_strs.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_strs.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_utils.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_utils.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_v7.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_v7.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_version.h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_version_gen.=
h
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.c
 create mode 100644 drivers/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.h

diff --git a/drivers/net/wireless/aic/aic8800_fdrv/aic_bsp_export.h b/drive=
rs/net/wireless/aic/aic8800_fdrv/aic_bsp_export.h
new file mode 100644
index 0000000000000..11b414df42ce3
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/aic_bsp_export.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __AIC_BSP_EXPORT_H
+#define __AIC_BSP_EXPORT_H
+
+#include <linux/types.h>
+
+enum aicbsp_subsys {
+	AIC_BLUETOOTH,
+	AIC_WIFI,
+};
+
+enum aicbsp_pwr_state {
+	AIC_PWR_OFF,
+	AIC_PWR_ON,
+};
+
+struct aicbsp_feature_t {
+	int hwinfo;
+	u32 sdio_clock;
+	u8 sdio_phase;
+	int fwlog_en;
+	u8 irqf;
+	u8 cpmode;
+	int adapt;
+};
+
+enum skb_buff_id {
+	AIC_RESV_MEM_TXDATA,
+};
+
+#ifdef CONFIG_DPD
+struct rf_misc_ram_t {
+	u32 bit_mask[3];
+	u32 reserved;
+	u32 dpd_high[96];
+	u32 dpd_11b[96];
+	u32 dpd_low[96];
+	u32 idac_11b[48];
+	u32 idac_high[48];
+	u32 idac_low[48];
+	u32 loft_res[18];
+	u32 rx_iqim_res[16];
+};
+
+struct rf_misc_ram_lite_t {
+	u32 bit_mask[4];
+	u32 dpd_high[96];
+	u32 loft_res[18];
+};
+
+#define MEMBER_SIZE(type, member) sizeof_field(type, member)
+#define DPD_RESULT_SIZE_8800DC    sizeof(struct rf_misc_ram_lite_t)
+
+extern struct rf_misc_ram_lite_t dpd_res;
+#endif
+
+int aicbsp_set_subsys(int, int);
+int aicbsp_get_feature(struct aicbsp_feature_t *feature);
+struct sk_buff *aicbsp_resv_mem_alloc_skb(unsigned int length, uint32_t id=
);
+void aicbsp_resv_mem_kfree_skb(struct sk_buff *skb, uint32_t id);
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/aic_bus.h b/drivers/net/=
wireless/aic/aic8800_fdrv/aic_bus.h
new file mode 100644
index 0000000000000..2498d3d592b42
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/aic_bus.h
@@ -0,0 +1,191 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 AIC semiconductor.
+ *
+ * @file aic_bus.h
+ * @brief Common bus abstraction layer for AIC8800 series.
+ *
+ * This header defines the bus-level operations that abstract the
+ * underlying transport (SDIO, USB, etc.) from the upper driver layers.
+ * The design follows the pattern used by silabs/wfx and broadcom/b43.
+ *
+ * Key principles:
+ *  - struct aicwf_bus_ops provides a complete set of low-level bus
+ *    primitives (read/write registers, send/recv packets, flow control,
+ *    power management, interrupt handling).
+ *  - Upper-layer code accesses the bus only through the ops table and
+ *    inline wrappers defined here.  It MUST NOT dereference the
+ *    bus-private structure (aic_sdio_dev etc.) directly.
+ *  - When a new transport (e.g. USB) is added, only the bus_ops
+ *    implementation needs to change; upper layers are unaffected.
+ */
+
+#ifndef _AIC_BUS_H_
+#define _AIC_BUS_H_
+
+#include <linux/device.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
+/* Bus operational state */
+enum aicwf_bus_state { BUS_DOWN_ST, BUS_UP_ST };
+
+struct aicwf_bus {
+	union {
+		struct aic_sdio_dev *sdio;
+		struct aic_usb_dev *usb;
+	} bus_priv;
+	struct device *dev;
+	struct aicwf_bus_ops *ops;
+	enum aicwf_bus_state state;
+	u8 *cmd_buf;
+	struct completion bustx_trgg;
+	struct completion busrx_trgg;
+	struct completion busirq_trgg; // new oob feature
+	struct task_struct *bustx_thread;
+	struct task_struct *busrx_thread;
+	struct task_struct *busirq_thread; // new oob feature
+};
+
+/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *  Bus-level operation vectors
+ *
+ *  Every transport (SDIO, USB, ...) provides one instance of this
+ *  struct.  The bus-private data pointer is carried inside
+ *  struct aicwf_bus so that ops callbacks can retrieve it via
+ *  bus->bus_priv.
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ */
+
+struct aicwf_bus_ops {
+	/* ----- Lifecycle ----- */
+	int  (*start)(struct device *dev);
+	void (*stop)(struct device *dev);
+
+	/* ----- Data / message transmission ----- */
+	int (*txdata)(struct device *dev, struct sk_buff *skb);
+	int (*txmsg)(struct device *dev, u8 *msg, uint len);
+
+	/* ----- Low-level register access -----
+	 * These replace the direct aicwf_sdio_readb/writeb calls.
+	 */
+	int (*read_reg)(struct device *dev, u32 regaddr, u8 *val);
+	int (*write_reg)(struct device *dev, u32 regaddr, u8 val);
+
+	/* ----- Bulk data transfer -----
+	 * send_pkt  =E2=80=93 write a buffer to the chip's TX FIFO
+	 * recv_pkt  =E2=80=93 read  a buffer from the chip's RX FIFO
+	 */
+	int (*send_pkt)(struct device *dev, u8 *buf, uint count);
+	int (*recv_pkt)(struct device *dev, u8 *buf, u32 size);
+
+	/* ----- Interrupt handling ----- */
+	int  (*enable_irq)(struct device *dev);
+	void (*disable_irq)(struct device *dev);
+
+	/* ----- Flow control -----
+	 * Returns true if the device is ready to accept more data.
+	 */
+	bool (*flow_ctrl)(struct device *dev);
+
+	/* ----- Power management ----- */
+	int (*sleep_allow)(struct device *dev);
+	int (*wakeup)(struct device *dev);
+
+	/* ----- Chip-specific hardware info -----
+	 * Returns a pointer to chip hardware properties (SDIO register
+	 * layout, feature flags, etc.).  The caller treats this as
+	 * opaque; only the bus layer interprets it.
+	 */
+	const void *(*get_hw_props)(struct device *dev);
+};
+
+/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *  Inline wrappers =E2=80=93 upper layers call these instead of touching
+ *  bus_priv internals.
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ */
+
+static inline int aicwf_bus_start(struct aicwf_bus *bus)
+{
+	return bus->ops->start(bus->dev);
+}
+
+static inline void aicwf_bus_stop(struct aicwf_bus *bus)
+{
+	bus->ops->stop(bus->dev);
+}
+
+static inline int aicwf_bus_txdata(struct aicwf_bus *bus, struct sk_buff *=
skb)
+{
+	return bus->ops->txdata(bus->dev, skb);
+}
+
+static inline int aicwf_bus_txmsg(struct aicwf_bus *bus, u8 *msg, uint len=
)
+{
+	return bus->ops->txmsg(bus->dev, msg, len);
+}
+
+static inline int aicwf_bus_read_reg(struct aicwf_bus *bus,
+				     u32 regaddr, u8 *val)
+{
+	return bus->ops->read_reg(bus->dev, regaddr, val);
+}
+
+static inline int aicwf_bus_write_reg(struct aicwf_bus *bus,
+				      u32 regaddr, u8 val)
+{
+	return bus->ops->write_reg(bus->dev, regaddr, val);
+}
+
+static inline int aicwf_bus_send_pkt(struct aicwf_bus *bus,
+				     u8 *buf, uint count)
+{
+	return bus->ops->send_pkt(bus->dev, buf, count);
+}
+
+static inline int aicwf_bus_recv_pkt(struct aicwf_bus *bus,
+				     u8 *buf, u32 size)
+{
+	return bus->ops->recv_pkt(bus->dev, buf, size);
+}
+
+static inline int aicwf_bus_enable_irq(struct aicwf_bus *bus)
+{
+	return bus->ops->enable_irq(bus->dev);
+}
+
+static inline void aicwf_bus_disable_irq(struct aicwf_bus *bus)
+{
+	bus->ops->disable_irq(bus->dev);
+}
+
+static inline bool aicwf_bus_flow_ctrl(struct aicwf_bus *bus)
+{
+	return bus->ops->flow_ctrl(bus->dev);
+}
+
+static inline int aicwf_bus_sleep_allow(struct aicwf_bus *bus)
+{
+	return bus->ops->sleep_allow(bus->dev);
+}
+
+static inline int aicwf_bus_wakeup(struct aicwf_bus *bus)
+{
+	return bus->ops->wakeup(bus->dev);
+}
+
+static inline const void *aicwf_bus_get_hw_props(struct aicwf_bus *bus)
+{
+	return bus->ops->get_hw_props(bus->dev);
+}
+
+/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ *  Bus-level init / deinit (shared across transports)
+ * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ */
+
+int aicwf_bus_init(uint bus_hdrlen, struct device *dev);
+void aicwf_bus_deinit(struct device *dev);
+
+#endif /* _AIC_BUS_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/aicwf_debug.h b/drivers/=
net/wireless/aic/aic8800_fdrv/aicwf_debug.h
new file mode 100644
index 0000000000000..4a49c16f15a31
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/aicwf_debug.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _AICWF_DEBUG_H_
+#define _AICWF_DEBUG_H_
+
+#define RWNX_FN_ENTRY_STR ">>> %s()\n", __func__
+
+/* message levels */
+#define LOGERROR    0x0001
+#define LOGINFO     0x0002
+#define LOGTRACE    0x0004
+#define LOGDEBUG    0x0008
+#define LOGDATA     0x0010
+#define LOGIRQ      0x0020
+#define LOGSDPWRC   0x0040
+#define LOGWAKELOCK 0x0080
+#define LOGRXPOLL   0x0100
+
+extern int aicwf_dbg_level;
+void rwnx_data_dump(char *tag, void *data, unsigned long len);
+
+#define AICWF_LOG "AICWFDBG("
+
+#define AICWFDBG(level, args, arg...)                                     =
     \
+	do {                                                                     =
  \
+		if (aicwf_dbg_level & (level)) {                                        =
 \
+			pr_debug(AICWF_LOG #level ")\t" args, ##arg);                        \
+		}                                                                      \
+	} while (0)
+
+#define RWNX_DBG(fmt, ...)                                                =
     \
+	do {                                                                     =
  \
+		if (aicwf_dbg_level & LOGTRACE) {                                      \
+			pr_debug(AICWF_LOG "LOGTRACE)\t" fmt, ##__VA_ARGS__);                \
+		}                                                                      \
+	} while (0)
+
+#endif /* _AICWF_DEBUG_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/hal_desc.h b/drivers/net=
/wireless/aic/aic8800_fdrv/hal_desc.h
new file mode 100644
index 0000000000000..95cba70c2a7ab
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/hal_desc.h
@@ -0,0 +1,362 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file hal_desc.c
+ *
+ * @brief File containing the definition of HW descriptors
+ *
+ *************************************************************************=
*****
+ */
+
+#ifndef _HAL_DESC_H_
+#define _HAL_DESC_H_
+
+#include "lmac_types.h"
+#include "rwnx_compat.h"
+
+/* Rate and policy table */
+
+#define N_CCK   8
+#define N_OFDM  8
+#define N_HT    (8 * 2 * 2 * 4)
+#define N_VHT   (10 * 4 * 2 * 8)
+#define N_HE_SU (12 * 4 * 3 * 8)
+#define N_HE_MU (12 * 6 * 3 * 8)
+#define N_HE_ER (3 * 3 + 3) // RU242 + RU106
+
+/* conversion table from NL80211 to MACHW enum */
+extern const int chnl2bw[];
+
+/* conversion table from MACHW to NL80211 enum */
+extern const int bw2chnl[];
+
+/* Values for formatModTx */
+#define FORMATMOD_NON_HT          0
+#define FORMATMOD_NON_HT_DUP_OFDM 1
+#define FORMATMOD_HT_MF           2
+#define FORMATMOD_HT_GF           3
+#define FORMATMOD_VHT             4
+#define FORMATMOD_HE_SU           5
+#define FORMATMOD_HE_MU           6
+#define FORMATMOD_HE_ER           7
+#define FORMATMOD_HE_TB           8
+
+/* Values for navProtFrmEx */
+#define NAV_PROT_NO_PROT_BIT          0
+#define NAV_PROT_SELF_CTS_BIT         1
+#define NAV_PROT_RTS_CTS_BIT          2
+#define NAV_PROT_RTS_CTS_WITH_QAP_BIT 3
+#define NAV_PROT_STBC_BIT             4
+
+/* THD MACCTRLINFO2 fields, used in  struct umacdesc umac.flags */
+/// WhichDescriptor definition - contains aMPDU bit and position value
+/// Offset of WhichDescriptor field in the MAC CONTROL INFO 2 word
+#define WHICHDESC_OFT                   19
+/// Mask of the WhichDescriptor field
+#define WHICHDESC_MSK                   (0x07 << WHICHDESC_OFT)
+/// Only 1 THD possible, describing an unfragmented MSDU
+#define WHICHDESC_UNFRAGMENTED_MSDU     (0x00 << WHICHDESC_OFT)
+/// THD describing the first MPDU of a fragmented MSDU
+#define WHICHDESC_FRAGMENTED_MSDU_FIRST (0x01 << WHICHDESC_OFT)
+/// THD describing intermediate MPDUs of a fragmented MSDU
+#define WHICHDESC_FRAGMENTED_MSDU_INT   (0x02 << WHICHDESC_OFT)
+/// THD describing the last MPDU of a fragmented MSDU
+#define WHICHDESC_FRAGMENTED_MSDU_LAST  (0x03 << WHICHDESC_OFT)
+/// THD for extra descriptor starting an AMPDU
+#define WHICHDESC_AMPDU_EXTRA           (0x04 << WHICHDESC_OFT)
+/// THD describing the first MPDU of an A-MPDU
+#define WHICHDESC_AMPDU_FIRST           (0x05 << WHICHDESC_OFT)
+/// THD describing intermediate MPDUs of an A-MPDU
+#define WHICHDESC_AMPDU_INT             (0x06 << WHICHDESC_OFT)
+/// THD describing the last MPDU of an A-MPDU
+#define WHICHDESC_AMPDU_LAST            (0x07 << WHICHDESC_OFT)
+
+/// aMPDU bit offset
+#define AMPDU_OFT 21
+/// aMPDU bit
+#define AMPDU_BIT CO_BIT(AMPDU_OFT)
+
+union rwnx_mcs_index {
+	struct {
+		u32 mcs : 3;
+		u32 nss : 2;
+	} ht;
+	struct {
+		u32 mcs : 4;
+		u32 nss : 3;
+	} vht;
+	struct {
+		u32 mcs : 4;
+		u32 nss : 3;
+	} he;
+	u32 legacy : 7;
+};
+
+/* c.f RW-WLAN-nX-MAC-HW-UM */
+union rwnx_rate_ctrl_info {
+	struct {
+		u32 mcs_index_tx : 7;
+		u32 bw_tx : 2;
+		u32 gi_and_pre_type_tx : 2;
+		u32 format_mod_tx : 3;
+		u32 nav_prot_frm_ex : 3;
+		u32 mcs_index_prot_tx : 7;
+		u32 bw_prot_tx : 2;
+		u32 format_mod_prot_tx : 3;
+		u32 n_retry : 3;
+	};
+	u32 value;
+};
+
+/* c.f RW-WLAN-nX-MAC-HW-UM */
+struct rwnx_power_ctrl_info {
+	u32 tx_pwr_level_pt : 8;
+	u32 tx_pwr_level_prot_pt : 8;
+	u32 reserved : 16;
+};
+
+/* c.f RW-WLAN-nX-MAC-HW-UM */
+union rwnx_pol_phy_ctrl_info_1 {
+	struct {
+		u32 rsvd1 : 3;
+		u32 bf_frm_ex : 1;
+		u32 num_extn_ss : 2;
+		u32 fec_coding : 1;
+		u32 stbc : 2;
+		u32 rsvd2 : 5;
+		u32 n_tx : 3;
+		u32 n_tx_prot : 3;
+	};
+	u32 value;
+};
+
+/* c.f RW-WLAN-nX-MAC-HW-UM */
+union rwnx_pol_phy_ctrl_info_2 {
+	struct {
+		u32 antenna_set : 8;
+		u32 smm_index : 8;
+		u32 beam_formed : 1;
+	};
+	u32 value;
+};
+
+/* c.f RW-WLAN-nX-MAC-HW-UM */
+union rwnx_pol_mac_ctrl_info_1 {
+	struct {
+		u32 key_sram_index : 10;
+		u32 key_sram_index_ra : 10;
+	};
+	u32 value;
+};
+
+/* c.f RW-WLAN-nX-MAC-HW-UM */
+union rwnx_pol_mac_ctrl_info_2 {
+	struct {
+		u32 long_retry_limit : 8;
+		u32 short_retry_limit : 8;
+		u32 rts_threshold : 12;
+	};
+	u32 value;
+};
+
+#define POLICY_TABLE_PATTERN 0xBADCAB1E
+
+struct tx_policy_tbl {
+	/* Unique Pattern at the start of Policy Table */
+	u32 upatterntx;
+	/* PHY Control 1 Information used by MAC HW */
+	union rwnx_pol_phy_ctrl_info_1 phyctrlinfo_1;
+	/* PHY Control 2 Information used by MAC HW */
+	union rwnx_pol_phy_ctrl_info_2 phyctrlinfo_2;
+	/* MAC Control 1 Information used by MAC HW */
+	union rwnx_pol_mac_ctrl_info_1 macctrlinfo_1;
+	/* MAC Control 2 Information used by MAC HW */
+	union rwnx_pol_mac_ctrl_info_2 macctrlinfo_2;
+
+	union rwnx_rate_ctrl_info ratectrlinfos[NX_TX_MAX_RATES];
+	struct rwnx_power_ctrl_info powerctrlinfos[NX_TX_MAX_RATES];
+};
+
+#ifdef CONFIG_RWNX_FULLMAC
+
+/**
+ * struct rwnx_hw_txstatus - Bitfield of confirmation status
+ *
+ * @tx_done: packet has been processed by the firmware.
+ * @retry_required: packet has been transmitted but not acknoledged.
+ * Driver must repush it.
+ * @sw_retry_required: packet has not been transmitted (FW wasn't able to =
push
+ * it when it received it: not active channel ...). Driver must repush it.
+ * @acknowledged: packet has been acknowledged by peer
+ */
+union rwnx_hw_txstatus {
+	struct {
+		u32 tx_done : 1;
+		u32 retry_required : 1;
+		u32 sw_retry_required : 1;
+		u32 acknowledged : 1;
+		u32 reserved : 28;
+	};
+	u32 value;
+};
+
+/**
+ * struct tx_cfm_tag - Structure indicating the status and other
+ * information about the transmission
+ *
+ * @pn: PN that was used for the transmission
+ * @sn: Sequence number of the packet
+ * @timestamp: Timestamp of first transmission of this MPDU
+ * @credits: Number of credits to be reallocated for the txq that push thi=
s
+ * buffer (can be 0 or 1)
+ * @ampdu_size: Size of the ampdu in which the frame has been transmitted =
if
+ * this was the last frame of the a-mpdu, and 0 if the frame is not the la=
st
+ * frame on a a-mdpu.
+ * 1 means that the frame has been transmitted as a singleton.
+ * @amsdu_size: Size, in bytes, allowed to create a-msdu.
+ * @status: transmission status
+ */
+struct tx_cfm_tag {
+	/*
+	 *	u16_l pn[4];
+	 *	u16_l sn;
+	 *	u16_l timestamp;
+	 */
+	s8_l credits;
+	u8_l ampdu_size;
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+	u16_l amsdu_size;
+#endif
+	union rwnx_hw_txstatus status;
+	u32_l hostid;
+};
+
+/**
+ * struct rwnx_hw_txhdr - Hardware part of tx header
+ *
+ * @cfm: Information updated by fw/hardware after sending a frame
+ */
+struct rwnx_hw_txhdr {
+	struct tx_cfm_tag cfm;
+};
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+/* Modem */
+
+#define MDM_PHY_CONFIG_TRIDENT 0
+#define MDM_PHY_CONFIG_ELMA    1
+#define MDM_PHY_CONFIG_KARST   2
+
+// MODEM features (from reg_mdm_stat.h)
+/// MUMIMOTX field bit
+#define MDM_MUMIMOTX_BIT ((u32)0x80000000)
+/// MUMIMOTX field position
+#define MDM_MUMIMOTX_POS 31
+/// MUMIMORX field bit
+#define MDM_MUMIMORX_BIT ((u32)0x40000000)
+/// MUMIMORX field position
+#define MDM_MUMIMORX_POS 30
+/// BFMER field bit
+#define MDM_BFMER_BIT    ((u32)0x20000000)
+/// BFMER field position
+#define MDM_BFMER_POS    29
+/// BFMEE field bit
+#define MDM_BFMEE_BIT    ((u32)0x10000000)
+/// BFMEE field position
+#define MDM_BFMEE_POS    28
+/// LDPCDEC field bit
+#define MDM_LDPCDEC_BIT  ((u32)0x08000000)
+/// LDPCDEC field position
+#define MDM_LDPCDEC_POS  27
+/// LDPCENC field bit
+#define MDM_LDPCENC_BIT  ((u32)0x04000000)
+/// LDPCENC field position
+#define MDM_LDPCENC_POS  26
+/// CHBW field mask
+#define MDM_CHBW_MASK    ((u32)0x03000000)
+/// CHBW field LSB position
+#define MDM_CHBW_LSB     24
+/// CHBW field width
+#define MDM_CHBW_WIDTH   ((u32)0x00000002)
+/// DSSSCCK field bit
+#define MDM_DSSSCCK_BIT  ((u32)0x00800000)
+/// DSSSCCK field position
+#define MDM_DSSSCCK_POS  23
+/// VHT field bit
+#define MDM_VHT_BIT      ((u32)0x00400000)
+/// VHT field position
+#define MDM_VHT_POS      22
+/// HE field bit
+#define MDM_HE_BIT       ((u32)0x00200000)
+/// HE field position
+#define MDM_HE_POS       21
+/// ESS field bit
+#define MDM_ESS_BIT      ((u32)0x00100000)
+/// ESS field position
+#define MDM_ESS_POS      20
+/// RFMODE field mask
+#define MDM_RFMODE_MASK  ((u32)0x000F0000)
+/// RFMODE field LSB position
+#define MDM_RFMODE_LSB   16
+/// RFMODE field width
+#define MDM_RFMODE_WIDTH ((u32)0x00000004)
+/// NSTS field mask
+#define MDM_NSTS_MASK    ((u32)0x0000F000)
+/// NSTS field LSB position
+#define MDM_NSTS_LSB     12
+/// NSTS field width
+#define MDM_NSTS_WIDTH   ((u32)0x00000004)
+/// NSS field mask
+#define MDM_NSS_MASK     ((u32)0x00000F00)
+/// NSS field LSB position
+#define MDM_NSS_LSB      8
+/// NSS field width
+#define MDM_NSS_WIDTH    ((u32)0x00000004)
+/// NTX field mask
+#define MDM_NTX_MASK     ((u32)0x000000F0)
+/// NTX field LSB position
+#define MDM_NTX_LSB      4
+/// NTX field width
+#define MDM_NTX_WIDTH    ((u32)0x00000004)
+/// NRX field mask
+#define MDM_NRX_MASK     ((u32)0x0000000F)
+/// NRX field LSB position
+#define MDM_NRX_LSB      0
+/// NRX field width
+#define MDM_NRX_WIDTH    ((u32)0x00000004)
+
+#define __MDM_PHYCFG_FROM_VERS(v) (((v) & MDM_RFMODE_MASK) >> MDM_RFMODE_L=
SB)
+
+#define RIU_FCU_PRESENT_MASK ((u32)0xFF000000)
+#define RIU_FCU_PRESENT_LSB  24
+
+#define __RIU_FCU_PRESENT(v)                                              =
     \
+	(((v) & RIU_FCU_PRESENT_MASK) >> RIU_FCU_PRESENT_LSB =3D=3D 5)
+
+/// AGC load version field mask
+#define RIU_AGC_LOAD_MASK ((u32)0x00C00000)
+/// AGC load version field LSB position
+#define RIU_AGC_LOAD_LSB  22
+
+#define __RIU_AGCLOAD_FROM_VERS(v)                                        =
     \
+	(((v) & RIU_AGC_LOAD_MASK) >> RIU_AGC_LOAD_LSB)
+
+#define __FPGA_TYPE(v) (((v) & 0xFFFF0000) >> 16)
+
+#define __MDM_MAJOR_VERSION(v) (((v) & 0xFF000000) >> 24)
+#define __MDM_MINOR_VERSION(v) (((v) & 0x00FF0000) >> 16)
+/*
+ * #define __MDM_VERSION(v)                                               =
        \
+ *	((__MDM_MAJOR_VERSION(v) + 2) * 10 + __MDM_MINOR_VERSION(v))
+ */
+#define __MDM_VERSION(v)	\
+({								\
+	u32 __v =3D (v);						\
+	(__MDM_MAJOR_VERSION(__v) + 2) * 10 + __MDM_MINOR_VERSION(__v);	\
+})
+
+#endif // _HAL_DESC_H_
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/ipc_compat.h b/drivers/n=
et/wireless/aic/aic8800_fdrv/ipc_compat.h
new file mode 100644
index 0000000000000..8c5b22ce74d0a
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/ipc_compat.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ *************************************************************************=
***************
+ */
+
+#ifndef _IPC_H_
+#define _IPC_H_
+
+#define __INLINE inline
+
+#define __ALIGN4 __aligned(4)
+
+#define ASSERT_ERR(condition)                                             =
     \
+	do {                                                                     =
  \
+		if (unlikely(!(condition))) {                                          \
+			pr_err("%s:%d:ASSERT_ERR(" #condition ")\n", __FILE__,    \
+				   __LINE__);                                                  \
+		}                                                                      \
+	} while (0)
+
+#endif /* _IPC_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/ipc_host.c b/drivers/net=
/wireless/aic/aic8800_fdrv/ipc_host.c
new file mode 100644
index 0000000000000..6768a6e4a34f2
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/ipc_host.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief IPC module
+ *
+ *************************************************************************=
*****
+ */
+
+#ifndef __KERNEL__
+#include <stdio.h>
+#else
+#include "rwnx_defs.h"
+#include "rwnx_prof.h"
+#include <linux/spinlock.h>
+#endif
+
+#include "ipc_host.h"
+
+/*
+ * TYPES DEFINITION
+ *************************************************************************=
*****
+ */
+
+const int nx_txdesc_cnt[] =3D {
+	NX_TXDESC_CNT0, NX_TXDESC_CNT1, NX_TXDESC_CNT2, NX_TXDESC_CNT3,
+#if NX_TXQ_CNT =3D=3D 5
+	NX_TXDESC_CNT4,
+#endif
+};
+
+const int nx_txuser_cnt[] =3D {
+	CONFIG_USER_MAX,
+	CONFIG_USER_MAX,
+	CONFIG_USER_MAX,
+	CONFIG_USER_MAX,
+#if NX_TXQ_CNT =3D=3D 5
+	1,
+#endif
+};
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/ipc_host.h b/drivers/net=
/wireless/aic/aic8800_fdrv/ipc_host.h
new file mode 100644
index 0000000000000..69efdedc8ec86
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/ipc_host.h
@@ -0,0 +1,169 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief IPC module
+ *
+ *************************************************************************=
*****
+ */
+
+#ifndef _IPC_HOST_H_
+#define _IPC_HOST_H_
+
+/*
+ * INCLUDE FILES
+ *************************************************************************=
*****
+ */
+#include "ipc_shared.h"
+#ifndef __KERNEL__
+#include "arch.h"
+#else
+#include "ipc_compat.h"
+#endif
+
+/**
+ *************************************************************************=
*****
+ * @brief This structure is used to initialize the MAC SW
+ *
+ * The WLAN device driver provides functions call-back with this structure
+ *************************************************************************=
*****
+ */
+struct ipc_host_cb_tag {
+	/// WLAN driver call-back function: send_data_cfm
+	int (*send_data_cfm)(void *pthis, void *host_id);
+
+	/// WLAN driver call-back function: recv_data_ind
+	uint8_t (*recv_data_ind)(void *pthis, void *host_id);
+
+	/// WLAN driver call-back function: recv_radar_ind
+	uint8_t (*recv_radar_ind)(void *pthis, void *host_id);
+
+	/// WLAN driver call-back function: recv_unsup_rx_vec_ind
+	uint8_t (*recv_unsup_rx_vec_ind)(void *pthis, void *host_id);
+
+	/// WLAN driver call-back function: recv_msg_ind
+	uint8_t (*recv_msg_ind)(void *pthis, void *host_id);
+
+	/// WLAN driver call-back function: recv_msgack_ind
+	uint8_t (*recv_msgack_ind)(void *pthis, void *host_id);
+
+	/// WLAN driver call-back function: recv_dbg_ind
+	uint8_t (*recv_dbg_ind)(void *pthis, void *host_id);
+
+	/// WLAN driver call-back function: prim_tbtt_ind
+	void (*prim_tbtt_ind)(void *pthis);
+
+	/// WLAN driver call-back function: sec_tbtt_ind
+	void (*sec_tbtt_ind)(void *pthis);
+};
+
+/*
+ * Struct used to store information about host buffers (DMA Address and lo=
cal
+ * pointer)
+ */
+struct ipc_hostbuf {
+	void *hostid;      ///< ptr to hostbuf client (ipc_host client) structure
+	u32 dma_addr; ///< ptr to real hostbuf dma address
+};
+
+/// Definition of the IPC Host environment structure.
+struct ipc_host_env_tag {
+	/// Structure containing the callback pointers
+	struct ipc_host_cb_tag cb;
+
+	/// Pointer to the shared environment
+	struct ipc_shared_env_tag *shared;
+
+#ifdef CONFIG_RWNX_FULLMAC
+	// Array used to store the descriptor addresses
+	struct ipc_hostbuf ipc_host_rxdesc_array[IPC_RXDESC_CNT];
+	// Index of the host RX descriptor array (ipc_shared environment)
+	u8 ipc_host_rxdesc_idx;
+	/// Store the number of RX Descriptors
+	u8 rxdesc_nb;
+#endif //(CONFIG_RWNX_FULLMAC)
+
+	/// Fields for Data Rx handling
+	// Index used for ipc_host_rxbuf_array to point to current buffer
+	u8 ipc_host_rxbuf_idx;
+	// Store the number of Rx Data buffers
+	u32 rx_bufnb;
+	// Store the size of the Rx Data buffers
+	u32 rx_bufsz;
+
+	/// Fields for Radar events handling
+	// Global array used to store the hostid and hostbuf addresses
+	struct ipc_hostbuf ipc_host_radarbuf_array[IPC_RADARBUF_CNT];
+	// Index used for ipc_host_rxbuf_array to point to current buffer
+	u8 ipc_host_radarbuf_idx;
+	// Store the number of radar event buffers
+	u32 radar_bufnb;
+	// Store the size of the radar event buffers
+	u32 radar_bufsz;
+
+	/// Fields for Unsupported frame handling
+	// Global array used to store the hostid and hostbuf addresses
+	struct ipc_hostbuf ipc_host_unsuprxvecbuf_array[IPC_UNSUPRXVECBUF_CNT];
+	// Index used for ipc_host_unsuprxvecbuf_array to point to current buffer
+	u8 ipc_host_unsuprxvecbuf_idx;
+	// Store the number of unsupported rx vector buffers
+	u32 unsuprxvec_bufnb;
+	// Store the size of unsupported rx vector buffers
+	u32 unsuprxvec_bufsz;
+
+	// Index used that points to the first free TX desc
+	u32 txdesc_free_idx[IPC_TXQUEUE_CNT][CONFIG_USER_MAX];
+	// Index used that points to the first used TX desc
+	u32 txdesc_used_idx[IPC_TXQUEUE_CNT][CONFIG_USER_MAX];
+	// Array storing the currently pushed host ids for the BK queue
+	void *tx_host_id0[CONFIG_USER_MAX][NX_TXDESC_CNT0];
+	// Array storing the currently pushed host ids for the BE queue
+	void *tx_host_id1[CONFIG_USER_MAX][NX_TXDESC_CNT1];
+	// Array storing the currently pushed host ids for the VI queue
+	void *tx_host_id2[CONFIG_USER_MAX][NX_TXDESC_CNT2];
+	// Array storing the currently pushed host ids for the VO queue
+	void *tx_host_id3[CONFIG_USER_MAX][NX_TXDESC_CNT3];
+#if NX_TXQ_CNT =3D=3D 5
+	// Array storing the currently pushed host ids for the BCN queue
+	void *tx_host_id4[1][NX_TXDESC_CNT4];
+#endif
+	// Pointer to the different host ids arrays, per IPC queue
+	void **tx_host_id[IPC_TXQUEUE_CNT][CONFIG_USER_MAX];
+	// Pointer to the different TX descriptor arrays, per IPC queue
+	struct txdesc_host *txdesc[IPC_TXQUEUE_CNT][CONFIG_USER_MAX];
+
+	/// Fields for Emb->App MSGs handling
+	// Global array used to store the hostid and hostbuf addresses for msg/in=
d
+	struct ipc_hostbuf ipc_host_msgbuf_array[IPC_MSGE2A_BUF_CNT];
+	// Index of the MSG E2A buffers array to point to current buffer
+	u8 ipc_host_msge2a_idx;
+	// Store the number of E2A MSG buffers
+	u32 ipc_e2amsg_bufnb;
+	// Store the size of the E2A MSG buffers
+	u32 ipc_e2amsg_bufsz;
+
+	/// E2A ACKs of A2E MSGs
+	u8 msga2e_cnt;
+	void *msga2e_hostid;
+
+	/// Fields for Debug MSGs handling
+	// Global array used to store the hostid and hostbuf addresses for Debug
+	// messages
+	struct ipc_hostbuf ipc_host_dbgbuf_array[IPC_DBGBUF_CNT];
+	// Index of the Debug messages buffers array to point to current buffer
+	u8 ipc_host_dbg_idx;
+	// Store the number of Debug messages buffers
+	u32 ipc_dbg_bufnb;
+	// Store the size of the Debug messages buffers
+	u32 ipc_dbg_bufsz;
+
+	/// Pointer to the attached object (used in callbacks and register access=
es)
+	void *pthis;
+};
+
+extern const int nx_txdesc_cnt[];
+extern const int nx_txuser_cnt[];
+
+#endif // _IPC_HOST_H_
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/ipc_shared.h b/drivers/n=
et/wireless/aic/aic8800_fdrv/ipc_shared.h
new file mode 100644
index 0000000000000..c71b74bd69f75
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/ipc_shared.h
@@ -0,0 +1,781 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief Shared data between both IPC modules
+ *
+ *************************************************************************=
*****
+ */
+
+#ifndef _IPC_SHARED_H_
+#define _IPC_SHARED_H_
+
+/*
+ * INCLUDE FILES
+ *************************************************************************=
***************
+ */
+#include "ipc_compat.h"
+#include "lmac_mac.h"
+#include "rwnx_compat.h"
+
+/*
+ * DEFINES AND MACROS
+ *************************************************************************=
***************
+ */
+#define CO_BIT(pos) (1U << (pos))
+
+#define IPC_TXQUEUE_CNT NX_TXQ_CNT
+#define NX_TXDESC_CNT0  8
+#define NX_TXDESC_CNT1  64
+#define NX_TXDESC_CNT2  64
+#define NX_TXDESC_CNT3  32
+#if NX_TXQ_CNT =3D=3D 5
+#define NX_TXDESC_CNT4 8
+#endif
+
+/*
+ * Number of Host buffers available for Data Rx handling (through DMA)
+ */
+#define IPC_RXBUF_CNT 128
+
+/*
+ * Number of shared descriptors available for Data RX handling
+ */
+#define IPC_RXDESC_CNT 128
+
+/*
+ * Number of Host buffers available for Radar events handling (through DMA=
)
+ */
+#define IPC_RADARBUF_CNT 16
+
+/*
+ * Number of Host buffers available for unsupported Rx vectors handling (t=
hrough
+ * DMA)
+ */
+#define IPC_UNSUPRXVECBUF_CNT 8
+
+/*
+ *  Size of RxVector
+ */
+#define IPC_RXVEC_SIZE 16
+
+/*
+ * Number of Host buffers available for Emb->App MSGs sending (through DMA=
)
+ */
+#ifdef CONFIG_RWNX_FULLMAC
+#define IPC_MSGE2A_BUF_CNT 64
+#endif
+/*
+ * Number of Host buffers available for Debug Messages sending (through DM=
A)
+ */
+#define IPC_DBGBUF_CNT 32
+
+/*
+ * Length used in MSGs structures
+ */
+#define IPC_A2E_MSG_BUF_SIZE 127 // size in 4-byte words
+#ifdef CONFIG_RWNX_FULLMAC
+#define IPC_E2A_MSG_SIZE_BASE 256 // size in 4-byte words
+#endif
+
+#ifdef CONFIG_RWNX_TL4
+#define IPC_E2A_MSG_PARAM_SIZE                                            =
     \
+	(IPC_E2A_MSG_SIZE_BASE + (IPC_E2A_MSG_SIZE_BASE / 2))
+#else
+#define IPC_E2A_MSG_PARAM_SIZE IPC_E2A_MSG_SIZE_BASE
+#endif
+
+/*
+ * Debug messages buffers size (in bytes)
+ */
+#define IPC_DBG_PARAM_SIZE 256
+
+/*
+ * Define used for Rx hostbuf validity.
+ * This value should appear only when hostbuf was used for a Reception.
+ */
+#define RX_DMA_OVER_PATTERN 0xAAAAAA00
+
+/*
+ * Define used for MSG buffers validity.
+ * This value will be written only when a MSG buffer is used for sending f=
rom
+ * Emb to App.
+ */
+#define IPC_MSGE2A_VALID_PATTERN 0xADDEDE2A
+
+/*
+ * Define used for Debug messages buffers validity.
+ * This value will be written only when a DBG buffer is used for sending f=
rom
+ * Emb to App.
+ */
+#define IPC_DBG_VALID_PATTERN 0x000CACA0
+
+/*
+ *  Length of the receive vectors, in bytes
+ */
+#define DMA_HDR_PHYVECT_LEN 36
+
+/*
+ * Maximum number of payload addresses and lengths present in the descript=
or
+ */
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+#define NX_TX_PAYLOAD_MAX 6
+#else
+#define NX_TX_PAYLOAD_MAX 1
+#endif
+
+/*
+ * Message struct/ID API version
+ */
+#define MSG_API_VER 33
+
+/*
+ *************************************************************************=
***************
+ */
+// c.f LMAC/src/tx/tx_swdesc.h
+/// Descriptor filled by the Host
+struct hostdesc {
+	/// Pointer to packet payload
+	// u32_l packet_addr;
+	/// Size of the payload
+	u16_l packet_len;
+	u16_l flags_ext;
+
+	u32_l hostid;
+#ifdef CONFIG_RWNX_FULLMAC
+	/// Address of the status descriptor in host memory (used for confirmatio=
n
+	/// upload)
+	// u32_l status_desc_addr;
+	/// Destination Address
+	struct mac_addr eth_dest_addr;
+	/// Source Address
+	struct mac_addr eth_src_addr;
+	/// Ethernet Type
+	u16_l ethertype;
+#else /* ! CONFIG_RWNX_FULLMAC */
+#ifdef CONFIG_RWNX_AGG_TX
+	/// Sequence Number for AMPDU MPDUs - for quick check if it's allowed wit=
hin
+	/// window
+	u16_l sn;
+#endif /* CONFIG_RWNX_AGG_TX */
+	/// Padding between the buffer control structure and the MPDU in host mem=
ory
+	u8_l padding;
+#endif /* CONFIG_RWNX_FULLMAC */
+	u8_l ac;
+	/// Packet TID (0xFF if not a QoS frame)
+	u8_l tid;
+	/// Interface Id
+	u8_l vif_idx;
+	/// Station Id (0xFF if station is unknown)
+	u8_l staid;
+#ifdef CONFIG_RWNX_MUMIMO_TX
+	/// MU-MIMO information (GroupId and User Position in the group) - The
+	/// GroupId is located on bits 0-5 and the User Position on bits 6-7. The
+	/// GroupId value is set to 63 if MU-MIMO shall not be used
+	u8_l mumimo_info;
+#endif /* CONFIG_RWNX_MUMIMO_TX */
+#ifdef CONFIG_RWNX_FULLMAC
+	/// TX flags
+	u16_l flags;
+#endif /* CONFIG_RWNX_FULLMAC */
+};
+
+/// Descriptor filled by the UMAC
+struct umacdesc {
+#ifdef CONFIG_RWNX_AGG_TX
+	/// First Sequence Number of the BlockAck window
+	u16_l sn_win;
+	/// Flags from UMAC (match tx_hd.macctrlinfo2 format)
+	u32_l flags;
+	/// PHY related flags field - rate, GI type, BW type - filled by driver
+	u32_l phy_flags;
+#endif //(CONFIG_RWNX_AGG_TX)
+};
+
+struct txdesc_api {
+	/// Information provided by Host
+	struct hostdesc host;
+};
+
+struct txdesc_host {
+	u32_l ready;
+
+	/// API of the embedded part
+	struct txdesc_api api;
+};
+
+/// Comes from ipc_dma.h
+/// Element in the pool of TX DMA bridge descriptors.
+struct dma_desc {
+	/* Application subsystem address which is used as source address for DMA
+	 * payload transfer
+	 */
+	u32_l src;
+	/** Points to the start of the embedded data buffer associated with this
+	 * descriptor. This address acts as the destination address for the DMA
+	 * payload transfer
+	 */
+	u32_l dest;
+	/// Complete length of the buffer in memory
+	u16_l length;
+	/// Control word for the DMA engine (e.g. for interrupt generation)
+	u16_l ctrl;
+	/// Pointer to the next element of the chained list
+	u32_l next;
+};
+
+// Comes from la.h
+/// Length of the configuration data of a logic analyzer
+#define LA_CONF_LEN 10
+
+/// Structure containing the configuration data of a logic analyzer
+struct la_conf_tag {
+	u32_l conf[LA_CONF_LEN];
+	u32_l trace_len;
+	u32_l diag_conf;
+};
+
+/// Size of a logic analyzer memory
+#define LA_MEM_LEN (1024 * 1024)
+
+/// Type of errors
+enum {
+	/// Recoverable error, not requiring any action from Upper MAC
+	DBG_ERROR_RECOVERABLE =3D 0,
+	/// Fatal error, requiring Upper MAC to reset Lower MAC and HW and restar=
t
+	/// operation
+	DBG_ERROR_FATAL
+};
+
+/// Maximum length of the SW diag trace
+#define DBG_SW_DIAG_MAX_LEN 1024
+
+/// Maximum length of the error trace
+#define DBG_ERROR_TRACE_SIZE 256
+
+/// Number of MAC diagnostic port banks
+#define DBG_DIAGS_MAC_MAX 48
+
+/// Number of PHY diagnostic port banks
+#define DBG_DIAGS_PHY_MAX 32
+
+/// Maximum size of the RX header descriptor information in the debug dump
+#define DBG_RHD_MEM_LEN (5 * 1024)
+
+/// Maximum size of the RX buffer descriptor information in the debug dump
+#define DBG_RBD_MEM_LEN (5 * 1024)
+
+/// Maximum size of the TX header descriptor information in the debug dump
+#define DBG_THD_MEM_LEN (10 * 1024)
+
+/// Structure containing the information about the PHY channel that is use=
d
+struct phy_channel_info {
+	/// PHY channel information 1
+	u32_l info1;
+	/// PHY channel information 2
+	u32_l info2;
+};
+
+/// Debug information forwarded to host when an error occurs
+struct dbg_debug_info_tag {
+	/// Type of error (0: recoverable, 1: fatal)
+	u32_l error_type;
+	/// Pointer to the first RX Header Descriptor chained to the MAC HW
+	u32_l rhd;
+	/// Size of the RX header descriptor buffer
+	u32_l rhd_len;
+	/// Pointer to the first RX Buffer Descriptor chained to the MAC HW
+	u32_l rbd;
+	/// Size of the RX buffer descriptor buffer
+	u32_l rbd_len;
+	/// Pointer to the first TX Header Descriptors chained to the MAC HW
+	u32_l thd[NX_TXQ_CNT];
+	/// Size of the TX header descriptor buffer
+	u32_l thd_len[NX_TXQ_CNT];
+	/// MAC HW diag configuration
+	u32_l hw_diag;
+	/// Error message
+	u32_l error[DBG_ERROR_TRACE_SIZE / 4];
+	/// SW diag configuration length
+	u32_l sw_diag_len;
+	/// SW diag configuration
+	u32_l sw_diag[DBG_SW_DIAG_MAX_LEN / 4];
+	/// PHY channel information
+	struct phy_channel_info chan_info;
+	/// Embedded LA configuration
+	struct la_conf_tag la_conf;
+	/// MAC diagnostic port state
+	u16_l diags_mac[DBG_DIAGS_MAC_MAX];
+	/// PHY diagnostic port state
+	u16_l diags_phy[DBG_DIAGS_PHY_MAX];
+	/// MAC HW RX Header descriptor pointer
+	u32_l rhd_hw_ptr;
+	/// MAC HW RX Buffer descriptor pointer
+	u32_l rbd_hw_ptr;
+};
+
+/// Full debug dump that is forwarded to host in case of error
+struct dbg_debug_dump_tag {
+	/// Debug information
+	struct dbg_debug_info_tag dbg_info;
+
+	/// RX header descriptor memory
+	u32_l rhd_mem[DBG_RHD_MEM_LEN / 4];
+
+	/// RX buffer descriptor memory
+	u32_l rbd_mem[DBG_RBD_MEM_LEN / 4];
+
+	/// TX header descriptor memory
+	u32_l thd_mem[NX_TXQ_CNT][DBG_THD_MEM_LEN / 4];
+
+	/// Logic analyzer memory
+	u32_l la_mem[LA_MEM_LEN / 4];
+};
+
+/// Number of pulses in a radar event structure
+#define RADAR_PULSE_MAX 4
+
+/// Definition of an array of radar pulses
+struct radar_pulse_array_desc {
+	/// Buffer containing the radar pulses
+	u32_l pulse[RADAR_PULSE_MAX];
+	/// Index of the radar detection chain that detected those pulses
+	u32_l idx;
+	/// Number of valid pulses in the buffer
+	u32_l cnt;
+};
+
+/// Bit mapping inside a radar pulse element
+struct radar_pulse {
+	s32_l
+		freq : 6;  /** Freq (resolution is 2Mhz range is [-Fadc/4 .. Fadc/4]) */
+	u32_l fom : 4; /** Figure of Merit */
+	u32_l len : 6; /** Length of the current radar pulse (resolution is 2us) =
*/
+	u32_l rep : 16; /* Time interval between the previous radar event
+			 * and the current one (in us)
+			 */
+};
+
+/// Definition of a RX vector descriptor
+struct rx_vector_desc {
+	/// PHY channel information
+	struct phy_channel_info phy_info;
+
+	/// RX vector 1
+	u32_l rx_vect1[IPC_RXVEC_SIZE / 4];
+
+	/// Used to print a valid rx vector
+	u32_l pattern;
+};
+
+///
+struct rxdesc_tag {
+	/// Host Buffer Address
+	u32_l host_id;
+	/// Length
+	u32_l frame_len;
+	/// Status
+	u16_l status;
+};
+
+/**
+ *************************************************************************=
***************
+ * @addtogroup IPC_TX IPC Tx path
+ *  @ingroup IPC
+ *  @brief IPC Tx path structures and functions
+ *
+ * A typical use case of the IPC Tx path API:
+ * @msc
+ * hscale =3D "2";
+ *
+ * a [label=3DDriver],
+ * b [label=3D"IPC host"],
+ * c [label=3D"IPC emb"],
+ * d [label=3DFirmware];
+ *
+ * ---   [label=3D"Tx descriptor queue example"];
+ * a=3D>a  [label=3D"Driver receives a Tx packet from OS"];
+ * a=3D>b  [label=3D"ipc_host_txdesc_get()"];
+ * a<<b  [label=3D"struct txdesc_host *"];
+ * a=3D>a  [label=3D"Driver fill the descriptor"];
+ * a=3D>b  [label=3D"ipc_host_txdesc_push()"];
+ * ...   [label=3D"(several Tx desc can be pushed)"];
+ * b:>c  [label=3D"Tx desc queue filled IRQ"];
+ * c=3D>>d [label=3D"EDCA sub-scheduler callback"];
+ * c<<d  [label=3D"Tx desc queue to pop"];
+ * c=3D>>d [label=3D"UMAC Tx desc callback"];
+ * ...   [label=3D"(several Tx desc can be popped)"];
+ * d=3D>d  [label=3D"Packets are sent or discarded"];
+ * ---   [label=3D"Tx confirm queue example"];
+ * c<=3Dd  [label=3D"ipc_emb_txcfm_push()"];
+ * c>>d  [label=3D"Request accepted"];
+ * ...   [label=3D"(several Tx cfm can be pushed)"];
+ * b<:c  [label=3D"Tx cfm queue filled IRQ"];
+ * a<<=3Db [label=3D"Driver's Tx Confirm callback"];
+ * a=3D>b  [label=3D"ipc_host_txcfm_pop()"];
+ * a<<b  [label=3D"struct ipc_txcfm"];
+ * a<=3Da  [label=3D"Packets are freed by the driver"];
+ * @endmsc
+ *
+ * @{
+ *************************************************************************=
***************
+ */
+
+/// @} IPC_TX
+
+/**
+ *************************************************************************=
***************
+ *  @defgroup IPC_RX IPC Rx path
+ *  @ingroup IPC
+ *  @brief IPC Rx path functions and structures
+ *
+ * A typical use case of the IPC Rx path API:
+ * @msc
+ * hscale =3D "2";
+ *
+ * a [label=3DFirmware],
+ * b [label=3D"IPC emb"],
+ * c [label=3D"IPC host"],
+ * d [label=3DDriver];
+ *
+ * ---   [label=3D"Rx buffer and desc queues usage example"];
+ * d=3D>c  [label=3D"ipc_host_rxbuf_push()"];
+ * d=3D>c  [label=3D"ipc_host_rxbuf_push()"];
+ * d=3D>c  [label=3D"ipc_host_rxbuf_push()"];
+ * ...   [label=3D"(several Rx buffer are pushed)"];
+ * a=3D>a  [label=3D" Frame is received\n from the medium"];
+ * a<<b  [label=3D"struct ipc_rxbuf"];
+ * a=3D>a  [label=3D" Firmware fill the buffer\n with received frame"];
+ * a<<b  [label=3D"Push accepted"];
+ * ...   [label=3D"(several Rx desc can be pushed)"];
+ * b:>c  [label=3D"Rx desc queue filled IRQ"];
+ * c=3D>>d [label=3D"Driver Rx packet callback"];
+ * c<=3Dd  [label=3D"ipc_host_rxdesc_pop()"];
+ * d=3D>d  [label=3D"Rx packet is handed\nover to the OS "];
+ * ...   [label=3D"(several Rx desc can be poped)"];
+ * ---   [label=3D"Rx buffer request exemple"];
+ * b:>c  [label=3D"Low Rx buffer count IRQ"];
+ * a<<b  [label=3D"struct ipc_rxbuf"];
+ * c=3D>>d [label=3D"Driver Rx buffer callback"];
+ * d=3D>c  [label=3D"ipc_host_rxbuf_push()"];
+ * d=3D>c  [label=3D"ipc_host_rxbuf_push()"];
+ * d=3D>c  [label=3D"ipc_host_rxbuf_push()"];
+ * ...   [label=3D"(several Rx buffer are pushed)"];
+ * @endmsc
+ *
+ * @addtogroup IPC_RX
+ * @{
+ *************************************************************************=
***************
+ */
+
+/// @} IPC_RX
+
+/**
+ *************************************************************************=
***************
+ *  @defgroup IPC_MISC IPC Misc
+ *  @ingroup IPC
+ *  @brief IPC miscellaneous functions
+ *************************************************************************=
***************
+ */
+/** IPC header structure.  This structure is stored at the beginning of ev=
ery
+ * IPC message.
+ * @warning This structure's size must NOT exceed 4 bytes in length.
+ */
+struct ipc_header {
+	/// IPC message type.
+	u16_l type;
+	/// IPC message size in number of bytes.
+	u16_l size;
+};
+
+struct ipc_msg_elt {
+	/// Message header (alignment forced on word size, see allocation in shar=
ed
+	/// env).
+	struct ipc_header header __ALIGN4;
+};
+
+/// Message structure for MSGs from Emb to App
+struct ipc_e2a_msg {
+	u16_l id; ///< Message id.
+	u16_l dummy_dest_id;
+	u16_l dummy_src_id;
+	u16_l param_len;                     ///< Parameter embedded struct lengt=
h.
+	u32_l pattern;                       ///< Used to stamp a valid MSG buffe=
r
+	u32_l param[IPC_E2A_MSG_PARAM_SIZE]; ///< Parameter embedded struct. Must=
 be
+										 ///< word-aligned.
+};
+
+/// Message structure for Debug messages from Emb to App
+struct ipc_dbg_msg {
+	u32_l string[IPC_DBG_PARAM_SIZE / 4]; ///< Debug string
+	u32_l pattern;                        ///< Used to stamp a valid buffer
+};
+
+/// Message structure for MSGs from App to Emb.
+/// Actually a sub-structure will be used when filling the messages.
+struct ipc_a2e_msg {
+	u32_l dummy_word; // used to cope with kernel message structure
+	u32_l msg[IPC_A2E_MSG_BUF_SIZE]; // body of the msg
+};
+
+struct ipc_shared_rx_buf {
+	/// < ptr to hostbuf client (ipc_host client) structure
+	u32_l hostid;
+	/// < ptr to real hostbuf dma address
+	u32_l dma_addr;
+};
+
+struct ipc_shared_rx_desc {
+	/// DMA Address
+	u32_l dma_addr;
+};
+
+/// Structure containing FW characteristics for compatibility checking
+struct compatibility_tag {
+	/// Size of IPC shared memory
+	u16_l ipc_shared_size;
+	/// Message struct/ID API version
+	u16_l msg_api;
+	/// Version of IPC shared
+	u8_l ipc_shared_version;
+	/// Number of host buffers available for Emb->App MSGs sending
+	u8_l msge2a_buf_cnt;
+	/// Number of host buffers available for Debug Messages sending
+	u8_l dbgbuf_cnt;
+	/// Number of host buffers available for Radar events handling
+	u8_l radarbuf_cnt;
+	/// Number of host buffers available for unsupported Rx vectors handling
+	u8_l unsuprxvecbuf_cnt;
+	/// Number of shared descriptors available for Data RX handling
+	u8_l rxdesc_cnt;
+	/// Number of host buffers available for Data Rx handling
+	u8_l rxbuf_cnt;
+	/// Number of descriptors in BK TX queue (power of 2, min 4, max 64)
+	u8_l bk_txq;
+	/// Number of descriptors in BE TX queue (power of 2, min 4, max 64)
+	u8_l be_txq;
+	/// Number of descriptors in VI TX queue (power of 2, min 4, max 64)
+	u8_l vi_txq;
+	/// Number of descriptors in VO TX queue (power of 2, min 4, max 64)
+	u8_l vo_txq;
+	/// Number of descriptors in BCN TX queue (power of 2, min 4, max 64)
+	u8_l bcn_txq;
+};
+
+/*
+ * TYPE and STRUCT DEFINITIONS
+ *************************************************************************=
***************
+ */
+
+// Indexes are defined in the MIB shared structure
+struct ipc_shared_env_tag {
+	struct compatibility_tag comp_info; // FW characteristics
+
+	struct ipc_a2e_msg
+		msg_a2e_buf; // room for MSG to be sent from App to Emb
+
+	// Fields for MSGs sending from Emb to App
+	struct ipc_e2a_msg
+		msg_e2a_buf; // room to build the MSG to be DMA Xferred
+	struct dma_desc
+		msg_dma_desc; // DMA descriptor for Emb->App MSGs Xfers
+	u32_l msg_e2a_hostbuf_addr[IPC_MSGE2A_BUF_CNT]; // buffers @ for DMA Xfer=
s
+
+	// Fields for Debug MSGs sending from Emb to App
+	struct ipc_dbg_msg
+		dbg_buf; // room to build the MSG to be DMA Xferred
+	struct dma_desc
+		dbg_dma_desc; // DMA descriptor for Emb->App MSGs Xfers
+	u32_l dbg_hostbuf_addr[IPC_DBGBUF_CNT]; // buffers @ for MSGs DMA Xfers
+	u32_l la_dbginfo_addr; // Host buffer address for the debug information
+	u32_l pattern_addr;
+
+	u32_l radarbuf_hostbuf[IPC_RADARBUF_CNT]; // buffers @ for Radar Events
+	u32_l unsuprxvecbuf_hostbuf[IPC_UNSUPRXVECBUF_CNT]; // buffers @ for
+	// unsupported Rx vectors
+	struct txdesc_host txdesc0[CONFIG_USER_MAX][NX_TXDESC_CNT0];
+	struct txdesc_host txdesc1[CONFIG_USER_MAX][NX_TXDESC_CNT1];
+	struct txdesc_host txdesc2[CONFIG_USER_MAX][NX_TXDESC_CNT2];
+	struct txdesc_host txdesc3[CONFIG_USER_MAX][NX_TXDESC_CNT3];
+#if NX_TXQ_CNT =3D=3D 5
+	struct txdesc_host txdesc4[1][NX_TXDESC_CNT4];
+#endif
+#ifdef CONFIG_RWNX_FULLMAC
+	// RX Descriptors Array
+	struct ipc_shared_rx_desc host_rxdesc[IPC_RXDESC_CNT];
+	// RX Buffers Array
+	struct ipc_shared_rx_buf host_rxbuf[IPC_RXBUF_CNT];
+#else
+	// buffers @ for Data Rx
+	u32_l host_rxbuf[IPC_RXBUF_CNT];
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	u32_l buffered[NX_REMOTE_STA_MAX][TID_MAX];
+
+	u16 trace_pattern;
+	u32 trace_start;
+	u32 trace_end;
+	u32 trace_size;
+	u32 trace_offset;
+	u32 trace_nb_compo;
+	u32 trace_offset_compo;
+};
+
+extern struct ipc_shared_env_tag ipc_shared_env;
+
+/*
+ * TYPE and STRUCT DEFINITIONS
+ *************************************************************************=
***************
+ */
+
+// IRQs from app to emb
+/// Interrupts bits used for the TX descriptors of the AC queues
+#ifdef CONFIG_RWNX_MUMIMO_TX
+#ifdef CONFIG_RWNX_OLD_IPC
+#error "MU-MIMO cannot be compiled for old IPC"
+#endif
+/// Interrupts bits used
+#if CONFIG_USER_MAX > 3
+#define IPC_IRQ_A2E_USER_MSK 0xF
+#elif CONFIG_USER_MAX > 2
+#define IPC_IRQ_A2E_USER_MSK 0x7
+#else
+#define IPC_IRQ_A2E_USER_MSK 0x3
+#endif
+
+/// Offset of the interrupts for AC0
+#define IPC_IRQ_A2E_AC0_OFT 8
+/// Mask of the interrupts for AC0
+#define IPC_IRQ_A2E_AC0_MSK (IPC_IRQ_A2E_USER_MSK << IPC_IRQ_A2E_AC0_OFT)
+/// Offset of the interrupts for AC1
+#define IPC_IRQ_A2E_AC1_OFT (IPC_IRQ_A2E_AC0_OFT + CONFIG_USER_MAX)
+/// Mask of the interrupts for AC1
+#define IPC_IRQ_A2E_AC1_MSK (IPC_IRQ_A2E_USER_MSK << IPC_IRQ_A2E_AC1_OFT)
+/// Offset of the interrupts for AC2
+#define IPC_IRQ_A2E_AC2_OFT (IPC_IRQ_A2E_AC1_OFT + CONFIG_USER_MAX)
+/// Mask of the interrupts for AC2
+#define IPC_IRQ_A2E_AC2_MSK (IPC_IRQ_A2E_USER_MSK << IPC_IRQ_A2E_AC2_OFT)
+/// Offset of the interrupts for AC3
+#define IPC_IRQ_A2E_AC3_OFT (IPC_IRQ_A2E_AC2_OFT + CONFIG_USER_MAX)
+/// Mask of the interrupts for AC3
+#define IPC_IRQ_A2E_AC3_MSK (IPC_IRQ_A2E_USER_MSK << IPC_IRQ_A2E_AC3_OFT)
+/// Offset of the interrupts for BCN
+#define IPC_IRQ_A2E_BCN_OFT (IPC_IRQ_A2E_AC3_OFT + CONFIG_USER_MAX)
+/// Mask of the interrupts for BCN
+#define IPC_IRQ_A2E_BCN_MSK CO_BIT(IPC_IRQ_A2E_BCN_OFT)
+
+#define IPC_IRQ_A2E_AC_TXDESC                                             =
     \
+	(IPC_IRQ_A2E_AC0_MSK | IPC_IRQ_A2E_AC1_MSK | IPC_IRQ_A2E_AC2_MSK |       =
  \
+	 IPC_IRQ_A2E_AC3_MSK)
+
+/// Interrupts bits used for the TX descriptors of the BCN queue
+#if NX_TXQ_CNT < 5
+#define IPC_IRQ_A2E_BCN_TXDESC 0
+#else
+#define IPC_IRQ_A2E_BCN_TXDESC (0x01 << IPC_IRQ_A2E_BCN_OFT)
+#endif
+
+/// IPC TX descriptor interrupt mask
+#define IPC_IRQ_A2E_TXDESC (IPC_IRQ_A2E_AC_TXDESC | IPC_IRQ_A2E_BCN_TXDESC=
)
+#else
+/// IPC TX descriptor interrupt mask
+#define IPC_IRQ_A2E_TXDESC 0xFF00
+#endif
+
+#define IPC_IRQ_A2E_TXDESC_FIRSTBIT (8)
+#define IPC_IRQ_A2E_RXBUF_BACK      CO_BIT(5)
+#define IPC_IRQ_A2E_RXDESC_BACK     CO_BIT(4)
+
+#define IPC_IRQ_A2E_MSG CO_BIT(1)
+#define IPC_IRQ_A2E_DBG CO_BIT(0)
+
+#define IPC_IRQ_A2E_ALL (IPC_IRQ_A2E_TXDESC | IPC_IRQ_A2E_MSG | IPC_IRQ_A2=
E_DBG)
+
+// IRQs from emb to app
+#define IPC_IRQ_E2A_TXCFM_POS 7
+
+#ifdef CONFIG_RWNX_MUMIMO_TX
+#ifdef CONFIG_RWNX_OLD_IPC
+#error "MU-MIMO cannot be compiled for old IPC"
+#endif
+/// Interrupts bits used
+#if CONFIG_USER_MAX > 3
+#define IPC_IRQ_E2A_USER_MSK 0xF
+#elif CONFIG_USER_MAX > 2
+#define IPC_IRQ_E2A_USER_MSK 0x7
+#else
+#define IPC_IRQ_E2A_USER_MSK 0x3
+#endif
+
+/// Offset of the interrupts for AC0
+#define IPC_IRQ_E2A_AC0_OFT IPC_IRQ_E2A_TXCFM_POS
+/// Mask of the interrupts for AC0
+#define IPC_IRQ_E2A_AC0_MSK (IPC_IRQ_E2A_USER_MSK << IPC_IRQ_E2A_AC0_OFT)
+/// Offset of the interrupts for AC1
+#define IPC_IRQ_E2A_AC1_OFT (IPC_IRQ_E2A_AC0_OFT + CONFIG_USER_MAX)
+/// Mask of the interrupts for AC1
+#define IPC_IRQ_E2A_AC1_MSK (IPC_IRQ_E2A_USER_MSK << IPC_IRQ_E2A_AC1_OFT)
+/// Offset of the interrupts for AC2
+#define IPC_IRQ_E2A_AC2_OFT (IPC_IRQ_E2A_AC1_OFT + CONFIG_USER_MAX)
+/// Mask of the interrupts for AC2
+#define IPC_IRQ_E2A_AC2_MSK (IPC_IRQ_E2A_USER_MSK << IPC_IRQ_E2A_AC2_OFT)
+/// Offset of the interrupts for AC3
+#define IPC_IRQ_E2A_AC3_OFT (IPC_IRQ_E2A_AC2_OFT + CONFIG_USER_MAX)
+/// Mask of the interrupts for AC3
+#define IPC_IRQ_E2A_AC3_MSK (IPC_IRQ_E2A_USER_MSK << IPC_IRQ_E2A_AC3_OFT)
+/// Offset of the interrupts for BCN
+#define IPC_IRQ_E2A_BCN_OFT (IPC_IRQ_E2A_AC3_OFT + CONFIG_USER_MAX)
+/// Mask of the interrupts for BCN
+#define IPC_IRQ_E2A_BCN_MSK CO_BIT(IPC_IRQ_E2A_BCN_OFT)
+
+#define IPC_IRQ_E2A_AC_TXCFM                                              =
     \
+	(IPC_IRQ_E2A_AC0_MSK | IPC_IRQ_E2A_AC1_MSK | IPC_IRQ_E2A_AC2_MSK |       =
  \
+	 IPC_IRQ_E2A_AC3_MSK)
+
+/// Interrupts bits used for the TX descriptors of the BCN queue
+#if NX_TXQ_CNT < 5
+#define IPC_IRQ_E2A_BCN_TXCFM 0
+#else
+#define IPC_IRQ_E2A_BCN_TXCFM (0x01 << IPC_IRQ_E2A_BCN_OFT)
+#endif
+
+/// IPC TX descriptor interrupt mask
+#define IPC_IRQ_E2A_TXCFM (IPC_IRQ_E2A_AC_TXCFM | IPC_IRQ_E2A_BCN_TXCFM)
+
+#else
+
+#define IPC_IRQ_E2A_TXCFM (((1 << NX_TXQ_CNT) - 1) << IPC_IRQ_E2A_TXCFM_PO=
S)
+
+#endif /* CONFIG_RWNX_MUMIMO_TX */
+
+#define IPC_IRQ_E2A_UNSUP_RX_VEC CO_BIT(7)
+#define IPC_IRQ_E2A_RADAR        CO_BIT(6)
+#define IPC_IRQ_E2A_TBTT_SEC     CO_BIT(5)
+#define IPC_IRQ_E2A_TBTT_PRIM    CO_BIT(4)
+#define IPC_IRQ_E2A_RXDESC       CO_BIT(3)
+#define IPC_IRQ_E2A_MSG_ACK      CO_BIT(2)
+#define IPC_IRQ_E2A_MSG          CO_BIT(1)
+#define IPC_IRQ_E2A_DBG          CO_BIT(0)
+
+#define IPC_IRQ_E2A_ALL                                                   =
     \
+	(IPC_IRQ_E2A_TXCFM | IPC_IRQ_E2A_RXDESC | IPC_IRQ_E2A_MSG_ACK |          =
  \
+	 IPC_IRQ_E2A_MSG | IPC_IRQ_E2A_DBG | IPC_IRQ_E2A_TBTT_PRIM |             =
  \
+	 IPC_IRQ_E2A_TBTT_SEC | IPC_IRQ_E2A_RADAR | IPC_IRQ_E2A_UNSUP_RX_VEC)
+
+// FLAGS for RX desc
+#define IPC_RX_FORWARD  CO_BIT(1)
+#define IPC_RX_INTRABSS CO_BIT(0)
+
+// IPC message TYPE
+enum {
+	IPC_MSG_NONE =3D 0,
+	IPC_MSG_WRAP,
+	IPC_MSG_KMSG,
+
+	IPC_DBG_STRING,
+
+};
+
+#endif // _IPC_SHARED_H_
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/lmac_mac.h b/drivers/net=
/wireless/aic/aic8800_fdrv/lmac_mac.h
new file mode 100644
index 0000000000000..3f57b5991cfe4
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/lmac_mac.h
@@ -0,0 +1,470 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief MAC related definitions.
+ *
+ * Adapted from mac_types.h to used lmac_types.h instead of standard types
+ * eg: perl -pi -e '$_ =3D~ s/uint(\d{1,2})_t/u$1_l/g; \
+ *                  $_ =3D~ s/int(\d{1,2})_t/s$1_l/g; \
+ *                  $_ =3D~ s/CO_BIT/BIT/g;'
+ *
+ *************************************************************************=
***************
+ */
+
+#ifndef LMAC_MAC_H_
+#define LMAC_MAC_H_
+
+#include "lmac_types.h"
+
+/// Interface types
+enum mac_vif_type {
+	/// ESS STA interface
+	VIF_STA,
+	/// IBSS STA interface
+	VIF_IBSS,
+	/// AP interface
+	VIF_AP,
+	/// Mesh Point interface
+	VIF_MESH_POINT,
+	/// Monitor interface
+	VIF_MONITOR,
+	/// Unknown type
+	VIF_UNKNOWN
+};
+
+/// MAC address length in bytes.
+#define MAC_ADDR_LEN 6
+
+/// MAC address structure.
+struct mac_addr {
+	/// Array of 16-bit words that make up the MAC address.
+	u16_l array[MAC_ADDR_LEN / 2];
+};
+
+/// SSID maximum length.
+#define MAC_SSID_LEN 32
+
+/// SSID.
+struct mac_ssid {
+	/// Actual length of the SSID.
+	u8_l length;
+	/// Array containing the SSID name.
+	u8_l array[MAC_SSID_LEN];
+};
+
+/// BSS type
+enum mac_bss_type {
+	INFRASTRUCTURE_MODE =3D 1,
+	INDEPENDENT_BSS_MODE,
+	ANY_BSS_MODE
+};
+
+/// Channel Band
+enum mac_chan_band {
+	/// 2.4GHz Band
+	PHY_BAND_2G4,
+	/// 5GHz band
+	PHY_BAND_5G,
+	/// Number of bands
+	PHY_BAND_MAX,
+};
+
+/// Operating Channel Bandwidth
+enum mac_chan_bandwidth {
+	/// 20MHz BW
+	PHY_CHNL_BW_20,
+	/// 40MHz BW
+	PHY_CHNL_BW_40,
+	/// 80MHz BW
+	PHY_CHNL_BW_80,
+	/// 160MHz BW
+	PHY_CHNL_BW_160,
+	/// 80+80MHz BW
+	PHY_CHNL_BW_80P80,
+	/// Reserved BW
+	PHY_CHNL_BW_OTHER,
+};
+
+/// max number of channels in the 2.4 GHZ band
+#define MAC_DOMAINCHANNEL_24G_MAX 14
+
+/// max number of channels in the 5 GHZ band
+#define MAC_DOMAINCHANNEL_5G_MAX 28
+
+/// Channel Flag
+enum mac_chan_flags {
+	/// Cannot initiate radiation on this channel
+	CHAN_NO_IR =3D BIT(0),
+	/// Channel is not allowed
+	CHAN_DISABLED =3D BIT(1),
+	/// Radar detection required on this channel
+	CHAN_RADAR =3D BIT(2),
+};
+
+/// Primary Channel definition
+struct mac_chan_def {
+	/// Frequency of the channel (in MHz)
+	u16_l freq;
+	/// RF band (@ref mac_chan_band)
+	u8_l band;
+	/// Additional information (@ref mac_chan_flags)
+	u8_l flags;
+	/// Max transmit power allowed on this channel (dBm)
+	s8_l tx_power;
+};
+
+/// Operating Channel
+struct mac_chan_op {
+	/// Band (@ref mac_chan_band)
+	u8_l band;
+	/// Channel type (@ref mac_chan_bandwidth)
+	u8_l type;
+	/// Frequency for Primary 20MHz channel (in MHz)
+	u16_l prim20_freq;
+	/// Frequency center of the contiguous channel or center of Primary 80+80
+	/// (in MHz)
+	u16_l center1_freq;
+	/// Frequency center of the non-contiguous secondary 80+80 (in MHz)
+	u16_l center2_freq;
+	/// Max transmit power allowed on this channel (dBm)
+	s8_l tx_power;
+	/// Additional information (@ref mac_chan_flags)
+	u8_l flags;
+};
+
+/// Cipher suites (order is important as it is used by MACHW)
+enum mac_cipher_suite {
+	/// 00-0F-AC 1
+	MAC_CIPHER_WEP40 =3D 0,
+	/// 00-0F-AC 2
+	MAC_CIPHER_TKIP =3D 1,
+	/// 00-0F-AC 4
+	MAC_CIPHER_CCMP =3D 2,
+	/// 00-0F-AC 5
+	MAC_CIPHER_WEP104 =3D 3,
+	/// 00-14-72 1
+	MAC_CIPHER_WPI_SMS4 =3D 4,
+	/// 00-0F-AC 6  (aka AES_CMAC)
+	MAC_CIPHER_BIP_CMAC_128 =3D 5,
+
+	// following cipher are not supported by MACHW
+	/// 00-0F-AC 08
+	MAC_CIPHER_GCMP_128,
+	/// 00-0F-AC 09
+	MAC_CIPHER_GCMP_256,
+	/// 00-0F-AC 10
+	MAC_CIPHER_CCMP_256,
+	/// 00-0F-AC 11
+	MAC_CIPHER_BIP_GMAC_128,
+	/// 00-0F-AC 12
+	MAC_CIPHER_BIP_GMAC_256,
+	/// 00-0F-AC 13
+	MAC_CIPHER_BIP_CMAC_256,
+
+	MAC_CIPHER_INVALID =3D 0xFF
+};
+
+/// Authentication and Key Management suite
+enum mac_akm_suite {
+	/// No security
+	MAC_AKM_NONE,
+	/// Pre RSN (WEP or WPA)
+	MAC_AKM_PRE_RSN,
+	/// 00-0F-AC 1
+	MAC_AKM_8021X,
+	/// 00-0F-AC 2
+	MAC_AKM_PSK,
+	/// 00-0F-AC 3
+	MAC_AKM_FT_8021X,
+	/// 00-0F-AC 4
+	MAC_AKM_FT_PSK,
+	/// 00-0F-AC 5
+	MAC_AKM_8021X_SHA256,
+	/// 00-0F-AC 6
+	MAC_AKM_PSK_SHA256,
+	/// 00-0F-AC 7
+	MAC_AKM_TDLS,
+	/// 00-0F-AC 8
+	MAC_AKM_SAE,
+	/// 00-0F-AC 9
+	MAC_AKM_FT_OVER_SAE,
+	/// 00-0F-AC 11
+	MAC_AKM_8021X_SUITE_B,
+	/// 00-0F-AC 12
+	MAC_AKM_8021X_SUITE_B_192,
+	/// 00-0F-AC 14
+	MAC_AKM_FILS_SHA256,
+	/// 00-0F-AC 15
+	MAC_AKM_FILS_SHA384,
+	/// 00-0F-AC 16
+	MAC_AKM_FT_FILS_SHA256,
+	/// 00-0F-AC 17
+	MAC_AKM_FT_FILS_SHA384,
+	/// 00-0F-AC 18
+	MAC_AKM_OWE,
+
+	/// 00-14-72 1
+	MAC_AKM_WAPI_CERT,
+	/// 00-14-72 2
+	MAC_AKM_WAPI_PSK,
+};
+
+/// Scan result element, parsed from beacon or probe response frames.
+struct mac_scan_result {
+	/// Scan result is valid
+	bool valid_flag;
+	/// Network BSSID.
+	struct mac_addr bssid;
+	/// Network name.
+	struct mac_ssid ssid;
+	/// Network type (@ref mac_bss_type).
+	u16_l bsstype;
+	/// Network channel.
+	struct mac_chan_def *chan;
+	/// Network beacon period (in TU).
+	u16_l beacon_period;
+	/// Capability information
+	u16_l cap_info;
+	/// Supported AKM (bit-field of @ref mac_akm_suite)
+	u32_l akm;
+	/// Group cipher (bit-field of @ref mac_cipher_suite)
+	u16_l group_cipher;
+	/// Group cipher (bit-field of @ref mac_cipher_suite)
+	u16_l pairwise_cipher;
+	/// RSSI of the scanned BSS (in dBm)
+	s8_l rssi;
+};
+
+/// Legacy rate 802.11 definitions
+enum mac_legacy_rates {
+	/// DSSS/CCK 1Mbps
+	MAC_RATE_1MBPS =3D 2,
+	/// DSSS/CCK 2Mbps
+	MAC_RATE_2MBPS =3D 4,
+	/// DSSS/CCK 5.5Mbps
+	MAC_RATE_5_5MBPS =3D 11,
+	/// OFDM 6Mbps
+	MAC_RATE_6MBPS =3D 12,
+	/// OFDM 9Mbps
+	MAC_RATE_9MBPS =3D 18,
+	/// DSSS/CCK 11Mbps
+	MAC_RATE_11MBPS =3D 22,
+	/// OFDM 12Mbps
+	MAC_RATE_12MBPS =3D 24,
+	/// OFDM 18Mbps
+	MAC_RATE_18MBPS =3D 36,
+	/// OFDM 24Mbps
+	MAC_RATE_24MBPS =3D 48,
+	/// OFDM 36Mbps
+	MAC_RATE_36MBPS =3D 72,
+	/// OFDM 48Mbps
+	MAC_RATE_48MBPS =3D 96,
+	/// OFDM 54Mbps
+	MAC_RATE_54MBPS =3D 108
+};
+
+/// BSS Membership Selector definitions
+enum mac_bss_membership {
+	/// HT PHY
+	MAC_BSS_MEMBERSHIP_HT_PHY =3D 127,
+	/// VHT PHY
+	MAC_BSS_MEMBERSHIP_VHT_PHY =3D 126,
+};
+
+/// MAC rateset maximum length
+#define MAC_RATESET_LEN 12
+
+/// Structure containing the legacy rateset of a station
+struct mac_rateset {
+	/// Number of legacy rates supported
+	u8_l length;
+	/// Array of legacy rates
+	u8_l array[MAC_RATESET_LEN];
+};
+
+/// MAC Security Key maximum length
+#define MAC_SEC_KEY_LEN 32 // TKIP keys 256 bits (max length) with MIC key=
s
+
+/// Structure defining a security key
+struct mac_sec_key {
+	/// Key material length
+	u8_l length;
+	/// Key material
+	u32_l array[MAC_SEC_KEY_LEN / 4];
+};
+
+/// Access Category enumeration
+enum mac_ac {
+	/// Background
+	AC_BK =3D 0,
+	/// Best-effort
+	AC_BE,
+	/// Video
+	AC_VI,
+	/// Voice
+	AC_VO,
+	/// Number of access categories
+	AC_MAX
+};
+
+/// Traffic ID enumeration
+enum mac_tid {
+	/// TID_0. Mapped to @ref AC_BE as per 802.11 standard.
+	TID_0,
+	/// TID_1. Mapped to @ref AC_BK as per 802.11 standard.
+	TID_1,
+	/// TID_2. Mapped to @ref AC_BK as per 802.11 standard.
+	TID_2,
+	/// TID_3. Mapped to @ref AC_BE as per 802.11 standard.
+	TID_3,
+	/// TID_4. Mapped to @ref AC_VI as per 802.11 standard.
+	TID_4,
+	/// TID_5. Mapped to @ref AC_VI as per 802.11 standard.
+	TID_5,
+	/// TID_6. Mapped to @ref AC_VO as per 802.11 standard.
+	TID_6,
+	/// TID_7. Mapped to @ref AC_VO as per 802.11 standard.
+	TID_7,
+	/// Non standard Management TID used internally
+	TID_MGT,
+	/// Number of TID supported
+	TID_MAX
+};
+
+/// MCS bitfield maximum size (in bytes)
+#define MAX_MCS_LEN 16 // 16 * 8 =3D 128
+
+/// MAC HT capability information element
+struct mac_htcapability {
+	/// HT capability information
+	u16_l ht_capa_info;
+	/// A-MPDU parameters
+	u8_l a_mpdu_param;
+	/// Supported MCS
+	u8_l mcs_rate[MAX_MCS_LEN];
+	/// HT extended capability information
+	u16_l ht_extended_capa;
+	/// Beamforming capability information
+	u32_l tx_beamforming_capa;
+	/// Antenna selection capability information
+	u8_l asel_capa;
+};
+
+/// MAC VHT capability information element
+struct mac_vhtcapability {
+	/// VHT capability information
+	u32_l vht_capa_info;
+	/// RX MCS map
+	u16_l rx_mcs_map;
+	/// RX highest data rate
+	u16_l rx_highest;
+	/// TX MCS map
+	u16_l tx_mcs_map;
+	/// TX highest data rate
+	u16_l tx_highest;
+};
+
+/// Length (in bytes) of the MAC HE capability field
+#define MAC_HE_MAC_CAPA_LEN      6
+/// Length (in bytes) of the PHY HE capability field
+#define MAC_HE_PHY_CAPA_LEN      11
+/// Maximum length (in bytes) of the PPE threshold data
+#define MAC_HE_PPE_THRES_MAX_LEN 25
+
+/// Structure listing the per-NSS, per-BW supported MCS combinations
+struct mac_he_mcs_nss_supp {
+	/// per-NSS supported MCS in RX, for BW <=3D 80MHz
+	u16_l rx_mcs_80;
+	/// per-NSS supported MCS in TX, for BW <=3D 80MHz
+	u16_l tx_mcs_80;
+	/// per-NSS supported MCS in RX, for BW =3D 160MHz
+	u16_l rx_mcs_160;
+	/// per-NSS supported MCS in TX, for BW =3D 160MHz
+	u16_l tx_mcs_160;
+	/// per-NSS supported MCS in RX, for BW =3D 80+80MHz
+	u16_l rx_mcs_80p80;
+	/// per-NSS supported MCS in TX, for BW =3D 80+80MHz
+	u16_l tx_mcs_80p80;
+};
+
+/// MAC HE capability information element
+struct mac_hecapability {
+	/// MAC HE capabilities
+	u8_l mac_cap_info[MAC_HE_MAC_CAPA_LEN];
+	/// PHY HE capabilities
+	u8_l phy_cap_info[MAC_HE_PHY_CAPA_LEN];
+	/// Supported MCS combinations
+	struct mac_he_mcs_nss_supp mcs_supp;
+	/// PPE Thresholds data
+	u8_l ppe_thres[MAC_HE_PPE_THRES_MAX_LEN];
+};
+
+/// Station flags
+enum mac_sta_flags {
+	/// Bit indicating that a STA has QoS (WMM) capability
+	STA_QOS_CAPA =3D BIT(0),
+	/// Bit indicating that a STA has HT capability
+	STA_HT_CAPA =3D BIT(1),
+	/// Bit indicating that a STA has VHT capability
+	STA_VHT_CAPA =3D BIT(2),
+	/// Bit indicating that a STA has MFP capability
+	STA_MFP_CAPA =3D BIT(3),
+	/// Bit indicating that the STA included the Operation Notification IE
+	STA_OPMOD_NOTIF =3D BIT(4),
+	/// Bit indicating that a STA has HE capability
+	STA_HE_CAPA =3D BIT(5),
+};
+
+/// Connection flags
+enum mac_connection_flags {
+	/// Flag indicating whether the control port is controlled by host or not
+	CONTROL_PORT_HOST =3D BIT(0),
+	/// Flag indicating whether the control port frame shall be sent unencryp=
ted
+	CONTROL_PORT_NO_ENC =3D BIT(1),
+	/// Flag indicating whether HT and VHT shall be disabled or not
+	DISABLE_HT =3D BIT(2),
+	/// Flag indicating whether WPA or WPA2 authentication is in use
+	WPA_WPA2_IN_USE =3D BIT(3),
+	/// Flag indicating whether MFP is in use
+	MFP_IN_USE =3D BIT(4),
+	//  Flag indicating Roam
+	REASSOCIATION =3D BIT(5),
+};
+
+#ifdef CONFIG_AIC8800_HE_FOR_OLD_KERNEL
+#define IEEE80211_HE_MAC_CAP2_ALL_ACK                                   0x=
02
+#define IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G             0x=
02
+#define IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G       0x=
04
+#define IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD                    0x=
20
+#define IEEE80211_HE_PHY_CAP1_HE_LTF_AND_GI_FOR_HE_PPDUS_0_8US          0x=
40
+#define IEEE80211_HE_PHY_CAP1_MIDAMBLE_RX_TX_MAX_NSTS                   0x=
80
+#define IEEE80211_HE_PHY_CAP2_MIDAMBLE_RX_TX_MAX_NSTS                   0x=
01
+#define IEEE80211_HE_PHY_CAP2_NDP_4x_LTF_AND_3_2US                      0x=
02
+#define IEEE80211_HE_PHY_CAP2_DOPPLER_RX                                0x=
20
+#define IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ                       0x=
08
+#define IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_16_QAM                   0x=
18
+#define IEEE80211_HE_PHY_CAP3_DCM_MAX_RX_NSS_1                          0x=
00
+#define IEEE80211_HE_PHY_CAP3_RX_HE_MU_PPDU_FROM_NON_AP_STA             0x=
40
+#define IEEE80211_HE_PHY_CAP4_SU_BEAMFORMEE                             0x=
01
+#define IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_4          0x=
0c
+#define IEEE80211_HE_PHY_CAP5_NG16_SU_FEEDBACK                          0x=
40
+#define IEEE80211_HE_PHY_CAP5_NG16_MU_FEEDBACK                          0x=
80
+#define IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_42_SU                       0x=
01
+#define IEEE80211_HE_PHY_CAP6_CODEBOOK_SIZE_75_MU                       0x=
02
+#define IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB                     0x=
04
+#define IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB                     0x=
08
+#define IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT                     0x=
80
+#define IEEE80211_HE_PHY_CAP6_PARTIAL_BANDWIDTH_DL_MUMIMO               0x=
40
+#define IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI          0x=
04
+#define IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G              0x=
02
+#define IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_COMP_SIGB     0x=
10
+#define IEEE80211_HE_PHY_CAP9_RX_FULL_BW_SU_USING_MU_WITH_NON_COMP_SIGB 0x=
20
+
+#define IEEE80211_HE_PPE_THRES_MAX_LEN 25
+
+#include <linux/ieee80211.h>
+#endif
+#endif // LMAC_MAC_H_
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/lmac_msg.h b/drivers/net=
/wireless/aic/aic8800_fdrv/lmac_msg.h
new file mode 100644
index 0000000000000..6013e78448a91
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/lmac_msg.h
@@ -0,0 +1,3124 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief Main definitions for message exchanges with LMAC
+ *
+ *************************************************************************=
***************
+ */
+
+#ifndef LMAC_MSG_H_
+#define LMAC_MSG_H_
+
+#include "lmac_mac.h"
+
+/* Task identifiers for communication between LMAC and DRIVER */
+enum {
+	TASK_NONE =3D (u8_l)-1,
+
+	// MAC Management task.
+	TASK_MM =3D 0,
+	// DEBUG task
+	TASK_DBG,
+	/// SCAN task
+	TASK_SCAN,
+	/// TDLS task
+	TASK_TDLS,
+	/// SCANU task
+	TASK_SCANU,
+	/// ME task
+	TASK_ME,
+	/// SM task
+	TASK_SM,
+	/// APM task
+	TASK_APM,
+	/// BAM task
+	TASK_BAM,
+	/// MESH task
+	TASK_MESH,
+	/// RXU task
+	TASK_RXU,
+	/// RM_task
+	TASK_RM,
+	/// TWT task
+	TASK_TWT,
+#if defined CONFIG_RWNX_FULLMAC
+	// This is used to define the last task that is running on the EMB proces=
sor
+	TASK_LAST_EMB =3D TASK_TWT,
+#else
+#error "Need to define SOFTMAC or FULLMAC"
+#endif
+	// nX API task
+	TASK_API,
+	TASK_MAX,
+};
+
+/// For MAC HW States copied from "hal_machw.h"
+enum {
+	/// MAC HW IDLE State.
+	HW_IDLE =3D 0,
+	/// MAC HW RESERVED State.
+	HW_RESERVED,
+	/// MAC HW DOZE State.
+	HW_DOZE,
+	/// MAC HW ACTIVE State.
+	HW_ACTIVE
+};
+
+/// Power Save mode setting
+enum mm_ps_mode_state {
+	MM_PS_MODE_OFF,
+	MM_PS_MODE_ON,
+	MM_PS_MODE_ON_DYN,
+};
+
+/// Status/error codes used in the MAC software.
+enum {
+	CO_OK,
+	CO_FAIL,
+	CO_EMPTY,
+	CO_FULL,
+	CO_BAD_PARAM,
+	CO_NOT_FOUND,
+	CO_NO_MORE_ELT_AVAILABLE,
+	CO_NO_ELT_IN_USE,
+	CO_BUSY,
+	CO_OP_IN_PROGRESS,
+};
+
+/// Remain on channel operation codes
+enum mm_remain_on_channel_op {
+	MM_ROC_OP_START =3D 0,
+	MM_ROC_OP_CANCEL,
+};
+
+#define DRV_TASK_ID 100
+
+/// Message Identifier. The number of messages is limited to 0xFFFF.
+/// The message ID is divided in two parts:
+/// - bits[15..10] : task index (no more than 64 tasks supported).
+/// - bits[9..0] : message index (no more that 1024 messages per task).
+typedef u16 lmac_msg_id_t;
+
+typedef u16 lmac_task_id_t;
+
+/// Build the first message ID of a task.
+#define LMAC_FIRST_MSG(task) ((lmac_msg_id_t)((task) << 10))
+
+#define MSG_T(msg) ((lmac_task_id_t)((msg) >> 10))
+#define MSG_I(msg) ((msg) & ((1 << 10) - 1))
+
+/// Message structure.
+struct lmac_msg {
+	lmac_msg_id_t id;       ///< Message id.
+	lmac_task_id_t dest_id; ///< Destination kernel identifier.
+	lmac_task_id_t src_id;  ///< Source kernel identifier.
+	u16 param_len;          ///< Parameter embedded struct length.
+	u32 param[]; ///< Parameter embedded struct. Must be word-aligned.
+};
+
+/// List of messages related to the task.
+enum mm_msg_tag {
+	/// RESET Request.
+	MM_RESET_REQ =3D LMAC_FIRST_MSG(TASK_MM),
+	/// RESET Confirmation.
+	MM_RESET_CFM,
+	/// START Request.
+	MM_START_REQ,
+	/// START Confirmation.
+	MM_START_CFM,
+	/// Read Version Request.
+	MM_VERSION_REQ,
+	/// Read Version Confirmation.
+	MM_VERSION_CFM,
+	/// ADD INTERFACE Request.
+	MM_ADD_IF_REQ,
+	/// ADD INTERFACE Confirmation.
+	MM_ADD_IF_CFM,
+	/// REMOVE INTERFACE Request.
+	MM_REMOVE_IF_REQ,
+	/// REMOVE INTERFACE Confirmation.
+	MM_REMOVE_IF_CFM,
+	/// STA ADD Request.
+	MM_STA_ADD_REQ,
+	/// STA ADD Confirm.
+	MM_STA_ADD_CFM,
+	/// STA DEL Request.
+	MM_STA_DEL_REQ,
+	/// STA DEL Confirm.
+	MM_STA_DEL_CFM,
+	/// RX FILTER CONFIGURATION Request.
+	MM_SET_FILTER_REQ,
+	/// RX FILTER CONFIGURATION Confirmation.
+	MM_SET_FILTER_CFM,
+	/// CHANNEL CONFIGURATION Request.
+	MM_SET_CHANNEL_REQ,
+	/// CHANNEL CONFIGURATION Confirmation.
+	MM_SET_CHANNEL_CFM,
+	/// DTIM PERIOD CONFIGURATION Request.
+	MM_SET_DTIM_REQ,
+	/// DTIM PERIOD CONFIGURATION Confirmation.
+	MM_SET_DTIM_CFM,
+	/// BEACON INTERVAL CONFIGURATION Request.
+	MM_SET_BEACON_INT_REQ,
+	/// BEACON INTERVAL CONFIGURATION Confirmation.
+	MM_SET_BEACON_INT_CFM,
+	/// BASIC RATES CONFIGURATION Request.
+	MM_SET_BASIC_RATES_REQ,
+	/// BASIC RATES CONFIGURATION Confirmation.
+	MM_SET_BASIC_RATES_CFM,
+	/// BSSID CONFIGURATION Request.
+	MM_SET_BSSID_REQ,
+	/// BSSID CONFIGURATION Confirmation.
+	MM_SET_BSSID_CFM,
+	/// EDCA PARAMETERS CONFIGURATION Request.
+	MM_SET_EDCA_REQ,
+	/// EDCA PARAMETERS CONFIGURATION Confirmation.
+	MM_SET_EDCA_CFM,
+	/// ABGN MODE CONFIGURATION Request.
+	MM_SET_MODE_REQ,
+	/// ABGN MODE CONFIGURATION Confirmation.
+	MM_SET_MODE_CFM,
+	/// Request setting the VIF active state (i.e associated or AP started)
+	MM_SET_VIF_STATE_REQ,
+	/// Confirmation of the @ref MM_SET_VIF_STATE_REQ message.
+	MM_SET_VIF_STATE_CFM,
+	/// SLOT TIME PARAMETERS CONFIGURATION Request.
+	MM_SET_SLOTTIME_REQ,
+	/// SLOT TIME PARAMETERS CONFIGURATION Confirmation.
+	MM_SET_SLOTTIME_CFM,
+	/// Power Mode Change Request.
+	MM_SET_IDLE_REQ,
+	/// Power Mode Change Confirm.
+	MM_SET_IDLE_CFM,
+	/// KEY ADD Request.
+	MM_KEY_ADD_REQ,
+	/// KEY ADD Confirm.
+	MM_KEY_ADD_CFM,
+	/// KEY DEL Request.
+	MM_KEY_DEL_REQ,
+	/// KEY DEL Confirm.
+	MM_KEY_DEL_CFM,
+	/// Block Ack agreement info addition
+	MM_BA_ADD_REQ,
+	/// Block Ack agreement info addition confirmation
+	MM_BA_ADD_CFM,
+	/// Block Ack agreement info deletion
+	MM_BA_DEL_REQ,
+	/// Block Ack agreement info deletion confirmation
+	MM_BA_DEL_CFM,
+	/// Indication of the primary TBTT to the upper MAC. Upon the reception o=
f
+	/// this
+	// message the upper MAC has to push the beacon(s) to the beacon
+	// transmission queue.
+	MM_PRIMARY_TBTT_IND,
+	/// Indication of the secondary TBTT to the upper MAC. Upon the reception=
 of
+	/// this
+	// message the upper MAC has to push the beacon(s) to the beacon
+	// transmission queue.
+	MM_SECONDARY_TBTT_IND,
+	/// Request for changing the TX power
+	MM_SET_POWER_REQ,
+	/// Confirmation of the TX power change
+	MM_SET_POWER_CFM,
+	/// Request to the LMAC to trigger the embedded logic analyzer and forwar=
d
+	/// the debug
+	/// dump.
+	MM_DBG_TRIGGER_REQ,
+	/// Set Power Save mode
+	MM_SET_PS_MODE_REQ,
+	/// Set Power Save mode confirmation
+	MM_SET_PS_MODE_CFM,
+	/// Request to add a channel context
+	MM_CHAN_CTXT_ADD_REQ,
+	/// Confirmation of the channel context addition
+	MM_CHAN_CTXT_ADD_CFM,
+	/// Request to delete a channel context
+	MM_CHAN_CTXT_DEL_REQ,
+	/// Confirmation of the channel context deletion
+	MM_CHAN_CTXT_DEL_CFM,
+	/// Request to link a channel context to a VIF
+	MM_CHAN_CTXT_LINK_REQ,
+	/// Confirmation of the channel context link
+	MM_CHAN_CTXT_LINK_CFM,
+	/// Request to unlink a channel context from a VIF
+	MM_CHAN_CTXT_UNLINK_REQ,
+	/// Confirmation of the channel context unlink
+	MM_CHAN_CTXT_UNLINK_CFM,
+	/// Request to update a channel context
+	MM_CHAN_CTXT_UPDATE_REQ,
+	/// Confirmation of the channel context update
+	MM_CHAN_CTXT_UPDATE_CFM,
+	/// Request to schedule a channel context
+	MM_CHAN_CTXT_SCHED_REQ,
+	/// Confirmation of the channel context scheduling
+	MM_CHAN_CTXT_SCHED_CFM,
+	/// Request to change the beacon template in LMAC
+	MM_BCN_CHANGE_REQ,
+	/// Confirmation of the beacon change
+	MM_BCN_CHANGE_CFM,
+	/// Request to update the TIM in the beacon (i.e to indicate traffic
+	/// bufferized at AP)
+	MM_TIM_UPDATE_REQ,
+	/// Confirmation of the TIM update
+	MM_TIM_UPDATE_CFM,
+	/// Connection loss indication
+	MM_CONNECTION_LOSS_IND,
+	/// Channel context switch indication to the upper layers
+	MM_CHANNEL_SWITCH_IND,
+	/// Channel context pre-switch indication to the upper layers
+	MM_CHANNEL_PRE_SWITCH_IND,
+	/// Request to remain on channel or cancel remain on channel
+	MM_REMAIN_ON_CHANNEL_REQ,
+	/// Confirmation of the (cancel) remain on channel request
+	MM_REMAIN_ON_CHANNEL_CFM,
+	/// Remain on channel expired indication
+	MM_REMAIN_ON_CHANNEL_EXP_IND,
+	/// Indication of a PS state change of a peer device
+	MM_PS_CHANGE_IND,
+	/// Indication that some buffered traffic should be sent to the peer devi=
ce
+	MM_TRAFFIC_REQ_IND,
+	/// Request to modify the STA Power-save mode options
+	MM_SET_PS_OPTIONS_REQ,
+	/// Confirmation of the PS options setting
+	MM_SET_PS_OPTIONS_CFM,
+	/// Indication of PS state change for a P2P VIF
+	MM_P2P_VIF_PS_CHANGE_IND,
+	/// Indication that CSA counter has been updated
+	MM_CSA_COUNTER_IND,
+	/// Channel occupation report indication
+	MM_CHANNEL_SURVEY_IND,
+	/// Message containing Beamformer Information
+	MM_BFMER_ENABLE_REQ,
+	/// Request to Start/Stop/Update NOA - GO Only
+	MM_SET_P2P_NOA_REQ,
+	/// Request to Start/Stop/Update Opportunistic PS - GO Only
+	MM_SET_P2P_OPPPS_REQ,
+	/// Start/Stop/Update NOA Confirmation
+	MM_SET_P2P_NOA_CFM,
+	/// Start/Stop/Update Opportunistic PS Confirmation
+	MM_SET_P2P_OPPPS_CFM,
+	/// P2P NoA Update Indication - GO Only
+	MM_P2P_NOA_UPD_IND,
+	/// Request to set RSSI threshold and RSSI hysteresis
+	MM_CFG_RSSI_REQ,
+	/// Indication that RSSI level is below or above the threshold
+	MM_RSSI_STATUS_IND,
+	/// Indication that CSA is done
+	MM_CSA_FINISH_IND,
+	/// Indication that CSA is in prorgess (resp. done) and traffic must be
+	/// stopped (resp. restarted)
+	MM_CSA_TRAFFIC_IND,
+	/// Request to update the group information of a station
+	MM_MU_GROUP_UPDATE_REQ,
+	/// Confirmation of the @ref MM_MU_GROUP_UPDATE_REQ message
+	MM_MU_GROUP_UPDATE_CFM,
+	/// Request to initialize the antenna diversity algorithm
+	MM_ANT_DIV_INIT_REQ,
+	/// Request to stop the antenna diversity algorithm
+	MM_ANT_DIV_STOP_REQ,
+	/// Request to update the antenna switch status
+	MM_ANT_DIV_UPDATE_REQ,
+	/// Request to switch the antenna connected to path_0
+	MM_SWITCH_ANTENNA_REQ,
+	/// Indication that a packet loss has occurred
+	MM_PKTLOSS_IND,
+
+	MM_SET_ARPOFFLOAD_REQ,
+	MM_SET_ARPOFFLOAD_CFM,
+	MM_SET_AGG_DISABLE_REQ,
+	MM_SET_AGG_DISABLE_CFM,
+	MM_SET_COEX_REQ,
+	MM_SET_COEX_CFM,
+	MM_SET_RF_CONFIG_REQ,
+	MM_SET_RF_CONFIG_CFM,
+	MM_SET_RF_CALIB_REQ,
+	MM_SET_RF_CALIB_CFM,
+
+	/// MU EDCA PARAMETERS Configuration Request.
+	MM_SET_MU_EDCA_REQ,
+	/// MU EDCA PARAMETERS Configuration Confirmation.
+	MM_SET_MU_EDCA_CFM,
+	/// UORA PARAMETERS Configuration Request.
+	MM_SET_UORA_REQ,
+	/// UORA PARAMETERS Configuration Confirmation.
+	MM_SET_UORA_CFM,
+	/// TXOP RTS THRESHOLD Configuration Request.
+	MM_SET_TXOP_RTS_THRES_REQ,
+	/// TXOP RTS THRESHOLD Configuration Confirmation.
+	MM_SET_TXOP_RTS_THRES_CFM,
+	/// HE BSS Color Configuration Request.
+	MM_SET_BSS_COLOR_REQ,
+	/// HE BSS Color Configuration Confirmation.
+	MM_SET_BSS_COLOR_CFM,
+
+	MM_GET_MAC_ADDR_REQ,
+	MM_GET_MAC_ADDR_CFM,
+
+	MM_GET_STA_INFO_REQ,
+	MM_GET_STA_INFO_CFM,
+
+	MM_SET_TXPWR_IDX_LVL_REQ,
+	MM_SET_TXPWR_IDX_LVL_CFM,
+
+	MM_SET_TXPWR_OFST_REQ,
+	MM_SET_TXPWR_OFST_CFM,
+
+	MM_SET_STACK_START_REQ,
+	MM_SET_STACK_START_CFM,
+
+	MM_APM_STALOSS_IND,
+
+	MM_SET_VENDOR_HWCONFIG_REQ,
+	MM_SET_VENDOR_HWCONFIG_CFM,
+
+	MM_GET_FW_VERSION_REQ,
+	MM_GET_FW_VERSION_CFM,
+
+	MM_SET_RESUME_RESTORE_REQ,
+	MM_SET_RESUME_RESTORE_CFM,
+
+	MM_GET_WIFI_DISABLE_REQ,
+	MM_GET_WIFI_DISABLE_CFM,
+
+	MM_CFG_RSSI_CFM,
+
+	MM_SET_VENDOR_SWCONFIG_REQ,
+	MM_SET_VENDOR_SWCONFIG_CFM,
+
+	MM_SET_TXPWR_LVL_ADJ_REQ,
+	MM_SET_TXPWR_LVL_ADJ_CFM,
+
+	MM_RADAR_DETECT_IND,
+
+	MM_SET_APF_PROG_REQ,
+	MM_SET_APF_PROG_CFM,
+
+	MM_GET_APF_PROG_REQ,
+	MM_GET_APF_PROG_CFM,
+
+	/// arp announcement frame reception indication
+	MM_ARP_ANNOUNCEMENT_IND,
+
+	/// MAX number of messages
+	MM_MAX,
+};
+
+/// Interface types
+enum {
+	/// ESS STA interface
+	MM_STA,
+	/// IBSS STA interface
+	MM_IBSS,
+	/// AP interface
+	MM_AP,
+	// Mesh Point interface
+	MM_MESH_POINT,
+	// Monitor interface
+	MM_MONITOR,
+};
+
+/// BA agreement types
+enum {
+	/// BlockAck agreement for TX
+	BA_AGMT_TX,
+	/// BlockAck agreement for RX
+	BA_AGMT_RX,
+};
+
+/// BA agreement related status
+enum {
+	/// Correct BA agreement establishment
+	BA_AGMT_ESTABLISHED,
+	/// BA agreement already exists for STA+TID requested, cannot override it
+	/// (should have been deleted first)
+	BA_AGMT_ALREADY_EXISTS,
+	/// Correct BA agreement deletion
+	BA_AGMT_DELETED,
+	/// BA agreement for the (STA, TID) doesn't exist so nothing to delete
+	BA_AGMT_DOESNT_EXIST,
+};
+
+/// Features supported by LMAC - Positions
+enum mm_features {
+	/// Beaconing
+	MM_FEAT_BCN_BIT =3D 0,
+	/*
+	 *	/// Autonomous Beacon Transmission
+	 *	MM_FEAT_AUTOBCN_BIT,
+	 *	/// Scan in LMAC
+	 *	MM_FEAT_HWSCAN_BIT,
+	 *	/// Connection Monitoring
+	 *	MM_FEAT_CMON_BIT,
+	 *	/// Multi Role
+	 *	MM_FEAT_MROLE_BIT,
+	 */
+	/// Radar Detection
+	MM_FEAT_RADAR_BIT,
+	/// Power Save
+	MM_FEAT_PS_BIT,
+	/// UAPSD
+	MM_FEAT_UAPSD_BIT,
+	/// DPSM
+	//  MM_FEAT_DPSM_BIT,
+	/// A-MPDU
+	MM_FEAT_AMPDU_BIT,
+	/// A-MSDU
+	MM_FEAT_AMSDU_BIT,
+	/// Channel Context
+	//  MM_FEAT_CHNL_CTXT_BIT,
+	/// Packet reordering
+	//  MM_FEAT_REORD_BIT,
+	/// P2P
+	MM_FEAT_P2P_BIT,
+	/// P2P Go
+	MM_FEAT_P2P_GO_BIT,
+	/// UMAC Present
+	MM_FEAT_UMAC_BIT,
+	/// VHT support
+	MM_FEAT_VHT_BIT,
+	/// Beamformee
+	MM_FEAT_BFMEE_BIT,
+	/// Beamformer
+	MM_FEAT_BFMER_BIT,
+	/// WAPI
+	MM_FEAT_WAPI_BIT,
+	/// MFP
+	MM_FEAT_MFP_BIT,
+	/// Mu-MIMO RX support
+	MM_FEAT_MU_MIMO_RX_BIT,
+	/// Mu-MIMO TX support
+	MM_FEAT_MU_MIMO_TX_BIT,
+	/// Wireless Mesh Networking
+	MM_FEAT_MESH_BIT,
+	/// TDLS support
+	MM_FEAT_TDLS_BIT,
+	/// Antenna Diversity support
+	MM_FEAT_ANT_DIV_BIT,
+	/// UF support
+	MM_FEAT_UF_BIT,
+	/// A-MSDU maximum size (bit0)
+	MM_AMSDU_MAX_SIZE_BIT0,
+	/// A-MSDU maximum size (bit1)
+	MM_AMSDU_MAX_SIZE_BIT1,
+	/// MON_DATA support
+	MM_FEAT_MON_DATA_BIT,
+	/// HE (802.11ax) support
+	MM_FEAT_HE_BIT,
+	/// TWT support
+	MM_FEAT_TWT_BIT,
+};
+
+/// Maximum number of words in the configuration buffer
+#define PHY_CFG_BUF_SIZE 16
+
+/// Structure containing the parameters of the PHY configuration
+struct phy_cfg_tag {
+	/// Buffer containing the parameters specific for the PHY used
+	u32_l parameters[PHY_CFG_BUF_SIZE];
+};
+
+/// Structure containing the parameters of the Trident PHY configuration
+struct phy_trd_cfg_tag {
+	/// MDM type(nxm)(upper nibble) and MDM2RF path mapping(lower nibble)
+	u8_l path_mapping;
+	/// TX DC offset compensation
+	u32_l tx_dc_off_comp;
+};
+
+/// Structure containing the parameters of the Karst PHY configuration
+struct phy_karst_cfg_tag {
+	/// TX IQ mismatch compensation in 2.4GHz
+	u32_l tx_iq_comp_2_4G[2];
+	/// RX IQ mismatch compensation in 2.4GHz
+	u32_l rx_iq_comp_2_4G[2];
+	/// TX IQ mismatch compensation in 5GHz
+	u32_l tx_iq_comp_5G[2];
+	/// RX IQ mismatch compensation in 5GHz
+	u32_l rx_iq_comp_5G[2];
+	/// RF path used by default (0 or 1)
+	u8_l path_used;
+};
+
+/// Structure containing the parameters of the @ref MM_START_REQ message
+struct mm_start_req {
+	/// PHY configuration
+	struct phy_cfg_tag phy_cfg;
+	/// UAPSD timeout
+	u32_l uapsd_timeout;
+	/// Local LP clock accuracy (in ppm)
+	u16_l lp_clk_accuracy;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_CHANNEL_REQ mes=
sage
+struct mm_set_channel_req {
+	/// Channel information
+	struct mac_chan_op chan;
+	/// Index of the RF for which the channel has to be set (0: operating
+	/// (primary), 1: secondary RF (used for additional radar detection). Thi=
s
+	/// parameter is reserved if no secondary RF is available in the system
+	u8_l index;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_CHANNEL_CFM mes=
sage
+struct mm_set_channel_cfm {
+	/// Radio index to be used in policy table
+	u8_l radio_idx;
+	/// TX power configured (in dBm)
+	s8_l power;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_DTIM_REQ messag=
e
+struct mm_set_dtim_req {
+	/// DTIM period
+	u8_l dtim_period;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_POWER_REQ messa=
ge
+struct mm_set_power_req {
+	/// Index of the interface for which the parameter is configured
+	u8_l inst_nbr;
+	/// TX power (in dBm)
+	s8_l power;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_POWER_CFM messa=
ge
+struct mm_set_power_cfm {
+	/// Radio index to be used in policy table
+	u8_l radio_idx;
+	/// TX power configured (in dBm)
+	s8_l power;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_BEACON_INT_REQ
+/// message
+struct mm_set_beacon_int_req {
+	/// Beacon interval
+	u16_l beacon_int;
+	/// Index of the interface for which the parameter is configured
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_BASIC_RATES_REQ
+/// message
+struct mm_set_basic_rates_req {
+	/// Basic rate set (as expected by bssBasicRateSet field of Rates MAC HW
+	/// register)
+	u32_l rates;
+	/// Index of the interface for which the parameter is configured
+	u8_l inst_nbr;
+	/// Band on which the interface will operate
+	u8_l band;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_BSSID_REQ messa=
ge
+struct mm_set_bssid_req {
+	/// BSSID to be configured in HW
+	struct mac_addr bssid;
+	/// Index of the interface for which the parameter is configured
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_FILTER_REQ mess=
age
+struct mm_set_filter_req {
+	/// RX filter to be put into rxCntrlReg HW register
+	u32_l filter;
+};
+
+/// Structure containing the parameters of the @ref MM_ADD_IF_REQ message.
+struct mm_add_if_req {
+	/// Type of the interface (AP, STA, ADHOC, ...)
+	u8_l type;
+	/// MAC ADDR of the interface to start
+	struct mac_addr addr;
+	/// P2P Interface
+	bool p2p;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_EDCA_REQ messag=
e
+struct mm_set_edca_req {
+	/// EDCA parameters of the queue (as expected by edcaACxReg HW register)
+	u32_l ac_param;
+	/// Flag indicating if UAPSD can be used on this queue
+	bool uapsd;
+	/// HW queue for which the parameters are configured
+	u8_l hw_queue;
+	/// Index of the interface for which the parameters are configured
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_MU_EDCA_REQ mes=
sage
+struct mm_set_mu_edca_req {
+	/// MU EDCA parameters of the different HE queues
+	u32_l param[AC_MAX];
+};
+
+/// Structure containing the parameters of the @ref MM_SET_UORA_REQ messag=
e
+struct mm_set_uora_req {
+	/// Minimum exponent of OFDMA Contention Window.
+	u8_l eocw_min;
+	/// Maximum exponent of OFDMA Contention Window.
+	u8_l eocw_max;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_TXOP_RTS_THRES_=
REQ
+/// message
+struct mm_set_txop_rts_thres_req {
+	/// TXOP RTS threshold
+	u16_l txop_dur_rts_thres;
+	/// Index of the interface for which the parameter is configured
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_BSS_COLOR_REQ m=
essage
+struct mm_set_bss_color_req {
+	/// HE BSS color, formatted as per BSS_COLOR MAC HW register
+	u32_l bss_color;
+};
+
+struct mm_set_idle_req {
+	u8_l hw_idle;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_SLOTTIME_REQ me=
ssage
+struct mm_set_slottime_req {
+	/// Slot time expressed in us
+	u8_l slottime;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_MODE_REQ messag=
e
+struct mm_set_mode_req {
+	/// abgnMode field of macCntrl1Reg register
+	u8_l abgnmode;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_VIF_STATE_REQ m=
essage
+struct mm_set_vif_state_req {
+	/// Association Id received from the AP (valid only if the VIF is of STA
+	/// type)
+	u16_l aid;
+	/// Flag indicating if the VIF is active or not
+	bool active;
+	/// Interface index
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_ADD_IF_CFM message.
+struct mm_add_if_cfm {
+	/// Status of operation (different from 0 if unsuccessful)
+	u8_l status;
+	/// Interface index assigned by the LMAC
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_REMOVE_IF_REQ messa=
ge.
+struct mm_remove_if_req {
+	/// Interface index assigned by the LMAC
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_VERSION_CFM message=
.
+struct mm_version_cfm {
+	/// Version of the LMAC FW
+	u32_l version_lmac;
+	/// Version1 of the MAC HW (as encoded in version1Reg MAC HW register)
+	u32_l version_machw_1;
+	/// Version2 of the MAC HW (as encoded in version2Reg MAC HW register)
+	u32_l version_machw_2;
+	/// Version1 of the PHY (depends on actual PHY)
+	u32_l version_phy_1;
+	/// Version2 of the PHY (depends on actual PHY)
+	u32_l version_phy_2;
+	/// Supported Features
+	u32_l features;
+	/// Maximum number of supported stations
+	u16_l max_sta_nb;
+	/// Maximum number of supported virtual interfaces
+	u8_l max_vif_nb;
+};
+
+/// Structure containing the parameters of the @ref MM_STA_ADD_REQ message=
.
+struct mm_sta_add_req {
+	/// Bitfield showing some capabilities of the STA (@ref enum mac_sta_flag=
s)
+	u32_l capa_flags;
+	/// Maximum A-MPDU size, in bytes, for HE frames
+	u32_l ampdu_size_max_he;
+	/// Maximum A-MPDU size, in bytes, for VHT frames
+	u32_l ampdu_size_max_vht;
+	/// PAID/GID
+	u32_l paid_gid;
+	/// Maximum A-MPDU size, in bytes, for HT frames
+	u16_l ampdu_size_max_ht;
+	/// MAC address of the station to be added
+	struct mac_addr mac_addr;
+	/// A-MPDU spacing, in us
+	u8_l ampdu_spacing_min;
+	/// Interface index
+	u8_l inst_nbr;
+	/// TDLS station
+	bool tdls_sta;
+	/// Indicate if the station is TDLS link initiator station
+	bool tdls_sta_initiator;
+	/// Indicate if the TDLS Channel Switch is allowed
+	bool tdls_chsw_allowed;
+	/// nonTransmitted BSSID index, set to the BSSID index in case the STA ad=
ded
+	/// is an AP that is a nonTransmitted BSSID. Should be set to 0 otherwise
+	u8_l bssid_index;
+	/// Maximum BSSID indicator, valid if the STA added is an AP that is a
+	/// nonTransmitted BSSID
+	u8_l max_bssid_ind;
+};
+
+/// Structure containing the parameters of the @ref MM_STA_ADD_CFM message=
.
+struct mm_sta_add_cfm {
+	/// Status of the operation (different from 0 if unsuccessful)
+	u8_l status;
+	/// Index assigned by the LMAC to the newly added station
+	u8_l sta_idx;
+	/// MAC HW index of the newly added station
+	u8_l hw_sta_idx;
+};
+
+/// Structure containing the parameters of the @ref MM_STA_DEL_REQ message=
.
+struct mm_sta_del_req {
+	/// Index of the station to be deleted
+	u8_l sta_idx;
+};
+
+/// Structure containing the parameters of the @ref MM_STA_DEL_CFM message=
.
+struct mm_sta_del_cfm {
+	/// Status of the operation (different from 0 if unsuccessful)
+	u8_l status;
+};
+
+/// Structure containing the parameters of the SET_POWER_MODE REQ message.
+struct mm_setpowermode_req {
+	u8_l mode;
+	u8_l sta_idx;
+};
+
+/// Structure containing the parameters of the SET_POWER_MODE CFM message.
+struct mm_setpowermode_cfm {
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref MM_KEY_ADD REQ message=
.
+struct mm_key_add_req {
+	/// Key index (valid only for default keys)
+	u8_l key_idx;
+	/// STA index (valid only for pairwise or mesh group keys)
+	u8_l sta_idx;
+	/// Key material
+	struct mac_sec_key key;
+	/// Cipher suite (WEP64, WEP128, TKIP, CCMP)
+	u8_l cipher_suite;
+	/// Index of the interface for which the key is set (valid only for defau=
lt
+	/// keys or mesh group keys)
+	u8_l inst_nbr;
+	/// A-MSDU SPP parameter
+	u8_l spp;
+	/// Indicate if provided key is a pairwise key or not
+	bool pairwise;
+};
+
+/// Structure containing the parameters of the @ref MM_KEY_ADD_CFM message=
.
+struct mm_key_add_cfm {
+	/// Status of the operation (different from 0 if unsuccessful)
+	u8_l status;
+	/// HW index of the key just added
+	u8_l hw_key_idx;
+};
+
+/// Structure containing the parameters of the @ref MM_KEY_DEL_REQ message=
.
+struct mm_key_del_req {
+	/// HW index of the key to be deleted
+	u8_l hw_key_idx;
+};
+
+/// Structure containing the parameters of the @ref MM_BA_ADD_REQ message.
+struct mm_ba_add_req {
+	/// Type of agreement (0: TX, 1: RX)
+	u8_l type;
+	/// Index of peer station with which the agreement is made
+	u8_l sta_idx;
+	/// TID for which the agreement is made with peer station
+	u8_l tid;
+	/// Buffer size - number of MPDUs that can be held in its buffer per TID
+	u8_l bufsz;
+	/// Start sequence number negotiated during BA setup - the one in first
+	/// aggregated MPDU counts more
+	u16_l ssn;
+};
+
+/// Structure containing the parameters of the @ref MM_BA_ADD_CFM message.
+struct mm_ba_add_cfm {
+	/// Index of peer station for which the agreement is being confirmed
+	u8_l sta_idx;
+	/// TID for which the agreement is being confirmed
+	u8_l tid;
+	/// Status of ba establishment
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref MM_BA_DEL_REQ message.
+struct mm_ba_del_req {
+	/// Type of agreement (0: TX, 1: RX)
+	u8_l type;
+	/// Index of peer station for which the agreement is being deleted
+	u8_l sta_idx;
+	/// TID for which the agreement is being deleted
+	u8_l tid;
+};
+
+/// Structure containing the parameters of the @ref MM_BA_DEL_CFM message.
+struct mm_ba_del_cfm {
+	/// Index of peer station for which the agreement deletion is being
+	/// confirmed
+	u8_l sta_idx;
+	/// TID for which the agreement deletion is being confirmed
+	u8_l tid;
+	/// Status of ba deletion
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref MM_CHAN_CTXT_ADD_REQ m=
essage
+struct mm_chan_ctxt_add_req {
+	/// Operating channel
+	struct mac_chan_op chan;
+};
+
+/// Structure containing the parameters of the @ref MM_CHAN_CTXT_ADD_REQ m=
essage
+struct mm_chan_ctxt_add_cfm {
+	/// Status of the addition
+	u8_l status;
+	/// Index of the new channel context
+	u8_l index;
+};
+
+/// Structure containing the parameters of the @ref MM_CHAN_CTXT_DEL_REQ m=
essage
+struct mm_chan_ctxt_del_req {
+	/// Index of the new channel context to be deleted
+	u8_l index;
+};
+
+/// Structure containing the parameters of the @ref MM_CHAN_CTXT_LINK_REQ
+/// message
+struct mm_chan_ctxt_link_req {
+	/// VIF index
+	u8_l vif_index;
+	/// Channel context index
+	u8_l chan_index;
+	/// Indicate if this is a channel switch (unlink current ctx first if tru=
e)
+	u8_l chan_switch;
+};
+
+/// Structure containing the parameters of the @ref MM_CHAN_CTXT_UNLINK_RE=
Q
+/// message
+struct mm_chan_ctxt_unlink_req {
+	/// VIF index
+	u8_l vif_index;
+};
+
+/// Structure containing the parameters of the @ref MM_CHAN_CTXT_UPDATE_RE=
Q
+/// message
+struct mm_chan_ctxt_update_req {
+	/// Channel context index
+	u8_l chan_index;
+	/// New channel information
+	struct mac_chan_op chan;
+};
+
+/// Structure containing the parameters of the @ref MM_CHAN_CTXT_SCHED_REQ
+/// message
+struct mm_chan_ctxt_sched_req {
+	/// VIF index
+	u8_l vif_index;
+	/// Channel context index
+	u8_l chan_index;
+	/// Type of the scheduling request (0: normal scheduling, 1: derogatory
+	/// scheduling)
+	u8_l type;
+};
+
+/// Structure containing the parameters of the @ref MM_CHANNEL_SWITCH_IND
+/// message
+struct mm_channel_switch_ind {
+	/// Index of the channel context we will switch to
+	u8_l chan_index;
+	/// Indicate if the switch has been triggered by a Remain on channel requ=
est
+	bool roc;
+	/// VIF on which remain on channel operation has been started (if roc =3D=
=3D 1)
+	u8_l vif_index;
+	/// Indicate if the switch has been triggered by a TDLS Remain on channel
+	/// request
+	bool roc_tdls;
+};
+
+/// Structure containing the parameters of the @ref MM_CHANNEL_PRE_SWITCH_=
IND
+/// message
+struct mm_channel_pre_switch_ind {
+	/// Index of the channel context we will switch to
+	u8_l chan_index;
+};
+
+/// Structure containing the parameters of the @ref MM_CONNECTION_LOSS_IND
+/// message.
+struct mm_connection_loss_ind {
+	/// VIF instance number
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_DBG_TRIGGER_REQ mes=
sage.
+struct mm_dbg_trigger_req {
+	/// Error trace to be reported by the LMAC
+	char error[64];
+};
+
+/// Structure containing the parameters of the @ref MM_SET_PS_MODE_REQ mes=
sage.
+struct mm_set_ps_mode_req {
+	/// Power Save is activated or deactivated
+	u8_l new_state;
+};
+
+/// Structure containing the parameters of the @ref MM_BCN_CHANGE_REQ mess=
age.
+#define BCN_MAX_CSA_CPT 2
+struct mm_bcn_change_req {
+	/// Pointer, in host memory, to the new beacon template
+	u32_l bcn_ptr;
+	/// Length of the beacon template
+	u16_l bcn_len;
+	/// Offset of the TIM IE in the beacon
+	u16_l tim_oft;
+	/// Length of the TIM IE
+	u8_l tim_len;
+	/// Index of the VIF for which the beacon is updated
+	u8_l inst_nbr;
+	/// Offset of CSA (channel switch announcement) counters (0 means no
+	/// counter)
+	u8_l csa_oft[BCN_MAX_CSA_CPT];
+};
+
+/// Structure containing the parameters of the @ref MM_TIM_UPDATE_REQ mess=
age.
+struct mm_tim_update_req {
+	/// Association ID of the STA the bit of which has to be updated (0 for
+	/// BC/MC traffic)
+	u16_l aid;
+	/// Flag indicating the availability of data packets for the given STA
+	u8_l tx_avail;
+	/// Index of the VIF for which the TIM is updated
+	u8_l inst_nbr;
+};
+
+/// Structure containing the parameters of the @ref MM_REMAIN_ON_CHANNEL_R=
EQ
+/// message.
+struct mm_remain_on_channel_req {
+	/// Operation Code
+	u8_l op_code;
+	/// VIF Index
+	u8_l vif_index;
+	/// Band (2.4GHz or 5GHz)
+	u8_l band;
+	/// Channel type: 20,40,80,160 or 80+80 MHz
+	u8_l type;
+	/// Frequency for Primary 20MHz channel (in MHz)
+	u16_l prim20_freq;
+	/// Frequency for Center of the contiguous channel or center of Primary
+	/// 80+80
+	u16_l center1_freq;
+	/// Frequency for Center of the non-contiguous secondary 80+80
+	u16_l center2_freq;
+	/// Duration (in ms)
+	u32_l duration_ms;
+	/// TX power (in dBm)
+	s8_l tx_power;
+};
+
+/// Structure containing the parameters of the @ref MM_REMAIN_ON_CHANNEL_C=
FM
+/// message
+struct mm_remain_on_channel_cfm {
+	/// Operation Code
+	u8_l op_code;
+	/// Status of the operation
+	u8_l status;
+	/// Channel Context index
+	u8_l chan_ctxt_index;
+};
+
+/// Structure containing the parameters of the @ref MM_REMAIN_ON_CHANNEL_E=
XP_IND
+/// message
+struct mm_remain_on_channel_exp_ind {
+	/// VIF Index
+	u8_l vif_index;
+	/// Channel Context index
+	u8_l chan_ctxt_index;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_UAPSD_TMR_REQ
+/// message.
+struct mm_set_uapsd_tmr_req {
+	/// action: Start or Stop the timer
+	u8_l action;
+	/// timeout value, in milliseconds
+	u32_l timeout;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_UAPSD_TMR_CFM
+/// message.
+struct mm_set_uapsd_tmr_cfm {
+	/// Status of the operation (different from 0 if unsuccessful)
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref MM_PS_CHANGE_IND messa=
ge
+struct mm_ps_change_ind {
+	/// Index of the peer device that is switching its PS state
+	u8_l sta_idx;
+	/// New PS state of the peer device (0: active, 1: sleeping)
+	u8_l ps_state;
+};
+
+/// Structure containing the parameters of the @ref MM_P2P_VIF_PS_CHANGE_I=
ND
+/// message
+struct mm_p2p_vif_ps_change_ind {
+	/// Index of the P2P VIF that is switching its PS state
+	u8_l vif_index;
+	/// New PS state of the P2P VIF interface (0: active, 1: sleeping)
+	u8_l ps_state;
+};
+
+/// Structure containing the parameters of the @ref MM_TRAFFIC_REQ_IND mes=
sage
+struct mm_traffic_req_ind {
+	/// Index of the peer device that needs traffic
+	u8_l sta_idx;
+	/// Number of packets that need to be sent (if 0, all buffered traffic sh=
all
+	/// be sent and if set to @ref PS_SP_INTERRUPTED, it means that current
+	/// service period has been interrupted)
+	u8_l pkt_cnt;
+	/// Flag indicating if the traffic request concerns U-APSD queues or not
+	bool uapsd;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_PS_OPTIONS_REQ
+/// message.
+struct mm_set_ps_options_req {
+	/// VIF Index
+	u8_l vif_index;
+	/// Listen interval (0 if wake up shall be based on DTIM period)
+	u16_l listen_interval;
+	/// Flag indicating if we shall listen the BC/MC traffic or not
+	bool dont_listen_bc_mc;
+};
+
+/// Structure containing the parameters of the @ref MM_CSA_COUNTER_IND mes=
sage
+struct mm_csa_counter_ind {
+	/// Index of the VIF
+	u8_l vif_index;
+	/// Updated CSA counter value
+	u8_l csa_count;
+};
+
+/// Structure containing the parameters of the @ref MM_CHANNEL_SURVEY_IND
+/// message
+struct mm_channel_survey_ind {
+	/// Frequency of the channel
+	u16_l freq;
+	/// Noise in dbm
+	s8_l noise_dbm;
+	/// Amount of time spent of the channel (in ms)
+	u32_l chan_time_ms;
+	/// Amount of time the primary channel was sensed busy
+	u32_l chan_time_busy_ms;
+};
+
+/// Structure containing the parameters of the @ref MM_BFMER_ENABLE_REQ me=
ssage.
+struct mm_bfmer_enable_req {
+	/**
+	 * Address of the beamforming report space allocated in host memory
+	 * (Valid only if vht_su_bfmee is true)
+	 */
+	u32_l host_bfr_addr;
+	/**
+	 * Size of the beamforming report space allocated in host memory. This sp=
ace
+	 * should be twice the maximum size of the expected beamforming reports a=
s
+	 * the FW will divide it in two in order to be able to upload a new repor=
t
+	 * while another one is used in transmission
+	 */
+	u16_l host_bfr_size;
+	/// AID
+	u16_l aid;
+	/// Station Index
+	u8_l sta_idx;
+	/// Maximum number of spatial streams the station can receive
+	u8_l rx_nss;
+	/**
+	 * Indicate if peer STA is MU Beamformee (VHT) capable
+	 * (Valid only if vht_su_bfmee is true)
+	 */
+	bool vht_mu_bfmee;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_P2P_NOA_REQ mes=
sage.
+struct mm_set_p2p_noa_req {
+	/// VIF Index
+	u8_l vif_index;
+	/// Allocated NOA Instance Number - Valid only if count =3D 0
+	u8_l noa_inst_nb;
+	/// Count
+	u8_l count;
+	/// Indicate if NoA can be paused for traffic reason
+	bool dyn_noa;
+	/// Duration (in us)
+	u32_l duration_us;
+	/// Interval (in us)
+	u32_l interval_us;
+	/// Start Time offset from next TBTT (in us)
+	u32_l start_offset;
+};
+
+#ifdef AICWF_ARP_OFFLOAD
+struct mm_set_arpoffload_en_req {
+	u32_l ipaddr;
+	u8_l enable;
+	u8_l vif_idx;
+};
+
+struct mm_set_arpoffload_en_cfm {
+	u8_l status;
+};
+#endif
+
+struct mm_set_agg_disable_req {
+	u8_l disable;
+	u8_l staidx;
+	u8_l disable_rx;
+};
+
+struct mm_set_coex_req {
+	u8_l bt_on;
+	u8_l disable_coexnull;
+	u8_l enable_nullcts;
+	u8_l enable_periodic_timer;
+	u8_l coex_timeslot_set;
+	u32_l coex_timeslot[2];
+};
+
+struct mm_set_rf_config_req {
+	u8_l table_sel;
+	u8_l table_ofst;
+	u8_l table_num;
+	u8_l deft_page;
+	u32_l data[64];
+};
+
+struct mm_set_rf_calib_req {
+	u32_l cal_cfg_24g;
+	u32_l cal_cfg_5g;
+	u32_l param_alpha;
+	u32_l bt_calib_en;
+	u32_l bt_calib_param;
+	u8_l xtal_cap;
+	u8_l xtal_cap_fine;
+};
+
+struct mm_set_rf_calib_cfm {
+	u32_l rxgain_24g_addr;
+	u32_l rxgain_5g_addr;
+	u32_l txgain_24g_addr;
+	u32_l txgain_5g_addr;
+};
+
+struct mm_get_mac_addr_req {
+	u32_l get;
+};
+
+struct mm_get_mac_addr_cfm {
+	u8_l mac_addr[6];
+};
+
+struct mm_get_sta_info_req {
+	u8_l sta_idx;
+};
+
+struct mm_get_sta_info_cfm {
+	u32_l rate_info;
+	u32_l txfailed;
+	u8 rssi;
+};
+
+#define REGION_NUM_MAX 5
+
+struct txpwr_lvl_conf {
+	u8_l enable;
+	u8_l dsss;
+	u8_l ofdmlowrate_2g4;
+	u8_l ofdm64qam_2g4;
+	u8_l ofdm256qam_2g4;
+	u8_l ofdm1024qam_2g4;
+	u8_l ofdmlowrate_5g;
+	u8_l ofdm64qam_5g;
+	u8_l ofdm256qam_5g;
+	u8_l ofdm1024qam_5g;
+};
+
+struct txpwr_lvl_conf_v2 {
+	u8_l enable;
+	s8_l pwrlvl_11b_11ag_2g4[12];
+	s8_l pwrlvl_11n_11ac_2g4[10];
+	s8_l pwrlvl_11ax_2g4[12];
+};
+
+struct txpwr_lvl_conf_v3 {
+	u8_l enable;
+	s8_l pwrlvl_11b_11ag_2g4[12];
+	s8_l pwrlvl_11n_11ac_2g4[10];
+	s8_l pwrlvl_11ax_2g4[12];
+	s8_l pwrlvl_11a_5g[12];
+	s8_l pwrlvl_11n_11ac_5g[10];
+	s8_l pwrlvl_11ax_5g[12];
+};
+
+struct txpwr_lvl_adj_conf {
+	u8_l enable;
+	s8_l pwrlvl_adj_tbl_2g4[3];
+	s8_l pwrlvl_adj_tbl_5g[6];
+};
+
+struct txpwr_loss_conf {
+	u8_l loss_enable_2g4;
+	s8_l loss_value_2g4;
+	u8_l loss_enable_5g;
+	s8_l loss_value_5g;
+};
+
+struct mm_set_txpwr_lvl_req {
+	union {
+		struct txpwr_lvl_conf txpwr_lvl;
+		struct txpwr_lvl_conf_v2 txpwr_lvl_v2;
+		struct txpwr_lvl_conf_v3 txpwr_lvl_v3;
+	};
+};
+
+struct mm_set_txpwr_lvl_adj_req {
+	struct txpwr_lvl_adj_conf txpwr_lvl_adj;
+};
+
+struct txpwr_idx_conf {
+	u8_l enable;
+	u8_l dsss;
+	u8_l ofdmlowrate_2g4;
+	u8_l ofdm64qam_2g4;
+	u8_l ofdm256qam_2g4;
+	u8_l ofdm1024qam_2g4;
+	u8_l ofdmlowrate_5g;
+	u8_l ofdm64qam_5g;
+	u8_l ofdm256qam_5g;
+	u8_l ofdm1024qam_5g;
+};
+
+struct mm_set_txpwr_idx_req {
+	struct txpwr_idx_conf txpwr_idx;
+};
+
+struct txpwr_ofst_conf {
+	u8_l enable;
+	s8_l chan_1_4;
+	s8_l chan_5_9;
+	s8_l chan_10_13;
+	s8_l chan_36_64;
+	s8_l chan_100_120;
+	s8_l chan_122_140;
+	s8_l chan_142_165;
+};
+
+/*
+ * pwrofst2x_tbl_2g4[3][3]:
+ * +---------------+----------+----------+----------+
+ * | RateTyp\ChGrp |  CH_1_4  |  CH_5_9  | CH_10_13 |
+ * +---------------+----------+----------+----------+
+ * | DSSS          |  [0][0]  |  [0][1]  |  [0][2]  |
+ * +---------------+----------+----------+----------+
+ * | OFDM_HIGHRATE |  [1][0]  |  [1][1]  |  [1][2]  |
+ * +---------------+----------+----------+----------+
+ * | OFDM_LOWRATE  |  [2][0]  |  [2][1]  |  [2][2]  |
+ * +---------------+----------+----------+----------+
+ * pwrofst2x_tbl_5g[3][6]:
+ * +---------------+--------------+--------------+----------------+-------=
---------+--+--+
+ * | RateTyp\ChGrp | CH_42(36~50) | CH_58(51~64) | CH_106(98~114) |
+ * CH_122(115~130)| CH_138(131~146)| CH_155(147~166)|
+ * +---------------+--------------+--------------+----------------+-------=
---------+--+--+
+ * | OFDM_LOWRATE  |    [0][0]    |    [0][1]    |     [0][2]     |     [0=
][3]
+ * |     [0][4]     |     [0][5]     |
+ * +---------------+--------------+--------------+----------------+-------=
---------+--+--+
+ * | OFDM_HIGHRATE |    [1][0]    |    [1][1]    |     [1][2]     |     [1=
][3]
+ * |     [1][4]     |     [1][5]     |
+ * +---------------+--------------+--------------+----------------+-------=
---------+--+--+
+ * | OFDM_MIDRATE  |    [2][0]    |    [2][1]    |     [2][2]     |     [2=
][3]
+ * |     [2][4]     |     [2][5]     |
+ * +---------------+--------------+--------------+----------------+-------=
---------+--+--+
+ */
+
+struct txpwr_ofst2x_conf {
+	s8 enable;
+	s8 pwrofst2x_tbl_2g4[3][3];
+	s8 pwrofst2x_tbl_5g[3][6];
+};
+
+struct xtal_cap_conf {
+	u8_l enable;
+	u8_l xtal_cap;
+	u8_l xtal_cap_fine;
+};
+
+struct mm_set_txpwr_ofst_req {
+	union {
+		struct txpwr_ofst_conf txpwr_ofst;
+		struct txpwr_ofst2x_conf txpwr_ofst2x;
+	};
+};
+
+struct mm_set_stack_start_req {
+	u8_l is_stack_start;
+	u8_l efuse_valid;
+	u8_l set_vendor_info;
+	u8_l fwtrace_redir;
+};
+
+struct mm_set_stack_start_cfm {
+	u8_l is_5g_support;
+	u8_l vendor_info;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_P2P_OPPPS_REQ
+/// message.
+struct mm_set_p2p_oppps_req {
+	/// VIF Index
+	u8_l vif_index;
+	/// CTWindow
+	u8_l ctwindow;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_P2P_NOA_CFM mes=
sage.
+struct mm_set_p2p_noa_cfm {
+	/// Request status
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref MM_SET_P2P_OPPPS_CFM
+/// message.
+struct mm_set_p2p_oppps_cfm {
+	/// Request status
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref MM_P2P_NOA_UPD_IND mes=
sage.
+struct mm_p2p_noa_upd_ind {
+	/// VIF Index
+	u8_l vif_index;
+	/// NOA Instance Number
+	u8_l noa_inst_nb;
+	/// NoA Type
+	u8_l noa_type;
+	/// Count
+	u8_l count;
+	/// Duration (in us)
+	u32_l duration_us;
+	/// Interval (in us)
+	u32_l interval_us;
+	/// Start Time
+	u32_l start_time;
+};
+
+/// Structure containing the parameters of the @ref MM_CFG_RSSI_REQ messag=
e
+struct mm_cfg_rssi_req {
+	/// Index of the VIF
+	u8_l vif_index;
+	/// RSSI threshold
+	s8_l rssi_thold;
+	/// RSSI hysteresis
+	u8_l rssi_hyst;
+};
+
+/// Structure containing the parameters of the @ref MM_RSSI_STATUS_IND mes=
sage
+struct mm_rssi_status_ind {
+	/// Index of the VIF
+	u8_l vif_index;
+	/// Status of the RSSI
+	bool rssi_status;
+	/// Current RSSI
+	s8_l rssi;
+};
+
+/// Structure containing the parameters of the @ref MM_PKTLOSS_IND message
+struct mm_pktloss_ind {
+	/// Index of the VIF
+	u8_l vif_index;
+	/// Address of the STA for which there is a packet loss
+	struct mac_addr mac_addr;
+	/// Number of packets lost
+	u32 num_packets;
+};
+
+/// Structure containing the parameters of the @ref MM_CSA_FINISH_IND mess=
age
+struct mm_csa_finish_ind {
+	/// Index of the VIF
+	u8_l vif_index;
+	/// Status of the operation
+	u8_l status;
+	/// New channel ctx index
+	u8_l chan_idx;
+};
+
+/// Structure containing the parameters of the @ref MM_CSA_TRAFFIC_IND mes=
sage
+struct mm_csa_traffic_ind {
+	/// Index of the VIF
+	u8_l vif_index;
+	/// Is tx traffic enable or disable
+	bool enable;
+};
+
+/// Structure containing the parameters of the @ref MM_MU_GROUP_UPDATE_REQ
+/// message. Size allocated for the structure depends of the number of gro=
up
+struct mm_mu_group_update_req {
+	/// Station index
+	u8_l sta_idx;
+	/// Number of groups the STA belongs to
+	u8_l group_cnt;
+	/// Group information
+	struct {
+		/// Group Id
+		u8_l group_id;
+		/// User position
+		u8_l user_pos;
+	} groups[];
+};
+
+//////////////////////////////////////////////////////////////////////////=
/////
+/////////// For Scan messages
+//////////////////////////////////////////////////////////////////////////=
/////
+enum scan_msg_tag {
+	/// Scanning start Request.
+	SCAN_START_REQ =3D LMAC_FIRST_MSG(TASK_SCAN),
+	/// Scanning start Confirmation.
+	SCAN_START_CFM,
+	/// End of scanning indication.
+	SCAN_DONE_IND,
+	/// Cancel scan request
+	SCAN_CANCEL_REQ,
+	/// Cancel scan confirmation
+	SCAN_CANCEL_CFM,
+
+	/// MAX number of messages
+	SCAN_MAX,
+};
+
+/// Maximum number of SSIDs in a scan request
+#define SCAN_SSID_MAX 3
+
+/// Maximum number of channels in a scan request
+#define SCAN_CHANNEL_MAX (MAC_DOMAINCHANNEL_24G_MAX + MAC_DOMAINCHANNEL_5G=
_MAX)
+
+/// Maximum length of the ProbeReq IEs (SoftMAC mode)
+#define SCAN_MAX_IE_LEN 300
+
+/// Maximum number of PHY bands supported
+#define SCAN_BAND_MAX 2
+
+/// Structure containing the parameters of the @ref SCAN_START_REQ message
+struct scan_start_req {
+	/// List of channel to be scanned
+	struct mac_chan_def chan[SCAN_CHANNEL_MAX];
+	/// List of SSIDs to be scanned
+	struct mac_ssid ssid[SCAN_SSID_MAX];
+	/// BSSID to be scanned
+	struct mac_addr bssid;
+	/// Pointer (in host memory) to the additional IEs that need to be added =
to
+	/// the ProbeReq (following the SSID element)
+	u32_l add_ies;
+	/// Length of the additional IEs
+	u16_l add_ie_len;
+	/// Index of the VIF that is scanning
+	u8_l vif_idx;
+	/// Number of channels to scan
+	u8_l chan_cnt;
+	/// Number of SSIDs to scan for
+	u8_l ssid_cnt;
+	/// no CCK - For P2P frames not being sent at CCK rate in 2GHz band.
+	bool no_cck;
+	/// Scan duration, in us
+	u32_l duration;
+};
+
+/// Structure containing the parameters of the @ref SCAN_START_CFM message
+struct scan_start_cfm {
+	/// Status of the request
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref SCAN_CANCEL_REQ messag=
e
+struct scan_cancel_req {
+};
+
+/// Structure containing the parameters of the @ref SCAN_START_CFM message
+struct scan_cancel_cfm {
+	/// Status of the request
+	u8_l status;
+};
+
+//////////////////////////////////////////////////////////////////////////=
/////
+/////////// For Scanu messages
+//////////////////////////////////////////////////////////////////////////=
/////
+/// Messages that are logically related to the task.
+enum {
+	/// Scan request from host.
+	SCANU_START_REQ =3D LMAC_FIRST_MSG(TASK_SCANU),
+	/// Scanning start Confirmation.
+	SCANU_START_CFM,
+	/// Join request
+	SCANU_JOIN_REQ,
+	/// Join confirmation.
+	SCANU_JOIN_CFM,
+	/// Scan result indication.
+	SCANU_RESULT_IND,
+	/// Fast scan request from any other module.
+	SCANU_FAST_REQ,
+	/// Confirmation of fast scan request.
+	SCANU_FAST_CFM,
+
+	SCANU_VENDOR_IE_REQ,
+	SCANU_VENDOR_IE_CFM,
+	SCANU_START_CFM_ADDTIONAL,
+	SCANU_CANCEL_REQ,
+	SCANU_CANCEL_CFM,
+
+	/// MAX number of messages
+	SCANU_MAX,
+};
+
+/// Maximum length of the additional ProbeReq IEs (FullMAC mode)
+#define SCANU_MAX_IE_LEN 200
+
+/// Structure containing the parameters of the @ref SCANU_START_REQ messag=
e
+struct scanu_start_req {
+	/// List of channel to be scanned
+	struct mac_chan_def chan[SCAN_CHANNEL_MAX];
+	/// List of SSIDs to be scanned
+	struct mac_ssid ssid[SCAN_SSID_MAX];
+	/// BSSID to be scanned (or WILDCARD BSSID if no BSSID is searched in
+	/// particular)
+	struct mac_addr bssid;
+	/// Address (in host memory) of the additional IEs that need to be added =
to
+	/// the ProbeReq (following the SSID element)
+	u32_l add_ies;
+	/// Length of the additional IEs
+	u16_l add_ie_len;
+	/// Index of the VIF that is scanning
+	u8_l vif_idx;
+	/// Number of channels to scan
+	u8_l chan_cnt;
+	/// Number of SSIDs to scan for
+	u8_l ssid_cnt;
+	/// no CCK - For P2P frames not being sent at CCK rate in 2GHz band.
+	bool no_cck;
+	/// Scan duration, in us
+	u32_l duration;
+};
+
+struct scanu_vendor_ie_req {
+	u16_l add_ie_len;
+	u8_l vif_idx;
+	u8_l ie[256];
+};
+
+/// Structure containing the parameters of the @ref SCANU_START_CFM messag=
e
+struct scanu_start_cfm {
+	/// Index of the VIF that was scanning
+	u8_l vif_idx;
+	/// Status of the request
+	u8_l status;
+	/// Number of scan results available
+	u8_l result_cnt;
+};
+
+/// Parameters of the @SCANU_RESULT_IND message
+struct scanu_result_ind {
+	/// Length of the frame
+	u16_l length;
+	/// Frame control field of the frame.
+	u16_l framectrl;
+	/// Center frequency on which we received the packet
+	u16_l center_freq;
+	/// PHY band
+	u8_l band;
+	/// Index of the station that sent the frame. 0xFF if unknown.
+	u8_l sta_idx;
+	/// Index of the VIF that received the frame. 0xFF if unknown.
+	u8_l inst_nbr;
+	/// RSSI of the received frame.
+	s8_l rssi;
+	/// Frame payload.
+	u32_l payload[];
+};
+
+struct rxu_arp_announcement_ind {
+	/// index of the vif
+	u8_l vif_index;
+	u8_l offset;
+	/// length of the frame
+	u16_l length;
+	u32_l rx_status;
+	/// frame payload
+	u8_l payload[];
+};
+
+/// Structure containing the parameters of the message.
+struct scanu_fast_req {
+	/// The SSID to scan in the channel.
+	struct mac_ssid ssid;
+	/// BSSID.
+	struct mac_addr bssid;
+	/// Probe delay.
+	u16_l probe_delay;
+	/// Minimum channel time.
+	u16_l minch_time;
+	/// Maximum channel time.
+	u16_l maxch_time;
+	/// The channel number to scan.
+	u16_l ch_nbr;
+};
+
+//////////////////////////////////////////////////////////////////////////=
/////
+/////////// For ME messages
+//////////////////////////////////////////////////////////////////////////=
/////
+/// Messages that are logically related to the task.
+enum {
+	/// Configuration request from host.
+	ME_CONFIG_REQ =3D LMAC_FIRST_MSG(TASK_ME),
+	/// Configuration confirmation.
+	ME_CONFIG_CFM,
+	/// Configuration request from host.
+	ME_CHAN_CONFIG_REQ,
+	/// Configuration confirmation.
+	ME_CHAN_CONFIG_CFM,
+	/// Set control port state for a station.
+	ME_SET_CONTROL_PORT_REQ,
+	/// Control port setting confirmation.
+	ME_SET_CONTROL_PORT_CFM,
+	/// TKIP MIC failure indication.
+	ME_TKIP_MIC_FAILURE_IND,
+	/// Add a station to the FW (AP mode)
+	ME_STA_ADD_REQ,
+	/// Confirmation of the STA addition
+	ME_STA_ADD_CFM,
+	/// Delete a station from the FW (AP mode)
+	ME_STA_DEL_REQ,
+	/// Confirmation of the STA deletion
+	ME_STA_DEL_CFM,
+	/// Indication of a TX RA/TID queue credit update
+	ME_TX_CREDITS_UPDATE_IND,
+	/// Request indicating to the FW that there is traffic buffered on host
+	ME_TRAFFIC_IND_REQ,
+	/// Confirmation that the @ref ME_TRAFFIC_IND_REQ has been executed
+	ME_TRAFFIC_IND_CFM,
+	/// Request of RC statistics to a station
+	ME_RC_STATS_REQ,
+	/// RC statistics confirmation
+	ME_RC_STATS_CFM,
+	/// RC fixed rate request
+	ME_RC_SET_RATE_REQ,
+	/// Configure monitor interface
+	ME_CONFIG_MONITOR_REQ,
+	/// Configure monitor interface response
+	ME_CONFIG_MONITOR_CFM,
+	/// Setting power Save mode request from host
+	ME_SET_PS_MODE_REQ,
+	/// Set power Save mode confirmation
+	ME_SET_PS_MODE_CFM,
+	/// Setting Low Power level request from host
+	ME_SET_LP_LEVEL_REQ,
+	/// Set Low Power level confirmation
+	ME_SET_LP_LEVEL_CFM,
+	/// MAX number of messages
+	ME_MAX,
+};
+
+/// Structure containing the parameters of the @ref ME_START_REQ message
+struct me_config_req {
+	/// HT Capabilities
+	struct mac_htcapability ht_cap;
+	/// VHT Capabilities
+	struct mac_vhtcapability vht_cap;
+	/// HE capabilities
+	struct mac_hecapability he_cap;
+	/// Lifetime of packets sent under a BlockAck agreement (expressed in TUs=
)
+	u16_l tx_lft;
+	/// Maximum supported BW
+	u8_l phy_bw_max;
+	/// Boolean indicating if HT is supported or not
+	bool ht_supp;
+	/// Boolean indicating if VHT is supported or not
+	bool vht_supp;
+	/// Boolean indicating if HE is supported or not
+	bool he_supp;
+	/// Boolean indicating if HE OFDMA UL is enabled or not
+	bool he_ul_on;
+	/// Boolean indicating if PS mode shall be enabled or not
+	bool ps_on;
+	/// Boolean indicating if Antenna Diversity shall be enabled or not
+	bool ant_div_on;
+	/// Boolean indicating if Dynamic PS mode shall be used or not
+	bool dpsm;
+};
+
+/// Structure containing the parameters of the @ref ME_CHAN_CONFIG_REQ mes=
sage
+struct me_chan_config_req {
+	/// List of 2.4GHz supported channels
+	struct mac_chan_def chan2G4[MAC_DOMAINCHANNEL_24G_MAX];
+	/// List of 5GHz supported channels
+	struct mac_chan_def chan5G[MAC_DOMAINCHANNEL_5G_MAX];
+	/// Number of 2.4GHz channels in the list
+	u8_l chan2G4_cnt;
+	/// Number of 5GHz channels in the list
+	u8_l chan5G_cnt;
+};
+
+/// Structure containing the parameters of the @ref ME_SET_CONTROL_PORT_RE=
Q
+/// message
+struct me_set_control_port_req {
+	/// Index of the station for which the control port is opened
+	u8_l sta_idx;
+	/// Control port state
+	bool control_port_open;
+};
+
+/// Structure containing the parameters of the @ref ME_TKIP_MIC_FAILURE_IN=
D
+/// message
+struct me_tkip_mic_failure_ind {
+	/// Address of the sending STA
+	struct mac_addr addr;
+	/// TSC value
+	u64_l tsc;
+	/// Boolean indicating if the packet was a group or unicast one (true if
+	/// group)
+	bool ga;
+	/// Key Id
+	u8_l keyid;
+	/// VIF index
+	u8_l vif_idx;
+};
+
+/// Structure containing the parameters of the @ref ME_STA_ADD_REQ message
+struct me_sta_add_req {
+	/// MAC address of the station to be added
+	struct mac_addr mac_addr;
+	/// Supported legacy rates
+	struct mac_rateset rate_set;
+	/// HT Capabilities
+	struct mac_htcapability ht_cap;
+	/// VHT Capabilities
+	struct mac_vhtcapability vht_cap;
+	/// HE capabilities
+	struct mac_hecapability he_cap;
+	/// Flags giving additional information about the station (@ref
+	/// mac_sta_flags)
+	u32_l flags;
+	/// Association ID of the station
+	u16_l aid;
+	/// Bit field indicating which queues have U-APSD enabled
+	u8_l uapsd_queues;
+	/// Maximum size, in frames, of a APSD service period
+	u8_l max_sp_len;
+	/// Operation mode information (valid if bit @ref STA_OPMOD_NOTIF is
+	/// set in the flags)
+	u8_l opmode;
+	/// Index of the VIF the station is attached to
+	u8_l vif_idx;
+	/// Whether the station is TDLS station
+	bool tdls_sta;
+	/// Indicate if the station is TDLS link initiator station
+	bool tdls_sta_initiator;
+	/// Indicate if the TDLS Channel Switch is allowed
+	bool tdls_chsw_allowed;
+};
+
+/// Structure containing the parameters of the @ref ME_STA_ADD_CFM message
+struct me_sta_add_cfm {
+	/// Station index
+	u8_l sta_idx;
+	/// Status of the station addition
+	u8_l status;
+	/// PM state of the station
+	u8_l pm_state;
+};
+
+/// Structure containing the parameters of the @ref ME_STA_DEL_REQ message=
.
+struct me_sta_del_req {
+	/// Index of the station to be deleted
+	u8_l sta_idx;
+	/// Whether the station is TDLS station
+	bool tdls_sta;
+};
+
+/// Structure containing the parameters of the @ref ME_TX_CREDITS_UPDATE_I=
ND
+/// message.
+struct me_tx_credits_update_ind {
+	/// Index of the station for which the credits are updated
+	u8_l sta_idx;
+	/// TID for which the credits are updated
+	u8_l tid;
+	/// Offset to be applied on the credit count
+	s8_l credits;
+};
+
+/// Structure containing the parameters of the @ref ME_TRAFFIC_IND_REQ mes=
sage.
+struct me_traffic_ind_req {
+	/// Index of the station for which UAPSD traffic is available on host
+	u8_l sta_idx;
+	/// Flag indicating the availability of UAPSD packets for the given STA
+	u8_l tx_avail;
+	/// Indicate if traffic is on uapsd-enabled queues
+	bool uapsd;
+};
+
+struct mm_apm_staloss_ind {
+	u8_l sta_idx;
+	u8_l vif_idx;
+	u8_l mac_addr[6];
+};
+
+#ifdef CONFIG_SDIO_BT
+struct mm_bt_recv_ind {
+	u32_l data_len;
+	u8_l bt_data[1024];
+};
+#endif
+
+enum vendor_hwconfig_tag {
+	ACS_TXOP_REQ =3D 0,
+	CHANNEL_ACCESS_REQ,
+	MAC_TIMESCALE_REQ,
+	CCA_THRESHOLD_REQ,
+	BWMODE_REQ,
+	CHIP_TEMP_GET_REQ,
+	AP_PS_LEVEL_SET_REQ,
+	CUSTOMIZED_FREQ_REQ,
+	WAKEUP_INFO_REQ,
+	KEEPALIVE_PKT_REQ,
+};
+
+enum {
+	BWMODE20M =3D 0,
+	BWMODE10M,
+	BWMODE5M,
+};
+
+struct mm_set_acs_txop_req {
+	u32_l hwconfig_id;
+	u16_l txop_bk;
+	u16_l txop_be;
+	u16_l txop_vi;
+	u16_l txop_vo;
+};
+
+struct mm_set_channel_access_req {
+	u32_l hwconfig_id;
+	u32_l edca[4];
+	u8_l vif_idx;
+	u8_l retry_cnt;
+	u8_l rts_en;
+	u8_l long_nav_en;
+	u8_l cfe_en;
+	u8_l rc_retry_cnt[3];
+	s8_l ccademod_th;
+};
+
+struct mm_set_mac_timescale_req {
+	u32_l hwconfig_id;
+	u8_l sifs_a_time;
+	u8_l sifs_b_time;
+	u8_l slot_time;
+	u8_l rx_startdelay_ofdm;
+	u8_l rx_startdelay_long;
+	u8_l rx_startdelay_short;
+};
+
+struct mm_set_cca_threshold_req {
+	u32_l hwconfig_id;
+	u8_l auto_cca_en;
+	s8_l cca20p_rise_th;
+	s8_l cca20s_rise_th;
+	s8_l cca20p_fall_th;
+	s8_l cca20s_fall_th;
+};
+
+struct mm_set_bwmode_req {
+	u32_l hwconfig_id;
+	u8_l bwmode;
+};
+
+struct mm_get_chip_temp_req {
+	u32_l hwconfig_id;
+};
+
+struct mm_get_chip_temp_cfm {
+	/// Temp degree val
+	s8_l degree;
+};
+
+struct mm_set_ap_ps_level_req {
+	u32_l hwconfig_id;
+	u8 ap_ps_level;
+};
+
+struct mm_set_vendor_hwconfig_cfm {
+	u32_l hwconfig_id;
+	union {
+		struct mm_get_chip_temp_cfm chip_temp_cfm;
+	};
+};
+
+struct mm_set_customized_freq_req {
+	u32_l hwconfig_id;
+	u16_l raw_freq[4];
+	u16_l map_freq[4];
+};
+
+struct mm_set_keepalive_req {
+	u32_l hwconfig_id;
+	u16_l code;
+	u16_l length;
+	u32_l intv;
+	u8_l payload[];
+};
+
+struct mm_set_txop_req {
+	u16_l txop_bk;
+	u16_l txop_be;
+	u16_l txop_vi;
+	u16_l txop_vo;
+	u8_l long_nav_en;
+	u8_l cfe_en;
+};
+
+struct mm_set_wakeup_info_req {
+	u32_l hwconfig_id;
+	u16_l code;
+	u16_l offset;
+	u16_l length;
+	u16_l length_win;
+	u8_l mask_and_pattern[];
+};
+
+struct mm_get_fw_version_cfm {
+	u8_l fw_version_len;
+	u8_l fw_version[63];
+};
+
+struct mm_get_wifi_disable_cfm {
+	u8_l wifi_disable;
+};
+
+enum vendor_swconfig_tag {
+	BCN_CFG_REQ =3D 0,
+	TEMP_COMP_SET_REQ,
+	TEMP_COMP_GET_REQ,
+	EXT_FLAGS_SET_REQ,
+	EXT_FLAGS_GET_REQ,
+	EXT_FLAGS_MASK_SET_REQ,
+};
+
+struct mm_set_bcn_cfg_req {
+	/// Ignore or not bcn tim bcmc bit
+	bool tim_bcmc_ignored_enable;
+};
+
+struct mm_set_bcn_cfg_cfm {
+	/// Request status
+	bool tim_bcmc_ignored_status;
+};
+
+struct mm_set_temp_comp_req {
+	/// Enable or not temp comp
+	u8_l enable;
+	u8_l reserved[3];
+	u32_l tmr_period_ms;
+};
+
+struct mm_set_temp_comp_cfm {
+	/// Request status
+	u8_l status;
+};
+
+struct mm_get_temp_comp_cfm {
+	/// Request status
+	u8_l status;
+	/// Temp degree val
+	s8_l degree;
+};
+
+struct mm_set_ext_flags_req {
+	u32_l user_flags;
+};
+
+struct mm_set_ext_flags_cfm {
+	u32_l user_flags;
+};
+
+struct mm_get_ext_flags_cfm {
+	u32_l user_flags;
+};
+
+struct mm_mask_set_ext_flags_req {
+	u32_l user_flags_mask;
+	u32_l user_flags_val;
+};
+
+struct mm_mask_set_ext_flags_cfm {
+	u32_l user_flags;
+};
+
+struct mm_set_vendor_swconfig_req {
+	u32_l swconfig_id;
+	union {
+		struct mm_set_bcn_cfg_req bcn_cfg_req;
+		struct mm_set_temp_comp_req temp_comp_set_req;
+		struct mm_set_ext_flags_req ext_flags_set_req;
+		struct mm_mask_set_ext_flags_req ext_flags_mask_set_req;
+	};
+};
+
+struct mm_set_vendor_swconfig_cfm {
+	u32_l swconfig_id;
+	union {
+		struct mm_set_bcn_cfg_cfm bcn_cfg_cfm;
+		struct mm_set_temp_comp_cfm temp_comp_set_cfm;
+		struct mm_get_temp_comp_cfm temp_comp_get_cfm;
+		struct mm_set_ext_flags_cfm ext_flags_set_cfm;
+		struct mm_get_ext_flags_cfm ext_flags_get_cfm;
+		struct mm_mask_set_ext_flags_cfm ext_flags_mask_set_cfm;
+	};
+};
+
+#ifdef CONFIG_SDIO_BT
+struct mm_bt_send_req {
+	u32_l data_len;
+	u8_l bt_data[1024];
+};
+
+struct mm_bt_send_cfm {
+	u8_l status;
+};
+#endif
+
+/// Structure containing the parameters of the @ref ME_RC_STATS_REQ messag=
e.
+struct me_rc_stats_req {
+	/// Index of the station for which the RC statistics are requested
+	u8_l sta_idx;
+};
+
+/// Structure containing the rate control statistics
+struct rc_rate_stats {
+	/// Number of attempts (per sampling interval)
+	u16_l attempts;
+	/// Number of success (per sampling interval)
+	u16_l success;
+	/// Estimated probability of success (EWMA)
+	u16_l probability;
+	/// Rate configuration of the sample
+	u16_l rate_config;
+	union {
+		struct {
+			/// Number of times the sample has been skipped (per sampling
+			/// interval)
+			u8_l sample_skipped;
+			/// Whether the old probability is available
+			bool old_prob_available;
+			/// Whether the rate can be used in the retry chain
+			bool rate_allowed;
+		};
+		struct {
+			/// RU size and UL length received in the latest HE trigger frame
+			u16_l ru_and_length;
+		};
+	};
+};
+
+/// Number of RC samples
+#define RC_MAX_N_SAMPLE 10
+/// Index of the HE statistics element in the table
+#define RC_HE_STATS_IDX RC_MAX_N_SAMPLE
+
+/// Structure containing the parameters of the @ref ME_RC_STATS_CFM messag=
e.
+struct me_rc_stats_cfm {
+	/// Index of the station for which the RC statistics are provided
+	u8_l sta_idx;
+	/// Number of samples used in the RC algorithm
+	u16_l no_samples;
+	/// Number of MPDUs transmitted (per sampling interval)
+	u16_l ampdu_len;
+	/// Number of AMPDUs transmitted (per sampling interval)
+	u16_l ampdu_packets;
+	/// Average number of MPDUs in each AMPDU frame (EWMA)
+	u32_l avg_ampdu_len;
+	// Current step 0 of the retry chain
+	u8_l sw_retry_step;
+	/// Trial transmission period
+	u8_l sample_wait;
+	/// Retry chain steps
+	u16_l retry_step_idx[4];
+	/// RC statistics - Max number of RC samples, plus one for the HE TB
+	/// statistics
+	struct rc_rate_stats rate_stats[RC_MAX_N_SAMPLE + 1];
+	/// Throughput - Max number of RC samples, plus one for the HE TB statist=
ics
+	u32_l tp[RC_MAX_N_SAMPLE + 1];
+};
+
+/// Structure containing the parameters of the @ref ME_RC_SET_RATE_REQ mes=
sage.
+struct me_rc_set_rate_req {
+	/// Index of the station for which the fixed rate is set
+	u8_l sta_idx;
+	/// Rate configuration to be set
+	u16_l fixed_rate_cfg;
+};
+
+/// Structure containing the parameters of the @ref ME_CONFIG_MONITOR_REQ
+/// message.
+struct me_config_monitor_req {
+	/// Channel to configure
+	struct mac_chan_op chan;
+	/// Is channel data valid
+	bool chan_set;
+	/// Enable report of unsupported HT frames
+	bool uf;
+	/// Enable auto-reply as the mac_addr matches
+	bool auto_reply;
+};
+
+/// Structure containing the parameters of the @ref ME_CONFIG_MONITOR_CFM
+/// message.
+struct me_config_monitor_cfm {
+	/// Channel context index
+	u8_l chan_index;
+	/// Channel parameters
+	struct mac_chan_op chan;
+};
+
+/// Structure containing the parameters of the @ref ME_SET_PS_MODE_REQ mes=
sage.
+struct me_set_ps_mode_req {
+	/// Power Save is activated or deactivated
+	u8_l ps_state;
+};
+
+/// Structure containing the parameters of the @ref ME_SET_LP_LEVEL_REQ me=
ssage.
+struct me_set_lp_level_req {
+	/// Low Power level
+	u8_l lp_level;
+	u8_l disable_filter;
+};
+
+//////////////////////////////////////////////////////////////////////////=
/////
+/////////// For SM messages
+//////////////////////////////////////////////////////////////////////////=
/////
+/// Message API of the SM task
+enum sm_msg_tag {
+	/// Request to connect to an AP
+	SM_CONNECT_REQ =3D LMAC_FIRST_MSG(TASK_SM),
+	/// Confirmation of connection
+	SM_CONNECT_CFM,
+	/// Indicates that the SM associated to the AP
+	SM_CONNECT_IND,
+	/// Request to disconnect
+	SM_DISCONNECT_REQ,
+	/// Confirmation of disconnection
+	SM_DISCONNECT_CFM,
+	/// Indicates that the SM disassociated the AP
+	SM_DISCONNECT_IND,
+	/// Request to start external authentication
+	SM_EXTERNAL_AUTH_REQUIRED_IND,
+	/// Response to external authentication request
+	SM_EXTERNAL_AUTH_REQUIRED_RSP,
+	/// Request to update assoc elements after FT over the air authentication
+	SM_FT_AUTH_IND,
+	/// Response to FT authentication with updated assoc elements
+	SM_FT_AUTH_RSP,
+
+	SM_RSP_TIMEOUT_IND,
+
+	SM_COEX_TS_TIMEOUT_IND,
+
+	SM_EXTERNAL_AUTH_REQUIRED_RSP_CFM,
+	/// MAX number of messages
+	SM_MAX,
+};
+
+/// Structure containing the parameters of @ref SM_CONNECT_REQ message.
+struct sm_connect_req {
+	/// SSID to connect to
+	struct mac_ssid ssid;
+	/// BSSID to connect to (if not specified, set this field to WILDCARD BSS=
ID)
+	struct mac_addr bssid;
+	/// Channel on which we have to connect (if not specified, set -1 in the
+	/// chan.freq field)
+	struct mac_chan_def chan;
+	/// Connection flags (see @ref mac_connection_flags)
+	u32_l flags;
+	/// Control port Ethertype (in network endianness)
+	u16_l ctrl_port_ethertype;
+	/// Length of the association request IEs
+	u16_l ie_len;
+	/// Listen interval to be used for this connection
+	u16_l listen_interval;
+	/// Flag indicating if the we have to wait for the BC/MC traffic after
+	/// beacon or not
+	bool dont_wait_bcmc;
+	/// Authentication type
+	u8_l auth_type;
+	/// UAPSD queues (bit0: VO, bit1: VI, bit2: BE, bit3: BK)
+	u8_l uapsd_queues;
+	/// VIF index
+	u8_l vif_idx;
+	/// Buffer containing the additional information elements to be put in th=
e
+	/// association request
+	u32_l ie_buf[64];
+};
+
+/// Structure containing the parameters of the @ref SM_CONNECT_CFM message=
.
+struct sm_connect_cfm {
+	/// Status. If 0, it means that the connection procedure will be performe=
d
+	/// and that a subsequent @ref SM_CONNECT_IND message will be forwarded o=
nce
+	/// the procedure is completed
+	u8_l status;
+};
+
+#define SM_ASSOC_IE_LEN 800
+/// Structure containing the parameters of the @ref SM_CONNECT_IND message=
.
+struct sm_connect_ind {
+	/// Status code of the connection procedure
+	u16_l status_code;
+	/// BSSID
+	struct mac_addr bssid;
+	/// Flag indicating if the indication refers to an internal roaming or fr=
om
+	/// a host request
+	bool roamed;
+	/// Index of the VIF for which the association process is complete
+	u8_l vif_idx;
+	/// Index of the STA entry allocated for the AP
+	u8_l ap_idx;
+	/// Index of the LMAC channel context the connection is attached to
+	u8_l ch_idx;
+	/// Flag indicating if the AP is supporting QoS
+	bool qos;
+	/// ACM bits set in the AP WMM parameter element
+	u8_l acm;
+	/// Length of the AssocReq IEs
+	u16_l assoc_req_ie_len;
+	/// Length of the AssocRsp IEs
+	u16_l assoc_rsp_ie_len;
+	/// IE buffer
+	u32_l assoc_ie_buf[SM_ASSOC_IE_LEN / 4];
+
+	u16_l aid;
+	u8_l band;
+	u16_l center_freq;
+	u8_l width;
+	u32_l center_freq1;
+	u32_l center_freq2;
+
+	/// EDCA parameters
+	u32_l ac_param[AC_MAX];
+};
+
+/// Structure containing the parameters of the @ref SM_DISCONNECT_REQ mess=
age.
+struct sm_disconnect_req {
+	/// Reason of the deauthentication.
+	u16_l reason_code;
+	/// Index of the VIF.
+	u8_l vif_idx;
+};
+
+/// Structure containing the parameters of SM_ASSOCIATION_IND the message
+struct sm_association_ind {
+	// MAC ADDR of the STA
+	struct mac_addr me_mac_addr;
+};
+
+/// Structure containing the parameters of the @ref SM_DISCONNECT_IND mess=
age.
+struct sm_disconnect_ind {
+	/// Reason of the disconnection.
+	u16_l reason_code;
+	/// Index of the VIF.
+	u8_l vif_idx;
+	/// FT over DS is ongoing
+	bool ft_over_ds;
+	u8_l reassoc;
+};
+
+/// Structure containing the parameters of the @ref
+/// SM_EXTERNAL_AUTH_REQUIRED_IND
+struct sm_external_auth_required_ind {
+	/// Index of the VIF.
+	u8_l vif_idx;
+	/// SSID to authenticate to
+	struct mac_ssid ssid;
+	/// BSSID to authenticate to
+	struct mac_addr bssid;
+	/// AKM suite of the respective authentication
+	u32_l akm;
+};
+
+/// Structure containing the parameters of the @ref
+/// SM_EXTERNAL_AUTH_REQUIRED_RSP
+struct sm_external_auth_required_rsp {
+	/// Index of the VIF.
+	u8_l vif_idx;
+	/// Authentication status
+	u16_l status;
+};
+
+//////////////////////////////////////////////////////////////////////////=
/////
+/////////// For APM messages
+//////////////////////////////////////////////////////////////////////////=
/////
+/// Message API of the APM task
+enum apm_msg_tag {
+	/// Request to start the AP.
+	APM_START_REQ =3D LMAC_FIRST_MSG(TASK_APM),
+	/// Confirmation of the AP start.
+	APM_START_CFM,
+	/// Request to stop the AP.
+	APM_STOP_REQ,
+	/// Confirmation of the AP stop.
+	APM_STOP_CFM,
+	/// Request to start CAC
+	APM_START_CAC_REQ,
+	/// Confirmation of the CAC start
+	APM_START_CAC_CFM,
+	/// Request to stop CAC
+	APM_STOP_CAC_REQ,
+	/// Confirmation of the CAC stop
+	APM_STOP_CAC_CFM,
+
+	APM_SET_BEACON_IE_REQ,
+	APM_SET_BEACON_IE_CFM,
+
+	/// MAX number of messages
+	APM_MAX,
+};
+
+/// Structure containing the parameters of the @ref APM_START_REQ message.
+struct apm_start_req {
+	/// Basic rate set
+	struct mac_rateset basic_rates;
+	/// Control channel on which we have to enable the AP
+	struct mac_chan_def chan;
+	/// Center frequency of the first segment
+	u32_l center_freq1;
+	/// Center frequency of the second segment (only in 80+80 configuration)
+	u32_l center_freq2;
+	/// Width of channel
+	u8_l ch_width;
+	/// Address, in host memory, to the beacon template
+	u32_l bcn_addr;
+	/// Length of the beacon template
+	u16_l bcn_len;
+	/// Offset of the TIM IE in the beacon
+	u16_l tim_oft;
+	/// Beacon interval
+	u16_l bcn_int;
+	/// Flags (@ref mac_connection_flags)
+	u32_l flags;
+	/// Control port Ethertype
+	u16_l ctrl_port_ethertype;
+	/// Length of the TIM IE
+	u8_l tim_len;
+	/// Index of the VIF for which the AP is started
+	u8_l vif_idx;
+};
+
+struct apm_set_bcn_ie_req {
+	u8_l vif_idx;
+	u16_l bcn_ie_len;
+	u8_l bcn_ie[512];
+};
+
+/// Structure containing the parameters of the @ref APM_START_CFM message.
+struct apm_start_cfm {
+	/// Status of the AP starting procedure
+	u8_l status;
+	/// Index of the VIF for which the AP is started
+	u8_l vif_idx;
+	/// Index of the channel context attached to the VIF
+	u8_l ch_idx;
+	/// Index of the STA used for BC/MC traffic
+	u8_l bcmc_idx;
+};
+
+/// Structure containing the parameters of the @ref APM_STOP_REQ message.
+struct apm_stop_req {
+	/// Index of the VIF for which the AP has to be stopped
+	u8_l vif_idx;
+};
+
+/// Structure containing the parameters of the @ref APM_START_CAC_REQ mess=
age.
+struct apm_start_cac_req {
+	/// Control channel on which we have to start the CAC
+	struct mac_chan_def chan;
+	/// Center frequency of the first segment
+	u32_l center_freq1;
+	/// Center frequency of the second segment (only in 80+80 configuration)
+	u32_l center_freq2;
+	/// Width of channel
+	u8_l ch_width;
+	/// Index of the VIF for which the CAC is started
+	u8_l vif_idx;
+};
+
+/// Structure containing the parameters of the @ref APM_START_CAC_CFM mess=
age.
+struct apm_start_cac_cfm {
+	/// Status of the CAC starting procedure
+	u8_l status;
+	/// Index of the channel context attached to the VIF for CAC
+	u8_l ch_idx;
+};
+
+/// Structure containing the parameters of the @ref APM_STOP_CAC_REQ messa=
ge.
+struct apm_stop_cac_req {
+	/// Index of the VIF for which the CAC has to be stopped
+	u8_l vif_idx;
+};
+
+//////////////////////////////////////////////////////////////////////////=
/////
+/////////// For MESH messages
+//////////////////////////////////////////////////////////////////////////=
/////
+
+/// Maximum length of the Mesh ID
+#define MESH_MESHID_MAX_LEN (32)
+
+/// Message API of the MESH task
+enum mesh_msg_tag {
+	/// Request to start the MP
+	MESH_START_REQ =3D LMAC_FIRST_MSG(TASK_MESH),
+	/// Confirmation of the MP start.
+	MESH_START_CFM,
+
+	/// Request to stop the MP.
+	MESH_STOP_REQ,
+	/// Confirmation of the MP stop.
+	MESH_STOP_CFM,
+
+	// Request to update the MP
+	MESH_UPDATE_REQ,
+	/// Confirmation of the MP update
+	MESH_UPDATE_CFM,
+
+	/// Request information about a given link
+	MESH_PEER_INFO_REQ,
+	/// Response to the MESH_PEER_INFO_REQ message
+	MESH_PEER_INFO_CFM,
+
+	/// Request automatic establishment of a path with a given mesh STA
+	MESH_PATH_CREATE_REQ,
+	/// Confirmation to the MESH_PATH_CREATE_REQ message
+	MESH_PATH_CREATE_CFM,
+
+	/// Request a path update (delete path, modify next hop mesh STA)
+	MESH_PATH_UPDATE_REQ,
+	/// Confirmation to the MESH_PATH_UPDATE_REQ message
+	MESH_PATH_UPDATE_CFM,
+
+	/// Indication from Host that the indicated Mesh Interface is a proxy for=
 an
+	/// external STA
+	MESH_PROXY_ADD_REQ,
+
+	/// Indicate that a connection has been established or lost
+	MESH_PEER_UPDATE_IND,
+	/// Notification that a connection has been established or lost (when MPM
+	/// handled by userspace)
+	MESH_PEER_UPDATE_NTF =3D MESH_PEER_UPDATE_IND,
+
+	/// Indicate that a path is now active or inactive
+	MESH_PATH_UPDATE_IND,
+	/// Indicate that proxy information have been updated
+	MESH_PROXY_UPDATE_IND,
+
+	/// MAX number of messages
+	MESH_MAX,
+};
+
+/// Structure containing the parameters of the @ref MESH_START_REQ message=
.
+struct mesh_start_req {
+	/// Basic rate set
+	struct mac_rateset basic_rates;
+	/// Control channel on which we have to enable the AP
+	struct mac_chan_def chan;
+	/// Center frequency of the first segment
+	u32_l center_freq1;
+	/// Center frequency of the second segment (only in 80+80 configuration)
+	u32_l center_freq2;
+	/// Width of channel
+	u8_l ch_width;
+	/// DTIM Period
+	u8_l dtim_period;
+	/// Beacon Interval
+	u16_l bcn_int;
+	/// Index of the VIF for which the MP is started
+	u8_l vif_index;
+	/// Length of the Mesh ID
+	u8_l mesh_id_len;
+	/// Mesh ID
+	u8_l mesh_id[MESH_MESHID_MAX_LEN];
+	/// Address of the IEs to download
+	u32_l ie_addr;
+	/// Length of the provided IEs
+	u8_l ie_len;
+	/// Indicate if Mesh Peering Management (MPM) protocol is handled in
+	/// userspace
+	bool user_mpm;
+	/// Indicate if Mesh Point is using authentication
+	bool is_auth;
+	/// Indicate which authentication method is used
+	u8_l auth_id;
+};
+
+/// Structure containing the parameters of the @ref MESH_START_CFM message=
.
+struct mesh_start_cfm {
+	/// Status of the MP starting procedure
+	u8_l status;
+	/// Index of the VIF for which the MP is started
+	u8_l vif_idx;
+	/// Index of the channel context attached to the VIF
+	u8_l ch_idx;
+	/// Index of the STA used for BC/MC traffic
+	u8_l bcmc_idx;
+};
+
+/// Structure containing the parameters of the @ref MESH_STOP_REQ message.
+struct mesh_stop_req {
+	/// Index of the VIF for which the MP has to be stopped
+	u8_l vif_idx;
+};
+
+/// Structure containing the parameters of the @ref MESH_STOP_CFM message.
+struct mesh_stop_cfm {
+	/// Index of the VIF for which the MP has to be stopped
+	u8_l vif_idx;
+	/// Status
+	u8_l status;
+};
+
+/// Bit fields for mesh_update_req message's flags value
+enum mesh_update_flags_bit {
+	/// Root Mode
+	MESH_UPDATE_FLAGS_ROOT_MODE_BIT =3D 0,
+	/// Gate Mode
+	MESH_UPDATE_FLAGS_GATE_MODE_BIT,
+	/// Mesh Forwarding
+	MESH_UPDATE_FLAGS_MESH_FWD_BIT,
+	/// Local Power Save Mode
+	MESH_UPDATE_FLAGS_LOCAL_PSM_BIT,
+};
+
+/// Structure containing the parameters of the @ref MESH_UPDATE_REQ messag=
e.
+struct mesh_update_req {
+	/// Flags, indicate fields which have been updated
+	u8_l flags;
+	/// VIF Index
+	u8_l vif_idx;
+	/// Root Mode
+	u8_l root_mode;
+	/// Gate Announcement
+	bool gate_announ;
+	/// Mesh Forwarding
+	bool mesh_forward;
+	/// Local PS Mode
+	u8_l local_ps_mode;
+};
+
+/// Structure containing the parameters of the @ref MESH_UPDATE_CFM messag=
e.
+struct mesh_update_cfm {
+	/// Status
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref MESH_PEER_INFO_REQ mes=
sage.
+struct mesh_peer_info_req {
+	/// Index of the station allocated for the peer
+	u8_l sta_idx;
+};
+
+/// Structure containing the parameters of the @ref MESH_PEER_INFO_CFM mes=
sage.
+struct mesh_peer_info_cfm {
+	/// Response status
+	u8_l status;
+	/// Index of the station allocated for the peer
+	u8_l sta_idx;
+	/// Local Link ID
+	u16_l local_link_id;
+	/// Peer Link ID
+	u16_l peer_link_id;
+	/// Local PS Mode
+	u8_l local_ps_mode;
+	/// Peer PS Mode
+	u8_l peer_ps_mode;
+	/// Non-peer PS Mode
+	u8_l non_peer_ps_mode;
+	/// Link State
+	u8_l link_state;
+};
+
+/// Structure containing the parameters of the @ref MESH_PATH_CREATE_REQ
+/// message.
+struct mesh_path_create_req {
+	/// Index of the interface on which path has to be created
+	u8_l vif_idx;
+	/// Indicate if originator MAC Address is provided
+	bool has_orig_addr;
+	/// Path Target MAC Address
+	struct mac_addr tgt_mac_addr;
+	/// Originator MAC Address
+	struct mac_addr orig_mac_addr;
+};
+
+/// Structure containing the parameters of the @ref MESH_PATH_CREATE_CFM
+/// message.
+struct mesh_path_create_cfm {
+	/// Confirmation status
+	u8_l status;
+	/// VIF Index
+	u8_l vif_idx;
+};
+
+/// Structure containing the parameters of the @ref MESH_PATH_UPDATE_REQ
+/// message.
+struct mesh_path_update_req {
+	/// Indicate if path must be deleted
+	bool delete;
+	/// Index of the interface on which path has to be created
+	u8_l vif_idx;
+	/// Path Target MAC Address
+	struct mac_addr tgt_mac_addr;
+	/// Next Hop MAC Address
+	struct mac_addr nhop_mac_addr;
+};
+
+/// Structure containing the parameters of the @ref MESH_PATH_UPDATE_CFM
+/// message.
+struct mesh_path_update_cfm {
+	/// Confirmation status
+	u8_l status;
+	/// VIF Index
+	u8_l vif_idx;
+};
+
+/// Structure containing the parameters of the @ref MESH_PROXY_ADD_REQ mes=
sage.
+struct mesh_proxy_add_req {
+	/// VIF Index
+	u8_l vif_idx;
+	/// MAC Address of the External STA
+	struct mac_addr ext_sta_addr;
+};
+
+/// Structure containing the parameters of the @ref MESH_PROXY_UPDATE_IND
+struct mesh_proxy_update_ind {
+	/// Indicate if proxy information has been added or deleted
+	bool delete;
+	/// Indicate if we are a proxy for the external STA
+	bool local;
+	/// VIF Index
+	u8_l vif_idx;
+	/// MAC Address of the External STA
+	struct mac_addr ext_sta_addr;
+	/// MAC Address of the proxy (only valid if local is false)
+	struct mac_addr proxy_mac_addr;
+};
+
+/// Structure containing the parameters of the @ref MESH_PEER_UPDATE_IND
+/// message.
+struct mesh_peer_update_ind {
+	/// Indicate if connection has been established or lost
+	bool estab;
+	/// VIF Index
+	u8_l vif_idx;
+	/// STA Index
+	u8_l sta_idx;
+	/// Peer MAC Address
+	struct mac_addr peer_addr;
+};
+
+/// Structure containing the parameters of the @ref MESH_PEER_UPDATE_NTF
+/// message.
+struct mesh_peer_update_ntf {
+	/// VIF Index
+	u8_l vif_idx;
+	/// STA Index
+	u8_l sta_idx;
+	/// Mesh Link State
+	u8_l state;
+};
+
+/// Structure containing the parameters of the @ref MESH_PATH_UPDATE_IND
+/// message.
+struct mesh_path_update_ind {
+	/// Indicate if path is deleted or not
+	bool delete;
+	/// Indicate if path is towards an external STA (not part of MBSS)
+	bool ext_sta;
+	/// VIF Index
+	u8_l vif_idx;
+	/// Path Index
+	u8_l path_idx;
+	/// Target MAC Address
+	struct mac_addr tgt_mac_addr;
+	/// External STA MAC Address (only if ext_sta is true)
+	struct mac_addr ext_sta_mac_addr;
+	/// Next Hop STA Index
+	u8_l nhop_sta_idx;
+};
+
+//////////////////////////////////////////////////////////////////////////=
/////
+/////////// For Debug messages
+//////////////////////////////////////////////////////////////////////////=
/////
+
+/// Messages related to Debug Task
+enum dbg_msg_tag {
+	/// Memory read request
+	DBG_MEM_READ_REQ =3D LMAC_FIRST_MSG(TASK_DBG),
+	/// Memory read confirm
+	DBG_MEM_READ_CFM,
+	/// Memory write request
+	DBG_MEM_WRITE_REQ,
+	/// Memory write confirm
+	DBG_MEM_WRITE_CFM,
+	/// Module filter request
+	DBG_SET_MOD_FILTER_REQ,
+	/// Module filter confirm
+	DBG_SET_MOD_FILTER_CFM,
+	/// Severity filter request
+	DBG_SET_SEV_FILTER_REQ,
+	/// Severity filter confirm
+	DBG_SET_SEV_FILTER_CFM,
+	/// LMAC/MAC HW fatal error indication
+	DBG_ERROR_IND,
+	/// Request to get system statistics
+	DBG_GET_SYS_STAT_REQ,
+	/// COnfirmation of system statistics
+	DBG_GET_SYS_STAT_CFM,
+	/// Memory block write request
+	DBG_MEM_BLOCK_WRITE_REQ,
+	/// Memory block write confirm
+	DBG_MEM_BLOCK_WRITE_CFM,
+	/// Start app request
+	DBG_START_APP_REQ,
+	/// Start app confirm
+	DBG_START_APP_CFM,
+	/// Start npc request
+	DBG_START_NPC_REQ,
+	/// Start npc confirm
+	DBG_START_NPC_CFM,
+	/// Memory mask write request
+	DBG_MEM_MASK_WRITE_REQ,
+	/// Memory mask write confirm
+	DBG_MEM_MASK_WRITE_CFM,
+
+	DBG_RFTEST_CMD_REQ,
+	DBG_RFTEST_CMD_CFM,
+	DBG_BINDING_REQ,
+	DBG_BINDING_CFM,
+	DBG_BINDING_IND,
+
+	DBG_CUSTOM_MSG_REQ,
+	DBG_CUSTOM_MSG_CFM,
+	DBG_CUSTOM_MSG_IND,
+
+	DBG_GPIO_WRITE_REQ,
+	DBG_GPIO_WRITE_CFM,
+	DBG_GPIO_READ_REQ,
+	DBG_GPIO_READ_CFM,
+	DBG_GPIO_INIT_REQ,
+	DBG_GPIO_INIT_CFM,
+
+	/// EF usrdata read request
+	DBG_EF_USRDATA_READ_REQ,
+	/// EF usrdata read confirm
+	DBG_EF_USRDATA_READ_CFM,
+	/// Memory block read request
+	DBG_MEM_BLOCK_READ_REQ,
+	/// Memory block read confirm
+	DBG_MEM_BLOCK_READ_CFM,
+
+	DBG_PWM_INIT_REQ,
+	DBG_PWM_INIT_CFM,
+	DBG_PWM_DEINIT_REQ,
+	DBG_PWM_DEINIT_CFM,
+
+	/// Max number of Debug messages
+	DBG_MAX,
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_READ_REQ messa=
ge.
+struct dbg_mem_read_req {
+	u32_l memaddr;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_READ_CFM messa=
ge.
+struct dbg_mem_read_cfm {
+	u32_l memaddr;
+	u32_l memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_WRITE_REQ mess=
age.
+struct dbg_mem_write_req {
+	u32_l memaddr;
+	u32_l memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_WRITE_CFM mess=
age.
+struct dbg_mem_write_cfm {
+	u32_l memaddr;
+	u32_l memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_MASK_WRITE_REQ
+/// message.
+struct dbg_mem_mask_write_req {
+	u32_l memaddr;
+	u32_l memmask;
+	u32_l memdata;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_MASK_WRITE_CFM
+/// message.
+struct dbg_mem_mask_write_cfm {
+	u32_l memaddr;
+	u32_l memdata;
+};
+
+struct dbg_rftest_cmd_req {
+	u32_l cmd;
+	u32_l argc;
+	u8_l argv[30];
+};
+
+struct dbg_rftest_cmd_cfm {
+	u32_l rftest_result[18];
+};
+
+struct dbg_gpio_write_req {
+	u8 gpio_idx;
+	u8 gpio_val;
+};
+
+struct dbg_gpio_read_req {
+	u8 gpio_idx;
+};
+
+struct dbg_gpio_read_cfm {
+	u8 gpio_idx;
+	u8 gpio_val;
+};
+
+struct dbg_gpio_init_req {
+	u8 gpio_idx;
+	u8 gpio_dir; // 1 output, 0 input;
+	u8 gpio_val; // for output, 1 high, 0 low;
+};
+
+/// Structure containing the parameters of the @ref DBG_SET_MOD_FILTER_REQ
+/// message.
+struct dbg_set_mod_filter_req {
+	/// Bit field indicating for each module if the traces are enabled or not
+	u32_l mod_filter;
+};
+
+/// Structure containing the parameters of the @ref DBG_SEV_MOD_FILTER_REQ
+/// message.
+struct dbg_set_sev_filter_req {
+	/// Bit field indicating the severity threshold for the traces
+	u32_l sev_filter;
+};
+
+/// Structure containing the parameters of the @ref DBG_GET_SYS_STAT_CFM
+/// message.
+struct dbg_get_sys_stat_cfm {
+	/// Time spent in CPU sleep since last reset of the system statistics
+	u32_l cpu_sleep_time;
+	/// Time spent in DOZE since last reset of the system statistics
+	u32_l doze_time;
+	/// Total time spent since last reset of the system statistics
+	u32_l stats_time;
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_BLOCK_WRITE_RE=
Q
+/// message.
+struct dbg_mem_block_write_req {
+	u32_l memaddr;
+	u32_l memsize;
+	u32_l memdata[1024 / sizeof(u32_l)];
+};
+
+/// Structure containing the parameters of the @ref DBG_MEM_BLOCK_WRITE_CF=
M
+/// message.
+struct dbg_mem_block_write_cfm {
+	u32_l wstatus;
+};
+
+/// Structure containing the parameters of the @ref DBG_START_APP_REQ mess=
age.
+struct dbg_start_app_req {
+	u32_l bootaddr;
+	u32_l boottype;
+};
+
+/// Structure containing the parameters of the @ref DBG_START_APP_CFM mess=
age.
+struct dbg_start_app_cfm {
+	u32_l bootstatus;
+};
+
+enum {
+	HOST_START_APP_AUTO =3D 1,
+	HOST_START_APP_CUSTOM,
+	HOST_START_APP_FNCALL =3D 4,
+	HOST_START_APP_DUMMY =3D 5,
+};
+
+//////////////////////////////////////////////////////////////////////////=
/////
+/////////// For TDLS messages
+//////////////////////////////////////////////////////////////////////////=
/////
+
+/// List of messages related to the task.
+enum tdls_msg_tag {
+	/// TDLS channel Switch Request.
+	TDLS_CHAN_SWITCH_REQ =3D LMAC_FIRST_MSG(TASK_TDLS),
+	/// TDLS channel switch confirmation.
+	TDLS_CHAN_SWITCH_CFM,
+	/// TDLS channel switch indication.
+	TDLS_CHAN_SWITCH_IND,
+	/// TDLS channel switch to base channel indication.
+	TDLS_CHAN_SWITCH_BASE_IND,
+	/// TDLS cancel channel switch request.
+	TDLS_CANCEL_CHAN_SWITCH_REQ,
+	/// TDLS cancel channel switch confirmation.
+	TDLS_CANCEL_CHAN_SWITCH_CFM,
+	/// TDLS peer power save indication.
+	TDLS_PEER_PS_IND,
+	/// TDLS peer traffic indication request.
+	TDLS_PEER_TRAFFIC_IND_REQ,
+	/// TDLS peer traffic indication confirmation.
+	TDLS_PEER_TRAFFIC_IND_CFM,
+
+#ifdef CONFIG_SDIO_BT
+	TDLS_SDIO_BT_SEND_REQ =3D LMAC_FIRST_MSG(TASK_TDLS) + 16,
+	TDLS_SDIO_BT_SEND_CFM,
+	TDLS_SDIO_BT_RECV_IND,
+#endif
+	/// MAX number of messages
+	TDLS_MAX
+};
+
+/// Structure containing the parameters of the @ref TDLS_CHAN_SWITCH_REQ m=
essage
+struct tdls_chan_switch_req {
+	/// Index of the VIF
+	u8_l vif_index;
+	/// STA Index
+	u8_l sta_idx;
+	/// MAC address of the TDLS station
+	struct mac_addr peer_mac_addr;
+	bool initiator;
+	/// Band (2.4GHz or 5GHz)
+	u8_l band;
+	/// Channel type: 20,40,80,160 or 80+80 MHz
+	u8_l type;
+	/// Frequency for Primary 20MHz channel (in MHz)
+	u16_l prim20_freq;
+	/// Frequency for Center of the contiguous channel or center of Primary
+	/// 80+80
+	u16_l center1_freq;
+	/// Frequency for Center of the non-contiguous secondary 80+80
+	u16_l center2_freq;
+	/// TX power (in dBm)
+	s8_l tx_power;
+	/// Operating class
+	u8_l op_class;
+};
+
+/// Structure containing the parameters of the @ref TDLS_CANCEL_CHAN_SWITC=
H_REQ
+/// message
+struct tdls_cancel_chan_switch_req {
+	/// Index of the VIF
+	u8_l vif_index;
+	/// STA Index
+	u8_l sta_idx;
+	/// MAC address of the TDLS station
+	struct mac_addr peer_mac_addr;
+};
+
+/// Structure containing the parameters of the @ref TDLS_CHAN_SWITCH_CFM m=
essage
+struct tdls_chan_switch_cfm {
+	/// Status of the operation
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref TDLS_CANCEL_CHAN_SWITC=
H_CFM
+/// message
+struct tdls_cancel_chan_switch_cfm {
+	/// Status of the operation
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref TDLS_CHAN_SWITCH_IND m=
essage
+struct tdls_chan_switch_ind {
+	/// VIF Index
+	u8_l vif_index;
+	/// Channel Context Index
+	u8_l chan_ctxt_index;
+	/// Status of the operation
+	u8_l status;
+};
+
+/// Structure containing the parameters of the @ref TDLS_CHAN_SWITCH_BASE_=
IND
+/// message
+struct tdls_chan_switch_base_ind {
+	/// VIF Index
+	u8_l vif_index;
+	/// Channel Context index
+	u8_l chan_ctxt_index;
+};
+
+/// Structure containing the parameters of the @ref TDLS_PEER_PS_IND messa=
ge
+struct tdls_peer_ps_ind {
+	/// VIF Index
+	u8_l vif_index;
+	/// STA Index
+	u8_l sta_idx;
+	/// MAC ADDR of the TDLS STA
+	struct mac_addr peer_mac_addr;
+	/// Flag to indicate if the TDLS peer is going to sleep
+	bool ps_on;
+};
+
+/// Structure containing the parameters of the @ref TDLS_PEER_TRAFFIC_IND_=
REQ
+/// message
+struct tdls_peer_traffic_ind_req {
+	/// VIF Index
+	u8_l vif_index;
+	/// STA Index
+	u8_l sta_idx;
+	// MAC ADDR of the TDLS STA
+	struct mac_addr peer_mac_addr;
+	/// Dialog token
+	u8_l dialog_token;
+	/// TID of the latest MPDU transmitted over the TDLS direct link to the T=
DLS
+	/// STA
+	u8_l last_tid;
+	/// Sequence number of the latest MPDU transmitted over the TDLS direct l=
ink
+	/// to the TDLS STA
+	u16_l last_sn;
+};
+
+/// Structure containing the parameters of the @ref TDLS_PEER_TRAFFIC_IND_=
CFM
+/// message
+struct tdls_peer_traffic_ind_cfm {
+	/// Status of the operation
+	u8_l status;
+};
+
+#endif // LMAC_MSG_H_
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/lmac_types.h b/drivers/n=
et/wireless/aic/aic8800_fdrv/lmac_types.h
new file mode 100644
index 0000000000000..59537b4575ddd
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/lmac_types.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file co_types.h
+ *
+ * @brief This file replaces the need to include stdint or stdbool typical
+ *headers, which may not be available in all toolchains, and adds new type=
s
+ *
+ *************************************************************************=
***************
+ */
+
+#ifndef _LMAC_INT_H_
+#define _LMAC_INT_H_
+
+#include <linux/types.h>
+#include <linux/version.h>
+#include <linux/bits.h>
+
+#ifdef CONFIG_RWNX_TL4
+typedef u16 u8_l;
+typedef s16 s8_l;
+typedef u16 bool_l;
+#else
+typedef u8 u8_l;
+typedef s8 s8_l;
+#endif
+typedef u16 u16_l;
+typedef s16 s16_l;
+typedef u32 u32_l;
+typedef s32 s32_l;
+typedef u64 u64_l;
+
+/// @} CO_INT
+#endif // _LMAC_INT_H_
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/md5.c b/drivers/net/wire=
less/aic/aic8800_fdrv/md5.c
new file mode 100644
index 0000000000000..e2ef60d9475c4
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/md5.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief md5 check
+ *
+ *************************************************************************=
***************
+ */
+
+#include "md5.h"
+#include <linux/memory.h>
+
+unsigned char PADDING[] =3D {0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, =
0, 0,
+			   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+
+void md5_init(struct MD5_CTX *context)
+{
+	context->count[0] =3D 0;
+	context->count[1] =3D 0;
+	context->state[0] =3D 0x67452301;
+	context->state[1] =3D 0xEFCDAB89;
+	context->state[2] =3D 0x98BADCFE;
+	context->state[3] =3D 0x10325476;
+}
+
+void md5_update(struct MD5_CTX *context, unsigned char *input, unsigned in=
t inputlen)
+{
+	unsigned int i =3D 0, index =3D 0, partlen =3D 0;
+
+	index =3D (context->count[0] >> 3) & 0x3F;
+	partlen =3D 64 - index;
+	context->count[0] +=3D inputlen << 3;
+	if (context->count[0] < (inputlen << 3))
+		context->count[1]++;
+	context->count[1] +=3D inputlen >> 29;
+
+	if (inputlen >=3D partlen) {
+		memcpy(&context->buffer[index], input, partlen);
+		md5_transform(context->state, context->buffer);
+		for (i =3D partlen; i + 64 <=3D inputlen; i +=3D 64)
+			md5_transform(context->state, &input[i]);
+		index =3D 0;
+	} else {
+		i =3D 0;
+	}
+	memcpy(&context->buffer[index], &input[i], inputlen - i);
+}
+
+void md5_final(struct MD5_CTX *context, unsigned char digest[16])
+{
+	unsigned int index =3D 0, padlen =3D 0;
+	unsigned char bits[8];
+
+	index =3D (context->count[0] >> 3) & 0x3F;
+	padlen =3D (index < 56) ? (56 - index) : (120 - index);
+	md5_encode(bits, context->count, 8);
+	md5_update(context, PADDING, padlen);
+	md5_update(context, bits, 8);
+	md5_encode(digest, context->state, 16);
+}
+
+void md5_encode(unsigned char *output, unsigned int *input, unsigned int l=
en)
+{
+	unsigned int i =3D 0, j =3D 0;
+
+	while (j < len) {
+		output[j] =3D input[i] & 0xFF;
+		output[j + 1] =3D (input[i] >> 8) & 0xFF;
+		output[j + 2] =3D (input[i] >> 16) & 0xFF;
+		output[j + 3] =3D (input[i] >> 24) & 0xFF;
+		i++;
+		j +=3D 4;
+	}
+}
+
+void md5_decode(unsigned int *output, unsigned char *input, unsigned int l=
en)
+{
+	unsigned int i =3D 0, j =3D 0;
+
+	while (j < len) {
+		output[i] =3D (input[j]) | (input[j + 1] << 8) | (input[j + 2] << 16) |
+					(input[j + 3] << 24);
+		i++;
+		j +=3D 4;
+	}
+}
+
+void md5_transform(unsigned int state[4], unsigned char block[64])
+{
+	unsigned int a =3D state[0];
+	unsigned int b =3D state[1];
+	unsigned int c =3D state[2];
+	unsigned int d =3D state[3];
+	unsigned int x[64];
+
+	md5_decode(x, block, 64);
+	FF(a, b, c, d, x[0], 7, 0xd76aa478);   /* 1 */
+	FF(d, a, b, c, x[1], 12, 0xe8c7b756);  /* 2 */
+	FF(c, d, a, b, x[2], 17, 0x242070db);  /* 3 */
+	FF(b, c, d, a, x[3], 22, 0xc1bdceee);  /* 4 */
+	FF(a, b, c, d, x[4], 7, 0xf57c0faf);   /* 5 */
+	FF(d, a, b, c, x[5], 12, 0x4787c62a);  /* 6 */
+	FF(c, d, a, b, x[6], 17, 0xa8304613);  /* 7 */
+	FF(b, c, d, a, x[7], 22, 0xfd469501);  /* 8 */
+	FF(a, b, c, d, x[8], 7, 0x698098d8);   /* 9 */
+	FF(d, a, b, c, x[9], 12, 0x8b44f7af);  /* 10 */
+	FF(c, d, a, b, x[10], 17, 0xffff5bb1); /* 11 */
+	FF(b, c, d, a, x[11], 22, 0x895cd7be); /* 12 */
+	FF(a, b, c, d, x[12], 7, 0x6b901122);  /* 13 */
+	FF(d, a, b, c, x[13], 12, 0xfd987193); /* 14 */
+	FF(c, d, a, b, x[14], 17, 0xa679438e); /* 15 */
+	FF(b, c, d, a, x[15], 22, 0x49b40821); /* 16 */
+
+	/* Round 2 */
+	GG(a, b, c, d, x[1], 5, 0xf61e2562);   /* 17 */
+	GG(d, a, b, c, x[6], 9, 0xc040b340);   /* 18 */
+	GG(c, d, a, b, x[11], 14, 0x265e5a51); /* 19 */
+	GG(b, c, d, a, x[0], 20, 0xe9b6c7aa);  /* 20 */
+	GG(a, b, c, d, x[5], 5, 0xd62f105d);   /* 21 */
+	GG(d, a, b, c, x[10], 9, 0x2441453);   /* 22 */
+	GG(c, d, a, b, x[15], 14, 0xd8a1e681); /* 23 */
+	GG(b, c, d, a, x[4], 20, 0xe7d3fbc8);  /* 24 */
+	GG(a, b, c, d, x[9], 5, 0x21e1cde6);   /* 25 */
+	GG(d, a, b, c, x[14], 9, 0xc33707d6);  /* 26 */
+	GG(c, d, a, b, x[3], 14, 0xf4d50d87);  /* 27 */
+	GG(b, c, d, a, x[8], 20, 0x455a14ed);  /* 28 */
+	GG(a, b, c, d, x[13], 5, 0xa9e3e905);  /* 29 */
+	GG(d, a, b, c, x[2], 9, 0xfcefa3f8);   /* 30 */
+	GG(c, d, a, b, x[7], 14, 0x676f02d9);  /* 31 */
+	GG(b, c, d, a, x[12], 20, 0x8d2a4c8a); /* 32 */
+
+	/* Round 3 */
+	HH(a, b, c, d, x[5], 4, 0xfffa3942);   /* 33 */
+	HH(d, a, b, c, x[8], 11, 0x8771f681);  /* 34 */
+	HH(c, d, a, b, x[11], 16, 0x6d9d6122); /* 35 */
+	HH(b, c, d, a, x[14], 23, 0xfde5380c); /* 36 */
+	HH(a, b, c, d, x[1], 4, 0xa4beea44);   /* 37 */
+	HH(d, a, b, c, x[4], 11, 0x4bdecfa9);  /* 38 */
+	HH(c, d, a, b, x[7], 16, 0xf6bb4b60);  /* 39 */
+	HH(b, c, d, a, x[10], 23, 0xbebfbc70); /* 40 */
+	HH(a, b, c, d, x[13], 4, 0x289b7ec6);  /* 41 */
+	HH(d, a, b, c, x[0], 11, 0xeaa127fa);  /* 42 */
+	HH(c, d, a, b, x[3], 16, 0xd4ef3085);  /* 43 */
+	HH(b, c, d, a, x[6], 23, 0x4881d05);   /* 44 */
+	HH(a, b, c, d, x[9], 4, 0xd9d4d039);   /* 45 */
+	HH(d, a, b, c, x[12], 11, 0xe6db99e5); /* 46 */
+	HH(c, d, a, b, x[15], 16, 0x1fa27cf8); /* 47 */
+	HH(b, c, d, a, x[2], 23, 0xc4ac5665);  /* 48 */
+
+	/* Round 4 */
+	II(a, b, c, d, x[0], 6, 0xf4292244);   /* 49 */
+	II(d, a, b, c, x[7], 10, 0x432aff97);  /* 50 */
+	II(c, d, a, b, x[14], 15, 0xab9423a7); /* 51 */
+	II(b, c, d, a, x[5], 21, 0xfc93a039);  /* 52 */
+	II(a, b, c, d, x[12], 6, 0x655b59c3);  /* 53 */
+	II(d, a, b, c, x[3], 10, 0x8f0ccc92);  /* 54 */
+	II(c, d, a, b, x[10], 15, 0xffeff47d); /* 55 */
+	II(b, c, d, a, x[1], 21, 0x85845dd1);  /* 56 */
+	II(a, b, c, d, x[8], 6, 0x6fa87e4f);   /* 57 */
+	II(d, a, b, c, x[15], 10, 0xfe2ce6e0); /* 58 */
+	II(c, d, a, b, x[6], 15, 0xa3014314);  /* 59 */
+	II(b, c, d, a, x[13], 21, 0x4e0811a1); /* 60 */
+	II(a, b, c, d, x[4], 6, 0xf7537e82);   /* 61 */
+	II(d, a, b, c, x[11], 10, 0xbd3af235); /* 62 */
+	II(c, d, a, b, x[2], 15, 0x2ad7d2bb);  /* 63 */
+	II(b, c, d, a, x[9], 21, 0xeb86d391);  /* 64 */
+	state[0] +=3D a;
+	state[1] +=3D b;
+	state[2] +=3D c;
+	state[3] +=3D d;
+}
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/md5.h b/drivers/net/wire=
less/aic/aic8800_fdrv/md5.h
new file mode 100644
index 0000000000000..95ad6e18256d3
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/md5.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef MD5_H
+#define MD5_H
+
+#include <linux/types.h>
+#include <asm/types.h>
+
+struct MD5_CTX {
+	unsigned int count[2];
+	unsigned int state[4];
+	unsigned char buffer[64];
+};
+
+static inline u32 F(u32 x, u32 y, u32 z)
+{
+	return (x & y) | (~x & z);
+}
+
+static inline u32 G(u32 x, u32 y, u32 z)
+{
+	return (x & z) | (y & ~z);
+}
+
+static inline u32 H(u32 x, u32 y, u32 z)
+{
+	return x ^ y ^ z;
+}
+
+static inline u32 I(u32 x, u32 y, u32 z)
+{
+	return y ^ (x | ~z);
+}
+
+static inline u32 ROTATE_LEFT(u32 x, u32 n)
+{
+	return (x << n) | (x >> (32 - n));
+}
+
+static inline u32 FF(u32 a, u32 b, u32 c, u32 d,
+		     u32 x, u32 s, u32 ac)
+{
+	a +=3D F(b, c, d) + x + ac;
+	a =3D ROTATE_LEFT(a, s);
+	a +=3D b;
+	return a;
+}
+
+static inline u32 GG(u32 a, u32 b, u32 c, u32 d,
+		     u32 x, u32 s, u32 ac)
+{
+	a +=3D G(b, c, d) + x + ac;
+	a =3D ROTATE_LEFT(a, s);
+	a +=3D b;
+	return a;
+}
+
+static inline u32 HH(u32 a, u32 b, u32 c, u32 d,
+		     u32 x, u32 s, u32 ac)
+{
+	a +=3D H(b, c, d) + x + ac;
+	a =3D ROTATE_LEFT(a, s);
+	a +=3D b;
+	return a;
+}
+
+static inline u32 II(u32 a, u32 b, u32 c, u32 d,
+		     u32 x, u32 s, u32 ac)
+{
+	a +=3D I(b, c, d) + x + ac;
+	a =3D ROTATE_LEFT(a, s);
+	a +=3D b;
+	return a;
+}
+
+void md5_init(struct MD5_CTX *context);
+void md5_update(struct MD5_CTX *context, unsigned char *input, unsigned in=
t inputlen);
+void md5_final(struct MD5_CTX *context, unsigned char digest[16]);
+void md5_transform(unsigned int state[4], unsigned char block[64]);
+void md5_encode(unsigned char *output, unsigned int *input, unsigned int l=
en);
+void md5_decode(unsigned int *output, unsigned char *input, unsigned int l=
en);
+
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/reg_access.h b/drivers/n=
et/wireless/aic/aic8800_fdrv/reg_access.h
new file mode 100644
index 0000000000000..fbdb87b44552d
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/reg_access.h
@@ -0,0 +1,146 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
*****
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief Definitions and macros for MAC HW and platform register accesses
+ *
+ *************************************************************************=
*****
+ */
+
+#ifndef REG_ACCESS_H_
+#define REG_ACCESS_H_
+
+/*************************************************************************=
****
+ * Addresses within RWNX_ADDR_SYSTEM
+ *************************************************************************=
****/
+/* Shard RAM */
+#define SHARED_RAM_START_ADDR 0x00000000
+
+/* IPC registers */
+#define IPC_REG_BASE_ADDR 0x00800000
+
+/* System Controller Registers */
+#define SYSCTRL_SIGNATURE_ADDR    0x00900000
+// old diag register name
+#define SYSCTRL_DIAG_CONF_ADDR    0x00900068
+#define SYSCTRL_PHYDIAG_CONF_ADDR 0x00900074
+#define SYSCTRL_RIUDIAG_CONF_ADDR 0x00900078
+// new diag register name
+#define SYSCTRL_DIAG_CONF0        0x00900064
+#define SYSCTRL_DIAG_CONF1        0x00900068
+#define SYSCTRL_DIAG_CONF2        0x00900074
+#define SYSCTRL_DIAG_CONF3        0x00900078
+#define SYSCTRL_MISC_CNTL_ADDR    0x009000E0
+#define BOOTROM_ENABLE            BIT(4)
+#define FPGA_B_RESET              BIT(1)
+#define SOFT_RESET                BIT(0)
+
+/* MAC platform */
+#define NXMAC_VERSION_1_ADDR         0x00B00004
+#define NXMAC_MU_MIMO_TX_BIT         BIT(19)
+#define NXMAC_BFMER_BIT              BIT(18)
+#define NXMAC_BFMEE_BIT              BIT(17)
+#define NXMAC_MAC_80211MH_FORMAT_BIT BIT(16)
+#define NXMAC_COEX_BIT               BIT(14)
+#define NXMAC_WAPI_BIT               BIT(13)
+#define NXMAC_TPC_BIT                BIT(12)
+#define NXMAC_VHT_BIT                BIT(11)
+#define NXMAC_HT_BIT                 BIT(10)
+#define NXMAC_RCE_BIT                BIT(8)
+#define NXMAC_CCMP_BIT               BIT(7)
+#define NXMAC_TKIP_BIT               BIT(6)
+#define NXMAC_WEP_BIT                BIT(5)
+#define NXMAC_SECURITY_BIT           BIT(4)
+#define NXMAC_SME_BIT                BIT(3)
+#define NXMAC_HCCA_BIT               BIT(2)
+#define NXMAC_EDCA_BIT               BIT(1)
+#define NXMAC_QOS_BIT                BIT(0)
+
+#define NXMAC_RX_CNTRL_ADDR                   0x00B00060
+#define NXMAC_EN_DUPLICATE_DETECTION_BIT      BIT(31)
+#define NXMAC_ACCEPT_UNKNOWN_BIT              BIT(30)
+#define NXMAC_ACCEPT_OTHER_DATA_FRAMES_BIT    BIT(29)
+#define NXMAC_ACCEPT_QO_S_NULL_BIT            BIT(28)
+#define NXMAC_ACCEPT_QCFWO_DATA_BIT           BIT(27)
+#define NXMAC_ACCEPT_Q_DATA_BIT               BIT(26)
+#define NXMAC_ACCEPT_CFWO_DATA_BIT            BIT(25)
+#define NXMAC_ACCEPT_DATA_BIT                 BIT(24)
+#define NXMAC_ACCEPT_OTHER_CNTRL_FRAMES_BIT   BIT(23)
+#define NXMAC_ACCEPT_CF_END_BIT               BIT(22)
+#define NXMAC_ACCEPT_ACK_BIT                  BIT(21)
+#define NXMAC_ACCEPT_CTS_BIT                  BIT(20)
+#define NXMAC_ACCEPT_RTS_BIT                  BIT(19)
+#define NXMAC_ACCEPT_PS_POLL_BIT              BIT(18)
+#define NXMAC_ACCEPT_BA_BIT                   BIT(17)
+#define NXMAC_ACCEPT_BAR_BIT                  BIT(16)
+#define NXMAC_ACCEPT_OTHER_MGMT_FRAMES_BIT    BIT(15)
+#define NXMAC_ACCEPT_BFMEE_FRAMES_BIT         BIT(14)
+#define NXMAC_ACCEPT_ALL_BEACON_BIT           BIT(13)
+#define NXMAC_ACCEPT_NOT_EXPECTED_BA_BIT      BIT(12)
+#define NXMAC_ACCEPT_DECRYPT_ERROR_FRAMES_BIT BIT(11)
+#define NXMAC_ACCEPT_BEACON_BIT               BIT(10)
+#define NXMAC_ACCEPT_PROBE_RESP_BIT           BIT(9)
+#define NXMAC_ACCEPT_PROBE_REQ_BIT            BIT(8)
+#define NXMAC_ACCEPT_MY_UNICAST_BIT           BIT(7)
+#define NXMAC_ACCEPT_UNICAST_BIT              BIT(6)
+#define NXMAC_ACCEPT_ERROR_FRAMES_BIT         BIT(5)
+#define NXMAC_ACCEPT_OTHER_BSSID_BIT          BIT(4)
+#define NXMAC_ACCEPT_BROADCAST_BIT            BIT(3)
+#define NXMAC_ACCEPT_MULTICAST_BIT            BIT(2)
+#define NXMAC_DONT_DECRYPT_BIT                BIT(1)
+#define NXMAC_EXC_UNENCRYPTED_BIT             BIT(0)
+
+#define NXMAC_DEBUG_PORT_SEL_ADDR     0x00B00510
+#define NXMAC_SW_SET_PROFILING_ADDR   0x00B08564
+#define NXMAC_SW_CLEAR_PROFILING_ADDR 0x00B08568
+
+/* Modem Status */
+#define MDM_HDMCONFIG_ADDR 0x00C00000
+
+/* Clock gating configuration */
+#define MDM_MEMCLKCTRL0_ADDR   0x00C00848
+#define MDM_CLKGATEFCTRL0_ADDR 0x00C00874
+#define CRM_CLKGATEFCTRL0_ADDR 0x00940010
+
+/* AGC (trident) */
+#define AGC_RWNXAGCCNTL_ADDR 0x00C02060
+
+/* LDPC RAM*/
+#define PHY_LDPC_RAM_ADDR 0x00C09000
+
+/* FCU (elma )*/
+#define FCU_RWNXFCAGCCNTL_ADDR 0x00C09034
+
+/* AGC RAM */
+#define PHY_AGC_UCODE_ADDR 0x00C0A000
+
+/* RIU */
+#define RIU_RWNXVERSION_ADDR         0x00C0B000
+#define RIU_RWNXDYNAMICCONFIG_ADDR   0x00C0B008
+#define RIU_AGCMEMBISTSTAT_ADDR      0x00C0B238
+#define RIU_AGCMEMSIGNATURESTAT_ADDR 0x00C0B23C
+#define RIU_RWNXAGCCNTL_ADDR         0x00C0B390
+
+/* FCU RAM */
+#define PHY_FCU_UCODE_ADDR 0x00C0E000
+
+/* RF ITF */
+#define FPGAB_MPIF_SEL_ADDR       0x00C10030
+#define RF_V6_DIAGPORT_CONF1_ADDR 0x00C10010
+#define RF_v6_PHYDIAG_CONF1_ADDR  0x00C10018
+
+#define RF_V7_DIAGPORT_CONF1_ADDR 0x00F10010
+#define RF_v7_PHYDIAG_CONF1_ADDR  0x00F10018
+
+/*************************************************************************=
****
+ * Macros for generated register files
+ *************************************************************************=
****/
+/* Macros for IPC registers access (used in reg_ipc_app.h) */
+#define REG_IPC_APP_RD(env, INDEX)                                        =
     \
+	(*(u32 *)((u8 *)(env) + IPC_REG_BASE_ADDR + 4 * (INDEX)))
+
+#define REG_IPC_APP_WR(env, INDEX, value)                                 =
     \
+	(*(u32 *)((u8 *)(env) + IPC_REG_BASE_ADDR + 4 * (INDEX)) =3D value)
+
+#endif /* REG_ACCESS_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.c b/drivers/ne=
t/wireless/aic/aic8800_fdrv/rwnx_cmds.c
new file mode 100644
index 0000000000000..0aabf28a531cb
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.c
@@ -0,0 +1,471 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
*****
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief Handles queueing (push to IPC, ack/cfm from IPC) of commands iss=
ued to
+ * LMAC FW
+ *
+ *************************************************************************=
*****
+ */
+
+#include "rwnx_cmds.h"
+#include "aicwf_txrxif.h"
+#include "rwnx_defs.h"
+#include "rwnx_events.h"
+#include "rwnx_strs.h"
+#include <linux/list.h>
+#ifdef AICWF_SDIO_SUPPORT
+#include "aicwf_sdio.h"
+#else
+#include "aicwf_usb.h"
+#endif
+
+static void cmd_dump(const struct rwnx_cmd *cmd)
+{
+	if (!cmd) {
+		AICWFDBG(LOGDEBUG, KERN_ERR "AICWF %s cmd is null\n", __func__);
+		return;
+	}
+	AICWFDBG(LOGDEBUG, KERN_CRIT
+		 "tkn[%d]  flags:%04x  result:%3d  cmd:%4d-%-24s - reqcfm(%4d-%-s)\n",
+		 cmd->tkn, cmd->flags, cmd->result, cmd->id, RWNX_ID2STR(cmd->id),
+		 cmd->reqid,
+		 cmd->reqid !=3D (lmac_msg_id_t)-1 ? RWNX_ID2STR(cmd->reqid) : "none");
+}
+
+static void cmd_complete(struct rwnx_cmd_mgr *cmd_mgr, struct rwnx_cmd *cm=
d)
+{
+	// RWNX_DBG(RWNX_FN_ENTRY_STR); //debug trace
+	lockdep_assert_held(&cmd_mgr->lock);
+
+	list_del(&cmd->list);
+	cmd_mgr->queue_sz--;
+
+	cmd->flags |=3D RWNX_CMD_FLAG_DONE;
+	if (cmd->flags & RWNX_CMD_FLAG_NONBLOCK) {
+		rwnx_cmd_free(cmd); // kfree(cmd);
+	} else {
+		if (RWNX_CMD_WAIT_COMPLETE(cmd->flags)) {
+			cmd->result =3D 0;
+			complete(&cmd->complete);
+		}
+	}
+}
+
+int cmd_mgr_queue_force_defer(struct rwnx_cmd_mgr *cmd_mgr,
+			      struct rwnx_cmd *cmd)
+{
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+#ifdef AIC8800_CREATE_TRACE_POINTS
+	trace_msg_send(cmd->id);
+#endif
+	spin_lock_bh(&cmd_mgr->lock);
+
+	if (cmd_mgr->state =3D=3D RWNX_CMD_MGR_STATE_CRASHED) {
+		AICWFDBG(LOGDEBUG, KERN_CRIT "AICWF cmd queue crashed\n");
+		cmd->result =3D -EPIPE;
+		spin_unlock_bh(&cmd_mgr->lock);
+		return -EPIPE;
+	}
+
+	if (!list_empty(&cmd_mgr->cmds)) {
+		if (cmd_mgr->queue_sz =3D=3D cmd_mgr->max_queue_sz) {
+			AICWFDBG(LOGDEBUG, KERN_CRIT "AICWF Too many cmds (%d) already queued\n=
",
+				 cmd_mgr->max_queue_sz);
+			cmd->result =3D -ENOMEM;
+			spin_unlock_bh(&cmd_mgr->lock);
+			return -ENOMEM;
+		}
+	}
+
+	cmd->flags |=3D RWNX_CMD_FLAG_WAIT_PUSH;
+
+	if (cmd->flags & RWNX_CMD_FLAG_REQ_CFM)
+		cmd->flags |=3D RWNX_CMD_FLAG_WAIT_CFM;
+
+	cmd->tkn =3D cmd_mgr->next_tkn++;
+	cmd->result =3D -EINTR;
+
+	if (!(cmd->flags & RWNX_CMD_FLAG_NONBLOCK))
+		init_completion(&cmd->complete);
+
+	list_add_tail(&cmd->list, &cmd_mgr->cmds);
+	cmd_mgr->queue_sz++;
+	spin_unlock_bh(&cmd_mgr->lock);
+
+	WAKE_CMD_WORK(cmd_mgr);
+	return 0;
+}
+
+static int cmd_mgr_queue(struct rwnx_cmd_mgr *cmd_mgr, struct rwnx_cmd *cm=
d)
+{
+#ifdef AICWF_SDIO_SUPPORT
+	int ret;
+	struct aic_sdio_dev *sdiodev =3D
+		container_of(cmd_mgr, struct aic_sdio_dev, cmd_mgr);
+#endif
+	bool defer_push =3D false;
+
+	// RWNX_DBG(RWNX_FN_ENTRY_STR); //debug trace
+#ifdef AIC8800_CREATE_TRACE_POINTS
+	trace_msg_send(cmd->id);
+#endif
+	spin_lock_bh(&cmd_mgr->lock);
+
+	if (cmd_mgr->state =3D=3D RWNX_CMD_MGR_STATE_CRASHED) {
+		AICWFDBG(LOGDEBUG, KERN_CRIT "AICWF cmd queue crashed\n");
+		cmd->result =3D -EPIPE;
+		spin_unlock_bh(&cmd_mgr->lock);
+		return -EPIPE;
+	}
+
+	if (!list_empty(&cmd_mgr->cmds)) {
+		struct rwnx_cmd *last;
+
+		if (cmd_mgr->queue_sz =3D=3D cmd_mgr->max_queue_sz) {
+			AICWFDBG(LOGDEBUG, KERN_CRIT "AICWF Too many cmds (%d) already queued\n=
",
+				 cmd_mgr->max_queue_sz);
+			cmd->result =3D -ENOMEM;
+			spin_unlock_bh(&cmd_mgr->lock);
+			return -ENOMEM;
+		}
+		last =3D list_entry(cmd_mgr->cmds.prev, struct rwnx_cmd, list);
+		if (last->flags & (RWNX_CMD_FLAG_WAIT_ACK | RWNX_CMD_FLAG_WAIT_PUSH |
+				   RWNX_CMD_FLAG_WAIT_CFM)) {
+			cmd->flags |=3D RWNX_CMD_FLAG_WAIT_PUSH;
+			defer_push =3D true;
+		}
+	}
+
+	if (cmd->flags & RWNX_CMD_FLAG_REQ_CFM)
+		cmd->flags |=3D RWNX_CMD_FLAG_WAIT_CFM;
+
+	cmd->tkn =3D cmd_mgr->next_tkn++;
+	cmd->result =3D -EINTR;
+
+	if (!(cmd->flags & RWNX_CMD_FLAG_NONBLOCK))
+		init_completion(&cmd->complete);
+
+	list_add_tail(&cmd->list, &cmd_mgr->cmds);
+	cmd_mgr->queue_sz++;
+
+#ifdef AICWF_ARP_OFFLOAD
+	if (cmd->a2e_msg->id =3D=3D ME_TRAFFIC_IND_REQ ||
+	    cmd->a2e_msg->id =3D=3D MM_SET_ARPOFFLOAD_REQ) {
+#else
+	if (cmd->a2e_msg->id =3D=3D ME_TRAFFIC_IND_REQ) {
+#endif
+		defer_push =3D true;
+		cmd->flags |=3D RWNX_CMD_FLAG_WAIT_PUSH;
+	}
+
+	spin_unlock_bh(&cmd_mgr->lock);
+	if (!defer_push) {
+#ifdef AICWF_SDIO_SUPPORT
+		aicwf_set_cmd_tx((void *)(sdiodev), cmd->a2e_msg,
+				 sizeof(struct lmac_msg) + cmd->a2e_msg->param_len);
+#else
+		aicwf_set_cmd_tx((void *)(usbdev), cmd->a2e_msg,
+				 sizeof(struct lmac_msg) + cmd->a2e_msg->param_len);
+#endif
+		kfree(cmd->a2e_msg);
+	} else {
+		if (cmd_mgr->queue_sz <=3D 1)
+			WAKE_CMD_WORK(cmd_mgr);
+		return 0;
+	}
+
+	if (!(cmd->flags & RWNX_CMD_FLAG_NONBLOCK)) {
+		unsigned long tout =3D
+			msecs_to_jiffies(RWNX_80211_CMD_TIMEOUT_MS * cmd_mgr->queue_sz);
+		if (!wait_for_completion_timeout(&cmd->complete, tout)) {
+			AICWFDBG(LOGDEBUG, KERN_CRIT "AICWF cmd timed-out\n");
+#ifdef AICWF_SDIO_SUPPORT
+			ret =3D aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.wakeup_reg, 2);
+			if (ret < 0) {
+				sdio_err("reg:%d write failed!\n",
+					 sdiodev->sdio_reg.wakeup_reg);
+			}
+#endif
+
+			cmd_dump(cmd);
+			spin_lock_bh(&cmd_mgr->lock);
+			cmd_mgr->state =3D RWNX_CMD_MGR_STATE_CRASHED;
+			if (!(cmd->flags & RWNX_CMD_FLAG_DONE)) {
+				cmd->result =3D -ETIMEDOUT;
+				cmd_complete(cmd_mgr, cmd);
+			}
+			spin_unlock_bh(&cmd_mgr->lock);
+		} else {
+			rwnx_cmd_free(cmd); // kfree(cmd);
+			if (!list_empty(&cmd_mgr->cmds))
+				WAKE_CMD_WORK(cmd_mgr);
+		}
+	} else {
+		cmd->result =3D 0;
+	}
+
+	return 0;
+}
+
+static int cmd_mgr_llind(struct rwnx_cmd_mgr *cmd_mgr, struct rwnx_cmd *cm=
d)
+{
+	struct rwnx_cmd *cur, *acked =3D NULL;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	spin_lock_bh(&cmd_mgr->lock);
+	list_for_each_entry(cur, &cmd_mgr->cmds, list) {
+		if (!acked) {
+			if (cur->tkn =3D=3D cmd->tkn) {
+				if (WARN_ON_ONCE(cur !=3D cmd))
+					cmd_dump(cmd);
+				acked =3D cur;
+				continue;
+			}
+		}
+		if (cur->flags & RWNX_CMD_FLAG_WAIT_PUSH)
+			break;
+	}
+	if (!acked) {
+		AICWFDBG(LOGDEBUG, KERN_CRIT "Error: acked cmd not found\n");
+	} else {
+		cmd->flags &=3D ~RWNX_CMD_FLAG_WAIT_ACK;
+		if (RWNX_CMD_WAIT_COMPLETE(cmd->flags))
+			cmd_complete(cmd_mgr, cmd);
+	}
+	spin_unlock(&cmd_mgr->lock);
+
+	return 0;
+}
+
+void cmd_mgr_task_process(struct work_struct *work)
+{
+	struct rwnx_cmd_mgr *cmd_mgr =3D
+		container_of(work, struct rwnx_cmd_mgr, cmd_work);
+	struct rwnx_cmd *cur, *next =3D NULL;
+	unsigned long tout;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	while (1) {
+		next =3D NULL;
+		spin_lock_bh(&cmd_mgr->lock);
+
+		list_for_each_entry(cur, &cmd_mgr->cmds, list) {
+			if (cur->flags & RWNX_CMD_FLAG_WAIT_PUSH)
+				next =3D cur;
+			break;
+		}
+		spin_unlock_bh(&cmd_mgr->lock);
+
+		if (!next)
+			break;
+
+		if (next) {
+#ifdef AICWF_SDIO_SUPPORT
+			struct aic_sdio_dev *sdiodev =3D
+				container_of(cmd_mgr, struct aic_sdio_dev, cmd_mgr);
+#endif
+			next->flags &=3D ~RWNX_CMD_FLAG_WAIT_PUSH;
+
+#ifdef AICWF_SDIO_SUPPORT
+			aicwf_set_cmd_tx((void *)(sdiodev), next->a2e_msg,
+					 sizeof(struct lmac_msg) +
+						next->a2e_msg->param_len);
+#else
+			aicwf_set_cmd_tx((void *)(usbdev), next->a2e_msg,
+					 sizeof(struct lmac_msg) +
+						next->a2e_msg->param_len);
+#endif
+			kfree(next->a2e_msg);
+
+			tout =3D
+				msecs_to_jiffies(RWNX_80211_CMD_TIMEOUT_MS * cmd_mgr->queue_sz);
+			if (!wait_for_completion_timeout(&next->complete, tout)) {
+				AICWFDBG(LOGDEBUG, KERN_CRIT "AICWF cmd timed-out\n");
+#ifdef AICWF_SDIO_SUPPORT
+				if (aicwf_sdio_writeb(sdiodev, sdiodev->sdio_reg.wakeup_reg,
+						      2) < 0) {
+					sdio_err("reg:%d write failed!\n",
+						 sdiodev->sdio_reg.wakeup_reg);
+				}
+#endif
+				cmd_dump(next);
+				spin_lock_bh(&cmd_mgr->lock);
+				cmd_mgr->state =3D RWNX_CMD_MGR_STATE_CRASHED;
+				if (!(next->flags & RWNX_CMD_FLAG_DONE)) {
+					next->result =3D -ETIMEDOUT;
+					cmd_complete(cmd_mgr, next);
+				}
+				spin_unlock_bh(&cmd_mgr->lock);
+			} else {
+				rwnx_cmd_free(next); // kfree(next);
+			}
+		}
+	}
+}
+
+static int cmd_mgr_run_callback(struct rwnx_hw *rwnx_hw, struct rwnx_cmd *=
cmd,
+				struct rwnx_cmd_e2amsg *msg, msg_cb_fct cb)
+{
+	int res;
+
+	if (!cb)
+		return 0;
+
+	res =3D cb(rwnx_hw, cmd, msg);
+
+	return res;
+}
+
+static int cmd_mgr_msgind(struct rwnx_cmd_mgr *cmd_mgr,
+			  struct rwnx_cmd_e2amsg *msg, msg_cb_fct cb)
+{
+#ifdef AICWF_SDIO_SUPPORT
+	struct aic_sdio_dev *sdiodev =3D
+		container_of(cmd_mgr, struct aic_sdio_dev, cmd_mgr);
+	struct rwnx_hw *rwnx_hw =3D sdiodev->rwnx_hw;
+#endif
+	struct rwnx_cmd *cmd, *pos;
+	bool found =3D false;
+
+	// RWNX_DBG(RWNX_FN_ENTRY_STR); //debug trace
+#ifdef AIC8800_CREATE_TRACE_POINTS
+	trace_msg_recv(msg->id);
+#endif
+	// AICWFDBG(LOGDEBUG, "cmd->id=3D%x\n", msg->id); //debug trace
+	spin_lock_bh(&cmd_mgr->lock);
+	list_for_each_entry_safe(cmd, pos, &cmd_mgr->cmds, list) {
+		if (cmd->reqid =3D=3D msg->id && (cmd->flags & RWNX_CMD_FLAG_WAIT_CFM)) =
{
+			if (!cmd_mgr_run_callback(rwnx_hw, cmd, msg, cb)) {
+				found =3D true;
+				cmd->flags &=3D ~RWNX_CMD_FLAG_WAIT_CFM;
+				if (WARN(msg->param_len > RWNX_CMD_E2AMSG_LEN_MAX,
+					 "Unexpect E2A msg len %d > %d\n", msg->param_len,
+					 RWNX_CMD_E2AMSG_LEN_MAX))
+					msg->param_len =3D RWNX_CMD_E2AMSG_LEN_MAX;
+
+				if (cmd->e2a_msg && msg->param_len)
+					memcpy(cmd->e2a_msg, &msg->param, msg->param_len);
+
+				if (RWNX_CMD_WAIT_COMPLETE(cmd->flags))
+					cmd_complete(cmd_mgr, cmd);
+
+				break;
+			}
+		}
+	}
+	spin_unlock_bh(&cmd_mgr->lock);
+
+	if (!found)
+		cmd_mgr_run_callback(rwnx_hw, NULL, msg, cb);
+
+	return 0;
+}
+
+static void cmd_mgr_print(struct rwnx_cmd_mgr *cmd_mgr)
+{
+	struct rwnx_cmd *cur;
+
+	spin_lock_bh(&cmd_mgr->lock);
+	RWNX_DBG("q_sz/max: %2d / %2d - next tkn: %d\n", cmd_mgr->queue_sz,
+		 cmd_mgr->max_queue_sz, cmd_mgr->next_tkn);
+	list_for_each_entry(cur, &cmd_mgr->cmds, list) {
+		cmd_dump(cur);
+	}
+	spin_unlock_bh(&cmd_mgr->lock);
+}
+
+static void cmd_mgr_drain(struct rwnx_cmd_mgr *cmd_mgr)
+{
+	struct rwnx_cmd *cur, *nxt;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	spin_lock_bh(&cmd_mgr->lock);
+	list_for_each_entry_safe(cur, nxt, &cmd_mgr->cmds, list) {
+		list_del(&cur->list);
+		cmd_mgr->queue_sz--;
+		if (!(cur->flags & RWNX_CMD_FLAG_NONBLOCK))
+			complete(&cur->complete);
+	}
+	spin_unlock_bh(&cmd_mgr->lock);
+}
+
+void rwnx_cmd_mgr_init(struct rwnx_cmd_mgr *cmd_mgr)
+{
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	INIT_LIST_HEAD(&cmd_mgr->cmds);
+	cmd_mgr->state =3D RWNX_CMD_MGR_STATE_INITED;
+	spin_lock_init(&cmd_mgr->lock);
+	cmd_mgr->max_queue_sz =3D RWNX_CMD_MAX_QUEUED;
+	cmd_mgr->queue =3D &cmd_mgr_queue;
+	cmd_mgr->print =3D &cmd_mgr_print;
+	cmd_mgr->drain =3D &cmd_mgr_drain;
+	cmd_mgr->llind =3D &cmd_mgr_llind;
+	cmd_mgr->msgind =3D &cmd_mgr_msgind;
+
+	INIT_WORK(&cmd_mgr->cmd_work, cmd_mgr_task_process);
+	cmd_mgr->cmd_wq =3D create_singlethread_workqueue("cmd_wq");
+	if (!cmd_mgr->cmd_wq) {
+		txrx_err("insufficient memory to create cmd workqueue.\n");
+		return;
+	}
+}
+
+void rwnx_cmd_mgr_deinit(struct rwnx_cmd_mgr *cmd_mgr)
+{
+	cmd_mgr->print(cmd_mgr);
+	cmd_mgr->drain(cmd_mgr);
+	cmd_mgr->print(cmd_mgr);
+	flush_workqueue(cmd_mgr->cmd_wq);
+	destroy_workqueue(cmd_mgr->cmd_wq);
+	memset(cmd_mgr, 0, sizeof(*cmd_mgr));
+}
+
+void aicwf_set_cmd_tx(void *dev, struct lmac_msg *msg, uint len)
+{
+	u8 *buffer =3D NULL;
+	u16 index =3D 0;
+#ifdef AICWF_SDIO_SUPPORT
+	struct aic_sdio_dev *sdiodev =3D (struct aic_sdio_dev *)dev;
+	struct aicwf_bus *bus =3D sdiodev->bus_if;
+#else
+	struct aic_usb_dev *usbdev =3D (struct aic_usb_dev *)dev;
+	struct aicwf_bus *bus =3D NULL;
+
+	if (!usbdev->state) {
+		AICWFDBG(LOGDEBUG, "down msg\n");
+		return;
+	}
+	bus =3D usbdev->bus_if;
+#endif
+	buffer =3D bus->cmd_buf;
+
+	memset(buffer, 0, CMD_BUF_MAX);
+	buffer[0] =3D (len + 4) & 0x00ff;
+	buffer[1] =3D ((len + 4) >> 8) & 0x0f;
+	buffer[2] =3D 0x11;
+
+	buffer[3] =3D aic_chip_cmd_hdr_checksum(sdiodev->rwnx_hw, &buffer[0], 3);
+
+	index +=3D 4;
+	// there is a dummy word
+	index +=3D 4;
+
+	// make sure little endian
+	put_u16(&buffer[index], msg->id);
+	index +=3D 2;
+	put_u16(&buffer[index], msg->dest_id);
+	index +=3D 2;
+	put_u16(&buffer[index], msg->src_id);
+	index +=3D 2;
+	put_u16(&buffer[index], msg->param_len);
+	index +=3D 2;
+	memcpy(&buffer[index], (u8 *)msg->param, msg->param_len);
+
+	aicwf_bus_txmsg(bus, buffer, len + 8);
+}
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.h b/drivers/ne=
t/wireless/aic/aic8800_fdrv/rwnx_cmds.h
new file mode 100644
index 0000000000000..adb4bc49c188a
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_cmds.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _RWNX_CMDS_H_
+#define _RWNX_CMDS_H_
+
+#include "lmac_msg.h"
+#include "ipc_shared.h"
+#include <linux/completion.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+
+#define RWNX_80211_CMD_TIMEOUT_MS 6000
+
+#define RWNX_CMD_FLAG_NONBLOCK  BIT(0)
+#define RWNX_CMD_FLAG_REQ_CFM   BIT(1)
+#define RWNX_CMD_FLAG_WAIT_PUSH BIT(2)
+#define RWNX_CMD_FLAG_WAIT_ACK  BIT(3)
+#define RWNX_CMD_FLAG_WAIT_CFM  BIT(4)
+#define RWNX_CMD_FLAG_DONE      BIT(5)
+/* ATM IPC design makes it possible to get the CFM before the ACK,
+ * otherwise this could have simply been a state enum
+ */
+#define RWNX_CMD_WAIT_COMPLETE(flags)                                     =
     \
+	(!((flags) & (RWNX_CMD_FLAG_WAIT_ACK | RWNX_CMD_FLAG_WAIT_CFM)))
+
+#define RWNX_CMD_MAX_QUEUED 16
+
+#define rwnx_cmd_e2amsg         ipc_e2a_msg
+#define rwnx_cmd_a2emsg         lmac_msg
+#define RWNX_CMD_A2EMSG_LEN(m)  (sizeof(struct lmac_msg) + (m)->param_len)
+#define RWNX_CMD_E2AMSG_LEN_MAX (IPC_E2A_MSG_PARAM_SIZE * 4)
+
+struct rwnx_hw;
+struct rwnx_cmd;
+typedef int (*msg_cb_fct)(struct rwnx_hw *rwnx_hw, struct rwnx_cmd *cmd,
+			  struct rwnx_cmd_e2amsg *msg);
+
+static inline void put_u16(u8 *buf, u16 data)
+{
+	buf[0] =3D (u8)(data & 0x00ff);
+	buf[1] =3D (u8)((data >> 8) & 0x00ff);
+}
+
+enum rwnx_cmd_mgr_state {
+	RWNX_CMD_MGR_STATE_DEINIT,
+	RWNX_CMD_MGR_STATE_INITED,
+	RWNX_CMD_MGR_STATE_CRASHED,
+};
+
+struct rwnx_cmd {
+	struct list_head list;
+	lmac_msg_id_t id;
+	lmac_msg_id_t reqid;
+	struct rwnx_cmd_a2emsg *a2e_msg;
+	char *e2a_msg;
+	u32 tkn;
+	u16 flags;
+
+	struct completion complete;
+	u32 result;
+	u8 used;
+	int array_id;
+};
+
+struct rwnx_cmd_mgr {
+	enum rwnx_cmd_mgr_state state;
+	spinlock_t lock; //
+	u32 next_tkn;
+	u32 queue_sz;
+	u32 max_queue_sz;
+
+	struct list_head cmds;
+
+	int (*queue)(struct rwnx_cmd_mgr *mgr, struct rwnx_cmd *cmd);
+	int (*llind)(struct rwnx_cmd_mgr *mgr, struct rwnx_cmd *cmd);
+	int (*msgind)(struct rwnx_cmd_mgr *mgr, struct rwnx_cmd_e2amsg *msg, msg_=
cb_fct cb);
+	void (*print)(struct rwnx_cmd_mgr *mgr);
+	void (*drain)(struct rwnx_cmd_mgr *mgr);
+
+	struct work_struct cmd_work;
+	struct workqueue_struct *cmd_wq;
+};
+
+#define WAKE_CMD_WORK(_cmd_mgr)							\
+	do {									\
+		struct rwnx_cmd_mgr *__mgr =3D (_cmd_mgr);                        \
+		queue_work((__mgr)->cmd_wq, &__mgr->cmd_work);		        \
+	} while (0)
+
+void rwnx_cmd_mgr_init(struct rwnx_cmd_mgr *cmd_mgr);
+void rwnx_cmd_mgr_deinit(struct rwnx_cmd_mgr *cmd_mgr);
+int cmd_mgr_queue_force_defer(struct rwnx_cmd_mgr *cmd_mgr,
+			      struct rwnx_cmd *cmd);
+void aicwf_set_cmd_tx(void *dev, struct lmac_msg *msg, uint len);
+
+void cmd_mgr_task_process(struct work_struct *work);
+
+void rwnx_cmd_free(struct rwnx_cmd *cmd);
+
+#endif /* _RWNX_CMDS_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h b/drivers/=
net/wireless/aic/aic8800_fdrv/rwnx_compat.h
new file mode 100644
index 0000000000000..7316a2f0b8322
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_compat.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief Ensure driver compilation for linux 3.16 to 3.19
+ * To avoid too many #if LINUX_VERSION_CODE if the code, when prototype ch=
ange
+ * between different kernel version:
+ * - For external function, define a macro whose name is the function name=
 with
+ *   _compat suffix and prototype (actually the number of parameter) of th=
e
+ *   latest version. Then latest version this macro simply call the functi=
on
+ *   and for older kernel version it call the function adapting the api.
+ * - For internal function (e.g. cfg80211_ops) do the same but the macro n=
ame
+ *   doesn't need to have the _compat suffix when the function is not used
+ *   directly by the driver
+ *
+ *************************************************************************=
*****
+ */
+
+#ifndef _RWNX_COMPAT_H_
+#define _RWNX_COMPAT_H_
+#include <linux/version.h>
+
+#include <linux/bitfield.h>
+
+/* CFG80211 */
+
+#ifdef CONFIG_RWNX_MUMIMO_TX
+#define CONFIG_USER_MAX 2
+#else
+#define CONFIG_USER_MAX 1
+#endif
+
+#define NX_VIRT_DEV_MAX 4
+
+#define NX_REMOTE_STA_MAX_FOR_OLD_IC 10
+#define NX_REMOTE_STA_MAX 32
+
+#define NX_MU_GROUP_MAX 62
+#define NX_TXDESC_CNT 64
+#define NX_TX_MAX_RATES 4
+#define NX_CHAN_CTXT_CNT 3
+
+#ifdef CONFIG_RWNX_BCMC
+#define NX_TXQ_CNT 5
+#else
+#define NX_TXQ_CNT 4
+#endif
+
+// because android kernel 5.15 uses kernel 6.0 or 6.1 kernel api
+#ifdef ANDROID_PLATFORM
+#define HIGH_KERNEL_VERSION  KERNEL_VERSION(5, 15, 41)
+#define HIGH_KERNEL_VERSION2 KERNEL_VERSION(5, 15, 41)
+#define HIGH_KERNEL_VERSION3 KERNEL_VERSION(5, 15, 104)
+#define HIGH_KERNEL_VERSION4 KERNEL_VERSION(6, 1, 0)
+#else
+#define HIGH_KERNEL_VERSION  KERNEL_VERSION(6, 0, 0)
+#define HIGH_KERNEL_VERSION2 KERNEL_VERSION(6, 1, 0)
+#define HIGH_KERNEL_VERSION3 KERNEL_VERSION(6, 3, 0)
+#define HIGH_KERNEL_VERSION4 KERNEL_VERSION(6, 3, 0)
+#endif
+
+#define IEEE80211_MAX_AMPDU_BUF IEEE80211_MAX_AMPDU_BUF_HE
+#define IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB                       =
     \
+	IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMING_PARTIAL_BW_FB
+#define IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB                       =
     \
+	IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMING_FB
+#define IEEE80211_HE_PHY_CAP3_RX_HE_MU_PPDU_FROM_NON_AP_STA               =
     \
+	IEEE80211_HE_PHY_CAP3_RX_PARTIAL_BW_SU_IN_20MHZ_MU
+
+#define CCFS0(vht) ((vht)->center_freq_seg0_idx)
+#define CCFS1(vht) ((vht)->center_freq_seg1_idx)
+
+#define SURVEY_TIME(s)      ((s)->time)
+#define SURVEY_TIME_BUSY(s) ((s)->time_busy)
+#define STA_TDLS_INITIATOR(sta) ((sta)->tdls_initiator)
+
+#define RX_ENC_HT(s) ((s)->encoding =3D RX_ENC_HT)
+#define RX_ENC_VHT(s) ((s)->encoding =3D RX_ENC_VHT)
+#define RX_ENC_HE(s) ((s)->encoding =3D RX_ENC_HE)
+#define RX_ENC_FLAG_SHORT_GI(s)  ((s)->enc_flags |=3D RX_ENC_FLAG_SHORT_GI=
)
+#define RX_ENC_FLAG_SHORT_PRE(s) ((s)->enc_flags |=3D RX_ENC_FLAG_SHORTPRE=
)
+#define RX_ENC_FLAG_LDPC(s)      ((s)->enc_flags |=3D RX_ENC_FLAG_LDPC)
+#define RX_BW_40MHZ(s)           ((s)->bw =3D RATE_INFO_BW_40)
+#define RX_BW_80MHZ(s)           ((s)->bw =3D RATE_INFO_BW_80)
+#define RX_BW_160MHZ(s)          ((s)->bw =3D RATE_INFO_BW_160)
+#define RX_NSS(s)                ((s)->nss)
+
+#ifndef CONFIG_VENDOR_RWNX_AMSDUS_TX
+#endif /* CONFIG_VENDOR_RWNX_AMSDUS_TX */
+
+#endif /* _RWNX_COMPAT_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_defs.h b/drivers/ne=
t/wireless/aic/aic8800_fdrv/rwnx_defs.h
new file mode 100644
index 0000000000000..d41bab76dd1b3
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_defs.h
@@ -0,0 +1,744 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief Main driver structure declarations for fullmac driver
+ *
+ *************************************************************************=
*****
+ */
+
+#ifndef _RWNX_DEFS_H_
+#define _RWNX_DEFS_H_
+
+#include <linux/device.h>
+#include <linux/dmapool.h>
+#include <linux/interrupt.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <net/cfg80211.h>
+
+#include "rwnx_cmds.h"
+#include "rwnx_debugfs.h"
+#include "rwnx_mod_params.h"
+#include "rwnx_mu_group.h"
+#include "rwnx_platform.h"
+#include "rwnx_radar.h"
+#include "rwnx_rx.h"
+#include "rwnx_tx.h"
+#include "rwnx_utils.h"
+#ifdef CONFIG_AIC8800_GKI
+#include "rwnx_gki.h"
+#endif
+#include "rwnx_compat.h"
+#ifdef CONFIG_AIC8800_FILTER_TCP_ACK
+#include "aicwf_tcp_ack.h"
+#endif
+
+#ifdef AICWF_SDIO_SUPPORT
+#include "aicwf_sdio.h"
+#include "sdio_host.h"
+#endif
+
+#ifdef CONFIG_AIC8800_BR_SUPPORT
+#include "aic_br_ext.h"
+#endif /* CONFIG_AIC8800_BR_SUPPORT */
+
+#include "lmac_mac.h"
+#include "aicwf_chip_ops.h"
+
+#define WPI_HDR_LEN    18
+#define WPI_PN_LEN     16
+#define WPI_PN_OFST    2
+#define WPI_MIC_LEN    16
+#define WPI_KEY_LEN    32
+#define WPI_SUBKEY_LEN 16 // WPI key is actually two 16bytes key
+
+#define LEGACY_PS_ID 0
+#define UAPSD_ID     1
+
+#define PS_SP_INTERRUPTED 255
+#define MAC_ADDR_LEN      6
+
+#ifdef CONFIG_AIC8800_AUTO_CUSTREG
+#define MAX_SEARCH_CNT 10
+
+/// Structure containing the parameters of the auto ccode
+struct scanu_ccode {
+	/// ccode auto/manual switch, auto--true, manual--false
+	bool auto_set;
+	/// ccode find
+	bool ccode_find;
+	/// ccode set
+	bool ccode_set;
+	/// ccode find cnt
+	u8_l ccode_cnt;
+	/// ccode rssi
+	s8_l ccode_rssi;
+	/// link scan
+	atomic_t link_scan;
+	/// record mac addr
+	struct mac_addr bssid;
+};
+#endif
+
+struct wf_bss_info {
+	u32_l length;
+	s8_l rssi;
+	u16_l chan;
+	enum nl80211_band band; /* Band */
+	u8_l width;             /* Channel width  0/1/2--20/40/80 */
+	u16 center_freq;        /* Center frequency */
+	u32 center_freq1;       /* Center frequency 1 */
+	u32 center_freq2;       /* Center frequency 2 */
+	bool ht;
+	bool vht;
+	u8_l bssid[ETH_ALEN];
+	u8_l ssid_len;
+	unsigned char ssid[33];
+};
+
+/**
+ * struct rwnx_bcn - Information of the beacon in used (AP mode)
+ *
+ * @head: head portion of beacon (before TIM IE)
+ * @tail: tail portion of beacon (after TIM IE)
+ * @ies: extra IEs (not used ?)
+ * @head_len: length of head data
+ * @tail_len: length of tail data
+ * @ies_len: length of extra IEs data
+ * @tim_len: length of TIM IE
+ * @len: Total beacon len (head + tim + tail + extra)
+ * @dtim: dtim period
+ */
+struct rwnx_bcn {
+	u8 *head;
+	u8 *tail;
+	u8 *ies;
+	size_t head_len;
+	size_t tail_len;
+	size_t ies_len;
+	size_t tim_len;
+	size_t len;
+	u8 dtim;
+};
+
+/**
+ * struct rwnx_key - Key information
+ *
+ * @hw_idx: Idx of the key from hardware point of view
+ */
+struct rwnx_key {
+	u8 hw_idx;
+};
+
+/**
+ * Structure containing information about a Mesh Path
+ */
+struct rwnx_mesh_path {
+	struct list_head list;        /* For rwnx_vif.mesh_paths */
+	u8 path_idx;                  /* Path Index */
+	struct mac_addr tgt_mac_addr; /* Target MAC Address */
+	struct rwnx_sta *p_nhop_sta;  /* Pointer to the Next Hop STA */
+};
+
+struct rwnx_mesh_proxy {
+	struct list_head list;        /* For rwnx_vif.mesh_proxy */
+	struct mac_addr ext_sta_addr; /* Address of the External STA */
+	struct mac_addr proxy_addr;   /* Proxy MAC Address */
+	bool local; /* Indicate if interface is a proxy for the device */
+};
+
+/**
+ * struct rwnx_csa - Information for CSA (Channel Switch Announcement)
+ *
+ * @vif: Pointer to the vif doing the CSA
+ * @bcn: Beacon to use after CSA
+ * @elem: IPC buffer to send the new beacon to the fw
+ * @chandef: defines the channel to use after the switch
+ * @count: Current csa counter
+ * @status: Status of the CSA at fw level
+ * @ch_idx: Index of the new channel context
+ * @work: work scheduled at the end of CSA
+ */
+struct rwnx_csa {
+	struct rwnx_vif *vif;
+	struct rwnx_bcn bcn;
+	struct rwnx_ipc_elem_var elem;
+	struct cfg80211_chan_def chandef;
+	int count;
+	int status;
+	int ch_idx;
+	struct work_struct work;
+};
+
+struct apm_probe_sta {
+	u8 sta_mac_addr[6];
+	u8 vif_idx;
+	u64 probe_id;
+	struct work_struct apmprobesta_work;
+	struct workqueue_struct *apmprobesta_wq;
+};
+
+/// Possible States of the TDLS link.
+enum tdls_status_tag {
+	/// TDLS link is not active (no TDLS peer connected)
+	TDLS_LINK_IDLE,
+	/// TDLS Setup Request transmitted
+	TDLS_SETUP_REQ_TX,
+	/// TDLS Setup Response transmitted
+	TDLS_SETUP_RSP_TX,
+	/// TDLS link is active (TDLS peer connected)
+	TDLS_LINK_ACTIVE,
+	/// TDLS Max Number of states.
+	TDLS_STATE_MAX
+};
+
+/*
+ * Structure used to save information relative to the TDLS peer.
+ * This is also linked within the rwnx_hw vifs list.
+ *
+ */
+struct rwnx_tdls {
+	bool active;       /* Indicate if TDLS link is active */
+	bool initiator;    /* Indicate if TDLS peer is the TDLS initiator */
+	bool chsw_en;      /* Indicate if channel switch is enabled */
+	u8 last_tid;       /* TID of the latest MPDU transmitted over the
+			    * TDLS direct link to the TDLS STA
+			    */
+	u16 last_sn;       /* Sequence number of the latest MPDU transmitted
+			    * over the TDLS direct link to the TDLS STA
+			    */
+	bool ps_on;        /* Indicate if the power save is enabled on the
+			    * TDLS STA
+			    */
+	bool chsw_allowed; /* Indicate if TDLS channel switch is allowed */
+};
+
+/**
+ * enum rwnx_ap_flags - AP flags
+ *
+ * @RWNX_AP_ISOLATE Isolate clients (i.e. Don't brige packets transmitted =
by
+ *                                   one client for another one)
+ */
+enum rwnx_ap_flags {
+	RWNX_AP_ISOLATE =3D BIT(0),
+};
+
+/*
+ * Structure used to save information relative to the managed interfaces.
+ * This is also linked within the rwnx_hw vifs list.
+ *
+ */
+struct rwnx_vif {
+	struct list_head list;
+	struct rwnx_hw *rwnx_hw;
+	struct wireless_dev wdev;
+	struct net_device *ndev;
+	struct net_device_stats net_stats;
+	struct rwnx_key key[6];
+	unsigned long drv_flags;
+	atomic_t drv_conn_state;
+	u8 drv_vif_index;  /* Identifier of the VIF in driver */
+	u8 vif_index;      /* Identifier of the station in FW */
+	u8 ch_index;       /* Channel context identifier */
+	bool up;           /* Indicate if associated netdev is up
+			    * (i.e. Interface is created at fw level)
+			    */
+	bool use_4addr;    /* Should we use 4addresses mode */
+	bool is_resending; /* Indicate if a frame is being resent on this interfa=
ce */
+	bool user_mpm;  /* In case of Mesh Point VIF, indicate if MPM is handled =
by
+			 * userspace
+			 */
+	bool roc_tdls;  /* Indicate if the ROC has been called by a
+			 * TDLS station
+			 */
+	u8 tdls_status; /* Status of the TDLS link */
+	bool tdls_chsw_prohibited; /* Indicate if TDLS Channel Switch is prohibit=
ed */
+	bool wep_enabled;          /* 1 if WEP is enabled */
+	bool wep_auth_err; /* 1 if auth status code is not supported auth alg whe=
n
+			    * WEP enabled
+			    */
+	enum nl80211_auth_type
+		last_auth_type; /* Authentication type (algorithm) sent in the last
+				 * connection when WEP enabled
+				 */
+	union {
+		struct {
+			struct rwnx_sta *ap; /* Pointer to the peer STA entry allocated for
+					      * the AP
+					      */
+			struct rwnx_sta *tdls_sta; /* Pointer to the TDLS station */
+			bool external_auth; /* Indicate if external authentication is in
+					     * progress
+					     */
+			u32 group_cipher_type;
+			u32 paired_cipher_type;
+			// connected network info start
+			char ssid[32];
+			int ssid_len;
+			u8 bssid[ETH_ALEN];
+			u32 conn_owner_nlportid;
+			bool is_roam;
+			unsigned long link_time;
+			u16_l b_interval;
+			u8_l dtim_peroid;
+			u16_l capability;
+			enum nl80211_auth_type auth_type;
+			// connected network info end
+		} sta;
+		struct {
+			u16 flags;                 /* see rwnx_ap_flags */
+			struct list_head sta_list; /* List of STA connected to the AP */
+			struct rwnx_bcn bcn;       /* beacon */
+			u8 bcmc_index;             /* Index of the BCMC sta to use */
+#if (defined CONFIG_AIC8800_HE_FOR_OLD_KERNEL) || (defined CONFIG_AIC8800_=
VHT_FOR_OLD_KERNEL)
+			u8 aic_index;
+#endif
+			struct rwnx_csa *csa;
+
+			struct list_head
+				mpath_list; /* List of Mesh Paths used on this interface */
+			struct list_head proxy_list; /* List of Proxies Information used on
+						      * this interface
+						      */
+			bool create_path;            /* Indicate if we are waiting for a
+						      * MESH_CREATE_PATH_CFM message
+						      */
+			int generation; /* Increased each time the list of Mesh Paths is
+					 * updated
+					 */
+			enum nl80211_mesh_power_mode
+				mesh_pm; /* mesh power save mode currently set in firmware */
+			enum nl80211_mesh_power_mode
+				next_mesh_pm; /* mesh power save mode for next peer */
+		} ap;
+		struct {
+			struct rwnx_vif *master; /* pointer on master interface */
+			struct rwnx_sta *sta_4a;
+		} ap_vlan;
+	};
+
+	u8_l key_has_add;
+	u8_l is_p2p_vif;
+	struct apm_probe_sta sta_probe;
+
+#ifdef CONFIG_AIC8800_BR_SUPPORT
+	spinlock_t br_ext_lock; //
+	/* unsigned int macclone_completed; */
+	struct nat25_network_db_entry *nethash[NAT25_HASH_SIZE];
+	int pppoe_connection_in_progress;
+	unsigned char pppoe_addr[MACADDRLEN];
+	unsigned char scdb_mac[MACADDRLEN];
+	unsigned char scdb_ip[4];
+	struct nat25_network_db_entry *scdb_entry;
+	unsigned char br_mac[MACADDRLEN];
+	unsigned char br_ip[4];
+
+	struct br_ext_info eth_br_ext_info;
+#endif /* CONFIG_AIC8800_BR_SUPPORT */
+};
+
+#define RWNX_VIF_TYPE(rwnx_vif) ((rwnx_vif)->wdev.iftype)
+
+/**
+ * Structure used to store information relative to PS mode.
+ *
+ * @active: True when the sta is in PS mode.
+ *          If false, other values should be ignored
+ * @pkt_ready: Number of packets buffered for the sta in drv's txq
+ *             (1 counter for Legacy PS and 1 for U-APSD)
+ * @sp_cnt: Number of packets that remain to be pushed in the service peri=
od.
+ *          0 means that no service period is in progress
+ *          (1 counter for Legacy PS and 1 for U-APSD)
+ */
+struct rwnx_sta_ps {
+	bool active;
+	u16 pkt_ready[2];
+	u16 sp_cnt[2];
+};
+
+/**
+ * struct rwnx_rx_rate_stats - Store statistics for RX rates
+ *
+ * @table: Table indicating how many frame has been receive which each
+ * rate index. Rate index is the same as the one used by RC algo for TX
+ * @size: Size of the table array
+ * @cpt: number of frames received
+ */
+struct rwnx_rx_rate_stats {
+	int *table;
+	int size;
+	int cpt;
+	int rate_cnt;
+};
+
+/**
+ * struct rwnx_sta_stats - Structure Used to store statistics specific to =
a STA
+ *
+ * @last_rx: Hardware vector of the last received frame
+ * @rx_rate: Statistics of the received rates
+ */
+struct rwnx_sta_stats {
+	struct hw_vect last_rx;
+	struct rwnx_rx_rate_stats rx_rate;
+};
+
+#if (defined CONFIG_AIC8800_HE_FOR_OLD_KERNEL) || (defined CONFIG_AIC8800_=
VHT_FOR_OLD_KERNEL)
+struct aic_sta {
+	u8 sta_idx; /* Identifier of the station */
+	bool he;    /* Flag indicating if the station supports HE */
+	bool vht;   /* Flag indicating if the station supports VHT */
+};
+#endif
+
+/*
+ * Structure used to save information relative to the managed stations.
+ */
+struct rwnx_sta {
+	struct list_head list;
+	u16 aid;                /* association ID */
+	u8 sta_idx;             /* Identifier of the station */
+	u8 vif_idx;             /* Identifier of the VIF (fw id) the station
+				 * belongs to
+				 */
+	u8 vlan_idx;            /* Identifier of the VLAN VIF (fw id) the station
+				 * belongs to (=3D vif_idx if no vlan in used)
+				 */
+	enum nl80211_band band; /* Band */
+	enum nl80211_chan_width width; /* Channel width */
+	u16 center_freq;               /* Center frequency */
+	u32 center_freq1;              /* Center frequency 1 */
+	u32 center_freq2;              /* Center frequency 2 */
+	u8 ch_idx;                     /* Identifier of the channel
+					* context the station belongs to
+					*/
+	bool qos;                      /* Flag indicating if the station
+					* supports QoS
+					*/
+	u8 acm;                        /* Bitfield indicating which queues
+					* have AC mandatory
+					*/
+	u16 uapsd_tids;        /* Bitfield indicating which tids are subject to
+				* UAPSD
+				*/
+	u8 mac_addr[ETH_ALEN]; /* MAC address of the station */
+	struct rwnx_key key;
+	bool valid;            /* Flag indicating if the entry is valid */
+	struct rwnx_sta_ps ps; /* Information when STA is in PS (AP only) */
+#ifdef CONFIG_RWNX_BFMER
+	struct rwnx_bfmer_report *bfm_report; /* Beamforming report to be used fo=
r
+					       * VHT TX Beamforming
+					       */
+#ifdef CONFIG_RWNX_MUMIMO_TX
+	struct rwnx_sta_group_info
+		group_info; /* MU grouping information for the STA */
+#endif              /* CONFIG_RWNX_MUMIMO_TX */
+#endif              /* CONFIG_RWNX_BFMER */
+
+	bool ht;               /* Flag indicating if the station
+				* supports HT
+				*/
+	bool vht;              /* Flag indicating if the station
+				* supports VHT
+				*/
+	u32 ac_param[AC_MAX];  /* EDCA parameters */
+	struct rwnx_tdls tdls; /* TDLS station information */
+	struct rwnx_sta_stats stats;
+	enum nl80211_mesh_power_mode
+		mesh_pm; /*  link-specific mesh power save mode */
+};
+
+static inline const u8 *rwnx_sta_addr(struct rwnx_sta *rwnx_sta)
+{
+	return rwnx_sta->mac_addr;
+}
+
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+struct rwnx_amsdu_stats {
+	int done;
+	int failed;
+};
+#endif
+
+struct rwnx_stats {
+	int cfm_balance[NX_TXQ_CNT];
+	unsigned long last_rx, last_tx; /* jiffies */
+	int ampdus_tx[IEEE80211_MAX_AMPDU_BUF];
+	int ampdus_rx[IEEE80211_MAX_AMPDU_BUF];
+	int ampdus_rx_map[4];
+	int ampdus_rx_miss;
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+	struct rwnx_amsdu_stats amsdus[NX_TX_PAYLOAD_MAX];
+#endif
+	int amsdus_rx[64];
+};
+
+struct rwnx_sec_phy_chan {
+	u16 prim20_freq;
+	u16 center_freq1;
+	u16 center_freq2;
+	enum nl80211_band band;
+	u8 type;
+};
+
+/* Structure that will contains all RoC information received from cfg80211=
 */
+struct rwnx_roc_elem {
+	struct wireless_dev *wdev;
+	struct ieee80211_channel *chan;
+	unsigned int duration;
+	/* Used to avoid call of CFG80211 callback upon expiration of RoC */
+	bool mgmt_roc;
+	/* Indicate if we have switch on the RoC channel */
+	bool on_chan;
+};
+
+/* Structure containing channel survey information received from MAC */
+struct rwnx_survey_info {
+	// Filled
+	u32 filled;
+	// Amount of time in ms the radio spent on the channel
+	u32 chan_time_ms;
+	// Amount of time the primary channel was sensed busy
+	u32 chan_time_busy_ms;
+	// Noise in dbm
+	s8 noise_dbm;
+};
+
+#define RWNX_CH_NOT_SET  0xFF
+#define RWNX_INVALID_VIF 0xFF
+#define RWNX_INVALID_STA 0xFF
+
+/* Structure containing channel context information */
+struct rwnx_chanctx {
+	struct cfg80211_chan_def chan_def; /* channel description */
+	u8 count;                          /* number of vif using this ctxt */
+};
+
+/**
+ * rwnx_phy_info - Phy information
+ *
+ * @phy_cnt: Number of phy interface
+ * @cfg: Configuration send to firmware
+ * @sec_chan: Channel configuration of the second phy interface (if phy_cn=
t > 1)
+ * @limit_bw: Set to true to limit BW on requested channel. Only set to us=
e
+ * VHT with old radio that don't support 80MHz (deprecated)
+ */
+struct rwnx_phy_info {
+	u8 cnt;
+	struct phy_cfg_tag cfg;
+	struct rwnx_sec_phy_chan sec_chan;
+	bool limit_bw;
+};
+
+struct defrag_ctrl_info {
+	struct list_head list;
+	u8 sta_idx;
+	u8 tid;
+	u16 sn;
+	u8 next_fn;
+	u16 frm_len;
+	struct sk_buff *skb;
+	struct timer_list defrag_timer;
+	struct rwnx_hw *rwnx_hw;
+};
+
+struct amsdu_subframe_hdr {
+	u8 da[6];
+	u8 sa[6];
+	u16 sublen;
+};
+
+/* rwnx driver status */
+void rwnx_set_conn_state(atomic_t *drv_conn_state, int state);
+
+enum rwnx_drv_connect_status {
+	RWNX_DRV_STATUS_DISCONNECTED =3D 0,
+	RWNX_DRV_STATUS_DISCONNECTING,
+	RWNX_DRV_STATUS_CONNECTING,
+	RWNX_DRV_STATUS_CONNECTED,
+	RWNX_DRV_STATUS_ROAMING,
+};
+
+struct rwnx_hw {
+	struct rwnx_mod_params *mod_params;
+	struct device *dev;
+#ifdef AICWF_SDIO_SUPPORT
+	struct aic_sdio_dev *sdiodev;
+#endif
+	struct wiphy *wiphy;
+	struct list_head vifs;
+	struct rwnx_vif *
+		vif_table[NX_VIRT_DEV_MAX + NX_REMOTE_STA_MAX]; /* indexed with fw id */
+	struct rwnx_sta sta_table[NX_REMOTE_STA_MAX + NX_VIRT_DEV_MAX];
+#if (defined CONFIG_AIC8800_HE_FOR_OLD_KERNEL) || (defined CONFIG_AIC8800_=
VHT_FOR_OLD_KERNEL)
+	struct aic_sta aic_table[NX_REMOTE_STA_MAX + NX_VIRT_DEV_MAX];
+#endif
+	struct rwnx_survey_info survey[SCAN_CHANNEL_MAX];
+	struct cfg80211_scan_request *scan_request;
+#ifdef CONFIG_AIC8800_SCHED_SCAN
+	struct cfg80211_sched_scan_request *sched_scan_req;
+#endif
+	struct rwnx_chanctx chanctx_table[NX_CHAN_CTXT_CNT];
+	u8 cur_chanctx;
+
+	u8 monitor_vif; /* FW id of the monitor interface, RWNX_INVALID_VIF if no
+			 * monitor vif at fw level
+			 */
+
+#ifdef CONFIG_AIC8800_FILTER_TCP_ACK
+	/* tcp ack management */
+	struct tcp_ack_manage ack_m;
+#endif
+
+	/* RoC Management */
+	struct rwnx_roc_elem *roc_elem; /* Information provided by cfg80211 in it=
s
+					 * remain on channel request
+					 */
+	u32 roc_cookie_cnt; /* Counter used to identify RoC request sent by cfg80=
211 */
+
+	struct rwnx_cmd_mgr *cmd_mgr;
+
+	struct rwnx_plat *plat;
+
+	spinlock_t tx_lock; //
+	spinlock_t cb_lock; //
+	struct mutex mutex; /* per-device perimeter lock */
+
+	struct tasklet_struct task;
+	struct mm_version_cfm
+		version_cfm; /* Lower layers versions - obtained via MM_VERSION_REQ */
+
+	u32 tcp_pacing_shift;
+
+	/* IPC */
+	struct ipc_host_env_tag *ipc_env;
+#ifdef AICWF_SDIO_SUPPORT
+	struct sdio_host_env_tag sdio_env;
+#endif
+
+	struct rwnx_ipc_elem_pool e2amsgs_pool;
+	struct rwnx_ipc_elem_pool dbgmsgs_pool;
+	struct rwnx_ipc_elem_pool e2aradars_pool;
+	struct rwnx_ipc_elem_var pattern_elem;
+	struct rwnx_ipc_dbgdump_elem dbgdump_elem;
+	struct rwnx_ipc_elem_pool e2arxdesc_pool;
+	struct rwnx_ipc_skb_elem *e2aunsuprxvec_elems;
+	// struct rwnx_ipc_rxbuf_elems rxbuf_elems;
+	struct rwnx_ipc_elem_var scan_ie;
+
+	struct kmem_cache *sw_txhdr_cache;
+
+	struct rwnx_debugfs debugfs;
+	struct rwnx_stats stats;
+
+#ifdef CONFIG_PREALLOC_TXQ
+	struct rwnx_txq *txq;
+#else
+	struct rwnx_txq txq[NX_NB_TXQ];
+#endif
+
+	struct rwnx_hwq hwq[NX_TXQ_CNT];
+
+	u64 avail_idx_map;
+	u8 vif_started;
+	bool adding_sta;
+	struct rwnx_phy_info phy;
+
+	struct rwnx_radar radar;
+
+	/* extended capabilities supported */
+	u8 ext_capa[8];
+
+#ifdef CONFIG_RWNX_MUMIMO_TX
+	struct rwnx_mu_info mu;
+#endif
+	u8 is_p2p_alive;
+	u8 is_p2p_connected;
+	struct timer_list p2p_alive_timer;
+	struct rwnx_vif *p2p_dev_vif;
+	atomic_t p2p_alive_timer_count;
+	bool band_5g_support;
+	u8_l vendor_info;
+	bool fwlog_en;
+	int testmode;
+	u8_l scanning;
+	char country_abbr[4];
+	const struct aic_chip_ops *chip_ops;
+
+	struct list_head defrag_list;
+	spinlock_t defrag_lock; //
+
+	struct work_struct apm_staloss_work;
+	struct workqueue_struct *apm_staloss_wq;
+	u8 apm_vif_idx;
+	u8 sta_mac_addr[6];
+
+	struct wakeup_source *ws_rx;
+	struct wakeup_source *ws_irqrx;
+	struct wakeup_source *ws_tx;
+	struct wakeup_source *ws_pwrctrl;
+	struct wakeup_source *ws_scan;
+
+#ifdef CONFIG_AIC8800_SCHED_SCAN
+	bool is_sched_scan;
+#endif
+
+#ifdef CONFIG_AIC8800_AUTO_CUSTREG
+	struct scanu_ccode ccode;
+#endif
+
+#ifdef CONFIG_AIC8800_TEMP_CONTROL
+	unsigned long started_jiffies;
+	s8_l temp;
+#endif
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+	struct work_struct pwlt_wk;
+#endif
+#ifdef CONFIG_AIC8800_REGION_PW
+	struct work_struct region_wk;
+#endif
+	char fw_version[32];
+#ifdef CONFIG_AIC8800_USE_WIRELESS_EXT
+	bool wext_scan;
+	struct completion wext_scan_com;
+	struct list_head wext_scanre_list;
+	char wext_essid[33];
+	int support_freqs[SCAN_CHANNEL_MAX];
+	int support_freqs_number;
+#endif
+
+};
+
+u8 *rwnx_build_bcn(struct rwnx_bcn *bcn, struct cfg80211_beacon_data *new)=
;
+
+void rwnx_chanctx_link(struct rwnx_vif *vif, u8 idx,
+		       struct cfg80211_chan_def *chandef);
+void rwnx_chanctx_unlink(struct rwnx_vif *vif);
+int rwnx_chanctx_valid(struct rwnx_hw *rwnx_hw, u8 idx);
+
+extern u8 chip_id;
+
+static inline bool is_multicast_sta(int sta_idx)
+{
+	if (g_rwnx_plat->sdiodev->rwnx_hw->chip_ops->is_old_ic)
+		return (sta_idx >=3D NX_REMOTE_STA_MAX_FOR_OLD_IC);
+	else
+		return (sta_idx >=3D NX_REMOTE_STA_MAX);
+}
+
+struct rwnx_sta *rwnx_get_sta(struct rwnx_hw *rwnx_hw, const u8 *mac_addr)=
;
+
+static inline uint8_t master_vif_idx(struct rwnx_vif *vif)
+{
+	if (unlikely(vif->wdev.iftype =3D=3D NL80211_IFTYPE_AP_VLAN))
+		return vif->ap_vlan.master->vif_index;
+	else
+		return vif->vif_index;
+}
+
+void rwnx_external_auth_enable(struct rwnx_vif *vif);
+void rwnx_external_auth_disable(struct rwnx_vif *vif);
+
+#endif /* _RWNX_DEFS_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_events.h b/drivers/=
net/wireless/aic/aic8800_fdrv/rwnx_events.h
new file mode 100644
index 0000000000000..936e006b58773
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_events.h
@@ -0,0 +1,938 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief Trace events definition
+ *
+ *************************************************************************=
*****
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rwnx
+
+#if !defined(_RWNX_EVENTS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _RWNX_EVENTS_H
+
+#include <linux/tracepoint.h>
+#include "rwnx_tx.h"
+
+#include "rwnx_compat.h"
+
+/*************************************************************************=
****
+ * TRACE function for MGMT TX (FULLMAC)
+ *************************************************************************=
***/
+#ifdef CONFIG_RWNX_FULLMAC
+#include "linux/ieee80211.h"
+#if defined(CONFIG_TRACEPOINTS) && defined(AIC8800_CREATE_TRACE_POINTS) &&=
 \
+	!defined(TRACE_HEADER_MULTI_READ)
+#include <linux/trace_seq.h>
+
+/* P2P Public Action Frames Definitions (see WiFi P2P Technical Specificat=
ion,
+ * section 4.2.8)
+ */
+/* IEEE 802.11 Public Action Usage Category - Define P2P public action fra=
mes */
+#define MGMT_ACTION_PUBLIC_CAT         (0x04)
+/* Offset of OUI Subtype field in P2P Action Frame format */
+#define MGMT_ACTION_OUI_SUBTYPE_OFFSET (6)
+/* P2P Public Action Frame Types */
+enum p2p_action_type {
+	P2P_ACTION_GO_NEG_REQ =3D 0, /* GO Negociation Request */
+	P2P_ACTION_GO_NEG_RSP,     /* GO Negociation Response */
+	P2P_ACTION_GO_NEG_CFM,     /* GO Negociation Confirmation */
+	P2P_ACTION_INVIT_REQ,      /* P2P Invitation Request */
+	P2P_ACTION_INVIT_RSP,      /* P2P Invitation Response */
+	P2P_ACTION_DEV_DISC_REQ,   /* Device Discoverability Request */
+	P2P_ACTION_DEV_DISC_RSP,   /* Device Discoverability Response */
+	P2P_ACTION_PROV_DISC_REQ,  /* Provision Discovery Request */
+	P2P_ACTION_PROV_DISC_RSP,  /* Provision Discovery Response */
+};
+
+static inline const char *ftrace_print_mgmt_info(struct trace_seq *p,
+						 u16 frame_control, u8 cat, u8 type,
+						 u8 p2p)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+
+	switch (frame_control & IEEE80211_FCTL_STYPE) {
+	case (IEEE80211_STYPE_ASSOC_REQ):
+		trace_seq_printf(p, "Association Request");
+		break;
+	case (IEEE80211_STYPE_ASSOC_RESP):
+		trace_seq_printf(p, "Association Response");
+		break;
+	case (IEEE80211_STYPE_REASSOC_REQ):
+		trace_seq_printf(p, "Reassociation Request");
+		break;
+	case (IEEE80211_STYPE_REASSOC_RESP):
+		trace_seq_printf(p, "Reassociation Response");
+		break;
+	case (IEEE80211_STYPE_PROBE_REQ):
+		trace_seq_printf(p, "Probe Request");
+		break;
+	case (IEEE80211_STYPE_PROBE_RESP):
+		trace_seq_printf(p, "Probe Response");
+		break;
+	case (IEEE80211_STYPE_BEACON):
+		trace_seq_printf(p, "Beacon");
+		break;
+	case (IEEE80211_STYPE_ATIM):
+		trace_seq_printf(p, "ATIM");
+		break;
+	case (IEEE80211_STYPE_DISASSOC):
+		trace_seq_printf(p, "Disassociation");
+		break;
+	case (IEEE80211_STYPE_AUTH):
+		trace_seq_printf(p, "Authentication");
+		break;
+	case (IEEE80211_STYPE_DEAUTH):
+		trace_seq_printf(p, "Deauthentication");
+		break;
+	case (IEEE80211_STYPE_ACTION):
+		trace_seq_printf(p, "Action");
+		if (cat =3D=3D MGMT_ACTION_PUBLIC_CAT && type =3D=3D 0x9) {
+			switch (p2p) {
+			case (P2P_ACTION_GO_NEG_REQ):
+				trace_seq_printf(p, ": GO Negociation Request");
+				break;
+			case (P2P_ACTION_GO_NEG_RSP):
+				trace_seq_printf(p, ": GO Negociation Response");
+				break;
+			case (P2P_ACTION_GO_NEG_CFM):
+				trace_seq_printf(p, ": GO Negociation Confirmation");
+				break;
+			case (P2P_ACTION_INVIT_REQ):
+				trace_seq_printf(p, ": P2P Invitation Request");
+				break;
+			case (P2P_ACTION_INVIT_RSP):
+				trace_seq_printf(p, ": P2P Invitation Response");
+				break;
+			case (P2P_ACTION_DEV_DISC_REQ):
+				trace_seq_printf(p, ": Device Discoverability Request");
+				break;
+			case (P2P_ACTION_DEV_DISC_RSP):
+				trace_seq_printf(p, ": Device Discoverability Response");
+				break;
+			case (P2P_ACTION_PROV_DISC_REQ):
+				trace_seq_printf(p, ": Provision Discovery Request");
+				break;
+			case (P2P_ACTION_PROV_DISC_RSP):
+				trace_seq_printf(p, ": Provision Discovery Response");
+				break;
+			default:
+				trace_seq_printf(p, "Unknown p2p %d", p2p);
+				break;
+			}
+		} else {
+			switch (cat) {
+			case 0:
+				trace_seq_printf(p, ":Spectrum %d", type);
+				break;
+			case 1:
+				trace_seq_printf(p, ":QOS %d", type);
+				break;
+			case 2:
+				trace_seq_printf(p, ":DLS %d", type);
+				break;
+			case 3:
+				trace_seq_printf(p, ":BA %d", type);
+				break;
+			case 4:
+				trace_seq_printf(p, ":Public %d", type);
+				break;
+			case 5:
+				trace_seq_printf(p, ":Radio Measure %d", type);
+				break;
+			case 6:
+				trace_seq_printf(p, ":Fast BSS %d", type);
+				break;
+			case 7:
+				trace_seq_printf(p, ":HT Action %d", type);
+				break;
+			case 8:
+				trace_seq_printf(p, ":SA Query %d", type);
+				break;
+			case 9:
+				trace_seq_printf(p, ":Protected Public %d", type);
+				break;
+			case 10:
+				trace_seq_printf(p, ":WNM %d", type);
+				break;
+			case 11:
+				trace_seq_printf(p, ":Unprotected WNM %d", type);
+				break;
+			case 12:
+				trace_seq_printf(p, ":TDLS %d", type);
+				break;
+			case 13:
+				trace_seq_printf(p, ":Mesh %d", type);
+				break;
+			case 14:
+				trace_seq_printf(p, ":MultiHop %d", type);
+				break;
+			case 15:
+				trace_seq_printf(p, ":Self Protected %d", type);
+				break;
+			case 126:
+				trace_seq_printf(p, ":Vendor protected");
+				break;
+			case 127:
+				trace_seq_printf(p, ":Vendor");
+				break;
+			default:
+				trace_seq_printf(p, ":Unknown category %d", cat);
+				break;
+			}
+		}
+		break;
+	default:
+		trace_seq_printf(p, "Unknown subtype %d",
+				 frame_control & IEEE80211_FCTL_STYPE);
+		break;
+	}
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+#endif /* defined(CONFIG_TRACEPOINTS) && defined(AIC8800_CREATE_TRACE_POIN=
TS) */
+
+#undef __print_mgmt_info
+#define __print_mgmt_info(frame_control, cat, type, p2p)                  =
     \
+	ftrace_print_mgmt_info(p, frame_control, cat, type, p2p)
+
+TRACE_EVENT(roc, TP_PROTO(u8 vif_idx, u16 freq, unsigned int duration),
+	    TP_ARGS(vif_idx, freq, duration),
+	    TP_STRUCT__entry(__field(u8, vif_idx) __field(u16, freq)
+			     __field(unsigned int, duration)),
+	    TP_fast_assign(__entry->vif_idx =3D vif_idx; __entry->freq =3D freq;
+			   __entry->duration =3D duration;),
+	    TP_printk("f=3D%d vif=3D%d dur=3D%d", __entry->freq, __entry->vif_idx=
,
+		      __entry->duration));
+
+TRACE_EVENT(cancel_roc, TP_PROTO(u8 vif_idx), TP_ARGS(vif_idx),
+	    TP_STRUCT__entry(__field(u8, vif_idx)),
+	    TP_fast_assign(__entry->vif_idx =3D vif_idx;),
+	    TP_printk("vif=3D%d", __entry->vif_idx));
+
+TRACE_EVENT(roc_exp, TP_PROTO(u8 vif_idx), TP_ARGS(vif_idx),
+	    TP_STRUCT__entry(__field(u8, vif_idx)),
+	    TP_fast_assign(__entry->vif_idx =3D vif_idx;),
+	    TP_printk("vif=3D%d", __entry->vif_idx));
+
+TRACE_EVENT(switch_roc, TP_PROTO(u8 vif_idx), TP_ARGS(vif_idx),
+	    TP_STRUCT__entry(__field(u8, vif_idx)),
+	    TP_fast_assign(__entry->vif_idx =3D vif_idx;),
+	    TP_printk("vif=3D%d", __entry->vif_idx));
+
+DECLARE_EVENT_CLASS(mgmt_template,
+		    TP_PROTO(u16 freq, u8 vif_idx, u8 sta_idx, struct ieee80211_mgmt *mg=
mt),
+		    TP_ARGS(freq, vif_idx, sta_idx, mgmt),
+		    TP_STRUCT__entry(__field(u16, freq) __field(u8, vif_idx)
+				     __field(u8, sta_idx) __field(u16, frame_control)
+				     __field(u8, action_cat) __field(u8, action_type)
+				     __field(u8, action_p2p)),
+		    TP_fast_assign(__entry->freq =3D freq; __entry->vif_idx =3D vif_idx;
+				   __entry->sta_idx =3D sta_idx;
+				   __entry->frame_control =3D mgmt->frame_control;
+				   __entry->action_cat =3D mgmt->u.action.category;
+				   __entry->action_type =3D mgmt->u.action.action_code;
+				   __entry->action_p2p =3D *((u8 *)&mgmt->u.action.category +
+								MGMT_ACTION_OUI_SUBTYPE_OFFSET);),
+		    TP_printk("f=3D%d vif=3D%d sta=3D%d -> %s", __entry->freq, __entry->=
vif_idx,
+			      __entry->sta_idx,
+			      __print_mgmt_info(__entry->frame_control, __entry->action_cat,
+						__entry->action_type, __entry->action_p2p)));
+
+DEFINE_EVENT(mgmt_template, mgmt_tx,
+	     TP_PROTO(u16 freq, u8 vif_idx, u8 sta_idx,
+		      struct ieee80211_mgmt *mgmt),
+	     TP_ARGS(freq, vif_idx, sta_idx, mgmt));
+
+DEFINE_EVENT(mgmt_template, mgmt_rx,
+	     TP_PROTO(u16 freq, u8 vif_idx, u8 sta_idx,
+		      struct ieee80211_mgmt *mgmt),
+	     TP_ARGS(freq, vif_idx, sta_idx, mgmt));
+
+TRACE_EVENT(mgmt_cfm, TP_PROTO(u8 vif_idx, u8 sta_idx, bool acked),
+	    TP_ARGS(vif_idx, sta_idx, acked),
+	    TP_STRUCT__entry(__field(u8, vif_idx) __field(u8, sta_idx)
+			     __field(bool, acked)),
+	    TP_fast_assign(__entry->vif_idx =3D vif_idx;
+			   __entry->sta_idx =3D sta_idx; __entry->acked =3D acked;),
+	    TP_printk("vif=3D%d sta=3D%d ack=3D%d", __entry->vif_idx,
+		      __entry->sta_idx, __entry->acked));
+#endif /* CONFIG_RWNX_FULLMAC */
+
+/*************************************************************************=
****
+ * TRACE function for TXQ
+ *************************************************************************=
***/
+
+#if defined(CONFIG_TRACEPOINTS) && defined(AIC8800_CREATE_TRACE_POINTS) &&=
 \
+	!defined(TRACE_HEADER_MULTI_READ)
+
+#include <linux/trace_seq.h>
+#include <linux/trace_events.h>
+
+static inline const char *ftrace_print_txq(struct trace_seq *p, int txq_id=
x)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+
+	if (txq_idx =3D=3D TXQ_INACTIVE) {
+		trace_seq_printf(p, "[INACTIVE]");
+	} else if (txq_idx < NX_FIRST_VIF_TXQ_IDX) {
+		trace_seq_printf(p, "[STA %d/%d]", txq_idx / NX_NB_TXQ_PER_STA,
+				 txq_idx % NX_NB_TXQ_PER_STA);
+#ifdef CONFIG_RWNX_FULLMAC
+	} else if (txq_idx < NX_FIRST_UNK_TXQ_IDX) {
+		trace_seq_printf(p, "[BC/MC %d]", txq_idx - NX_FIRST_BCMC_TXQ_IDX);
+	} else if (txq_idx < NX_OFF_CHAN_TXQ_IDX) {
+		trace_seq_printf(p, "[UNKNOWN %d]", txq_idx - NX_FIRST_UNK_TXQ_IDX);
+	} else if (txq_idx =3D=3D NX_OFF_CHAN_TXQ_IDX) {
+		trace_seq_printf(p, "[OFFCHAN]");
+#else
+	} else if (txq_idx < NX_NB_TXQ) {
+		txq_idx -=3D NX_FIRST_VIF_TXQ_IDX;
+		trace_seq_printf(p, "[VIF %d/%d]", txq_idx / NX_NB_TXQ_PER_VIF,
+				 txq_idx % NX_NB_TXQ_PER_VIF);
+#endif
+	} else {
+		trace_seq_printf(p, "[ERROR %d]", txq_idx);
+	}
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static inline const char *ftrace_print_sta(struct trace_seq *p, int sta_id=
x)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+
+	if (sta_idx < NX_REMOTE_STA_MAX)
+		trace_seq_printf(p, "[STA %d]", sta_idx);
+	else
+		trace_seq_printf(p, "[BC/MC %d]", sta_idx - NX_REMOTE_STA_MAX);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+static inline const char *ftrace_print_hwq(struct trace_seq *p, int hwq_id=
x)
+{
+	static const struct trace_print_flags symbols[] =3D {{RWNX_HWQ_BK, "BK"},
+							   {RWNX_HWQ_BE, "BE"},
+							   {RWNX_HWQ_VI, "VI"},
+							   {RWNX_HWQ_VO, "VO"},
+#ifdef CONFIG_RWNX_FULLMAC
+							   {RWNX_HWQ_BCMC, "BCMC"},
+#else
+							   {RWNX_HWQ_BCN, "BCN"},
+#endif
+							   {-1, NULL}};
+	return trace_print_symbols_seq(p, hwq_idx, symbols, ARRAY_SIZE(symbols));
+}
+
+static inline const char *ftrace_print_hwq_cred(struct trace_seq *p, u8 *c=
red)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+
+#if CONFIG_USER_MAX =3D=3D 1
+	trace_seq_printf(p, "%d", cred[0]);
+#else
+	int i;
+
+	for (i =3D 0; i < CONFIG_USER_MAX - 1; i++)
+		trace_seq_printf(p, "%d-", cred[i]);
+	trace_seq_printf(p, "%d", cred[i]);
+#endif
+
+	trace_seq_putc(p, 0);
+	return ret;
+}
+
+static inline const char *ftrace_print_mu_info(struct trace_seq *p, u8 mu_=
info)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+
+	if (mu_info)
+		trace_seq_printf(p, "MU: %d-%d", (mu_info & 0x3f), (mu_info >> 6));
+
+	trace_seq_putc(p, 0);
+	return ret;
+}
+
+static inline const char *ftrace_print_mu_group(struct trace_seq *p, int n=
b_user,
+						u8 *users)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+	int i;
+
+	if (users[0] !=3D 0xff)
+		trace_seq_printf(p, "(%d", users[0]);
+	else
+		trace_seq_printf(p, "(-");
+	for (i =3D 1; i < CONFIG_USER_MAX; i++) {
+		if (users[i] !=3D 0xff)
+			trace_seq_printf(p, ",%d", users[i]);
+		else
+			trace_seq_printf(p, ",-");
+	}
+
+	trace_seq_printf(p, ")");
+	trace_seq_putc(p, 0);
+	return ret;
+}
+
+static inline const char *ftrace_print_amsdu(struct trace_seq *p, u16 nb_p=
kt)
+{
+	const char *ret =3D trace_seq_buffer_ptr(p);
+
+	if (nb_pkt > 1)
+		trace_seq_printf(p, "(AMSDU %d)", nb_pkt);
+
+	trace_seq_putc(p, 0);
+	return ret;
+}
+#endif /* defined(CONFIG_TRACEPOINTS) && defined(AIC8800_CREATE_TRACE_POIN=
TS) */
+
+#undef __print_txq
+#define __print_txq(txq_idx) ftrace_print_txq(p, txq_idx)
+
+#undef __print_sta
+#define __print_sta(sta_idx) ftrace_print_sta(p, sta_idx)
+
+#undef __print_hwq
+#define __print_hwq(hwq) ftrace_print_hwq(p, hwq)
+
+#undef __print_hwq_cred
+#define __print_hwq_cred(cred) ftrace_print_hwq_cred(p, cred)
+
+#undef __print_mu_info
+#define __print_mu_info(mu_info) ftrace_print_mu_info(p, mu_info)
+
+#undef __print_mu_group
+#define __print_mu_group(nb, users) ftrace_print_mu_group(p, nb, users)
+
+#undef __print_amsdu
+#define __print_amsdu(nb_pkt) ftrace_print_amsdu(p, nb_pkt)
+
+#ifdef CONFIG_RWNX_FULLMAC
+
+TRACE_EVENT(txq_select, TP_PROTO(int txq_idx, u16 pkt_ready_up, struct sk_=
buff *skb),
+	    TP_ARGS(txq_idx, pkt_ready_up, skb),
+	    TP_STRUCT__entry(__field(u16, txq_idx) __field(u16, pkt_ready)
+			     __field(struct sk_buff *, skb)),
+	    TP_fast_assign(__entry->txq_idx =3D txq_idx;
+			   __entry->pkt_ready =3D pkt_ready_up; __entry->skb =3D skb;),
+	    TP_printk("%s pkt_ready_up=3D%d skb=3D%p", __print_txq(__entry->txq_i=
dx),
+		      __entry->pkt_ready, __entry->skb));
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+DECLARE_EVENT_CLASS(hwq_template, TP_PROTO(u8 hwq_idx), TP_ARGS(hwq_idx),
+		    TP_STRUCT__entry(__field(u8, hwq_idx)),
+		    TP_fast_assign(__entry->hwq_idx =3D hwq_idx;),
+		    TP_printk("%s", __print_hwq(__entry->hwq_idx)));
+
+DEFINE_EVENT(hwq_template, hwq_flowctrl_stop, TP_PROTO(u8 hwq_idx),
+	     TP_ARGS(hwq_idx));
+
+DEFINE_EVENT(hwq_template, hwq_flowctrl_start, TP_PROTO(u8 hwq_idx),
+	     TP_ARGS(hwq_idx));
+
+DECLARE_EVENT_CLASS(txq_template, TP_PROTO(struct rwnx_txq *txq), TP_ARGS(=
txq),
+		    TP_STRUCT__entry(__field(u16, txq_idx)),
+		    TP_fast_assign(__entry->txq_idx =3D txq->idx;),
+		    TP_printk("%s", __print_txq(__entry->txq_idx)));
+
+DEFINE_EVENT(txq_template, txq_add_to_hw, TP_PROTO(struct rwnx_txq *txq),
+	     TP_ARGS(txq));
+
+DEFINE_EVENT(txq_template, txq_del_from_hw, TP_PROTO(struct rwnx_txq *txq)=
,
+	     TP_ARGS(txq));
+
+#ifdef CONFIG_RWNX_FULLMAC
+
+DEFINE_EVENT(txq_template, txq_flowctrl_stop, TP_PROTO(struct rwnx_txq *tx=
q),
+	     TP_ARGS(txq));
+
+DEFINE_EVENT(txq_template, txq_flowctrl_restart, TP_PROTO(struct rwnx_txq =
*txq),
+	     TP_ARGS(txq));
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+TRACE_EVENT(process_txq, TP_PROTO(struct rwnx_txq *txq), TP_ARGS(txq),
+	    TP_STRUCT__entry(__field(u16, txq_idx) __field(u16, len)
+			     __field(u16, len_retry) __field(s8, credit)
+#ifdef CONFIG_RWNX_FULLMAC
+			     __field(u16, limit)
+#endif /* CONFIG_RWNX_FULLMAC */
+						),
+	    TP_fast_assign(__entry->txq_idx =3D txq->idx;
+			   __entry->len =3D skb_queue_len(&txq->sk_list);
+#ifdef CONFIG_MAC80211_TXQ
+			   __entry->len +=3D txq->nb_ready_mac80211;
+#endif
+			   __entry->len_retry =3D txq->nb_retry;
+			   __entry->credit =3D txq->credits;
+#ifdef CONFIG_RWNX_FULLMAC
+			   __entry->limit =3D txq->push_limit;
+#endif /* CONFIG_RWNX_FULLMAC */
+						),
+#ifdef CONFIG_RWNX_FULLMAC
+	    TP_printk("%s txq_credits=3D%d, len=3D%d, retry_len=3D%d, push_limit=
=3D%d",
+		      __print_txq(__entry->txq_idx), __entry->credit,
+		      __entry->len, __entry->len_retry, __entry->limit)
+#else
+	    TP_printk("%s txq_credits=3D%d, len=3D%d, retry_len=3D%d",
+		      __print_txq(__entry->txq_idx), __entry->credit,
+		      __entry->len, __entry->len_retry)
+#endif /* CONFIG_RWNX_FULLMAC */
+);
+
+DECLARE_EVENT_CLASS(txq_reason_template, TP_PROTO(struct rwnx_txq *txq, u1=
6 reason),
+		    TP_ARGS(txq, reason),
+		    TP_STRUCT__entry(__field(u16, txq_idx) __field(u16, reason)
+				     __field(u16, status)),
+		    TP_fast_assign(__entry->txq_idx =3D txq->idx; __entry->reason =3D re=
ason;
+				   __entry->status =3D txq->status;),
+		    TP_printk("%s reason=3D%s status=3D%s", __print_txq(__entry->txq_idx=
),
+			      __print_symbolic(__entry->reason, {RWNX_TXQ_STOP_FULL, "FULL"},
+					       {RWNX_TXQ_STOP_CSA, "CSA"},
+					       {RWNX_TXQ_STOP_STA_PS, "PS"},
+					       {RWNX_TXQ_STOP_VIF_PS, "VPS"},
+					       {RWNX_TXQ_STOP_CHAN, "CHAN"},
+					       {RWNX_TXQ_STOP_MU_POS, "MU"}),
+			      __print_flags(__entry->status, "|",
+					    {RWNX_TXQ_IN_HWQ_LIST, "IN LIST"},
+					    {RWNX_TXQ_STOP_FULL, "FULL"},
+					    {RWNX_TXQ_STOP_CSA, "CSA"},
+					    {RWNX_TXQ_STOP_STA_PS, "PS"},
+					    {RWNX_TXQ_STOP_VIF_PS, "VPS"},
+					    {RWNX_TXQ_STOP_CHAN, "CHAN"},
+					    {RWNX_TXQ_STOP_MU_POS, "MU"},
+					    {RWNX_TXQ_NDEV_FLOW_CTRL, "FLW_CTRL"})));
+
+DEFINE_EVENT(txq_reason_template, txq_start,
+	     TP_PROTO(struct rwnx_txq *txq, u16 reason), TP_ARGS(txq, reason));
+
+DEFINE_EVENT(txq_reason_template, txq_stop,
+	     TP_PROTO(struct rwnx_txq *txq, u16 reason), TP_ARGS(txq, reason));
+
+TRACE_EVENT(push_desc,
+	    TP_PROTO(struct sk_buff *skb, struct rwnx_sw_txhdr *sw_txhdr, int pus=
h_flags),
+	    TP_ARGS(skb, sw_txhdr, push_flags),
+	    TP_STRUCT__entry(__field(struct sk_buff *, skb) __field(unsigned int,=
 len)
+			     __field(u16, tx_queue) __field(u8, hw_queue)
+			     __field(u8, push_flag) __field(u32, flag)
+			     __field(s8, txq_cred) __field(u8, hwq_cred)
+			     __field(u16, pkt_cnt)
+			     __field(u8, mu_info)),
+	    TP_fast_assign(__entry->skb =3D skb; __entry->tx_queue =3D sw_txhdr->=
txq->idx;
+			   __entry->push_flag =3D push_flags;
+			   __entry->hw_queue =3D sw_txhdr->txq->hwq->id;
+			   __entry->txq_cred =3D sw_txhdr->txq->credits;
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+			   __entry->pkt_cnt =3D sw_txhdr->desc.host.packet_cnt;
+#endif
+#ifdef CONFIG_RWNX_FULLMAC
+			   __entry->flag =3D sw_txhdr->desc.host.flags;
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+#ifdef CONFIG_RWNX_AMSDUS_TX
+			if (sw_txhdr->amsdu.len)
+				__entry->len =3D sw_txhdr->amsdu.len;
+			else
+#endif /* CONFIG_RWNX_AMSDUS_TX */
+				__entry->len =3D sw_txhdr->desc.host.packet_len[0];
+#else
+			   __entry->len =3D sw_txhdr->desc.host.packet_len;
+#endif /* CONFIG_RWNX_SPLIT_TX_BUF */
+#else  /* !CONFIG_RWNX_FULLMAC */
+			   __entry->flag =3D sw_txhdr->desc.umac.flags;
+			   __entry->len =3D sw_txhdr->frame_len;
+			   __entry->sn =3D sw_txhdr->sn;
+#endif /* CONFIG_RWNX_FULLMAC */
+#ifdef CONFIG_RWNX_MUMIMO_TX
+			   __entry->mu_info =3D sw_txhdr->desc.host.mumimo_info;
+#else
+			   __entry->mu_info =3D 0;
+#endif
+					),
+#ifdef CONFIG_RWNX_FULLMAC
+	TP_printk("%s skb=3D%p (len=3D%d) hw_queue=3D%s cred_txq=3D%d cred_hwq=3D=
%d %s flag=3D%s %s %s %s",
+		  __print_txq(__entry->tx_queue), __entry->skb, __entry->len,
+		  __print_hwq(__entry->hw_queue), __entry->txq_cred,
+		  __entry->hwq_cred, __print_mu_info(__entry->mu_info),
+		  __print_flags(__entry->flag, "|", {TXU_CNTRL_RETRY, "RETRY"},
+				{TXU_CNTRL_MORE_DATA, "MOREDATA"}, {TXU_CNTRL_MGMT, "MGMT"},
+				{TXU_CNTRL_MGMT_NO_CCK, "NO_CCK"},
+				{TXU_CNTRL_MGMT_ROBUST, "ROBUST"}, {TXU_CNTRL_AMSDU, "AMSDU"},
+				{TXU_CNTRL_USE_4ADDR, "4ADDR"}, {TXU_CNTRL_EOSP, "EOSP"},
+				{TXU_CNTRL_MESH_FWD, "MESH_FWD"}, {TXU_CNTRL_TDLS, "TDLS"}),
+		  (__entry->push_flag & RWNX_PUSH_IMMEDIATE) ? "(IMMEDIATE)" : "",
+		  (!(__entry->flag & TXU_CNTRL_RETRY) &&
+		  (__entry->push_flag & RWNX_PUSH_RETRY))
+		  ? "(SW_RETRY)" : "",
+		  __print_amsdu(__entry->pkt_cnt))
+#else
+	TP_printk("%s skb=3D%p (len=3D%d) hw_queue=3D%s cred_txq=3D%d cred_hwq=3D=
%d %s flag=3D%x (%s) sn=3D%d %s",
+		  __print_txq(__entry->tx_queue), __entry->skb, __entry->len,
+		  __print_hwq(__entry->hw_queue), __entry->txq_cred,
+		  __entry->hwq_cred, __print_mu_info(__entry->mu_info),
+		  __entry->flag,
+		  __print_flags(__entry->push_flag, "|", {RWNX_PUSH_RETRY, "RETRY"},
+				{RWNX_PUSH_IMMEDIATE, "IMMEDIATE"}),
+		  __entry->sn, __print_amsdu(__entry->pkt_cnt))
+#endif /* CONFIG_RWNX_FULLMAC */
+);
+
+TRACE_EVENT(txq_queue_skb, TP_PROTO(struct sk_buff *skb, struct rwnx_txq *=
txq, bool retry),
+	    TP_ARGS(skb, txq, retry),
+	    TP_STRUCT__entry(__field(struct sk_buff *, skb) __field(u16, txq_idx)
+			     __field(s8, credit) __field(u16, q_len)
+			     __field(u16, q_len_retry) __field(bool, retry)),
+	TP_fast_assign(__entry->skb =3D skb; __entry->txq_idx =3D txq->idx;
+		       __entry->credit =3D txq->credits;
+		       __entry->q_len =3D skb_queue_len(&txq->sk_list);
+		       __entry->q_len_retry =3D txq->nb_retry;
+		       __entry->retry =3D retry;),
+	TP_printk("%s skb=3D%p retry=3D%d txq_credits=3D%d queue_len=3D%d (retry =
=3D %d)",
+		  __print_txq(__entry->txq_idx), __entry->skb, __entry->retry,
+		  __entry->credit, __entry->q_len, __entry->q_len_retry));
+
+#ifdef CONFIG_MAC80211_TXQ
+TRACE_EVENT(txq_wake, TP_PROTO(struct rwnx_txq *txq), TP_ARGS(txq),
+	    TP_STRUCT__entry(__field(u16, txq_idx) __field(u16, q_len)),
+	    TP_fast_assign(__entry->txq_idx =3D txq->idx;
+			   __entry->q_len =3D txq->nb_ready_mac80211;),
+	    TP_printk("%s mac80211_queue_len=3D%d", __print_txq(__entry->txq_idx)=
,
+		      __entry->q_len));
+
+TRACE_EVENT(txq_drop, TP_PROTO(struct rwnx_txq *txq, unsigned long nb_drop=
),
+	    TP_ARGS(txq, nb_drop),
+	    TP_STRUCT__entry(__field(u16, txq_idx) __field(u16, nb_drop)),
+	    TP_fast_assign(__entry->txq_idx =3D txq->idx;
+			   __entry->nb_drop =3D nb_drop;),
+	    TP_printk("%s %u pkt have been dropped by codel in mac80211 txq",
+		      __print_txq(__entry->txq_idx), __entry->nb_drop));
+
+#endif
+
+DECLARE_EVENT_CLASS(idx_template, TP_PROTO(u16 idx), TP_ARGS(idx),
+		    TP_STRUCT__entry(__field(u16, idx)),
+		    TP_fast_assign(__entry->idx =3D idx;),
+		    TP_printk("idx=3D%d", __entry->idx));
+
+DEFINE_EVENT(idx_template, txq_vif_start, TP_PROTO(u16 idx), TP_ARGS(idx))=
;
+
+DEFINE_EVENT(idx_template, txq_vif_stop, TP_PROTO(u16 idx), TP_ARGS(idx));
+
+TRACE_EVENT(process_hw_queue, TP_PROTO(struct rwnx_hwq *hwq), TP_ARGS(hwq)=
,
+	    TP_STRUCT__entry(__field(u16, hwq)
+			     __array(u8, credits, CONFIG_USER_MAX)),
+	    TP_fast_assign(__entry->hwq =3D hwq->id;),
+	    TP_printk("hw_queue=3D%s hw_credits=3D%s", __print_hwq(__entry->hwq),
+		      __print_hwq_cred(__entry->credits)));
+
+DECLARE_EVENT_CLASS(sta_idx_template, TP_PROTO(u16 idx), TP_ARGS(idx),
+		    TP_STRUCT__entry(__field(u16, idx)),
+		    TP_fast_assign(__entry->idx =3D idx;),
+		    TP_printk("%s", __print_sta(__entry->idx)));
+
+DEFINE_EVENT(sta_idx_template, txq_sta_start, TP_PROTO(u16 idx), TP_ARGS(i=
dx));
+
+DEFINE_EVENT(sta_idx_template, txq_sta_stop, TP_PROTO(u16 idx), TP_ARGS(id=
x));
+
+#ifdef CONFIG_RWNX_FULLMAC
+
+DEFINE_EVENT(sta_idx_template, ps_disable, TP_PROTO(u16 idx), TP_ARGS(idx)=
);
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+TRACE_EVENT(skb_confirm,
+	    #ifdef CONFIG_RWNX_FULLMAC
+	    TP_PROTO(struct sk_buff *skb, struct rwnx_txq *txq,
+		     struct rwnx_hwq *hwq, struct tx_cfm_tag *cfm),
+	    #else
+	    TP_PROTO(struct sk_buff *skb, struct rwnx_txq *txq,
+		     struct rwnx_hwq *hwq, u8 cfm),
+	    #endif
+	TP_ARGS(skb, txq, hwq, cfm),
+	TP_STRUCT__entry(__field(struct sk_buff *, skb) __field(u16, txq_idx)
+			 __field(u8, hw_queue) __array(u8, hw_credit, CONFIG_USER_MAX)
+			 __field(s8, sw_credit) __field(s8, sw_credit_up)
+#ifdef CONFIG_RWNX_FULLMAC
+			 __field(u8, ampdu_size)
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+			 __field(u16, amsdu)
+#endif /* CONFIG_RWNX_SPLIT_TX_BUF */
+			 __field(u16, sn)
+#endif /* CONFIG_RWNX_FULLMAC */
+					),
+	TP_fast_assign(__entry->skb =3D skb; __entry->txq_idx =3D txq->idx;
+		       __entry->hw_queue =3D hwq->id;
+		       __entry->sw_credit =3D txq->credits;
+#if defined CONFIG_RWNX_FULLMAC
+		       __entry->sw_credit_up =3D cfm->credits;
+		       __entry->ampdu_size =3D cfm->ampdu_size;
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+		       __entry->amsdu =3D cfm->amsdu_size; __entry->sn =3D cfm->sn;
+#endif
+#else
+		       __entry->sw_credit_up =3D cfm
+#endif /* CONFIG_RWNX_FULLMAC */
+				),
+	TP_printk("%s skb=3D%p hw_queue=3D%s, hw_credits=3D%s, txq_credits=3D%d (=
+%d)"
+#ifdef CONFIG_RWNX_FULLMAC
+		  " sn=3D%u ampdu=3D%d"
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+		  " amsdu=3D%u"
+#endif
+#endif
+		,
+		  __print_txq(__entry->txq_idx), __entry->skb,
+		  __print_hwq(__entry->hw_queue),
+		  __print_hwq_cred(__entry->hw_credit), __entry->sw_credit,
+		  __entry->sw_credit_up
+#ifdef CONFIG_RWNX_FULLMAC
+		,
+		  __entry->sn, __entry->ampdu_size
+#ifdef CONFIG_RWNX_SPLIT_TX_BUF
+		,
+		  __entry->amsdu
+#endif
+#endif
+			));
+
+TRACE_EVENT(credit_update, TP_PROTO(struct rwnx_txq *txq, s8_l cred_up),
+	    TP_ARGS(txq, cred_up),
+	    TP_STRUCT__entry(__field(struct sk_buff *, skb)
+			     __field(u16, txq_idx) __field(s8, sw_credit)
+			     __field(s8, sw_credit_up)),
+	    TP_fast_assign(__entry->txq_idx =3D txq->idx;
+			   __entry->sw_credit =3D txq->credits;
+			   __entry->sw_credit_up =3D cred_up;),
+	    TP_printk("%s txq_credits=3D%d (%+d)", __print_txq(__entry->txq_idx),
+		      __entry->sw_credit, __entry->sw_credit_up))
+#ifdef CONFIG_RWNX_FULLMAC
+DECLARE_EVENT_CLASS(ps_template, TP_PROTO(struct rwnx_sta *sta), TP_ARGS(s=
ta),
+		    TP_STRUCT__entry(__field(u16, idx) __field(u16, ready_ps)
+				     __field(u16, sp_ps) __field(u16, ready_uapsd)
+				     __field(u16, sp_uapsd)),
+		    TP_fast_assign(__entry->idx =3D sta->sta_idx;
+				   __entry->ready_ps =3D sta->ps.pkt_ready[LEGACY_PS_ID];
+				   __entry->sp_ps =3D sta->ps.sp_cnt[LEGACY_PS_ID];
+				   __entry->ready_uapsd =3D sta->ps.pkt_ready[UAPSD_ID];
+				   __entry->sp_uapsd =3D sta->ps.sp_cnt[UAPSD_ID];),
+		    TP_printk("%s [PS] ready=3D%d sp=3D%d [UAPSD] ready=3D%d sp=3D%d",
+			      __print_sta(__entry->idx), __entry->ready_ps, __entry->sp_ps,
+			      __entry->ready_uapsd, __entry->sp_uapsd));
+
+DEFINE_EVENT(ps_template, ps_queue, TP_PROTO(struct rwnx_sta *sta), TP_ARG=
S(sta));
+
+DEFINE_EVENT(ps_template, ps_push, TP_PROTO(struct rwnx_sta *sta), TP_ARGS=
(sta));
+
+DEFINE_EVENT(ps_template, ps_enable, TP_PROTO(struct rwnx_sta *sta), TP_AR=
GS(sta));
+
+TRACE_EVENT(ps_traffic_update, TP_PROTO(u16 sta_idx, u8 traffic, bool uaps=
d),
+	    TP_ARGS(sta_idx, traffic, uapsd),
+	    TP_STRUCT__entry(__field(u16, sta_idx) __field(u8, traffic)
+			     __field(bool, uapsd)),
+	    TP_fast_assign(__entry->sta_idx =3D sta_idx;
+			   __entry->traffic =3D traffic; __entry->uapsd =3D uapsd;),
+	    TP_printk("%s %s%s traffic available ",
+		      __print_sta(__entry->sta_idx),
+		      __entry->traffic ? "" : "no more ",
+		      __entry->uapsd ? "U-APSD" : "legacy PS"));
+
+TRACE_EVENT(ps_traffic_req, TP_PROTO(struct rwnx_sta *sta, u16 pkt_req, u8=
 ps_id),
+	    TP_ARGS(sta, pkt_req, ps_id),
+	    TP_STRUCT__entry(__field(u16, idx) __field(u16, pkt_req)
+			     __field(u8, ps_id) __field(u16, ready)
+			     __field(u16, sp)),
+	    TP_fast_assign(__entry->idx =3D sta->sta_idx;
+			   __entry->pkt_req =3D pkt_req; __entry->ps_id =3D ps_id;
+			   __entry->ready =3D sta->ps.pkt_ready[ps_id];
+			   __entry->sp =3D sta->ps.sp_cnt[ps_id];),
+	    TP_printk("%s %s traffic request %d pkt (ready=3D%d, sp=3D%d)",
+		      __print_sta(__entry->idx),
+		      __entry->ps_id =3D=3D UAPSD_ID ? "U-APSD" : "legacy PS",
+		      __entry->pkt_req, __entry->ready, __entry->sp));
+
+#ifdef CONFIG_RWNX_AMSDUS_TX
+TRACE_EVENT(amsdu_subframe, TP_PROTO(struct rwnx_sw_txhdr *sw_txhdr),
+	    TP_ARGS(sw_txhdr),
+	    TP_STRUCT__entry(__field(struct sk_buff *, skb)
+			     __field(u16, txq_idx) __field(u8, nb)
+			     __field(u32, len)),
+	    TP_fast_assign(__entry->skb =3D sw_txhdr->skb;
+			   __entry->nb =3D sw_txhdr->amsdu.nb;
+			   __entry->len =3D sw_txhdr->amsdu.len;
+			   __entry->txq_idx =3D sw_txhdr->txq->idx;),
+	    TP_printk("%s skb=3D%p %s nb_subframe=3D%d, len=3D%u",
+		      __print_txq(__entry->txq_idx), __entry->skb,
+		      (__entry->nb =3D=3D 2) ? "Start new AMSDU" : "Add subframe",
+		      __entry->nb, __entry->len));
+#endif
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+#ifdef CONFIG_RWNX_MUMIMO_TX
+TRACE_EVENT(mu_group_update, TP_PROTO(struct rwnx_mu_group *group),
+	    TP_ARGS(group),
+	    TP_STRUCT__entry(__field(u8, nb_user) __field(u8, group_id)
+			     __array(u8, users, CONFIG_USER_MAX)),
+	    TP_fast_assign(int i; __entry->nb_user =3D group->user_cnt;
+			for (i =3D 0; i < CONFIG_USER_MAX; i++) {
+				if (group->users[i])
+					__entry->users[i] =3D group->users[i]->sta_idx;
+				else
+					__entry->users[i] =3D 0xff;
+			}
+			__entry->group_id =3D group->group_id;),
+	    TP_printk("Group-id =3D %d, Users =3D %s", __entry->group_id,
+		      __print_mu_group(__entry->nb_user, __entry->users)));
+
+TRACE_EVENT(mu_group_delete, TP_PROTO(int group_id), TP_ARGS(group_id),
+	    TP_STRUCT__entry(__field(u8, group_id)),
+	    TP_fast_assign(__entry->group_id =3D group_id;),
+	    TP_printk("Group-id =3D %d", __entry->group_id));
+
+TRACE_EVENT(mu_group_selection, TP_PROTO(struct rwnx_sta *sta, int group_i=
d),
+	    TP_ARGS(sta, group_id),
+	    TP_STRUCT__entry(__field(u8, sta_idx) __field(u8, group_id)),
+	    TP_fast_assign(__entry->sta_idx =3D sta->sta_idx;
+			   __entry->group_id =3D group_id;),
+	    TP_printk("[Sta %d] Group-id =3D %d", __entry->sta_idx,
+		      __entry->group_id));
+
+TRACE_EVENT(txq_select_mu_group,
+	    TP_PROTO(struct rwnx_txq *txq, int group_id, int pos),
+	    TP_ARGS(txq, group_id, pos),
+	    TP_STRUCT__entry(__field(u16, txq_idx) __field(u8, group_id)
+			     __field(u8, pos)),
+	    TP_fast_assign(__entry->txq_idx =3D txq->idx;
+			   __entry->group_id =3D group_id; __entry->pos =3D pos;),
+	    TP_printk("%s: group=3D%d pos=3D%d", __print_txq(__entry->txq_idx),
+		      __entry->group_id, __entry->pos));
+
+#endif /* CONFIG_RWNX_MUMIMO_TX */
+
+/*************************************************************************=
****
+ * TRACE functions for MESH
+ *************************************************************************=
***/
+#ifdef CONFIG_RWNX_FULLMAC
+DECLARE_EVENT_CLASS(mesh_path_template, TP_PROTO(struct rwnx_mesh_path *me=
sh_path),
+		    TP_ARGS(mesh_path),
+		    TP_STRUCT__entry(__field(u8, idx) __field(u8, next_hop_sta)
+				     __array(u8, tgt_mac, ETH_ALEN)),
+		    TP_fast_assign(__entry->idx =3D mesh_path->path_idx;
+				   memcpy(__entry->tgt_mac, &mesh_path->tgt_mac_addr, ETH_ALEN);
+				if (mesh_path->p_nhop_sta)
+					__entry->next_hop_sta =3D mesh_path->p_nhop_sta->sta_idx;
+				else
+					__entry->next_hop_sta =3D 0xff;),
+		    TP_printk("Mpath(%d): target=3D%pM next_hop=3DSTA-%d", __entry->idx,
+			      __entry->tgt_mac, __entry->next_hop_sta));
+
+DEFINE_EVENT(mesh_path_template, mesh_create_path,
+	     TP_PROTO(struct rwnx_mesh_path *mesh_path), TP_ARGS(mesh_path));
+
+DEFINE_EVENT(mesh_path_template, mesh_delete_path,
+	     TP_PROTO(struct rwnx_mesh_path *mesh_path), TP_ARGS(mesh_path));
+
+DEFINE_EVENT(mesh_path_template, mesh_update_path,
+	     TP_PROTO(struct rwnx_mesh_path *mesh_path), TP_ARGS(mesh_path));
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+/*************************************************************************=
****
+ * TRACE functions for RADAR
+ *************************************************************************=
***/
+#ifdef CONFIG_RWNX_RADAR
+TRACE_EVENT(radar_pulse, TP_PROTO(u8 chain, struct radar_pulse *pulse),
+	    TP_ARGS(chain, pulse),
+	    TP_STRUCT__entry(__field(u8, chain) __field(s16, freq)
+			     __field(u16, pri) __field(u8, len)
+			     __field(u8, fom)),
+	    TP_fast_assign(__entry->freq =3D pulse->freq * 2;
+			   __entry->len =3D pulse->len * 2;
+			   __entry->fom =3D pulse->fom * 6;
+			   __entry->pri =3D pulse->rep; __entry->chain =3D chain;),
+	    TP_printk("%s: PRI=3D%.5d LEN=3D%.3d FOM=3D%.2d%% freq=3D%dMHz ",
+		      __print_symbolic(__entry->chain, {RWNX_RADAR_RIU, "RIU"},
+				       {RWNX_RADAR_FCU, "FCU"}),
+				       __entry->pri, __entry->len, __entry->fom, __entry->freq));
+
+TRACE_EVENT(radar_detected, TP_PROTO(u8 chain, u8 region, s16 freq, u8 typ=
e, u16 pri),
+	    TP_ARGS(chain, region, freq, type, pri),
+	    TP_STRUCT__entry(__field(u8, chain) __field(u8, region) __field(s16, =
freq)
+			     __field(u8, type) __field(u16, pri)),
+	    TP_fast_assign(__entry->chain =3D chain; __entry->region =3D region;
+			   __entry->freq =3D freq; __entry->type =3D type;
+			   __entry->pri =3D pri;),
+	    TP_printk("%s: region=3D%s type=3D%d freq=3D%dMHz (pri=3D%dus)",
+		      __print_symbolic(__entry->chain, {RWNX_RADAR_RIU, "RIU"},
+				       {RWNX_RADAR_FCU, "FCU"}),
+		      __print_symbolic(__entry->region, {NL80211_DFS_UNSET, "UNSET"},
+				       {NL80211_DFS_FCC, "FCC"},
+				       {NL80211_DFS_ETSI, "ETSI"},
+				       {NL80211_DFS_JP, "JP"}),
+		      __entry->type, __entry->freq, __entry->pri));
+
+TRACE_EVENT(radar_set_region, TP_PROTO(u8 region), TP_ARGS(region),
+	    TP_STRUCT__entry(__field(u8, region)),
+	    TP_fast_assign(__entry->region =3D region;),
+	    TP_printk("region=3D%s",
+		      __print_symbolic(__entry->region,
+				       {NL80211_DFS_UNSET, "UNSET"},
+				       {NL80211_DFS_FCC, "FCC"},
+				       {NL80211_DFS_ETSI, "ETSI"},
+				       {NL80211_DFS_JP, "JP"})));
+
+TRACE_EVENT(radar_enable_detection, TP_PROTO(u8 region, u8 enable, u8 chai=
n),
+	    TP_ARGS(region, enable, chain),
+	    TP_STRUCT__entry(__field(u8, region) __field(u8, chain)
+			     __field(u8, enable)),
+	    TP_fast_assign(__entry->chain =3D chain; __entry->enable =3D enable;
+			   __entry->region =3D region;),
+	    TP_printk("%s: %s radar detection %s",
+		      __print_symbolic(__entry->chain, {RWNX_RADAR_RIU, "RIU"},
+				       {RWNX_RADAR_FCU, "FCU"}),
+		      __print_symbolic(__entry->enable,
+				       {RWNX_RADAR_DETECT_DISABLE, "Disable"},
+				       {RWNX_RADAR_DETECT_ENABLE,
+				       "Enable (no report)"},
+				       {RWNX_RADAR_DETECT_REPORT, "Enable"}),
+		      __entry->enable =3D=3D RWNX_RADAR_DETECT_DISABLE
+				? ""	: __print_symbolic(__entry->region,
+							   {NL80211_DFS_UNSET, "UNSET"},
+							   {NL80211_DFS_FCC, "FCC"},
+							   {NL80211_DFS_ETSI, "ETSI"},
+							   {NL80211_DFS_JP, "JP"})));
+#endif /* CONFIG_RWNX_RADAR */
+
+/*************************************************************************=
****
+ * TRACE functions for IPC message
+ *************************************************************************=
***/
+#include "rwnx_strs.h"
+
+DECLARE_EVENT_CLASS(ipc_msg_template, TP_PROTO(u16 id), TP_ARGS(id),
+		    TP_STRUCT__entry(__field(u16, id)),
+		    TP_fast_assign(__entry->id =3D id;),
+		    TP_printk("%s (%d - %d)", RWNX_ID2STR(__entry->id),
+			      MSG_T(__entry->id), MSG_I(__entry->id)));
+
+DEFINE_EVENT(ipc_msg_template, msg_send, TP_PROTO(u16 id), TP_ARGS(id));
+
+DEFINE_EVENT(ipc_msg_template, msg_recv, TP_PROTO(u16 id), TP_ARGS(id));
+
+#endif /* !defined(_RWNX_EVENTS_H) || defined(TRACE_HEADER_MULTI_READ) */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH AIC_TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_FILE rwnx_events
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_irqs.c b/drivers/ne=
t/wireless/aic/aic8800_fdrv/rwnx_irqs.c
new file mode 100644
index 0000000000000..a941ab6e76e0b
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_irqs.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief IRQ handler
+ *
+ *************************************************************************=
*****
+ */
+#include <linux/interrupt.h>
+
+#include "rwnx_irqs.h"
+#include "ipc_host.h"
+#include "rwnx_defs.h"
+#include "rwnx_prof.h"
+
+/**
+ * rwnx_irq_hdlr - IRQ handler
+ *
+ * Handler registered by the platform driver
+ */
+irqreturn_t rwnx_irq_hdlr(int irq, void *dev_id)
+{
+	struct rwnx_hw *rwnx_hw =3D (struct rwnx_hw *)dev_id;
+
+	disable_irq_nosync(irq);
+	tasklet_schedule(&rwnx_hw->task);
+	return IRQ_HANDLED;
+}
+
+/**
+ * rwnx_task - Bottom half for IRQ handler
+ *
+ * Read irq status and process accordingly
+ */
+void rwnx_task(unsigned long data)
+{
+	struct rwnx_hw *rwnx_hw =3D (struct rwnx_hw *)data;
+
+	spin_lock_bh(&rwnx_hw->tx_lock);
+	rwnx_hwq_process_all(rwnx_hw);
+	spin_unlock_bh(&rwnx_hw->tx_lock);
+}
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_irqs.h b/drivers/ne=
t/wireless/aic/aic8800_fdrv/rwnx_irqs.h
new file mode 100644
index 0000000000000..ff6c766c727c3
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_irqs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _RWNX_IRQS_H_
+#define _RWNX_IRQS_H_
+
+#include <linux/interrupt.h>
+
+/* IRQ handler to be registered by platform driver */
+irqreturn_t rwnx_irq_hdlr(int irq, void *dev_id);
+
+void rwnx_task(unsigned long data);
+
+#endif /* _RWNX_IRQS_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.c b/drivers/=
net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.c
new file mode 100644
index 0000000000000..75971f7d4cb67
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.c
@@ -0,0 +1,1742 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief RX function definitions
+ *
+ *************************************************************************=
*****
+ */
+
+#include "rwnx_defs.h"
+#include "rwnx_prof.h"
+#include "rwnx_tx.h"
+#include "rwnx_rx.h"
+#include <linux/rtnetlink.h>
+#include <linux/vmalloc.h>
+#ifdef CONFIG_RWNX_BFMER
+#include "rwnx_bfmer.h"
+#endif //(CONFIG_RWNX_BFMER)
+#ifdef CONFIG_RWNX_FULLMAC
+#include "rwnx_debugfs.h"
+#include "rwnx_msg_tx.h"
+#include "rwnx_tdls.h"
+#endif /* CONFIG_RWNX_FULLMAC */
+#include "aicwf_txrxif.h"
+#include "rwnx_compat.h"
+#include "rwnx_events.h"
+#include "rwnx_msg_rx.h"
+#ifdef CONFIG_SDIO_BT
+#include "aic_btsdio.h"
+#endif
+#include "rwnx_mod_params.h"
+#include "rwnx_wakelock.h"
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+#include "aicwf_compat_8800d80.h"
+#endif
+#ifdef CONFIG_AIC8800_USE_WIRELESS_EXT
+#include "aicwf_wext_linux.h"
+#endif
+
+void rwnx_cfg80211_unlink_bss(struct rwnx_hw *rwnx_hw,
+			      struct rwnx_vif *rwnx_vif);
+
+static int rwnx_freq_to_idx(struct rwnx_hw *rwnx_hw, int freq)
+{
+	struct ieee80211_supported_band *sband =3D NULL;
+	int band, ch, idx =3D 0;
+
+	for (band =3D NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; band++) {
+#ifdef CONFIG_RWNX_FULLMAC
+		sband =3D rwnx_hw->wiphy->bands[band];
+#endif /* CONFIG_RWNX_FULLMAC */
+		if (!sband)
+			continue;
+
+		for (ch =3D 0; ch < sband->n_channels; ch++, idx++) {
+			if (sband->channels[ch].center_freq =3D=3D freq)
+				goto exit;
+		}
+	}
+
+	WARN_ON_ONCE(1);
+
+exit:
+	// Channel has been found, return the index
+	return idx;
+}
+
+/*************************************************************************=
**
+ * Messages from MM task
+ *************************************************************************=
*/
+static inline int rwnx_rx_chan_pre_switch_ind(struct rwnx_hw *rwnx_hw,
+					      struct rwnx_cmd *cmd,
+					      struct ipc_e2a_msg *msg)
+{
+	struct rwnx_vif *rwnx_vif;
+	int chan_idx =3D ((struct mm_channel_pre_switch_ind *)msg->param)->chan_i=
ndex;
+
+	REG_SW_SET_PROFILING_CHAN(rwnx_hw, SW_PROF_CHAN_CTXT_PSWTCH_BIT);
+
+#ifdef CONFIG_RWNX_FULLMAC
+	list_for_each_entry(rwnx_vif, &rwnx_hw->vifs, list) {
+		if (rwnx_vif->up && rwnx_vif->ch_index =3D=3D chan_idx)
+			rwnx_txq_vif_stop(rwnx_vif, RWNX_TXQ_STOP_CHAN, rwnx_hw);
+	}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	REG_SW_CLEAR_PROFILING_CHAN(rwnx_hw, SW_PROF_CHAN_CTXT_PSWTCH_BIT);
+
+	return 0;
+}
+
+static inline int rwnx_rx_chan_switch_ind(struct rwnx_hw *rwnx_hw,
+					  struct rwnx_cmd *cmd,
+					  struct ipc_e2a_msg *msg)
+{
+	struct rwnx_vif *rwnx_vif;
+	int chan_idx =3D ((struct mm_channel_switch_ind *)msg->param)->chan_index=
;
+	bool roc =3D ((struct mm_channel_switch_ind *)msg->param)->roc;
+	bool roc_tdls =3D ((struct mm_channel_switch_ind *)msg->param)->roc_tdls;
+
+	REG_SW_SET_PROFILING_CHAN(rwnx_hw, SW_PROF_CHAN_CTXT_SWTCH_BIT);
+
+#ifdef CONFIG_RWNX_FULLMAC
+	if (roc_tdls) {
+		u8 vif_index =3D ((struct mm_channel_switch_ind *)msg->param)->vif_index=
;
+
+		list_for_each_entry(rwnx_vif, &rwnx_hw->vifs, list) {
+			if (rwnx_vif->vif_index =3D=3D vif_index) {
+				rwnx_vif->roc_tdls =3D true;
+				rwnx_txq_tdls_sta_start(rwnx_vif, RWNX_TXQ_STOP_CHAN, rwnx_hw);
+			}
+		}
+	} else if (!roc) {
+		list_for_each_entry(rwnx_vif, &rwnx_hw->vifs, list) {
+			if (rwnx_vif->up && rwnx_vif->ch_index =3D=3D chan_idx)
+				rwnx_txq_vif_start(rwnx_vif, RWNX_TXQ_STOP_CHAN, rwnx_hw);
+		}
+	} else {
+		/* Retrieve the allocated RoC element */
+		struct rwnx_roc_elem *roc_elem =3D rwnx_hw->roc_elem;
+		/* Get VIF on which RoC has been started */
+		// rwnx_vif =3D netdev_priv(roc_elem->wdev->netdev);
+
+		/* For debug purpose (use ftrace kernel option) */
+		// trace_switch_roc(rwnx_vif->vif_index);
+
+		if (roc_elem) {
+			/* If mgmt_roc is true, remain on channel has been started by
+			 * ourself
+			 */
+			if (!roc_elem->mgmt_roc) {
+				/* Inform the host that we have switch on the indicated
+				 * off-channel
+				 */
+				cfg80211_ready_on_channel(roc_elem->wdev,
+							  (u64)(rwnx_hw->roc_cookie_cnt),
+							  roc_elem->chan, roc_elem->duration,
+							  GFP_ATOMIC);
+			}
+
+			/* Keep in mind that we have switched on the channel */
+			roc_elem->on_chan =3D true;
+		} else {
+			AICWFDBG(LOGDEBUG, "roc_elem =3D=3D null\n");
+		}
+		// Enable traffic on OFF channel queue
+		rwnx_txq_offchan_start(rwnx_hw);
+	}
+
+	tasklet_schedule(&rwnx_hw->task);
+
+	rwnx_hw->cur_chanctx =3D chan_idx;
+	rwnx_radar_detection_enable_on_cur_channel(rwnx_hw);
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	REG_SW_CLEAR_PROFILING_CHAN(rwnx_hw, SW_PROF_CHAN_CTXT_SWTCH_BIT);
+
+	return 0;
+}
+
+static inline int rwnx_rx_tdls_chan_switch_cfm(struct rwnx_hw *rwnx_hw,
+					       struct rwnx_cmd *cmd,
+					       struct ipc_e2a_msg *msg)
+{
+	return 0;
+}
+
+static inline int rwnx_rx_tdls_chan_switch_ind(struct rwnx_hw *rwnx_hw,
+					       struct rwnx_cmd *cmd,
+					       struct ipc_e2a_msg *msg)
+{
+#ifdef CONFIG_RWNX_FULLMAC
+	// Enable traffic on OFF channel queue
+	rwnx_txq_offchan_start(rwnx_hw);
+
+	return 0;
+#endif
+}
+
+static inline int rwnx_rx_tdls_chan_switch_base_ind(struct rwnx_hw *rwnx_h=
w,
+						    struct rwnx_cmd *cmd,
+						    struct ipc_e2a_msg *msg)
+{
+	struct rwnx_vif *rwnx_vif;
+	u8 vif_index =3D ((struct tdls_chan_switch_base_ind *)msg->param)->vif_in=
dex;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+#ifdef CONFIG_RWNX_FULLMAC
+	list_for_each_entry(rwnx_vif, &rwnx_hw->vifs, list) {
+		if (rwnx_vif->vif_index =3D=3D vif_index) {
+			rwnx_vif->roc_tdls =3D false;
+			rwnx_txq_tdls_sta_stop(rwnx_vif, RWNX_TXQ_STOP_CHAN, rwnx_hw);
+		}
+	}
+	return 0;
+#endif
+}
+
+static inline int rwnx_rx_tdls_peer_ps_ind(struct rwnx_hw *rwnx_hw,
+					   struct rwnx_cmd *cmd,
+					   struct ipc_e2a_msg *msg)
+{
+	struct rwnx_vif *rwnx_vif;
+	u8 vif_index =3D ((struct tdls_peer_ps_ind *)msg->param)->vif_index;
+	bool ps_on =3D ((struct tdls_peer_ps_ind *)msg->param)->ps_on;
+
+#ifdef CONFIG_RWNX_FULLMAC
+	list_for_each_entry(rwnx_vif, &rwnx_hw->vifs, list) {
+		if (rwnx_vif->vif_index =3D=3D vif_index) {
+			rwnx_vif->sta.tdls_sta->tdls.ps_on =3D ps_on;
+			// Update PS status for the TDLS station
+			rwnx_ps_bh_enable(rwnx_hw, rwnx_vif->sta.tdls_sta, ps_on);
+		}
+	}
+
+	return 0;
+#endif
+}
+
+static inline int rwnx_rx_remain_on_channel_exp_ind(struct rwnx_hw *rwnx_h=
w,
+						    struct rwnx_cmd *cmd,
+						    struct ipc_e2a_msg *msg)
+{
+#ifdef CONFIG_RWNX_FULLMAC
+	/* Retrieve the allocated RoC element */
+	struct rwnx_roc_elem *roc_elem =3D rwnx_hw->roc_elem;
+	/* Get VIF on which RoC has been started */
+	struct rwnx_vif *rwnx_vif;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	if (!roc_elem)
+		return 0;
+
+	rwnx_vif =3D container_of(roc_elem->wdev, struct rwnx_vif, wdev);
+	/* For debug purpose (use ftrace kernel option) */
+#ifdef AIC8800_CREATE_TRACE_POINTS
+	trace_roc_exp(rwnx_vif->vif_index);
+#endif
+	/* If mgmt_roc is true, remain on channel has been started by ourself */
+	/* If RoC has been cancelled before we switched on channel, do not call
+	 * cfg80211
+	 */
+	if (!roc_elem->mgmt_roc && roc_elem->on_chan) {
+		/* Inform the host that off-channel period has expired */
+		cfg80211_remain_on_channel_expired(roc_elem->wdev,
+						   (u64)(rwnx_hw->roc_cookie_cnt),
+						   roc_elem->chan, GFP_ATOMIC);
+	}
+
+	/* De-init offchannel TX queue */
+	rwnx_txq_offchan_deinit(rwnx_vif);
+
+	/* Increase the cookie counter cannot be zero */
+	rwnx_hw->roc_cookie_cnt++;
+
+	if (rwnx_hw->roc_cookie_cnt =3D=3D 0)
+		rwnx_hw->roc_cookie_cnt =3D 1;
+
+	/* Free the allocated RoC element */
+	kfree(roc_elem);
+	rwnx_hw->roc_elem =3D NULL;
+
+#endif /* CONFIG_RWNX_FULLMAC */
+	return 0;
+}
+
+static inline int rwnx_rx_p2p_vif_ps_change_ind(struct rwnx_hw *rwnx_hw,
+						struct rwnx_cmd *cmd,
+						struct ipc_e2a_msg *msg)
+{
+	int vif_idx =3D ((struct mm_p2p_vif_ps_change_ind *)msg->param)->vif_inde=
x;
+	int ps_state =3D ((struct mm_p2p_vif_ps_change_ind *)msg->param)->ps_stat=
e;
+	struct rwnx_vif *vif_entry;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+#ifdef CONFIG_RWNX_FULLMAC
+	vif_entry =3D rwnx_hw->vif_table[vif_idx];
+
+	if (vif_entry)
+		goto found_vif;
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	goto exit;
+found_vif:
+
+#ifdef CONFIG_RWNX_FULLMAC
+	if (ps_state =3D=3D MM_PS_MODE_OFF) {
+		// Start TX queues for provided VIF
+		rwnx_txq_vif_start(vif_entry, RWNX_TXQ_STOP_VIF_PS, rwnx_hw);
+	} else {
+		// Stop TX queues for provided VIF
+		rwnx_txq_vif_stop(vif_entry, RWNX_TXQ_STOP_VIF_PS, rwnx_hw);
+	}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+exit:
+	return 0;
+}
+
+static inline int rwnx_rx_channel_survey_ind(struct rwnx_hw *rwnx_hw,
+					     struct rwnx_cmd *cmd,
+					     struct ipc_e2a_msg *msg)
+{
+	struct mm_channel_survey_ind *ind =3D
+		(struct mm_channel_survey_ind *)msg->param;
+	// Get the channel index
+	int idx =3D rwnx_freq_to_idx(rwnx_hw, ind->freq);
+	// Get the survey
+	struct rwnx_survey_info *rwnx_survey;
+
+	if (idx > ARRAY_SIZE(rwnx_hw->survey))
+		return 0;
+
+	rwnx_survey =3D &rwnx_hw->survey[idx];
+
+	// Store the received parameters
+	rwnx_survey->chan_time_ms =3D ind->chan_time_ms;
+	rwnx_survey->chan_time_busy_ms =3D ind->chan_time_busy_ms;
+	rwnx_survey->noise_dbm =3D ind->noise_dbm;
+	rwnx_survey->filled =3D (SURVEY_INFO_TIME | SURVEY_INFO_TIME_BUSY);
+
+	if (ind->noise_dbm !=3D 0)
+		rwnx_survey->filled |=3D SURVEY_INFO_NOISE_DBM;
+
+	return 0;
+}
+
+static inline int rwnx_rx_p2p_noa_upd_ind(struct rwnx_hw *rwnx_hw,
+					  struct rwnx_cmd *cmd,
+					  struct ipc_e2a_msg *msg)
+{
+	return 0;
+}
+
+static inline int rwnx_rx_rssi_status_ind(struct rwnx_hw *rwnx_hw,
+					  struct rwnx_cmd *cmd,
+					  struct ipc_e2a_msg *msg)
+{
+	struct mm_rssi_status_ind *ind =3D (struct mm_rssi_status_ind *)msg->para=
m;
+	int vif_idx =3D ind->vif_index;
+	bool rssi_status =3D ind->rssi_status;
+
+	struct rwnx_vif *vif_entry;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+#ifdef CONFIG_RWNX_FULLMAC
+	vif_entry =3D rwnx_hw->vif_table[vif_idx];
+	if (vif_entry) {
+		cfg80211_cqm_rssi_notify(vif_entry->ndev,
+					 rssi_status ? NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW
+					 : NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+					 ind->rssi, GFP_ATOMIC);
+	}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	return 0;
+}
+
+static inline int rwnx_rx_pktloss_notify_ind(struct rwnx_hw *rwnx_hw,
+					     struct rwnx_cmd *cmd,
+					     struct ipc_e2a_msg *msg)
+{
+#ifdef CONFIG_RWNX_FULLMAC
+	struct mm_pktloss_ind *ind =3D (struct mm_pktloss_ind *)msg->param;
+	struct rwnx_vif *vif_entry;
+	int vif_idx =3D ind->vif_index;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	vif_entry =3D rwnx_hw->vif_table[vif_idx];
+	if (vif_entry) {
+		cfg80211_cqm_pktloss_notify(vif_entry->ndev,
+					    (const u8 *)ind->mac_addr.array,
+					    ind->num_packets, GFP_ATOMIC);
+	}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	return 0;
+}
+
+static inline int rwnx_apm_staloss_ind(struct rwnx_hw *rwnx_hw,
+				       struct rwnx_cmd *cmd,
+				       struct ipc_e2a_msg *msg)
+{
+	struct mm_apm_staloss_ind *ind =3D (struct mm_apm_staloss_ind *)msg->para=
m;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	memcpy(rwnx_hw->sta_mac_addr, ind->mac_addr, 6);
+	rwnx_hw->apm_vif_idx =3D ind->vif_idx;
+
+	queue_work(rwnx_hw->apm_staloss_wq, &rwnx_hw->apm_staloss_work);
+
+	return 0;
+}
+
+static struct sk_buff *arp_80211_to_8023(struct sk_buff *skb, u8_l hdrlen)
+{
+	struct ethhdr *eth;
+	size_t payload_len;
+	struct sk_buff *new_skb =3D NULL;
+	char *llc;
+	u8 da[MAC_ADDR_LEN] =3D {0};
+	u8 sa[MAC_ADDR_LEN] =3D {0};
+
+	if (skb->len <=3D hdrlen) {
+		AICWFDBG(LOGERROR, "%s skb_len err1\n", __func__);
+		return NULL;
+	}
+
+	memcpy(da, &skb->data[4], 6);
+	memcpy(sa, &skb->data[16], 6);
+
+	skb_pull(skb, hdrlen);
+	llc =3D skb->data;
+	if (llc[0] =3D=3D 0xAA && llc[1] =3D=3D 0xAA && llc[2] =3D=3D 0x03) {
+		if (skb->len < 8) {
+			AICWFDBG(LOGERROR, "%s skb_len err2\n", __func__);
+			return NULL;
+		}
+		skb_pull(skb, 8);
+	}
+	payload_len =3D skb->len;
+
+	new_skb =3D __dev_alloc_skb(ETH_HLEN + payload_len, GFP_ATOMIC);
+	if (!new_skb) {
+		AICWFDBG(LOGERROR, "%s skb alloc fail\n", __func__);
+		return NULL;
+	}
+
+	skb_reserve(new_skb, ETH_HLEN);
+	skb_put(new_skb, payload_len);
+	memcpy(new_skb->data, skb->data, payload_len);
+
+	eth =3D (struct ethhdr *)skb_push(new_skb, ETH_HLEN);
+
+	memcpy(eth->h_dest, da, ETH_ALEN);
+	memcpy(eth->h_source, sa, ETH_ALEN);
+
+	eth->h_proto =3D htons(ETH_P_ARP);
+
+	new_skb->protocol =3D eth->h_proto;
+	new_skb->dev =3D skb->dev;
+
+	return new_skb;
+}
+
+static inline int rwnx_arp_announcement_ind(struct rwnx_hw *rwnx_hw,
+					    struct rwnx_cmd *cmd,
+					    struct ipc_e2a_msg *msg)
+{
+	struct rwnx_vif *vif;
+	struct sk_buff *skb =3D NULL;
+	struct sk_buff *new_skb =3D NULL;
+	struct hw_rxhdr rxhdr;
+	int hdrlen =3D 24;
+	struct rxu_arp_announcement_ind *ind =3D (struct rxu_arp_announcement_ind=
 *)msg->param;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	//AICWFDBG(LOGDEBUG, "vif: %d, length: %d, offset: %d\n",
+	// ind->vif_index, ind->length, ind->offset);
+
+	AICWFDBG(LOGDEBUG, "%s, vif: %d, length: %d, offset: %d\n",
+		 __func__, ind->vif_index, ind->length, ind->offset);
+
+	vif =3D rwnx_hw->vif_table[ind->vif_index];
+	rxhdr.flags_is_amsdu =3D false;
+	rxhdr.flags_dst_idx =3D 0xff;
+
+	if (ind->payload[0] & 0x80)
+		hdrlen +=3D 2;
+
+	switch ((ind->rx_status >> 2) & 0x7) {
+	case RWNX_RX_HD_DECR_CCMP128:
+		hdrlen +=3D 8;
+		break;
+	case RWNX_RX_HD_DECR_TKIP:
+		hdrlen +=3D 8;
+		break;
+	case RWNX_RX_HD_DECR_WEP:
+		hdrlen +=3D 4;
+		break;
+	case RWNX_RX_HD_DECR_WAPI:
+		hdrlen +=3D 18;
+		break;
+	default:
+		break;
+	}
+
+	skb =3D __dev_alloc_skb(ind->length, GFP_ATOMIC);
+	if (!skb) {
+		AICWFDBG(LOGERROR, "%s skb alloc fail\n", __func__);
+		return -1;
+	}
+	skb_put(skb, ind->length);
+	memcpy(skb->data, ind->payload, ind->length);
+	skb->dev =3D vif->ndev;
+
+	new_skb =3D arp_80211_to_8023(skb, hdrlen);
+	if (!new_skb) {
+		AICWFDBG(LOGERROR, "arp_80211_to_8023 fail\n");
+		dev_kfree_skb(skb);
+		return -1;
+	}
+	if (!rwnx_rx_data_skb(rwnx_hw, vif, new_skb, &rxhdr)) {
+		AICWFDBG(LOGERROR, "rwnx_rx_data_skb fail\n");
+		dev_kfree_skb(new_skb);
+		dev_kfree_skb(skb);
+		return -1;
+	}
+
+	dev_kfree_skb(skb);
+	return 0;
+}
+
+#ifdef CONFIG_SDIO_BT
+static inline int rwnx_bt_recv_ind(struct rwnx_hw *rwnx_hw,
+				   struct rwnx_cmd *cmd,
+				   struct ipc_e2a_msg *msg)
+{
+	struct mm_bt_recv_ind *ind =3D (struct mm_bt_recv_ind *)msg->param;
+
+	bt_sdio_recv(ind->bt_data, ind->data_len);
+	return 0;
+}
+#endif
+
+static inline int rwnx_rx_csa_counter_ind(struct rwnx_hw *rwnx_hw,
+					  struct rwnx_cmd *cmd,
+					  struct ipc_e2a_msg *msg)
+{
+	struct mm_csa_counter_ind *ind =3D (struct mm_csa_counter_ind *)msg->para=
m;
+	struct rwnx_vif *vif;
+	bool found =3D false;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	// Look for VIF entry
+	list_for_each_entry(vif, &rwnx_hw->vifs, list) {
+		if (vif->vif_index =3D=3D ind->vif_index) {
+			found =3D true;
+			break;
+		}
+	}
+
+	if (found) {
+#ifdef CONFIG_RWNX_FULLMAC
+		if (vif->ap.csa)
+			vif->ap.csa->count =3D ind->csa_count;
+		else
+			netdev_err(vif->ndev, "CSA counter update but no active CSA");
+
+#endif
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_RWNX_FULLMAC
+static inline int rwnx_rx_csa_finish_ind(struct rwnx_hw *rwnx_hw,
+					 struct rwnx_cmd *cmd,
+					 struct ipc_e2a_msg *msg)
+{
+	struct mm_csa_finish_ind *ind =3D (struct mm_csa_finish_ind *)msg->param;
+	struct rwnx_vif *vif;
+	bool found =3D false;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	// Look for VIF entry
+	list_for_each_entry(vif, &rwnx_hw->vifs, list) {
+		if (vif->vif_index =3D=3D ind->vif_index) {
+			found =3D true;
+			break;
+		}
+	}
+
+	if (found) {
+		if (RWNX_VIF_TYPE(vif) =3D=3D NL80211_IFTYPE_AP ||
+		    RWNX_VIF_TYPE(vif) =3D=3D NL80211_IFTYPE_P2P_GO) {
+			if (vif->ap.csa) {
+				vif->ap.csa->status =3D ind->status;
+				vif->ap.csa->ch_idx =3D ind->chan_idx;
+				schedule_work(&vif->ap.csa->work);
+			} else {
+				netdev_err(vif->ndev,
+					   "CSA finish indication but no active CSA");
+			}
+		} else {
+			if (ind->status =3D=3D 0) {
+				rwnx_chanctx_unlink(vif);
+				rwnx_chanctx_link(vif, ind->chan_idx, NULL);
+				if (rwnx_hw->cur_chanctx =3D=3D ind->chan_idx) {
+					rwnx_radar_detection_enable_on_cur_channel(rwnx_hw);
+					rwnx_txq_vif_start(vif, RWNX_TXQ_STOP_CHAN, rwnx_hw);
+				} else {
+					rwnx_txq_vif_stop(vif, RWNX_TXQ_STOP_CHAN, rwnx_hw);
+				}
+			}
+		}
+	}
+
+	return 0;
+}
+
+static inline int rwnx_rx_csa_traffic_ind(struct rwnx_hw *rwnx_hw,
+					  struct rwnx_cmd *cmd,
+					  struct ipc_e2a_msg *msg)
+{
+	struct mm_csa_traffic_ind *ind =3D (struct mm_csa_traffic_ind *)msg->para=
m;
+	struct rwnx_vif *vif;
+	bool found =3D false;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	// Look for VIF entry
+	list_for_each_entry(vif, &rwnx_hw->vifs, list) {
+		if (vif->vif_index =3D=3D ind->vif_index) {
+			found =3D true;
+			break;
+		}
+	}
+
+	if (found) {
+		if (ind->enable)
+			rwnx_txq_vif_start(vif, RWNX_TXQ_STOP_CSA, rwnx_hw);
+		else
+			rwnx_txq_vif_stop(vif, RWNX_TXQ_STOP_CSA, rwnx_hw);
+	}
+
+	return 0;
+}
+
+static inline int rwnx_rx_ps_change_ind(struct rwnx_hw *rwnx_hw,
+					struct rwnx_cmd *cmd,
+					struct ipc_e2a_msg *msg)
+{
+	struct mm_ps_change_ind *ind =3D (struct mm_ps_change_ind *)msg->param;
+	struct rwnx_sta *sta =3D &rwnx_hw->sta_table[ind->sta_idx];
+
+	if (ind->sta_idx >=3D (NX_REMOTE_STA_MAX + NX_VIRT_DEV_MAX)) {
+		wiphy_err(rwnx_hw->wiphy, "Invalid sta index reported by fw %d\n",
+			  ind->sta_idx);
+		return 1;
+	}
+
+	netdev_dbg(rwnx_hw->vif_table[sta->vif_idx]->ndev,
+		   "Sta %d, change PS mode to %s", sta->sta_idx,
+		   ind->ps_state ? "ON" : "OFF");
+
+	if (sta->valid) {
+		rwnx_ps_bh_enable(rwnx_hw, sta, ind->ps_state);
+	} else if (rwnx_hw->adding_sta) {
+		sta->ps.active =3D ind->ps_state ? true : false;
+	} else {
+		if (rwnx_hw->vif_table[sta->vif_idx] &&
+		    rwnx_hw->vif_table[sta->vif_idx]->ndev)
+			netdev_err(rwnx_hw->vif_table[sta->vif_idx]->ndev,
+				   "Ignore PS mode change on invalid sta\n");
+	}
+
+	return 0;
+}
+
+static inline int rwnx_rx_traffic_req_ind(struct rwnx_hw *rwnx_hw,
+					  struct rwnx_cmd *cmd,
+					  struct ipc_e2a_msg *msg)
+{
+	struct mm_traffic_req_ind *ind =3D (struct mm_traffic_req_ind *)msg->para=
m;
+	struct rwnx_sta *sta =3D &rwnx_hw->sta_table[ind->sta_idx];
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	netdev_dbg(rwnx_hw->vif_table[sta->vif_idx]->ndev,
+		   "Sta %d, asked for %d pkt", sta->sta_idx, ind->pkt_cnt);
+
+	rwnx_ps_bh_traffic_req(rwnx_hw, sta, ind->pkt_cnt,
+			       ind->uapsd ? UAPSD_ID : LEGACY_PS_ID);
+
+	return 0;
+}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+/*************************************************************************=
**
+ * Messages from SCANU task
+ *************************************************************************=
*/
+#ifdef CONFIG_RWNX_FULLMAC
+
+static inline int rwnx_rx_scanu_start_cfm(struct rwnx_hw *rwnx_hw,
+					  struct rwnx_cmd *cmd,
+					  struct ipc_e2a_msg *msg)
+{
+#ifdef CONFIG_AIC8800_AUTO_CUSTREG
+	struct ieee80211_regdomain *regdomain;
+#endif
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+#ifdef CONFIG_AIC8800_SCHED_SCAN
+#ifdef CONFIG_AIC8800_USE_WIRELESS_EXT
+	if (rwnx_hw->scan_request && !rwnx_hw->is_sched_scan && !rwnx_hw->wext_sc=
an)
+#else
+	if (rwnx_hw->scan_request && !rwnx_hw->is_sched_scan)
+#endif
+#endif // CONFIG_AIC8800_SCHED_SCAN
+	{
+		struct cfg80211_scan_info info =3D {
+			.aborted =3D false,
+		};
+
+		cfg80211_scan_done(rwnx_hw->scan_request, &info);
+	}
+#ifdef CONFIG_AIC8800_USE_WIRELESS_EXT
+	else if (rwnx_hw->wext_scan) {
+		rwnx_hw->wext_scan =3D 0;
+		AICWFDBG(LOGDEBUG, "%s rwnx_hw->wext_scan done!!\r\n", __func__);
+		kfree(rwnx_hw->scan_request->ssids);
+		if (rwnx_hw->scan_request)
+			vfree(rwnx_hw->scan_request);
+		complete(&rwnx_hw->wext_scan_com);
+	}
+#endif
+
+#ifdef CONFIG_AIC8800_SCHED_SCAN
+	if (rwnx_hw->is_sched_scan) {
+		AICWFDBG(LOGINFO, "%s cfg80211_sched_scan_results \r\n", __func__);
+		cfg80211_sched_scan_results(rwnx_hw->scan_request->wiphy,
+					    rwnx_hw->sched_scan_req->reqid);
+		kfree(rwnx_hw->scan_request);
+		rwnx_hw->is_sched_scan =3D false;
+	}
+#endif // CONFIG_AIC8800_SCHED_SCAN
+
+#ifdef CONFIG_AIC8800_AUTO_CUSTREG
+	if (rwnx_hw->ccode.auto_set && rwnx_hw->ccode.ccode_find) {
+#ifdef CONFIG_AIC8800_REGION_PW
+		schedule_work(&rwnx_hw->region_wk);
+#endif
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+		if (!work_pending(&rwnx_hw->pwlt_wk))
+			schedule_work(&rwnx_hw->pwlt_wk);
+#endif
+		regdomain =3D get_regdomain_from_rwnx_db(rwnx_hw->wiphy, rwnx_hw->countr=
y_abbr);
+		regulatory_set_wiphy_regd(rwnx_hw->wiphy, regdomain);
+		rwnx_hw->ccode.ccode_cnt =3D 0;
+		rwnx_hw->ccode.ccode_find =3D false;
+		rwnx_hw->ccode.ccode_set =3D true;
+	}
+#endif
+
+	rwnx_hw->scan_request =3D NULL;
+	rwnx_hw->scanning =3D 0;
+	rwnx_wakeup_unlock(rwnx_hw->ws_scan);
+
+	return 0;
+}
+
+static void parse_ssid_from_id(const u8 *ssid_id, char ssid_name[33], u8 *=
ssid_len)
+{
+	u8 len;
+
+	if (!ssid_id)
+		return;
+
+	len =3D *(ssid_id + 1);
+	if (len > 32)
+		len =3D 32;
+
+	strscpy(ssid_name, ssid_id + 2, len);
+	ssid_name[len] =3D '\0';
+	*ssid_len =3D len;
+
+	if (len > 0)
+		AICWFDBG(LOGDEBUG, "find_ccode ssid: %s\n", ssid_name);
+	else
+		AICWFDBG(LOGDEBUG, "find_ccode ssid is null\n");
+}
+
+static void rwnx_update_country(struct rwnx_hw *rwnx_hw,
+				const u8 *country_id,
+				struct ieee80211_regdomain **regdomain)
+{
+	if (!country_id)
+		return;
+
+	if (memcmp(rwnx_hw->country_abbr, country_id + 2, 2) !=3D 0) {
+		AICWFDBG(LOGINFO, "update ccode of the connected ap\n");
+
+		strscpy(rwnx_hw->country_abbr, country_id + 2, 2);
+
+		*regdomain =3D get_regdomain_from_rwnx_db(rwnx_hw->wiphy, rwnx_hw->count=
ry_abbr);
+
+#ifdef CONFIG_AIC8800_REGION_PW
+		schedule_work(&rwnx_hw->region_wk);
+#endif
+
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+		if (!work_pending(&rwnx_hw->pwlt_wk))
+			schedule_work(&rwnx_hw->pwlt_wk);
+#endif
+
+		regulatory_set_wiphy_regd(rwnx_hw->wiphy, *regdomain);
+	}
+}
+
+static inline int rwnx_rx_scanu_result_ind(struct rwnx_hw *rwnx_hw,
+					   struct rwnx_cmd *cmd,
+					   struct ipc_e2a_msg *msg)
+{
+	struct cfg80211_bss *bss =3D NULL;
+	struct ieee80211_channel *chan;
+	struct scanu_result_ind *ind =3D (struct scanu_result_ind *)msg->param;
+	struct ieee80211_mgmt *mgmt =3D (struct ieee80211_mgmt *)ind->payload;
+	u64 tsf;
+
+#ifdef CONFIG_AIC8800_AUTO_CUSTREG
+	const u8 *country_id;
+	const u8 *ssid_id;
+	char ssid_name[33];
+	u8_l ssid_len;
+	struct ieee80211_regdomain *regdomain;
+#endif
+
+#ifdef CONFIG_AIC8800_USE_WIRELESS_EXT
+	struct scanu_result_wext *scan_re_wext;
+#endif
+
+	// RWNX_DBG(RWNX_FN_ENTRY_STR); //debug trace
+
+	chan =3D ieee80211_get_channel(rwnx_hw->wiphy, ind->center_freq);
+
+	if (chan) {
+		struct timespec64 ts;
+
+		ts =3D ktime_to_timespec64(ktime_get_boottime());
+		tsf =3D (u64)ts.tv_sec * 1000000 + div_u64(ts.tv_nsec, 1000);
+		mgmt->u.probe_resp.timestamp =3D tsf;
+
+#ifdef CONFIG_AIC8800_AUTO_CUSTREG
+		if (rwnx_hw->ccode.auto_set && !rwnx_hw->ccode.ccode_set &&
+		    rwnx_hw->ccode.ccode_cnt < MAX_SEARCH_CNT) {
+			country_id =3D
+				cfg80211_find_ie(WLAN_EID_COUNTRY, mgmt->u.beacon.variable,
+						 ind->length - offsetof(struct ieee80211_mgmt,
+									u.beacon.variable));
+			if (country_id) {
+				if (ind->rssi > rwnx_hw->ccode.ccode_rssi) {
+					rwnx_hw->ccode.ccode_rssi =3D ind->rssi;
+					// AICWFDBG(LOGINFO, "find_ccode, bssid: %pM\n",
+					// mgmt->bssid); //debug trace
+					if (!rwnx_hw->ccode.ccode_find)
+						rwnx_hw->ccode.ccode_find =3D true;
+					strscpy(rwnx_hw->country_abbr, country_id + 2, 2);
+					ssid_id =3D
+					cfg80211_find_ie(WLAN_EID_SSID, mgmt->u.beacon.variable,
+							 ind->length -
+							 offsetof(struct ieee80211_mgmt,
+								  u.beacon.variable));
+					parse_ssid_from_id(ssid_id, ssid_name, &ssid_len);
+				}
+			}
+			rwnx_hw->ccode.ccode_cnt +=3D 1;
+			AICWFDBG(LOGDEBUG, "find cnt: %d\n",
+				 rwnx_hw->ccode.ccode_cnt); // debug trace
+		} else if (rwnx_hw->ccode.auto_set && !rwnx_hw->ccode.ccode_find &&
+			   !rwnx_hw->ccode.ccode_set &&
+			   rwnx_hw->ccode.ccode_cnt >=3D MAX_SEARCH_CNT) {
+			AICWFDBG(LOGINFO, "find cnt over !!!\n");
+			strscpy(rwnx_hw->country_abbr, "XX", 2);
+			rwnx_hw->ccode.ccode_find =3D true;
+		}
+
+		if (rwnx_hw->ccode.auto_set &&
+		    atomic_read(&rwnx_hw->ccode.link_scan) =3D=3D 1) {
+			if (memcmp(&rwnx_hw->ccode.bssid, mgmt->bssid, ETH_ALEN) =3D=3D 0) {
+				country_id =3D
+				cfg80211_find_ie(WLAN_EID_COUNTRY,
+						 mgmt->u.probe_resp.variable,
+						 ind->length - offsetof(struct ieee80211_mgmt,
+									u.probe_resp.variable));
+				rwnx_update_country(rwnx_hw, country_id, &regdomain);
+				memset(&rwnx_hw->ccode.bssid, 0, sizeof(rwnx_hw->ccode.bssid));
+			}
+			atomic_set(&rwnx_hw->ccode.link_scan, 0);
+			rwnx_hw->ccode.ccode_cnt =3D 0;
+		}
+#endif
+		bss =3D
+		cfg80211_inform_bss_frame(rwnx_hw->wiphy, chan,
+					  (struct ieee80211_mgmt *)ind->payload,
+					  ind->length, ind->rssi * 100, GFP_ATOMIC);
+
+#ifdef CONFIG_AIC8800_USE_WIRELESS_EXT
+		if (rwnx_hw->wext_scan) {
+			list_for_each_entry(scan_re_wext,
+					    &rwnx_hw->wext_scanre_list, scanu_re_list) {
+				if (!memcmp(scan_re_wext->bss->bssid, bss->bssid, ETH_ALEN)) {
+					AICWFDBG(LOGDEBUG,
+						 "%s: BSSID already exists, no need to add again\r\n",
+						 __func__);
+					if (bss)
+						cfg80211_put_bss(rwnx_hw->wiphy, bss);
+					return 0;
+				}
+			}
+			scan_re_wext =3D
+				vmalloc(sizeof(struct scanu_result_wext));
+			scan_re_wext->ind =3D
+				vmalloc(sizeof(struct scanu_result_ind));
+
+			scan_re_wext->payload =3D vmalloc(sizeof(u32_l) * ind->length);
+
+			memset(scan_re_wext->ind, 0, sizeof(struct scanu_result_ind));
+			memset(scan_re_wext->payload, 0, ind->length);
+
+			memcpy(scan_re_wext->ind, ind, sizeof(struct scanu_result_ind));
+			memcpy(scan_re_wext->payload, ind->payload, ind->length);
+
+			scan_re_wext->bss =3D bss;
+
+			INIT_LIST_HEAD(&scan_re_wext->scanu_re_list);
+			list_add_tail(&scan_re_wext->scanu_re_list, &rwnx_hw->wext_scanre_list)=
;
+			return 0;
+		}
+#endif
+	}
+	if (bss)
+		cfg80211_put_bss(rwnx_hw->wiphy, bss);
+	return 0;
+}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+/*************************************************************************=
**
+ * Messages from ME task
+ *************************************************************************=
*/
+#ifdef CONFIG_RWNX_FULLMAC
+static inline int rwnx_rx_me_tkip_mic_failure_ind(struct rwnx_hw *rwnx_hw,
+						  struct rwnx_cmd *cmd,
+						  struct ipc_e2a_msg *msg)
+{
+	struct me_tkip_mic_failure_ind *ind =3D
+		(struct me_tkip_mic_failure_ind *)msg->param;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[ind->vif_idx];
+	struct net_device *dev =3D rwnx_vif->ndev;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	cfg80211_michael_mic_failure(dev, (u8 *)&ind->addr,
+				     (ind->ga ? NL80211_KEYTYPE_GROUP : NL80211_KEYTYPE_PAIRWISE),
+				     ind->keyid, (u8 *)&ind->tsc, GFP_ATOMIC);
+
+	return 0;
+}
+
+static inline int rwnx_rx_me_tx_credits_update_ind(struct rwnx_hw *rwnx_hw=
,
+						   struct rwnx_cmd *cmd,
+						   struct ipc_e2a_msg *msg)
+{
+	struct me_tx_credits_update_ind *ind =3D
+		(struct me_tx_credits_update_ind *)msg->param;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	rwnx_txq_credit_update(rwnx_hw, ind->sta_idx, ind->tid, ind->credits);
+
+	return 0;
+}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+/*************************************************************************=
**
+ * Messages from SM task
+ *************************************************************************=
*/
+#ifdef CONFIG_RWNX_FULLMAC
+static inline int rwnx_rx_sm_connect_ind(struct rwnx_hw *rwnx_hw,
+					 struct rwnx_cmd *cmd,
+					 struct ipc_e2a_msg *msg)
+{
+	struct sm_connect_ind *ind =3D (struct sm_connect_ind *)msg->param;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[ind->vif_idx];
+	struct net_device *dev =3D rwnx_vif->ndev;
+	const u8 *req_ie, *rsp_ie;
+	const u8 *extcap_ie;
+	const struct ieee_types_extcap *extcap;
+	struct ieee80211_channel *chan;
+	const u8 *ht_ie =3D NULL;
+	const u8 *vht_ie =3D NULL;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Retrieve IE addresses and lengths */
+	req_ie =3D (const u8 *)ind->assoc_ie_buf;
+	rsp_ie =3D req_ie + ind->assoc_req_ie_len;
+
+	// Fill-in the AP information
+	AICWFDBG(LOGINFO, "%s ind->status_code:%d \r\n", __func__,
+		 ind->status_code);
+
+	if (ind->status_code =3D=3D 0) {
+		struct rwnx_sta *sta =3D &rwnx_hw->sta_table[ind->ap_idx];
+		u8 txq_status;
+		struct cfg80211_chan_def chandef;
+
+		sta->valid =3D true;
+		sta->sta_idx =3D ind->ap_idx;
+		sta->ch_idx =3D ind->ch_idx;
+		sta->vif_idx =3D ind->vif_idx;
+		sta->vlan_idx =3D sta->vif_idx;
+		sta->qos =3D ind->qos;
+		sta->acm =3D ind->acm;
+		sta->ps.active =3D false;
+		sta->aid =3D ind->aid;
+		sta->band =3D ind->band;                 // ind->chan.band;
+		sta->width =3D ind->width;               // ind->chan.type;
+		sta->center_freq =3D ind->center_freq;   // ind->chan.prim20_freq;
+		sta->center_freq1 =3D ind->center_freq1; // ind->chan.center1_freq;
+		sta->center_freq2 =3D ind->center_freq2; // ind->chan.center2_freq;
+		rwnx_vif->sta.ap =3D sta;
+		// ind->chan.prim20_freq);
+		chan =3D ieee80211_get_channel(rwnx_hw->wiphy, ind->center_freq);
+		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+		if (!rwnx_hw->mod_params->ht_on)
+			chandef.width =3D NL80211_CHAN_WIDTH_20_NOHT;
+		else
+			chandef.width =3D chnl2bw[ind->width];  //[ind->chan.type];
+		chandef.center_freq1 =3D ind->center_freq1; // ind->chan.center1_freq;
+		chandef.center_freq2 =3D ind->center_freq2; // ind->chan.center2_freq;
+		rwnx_chanctx_link(rwnx_vif, ind->ch_idx, &chandef);
+		memcpy(sta->mac_addr, ind->bssid.array, ETH_ALEN);
+		if (ind->ch_idx =3D=3D rwnx_hw->cur_chanctx)
+			txq_status =3D 0;
+		else
+			txq_status =3D RWNX_TXQ_STOP_CHAN;
+		memcpy(sta->ac_param, ind->ac_param, sizeof(sta->ac_param));
+		rwnx_txq_sta_init(rwnx_hw, sta, txq_status);
+		rwnx_txq_tdls_vif_init(rwnx_vif);
+#ifdef CONFIG_RWNX_DEBUGFS
+		rwnx_dbgfs_register_rc_stat(rwnx_hw, sta);
+#endif
+		rwnx_mu_group_sta_init(sta, NULL);
+		/* Look for TDLS Channel Switch Prohibited flag in the Extended
+		 * Capability Information Element
+		 */
+		extcap_ie =3D cfg80211_find_ie(WLAN_EID_EXT_CAPABILITY, rsp_ie,
+					     ind->assoc_rsp_ie_len);
+		if (extcap_ie && extcap_ie[1] >=3D 5) {
+			extcap =3D (void *)(extcap_ie);
+			rwnx_vif->tdls_chsw_prohibited =3D
+				extcap->ext_capab[4] & WLAN_EXT_CAPA5_TDLS_CH_SW_PROHIBITED;
+		}
+
+		if (rwnx_vif->wep_enabled)
+			rwnx_vif->wep_auth_err =3D false;
+
+#ifdef CONFIG_RWNX_BFMER
+		/* If Beamformer feature is activated, check if features can be used
+		 * with the new peer device
+		 */
+		if (rwnx_hw->mod_params->bfmer) {
+			const u8 *vht_capa_ie;
+			const struct ieee80211_vht_cap *vht_cap;
+
+			do {
+				/* Look for VHT Capability Information Element */
+				vht_capa_ie =3D cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY, rsp_ie,
+							       ind->assoc_rsp_ie_len);
+
+				/* Stop here if peer device does not support VHT */
+				if (!vht_capa_ie)
+					break;
+
+				vht_cap =3D (const struct ieee80211_vht_cap *)(vht_capa_ie + 2);
+
+				/* Send MM_BFMER_ENABLE_REQ message if needed */
+				rwnx_send_bfmer_enable(rwnx_hw, sta, vht_cap);
+			} while (0);
+		}
+#endif //(CONFIG_RWNX_BFMER)
+
+		ht_ie =3D cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, rsp_ie,
+					 ind->assoc_rsp_ie_len);
+		if (ht_ie)
+			rwnx_vif->sta.ap->ht =3D true;
+		vht_ie =3D cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY, rsp_ie,
+					  ind->assoc_rsp_ie_len);
+		if (vht_ie)
+			rwnx_vif->sta.ap->vht =3D true;
+
+#ifdef CONFIG_RWNX_MON_DATA
+		// If there are 1 sta and 1 monitor interface active at the same time
+		// then monitor interface channel context is always the same as the STA
+		// interface. This doesn't work with 2 STA interfaces but we don't want
+		// to support it.
+		if (rwnx_hw->monitor_vif !=3D RWNX_INVALID_VIF) {
+			struct rwnx_vif *rwnx_mon_vif =3D
+				rwnx_hw->vif_table[rwnx_hw->monitor_vif];
+			rwnx_chanctx_unlink(rwnx_mon_vif);
+			rwnx_chanctx_link(rwnx_mon_vif, ind->ch_idx, NULL);
+		}
+#endif
+		// atomic_set(&rwnx_vif->drv_conn_state,
+		// (int)RWNX_DRV_STATUS_CONNECTED);
+	} else if (ind->status_code =3D=3D WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG) {
+		if (rwnx_vif->wep_enabled) {
+			rwnx_vif->wep_auth_err =3D true;
+			AICWFDBG(LOGINFO, "con ind wep_auth_err %d\n",
+				 rwnx_vif->wep_auth_err);
+		}
+		rwnx_set_conn_state(&rwnx_vif->drv_conn_state, (int)RWNX_DRV_STATUS_DISC=
ONNECTED);
+	} else {
+		rwnx_set_conn_state(&rwnx_vif->drv_conn_state, (int)RWNX_DRV_STATUS_DISC=
ONNECTED);
+	}
+
+	AICWFDBG(LOGINFO,
+		 "%s ind->roamed:%d ind->status_code:%d rwnx_vif->drv_conn_state:%d\r\n"=
,
+		 __func__, ind->roamed, ind->status_code,
+		 (int)atomic_read(&rwnx_vif->drv_conn_state));
+
+	if (ind->status_code =3D=3D 0 &&
+	    (int)atomic_read(&rwnx_vif->drv_conn_state) =3D=3D RWNX_DRV_STATUS_DI=
SCONNECTING) {
+		AICWFDBG(LOGINFO, "%s the disconnection has been requested, return it\r\=
n",
+			 __func__);
+		goto exit;
+	}
+
+	if (!ind->roamed) { // not roaming
+		cfg80211_connect_result(dev, (const u8 *)ind->bssid.array,
+					req_ie, ind->assoc_req_ie_len,
+					rsp_ie, ind->assoc_rsp_ie_len, ind->status_code,
+					GFP_ATOMIC);
+		if (ind->status_code =3D=3D 0) {
+			rwnx_set_conn_state(&rwnx_vif->drv_conn_state,
+					    (int)RWNX_DRV_STATUS_CONNECTED);
+			AICWFDBG(LOGINFO,
+				 "%s cfg80211_connect_result pass, rwnx_vif->drv_conn_state:%d\r\n",
+				 __func__, (int)atomic_read(&rwnx_vif->drv_conn_state));
+			rwnx_vif->sta.link_time =3D jiffies;
+		} else {
+			rwnx_set_conn_state(&rwnx_vif->drv_conn_state,
+					    (int)RWNX_DRV_STATUS_DISCONNECTED);
+			rwnx_external_auth_disable(rwnx_vif);
+		}
+	} else { // roaming
+		if (ind->status_code !=3D 0) {
+			AICWFDBG(LOGINFO, "%s roaming fail to notify disconnect \r\n",
+				 __func__);
+			cfg80211_disconnected(dev, 0, NULL, 0, 1, GFP_ATOMIC);
+			rwnx_set_conn_state(&rwnx_vif->drv_conn_state,
+					    (int)RWNX_DRV_STATUS_DISCONNECTED);
+			rwnx_external_auth_disable(rwnx_vif);
+		} else {
+			struct cfg80211_roam_info info;
+
+			memset(&info, 0, sizeof(info));
+			if (rwnx_vif->ch_index < NX_CHAN_CTXT_CNT)
+				info.links[0].channel =3D
+					rwnx_hw->chanctx_table[rwnx_vif->ch_index].chan_def.chan;
+			info.links[0].bssid =3D (const u8 *)ind->bssid.array;
+			info.req_ie =3D req_ie;
+			info.req_ie_len =3D ind->assoc_req_ie_len;
+			info.resp_ie =3D rsp_ie;
+			info.resp_ie_len =3D ind->assoc_rsp_ie_len;
+			cfg80211_roamed(dev, &info, GFP_ATOMIC);
+			rwnx_vif->sta.link_time =3D jiffies;
+
+			rwnx_set_conn_state(&rwnx_vif->drv_conn_state,
+					    (int)RWNX_DRV_STATUS_CONNECTED);
+			rwnx_vif->sta.link_time =3D jiffies;
+		}
+		rwnx_vif->sta.is_roam =3D false;
+	}
+
+	if (ind->status_code =3D=3D 0) {
+		netif_tx_start_all_queues(dev);
+		netif_carrier_on(dev);
+	}
+
+exit:
+	rwnx_vif->sta.is_roam =3D false;
+	return 0;
+}
+
+void rwnx_cfg80211_unlink_bss(struct rwnx_hw *rwnx_hw,
+			      struct rwnx_vif *rwnx_vif)
+{
+	struct wiphy *wiphy =3D rwnx_hw->wiphy;
+	struct cfg80211_bss *bss =3D NULL;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	bss =3D cfg80211_get_bss(wiphy, NULL /*notify_channel */, rwnx_vif->sta.b=
ssid,
+			       rwnx_vif->sta.ssid, rwnx_vif->sta.ssid_len,
+			       IEEE80211_BSS_TYPE_ESS,
+			       IEEE80211_PRIVACY(true)); // temp set true
+	if (bss) {
+		cfg80211_unlink_bss(wiphy, bss);
+		AICWFDBG(LOGINFO, "%s(): cfg80211_unlink %s!!\n", __func__,
+			 rwnx_vif->sta.ssid);
+		cfg80211_put_bss(wiphy, bss);
+	} else {
+		AICWFDBG(LOGINFO, "%s(): cfg80211_unlink error %s!!\n", __func__,
+			 rwnx_vif->sta.ssid);
+	}
+}
+
+static inline int rwnx_rx_sm_disconnect_ind(struct rwnx_hw *rwnx_hw,
+					    struct rwnx_cmd *cmd,
+					    struct ipc_e2a_msg *msg)
+{
+	struct sm_disconnect_ind *ind =3D (struct sm_disconnect_ind *)msg->param;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[ind->vif_idx];
+	struct net_device *dev;
+#ifdef AICWF_RX_REORDER
+	struct reord_ctrl_info *reord_info, *tmp;
+	u8 *macaddr;
+	struct aicwf_rx_priv *rx_priv;
+#endif
+
+	AICWFDBG(LOGINFO, "%s reason code:%d \r\n", __func__, ind->reason_code);
+
+	if (!rwnx_vif)
+		return 0;
+
+	if ((int)atomic_read(&rwnx_vif->drv_conn_state) =3D=3D
+		(int)RWNX_DRV_STATUS_DISCONNECTED) {
+		AICWFDBG(LOGINFO, "%s, is already disconnected, drop disconnect ind",
+			 __func__);
+		return 0;
+	}
+
+	dev =3D rwnx_vif->ndev;
+
+	if (!rwnx_vif->sta.is_roam)
+		rwnx_cfg80211_unlink_bss(rwnx_hw, rwnx_vif);
+	else
+		AICWFDBG(LOGINFO, "%s roaming no rwnx_cfg80211_unlink_bss \r\n",
+			 __func__);
+
+#ifdef CONFIG_RWNX_DEBUGFS
+	rwnx_dbgfs_unregister_rc_stat(rwnx_hw, rwnx_vif->sta.ap);
+#endif
+
+#ifdef CONFIG_AIC8800_BR_SUPPORT
+	/* clear bridge database */
+	nat25_db_cleanup(rwnx_vif);
+#endif /* CONFIG_AIC8800_BR_SUPPORT */
+
+	if (rwnx_vif->wdev.iftype =3D=3D NL80211_IFTYPE_P2P_CLIENT)
+		rwnx_hw->is_p2p_connected =3D 0;
+	/* if vif is not up, rwnx_close has already been called */
+	if (rwnx_vif->up) {
+		if (!ind->ft_over_ds && !ind->reassoc) {
+			cfg80211_disconnected(dev, ind->reason_code, NULL, 0,
+					      (ind->reason_code < 1), GFP_ATOMIC);
+		}
+		netif_tx_stop_all_queues(dev);
+		netif_carrier_off(dev);
+	}
+
+#ifdef CONFIG_RWNX_BFMER
+	/* Disable Beamformer if supported */
+	rwnx_bfmer_report_del(rwnx_hw, rwnx_vif->sta.ap);
+#endif //(CONFIG_RWNX_BFMER)
+
+#ifdef AICWF_RX_REORDER
+#ifdef AICWF_SDIO_SUPPORT
+	rx_priv =3D rwnx_hw->sdiodev->rx_priv;
+#else
+	rx_priv =3D rwnx_hw->usbdev->rx_priv;
+#endif
+	if (rwnx_vif->wdev.iftype =3D=3D NL80211_IFTYPE_STATION ||
+	    rwnx_vif->wdev.iftype =3D=3D NL80211_IFTYPE_P2P_CLIENT) {
+		macaddr =3D (u8 *)rwnx_vif->ndev->dev_addr;
+		AICWFDBG(LOGDEBUG, "deinit:macaddr:%x,%x,%x,%x,%x,%x\r\n", macaddr[0], m=
acaddr[1],
+			 macaddr[2], macaddr[3], macaddr[4], macaddr[5]);
+
+		// spin_lock_bh(&rx_priv->stas_reord_lock);
+		list_for_each_entry_safe(reord_info, tmp, &rx_priv->stas_reord_list,
+					 list) {
+			macaddr =3D (u8 *)rwnx_vif->ndev->dev_addr;
+			AICWFDBG(LOGDEBUG, "reord_mac:%x,%x,%x,%x,%x,%x\r\n",
+				 reord_info->mac_addr[0], reord_info->mac_addr[1],
+				 reord_info->mac_addr[2], reord_info->mac_addr[3],
+				 reord_info->mac_addr[4], reord_info->mac_addr[5]);
+			if (!memcmp(reord_info->mac_addr, macaddr, 6)) {
+				reord_deinit_sta(rx_priv, reord_info);
+				break;
+			}
+		}
+		// spin_unlock_bh(&rx_priv->stas_reord_lock);
+	} else if (rwnx_vif->wdev.iftype =3D=3D NL80211_IFTYPE_AP ||
+		   rwnx_vif->wdev.iftype =3D=3D NL80211_IFTYPE_P2P_GO) {
+		// WARN_ON_ONCE(); // should be not here: del_sta function
+	}
+#endif
+
+	rwnx_txq_sta_deinit(rwnx_hw, rwnx_vif->sta.ap);
+	rwnx_txq_tdls_vif_deinit(rwnx_vif);
+	rwnx_vif->sta.ap->valid =3D false;
+	rwnx_vif->sta.ap =3D NULL;
+	rwnx_external_auth_disable(rwnx_vif);
+	rwnx_chanctx_unlink(rwnx_vif);
+
+	// msleep(200);
+	if (!rwnx_vif->sta.is_roam)
+		rwnx_set_conn_state(&rwnx_vif->drv_conn_state, (int)RWNX_DRV_STATUS_DISC=
ONNECTED);
+
+	return 0;
+}
+
+static inline int rwnx_rx_sm_external_auth_required_ind(struct rwnx_hw *rw=
nx_hw,
+							struct rwnx_cmd *cmd,
+							struct ipc_e2a_msg *msg)
+{
+	struct sm_external_auth_required_ind *ind =3D
+		(struct sm_external_auth_required_ind *)msg->param;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[ind->vif_idx];
+	struct net_device *dev =3D rwnx_vif->ndev;
+	struct cfg80211_external_auth_params params;
+	int ret =3D 0;
+	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
+	int retry_counter =3D 10;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	params.action =3D NL80211_EXTERNAL_AUTH_START;
+	memcpy(params.bssid, ind->bssid.array, ETH_ALEN);
+	params.ssid.ssid_len =3D ind->ssid.length;
+	memcpy(params.ssid.ssid, ind->ssid.array,
+	       min_t(size_t, ind->ssid.length, sizeof(params.ssid.ssid)));
+	params.key_mgmt_suite =3D ind->akm;
+
+	while (wdev->conn_owner_nlportid =3D=3D 0) {
+		AICWFDBG(LOGINFO,
+			 "%s WARNING conn_owner_nlportid =3D 0, msleep 100ms.\r\n",
+			 __func__);
+		msleep(100);
+		retry_counter--;
+		if (retry_counter =3D=3D 0)
+			break;
+	}
+	AICWFDBG(LOGINFO, "%s wdev->conn_owner_nlportid:%d \r\n", __func__,
+		 (int)wdev->conn_owner_nlportid);
+	ret =3D cfg80211_external_auth_request(dev, &params, GFP_ATOMIC);
+	if (ind->vif_idx > NX_VIRT_DEV_MAX || !rwnx_vif->up ||
+	    RWNX_VIF_TYPE(rwnx_vif) !=3D NL80211_IFTYPE_STATION ||
+	    ret) {
+		wiphy_err(rwnx_hw->wiphy,
+			  "Failed to start external auth on vif %d, rwnx_vif->up %d, iftype:%d,=
 ret %d",
+			  ind->vif_idx, rwnx_vif->up, RWNX_VIF_TYPE(rwnx_vif), ret);
+		rwnx_send_sm_external_auth_required_rsp(rwnx_hw, rwnx_vif,
+							WLAN_STATUS_UNSPECIFIED_FAILURE);
+		return 0;
+	}
+
+	rwnx_external_auth_enable(rwnx_vif);
+	return 0;
+}
+
+static inline int rwnx_rx_mesh_path_create_cfm(struct rwnx_hw *rwnx_hw,
+					       struct rwnx_cmd *cmd,
+					       struct ipc_e2a_msg *msg)
+{
+	struct mesh_path_create_cfm *cfm =3D
+		(struct mesh_path_create_cfm *)msg->param;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[cfm->vif_idx];
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Check we well have a Mesh Point Interface */
+	if (rwnx_vif && RWNX_VIF_TYPE(rwnx_vif) =3D=3D NL80211_IFTYPE_MESH_POINT)
+		rwnx_vif->ap.create_path =3D false;
+
+	return 0;
+}
+
+static inline int rwnx_rx_mesh_peer_update_ind(struct rwnx_hw *rwnx_hw,
+					       struct rwnx_cmd *cmd,
+					       struct ipc_e2a_msg *msg)
+{
+	struct mesh_peer_update_ind *ind =3D
+		(struct mesh_peer_update_ind *)msg->param;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[ind->vif_idx];
+	struct rwnx_sta *rwnx_sta =3D &rwnx_hw->sta_table[ind->sta_idx];
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	if (ind->vif_idx >=3D (NX_VIRT_DEV_MAX + NX_REMOTE_STA_MAX) ||
+	    (rwnx_vif && RWNX_VIF_TYPE(rwnx_vif) !=3D NL80211_IFTYPE_MESH_POINT) =
||
+	    ind->sta_idx >=3D NX_REMOTE_STA_MAX)
+		return 1;
+
+	/* Check we well have a Mesh Point Interface */
+	if (!rwnx_vif->user_mpm) {
+		/* Check if peer link has been established or lost */
+		if (ind->estab) {
+			if (!rwnx_sta->valid) {
+				u8 txq_status;
+
+				rwnx_sta->valid =3D true;
+				rwnx_sta->sta_idx =3D ind->sta_idx;
+				rwnx_sta->ch_idx =3D rwnx_vif->ch_index;
+				rwnx_sta->vif_idx =3D ind->vif_idx;
+				rwnx_sta->vlan_idx =3D rwnx_sta->vif_idx;
+				rwnx_sta->ps.active =3D false;
+				rwnx_sta->qos =3D true;
+				rwnx_sta->aid =3D ind->sta_idx + 1;
+				// rwnx_sta->acm =3D ind->acm;
+				memcpy(rwnx_sta->mac_addr, ind->peer_addr.array, ETH_ALEN);
+
+				rwnx_chanctx_link(rwnx_vif, rwnx_sta->ch_idx, NULL);
+
+				/* Add the station in the list of VIF's stations */
+				INIT_LIST_HEAD(&rwnx_sta->list);
+				list_add_tail(&rwnx_sta->list, &rwnx_vif->ap.sta_list);
+
+				/* Initialize the TX queues */
+				if (rwnx_sta->ch_idx =3D=3D rwnx_hw->cur_chanctx)
+					txq_status =3D 0;
+				else
+					txq_status =3D RWNX_TXQ_STOP_CHAN;
+
+				rwnx_txq_sta_init(rwnx_hw, rwnx_sta, txq_status);
+#ifdef CONFIG_RWNX_DEBUGFS
+				rwnx_dbgfs_register_rc_stat(rwnx_hw, rwnx_sta);
+#endif
+#ifdef CONFIG_RWNX_BFMER
+				// TODO: update indication to contains vht capabilities
+				if (rwnx_hw->mod_params->bfmer)
+					rwnx_send_bfmer_enable(rwnx_hw, rwnx_sta, NULL);
+
+				rwnx_mu_group_sta_init(rwnx_sta, NULL);
+#endif /* CONFIG_RWNX_BFMER */
+
+			} else {
+				WARN_ON(0);
+			}
+		} else {
+			if (rwnx_sta->valid) {
+				rwnx_sta->ps.active =3D false;
+				rwnx_sta->valid =3D false;
+
+				/* Remove the station from the list of VIF's station */
+				list_del_init(&rwnx_sta->list);
+
+				rwnx_txq_sta_deinit(rwnx_hw, rwnx_sta);
+#ifdef CONFIG_RWNX_DEBUGFS
+				rwnx_dbgfs_unregister_rc_stat(rwnx_hw, rwnx_sta);
+#endif
+			} else {
+				WARN_ON(0);
+			}
+		}
+	} else {
+		if (!ind->estab && rwnx_sta->valid) {
+			/* There is no way to inform upper layer for lost of peer, still
+			 * clean everything in the driver
+			 */
+			rwnx_sta->ps.active =3D false;
+			rwnx_sta->valid =3D false;
+
+			/* Remove the station from the list of VIF's station */
+			list_del_init(&rwnx_sta->list);
+
+			rwnx_txq_sta_deinit(rwnx_hw, rwnx_sta);
+#ifdef CONFIG_RWNX_DEBUGFS
+			rwnx_dbgfs_unregister_rc_stat(rwnx_hw, rwnx_sta);
+#endif
+		} else {
+			WARN_ON(0);
+		}
+	}
+
+	return 0;
+}
+
+static inline int rwnx_rx_mesh_path_update_ind(struct rwnx_hw *rwnx_hw,
+					       struct rwnx_cmd *cmd,
+					       struct ipc_e2a_msg *msg)
+{
+	struct mesh_path_update_ind *ind =3D
+		(struct mesh_path_update_ind *)msg->param;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[ind->vif_idx];
+	struct rwnx_mesh_path *mesh_path;
+	bool found =3D false;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	if (ind->vif_idx >=3D (NX_VIRT_DEV_MAX + NX_REMOTE_STA_MAX))
+		return 1;
+
+	if (!rwnx_vif || (RWNX_VIF_TYPE(rwnx_vif) !=3D NL80211_IFTYPE_MESH_POINT)=
)
+		return 0;
+
+	/* Look for path with provided target address */
+	list_for_each_entry(mesh_path, &rwnx_vif->ap.mpath_list, list) {
+		if (mesh_path->path_idx =3D=3D ind->path_idx) {
+			found =3D true;
+			break;
+		}
+	}
+
+	/* Check if element has been deleted */
+	if (ind->delete) {
+		if (found) {
+#ifdef AIC8800_CREATE_TRACE_POINTS
+			trace_mesh_delete_path(mesh_path);
+#endif
+			/* Remove element from list */
+			list_del_init(&mesh_path->list);
+			/* Free the element */
+			kfree(mesh_path);
+		}
+	} else {
+		if (found) {
+			// Update the Next Hop STA
+			mesh_path->p_nhop_sta =3D &rwnx_hw->sta_table[ind->nhop_sta_idx];
+#ifdef AIC8800_CREATE_TRACE_POINTS
+			trace_mesh_update_path(mesh_path);
+#endif
+		} else {
+			// Allocate a Mesh Path structure
+			mesh_path =3D
+				kmalloc_obj(struct rwnx_mesh_path, GFP_ATOMIC);
+
+			if (mesh_path) {
+				INIT_LIST_HEAD(&mesh_path->list);
+
+				mesh_path->path_idx =3D ind->path_idx;
+				mesh_path->p_nhop_sta =3D &rwnx_hw->sta_table[ind->nhop_sta_idx];
+				memcpy(&mesh_path->tgt_mac_addr, &ind->tgt_mac_addr,
+				       MAC_ADDR_LEN);
+
+				// Insert the path in the list of path
+				list_add_tail(&mesh_path->list, &rwnx_vif->ap.mpath_list);
+#ifdef AIC8800_CREATE_TRACE_POINTS
+				trace_mesh_create_path(mesh_path);
+#endif
+			}
+		}
+	}
+
+	return 0;
+}
+
+static inline int rwnx_rx_mesh_proxy_update_ind(struct rwnx_hw *rwnx_hw,
+						struct rwnx_cmd *cmd,
+						struct ipc_e2a_msg *msg)
+{
+	struct mesh_proxy_update_ind *ind =3D
+		(struct mesh_proxy_update_ind *)msg->param;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[ind->vif_idx];
+	struct rwnx_mesh_proxy *mesh_proxy;
+	bool found =3D false;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	if (ind->vif_idx >=3D (NX_VIRT_DEV_MAX + NX_REMOTE_STA_MAX))
+		return 1;
+
+	if (!rwnx_vif || RWNX_VIF_TYPE(rwnx_vif) !=3D NL80211_IFTYPE_MESH_POINT)
+		return 0;
+
+	/* Look for path with provided external STA address */
+	list_for_each_entry(mesh_proxy, &rwnx_vif->ap.proxy_list, list) {
+		if (!memcmp(&ind->ext_sta_addr, &mesh_proxy->ext_sta_addr, ETH_ALEN)) {
+			found =3D true;
+			break;
+		}
+	}
+
+	if (ind->delete && found) {
+		/* Delete mesh path */
+		list_del_init(&mesh_proxy->list);
+		kfree(mesh_proxy);
+	} else if (!ind->delete && !found) {
+		/* Allocate a Mesh Path structure */
+		mesh_proxy =3D
+			kmalloc_obj(*mesh_proxy, GFP_ATOMIC);
+
+		if (mesh_proxy) {
+			INIT_LIST_HEAD(&mesh_proxy->list);
+
+			memcpy(&mesh_proxy->ext_sta_addr, &ind->ext_sta_addr, MAC_ADDR_LEN);
+			mesh_proxy->local =3D ind->local;
+
+			if (!ind->local)
+				memcpy(&mesh_proxy->proxy_addr, &ind->proxy_mac_addr,
+				       MAC_ADDR_LEN);
+
+			/* Insert the path in the list of path */
+			list_add_tail(&mesh_proxy->list, &rwnx_vif->ap.proxy_list);
+		}
+	}
+
+	return 0;
+}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+/*************************************************************************=
**
+ * Messages from DEBUG task
+ *************************************************************************=
*/
+static inline int rwnx_rx_dbg_error_ind(struct rwnx_hw *rwnx_hw,
+					struct rwnx_cmd *cmd,
+					struct ipc_e2a_msg *msg)
+{
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	return 0;
+}
+
+#ifdef CONFIG_RWNX_FULLMAC
+
+static msg_cb_fct mm_hdlrs[MSG_I(MM_MAX)] =3D {
+	[MSG_I(MM_CHANNEL_SWITCH_IND)] =3D rwnx_rx_chan_switch_ind,
+	[MSG_I(MM_CHANNEL_PRE_SWITCH_IND)] =3D rwnx_rx_chan_pre_switch_ind,
+	[MSG_I(MM_REMAIN_ON_CHANNEL_EXP_IND)] =3D rwnx_rx_remain_on_channel_exp_i=
nd,
+	[MSG_I(MM_PS_CHANGE_IND)] =3D rwnx_rx_ps_change_ind,
+	[MSG_I(MM_TRAFFIC_REQ_IND)] =3D rwnx_rx_traffic_req_ind,
+	[MSG_I(MM_P2P_VIF_PS_CHANGE_IND)] =3D rwnx_rx_p2p_vif_ps_change_ind,
+	[MSG_I(MM_CSA_COUNTER_IND)] =3D rwnx_rx_csa_counter_ind,
+	[MSG_I(MM_CSA_FINISH_IND)] =3D rwnx_rx_csa_finish_ind,
+	[MSG_I(MM_CSA_TRAFFIC_IND)] =3D rwnx_rx_csa_traffic_ind,
+	[MSG_I(MM_CHANNEL_SURVEY_IND)] =3D rwnx_rx_channel_survey_ind,
+	[MSG_I(MM_P2P_NOA_UPD_IND)] =3D rwnx_rx_p2p_noa_upd_ind,
+	[MSG_I(MM_RSSI_STATUS_IND)] =3D rwnx_rx_rssi_status_ind,
+	[MSG_I(MM_PKTLOSS_IND)] =3D rwnx_rx_pktloss_notify_ind,
+	[MSG_I(MM_APM_STALOSS_IND)] =3D rwnx_apm_staloss_ind,
+	[MSG_I(MM_ARP_ANNOUNCEMENT_IND)] =3D rwnx_arp_announcement_ind,
+};
+
+static msg_cb_fct scan_hdlrs[MSG_I(SCANU_MAX)] =3D {
+	[MSG_I(SCANU_START_CFM)] =3D rwnx_rx_scanu_start_cfm,
+	[MSG_I(SCANU_RESULT_IND)] =3D rwnx_rx_scanu_result_ind,
+};
+
+static msg_cb_fct me_hdlrs[MSG_I(ME_MAX)] =3D {
+	[MSG_I(ME_TKIP_MIC_FAILURE_IND)] =3D rwnx_rx_me_tkip_mic_failure_ind,
+	[MSG_I(ME_TX_CREDITS_UPDATE_IND)] =3D rwnx_rx_me_tx_credits_update_ind,
+};
+
+static msg_cb_fct sm_hdlrs[MSG_I(SM_MAX)] =3D {
+	[MSG_I(SM_CONNECT_IND)] =3D rwnx_rx_sm_connect_ind,
+	[MSG_I(SM_DISCONNECT_IND)] =3D rwnx_rx_sm_disconnect_ind,
+	[MSG_I(SM_EXTERNAL_AUTH_REQUIRED_IND)] =3D
+		rwnx_rx_sm_external_auth_required_ind,
+};
+
+static msg_cb_fct apm_hdlrs[MSG_I(APM_MAX)] =3D {};
+
+static msg_cb_fct mesh_hdlrs[MSG_I(MESH_MAX)] =3D {
+	[MSG_I(MESH_PATH_CREATE_CFM)] =3D rwnx_rx_mesh_path_create_cfm,
+	[MSG_I(MESH_PEER_UPDATE_IND)] =3D rwnx_rx_mesh_peer_update_ind,
+	[MSG_I(MESH_PATH_UPDATE_IND)] =3D rwnx_rx_mesh_path_update_ind,
+	[MSG_I(MESH_PROXY_UPDATE_IND)] =3D rwnx_rx_mesh_proxy_update_ind,
+};
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+static msg_cb_fct dbg_hdlrs[MSG_I(DBG_MAX)] =3D {
+	[MSG_I(DBG_ERROR_IND)] =3D rwnx_rx_dbg_error_ind,
+};
+
+static msg_cb_fct tdls_hdlrs[MSG_I(TDLS_MAX)] =3D {
+	[MSG_I(TDLS_CHAN_SWITCH_CFM)] =3D rwnx_rx_tdls_chan_switch_cfm,
+	[MSG_I(TDLS_CHAN_SWITCH_IND)] =3D rwnx_rx_tdls_chan_switch_ind,
+	[MSG_I(TDLS_CHAN_SWITCH_BASE_IND)] =3D rwnx_rx_tdls_chan_switch_base_ind,
+	[MSG_I(TDLS_PEER_PS_IND)] =3D rwnx_rx_tdls_peer_ps_ind,
+#ifdef CONFIG_SDIO_BT
+	[MSG_I(TDLS_SDIO_BT_RECV_IND)] =3D rwnx_bt_recv_ind,
+#endif
+};
+
+static msg_cb_fct *msg_hdlrs[] =3D {
+	[TASK_MM] =3D mm_hdlrs,     [TASK_DBG] =3D dbg_hdlrs,
+#ifdef CONFIG_RWNX_FULLMAC
+	[TASK_TDLS] =3D tdls_hdlrs, [TASK_SCANU] =3D scan_hdlrs,
+	[TASK_ME] =3D me_hdlrs,     [TASK_SM] =3D sm_hdlrs,
+	[TASK_APM] =3D apm_hdlrs,   [TASK_MESH] =3D mesh_hdlrs,
+#endif /* CONFIG_RWNX_FULLMAC */
+};
+
+/**
+ *
+ */
+void rwnx_rx_handle_msg(struct rwnx_hw *rwnx_hw, struct ipc_e2a_msg *msg)
+{
+	// AICWFDBG(LOGDEBUG, "%s msg->id:0x%x \r\n", __func__, msg->id);
+
+	rwnx_hw->cmd_mgr->msgind(rwnx_hw->cmd_mgr, msg,
+				 msg_hdlrs[MSG_T(msg->id)][MSG_I(msg->id)]);
+}
+
+void rwnx_rx_handle_print(struct rwnx_hw *rwnx_hw, u8 *msg, u32 len)
+{
+	u8 *data_end =3D NULL;
+	(void)data_end;
+
+	if (!rwnx_hw || !rwnx_hw->fwlog_en) {
+		pr_err("FWLOG-OVFL: %s", msg);
+		return;
+	}
+
+	AICWFDBG(LOGDEBUG, "FWLOG: %s", msg);
+
+#ifdef CONFIG_RWNX_DEBUGFS
+	data_end =3D rwnx_hw->debugfs.fw_log.buf.dataend;
+
+	if (!rwnx_hw->debugfs.fw_log.buf.data)
+		return;
+
+	// AICWFDBG(LOGDEBUG, "end=3D%lx, len=3D%d\n", (unsigned
+	// long)rwnx_hw->debugfs.fw_log.buf.end, len);
+
+	spin_lock_bh(&rwnx_hw->debugfs.fw_log.lock);
+
+	if (rwnx_hw->debugfs.fw_log.buf.end + len > data_end) {
+		int rem =3D data_end - rwnx_hw->debugfs.fw_log.buf.end;
+
+		memcpy(rwnx_hw->debugfs.fw_log.buf.end, msg, rem);
+		memcpy(rwnx_hw->debugfs.fw_log.buf.data, &msg[rem], len - rem);
+		rwnx_hw->debugfs.fw_log.buf.end =3D
+			rwnx_hw->debugfs.fw_log.buf.data + (len - rem);
+	} else {
+		memcpy(rwnx_hw->debugfs.fw_log.buf.end, msg, len);
+		rwnx_hw->debugfs.fw_log.buf.end +=3D len;
+	}
+
+	rwnx_hw->debugfs.fw_log.buf.size +=3D len;
+	if (rwnx_hw->debugfs.fw_log.buf.size > FW_LOG_SIZE)
+		rwnx_hw->debugfs.fw_log.buf.size =3D FW_LOG_SIZE;
+
+	spin_unlock_bh(&rwnx_hw->debugfs.fw_log.lock);
+#endif
+}
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.h b/drivers/=
net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.h
new file mode 100644
index 0000000000000..211f2e616cbf4
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_rx.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _RWNX_MSG_RX_H_
+#define _RWNX_MSG_RX_H_
+
+void rwnx_rx_handle_msg(struct rwnx_hw *rwnx_hw, struct ipc_e2a_msg *msg);
+void rwnx_rx_handle_print(struct rwnx_hw *rwnx_hw, u8 *msg, u32 len);
+
+#endif /* _RWNX_MSG_RX_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.c b/drivers/=
net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.c
new file mode 100644
index 0000000000000..a45598725737d
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.c
@@ -0,0 +1,3815 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @brief TX function definitions
+ *
+ *************************************************************************=
*****
+ */
+
+#include "rwnx_msg_tx.h"
+#include "reg_access.h"
+#include "rwnx_mod_params.h"
+#ifdef CONFIG_RWNX_BFMER
+#include "rwnx_bfmer.h"
+#endif //(CONFIG_RWNX_BFMER)
+#include "aicwf_txrxif.h"
+#include "rwnx_cmds.h"
+#include "rwnx_compat.h"
+#include "rwnx_main.h"
+#include "rwnx_strs.h"
+#include "rwnx_wakelock.h"
+#include "aicwf_sdio.h"
+#include "aicwf_chip_ops.h"
+
+const struct mac_addr mac_addr_bcst =3D {{0xFFFF, 0xFFFF, 0xFFFF}};
+
+/* Default MAC Rx filters that can be changed by mac80211
+ * (via the configure_filter() callback)
+ */
+#define RWNX_MAC80211_CHANGEABLE                                          =
     \
+	(NXMAC_ACCEPT_BA_BIT | NXMAC_ACCEPT_BAR_BIT |                            =
  \
+	 NXMAC_ACCEPT_OTHER_DATA_FRAMES_BIT | NXMAC_ACCEPT_PROBE_REQ_BIT |       =
  \
+	 NXMAC_ACCEPT_PS_POLL_BIT)
+
+/* Default MAC Rx filters that cannot be changed by mac80211 */
+#define RWNX_MAC80211_NOT_CHANGEABLE                                      =
     \
+	(NXMAC_ACCEPT_QO_S_NULL_BIT | NXMAC_ACCEPT_Q_DATA_BIT |                  =
  \
+	 NXMAC_ACCEPT_DATA_BIT | NXMAC_ACCEPT_OTHER_MGMT_FRAMES_BIT |            =
  \
+	 NXMAC_ACCEPT_MY_UNICAST_BIT | NXMAC_ACCEPT_BROADCAST_BIT |              =
  \
+	 NXMAC_ACCEPT_BEACON_BIT | NXMAC_ACCEPT_PROBE_RESP_BIT)
+
+/* Default MAC Rx filter */
+#define RWNX_DEFAULT_RX_FILTER                                            =
     \
+	(RWNX_MAC80211_CHANGEABLE | RWNX_MAC80211_NOT_CHANGEABLE)
+
+const int bw2chnl[] =3D {
+	[NL80211_CHAN_WIDTH_20_NOHT] =3D PHY_CHNL_BW_20,
+	[NL80211_CHAN_WIDTH_20] =3D PHY_CHNL_BW_20,
+	[NL80211_CHAN_WIDTH_40] =3D PHY_CHNL_BW_40,
+	[NL80211_CHAN_WIDTH_80] =3D PHY_CHNL_BW_80,
+	[NL80211_CHAN_WIDTH_160] =3D PHY_CHNL_BW_160,
+	[NL80211_CHAN_WIDTH_80P80] =3D PHY_CHNL_BW_80P80,
+};
+
+const int chnl2bw[] =3D {
+	[PHY_CHNL_BW_20] =3D NL80211_CHAN_WIDTH_20,
+	[PHY_CHNL_BW_40] =3D NL80211_CHAN_WIDTH_40,
+	[PHY_CHNL_BW_80] =3D NL80211_CHAN_WIDTH_80,
+	[PHY_CHNL_BW_160] =3D NL80211_CHAN_WIDTH_160,
+	[PHY_CHNL_BW_80P80] =3D NL80211_CHAN_WIDTH_80P80,
+};
+
+#define RWNX_CMD_ARRAY_SIZE      20
+#define RWNX_CMD_HIGH_WATER_SIZE (RWNX_CMD_ARRAY_SIZE / 2)
+
+struct rwnx_cmd cmd_array[RWNX_CMD_ARRAY_SIZE];
+static spinlock_t cmd_array_lock;
+int cmd_array_index;
+
+/*************************************************************************=
****/
+/*
+ * Parse the ampdu density to retrieve the value in usec, according to the
+ * values defined in ieee80211.h
+ */
+static inline u8 rwnx_ampdudensity2usec(u8 ampdudensity)
+{
+	switch (ampdudensity) {
+	case IEEE80211_HT_MPDU_DENSITY_NONE:
+		return 0;
+		/* 1 microsecond is our granularity */
+	case IEEE80211_HT_MPDU_DENSITY_0_25:
+	case IEEE80211_HT_MPDU_DENSITY_0_5:
+	case IEEE80211_HT_MPDU_DENSITY_1:
+		return 1;
+	case IEEE80211_HT_MPDU_DENSITY_2:
+		return 2;
+	case IEEE80211_HT_MPDU_DENSITY_4:
+		return 4;
+	case IEEE80211_HT_MPDU_DENSITY_8:
+		return 8;
+	case IEEE80211_HT_MPDU_DENSITY_16:
+		return 16;
+	default:
+		return 0;
+	}
+}
+
+static inline bool use_pairwise_key(struct cfg80211_crypto_settings *crypt=
o)
+{
+	if (crypto->cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP40 ||
+	    crypto->cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP104)
+		return false;
+
+	return true;
+}
+
+static inline bool is_non_blocking_msg(int id)
+{
+	return (id =3D=3D MM_TIM_UPDATE_REQ || id =3D=3D ME_RC_SET_RATE_REQ ||
+		id =3D=3D MM_BFMER_ENABLE_REQ || id =3D=3D ME_TRAFFIC_IND_REQ ||
+		id =3D=3D TDLS_PEER_TRAFFIC_IND_REQ || id =3D=3D MESH_PATH_CREATE_REQ ||
+		id =3D=3D MESH_PROXY_ADD_REQ || id =3D=3D SM_EXTERNAL_AUTH_REQUIRED_RSP)=
;
+}
+
+static inline u8_l get_chan_flags(uint32_t flags)
+{
+	u8_l chan_flags =3D 0;
+#ifdef AIC8800_RADAR_OR_IR_DETECT
+
+	if (flags & IEEE80211_CHAN_NO_IR)
+		chan_flags |=3D CHAN_NO_IR;
+
+	if (flags & IEEE80211_CHAN_RADAR)
+		chan_flags |=3D CHAN_RADAR;
+#endif
+	return chan_flags;
+}
+
+static inline s8_l chan_to_fw_pwr(int power)
+{
+	return power > 127 ? 127 : (s8_l)power;
+}
+
+static inline void limit_chan_bw(u8_l *bw, u16_l primary, u16_l *center1)
+{
+	int oft, new_oft =3D 10;
+
+	if (*bw <=3D PHY_CHNL_BW_40)
+		return;
+
+	oft =3D *center1 - primary;
+	*bw =3D PHY_CHNL_BW_40;
+
+	if (oft < 0)
+		new_oft =3D new_oft * -1;
+	if (abs(oft) =3D=3D 10 || abs(oft) =3D=3D 50)
+		new_oft =3D new_oft * -1;
+
+	*center1 =3D primary + new_oft;
+}
+
+struct rwnx_cmd *rwnx_cmd_malloc(void)
+{
+	struct rwnx_cmd *cmd =3D NULL;
+	unsigned long flags =3D 0;
+
+	spin_lock_irqsave(&cmd_array_lock, flags);
+
+	for (cmd_array_index =3D 0; cmd_array_index < RWNX_CMD_ARRAY_SIZE;
+		 cmd_array_index++) {
+		if (cmd_array[cmd_array_index].used =3D=3D 0) {
+			AICWFDBG(LOGTRACE, "%s get cmd_array[%d]:%p \r\n", __func__,
+				 cmd_array_index, &cmd_array[cmd_array_index]);
+			cmd =3D &cmd_array[cmd_array_index];
+			cmd_array[cmd_array_index].used =3D 1;
+			break;
+		}
+	}
+
+	if (cmd_array_index >=3D RWNX_CMD_HIGH_WATER_SIZE) {
+		AICWFDBG(LOGERROR, "%s cmd(%d) was pending...\r\n", __func__,
+			 cmd_array_index);
+		mdelay(100);
+	}
+
+	if (!cmd)
+		AICWFDBG(LOGERROR, "%s array is empty...\r\n", __func__);
+
+	spin_unlock_irqrestore(&cmd_array_lock, flags);
+
+	return cmd;
+}
+
+void rwnx_cmd_free(struct rwnx_cmd *cmd)
+{
+	unsigned long flags =3D 0;
+
+	spin_lock_irqsave(&cmd_array_lock, flags);
+	cmd->used =3D 0;
+	AICWFDBG(LOGTRACE, "%s cmd_array[%d]:%p \r\n", __func__, cmd->array_id,
+		 cmd);
+	spin_unlock_irqrestore(&cmd_array_lock, flags);
+}
+
+int rwnx_init_cmd_array(void)
+{
+	AICWFDBG(LOGTRACE, "%s Enter \r\n", __func__);
+	spin_lock_init(&cmd_array_lock);
+
+	for (cmd_array_index =3D 0; cmd_array_index < RWNX_CMD_ARRAY_SIZE;
+	     cmd_array_index++) {
+		AICWFDBG(LOGTRACE, "%s cmd_queue[%d]:%p \r\n", __func__,
+			 cmd_array_index, &cmd_array[cmd_array_index]);
+		cmd_array[cmd_array_index].used =3D 0;
+		cmd_array[cmd_array_index].array_id =3D cmd_array_index;
+	}
+	AICWFDBG(LOGTRACE, "%s Exit \r\n", __func__);
+
+	return 0;
+}
+
+void rwnx_free_cmd_array(void)
+{
+	AICWFDBG(LOGTRACE, "%s Enter \r\n", __func__);
+
+	for (cmd_array_index =3D 0; cmd_array_index < RWNX_CMD_ARRAY_SIZE;
+	     cmd_array_index++)
+		cmd_array[cmd_array_index].used =3D 0;
+
+	AICWFDBG(LOGTRACE, "%s Exit \r\n", __func__);
+}
+
+/**
+ *************************************************************************=
*****
+ * @brief Allocate memory for a message
+ *
+ * This primitive allocates memory for a message that has to be sent. The =
memory
+ * is allocated dynamically on the heap and the length of the variable par=
ameter
+ * structure has to be provided in order to allocate the correct size.
+ *
+ * Several additional parameters are provided which will be preset in the
+ *message and which may be used internally to choose the kind of memory to
+ *allocate.
+ *
+ * The memory allocated will be automatically freed by the kernel, after t=
he
+ * pointer has been sent to ke_msg_send(). If the message is not sent, it =
must
+ * be freed explicitly with ke_msg_free().
+ *
+ * Allocation failure is considered critical and should not happen.
+ *
+ * @param[in] id        Message identifier
+ * @param[in] dest_id   Destination Task Identifier
+ * @param[in] src_id    Source Task Identifier
+ * @param[in] param_len Size of the message parameters to be allocated
+ *
+ * @return Pointer to the parameter member of the ke_msg. If the parameter
+ *         structure is empty, the pointer will point to the end of the me=
ssage
+ *         and should not be used (except to retrieve the message pointer =
or to
+ *         send the message)
+ *************************************************************************=
*****
+ */
+static inline void *rwnx_msg_zalloc(lmac_msg_id_t const id,
+				    lmac_task_id_t const dest_id,
+				    lmac_task_id_t const src_id,
+				    uint16_t const param_len)
+{
+	struct lmac_msg *msg;
+	gfp_t flags;
+
+	//  if (is_non_blocking_msg(id) && (in_softirq()||in_atomic()))
+	flags =3D GFP_ATOMIC;
+	//  else
+	//      flags =3D GFP_KERNEL;
+
+	// msg =3D (struct lmac_msg *)kzalloc(sizeof(struct lmac_msg) + param_len=
, flags);
+	msg =3D kzalloc(sizeof(*msg) + param_len, flags);
+	if (!msg) {
+		AICWFDBG(LOGERROR, "%s: msg allocation failed\n", __func__);
+		return NULL;
+	}
+	msg->id =3D id;
+	msg->dest_id =3D dest_id;
+	msg->src_id =3D src_id;
+	msg->param_len =3D param_len;
+	// AICWFDBG(LOGDEBUG, "rwnx_msg_zalloc size=3D%d  id=3D%d\n",msg->param_l=
en,msg->id);
+
+	return msg->param;
+}
+
+static void rwnx_msg_free(struct rwnx_hw *rwnx_hw, const void *msg_params)
+{
+	struct lmac_msg *msg =3D container_of((void *)msg_params, struct lmac_msg=
, param);
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+	/* Free the message */
+	kfree(msg);
+}
+
+// void rwnx_pm_relax(struct aic_sdio_dev *sdiodev);
+// void rwnx_pm_stay_awake(struct aic_sdio_dev *sdiodev);
+
+static int rwnx_send_msg(struct rwnx_hw *rwnx_hw, const void *msg_params,
+			 int reqcfm, lmac_msg_id_t reqid, void *cfm)
+{
+	struct lmac_msg *msg;
+	struct rwnx_cmd *cmd;
+	bool nonblock;
+	int ret =3D 0;
+	u8_l empty =3D 0;
+
+	// RWNX_DBG(RWNX_FN_ENTRY_STR);
+	AICWFDBG(LOGTRACE,
+		 "%s (%d)%s reqcfm:%d in_hardirq:%d in_softirq:%d irqs_disabled:%d\r\n",
+		 __func__, reqid, RWNX_ID2STR(reqid), reqcfm, (int)in_hardirq(),
+		 (int)in_softirq(), (int)irqs_disabled());
+
+#ifdef AICWF_SDIO_SUPPORT
+	rwnx_wakeup_lock(rwnx_hw->ws_tx);
+	if (rwnx_hw->sdiodev->bus_if->state =3D=3D BUS_DOWN_ST) {
+		rwnx_msg_free(rwnx_hw, msg_params);
+		sdio_err("bus is down\n");
+		rwnx_wakeup_unlock(rwnx_hw->ws_tx);
+		return 0;
+	}
+#endif
+
+	msg =3D container_of((void *)msg_params, struct lmac_msg, param);
+
+	// nonblock =3D is_non_blocking_msg(msg->id);
+	nonblock =3D 0;
+	cmd =3D rwnx_cmd_malloc(); // kzalloc_obj(struct rwnx_cmd, nonblock ?
+							 // GFP_ATOMIC : GFP_KERNEL);
+	cmd->result =3D -EINTR;
+	cmd->id =3D msg->id;
+	cmd->reqid =3D reqid;
+	cmd->a2e_msg =3D msg;
+	cmd->e2a_msg =3D cfm;
+	if (nonblock)
+		cmd->flags =3D RWNX_CMD_FLAG_NONBLOCK;
+	if (reqcfm)
+		cmd->flags |=3D RWNX_CMD_FLAG_REQ_CFM;
+
+	if (cfm) {
+		do {
+			if (rwnx_hw->cmd_mgr->state =3D=3D RWNX_CMD_MGR_STATE_CRASHED)
+				break;
+			spin_lock_bh(&rwnx_hw->cmd_mgr->lock);
+			empty =3D list_empty(&rwnx_hw->cmd_mgr->cmds);
+			spin_unlock_bh(&rwnx_hw->cmd_mgr->lock);
+			if (!empty) {
+				if (in_softirq()) {
+					AICWFDBG(LOGDEBUG,
+						 "AICWF_LOG in_softirq:check cmdqueue empty\n");
+					mdelay(10);
+				} else {
+					AICWFDBG(LOGDEBUG, "AICWF_LOG check cmdqueue empty\n");
+					msleep(50);
+				}
+			}
+		} while (!empty); // wait for cmd queue empty
+	}
+
+	if (reqcfm) {
+		cmd->flags &=3D ~RWNX_CMD_FLAG_WAIT_ACK; // we don't need ack any more
+		ret =3D rwnx_hw->cmd_mgr->queue(rwnx_hw->cmd_mgr, cmd);
+	} else {
+#ifdef AICWF_SDIO_SUPPORT
+		aicwf_set_cmd_tx((void *)(rwnx_hw->sdiodev), cmd->a2e_msg,
+				 sizeof(struct lmac_msg) + cmd->a2e_msg->param_len);
+#else
+		aicwf_set_cmd_tx((void *)(rwnx_hw->usbdev), cmd->a2e_msg,
+				 sizeof(struct lmac_msg) + cmd->a2e_msg->param_len);
+#endif
+	}
+
+	if (!reqcfm || ret)
+		rwnx_cmd_free(cmd); // kfree(cmd);
+
+	rwnx_wakeup_unlock(rwnx_hw->ws_tx);
+	return 0;
+}
+
+static int rwnx_send_msg1(struct rwnx_hw *rwnx_hw, const void *msg_params,
+			  int reqcfm, lmac_msg_id_t reqid, void *cfm,
+			  bool defer)
+{
+	struct lmac_msg *msg;
+	struct rwnx_cmd *cmd;
+	bool nonblock;
+	int ret =3D 0;
+
+	//  RWNX_DBG(RWNX_FN_ENTRY_STR);
+	AICWFDBG(LOGDEBUG,
+		 "AICWF_LOG %s (%d)%s reqcfm:%d in_hardirq:%d in_softirq:%d irqs_disable=
d:%d\r\n",
+		 __func__, reqid, RWNX_ID2STR(reqid), reqcfm, (int)in_hardirq(),
+		 (int)in_softirq(), (int)irqs_disabled());
+
+	rwnx_wakeup_lock(rwnx_hw->ws_tx);
+	msg =3D container_of((void *)msg_params, struct lmac_msg, param);
+
+	// nonblock =3D is_non_blocking_msg(msg->id);
+	nonblock =3D 0;
+	cmd =3D rwnx_cmd_malloc(); // kzalloc_obj(struct rwnx_cmd, nonblock ?
+							 // GFP_ATOMIC : GFP_KERNEL);
+	cmd->result =3D -EINTR;
+	cmd->id =3D msg->id;
+	cmd->reqid =3D reqid;
+	cmd->a2e_msg =3D msg;
+	cmd->e2a_msg =3D cfm;
+	if (nonblock)
+		cmd->flags =3D RWNX_CMD_FLAG_NONBLOCK;
+	if (reqcfm)
+		cmd->flags |=3D RWNX_CMD_FLAG_REQ_CFM;
+
+	if (reqcfm) {
+		cmd->flags &=3D ~RWNX_CMD_FLAG_WAIT_ACK; // we don't need ack any more
+		if (!defer)
+			ret =3D rwnx_hw->cmd_mgr->queue(rwnx_hw->cmd_mgr, cmd);
+		else
+			ret =3D cmd_mgr_queue_force_defer(rwnx_hw->cmd_mgr, cmd);
+	}
+
+	if (!reqcfm || ret)
+		rwnx_cmd_free(cmd); // kfree(cmd);
+
+	if (!ret)
+		ret =3D cmd->result;
+
+	rwnx_wakeup_unlock(rwnx_hw->ws_tx);
+	// return ret;
+	return 0;
+}
+
+/*************************************************************************=
*****
+ *    Control messages handling functions (FULLMAC)
+ *************************************************************************=
****/
+int rwnx_send_reset(struct rwnx_hw *rwnx_hw)
+{
+	void *void_param;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* RESET REQ has no parameter */
+	void_param =3D rwnx_msg_zalloc(MM_RESET_REQ, TASK_MM, DRV_TASK_ID, 0);
+	if (!void_param)
+		return -ENOMEM;
+
+	return rwnx_send_msg(rwnx_hw, void_param, 1, MM_RESET_CFM, NULL);
+}
+
+int rwnx_send_start(struct rwnx_hw *rwnx_hw)
+{
+	struct mm_start_req *start_req_param;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the START REQ message */
+	start_req_param =3D rwnx_msg_zalloc(MM_START_REQ, TASK_MM, DRV_TASK_ID,
+					  sizeof(struct mm_start_req));
+	if (!start_req_param)
+		return -ENOMEM;
+
+	/* Set parameters for the START message */
+	memcpy(&start_req_param->phy_cfg, &rwnx_hw->phy.cfg,
+	       sizeof(rwnx_hw->phy.cfg));
+	start_req_param->uapsd_timeout =3D (u32_l)rwnx_hw->mod_params->uapsd_time=
out;
+	start_req_param->lp_clk_accuracy =3D (u16_l)rwnx_hw->mod_params->lp_clk_p=
pm;
+
+	/* Send the START REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, start_req_param, 1, MM_START_CFM, NULL);
+}
+
+int rwnx_send_version_req(struct rwnx_hw *rwnx_hw, struct mm_version_cfm *=
cfm)
+{
+	void *void_param;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* VERSION REQ has no parameter */
+	void_param =3D rwnx_msg_zalloc(MM_VERSION_REQ, TASK_MM, DRV_TASK_ID, 0);
+	if (!void_param)
+		return -ENOMEM;
+
+	return rwnx_send_msg(rwnx_hw, void_param, 1, MM_VERSION_CFM, cfm);
+}
+
+int rwnx_send_add_if(struct rwnx_hw *rwnx_hw, const unsigned char *mac,
+		     enum nl80211_iftype iftype, bool p2p,
+		     struct mm_add_if_cfm *cfm)
+{
+	struct mm_add_if_req *add_if_req_param;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ADD_IF_REQ message */
+	add_if_req_param =3D rwnx_msg_zalloc(MM_ADD_IF_REQ, TASK_MM, DRV_TASK_ID,
+					   sizeof(struct mm_add_if_req));
+	if (!add_if_req_param)
+		return -ENOMEM;
+
+	/* Set parameters for the ADD_IF_REQ message */
+	memcpy(&add_if_req_param->addr.array[0], mac, ETH_ALEN);
+	switch (iftype) {
+#ifdef CONFIG_RWNX_FULLMAC
+		// case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		add_if_req_param->p2p =3D true;
+		fallthrough;
+		// no break
+#endif /* CONFIG_RWNX_FULLMAC */
+	case NL80211_IFTYPE_STATION:
+		add_if_req_param->type =3D MM_STA;
+		break;
+
+	case NL80211_IFTYPE_ADHOC:
+		add_if_req_param->type =3D MM_IBSS;
+		break;
+
+#ifdef CONFIG_RWNX_FULLMAC
+	case NL80211_IFTYPE_P2P_GO:
+		add_if_req_param->p2p =3D true;
+		fallthrough;
+		// no break
+#endif /* CONFIG_RWNX_FULLMAC */
+	case NL80211_IFTYPE_AP:
+		add_if_req_param->type =3D MM_AP;
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		add_if_req_param->type =3D MM_MESH_POINT;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		return -1;
+	case NL80211_IFTYPE_MONITOR:
+		add_if_req_param->type =3D MM_MONITOR;
+		break;
+	default:
+		add_if_req_param->type =3D MM_STA;
+		break;
+	}
+
+	/* Send the ADD_IF_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, add_if_req_param, 1, MM_ADD_IF_CFM, cfm);
+}
+
+int rwnx_send_remove_if(struct rwnx_hw *rwnx_hw, u8 vif_index, bool defer)
+{
+	struct mm_remove_if_req *remove_if_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_REMOVE_IF_REQ message */
+	remove_if_req =3D rwnx_msg_zalloc(MM_REMOVE_IF_REQ, TASK_MM, DRV_TASK_ID,
+					sizeof(struct mm_remove_if_req));
+	if (!remove_if_req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_REMOVE_IF_REQ message */
+	remove_if_req->inst_nbr =3D vif_index;
+
+	/* Send the MM_REMOVE_IF_REQ message to LMAC FW */
+	return rwnx_send_msg1(rwnx_hw, remove_if_req, 1, MM_REMOVE_IF_CFM, NULL,
+						  defer);
+}
+
+int rwnx_send_set_channel(struct rwnx_hw *rwnx_hw, int phy_idx,
+			  struct mm_set_channel_cfm *cfm)
+{
+	struct mm_set_channel_req *req;
+	enum nl80211_chan_width width =3D NL80211_CHAN_WIDTH_20_NOHT;
+	u16 center_freq =3D 2412, center_freq1 =3D 2412, center_freq2 =3D 2412;
+	s8 tx_power =3D 0;
+	u8 flags =3D 0;
+	enum nl80211_band band =3D NL80211_BAND_2GHZ;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	if (phy_idx >=3D rwnx_hw->phy.cnt)
+		return -EOPNOTSUPP;
+
+	req =3D rwnx_msg_zalloc(MM_SET_CHANNEL_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_channel_req));
+	if (!req)
+		return -ENOMEM;
+
+	if (phy_idx =3D=3D 0) {
+#ifdef CONFIG_RWNX_FULLMAC
+		/* On FULLMAC only setting channel of secondary chain */
+		wiphy_err(rwnx_hw->wiphy, "Trying to set channel of primary chain");
+		return 0;
+#endif /* CONFIG_RWNX_FULLMAC */
+	} else {
+		struct rwnx_sec_phy_chan *chan =3D &rwnx_hw->phy.sec_chan;
+
+		width =3D chnl2bw[chan->type];
+		band =3D chan->band;
+		center_freq =3D chan->prim20_freq;
+		center_freq1 =3D chan->center_freq1;
+		center_freq2 =3D chan->center_freq2;
+		flags =3D 0;
+	}
+
+	req->chan.band =3D band;
+	req->chan.type =3D bw2chnl[width];
+	req->chan.prim20_freq =3D center_freq;
+	req->chan.center1_freq =3D center_freq1;
+	req->chan.center2_freq =3D center_freq2;
+	req->chan.tx_power =3D tx_power;
+	req->chan.flags =3D flags;
+	req->index =3D phy_idx;
+
+	if (rwnx_hw->phy.limit_bw)
+		limit_chan_bw(&req->chan.type, req->chan.prim20_freq,
+			      &req->chan.center1_freq);
+
+	RWNX_DBG("mac80211:   freq=3D%d(c1:%d - c2:%d)/width=3D%d - band=3D%d\n"
+		 "   hw(%d): prim20=3D%d(c1:%d - c2:%d)/ type=3D%d - band=3D%d\n",
+		 center_freq, center_freq1, center_freq2, width, band, phy_idx,
+		 req->chan.prim20_freq, req->chan.center1_freq,
+		 req->chan.center2_freq, req->chan.type, req->chan.band);
+
+	/* Send the MM_SET_CHANNEL_REQ REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MM_SET_CHANNEL_CFM, cfm);
+}
+
+int rwnx_send_key_add(struct rwnx_hw *rwnx_hw, u8 vif_idx, u8 sta_idx,
+		      bool pairwise, u8 *key, u8 key_len, u8 key_idx,
+		      u8 cipher_suite, struct mm_key_add_cfm *cfm)
+{
+	struct mm_key_add_req *key_add_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_KEY_ADD_REQ message */
+	key_add_req =3D rwnx_msg_zalloc(MM_KEY_ADD_REQ, TASK_MM, DRV_TASK_ID,
+				      sizeof(struct mm_key_add_req));
+	if (!key_add_req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_KEY_ADD_REQ message */
+	if (sta_idx !=3D 0xFF) {
+		/* Pairwise key */
+		key_add_req->sta_idx =3D sta_idx;
+	} else {
+		/* Default key */
+		key_add_req->sta_idx =3D sta_idx;
+		key_add_req->key_idx =3D (u8_l)key_idx; /* only useful for default keys =
*/
+	}
+	key_add_req->pairwise =3D pairwise;
+	key_add_req->inst_nbr =3D vif_idx;
+	key_add_req->key.length =3D key_len;
+	memcpy(&key_add_req->key.array[0], key, key_len);
+
+	key_add_req->cipher_suite =3D cipher_suite;
+
+	RWNX_DBG("%s: sta_idx:%d key_idx:%d inst_nbr:%d cipher:%d key_len:%d\n",
+		 __func__, key_add_req->sta_idx, key_add_req->key_idx,
+		 key_add_req->inst_nbr, key_add_req->cipher_suite,
+		 key_add_req->key.length);
+#if defined(CONFIG_RWNX_DBG) || defined(CONFIG_DYNAMIC_DEBUG)
+	print_hex_dump_bytes("key: ", DUMP_PREFIX_OFFSET, key_add_req->key.array,
+			     key_add_req->key.length);
+#endif
+
+	/* Send the MM_KEY_ADD_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, key_add_req, 1, MM_KEY_ADD_CFM, cfm);
+}
+
+int rwnx_send_key_del(struct rwnx_hw *rwnx_hw, uint8_t hw_key_idx)
+{
+	struct mm_key_del_req *key_del_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_KEY_DEL_REQ message */
+	key_del_req =3D rwnx_msg_zalloc(MM_KEY_DEL_REQ, TASK_MM, DRV_TASK_ID,
+				      sizeof(struct mm_key_del_req));
+	if (!key_del_req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_KEY_DEL_REQ message */
+	key_del_req->hw_key_idx =3D hw_key_idx;
+
+	/* Send the MM_KEY_DEL_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, key_del_req, 1, MM_KEY_DEL_CFM, NULL);
+}
+
+int rwnx_send_bcn(struct rwnx_hw *rwnx_hw, u8 *buf, u8 vif_idx, u16 bcn_le=
n)
+{
+	struct apm_set_bcn_ie_req *bcn_ie_req;
+
+	bcn_ie_req =3D rwnx_msg_zalloc(APM_SET_BEACON_IE_REQ, TASK_APM, DRV_TASK_=
ID,
+				     sizeof(struct apm_set_bcn_ie_req));
+	if (!bcn_ie_req)
+		return -ENOMEM;
+
+	bcn_ie_req->vif_idx =3D vif_idx;
+	bcn_ie_req->bcn_ie_len =3D bcn_len;
+	memcpy(bcn_ie_req->bcn_ie, (u8 *)buf, bcn_len);
+	kfree(buf);
+
+	return rwnx_send_msg(rwnx_hw, bcn_ie_req, 1, APM_SET_BEACON_IE_CFM, NULL)=
;
+}
+
+int rwnx_send_bcn_change(struct rwnx_hw *rwnx_hw, u8 vif_idx, u32 bcn_addr=
,
+			 u16 bcn_len, u16 tim_oft, u16 tim_len, u16 *csa_oft)
+{
+	struct mm_bcn_change_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_BCN_CHANGE_REQ message */
+	req =3D rwnx_msg_zalloc(MM_BCN_CHANGE_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_bcn_change_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_BCN_CHANGE_REQ message */
+	req->bcn_ptr =3D bcn_addr;
+	req->bcn_len =3D bcn_len;
+	req->tim_oft =3D tim_oft;
+	req->tim_len =3D tim_len;
+	req->inst_nbr =3D vif_idx;
+
+	if (csa_oft) {
+		int i;
+
+		for (i =3D 0; i < BCN_MAX_CSA_CPT; i++)
+			req->csa_oft[i] =3D csa_oft[i];
+	}
+
+	/* Send the MM_BCN_CHANGE_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MM_BCN_CHANGE_CFM, NULL);
+}
+
+int rwnx_send_roc(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif,
+		  struct ieee80211_channel *chan, unsigned int duration,
+		  struct mm_remain_on_channel_cfm *roc_cfm)
+{
+	struct mm_remain_on_channel_req *req;
+	struct cfg80211_chan_def chandef;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Create channel definition structure */
+	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+
+	/* Build the MM_REMAIN_ON_CHANNEL_REQ message */
+	req =3D rwnx_msg_zalloc(MM_REMAIN_ON_CHANNEL_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_remain_on_channel_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_REMAIN_ON_CHANNEL_REQ message */
+	req->op_code =3D MM_ROC_OP_START;
+	req->vif_index =3D vif->vif_index;
+	req->duration_ms =3D duration;
+	req->band =3D chan->band;
+	req->type =3D bw2chnl[chandef.width];
+	req->prim20_freq =3D chan->center_freq;
+	req->center1_freq =3D chandef.center_freq1;
+	req->center2_freq =3D chandef.center_freq2;
+	req->tx_power =3D chan_to_fw_pwr(chan->max_power);
+
+	/* Send the MM_REMAIN_ON_CHANNEL_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MM_REMAIN_ON_CHANNEL_CFM, roc_cfm);
+}
+
+int rwnx_send_cancel_roc(struct rwnx_hw *rwnx_hw)
+{
+	struct mm_remain_on_channel_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_REMAIN_ON_CHANNEL_REQ message */
+	req =3D rwnx_msg_zalloc(MM_REMAIN_ON_CHANNEL_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_remain_on_channel_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_REMAIN_ON_CHANNEL_REQ message */
+	req->op_code =3D MM_ROC_OP_CANCEL;
+
+	/* Send the MM_REMAIN_ON_CHANNEL_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MM_REMAIN_ON_CHANNEL_CFM, NULL);
+}
+
+int rwnx_send_set_power(struct rwnx_hw *rwnx_hw, u8 vif_idx, s8 pwr,
+			struct mm_set_power_cfm *cfm)
+{
+	struct mm_set_power_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_POWER_REQ message */
+	req =3D rwnx_msg_zalloc(MM_SET_POWER_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_power_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_SET_POWER_REQ message */
+	req->inst_nbr =3D vif_idx;
+	req->power =3D pwr;
+
+	/* Send the MM_SET_POWER_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MM_SET_POWER_CFM, cfm);
+}
+
+int rwnx_send_set_edca(struct rwnx_hw *rwnx_hw, u8 hw_queue, u32 param,
+		       bool uapsd, u8 inst_nbr)
+{
+	struct mm_set_edca_req *set_edca_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_EDCA_REQ message */
+	set_edca_req =3D rwnx_msg_zalloc(MM_SET_EDCA_REQ, TASK_MM, DRV_TASK_ID,
+				       sizeof(struct mm_set_edca_req));
+	if (!set_edca_req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_SET_EDCA_REQ message */
+	set_edca_req->ac_param =3D param;
+	set_edca_req->uapsd =3D uapsd;
+	set_edca_req->hw_queue =3D hw_queue;
+	set_edca_req->inst_nbr =3D inst_nbr;
+
+	/* Send the MM_SET_EDCA_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, set_edca_req, 1, MM_SET_EDCA_CFM, NULL);
+}
+
+#ifdef CONFIG_RWNX_P2P_DEBUGFS
+int rwnx_send_p2p_oppps_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *rwnx=
_vif,
+			    u8 ctw, struct mm_set_p2p_oppps_cfm *cfm)
+{
+	struct mm_set_p2p_oppps_req *p2p_oppps_req;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_P2P_OPPPS_REQ message */
+	p2p_oppps_req =3D rwnx_msg_zalloc(MM_SET_P2P_OPPPS_REQ, TASK_MM, DRV_TASK=
_ID,
+					sizeof(struct mm_set_p2p_oppps_req));
+
+	if (!p2p_oppps_req)
+		return -ENOMEM;
+
+	/* Fill the message parameters */
+	p2p_oppps_req->vif_index =3D rwnx_vif->vif_index;
+	p2p_oppps_req->ctwindow =3D ctw;
+
+	/* Send the MM_P2P_OPPPS_REQ message to LMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, p2p_oppps_req, 1, MM_SET_P2P_OPPPS_CFM, =
cfm);
+
+	return error;
+}
+
+int rwnx_send_p2p_noa_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *rwnx_v=
if,
+			  int count, int interval, int duration, bool dyn_noa,
+			  struct mm_set_p2p_noa_cfm *cfm)
+{
+	struct mm_set_p2p_noa_req *p2p_noa_req;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Param check */
+	if (count > 255)
+		count =3D 255;
+
+	if (duration >=3D interval) {
+		dev_err(rwnx_hw->dev,
+			"Invalid p2p NOA config: interval=3D%d <=3D duration=3D%d\n",
+			interval, duration);
+		return -EINVAL;
+	}
+
+	/* Build the MM_SET_P2P_NOA_REQ message */
+	p2p_noa_req =3D rwnx_msg_zalloc(MM_SET_P2P_NOA_REQ, TASK_MM, DRV_TASK_ID,
+				      sizeof(struct mm_set_p2p_noa_req));
+
+	if (!p2p_noa_req)
+		return -ENOMEM;
+
+	/* Fill the message parameters */
+	p2p_noa_req->vif_index =3D rwnx_vif->vif_index;
+	p2p_noa_req->noa_inst_nb =3D 0;
+	p2p_noa_req->count =3D count;
+
+	if (count) {
+		p2p_noa_req->duration_us =3D duration * 1024;
+		p2p_noa_req->interval_us =3D interval * 1024;
+		p2p_noa_req->start_offset =3D (interval - duration - 10) * 1024;
+		p2p_noa_req->dyn_noa =3D dyn_noa;
+	}
+
+	/* Send the MM_SET_2P_NOA_REQ message to LMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, p2p_noa_req, 1, MM_SET_P2P_NOA_CFM, cfm)=
;
+
+	return error;
+}
+#endif /* CONFIG_RWNX_P2P_DEBUGFS */
+
+#ifdef AICWF_ARP_OFFLOAD
+int rwnx_send_arpoffload_en_req(struct rwnx_hw *rwnx_hw,
+				struct rwnx_vif *rwnx_vif, u32_l ipaddr,
+				u8_l enable)
+{
+	struct mm_set_arpoffload_en_req *arp_offload_req;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_P2P_NOA_REQ message */
+	arp_offload_req =3D
+		rwnx_msg_zalloc(MM_SET_ARPOFFLOAD_REQ, TASK_MM, DRV_TASK_ID,
+				sizeof(struct mm_set_arpoffload_en_req));
+
+	if (!arp_offload_req)
+		return -ENOMEM;
+
+	/* Fill the message parameters */
+	arp_offload_req->enable =3D enable;
+	arp_offload_req->vif_idx =3D rwnx_vif->vif_index;
+	arp_offload_req->ipaddr =3D ipaddr;
+
+	/* Send the MM_ARPOFFLOAD_EN_REQ message to UMAC FW */
+	error =3D
+		rwnx_send_msg(rwnx_hw, arp_offload_req, 1, MM_SET_ARPOFFLOAD_CFM, NULL);
+
+	return error;
+}
+#endif
+
+int rwnx_send_disable_agg_req(struct rwnx_hw *rwnx_hw, u8_l agg_disable,
+			      u8_l agg_disable_rx, u8_l sta_idx)
+{
+	struct mm_set_agg_disable_req *req;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_AGG_DISABLE_REQ message */
+	req =3D rwnx_msg_zalloc(MM_SET_AGG_DISABLE_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_agg_disable_req));
+
+	if (!req)
+		return -ENOMEM;
+
+	req->disable =3D agg_disable;
+	req->staidx =3D sta_idx;
+	req->disable_rx =3D agg_disable_rx;
+
+	/* Send the MM_SET_AGG_DISABLE_REQ message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, req, 1, MM_SET_AGG_DISABLE_CFM, NULL);
+
+	return error;
+};
+
+int rwnx_send_coex_req(struct rwnx_hw *rwnx_hw, u8_l disable_coexnull,
+		       u8_l enable_nullcts)
+{
+	struct mm_set_coex_req *coex_req;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_COEX_REQ message */
+	coex_req =3D rwnx_msg_zalloc(MM_SET_COEX_REQ, TASK_MM, DRV_TASK_ID,
+				   sizeof(struct mm_set_coex_req));
+
+	if (!coex_req)
+		return -ENOMEM;
+
+	coex_req->bt_on =3D 1;
+	coex_req->disable_coexnull =3D disable_coexnull;
+	coex_req->enable_nullcts =3D enable_nullcts;
+	coex_req->enable_periodic_timer =3D 0;
+	coex_req->coex_timeslot_set =3D 0;
+
+	/* Send the MM_SET_COEX_REQ message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, coex_req, 1, MM_SET_COEX_CFM, NULL);
+
+	return error;
+};
+
+int rwnx_send_rf_config_req(struct rwnx_hw *rwnx_hw, u8_l ofst, u8_l sel,
+			    u8_l *tbl, u16_l len)
+{
+	struct mm_set_rf_config_req *rf_config_req;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_RF_CONFIG_REQ message */
+	rf_config_req =3D rwnx_msg_zalloc(MM_SET_RF_CONFIG_REQ, TASK_MM, DRV_TASK=
_ID,
+					sizeof(struct mm_set_rf_config_req));
+
+	if (!rf_config_req)
+		return -ENOMEM;
+
+	rf_config_req->table_sel =3D sel;
+	rf_config_req->table_ofst =3D ofst;
+	rf_config_req->table_num =3D 16;
+	rf_config_req->deft_page =3D 0;
+
+	memcpy(rf_config_req->data, tbl, len);
+
+	/* Send the MM_SET_RF_CONFIG_REQ message to UMAC FW */
+	error =3D
+		rwnx_send_msg(rwnx_hw, rf_config_req, 1, MM_SET_RF_CONFIG_CFM, NULL);
+
+	return error;
+}
+
+int rwnx_send_rf_calib_req(struct rwnx_hw *rwnx_hw,
+			   struct mm_set_rf_calib_cfm *cfm)
+{
+	struct mm_set_rf_calib_req *rf_calib_req;
+	struct xtal_cap_conf xtal_cap =3D {
+		0,
+	};
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_P2P_NOA_REQ message */
+	rf_calib_req =3D rwnx_msg_zalloc(MM_SET_RF_CALIB_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_set_rf_calib_req));
+
+	if (!rf_calib_req)
+		return -ENOMEM;
+
+	aic_chip_set_rf_calib_cfg(rwnx_hw, rf_calib_req);
+
+	rf_calib_req->param_alpha =3D 0x0c34c008;
+	rf_calib_req->bt_calib_en =3D 0;
+	rf_calib_req->bt_calib_param =3D 0x264203;
+
+	get_userconfig_xtal_cap(&xtal_cap);
+
+	if (xtal_cap.enable) {
+		AICWFDBG(LOGDEBUG, "user xtal cap: %d, cap_fine: %d\n", xtal_cap.xtal_ca=
p,
+			 xtal_cap.xtal_cap_fine);
+		rf_calib_req->xtal_cap =3D xtal_cap.xtal_cap;
+		rf_calib_req->xtal_cap_fine =3D xtal_cap.xtal_cap_fine;
+	} else {
+		rf_calib_req->xtal_cap =3D 0;
+		rf_calib_req->xtal_cap_fine =3D 0;
+	}
+
+	/* Send the MM_SET_RF_CALIB_REQ message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, rf_calib_req, 1, MM_SET_RF_CALIB_CFM, cf=
m);
+
+	return error;
+};
+
+int rwnx_send_get_macaddr_req(struct rwnx_hw *rwnx_hw,
+			      struct mm_get_mac_addr_cfm *cfm)
+{
+	struct mm_get_mac_addr_req *get_macaddr_req;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_GET_MAC_ADDR_REQ message */
+	get_macaddr_req =3D rwnx_msg_zalloc(MM_GET_MAC_ADDR_REQ, TASK_MM, DRV_TAS=
K_ID,
+					  sizeof(struct mm_get_mac_addr_req));
+
+	if (!get_macaddr_req)
+		return -ENOMEM;
+
+	get_macaddr_req->get =3D 1;
+
+	/* Send the MM_GET_MAC_ADDR_REQ  message to UMAC FW */
+	error =3D
+		rwnx_send_msg(rwnx_hw, get_macaddr_req, 1, MM_GET_MAC_ADDR_CFM, cfm);
+
+	return error;
+};
+
+int rwnx_send_get_sta_info_req(struct rwnx_hw *rwnx_hw, u8_l sta_idx,
+			       struct mm_get_sta_info_cfm *cfm)
+{
+	struct mm_get_sta_info_req *get_info_req;
+	int error;
+
+	/* Build the MM_GET_STA_INFO_REQ message */
+	get_info_req =3D rwnx_msg_zalloc(MM_GET_STA_INFO_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_get_sta_info_req));
+
+	if (!get_info_req)
+		return -ENOMEM;
+
+	get_info_req->sta_idx =3D sta_idx;
+
+	/* Send the MM_GET_STA_INFO_REQ  message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, get_info_req, 1, MM_GET_STA_INFO_CFM, cf=
m);
+
+	return error;
+};
+
+int rwnx_send_set_stack_start_req(struct rwnx_hw *rwnx_hw, u8_l on,
+				  u8_l efuse_valid, u8_l set_vendor_info,
+				  u8_l fwtrace_redir_en,
+				  struct mm_set_stack_start_cfm *cfm)
+{
+	struct mm_set_stack_start_req *req;
+	int error;
+
+	/* Build the MM_SET_STACK_START_REQ message */
+	req =3D rwnx_msg_zalloc(MM_SET_STACK_START_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_stack_start_req));
+
+	if (!req)
+		return -ENOMEM;
+
+	req->is_stack_start =3D on;
+	req->efuse_valid =3D efuse_valid;
+	req->set_vendor_info =3D set_vendor_info;
+	req->fwtrace_redir =3D fwtrace_redir_en;
+	/* Send the MM_SET_STACK_START_REQ  message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, req, 1, MM_SET_STACK_START_CFM, cfm);
+
+	return error;
+}
+
+int rwnx_send_get_temp_req(struct rwnx_hw *rwnx_hw,
+			   struct mm_set_vendor_swconfig_cfm *cfm)
+{
+	struct mm_set_vendor_swconfig_req *req;
+	int ret;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the TEMP_COMP_GET_REQ message */
+	req =3D rwnx_msg_zalloc(MM_SET_VENDOR_SWCONFIG_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_vendor_swconfig_req));
+	if (!req) {
+		AICWFDBG(LOGINFO, "%s msg_alloc fail\n", __func__);
+		return -ENOMEM;
+	}
+	req->swconfig_id =3D TEMP_COMP_GET_REQ;
+
+	ret =3D rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, cfm);
+	if (!ret) {
+		AICWFDBG(LOGDEBUG, "status=3D%d, temp=3D%d\n", cfm->temp_comp_get_cfm.st=
atus,
+			 cfm->temp_comp_get_cfm.degree);
+	} else {
+		AICWFDBG(LOGINFO, "%s msg_fail\n", __func__);
+		return ret;
+	}
+#ifdef CONFIG_AIC8800_TEMP_CONTROL
+	// rwnx_hw->started_jiffies =3D jiffies;
+	rwnx_hw->temp =3D cfm->temp_comp_get_cfm.degree;
+#endif
+
+	return ret;
+}
+
+int rwnx_send_get_temp_hwconfig_req(struct rwnx_hw *rwnx_hw,
+				    struct mm_set_vendor_hwconfig_cfm *cfm)
+{
+	struct mm_get_chip_temp_req *req;
+	int ret;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+	/* Build the TEMP_COMP_HWCONFIG_GET_REQ message */
+	req =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_get_chip_temp_req));
+	if (!req) {
+		AICWFDBG(LOGINFO, "%s msg_alloc fail\n", __func__);
+		return -ENOMEM;
+	}
+	req->hwconfig_id =3D CHIP_TEMP_GET_REQ;
+
+	ret =3D rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_HWCONFIG_CFM, cfm);
+	if (!ret) {
+		AICWFDBG(LOGDEBUG, "get_chip_temp degree=3D%d\n",
+			 cfm->chip_temp_cfm.degree);
+	} else {
+		AICWFDBG(LOGINFO, "%s msg_fail\n", __func__);
+		return ret;
+	}
+	return ret;
+}
+
+int rwnx_send_set_temp_comp_req(struct rwnx_hw *rwnx_hw,
+				struct mm_set_vendor_swconfig_cfm *cfm)
+{
+	struct mm_set_vendor_swconfig_req *req;
+	int ret;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+	/* Build the TEMP_COMP_SET_REQ message */
+	req =3D rwnx_msg_zalloc(MM_SET_VENDOR_SWCONFIG_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_vendor_swconfig_req));
+	if (!req) {
+		AICWFDBG(LOGERROR, "%s msg_alloc fail\n", __func__);
+		return -ENOMEM;
+	}
+	req->swconfig_id =3D TEMP_COMP_SET_REQ;
+	req->temp_comp_set_req.enable =3D 1;
+#ifdef CONFIG_AIC8800_TEMP_CONTROL
+	req->temp_comp_set_req.tmr_period_ms =3D TEMP_GET_INTERVAL;
+#else
+	req->temp_comp_set_req.tmr_period_ms =3D 15 * 1000;
+#endif
+
+	ret =3D rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, cfm);
+	if (!ret) {
+		AICWFDBG(LOGINFO, "temp_comp status: %d\n", cfm->temp_comp_set_cfm.statu=
s);
+	} else {
+		AICWFDBG(LOGINFO, "%s msg_fail\n", __func__);
+		return ret;
+	}
+	return ret;
+}
+
+int rwnx_send_set_pkt_filter_req(struct rwnx_hw *rwnx_hw, u16_l *param)
+{
+	struct mm_set_wakeup_info_req *req;
+	int i, err;
+	u16_l pt_start =3D 3;
+	u16_l total_len =3D 0;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the WAKEUP_INFO_REQ message */
+	if (param[2] =3D=3D 0)
+		req =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_ID=
,
+				      sizeof(struct mm_set_wakeup_info_req));
+	else
+		req =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_ID=
,
+				      sizeof(struct mm_set_wakeup_info_req) + 2 * param[2]);
+
+	if (!req)
+		return -ENOMEM;
+	memset(req, 0, sizeof(struct mm_set_wakeup_info_req));
+
+	req->hwconfig_id =3D WAKEUP_INFO_REQ;
+	req->code =3D (u16_l)param[0];
+	req->offset =3D (u16_l)param[1];
+	req->length =3D (u16_l)param[2];
+	total_len =3D (u16_l)param[pt_start + 2 * req->length];
+	//AICWFDBG(LOGDEBUG, "total_len: 0x%x\n", total_len);
+	if (total_len > 0)
+		req->length_win =3D total_len - req->length + 1;
+	AICWFDBG(LOGINFO,
+		 "wakeup_info: id: 0x%x, offset: 0x%x, length: 0x%x, length_win: 0x%x, t=
otal_len: 0x%x\n",
+		 req->code, req->offset, req->length, req->length_win, total_len);
+	// AICWFDBG(LOGINFO, "set_wakeup_info_req mask and pattern: 0x%x\n", 2 * =
req->length);
+	for (i =3D 0; i < 2 * req->length; i++) {
+		req->mask_and_pattern[i] =3D param[pt_start + i];
+		// AICWFDBG(LOGINFO, "0x%x: 0x%02x ", i, req->mask_and_pattern[i]);
+	}
+
+	/* Send the MM_SET_VENDOR_HWCONFIG_CFM  message to UMAC FW */
+	err =3D rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+	if (err) {
+		AICWFDBG(LOGINFO, "%s msg_fail\n", __func__);
+		return err;
+	}
+
+	return err;
+}
+
+int rwnx_send_del_pkt_filter_req(struct rwnx_hw *rwnx_hw, u16_l code)
+{
+	struct mm_set_wakeup_info_req *req;
+	int err;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the WAKEUP_INFO_REQ message */
+	req =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_wakeup_info_req));
+	if (!req)
+		return -ENOMEM;
+
+	req->hwconfig_id =3D WAKEUP_INFO_REQ;
+	req->code =3D code; // 0xffff;
+	req->offset =3D 0x0;
+	req->length =3D 0x0;
+
+	/* Send the MM_SET_VENDOR_HWCONFIG_CFM  message to UMAC FW */
+	err =3D rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+	if (err) {
+		AICWFDBG(LOGINFO, "%s msg_fail\n", __func__);
+		return err;
+	}
+
+	return err;
+}
+
+int rwnx_send_vendor_hwconfig_req(struct rwnx_hw *rwnx_hw, u32_l hwconfig_=
id,
+				  s32_l *param, s32_l *param_out)
+{
+	struct mm_set_acs_txop_req *req0;
+	struct mm_set_channel_access_req *req1;
+	struct mm_set_mac_timescale_req *req2;
+	struct mm_set_cca_threshold_req *req3;
+	struct mm_set_bwmode_req *req4;
+	struct mm_set_ap_ps_level_req *req5 =3D NULL;
+	struct mm_set_customized_freq_req *req6;
+
+	int error =3D 0;
+	int i;
+
+	switch (hwconfig_id) {
+	case ACS_TXOP_REQ:
+		/* Build the ACS_TXOP_REQ message */
+		req0 =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_set_acs_txop_req));
+		if (!req0)
+			return -ENOMEM;
+		req0->hwconfig_id =3D hwconfig_id;
+		req0->txop_be =3D param[0];
+		req0->txop_bk =3D param[1];
+		req0->txop_vi =3D param[2];
+		req0->txop_vo =3D param[3];
+		AICWFDBG(LOGDEBUG, "set_acs_txop_req: be: %x,bk: %x,vi: %x,vo: %x\n", re=
q0->txop_be,
+			 req0->txop_bk, req0->txop_vi, req0->txop_vo);
+		/* Send the MM_SET_VENDOR_HWCONFIG_CFM  message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req0, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+		break;
+
+	case CHANNEL_ACCESS_REQ:
+		/* Build the CHANNEL_ACCESS_REQ message */
+		req1 =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_set_channel_access_req));
+		if (!req1)
+			return -ENOMEM;
+		req1->hwconfig_id =3D hwconfig_id;
+		req1->edca[0] =3D param[0];
+		req1->edca[1] =3D param[1];
+		req1->edca[2] =3D param[2];
+		req1->edca[3] =3D param[3];
+		req1->vif_idx =3D param[4];
+		req1->retry_cnt =3D param[5];
+		req1->rts_en =3D param[6];
+		req1->long_nav_en =3D param[7];
+		req1->cfe_en =3D param[8];
+		req1->rc_retry_cnt[0] =3D param[9];
+		req1->rc_retry_cnt[1] =3D param[10];
+		req1->rc_retry_cnt[2] =3D param[11];
+		req1->ccademod_th =3D param[12];
+		AICWFDBG(LOGDEBUG,
+			 "set_channel_access_req:edca[]=3D %x %x %x %x\nvif_idx: %x, retry_cnt:=
 %x, rts_en: %x, long_nav_en: %x, cfe_en: %x, rc_retry_cnt: %x:%x:%x, ccade=
mod_th =3D %d\n",
+			 req1->edca[0], req1->edca[1], req1->edca[2], req1->edca[3],
+			 req1->vif_idx, req1->retry_cnt, req1->rts_en, req1->long_nav_en,
+			 req1->cfe_en, req1->rc_retry_cnt[0], req1->rc_retry_cnt[1],
+			 req1->rc_retry_cnt[2], req1->ccademod_th);
+		/* Send the MM_SET_VENDOR_HWCONFIG_CFM  message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req1, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+		break;
+
+	case MAC_TIMESCALE_REQ:
+		/* Build the MAC_TIMESCALE_REQ message */
+		req2 =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_set_mac_timescale_req));
+		if (!req2)
+			return -ENOMEM;
+		req2->hwconfig_id =3D hwconfig_id;
+		req2->sifs_a_time =3D param[0];
+		req2->sifs_b_time =3D param[1];
+		req2->slot_time =3D param[2];
+		req2->rx_startdelay_ofdm =3D param[3];
+		req2->rx_startdelay_long =3D param[4];
+		req2->rx_startdelay_short =3D param[5];
+		AICWFDBG(LOGDEBUG,
+			 "set_mac_timescale_req:sifsA_time: %x, sifsB_time: %x, slot_time: %x, =
rx_startdelay ofdm:%x long %x short %x\n",
+			 req2->sifs_a_time, req2->sifs_b_time, req2->slot_time,
+			 req2->rx_startdelay_ofdm, req2->rx_startdelay_long,
+			 req2->rx_startdelay_short);
+		/* Send the MM_SET_VENDOR_HWCONFIG_CFM  message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req2, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+		break;
+
+	case CCA_THRESHOLD_REQ:
+		/* Build the CCA_THRESHOLD_REQ message */
+		req3 =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_set_cca_threshold_req));
+		if (!req3)
+			return -ENOMEM;
+		req3->hwconfig_id =3D hwconfig_id;
+		req3->auto_cca_en =3D param[0];
+		req3->cca20p_rise_th =3D param[1];
+		req3->cca20s_rise_th =3D param[2];
+		req3->cca20p_fall_th =3D param[3];
+		req3->cca20s_fall_th =3D param[4];
+		AICWFDBG(LOGDEBUG,
+			 "cca_threshold_req: auto_cca_en:%d\ncca20p_rise_th =3D %d\ncca20s_rise=
_th =3D %d\ncca20p_fall_th =3D %d\ncca20s_fall_th =3D %d\n",
+			 req3->auto_cca_en, req3->cca20p_rise_th, req3->cca20s_rise_th,
+			 req3->cca20p_fall_th, req3->cca20s_fall_th);
+		/* Send the MM_SET_VENDOR_HWCONFIG_CFM  message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req3, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+		break;
+	case BWMODE_REQ:
+		/* Build the SET_BWMODE_REQ message */
+		req4 =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_set_bwmode_req));
+		if (!req4)
+			return -ENOMEM;
+		req4->hwconfig_id =3D hwconfig_id;
+		req4->bwmode =3D param[0];
+		AICWFDBG(LOGDEBUG, "bwmode :%d\n", req4->bwmode);
+		/* Send the MM_SET_VENDOR_HWCONFIG_CFM  message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req4, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+		break;
+	case CHIP_TEMP_GET_REQ:
+		aic_chip_get_temp(rwnx_hw, param_out);
+		break;
+	case AP_PS_LEVEL_SET_REQ:
+		/*
+		 * AP_PS_CLK_1 =3D 1,  // 3:7 -> active 3, doze 7
+		 * AP_PS_CLK_2,      // 5:5 -> active 5, doze 5
+		 * AP_PS_CLK_3,      // 7:3 -> active 7, doze 3
+		 * AP_PS_CLK_4,      // 8:2 -> active 8, doze 2
+		 * AP_PS_CLK_5,      // 9:1 -> active 9, doze 1
+		 */
+		/* Build the MM_SET_VENDOR_HWCONFIG_REQ message */
+		req5 =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_set_ap_ps_level_req));
+		if (!req5)
+			return -ENOMEM;
+		req5->hwconfig_id =3D hwconfig_id;
+		req5->ap_ps_level =3D param[0];
+
+		/* Send the MM_GET_MAC_ADDR_REQ  message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req5, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+		if (!error)
+			AICWFDBG(LOGDEBUG, "set ap_ps_level=3D%d\n", param[0]);
+		break;
+
+	case CUSTOMIZED_FREQ_REQ:
+		/* Build the CUSTOMIZED_FREQ_REQ message */
+		req6 =3D rwnx_msg_zalloc(MM_SET_VENDOR_HWCONFIG_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_set_customized_freq_req));
+		if (!req6)
+			return -ENOMEM;
+		req5->hwconfig_id =3D hwconfig_id;
+		for (i =3D 0; i < 4; i++) {
+			req6->raw_freq[i] =3D param[i];
+			req6->map_freq[i] =3D param[i + 4];
+		}
+		AICWFDBG(LOGDEBUG,
+			 "customized_freq_req: raw_freq[ %d %d %d %d ], map_freq[ %d %d %d %d]\=
n",
+			 param[0], param[1], param[2], param[3], param[4], param[5],
+			 param[6], param[7]);
+		/* Send the MM_SET_VENDOR_HWCONFIG_CFM  message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req5, 1, MM_SET_VENDOR_HWCONFIG_CFM, NULL);
+
+		break;
+	default:
+		return -ENOMEM;
+	}
+	return error;
+}
+
+int rwnx_send_vendor_swconfig_req(struct rwnx_hw *rwnx_hw, u32_l swconfig_=
id,
+				  s32_l *param_in, s32_l *param_out)
+{
+	struct mm_set_vendor_swconfig_req *req;
+	struct mm_set_vendor_swconfig_cfm cfm =3D {
+		0,
+	};
+	int error;
+
+	req =3D rwnx_msg_zalloc(MM_SET_VENDOR_SWCONFIG_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_vendor_swconfig_req));
+	if (!req)
+		return -ENOMEM;
+	req->swconfig_id =3D swconfig_id;
+
+	switch (swconfig_id) {
+	case BCN_CFG_REQ:
+		/* Build the BCN_CFG_REQ message */
+		req->bcn_cfg_req.tim_bcmc_ignored_enable =3D (bool)param_in[0];
+		AICWFDBG(LOGDEBUG, "bcn_cfg_req: tim_bcmc_ignd=3D%d\n",
+			 req->bcn_cfg_req.tim_bcmc_ignored_enable);
+		/* Send the MM_SET_VENDOR_SWCONFIG_REQ message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, &cfm);
+		if (!error) {
+			param_out[0] =3D (s32_l)cfm.bcn_cfg_cfm.tim_bcmc_ignored_status;
+			AICWFDBG(LOGDEBUG, "status=3D%d\n", cfm.bcn_cfg_cfm.tim_bcmc_ignored_st=
atus);
+		}
+		break;
+
+	case TEMP_COMP_SET_REQ:
+		/* Build the TEMP_COMP_SET_REQ message */
+		req->temp_comp_set_req.enable =3D (u8_l)param_in[0];
+		req->temp_comp_set_req.tmr_period_ms =3D (u32_l)param_in[1];
+		AICWFDBG(LOGDEBUG, "temp_comp_set_req: en=3D%d, tmr=3D%x\n",
+			 req->temp_comp_set_req.enable,
+			 req->temp_comp_set_req.tmr_period_ms);
+		/* Send the MM_SET_VENDOR_SWCONFIG_REQ message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, &cfm);
+		if (!error) {
+			param_out[0] =3D (s32_l)cfm.temp_comp_set_cfm.status;
+			AICWFDBG(LOGDEBUG, "status=3D%d\n", cfm.temp_comp_set_cfm.status);
+		}
+		break;
+
+	case TEMP_COMP_GET_REQ:
+		AICWFDBG(LOGDEBUG, "temp_comp_get_req\n");
+		/* Send the MM_SET_VENDOR_SWCONFIG_REQ message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, &cfm);
+		if (!error) {
+			param_out[0] =3D (s32_l)cfm.temp_comp_get_cfm.status;
+			param_out[1] =3D (s32_l)cfm.temp_comp_get_cfm.degree;
+			AICWFDBG(LOGDEBUG, "status=3D%d, degree=3D%d\n", cfm.temp_comp_get_cfm.=
status,
+				 cfm.temp_comp_get_cfm.degree);
+		}
+		break;
+
+	case EXT_FLAGS_SET_REQ:
+		/* Build the EXT_FLAGS_SET_REQ message */
+		req->ext_flags_set_req.user_flags =3D (u32_l)param_in[0];
+		AICWFDBG(LOGDEBUG, "ext_flags_set_req: flags=3D%x\n",
+			 req->ext_flags_set_req.user_flags);
+		/* Send the MM_SET_VENDOR_SWCONFIG_REQ message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, &cfm);
+		if (!error) {
+			param_out[0] =3D (u32_l)cfm.ext_flags_set_cfm.user_flags;
+			AICWFDBG(LOGDEBUG, "cfm flags=3D%x\n", cfm.ext_flags_set_cfm.user_flags=
);
+		}
+		break;
+
+	case EXT_FLAGS_GET_REQ:
+		/* Build the EXT_FLAGS_GET_REQ message */
+		AICWFDBG(LOGDEBUG, "ext_flags_get_req\n");
+		/* Send the MM_SET_VENDOR_SWCONFIG_REQ message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, &cfm);
+		if (!error) {
+			param_out[0] =3D (u32_l)cfm.ext_flags_get_cfm.user_flags;
+			AICWFDBG(LOGDEBUG, "cfm flags=3D%x\n", cfm.ext_flags_get_cfm.user_flags=
);
+		}
+		break;
+
+	case EXT_FLAGS_MASK_SET_REQ:
+		/* Build the EXT_FLAGS_MASK_SET_REQ message */
+		req->ext_flags_mask_set_req.user_flags_mask =3D (u32_l)param_in[0];
+		req->ext_flags_mask_set_req.user_flags_val =3D (u32_l)param_in[1];
+		AICWFDBG(LOGDEBUG, "ext_flags_mask_set_req: flags mask=3D0x%x, val=3D0x%=
x\n",
+			 req->ext_flags_mask_set_req.user_flags_mask,
+			 req->ext_flags_mask_set_req.user_flags_val);
+		/* Send the MM_SET_VENDOR_SWCONFIG_REQ message to UMAC FW */
+		error =3D
+			rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, &cfm);
+		if (!error) {
+			param_out[0] =3D (u32_l)cfm.ext_flags_mask_set_cfm.user_flags;
+			AICWFDBG(LOGDEBUG, "cfm flags=3D%x\n", cfm.ext_flags_mask_set_cfm.user_=
flags);
+		}
+		break;
+
+	default:
+		error =3D -ENOMEM;
+		break;
+	}
+
+	return error;
+}
+
+int rwnx_send_mask_set_ext_flags_req(struct rwnx_hw *rwnx_hw,
+				     u32_l flags_mask, u32_l flags_val,
+				     struct mm_set_vendor_swconfig_cfm *cfm)
+{
+	struct mm_set_vendor_swconfig_req *req;
+	int ret;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+	/* Build the REQ message */
+	req =3D rwnx_msg_zalloc(MM_SET_VENDOR_SWCONFIG_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_set_vendor_swconfig_req));
+	if (!req) {
+		AICWFDBG(LOGERROR, "%s msg_alloc fail\n", __func__);
+		return -ENOMEM;
+	}
+	req->swconfig_id =3D EXT_FLAGS_MASK_SET_REQ;
+	req->ext_flags_mask_set_req.user_flags_mask =3D (u32_l)flags_mask;
+	req->ext_flags_mask_set_req.user_flags_val =3D (u32_l)flags_val;
+
+	ret =3D rwnx_send_msg(rwnx_hw, req, 1, MM_SET_VENDOR_SWCONFIG_CFM, cfm);
+	if (!ret) {
+		AICWFDBG(LOGINFO, "curr ext_flags=3D%x\n",
+			 cfm->ext_flags_mask_set_cfm.user_flags);
+	} else {
+		AICWFDBG(LOGERROR, "%s send_msg_fail\n", __func__);
+		return ret;
+	}
+	return ret;
+}
+
+#ifdef CONFIG_SDIO_BT
+int rwnx_sdio_bt_send_req(struct rwnx_hw *rwnx_hw, uint32_t len,
+			  struct sk_buff *skb)
+{
+	struct mm_bt_send_req *req;
+	struct mm_bt_send_cfm cfm;
+	int error;
+
+	cfm.status =3D 0;
+	req =3D rwnx_msg_zalloc(TDLS_SDIO_BT_SEND_REQ, TASK_TDLS, DRV_TASK_ID,
+			      sizeof(struct mm_bt_send_req));
+
+	if (!req)
+		return -ENOMEM;
+
+	req->data_len =3D len;
+	memcpy(req->bt_data, skb->data, len);
+
+	error =3D rwnx_send_msg(rwnx_hw, req, 1, TDLS_SDIO_BT_SEND_CFM, &cfm);
+	if (!cfm.status)
+		AICWFDBG(LOGDEBUG, "bt send no cfm");
+
+	return error;
+}
+#endif
+
+int rwnx_send_get_fw_version_req(struct rwnx_hw *rwnx_hw,
+				 struct mm_get_fw_version_cfm *cfm)
+{
+	void *req;
+	int error;
+
+	/* Build the MM_GET_FW_VERSION_REQ message */
+	req =3D rwnx_msg_zalloc(MM_GET_FW_VERSION_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(u8));
+
+	if (!req)
+		return -ENOMEM;
+
+	/* Send the MM_GET_FW_VERSION_REQ  message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, req, 1, MM_GET_FW_VERSION_CFM, cfm);
+
+	return error;
+}
+
+int rwnx_send_txpwr_lvl_req(struct rwnx_hw *rwnx_hw)
+{
+	struct mm_set_txpwr_lvl_req *txpwr_lvl_req;
+	struct txpwr_lvl_conf_v2 txpwr_lvl_v2_tmp;
+	struct txpwr_lvl_conf_v2 *txpwr_lvl_v2;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_TXPWR_LVL_REQ message */
+	txpwr_lvl_req =3D
+		rwnx_msg_zalloc(MM_SET_TXPWR_IDX_LVL_REQ, TASK_MM, DRV_TASK_ID,
+				sizeof(struct mm_set_txpwr_lvl_req));
+
+	if (!txpwr_lvl_req)
+		return -ENOMEM;
+
+	txpwr_lvl_v2 =3D &txpwr_lvl_v2_tmp;
+
+	get_userconfig_txpwr_lvl_v2_in_fdrv(txpwr_lvl_v2);
+
+	if (txpwr_lvl_v2->enable =3D=3D 0) {
+		rwnx_msg_free(rwnx_hw, txpwr_lvl_req);
+		return 0;
+	}
+
+	AICWFDBG(LOGINFO, "%s:enable:%d\r\n", __func__, txpwr_lvl_v2->enable);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_1m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[0]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_2m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[1]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_5m5_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[2]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_11m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[3]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_6m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[4]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_9m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[5]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_12m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[6]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_18m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[7]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_24m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[8]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_36m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[9]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_48m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[10]);
+	AICWFDBG(LOGINFO, "%s:lvl_11b_11ag_54m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[11]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs0_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[0]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs1_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[1]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs2_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[2]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs3_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[3]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs4_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[4]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs5_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[5]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs6_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[6]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs7_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[7]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs8_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[8]);
+	AICWFDBG(LOGINFO, "%s:lvl_11n_11ac_mcs9_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[9]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs0_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[0]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs1_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[1]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs2_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[2]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs3_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[3]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs4_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[4]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs5_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[5]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs6_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[6]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs7_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[7]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs8_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[8]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs9_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[9]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs10_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[10]);
+	AICWFDBG(LOGINFO, "%s:lvl_11ax_mcs11_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[11]);
+
+	if (rwnx_hw->testmode =3D=3D 0 && chip_sub_id =3D=3D 0) {
+		txpwr_lvl_req->txpwr_lvl.enable =3D txpwr_lvl_v2->enable;
+		txpwr_lvl_req->txpwr_lvl.dsss =3D
+			txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[3]; // 11M
+		txpwr_lvl_req->txpwr_lvl.ofdmlowrate_2g4 =3D
+			txpwr_lvl_v2->pwrlvl_11ax_2g4[4]; // MCS4
+		txpwr_lvl_req->txpwr_lvl.ofdm64qam_2g4 =3D
+			txpwr_lvl_v2->pwrlvl_11ax_2g4[7]; // MCS7
+		txpwr_lvl_req->txpwr_lvl.ofdm256qam_2g4 =3D
+			txpwr_lvl_v2->pwrlvl_11ax_2g4[9]; // MCS9
+		txpwr_lvl_req->txpwr_lvl.ofdm1024qam_2g4 =3D
+			txpwr_lvl_v2->pwrlvl_11ax_2g4[11];        // MCS11
+		txpwr_lvl_req->txpwr_lvl.ofdmlowrate_5g =3D 13; // unused
+		txpwr_lvl_req->txpwr_lvl.ofdm64qam_5g =3D 13;   // unused
+		txpwr_lvl_req->txpwr_lvl.ofdm256qam_5g =3D 13;  // unused
+		txpwr_lvl_req->txpwr_lvl.ofdm1024qam_5g =3D 13; // unused
+	} else {
+		txpwr_lvl_req->txpwr_lvl_v2 =3D *txpwr_lvl_v2;
+	}
+
+	/* Send the MM_SET_TXPWR_LVL_REQ message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, txpwr_lvl_req, 1,
+			      MM_SET_TXPWR_IDX_LVL_CFM, NULL);
+
+	return error;
+}
+
+int rwnx_send_txpwr_lvl_v3_req(struct rwnx_hw *rwnx_hw, int index_reg)
+{
+	struct mm_set_txpwr_lvl_req *txpwr_lvl_req;
+	struct txpwr_lvl_conf_v3 txpwr_lvl_v3_tmp;
+	struct txpwr_lvl_conf_v3 *txpwr_lvl_v3;
+	struct txpwr_loss_conf txpwr_loss_tmp;
+	struct txpwr_loss_conf *txpwr_loss;
+	int error;
+	int i;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_TXPWR_LVL_REQ message */
+	txpwr_lvl_req =3D
+		rwnx_msg_zalloc(MM_SET_TXPWR_IDX_LVL_REQ, TASK_MM, DRV_TASK_ID,
+				sizeof(struct mm_set_txpwr_lvl_req));
+
+	if (!txpwr_lvl_req)
+		return -ENOMEM;
+
+	txpwr_lvl_v3 =3D &txpwr_lvl_v3_tmp;
+	txpwr_loss =3D &txpwr_loss_tmp;
+	txpwr_loss->loss_enable_2g4 =3D 0;
+	txpwr_loss->loss_enable_5g =3D 0;
+
+	//get_userconfig_txpwr_lvl_v3_in_fdrv(txpwr_lvl_v3);
+	get_userconfig_txpwr_lvl_group_in_fdrv(txpwr_lvl_v3, index_reg);
+	get_userconfig_txpwr_loss(txpwr_loss);
+
+	if (txpwr_loss->loss_enable_2g4 =3D=3D 1) {
+		AICWFDBG(LOGINFO, "%s:loss_value_2g4: %d\r\n", __func__,
+			 txpwr_loss->loss_value_2g4);
+
+		for (i =3D 0; i <=3D 11; i++)
+			txpwr_lvl_v3->pwrlvl_11b_11ag_2g4[i] -=3D txpwr_loss->loss_value_2g4;
+		for (i =3D 0; i <=3D 9; i++)
+			txpwr_lvl_v3->pwrlvl_11n_11ac_2g4[i] -=3D txpwr_loss->loss_value_2g4;
+		for (i =3D 0; i <=3D 11; i++)
+			txpwr_lvl_v3->pwrlvl_11ax_2g4[i] -=3D txpwr_loss->loss_value_2g4;
+	}
+
+	if (txpwr_loss->loss_enable_5g =3D=3D 1) {
+		AICWFDBG(LOGINFO, "%s:loss_value_5g: %d\r\n", __func__,
+			 txpwr_loss->loss_value_5g);
+
+		for (i =3D 0; i <=3D 11; i++)
+			txpwr_lvl_v3->pwrlvl_11a_5g[i] -=3D txpwr_loss->loss_value_5g;
+		for (i =3D 0; i <=3D 9; i++)
+			txpwr_lvl_v3->pwrlvl_11n_11ac_5g[i] -=3D txpwr_loss->loss_value_5g;
+		for (i =3D 0; i <=3D 11; i++)
+			txpwr_lvl_v3->pwrlvl_11ax_5g[i] -=3D txpwr_loss->loss_value_5g;
+	}
+
+	if (txpwr_lvl_v3->enable =3D=3D 0) {
+		rwnx_msg_free(rwnx_hw, txpwr_lvl_req);
+		return 0;
+	}
+
+	AICWFDBG(LOGDEBUG, "%s: dump\n", __func__);
+	AICWFDBG(LOGDEBUG, "txpwr_lvl_v3->enable: %d\r\n", txpwr_lvl_v3->enable);
+	AICWFDBG(LOGDEBUG, "lvl_11b_11ag_1m_2g4:%d\r\n",
+		 txpwr_lvl_v3->pwrlvl_11b_11ag_2g4[0]);
+
+	txpwr_lvl_req->txpwr_lvl_v3 =3D *txpwr_lvl_v3;
+
+	/* Send the MM_SET_TXPWR_LVL_REQ message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, txpwr_lvl_req, 1,
+			      MM_SET_TXPWR_IDX_LVL_CFM, NULL);
+
+	return error;
+}
+
+int rwnx_send_txpwr_lvl_adj_req(struct rwnx_hw *rwnx_hw)
+{
+	struct mm_set_txpwr_lvl_adj_req *txpwr_lvl_adj_req;
+	struct txpwr_lvl_adj_conf txpwr_lvl_adj_tmp;
+	struct txpwr_lvl_adj_conf *txpwr_lvl_adj;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_TXPWR_LVL_REQ message */
+	txpwr_lvl_adj_req =3D
+		rwnx_msg_zalloc(MM_SET_TXPWR_LVL_ADJ_REQ, TASK_MM, DRV_TASK_ID,
+				sizeof(struct mm_set_txpwr_lvl_adj_req));
+
+	if (!txpwr_lvl_adj_req)
+		return -ENOMEM;
+
+	txpwr_lvl_adj =3D &txpwr_lvl_adj_tmp;
+
+	get_userconfig_txpwr_lvl_adj_in_fdrv(txpwr_lvl_adj);
+
+	if (txpwr_lvl_adj->enable =3D=3D 0) {
+		rwnx_msg_free(rwnx_hw, txpwr_lvl_adj_req);
+		return 0;
+	}
+
+	AICWFDBG(LOGINFO, "%s:enable:%d\r\n", __func__, txpwr_lvl_adj->enable);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_2g4_chan_1_4:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_2g4[0]);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_2g4_chan_5_9:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_2g4[1]);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_2g4_chan_10_13:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_2g4[2]);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_5g_chan_42:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_5g[0]);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_5g_chan_58:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_5g[1]);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_5g_chan_106:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_5g[2]);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_5g_chan_122:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_5g[3]);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_5g_chan_138:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_5g[4]);
+	AICWFDBG(LOGINFO, "%s:lvl_adj_5g_chan_155:%d\r\n", __func__,
+		 txpwr_lvl_adj->pwrlvl_adj_tbl_5g[5]);
+
+	txpwr_lvl_adj_req->txpwr_lvl_adj =3D *txpwr_lvl_adj;
+
+	/* Send the MM_SET_TXPWR_LVL_REQ message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, txpwr_lvl_adj_req, 1,
+			      MM_SET_TXPWR_LVL_ADJ_CFM, NULL);
+
+	return error;
+}
+
+int rwnx_send_txpwr_idx_req(struct rwnx_hw *rwnx_hw)
+{
+	struct mm_set_txpwr_idx_req *txpwr_idx_req;
+	struct txpwr_idx_conf *txpwr_idx;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_TXPWR_IDX_LVL_REQ message */
+	txpwr_idx_req =3D
+		rwnx_msg_zalloc(MM_SET_TXPWR_IDX_LVL_REQ, TASK_MM, DRV_TASK_ID,
+				sizeof(struct mm_set_txpwr_idx_req));
+
+	if (!txpwr_idx_req)
+		return -ENOMEM;
+
+	txpwr_idx =3D &txpwr_idx_req->txpwr_idx;
+	txpwr_idx->enable =3D 1;
+	txpwr_idx->dsss =3D 9;
+	txpwr_idx->ofdmlowrate_2g4 =3D 8;
+	txpwr_idx->ofdm64qam_2g4 =3D 8;
+	txpwr_idx->ofdm256qam_2g4 =3D 8;
+	txpwr_idx->ofdm1024qam_2g4 =3D 8;
+	txpwr_idx->ofdmlowrate_5g =3D 11;
+	txpwr_idx->ofdm64qam_5g =3D 10;
+	txpwr_idx->ofdm256qam_5g =3D 9;
+	txpwr_idx->ofdm1024qam_5g =3D 9;
+
+	get_userconfig_txpwr_idx(txpwr_idx);
+
+	if (txpwr_idx->enable =3D=3D 0) {
+		rwnx_msg_free(rwnx_hw, txpwr_idx_req);
+		return 0;
+	}
+	/* Send the MM_SET_TXPWR_IDX_LVL_REQ message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, txpwr_idx_req, 1,
+			      MM_SET_TXPWR_IDX_LVL_CFM, NULL);
+
+	return error;
+};
+
+int rwnx_send_txpwr_ofst_req(struct rwnx_hw *rwnx_hw)
+{
+	struct mm_set_txpwr_ofst_req *txpwr_ofst_req;
+	struct txpwr_ofst_conf *txpwr_ofst;
+	int error;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_TXPWR_OFST_REQ message */
+	txpwr_ofst_req =3D
+		rwnx_msg_zalloc(MM_SET_TXPWR_OFST_REQ, TASK_MM, DRV_TASK_ID,
+				sizeof(struct mm_set_txpwr_ofst_req));
+
+	if (!txpwr_ofst_req)
+		return -ENOMEM;
+
+	txpwr_ofst =3D &txpwr_ofst_req->txpwr_ofst;
+	txpwr_ofst->enable =3D 1;
+	txpwr_ofst->chan_1_4 =3D 0;
+	txpwr_ofst->chan_5_9 =3D 0;
+	txpwr_ofst->chan_10_13 =3D 0;
+	txpwr_ofst->chan_36_64 =3D 0;
+	txpwr_ofst->chan_100_120 =3D 0;
+	txpwr_ofst->chan_122_140 =3D 0;
+	txpwr_ofst->chan_142_165 =3D 0;
+
+	aic_chip_get_userconfig_txpwr_ofst(rwnx_hw, txpwr_ofst);
+
+	if (txpwr_ofst->enable =3D=3D 0) {
+		rwnx_msg_free(rwnx_hw, txpwr_ofst_req);
+		return 0;
+	}
+	/* Send the MM_SET_TXPWR_OFST_REQ message to UMAC FW */
+	error =3D rwnx_send_msg(rwnx_hw, txpwr_ofst_req, 1, MM_SET_TXPWR_OFST_CFM=
,
+			      NULL);
+
+	return error;
+};
+
+int rwnx_send_txpwr_ofst2x_req(struct rwnx_hw *rwnx_hw)
+{
+	struct mm_set_txpwr_ofst_req *txpwr_ofst_req;
+	struct txpwr_ofst2x_conf *txpwr_ofst2x;
+	int error =3D 0;
+	int type, ch_grp;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_SET_TXPWR_OFST_REQ message */
+	txpwr_ofst_req =3D
+		rwnx_msg_zalloc(MM_SET_TXPWR_OFST_REQ, TASK_MM, DRV_TASK_ID,
+				sizeof(struct mm_set_txpwr_ofst_req));
+
+	if (!txpwr_ofst_req)
+		return -ENOMEM;
+
+	txpwr_ofst2x =3D &txpwr_ofst_req->txpwr_ofst2x;
+	txpwr_ofst2x->enable =3D 0;
+	for (type =3D 0; type < 3; type++) {
+		for (ch_grp =3D 0; ch_grp < 6; ch_grp++) {
+			if (ch_grp < 3)
+				txpwr_ofst2x->pwrofst2x_tbl_2g4[type][ch_grp] =3D 0;
+			txpwr_ofst2x->pwrofst2x_tbl_5g[type][ch_grp] =3D 0;
+		}
+	}
+
+	aic_chip_get_userconfig_txpwr_ofst2x(rwnx_hw, txpwr_ofst2x);
+
+	if (txpwr_ofst2x->enable) {
+		AICWFDBG(LOGINFO, "%s:enable:%d\r\n", __func__, txpwr_ofst2x->enable);
+		AICWFDBG(LOGDEBUG,
+			 "pwrofst2x 2.4g: [0]:11b, [1]:ofdm_highrate, [2]:ofdm_lowrate\n  chan=
=3D\t1-4\t5-9\t10-13");
+		for (type =3D 0; type < 3; type++) {
+			AICWFDBG(LOGDEBUG, "\n  [%d] =3D", type);
+			for (ch_grp =3D 0; ch_grp < 3; ch_grp++) {
+				AICWFDBG(LOGDEBUG, "\t%d",
+					 txpwr_ofst2x->pwrofst2x_tbl_2g4[type][ch_grp]);
+			}
+		}
+		AICWFDBG(LOGDEBUG,
+			 "\npwrofst2x 5g: [0]:ofdm_lowrate, [1]:ofdm_highrate, [2]:ofdm_midrate=
\n  chan=3D\t36-50\t51-64\t98-114\t115-130\t131-146\t147-166");
+		for (type =3D 0; type < 3; type++) {
+			AICWFDBG(LOGDEBUG, "\n  [%d] =3D", type);
+			for (ch_grp =3D 0; ch_grp < 6; ch_grp++)
+				AICWFDBG(LOGDEBUG, "\t%d",
+					 txpwr_ofst2x->pwrofst2x_tbl_5g[type][ch_grp]);
+		}
+		AICWFDBG(LOGDEBUG, "\n");
+
+		/* Send the MM_SET_TXPWR_OFST_REQ message to UMAC FW */
+		error =3D rwnx_send_msg(rwnx_hw, txpwr_ofst_req, 1, MM_SET_TXPWR_OFST_CF=
M,
+				      NULL);
+	} else {
+		AICWFDBG(LOGDEBUG, "%s:Do not use txpwr_ofst2x\r\n", __func__);
+		rwnx_msg_free(rwnx_hw, txpwr_ofst_req);
+	}
+
+	return error;
+}
+
+/*************************************************************************=
*****
+ *    Control messages handling functions (FULLMAC only)
+ *************************************************************************=
****/
+#ifdef CONFIG_RWNX_FULLMAC
+#ifdef CONFIG_AIC8800_HE_FOR_OLD_KERNEL
+extern struct ieee80211_sband_iftype_data rwnx_he_capa;
+#endif
+#ifdef CONFIG_AIC8800_VHT_FOR_OLD_KERNEL
+static struct ieee80211_sta_vht_cap *rwnx_vht_capa;
+#endif
+int rwnx_send_me_config_req(struct rwnx_hw *rwnx_hw)
+{
+	struct me_config_req *req;
+	struct wiphy *wiphy =3D rwnx_hw->wiphy;
+	struct ieee80211_sta_ht_cap *ht_cap;
+	struct ieee80211_sta_vht_cap *vht_cap;
+	struct ieee80211_sta_he_cap const *he_cap =3D NULL;
+
+	u8_l *ht_mcs;
+	int i;
+
+	if (rwnx_hw->chip_ops->use_80_bandwidth)
+		rwnx_hw->mod_params->use_80 =3D true;
+
+	if (rwnx_hw->band_5g_support) {
+		ht_cap =3D &wiphy->bands[NL80211_BAND_5GHZ]->ht_cap;
+		vht_cap =3D &wiphy->bands[NL80211_BAND_5GHZ]->vht_cap;
+	} else {
+		ht_cap =3D &wiphy->bands[NL80211_BAND_2GHZ]->ht_cap;
+		vht_cap =3D &wiphy->bands[NL80211_BAND_2GHZ]->vht_cap;
+	}
+#ifdef CONFIG_AIC8800_VHT_FOR_OLD_KERNEL
+	rwnx_vht_capa =3D vht_cap;
+#endif
+
+	ht_mcs =3D (u8_l *)&ht_cap->mcs;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ME_CONFIG_REQ message */
+	req =3D rwnx_msg_zalloc(ME_CONFIG_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_config_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the ME_CONFIG_REQ message */
+	req->ht_supp =3D ht_cap->ht_supported;
+	req->vht_supp =3D vht_cap->vht_supported;
+	req->ht_cap.ht_capa_info =3D
+		cpu_to_le16(ht_cap->cap | IEEE80211_HT_CAP_LDPC_CODING);
+	req->ht_cap.a_mpdu_param =3D
+		ht_cap->ampdu_factor |
+		(ht_cap->ampdu_density << IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+	for (i =3D 0; i < sizeof(ht_cap->mcs); i++)
+		req->ht_cap.mcs_rate[i] =3D ht_mcs[i];
+	req->ht_cap.ht_extended_capa =3D 0;
+	req->ht_cap.tx_beamforming_capa =3D 0;
+	req->ht_cap.asel_capa =3D 0;
+
+	if (req->vht_supp) {
+		req->vht_cap.vht_capa_info =3D cpu_to_le32(vht_cap->cap);
+		req->vht_cap.rx_highest =3D cpu_to_le16(vht_cap->vht_mcs.rx_highest);
+		req->vht_cap.rx_mcs_map =3D cpu_to_le16(vht_cap->vht_mcs.rx_mcs_map);
+		req->vht_cap.tx_highest =3D cpu_to_le16(vht_cap->vht_mcs.tx_highest);
+		req->vht_cap.tx_mcs_map =3D cpu_to_le16(vht_cap->vht_mcs.tx_mcs_map);
+	}
+
+	if (wiphy->bands[NL80211_BAND_2GHZ]->iftype_data) {
+		he_cap =3D &wiphy->bands[NL80211_BAND_2GHZ]->iftype_data->he_cap;
+#if defined(CONFIG_AIC8800_HE_FOR_OLD_KERNEL)
+		he_cap =3D &rwnx_he_capa.he_cap;
+#endif
+		req->he_supp =3D he_cap->has_he;
+		for (i =3D 0; i < ARRAY_SIZE(he_cap->he_cap_elem.mac_cap_info); i++)
+			req->he_cap.mac_cap_info[i] =3D he_cap->he_cap_elem.mac_cap_info[i];
+
+		for (i =3D 0; i < ARRAY_SIZE(he_cap->he_cap_elem.phy_cap_info); i++)
+			req->he_cap.phy_cap_info[i] =3D he_cap->he_cap_elem.phy_cap_info[i];
+
+		req->he_cap.mcs_supp.rx_mcs_80 =3D
+			cpu_to_le16(he_cap->he_mcs_nss_supp.rx_mcs_80);
+		req->he_cap.mcs_supp.tx_mcs_80 =3D
+			cpu_to_le16(he_cap->he_mcs_nss_supp.tx_mcs_80);
+		req->he_cap.mcs_supp.rx_mcs_160 =3D
+			cpu_to_le16(he_cap->he_mcs_nss_supp.rx_mcs_160);
+		req->he_cap.mcs_supp.tx_mcs_160 =3D
+			cpu_to_le16(he_cap->he_mcs_nss_supp.tx_mcs_160);
+		req->he_cap.mcs_supp.rx_mcs_80p80 =3D
+			cpu_to_le16(he_cap->he_mcs_nss_supp.rx_mcs_80p80);
+		req->he_cap.mcs_supp.tx_mcs_80p80 =3D
+			cpu_to_le16(he_cap->he_mcs_nss_supp.tx_mcs_80p80);
+		for (i =3D 0; i < MAC_HE_PPE_THRES_MAX_LEN; i++)
+			req->he_cap.ppe_thres[i] =3D he_cap->ppe_thres[i];
+
+		req->he_ul_on =3D rwnx_hw->mod_params->he_ul_on;
+	}
+	req->ps_on =3D rwnx_hw->mod_params->ps_on;
+	req->dpsm =3D rwnx_hw->mod_params->dpsm;
+	req->tx_lft =3D rwnx_hw->mod_params->tx_lft;
+	req->ant_div_on =3D rwnx_hw->mod_params->ant_div;
+	if (rwnx_hw->mod_params->use_80)
+		req->phy_bw_max =3D PHY_CHNL_BW_80;
+	else if (rwnx_hw->mod_params->use_2040)
+		req->phy_bw_max =3D PHY_CHNL_BW_40;
+	else
+		req->phy_bw_max =3D PHY_CHNL_BW_20;
+
+	wiphy_info(wiphy, "AICWF HT supp %d, VHT supp %d, HE supp %d\n", req->ht_=
supp,
+		   req->vht_supp, req->he_supp);
+	/* Send the ME_CONFIG_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_CONFIG_CFM, NULL);
+}
+
+int rwnx_send_me_chan_config_req(struct rwnx_hw *rwnx_hw)
+{
+	struct me_chan_config_req *req;
+	struct wiphy *wiphy =3D rwnx_hw->wiphy;
+	int i;
+	u8_l enable =3D 0;
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+	s8_l max_pwr;
+	struct txpwr_loss_conf txpwr_loss_tmp;
+	struct txpwr_loss_conf *txpwr_loss;
+#endif
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ME_CHAN_CONFIG_REQ message */
+	req =3D rwnx_msg_zalloc(ME_CHAN_CONFIG_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_chan_config_req));
+	if (!req)
+		return -ENOMEM;
+
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+	txpwr_loss =3D &txpwr_loss_tmp;
+	get_userconfig_txpwr_loss(txpwr_loss);
+
+	if (txpwr_loss->loss_enable_2g4 =3D=3D 1)
+		AICWFDBG(LOGINFO, "%s:loss_value_2g4: %d\r\n", __func__,
+			 txpwr_loss->loss_value_2g4);
+	if (txpwr_loss->loss_enable_5g =3D=3D 1)
+		AICWFDBG(LOGINFO, "%s:loss_value_5g: %d\r\n", __func__,
+			 txpwr_loss->loss_value_5g);
+#endif
+
+	req->chan2G4_cnt =3D 0;
+	if (wiphy->bands[NL80211_BAND_2GHZ]) {
+		struct ieee80211_supported_band *b =3D wiphy->bands[NL80211_BAND_2GHZ];
+
+		for (i =3D 0; i < b->n_channels; i++) {
+			req->chan2G4[req->chan2G4_cnt].flags =3D 0;
+
+			if (b->channels[i].flags & IEEE80211_CHAN_DISABLED)
+				req->chan2G4[req->chan2G4_cnt].flags |=3D CHAN_DISABLED;
+			req->chan2G4[req->chan2G4_cnt].flags |=3D
+				get_chan_flags(b->channels[i].flags);
+			req->chan2G4[req->chan2G4_cnt].band =3D NL80211_BAND_2GHZ;
+			req->chan2G4[req->chan2G4_cnt].freq =3D b->channels[i].center_freq;
+			req->chan2G4[req->chan2G4_cnt].tx_power =3D
+				chan_to_fw_pwr(b->channels[i].max_power);
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+			max_pwr =3D get_powerlimit_by_freq(PHY_BAND_2G4,
+							 req->chan2G4[req->chan2G4_cnt].freq,
+							 &enable);
+			if (txpwr_loss->loss_enable_2g4 =3D=3D 1)
+				max_pwr -=3D txpwr_loss->loss_value_2g4;
+			if (enable) {
+				if (req->chan2G4[req->chan2G4_cnt].tx_power > max_pwr)
+					req->chan2G4[req->chan2G4_cnt].tx_power =3D max_pwr;
+			}
+#endif
+			req->chan2G4_cnt++;
+			if (req->chan2G4_cnt =3D=3D MAC_DOMAINCHANNEL_24G_MAX)
+				break;
+		}
+	}
+
+	req->chan5G_cnt =3D 0;
+	if (wiphy->bands[NL80211_BAND_5GHZ]) {
+		struct ieee80211_supported_band *b =3D wiphy->bands[NL80211_BAND_5GHZ];
+
+		for (i =3D 0; i < b->n_channels; i++) {
+			req->chan5G[req->chan5G_cnt].flags =3D 0;
+			if (b->channels[i].flags & IEEE80211_CHAN_DISABLED)
+				req->chan5G[req->chan5G_cnt].flags |=3D CHAN_DISABLED;
+			req->chan5G[req->chan5G_cnt].flags |=3D
+				get_chan_flags(b->channels[i].flags);
+			req->chan5G[req->chan5G_cnt].band =3D NL80211_BAND_5GHZ;
+			req->chan5G[req->chan5G_cnt].freq =3D b->channels[i].center_freq;
+			req->chan5G[req->chan5G_cnt].tx_power =3D
+				chan_to_fw_pwr(b->channels[i].max_power);
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+			max_pwr =3D get_powerlimit_by_freq(PHY_BAND_5G,
+							 req->chan5G[req->chan5G_cnt].freq,
+							 &enable);
+			if (txpwr_loss->loss_enable_5g =3D=3D 1)
+				max_pwr -=3D txpwr_loss->loss_value_5g;
+			if (enable) {
+				if (req->chan5G[req->chan5G_cnt].tx_power > max_pwr)
+					req->chan5G[req->chan5G_cnt].tx_power =3D max_pwr;
+			}
+#endif
+			req->chan5G_cnt++;
+			if (req->chan5G_cnt =3D=3D MAC_DOMAINCHANNEL_5G_MAX)
+				break;
+		}
+	}
+
+	/* Send the ME_CHAN_CONFIG_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_CHAN_CONFIG_CFM, NULL);
+}
+
+int rwnx_send_me_set_control_port_req(struct rwnx_hw *rwnx_hw, bool opened=
,
+				      u8 sta_idx)
+{
+	struct me_set_control_port_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ME_SET_CONTROL_PORT_REQ message */
+	req =3D rwnx_msg_zalloc(ME_SET_CONTROL_PORT_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_set_control_port_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the ME_SET_CONTROL_PORT_REQ message */
+	req->sta_idx =3D sta_idx;
+	req->control_port_open =3D opened;
+
+	/* Send the ME_SET_CONTROL_PORT_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_SET_CONTROL_PORT_CFM, NULL);
+}
+
+int rwnx_send_me_sta_add(struct rwnx_hw *rwnx_hw,
+			 struct station_parameters *params, const u8 *mac,
+			 u8 inst_nbr, struct me_sta_add_cfm *cfm)
+{
+	struct me_sta_add_req *req;
+	struct link_station_parameters *link_sta_params =3D &params->link_sta_par=
ams;
+
+	u8 *ht_mcs =3D (u8 *)&link_sta_params->ht_capa->mcs;
+
+	int i;
+	struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[inst_nbr];
+#if (defined CONFIG_AIC8800_HE_FOR_OLD_KERNEL) || (defined CONFIG_AIC8800_=
VHT_FOR_OLD_KERNEL)
+	struct aic_sta *sta =3D &rwnx_hw->aic_table[rwnx_vif->ap.aic_index];
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+	AICWFDBG(LOGDEBUG, "AICWF assoc_req idx %d, he: %d, vht: %d\n ", rwnx_vif=
->ap.aic_index,
+		 sta->he, sta->vht);
+	if (rwnx_vif->ap.aic_index < NX_REMOTE_STA_MAX + NX_VIRT_DEV_MAX)
+		rwnx_vif->ap.aic_index++;
+	else
+		rwnx_vif->ap.aic_index =3D 0;
+#endif
+
+	/* Build the MM_STA_ADD_REQ message */
+	req =3D rwnx_msg_zalloc(ME_STA_ADD_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_sta_add_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_STA_ADD_REQ message */
+	memcpy(&req->mac_addr.array[0], mac, ETH_ALEN);
+
+	req->rate_set.length =3D link_sta_params->supported_rates_len;
+	for (i =3D 0; i < link_sta_params->supported_rates_len; i++)
+		req->rate_set.array[i] =3D link_sta_params->supported_rates[i];
+
+	req->flags =3D 0;
+	if (link_sta_params->ht_capa) {
+		const struct ieee80211_ht_cap *ht_capa =3D link_sta_params->ht_capa;
+
+		req->flags |=3D STA_HT_CAPA;
+		req->ht_cap.ht_capa_info =3D cpu_to_le16(ht_capa->cap_info);
+		req->ht_cap.a_mpdu_param =3D ht_capa->ampdu_params_info;
+		for (i =3D 0; i < sizeof(ht_capa->mcs); i++)
+			req->ht_cap.mcs_rate[i] =3D ht_mcs[i];
+		req->ht_cap.ht_extended_capa =3D
+			cpu_to_le16(ht_capa->extended_ht_cap_info);
+		req->ht_cap.tx_beamforming_capa =3D cpu_to_le32(ht_capa->tx_BF_cap_info)=
;
+		req->ht_cap.asel_capa =3D ht_capa->antenna_selection_info;
+	}
+
+	if (link_sta_params->vht_capa) {
+		const struct ieee80211_vht_cap *vht_capa =3D link_sta_params->vht_capa;
+
+		req->flags |=3D STA_VHT_CAPA;
+		req->vht_cap.vht_capa_info =3D cpu_to_le32(vht_capa->vht_cap_info);
+		req->vht_cap.rx_highest =3D cpu_to_le16(vht_capa->supp_mcs.rx_highest);
+		req->vht_cap.rx_mcs_map =3D cpu_to_le16(vht_capa->supp_mcs.rx_mcs_map);
+		req->vht_cap.tx_highest =3D cpu_to_le16(vht_capa->supp_mcs.tx_highest);
+		req->vht_cap.tx_mcs_map =3D cpu_to_le16(vht_capa->supp_mcs.tx_mcs_map);
+	}
+
+	if (link_sta_params->he_capa) {
+		const struct ieee80211_he_cap_elem *he_capa =3D link_sta_params->he_capa=
;
+		struct ieee80211_he_mcs_nss_supp *mcs_nss_supp =3D
+			(struct ieee80211_he_mcs_nss_supp *)(he_capa + 1);
+
+		req->flags |=3D STA_HE_CAPA;
+		for (i =3D 0; i < ARRAY_SIZE(he_capa->mac_cap_info); i++)
+			req->he_cap.mac_cap_info[i] =3D he_capa->mac_cap_info[i];
+		for (i =3D 0; i < ARRAY_SIZE(he_capa->phy_cap_info); i++)
+			req->he_cap.phy_cap_info[i] =3D he_capa->phy_cap_info[i];
+		req->he_cap.mcs_supp.rx_mcs_80 =3D mcs_nss_supp->rx_mcs_80;
+		req->he_cap.mcs_supp.tx_mcs_80 =3D mcs_nss_supp->tx_mcs_80;
+		req->he_cap.mcs_supp.rx_mcs_160 =3D mcs_nss_supp->rx_mcs_160;
+		req->he_cap.mcs_supp.tx_mcs_160 =3D mcs_nss_supp->tx_mcs_160;
+		req->he_cap.mcs_supp.rx_mcs_80p80 =3D mcs_nss_supp->rx_mcs_80p80;
+		req->he_cap.mcs_supp.tx_mcs_80p80 =3D mcs_nss_supp->tx_mcs_80p80;
+	}
+
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_WME))
+		req->flags |=3D STA_QOS_CAPA;
+
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_MFP))
+		req->flags |=3D STA_MFP_CAPA;
+
+	if (link_sta_params->opmode_notif_used) {
+		req->flags |=3D STA_OPMOD_NOTIF;
+		req->opmode =3D link_sta_params->opmode_notif_used;
+	}
+
+	req->aid =3D cpu_to_le16(params->aid);
+	req->uapsd_queues =3D params->uapsd_queues;
+	req->max_sp_len =3D params->max_sp * 2;
+	req->vif_idx =3D inst_nbr;
+
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) {
+		// struct rwnx_vif *rwnx_vif =3D rwnx_hw->vif_table[inst_nbr];
+		req->tdls_sta =3D true;
+		if ((params->ext_capab[3] & WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH) &&
+		    !rwnx_vif->tdls_chsw_prohibited)
+			req->tdls_chsw_allowed =3D true;
+		if (rwnx_vif->tdls_status =3D=3D TDLS_SETUP_RSP_TX)
+			req->tdls_sta_initiator =3D true;
+	}
+
+	/* Send the ME_STA_ADD_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_STA_ADD_CFM, cfm);
+}
+
+int rwnx_send_me_sta_del(struct rwnx_hw *rwnx_hw, u8 sta_idx, bool tdls_st=
a)
+{
+	struct me_sta_del_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_STA_DEL_REQ message */
+	req =3D rwnx_msg_zalloc(ME_STA_DEL_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_sta_del_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_STA_DEL_REQ message */
+	req->sta_idx =3D sta_idx;
+	req->tdls_sta =3D tdls_sta;
+
+	/* Send the ME_STA_DEL_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_STA_DEL_CFM, NULL);
+}
+
+int rwnx_send_me_traffic_ind(struct rwnx_hw *rwnx_hw, u8 sta_idx, bool uap=
sd,
+			     u8 tx_status)
+{
+	struct me_traffic_ind_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ME_UTRAFFIC_IND_REQ message */
+	req =3D rwnx_msg_zalloc(ME_TRAFFIC_IND_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_traffic_ind_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the ME_TRAFFIC_IND_REQ message */
+	req->sta_idx =3D sta_idx;
+	req->tx_avail =3D tx_status;
+	req->uapsd =3D uapsd;
+
+	/* Send the ME_TRAFFIC_IND_REQ to UMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_TRAFFIC_IND_CFM, NULL);
+}
+
+int rwnx_send_me_rc_stats(struct rwnx_hw *rwnx_hw, u8 sta_idx,
+			  struct me_rc_stats_cfm *cfm)
+{
+	struct me_rc_stats_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ME_RC_STATS_REQ message */
+	req =3D rwnx_msg_zalloc(ME_RC_STATS_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_rc_stats_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the ME_RC_STATS_REQ message */
+	req->sta_idx =3D sta_idx;
+
+	/* Send the ME_RC_STATS_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_RC_STATS_CFM, cfm);
+}
+
+int rwnx_send_me_rc_set_rate(struct rwnx_hw *rwnx_hw, u8 sta_idx, u16 rate=
_cfg)
+{
+	struct me_rc_set_rate_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ME_RC_SET_RATE_REQ message */
+	req =3D rwnx_msg_zalloc(ME_RC_SET_RATE_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_rc_set_rate_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the ME_RC_SET_RATE_REQ message */
+	req->sta_idx =3D sta_idx;
+	req->fixed_rate_cfg =3D rate_cfg;
+
+	/* Send the ME_RC_SET_RATE_REQ message to FW */
+	return rwnx_send_msg(rwnx_hw, req, 0, 0, NULL);
+}
+
+int rwnx_send_me_set_ps_mode(struct rwnx_hw *rwnx_hw, u8 ps_mode)
+{
+	struct me_set_ps_mode_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ME_SET_PS_MODE_REQ message */
+	req =3D rwnx_msg_zalloc(ME_SET_PS_MODE_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_set_ps_mode_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the ME_SET_PS_MODE_REQ message */
+	req->ps_state =3D ps_mode;
+
+	/* Send the ME_SET_PS_MODE_REQ message to FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_SET_PS_MODE_CFM, NULL);
+}
+
+int rwnx_send_me_set_lp_level(struct rwnx_hw *rwnx_hw, u8 lp_level, u8 dis=
able_filter)
+{
+	struct me_set_lp_level_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+	AICWFDBG(LOGDEBUG, "lp_lvl: %d %d\n", lp_level, disable_filter);
+	/* Build the ME_SET_LP_LEVEL_REQ message */
+	req =3D rwnx_msg_zalloc(ME_SET_LP_LEVEL_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_set_lp_level_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the ME_SET_LP_LEVEL_REQ message */
+	req->lp_level =3D lp_level;
+	req->disable_filter =3D disable_filter;
+
+	/* Send the ME_SET_LP_LEVEL_REQ message to FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_SET_LP_LEVEL_CFM, NULL);
+}
+
+int rwnx_send_sm_connect_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *rwn=
x_vif,
+			     struct cfg80211_connect_params *sme,
+			     struct sm_connect_cfm *cfm)
+{
+	struct sm_connect_req *req;
+	int i;
+	u32_l flags =3D 0;
+	bool gval =3D false;
+	bool pval =3D false;
+
+	rwnx_vif->wep_enabled =3D false;
+	rwnx_vif->wep_auth_err =3D false;
+	rwnx_vif->last_auth_type =3D 0;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the SM_CONNECT_REQ message */
+	req =3D rwnx_msg_zalloc(SM_CONNECT_REQ, TASK_SM, DRV_TASK_ID,
+			      sizeof(struct sm_connect_req));
+	if (!req)
+		return -ENOMEM;
+
+	if (sme->crypto.cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP40 ||
+	    sme->crypto.cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP104)
+		gval =3D true;
+
+	if (sme->crypto.n_ciphers_pairwise &&
+	    (sme->crypto.ciphers_pairwise[0] =3D=3D WLAN_CIPHER_SUITE_WEP40 ||
+	     sme->crypto.ciphers_pairwise[0] =3D=3D WLAN_CIPHER_SUITE_WEP104))
+		pval =3D true;
+
+	/* Set parameters for the SM_CONNECT_REQ message */
+	if (sme->crypto.n_ciphers_pairwise &&
+	    (sme->crypto.ciphers_pairwise[0] =3D=3D WLAN_CIPHER_SUITE_WEP40 ||
+	     sme->crypto.ciphers_pairwise[0] =3D=3D WLAN_CIPHER_SUITE_TKIP ||
+	     sme->crypto.ciphers_pairwise[0] =3D=3D WLAN_CIPHER_SUITE_WEP104))
+		flags |=3D DISABLE_HT;
+
+	if (sme->crypto.control_port)
+		flags |=3D CONTROL_PORT_HOST;
+
+	if (sme->crypto.control_port_no_encrypt)
+		flags |=3D CONTROL_PORT_NO_ENC;
+
+	if (use_pairwise_key(&sme->crypto))
+		flags |=3D WPA_WPA2_IN_USE;
+
+	if (sme->mfp =3D=3D NL80211_MFP_REQUIRED)
+		flags |=3D MFP_IN_USE;
+
+	if (rwnx_vif->sta.ap)
+		flags |=3D REASSOCIATION;
+
+	req->ctrl_port_ethertype =3D sme->crypto.control_port_ethertype;
+
+	if (sme->bssid)
+		memcpy(&req->bssid, sme->bssid, ETH_ALEN);
+	else
+		req->bssid =3D mac_addr_bcst;
+#ifdef CONFIG_AIC8800_AUTO_CUSTREG
+	if (rwnx_hw->ccode.auto_set) {
+		memcpy(&rwnx_hw->ccode.bssid, &req->bssid, ETH_ALEN);
+		atomic_set(&rwnx_hw->ccode.link_scan, 1);
+	}
+#endif
+	req->vif_idx =3D rwnx_vif->vif_index;
+	if (sme->channel) {
+		req->chan.band =3D sme->channel->band;
+		req->chan.freq =3D sme->channel->center_freq;
+		req->chan.flags =3D get_chan_flags(sme->channel->flags);
+	} else {
+		req->chan.freq =3D (u16_l)-1;
+	}
+	for (i =3D 0; i < sme->ssid_len; i++)
+		req->ssid.array[i] =3D sme->ssid[i];
+	req->ssid.length =3D sme->ssid_len;
+	req->flags =3D flags;
+	if (WARN_ON(sme->ie_len > sizeof(req->ie_buf)))
+		goto invalid_param;
+	if (sme->ie_len)
+		memcpy(req->ie_buf, sme->ie, sme->ie_len);
+	req->ie_len =3D sme->ie_len;
+	req->listen_interval =3D rwnx_mod_params.listen_itv;
+	req->dont_wait_bcmc =3D !rwnx_mod_params.listen_bcmc;
+
+	/* Set auth_type */
+	if (sme->auth_type =3D=3D NL80211_AUTHTYPE_AUTOMATIC)
+		req->auth_type =3D WLAN_AUTH_OPEN;
+	else if (sme->auth_type =3D=3D NL80211_AUTHTYPE_OPEN_SYSTEM)
+		req->auth_type =3D WLAN_AUTH_OPEN;
+	else if (sme->auth_type =3D=3D NL80211_AUTHTYPE_SHARED_KEY)
+		req->auth_type =3D WLAN_AUTH_SHARED_KEY;
+	else if (sme->auth_type =3D=3D NL80211_AUTHTYPE_FT)
+		req->auth_type =3D WLAN_AUTH_FT;
+	else if (sme->auth_type =3D=3D NL80211_AUTHTYPE_SAE)
+		req->auth_type =3D WLAN_AUTH_SAE;
+	else
+		goto invalid_param;
+
+	rwnx_vif->sta.auth_type =3D sme->auth_type;
+
+	/* Set UAPSD queues */
+	req->uapsd_queues =3D rwnx_mod_params.uapsd_queues;
+
+	rwnx_vif->wep_enabled =3D pval & gval;
+
+	if (rwnx_vif->wep_enabled)
+		rwnx_vif->last_auth_type =3D sme->auth_type;
+
+#ifdef CONFIG_AIC8800_USE_WIRELESS_EXT
+	memset(rwnx_hw->wext_essid, 0, 33);
+	memcpy(rwnx_hw->wext_essid, sme->ssid, (int)sme->ssid_len);
+#endif
+
+	rwnx_vif->sta.ssid_len =3D (int)sme->ssid_len;
+	memset(rwnx_vif->sta.ssid, 0, rwnx_vif->sta.ssid_len + 1);
+	memcpy(rwnx_vif->sta.ssid, sme->ssid, rwnx_vif->sta.ssid_len);
+	if (sme->bssid)
+		memcpy(rwnx_vif->sta.bssid, sme->bssid, ETH_ALEN);
+
+	AICWFDBG(LOGDEBUG,
+		 "AICWF %s drv_vif_index:%d connect to %s(%d) channel:%d auth_type:%d\r\=
n",
+		 __func__, rwnx_vif->drv_vif_index, rwnx_vif->sta.ssid,
+		 rwnx_vif->sta.ssid_len, req->chan.freq, req->auth_type);
+
+	/* Send the SM_CONNECT_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, SM_CONNECT_CFM, cfm);
+
+invalid_param:
+	rwnx_msg_free(rwnx_hw, req);
+	return -EINVAL;
+}
+
+int rwnx_send_sm_disconnect_req(struct rwnx_hw *rwnx_hw,
+				struct rwnx_vif *rwnx_vif, u16 reason)
+{
+	struct sm_disconnect_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the SM_DISCONNECT_REQ message */
+	req =3D rwnx_msg_zalloc(SM_DISCONNECT_REQ, TASK_SM, DRV_TASK_ID,
+			      sizeof(struct sm_disconnect_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the SM_DISCONNECT_REQ message */
+	req->reason_code =3D reason;
+	req->vif_idx =3D rwnx_vif->vif_index;
+
+	/* Send the SM_DISCONNECT_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, SM_DISCONNECT_CFM, NULL);
+}
+
+int rwnx_send_sm_external_auth_required_rsp(struct rwnx_hw *rwnx_hw,
+					    struct rwnx_vif *rwnx_vif,
+					    u16 status)
+{
+	struct sm_external_auth_required_rsp *rsp;
+
+	/* Build the SM_EXTERNAL_AUTH_CFM message */
+	rsp =3D rwnx_msg_zalloc(SM_EXTERNAL_AUTH_REQUIRED_RSP, TASK_SM, DRV_TASK_=
ID,
+			      sizeof(struct sm_external_auth_required_rsp));
+	if (!rsp)
+		return -ENOMEM;
+
+	rsp->status =3D status;
+	rsp->vif_idx =3D rwnx_vif->vif_index;
+
+	/* send the SM_EXTERNAL_AUTH_REQUIRED_RSP message UMAC FW */
+	return rwnx_send_msg(rwnx_hw, rsp, 1, SM_EXTERNAL_AUTH_REQUIRED_RSP_CFM,
+			     NULL);
+}
+
+int rwnx_send_apm_start_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif,
+			    struct cfg80211_ap_settings *settings,
+			    struct apm_start_cfm *cfm,
+			    struct rwnx_ipc_elem_var *elem)
+{
+	struct apm_start_req *req;
+	struct rwnx_bcn *bcn =3D &vif->ap.bcn;
+	u8 *buf;
+	u32 flags =3D 0;
+	const u8 *rate_ie;
+	u8 rate_len =3D 0;
+	int var_offset =3D offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	const u8 *var_pos;
+	int len, i;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the APM_START_REQ message */
+	req =3D rwnx_msg_zalloc(APM_START_REQ, TASK_APM, DRV_TASK_ID,
+			      sizeof(struct apm_start_req));
+	if (!req)
+		return -ENOMEM;
+
+	// Build the beacon
+	bcn->dtim =3D (u8)settings->dtim_period;
+	buf =3D rwnx_build_bcn(bcn, &settings->beacon);
+	if (!buf) {
+		rwnx_msg_free(rwnx_hw, req);
+		return -ENOMEM;
+	}
+
+	// Retrieve the basic rate set from the beacon buffer
+	len =3D bcn->len - var_offset;
+	var_pos =3D buf + var_offset;
+
+// Assume that rate higher that 54 Mbps are BSS membership
+
+	rate_ie =3D cfg80211_find_ie(WLAN_EID_SUPP_RATES, var_pos, len);
+	if (rate_ie) {
+		const u8 *rates =3D rate_ie + 2;
+		u8 rate1 =3D 0;
+		bool is_basic1;
+
+		for (i =3D 0; i < rate_ie[1] && rate_len < MAC_RATESET_LEN; i++) {
+			rate1 =3D rates[i];
+			is_basic1 =3D ((rate1 & 0x80) && ((rate1 & ~0x80) <=3D (54 * 2)));
+			if (is_basic1)
+				req->basic_rates.array[rate_len++] =3D rate1;
+		}
+	}
+	rate_ie =3D cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES, var_pos, len);
+	if (rate_ie) {
+		const u8 *rates =3D rate_ie + 2;
+		u8 rate2 =3D 0;
+		bool is_basic2;
+
+		for (i =3D 0; i < rate_ie[1] && rate_len < MAC_RATESET_LEN; i++) {
+			rate2 =3D rates[i];
+			is_basic2 =3D ((rate2 & 0x80) && ((rate2 & ~0x80) <=3D (54 * 2)));
+			if (is_basic2)
+				req->basic_rates.array[rate_len++] =3D rate2;
+		}
+	}
+	req->basic_rates.length =3D rate_len;
+
+	rwnx_send_bcn(rwnx_hw, buf, vif->vif_index, bcn->len);
+
+	/* Set parameters for the APM_START_REQ message */
+	req->vif_idx =3D vif->vif_index;
+	req->bcn_addr =3D elem->dma_addr;
+	req->bcn_len =3D bcn->len;
+	req->tim_oft =3D bcn->head_len;
+	req->tim_len =3D bcn->tim_len;
+	req->chan.band =3D settings->chandef.chan->band;
+	req->chan.freq =3D settings->chandef.chan->center_freq;
+	req->chan.flags =3D 0;
+	req->chan.tx_power =3D chan_to_fw_pwr(settings->chandef.chan->max_power);
+	req->center_freq1 =3D settings->chandef.center_freq1;
+	req->center_freq2 =3D settings->chandef.center_freq2;
+	req->ch_width =3D bw2chnl[settings->chandef.width];
+	req->bcn_int =3D settings->beacon_interval;
+
+	if (settings->crypto.control_port)
+		flags |=3D CONTROL_PORT_HOST;
+
+	if (settings->crypto.control_port_no_encrypt)
+		flags |=3D CONTROL_PORT_NO_ENC;
+
+	if (use_pairwise_key(&settings->crypto))
+		flags |=3D WPA_WPA2_IN_USE;
+
+	if (settings->crypto.control_port_ethertype)
+		req->ctrl_port_ethertype =3D settings->crypto.control_port_ethertype;
+	else
+		req->ctrl_port_ethertype =3D ETH_P_PAE;
+	req->flags =3D flags;
+
+	/* Send the APM_START_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, APM_START_CFM, cfm);
+}
+
+int rwnx_send_apm_stop_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif)
+{
+	struct apm_stop_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the APM_STOP_REQ message */
+	req =3D rwnx_msg_zalloc(APM_STOP_REQ, TASK_APM, DRV_TASK_ID,
+			      sizeof(struct apm_stop_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the APM_STOP_REQ message */
+	req->vif_idx =3D vif->vif_index;
+
+	/* Send the APM_STOP_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, APM_STOP_CFM, NULL);
+}
+
+#define P2P_WILDCARD_SSID     "DIRECT-"
+#define P2P_WILDCARD_SSID_LEN (sizeof(P2P_WILDCARD_SSID) - 1)
+
+#ifdef CONFIG_AIC8800_SET_VENDOR_EXTENSION_IE
+u8_l vendor_extension_data[256];
+u8_l vendor_extension_len;
+
+static void rwnx_insert_vendor_extension_data(struct scanu_vendor_ie_req *=
ie_req)
+{
+	u8_l temp_ie[256];
+	u8_l vendor_extension_subelement[3] =3D {0x00, 0x37, 0x2A};
+	u8_l vendor_extension_id[2] =3D {0x10, 0x49};
+	int index =3D 0;
+	int vendor_extension_subelement_len =3D 0;
+
+	memset(temp_ie, 0, 256);
+
+	// find vendor_extension_subelement
+	for (index =3D 0; index < ie_req->add_ie_len; index++) {
+		if (ie_req->ie[index] =3D=3D vendor_extension_id[0]) {
+			index++;
+			if (index =3D=3D ie_req->add_ie_len)
+				return;
+
+			if (ie_req->ie[index] =3D=3D vendor_extension_id[1] &&
+			    ie_req->ie[index + 3] =3D=3D vendor_extension_subelement[0] &&
+			    ie_req->ie[index + 4] =3D=3D vendor_extension_subelement[1] &&
+			    ie_req->ie[index + 5] =3D=3D vendor_extension_subelement[2]) {
+				index =3D index + 2;
+				vendor_extension_subelement_len =3D ie_req->ie[index];
+				AICWFDBG(LOGDEBUG,
+					 "AICWF %s find vendor_extension_subelement,index:%d len:%d\r\n",
+					 __func__, index, ie_req->ie[index]);
+				break;
+			}
+		}
+	}
+	index =3D index + vendor_extension_subelement_len;
+
+	// insert vendor extension
+	memcpy(&temp_ie[0], ie_req->ie, index + 1);
+	memcpy(&temp_ie[index + 1], vendor_extension_data,
+	       vendor_extension_len /*sizeof(vendor_extension_data) */);
+	memcpy(&temp_ie[index + 1 +
+	       vendor_extension_len /*sizeof(vendor_extension_data) */],
+	       &ie_req->ie[index + 1], ie_req->add_ie_len - index);
+
+	memcpy(ie_req->ie, temp_ie,
+	       ie_req->add_ie_len +
+	       vendor_extension_len /*sizeof(vendor_extension_data) */);
+	ie_req->add_ie_len =3D
+		ie_req->add_ie_len +
+		vendor_extension_len /*sizeof(vendor_extension_data) */;
+	ie_req->ie[1] =3D
+		ie_req->ie[1] + vendor_extension_len /*sizeof(vendor_extension_data) */;
+
+	// rwnx_data_dump((char*)__func__, (void*)ie_req->ie,
+	// ie_req->add_ie_len);
+}
+#endif // CONFIG_AIC8800_SET_VENDOR_EXTENSION_IE
+
+int rwnx_send_scanu_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *rwnx_vif=
,
+			struct cfg80211_scan_request *param)
+{
+	struct scanu_start_req *req =3D NULL;
+	struct scanu_vendor_ie_req *ie_req =3D NULL;
+	struct mm_add_if_cfm add_if_cfm;
+	int i;
+	u8_l chan_flags =3D 0;
+	int err;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the SCANU_START_REQ message */
+	req =3D rwnx_msg_zalloc(SCANU_START_REQ, TASK_SCANU, DRV_TASK_ID,
+			      sizeof(struct scanu_start_req));
+	if (!req)
+		return -ENOMEM;
+
+	rwnx_hw->scanning =3D 1;
+	/* Set parameters */
+	req->vif_idx =3D rwnx_vif->vif_index;
+	req->chan_cnt =3D (u8)min_t(int, SCAN_CHANNEL_MAX, param->n_channels);
+
+#ifdef CONFIG_AIC8800_AUTO_CUSTREG
+	if (rwnx_hw->ccode.ccode_set || rwnx_hw->ccode.ccode_cnt >=3D MAX_SEARCH_=
CNT)
+		req->ssid_cnt =3D (u8)min_t(int, SCAN_SSID_MAX, param->n_ssids);
+	else
+		req->ssid_cnt =3D (u8)min_t(int, 0, param->n_ssids);
+#else
+	req->ssid_cnt =3D (u8)min_t(int, SCAN_SSID_MAX, param->n_ssids);
+#endif
+
+	req->bssid =3D mac_addr_bcst;
+	req->no_cck =3D param->no_cck;
+	if (param->duration_mandatory)
+		// req->duration =3D ieee80211_tu_to_usec(param->duration);
+		req->duration =3D 0;
+
+#ifdef AIC8800_RADAR_OR_IR_DETECT
+	if (req->ssid_cnt =3D=3D 0)
+		chan_flags |=3D CHAN_NO_IR;
+#endif
+	for (i =3D 0; i < req->ssid_cnt; i++) {
+		int j;
+
+		for (j =3D 0; j < param->ssids[i].ssid_len; j++)
+			req->ssid[i].array[j] =3D param->ssids[i].ssid[j];
+		req->ssid[i].length =3D param->ssids[i].ssid_len;
+
+		if (!memcmp(P2P_WILDCARD_SSID, param->ssids[i].ssid,
+			    P2P_WILDCARD_SSID_LEN)) {
+			AICWFDBG(LOGINFO, "p2p scanu:%d,%d,%d\n", rwnx_vif->vif_index,
+				 rwnx_vif->is_p2p_vif, rwnx_hw->is_p2p_alive);
+#ifdef CONFIG_AIC8800_USE_P2P0
+			if (rwnx_vif->is_p2p_vif && !rwnx_hw->is_p2p_alive) {
+#else
+			if (rwnx_vif =3D=3D rwnx_hw->p2p_dev_vif && !rwnx_vif->up) {
+#endif
+				err =3D rwnx_send_add_if(rwnx_hw, rwnx_vif->wdev.address,
+						       RWNX_VIF_TYPE(rwnx_vif), false,
+						       &add_if_cfm);
+				if (err)
+					goto error;
+
+				if (add_if_cfm.status !=3D 0)
+					return -EIO;
+
+				/* Save the index retrieved from LMAC */
+				spin_lock_bh(&rwnx_hw->cb_lock);
+				rwnx_vif->vif_index =3D add_if_cfm.inst_nbr;
+				rwnx_vif->up =3D true;
+				rwnx_hw->vif_started++;
+				rwnx_hw->vif_table[add_if_cfm.inst_nbr] =3D rwnx_vif;
+				spin_unlock_bh(&rwnx_hw->cb_lock);
+			}
+			rwnx_hw->is_p2p_alive =3D 1;
+#ifndef CONFIG_AIC8800_USE_P2P0
+			mod_timer(&rwnx_hw->p2p_alive_timer,
+				  jiffies + msecs_to_jiffies(1000));
+			atomic_set(&rwnx_hw->p2p_alive_timer_count, 0);
+#endif
+			AICWFDBG(LOGINFO, "p2p scan start\n");
+		}
+	}
+
+	if (param->ie) {
+		ie_req =3D rwnx_msg_zalloc(SCANU_VENDOR_IE_REQ, TASK_SCANU, DRV_TASK_ID,
+					 sizeof(struct scanu_vendor_ie_req));
+		if (!ie_req)
+			return -ENOMEM;
+
+		ie_req->add_ie_len =3D param->ie_len;
+		ie_req->vif_idx =3D rwnx_vif->vif_index;
+		memcpy(ie_req->ie, param->ie, param->ie_len);
+#ifdef CONFIG_AIC8800_SET_VENDOR_EXTENSION_IE
+		rwnx_insert_vendor_extension_data(ie_req);
+#endif // CONFIG_AIC8800_SET_VENDOR_EXTENSION_IE
+		req->add_ie_len =3D 0;
+		req->add_ies =3D 0;
+
+		err =3D rwnx_send_msg(rwnx_hw, ie_req, 1, SCANU_VENDOR_IE_CFM, NULL);
+		if (err)
+			goto error;
+	} else {
+		req->add_ie_len =3D 0;
+		req->add_ies =3D 0;
+	}
+
+	for (i =3D 0; i < req->chan_cnt; i++) {
+		struct ieee80211_channel *chan =3D param->channels[i];
+
+		AICWFDBG(LOGDEBUG, "scan channel:%d(%d) \r\n",
+			 ieee80211_frequency_to_channel(chan->center_freq),
+			 chan->center_freq);
+		req->chan[i].band =3D chan->band;
+		req->chan[i].freq =3D chan->center_freq;
+		req->chan[i].flags =3D chan_flags | get_chan_flags(chan->flags);
+		req->chan[i].tx_power =3D chan_to_fw_pwr(chan->max_reg_power);
+	}
+
+	/* Send the SCANU_START_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, SCANU_START_CFM_ADDTIONAL, NULL);
+error:
+	if (req)
+		rwnx_msg_free(rwnx_hw, req);
+	if (ie_req)
+		rwnx_msg_free(rwnx_hw, ie_req);
+	return -ENOMEM;
+}
+
+int rwnx_send_scanu_cancel_req(struct rwnx_hw *rwnx_hw,
+			       struct scan_cancel_cfm *cfm)
+{
+	struct scan_cancel_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the SCAN_CANCEL_REQ message */
+	req =3D rwnx_msg_zalloc(SCANU_CANCEL_REQ, TASK_SCANU, DRV_TASK_ID,
+			      sizeof(struct scan_cancel_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Send the SCAN_CANCEL_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, SCANU_CANCEL_CFM, cfm);
+}
+
+int rwnx_send_apm_start_cac_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *=
vif,
+				struct cfg80211_chan_def *chandef,
+				struct apm_start_cac_cfm *cfm)
+{
+	struct apm_start_cac_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the APM_START_CAC_REQ message */
+	req =3D rwnx_msg_zalloc(APM_START_CAC_REQ, TASK_APM, DRV_TASK_ID,
+			      sizeof(struct apm_start_cac_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the APM_START_CAC_REQ message */
+	req->vif_idx =3D vif->vif_index;
+	req->chan.band =3D chandef->chan->band;
+	req->chan.freq =3D chandef->chan->center_freq;
+	req->chan.flags =3D 0;
+	req->center_freq1 =3D chandef->center_freq1;
+	req->center_freq2 =3D chandef->center_freq2;
+	req->ch_width =3D bw2chnl[chandef->width];
+
+	/* Send the APM_START_CAC_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, APM_START_CAC_CFM, cfm);
+}
+
+int rwnx_send_apm_stop_cac_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *v=
if)
+{
+	struct apm_stop_cac_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the APM_STOP_CAC_REQ message */
+	req =3D rwnx_msg_zalloc(APM_STOP_CAC_REQ, TASK_APM, DRV_TASK_ID,
+			      sizeof(struct apm_stop_cac_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the APM_STOP_CAC_REQ message */
+	req->vif_idx =3D vif->vif_index;
+
+	/* Send the APM_STOP_CAC_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, APM_STOP_CAC_CFM, NULL);
+}
+
+int rwnx_send_mesh_start_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif=
,
+			     const struct mesh_config *conf,
+			     const struct mesh_setup *setup,
+			     struct mesh_start_cfm *cfm)
+{
+	// Message to send
+	struct mesh_start_req *req;
+	// Supported basic rates
+	struct ieee80211_supported_band *band_2ghz =3D
+		rwnx_hw->wiphy->bands[NL80211_BAND_2GHZ];
+	/* Counter */
+	int i;
+	/* Return status */
+	int status;
+	/* DMA Address to be unmapped after confirmation reception */
+	u32 dma_addr =3D 0;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MESH_START_REQ message */
+	req =3D rwnx_msg_zalloc(MESH_START_REQ, TASK_MESH, DRV_TASK_ID,
+			      sizeof(struct mesh_start_req));
+	if (!req)
+		return -ENOMEM;
+
+	req->vif_index =3D vif->vif_index;
+	req->bcn_int =3D setup->beacon_interval;
+	req->dtim_period =3D setup->dtim_period;
+	req->mesh_id_len =3D setup->mesh_id_len;
+
+	for (i =3D 0; i < setup->mesh_id_len; i++)
+		req->mesh_id[i] =3D *(setup->mesh_id + i);
+
+	req->user_mpm =3D setup->user_mpm;
+	req->is_auth =3D setup->is_authenticated;
+	req->auth_id =3D setup->auth_id;
+	req->ie_len =3D setup->ie_len;
+
+	if (setup->ie_len) {
+		/*
+		 * Need to provide a Virtual Address to the MAC so that it can
+		 * download the additional information elements.
+		 */
+		req->ie_addr =3D dma_map_single(rwnx_hw->dev, (void *)setup->ie,
+					      setup->ie_len, DMA_FROM_DEVICE);
+
+		/* Check DMA mapping result */
+		if (dma_mapping_error(rwnx_hw->dev, req->ie_addr)) {
+			AICWFDBG(LOGDEBUG, KERN_CRIT
+				 "AICWF %s - DMA Mapping error on additional IEs\n",
+				 __func__);
+
+			/* Consider there is no Additional IEs */
+			req->ie_len =3D 0;
+		} else {
+			/* Store DMA Address so that we can unmap the memory section
+			 * once MESH_START_CFM is received
+			 */
+			dma_addr =3D req->ie_addr;
+		}
+	}
+
+	/* Provide rate information */
+	req->basic_rates.length =3D 0;
+	for (i =3D 0; i < band_2ghz->n_bitrates; i++) {
+		u16 rate =3D band_2ghz->bitrates[i].bitrate;
+
+		/* Read value is in units of 100 Kbps, provided value is in units
+		 * of 1Mbps, and multiplied by 2 so that 5.5 becomes 11
+		 */
+		rate =3D (rate << 1) / 10;
+
+		if (setup->basic_rates & CO_BIT(i))
+			rate |=3D 0x80;
+
+		req->basic_rates.array[i] =3D (u8)rate;
+		req->basic_rates.length++;
+	}
+
+	/* Provide channel information */
+	req->chan.band =3D setup->chandef.chan->band;
+	req->chan.freq =3D setup->chandef.chan->center_freq;
+	req->chan.flags =3D 0;
+	req->chan.tx_power =3D chan_to_fw_pwr(setup->chandef.chan->max_power);
+	req->center_freq1 =3D setup->chandef.center_freq1;
+	req->center_freq2 =3D setup->chandef.center_freq2;
+	req->ch_width =3D bw2chnl[setup->chandef.width];
+
+	/* Send the MESH_START_REQ message to UMAC FW */
+	status =3D rwnx_send_msg(rwnx_hw, req, 1, MESH_START_CFM, cfm);
+
+	/* Unmap DMA area */
+	if (setup->ie_len)
+		dma_unmap_single(rwnx_hw->dev, dma_addr, setup->ie_len, DMA_TO_DEVICE);
+
+	/* Return the status */
+	return status;
+}
+
+int rwnx_send_mesh_stop_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif,
+			    struct mesh_stop_cfm *cfm)
+{
+	// Message to send
+	struct mesh_stop_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MESH_STOP_REQ message */
+	req =3D rwnx_msg_zalloc(MESH_STOP_REQ, TASK_MESH, DRV_TASK_ID,
+			      sizeof(struct mesh_stop_req));
+	if (!req)
+		return -ENOMEM;
+
+	req->vif_idx =3D vif->vif_index;
+
+	/* Send the MESH_STOP_REQ message to UMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MESH_STOP_CFM, cfm);
+}
+
+int rwnx_send_mesh_update_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vi=
f,
+			      u32 mask, const struct mesh_config *p_mconf,
+			      struct mesh_update_cfm *cfm)
+{
+	// Message to send
+	struct mesh_update_req *req;
+	// Keep only bit for fields which can be updated
+	u32 supp_mask =3D (mask << 1) & (CO_BIT(NL80211_MESHCONF_GATE_ANNOUNCEMEN=
TS) |
+			CO_BIT(NL80211_MESHCONF_HWMP_ROOTMODE) |
+			CO_BIT(NL80211_MESHCONF_FORWARDING) |
+			CO_BIT(NL80211_MESHCONF_POWER_MODE));
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	if (!supp_mask)
+		return -ENOENT;
+
+	/* Build the MESH_UPDATE_REQ message */
+	req =3D rwnx_msg_zalloc(MESH_UPDATE_REQ, TASK_MESH, DRV_TASK_ID,
+			      sizeof(struct mesh_update_req));
+
+	if (!req)
+		return -ENOMEM;
+
+	req->vif_idx =3D vif->vif_index;
+
+	if (supp_mask & CO_BIT(NL80211_MESHCONF_GATE_ANNOUNCEMENTS)) {
+		req->flags |=3D CO_BIT(MESH_UPDATE_FLAGS_GATE_MODE_BIT);
+		req->gate_announ =3D p_mconf->dot11MeshGateAnnouncementProtocol;
+	}
+
+	if (supp_mask & CO_BIT(NL80211_MESHCONF_HWMP_ROOTMODE)) {
+		req->flags |=3D CO_BIT(MESH_UPDATE_FLAGS_ROOT_MODE_BIT);
+		req->root_mode =3D p_mconf->dot11MeshHWMPRootMode;
+	}
+
+	if (supp_mask & CO_BIT(NL80211_MESHCONF_FORWARDING)) {
+		req->flags |=3D CO_BIT(MESH_UPDATE_FLAGS_MESH_FWD_BIT);
+		req->mesh_forward =3D p_mconf->dot11MeshForwarding;
+	}
+
+	if (supp_mask & CO_BIT(NL80211_MESHCONF_POWER_MODE)) {
+		req->flags |=3D CO_BIT(MESH_UPDATE_FLAGS_LOCAL_PSM_BIT);
+		req->local_ps_mode =3D p_mconf->power_mode;
+	}
+
+	/* Send the MESH_UPDATE_REQ message to UMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MESH_UPDATE_CFM, cfm);
+}
+
+int rwnx_send_mesh_peer_info_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif =
*vif,
+				 u8 sta_idx, struct mesh_peer_info_cfm *cfm)
+{
+	// Message to send
+	struct mesh_peer_info_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MESH_PEER_INFO_REQ message */
+	req =3D rwnx_msg_zalloc(MESH_PEER_INFO_REQ, TASK_MESH, DRV_TASK_ID,
+			      sizeof(struct mesh_peer_info_req));
+	if (!req)
+		return -ENOMEM;
+
+	req->sta_idx =3D sta_idx;
+
+	/* Send the MESH_PEER_INFO_REQ message to UMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MESH_PEER_INFO_CFM, cfm);
+}
+
+void rwnx_send_mesh_peer_update_ntf(struct rwnx_hw *rwnx_hw,
+				    struct rwnx_vif *vif, u8 sta_idx,
+				    u8 mlink_state)
+{
+	// Message to send
+	struct mesh_peer_update_ntf *ntf;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MESH_PEER_UPDATE_NTF message */
+	ntf =3D rwnx_msg_zalloc(MESH_PEER_UPDATE_NTF, TASK_MESH, DRV_TASK_ID,
+			      sizeof(struct mesh_peer_update_ntf));
+
+	if (ntf) {
+		ntf->vif_idx =3D vif->vif_index;
+		ntf->sta_idx =3D sta_idx;
+		ntf->state =3D mlink_state;
+
+		/* Send the MESH_PEER_INFO_REQ message to UMAC FW */
+		rwnx_send_msg(rwnx_hw, ntf, 0, 0, NULL);
+	}
+}
+
+void rwnx_send_mesh_path_create_req(struct rwnx_hw *rwnx_hw,
+				    struct rwnx_vif *vif, u8 *tgt_addr)
+{
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Check if we are already waiting for a confirmation */
+	if (!vif->ap.create_path) {
+		// Message to send
+		struct mesh_path_create_req *req;
+
+		/* Build the MESH_PATH_CREATE_REQ message */
+		req =3D rwnx_msg_zalloc(MESH_PATH_CREATE_REQ, TASK_MESH, DRV_TASK_ID,
+				      sizeof(struct mesh_path_create_req));
+
+		if (req) {
+			req->vif_idx =3D vif->vif_index;
+			memcpy(&req->tgt_mac_addr, tgt_addr, ETH_ALEN);
+
+			vif->ap.create_path =3D true;
+
+			/* Send the MESH_PATH_CREATE_REQ message to UMAC FW */
+			rwnx_send_msg(rwnx_hw, req, 0, 0, NULL);
+		}
+	}
+}
+
+int rwnx_send_mesh_path_update_req(struct rwnx_hw *rwnx_hw,
+				   struct rwnx_vif *vif, const u8 *tgt_addr,
+				   const u8 *p_nhop_addr,
+				   struct mesh_path_update_cfm *cfm)
+{
+	// Message to send
+	struct mesh_path_update_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MESH_PATH_UPDATE_REQ message */
+	req =3D rwnx_msg_zalloc(MESH_PATH_UPDATE_REQ, TASK_MESH, DRV_TASK_ID,
+			      sizeof(struct mesh_path_update_req));
+	if (!req)
+		return -ENOMEM;
+
+	req->delete =3D (!p_nhop_addr);
+	req->vif_idx =3D vif->vif_index;
+	memcpy(&req->tgt_mac_addr, tgt_addr, ETH_ALEN);
+
+	if (p_nhop_addr)
+		memcpy(&req->nhop_mac_addr, p_nhop_addr, ETH_ALEN);
+
+	/* Send the MESH_PATH_UPDATE_REQ message to UMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MESH_PATH_UPDATE_CFM, cfm);
+}
+
+void rwnx_send_mesh_proxy_add_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif=
 *vif,
+				  u8 *ext_addr)
+{
+	// Message to send
+	struct mesh_proxy_add_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MESH_PROXY_ADD_REQ message */
+	req =3D rwnx_msg_zalloc(MESH_PROXY_ADD_REQ, TASK_MESH, DRV_TASK_ID,
+			      sizeof(struct mesh_proxy_add_req));
+
+	if (req) {
+		req->vif_idx =3D vif->vif_index;
+		memcpy(&req->ext_sta_addr, ext_addr, ETH_ALEN);
+
+		/* Send the MESH_PROXY_ADD_REQ message to UMAC FW */
+		rwnx_send_msg(rwnx_hw, req, 0, 0, NULL);
+	}
+}
+
+int rwnx_send_tdls_peer_traffic_ind_req(struct rwnx_hw *rwnx_hw,
+					struct rwnx_vif *rwnx_vif)
+{
+	struct tdls_peer_traffic_ind_req *tdls_peer_traffic_ind_req;
+
+	if (!rwnx_vif->sta.tdls_sta)
+		return -ENOLINK;
+
+	/* Build the TDLS_PEER_TRAFFIC_IND_REQ message */
+	tdls_peer_traffic_ind_req =3D
+		rwnx_msg_zalloc(TDLS_PEER_TRAFFIC_IND_REQ, TASK_TDLS, DRV_TASK_ID,
+				sizeof(struct tdls_peer_traffic_ind_req));
+
+	if (!tdls_peer_traffic_ind_req)
+		return -ENOMEM;
+
+	/* Set parameters for the TDLS_PEER_TRAFFIC_IND_REQ message */
+	tdls_peer_traffic_ind_req->vif_index =3D rwnx_vif->vif_index;
+	tdls_peer_traffic_ind_req->sta_idx =3D rwnx_vif->sta.tdls_sta->sta_idx;
+	memcpy(&tdls_peer_traffic_ind_req->peer_mac_addr.array[0],
+	       rwnx_vif->sta.tdls_sta->mac_addr, ETH_ALEN);
+	tdls_peer_traffic_ind_req->dialog_token =3D 0; // check dialog token valu=
e
+	tdls_peer_traffic_ind_req->last_tid =3D rwnx_vif->sta.tdls_sta->tdls.last=
_tid;
+	tdls_peer_traffic_ind_req->last_sn =3D rwnx_vif->sta.tdls_sta->tdls.last_=
sn;
+
+	/* Send the TDLS_PEER_TRAFFIC_IND_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, tdls_peer_traffic_ind_req, 0, 0, NULL);
+}
+
+int rwnx_send_config_monitor_req(struct rwnx_hw *rwnx_hw,
+				 struct cfg80211_chan_def *chandef,
+				 struct me_config_monitor_cfm *cfm)
+{
+	struct me_config_monitor_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the ME_CONFIG_MONITOR_REQ message */
+	req =3D rwnx_msg_zalloc(ME_CONFIG_MONITOR_REQ, TASK_ME, DRV_TASK_ID,
+			      sizeof(struct me_config_monitor_req));
+	if (!req)
+		return -ENOMEM;
+
+	if (chandef) {
+		req->chan_set =3D true;
+
+		req->chan.band =3D chandef->chan->band;
+		req->chan.type =3D bw2chnl[chandef->width];
+		req->chan.prim20_freq =3D chandef->chan->center_freq;
+		req->chan.center1_freq =3D chandef->center_freq1;
+		req->chan.center2_freq =3D chandef->center_freq2;
+		req->chan.tx_power =3D chan_to_fw_pwr(chandef->chan->max_power);
+
+		if (rwnx_hw->phy.limit_bw)
+			limit_chan_bw(&req->chan.type, req->chan.prim20_freq,
+				      &req->chan.center1_freq);
+	} else {
+		req->chan_set =3D false;
+	}
+
+	req->uf =3D rwnx_hw->mod_params->uf;
+	req->auto_reply =3D rwnx_hw->mod_params->auto_reply;
+
+	/* Send the ME_CONFIG_MONITOR_REQ message to FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, ME_CONFIG_MONITOR_CFM, cfm);
+}
+#endif /* CONFIG_RWNX_FULLMAC */
+
+int rwnx_send_tdls_chan_switch_req(struct rwnx_hw *rwnx_hw,
+				   struct rwnx_vif *rwnx_vif,
+				   struct rwnx_sta *rwnx_sta,
+				   bool sta_initiator, u8 oper_class,
+				   struct cfg80211_chan_def *chandef,
+				   struct tdls_chan_switch_cfm *cfm)
+{
+	struct tdls_chan_switch_req *tdls_chan_switch_req;
+
+	/* Build the TDLS_CHAN_SWITCH_REQ message */
+	tdls_chan_switch_req =3D
+		rwnx_msg_zalloc(TDLS_CHAN_SWITCH_REQ, TASK_TDLS, DRV_TASK_ID,
+				sizeof(struct tdls_chan_switch_req));
+
+	if (!tdls_chan_switch_req)
+		return -ENOMEM;
+
+	/* Set parameters for the TDLS_CHAN_SWITCH_REQ message */
+	tdls_chan_switch_req->vif_index =3D rwnx_vif->vif_index;
+	tdls_chan_switch_req->sta_idx =3D rwnx_sta->sta_idx;
+	memcpy(&tdls_chan_switch_req->peer_mac_addr.array[0],
+	       rwnx_sta_addr(rwnx_sta), ETH_ALEN);
+	tdls_chan_switch_req->initiator =3D sta_initiator;
+	tdls_chan_switch_req->band =3D chandef->chan->band;
+	tdls_chan_switch_req->type =3D bw2chnl[chandef->width];
+	tdls_chan_switch_req->prim20_freq =3D chandef->chan->center_freq;
+	tdls_chan_switch_req->center1_freq =3D chandef->center_freq1;
+	tdls_chan_switch_req->center2_freq =3D chandef->center_freq2;
+	tdls_chan_switch_req->tx_power =3D chan_to_fw_pwr(chandef->chan->max_powe=
r);
+	tdls_chan_switch_req->op_class =3D oper_class;
+
+	/* Send the TDLS_CHAN_SWITCH_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, tdls_chan_switch_req, 1, TDLS_CHAN_SWITCH_C=
FM,
+			     cfm);
+}
+
+int rwnx_send_tdls_cancel_chan_switch_req(struct rwnx_hw *rwnx_hw,
+					  struct rwnx_vif *rwnx_vif,
+					  struct rwnx_sta *rwnx_sta,
+					  struct tdls_cancel_chan_switch_cfm *cfm)
+{
+	struct tdls_cancel_chan_switch_req *tdls_cancel_chan_switch_req;
+
+	/* Build the TDLS_CHAN_SWITCH_REQ message */
+	tdls_cancel_chan_switch_req =3D
+		rwnx_msg_zalloc(TDLS_CANCEL_CHAN_SWITCH_REQ, TASK_TDLS, DRV_TASK_ID,
+				sizeof(struct tdls_cancel_chan_switch_req));
+	if (!tdls_cancel_chan_switch_req)
+		return -ENOMEM;
+
+	/* Set parameters for the TDLS_CHAN_SWITCH_REQ message */
+	tdls_cancel_chan_switch_req->vif_index =3D rwnx_vif->vif_index;
+	tdls_cancel_chan_switch_req->sta_idx =3D rwnx_sta->sta_idx;
+	memcpy(&tdls_cancel_chan_switch_req->peer_mac_addr.array[0],
+	       rwnx_sta_addr(rwnx_sta), ETH_ALEN);
+
+	/* Send the TDLS_CHAN_SWITCH_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, tdls_cancel_chan_switch_req, 1,
+			     TDLS_CANCEL_CHAN_SWITCH_CFM, cfm);
+}
+
+#ifdef CONFIG_RWNX_BFMER
+#ifdef CONFIG_RWNX_FULLMAC
+void rwnx_send_bfmer_enable(struct rwnx_hw *rwnx_hw, struct rwnx_sta *rwnx=
_sta,
+			    const struct ieee80211_vht_cap *vht_cap)
+#endif /* CONFIG_RWNX_FULLMAC */
+{
+	struct mm_bfmer_enable_req *bfmer_en_req;
+#ifdef CONFIG_RWNX_FULLMAC
+	__le32 vht_capability;
+	u8 rx_nss =3D 0;
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+#ifdef CONFIG_RWNX_FULLMAC
+	if (!vht_cap) {
+#endif /* CONFIG_RWNX_FULLMAC */
+		goto end;
+	}
+
+#ifdef CONFIG_RWNX_FULLMAC
+	vht_capability =3D vht_cap->vht_cap_info;
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	if (!(vht_capability & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE))
+		goto end;
+
+#ifdef CONFIG_RWNX_FULLMAC
+	rx_nss =3D rwnx_bfmer_get_rx_nss(vht_cap);
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	/* Allocate a structure that will contain the beamforming report */
+	if (rwnx_bfmer_report_add(rwnx_hw, rwnx_sta,
+				  RWNX_BFMER_REPORT_SPACE_SIZE))
+		goto end;
+
+	/* Build the MM_BFMER_ENABLE_REQ message */
+	bfmer_en_req =3D rwnx_msg_zalloc(MM_BFMER_ENABLE_REQ, TASK_MM, DRV_TASK_I=
D,
+				       sizeof(struct mm_bfmer_enable_req));
+
+	/* Check message allocation */
+	if (!bfmer_en_req) {
+		/* Free memory allocated for the report */
+		rwnx_bfmer_report_del(rwnx_hw, rwnx_sta);
+		/* Do not use beamforming */
+		goto end;
+	}
+
+	/* Provide DMA address to the MAC */
+	bfmer_en_req->host_bfr_addr =3D rwnx_sta->bfm_report->dma_addr;
+	bfmer_en_req->host_bfr_size =3D RWNX_BFMER_REPORT_SPACE_SIZE;
+	bfmer_en_req->sta_idx =3D rwnx_sta->sta_idx;
+#ifdef CONFIG_RWNX_FULLMAC
+	bfmer_en_req->aid =3D rwnx_sta->aid;
+	bfmer_en_req->rx_nss =3D rx_nss;
+#endif /* CONFIG_RWNX_FULLMAC */
+
+	if (vht_capability & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)
+		bfmer_en_req->vht_mu_bfmee =3D true;
+	else
+		bfmer_en_req->vht_mu_bfmee =3D false;
+
+	/* Send the MM_BFMER_EN_REQ message to LMAC FW */
+	rwnx_send_msg(rwnx_hw, bfmer_en_req, 0, 0, NULL);
+
+end:
+	return;
+}
+
+#ifdef CONFIG_RWNX_MUMIMO_TX
+int rwnx_send_mu_group_update_req(struct rwnx_hw *rwnx_hw,
+				  struct rwnx_sta *rwnx_sta)
+{
+	struct mm_mu_group_update_req *req;
+	int group_id, i =3D 0;
+	u64 map;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_MU_GROUP_UPDATE_REQ message */
+	req =3D
+		rwnx_msg_zalloc(MM_MU_GROUP_UPDATE_REQ, TASK_MM, DRV_TASK_ID,
+				sizeof(struct mm_mu_group_update_req) +
+				rwnx_sta->group_info.cnt * sizeof(req->groups[0]));
+
+	/* Check message allocation */
+	if (!req)
+		return -ENOMEM;
+
+	map =3D rwnx_sta->group_info.map & RWNX_MU_GROUP_MASK;
+	for (group_id =3D (fls64(map) - 1); group_id > 0;
+	     map &=3D ~(u64)BIT_ULL(group_id), group_id =3D (fls64(map) - 1)) {
+		int user_pos =3D rwnx_mu_group_sta_get_pos(rwnx_hw, rwnx_sta, group_id);
+
+		if (WARN(i >=3D rwnx_sta->group_info.cnt,
+			 "STA%d: Too much group (%d)\n", rwnx_sta->sta_idx, i + 1))
+			break;
+
+		req->groups[i].group_id =3D group_id;
+		req->groups[i].user_pos =3D user_pos;
+
+		i++;
+	}
+
+	req->group_cnt =3D rwnx_sta->group_info.cnt;
+	req->sta_idx =3D rwnx_sta->sta_idx;
+
+	/* Send the MM_MU_GROUP_UPDATE_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MM_MU_GROUP_UPDATE_CFM, NULL);
+}
+#endif /* CONFIG_RWNX_MUMIMO_TX */
+#endif /* CONFIG_RWNX_BFMER */
+
+/**********************************************************************
+ *    Debug Messages
+ *********************************************************************/
+int rwnx_send_dbg_trigger_req(struct rwnx_hw *rwnx_hw, char *msg)
+{
+	struct mm_dbg_trigger_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_DBG_TRIGGER_REQ message */
+	req =3D rwnx_msg_zalloc(MM_DBG_TRIGGER_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_dbg_trigger_req));
+	if (!req)
+		return -ENOMEM;
+
+	/* Set parameters for the MM_DBG_TRIGGER_REQ message */
+	strscpy(req->error, msg, sizeof(req->error));
+
+	/* Send the MM_DBG_TRIGGER_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 0, -1, NULL);
+}
+
+int rwnx_send_dbg_mem_read_req(struct rwnx_hw *rwnx_hw, u32 mem_addr,
+			       struct dbg_mem_read_cfm *cfm)
+{
+	struct dbg_mem_read_req *mem_read_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the DBG_MEM_READ_REQ message */
+	mem_read_req =3D rwnx_msg_zalloc(DBG_MEM_READ_REQ, TASK_DBG, DRV_TASK_ID,
+				       sizeof(struct dbg_mem_read_req));
+	if (!mem_read_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_READ_REQ message */
+	mem_read_req->memaddr =3D mem_addr;
+
+	/* Send the DBG_MEM_READ_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, mem_read_req, 1, DBG_MEM_READ_CFM, cfm);
+}
+
+int rwnx_send_dbg_mem_write_req(struct rwnx_hw *rwnx_hw, u32 mem_addr,
+				u32 mem_data)
+{
+	struct dbg_mem_write_req *mem_write_req;
+
+	// RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the DBG_MEM_WRITE_REQ message */
+	mem_write_req =3D rwnx_msg_zalloc(DBG_MEM_WRITE_REQ, TASK_DBG, DRV_TASK_I=
D,
+					sizeof(struct dbg_mem_write_req));
+	if (!mem_write_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_WRITE_REQ message */
+	mem_write_req->memaddr =3D mem_addr;
+	mem_write_req->memdata =3D mem_data;
+
+	/* Send the DBG_MEM_WRITE_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, mem_write_req, 1, DBG_MEM_WRITE_CFM, NULL);
+}
+
+int rwnx_send_dbg_mem_mask_write_req(struct rwnx_hw *rwnx_hw, u32 mem_addr=
,
+				     u32 mem_mask, u32 mem_data)
+{
+	struct dbg_mem_mask_write_req *mem_mask_write_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the DBG_MEM_MASK_WRITE_REQ message */
+	mem_mask_write_req =3D
+		rwnx_msg_zalloc(DBG_MEM_MASK_WRITE_REQ, TASK_DBG, DRV_TASK_ID,
+				sizeof(struct dbg_mem_mask_write_req));
+	if (!mem_mask_write_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_MASK_WRITE_REQ message */
+	mem_mask_write_req->memaddr =3D mem_addr;
+	mem_mask_write_req->memmask =3D mem_mask;
+	mem_mask_write_req->memdata =3D mem_data;
+
+	/* Send the DBG_MEM_MASK_WRITE_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, mem_mask_write_req, 1, DBG_MEM_MASK_WRITE_C=
FM,
+			     NULL);
+}
+
+int rwnx_send_rftest_req(struct rwnx_hw *rwnx_hw, u32_l cmd, u32_l argc,
+			 u8_l *argv, struct dbg_rftest_cmd_cfm *cfm)
+{
+	struct dbg_rftest_cmd_req *mem_rftest_cmd_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the DBG_RFTEST_CMD_REQ message */
+	mem_rftest_cmd_req =3D
+		rwnx_msg_zalloc(DBG_RFTEST_CMD_REQ, TASK_DBG, DRV_TASK_ID,
+				sizeof(struct dbg_rftest_cmd_req));
+	if (!mem_rftest_cmd_req)
+		return -ENOMEM;
+
+	if (argc > 10)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_MASK_WRITE_REQ message */
+	mem_rftest_cmd_req->cmd =3D cmd;
+	mem_rftest_cmd_req->argc =3D argc;
+	if (argc !=3D 0)
+		memcpy(mem_rftest_cmd_req->argv, argv, argc);
+
+	/* Send the DBG_RFTEST_CMD_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, mem_rftest_cmd_req, 1, DBG_RFTEST_CMD_CFM,
+			     cfm);
+}
+
+int rwnx_send_dbg_set_mod_filter_req(struct rwnx_hw *rwnx_hw, u32 filter)
+{
+	struct dbg_set_mod_filter_req *set_mod_filter_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the DBG_SET_MOD_FILTER_REQ message */
+	set_mod_filter_req =3D
+		rwnx_msg_zalloc(DBG_SET_MOD_FILTER_REQ, TASK_DBG, DRV_TASK_ID,
+				sizeof(struct dbg_set_mod_filter_req));
+	if (!set_mod_filter_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_SET_MOD_FILTER_REQ message */
+	set_mod_filter_req->mod_filter =3D filter;
+
+	/* Send the DBG_SET_MOD_FILTER_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, set_mod_filter_req, 1, DBG_SET_MOD_FILTER_C=
FM,
+						 NULL);
+}
+
+int rwnx_send_dbg_set_sev_filter_req(struct rwnx_hw *rwnx_hw, u32 filter)
+{
+	struct dbg_set_sev_filter_req *set_sev_filter_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the DBG_SET_SEV_FILTER_REQ message */
+	set_sev_filter_req =3D
+		rwnx_msg_zalloc(DBG_SET_SEV_FILTER_REQ, TASK_DBG, DRV_TASK_ID,
+				sizeof(struct dbg_set_sev_filter_req));
+	if (!set_sev_filter_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_SET_SEV_FILTER_REQ message */
+	set_sev_filter_req->sev_filter =3D filter;
+
+	/* Send the DBG_SET_SEV_FILTER_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, set_sev_filter_req, 1, DBG_SET_SEV_FILTER_C=
FM,
+			     NULL);
+}
+
+int rwnx_send_dbg_get_sys_stat_req(struct rwnx_hw *rwnx_hw,
+				   struct dbg_get_sys_stat_cfm *cfm)
+{
+	void *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Allocate the message */
+	req =3D rwnx_msg_zalloc(DBG_GET_SYS_STAT_REQ, TASK_DBG, DRV_TASK_ID, 0);
+	if (!req)
+		return -ENOMEM;
+
+	/* Send the DBG_MEM_READ_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, DBG_GET_SYS_STAT_CFM, cfm);
+}
+
+int rwnx_send_dbg_mem_block_write_req(struct rwnx_hw *rwnx_hw, u32 mem_add=
r,
+				      u32 mem_size, u32 *mem_data)
+{
+	struct dbg_mem_block_write_req *mem_blk_write_req;
+
+	// RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the DBG_MEM_BLOCK_WRITE_REQ message */
+	mem_blk_write_req =3D
+		rwnx_msg_zalloc(DBG_MEM_BLOCK_WRITE_REQ, TASK_DBG, DRV_TASK_ID,
+				sizeof(struct dbg_mem_block_write_req));
+	if (!mem_blk_write_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_MEM_BLOCK_WRITE_REQ message */
+	mem_blk_write_req->memaddr =3D mem_addr;
+	mem_blk_write_req->memsize =3D mem_size;
+	memcpy(mem_blk_write_req->memdata, mem_data, mem_size);
+
+	/* Send the DBG_MEM_BLOCK_WRITE_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, mem_blk_write_req, 1, DBG_MEM_BLOCK_WRITE_C=
FM,
+			     NULL);
+}
+
+int rwnx_send_dbg_start_app_req(struct rwnx_hw *rwnx_hw, u32 boot_addr,
+				u32 boot_type)
+{
+	struct dbg_start_app_req *start_app_req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the DBG_START_APP_REQ message */
+	start_app_req =3D rwnx_msg_zalloc(DBG_START_APP_REQ, TASK_DBG, DRV_TASK_I=
D,
+					sizeof(struct dbg_start_app_req));
+	if (!start_app_req)
+		return -ENOMEM;
+
+	/* Set parameters for the DBG_START_APP_REQ message */
+	start_app_req->bootaddr =3D boot_addr;
+	start_app_req->boottype =3D boot_type;
+
+	/* Send the DBG_START_APP_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, start_app_req, 1, DBG_START_APP_CFM, NULL);
+}
+
+int rwnx_send_cfg_rssi_req(struct rwnx_hw *rwnx_hw, u8 vif_index,
+			   int rssi_thold, u32 rssi_hyst)
+{
+	struct mm_cfg_rssi_req *req;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	/* Build the MM_CFG_RSSI_REQ message */
+	req =3D rwnx_msg_zalloc(MM_CFG_RSSI_REQ, TASK_MM, DRV_TASK_ID,
+			      sizeof(struct mm_cfg_rssi_req));
+	if (!req)
+		return -ENOMEM;
+
+	if (!rwnx_hw->vif_table[vif_index])
+		return 0;
+
+	/* Set parameters for the MM_CFG_RSSI_REQ message */
+	req->vif_index =3D vif_index;
+	req->rssi_thold =3D (s8)rssi_thold;
+	req->rssi_hyst =3D (u8)rssi_hyst;
+
+	/* Send the MM_CFG_RSSI_REQ message to LMAC FW */
+	return rwnx_send_msg(rwnx_hw, req, 1, MM_CFG_RSSI_CFM, NULL);
+}
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.h b/drivers/=
net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.h
new file mode 100644
index 0000000000000..c9b46ef9d4634
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_msg_tx.h
@@ -0,0 +1,285 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _RWNX_MSG_TX_H_
+#define _RWNX_MSG_TX_H_
+
+#include "lmac_types.h"
+#include "rwnx_defs.h"
+
+int rwnx_send_reset(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_start(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_version_req(struct rwnx_hw *rwnx_hw, struct mm_version_cfm *=
cfm);
+
+int rwnx_send_add_if(struct rwnx_hw *rwnx_hw, const unsigned char *mac,
+		     enum nl80211_iftype iftype, bool p2p,
+		     struct mm_add_if_cfm *cfm);
+
+int rwnx_send_remove_if(struct rwnx_hw *rwnx_hw, u8 vif_index, bool defer)=
;
+
+int rwnx_send_set_channel(struct rwnx_hw *rwnx_hw, int phy_idx,
+			  struct mm_set_channel_cfm *cfm);
+
+int rwnx_send_key_add(struct rwnx_hw *rwnx_hw, u8 vif_idx, u8 sta_idx,
+		      bool pairwise, u8 *key, u8 key_len, u8 key_idx,
+		      u8 cipher_suite, struct mm_key_add_cfm *cfm);
+
+int rwnx_send_key_del(struct rwnx_hw *rwnx_hw, uint8_t hw_key_idx);
+
+int rwnx_send_bcn(struct rwnx_hw *rwnx_hw, u8 *buf, u8 vif_idx, u16 bcn_le=
n);
+
+int rwnx_send_bcn_change(struct rwnx_hw *rwnx_hw, u8 vif_idx, u32 bcn_addr=
,
+			 u16 bcn_len, u16 tim_oft, u16 tim_len, u16 *csa_oft);
+
+int rwnx_send_tim_update(struct rwnx_hw *rwnx_hw, u8 vif_idx, u16 aid,
+			 u8 tx_status);
+
+int rwnx_send_roc(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif,
+		  struct ieee80211_channel *chan, unsigned int duration,
+		  struct mm_remain_on_channel_cfm *roc_cfm);
+
+int rwnx_send_cancel_roc(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_set_power(struct rwnx_hw *rwnx_hw, u8 vif_idx, s8 pwr,
+			struct mm_set_power_cfm *cfm);
+
+int rwnx_send_set_edca(struct rwnx_hw *rwnx_hw, u8 hw_queue, u32 param,
+		       bool uapsd, u8 inst_nbr);
+
+int rwnx_send_tdls_chan_switch_req(struct rwnx_hw *rwnx_hw,
+				   struct rwnx_vif *rwnx_vif,
+				   struct rwnx_sta *rwnx_sta,
+				   bool sta_initiator, u8 oper_class,
+				   struct cfg80211_chan_def *chandef,
+				   struct tdls_chan_switch_cfm *cfm);
+
+int rwnx_send_tdls_cancel_chan_switch_req(struct rwnx_hw *rwnx_hw, struct =
rwnx_vif *rwnx_vif,
+					  struct rwnx_sta *rwnx_sta,
+					  struct tdls_cancel_chan_switch_cfm *cfm);
+
+#ifdef CONFIG_RWNX_P2P_DEBUGFS
+int rwnx_send_p2p_oppps_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *rwnx=
_vif,
+			    u8 ctw, struct mm_set_p2p_oppps_cfm *cfm);
+
+int rwnx_send_p2p_noa_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *rwnx_v=
if,
+			  int count, int interval, int duration, bool dyn_noa,
+			  struct mm_set_p2p_noa_cfm *cfm);
+
+#endif /* CONFIG_RWNX_P2P_DEBUGFS */
+
+#ifdef AICWF_ARP_OFFLOAD
+int rwnx_send_arpoffload_en_req(struct rwnx_hw *rwnx_hw,
+				struct rwnx_vif *rwnx_vif, u32_l ipaddr,
+				u8_l enable);
+#endif
+int rwnx_send_rf_config_req(struct rwnx_hw *rwnx_hw, u8_l ofst, u8_l sel, =
u8_l *tbl, u16_l len);
+
+int rwnx_send_rf_calib_req(struct rwnx_hw *rwnx_hw,
+			   struct mm_set_rf_calib_cfm *cfm);
+
+int rwnx_send_get_macaddr_req(struct rwnx_hw *rwnx_hw,
+			      struct mm_get_mac_addr_cfm *cfm);
+
+#ifdef CONFIG_RWNX_FULLMAC
+int rwnx_send_me_config_req(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_me_chan_config_req(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_me_set_control_port_req(struct rwnx_hw *rwnx_hw, bool opened=
,
+				      u8 sta_idx);
+
+int rwnx_send_me_sta_add(struct rwnx_hw *rwnx_hw,
+			 struct station_parameters *params, const u8 *mac,
+			 u8 inst_nbr, struct me_sta_add_cfm *cfm);
+
+int rwnx_send_me_sta_del(struct rwnx_hw *rwnx_hw, u8 sta_idx, bool tdls_st=
a);
+
+int rwnx_send_me_traffic_ind(struct rwnx_hw *rwnx_hw, u8 sta_idx, bool uap=
sd,
+			     u8 tx_status);
+
+int rwnx_send_me_rc_stats(struct rwnx_hw *rwnx_hw, u8 sta_idx,
+			  struct me_rc_stats_cfm *cfm);
+
+int rwnx_send_me_rc_set_rate(struct rwnx_hw *rwnx_hw, u8 sta_idx, u16 rate=
_idx);
+
+int rwnx_send_me_set_ps_mode(struct rwnx_hw *rwnx_hw, u8 ps_mode);
+
+int rwnx_send_me_set_lp_level(struct rwnx_hw *rwnx_hw, u8 lp_level, u8 dis=
able_filter);
+
+int rwnx_send_sm_connect_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *rwn=
x_vif,
+			     struct cfg80211_connect_params *sme, struct sm_connect_cfm *cfm);
+
+int rwnx_send_sm_disconnect_req(struct rwnx_hw *rwnx_hw,
+				struct rwnx_vif *rwnx_vif, u16 reason);
+
+int rwnx_send_sm_external_auth_required_rsp(struct rwnx_hw *rwnx_hw,
+					    struct rwnx_vif *rwnx_vif, u16 status);
+
+int rwnx_send_apm_start_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif,
+			    struct cfg80211_ap_settings *settings, struct apm_start_cfm *cfm,
+			    struct rwnx_ipc_elem_var *elem);
+
+int rwnx_send_apm_stop_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif);
+
+int rwnx_send_scanu_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *rwnx_vif=
,
+			struct cfg80211_scan_request *param);
+
+int rwnx_send_scanu_cancel_req(struct rwnx_hw *rwnx_hw,
+			       struct scan_cancel_cfm *cfm);
+
+int rwnx_send_apm_start_cac_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *=
vif,
+				struct cfg80211_chan_def *chandef,
+				struct apm_start_cac_cfm *cfm);
+
+int rwnx_send_apm_stop_cac_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *v=
if);
+
+int rwnx_send_tdls_peer_traffic_ind_req(struct rwnx_hw *rwnx_hw,
+					struct rwnx_vif *rwnx_vif);
+
+int rwnx_send_config_monitor_req(struct rwnx_hw *rwnx_hw,
+				 struct cfg80211_chan_def *chandef,
+				 struct me_config_monitor_cfm *cfm);
+
+int rwnx_send_mesh_start_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif=
,
+			     const struct mesh_config *conf, const struct mesh_setup *setup,
+			     struct mesh_start_cfm *cfm);
+
+int rwnx_send_mesh_stop_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vif,
+			    struct mesh_stop_cfm *cfm);
+
+int rwnx_send_mesh_update_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif *vi=
f,
+			      u32 mask, const struct mesh_config *p_mconf,
+			      struct mesh_update_cfm *cfm);
+
+int rwnx_send_mesh_peer_info_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif =
*vif,
+				 u8 sta_idx, struct mesh_peer_info_cfm *cfm);
+
+void rwnx_send_mesh_peer_update_ntf(struct rwnx_hw *rwnx_hw,
+				    struct rwnx_vif *vif, u8 sta_idx,
+				    u8 mlink_state);
+
+void rwnx_send_mesh_path_create_req(struct rwnx_hw *rwnx_hw,
+				    struct rwnx_vif *vif, u8 *tgt_addr);
+
+int rwnx_send_mesh_path_update_req(struct rwnx_hw *rwnx_hw,
+				   struct rwnx_vif *vif, const u8 *tgt_addr,
+				   const u8 *p_nhop_addr,
+				   struct mesh_path_update_cfm *cfm);
+
+void rwnx_send_mesh_proxy_add_req(struct rwnx_hw *rwnx_hw, struct rwnx_vif=
 *vif,
+				  u8 *ext_addr);
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+#ifdef CONFIG_RWNX_BFMER
+#ifdef CONFIG_RWNX_FULLMAC
+void rwnx_send_bfmer_enable(struct rwnx_hw *rwnx_hw, struct rwnx_sta *rwnx=
_sta,
+			    const struct ieee80211_vht_cap *vht_cap);
+
+#endif /* CONFIG_RWNX_FULLMAC */
+#ifdef CONFIG_RWNX_MUMIMO_TX
+int rwnx_send_mu_group_update_req(struct rwnx_hw *rwnx_hw,
+				  struct rwnx_sta *rwnx_sta);
+#endif /* CONFIG_RWNX_MUMIMO_TX */
+#endif /* CONFIG_RWNX_BFMER */
+
+/* Debug messages */
+int rwnx_send_dbg_trigger_req(struct rwnx_hw *rwnx_hw, char *msg);
+
+int rwnx_send_dbg_mem_read_req(struct rwnx_hw *rwnx_hw, u32 mem_addr,
+			       struct dbg_mem_read_cfm *cfm);
+
+int rwnx_send_dbg_mem_write_req(struct rwnx_hw *rwnx_hw, u32 mem_addr,
+				u32 mem_data);
+
+int rwnx_send_dbg_mem_mask_write_req(struct rwnx_hw *rwnx_hw, u32 mem_addr=
,
+				     u32 mem_mask, u32 mem_data);
+
+int rwnx_send_dbg_set_mod_filter_req(struct rwnx_hw *rwnx_hw, u32 filter);
+
+int rwnx_send_rftest_req(struct rwnx_hw *rwnx_hw, u32_l cmd, u32_l argc,
+			 u8_l *argv, struct dbg_rftest_cmd_cfm *cfm);
+
+int rwnx_send_dbg_set_sev_filter_req(struct rwnx_hw *rwnx_hw, u32 filter);
+
+int rwnx_send_dbg_get_sys_stat_req(struct rwnx_hw *rwnx_hw,
+				   struct dbg_get_sys_stat_cfm *cfm);
+
+int rwnx_send_dbg_mem_block_write_req(struct rwnx_hw *rwnx_hw, u32 mem_add=
r,
+				      u32 mem_size, u32 *mem_data);
+
+int rwnx_send_dbg_start_app_req(struct rwnx_hw *rwnx_hw, u32 boot_addr,
+				u32 boot_type);
+
+int rwnx_send_cfg_rssi_req(struct rwnx_hw *rwnx_hw, u8 vif_index,
+			   int rssi_thold, u32 rssi_hyst);
+
+int rwnx_send_disable_agg_req(struct rwnx_hw *rwnx_hw, u8_l agg_disable,
+			      u8_l agg_disable_rx, u8_l sta_idx);
+
+int rwnx_send_coex_req(struct rwnx_hw *rwnx_hw, u8_l disable_coexnull,
+		       u8_l enable_nullcts);
+
+int rwnx_send_get_sta_info_req(struct rwnx_hw *rwnx_hw, u8_l sta_idx,
+			       struct mm_get_sta_info_cfm *cfm);
+
+int rwnx_send_set_stack_start_req(struct rwnx_hw *rwnx_hw, u8_l on,
+				  u8_l efuse_valid, u8_l set_vendor_info,
+				  u8_l fwtrace_redir_en,
+				  struct mm_set_stack_start_cfm *cfm);
+
+int rwnx_send_get_temp_req(struct rwnx_hw *rwnx_hw,
+			   struct mm_set_vendor_swconfig_cfm *cfm);
+
+int rwnx_send_get_temp_hwconfig_req(struct rwnx_hw *rwnx_hw,
+				    struct mm_set_vendor_hwconfig_cfm *cfm);
+
+int rwnx_send_set_temp_comp_req(struct rwnx_hw *rwnx_hw,
+				struct mm_set_vendor_swconfig_cfm *cfm);
+
+int rwnx_send_set_pkt_filter_req(struct rwnx_hw *rwnx_hw, u16_l *param);
+
+int rwnx_send_del_pkt_filter_req(struct rwnx_hw *rwnx_hw, u16_l code);
+
+int rwnx_send_txop_req(struct rwnx_hw *rwnx_hw, uint16_t *txop,
+		       u8_l long_nav_en, u8_l cfe_en);
+
+int rwnx_send_vendor_hwconfig_req(struct rwnx_hw *rwnx_hw, u32_l hwconfig_=
id,
+				  s32_l *param, s32_l *param_out);
+
+int rwnx_send_vendor_swconfig_req(struct rwnx_hw *rwnx_hw, u32_l swconfig_=
id,
+				  s32_l *param_in, s32_l *param_out);
+
+int rwnx_send_mask_set_ext_flags_req(struct rwnx_hw *rwnx_hw,
+				     u32_l flags_mask, u32_l flags_val,
+				     struct mm_set_vendor_swconfig_cfm *cfm);
+
+int rwnx_send_get_fw_version_req(struct rwnx_hw *rwnx_hw,
+				 struct mm_get_fw_version_cfm *cfm);
+
+int rwnx_send_txpwr_idx_req(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_txpwr_ofst_req(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_txpwr_ofst2x_req(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_txpwr_lvl_req(struct rwnx_hw *rwnx_hw);
+
+int rwnx_send_txpwr_lvl_v3_req(struct rwnx_hw *rwnx_hw, int index_reg);
+
+int rwnx_send_txpwr_lvl_adj_req(struct rwnx_hw *rwnx_hw);
+
+struct rwnx_cmd *rwnx_cmd_malloc(void);
+
+void rwnx_cmd_free(struct rwnx_cmd *cmd);
+
+int rwnx_init_cmd_array(void);
+
+void rwnx_free_cmd_array(void);
+
+#ifdef CONFIG_SDIO_BT
+int rwnx_sdio_bt_send_req(struct rwnx_hw *rwnx_hw, uint32_t len,
+			  struct sk_buff *skb);
+#endif
+
+#endif /* _RWNX_MSG_TX_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_platform.c b/driver=
s/net/wireless/aic/aic8800_fdrv/rwnx_platform.c
new file mode 100644
index 0000000000000..88a574e29a269
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_platform.c
@@ -0,0 +1,2946 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
*****
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file rwnx_platform.c
+ *
+ * @brief Platform profile
+ *
+ *************************************************************************=
*****
+ */
+
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/sprintf.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
+
+#include "hal_desc.h"
+#include "reg_access.h"
+#include "rwnx_main.h"
+#include "rwnx_platform.h"
+#include "ipc_host.h"
+#include "rwnx_msg_tx.h"
+
+#ifdef AICWF_SDIO_SUPPORT
+#include "aicwf_sdio.h"
+#endif
+
+#include "aicwf_compat_8800d80.h"
+#include "aicwf_compat_8800dc.h"
+#include "aicwf_chip_ops.h"
+#include "md5.h"
+
+// Parser state
+#define INIT      0
+#define CMD       1
+#define PRINT     2
+#define GET_VALUE 3
+
+struct reg_table {
+	char ccode[3];
+	enum regions_code region;
+};
+
+/* If the region conflicts with the kernel, the actual authentication stan=
dard prevails */
+struct reg_table reg_tables[] =3D {
+	{.ccode =3D "CN", .region =3D REGIONS_SRRC},
+	{.ccode =3D "US", .region =3D REGIONS_FCC},
+	{.ccode =3D "DE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "00", .region =3D REGIONS_DEFAULT},
+	{.ccode =3D "WW", .region =3D REGIONS_DEFAULT},
+	{.ccode =3D "XX", .region =3D REGIONS_DEFAULT},
+	{.ccode =3D "JP", .region =3D REGIONS_JP},
+	{.ccode =3D "AD", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AF", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AI", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AL", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AM", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AN", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AR", .region =3D REGIONS_FCC},
+	{.ccode =3D "AS", .region =3D REGIONS_FCC},
+	{.ccode =3D "AT", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AU", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AW", .region =3D REGIONS_ETSI},
+	{.ccode =3D "AZ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BA", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BB", .region =3D REGIONS_FCC},
+	{.ccode =3D "BD", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BF", .region =3D REGIONS_FCC},
+	{.ccode =3D "BG", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BH", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BL", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BM", .region =3D REGIONS_FCC},
+	{.ccode =3D "BN", .region =3D REGIONS_JP},
+	{.ccode =3D "BO", .region =3D REGIONS_JP},
+	{.ccode =3D "BR", .region =3D REGIONS_FCC},
+	{.ccode =3D "BS", .region =3D REGIONS_FCC},
+	{.ccode =3D "BT", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BW", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BY", .region =3D REGIONS_ETSI},
+	{.ccode =3D "BZ", .region =3D REGIONS_JP},
+	{.ccode =3D "CA", .region =3D REGIONS_FCC},
+	{.ccode =3D "CF", .region =3D REGIONS_FCC},
+	{.ccode =3D "CH", .region =3D REGIONS_ETSI},
+	{.ccode =3D "CI", .region =3D REGIONS_FCC},
+	{.ccode =3D "CL", .region =3D REGIONS_ETSI},
+	{.ccode =3D "CO", .region =3D REGIONS_FCC},
+	{.ccode =3D "CR", .region =3D REGIONS_FCC},
+	{.ccode =3D "CU", .region =3D REGIONS_FCC},
+	{.ccode =3D "CX", .region =3D REGIONS_FCC},
+	{.ccode =3D "CY", .region =3D REGIONS_ETSI},
+	{.ccode =3D "CZ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "DK", .region =3D REGIONS_ETSI},
+	{.ccode =3D "DM", .region =3D REGIONS_FCC},
+	{.ccode =3D "DO", .region =3D REGIONS_FCC},
+	{.ccode =3D "DZ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "EC", .region =3D REGIONS_FCC},
+	{.ccode =3D "EE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "EG", .region =3D REGIONS_ETSI},
+	{.ccode =3D "ES", .region =3D REGIONS_ETSI},
+	{.ccode =3D "ET", .region =3D REGIONS_ETSI},
+	{.ccode =3D "FI", .region =3D REGIONS_ETSI},
+	{.ccode =3D "FK", .region =3D REGIONS_ETSI},
+	{.ccode =3D "FM", .region =3D REGIONS_FCC},
+	{.ccode =3D "FO", .region =3D REGIONS_ETSI},
+	{.ccode =3D "FR", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GB", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GD", .region =3D REGIONS_FCC},
+	{.ccode =3D "GE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GF", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GH", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GI", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GL", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GP", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GR", .region =3D REGIONS_ETSI},
+	{.ccode =3D "GT", .region =3D REGIONS_FCC},
+	{.ccode =3D "GU", .region =3D REGIONS_FCC},
+	{.ccode =3D "GY", .region =3D REGIONS_DEFAULT},
+	{.ccode =3D "HK", .region =3D REGIONS_ETSI},
+	{.ccode =3D "HN", .region =3D REGIONS_FCC},
+	{.ccode =3D "HR", .region =3D REGIONS_ETSI},
+	{.ccode =3D "HT", .region =3D REGIONS_FCC},
+	{.ccode =3D "HU", .region =3D REGIONS_ETSI},
+	{.ccode =3D "ID", .region =3D REGIONS_ETSI},
+	{.ccode =3D "IE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "IL", .region =3D REGIONS_ETSI},
+	{.ccode =3D "IN", .region =3D REGIONS_ETSI},
+	{.ccode =3D "IQ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "IR", .region =3D REGIONS_JP},
+	{.ccode =3D "IS", .region =3D REGIONS_ETSI},
+	{.ccode =3D "IT", .region =3D REGIONS_ETSI},
+	{.ccode =3D "JM", .region =3D REGIONS_FCC},
+	{.ccode =3D "JO", .region =3D REGIONS_ETSI},
+	{.ccode =3D "KE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "KG", .region =3D REGIONS_ETSI},
+	{.ccode =3D "KH", .region =3D REGIONS_ETSI},
+	{.ccode =3D "KN", .region =3D REGIONS_ETSI},
+	{.ccode =3D "KP", .region =3D REGIONS_JP},
+	{.ccode =3D "KR", .region =3D REGIONS_ETSI},
+	{.ccode =3D "KW", .region =3D REGIONS_ETSI},
+	{.ccode =3D "KY", .region =3D REGIONS_FCC},
+	{.ccode =3D "KZ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "LB", .region =3D REGIONS_ETSI},
+	{.ccode =3D "LC", .region =3D REGIONS_ETSI},
+	{.ccode =3D "LI", .region =3D REGIONS_ETSI},
+	{.ccode =3D "LK", .region =3D REGIONS_FCC},
+	{.ccode =3D "LS", .region =3D REGIONS_ETSI},
+	{.ccode =3D "LT", .region =3D REGIONS_ETSI},
+	{.ccode =3D "LU", .region =3D REGIONS_ETSI},
+	{.ccode =3D "LV", .region =3D REGIONS_ETSI},
+	{.ccode =3D "LY", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MA", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MC", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MD", .region =3D REGIONS_ETSI},
+	{.ccode =3D "ME", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MF", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MH", .region =3D REGIONS_FCC},
+	{.ccode =3D "MK", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MN", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MO", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MP", .region =3D REGIONS_FCC},
+	{.ccode =3D "MQ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MR", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MT", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MU", .region =3D REGIONS_FCC},
+	{.ccode =3D "MV", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MW", .region =3D REGIONS_ETSI},
+	{.ccode =3D "MX", .region =3D REGIONS_FCC},
+	{.ccode =3D "MY", .region =3D REGIONS_ETSI},
+	{.ccode =3D "NA", .region =3D REGIONS_ETSI},
+	{.ccode =3D "NG", .region =3D REGIONS_ETSI},
+	{.ccode =3D "NI", .region =3D REGIONS_FCC},
+	{.ccode =3D "NL", .region =3D REGIONS_ETSI},
+	{.ccode =3D "NO", .region =3D REGIONS_ETSI},
+	{.ccode =3D "NP", .region =3D REGIONS_JP},
+	{.ccode =3D "NZ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "OM", .region =3D REGIONS_ETSI},
+	{.ccode =3D "PA", .region =3D REGIONS_FCC},
+	{.ccode =3D "PE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "PF", .region =3D REGIONS_ETSI},
+	{.ccode =3D "PG", .region =3D REGIONS_FCC},
+	{.ccode =3D "PH", .region =3D REGIONS_ETSI},
+	{.ccode =3D "PK", .region =3D REGIONS_ETSI},
+	{.ccode =3D "PL", .region =3D REGIONS_ETSI},
+	{.ccode =3D "PM", .region =3D REGIONS_ETSI},
+	{.ccode =3D "PR", .region =3D REGIONS_FCC},
+	{.ccode =3D "PT", .region =3D REGIONS_ETSI},
+	{.ccode =3D "PW", .region =3D REGIONS_FCC},
+	{.ccode =3D "PY", .region =3D REGIONS_FCC},
+	{.ccode =3D "QA", .region =3D REGIONS_ETSI},
+	{.ccode =3D "RE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "RO", .region =3D REGIONS_ETSI},
+	{.ccode =3D "RS", .region =3D REGIONS_ETSI},
+	{.ccode =3D "RU", .region =3D REGIONS_ETSI},
+	{.ccode =3D "RW", .region =3D REGIONS_FCC},
+	{.ccode =3D "SA", .region =3D REGIONS_ETSI},
+	{.ccode =3D "SE", .region =3D REGIONS_ETSI},
+	{.ccode =3D "SG", .region =3D REGIONS_ETSI},
+	{.ccode =3D "SI", .region =3D REGIONS_ETSI},
+	{.ccode =3D "SK", .region =3D REGIONS_ETSI},
+	{.ccode =3D "SM", .region =3D REGIONS_ETSI},
+	{.ccode =3D "SN", .region =3D REGIONS_FCC},
+	{.ccode =3D "SR", .region =3D REGIONS_ETSI},
+	{.ccode =3D "SV", .region =3D REGIONS_FCC},
+	{.ccode =3D "SY", .region =3D REGIONS_DEFAULT},
+	{.ccode =3D "TC", .region =3D REGIONS_FCC},
+	{.ccode =3D "TD", .region =3D REGIONS_ETSI},
+	{.ccode =3D "TG", .region =3D REGIONS_ETSI},
+	{.ccode =3D "TH", .region =3D REGIONS_ETSI},
+	{.ccode =3D "TJ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "TM", .region =3D REGIONS_ETSI},
+	{.ccode =3D "TN", .region =3D REGIONS_ETSI},
+	{.ccode =3D "TR", .region =3D REGIONS_ETSI},
+	{.ccode =3D "TT", .region =3D REGIONS_FCC},
+	{.ccode =3D "TW", .region =3D REGIONS_FCC},
+	{.ccode =3D "TZ", .region =3D REGIONS_DEFAULT},
+	{.ccode =3D "UA", .region =3D REGIONS_ETSI},
+	{.ccode =3D "UG", .region =3D REGIONS_FCC},
+	{.ccode =3D "UY", .region =3D REGIONS_ETSI},
+	{.ccode =3D "UZ", .region =3D REGIONS_ETSI},
+	{.ccode =3D "VC", .region =3D REGIONS_ETSI},
+	{.ccode =3D "VE", .region =3D REGIONS_FCC},
+	{.ccode =3D "VI", .region =3D REGIONS_FCC},
+	{.ccode =3D "VN", .region =3D REGIONS_JP},
+	{.ccode =3D "VU", .region =3D REGIONS_FCC},
+	{.ccode =3D "WF", .region =3D REGIONS_ETSI},
+	{.ccode =3D "WS", .region =3D REGIONS_ETSI},
+	{.ccode =3D "YE", .region =3D REGIONS_DEFAULT},
+	{.ccode =3D "YT", .region =3D REGIONS_ETSI},
+	{.ccode =3D "ZA", .region =3D REGIONS_ETSI},
+	{.ccode =3D "ZM", .region =3D REGIONS_ETSI},
+	{.ccode =3D "ZW", .region =3D REGIONS_ETSI},
+	{.ccode =3D "XK", .region =3D REGIONS_ETSI},
+};
+
+struct rwnx_plat *g_rwnx_plat;
+
+struct userconfig_info_t {
+	struct txpwr_lvl_conf txpwr_lvl;
+	struct txpwr_lvl_conf_v2 txpwr_lvl_v2;
+	struct txpwr_lvl_conf_v3 txpwr_lvl_v3;
+	struct txpwr_lvl_conf_v3 txpwr_lvl_v3_gp[REGION_NUM_MAX];
+	struct txpwr_lvl_adj_conf txpwr_lvl_adj;
+	struct txpwr_loss_conf txpwr_loss;
+	struct txpwr_ofst_conf txpwr_ofst;
+	struct txpwr_ofst2x_conf txpwr_ofst2x;
+	struct xtal_cap_conf xtal_cap;
+};
+
+struct userconfig_info_t userconfig_info =3D {
+	.txpwr_lvl =3D { .enable =3D 1,
+				  .dsss =3D 9,
+				  .ofdmlowrate_2g4 =3D 8,
+				  .ofdm64qam_2g4 =3D 8,
+				  .ofdm256qam_2g4 =3D 8,
+				  .ofdm1024qam_2g4 =3D 8,
+				  .ofdmlowrate_5g =3D 11,
+				  .ofdm64qam_5g =3D 10,
+				  .ofdm256qam_5g =3D 9,
+				  .ofdm1024qam_5g =3D 9},
+	.txpwr_lvl_v2 =3D	{ .enable =3D 1,
+			.pwrlvl_11b_11ag_2g4 =3D
+				// 1M,   2M,   5M5,  11M,  6M,   9M,   12M,  18M,  24M,  36M,
+				// 48M,  54M
+			{20, 20, 20, 20, 20, 20, 20, 20, 18, 18, 16, 16},
+			.pwrlvl_11n_11ac_2g4 =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 16},
+			.pwrlvl_11ax_2g4 =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9,
+				// MCS10,MCS11
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 16, 15, 15},
+		},
+	.txpwr_lvl_v3 =3D	{ .enable =3D 1,
+			.pwrlvl_11b_11ag_2g4 =3D
+				// 1M,   2M,   5M5,  11M,  6M,   9M,   12M,  18M,  24M,  36M,
+				// 48M,  54M
+			{20, 20, 20, 20, 20, 20, 20, 20, 18, 18, 16, 16},
+			.pwrlvl_11n_11ac_2g4 =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 16},
+			.pwrlvl_11ax_2g4 =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9,
+				// MCS10,MCS11
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 16, 15, 15},
+			.pwrlvl_11a_5g =3D
+				// NA,   NA,   NA,   NA,   6M,   9M,   12M,  18M,  24M,  36M,
+				// 48M,  54M
+			{0x80, 0x80, 0x80, 0x80, 20, 20, 20, 20, 18, 18, 16, 16},
+			.pwrlvl_11n_11ac_5g =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 15},
+			.pwrlvl_11ax_5g =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9,
+				// MCS10,MCS11
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 15, 14, 14},
+		},
+	.txpwr_lvl_v3_gp[0] =3D { .enable =3D 1,
+			.pwrlvl_11b_11ag_2g4 =3D
+				// 1M,   2M,   5M5,  11M,  6M,   9M,   12M,  18M,  24M,  36M,
+				// 48M,  54M
+			{20, 20, 20, 20, 20, 20, 20, 20, 18, 18, 16, 16},
+			.pwrlvl_11n_11ac_2g4 =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 16},
+			.pwrlvl_11ax_2g4 =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9,
+				// MCS10,MCS11
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 16, 15, 15},
+			.pwrlvl_11a_5g =3D
+				// NA,   NA,   NA,   NA,   6M,   9M,   12M,  18M,  24M,  36M,
+				// 48M,  54M
+			{0x80, 0x80, 0x80, 0x80, 20, 20, 20, 20, 18, 18, 16, 16},
+			.pwrlvl_11n_11ac_5g =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 15},
+			.pwrlvl_11ax_5g =3D
+				// MCS0, MCS1, MCS2, MCS3, MCS4, MCS5, MCS6, MCS7, MCS8, MCS9,
+				// MCS10,MCS11
+			{20, 20, 20, 20, 18, 18, 16, 16, 16, 15, 14, 14},
+		},
+	.txpwr_lvl_v3_gp[1] =3D { .enable =3D 1,
+			.pwrlvl_11b_11ag_2g4 =3D {20, 20, 20, 20, 20, 20, 20, 20, 18, 18, 16, 1=
6},
+			.pwrlvl_11n_11ac_2g4 =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 16},
+			.pwrlvl_11ax_2g4 =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 16, 15, 15},
+			.pwrlvl_11a_5g =3D {0x80, 0x80, 0x80, 0x80, 20, 20, 20, 20, 18, 18, 16,=
 16},
+			.pwrlvl_11n_11ac_5g =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 15},
+			.pwrlvl_11ax_5g =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 15, 14, 14},
+		},
+	.txpwr_lvl_v3_gp[2] =3D { .enable =3D 1,
+			.pwrlvl_11b_11ag_2g4 =3D {20, 20, 20, 20, 20, 20, 20, 20, 18, 18, 16, 1=
6},
+			.pwrlvl_11n_11ac_2g4 =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 16},
+			.pwrlvl_11ax_2g4 =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 16, 15, 15},
+			.pwrlvl_11a_5g =3D {0x80, 0x80, 0x80, 0x80, 20, 20, 20, 20, 18, 18, 16,=
 16},
+			.pwrlvl_11n_11ac_5g =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 15},
+			.pwrlvl_11ax_5g =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 15, 14, 14},
+		},
+	.txpwr_lvl_v3_gp[3] =3D { .enable =3D 1,
+			.pwrlvl_11b_11ag_2g4 =3D {20, 20, 20, 20, 20, 20, 20, 20, 18, 18, 16, 1=
6},
+			.pwrlvl_11n_11ac_2g4 =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 16},
+			.pwrlvl_11ax_2g4 =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 16, 15, 15},
+			.pwrlvl_11a_5g =3D {0x80, 0x80, 0x80, 0x80, 20, 20, 20, 20, 18, 18, 16,=
 16},
+			.pwrlvl_11n_11ac_5g =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 15},
+			.pwrlvl_11ax_5g =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 15, 14, 14},
+		},
+	.txpwr_lvl_v3_gp[4] =3D { .enable =3D 1,
+			.pwrlvl_11b_11ag_2g4 =3D {20, 20, 20, 20, 20, 20, 20, 20, 18, 18, 16, 1=
6},
+			.pwrlvl_11n_11ac_2g4 =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 16},
+			.pwrlvl_11ax_2g4 =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 16, 15, 15},
+			.pwrlvl_11a_5g =3D {0x80, 0x80, 0x80, 0x80, 20, 20, 20, 20, 18, 18, 16,=
 16},
+			.pwrlvl_11n_11ac_5g =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 15},
+			.pwrlvl_11ax_5g =3D {20, 20, 20, 20, 18, 18, 16, 16, 16, 15, 14, 14},
+		},
+	.txpwr_loss =3D { .loss_enable_2g4 =3D 1,
+			.loss_value_2g4 =3D 0,
+			.loss_enable_5g =3D 1,
+			.loss_value_5g =3D 0,
+		},
+	.txpwr_ofst =3D { .enable =3D 1,
+			.chan_1_4 =3D 0,
+			.chan_5_9 =3D 0,
+			.chan_10_13 =3D 0,
+			.chan_36_64 =3D 0,
+			.chan_100_120 =3D 0,
+			.chan_122_140 =3D 0,
+			.chan_142_165 =3D 0,
+		},
+	.txpwr_ofst2x =3D { .enable =3D 0,
+			.pwrofst2x_tbl_2g4 =3D {
+					// ch1-4, ch5-9, ch10-13
+					{0, 0, 0}, // 11b
+					{0, 0, 0}, // ofdm_highrate
+					{0, 0, 0}, // ofdm_lowrate
+				},
+			.pwrofst2x_tbl_5g =3D {
+					// ch42,  ch58, ch106,ch122,ch138,ch155
+					{0, 0, 0, 0, 0, 0}, // ofdm_lowrate
+					{0, 0, 0, 0, 0, 0}, // ofdm_highrate
+					{0, 0, 0, 0, 0, 0}, // ofdm_midrate
+				},
+		},
+	.xtal_cap =3D { .enable =3D 0,
+			.xtal_cap =3D 24,
+			.xtal_cap_fine =3D 31,
+		},
+};
+
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+#define POWER_LIMIT_INVALID_VAL POWER_LEVEL_INVALID_VAL
+
+#define POWER_LIMIT_CC_MATCHED_BIT (0x1U << 0)
+
+struct txpwr_lmt_info_t {
+	u8_l ch_cnt_2g4;
+	u8_l ch_cnt_5g;
+	u8_l ch_num_2g4[MAC_DOMAINCHANNEL_24G_MAX];
+	u8_l ch_num_5g[MAC_DOMAINCHANNEL_5G_MAX];
+	s8_l max_pwr_2g4[MAC_DOMAINCHANNEL_24G_MAX];
+	s8_l max_pwr_5g[MAC_DOMAINCHANNEL_5G_MAX];
+};
+
+struct powerlimit_info_t {
+	u32_l flags;
+	struct txpwr_lmt_info_t txpwr_lmt;
+};
+
+struct powerlimit_info_t powerlimit_info =3D {
+	0,
+};
+#endif
+
+int aicwf_request_firmware(const struct firmware **fw, const char *name,
+			   struct device *dev)
+{
+	char *fw_name;
+	int ret;
+
+	if (!name || !name[0])
+		return -EINVAL;
+
+	fw_name =3D kasprintf(GFP_KERNEL, AIC8800_FW_DIR "%s", name);
+	if (!fw_name)
+		return -ENOMEM;
+
+	ret =3D request_firmware(fw, fw_name, dev);
+	kfree(fw_name);
+
+	return ret;
+}
+
+#ifdef CONFIG_RWNX_TL4
+/**
+ * rwnx_plat_tl4_fw_upload() - Load the requested FW into embedded side.
+ *
+ * @rwnx_plat: pointer to platform structure
+ * @fw_addr: Virtual address where the fw must be loaded
+ * @filename: Name of the fw.
+ *
+ * Load a fw, stored as a hex file, into the specified address
+ */
+static int rwnx_plat_tl4_fw_upload(struct rwnx_plat *rwnx_plat, u8 *fw_add=
r,
+				   char *filename)
+{
+	struct device *dev =3D rwnx_platform_get_dev(rwnx_plat);
+	const struct firmware *fw;
+	int err =3D 0;
+	u32 *dst;
+	u8 const *file_data;
+	char typ0, typ1;
+	u32 addr0, addr1;
+	u32 dat0, dat1;
+	int remain;
+
+	err =3D aicwf_request_firmware(&fw, filename, dev);
+	if (err)
+		return err;
+
+	file_data =3D fw->data;
+	remain =3D fw->size;
+
+	/* Copy the file on the Embedded side */
+	dev_dbg(dev, "\n### Now copy %s firmware, @ =3D %p\n", filename, fw_addr)=
;
+
+	/* Walk through all the lines of the configuration file */
+	while (remain >=3D 16) {
+		u32 data, offset;
+
+		if (sscanf(file_data, "%c:%08X %04X", &typ0, &addr0, &dat0) !=3D 3)
+			break;
+		if ((addr0 & 0x01) !=3D 0) {
+			addr0 =3D addr0 - 1;
+			dat0 =3D 0;
+		} else {
+			file_data +=3D 16;
+			remain -=3D 16;
+		}
+		if (remain < 16 ||
+		    (sscanf(file_data, "%c:%08X %04X", &typ1, &addr1, &dat1) !=3D 3) ||
+		    typ1 !=3D typ0 || addr1 !=3D (addr0 + 1)) {
+			typ1 =3D typ0;
+			addr1 =3D addr0 + 1;
+			dat1 =3D 0;
+		} else {
+			file_data +=3D 16;
+			remain -=3D 16;
+		}
+
+		if (typ0 =3D=3D 'C') {
+			offset =3D 0x00200000;
+			if ((addr1 % 4) =3D=3D 3)
+				offset +=3D 2 * (addr1 - 3);
+			else
+				offset +=3D 2 * (addr1 + 1);
+
+			data =3D dat1 | (dat0 << 16);
+		} else {
+			offset =3D 2 * (addr1 - 1);
+			data =3D dat0 | (dat1 << 16);
+		}
+		dst =3D (u32 *)(fw_addr + offset);
+		*dst =3D data;
+	}
+
+	release_firmware(fw);
+
+	return err;
+}
+#endif
+
+#define MD5PINRT                                                          =
     \
+	"file "                                                                  =
  \
+	"md5:%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\r\n=
"
+
+static int rwnx_load_firmware(u32 **fw_buf, const char *name,
+			      struct device *device)
+{
+	const struct firmware *fw =3D NULL;
+	u32 *dst =3D NULL;
+	void *buffer =3D NULL;
+	struct MD5_CTX md5;
+	unsigned char decrypt[16];
+	int size =3D 0;
+	int ret =3D 0;
+
+	AICWFDBG(LOGINFO, "AICWF %s: request firmware =3D %s\n", __func__, name);
+
+	ret =3D aicwf_request_firmware(&fw, name, device);
+
+	if (ret < 0) {
+		AICWFDBG(LOGDEBUG, "AICWF Load %s fail\n", name);
+		return ret;
+	}
+
+	size =3D fw->size;
+	dst =3D (u32 *)fw->data;
+
+	if (size <=3D 0) {
+		AICWFDBG(LOGDEBUG, "AICWF wrong size of firmware file\n");
+		release_firmware(fw);
+		return -1;
+	}
+
+	buffer =3D vmalloc(size);
+	if (!buffer) {
+		release_firmware(fw);
+		return -ENOMEM;
+	}
+	memset(buffer, 0, size);
+	memcpy(buffer, dst, size);
+
+	*fw_buf =3D buffer;
+
+	md5_init(&md5);
+	md5_update(&md5, (unsigned char *)buffer, size);
+	md5_final(&md5, decrypt);
+	AICWFDBG(LOGDEBUG, "AICWF " MD5PINRT, decrypt[0], decrypt[1], decrypt[2],=
 decrypt[3],
+		 decrypt[4], decrypt[5], decrypt[6], decrypt[7], decrypt[8], decrypt[9],
+		 decrypt[10], decrypt[11], decrypt[12], decrypt[13], decrypt[14], decryp=
t[15]);
+
+	release_firmware(fw);
+
+	return size;
+}
+
+/* buffer is allocated by kzalloc */
+int rwnx_request_firmware_common(struct rwnx_hw *rwnx_hw, u32 **buffer,
+				 const char *filename)
+{
+	int size;
+
+	AICWFDBG(LOGDEBUG, "### Load file %s\n", filename);
+
+	size =3D rwnx_load_firmware(buffer, filename, rwnx_hw->dev);
+
+	return size;
+}
+
+static void rwnx_restore_firmware(u32 **fw_buf)
+{
+	vfree(*fw_buf);
+	*fw_buf =3D NULL;
+}
+
+void rwnx_release_firmware_common(u32 **buffer)
+{
+	rwnx_restore_firmware(buffer);
+}
+
+/**
+ * rwnx_plat_bin_fw_upload_2() - Load the requested binary FW into embedde=
d
+ * side.
+ *
+ * @rwnx_hw: Main driver data
+ * @fw_addr: Address where the fw must be loaded
+ * @filename: Name of the fw.
+ *
+ * Load a fw, stored as a binary file, into the specified address
+ */
+int rwnx_plat_bin_fw_upload_2(struct rwnx_hw *rwnx_hw, u32 fw_addr,
+			      char *filename)
+{
+	int err =3D 0;
+	unsigned int i =3D 0, size;
+	//    u32 *src;
+	u32 *dst =3D NULL;
+
+	/* Copy the file on the Embedded side */
+	AICWFDBG(LOGINFO, "### Upload %s firmware, @ =3D %x\n", filename, fw_addr=
);
+
+	size =3D rwnx_request_firmware_common(rwnx_hw, &dst, filename);
+	if (!dst) {
+		AICWFDBG(LOGERROR, "No such file or directory\n");
+		return -1;
+	}
+	if (size <=3D 0) {
+		AICWFDBG(LOGERROR, "wrong size of firmware file\n");
+		dst =3D NULL;
+		err =3D -1;
+	}
+
+	AICWFDBG(LOGINFO, "size=3D%d, dst[0]=3D%x\n", size, dst[0]);
+	if (size > 512) {
+		for (; i < (size - 512); i +=3D 512) {
+			// AICWFDBG(LOGDEBUG, "AICWF wr blk 0: %p -> %x\r\n",
+			// dst + i / 4, fw_addr + i);
+			err =3D rwnx_send_dbg_mem_block_write_req(rwnx_hw, fw_addr + i, 512,
+								dst + i / 4);
+			if (err) {
+				AICWFDBG(LOGERROR, "bin upload fail: %x, err:%d\r\n",
+					 fw_addr + i, err);
+				break;
+			}
+		}
+	}
+	if (!err && i < size) {
+		// AICWFDBG(LOGDEBUG, "AICWF wr blk 1: %p -> %x\r\n", dst + i / 4, fw_ad=
dr + i);
+		err =3D rwnx_send_dbg_mem_block_write_req(rwnx_hw, fw_addr + i, size - i=
,
+							dst + i / 4);
+		if (err) {
+			AICWFDBG(LOGERROR, "bin upload fail: %x, err:%d\r\n", fw_addr + i,
+				 err);
+		}
+	}
+
+	if (dst)
+		rwnx_release_firmware_common(&dst);
+
+	return err;
+}
+
+struct nvram_info_t {
+	struct txpwr_idx_conf txpwr_idx;
+	struct txpwr_ofst_conf txpwr_ofst;
+	struct xtal_cap_conf xtal_cap;
+};
+
+struct nvram_info_t nvram_info =3D {
+	.txpwr_idx =3D {.enable =3D 1,
+			.dsss =3D 9,
+			.ofdmlowrate_2g4 =3D 8,
+			.ofdm64qam_2g4 =3D 8,
+			.ofdm256qam_2g4 =3D 8,
+			.ofdm1024qam_2g4 =3D 8,
+			.ofdmlowrate_5g =3D 11,
+			.ofdm64qam_5g =3D 10,
+			.ofdm256qam_5g =3D 9,
+			.ofdm1024qam_5g =3D 9},
+	.txpwr_ofst =3D { .enable =3D 1,
+			.chan_1_4 =3D 0,
+			.chan_5_9 =3D 0,
+			.chan_10_13 =3D 0,
+			.chan_36_64 =3D 0,
+			.chan_100_120 =3D 0,
+			.chan_122_140 =3D 0,
+			.chan_142_165 =3D 0,
+		},
+	.xtal_cap =3D { .enable =3D 0,
+			.xtal_cap =3D 24,
+			.xtal_cap_fine =3D 31,
+		},
+};
+
+void get_userconfig_txpwr_ofst_in_fdrv(struct txpwr_ofst_conf *txpwr_ofst)
+{
+	txpwr_ofst->enable =3D userconfig_info.txpwr_ofst.enable;
+	txpwr_ofst->chan_1_4 =3D userconfig_info.txpwr_ofst.chan_1_4;
+	txpwr_ofst->chan_5_9 =3D userconfig_info.txpwr_ofst.chan_5_9;
+	txpwr_ofst->chan_10_13 =3D userconfig_info.txpwr_ofst.chan_10_13;
+	txpwr_ofst->chan_36_64 =3D userconfig_info.txpwr_ofst.chan_36_64;
+	txpwr_ofst->chan_100_120 =3D userconfig_info.txpwr_ofst.chan_100_120;
+	txpwr_ofst->chan_122_140 =3D userconfig_info.txpwr_ofst.chan_122_140;
+	txpwr_ofst->chan_142_165 =3D userconfig_info.txpwr_ofst.chan_142_165;
+
+	AICWFDBG(LOGINFO, "%s:enable      :%d\r\n", __func__, txpwr_ofst->enable)=
;
+	AICWFDBG(LOGINFO, "%s:chan_1_4    :%d\r\n", __func__, txpwr_ofst->chan_1_=
4);
+	AICWFDBG(LOGINFO, "%s:chan_5_9    :%d\r\n", __func__, txpwr_ofst->chan_5_=
9);
+	AICWFDBG(LOGINFO, "%s:chan_10_13  :%d\r\n", __func__,
+		 txpwr_ofst->chan_10_13);
+	AICWFDBG(LOGINFO, "%s:chan_36_64  :%d\r\n", __func__,
+		 txpwr_ofst->chan_36_64);
+	AICWFDBG(LOGINFO, "%s:chan_100_120:%d\r\n", __func__,
+		 txpwr_ofst->chan_100_120);
+	AICWFDBG(LOGINFO, "%s:chan_122_140:%d\r\n", __func__,
+		 txpwr_ofst->chan_122_140);
+	AICWFDBG(LOGINFO, "%s:chan_142_165:%d\r\n", __func__,
+		 txpwr_ofst->chan_142_165);
+}
+
+void get_userconfig_txpwr_ofst2x_in_fdrv(struct txpwr_ofst2x_conf *txpwr_o=
fst2x)
+{
+	int type, ch_grp;
+	*txpwr_ofst2x =3D userconfig_info.txpwr_ofst2x;
+	AICWFDBG(LOGINFO, "%s:enable      :%d\r\n", __func__, txpwr_ofst2x->enabl=
e);
+	AICWFDBG(LOGDEBUG,
+		 "pwrofst2x 2.4g: [0]:11b, [1]:ofdm_highrate, [2]:ofdm_lowrate\n  chan=
=3D\t1-4\t5-9\t10-13");
+
+	for (type =3D 0; type < 3; type++) {
+		AICWFDBG(LOGDEBUG, "\n  [%d] =3D", type);
+		for (ch_grp =3D 0; ch_grp < 3; ch_grp++) {
+			AICWFDBG(LOGDEBUG, "\t%d",
+				 txpwr_ofst2x->pwrofst2x_tbl_2g4[type][ch_grp]);
+		}
+	}
+	AICWFDBG(LOGDEBUG,
+		 "\npwrofst2x 5g: [0]:ofdm_lowrate, [1]:ofdm_highrate, [2]:ofdm_midrate\=
n  chan=3D\t36-50\t51-64\t98-114\t115-130\t131-146\t147-166");
+	for (type =3D 0; type < 3; type++) {
+		AICWFDBG(LOGDEBUG, "\n  [%d] =3D", type);
+		for (ch_grp =3D 0; ch_grp < 6; ch_grp++) {
+			AICWFDBG(LOGDEBUG, "\t%d",
+				 txpwr_ofst2x->pwrofst2x_tbl_5g[type][ch_grp]);
+		}
+	}
+	AICWFDBG(LOGDEBUG, "\n");
+}
+
+void get_userconfig_txpwr_idx(struct txpwr_idx_conf *txpwr_idx)
+{
+	memcpy(txpwr_idx, &nvram_info.txpwr_idx, sizeof(struct txpwr_idx_conf));
+}
+
+void get_userconfig_txpwr_ofst(struct txpwr_ofst_conf *txpwr_ofst)
+{
+	memcpy(txpwr_ofst, &nvram_info.txpwr_ofst, sizeof(struct txpwr_ofst_conf)=
);
+}
+
+void get_userconfig_xtal_cap(struct xtal_cap_conf *xtal_cap)
+{
+	if (nvram_info.xtal_cap.enable)
+		*xtal_cap =3D nvram_info.xtal_cap;
+
+	if (userconfig_info.xtal_cap.enable)
+		*xtal_cap =3D userconfig_info.xtal_cap;
+
+	AICWFDBG(LOGINFO, "%s:enable       :%d\r\n", __func__, xtal_cap->enable);
+	AICWFDBG(LOGINFO, "%s:xtal_cap     :%d\r\n", __func__, xtal_cap->xtal_cap=
);
+	AICWFDBG(LOGINFO, "%s:xtal_cap_fine:%d\r\n", __func__,
+		 xtal_cap->xtal_cap_fine);
+}
+
+s8_l get_txpwr_max(s8_l power)
+{
+	int i =3D 0;
+
+	for (i =3D 0; i <=3D 11; i++) {
+		if (power < userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[i])
+			power =3D userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[i];
+	}
+	for (i =3D 0; i <=3D 9; i++) {
+		if (power < userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[i])
+			power =3D userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[i];
+	}
+	for (i =3D 0; i <=3D 11; i++) {
+		if (power < userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[i])
+			power =3D userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[i];
+	}
+	for (i =3D 4; i <=3D 11; i++) {
+		if (power < userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[i])
+			power =3D userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[i];
+	}
+	for (i =3D 0; i <=3D 9; i++) {
+		if (power < userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[i])
+			power =3D userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[i];
+	}
+	for (i =3D 0; i <=3D 11; i++) {
+		if (power < userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[i])
+			power =3D userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[i];
+	}
+
+	if (userconfig_info.txpwr_loss.loss_enable_2g4 =3D=3D 1 ||
+	    userconfig_info.txpwr_loss.loss_enable_5g =3D=3D 1) {
+		if (userconfig_info.txpwr_loss.loss_value_2g4 <
+		    userconfig_info.txpwr_loss.loss_value_5g)
+			power +=3D userconfig_info.txpwr_loss.loss_value_5g;
+		else
+			power +=3D userconfig_info.txpwr_loss.loss_value_2g4;
+	}
+
+	AICWFDBG(LOGDEBUG, "AICWF %s:txpwr_max:%d \r\n", __func__, power);
+	return power;
+}
+
+void set_txpwr_loss_ofst(s8_l value)
+{
+	int i =3D 0;
+
+	for (i =3D 0; i <=3D 11; i++)
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[i] +=3D value;
+
+	for (i =3D 0; i <=3D 9; i++)
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[i] +=3D value;
+
+	for (i =3D 0; i <=3D 11; i++)
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[i] +=3D value;
+
+	for (i =3D 4; i <=3D 11; i++)
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[i] +=3D value;
+
+	for (i =3D 0; i <=3D 9; i++)
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[i] +=3D value;
+
+	for (i =3D 0; i <=3D 11; i++)
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[i] +=3D value;
+
+	AICWFDBG(LOGDEBUG, "AICWF %s:value:%d\r\n", __func__, value);
+}
+
+#define MATCH_NODE(type, node, cfg_key) {cfg_key, offsetof(type, node)}
+
+struct parse_match_t {
+	char keyname[64];
+	int offset;
+};
+
+static const char * const parse_key_prefix[] =3D {
+	[0x01] =3D "module0_",
+	[0x21] =3D "module1_",
+};
+
+static const struct parse_match_t parse_match_tab[] =3D {
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.enable, "enable"),
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.dsss, "dsss"),
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.ofdmlowrate_2g4, "ofdmlowrate_2=
g4"),
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.ofdm64qam_2g4, "ofdm64qam_2g4")=
,
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.ofdm256qam_2g4, "ofdm256qam_2g4=
"),
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.ofdm1024qam_2g4, "ofdm1024qam_2=
g4"),
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.ofdmlowrate_5g, "ofdmlowrate_5g=
"),
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.ofdm64qam_5g, "ofdm64qam_5g"),
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.ofdm256qam_5g, "ofdm256qam_5g")=
,
+	MATCH_NODE(struct nvram_info_t, txpwr_idx.ofdm1024qam_5g, "ofdm1024qam_5g=
"),
+
+	MATCH_NODE(struct nvram_info_t, txpwr_ofst.enable, "ofst_enable"),
+	MATCH_NODE(struct nvram_info_t, txpwr_ofst.chan_1_4, "ofst_chan_1_4"),
+	MATCH_NODE(struct nvram_info_t, txpwr_ofst.chan_5_9, "ofst_chan_5_9"),
+	MATCH_NODE(struct nvram_info_t, txpwr_ofst.chan_10_13, "ofst_chan_10_13")=
,
+	MATCH_NODE(struct nvram_info_t, txpwr_ofst.chan_36_64, "ofst_chan_36_64")=
,
+	MATCH_NODE(struct nvram_info_t, txpwr_ofst.chan_100_120, "ofst_chan_100_1=
20"),
+	MATCH_NODE(struct nvram_info_t, txpwr_ofst.chan_122_140, "ofst_chan_122_1=
40"),
+	MATCH_NODE(struct nvram_info_t, txpwr_ofst.chan_142_165, "ofst_chan_142_1=
65"),
+
+	MATCH_NODE(struct nvram_info_t, xtal_cap.enable, "xtal_enable"),
+	MATCH_NODE(struct nvram_info_t, xtal_cap.xtal_cap, "xtal_cap"),
+	MATCH_NODE(struct nvram_info_t, xtal_cap.xtal_cap_fine, "xtal_cap_fine"),
+};
+
+static int parse_key_val(const char *str, const char *key, char *val)
+{
+	const char *p =3D NULL;
+	const char *dst =3D NULL;
+	int keysize =3D 0;
+	int bufsize =3D 0;
+
+	if (!str || !key || !val)
+		return -1;
+
+	keysize =3D strlen(key);
+	bufsize =3D strlen(str);
+	if (bufsize <=3D keysize)
+		return -1;
+
+	p =3D str;
+	while (*p !=3D 0 && *p =3D=3D ' ')
+		p++;
+
+	if (*p =3D=3D '#')
+		return -1;
+
+	if (str + bufsize - p <=3D keysize)
+		return -1;
+
+	if (strncmp(p, key, keysize) !=3D 0)
+		return -1;
+
+	p +=3D keysize;
+
+	while (*p !=3D 0 && *p =3D=3D ' ')
+		p++;
+
+	if (*p !=3D '=3D')
+		return -1;
+
+	p++;
+	while (*p !=3D 0 && *p =3D=3D ' ')
+		p++;
+
+	if (*p =3D=3D '"')
+		p++;
+
+	dst =3D p;
+	while (*p !=3D 0)
+		p++;
+
+	p--;
+	while (*p =3D=3D ' ')
+		p--;
+
+	if (*p =3D=3D '"')
+		p--;
+
+	while (*p =3D=3D '\r' || *p =3D=3D '\n')
+		p--;
+
+	p++;
+	strscpy(val, dst, p - dst);
+	val[p - dst] =3D 0;
+	return 0;
+}
+
+int rwnx_atoi(char *value)
+{
+	int len =3D 0;
+	int i =3D 0;
+	int result =3D 0;
+	int flag =3D 1;
+
+	if (value[0] =3D=3D '-') {
+		flag =3D -1;
+		value++;
+	}
+	len =3D strlen(value);
+
+	for (i =3D 0; i < len; i++) {
+		result =3D result * 10;
+		if (value[i] >=3D 48 && value[i] <=3D 57) {
+			result +=3D value[i] - 48;
+		} else {
+			result =3D 0;
+			break;
+		}
+	}
+
+	return result * flag;
+}
+
+static int rwnx_parse_mul_value(char *line, char *val[])
+{
+	int nargs =3D 0;
+
+	while (nargs < 10) {
+		while ((*line =3D=3D ' ') || (*line =3D=3D '\t'))
+			++line;
+
+		if (*line =3D=3D '\0') { /* end of line, no more args    */
+			//AICWFDBG(LOGDEBUG, "%s p1,%d\n", __func__, nargs);
+			return nargs;
+		}
+
+		val[nargs++] =3D line; /* begin of argument string    */
+
+		/* find end of string */
+		while (*line && (*line !=3D ' ') && (*line !=3D '\t'))
+			++line;
+
+		if (*line =3D=3D '\0') { /* end of line, no more args    */
+			//AICWFDBG(LOGDEBUG, "%s p2,%d\n", __func__, nargs);
+			return nargs;
+		}
+
+		*line++ =3D '\0'; /* terminate current arg     */
+	}
+
+	AICWFDBG(LOGDEBUG, "nargs: %d\n", nargs);
+	//AICWFDBG(LOGDEBUG, "%s exit,%d\n", __func__, nargs);
+	return nargs;
+}
+
+int get_ccode_region(char *ccode)
+{
+	int i, cnt;
+
+	AICWFDBG(LOGDEBUG, "%s ccode:%s\r\n", __func__, ccode);
+	cnt =3D ARRAY_SIZE(reg_tables);
+
+	for (i =3D 0; i < cnt; i++) {
+		if (reg_tables[i].ccode[0] =3D=3D ccode[0] &&
+		    reg_tables[i].ccode[1] =3D=3D ccode[1]) {
+			AICWFDBG(LOGDEBUG, "region: %d\r\n", reg_tables[i].region);
+			return reg_tables[i].region;
+		}
+	}
+	AICWFDBG(LOGDEBUG, "use default region\r\n");
+	return REGIONS_DEFAULT;
+}
+
+void rwnx_plat_nvram_set_value(char *command, char *value)
+{
+	// TODO send command
+	AICWFDBG(LOGDEBUG, "%s:command=3D%s value=3D%s\n", __func__, command, val=
ue);
+	if (!strcmp(command, "enable")) {
+		userconfig_info.txpwr_lvl.enable =3D rwnx_atoi(value);
+		userconfig_info.txpwr_lvl_v2.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "dsss")) {
+		userconfig_info.txpwr_lvl.dsss =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdmlowrate_2g4")) {
+		userconfig_info.txpwr_lvl.ofdmlowrate_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm64qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm64qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm256qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm256qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm1024qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm1024qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdmlowrate_5g")) {
+		userconfig_info.txpwr_lvl.ofdmlowrate_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm64qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm64qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm256qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm256qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm1024qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm1024qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11b_11ag_1m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_2m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_5m5_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_11m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_6m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_9m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_12m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[6] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_18m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[7] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_24m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[8] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_36m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[9] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_48m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[10] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "lvl_11b_11ag_54m_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11b_11ag_2g4[11] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs0_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs1_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs2_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs3_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs4_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs5_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs6_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[6] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs7_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[7] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs8_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[8] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs9_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11n_11ac_2g4[9] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11ax_mcs0_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[0] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs1_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[1] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs2_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[2] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs3_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[3] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs4_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[4] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs5_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[5] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs6_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[6] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs7_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[7] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs8_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[8] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs9_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[9] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs10_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[10] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs11_2g4")) {
+		userconfig_info.txpwr_lvl_v2.pwrlvl_11ax_2g4[11] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_enable")) {
+		userconfig_info.txpwr_ofst.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_1_4")) {
+		userconfig_info.txpwr_ofst.chan_1_4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_5_9")) {
+		userconfig_info.txpwr_ofst.chan_5_9 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_10_13")) {
+		userconfig_info.txpwr_ofst.chan_10_13 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_36_64")) {
+		userconfig_info.txpwr_ofst.chan_36_64 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_100_120")) {
+		userconfig_info.txpwr_ofst.chan_100_120 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_122_140")) {
+		userconfig_info.txpwr_ofst.chan_122_140 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_142_165")) {
+		userconfig_info.txpwr_ofst.chan_142_165 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "xtal_enable")) {
+		userconfig_info.xtal_cap.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "xtal_cap")) {
+		userconfig_info.xtal_cap.xtal_cap =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "xtal_cap_fine")) {
+		userconfig_info.xtal_cap.xtal_cap_fine =3D rwnx_atoi(value);
+	} else {
+		AICWFDBG(LOGERROR, "invalid cmd: %s\n", command);
+	}
+}
+
+void rwnx_plat_nvram_set_value_group(char *command, char *value)
+{
+	char *mul_val[10];
+	int i;
+
+	// TODO send command
+	AICWFDBG(LOGDEBUG, "%s:command=3D%s value=3D%s\n", __func__, command, val=
ue);
+	if (!strcmp(command, "enable")) {
+		userconfig_info.txpwr_lvl.enable =3D rwnx_atoi(value);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "dsss")) {
+		userconfig_info.txpwr_lvl.dsss =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdmlowrate_2g4")) {
+		userconfig_info.txpwr_lvl.ofdmlowrate_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm64qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm64qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm256qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm256qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm1024qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm1024qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdmlowrate_5g")) {
+		userconfig_info.txpwr_lvl.ofdmlowrate_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm64qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm64qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm256qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm256qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm1024qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm1024qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11b_11ag_1m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[0] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_2m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[1] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_5m5_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[2] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_11m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[3] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_6m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[4] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_9m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[5] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_12m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[6] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_18m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[7] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_24m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[8] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_36m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[9] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_48m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[10] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11b_11ag_54m_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11b_11ag_2g4[11] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs0_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[0] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs1_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[1] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs2_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[2] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs3_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[3] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs4_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[4] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs5_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[5] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs6_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[6] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs7_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[7] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs8_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[8] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs9_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_2g4[9] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs0_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[0] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs1_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[1] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs2_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[2] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs3_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[3] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs4_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[4] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs5_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[5] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs6_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[6] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs7_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[7] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs8_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[8] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs9_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[9] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs10_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[10] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs11_2g4")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_2g4[11] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_1m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[0] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_2m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[1] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_5m5_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[2] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_11m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[3] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_6m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[4] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_9m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[5] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_12m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[6] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_18m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[7] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_24m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[8] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_36m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[9] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_48m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[10] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11a_54m_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11a_5g[11] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs0_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[0] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs1_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[1] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs2_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[2] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs3_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[3] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs4_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[4] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs5_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[5] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs6_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[6] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs7_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[7] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs8_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[8] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs9_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11n_11ac_5g[9] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs0_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[0] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs1_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[1] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs2_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[2] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs3_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[3] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs4_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[4] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs5_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[5] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs6_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[6] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs7_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[7] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs8_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[8] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs9_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[9] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs10_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[10] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_11ax_mcs11_5g")) {
+		rwnx_parse_mul_value(value, mul_val);
+		for (i =3D 0; i < REGION_NUM_MAX; i++)
+			userconfig_info.txpwr_lvl_v3_gp[i].pwrlvl_11ax_5g[11] =3D
+				rwnx_atoi(mul_val[i]);
+	} else if (!strcmp(command, "lvl_adj_enable")) {
+		userconfig_info.txpwr_lvl_adj.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_2g4_chan_1_4")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_2g4[0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_adj_2g4_chan_5_9")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_2g4[1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_adj_2g4_chan_10_13")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_2g4[2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_adj_5g_chan_42")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[0] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_58")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[1] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_106")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[2] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_122")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[3] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_138")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[4] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_155")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[5] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "loss_enable_2g4")) {
+		userconfig_info.txpwr_loss.loss_enable_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "loss_value_2g4")) {
+		userconfig_info.txpwr_loss.loss_value_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "loss_enable_5g")) {
+		userconfig_info.txpwr_loss.loss_enable_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "loss_value_5g")) {
+		userconfig_info.txpwr_loss.loss_value_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_enable")) {
+		userconfig_info.txpwr_ofst.enable =3D rwnx_atoi(value);
+		userconfig_info.txpwr_ofst2x.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_1_4")) {
+		userconfig_info.txpwr_ofst.chan_1_4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_5_9")) {
+		userconfig_info.txpwr_ofst.chan_5_9 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_10_13")) {
+		userconfig_info.txpwr_ofst.chan_10_13 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_36_64")) {
+		userconfig_info.txpwr_ofst.chan_36_64 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_100_120")) {
+		userconfig_info.txpwr_ofst.chan_100_120 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_122_140")) {
+		userconfig_info.txpwr_ofst.chan_122_140 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_142_165")) {
+		userconfig_info.txpwr_ofst.chan_142_165 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_2g4_11b_chan_1_4")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[0][0] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_11b_chan_5_9")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[0][1] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_11b_chan_10_13")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[0][2] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_highrate_chan_1_4")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[1][0] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_highrate_chan_5_9")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[1][1] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_highrate_chan_10_13")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[1][2] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_lowrate_chan_1_4")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[2][0] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_lowrate_chan_5_9")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[2][1] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_lowrate_chan_10_13")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[2][0] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_42")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_58")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_106")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_122")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_138")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_155")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_42")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_58")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_106")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_122")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_138")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_155")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_42")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_58")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_106")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_122")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_138")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_155")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "xtal_enable")) {
+		userconfig_info.xtal_cap.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "xtal_cap")) {
+		userconfig_info.xtal_cap.xtal_cap =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "xtal_cap_fine")) {
+		userconfig_info.xtal_cap.xtal_cap_fine =3D rwnx_atoi(value);
+	} else {
+		AICWFDBG(LOGERROR, "invalid cmd: %s\n", command);
+	}
+}
+
+void rwnx_plat_nvram_set_value_v3(char *command, char *value)
+{
+	// TODO send command
+	AICWFDBG(LOGDEBUG, "%s:command=3D%s value=3D%s\n", __func__, command, val=
ue);
+	//AICWFDBG(LOGDEBUG, "AICWF command=3D%s value=3D%s\n", command, value);
+	if (!strcmp(command, "enable")) {
+		userconfig_info.txpwr_lvl.enable =3D rwnx_atoi(value);
+		userconfig_info.txpwr_lvl_v3.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "dsss")) {
+		userconfig_info.txpwr_lvl.dsss =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdmlowrate_2g4")) {
+		userconfig_info.txpwr_lvl.ofdmlowrate_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm64qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm64qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm256qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm256qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm1024qam_2g4")) {
+		userconfig_info.txpwr_lvl.ofdm1024qam_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdmlowrate_5g")) {
+		userconfig_info.txpwr_lvl.ofdmlowrate_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm64qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm64qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm256qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm256qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofdm1024qam_5g")) {
+		userconfig_info.txpwr_lvl.ofdm1024qam_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11b_11ag_1m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_2m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_5m5_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_11m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_6m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_9m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_12m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[6] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_18m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[7] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_24m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[8] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_36m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[9] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11b_11ag_48m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[10] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "lvl_11b_11ag_54m_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11b_11ag_2g4[11] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs0_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs1_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs2_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs3_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs4_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs5_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs6_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[6] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs7_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[7] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs8_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[8] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs9_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_2g4[9] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_11ax_mcs0_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[0] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs1_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[1] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs2_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[2] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs3_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[3] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs4_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[4] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs5_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[5] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs6_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[6] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs7_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[7] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs8_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[8] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs9_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[9] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs10_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[10] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs11_2g4")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_2g4[11] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_1m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[0] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_2m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[1] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_5m5_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[2] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_11m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[3] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_6m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[4] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_9m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[5] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_12m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[6] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_18m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[7] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_24m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[8] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_36m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[9] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_48m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[10] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11a_54m_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11a_5g[11] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs0_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[0] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs1_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[1] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs2_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[2] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs3_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[3] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs4_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[4] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs5_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[5] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs6_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[6] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs7_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[7] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs8_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[8] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11n_11ac_mcs9_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11n_11ac_5g[9] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs0_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[0] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs1_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[1] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs2_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[2] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs3_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[3] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs4_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[4] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs5_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[5] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs6_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[6] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs7_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[7] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs8_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[8] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs9_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[9] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs10_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[10] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_11ax_mcs11_5g")) {
+		userconfig_info.txpwr_lvl_v3.pwrlvl_11ax_5g[11] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_enable")) {
+		userconfig_info.txpwr_lvl_adj.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_2g4_chan_1_4")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_2g4[0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_adj_2g4_chan_5_9")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_2g4[1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_adj_2g4_chan_10_13")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_2g4[2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "lvl_adj_5g_chan_42")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[0] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_58")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[1] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_106")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[2] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_122")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[3] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_138")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[4] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "lvl_adj_5g_chan_155")) {
+		userconfig_info.txpwr_lvl_adj.pwrlvl_adj_tbl_5g[5] =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "loss_enable_2g4")) {
+		userconfig_info.txpwr_loss.loss_enable_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "loss_value_2g4")) {
+		userconfig_info.txpwr_loss.loss_value_2g4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "loss_enable_5g")) {
+		userconfig_info.txpwr_loss.loss_enable_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "loss_value_5g")) {
+		userconfig_info.txpwr_loss.loss_value_5g =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_enable")) {
+		userconfig_info.txpwr_ofst.enable =3D rwnx_atoi(value);
+		userconfig_info.txpwr_ofst2x.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_1_4")) {
+		userconfig_info.txpwr_ofst.chan_1_4 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_5_9")) {
+		userconfig_info.txpwr_ofst.chan_5_9 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_10_13")) {
+		userconfig_info.txpwr_ofst.chan_10_13 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_36_64")) {
+		userconfig_info.txpwr_ofst.chan_36_64 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_100_120")) {
+		userconfig_info.txpwr_ofst.chan_100_120 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_122_140")) {
+		userconfig_info.txpwr_ofst.chan_122_140 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_chan_142_165")) {
+		userconfig_info.txpwr_ofst.chan_142_165 =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "ofst_2g4_11b_chan_1_4")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[0][0] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_11b_chan_5_9")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[0][1] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_11b_chan_10_13")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[0][2] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_highrate_chan_1_4")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[1][0] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_highrate_chan_5_9")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[1][1] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_highrate_chan_10_13")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[1][2] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_lowrate_chan_1_4")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[2][0] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_lowrate_chan_5_9")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[2][1] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_2g4_ofdm_lowrate_chan_10_13")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_2g4[2][0] =3D rwnx_atoi(value=
);
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_42")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_58")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_106")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_122")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_138")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_lowrate_chan_155")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[0][5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_42")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_58")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_106")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_122")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_138")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_highrate_chan_155")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[1][5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_42")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][0] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_58")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][1] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_106")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][2] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_122")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][3] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_138")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][4] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "ofst_5g_ofdm_midrate_chan_155")) {
+		userconfig_info.txpwr_ofst2x.pwrofst2x_tbl_5g[2][5] =3D rwnx_atoi(value)=
;
+	} else if (!strcmp(command, "xtal_enable")) {
+		userconfig_info.xtal_cap.enable =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "xtal_cap")) {
+		userconfig_info.xtal_cap.xtal_cap =3D rwnx_atoi(value);
+	} else if (!strcmp(command, "xtal_cap_fine")) {
+		userconfig_info.xtal_cap.xtal_cap_fine =3D rwnx_atoi(value);
+	} else {
+		AICWFDBG(LOGERROR, "invalid cmd: %s\n", command);
+	}
+}
+
+void rwnx_plat_userconfig_parsing2(char *buffer, int size)
+{
+	int i =3D 0;
+	int parse_state =3D 0;
+	char command[30];
+	char value[100];
+	int char_counter =3D 0;
+
+	memset(command, 0, 30);
+	memset(value, 0, 100);
+
+	for (i =3D 0; i < size; i++) {
+		// Send command or print nvram log when char is \r or \n
+		if (buffer[i] =3D=3D 0x0a || buffer[i] =3D=3D 0x0d) {
+			if (command[0] !=3D 0 && value[0] !=3D 0) {
+				if (parse_state =3D=3D PRINT)
+					AICWFDBG(LOGINFO, "%s:%s\r\n", __func__, value);
+				else if (parse_state =3D=3D GET_VALUE)
+					rwnx_plat_nvram_set_value(command, value);
+			}
+			// Reset command value and char_counter
+			memset(command, 0, 30);
+			memset(value, 0, 100);
+			char_counter =3D 0;
+			parse_state =3D INIT;
+			continue;
+		}
+
+		// Switch parser state
+		if (parse_state =3D=3D INIT) {
+			if (buffer[i] =3D=3D '#') {
+				parse_state =3D PRINT;
+				continue;
+			} else if (buffer[i] =3D=3D 0x0a || buffer[i] =3D=3D 0x0d) {
+				parse_state =3D INIT;
+				continue;
+			} else {
+				parse_state =3D CMD;
+			}
+		}
+
+		// Fill data to command and value
+		if (parse_state =3D=3D PRINT) {
+			command[0] =3D 0x01;
+			value[char_counter] =3D buffer[i];
+			char_counter++;
+		} else if (parse_state =3D=3D CMD) {
+			if (command[0] !=3D 0 && buffer[i] =3D=3D '=3D') {
+				parse_state =3D GET_VALUE;
+				char_counter =3D 0;
+				continue;
+			}
+			command[char_counter] =3D buffer[i];
+			char_counter++;
+		} else if (parse_state =3D=3D GET_VALUE) {
+			value[char_counter] =3D buffer[i];
+			char_counter++;
+		}
+	}
+}
+
+void rwnx_plat_userconfig_parsing3(char *buffer, int size)
+{
+	int i =3D 0;
+	int parse_state =3D 0;
+	char command[64];
+	char value[100];
+	int char_counter =3D 0;
+	u8_l area_pw =3D 0;
+
+	memset(command, 0, 64);
+	memset(value, 0, 100);
+
+	for (i =3D 0; i < size; i++) {
+		// Send command or print nvram log when char is \r or \n
+		if (buffer[i] =3D=3D 0x0a || buffer[i] =3D=3D 0x0d) {
+			if (command[0] !=3D 0 && value[0] !=3D 0) {
+				if (parse_state =3D=3D PRINT) {
+					if (area_pw =3D=3D 0 &&
+					    strnstr(value, "SRRC", strlen(value))) {
+						area_pw =3D 1;
+						AICWFDBG(LOGINFO,
+							 "use diff_area_power userconfig\n");
+					}
+					AICWFDBG(LOGINFO, "%s:%s\r\n", __func__, value);
+				} else if (parse_state =3D=3D GET_VALUE) {
+					if (area_pw)
+						rwnx_plat_nvram_set_value_group(command, value);
+					else
+						rwnx_plat_nvram_set_value_v3(command, value);
+				}
+			}
+			// Reset command value and char_counter
+			memset(command, 0, 64);
+			memset(value, 0, 100);
+			char_counter =3D 0;
+			parse_state =3D INIT;
+			continue;
+		}
+
+		// Switch parser state
+		if (parse_state =3D=3D INIT) {
+			if (buffer[i] =3D=3D '#') {
+				parse_state =3D PRINT;
+				continue;
+			} else if (buffer[i] =3D=3D 0x0a || buffer[i] =3D=3D 0x0d) {
+				parse_state =3D INIT;
+				continue;
+			} else {
+				parse_state =3D CMD;
+			}
+		}
+
+		// Fill data to command and value
+		if (parse_state =3D=3D PRINT) {
+			command[0] =3D 0x01;
+			value[char_counter] =3D buffer[i];
+			char_counter++;
+		} else if (parse_state =3D=3D CMD) {
+			if (command[0] !=3D 0 && buffer[i] =3D=3D '=3D') {
+				parse_state =3D GET_VALUE;
+				char_counter =3D 0;
+				continue;
+			}
+			command[char_counter] =3D buffer[i];
+			char_counter++;
+		} else if (parse_state =3D=3D GET_VALUE) {
+			if (buffer[i] !=3D 0x2D &&
+			    (buffer[i] < 0x30 || buffer[i] > 0x39) &&
+			    buffer[i] !=3D 0x20)
+				continue;
+			value[char_counter] =3D buffer[i];
+			char_counter++;
+		}
+	}
+}
+
+void rwnx_plat_userconfig_parsing(struct rwnx_hw *rwnx_hw, char *buffer,
+				  int size)
+{
+	char conf[100], keyname[64];
+	char *line;
+	char *data;
+	int i =3D 0, len =3D 0;
+	long val;
+
+	if (size <=3D 0) {
+		pr_err("Config buffer size %d error\n", size);
+		return;
+	}
+
+	AICWFDBG(LOGDEBUG, "AICWF %s rwnx_hw->vendor_info:0x%02X \r\n", __func__,
+		 rwnx_hw->vendor_info);
+	if (rwnx_hw->vendor_info =3D=3D 0x00 ||
+	    rwnx_hw->vendor_info > (ARRAY_SIZE(parse_key_prefix) - 1)) {
+		AICWFDBG(LOGDEBUG, "AICWF Unsuppor vendor info config\n");
+		AICWFDBG(LOGDEBUG, "AICWF Using module0 config\n");
+		rwnx_hw->vendor_info =3D 0x01;
+		// return;
+	}
+
+	data =3D vmalloc(size + 1);
+	if (!data) {
+		AICWFDBG(LOGERROR, "%s vmalloc fail\n", __func__);
+		return;
+	}
+
+	memcpy(data, buffer, size);
+	buffer =3D data;
+
+	while (1) {
+		line =3D buffer;
+		if (*line =3D=3D 0)
+			break;
+
+		while (*buffer !=3D '\r' && *buffer !=3D '\n' &&
+		       *buffer !=3D 0 && len++ < size)
+			buffer++;
+
+		while ((*buffer =3D=3D '\r' || *buffer =3D=3D '\n') && len++ < size)
+			*buffer++ =3D 0;
+
+		if (len >=3D size)
+			*buffer =3D 0;
+
+		// store value to data struct
+		for (i =3D 0; i < ARRAY_SIZE(parse_match_tab); i++) {
+			scnprintf(keyname, sizeof(keyname), "%s%s",
+				  parse_key_prefix[rwnx_hw->vendor_info],
+				  parse_match_tab[i].keyname);
+			if (parse_key_val(line, keyname, conf) =3D=3D 0) {
+				if (kstrtol(conf, 0, &val)) {
+					pr_warn("Invalid value for %s\n", keyname);
+					continue;
+				}
+				*(unsigned long *)((unsigned long)&nvram_info +
+								parse_match_tab[i].offset) =3D val;
+				AICWFDBG(LOGDEBUG, "AICWF %s, %s =3D %ld\n", __func__,
+					 parse_match_tab[i].keyname, val);
+				break;
+			}
+		}
+	}
+	vfree(data);
+}
+
+int rwnx_plat_userconfig_upload(struct rwnx_hw *rwnx_hw,
+				const char *filename)
+{
+	int size;
+	u32 *dst =3D NULL;
+
+	AICWFDBG(LOGDEBUG, "AICWF userconfig file path:%s \r\n", filename);
+
+	/* load aic firmware */
+	size =3D rwnx_load_firmware(&dst, filename, rwnx_hw->dev);
+	if (size <=3D 0) {
+		AICWFDBG(LOGDEBUG, "AICWF wrong size of firmware file\n");
+		vfree(dst);
+		dst =3D NULL;
+		return 0;
+	}
+
+	/* Copy the file on the Embedded side */
+	AICWFDBG(LOGDEBUG, "AICWF ### Upload %s userconfig, size=3D%d\n", filenam=
e, size);
+
+	rwnx_plat_userconfig_parsing(rwnx_hw, (char *)dst, size);
+
+	if (dst) {
+		vfree(dst);
+		dst =3D NULL;
+	}
+
+	AICWFDBG(LOGDEBUG, "AICWF userconfig download complete\n\n");
+
+	return 0;
+}
+
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+static inline char *get_line_from_buffer(char **buffer)
+{
+	return strsep(buffer, "\n");
+}
+
+int is_all_space_or_tab(u8_l *data, u8_l size)
+{
+	u8_l cnt =3D 0;
+	u8_l num_of_space_and_tab =3D 0;
+
+	while (size > cnt) {
+		if (data[cnt] =3D=3D ' ' || data[cnt] =3D=3D '\t' || data[cnt] =3D=3D '\=
0')
+			++num_of_space_and_tab;
+		++cnt;
+	}
+	return size =3D=3D num_of_space_and_tab;
+}
+
+int is_comment_string(char *sz_str)
+{
+	if (*sz_str =3D=3D '#' && *(sz_str + 1) =3D=3D ' ')
+		return 1;
+	else
+		return 0;
+}
+
+int is_enable_limit(char *szs_str)
+{
+	int i =3D 0, value =3D 0;
+	char en[15];
+
+	if (*szs_str =3D=3D '#' && *(szs_str + 1) =3D=3D '*') {
+		i =3D 2;
+		while (szs_str[i] !=3D '=3D' && (i < 15)) {
+			en[i - 2] =3D szs_str[i];
+			i++;
+		}
+		en[i - 2] =3D '\0';
+		i +=3D 1;
+		if (strncmp(en, "enable", 6) =3D=3D 0) {
+			value =3D rwnx_atoi(szs_str + i);
+			if (value =3D=3D 1)
+				return 1;
+			else
+				return 0;
+		}
+	}
+	return -1;
+}
+
+int parse_qualified_string(char *in, u32 *start, char *out, char left_qual=
ifier,
+			   char right_qualifier)
+{
+	u32 i =3D 0, j =3D 0;
+	char c =3D in[(*start)++];
+
+	if (c !=3D left_qualifier)
+		return 0;
+	i =3D (*start);
+	c =3D in[(*start)++];
+	while (c !=3D right_qualifier && c !=3D '\0')
+		c =3D in[(*start)++];
+	if (c =3D=3D '\0')
+		return 0;
+	j =3D (*start) - 2;
+	strscpy((char *)out, (const char *)(in + i), j - i + 1);
+	return 1;
+}
+
+int get_u1_byte_integer_from_string_in_decimal(char *str, u8 *p_int)
+{
+	u16 i =3D 0;
+	*p_int =3D 0;
+	while (str[i] !=3D '\0') {
+		if (str[i] >=3D '0' && str[i] <=3D '9') {
+			*p_int *=3D 10;
+			*p_int +=3D (str[i] - '0');
+		} else {
+			return 0;
+		}
+		++i;
+	}
+	return 1;
+}
+
+int get_s1_byte_integer_from_string_in_decimal(char *str, s8 *val)
+{
+	u8 negative =3D 0;
+	u16 i =3D 0;
+	*val =3D 0;
+	while (str[i] !=3D '\0') {
+		if (i =3D=3D 0 && (str[i] =3D=3D '+' || str[i] =3D=3D '-')) {
+			if (str[i] =3D=3D '-')
+				negative =3D 1;
+		} else if (str[i] >=3D '0' && str[i] <=3D '9') {
+			*val *=3D 10;
+			*val +=3D (str[i] - '0');
+		} else {
+			return 0;
+		}
+		++i;
+	}
+	if (negative)
+		*val =3D -*val;
+	return 1;
+}
+
+static void update_power_limit(u8 band_cc, const char *channel, u8 channel=
_num,
+			       const char *power_limit, u8 power_limit_val,
+			       struct powerlimit_info_t *powerlimit_info)
+{
+	if (band_cc =3D=3D PHY_BAND_2G4) {
+		u8 cur_idx =3D powerlimit_info->txpwr_lmt.ch_cnt_2g4;
+
+		if (cur_idx =3D=3D 0)
+			AICWFDBG(LOGDEBUG, "[%d]: ch=3D%s, pwr=3D%s\n", cur_idx, channel, power=
_limit);
+		if (cur_idx < MAC_DOMAINCHANNEL_24G_MAX) {
+			powerlimit_info->txpwr_lmt.ch_num_2g4[cur_idx] =3D channel_num;
+			powerlimit_info->txpwr_lmt.max_pwr_2g4[cur_idx] =3D power_limit_val;
+			powerlimit_info->txpwr_lmt.ch_cnt_2g4++;
+		} else {
+			AICWFDBG(LOGERROR, "band %d chan_cnt reached %d\n",
+				 band_cc, MAC_DOMAINCHANNEL_24G_MAX);
+			AICWFDBG(LOGERROR, "channel=3D%s(%d) powerLimit=3D%s(%d)\n",
+				 channel, channel_num, power_limit, power_limit_val);
+		}
+	} else if (band_cc =3D=3D PHY_BAND_5G) {
+		u8 cur_idx =3D powerlimit_info->txpwr_lmt.ch_cnt_5g;
+
+		if (cur_idx =3D=3D 0)
+			AICWFDBG(LOGDEBUG, "[%d]: ch=3D%s, pwr=3D%s\n", cur_idx, channel, power=
_limit);
+		if (cur_idx < MAC_DOMAINCHANNEL_5G_MAX) {
+			powerlimit_info->txpwr_lmt.ch_num_5g[cur_idx] =3D channel_num;
+			powerlimit_info->txpwr_lmt.max_pwr_5g[cur_idx] =3D power_limit_val;
+			powerlimit_info->txpwr_lmt.ch_cnt_5g++;
+		} else {
+			AICWFDBG(LOGERROR, "band %d chan_cnt reached %d\n",
+				 band_cc, MAC_DOMAINCHANNEL_5G_MAX);
+			AICWFDBG(LOGERROR, "channel=3D%s(%d) powerLimit=3D%s(%d)\n",
+				 channel, channel_num, power_limit, power_limit_val);
+		}
+	}
+}
+
+void rwnx_plat_powerlimit_parsing(char *buffer, int size, char *cc)
+{
+#define LD_STAGE_EXC_MAPPING   0
+#define LD_STAGE_TAB_DEFINE    1
+#define LD_STAGE_TAB_START     2
+#define LD_STAGE_COLUMN_DEFINE 3
+#define LD_STAGE_CH_ROW        4
+
+	u8_l loading_stage =3D LD_STAGE_EXC_MAPPING;
+	u32_l i =3D 0, for_cnt =3D 0;
+	u32_l i_cc;
+	char *sz_line, *ptmp;
+	char band[10], col_num_buf[10];
+	u8_l col_num =3D 0, col_num_cc =3D 255, band_cc =3D 0;
+	bool sp_cc =3D false;
+	// clear powerlimit info at first
+	memset((void *)&powerlimit_info, 0, sizeof(struct powerlimit_info_t));
+	ptmp =3D buffer;
+	for (sz_line =3D get_line_from_buffer(&ptmp); sz_line;
+	     sz_line =3D get_line_from_buffer(&ptmp)) {
+		if (is_all_space_or_tab(sz_line, sizeof(*sz_line)))
+			continue;
+
+		if (is_enable_limit(sz_line) =3D=3D 0)
+			return;
+
+		if (is_comment_string(sz_line))
+			continue;
+
+		if (loading_stage =3D=3D LD_STAGE_EXC_MAPPING) {
+			if (sz_line[0] =3D=3D '#' || sz_line[1] =3D=3D '#')
+				loading_stage =3D LD_STAGE_TAB_DEFINE;
+			else
+				continue;
+		}
+
+		if (loading_stage =3D=3D LD_STAGE_TAB_DEFINE) {
+			/* read "##	2.4G" */
+			if (sz_line[0] !=3D '#' || sz_line[1] !=3D '#')
+				continue;
+
+			/* skip the space */
+			i =3D 2;
+			while (sz_line[i] =3D=3D ' ' || sz_line[i] =3D=3D '\t')
+				++i;
+
+			sz_line[--i] =3D
+				' '; /* return the space in front of the regulation info */
+
+			/* Parse the label of the table */
+			memset((void *)band, 0, 10);
+			if (!parse_qualified_string(sz_line, &i, band, ' ', ',')) {
+				AICWFDBG(LOGERROR, "Fail to parse band!\n");
+				goto exit;
+			}
+			if (strncmp(band, "2.4G", 4) =3D=3D 0)
+				band_cc =3D PHY_BAND_2G4;
+			else if (strncmp(band, "5G", 2) =3D=3D 0)
+				band_cc =3D PHY_BAND_5G;
+
+			memset((void *)col_num_buf, 0, 10);
+			if (!parse_qualified_string(sz_line, &i, col_num_buf, '#', '#')) {
+				AICWFDBG(LOGERROR, "Fail to parse column number!\n");
+				goto exit;
+			}
+			if (!get_u1_byte_integer_from_string_in_decimal(col_num_buf, &col_num))=
 {
+				AICWFDBG(LOGERROR,
+					 "Column number \"%s\" is not unsigned decimal\n",
+					 col_num_buf);
+				goto exit;
+			}
+			if (col_num =3D=3D 0) {
+				AICWFDBG(LOGERROR, "Column number is 0\n");
+				goto exit;
+			}
+
+			AICWFDBG(LOGDEBUG, "band=3D%s(%d)\n", band, band_cc);
+			loading_stage =3D LD_STAGE_TAB_START;
+		} else if (loading_stage =3D=3D LD_STAGE_TAB_START) {
+			/* read "##	START" */
+			if (sz_line[0] !=3D '#' || sz_line[1] !=3D '#')
+				continue;
+
+			/* skip the space */
+			i =3D 2;
+			while (sz_line[i] =3D=3D ' ' || sz_line[i] =3D=3D '\t')
+				++i;
+
+			if (strncmp((u8 *)(sz_line + i), "START", 5)) {
+				AICWFDBG(LOGERROR, "Missing \"##   START\" label\n");
+				goto exit;
+			}
+
+			loading_stage =3D LD_STAGE_COLUMN_DEFINE;
+		} else if (loading_stage =3D=3D LD_STAGE_COLUMN_DEFINE) {
+			/* read "##	CN	US" */
+			if (sz_line[0] !=3D '#' || sz_line[1] !=3D '#')
+				continue;
+
+			/* skip the space */
+			i =3D 2;
+			while (sz_line[i] =3D=3D ' ' || sz_line[i] =3D=3D '\t')
+				++i;
+
+			for (for_cnt =3D 0; for_cnt < col_num; for_cnt++) {
+				/* skip the space */
+				while (sz_line[i] =3D=3D ' ' || sz_line[i] =3D=3D '\t')
+					i++;
+				i_cc =3D i;
+
+				while (sz_line[i] !=3D ' ' && sz_line[i] !=3D '\t' &&
+				       sz_line[i] !=3D '\0')
+					i++;
+
+				if ((i - i_cc) !=3D 2) {
+					AICWFDBG(LOGERROR, "CC len err\n");
+					goto exit;
+				} else if ((sz_line[i_cc] =3D=3D cc[0]) &&
+						   (sz_line[i_cc + 1] =3D=3D cc[1])) {
+					AICWFDBG(LOGDEBUG, "CC matched: %s, col=3D%d\n", cc, for_cnt);
+					col_num_cc =3D for_cnt;
+					powerlimit_info.flags |=3D POWER_LIMIT_CC_MATCHED_BIT;
+					sp_cc =3D true;
+					break;
+				}
+			}
+			if (!sp_cc) {
+				col_num_cc =3D col_num - 1;
+				AICWFDBG(LOGDEBUG, "use 00: %s, col_num_cc=3D%d\n", cc, col_num_cc);
+				powerlimit_info.flags |=3D POWER_LIMIT_CC_MATCHED_BIT;
+			}
+
+			loading_stage =3D LD_STAGE_CH_ROW;
+		} else if (loading_stage =3D=3D LD_STAGE_CH_ROW) {
+			char channel[10] =3D {0}, power_limit[10] =3D {0};
+			u8 channel_num, power_limit_val, cnt =3D 0;
+
+			/* the table ends */
+			if (sz_line[0] =3D=3D '#' && sz_line[1] =3D=3D '#') {
+				i =3D 2;
+				while (sz_line[i] =3D=3D ' ' || sz_line[i] =3D=3D '\t')
+					++i;
+
+				if (strncmp((u8 *)(sz_line + i), "END", 3) =3D=3D 0) {
+					loading_stage =3D LD_STAGE_TAB_DEFINE;
+					col_num =3D 0;
+					continue;
+				} else {
+					AICWFDBG(LOGERROR, "Missing \"##   END\" label\n");
+					goto exit;
+				}
+			}
+
+			if ((sz_line[0] !=3D 'c' && sz_line[0] !=3D 'C') ||
+			    (sz_line[1] !=3D 'h' && sz_line[1] !=3D 'H')) {
+				AICWFDBG(LOGERROR, "Wrong channel prefix: '%c','%c'(%d,%d)\n",
+					 sz_line[0], sz_line[1], sz_line[0], sz_line[1]);
+				continue;
+			}
+			i =3D 2; /* move to the  location behind 'h' */
+
+			/* load the channel number */
+			cnt =3D 0;
+			while (sz_line[i] >=3D '0' && sz_line[i] <=3D '9') {
+				channel[cnt] =3D sz_line[i];
+				++cnt;
+				++i;
+			}
+
+			for (for_cnt =3D 0; for_cnt < col_num; ++for_cnt) {
+				/* skip the space between channel number and the power limit
+				 * value
+				 */
+				while (sz_line[i] =3D=3D ' ' || sz_line[i] =3D=3D '\t')
+					++i;
+
+				/* load the power limit value */
+				memset((void *)power_limit, 0, 10);
+
+				if (sz_line[i] =3D=3D 'N' && sz_line[i + 1] =3D=3D 'A') {
+					/*
+					 * means channel not available
+					 */
+					sprintf(power_limit, "%d", POWER_LIMIT_INVALID_VAL);
+					i +=3D 2;
+				} else if ((sz_line[i] >=3D '0' && sz_line[i] <=3D '9') ||
+						   sz_line[i] =3D=3D '+' || sz_line[i] =3D=3D '-') {
+					/* case of dBm value */
+					cnt =3D 0;
+					while ((sz_line[i] >=3D '0' && sz_line[i] <=3D '9') ||
+					       sz_line[i] =3D=3D '+' || sz_line[i] =3D=3D '-') {
+						power_limit[cnt] =3D sz_line[i];
+						++cnt;
+						++i;
+					}
+				} else {
+					AICWFDBG
+					(LOGERROR, "Wrong limit expression \"%c%c\"(%d, %d)\n",
+					 sz_line[i], sz_line[i + 1], sz_line[i], sz_line[i + 1]);
+					goto exit;
+				}
+
+				if (for_cnt =3D=3D col_num_cc) {
+					/* store the power limit value */
+					if (get_u1_byte_integer_from_string_in_decimal
+						((char *)channel, &channel_num) =3D=3D 0 ||
+					    get_s1_byte_integer_from_string_in_decimal
+						((char *)power_limit, &power_limit_val) =3D=3D 0) {
+						AICWFDBG(LOGERROR,
+							 "Illegal index of power limit table [ch %s][val %s]\n",
+							 channel, power_limit);
+						goto exit;
+					}
+
+					update_power_limit(band_cc, channel, channel_num,
+							   power_limit, power_limit_val,
+							   &powerlimit_info);
+					break;
+				}
+			}
+		}
+	}
+exit:
+	return;
+}
+
+/// 5G lower bound freq
+#define PHY_FREQ_5G 5000
+
+u16_l phy_channel_to_freq(u8_l band, int channel)
+{
+	if (band =3D=3D PHY_BAND_2G4 && channel >=3D 1 && channel <=3D 14) {
+		if (channel =3D=3D 14)
+			return 2484;
+		else
+			return 2407 + channel * 5;
+	} else if (band =3D=3D PHY_BAND_5G && channel >=3D 1 && channel <=3D 165)=
 {
+		return PHY_FREQ_5G + channel * 5;
+	}
+	return 0;
+}
+
+s8_l get_powerlimit_by_freq(u8_l band, u16_l freq, u8_l *enable)
+{
+	s8_l ret =3D POWER_LIMIT_INVALID_VAL;
+	u8_l idx;
+
+	if ((powerlimit_info.flags & POWER_LIMIT_CC_MATCHED_BIT) =3D=3D 0) {
+		*enable =3D 0;
+	} else if (powerlimit_info.flags & POWER_LIMIT_CC_MATCHED_BIT) {
+		*enable =3D 1;
+
+		if (band =3D=3D PHY_BAND_2G4) {
+			u8_l idx_cnt =3D powerlimit_info.txpwr_lmt.ch_cnt_2g4;
+
+			for (idx =3D 0; idx < idx_cnt; idx++) {
+				int ch_num =3D powerlimit_info.txpwr_lmt.ch_num_2g4[idx];
+				u16_l freq_tmp =3D phy_channel_to_freq(PHY_BAND_2G4, ch_num);
+
+				if (freq =3D=3D freq_tmp) {
+					ret =3D powerlimit_info.txpwr_lmt.max_pwr_2g4[idx];
+					// AICWFDBG(LOGINFO, "[%d]: ch=3D%d(freq=3D%d), pwr=3D%d\n", idx,
+					// ch_num, freq, ret);
+					break;
+				}
+			}
+			if (idx =3D=3D idx_cnt) {
+				AICWFDBG(LOGERROR,
+					 "powerlimit search failed: band=3D%d freq=3D%d\n", band,
+					 freq);
+			}
+		} else if (band =3D=3D PHY_BAND_5G) {
+			u8_l idx_cnt =3D powerlimit_info.txpwr_lmt.ch_cnt_5g;
+
+			for (idx =3D 0; idx < idx_cnt; idx++) {
+				int ch_num =3D powerlimit_info.txpwr_lmt.ch_num_5g[idx];
+				u16_l freq_tmp =3D phy_channel_to_freq(PHY_BAND_5G, ch_num);
+
+				if (freq =3D=3D freq_tmp) {
+					ret =3D powerlimit_info.txpwr_lmt.max_pwr_5g[idx];
+					// AICWFDBG(LOGINFO, "[%d]: ch=3D%d(freq=3D%d), pwr=3D%d\n", idx,
+					// ch_num, freq, ret);
+					break;
+				}
+			}
+			if (idx =3D=3D idx_cnt) {
+				AICWFDBG(LOGERROR,
+					 "powerlimit search failed: band=3D%d freq=3D%d\n", band,
+					 freq);
+			}
+		}
+	}
+	return ret;
+}
+
+s8_l get_powerlimit_by_chnum(u8_l chnum, u8_l *enable)
+{
+	s8_l ret =3D POWER_LIMIT_INVALID_VAL;
+	u8_l idx;
+
+	if ((powerlimit_info.flags & POWER_LIMIT_CC_MATCHED_BIT) =3D=3D 0) {
+		*enable =3D 0;
+	} else if (powerlimit_info.flags & POWER_LIMIT_CC_MATCHED_BIT) {
+		*enable =3D 1;
+
+		if (chnum <=3D 14) {
+			u8_l idx_cnt =3D powerlimit_info.txpwr_lmt.ch_cnt_2g4;
+
+			for (idx =3D 0; idx < idx_cnt; idx++) {
+				u8_l ch_num =3D powerlimit_info.txpwr_lmt.ch_num_2g4[idx];
+
+				if (chnum =3D=3D ch_num) {
+					ret =3D powerlimit_info.txpwr_lmt.max_pwr_2g4[idx];
+					// AICWFDBG(LOGINFO, "[%d]: ch=3D%d, pwr=3D%d\n", idx, ch_num,
+					// ret);
+					break;
+				}
+			}
+			if (idx =3D=3D idx_cnt) {
+				AICWFDBG(LOGERROR, "powerlimit search failed: chnum=3D%d\n",
+					 chnum);
+			}
+		} else if (chnum <=3D 165) {
+			u8_l idx_cnt =3D powerlimit_info.txpwr_lmt.ch_cnt_5g;
+
+			for (idx =3D 0; idx < idx_cnt; idx++) {
+				int ch_num =3D powerlimit_info.txpwr_lmt.ch_num_5g[idx];
+
+				if (chnum =3D=3D ch_num) {
+					ret =3D powerlimit_info.txpwr_lmt.max_pwr_5g[idx];
+					// AICWFDBG(LOGINFO, "[%d]: ch=3D%d, pwr=3D%d\n", idx, ch_num,
+					// ret);
+					break;
+				}
+			}
+			if (idx =3D=3D idx_cnt) {
+				AICWFDBG(LOGERROR, "powerlimit search failed: chnum=3D%d\n",
+					 chnum);
+			}
+		}
+	}
+	return ret;
+}
+#endif
+
+/**
+ * rwnx_platform_reset() - Reset the platform
+ *
+ * @rwnx_plat: platform data
+ */
+static int rwnx_platform_reset(struct rwnx_plat *rwnx_plat)
+{
+	u32 regval;
+
+#if defined(AICWF_SDIO_SUPPORT)
+	return 0;
+#endif
+
+	/*
+	 * the doc states that SOFT implies FPGA_B_RESET
+	 * adding FPGA_B_RESET is clearer
+	 */
+	RWNX_REG_WRITE(SOFT_RESET | FPGA_B_RESET, rwnx_plat, RWNX_ADDR_SYSTEM,
+		       SYSCTRL_MISC_CNTL_ADDR);
+	msleep(100);
+
+	regval =3D RWNX_REG_READ(rwnx_plat, RWNX_ADDR_SYSTEM, SYSCTRL_MISC_CNTL_A=
DDR);
+
+	if (regval & SOFT_RESET) {
+		dev_err(rwnx_platform_get_dev(rwnx_plat), "reset: failed\n");
+		return -EIO;
+	}
+
+	RWNX_REG_WRITE(regval & ~FPGA_B_RESET, rwnx_plat, RWNX_ADDR_SYSTEM,
+		       SYSCTRL_MISC_CNTL_ADDR);
+	msleep(100);
+	return 0;
+}
+
+/**
+ * rwmx_platform_save_config() - Save hardware config before reload
+ *
+ * @rwnx_plat: Pointer to platform data
+ *
+ * Return configuration registers values.
+ */
+static void *rwnx_term_save_config(struct rwnx_plat *rwnx_plat)
+{
+	const u32 *reg_list;
+	u32 *reg_value, *res;
+	int i, size =3D 0;
+
+	if (rwnx_plat->get_config_reg)
+		size =3D rwnx_plat->get_config_reg(rwnx_plat, &reg_list);
+
+	if (size <=3D 0)
+		return NULL;
+
+	// res =3D kmalloc(sizeof(u32) * size, GFP_KERNEL);
+	res =3D kmalloc_array(size, sizeof(u32), GFP_KERNEL);
+	if (!res)
+		return NULL;
+
+	reg_value =3D res;
+	for (i =3D 0; i < size; i++)
+		*reg_value++ =3D RWNX_REG_READ(rwnx_plat, RWNX_ADDR_SYSTEM, *reg_list++)=
;
+
+	return res;
+}
+
+void get_userconfig_txpwr_lvl_in_fdrv(struct txpwr_lvl_conf *txpwr_lvl)
+{
+	txpwr_lvl->enable =3D userconfig_info.txpwr_lvl.enable;
+	txpwr_lvl->dsss =3D userconfig_info.txpwr_lvl.dsss;
+	txpwr_lvl->ofdmlowrate_2g4 =3D userconfig_info.txpwr_lvl.ofdmlowrate_2g4;
+	txpwr_lvl->ofdm64qam_2g4 =3D userconfig_info.txpwr_lvl.ofdm64qam_2g4;
+	txpwr_lvl->ofdm256qam_2g4 =3D userconfig_info.txpwr_lvl.ofdm256qam_2g4;
+	txpwr_lvl->ofdm1024qam_2g4 =3D userconfig_info.txpwr_lvl.ofdm1024qam_2g4;
+	txpwr_lvl->ofdmlowrate_5g =3D userconfig_info.txpwr_lvl.ofdmlowrate_5g;
+	txpwr_lvl->ofdm64qam_5g =3D userconfig_info.txpwr_lvl.ofdm64qam_5g;
+	txpwr_lvl->ofdm256qam_5g =3D userconfig_info.txpwr_lvl.ofdm256qam_5g;
+	txpwr_lvl->ofdm1024qam_5g =3D userconfig_info.txpwr_lvl.ofdm1024qam_5g;
+
+	AICWFDBG(LOGDEBUG, "%s:enable:%d\r\n", __func__, txpwr_lvl->enable);
+	AICWFDBG(LOGDEBUG, "%s:dsss:%d\r\n", __func__, txpwr_lvl->dsss);
+	AICWFDBG(LOGDEBUG, "%s:ofdmlowrate_2g4:%d\r\n", __func__,
+		 txpwr_lvl->ofdmlowrate_2g4);
+	AICWFDBG(LOGDEBUG, "%s:ofdm64qam_2g4:%d\r\n", __func__,
+		 txpwr_lvl->ofdm64qam_2g4);
+	AICWFDBG(LOGDEBUG, "%s:ofdm256qam_2g4:%d\r\n", __func__,
+		 txpwr_lvl->ofdm256qam_2g4);
+	AICWFDBG(LOGDEBUG, "%s:ofdm1024qam_2g4:%d\r\n", __func__,
+		 txpwr_lvl->ofdm1024qam_2g4);
+	AICWFDBG(LOGDEBUG, "%s:ofdmlowrate_5g:%d\r\n", __func__,
+		 txpwr_lvl->ofdmlowrate_5g);
+	AICWFDBG(LOGDEBUG, "%s:ofdm64qam_5g:%d\r\n", __func__,
+		 txpwr_lvl->ofdm64qam_5g);
+	AICWFDBG(LOGDEBUG, "%s:ofdm256qam_5g:%d\r\n", __func__,
+		 txpwr_lvl->ofdm256qam_5g);
+	AICWFDBG(LOGDEBUG, "%s:ofdm1024qam_5g:%d\r\n", __func__,
+		 txpwr_lvl->ofdm1024qam_5g);
+}
+
+void get_userconfig_txpwr_lvl_v2_in_fdrv(struct txpwr_lvl_conf_v2 *txpwr_l=
vl_v2)
+{
+	*txpwr_lvl_v2 =3D userconfig_info.txpwr_lvl_v2;
+
+	AICWFDBG(LOGDEBUG, "%s:enable:%d\r\n", __func__, txpwr_lvl_v2->enable);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_1m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[0]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_2m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[1]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_5m5_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[2]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_11m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[3]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_6m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[4]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_9m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[5]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_12m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[6]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_18m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[7]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_24m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[8]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_36m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[9]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_48m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[10]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11b_11ag_54m_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11b_11ag_2g4[11]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs0_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[0]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs1_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[1]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs2_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[2]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs3_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[3]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs4_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[4]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs5_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[5]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs6_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[6]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs7_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[7]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs8_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[8]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11n_11ac_mcs9_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11n_11ac_2g4[9]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs0_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[0]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs1_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[1]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs2_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[2]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs3_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[3]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs4_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[4]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs5_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[5]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs6_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[6]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs7_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[7]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs8_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[8]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs9_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[9]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs10_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[10]);
+	AICWFDBG(LOGDEBUG, "%s:lvl_11ax_mcs11_2g4:%d\r\n", __func__,
+		 txpwr_lvl_v2->pwrlvl_11ax_2g4[11]);
+}
+
+void get_userconfig_txpwr_lvl_group_in_fdrv(struct txpwr_lvl_conf_v3 *txpw=
r_lvl_v3, int index_reg)
+{
+	*txpwr_lvl_v3 =3D userconfig_info.txpwr_lvl_v3_gp[index_reg];
+
+	AICWFDBG(LOGDEBUG, "%s:enable:%d\r\n", __func__, txpwr_lvl_v3->enable);
+	AICWFDBG(LOGDEBUG, "lvl_11b_11ag_1m_2g4:%d\r\n", txpwr_lvl_v3->pwrlvl_11b=
_11ag_2g4[0]);
+}
+
+void get_userconfig_txpwr_lvl_v3_in_fdrv(struct txpwr_lvl_conf_v3 *txpwr_l=
vl_v3)
+{
+	*txpwr_lvl_v3 =3D userconfig_info.txpwr_lvl_v3;
+
+	AICWFDBG(LOGDEBUG, "%s:enable:%d\r\n", __func__, txpwr_lvl_v3->enable);
+	AICWFDBG(LOGDEBUG, "lvl_11b_11ag_1m_2g4:%d\r\n", txpwr_lvl_v3->pwrlvl_11b=
_11ag_2g4[0]);
+}
+
+void get_userconfig_txpwr_lvl_adj_in_fdrv(struct txpwr_lvl_adj_conf *txpwr=
_lvl_adj)
+{
+	*txpwr_lvl_adj =3D userconfig_info.txpwr_lvl_adj;
+
+	AICWFDBG(LOGDEBUG, "%s:enable:%d\r\n", __func__, txpwr_lvl_adj->enable);
+	AICWFDBG(LOGDEBUG, "lvl_adj_2g4_chan_1_4:%d\r\n", txpwr_lvl_adj->pwrlvl_a=
dj_tbl_2g4[0]);
+}
+
+/**
+ * rwnx_plat_userconfig_load  ---Load aic_userconfig.txt
+ *@filename name of config
+ */
+static int rwnx_plat_userconfig_load(struct rwnx_hw *rwnx_hw)
+{
+	aic_chip_userconfig_load(rwnx_hw);
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+	aic_chip_powerlimit_load(rwnx_hw);
+#endif
+	return 0;
+}
+
+void get_userconfig_txpwr_loss(struct txpwr_loss_conf *txpwr_loss)
+{
+	txpwr_loss->loss_enable_2g4 =3D userconfig_info.txpwr_loss.loss_enable_2g=
4;
+	txpwr_loss->loss_value_2g4 =3D userconfig_info.txpwr_loss.loss_value_2g4;
+	txpwr_loss->loss_enable_5g =3D userconfig_info.txpwr_loss.loss_enable_5g;
+	txpwr_loss->loss_value_5g =3D userconfig_info.txpwr_loss.loss_value_5g;
+
+	AICWFDBG(LOGDEBUG,
+		 "%s:loss_enable_2g4: %d, val_2g4: %d, loss_enable_5g: %d, val_5g: %d\r\=
n",
+		 __func__,
+		 txpwr_loss->loss_enable_2g4, txpwr_loss->loss_value_2g4,
+		 txpwr_loss->loss_enable_5g, txpwr_loss->loss_value_5g);
+}
+
+/**
+ * rwnx_platform_on() - Start the platform
+ *
+ * @rwnx_hw: Main driver data
+ * @config: Config to restore (NULL if nothing to restore)
+ *
+ * It starts the platform :
+ * - load fw and ucodes
+ * - initialize IPC
+ * - boot the fw
+ * - enable link communication/IRQ
+ *
+ * Called by 802.11 part
+ */
+int rwnx_platform_on(struct rwnx_hw *rwnx_hw, void *config)
+{
+	int ret;
+	struct rwnx_plat *rwnx_plat =3D rwnx_hw->plat;
+	(void)ret;
+
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	if (rwnx_plat->enabled)
+		return 0;
+
+	rwnx_plat_userconfig_load(rwnx_hw);
+	// rwnx_plat->enabled =3D true;
+	return 0;
+}
+
+/**
+ * rwnx_platform_off() - Stop the platform
+ *
+ * @rwnx_hw: Main driver data
+ * @config: Updated with pointer to config, to be able to restore it with
+ * rwnx_platform_on(). It's up to the caller to free the config. Set to NU=
LL
+ * if configuration is not needed.
+ *
+ * Called by 802.11 part
+ */
+void rwnx_platform_off(struct rwnx_hw *rwnx_hw, void **config)
+{
+#if defined(AICWF_SDIO_SUPPORT)
+	tasklet_kill(&rwnx_hw->task);
+	rwnx_hw->plat->enabled =3D false;
+	return;
+#endif
+
+	if (!rwnx_hw->plat->enabled) {
+		if (config)
+			*config =3D NULL;
+		return;
+	}
+
+	if (config)
+		*config =3D rwnx_term_save_config(rwnx_hw->plat);
+
+	rwnx_hw->plat->disable(rwnx_hw);
+
+	tasklet_kill(&rwnx_hw->task);
+	rwnx_platform_reset(rwnx_hw->plat);
+
+	rwnx_hw->plat->enabled =3D false;
+}
+
+/**
+ * rwnx_platform_init() - Initialize the platform
+ *
+ * @rwnx_plat: platform data (already updated by platform driver)
+ * @platform_data: Pointer to store the main driver data pointer (aka rwnx=
_hw)
+ *                That will be set as driver data for the platform driver
+ * Return: 0 on success, < 0 otherwise
+ *
+ * Called by the platform driver after it has been probed
+ */
+int rwnx_platform_init(struct rwnx_plat *rwnx_plat, void **platform_data)
+{
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	rwnx_plat->enabled =3D false;
+	g_rwnx_plat =3D rwnx_plat;
+
+	return rwnx_cfg80211_init(rwnx_plat, platform_data);
+}
+
+/**
+ * rwnx_platform_deinit() - Deinitialize the platform
+ *
+ * @rwnx_hw: main driver data
+ *
+ * Called by the platform driver after it is removed
+ */
+void rwnx_platform_deinit(struct rwnx_hw *rwnx_hw)
+{
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+
+	rwnx_cfg80211_deinit(rwnx_hw);
+}
+
+struct device *rwnx_platform_get_dev(struct rwnx_plat *rwnx_plat)
+{
+#ifdef AICWF_SDIO_SUPPORT
+	return rwnx_plat->sdiodev->dev;
+#endif
+}
+
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_AGC_FW_NAME);
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_FCU_FW_NAME);
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_LDPC_RAM_NAME);
+
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_FW_NAME);
+#ifndef CONFIG_RWNX_TL4
+MODULE_FIRMWARE(AIC8800_FW_DIR RWNX_MAC_FW_NAME2);
+#endif
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_platform.h b/driver=
s/net/wireless/aic/aic8800_fdrv/rwnx_platform.h
new file mode 100644
index 0000000000000..ef12cd2af4602
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_platform.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _RWNX_PLATFORM_H_
+#define _RWNX_PLATFORM_H_
+
+#include "lmac_msg.h"
+#include <linux/pci.h>
+
+#define AIC8800_FW_DIR "aic8800/"
+
+#define RWNX_CONFIG_FW_NAME        "rwnx_settings.ini"
+#define RWNX_PHY_CONFIG_TRD_NAME   "rwnx_trident.ini"
+#define RWNX_PHY_CONFIG_KARST_NAME "rwnx_karst.ini"
+#define RWNX_AGC_FW_NAME           "agcram.bin"
+#define RWNX_LDPC_RAM_NAME         "ldpcram.bin"
+
+#define RWNX_MAC_FW_BASE_NAME "fmacfw"
+
+#ifdef CONFIG_RWNX_TL4
+#define RWNX_MAC_FW_NAME RWNX_MAC_FW_BASE_NAME ".hex"
+#else
+#define RWNX_MAC_FW_NAME  RWNX_MAC_FW_BASE_NAME ".ihex"
+#define RWNX_MAC_FW_NAME2 RWNX_MAC_FW_BASE_NAME ".bin"
+#endif
+
+#define RWNX_FCU_FW_NAME "fcuram.bin"
+#if (defined(CONFIG_DPD) && !defined(CONFIG_FORCE_DPD_CALIB))
+#define FW_DPDRESULT_NAME_8800DC "aic_dpdresult_lite_8800dc.bin"
+#endif
+
+#define POWER_LEVEL_INVALID_VAL (127)
+
+/**
+ * Type of memory to access (cf rwnx_plat.get_address)
+ *
+ * @RWNX_ADDR_CPU To access memory of the embedded CPU
+ * @RWNX_ADDR_SYSTEM To access memory/registers of one subsystem of the
+ * embedded system
+ *
+ */
+enum rwnx_platform_addr {
+	RWNX_ADDR_CPU,
+	RWNX_ADDR_SYSTEM,
+	RWNX_ADDR_MAX,
+};
+
+enum regions_code {
+	REGIONS_SRRC,
+	REGIONS_FCC,
+	REGIONS_ETSI,
+	REGIONS_JP,
+	REGIONS_DEFAULT,
+};
+
+struct rwnx_hw;
+struct device;
+struct firmware;
+
+int aicwf_request_firmware(const struct firmware **fw, const char *name,
+			   struct device *dev);
+
+/**
+ * struct rwnx_plat - Operation pointers for RWNX PCI platform
+ *
+ * @pci_dev: pointer to pci dev
+ * @enabled: Set if embedded platform has been enabled (i.e. fw loaded and
+ *          ipc started)
+ * @enable: Configure communication with the fw (i.e. configure the transf=
ers
+ *         enable and register interrupt)
+ * @disable: Stop communication with the fw
+ * @deinit: Free all resources allocated for the embedded platform
+ * @get_address: Return the virtual address to access the requested addres=
s on
+ *              the platform.
+ * @ack_irq: Acknowledge the irq at link level.
+ * @get_config_reg: Return the list (size + pointer) of registers to resto=
re in
+ * order to reload the platform while keeping the current configuration.
+ *
+ * @priv Private data for the link driver
+ */
+struct rwnx_plat {
+	struct pci_dev *pci_dev;
+
+#ifdef AICWF_SDIO_SUPPORT
+	struct aic_sdio_dev *sdiodev;
+#endif
+
+	bool enabled;
+
+	int (*enable)(struct rwnx_hw *rwnx_hw);
+	int (*disable)(struct rwnx_hw *rwnx_hw);
+	void (*deinit)(struct rwnx_plat *rwnx_plat);
+	u8 *(*get_address)(struct rwnx_plat *rwnx_plat, int addr_name,
+			   unsigned int offset);
+	void (*ack_irq)(struct rwnx_plat *rwnx_plat);
+	int (*get_config_reg)(struct rwnx_plat *rwnx_plat, const u32 **list);
+
+	u8 priv[0] __aligned(sizeof(void *));
+};
+
+static inline void *RWNX_ADDR(void *plat, int base, int offset)
+{
+	struct rwnx_plat *p =3D (struct rwnx_plat *)plat;
+
+	return p->get_address(p, base, offset);
+}
+
+static inline u32 RWNX_REG_READ(void *plat, int base, int offset)
+{
+	struct rwnx_plat *p =3D (struct rwnx_plat *)plat;
+
+	return readl(p->get_address(p, base, offset));
+}
+
+static inline void RWNX_REG_WRITE(u32 val, void *plat, int base, int offse=
t)
+{
+	struct rwnx_plat *p =3D (struct rwnx_plat *)plat;
+
+	writel(val, p->get_address(p, base, offset));
+}
+
+extern struct rwnx_plat *g_rwnx_plat;
+
+int rwnx_platform_init(struct rwnx_plat *rwnx_plat, void **platform_data);
+void rwnx_platform_deinit(struct rwnx_hw *rwnx_hw);
+
+int rwnx_platform_on(struct rwnx_hw *rwnx_hw, void *config);
+void rwnx_platform_off(struct rwnx_hw *rwnx_hw, void **config);
+
+int rwnx_platform_register_drv(void);
+void rwnx_platform_unregister_drv(void);
+
+void get_userconfig_txpwr_idx(struct txpwr_idx_conf *txpwr_idx);
+void get_userconfig_txpwr_ofst(struct txpwr_ofst_conf *txpwr_ofst);
+void get_userconfig_xtal_cap(struct xtal_cap_conf *xtal_cap);
+s8_l get_txpwr_max(s8_l power);
+void set_txpwr_loss_ofst(s8_l value);
+
+int get_ccode_region(char *ccode);
+
+void rwnx_release_firmware_common(u32 **buffer);
+
+int rwnx_plat_userconfig_upload(struct rwnx_hw *rwnx_hw,
+				const char *filename);
+void rwnx_plat_userconfig_parsing(struct rwnx_hw *rwnx_hw, char *buffer, i=
nt size);
+void rwnx_plat_userconfig_parsing2(char *buffer, int size);
+void rwnx_plat_userconfig_parsing3(char *buffer, int size);
+
+void get_userconfig_txpwr_lvl_in_fdrv(struct txpwr_lvl_conf *txpwr_lvl);
+void get_userconfig_txpwr_lvl_v2_in_fdrv(struct txpwr_lvl_conf_v2 *txpwr_l=
vl_v2);
+void get_userconfig_txpwr_lvl_group_in_fdrv(struct txpwr_lvl_conf_v3 *txpw=
r_lvl_v3, int index_reg);
+void get_userconfig_txpwr_lvl_v3_in_fdrv(struct txpwr_lvl_conf_v3 *txpwr_l=
vl_v3);
+void get_userconfig_txpwr_lvl_adj_in_fdrv(struct txpwr_lvl_adj_conf *txpwr=
_lvl_adj);
+
+void get_userconfig_txpwr_ofst_in_fdrv(struct txpwr_ofst_conf *txpwr_ofst)=
;
+void get_userconfig_txpwr_ofst2x_in_fdrv(struct txpwr_ofst2x_conf *txpwr_o=
fst2x);
+void get_userconfig_txpwr_loss(struct txpwr_loss_conf *txpwr_loss);
+#ifdef CONFIG_AIC8800_POWER_LIMIT
+int is_all_space_or_tab(u8_l *data, u8_l size);
+int is_comment_string(char *sz_str);
+int is_enable_limit(char *sz_str);
+int parse_qualified_string(char *in, u32 *start, char *out, char left_qual=
ifier,
+			   char right_qualifier);
+int get_u1_byte_integer_from_string_in_decimal(char *str, u8 *p_int);
+int get_s1_byte_integer_from_string_in_decimal(char *str, s8 *val);
+void rwnx_plat_powerlimit_parsing(char *buffer, int size, char *cc);
+s8_l get_powerlimit_by_freq(u8_l band, u16_l freq, u8_l *enable);
+s8_l get_powerlimit_by_chnum(u8_l chnum, u8_l *enable);
+u16_l phy_channel_to_freq(u8_l band, int channel);
+#endif
+
+struct device *rwnx_platform_get_dev(struct rwnx_plat *rwnx_plat);
+
+int rwnx_request_firmware_common(struct rwnx_hw *rwnx_hw, u32 **buffer,
+				 const char *filename);
+int rwnx_plat_bin_fw_upload_2(struct rwnx_hw *rwnx_hw, u32 fw_addr,
+			      char *filename);
+int rwnx_atoi(char *value);
+void rwnx_plat_nvram_set_value(char *command, char *value);
+void rwnx_plat_nvram_set_value_group(char *command, char *value);
+void rwnx_plat_nvram_set_value_v3(char *command, char *value);
+
+static inline unsigned int rwnx_platform_get_irq(struct rwnx_plat *rwnx_pl=
at)
+{
+	return rwnx_plat->pci_dev->irq;
+}
+
+#endif /* _RWNX_PLATFORM_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_prof.h b/drivers/ne=
t/wireless/aic/aic8800_fdrv/rwnx_prof.h
new file mode 100644
index 0000000000000..093e243f3c94f
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_prof.h
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _RWNX_PROF_H_
+#define _RWNX_PROF_H_
+
+#include "reg_access.h"
+#include "rwnx_platform.h"
+#include "rwnx_radar.h"
+
+static inline void rwnx_prof_set(struct rwnx_hw *rwnx_hw, int val)
+{
+	struct rwnx_plat *rwnx_plat =3D rwnx_hw->plat;
+
+	RWNX_REG_WRITE(val, rwnx_plat, RWNX_ADDR_SYSTEM,
+		       NXMAC_SW_SET_PROFILING_ADDR);
+}
+
+static inline void rwnx_prof_clear(struct rwnx_hw *rwnx_hw, int val)
+{
+	struct rwnx_plat *rwnx_plat =3D rwnx_hw->plat;
+
+	RWNX_REG_WRITE(val, rwnx_plat, RWNX_ADDR_SYSTEM,
+		       NXMAC_SW_CLEAR_PROFILING_ADDR);
+}
+
+enum {
+	SW_PROF_HOSTBUF_IDX =3D 12,
+	/****** IPC IRQs related signals ******/
+	/* E2A direction */
+	SW_PROF_IRQ_E2A_RXDESC =3D
+		16, // to make sure we let 16 bits available for LMAC FW
+	SW_PROF_IRQ_E2A_TXCFM,
+	SW_PROF_IRQ_E2A_DBG,
+	SW_PROF_IRQ_E2A_MSG,
+	SW_PROF_IPC_MSGPUSH,
+	SW_PROF_MSGALLOC,
+	SW_PROF_MSGIND,
+	SW_PROF_DBGIND,
+
+	/* A2E direction */
+	SW_PROF_IRQ_A2E_TXCFM_BACK,
+
+	/****** Driver functions related signals ******/
+	SW_PROF_WAIT_QUEUE_STOP,
+	SW_PROF_WAIT_QUEUE_WAKEUP,
+	SW_PROF_RWNXDATAIND,
+	SW_PROF_RWNX_IPC_IRQ_HDLR,
+	SW_PROF_RWNX_IPC_THR_IRQ_HDLR,
+	SW_PROF_IEEE80211RX,
+	SW_PROF_RWNX_PATTERN,
+	SW_PROF_MAX
+};
+
+// [LT]For debug purpose only
+#if (0)
+#define SW_PROF_CHAN_CTXT_CFM_HDL_BIT    (21)
+#define SW_PROF_CHAN_CTXT_CFM_BIT        (22)
+#define SW_PROF_CHAN_CTXT_CFM_SWDONE_BIT (23)
+#define SW_PROF_CHAN_CTXT_PUSH_BIT       (24)
+#define SW_PROF_CHAN_CTXT_QUEUE_BIT      (25)
+#define SW_PROF_CHAN_CTXT_TX_BIT         (26)
+#define SW_PROF_CHAN_CTXT_TX_PAUSE_BIT   (27)
+#define SW_PROF_CHAN_CTXT_PSWTCH_BIT     (28)
+#define SW_PROF_CHAN_CTXT_SWTCH_BIT      (29)
+
+#else
+#define SW_PROF_CHAN_CTXT_CFM_HDL_BIT    (0)
+#define SW_PROF_CHAN_CTXT_CFM_BIT        (0)
+#define SW_PROF_CHAN_CTXT_CFM_SWDONE_BIT (0)
+#define SW_PROF_CHAN_CTXT_PUSH_BIT       (0)
+#define SW_PROF_CHAN_CTXT_QUEUE_BIT      (0)
+#define SW_PROF_CHAN_CTXT_TX_BIT         (0)
+#define SW_PROF_CHAN_CTXT_TX_PAUSE_BIT   (0)
+#define SW_PROF_CHAN_CTXT_PSWTCH_BIT     (0)
+#define SW_PROF_CHAN_CTXT_SWTCH_BIT      (0)
+#endif
+
+static inline void REG_SW_SET_PROFILING_CHAN(void *env, int bit)
+{
+#if (0)
+	rwnx_prof_clear((struct rwnx_hw *)env, BIT(bit));
+#else
+
+#endif
+}
+
+static inline void REG_SW_CLEAR_PROFILING_CHAN(void *env, int bit)
+{
+#if (0)
+	rwnx_prof_clear((struct rwnx_hw *)env, BIT(bit));
+#else
+
+#endif
+}
+
+#ifdef CONFIG_RWNX_SW_PROFILING
+/* Macros for SW PRofiling registers access */
+static inline void REG_SW_SET_PROFILING(void *env, int bit)
+{
+	rwnx_prof_set((struct rwnx_hw *)env, BIT(bit));
+}
+
+static inline void REG_SW_SET_HOSTBUF_IDX_PROFILING(void *env, int val)
+{
+	rwnx_prof_set((struct rwnx_hw *)env, (val) << (SW_PROF_HOSTBUF_IDX));
+}
+
+static inline void REG_SW_CLEAR_PROFILING(void *env, int bit)
+{
+	rwnx_prof_clear((struct rwnx_hw *)env, BIT(bit));
+}
+
+static inline void REG_SW_CLEAR_HOSTBUF_IDX_PROFILING(void *env)
+{
+	rwnx_prof_clear((struct rwnx_hw *)env, 0x0F << (SW_PROF_HOSTBUF_IDX));
+}
+
+#else
+static inline void REG_SW_SET_PROFILING(void *env, int value)
+{
+	(void)env;
+	(void)value;
+}
+
+static inline void REG_SW_CLEAR_PROFILING(void *env, int value)
+{
+	(void)env;
+	(void)value;
+}
+
+static inline void REG_SW_SET_HOSTBUF_IDX_PROFILING(void *env, int val)
+{
+	(void)env;
+	(void)val;
+}
+
+static inline void REG_SW_CLEAR_HOSTBUF_IDX_PROFILING(void *env)
+{
+	(void)env;
+}
+#endif
+
+#endif /* _RWNX_PROF_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_strs.c b/drivers/ne=
t/wireless/aic/aic8800_fdrv/rwnx_strs.c
new file mode 100644
index 0000000000000..49e7ce3560b49
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_strs.c
@@ -0,0 +1,268 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file rwnx_strs.c
+ *
+ * @brief Miscellaneous debug strings
+ *
+ *************************************************************************=
***************
+ */
+
+#include "lmac_msg.h"
+static const char *const rwnx_mmid2str[MSG_I(MM_MAX)] =3D {
+	[MSG_I(MM_RESET_REQ)] =3D "MM_RESET_REQ",
+	[MSG_I(MM_RESET_CFM)] =3D "MM_RESET_CFM",
+	[MSG_I(MM_START_REQ)] =3D "MM_START_REQ",
+	[MSG_I(MM_START_CFM)] =3D "MM_START_CFM",
+	[MSG_I(MM_VERSION_REQ)] =3D "MM_VERSION_REQ",
+	[MSG_I(MM_VERSION_CFM)] =3D "MM_VERSION_CFM",
+	[MSG_I(MM_ADD_IF_REQ)] =3D "MM_ADD_IF_REQ",
+	[MSG_I(MM_ADD_IF_CFM)] =3D "MM_ADD_IF_CFM",
+	[MSG_I(MM_REMOVE_IF_REQ)] =3D "MM_REMOVE_IF_REQ",
+	[MSG_I(MM_REMOVE_IF_CFM)] =3D "MM_REMOVE_IF_CFM",
+	[MSG_I(MM_STA_ADD_REQ)] =3D "MM_STA_ADD_REQ",
+	[MSG_I(MM_STA_ADD_CFM)] =3D "MM_STA_ADD_CFM",
+	[MSG_I(MM_STA_DEL_REQ)] =3D "MM_STA_DEL_REQ",
+	[MSG_I(MM_STA_DEL_CFM)] =3D "MM_STA_DEL_CFM",
+	[MSG_I(MM_SET_FILTER_REQ)] =3D "MM_SET_FILTER_REQ",
+	[MSG_I(MM_SET_FILTER_CFM)] =3D "MM_SET_FILTER_CFM",
+	[MSG_I(MM_SET_CHANNEL_REQ)] =3D "MM_SET_CHANNEL_REQ",
+	[MSG_I(MM_SET_CHANNEL_CFM)] =3D "MM_SET_CHANNEL_CFM",
+	[MSG_I(MM_SET_DTIM_REQ)] =3D "MM_SET_DTIM_REQ",
+	[MSG_I(MM_SET_DTIM_CFM)] =3D "MM_SET_DTIM_CFM",
+	[MSG_I(MM_SET_BEACON_INT_REQ)] =3D "MM_SET_BEACON_INT_REQ",
+	[MSG_I(MM_SET_BEACON_INT_CFM)] =3D "MM_SET_BEACON_INT_CFM",
+	[MSG_I(MM_SET_BASIC_RATES_REQ)] =3D "MM_SET_BASIC_RATES_REQ",
+	[MSG_I(MM_SET_BASIC_RATES_CFM)] =3D "MM_SET_BASIC_RATES_CFM",
+	[MSG_I(MM_SET_BSSID_REQ)] =3D "MM_SET_BSSID_REQ",
+	[MSG_I(MM_SET_BSSID_CFM)] =3D "MM_SET_BSSID_CFM",
+	[MSG_I(MM_SET_EDCA_REQ)] =3D "MM_SET_EDCA_REQ",
+	[MSG_I(MM_SET_EDCA_CFM)] =3D "MM_SET_EDCA_CFM",
+	[MSG_I(MM_SET_MODE_REQ)] =3D "MM_SET_MODE_REQ",
+	[MSG_I(MM_SET_MODE_CFM)] =3D "MM_SET_MODE_CFM",
+	[MSG_I(MM_SET_VIF_STATE_REQ)] =3D "MM_SET_VIF_STATE_REQ",
+	[MSG_I(MM_SET_VIF_STATE_CFM)] =3D "MM_SET_VIF_STATE_CFM",
+	[MSG_I(MM_SET_SLOTTIME_REQ)] =3D "MM_SET_SLOTTIME_REQ",
+	[MSG_I(MM_SET_SLOTTIME_CFM)] =3D "MM_SET_SLOTTIME_CFM",
+	[MSG_I(MM_SET_IDLE_REQ)] =3D "MM_SET_IDLE_REQ",
+	[MSG_I(MM_SET_IDLE_CFM)] =3D "MM_SET_IDLE_CFM",
+	[MSG_I(MM_KEY_ADD_REQ)] =3D "MM_KEY_ADD_REQ",
+	[MSG_I(MM_KEY_ADD_CFM)] =3D "MM_KEY_ADD_CFM",
+	[MSG_I(MM_KEY_DEL_REQ)] =3D "MM_KEY_DEL_REQ",
+	[MSG_I(MM_KEY_DEL_CFM)] =3D "MM_KEY_DEL_CFM",
+	[MSG_I(MM_BA_ADD_REQ)] =3D "MM_BA_ADD_REQ",
+	[MSG_I(MM_BA_ADD_CFM)] =3D "MM_BA_ADD_CFM",
+	[MSG_I(MM_BA_DEL_REQ)] =3D "MM_BA_DEL_REQ",
+	[MSG_I(MM_BA_DEL_CFM)] =3D "MM_BA_DEL_CFM",
+	[MSG_I(MM_PRIMARY_TBTT_IND)] =3D "MM_PRIMARY_TBTT_IND",
+	[MSG_I(MM_SECONDARY_TBTT_IND)] =3D "MM_SECONDARY_TBTT_IND",
+	[MSG_I(MM_SET_POWER_REQ)] =3D "MM_SET_POWER_REQ",
+	[MSG_I(MM_SET_POWER_CFM)] =3D "MM_SET_POWER_CFM",
+	[MSG_I(MM_DBG_TRIGGER_REQ)] =3D "MM_DBG_TRIGGER_REQ",
+	[MSG_I(MM_SET_PS_MODE_REQ)] =3D "MM_SET_PS_MODE_REQ",
+	[MSG_I(MM_SET_PS_MODE_CFM)] =3D "MM_SET_PS_MODE_CFM",
+	[MSG_I(MM_CHAN_CTXT_ADD_REQ)] =3D "MM_CHAN_CTXT_ADD_REQ",
+	[MSG_I(MM_CHAN_CTXT_ADD_CFM)] =3D "MM_CHAN_CTXT_ADD_CFM",
+	[MSG_I(MM_CHAN_CTXT_DEL_REQ)] =3D "MM_CHAN_CTXT_DEL_REQ",
+	[MSG_I(MM_CHAN_CTXT_DEL_CFM)] =3D "MM_CHAN_CTXT_DEL_CFM",
+	[MSG_I(MM_CHAN_CTXT_LINK_REQ)] =3D "MM_CHAN_CTXT_LINK_REQ",
+	[MSG_I(MM_CHAN_CTXT_LINK_CFM)] =3D "MM_CHAN_CTXT_LINK_CFM",
+	[MSG_I(MM_CHAN_CTXT_UNLINK_REQ)] =3D "MM_CHAN_CTXT_UNLINK_REQ",
+	[MSG_I(MM_CHAN_CTXT_UNLINK_CFM)] =3D "MM_CHAN_CTXT_UNLINK_CFM",
+	[MSG_I(MM_CHAN_CTXT_UPDATE_REQ)] =3D "MM_CHAN_CTXT_UPDATE_REQ",
+	[MSG_I(MM_CHAN_CTXT_UPDATE_CFM)] =3D "MM_CHAN_CTXT_UPDATE_CFM",
+	[MSG_I(MM_CHAN_CTXT_SCHED_REQ)] =3D "MM_CHAN_CTXT_SCHED_REQ",
+	[MSG_I(MM_CHAN_CTXT_SCHED_CFM)] =3D "MM_CHAN_CTXT_SCHED_CFM",
+	[MSG_I(MM_BCN_CHANGE_REQ)] =3D "MM_BCN_CHANGE_REQ",
+	[MSG_I(MM_BCN_CHANGE_CFM)] =3D "MM_BCN_CHANGE_CFM",
+	[MSG_I(MM_TIM_UPDATE_REQ)] =3D "MM_TIM_UPDATE_REQ",
+	[MSG_I(MM_TIM_UPDATE_CFM)] =3D "MM_TIM_UPDATE_CFM",
+	[MSG_I(MM_CONNECTION_LOSS_IND)] =3D "MM_CONNECTION_LOSS_IND",
+	[MSG_I(MM_CHANNEL_SWITCH_IND)] =3D "MM_CHANNEL_SWITCH_IND",
+	[MSG_I(MM_CHANNEL_PRE_SWITCH_IND)] =3D "MM_CHANNEL_PRE_SWITCH_IND",
+	[MSG_I(MM_REMAIN_ON_CHANNEL_REQ)] =3D "MM_REMAIN_ON_CHANNEL_REQ",
+	[MSG_I(MM_REMAIN_ON_CHANNEL_CFM)] =3D "MM_REMAIN_ON_CHANNEL_CFM",
+	[MSG_I(MM_REMAIN_ON_CHANNEL_EXP_IND)] =3D "MM_REMAIN_ON_CHANNEL_EXP_IND",
+	[MSG_I(MM_PS_CHANGE_IND)] =3D "MM_PS_CHANGE_IND",
+	[MSG_I(MM_TRAFFIC_REQ_IND)] =3D "MM_TRAFFIC_REQ_IND",
+	[MSG_I(MM_SET_PS_OPTIONS_REQ)] =3D "MM_SET_PS_OPTIONS_REQ",
+	[MSG_I(MM_SET_PS_OPTIONS_CFM)] =3D "MM_SET_PS_OPTIONS_CFM",
+	[MSG_I(MM_P2P_VIF_PS_CHANGE_IND)] =3D "MM_P2P_VIF_PS_CHANGE_IND",
+	[MSG_I(MM_CSA_COUNTER_IND)] =3D "MM_CSA_COUNTER_IND",
+	[MSG_I(MM_CHANNEL_SURVEY_IND)] =3D "MM_CHANNEL_SURVEY_IND",
+	[MSG_I(MM_SET_P2P_NOA_REQ)] =3D "MM_SET_P2P_NOA_REQ",
+	[MSG_I(MM_SET_P2P_OPPPS_REQ)] =3D "MM_SET_P2P_OPPPS_REQ",
+	[MSG_I(MM_SET_P2P_NOA_CFM)] =3D "MM_SET_P2P_NOA_CFM",
+	[MSG_I(MM_SET_P2P_OPPPS_CFM)] =3D "MM_SET_P2P_OPPPS_CFM",
+	[MSG_I(MM_CFG_RSSI_REQ)] =3D "MM_CFG_RSSI_REQ",
+	[MSG_I(MM_RSSI_STATUS_IND)] =3D "MM_RSSI_STATUS_IND",
+	[MSG_I(MM_CSA_FINISH_IND)] =3D "MM_CSA_FINISH_IND",
+	[MSG_I(MM_CSA_TRAFFIC_IND)] =3D "MM_CSA_TRAFFIC_IND",
+	[MSG_I(MM_MU_GROUP_UPDATE_REQ)] =3D "MM_MU_GROUP_UPDATE_REQ",
+	[MSG_I(MM_MU_GROUP_UPDATE_CFM)] =3D "MM_MU_GROUP_UPDATE_CFM",
+
+	[MSG_I(MM_SET_ARPOFFLOAD_REQ)] =3D "MM_SET_ARPOFFLOAD_REQ",
+	[MSG_I(MM_SET_ARPOFFLOAD_CFM)] =3D "MM_SET_ARPOFFLOAD_CFM",
+	[MSG_I(MM_SET_AGG_DISABLE_REQ)] =3D "MM_SET_AGG_DISABLE_REQ",
+	[MSG_I(MM_SET_AGG_DISABLE_CFM)] =3D "MM_SET_AGG_DISABLE_CFM",
+	[MSG_I(MM_SET_COEX_REQ)] =3D "MM_SET_COEX_REQ",
+	[MSG_I(MM_SET_COEX_CFM)] =3D "MM_SET_COEX_CFM",
+	[MSG_I(MM_SET_RF_CONFIG_REQ)] =3D "MM_SET_RF_CONFIG_REQ",
+	[MSG_I(MM_SET_RF_CONFIG_CFM)] =3D "MM_SET_RF_CONFIG_CFM",
+	[MSG_I(MM_SET_RF_CALIB_REQ)] =3D "MM_SET_RF_CALIB_REQ",
+	[MSG_I(MM_SET_RF_CALIB_CFM)] =3D "MM_SET_RF_CALIB_CFM",
+
+	[MSG_I(MM_GET_MAC_ADDR_REQ)] =3D "MM_GET_MAC_ADDR_REQ",
+	[MSG_I(MM_GET_MAC_ADDR_CFM)] =3D "MM_GET_MAC_ADDR_CFM",
+	[MSG_I(MM_GET_STA_INFO_REQ)] =3D "MM_GET_STA_INFO_REQ",
+	[MSG_I(MM_GET_STA_INFO_CFM)] =3D "MM_GET_STA_INFO_CFM",
+	[MSG_I(MM_SET_TXPWR_IDX_LVL_REQ)] =3D "MM_SET_TXPWR_IDX_LVL_REQ",
+	[MSG_I(MM_SET_TXPWR_IDX_LVL_CFM)] =3D "MM_SET_TXPWR_IDX_LVL_CFM",
+	[MSG_I(MM_SET_TXPWR_OFST_REQ)] =3D "MM_SET_TXPWR_OFST_REQ",
+	[MSG_I(MM_SET_TXPWR_OFST_CFM)] =3D "MM_SET_TXPWR_OFST_CFM",
+	[MSG_I(MM_SET_STACK_START_REQ)] =3D "MM_SET_STACK_START_REQ",
+	[MSG_I(MM_SET_STACK_START_CFM)] =3D "MM_SET_STACK_START_CFM",
+	[MSG_I(MM_APM_STALOSS_IND)] =3D "MM_APM_STALOSS_IND",
+	[MSG_I(MM_SET_VENDOR_HWCONFIG_REQ)] =3D "MM_SET_VENDOR_HWCONFIG_REQ",
+	[MSG_I(MM_SET_VENDOR_HWCONFIG_CFM)] =3D "MM_SET_VENDOR_HWCONFIG_CFM",
+	[MSG_I(MM_GET_FW_VERSION_REQ)] =3D "MM_GET_FW_VERSION_REQ",
+	[MSG_I(MM_GET_FW_VERSION_CFM)] =3D "MM_GET_FW_VERSION_CFM",
+	[MSG_I(MM_SET_RESUME_RESTORE_REQ)] =3D "MM_SET_RESUME_RESTORE_REQ",
+	[MSG_I(MM_SET_RESUME_RESTORE_CFM)] =3D "MM_SET_RESUME_RESTORE_CFM",
+	[MSG_I(MM_GET_WIFI_DISABLE_REQ)] =3D "MM_GET_WIFI_DISABLE_REQ",
+	[MSG_I(MM_GET_WIFI_DISABLE_CFM)] =3D "MM_GET_WIFI_DISABLE_CFM",
+	[MSG_I(MM_CFG_RSSI_CFM)] =3D "MM_CFG_RSSI_CFM",
+	[MSG_I(MM_SET_VENDOR_SWCONFIG_REQ)] =3D "MM_SET_VENDOR_SWCONFIG_REQ",
+	[MSG_I(MM_SET_VENDOR_SWCONFIG_CFM)] =3D "MM_SET_VENDOR_SWCONFIG_CFM",
+};
+
+static const char *const rwnx_dbgid2str[MSG_I(DBG_MAX)] =3D {
+	[MSG_I(DBG_MEM_READ_REQ)] =3D "DBG_MEM_READ_REQ",
+	[MSG_I(DBG_MEM_READ_CFM)] =3D "DBG_MEM_READ_CFM",
+	[MSG_I(DBG_MEM_WRITE_REQ)] =3D "DBG_MEM_WRITE_REQ",
+	[MSG_I(DBG_MEM_WRITE_CFM)] =3D "DBG_MEM_WRITE_CFM",
+	[MSG_I(DBG_SET_MOD_FILTER_REQ)] =3D "DBG_SET_MOD_FILTER_REQ",
+	[MSG_I(DBG_SET_MOD_FILTER_CFM)] =3D "DBG_SET_MOD_FILTER_CFM",
+	[MSG_I(DBG_SET_SEV_FILTER_REQ)] =3D "DBG_SET_SEV_FILTER_REQ",
+	[MSG_I(DBG_SET_SEV_FILTER_CFM)] =3D "DBG_SET_SEV_FILTER_CFM",
+	[MSG_I(DBG_ERROR_IND)] =3D "DBG_ERROR_IND",
+	[MSG_I(DBG_GET_SYS_STAT_REQ)] =3D "DBG_GET_SYS_STAT_REQ",
+	[MSG_I(DBG_GET_SYS_STAT_CFM)] =3D "DBG_GET_SYS_STAT_CFM",
+};
+
+static const char *const rwnx_scanid2str[MSG_I(SCAN_MAX)] =3D {
+	[MSG_I(SCAN_START_REQ)] =3D "SCAN_START_REQ",
+	[MSG_I(SCAN_START_CFM)] =3D "SCAN_START_CFM",
+	[MSG_I(SCAN_DONE_IND)] =3D "SCAN_DONE_IND",
+};
+
+static const char *const rwnx_tdlsid2str[MSG_I(TDLS_MAX)] =3D {
+	[MSG_I(TDLS_CHAN_SWITCH_CFM)] =3D "TDLS_CHAN_SWITCH_CFM",
+	[MSG_I(TDLS_CHAN_SWITCH_REQ)] =3D "TDLS_CHAN_SWITCH_REQ",
+	[MSG_I(TDLS_CHAN_SWITCH_IND)] =3D "TDLS_CHAN_SWITCH_IND",
+	[MSG_I(TDLS_CHAN_SWITCH_BASE_IND)] =3D "TDLS_CHAN_SWITCH_BASE_IND",
+	[MSG_I(TDLS_CANCEL_CHAN_SWITCH_REQ)] =3D "TDLS_CANCEL_CHAN_SWITCH_REQ",
+	[MSG_I(TDLS_CANCEL_CHAN_SWITCH_CFM)] =3D "TDLS_CANCEL_CHAN_SWITCH_CFM",
+	[MSG_I(TDLS_PEER_PS_IND)] =3D "TDLS_PEER_PS_IND",
+	[MSG_I(TDLS_PEER_TRAFFIC_IND_REQ)] =3D "TDLS_PEER_TRAFFIC_IND_REQ",
+	[MSG_I(TDLS_PEER_TRAFFIC_IND_CFM)] =3D "TDLS_PEER_TRAFFIC_IND_CFM",
+};
+
+#ifdef CONFIG_RWNX_FULLMAC
+
+static const char *const rwnx_scanuid2str[MSG_I(SCANU_MAX)] =3D {
+	[MSG_I(SCANU_START_REQ)] =3D "SCANU_START_REQ",
+	[MSG_I(SCANU_START_CFM)] =3D "SCANU_START_CFM",
+	[MSG_I(SCANU_JOIN_REQ)] =3D "SCANU_JOIN_REQ",
+	[MSG_I(SCANU_JOIN_CFM)] =3D "SCANU_JOIN_CFM",
+	[MSG_I(SCANU_RESULT_IND)] =3D "SCANU_RESULT_IND",
+	[MSG_I(SCANU_FAST_REQ)] =3D "SCANU_FAST_REQ",
+	[MSG_I(SCANU_FAST_CFM)] =3D "SCANU_FAST_CFM",
+	[MSG_I(SCANU_VENDOR_IE_REQ)] =3D "SCANU_VENDOR_IE_REQ",
+	[MSG_I(SCANU_VENDOR_IE_CFM)] =3D "SCANU_VENDOR_IE_CFM",
+	[MSG_I(SCANU_START_CFM_ADDTIONAL)] =3D "SCANU_START_CFM_ADDTIONAL",
+	[MSG_I(SCANU_CANCEL_REQ)] =3D "SCANU_CANCEL_REQ",
+	[MSG_I(SCANU_CANCEL_CFM)] =3D "SCANU_CANCEL_CFM",
+};
+
+static const char *const rwnx_meid2str[MSG_I(ME_MAX)] =3D {
+	[MSG_I(ME_CONFIG_REQ)] =3D "ME_CONFIG_REQ",
+	[MSG_I(ME_CONFIG_CFM)] =3D "ME_CONFIG_CFM",
+	[MSG_I(ME_CHAN_CONFIG_REQ)] =3D "ME_CHAN_CONFIG_REQ",
+	[MSG_I(ME_CHAN_CONFIG_CFM)] =3D "ME_CHAN_CONFIG_CFM",
+	[MSG_I(ME_SET_CONTROL_PORT_REQ)] =3D "ME_SET_CONTROL_PORT_REQ",
+	[MSG_I(ME_SET_CONTROL_PORT_CFM)] =3D "ME_SET_CONTROL_PORT_CFM",
+	[MSG_I(ME_TKIP_MIC_FAILURE_IND)] =3D "ME_TKIP_MIC_FAILURE_IND",
+	[MSG_I(ME_STA_ADD_REQ)] =3D "ME_STA_ADD_REQ",
+	[MSG_I(ME_STA_ADD_CFM)] =3D "ME_STA_ADD_CFM",
+	[MSG_I(ME_STA_DEL_REQ)] =3D "ME_STA_DEL_REQ",
+	[MSG_I(ME_STA_DEL_CFM)] =3D "ME_STA_DEL_CFM",
+	[MSG_I(ME_TX_CREDITS_UPDATE_IND)] =3D "ME_TX_CREDITS_UPDATE_IND",
+	[MSG_I(ME_RC_STATS_REQ)] =3D "ME_RC_STATS_REQ",
+	[MSG_I(ME_RC_STATS_CFM)] =3D "ME_RC_STATS_CFM",
+	[MSG_I(ME_RC_SET_RATE_REQ)] =3D "ME_RC_SET_RATE_REQ",
+	[MSG_I(ME_TRAFFIC_IND_REQ)] =3D "ME_TRAFFIC_IND_REQ",
+	[MSG_I(ME_TRAFFIC_IND_CFM)] =3D "ME_TRAFFIC_IND_CFM",
+	[MSG_I(ME_SET_PS_MODE_REQ)] =3D "ME_SET_PS_MODE_REQ",
+	[MSG_I(ME_SET_PS_MODE_CFM)] =3D "ME_SET_PS_MODE_CFM",
+	[MSG_I(ME_SET_LP_LEVEL_REQ)] =3D "ME_SET_LP_LEVEL_REQ",
+	[MSG_I(ME_SET_LP_LEVEL_CFM)] =3D "ME_SET_LP_LEVEL_CFM",
+};
+
+static const char *const rwnx_smid2str[MSG_I(SM_MAX)] =3D {
+	[MSG_I(SM_CONNECT_REQ)] =3D "SM_CONNECT_REQ",
+	[MSG_I(SM_CONNECT_CFM)] =3D "SM_CONNECT_CFM",
+	[MSG_I(SM_CONNECT_IND)] =3D "SM_CONNECT_IND",
+	[MSG_I(SM_DISCONNECT_REQ)] =3D "SM_DISCONNECT_REQ",
+	[MSG_I(SM_DISCONNECT_CFM)] =3D "SM_DISCONNECT_CFM",
+	[MSG_I(SM_DISCONNECT_IND)] =3D "SM_DISCONNECT_IND",
+	[MSG_I(SM_EXTERNAL_AUTH_REQUIRED_IND)] =3D "SM_EXTERNAL_AUTH_REQUIRED_IND=
",
+	[MSG_I(SM_EXTERNAL_AUTH_REQUIRED_RSP)] =3D "SM_EXTERNAL_AUTH_REQUIRED_RSP=
",
+	[MSG_I(SM_EXTERNAL_AUTH_REQUIRED_RSP_CFM)] =3D
+		"SM_EXTERNAL_AUTH_REQUIRED_RSP_CFM",
+};
+
+static const char *const rwnx_apmid2str[MSG_I(APM_MAX)] =3D {
+	[MSG_I(APM_START_REQ)] =3D "APM_START_REQ",
+	[MSG_I(APM_START_CFM)] =3D "APM_START_CFM",
+	[MSG_I(APM_STOP_REQ)] =3D "APM_STOP_REQ",
+	[MSG_I(APM_STOP_CFM)] =3D "APM_STOP_CFM",
+	[MSG_I(APM_START_CAC_REQ)] =3D "APM_START_CAC_REQ",
+	[MSG_I(APM_START_CAC_CFM)] =3D "APM_START_CAC_CFM",
+	[MSG_I(APM_STOP_CAC_REQ)] =3D "APM_STOP_CAC_REQ",
+	[MSG_I(APM_STOP_CAC_CFM)] =3D "APM_STOP_CAC_CFM",
+	[MSG_I(APM_SET_BEACON_IE_REQ)] =3D "APM_SET_BEACON_IE_REQ",
+	[MSG_I(APM_SET_BEACON_IE_CFM)] =3D "APM_SET_BEACON_IE_CFM",
+};
+
+static const char *const rwnx_meshid2str[MSG_I(MESH_MAX)] =3D {
+	[MSG_I(MESH_START_REQ)] =3D "MESH_START_REQ",
+	[MSG_I(MESH_START_CFM)] =3D "MESH_START_CFM",
+	[MSG_I(MESH_STOP_REQ)] =3D "MESH_STOP_REQ",
+	[MSG_I(MESH_STOP_CFM)] =3D "MESH_STOP_CFM",
+	[MSG_I(MESH_UPDATE_REQ)] =3D "MESH_UPDATE_REQ",
+	[MSG_I(MESH_UPDATE_CFM)] =3D "MESH_UPDATE_CFM",
+	[MSG_I(MESH_PATH_CREATE_REQ)] =3D "MESH_PATH_CREATE_REQ",
+	[MSG_I(MESH_PATH_CREATE_CFM)] =3D "MESH_PATH_CREATE_CFM",
+	[MSG_I(MESH_PATH_UPDATE_REQ)] =3D "MESH_PATH_UPDATE_REQ",
+	[MSG_I(MESH_PATH_UPDATE_CFM)] =3D "MESH_PATH_UPDATE_CFM",
+	[MSG_I(MESH_PROXY_ADD_REQ)] =3D "MESH_PROXY_ADD_REQ",
+	[MSG_I(MESH_PEER_UPDATE_IND)] =3D "MESH_PEER_UPDATE_IND",
+	[MSG_I(MESH_PATH_UPDATE_IND)] =3D "MESH_PATH_UPDATE_IND",
+	[MSG_I(MESH_PROXY_UPDATE_IND)] =3D "MESH_PROXY_UPDATE_IND",
+};
+
+#endif /* CONFIG_RWNX_FULLMAC */
+
+const char *const *rwnx_id2str[TASK_LAST_EMB + 1] =3D {
+	[TASK_MM] =3D rwnx_mmid2str,       [TASK_DBG] =3D rwnx_dbgid2str,
+	[TASK_SCAN] =3D rwnx_scanid2str,   [TASK_TDLS] =3D rwnx_tdlsid2str,
+#ifdef CONFIG_RWNX_FULLMAC
+	[TASK_SCANU] =3D rwnx_scanuid2str, [TASK_ME] =3D rwnx_meid2str,
+	[TASK_SM] =3D rwnx_smid2str,       [TASK_APM] =3D rwnx_apmid2str,
+	[TASK_MESH] =3D rwnx_meshid2str,
+#endif
+};
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_strs.h b/drivers/ne=
t/wireless/aic/aic8800_fdrv/rwnx_strs.h
new file mode 100644
index 0000000000000..73de33c4f1c7d
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_strs.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file rwnx_strs.h
+ *
+ * @brief Miscellaneous debug strings
+ *
+ *************************************************************************=
***************
+ */
+
+#ifndef _RWNX_STRS_H_
+#define _RWNX_STRS_H_
+
+#include "lmac_msg.h"
+
+#define RWNX_ID2STR(tag)                                               \
+	({                                                                 \
+		const typeof(tag) __tag =3D (tag);                               \
+		((MSG_T(__tag) < ARRAY_SIZE(rwnx_id2str)) &&                   \
+		 (rwnx_id2str[MSG_T(__tag)]) &&                                \
+		 ((rwnx_id2str[MSG_T(__tag)])[MSG_I(__tag)]))                  \
+		 ? (rwnx_id2str[MSG_T(__tag)])[MSG_I(__tag)]                \
+		 : "unknown";                                               \
+	})
+
+extern const char *const *rwnx_id2str[TASK_LAST_EMB + 1];
+
+#endif /* _RWNX_STRS_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_utils.c b/drivers/n=
et/wireless/aic/aic8800_fdrv/rwnx_utils.c
new file mode 100644
index 0000000000000..532b7cbb55b0e
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_utils.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file rwnx_utils.c
+ *
+ * @brief IPC utility function declarations
+ *
+ *************************************************************************=
***************
+ */
+
+#include "rwnx_utils.h"
+#include "ipc_host.h"
+#include "rwnx_debugfs.h"
+#include "rwnx_defs.h"
+#include "rwnx_msg_rx.h"
+#include "rwnx_prof.h"
+#include "rwnx_rx.h"
+#include "rwnx_tx.h"
+
+int rwnx_init_aic(struct rwnx_hw *rwnx_hw)
+{
+	RWNX_DBG(RWNX_FN_ENTRY_STR);
+#ifdef AICWF_SDIO_SUPPORT
+	aicwf_sdio_host_init(&rwnx_hw->sdio_env, NULL, NULL, rwnx_hw);
+#else
+	aicwf_usb_host_init(&rwnx_hw->usb_env, NULL, NULL, rwnx_hw);
+#endif
+	rwnx_cmd_mgr_init(rwnx_hw->cmd_mgr);
+
+	rwnx_hw->testmode =3D get_testmode();
+
+	return 0;
+}
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_utils.h b/drivers/n=
et/wireless/aic/aic8800_fdrv/rwnx_utils.h
new file mode 100644
index 0000000000000..3383a27581377
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_utils.h
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file rwnx_utils.c
+ *
+ * @brief IPC utility function declarations
+ *
+ *************************************************************************=
***************
+ */
+
+#ifndef _RWNX_IPC_UTILS_H_
+#define _RWNX_IPC_UTILS_H_
+
+#include "aicwf_debug.h"
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/skbuff.h>
+#include "lmac_msg.h"
+#include "rwnx_compat.h"
+
+enum rwnx_dev_flag {
+	RWNX_DEV_RESTARTING,
+	RWNX_DEV_STACK_RESTARTING,
+	RWNX_DEV_STARTED,
+};
+
+struct rwnx_hw;
+struct rwnx_sta;
+
+/**
+ * struct rwnx_ipc_elem - Generic IPC buffer of fixed size
+ *
+ * @addr: Host address of the buffer.
+ * @dma_addr: DMA address of the buffer.
+ */
+struct rwnx_ipc_elem {
+	void *addr;
+	dma_addr_t dma_addr;
+};
+
+/**
+ * struct rwnx_ipc_elem_pool - Generic pool of IPC buffers of fixed size
+ *
+ * @nb: Number of buffers currenlty allocated in the pool
+ * @buf: Array of buffers (size of array is @nb)
+ * @pool: DMA pool in which buffers have been allocated
+ */
+struct rwnx_ipc_elem_pool {
+	int nb;
+	struct rwnx_ipc_elem *buf;
+	struct dma_pool *pool;
+};
+
+/**
+ * struct rwnx_ipc_elem - Generic IPC buffer of variable size
+ *
+ * @addr: Host address of the buffer.
+ * @dma_addr: DMA address of the buffer.
+ * @size: Size, in bytes, of the buffer
+ */
+struct rwnx_ipc_elem_var {
+	void *addr;
+	dma_addr_t dma_addr;
+	size_t size;
+};
+
+/**
+ * struct rwnx_ipc_dbgdump_elem - IPC buffer for debug dump
+ *
+ * @mutex: Mutex to protect access to debug dump
+ * @buf: IPC buffer
+ */
+struct rwnx_ipc_dbgdump_elem {
+	struct mutex mutex; //Mutex to protect access to debug dump
+	struct rwnx_ipc_elem_var buf;
+};
+
+/*
+ * Maximum Length of Radiotap header vendor specific data(in bytes)
+ */
+#define RADIOTAP_HDR_VEND_MAX_LEN 16
+
+/*
+ * Maximum Radiotap Header Length without vendor specific data (in bytes)
+ */
+#define RADIOTAP_HDR_MAX_LEN 80
+
+/*
+ * Unsupported HT Frame data length (in bytes)
+ */
+#define UNSUP_RX_VEC_DATA_LEN 2
+
+/**
+ * struct rwnx_ipc_skb_elem - IPC buffer for SKB element
+ *
+ * @skb: Pointer to the skb buffer allocated
+ * @dma_addr: DMA address of the data buffer fo skb
+ *
+ */
+struct rwnx_ipc_skb_elem {
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+};
+
+#ifdef CONFIG_RWNX_FULLMAC
+
+/* Maximum number of rx buffer the fw may use at the same time */
+#define RWNX_RXBUFF_MAX (64 * NX_REMOTE_STA_MAX)
+
+/**
+ * struct rwnx_ipc_rxbuf_elems - IPC buffers for RX
+ *
+ * @skb: Array of buffer push to FW.
+ * @idx: Index of the last pushed skb.(Use to find the next free entry qui=
cker)
+ *
+ * Note: contrary to softmac version, dma_addr are stored inside skb->cb.
+ */
+struct rwnx_ipc_rxbuf_elems {
+	struct sk_buff *skb[RWNX_RXBUFF_MAX];
+	int idx;
+};
+
+#endif /* CONFIG_RWNX_FULLMAC */
+int rwnx_init_aic(struct rwnx_hw *rwnx_hw);
+
+int get_testmode(void);
+
+#endif /* _RWNX_IPC_UTILS_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_v7.c b/drivers/net/=
wireless/aic/aic8800_fdrv/rwnx_v7.c
new file mode 100644
index 0000000000000..d240d5e04bf7e
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_v7.c
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file rwnx_v7.h
+ *
+ *************************************************************************=
***************
+ */
+
+#include "rwnx_v7.h"
+#include "hal_desc.h"
+#include "reg_access.h"
+#include "rwnx_defs.h"
+#include "rwnx_irqs.h"
+
+struct rwnx_v7 {
+	u8 *pci_bar0_vaddr;
+	u8 *pci_bar1_vaddr;
+};
+
+static int rwnx_v7_platform_enable(struct rwnx_hw *rwnx_hw)
+{
+	int ret;
+
+	/* sched_setscheduler on ONESHOT threaded irq handler for BCNs ? */
+	ret =3D request_irq(rwnx_hw->plat->pci_dev->irq, rwnx_irq_hdlr, 0, "rwnx"=
,
+			  rwnx_hw);
+	return ret;
+}
+
+static int rwnx_v7_platform_disable(struct rwnx_hw *rwnx_hw)
+{
+	free_irq(rwnx_hw->plat->pci_dev->irq, rwnx_hw);
+	return 0;
+}
+
+static void rwnx_v7_platform_deinit(struct rwnx_plat *rwnx_plat)
+{
+#ifdef CONFIG_PCI
+	struct rwnx_v7 *rwnx_v7 =3D (struct rwnx_v7 *)rwnx_plat->priv;
+
+	pci_disable_device(rwnx_plat->pci_dev);
+	iounmap(rwnx_v7->pci_bar0_vaddr);
+	iounmap(rwnx_v7->pci_bar1_vaddr);
+	pci_release_regions(rwnx_plat->pci_dev);
+	pci_clear_master(rwnx_plat->pci_dev);
+	pci_disable_msi(rwnx_plat->pci_dev);
+#endif
+	kfree(rwnx_plat);
+}
+
+static u8 *rwnx_v7_get_address(struct rwnx_plat *rwnx_plat, int addr_name,
+			       unsigned int offset)
+{
+	struct rwnx_v7 *rwnx_v7 =3D (struct rwnx_v7 *)rwnx_plat->priv;
+
+	if (WARN(addr_name >=3D RWNX_ADDR_MAX, "Invalid address %d", addr_name))
+		return NULL;
+
+	if (addr_name =3D=3D RWNX_ADDR_CPU)
+		return rwnx_v7->pci_bar0_vaddr + offset;
+	else
+		return rwnx_v7->pci_bar1_vaddr + offset;
+}
+
+static void rwnx_v7_ack_irq(struct rwnx_plat *rwnx_plat)
+{
+}
+
+static const u32 rwnx_v7_config_reg[] =3D {
+	NXMAC_DEBUG_PORT_SEL_ADDR, SYSCTRL_DIAG_CONF_ADDR,
+	SYSCTRL_PHYDIAG_CONF_ADDR, SYSCTRL_RIUDIAG_CONF_ADDR,
+	RF_V7_DIAGPORT_CONF1_ADDR,
+};
+
+static const u32 rwnx_v7_he_config_reg[] =3D {
+	SYSCTRL_DIAG_CONF0,
+	SYSCTRL_DIAG_CONF1,
+	SYSCTRL_DIAG_CONF2,
+	SYSCTRL_DIAG_CONF3,
+};
+
+static int rwnx_v7_get_config_reg(struct rwnx_plat *rwnx_plat, const u32 *=
*list)
+{
+	u32 fpga_sign;
+
+	if (!list)
+		return 0;
+
+	fpga_sign =3D
+		RWNX_REG_READ(rwnx_plat, RWNX_ADDR_SYSTEM, SYSCTRL_SIGNATURE_ADDR);
+	if (__FPGA_TYPE(fpga_sign) =3D=3D 0xc0ca) {
+		*list =3D rwnx_v7_he_config_reg;
+		return ARRAY_SIZE(rwnx_v7_he_config_reg);
+	}
+	*list =3D rwnx_v7_config_reg;
+	return ARRAY_SIZE(rwnx_v7_config_reg);
+}
+
+/**
+ * rwnx_v7_platform_init - Initialize the DINI platform
+ *
+ * @pci_dev PCI device
+ * @rwnx_plat Pointer on struct rwnx_stat * to be populated
+ *
+ * @return 0 on success, < 0 otherwise
+ *
+ * Allocate and initialize a rwnx_plat structure for the dini platform.
+ */
+int rwnx_v7_platform_init(struct pci_dev *pci_dev, struct rwnx_plat **rwnx=
_plat)
+{
+	struct rwnx_v7 *rwnx_v7;
+	u16 pci_cmd;
+	int ret =3D 0;
+
+	*rwnx_plat =3D
+		kzalloc(sizeof(struct rwnx_plat) + sizeof(struct rwnx_v7), GFP_KERNEL);
+	if (!*rwnx_plat)
+		return -ENOMEM;
+
+	rwnx_v7 =3D (struct rwnx_v7 *)(*rwnx_plat)->priv;
+
+	/* Hotplug fixups */
+	pci_read_config_word(pci_dev, PCI_COMMAND, &pci_cmd);
+	pci_cmd |=3D PCI_COMMAND_PARITY | PCI_COMMAND_SERR;
+	pci_write_config_word(pci_dev, PCI_COMMAND, pci_cmd);
+
+	ret =3D pci_enable_device(pci_dev);
+	if (ret) {
+		dev_err(&pci_dev->dev, "pci_enable_device failed\n");
+		goto out_enable;
+	}
+
+	pci_set_master(pci_dev);
+
+#ifdef CONFIG_PCI
+	if (pci_enable_msi(pci_dev)) {
+		dev_err(&pci_dev->dev, "pci_enable_msi failed\n");
+		goto out_msi;
+	}
+#endif
+
+	rwnx_v7->pci_bar0_vaddr =3D (u8 *)pci_ioremap_bar(pci_dev, 0);
+	if (!rwnx_v7->pci_bar0_vaddr) {
+		dev_err(&pci_dev->dev, "pci_ioremap_bar(%d) failed\n", 0);
+		ret =3D -ENOMEM;
+		goto out_bar0;
+	}
+	rwnx_v7->pci_bar1_vaddr =3D (u8 *)pci_ioremap_bar(pci_dev, 1);
+	if (!rwnx_v7->pci_bar1_vaddr) {
+		dev_err(&pci_dev->dev, "pci_ioremap_bar(%d) failed\n", 1);
+		ret =3D -ENOMEM;
+		goto out_bar1;
+	}
+
+	(*rwnx_plat)->enable =3D rwnx_v7_platform_enable;
+	(*rwnx_plat)->disable =3D rwnx_v7_platform_disable;
+	(*rwnx_plat)->deinit =3D rwnx_v7_platform_deinit;
+	(*rwnx_plat)->get_address =3D rwnx_v7_get_address;
+	(*rwnx_plat)->ack_irq =3D rwnx_v7_ack_irq;
+	(*rwnx_plat)->get_config_reg =3D rwnx_v7_get_config_reg;
+
+	return 0;
+
+out_bar1:
+	iounmap(rwnx_v7->pci_bar0_vaddr);
+out_bar0:
+#ifdef CONFIG_PCI
+	pci_disable_msi(pci_dev);
+out_msi:
+#endif
+	pci_release_regions(pci_dev);
+#ifdef CONFIG_PCI
+	pci_clear_master(pci_dev);
+#endif
+	pci_disable_device(pci_dev);
+out_enable:
+	kfree(*rwnx_plat);
+	return ret;
+}
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_v7.h b/drivers/net/=
wireless/aic/aic8800_fdrv/rwnx_v7.h
new file mode 100644
index 0000000000000..c77f26e48ee26
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_v7.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file rwnx_v7.h
+ *
+ *************************************************************************=
***************
+ */
+
+#ifndef _RWNX_V7_H_
+#define _RWNX_V7_H_
+
+#include "rwnx_platform.h"
+#include <linux/pci.h>
+
+int rwnx_v7_platform_init(struct pci_dev *pci_dev,
+			  struct rwnx_plat **rwnx_plat);
+
+#endif /* _RWNX_V7_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_version.h b/drivers=
/net/wireless/aic/aic8800_fdrv/rwnx_version.h
new file mode 100644
index 0000000000000..7f3f2d88d2d98
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_version.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _RWNX_VERSION_H_
+#define _RWNX_VERSION_H_
+
+#include "rwnx_version_gen.h"
+#include "aicwf_debug.h"
+
+static inline void rwnx_print_version(void)
+{
+	// AICWFDBG(LOGINFO, RWNX_VERS_BANNER "\n");
+	pr_info("AIC_WF RELEASE VERSION:%s \r\n", RELEASE_VERSION);
+}
+
+#endif /* _RWNX_VERSION_H_ */
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_version_gen.h b/dri=
vers/net/wireless/aic/aic8800_fdrv/rwnx_version_gen.h
new file mode 100644
index 0000000000000..8768db424ce78
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_version_gen.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#define RWNX_VERS_REV    "241c091M (master)"
+#define RWNX_VERS_MOD    "6.4.3.0"
+#define RWNX_VERS_BANNER "rwnx v6.4.3.0 - - 241c091M (master)"
+#define RELEASE_VERSION "2.0.14"
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.c b/driver=
s/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.c
new file mode 100644
index 0000000000000..ee0879fd14215
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ *************************************************************************=
***************
+ *
+ * Copyright (C) 2020 AIC semiconductor.
+ *
+ * @file rwnx_wakelock.c
+ *
+ * @brief wakelock function declarations
+ *
+ *************************************************************************=
***************
+ */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/pm_wakeirq.h>
+#include "rwnx_defs.h"
+#include "rwnx_wakelock.h"
+
+struct wakeup_source *rwnx_wakeup_init(const char *name, struct rwnx_hw *r=
wnx_hw)
+{
+	struct wakeup_source *ws;
+
+	ws =3D wakeup_source_register(rwnx_hw->dev, name);
+	return ws;
+}
+
+void rwnx_wakeup_deinit(struct wakeup_source *ws)
+{
+	if (ws && ws->active)
+		__pm_relax(ws);
+	wakeup_source_unregister(ws);
+}
+
+struct wakeup_source *rwnx_wakeup_register(struct device *dev, const char =
*name)
+{
+	return wakeup_source_register(dev, name);
+}
+
+void rwnx_wakeup_unregister(struct wakeup_source *ws)
+{
+	if (ws && ws->active)
+		__pm_relax(ws);
+	wakeup_source_unregister(ws);
+}
+
+void rwnx_wakeup_lock(struct wakeup_source *ws)
+{
+	__pm_stay_awake(ws);
+}
+
+void rwnx_wakeup_unlock(struct wakeup_source *ws)
+{
+	__pm_relax(ws);
+}
+
+void rwnx_wakeup_lock_timeout(struct wakeup_source *ws, unsigned int msec)
+{
+	__pm_wakeup_event(ws, msec);
+}
+
+void aicwf_wakeup_lock_init(struct rwnx_hw *rwnx_hw)
+{
+	rwnx_hw->ws_tx =3D rwnx_wakeup_init("rwnx_tx_wakelock", rwnx_hw);
+	rwnx_hw->ws_rx =3D rwnx_wakeup_init("rwnx_rx_wakelock", rwnx_hw);
+	rwnx_hw->ws_irqrx =3D rwnx_wakeup_init("rwnx_irqrx_wakelock", rwnx_hw);
+	rwnx_hw->ws_pwrctrl =3D rwnx_wakeup_init("rwnx_pwrcrl_wakelock", rwnx_hw)=
;
+	rwnx_hw->ws_scan =3D rwnx_wakeup_init("rwnx_scan_wakelock", rwnx_hw);
+}
+
+void aicwf_wakeup_lock_deinit(struct rwnx_hw *rwnx_hw)
+{
+	rwnx_wakeup_deinit(rwnx_hw->ws_tx);
+	rwnx_wakeup_deinit(rwnx_hw->ws_rx);
+	rwnx_wakeup_deinit(rwnx_hw->ws_irqrx);
+	rwnx_wakeup_deinit(rwnx_hw->ws_pwrctrl);
+	rwnx_wakeup_deinit(rwnx_hw->ws_scan);
+	rwnx_hw->ws_tx =3D NULL;
+	rwnx_hw->ws_rx =3D NULL;
+	rwnx_hw->ws_irqrx =3D NULL;
+	rwnx_hw->ws_pwrctrl =3D NULL;
+	rwnx_hw->ws_scan =3D NULL;
+}
+
+int aicwf_wakeup_lock_status(struct rwnx_hw *rwnx_hw)
+{
+	if (rwnx_hw->ws_tx && rwnx_hw->ws_tx->active) {
+		AICWFDBG(LOGDEBUG, "AICWF ws_tx active\n");
+		return -1;
+	}
+	if (rwnx_hw->ws_rx && rwnx_hw->ws_rx->active) {
+		AICWFDBG(LOGDEBUG, "AICWF ws_rx active\n");
+		return -1;
+	}
+	if (rwnx_hw->ws_pwrctrl && rwnx_hw->ws_pwrctrl->active) {
+		AICWFDBG(LOGDEBUG, "AICWF ws_pwrctrl active\n");
+		return -1;
+	}
+	if (rwnx_hw->ws_irqrx && rwnx_hw->ws_irqrx->active) {
+		AICWFDBG(LOGDEBUG, "AICWF ws_irqrx active\n");
+		return -1;
+	}
+	if (rwnx_hw->ws_scan && rwnx_hw->ws_scan->active) {
+		AICWFDBG(LOGDEBUG, "AICWF ws_scan active\n");
+		return -1;
+	}
+	return 0;
+}
diff --git a/drivers/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.h b/driver=
s/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.h
new file mode 100644
index 0000000000000..f3ec804f5732d
--- /dev/null
+++ b/drivers/net/wireless/aic/aic8800_fdrv/rwnx_wakelock.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __RWNX_WAKELOCK_H
+#define __RWNX_WAKELOCK_H
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+
+struct wakeup_source *rwnx_wakeup_init(const char *name, struct rwnx_hw *r=
wnx_hw);
+void rwnx_wakeup_deinit(struct wakeup_source *ws);
+
+struct wakeup_source *rwnx_wakeup_register(struct device *dev,
+					   const char *name);
+void rwnx_wakeup_unregister(struct wakeup_source *ws);
+
+void rwnx_wakeup_lock(struct wakeup_source *ws);
+void rwnx_wakeup_unlock(struct wakeup_source *ws);
+void rwnx_wakeup_lock_timeout(struct wakeup_source *ws, unsigned int msec)=
;
+
+void aicwf_wakeup_lock_init(struct rwnx_hw *rwnx_hw);
+void aicwf_wakeup_lock_deinit(struct rwnx_hw *rwnx_hw);
+int aicwf_wakeup_lock_status(struct rwnx_hw *rwnx_hw);
+
+#endif
