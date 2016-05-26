Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2on0056.outbound.protection.outlook.com ([207.46.100.56]:19215
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755190AbcEZT0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 15:26:12 -0400
From: Avinash Patil <avinashp@quantenna.com>
To: <kvalo@codeaurora.org>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<dlebed@quantenna.com>, <smaksimenko@quantenna.com>,
	<smatyukevich@quantenna.com>, <imitsyanko@quantenna.com>,
	<btherthala@quantenna.com>, <hwang@quantenna.com>,
	<krath@quantenna.com>, Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
Date: Thu, 26 May 2016 11:52:32 -0700
Message-ID: <1464288752-6625-1-git-send-email-avinashp@quantenna.com> (sfid-20160526_212622_651140_FDE8494B)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for new FullMAC WiFi driver for Quantenna
QSR10G chipsets.

QSR10G is Quantenna's 8x8, 160M, 11ac offering.
QSR10G supports 2 simultaneous WMACs- one 5G and one 2G. 5G WMAC
supports 160M, 8x8 configuration.
FW supports 8 concurrent virtual interfaces on each WMAC.

Patch introduces 2 new drivers- qtnfmac.ko for interfacing with
kernel/cfg80211 and qtnfmac_pcie.ko for PCIe bus interface.

Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
Signed-off-by: Igor Mitsyanko <imitsyanko@quantenna.com>
Signed-off-by: Bindu Therthala <btherthala@quantenna.com>
Signed-off-by: Huizhao Wang <hwang@quantenna.com>
Signed-off-by: Kamlesh Rath <krath@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 MAINTAINERS                                        |    8 +
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/quantenna/Kconfig             |   16 +
 drivers/net/wireless/quantenna/Makefile            |    6 +
 drivers/net/wireless/quantenna/include/bus.h       |  195 ++
 .../wireless/quantenna/include/pcie_regs_pearl.h   |  353 ++++
 drivers/net/wireless/quantenna/include/qlink.h     |  584 ++++++
 .../net/wireless/quantenna/include/qtn_hw_ids.h    |   34 +
 .../net/wireless/quantenna/include/shm_ipc_defs.h  |   46 +
 drivers/net/wireless/quantenna/qtnfmac/Kconfig     |   20 +
 drivers/net/wireless/quantenna/qtnfmac/Makefile    |   24 +
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 1097 +++++++++++
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h  |   34 +
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 1927 ++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   73 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  220 +++
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  170 ++
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  436 +++++
 drivers/net/wireless/quantenna/qtnfmac/event.h     |   27 +
 drivers/net/wireless/quantenna/qtnfmac/init.c      |  320 ++++
 drivers/net/wireless/quantenna/qtnfmac/pcie.c      | 1374 ++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/pcie.h      |  143 ++
 drivers/net/wireless/quantenna/qtnfmac/pcie_ipc.h  |  144 ++
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |   71 +
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   87 +
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c   |  169 ++
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h   |   80 +
 drivers/net/wireless/quantenna/qtnfmac/trans.c     |  224 +++
 drivers/net/wireless/quantenna/qtnfmac/trans.h     |   57 +
 drivers/net/wireless/quantenna/qtnfmac/util.c      |  134 ++
 drivers/net/wireless/quantenna/qtnfmac/util.h      |   53 +
 32 files changed, 8128 insertions(+)
 create mode 100644 drivers/net/wireless/quantenna/Kconfig
 create mode 100644 drivers/net/wireless/quantenna/Makefile
 create mode 100644 drivers/net/wireless/quantenna/include/bus.h
 create mode 100644 drivers/net/wireless/quantenna/include/pcie_regs_pearl.h
 create mode 100644 drivers/net/wireless/quantenna/include/qlink.h
 create mode 100644 drivers/net/wireless/quantenna/include/qtn_hw_ids.h
 create mode 100644 drivers/net/wireless/quantenna/include/shm_ipc_defs.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/Kconfig
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/Makefile
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/commands.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/commands.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/core.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/core.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/event.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/event.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/init.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie_ipc.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/trans.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/trans.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/util.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/util.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ee2fad5..1022fbe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9151,6 +9151,14 @@ L:       qemu-devel@nongnu.org
 S:     Maintained
 F:     drivers/firmware/qemu_fw_cfg.c

+QUANTENNA QTNFMAC WIRELESS DRIVER
+M:     Igor Mitsyanko <imitsyanko@quantenna.com>
+M:     Avinash Patil <avinashp@quantenna.com>
+M:     Sergey Matyukevich <smatyukevich@quantenna.com>
+L:     linux-wireless@vger.kernel.org
+S:     Maintained
+F:     drivers/net/wireless/quantenna/qtnfmac
+
 RADOS BLOCK DEVICE (RBD)
 M:     Ilya Dryomov <idryomov@gmail.com>
 M:     Sage Weil <sage@redhat.com>
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8c8edaf..dc45057 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -26,6 +26,7 @@ source "drivers/net/wireless/intel/Kconfig"
 source "drivers/net/wireless/intersil/Kconfig"
 source "drivers/net/wireless/marvell/Kconfig"
 source "drivers/net/wireless/mediatek/Kconfig"
+source "drivers/net/wireless/quantenna/Kconfig"
 source "drivers/net/wireless/ralink/Kconfig"
 source "drivers/net/wireless/realtek/Kconfig"
 source "drivers/net/wireless/rsi/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index f00d429..9c311ff 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_WLAN_VENDOR_INTEL) += intel/
 obj-$(CONFIG_WLAN_VENDOR_INTERSIL) += intersil/
 obj-$(CONFIG_WLAN_VENDOR_MARVELL) += marvell/
 obj-$(CONFIG_WLAN_VENDOR_MEDIATEK) += mediatek/
+obj-$(CONFIG_WLAN_VENDOR_QUANTENNA) += quantenna/
 obj-$(CONFIG_WLAN_VENDOR_RALINK) += ralink/
 obj-$(CONFIG_WLAN_VENDOR_REALTEK) += realtek/
 obj-$(CONFIG_WLAN_VENDOR_RSI) += rsi/
diff --git a/drivers/net/wireless/quantenna/Kconfig b/drivers/net/wireless/quantenna/Kconfig
new file mode 100644
index 0000000..c177dd5
--- /dev/null
+++ b/drivers/net/wireless/quantenna/Kconfig
@@ -0,0 +1,16 @@
+config WLAN_VENDOR_QUANTENNA
+       bool "Quantenna WLAN devices"
+       default y
+       ---help---
+         If you have a wireless card belonging to this class, say Y.
+
+         Note that the answer to this question doesn't directly affect the
+         kernel: saying N will just cause the configurator to skip all
+         the questions about  cards. If you say Y, you will be asked for
+         your specific card in the following questions.
+
+if WLAN_VENDOR_QUANTENNA
+
+source "drivers/net/wireless/quantenna/qtnfmac/Kconfig"
+
+endif # WLAN_VENDOR_QUANTENNA
diff --git a/drivers/net/wireless/quantenna/Makefile b/drivers/net/wireless/quantenna/Makefile
new file mode 100644
index 0000000..baebfbd
--- /dev/null
+++ b/drivers/net/wireless/quantenna/Makefile
@@ -0,0 +1,6 @@
+#
+# Copyright (c) 2015-2016 Quantenna Communications, Inc.
+# All rights reserved.
+#
+
+obj-$(CONFIG_QTNFMAC)  += qtnfmac/
diff --git a/drivers/net/wireless/quantenna/include/bus.h b/drivers/net/wireless/quantenna/include/bus.h
new file mode 100644
index 0000000..d7494e5
--- /dev/null
+++ b/drivers/net/wireless/quantenna/include/bus.h
@@ -0,0 +1,195 @@
+/*
+ * Copyright (c) 2015-2016 Quantenna Communications
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef QTNFMAC_BUS_H
+#define QTNFMAC_BUS_H
+
+#include <linux/workqueue.h>
+
+/* bitmap for EP status and flags: updated by EP, read by RC */
+
+#define QTN_EP_HAS_UBOOT       BIT(0)
+#define QTN_EP_HAS_FIRMWARE    BIT(1)
+#define QTN_EP_REQ_UBOOT       BIT(2)
+#define QTN_EP_REQ_FIRMWARE    BIT(3)
+#define QTN_EP_ERROR_UBOOT     BIT(4)
+#define QTN_EP_ERROR_FIRMWARE  BIT(5)
+
+#define QTN_EP_FW_LOADRDY      BIT(8)
+#define QTN_EP_FW_SYNC         BIT(9)
+#define QTN_EP_FW_RETRY                BIT(10)
+#define QTN_EP_FW_QLINK_DONE   BIT(15)
+#define QTN_EP_FW_DONE         BIT(16)
+
+/* bitmap for RC status and flags: updated by RC, read by EP */
+
+#define QTN_RC_PCIE_LINK       BIT(0)
+#define QTN_RC_NET_LINK                BIT(1)
+#define QTN_RC_FW_QLINK                BIT(7)
+#define QTN_RC_FW_LOADRDY      BIT(8)
+#define QTN_RC_FW_SYNC         BIT(9)
+
+/* state transition timeouts */
+
+#define QTN_FW_DL_TIMEOUT_MS   3000
+#define QTN_FW_QLINK_TIMEOUT_MS        20000
+
+/* */
+
+#define QLINK_MAC_MASK         0x04
+#define QTNF_MAX_MAC           3
+
+enum qtnf_bus_state {
+       QTNF_BUS_DOWN,
+       QTNF_BUS_UP
+};
+
+enum qtnf_bus_end {
+       QTN_BUS_DEVICE,
+       QTN_BUS_HOST,
+};
+
+enum qtnf_fw_state {
+       QTNF_FW_STATE_RESET,
+       QTNF_FW_STATE_FW_DNLD_DONE,
+       QTNF_FW_STATE_BOOT_DONE,
+       QTNF_FW_STATE_ACTIVE,
+       QTNF_FW_STATE_DEAD,
+};
+
+struct qtnf_bus;
+
+struct qtnf_bus_ops {
+       int (*preinit)(struct qtnf_bus *dev);
+       void (*stop)(struct qtnf_bus *dev);
+
+       /* boot state methods */
+       int (*is_state)(struct qtnf_bus *, enum qtnf_bus_end, u32);
+       void (*set_state)(struct qtnf_bus *, enum qtnf_bus_end, u32);
+       void (*clear_state)(struct qtnf_bus *, enum qtnf_bus_end, u32);
+       int (*poll_state)(struct qtnf_bus *, enum qtnf_bus_end, u32, u32);
+
+       /* data xfer methods */
+       int (*data_tx)(struct qtnf_bus *, struct sk_buff *);
+       int (*control_tx)(struct qtnf_bus *, struct sk_buff *);
+       void (*data_rx_start)(struct qtnf_bus *);
+       void (*data_rx_stop)(struct qtnf_bus *);
+};
+
+struct qtnf_bus {
+       struct device *dev;
+       enum qtnf_bus_state state;
+       enum qtnf_fw_state fw_state;
+       u32 chip;
+       u32 chiprev;
+       struct qtnf_bus_ops *bus_ops;
+       struct qtnf_wmac *mac[QTNF_MAX_MAC];
+       struct qtnf_qlink_transport trans;
+       struct qtnf_hw_info hw_info;
+       char fwname[32];
+       struct napi_struct mux_napi;
+       struct net_device mux_dev;
+       struct completion request_firmware_complete;
+       struct workqueue_struct *workqueue;
+       struct work_struct event_work;
+       struct mutex bus_lock; /* lock during command/event processing */
+       /* bus private data */
+       char bus_priv[0];
+};
+
+static inline void *get_bus_priv(struct qtnf_bus *bus)
+{
+       if (WARN_ON(!bus)) {
+               pr_err("qtnfmac: invalid bus pointer!\n");
+               return NULL;
+       }
+
+       return &bus->bus_priv;
+}
+
+/* This function returns the pointer to transport block. */
+
+static inline struct qtnf_qlink_transport *
+qtnf_wmac_get_trans(struct qtnf_wmac *mac)
+{
+       if (!mac->bus)
+               return ERR_PTR(ENODEV);
+
+       return (void *)(&mac->bus->trans);
+}
+
+/* callback wrappers */
+
+static inline int qtnf_bus_preinit(struct qtnf_bus *bus)
+{
+       if (!bus->bus_ops->preinit)
+               return 0;
+       return bus->bus_ops->preinit(bus);
+}
+
+static inline void qtnf_bus_stop(struct qtnf_bus *bus)
+{
+       bus->bus_ops->stop(bus);
+}
+
+static inline int qtnf_bus_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+       return bus->bus_ops->data_tx(bus, skb);
+}
+
+static inline int qtnf_bus_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+       return bus->bus_ops->control_tx(bus, skb);
+}
+
+static inline int
+qtnf_bus_poll_state(struct qtnf_bus *bus, enum qtnf_bus_end ep,
+                   u32 state, u32 delay_ms)
+{
+       return bus->bus_ops->poll_state(bus, ep, state, delay_ms);
+}
+
+static inline void qtnf_bus_data_rx_start(struct qtnf_bus *bus)
+{
+       return bus->bus_ops->data_rx_start(bus);
+}
+
+static inline void qtnf_bus_data_rx_stop(struct qtnf_bus *bus)
+{
+       return bus->bus_ops->data_rx_stop(bus);
+}
+
+static __always_inline void qtnf_bus_lock(struct qtnf_bus *bus)
+{
+       mutex_lock(&bus->bus_lock);
+}
+
+static __always_inline void qtnf_bus_unlock(struct qtnf_bus *bus)
+{
+       mutex_unlock(&bus->bus_lock);
+}
+
+/* interface functions from common layer */
+
+void qtnf_rx_frame(struct device *dev, struct sk_buff *rxp);
+int qtnf_core_attach(struct qtnf_bus *bus);
+void qtnf_core_detach(struct qtnf_bus *bus);
+void qtnf_dev_reset(struct device *dev);
+void qtnf_txflowblock(struct device *dev, bool state);
+void qtnf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
+void qtnf_bus_change_state(struct qtnf_bus *bus, enum qtnf_bus_state state);
+
+#endif /* QTNFMAC_BUS_H */
diff --git a/drivers/net/wireless/quantenna/include/pcie_regs_pearl.h b/drivers/net/wireless/quantenna/include/pcie_regs_pearl.h
new file mode 100644
index 0000000..26c38a4
--- /dev/null
+++ b/drivers/net/wireless/quantenna/include/pcie_regs_pearl.h
@@ -0,0 +1,353 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef __PEARL_PCIE_H
+#define __PEARL_PCIE_H
+
+#define        PCIE_GEN2_BASE                          (0xe9000000)
+#define        PCIE_GEN3_BASE                          (0xe7000000)
+
+#define PEARL_CUR_PCIE_BASE                    (PCIE_GEN2_BASE)
+#define PCIE_HDP_OFFSET                                (0x2000)
+
+#define PCIE_HDP_CTRL(base)                    ((base) + 0x2c00)
+#define PCIE_HDP_AXI_CTRL(base)                        ((base) + 0x2c04)
+#define PCIE_HDP_HOST_WR_DESC0(base)           ((base) + 0x2c10)
+#define PCIE_HDP_HOST_WR_DESC0_H(base)         ((base) + 0x2c14)
+#define PCIE_HDP_HOST_WR_DESC1(base)           ((base) + 0x2c18)
+#define PCIE_HDP_HOST_WR_DESC1_H(base)         ((base) + 0x2c1c)
+#define PCIE_HDP_HOST_WR_DESC2(base)           ((base) + 0x2c20)
+#define PCIE_HDP_HOST_WR_DESC2_H(base)         ((base) + 0x2c24)
+#define PCIE_HDP_HOST_WR_DESC3(base)           ((base) + 0x2c28)
+#define PCIE_HDP_HOST_WR_DESC4_H(base)         ((base) + 0x2c2c)
+#define PCIE_HDP_RX_INT_CTRL(base)             ((base) + 0x2c30)
+#define PCIE_HDP_TX_INT_CTRL(base)             ((base) + 0x2c34)
+#define PCIE_HDP_INT_STATUS(base)              ((base) + 0x2c38)
+#define PCIE_HDP_INT_EN(base)                  ((base) + 0x2c3c)
+#define PCIE_HDP_RX_DESC0_PTR(base)            ((base) + 0x2c40)
+#define PCIE_HDP_RX_DESC0_NOE(base)            ((base) + 0x2c44)
+#define PCIE_HDP_RX_DESC1_PTR(base)            ((base) + 0x2c48)
+#define PCIE_HDP_RX_DESC1_NOE(base)            ((base) + 0x2c4c)
+#define PCIE_HDP_RX_DESC2_PTR(base)            ((base) + 0x2c50)
+#define PCIE_HDP_RX_DESC2_NOE(base)            ((base) + 0x2c54)
+#define PCIE_HDP_RX_DESC3_PTR(base)            ((base) + 0x2c58)
+#define PCIE_HDP_RX_DESC3_NOE(base)            ((base) + 0x2c5c)
+
+#define PCIE_HDP_TX0_BASE_ADDR(base)           ((base) + 0x2c60)
+#define PCIE_HDP_TX1_BASE_ADDR(base)           ((base) + 0x2c64)
+#define PCIE_HDP_TX0_Q_CTRL(base)              ((base) + 0x2c70)
+#define PCIE_HDP_TX1_Q_CTRL(base)              ((base) + 0x2c74)
+#define PCIE_HDP_CFG0(base)                    ((base) + 0x2c80)
+#define PCIE_HDP_CFG1(base)                    ((base) + 0x2c84)
+#define PCIE_HDP_CFG2(base)                    ((base) + 0x2c88)
+#define PCIE_HDP_CFG3(base)                    ((base) + 0x2c8c)
+#define PCIE_HDP_CFG4(base)                    ((base) + 0x2c90)
+#define PCIE_HDP_CFG5(base)                    ((base) + 0x2c94)
+#define PCIE_HDP_CFG6(base)                    ((base) + 0x2c98)
+#define PCIE_HDP_CFG7(base)                    ((base) + 0x2c9c)
+#define PCIE_HDP_CFG8(base)                    ((base) + 0x2ca0)
+#define PCIE_HDP_CFG9(base)                    ((base) + 0x2ca4)
+#define PCIE_HDP_CFG10(base)                   ((base) + 0x2ca8)
+#define PCIE_HDP_CFG11(base)                   ((base) + 0x2cac)
+#define PCIE_INT(base)                         ((base) + 0x2cb0)
+#define PCIE_INT_MASK(base)                    ((base) + 0x2cb4)
+#define PCIE_MSI_MASK(base)                    ((base) + 0x2cb8)
+#define PCIE_MSI_PNDG(base)                    ((base) + 0x2cbc)
+#define PCIE_PRI_CFG(base)                     ((base) + 0x2cc0)
+#define PCIE_PHY_CR(base)                      ((base) + 0x2cc4)
+#define PCIE_HDP_CTAG_CTRL(base)               ((base) + 0x2cf4)
+#define PCIE_HDP_HHBM_BUF_PTR(base)            ((base) + 0x2d00)
+#define PCIE_HDP_HHBM_BUF_PTR_H(base)          ((base) + 0x2d04)
+#define PCIE_HDP_HHBM_BUF_FIFO_NOE(base)       ((base) + 0x2d04)
+#define PCIE_HDP_RX0DMA_CNT(base)              ((base) + 0x2d10)
+#define PCIE_HDP_RX1DMA_CNT(base)              ((base) + 0x2d14)
+#define PCIE_HDP_RX2DMA_CNT(base)              ((base) + 0x2d18)
+#define PCIE_HDP_RX3DMA_CNT(base)              ((base) + 0x2d1c)
+#define PCIE_HDP_TX0DMA_CNT(base)              ((base) + 0x2d20)
+#define PCIE_HDP_TX1DMA_CNT(base)              ((base) + 0x2d24)
+#define PCIE_HDP_RXDMA_CTRL(base)              ((base) + 0x2d28)
+#define PCIE_HDP_TX_HOST_Q_SZ_CTRL(base)       ((base) + 0x2d2c)
+#define PCIE_HDP_TX_HOST_Q_BASE_L(base)                ((base) + 0x2d30)
+#define PCIE_HDP_TX_HOST_Q_BASE_H(base)                ((base) + 0x2d34)
+#define PCIE_HDP_TX_HOST_Q_WR_PTR(base)                ((base) + 0x2d38)
+#define PCIE_HDP_TX_HOST_Q_RD_PTR(base)                ((base) + 0x2d3c)
+#define PCIE_HDP_TX_HOST_Q_STS(base)           ((base) + 0x2d40)
+
+/* Host HBM pool registers */
+#define PCIE_HHBM_CSR_REG(base)                        ((base) + 0x2e00)
+#define PCIE_HHBM_Q_BASE_REG(base)             ((base) + 0x2e04)
+#define PCIE_HHBM_Q_LIMIT_REG(base)            ((base) + 0x2e08)
+#define PCIE_HHBM_Q_WR_REG(base)               ((base) + 0x2e0c)
+#define PCIE_HHBM_Q_RD_REG(base)               ((base) + 0x2e10)
+#define PCIE_HHBM_POOL_DATA_0_H(base)          ((base) + 0x2e90)
+#define PCIE_HHBM_CONFIG(base)                 ((base) + 0x2f9c)
+#define PCIE_HHBM_POOL_REQ_0(base)             ((base) + 0x2f10)
+#define PCIE_HHBM_POOL_DATA_0(base)            ((base) + 0x2f40)
+#define PCIE_HHBM_WATERMARK_MASKED_INT(base)   ((base) + 0x2f68)
+#define PCIE_HHBM_WATERMARK_INT(base)          ((base) + 0x2f6c)
+#define PCIE_HHBM_POOL_WATERMARK(base)         ((base) + 0x2f70)
+#define PCIE_HHBM_POOL_OVERFLOW_CNT(base)      ((base) + 0x2f90)
+#define PCIE_HHBM_POOL_UNDERFLOW_CNT(base)     ((base) + 0x2f94)
+#define HBM_INT_STATUS(base)                   ((base) + 0x2f9c)
+#define PCIE_HHBM_POOL_CNFIG(base)             ((base) + 0x2f9c)
+
+/* host HBM bit field definition */
+#define HHBM_CONFIG_SOFT_RESET                 (BIT(8))
+#define HHBM_WR_REQ                            (BIT(0))
+#define HHBM_RD_REQ                            (BIT(1))
+#define HHBM_DONE                              (BIT(31))
+
+/* offsets for dual PCIE */
+#define PCIE_PORT_LINK_CTL(base)               ((base) + 0x0710)
+#define PCIE_GEN2_CTL(base)                    ((base) + 0x080C)
+#define PCIE_GEN3_OFF(base)                    ((base) + 0x0890)
+#define PCIE_ATU_CTRL1(base)                   ((base) + 0x0904)
+#define PCIE_ATU_CTRL2(base)                   ((base) + 0x0908)
+#define PCIE_ATU_BASE_LOW(base)                        ((base) + 0x090C)
+#define PCIE_ATU_BASE_HIGH(base)               ((base) + 0x0910)
+#define PCIE_ATU_BASE_LIMIT(base)              ((base) + 0x0914)
+#define PCIE_ATU_TGT_LOW(base)                 ((base) + 0x0918)
+#define PCIE_ATU_TGT_HIGH(base)                        ((base) + 0x091C)
+#define PCIE_DMA_WR_ENABLE(base)               ((base) + 0x097C)
+#define PCIE_DMA_WR_CHWTLOW(base)              ((base) + 0x0988)
+#define PCIE_DMA_WR_CHWTHIG(base)              ((base) + 0x098C)
+#define PCIE_DMA_WR_INTSTS(base)               ((base) + 0x09BC)
+#define PCIE_DMA_WR_INTMASK(base)              ((base) + 0x09C4)
+#define PCIE_DMA_WR_INTCLER(base)              ((base) + 0x09C8)
+#define PCIE_DMA_WR_DONE_IMWR_ADDR_L(base)     ((base) + 0x09D0)
+#define PCIE_DMA_WR_DONE_IMWR_ADDR_H(base)     ((base) + 0x09D4)
+#define PCIE_DMA_WR_ABORT_IMWR_ADDR_L(base)    ((base) + 0x09D8)
+#define PCIE_DMA_WR_ABORT_IMWR_ADDR_H(base)    ((base) + 0x09DC)
+#define PCIE_DMA_WR_IMWR_DATA(base)            ((base) + 0x09E0)
+#define PCIE_DMA_WR_LL_ERR_EN(base)            ((base) + 0x0A00)
+#define PCIE_DMA_WR_DOORBELL(base)             ((base) + 0x0980)
+#define PCIE_DMA_RD_ENABLE(base)               ((base) + 0x099C)
+#define PCIE_DMA_RD_DOORBELL(base)             ((base) + 0x09A0)
+#define PCIE_DMA_RD_CHWTLOW(base)              ((base) + 0x09A8)
+#define PCIE_DMA_RD_CHWTHIG(base)              ((base) + 0x09AC)
+#define PCIE_DMA_RD_INTSTS(base)               ((base) + 0x0A10)
+#define PCIE_DMA_RD_INTMASK(base)              ((base) + 0x0A18)
+#define PCIE_DMA_RD_INTCLER(base)              ((base) + 0x0A1C)
+#define PCIE_DMA_RD_ERR_STS_L(base)            ((base) + 0x0A24)
+#define PCIE_DMA_RD_ERR_STS_H(base)            ((base) + 0x0A28)
+#define PCIE_DMA_RD_LL_ERR_EN(base)            ((base) + 0x0A34)
+#define PCIE_DMA_RD_DONE_IMWR_ADDR_L(base)     ((base) + 0x0A3C)
+#define PCIE_DMA_RD_DONE_IMWR_ADDR_H(base)     ((base) + 0x0A40)
+#define PCIE_DMA_RD_ABORT_IMWR_ADDR_L(base)    ((base) + 0x0A44)
+#define PCIE_DMA_RD_ABORT_IMWR_ADDR_H(base)    ((base) + 0x0A48)
+#define PCIE_DMA_RD_IMWR_DATA(base)            ((base) + 0x0A4C)
+#define PCIE_DMA_CHNL_CONTEXT(base)            ((base) + 0x0A6C)
+#define PCIE_DMA_CHNL_CNTRL(base)              ((base) + 0x0A70)
+#define PCIE_DMA_XFR_SIZE(base)                        ((base) + 0x0A78)
+#define PCIE_DMA_SAR_LOW(base)                 ((base) + 0x0A7C)
+#define PCIE_DMA_SAR_HIGH(base)                        ((base) + 0x0A80)
+#define PCIE_DMA_DAR_LOW(base)                 ((base) + 0x0A84)
+#define PCIE_DMA_DAR_HIGH(base)                        ((base) + 0x0A88)
+#define PCIE_DMA_LLPTR_LOW(base)               ((base) + 0x0A8C)
+#define PCIE_DMA_LLPTR_HIGH(base)              ((base) + 0x0A90)
+#define PCIE_DMA_WRLL_ERR_ENB(base)            ((base) + 0x0A00)
+#define PCIE_DMA_RDLL_ERR_ENB(base)            ((base) + 0x0A34)
+#define PCIE_DMABD_CHNL_CNTRL(base)            ((base) + 0x8000)
+#define PCIE_DMABD_XFR_SIZE(base)              ((base) + 0x8004)
+#define PCIE_DMABD_SAR_LOW(base)               ((base) + 0x8008)
+#define PCIE_DMABD_SAR_HIGH(base)              ((base) + 0x800c)
+#define PCIE_DMABD_DAR_LOW(base)               ((base) + 0x8010)
+#define PCIE_DMABD_DAR_HIGH(base)              ((base) + 0x8014)
+#define PCIE_DMABD_LLPTR_LOW(base)             ((base) + 0x8018)
+#define PCIE_DMABD_LLPTR_HIGH(base)            ((base) + 0x801c)
+#define PCIE_WRDMA0_CHNL_CNTRL(base)           ((base) + 0x8000)
+#define PCIE_WRDMA0_XFR_SIZE(base)             ((base) + 0x8004)
+#define PCIE_WRDMA0_SAR_LOW(base)              ((base) + 0x8008)
+#define PCIE_WRDMA0_SAR_HIGH(base)             ((base) + 0x800c)
+#define PCIE_WRDMA0_DAR_LOW(base)              ((base) + 0x8010)
+#define PCIE_WRDMA0_DAR_HIGH(base)             ((base) + 0x8014)
+#define PCIE_WRDMA0_LLPTR_LOW(base)            ((base) + 0x8018)
+#define PCIE_WRDMA0_LLPTR_HIGH(base)           ((base) + 0x801c)
+#define PCIE_WRDMA1_CHNL_CNTRL(base)           ((base) + 0x8020)
+#define PCIE_WRDMA1_XFR_SIZE(base)             ((base) + 0x8024)
+#define PCIE_WRDMA1_SAR_LOW(base)              ((base) + 0x8028)
+#define PCIE_WRDMA1_SAR_HIGH(base)             ((base) + 0x802c)
+#define PCIE_WRDMA1_DAR_LOW(base)              ((base) + 0x8030)
+#define PCIE_WRDMA1_DAR_HIGH(base)             ((base) + 0x8034)
+#define PCIE_WRDMA1_LLPTR_LOW(base)            ((base) + 0x8038)
+#define PCIE_WRDMA1_LLPTR_HIGH(base)           ((base) + 0x803c)
+#define PCIE_RDDMA0_CHNL_CNTRL(base)           ((base) + 0x8040)
+#define PCIE_RDDMA0_XFR_SIZE(base)             ((base) + 0x8044)
+#define PCIE_RDDMA0_SAR_LOW(base)              ((base) + 0x8048)
+#define PCIE_RDDMA0_SAR_HIGH(base)             ((base) + 0x804c)
+#define PCIE_RDDMA0_DAR_LOW(base)              ((base) + 0x8050)
+#define PCIE_RDDMA0_DAR_HIGH(base)             ((base) + 0x8054)
+#define PCIE_RDDMA0_LLPTR_LOW(base)            ((base) + 0x8058)
+#define PCIE_RDDMA0_LLPTR_HIGH(base)           ((base) + 0x805c)
+#define PCIE_RDDMA1_CHNL_CNTRL(base)           ((base) + 0x8060)
+#define PCIE_RDDMA1_XFR_SIZE(base)             ((base) + 0x8064)
+#define PCIE_RDDMA1_SAR_LOW(base)              ((base) + 0x8068)
+#define PCIE_RDDMA1_SAR_HIGH(base)             ((base) + 0x806c)
+#define PCIE_RDDMA1_DAR_LOW(base)              ((base) + 0x8070)
+#define PCIE_RDDMA1_DAR_HIGH(base)             ((base) + 0x8074)
+#define PCIE_RDDMA1_LLPTR_LOW(base)            ((base) + 0x8078)
+#define PCIE_RDDMA1_LLPTR_HIGH(base)           ((base) + 0x807c)
+
+#define PCIE_ID(base)                          ((base) + 0x0000)
+#define PCIE_CMD(base)                         ((base) + 0x0004)
+#define PCIE_BAR(base, n)                      ((base) + 0x0010 + ((n) << 2))
+#define PCIE_CAP_PTR(base)                     ((base) + 0x0034)
+#define PCIE_MSI_LBAR(base)                    ((base) + 0x0054)
+#define PCIE_MSI_CTRL(base)                    ((base) + 0x0050)
+#define PCIE_MSI_ADDR_L(base)                  ((base) + 0x0054)
+#define PCIE_MSI_ADDR_H(base)                  ((base) + 0x0058)
+#define PCIE_MSI_DATA(base)                    ((base) + 0x005C)
+#define PCIE_MSI_MASK_BIT(base)                        ((base) + 0x0060)
+#define PCIE_MSI_PEND_BIT(base)                        ((base) + 0x0064)
+#define PCIE_DEVCAP(base)                      ((base) + 0x0074)
+#define PCIE_DEVCTLSTS(base)                   ((base) + 0x0078)
+
+#define PCIE_CMDSTS(base)                      ((base) + 0x0004)
+#define PCIE_LINK_STAT(base)                   ((base) + 0x80)
+#define PCIE_LINK_CTL2(base)                   ((base) + 0xa0)
+#define PCIE_ASPM_L1_CTRL(base)                        ((base) + 0x70c)
+#define PCIE_ASPM_LINK_CTRL(base)              (PCIE_LINK_STAT)
+#define PCIE_ASPM_L1_SUBSTATE_TIMING(base)     ((base) + 0xB44)
+#define PCIE_L1SUB_CTRL1(base)                 ((base) + 0x150)
+#define PCIE_PMCSR(base)                       ((base) + 0x44)
+#define PCIE_CFG_SPACE_LIMIT(base)             ((base) + 0x100)
+
+/* PCIe link defines */
+#define PEARL_PCIE_LINKUP                      (0x7)
+#define PEARL_PCIE_DATA_LINK                   (BIT(0))
+#define PEARL_PCIE_PHY_LINK                    (BIT(1))
+#define PEARL_PCIE_LINK_RST                    (BIT(3))
+#define PEARL_PCIE_FATAL_ERR                   (BIT(5))
+#define PEARL_PCIE_NONFATAL_ERR                        (BIT(6))
+
+/* PCIe Lane defines */
+#define PCIE_G2_LANE_X1                                ((BIT(0)) << 16)
+#define PCIE_G2_LANE_X2                                ((BIT(0) | BIT(1)) << 16)
+
+/* PCIe DLL link enable */
+#define PCIE_DLL_LINK_EN                       ((BIT(0)) << 5)
+
+#define PCIE_LINK_GEN1                         (BIT(0))
+#define PCIE_LINK_GEN2                         (BIT(1))
+#define PCIE_LINK_GEN3                         (BIT(2))
+#define PCIE_LINK_MODE(x)                      (((x) >> 16) & 0x7)
+
+#define MSI_EN                                 (BIT(0))
+#define MSI_64_EN                              (BIT(7))
+#define PCIE_MSI_ADDR_OFFSET(a)                        ((a) & 0xFFFF)
+#define PCIE_MSI_ADDR_ALIGN(a)                 ((a) & (~0xFFFF))
+
+#define PCIE_BAR_MASK(base, n)                 ((base) + 0x1010 + ((n) << 2))
+#define PCIE_MAX_BAR                           (6)
+
+#define PCIE_ATU_VIEW(base)                    ((base) + 0x0900)
+#define PCIE_ATU_CTL1(base)                    ((base) + 0x0904)
+#define PCIE_ATU_CTL2(base)                    ((base) + 0x0908)
+#define PCIE_ATU_LBAR(base)                    ((base) + 0x090c)
+#define PCIE_ATU_UBAR(base)                    ((base) + 0x0910)
+#define PCIE_ATU_LAR(base)                     ((base) + 0x0914)
+#define PCIE_ATU_LTAR(base)                    ((base) + 0x0918)
+#define PCIE_ATU_UTAR(base)                    ((base) + 0x091c)
+
+#define PCIE_MSI_ADDR_LOWER(base)              ((base) + 0x0820)
+#define PCIE_MSI_ADDR_UPPER(base)              ((base) + 0x0824)
+#define PCIE_MSI_ENABLE(base)                  ((base) + 0x0828)
+#define PCIE_MSI_MASK_RC(base)                 ((base) + 0x082c)
+#define PCIE_MSI_STATUS(base)                  ((base) + 0x0830)
+#define PEARL_PCIE_MSI_REGION                  (0xce000000)
+#define PEARL_PCIE_MSI_DATA                    (0)
+#define PCIE_MSI_GPIO(base)                    ((base) + 0x0888)
+
+#define PCIE_HDP_HOST_QUEUE_FULL       (BIT(17))
+#define USE_BAR_MATCH_MODE
+#define PCIE_ATU_OB_REGION             (BIT(0))
+#define PCIE_ATU_EN_REGION             (BIT(31))
+#define PCIE_ATU_EN_MATCH              (BIT(30))
+#define PCIE_BASE_REGION               (0xb0000000)
+#define PCIE_MEM_MAP_SIZE              (512 * 1024)
+
+#define PCIE_OB_REG_REGION             (0xcf000000)
+#define PCIE_CONFIG_REGION             (0xcf000000)
+#define PCIE_CONFIG_SIZE               (4096)
+#define PCIE_CONFIG_CH                 (1)
+
+/* inbound mapping */
+#define PCIE_IB_BAR0                   (0x00000000)    /* ddr */
+#define PCIE_IB_BAR0_CH                        (0)
+#define PCIE_IB_BAR3                   (0xe0000000)    /* sys_reg */
+#define PCIE_IB_BAR3_CH                        (1)
+
+/* outbound mapping */
+#define PCIE_MEM_CH                    (0)
+#define PCIE_REG_CH                    (1)
+#define PCIE_MEM_REGION                        (0xc0000000)
+#define        PCIE_MEM_SIZE                   (0x000fffff)
+#define PCIE_MEM_TAR                   (0x80000000)
+
+#define PCIE_MSI_REGION                        (0xce000000)
+#define PCIE_MSI_SIZE                  (KBYTE(4) - 1)
+#define PCIE_MSI_CH                    (1)
+
+/* size of config region */
+#define PCIE_CFG_SIZE                  (0x0000ffff)
+
+#define PCIE_ATU_DIR_IB                        (BIT(31))
+#define PCIE_ATU_DIR_OB                        (0)
+#define PCIE_ATU_DIR_CFG               (2)
+#define PCIE_ATU_DIR_MATCH_IB          (BIT(31) | BIT(30))
+
+#define PCIE_DMA_WR_0                  (0)
+#define PCIE_DMA_WR_1                  (1)
+#define PCIE_DMA_RD_0                  (2)
+#define PCIE_DMA_RD_1                  (3)
+
+#define PCIE_DMA_CHNL_CNTRL_CB         (BIT(0))
+#define PCIE_DMA_CHNL_CNTRL_TCB                (BIT(1))
+#define PCIE_DMA_CHNL_CNTRL_LLP                (BIT(2))
+#define PCIE_DMA_CHNL_CNTRL_LIE                (BIT(3))
+#define PCIE_DMA_CHNL_CNTRL_RIE                (BIT(4))
+#define PCIE_DMA_CHNL_CNTRL_CSS                (BIT(8))
+#define PCIE_DMA_CHNL_CNTRL_LLE                (BIT(9))
+#define PCIE_DMA_CHNL_CNTRL_TLP                (BIT(26))
+
+#define PCIE_DMA_CHNL_CONTEXT_RD       (BIT(31))
+#define PCIE_DMA_CHNL_CONTEXT_WR       (0)
+#define PCIE_MAX_BAR                   (6)
+
+/* PCIe HDP interrupt status definition */
+#define PCIE_HDP_INT_EP_RXDMA          (BIT(0))
+#define PCIE_HDP_INT_HBM_UF            (BIT(1))
+#define PCIE_HDP_INT_RX_LEN_ERR                (BIT(2))
+#define PCIE_HDP_INT_RX_HDR_LEN_ERR    (BIT(3))
+#define PCIE_HDP_INT_EP_TXDMA          (BIT(12))
+#define PCIE_HDP_INT_EP_TXEMPTY                (BIT(15))
+#define PCIE_HDP_INT_IPC               (BIT(29))
+
+/* PCIe interrupt status definition */
+#define PCIE_INT_MSI                   (BIT(24))
+#define PCIE_INT_INTX                  (BIT(23))
+
+/* PCIe legacy INTx */
+#define PEARL_PCIE_CFG0_OFFSET         (0x6C)
+#define PEARL_ASSERT_INTX              (BIT(9))
+
+/* SYS CTL regs */
+#define QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET      (0x001C)
+
+#define QTN_PEARL_IPC_IRQ_WORD(irq)    (BIT(irq) | BIT(irq + 16))
+#define QTN_PEARL_LHOST_IPC_IRQ                (6)
+
+#endif /* __PEARL_PCIE_H */
diff --git a/drivers/net/wireless/quantenna/include/qlink.h b/drivers/net/wireless/quantenna/include/qlink.h
new file mode 100644
index 0000000..7bb6b50
--- /dev/null
+++ b/drivers/net/wireless/quantenna/include/qlink.h
@@ -0,0 +1,584 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_QLINK_H_
+#define _QTN_QLINK_H_
+
+#define QLINK_HT_MCS_MASK_LEN  10
+#define QLINK_ETH_ALEN         6
+#define QLINK_MAX_SSID_LEN     32
+
+#define QLINK_PROTO_VER                1
+
+#define QLINK_ENUM_MASK(NAME) \
+       __ ## NAME, \
+       NAME = (__ ## NAME - 1) | (__ ## NAME - 2)
+
+enum qlink_phy_mode {
+       QLINK_PHYMODE_BGN       = BIT(0),
+       QLINK_PHYMODE_AN        = BIT(1),
+       QLINK_PHYMODE_AC        = BIT(2),
+};
+
+#define QLINK_MACID_RSVD               0xFF
+#define QLINK_VIFID_RSVD               0xFF
+
+#define QTNF_CMD_FLAG_SYNC             BIT(0)
+
+#define QLINK_MAX_CHANNELS             30
+
+enum qlink_msg_type {
+       QLINK_MSG_TYPE_CMD              = 1,
+       QLINK_MSG_TYPE_CMDRSP           = 2,
+       QLINK_MSG_TYPE_EVENT            = 3
+};
+
+enum qlink_cmd_action {
+       QTNF_HOSTCMD_ACTION_GET         = 0,
+       QTNF_HOSTCMD_ACTION_SET         = 1
+};
+
+enum qlink_host_cmd_type {
+       QLINK_HOSTCMD_FW_INIT                   = 0x0001,
+       QLINK_HOSTCMD_FW_DEINIT                 = 0x0002,
+       QLINK_HOSTCMD_REGISTER_MGMT             = 0x0003,
+       QLINK_HOSTCMD_SEND_MGMT_FRAME           = 0x0004,
+       QLINK_HOSTCMD_MGMT_SET_APPIE            = 0x0005,
+       QLINK_HOSTCMD_PHY_PARAMS                = 0x0011,
+       QLINK_HOSTCMD_HW_INFO                   = 0x0013,
+       QLINK_HOSTCMD_MAC_INFO                  = 0x0014,
+       QLINK_HOSTCMD_ADD_INTF                  = 0x0015,
+       QLINK_HOSTCMD_DEL_INTF                  = 0x0016,
+       QLINK_HOSTCMD_CHANGE_INTF               = 0x0017,
+       QLINK_HOSTCMD_UPDOWN_INTF               = 0x0018,
+       QLINK_HOSTCMD_REG_REGION                = 0x0019,
+       QLINK_HOSTCMD_MAC_CHAN_INFO             = 0x001A,
+       QLINK_HOSTCMD_CONFIG_AP                 = 0x0020,
+       QLINK_HOSTCMD_START_AP                  = 0x0021,
+       QLINK_HOSTCMD_STOP_AP                   = 0x0022,
+       QLINK_HOSTCMD_GET_STA_INFO              = 0x0030,
+       QLINK_HOSTCMD_ADD_KEY                   = 0x0040,
+       QLINK_HOSTCMD_DEL_KEY                   = 0x0041,
+       QLINK_HOSTCMD_SET_DEFAULT_KEY           = 0x0042,
+       QLINK_HOSTCMD_SET_DEFAULT_MGMT_KEY      = 0x0043,
+       QLINK_HOSTCMD_CHANGE_STA                = 0x0051,
+       QLINK_HOSTCMD_DEL_STA                   = 0x0052,
+       QLINK_HOSTCMD_SCAN                      = 0x0053,
+       QLINK_HOSTCMD_CONNECT                   = 0x0060,
+       QLINK_HOSTCMD_DISCONNECT                = 0x0061,
+};
+
+enum qlink_event_type {
+       QLINK_EVENT_STA_ASSOCIATED      = 0x0021,
+       QLINK_EVENT_STA_DEAUTH          = 0x0022,
+       QLINK_EVENT_MGMT_RECEIVED       = 0x0023,
+       QLINK_EVENT_SCAN_RESULTS        = 0x0024,
+       QLINK_EVENT_SCAN_COMPLETE       = 0x0025,
+       QLINK_EVENT_BSS_JOIN            = 0x0026,
+       QLINK_EVENT_BSS_LEAVE           = 0x0027,
+};
+
+enum qlink_tlv_id {
+       QTN_TLV_ID_FRAG_THRESH          = 0x0201,
+       QTN_TLV_ID_RTS_THRESH           = 0x0202,
+       QTN_TLV_ID_SRETRY_LIMIT         = 0x0203,
+       QTN_TLV_ID_LRETRY_LIMIT         = 0x0204,
+       QTN_TLV_ID_BCN_PERIOD           = 0x0205,
+       QTN_TLV_ID_DTIM                 = 0x0206,
+       QTN_TLV_ID_CHANNEL_CFG          = 0x020F,
+       QTN_TLV_ID_COVERAGE_CLASS       = 0x0213,
+       QTN_TLV_ID_IFACE_LIMIT          = 0x0214,
+       QTN_TLV_ID_NUM_IFACE_COMB       = 0x0215,
+       QTN_TLV_ID_CHAN_COUNT           = 0x0216,
+       QTN_TLV_ID_STA_BASIC_COUNTERS   = 0x0300,
+       QTN_TLV_ID_STA_GENERIC_INFO     = 0x0301,
+       QTN_TLV_ID_KEY                  = 0x0302,
+       QTN_TLV_ID_SEQ                  = 0x0303,
+       QTN_TLV_ID_CRYPTO               = 0x0304,
+       QTN_TLV_ID_IE_SET               = 0x0305,
+};
+
+enum qlink_iface_type {
+       QLINK_IFTYPE_AP         = BIT(0),
+       QLINK_IFTYPE_STATION    = BIT(1),
+       QLINK_IFTYPE_ADHOC      = BIT(2),
+       QLINK_IFTYPE_MONITOR    = BIT(3),
+       QLINK_IFTYPE_WDS        = BIT(4),
+
+       /* keep last */
+       QLINK_ENUM_MASK(QLINK_IFTYPE_MASK)
+};
+
+enum qlink_hw_capab {
+       QLINK_HW_SUPPORTS_REG_UPDATE    = BIT(0),
+};
+
+enum qlink_chan_width {
+       QLINK_CHAN_WIDTH_5              = BIT(0),
+       QLINK_CHAN_WIDTH_10             = BIT(1),
+       QLINK_CHAN_WIDTH_20_NOHT        = BIT(2),
+       QLINK_CHAN_WIDTH_20             = BIT(3),
+       QLINK_CHAN_WIDTH_40             = BIT(4),
+       QLINK_CHAN_WIDTH_80             = BIT(5),
+       QLINK_CHAN_WIDTH_80P80          = BIT(6),
+       QLINK_CHAN_WIDTH_160            = BIT(7),
+
+       /* keep last */
+       QLINK_ENUM_MASK(QLINK_CHAN_WIDTH_MASK)
+};
+
+#define QTNF_DEF_DFS_CAC_TIME          60000
+enum qlink_channel_flags {
+       /* bits 0-3 are for private use by drivers */
+       /* channel attributes */
+       QLINK_CHAN_TURBO                = BIT(4),
+       QLINK_CHAN_CCK                  = BIT(5),
+       QLINK_CHAN_OFDM                 = BIT(6),
+       QLINK_CHAN_2GHZ                 = BIT(7),
+       QLINK_CHAN_5GHZ                 = BIT(8),
+       QLINK_CHAN_PASSIVE              = BIT(9),
+       QLINK_CHAN_DYN                  = BIT(10),
+       QLINK_CHAN_GFSK                 = BIT(11),
+       QLINK_CHAN_RADAR                = BIT(12),
+       QLINK_CHAN_STURBO               = BIT(13),
+       QLINK_CHAN_HALF                 = BIT(14),
+       QLINK_CHAN_QUARTER              = BIT(15),
+       QLINK_CHAN_HT20                 = BIT(16),
+       QLINK_CHAN_HT40U                = BIT(17),
+       QLINK_CHAN_HT40D                = BIT(18),
+       QLINK_CHAN_HT40                 = BIT(19),
+       QLINK_CHAN_DFS                  = BIT(20),
+       QLINK_CHAN_DFS_CAC_DONE         = BIT(21),
+       QLINK_CHAN_VHT80                = BIT(22),
+       QLINK_CHAN_DFS_OCAC_DONE        = BIT(23),
+       QLINK_CHAN_DFS_CAC_IN_PROGRESS  = BIT(24),
+       QLINK_CHAN_WEATHER              = BIT(25),
+       QLINK_CHAN_WEATHER_40M          = BIT(26),
+       QLINK_CHAN_WEATHER_80M          = BIT(27),
+       QLINK_CHAN_WEATHER_160M         = BIT(28),
+       QLINK_CHAN_VHT160               = BIT(29),
+       QLINK_CHAN_AC_NG                = BIT(30),
+};
+
+enum qlink_host_cmd_result {
+       QLINK_HOSTCMD_RESULT_OK = 0,
+       QLINK_HOSTCMD_RESULT_INVALID,
+       QLINK_HOSTCMD_RESULT_ENOTSUPP,
+       QLINK_HOSTCMD_RESULT_ENOTFOUND,
+};
+
+struct qlink_msg_header {
+       __le16 type;
+       __le16 len;
+} __packed;
+
+struct qlink_host_cmd {
+       struct qlink_msg_header header;
+       __le16 cmd_id;
+       __le16 seq_num;
+       __le16 result;
+       u8 macid;
+       u8 vifid;
+       u8 payload[0];
+} __packed;
+#define QTNF_DEF_CMDHDR_SZ     sizeof(struct qlink_host_cmd)
+
+struct qlink_event_header {
+       struct qlink_msg_header header;
+       __le16 event_id;
+       u8 macid;
+       u8 vifid;
+       u8 payload[0];
+} __packed;
+#define QTNF_DEF_EVHDR_SZ      sizeof(struct qlink_event_header)
+
+struct qlink_tlv_hdr {
+       __le16 type;
+       __le16 len;
+       u8 val[0];
+} __packed;
+#define QTNF_TLV_SZ    sizeof(struct qlink_tlv_hdr)
+
+struct qlink_ht_mcs_info {
+       u8 rx_mask[QLINK_HT_MCS_MASK_LEN];
+       __le16 rx_highest;
+       u8 tx_params;
+       u8 reserved[3];
+} __packed;
+
+struct qlink_ht_cap {
+       struct qlink_ht_mcs_info mcs;
+       __le32 tx_BF_cap_info;
+       __le16 cap_info;
+       __le16 extended_ht_cap_info;
+       u8 ampdu_params_info;
+       u8 antenna_selection_info;
+} __packed;
+
+struct qlink_vht_mcs_info {
+       __le16 rx_mcs_map;
+       __le16 rx_highest;
+       __le16 tx_mcs_map;
+       __le16 tx_highest;
+} __packed;
+
+struct qlink_vht_cap {
+       __le32 vht_cap_info;
+       struct qlink_vht_mcs_info supp_mcs;
+} __packed;
+
+struct qlink_hw_info {
+       __le32 fw_api_ver;
+       __le32 hw_capab;
+       __le16 ql_proto_ver;
+       u8 country_code[2];
+       u8 num_mac;
+       u8 mac_bitmap;
+       u8 total_tx_chain;
+       u8 total_rx_chain;
+       u8 payload[0];
+} __packed;
+
+struct qlink_iface_limit {
+       __le16 max_num;
+       __le16 type_mask;
+} __packed;
+
+struct qlink_iface_comb_num {
+       __le16 iface_comb_num;
+} __packed;
+
+struct qlink_mac_info {
+       __le16 phymode;
+       u8 dev_mac[QLINK_ETH_ALEN];
+       u8 num_tx_chain;
+       u8 num_rx_chain;
+       struct qlink_vht_cap vht_cap;
+       struct qlink_ht_cap ht_cap;
+       __le16 max_ap_assoc_sta;
+       __le16 radar_detect_widths;
+       u8 payload[0];
+} __packed;
+
+struct qlink_intf_info {
+       __le16 if_type;
+       __le16 flags;
+       u8 mac_addr[QLINK_ETH_ALEN];
+} __packed;
+
+enum qlink_mgmt_frame_type {
+       QLINK_MGMT_FRAME_ASSOC_REQ      = 0x00,
+       QLINK_MGMT_FRAME_ASSOC_RESP     = 0x01,
+       QLINK_MGMT_FRAME_REASSOC_REQ    = 0x02,
+       QLINK_MGMT_FRAME_REASSOC_RESP   = 0x03,
+       QLINK_MGMT_FRAME_PROBE_REQ      = 0x04,
+       QLINK_MGMT_FRAME_PROBE_RESP     = 0x05,
+       QLINK_MGMT_FRAME_BEACON         = 0x06,
+       QLINK_MGMT_FRAME_ATIM           = 0x07,
+       QLINK_MGMT_FRAME_DISASSOC       = 0x08,
+       QLINK_MGMT_FRAME_AUTH           = 0x09,
+       QLINK_MGMT_FRAME_DEAUTH         = 0x0A,
+       QLINK_MGMT_FRAME_ACTION         = 0x0B,
+
+       QLINK_MGMT_FRAME_TYPE_COUNT
+};
+
+struct qlink_mgmt_frame_reg_req {
+       __le16 frame_type;
+       u8 do_register;
+} __packed;
+
+enum qlink_rxmgmt_flags {
+       QLINK_RXMGMT_FLAG_ANSWERED = 1 << 0,
+};
+
+struct qlink_event_sta_assoc {
+       u8 sta_addr[QLINK_ETH_ALEN];
+       __le16 frame_control;
+       u8 payload[0];
+} __packed;
+
+struct qlink_event_sta_deauth {
+       u8 sta_addr[QLINK_ETH_ALEN];
+       __le16 reason;
+} __packed;
+
+struct qlink_event_bss_join {
+       u8 bssid[QLINK_ETH_ALEN];
+       __le16 status;
+} __packed;
+
+struct qlink_event_bss_leave {
+       u16 reason;
+} __packed;
+
+struct qlink_event_rxmgmt {
+       __le32 freq;
+       __le32 sig_mbm;
+       __le32 flags;
+       u8 frame_data[0];
+} __packed;
+
+enum qlink_scan_complete_flags {
+       QLINK_SCAN_NONE         = 0,
+       QLINK_SCAN_ABORTED      = BIT(0),
+};
+
+enum qlink_frame_type {
+       QLINK_BSS_FTYPE_UNKNOWN,
+       QLINK_BSS_FTYPE_BEACON,
+       QLINK_BSS_FTYPE_PRESP,
+};
+
+struct qlink_event_scan_entry {
+       __le64 tsf;
+       __le16 freq;
+       __le16 capab;
+       __le16 bintval;
+       s8 signal;
+       u8 frame_type;
+       u8 bssid[QLINK_ETH_ALEN];
+       u8 ssid_len;
+       u8 ssid[QLINK_MAX_SSID_LEN];
+       u8 payload[0];
+} __packed;
+
+struct qlink_event_scan_complete {
+       __le32 flags;
+} __packed;
+
+enum qlink_mgmt_frame_tx_flags {
+       QLINK_MGMT_FRAME_TX_FLAG_NONE           = 0,
+       QLINK_MGMT_FRAME_TX_FLAG_OFFCHAN        = BIT(0),
+       QLINK_MGMT_FRAME_TX_FLAG_NO_CCK         = BIT(1),
+       QLINK_MGMT_FRAME_TX_FLAG_ACK_NOWAIT     = BIT(2),
+
+       /* keep last */
+       QLINK_ENUM_MASK(QLINK_MGMT_FRAME_TX_FLAG_MASK)
+};
+
+struct qlink_mgmt_frame_tx_req {
+       __le32 cookie;
+       __le16 freq;
+       __le16 flags;
+       u8 frame_data[0];
+} __packed;
+
+struct qlink_mgmt_append_ie_req {
+       u8 type;                /* \sa qlink_mgmt_frame_type */
+       u8 flags;               /* not used / for possible future use */
+       u8 frame_data[0];
+} __packed;
+
+/* Begin of STA info section */
+
+struct qlink_sta_info_req {
+       u8 sta_addr[QLINK_ETH_ALEN];
+} __packed;
+
+struct qlink_sta_info_res {
+       u8 sta_addr[QLINK_ETH_ALEN];
+       u8 payload[0];          /* Here comes STA info TLVs */
+} __packed;
+
+struct qlink_sta_stat_basic_counters {
+       __le64 rx_bytes;
+       __le64 tx_bytes;
+       __le64 rx_beacons;
+       __le32 rx_packets;
+       __le32 tx_packets;
+       __le32 rx_dropped;
+       __le32 tx_failed;
+} __packed;
+
+enum qlink_sta_info_rate_flags {
+       QLINK_STA_INFO_RATE_FLAG_INVALID        = 0,
+       QLINK_STA_INFO_RATE_FLAG_HT_MCS         = BIT(0),
+       QLINK_STA_INFO_RATE_FLAG_VHT_MCS        = BIT(1),
+       QLINK_STA_INFO_RATE_FLAG_SHORT_GI       = BIT(2),
+       QLINK_STA_INFO_RATE_FLAG_60G            = BIT(3),
+
+       /* keep last */
+       QLINK_ENUM_MASK(QLINK_STA_INFO_RATE_FLAG_MASK)
+};
+
+enum qlink_sta_flags {
+       QLINK_STA_FLAG_INVALID          = 0,
+       QLINK_STA_FLAG_AUTHORIZED               = BIT(0),
+       QLINK_STA_FLAG_SHORT_PREAMBLE   = BIT(1),
+       QLINK_STA_FLAG_WME                      = BIT(2),
+       QLINK_STA_FLAG_MFP                      = BIT(3),
+       QLINK_STA_FLAG_AUTHENTICATED            = BIT(4),
+       QLINK_STA_FLAG_TDLS_PEER                = BIT(5),
+       QLINK_STA_FLAG_ASSOCIATED               = BIT(6),
+
+       /* keep last */
+       QLINK_ENUM_MASK(QLINK_STA_INFO_STATE_FLAG_MASK)
+};
+
+enum qlink_sta_info_rate_bw {
+       QLINK_STA_INFO_RATE_BW_5                = 0,
+       QLINK_STA_INFO_RATE_BW_10               = 1,
+       QLINK_STA_INFO_RATE_BW_20               = 2,
+       QLINK_STA_INFO_RATE_BW_40               = 3,
+       QLINK_STA_INFO_RATE_BW_80               = 4,
+       QLINK_STA_INFO_RATE_BW_160              = 5,
+
+       /* keep last */
+       QLINK_ENUM_MASK(QLINK_STA_INFO_RATE_BW_MAX)
+};
+
+struct qlink_sta_info_rate {
+       __le16 rate;            /* Mbps */
+       u8 flags;               /* qlink_sta_info_rate_flags */
+       u8 mcs;
+       u8 nss;
+       u8 bw;                  /* qlink_sta_info_rate_bw */
+} __packed;
+
+struct qlink_sta_info_state {
+       __le32 mask;
+       __le32 value;
+} __packed;
+
+#define QLINK_RSSI_OFFSET      120
+
+struct qlink_sta_info_generic {
+       struct qlink_sta_info_state state;      /* qlink_sta_info_state_flags */
+       __le32 connected_time;
+       __le32 inactive_time;
+       struct qlink_sta_info_rate rx_rate;
+       struct qlink_sta_info_rate tx_rate;
+       u8 rssi;
+       u8 rssi_avg;
+} __packed;
+
+/* End of STA info section */
+
+struct qlink_tlv_frag_rts_thr {
+       struct qlink_tlv_hdr hdr;
+       __le16 thr;
+} __packed;
+
+struct qlink_tlv_rlimit {
+       struct qlink_tlv_hdr hdr;
+       u8 rlimit;
+} __packed;
+
+struct qlink_tlv_cclass {
+       struct qlink_tlv_hdr hdr;
+       u8 cclass;
+} __packed;
+
+#define QLINK_MAX_NR_CIPHER_SUITES            5
+#define QLINK_MAX_NR_AKM_SUITES               2
+
+struct qlink_auth_encr {
+       __le32 wpa_versions;
+       __le32 cipher_group;
+       __le32 n_ciphers_pairwise;
+       __le32 ciphers_pairwise[QLINK_MAX_NR_CIPHER_SUITES];
+       __le32 n_akm_suites;
+       __le32 akm_suites[QLINK_MAX_NR_AKM_SUITES];
+       __le16 control_port_ethertype;
+       u8 auth_type;
+       u8 privacy;
+       u8 mfp;
+       u8 control_port;
+       u8 control_port_no_encrypt;
+} __packed;
+
+struct qlink_add_key_req {
+       u8 key_index;
+       u8 pairwise;
+       u8 addr[QLINK_ETH_ALEN];
+       __le32 cipher;
+       u8 payload[0];
+} __packed;
+
+struct qlink_del_key_req {
+       u8 key_index;
+       u8 pairwise;
+       u8 addr[QLINK_ETH_ALEN];
+} __packed;
+
+struct qlink_set_def_key_req {
+       u8 key_index;
+       u8 unicast;
+       u8 multicast;
+} __packed;
+
+struct qlink_set_def_mgmt_key_req {
+       u8 key_index;
+} __packed;
+
+struct qlink_sta_params_req {
+       __le32 sta_flags_mask;
+       __le32 sta_flags_set;
+       u8 sta_addr[QLINK_ETH_ALEN];
+} __packed;
+
+struct qlink_del_sta_req {
+       __le16 reason_code;
+       u8 subtype;
+       u8 sta_addr[QLINK_ETH_ALEN];
+} __packed;
+
+enum qlink_sta_connect_flags {
+       QLINK_STA_CONNECT_DISABLE_HT    = BIT(0),
+       QLINK_STA_CONNECT_DISABLE_VHT   = BIT(1),
+       QLINK_STA_CONNECT_USE_RRM       = BIT(2),
+
+       /* keep last */
+       QLINK_ENUM_MASK(QLINK_STA_CONNECT_FLAGS_MASK)
+};
+
+struct qlink_connect_req {
+       __le32 flags;
+       __le16 freq;
+       __le16 bg_scan_period;
+       u8 bssid[QLINK_ETH_ALEN];
+       u8 payload[0];
+} __packed;
+
+struct qlink_disconnect_req {
+       __le16 reason;
+} __packed;
+
+struct qlink_chan_count {
+       __le16 count;
+} __packed;
+
+struct qlink_channel {
+       __le32 ic_flags;
+       __le32 ic_ext_flags;
+       /* setting in Mhz */
+       __le16 ic_freq;
+       /* IEEE channel number */
+       u8 ic_ieee;
+       /* maximum regulatory tx power in dBm */
+       s8 ic_maxregpower;
+       /* maximum tx power in dBm with beam-forming off */
+       s8 ic_maxpower;
+       /* minimum tx power in dBm */
+       s8 ic_minpower;
+
+       u8 ic_center_f_40mhz;
+       u8 ic_center_f_80mhz;
+       u8 ic_center_f_160mhz;
+} __packed;
+
+#endif /* _QTN_QLINK_H_ */
diff --git a/drivers/net/wireless/quantenna/include/qtn_hw_ids.h b/drivers/net/wireless/quantenna/include/qtn_hw_ids.h
new file mode 100644
index 0000000..353669b
--- /dev/null
+++ b/drivers/net/wireless/quantenna/include/qtn_hw_ids.h
@@ -0,0 +1,34 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef        _QTN_HW_IDS_H_
+#define        _QTN_HW_IDS_H_
+
+#include <linux/pci_ids.h>
+
+/* */
+
+#define PCIE_VENDOR_ID_QUANTENNA       (0x1bb5)
+
+/* PCIE Device IDs */
+
+#define        PCIE_DEVICE_ID_QTN_PEARL        (0x0008)
+
+/* FW names */
+
+#define QTN_PCI_FW_NAME                "pearl-linux.lzma.img"
+
+#endif /* _QTN_HW_IDS_H_ */
diff --git a/drivers/net/wireless/quantenna/include/shm_ipc_defs.h b/drivers/net/wireless/quantenna/include/shm_ipc_defs.h
new file mode 100644
index 0000000..5f302b2
--- /dev/null
+++ b/drivers/net/wireless/quantenna/include/shm_ipc_defs.h
@@ -0,0 +1,46 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_SHM_IPC_DEFS_H_
+#define _QTN_FMAC_SHM_IPC_DEFS_H_
+
+#include <linux/types.h>
+
+#define QTN_IPC_REG_HDR_SZ     (32)
+#define QTN_IPC_REG_SZ         (4096)
+#define QTN_IPC_MAX_DATA_SZ    (QTN_IPC_REG_SZ - QTN_IPC_REG_HDR_SZ)
+
+enum qtnf_shm_ipc_region_flags {
+       QTNF_SHM_IPC_NEW_DATA           = BIT(0),
+       QTNF_SHM_IPC_ACK                = BIT(1),
+};
+
+struct qtnf_shm_ipc_region_header {
+       __le32 flags;
+       __le16 data_len;
+} __packed;
+
+union qtnf_shm_ipc_region_headroom {
+       struct qtnf_shm_ipc_region_header hdr;
+       u8 headroom[QTN_IPC_REG_HDR_SZ];
+} __packed;
+
+struct qtnf_shm_ipc_region {
+       union qtnf_shm_ipc_region_headroom headroom;
+       u8 data[QTN_IPC_MAX_DATA_SZ];
+} __packed;
+
+#endif /* _QTN_FMAC_SHM_IPC_DEFS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Kconfig b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
new file mode 100644
index 0000000..b69c018
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
@@ -0,0 +1,20 @@
+config QTNFMAC
+       tristate "Quantenna WiFi FullMAC WLAN driver"
+       default n
+       depends on CFG80211
+       ---help---
+         This adds support for wireless adapters based on Quantenna chipsets.
+         If you choose to build it as a module, it will be called
+         qtnfmac.ko.
+
+config QTNFMAC_PCIE
+       tristate "PCIE bus interface support for Quantenna FullMAC driver"
+       default n
+       depends on QTNFMAC && PCI
+       depends on HAS_DMA
+       select FW_LOADER
+       select CRC32
+       ---help---
+         This option enables the PCIE bus support for Quantenna FullMAC
+         WLAN driver. If you choose to build it as a module, it will be called
+         qtnfmac_pcie.ko.
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/wireless/quantenna/qtnfmac/Makefile
new file mode 100644
index 0000000..cf50e36
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -0,0 +1,24 @@
+#
+# Copyright (c) 2015-2016 Quantenna Communications, Inc.
+# All rights reserved.
+#
+
+ccflags-y += -Idrivers/net/wireless/quantenna/include
+ccflags-y += -D__CHECK_ENDIAN
+
+obj-$(CONFIG_QTNFMAC) += qtnfmac.o
+
+qtnfmac-objs += \
+       core.o \
+       init.o \
+       commands.o \
+       trans.o \
+       cfg80211.o \
+       event.o \
+       util.o \
+       qlink_util.o
+
+obj-$(CONFIG_QTNFMAC_PCIE) += qtnfmac_pcie.o
+qtnfmac_pcie-objs += \
+       pcie.o \
+       shm_ipc.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
new file mode 100644
index 0000000..8f8175c
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -0,0 +1,1097 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include <linux/kernel.h>
+#include <linux/etherdevice.h>
+#include <linux/vmalloc.h>
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include <net/netlink.h>
+
+#include "cfg80211.h"
+#include "commands.h"
+#include "core.h"
+#include "util.h"
+#include "bus.h"
+
+/* Supported rates to be advertised to the cfg80211 */
+static struct ieee80211_rate qtnf_rates[] = {
+       {.bitrate = 10, .hw_value = 2, },
+       {.bitrate = 20, .hw_value = 4, },
+       {.bitrate = 55, .hw_value = 11, },
+       {.bitrate = 110, .hw_value = 22, },
+       {.bitrate = 60, .hw_value = 12, },
+       {.bitrate = 90, .hw_value = 18, },
+       {.bitrate = 120, .hw_value = 24, },
+       {.bitrate = 180, .hw_value = 36, },
+       {.bitrate = 240, .hw_value = 48, },
+       {.bitrate = 360, .hw_value = 72, },
+       {.bitrate = 480, .hw_value = 96, },
+       {.bitrate = 540, .hw_value = 108, },
+};
+
+/* Channel definitions to be advertised to cfg80211 */
+static struct ieee80211_channel qtnf_channels_2ghz[] = {
+       {.center_freq = 2412, .hw_value = 1, },
+       {.center_freq = 2417, .hw_value = 2, },
+       {.center_freq = 2422, .hw_value = 3, },
+       {.center_freq = 2427, .hw_value = 4, },
+       {.center_freq = 2432, .hw_value = 5, },
+       {.center_freq = 2437, .hw_value = 6, },
+       {.center_freq = 2442, .hw_value = 7, },
+       {.center_freq = 2447, .hw_value = 8, },
+       {.center_freq = 2452, .hw_value = 9, },
+       {.center_freq = 2457, .hw_value = 10, },
+       {.center_freq = 2462, .hw_value = 11, },
+       {.center_freq = 2467, .hw_value = 12, },
+       {.center_freq = 2472, .hw_value = 13, },
+       {.center_freq = 2484, .hw_value = 14, },
+};
+
+static struct ieee80211_supported_band qtnf_band_2ghz = {
+       .channels = qtnf_channels_2ghz,
+       .n_channels = ARRAY_SIZE(qtnf_channels_2ghz),
+       .bitrates = qtnf_rates,
+       .n_bitrates = ARRAY_SIZE(qtnf_rates),
+};
+
+static struct ieee80211_channel qtnf_channels_5ghz[] = {
+       {.center_freq = 5040, .hw_value = 8, },
+       {.center_freq = 5060, .hw_value = 12, },
+       {.center_freq = 5080, .hw_value = 16, },
+       {.center_freq = 5170, .hw_value = 34, },
+       {.center_freq = 5190, .hw_value = 38, },
+       {.center_freq = 5210, .hw_value = 42, },
+       {.center_freq = 5230, .hw_value = 46, },
+       {.center_freq = 5180, .hw_value = 36, },
+       {.center_freq = 5200, .hw_value = 40, },
+       {.center_freq = 5220, .hw_value = 44, },
+       {.center_freq = 5240, .hw_value = 48, },
+       {.center_freq = 5260, .hw_value = 52, },
+       {.center_freq = 5280, .hw_value = 56, },
+       {.center_freq = 5300, .hw_value = 60, },
+       {.center_freq = 5320, .hw_value = 64, },
+       {.center_freq = 5500, .hw_value = 100, },
+       {.center_freq = 5520, .hw_value = 104, },
+       {.center_freq = 5540, .hw_value = 108, },
+       {.center_freq = 5560, .hw_value = 112, },
+       {.center_freq = 5580, .hw_value = 116, },
+       {.center_freq = 5600, .hw_value = 120, },
+       {.center_freq = 5620, .hw_value = 124, },
+       {.center_freq = 5640, .hw_value = 128, },
+       {.center_freq = 5660, .hw_value = 132, },
+       {.center_freq = 5680, .hw_value = 136, },
+       {.center_freq = 5700, .hw_value = 140, },
+       {.center_freq = 5745, .hw_value = 149, },
+       {.center_freq = 5765, .hw_value = 153, },
+       {.center_freq = 5785, .hw_value = 157, },
+       {.center_freq = 5805, .hw_value = 161, },
+       {.center_freq = 5825, .hw_value = 165, },
+};
+
+static struct ieee80211_supported_band qtnf_band_5ghz = {
+       .channels = qtnf_channels_5ghz,
+       .n_channels = ARRAY_SIZE(qtnf_channels_5ghz),
+       .bitrates = qtnf_rates + 4,
+       .n_bitrates = ARRAY_SIZE(qtnf_rates) - 4,
+};
+
+/* Supported crypto cipher suits to be advertised to cfg80211 */
+static const u32 qtnf_cipher_suites[] = {
+       WLAN_CIPHER_SUITE_TKIP,
+       WLAN_CIPHER_SUITE_CCMP,
+       WLAN_CIPHER_SUITE_AES_CMAC,
+};
+
+/* Supported mgmt frame types to be advertised to cfg80211 */
+static const struct ieee80211_txrx_stypes
+qtnf_mgmt_stypes[NUM_NL80211_IFTYPES] = {
+       [NL80211_IFTYPE_STATION] = {
+               .tx = BIT(IEEE80211_STYPE_ACTION >> 4),
+               .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+                     BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+       },
+       [NL80211_IFTYPE_AP] = {
+               .tx = BIT(IEEE80211_STYPE_ACTION >> 4),
+               .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+                     BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+       },
+};
+
+static int
+qtnf_change_virtual_intf(struct wiphy *wiphy,
+                        struct net_device *dev,
+                        enum nl80211_iftype type, u32 *flags,
+                        struct vif_params *params)
+{
+       struct qtnf_vif *vif;
+       u8 *mac_addr;
+
+       vif = qtnf_netdev_get_priv(dev);
+
+       if (params)
+               mac_addr = params->macaddr;
+       else
+               mac_addr = NULL;
+
+       if (qtnf_cmd_send_change_intf_type(vif, type, mac_addr)) {
+               pr_err("%s: failed to change interface type\n", __func__);
+               return -EFAULT;
+       }
+
+       vif->wdev.iftype = type;
+       return 0;
+}
+
+int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+       struct net_device *netdev =  wdev->netdev;
+       struct qtnf_vif *vif;
+
+       if (WARN_ON(!netdev)) {
+               pr_err("could not get netdev for wdev\n");
+               return -EFAULT;
+       }
+
+       vif = qtnf_netdev_get_priv(wdev->netdev);
+
+       if (qtnf_cmd_send_del_intf(vif))
+               pr_err("%s: failed to send del_intf command\n", __func__);
+
+       /* Stop data */
+       netif_tx_stop_all_queues(netdev);
+       if (netif_carrier_ok(netdev))
+               netif_carrier_off(netdev);
+
+       if (netdev->reg_state == NETREG_REGISTERED)
+               unregister_netdevice(netdev);
+
+       /* Clear the vif in mac */
+       vif->netdev->ieee80211_ptr = NULL;
+       vif->netdev = NULL;
+       vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+       eth_zero_addr(vif->mac_addr);
+
+       return 0;
+}
+
+struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
+                                          const char *name,
+                                          unsigned char name_assign_type,
+                                          enum nl80211_iftype type,
+                                          u32 *flags,
+                                          struct vif_params *params)
+{
+       struct qtnf_wmac *mac;
+       struct qtnf_vif *vif;
+       u8 *mac_addr = NULL;
+
+       mac = wiphy_priv(wiphy);
+
+       if (!mac)
+               return ERR_PTR(-EFAULT);
+
+       switch (type) {
+       case NL80211_IFTYPE_STATION:
+       case NL80211_IFTYPE_AP:
+               vif = qtnf_get_free_vif(mac);
+               if (!vif) {
+                       pr_err("qtnfmac: %s: could not get free private structure\n",
+                              __func__);
+                       return ERR_PTR(-EFAULT);
+               }
+
+               eth_zero_addr(vif->mac_addr);
+               vif->bss_priority = QTNF_DEF_BSS_PRIORITY;
+               vif->wdev.wiphy = wiphy;
+               vif->wdev.iftype = type;
+               vif->sta_state = QTNF_STA_DISCONNECTED;
+               break;
+       default:
+               pr_err("qtnfmac: %s: unsupported virtual interface type (%d)\n",
+                      __func__, type);
+               return ERR_PTR(-ENOTSUPP);
+       }
+
+       if (params)
+               mac_addr = params->macaddr;
+
+       if (qtnf_cmd_send_add_intf(vif, type, mac_addr)) {
+               vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+               pr_err("%s: failed to send add_intf command\n", __func__);
+               return ERR_PTR(-EFAULT);
+       }
+
+       if (!is_valid_ether_addr(vif->mac_addr)) {
+               vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+               pr_err("%s: invalid MAC address from FW EP for add_intf\n",
+                      __func__);
+               return ERR_PTR(-EFAULT);
+       }
+
+       if (qtnf_net_attach(mac, vif, name, name_assign_type, type)) {
+               pr_err("could not attach netdev\n");
+               vif->netdev = NULL;
+               vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+               return ERR_PTR(-EFAULT);
+       }
+
+       vif->wdev.netdev = vif->netdev;
+       return &vif->wdev;
+}
+
+/* concatenate all the beacon IEs into one buffer
+ * Take IEs from head, tail and beacon_ies fields of cfg80211_beacon_data
+ * and append it to provided buffer.
+ * Checks total IE buf length to be <= than IEEE80211_MAX_DATA_LEN.
+ * Checks IE buffers to be valid, so that resulting buffer
+ * should be a valid IE buffer with length <= IEEE80211_MAX_DATA_LEN.
+ */
+static int qtnf_get_beacon_ie(const struct cfg80211_beacon_data *info,
+                             uint8_t *buf)
+{
+       const struct ieee80211_mgmt *frame = (void *)info->head;
+       const size_t head_tlv_offset = offsetof(struct ieee80211_mgmt,
+                                               u.beacon.variable);
+       const size_t head_tlv_len = (info->head_len > head_tlv_offset) ?
+                                    info->head_len - head_tlv_offset : 0;
+       size_t pos = 0;
+
+       if (frame && head_tlv_len) {
+               if (pos + head_tlv_len > IEEE80211_MAX_DATA_LEN) {
+                       pr_warn("%s: too large beacon head IEs: %zu\n",
+                               __func__, pos + head_tlv_len);
+                       return -E2BIG;
+               } else if (qtnf_ieee80211_check_ie_buf(frame->u.beacon.variable,
+                                                      head_tlv_len)) {
+                       memcpy(buf, frame->u.beacon.variable, head_tlv_len);
+                       pos += head_tlv_len;
+                       buf += head_tlv_len;
+               } else {
+                       pr_warn("%s: invalid head IE buf\n", __func__);
+                       return -EINVAL;
+               }
+       }
+
+       if (info->tail && info->tail_len) {
+               if (pos + info->tail_len > IEEE80211_MAX_DATA_LEN) {
+                       pr_warn("%s: too large beacon tail IEs: %zu\n",
+                               __func__, pos + info->tail_len);
+                       return -E2BIG;
+               } else if (qtnf_ieee80211_check_ie_buf(info->tail,
+                                                      info->tail_len)) {
+                       memcpy(buf, info->tail, info->tail_len);
+                       pos += info->tail_len;
+                       buf += info->tail_len;
+               } else {
+                       pr_warn("%s: invalid tail IE buf\n", __func__);
+                       return -EINVAL;
+               }
+       }
+
+       if (info->beacon_ies && info->beacon_ies_len) {
+               if (pos + info->beacon_ies_len > IEEE80211_MAX_DATA_LEN) {
+                       pr_warn("%s: too large beacon extra IEs: %zu\n",
+                               __func__, pos + info->beacon_ies_len);
+                       return -E2BIG;
+               } else if (qtnf_ieee80211_check_ie_buf(info->beacon_ies,
+                                                      info->beacon_ies_len)) {
+                       memcpy(buf, info->beacon_ies, info->beacon_ies_len);
+                       pos += info->beacon_ies_len;
+                       buf += info->beacon_ies_len;
+               } else {
+                       pr_warn("%s: invalid beacon_ies IE buf\n", __func__);
+                       return -EINVAL;
+               }
+       }
+
+       return pos;
+}
+
+static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
+                              const struct cfg80211_beacon_data *info)
+{
+       u8 *beacon_ies;
+       int beacon_ies_len;
+       int ret = 0;
+
+       beacon_ies = kmalloc(IEEE80211_MAX_DATA_LEN, GFP_KERNEL);
+
+       if (unlikely(!beacon_ies))
+               return -ENOMEM;
+
+       beacon_ies_len = qtnf_get_beacon_ie(info, beacon_ies);
+
+       if (unlikely(beacon_ies_len < 0)) {
+               ret = beacon_ies_len;
+               goto out;
+       }
+
+       ret = qtnf_cmd_send_mgmt_set_appie(vif, QLINK_MGMT_FRAME_BEACON,
+                                          beacon_ies, beacon_ies_len);
+
+       if (ret)
+               goto out;
+
+       if (!info->proberesp_ies || !info->proberesp_ies_len) {
+               ret = qtnf_cmd_send_mgmt_set_appie(vif,
+                                                  QLINK_MGMT_FRAME_PROBE_RESP,
+                                                  NULL, 0);
+       } else if (qtnf_ieee80211_check_ie_buf(info->proberesp_ies,
+                                              info->proberesp_ies_len)) {
+               ret = qtnf_cmd_send_mgmt_set_appie(vif,
+                                                  QLINK_MGMT_FRAME_PROBE_RESP,
+                                                  info->proberesp_ies,
+                                                  info->proberesp_ies_len);
+       } else {
+               pr_err("%s: proberesp_ies is not a valid IE buffer\n",
+                      __func__);
+               ret = -EINVAL;
+       }
+
+       if (ret)
+               goto out;
+
+       if (!info->assocresp_ies || !info->assocresp_ies_len) {
+               ret = qtnf_cmd_send_mgmt_set_appie(vif,
+                                                  QLINK_MGMT_FRAME_ASSOC_RESP,
+                                                  NULL, 0);
+       } else if (qtnf_ieee80211_check_ie_buf(info->assocresp_ies,
+                                              info->assocresp_ies_len)) {
+               ret = qtnf_cmd_send_mgmt_set_appie(vif,
+                                                  QLINK_MGMT_FRAME_ASSOC_RESP,
+                                                  info->assocresp_ies,
+                                                  info->assocresp_ies_len);
+       } else {
+               pr_err("%s: assocresp_ies is not a valid IE buffer\n",
+                      __func__);
+               ret = -EINVAL;
+       }
+
+out:
+       kfree(beacon_ies);
+       return ret;
+}
+
+static int qtnf_change_beacon(struct wiphy *wiphy, struct net_device *dev,
+                             struct cfg80211_beacon_data *info)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+               pr_err("%s: bss not started\n", __func__);
+               return -EFAULT;
+       }
+
+       return qtnf_mgmt_set_appie(vif, info);
+}
+
+static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
+                        struct cfg80211_ap_settings *settings)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+       struct qtnf_bss_config *bss_cfg;
+
+       bss_cfg = &vif->bss_cfg;
+
+       memset(bss_cfg, 0, sizeof(*bss_cfg));
+
+       bss_cfg->bcn_period = settings->beacon_interval;
+       bss_cfg->dtim = settings->dtim_period;
+       bss_cfg->auth_type = settings->auth_type;
+       bss_cfg->privacy = settings->privacy;
+
+       bss_cfg->ssid_len = settings->ssid_len;
+       memcpy(&bss_cfg->ssid, settings->ssid, bss_cfg->ssid_len);
+
+       memcpy(&bss_cfg->chandef, &settings->chandef,
+              sizeof(struct cfg80211_chan_def));
+       memcpy(&bss_cfg->crypto, &settings->crypto,
+              sizeof(struct cfg80211_crypto_settings));
+
+       if (qtnf_cmd_send_config_ap(vif)) {
+               pr_err("failed to download AP configuration\n");
+               return -EFAULT;
+       }
+
+       if (!(vif->bss_status & QTNF_STATE_AP_CONFIG)) {
+               pr_err("failed to configure AP settings in FW\n");
+               return -EFAULT;
+       }
+
+       /* update beacon extra IEs */
+       if (qtnf_mgmt_set_appie(vif, &settings->beacon)) {
+               pr_err("failed to setup mgmt frames IEs in FW\n");
+               return -EFAULT;
+       }
+
+       if (qtnf_cmd_send_start_ap(vif)) {
+               pr_err("failed to issue start AP command\n");
+               return -EFAULT;
+       }
+
+       if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+               pr_err("failed to start AP operations in FW\n");
+               return -EFAULT;
+       }
+
+       return 0;
+}
+
+static int qtnf_stop_ap(struct wiphy *wiphy, struct net_device *dev)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       if (qtnf_cmd_send_stop_ap(vif)) {
+               pr_err("failed to stop AP operation in FW\n");
+               vif->bss_status &= ~QTNF_STATE_AP_START;
+               vif->bss_status &= ~QTNF_STATE_AP_CONFIG;
+
+               netif_carrier_off(vif->netdev);
+               return -EFAULT;
+       }
+       return 0;
+}
+
+static int qtnf_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+       struct qtnf_wmac *mac = wiphy_priv(wiphy);
+       struct qtnf_vif *vif;
+       int ret;
+
+       vif = qtnf_get_base_vif(mac);
+       if (!vif) {
+               pr_err("core_attach: could not get valid vif pointer\n");
+               return -EFAULT;
+       }
+
+       if (changed & (WIPHY_PARAM_RETRY_LONG | WIPHY_PARAM_RETRY_SHORT)) {
+               pr_err("device doesn't support modifing retry parameters\n");
+               return -EOPNOTSUPP;
+       }
+
+       ret = qtnf_cmd_send_update_phy_params(mac, QTNF_HOSTCMD_ACTION_SET,
+                                             changed);
+
+       if (ret)
+               pr_warn("failed to configure phy thresholds\n");
+
+       return ret;
+}
+
+static void
+qtnf_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
+                        u16 frame_type, bool reg)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(wdev->netdev);
+       u16 mgmt_type;
+       u16 new_mask;
+       u16 qlink_frame_type = 0;
+
+       mgmt_type = (frame_type & IEEE80211_FCTL_STYPE) >> 4;
+
+       if (reg)
+               new_mask = vif->mgmt_frames_bitmask | BIT(mgmt_type);
+       else
+               new_mask = vif->mgmt_frames_bitmask & ~BIT(mgmt_type);
+
+       if (new_mask == vif->mgmt_frames_bitmask)
+               return;
+
+       switch (frame_type & IEEE80211_FCTL_STYPE) {
+       case IEEE80211_STYPE_PROBE_REQ:
+               qlink_frame_type = QLINK_MGMT_FRAME_PROBE_REQ;
+               break;
+       case IEEE80211_STYPE_ACTION:
+               qlink_frame_type = QLINK_MGMT_FRAME_ACTION;
+               break;
+       default:
+               pr_warn("%s: unsupported frame type: %X\n", __func__,
+                       (frame_type & IEEE80211_FCTL_STYPE) >> 4);
+               return;
+       }
+
+       if (qtnf_cmd_send_register_mgmt(vif, qlink_frame_type, reg)) {
+               pr_warn("%s: failed to %sregistered mgmt frame type 0x%x\n",
+                       __func__, reg ? "" : "un", frame_type);
+               return;
+       }
+
+       vif->mgmt_frames_bitmask = new_mask;
+       pr_info("%s: %sregistered mgmt frame type 0x%x\n", __func__,
+               reg ? "" : "un", frame_type);
+}
+
+static int
+qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
+            struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(wdev->netdev);
+       const struct ieee80211_mgmt *mgmt_frame = (void *)params->buf;
+       u32 short_cookie = prandom_u32();
+       u16 flags = 0;
+
+       *cookie = short_cookie;
+
+       if (params->offchan)
+               flags |= QLINK_MGMT_FRAME_TX_FLAG_OFFCHAN;
+
+       if (params->no_cck)
+               flags |= QLINK_MGMT_FRAME_TX_FLAG_NO_CCK;
+
+       if (params->dont_wait_for_ack)
+               flags |= QLINK_MGMT_FRAME_TX_FLAG_ACK_NOWAIT;
+
+       pr_debug("%s: %s freq:%u; FC:%.4X; DA:%pM; len:%zu; C:%.8X; FL:%.4X\n",
+                __func__, wdev->netdev->name, params->chan->center_freq,
+                le16_to_cpu(mgmt_frame->frame_control), mgmt_frame->da,
+                params->len, short_cookie, flags);
+
+       return qtnf_cmd_send_mgmt_frame(vif, short_cookie, flags,
+                                       params->chan->center_freq,
+                                       params->buf, params->len);
+}
+
+static int
+qtnf_get_station(struct wiphy *wiphy, struct net_device *dev,
+                const u8 *mac, struct station_info *sinfo)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       return qtnf_cmd_get_sta_info(vif, mac, sinfo);
+}
+
+static int
+qtnf_dump_station(struct wiphy *wiphy, struct net_device *dev,
+                 int idx, u8 *mac, struct station_info *sinfo)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+       const struct qtnf_sta_node *sta_node;
+       int ret;
+
+       sta_node = qtnf_sta_list_lookup_index(&vif->sta_list, idx);
+
+       if (unlikely(!sta_node))
+               return -ENOENT;
+
+       ether_addr_copy(mac, sta_node->mac_addr);
+
+       ret = qtnf_cmd_get_sta_info(vif, sta_node->mac_addr, sinfo);
+
+       if (unlikely(ret == -ENOENT)) {
+               sinfo->filled = 0;
+               ret = 0;
+       }
+
+       return ret;
+}
+
+static int qtnf_add_key(struct wiphy *wiphy, struct net_device *dev,
+                       u8 key_index, bool pairwise, const u8 *mac_addr,
+                       struct key_params *params)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       pr_info("QTNF: %s cipher=%x, idx=%u, pairwise=%u\n", __func__,
+               params->cipher, key_index, pairwise);
+       if (qtnf_cmd_send_add_key(vif, key_index, pairwise, mac_addr,
+                                 params)) {
+               pr_err("QTNF: failed to add key\n");
+               return -EFAULT;
+       }
+       return 0;
+}
+
+static int qtnf_del_key(struct wiphy *wiphy, struct net_device *dev,
+                       u8 key_index, bool pairwise, const u8 *mac_addr)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       pr_info("QTNF: %s idx=%u, pairwise=%u\n", __func__, key_index,
+               pairwise);
+       if (qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr)) {
+               pr_err("QTNF: failed to delete key\n");
+               return -EFAULT;
+       }
+       return 0;
+}
+
+static int qtnf_set_default_key(struct wiphy *wiphy, struct net_device *dev,
+                               u8 key_index, bool unicast, bool multicast)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       pr_info("QTNF: %s idx=%u, unicast=%u, multicast=%u\n", __func__,
+               key_index, unicast, multicast);
+       if (qtnf_cmd_send_set_default_key(vif, key_index, unicast,
+                                         multicast)) {
+               pr_err("QTNF: failed to set default key\n");
+               return -EFAULT;
+       }
+       return 0;
+}
+
+static int
+qtnf_set_default_mgmt_key(struct wiphy *wiphy, struct net_device *dev,
+                         u8 key_index)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       pr_info("QTNF: %s idx=%u\n", __func__, key_index);
+       if (qtnf_cmd_send_set_default_mgmt_key(vif, key_index)) {
+               pr_err("QTNF: failed to set default mgmt key\n");
+               return -EFAULT;
+       }
+       return 0;
+}
+
+static int
+qtnf_change_station(struct wiphy *wiphy, struct net_device *dev,
+                   const u8 *mac, struct station_parameters *params)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       if (qtnf_cmd_send_change_sta(vif, mac, params)) {
+               pr_err("QTNF: failed to change STA\n");
+               return -EFAULT;
+       }
+       return 0;
+}
+
+static int
+qtnf_del_station(struct wiphy *wiphy, struct net_device *dev,
+                struct station_del_parameters *params)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+       if (params->mac &&
+           (vif->wdev.iftype == NL80211_IFTYPE_AP) &&
+           !is_broadcast_ether_addr(params->mac) &&
+           !qtnf_sta_list_lookup(&vif->sta_list, params->mac))
+               return 0;
+       if (qtnf_cmd_send_del_sta(vif, params)) {
+               pr_err("QTNF: failed to delete STA\n");
+               return -EFAULT;
+       }
+       return 0;
+}
+
+static int
+qtnf_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
+{
+       struct qtnf_wmac *mac = wiphy_priv(wiphy);
+
+       mac->scan_req = request;
+
+       if (qtnf_cmd_send_scan(mac)) {
+               pr_err("QTNF: failed to start scan\n");
+               return -EFAULT;
+       }
+       return 0;
+}
+
+static int
+qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
+            struct cfg80211_connect_params *sme)
+{
+       struct qtnf_vif *vif;
+       struct qtnf_bss_config *bss_cfg;
+
+       vif = qtnf_netdev_get_priv(dev);
+       if (!vif) {
+               pr_err("core_attach: could not get valid vif pointer\n");
+               return -EFAULT;
+       }
+       if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
+               pr_err("can't connect when not in STA mode\n");
+               return -EOPNOTSUPP;
+       }
+
+       if (vif->sta_state != QTNF_STA_DISCONNECTED)
+               return -EBUSY;
+
+       bss_cfg = &vif->bss_cfg;
+       memset(bss_cfg, 0, sizeof(*bss_cfg));
+
+       bss_cfg->ssid_len = sme->ssid_len;
+       memcpy(&bss_cfg->ssid, sme->ssid, bss_cfg->ssid_len);
+       bss_cfg->chandef.chan = sme->channel;
+       bss_cfg->auth_type = sme->auth_type;
+       bss_cfg->privacy = sme->privacy;
+       bss_cfg->mfp = sme->mfp;
+       if ((sme->bg_scan_period > 0) &&
+           (sme->bg_scan_period <= QTNF_MAX_BG_SCAN_PERIOD))
+               bss_cfg->bg_scan_period = sme->bg_scan_period;
+       else if (sme->bg_scan_period == -1)
+               bss_cfg->bg_scan_period = QTNF_DEFAULT_BG_SCAN_PERIOD;
+       else
+               bss_cfg->bg_scan_period = 0; /* disabled */
+       bss_cfg->connect_flags = 0;
+       if (sme->flags & ASSOC_REQ_DISABLE_HT)
+               bss_cfg->connect_flags |= QLINK_STA_CONNECT_DISABLE_HT;
+       if (sme->flags & ASSOC_REQ_DISABLE_VHT)
+               bss_cfg->connect_flags |= QLINK_STA_CONNECT_DISABLE_VHT;
+       if (sme->flags & ASSOC_REQ_USE_RRM)
+               bss_cfg->connect_flags |= QLINK_STA_CONNECT_USE_RRM;
+       memcpy(&bss_cfg->crypto, &sme->crypto, sizeof(bss_cfg->crypto));
+       if (sme->bssid)
+               ether_addr_copy(bss_cfg->bssid, sme->bssid);
+       else
+               eth_zero_addr(bss_cfg->bssid);
+
+       if (qtnf_cmd_send_connect(vif, sme)) {
+               pr_err("QTNF: failed to connect\n");
+               return -EFAULT;
+       }
+
+       vif->sta_state = QTNF_STA_CONNECTING;
+       return 0;
+}
+
+static int
+qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
+               u16 reason_code)
+{
+       struct qtnf_wmac *mac = wiphy_priv(wiphy);
+       struct qtnf_vif *vif;
+
+       vif = qtnf_get_base_vif(mac);
+       if (!vif) {
+               pr_err("core_attach: could not get valid vif pointer\n");
+               return -EFAULT;
+       }
+
+       if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
+               pr_err("can't disconnect when not in STA mode\n");
+               return -EOPNOTSUPP;
+       }
+
+       if (vif->sta_state == QTNF_STA_DISCONNECTED)
+               return 0;
+
+       if (qtnf_cmd_send_disconnect(vif, reason_code)) {
+               pr_err("QTNF: failed to disconnect\n");
+               return -EFAULT;
+       }
+
+       vif->sta_state = QTNF_STA_DISCONNECTED;
+       return 0;
+}
+
+static struct cfg80211_ops qtn_cfg80211_ops = {
+       .add_virtual_intf       = qtnf_add_virtual_intf,
+       .change_virtual_intf    = qtnf_change_virtual_intf,
+       .del_virtual_intf       = qtnf_del_virtual_intf,
+       .start_ap               = qtnf_start_ap,
+       .change_beacon          = qtnf_change_beacon,
+       .stop_ap                = qtnf_stop_ap,
+       .set_wiphy_params       = qtnf_set_wiphy_params,
+       .mgmt_frame_register    = qtnf_mgmt_frame_register,
+       .mgmt_tx                = qtnf_mgmt_tx,
+       .change_station         = qtnf_change_station,
+       .del_station            = qtnf_del_station,
+       .get_station            = qtnf_get_station,
+       .dump_station           = qtnf_dump_station,
+       .add_key                = qtnf_add_key,
+       .del_key                = qtnf_del_key,
+       .set_default_key        = qtnf_set_default_key,
+       .set_default_mgmt_key   = qtnf_set_default_mgmt_key,
+       .scan                   = qtnf_scan,
+       .connect                = qtnf_connect,
+       .disconnect             = qtnf_disconnect
+};
+
+static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy,
+                                      struct regulatory_request *req)
+{
+       struct qtnf_wmac *mac = wiphy_priv(wiphy);
+       struct qtnf_bus *bus;
+       struct qtnf_vif *vif;
+       struct qtnf_wmac *chan_mac;
+       int i;
+
+       bus = mac->bus;
+
+       pr_info("%s: initiator=%d, alpha=%c%c, macid=%d\n", __func__,
+               req->initiator, req->alpha2[0], req->alpha2[1], mac->macid);
+
+       vif = qtnf_get_base_vif(mac);
+       if (!vif) {
+               pr_err("%s: could not get valid vif pointer\n", __func__);
+               return;
+       }
+       /* ignore non-ISO3166 country codes */
+       for (i = 0; i < sizeof(req->alpha2); i++) {
+               if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
+                       pr_err("not a ISO3166 code\n");
+                       return;
+               }
+       }
+       if (!strncasecmp(req->alpha2, bus->hw_info.country_code,
+                        sizeof(req->alpha2))) {
+               pr_warn("unchanged country code\n");
+               return;
+       }
+
+       if (qtnf_cmd_send_regulatory_config(mac, QTNF_HOSTCMD_ACTION_SET,
+                                           req->alpha2)) {
+               pr_err("failed to download regulatory configuration\n");
+               return;
+       }
+
+       for (i = 0; i < bus->hw_info.num_mac; i++) {
+               chan_mac = bus->mac[i];
+               if (!chan_mac || !chan_mac->mac_started)
+                       continue;
+               if (!(bus->hw_info.mac_bitmap & BIT(i)))
+                       continue;
+               if (qtnf_cmd_get_mac_chan_info(chan_mac)) {
+                       pr_err("reg_notifier: could not get channel information for mac%d\n",
+                              chan_mac->macid);
+                       pr_err("cannot continue without valid channel information from EP");
+                       qtnf_core_detach(bus);
+                       return;
+               }
+       }
+}
+
+static void
+qtnf_setup_htvht_caps(struct qtnf_wmac *mac, struct wiphy *wiphy)
+{
+       struct ieee80211_supported_band *band;
+       struct ieee80211_sta_ht_cap *ht_cap;
+       struct ieee80211_sta_vht_cap *vht_cap;
+       int i;
+
+       for (i = 0; i <= NL80211_BAND_5GHZ; i++) {
+               band = wiphy->bands[i];
+               if (!band)
+                       continue;
+
+               ht_cap = &band->ht_cap;
+               ht_cap->ht_supported = true;
+               memcpy(&ht_cap->cap, &mac->macinfo.ht_cap.cap_info,
+                      sizeof(u16));
+               ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+               ht_cap->ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
+               memcpy(&ht_cap->mcs, &mac->macinfo.ht_cap.mcs,
+                      sizeof(ht_cap->mcs));
+
+               if (mac->macinfo.phymode & QLINK_PHYMODE_AC) {
+                       vht_cap = &band->vht_cap;
+                       vht_cap->vht_supported = true;
+                       memcpy(&vht_cap->cap,
+                              &mac->macinfo.vht_cap.vht_cap_info, sizeof(u32));
+                       /* Update MCS support for VHT */
+                       memcpy(&vht_cap->vht_mcs,
+                              &mac->macinfo.vht_cap.supp_mcs,
+                              sizeof(struct ieee80211_vht_mcs_info));
+               }
+       }
+}
+
+struct wiphy *qtnf_allocate_wiphy(struct qtnf_bus *bus)
+{
+       struct wiphy *wiphy;
+
+       wiphy = wiphy_new(&qtn_cfg80211_ops, sizeof(struct qtnf_wmac));
+       if (!wiphy) {
+               pr_err("could not create new wiphy\n");
+               return NULL;
+       }
+
+       set_wiphy_dev(wiphy, bus->dev);
+
+       return wiphy;
+}
+
+static int qtnf_wiphy_setup_if_comb(struct wiphy *wiphy,
+                                   struct ieee80211_iface_combination *if_comb,
+                                   const struct qtnf_mac_info *mac_info)
+{
+       size_t max_interfaces = 0;
+       u16 interface_modes = 0;
+       size_t i;
+
+       if (unlikely(!mac_info->limits || !mac_info->n_limits)) {
+               pr_err("%s: no interface types supported\n", __func__);
+               return -ENOENT;
+       }
+
+       if_comb->limits = mac_info->limits;
+       if_comb->n_limits = mac_info->n_limits;
+
+       for (i = 0; i < mac_info->n_limits; i++) {
+               max_interfaces += mac_info->limits[i].max;
+               interface_modes |= mac_info->limits[i].types;
+       }
+
+       if_comb->num_different_channels = 1;
+       if_comb->beacon_int_infra_match = true;
+       if_comb->max_interfaces = max_interfaces;
+       if_comb->radar_detect_widths = mac_info->radar_detect_widths;
+       wiphy->interface_modes = interface_modes;
+
+       pr_info("%s: MAX_IF: %zu; MODES: %.4X; RADAR WIDTHS: %.2X\n", __func__,
+               max_interfaces, interface_modes, if_comb->radar_detect_widths);
+
+       return 0;
+}
+
+int qtnf_register_wiphy(struct qtnf_bus *bus, struct qtnf_wmac *mac)
+{
+       struct wiphy *wiphy = priv_to_wiphy(mac);
+       struct ieee80211_iface_combination *iface_comb = NULL;
+       int ret;
+
+       if (!wiphy) {
+               pr_err("%s:invalid wiphy pointer\n", __func__);
+               return -EFAULT;
+       }
+
+       if (!(mac->macinfo.phymode & (QLINK_PHYMODE_BGN | QLINK_PHYMODE_AN))) {
+               pr_err("%s:invalid phymode reported by FW\n", __func__);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       iface_comb = kzalloc(sizeof(*iface_comb), GFP_KERNEL);
+       if (!iface_comb) {
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       ret = qtnf_wiphy_setup_if_comb(wiphy, iface_comb, &mac->macinfo);
+       if (ret)
+               goto out;
+
+       pr_info("macid=%d, phymode=%#x\n", mac->macid, mac->macinfo.phymode);
+       if (mac->macinfo.phymode & QLINK_PHYMODE_BGN) {
+               if (!(bus->hw_info.hw_capab & QLINK_HW_SUPPORTS_REG_UPDATE)) {
+                       /* This means driver should use channel info from EP */
+                       qtnf_band_2ghz.n_channels = mac->macinfo.n_channels;
+                       qtnf_band_2ghz.channels = mac->macinfo.channels;
+               }
+               wiphy->bands[NL80211_BAND_2GHZ] = &qtnf_band_2ghz;
+       }
+       if (mac->macinfo.phymode & QLINK_PHYMODE_AN) {
+               if (!(bus->hw_info.hw_capab & QLINK_HW_SUPPORTS_REG_UPDATE)) {
+                       /* This means driver should use channel info from EP */
+                       qtnf_band_5ghz.n_channels = mac->macinfo.n_channels;
+                       qtnf_band_5ghz.channels = mac->macinfo.channels;
+               }
+               wiphy->bands[NL80211_BAND_5GHZ] = &qtnf_band_5ghz;
+       }
+       qtnf_setup_htvht_caps(mac, wiphy);
+
+       wiphy->frag_threshold = mac->macinfo.frag_thr;
+       wiphy->rts_threshold = mac->macinfo.rts_thr;
+       wiphy->retry_short = mac->macinfo.sretry_limit;
+       wiphy->retry_long = mac->macinfo.lretry_limit;
+       wiphy->coverage_class = mac->macinfo.coverage_class;
+
+       wiphy->max_scan_ssids = QTNF_MAX_SSID_LIST_LENGTH;
+       wiphy->max_scan_ie_len = QTNF_MAX_VSIE_LEN;
+       wiphy->mgmt_stypes = qtnf_mgmt_stypes;
+       wiphy->max_remain_on_channel_duration = 5000;
+
+       wiphy->iface_combinations = iface_comb;
+       wiphy->n_iface_combinations = 1;
+
+       /* Initialize cipher suits */
+       wiphy->cipher_suites = qtnf_cipher_suites;
+       wiphy->n_cipher_suites = ARRAY_SIZE(qtnf_cipher_suites);
+       wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+       wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
+                       WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
+                       WIPHY_FLAG_AP_UAPSD;
+
+       wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+                                   NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
+
+       wiphy->available_antennas_tx = mac->macinfo.num_tx_chain;
+       wiphy->available_antennas_rx = mac->macinfo.num_rx_chain;
+
+       wiphy->max_ap_assoc_sta = mac->macinfo.max_ap_assoc_sta;
+
+       ether_addr_copy(wiphy->perm_addr, mac->macaddr);
+
+       if (bus->hw_info.hw_capab & QLINK_HW_SUPPORTS_REG_UPDATE) {
+               pr_debug("Device supports REG_UPDATE\n");
+               wiphy->reg_notifier = qtnf_cfg80211_reg_notifier;
+               pr_debug("Hint regulatory about EP region:%c%c\n",
+                        bus->hw_info.country_code[0],
+                        bus->hw_info.country_code[1]);
+               regulatory_hint(wiphy, bus->hw_info.country_code);
+       } else {
+               pr_debug("Device doesn't support REG_UPDATE\n");
+               wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
+       }
+
+       pr_debug("Registering regulatory for WMAC %d\n", mac->macid);
+       ret = wiphy_register(wiphy);
+
+out:
+       if (ret < 0) {
+               pr_err("could not register wiphy\n");
+               kfree(iface_comb);
+               return ret;
+       }
+
+       return 0;
+}
+
+void qtnf_netdev_updown(struct net_device *ndev, bool up)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+
+       if (qtnf_cmd_send_updown_intf(vif, up))
+               pr_err("QTNF: failed to send intf up/down event to FW\n");
+}
+
+void qtnf_virtual_intf_cleanup(struct net_device *ndev)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+       struct qtnf_wmac *mac = mac = wiphy_priv(vif->wdev.wiphy);
+
+       if (vif->wdev.iftype == NL80211_IFTYPE_STATION) {
+               switch (vif->sta_state) {
+               case QTNF_STA_DISCONNECTED:
+                       break;
+               case QTNF_STA_CONNECTING:
+                       cfg80211_connect_result(vif->netdev,
+                                               vif->bss_cfg.bssid, NULL, 0,
+                                               NULL, 0,
+                                               WLAN_STATUS_UNSPECIFIED_FAILURE,
+                                               GFP_KERNEL);
+                       qtnf_disconnect(vif->wdev.wiphy, ndev,
+                                       WLAN_REASON_DEAUTH_LEAVING);
+                       break;
+               case QTNF_STA_CONNECTED:
+                       cfg80211_disconnected(vif->netdev,
+                                             WLAN_REASON_DEAUTH_LEAVING,
+                                             NULL, 0, 1, GFP_KERNEL);
+                       qtnf_disconnect(vif->wdev.wiphy, ndev,
+                                       WLAN_REASON_DEAUTH_LEAVING);
+                       break;
+               }
+               vif->sta_state = QTNF_STA_DISCONNECTED;
+               if (mac->scan_req) {
+                       cfg80211_scan_done(mac->scan_req, 1);
+                       mac->scan_req = NULL;
+               }
+       }
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
new file mode 100644
index 0000000..51f4a73
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
@@ -0,0 +1,34 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_CFG80211_H_
+#define _QTN_FMAC_CFG80211_H_
+
+#include <net/cfg80211.h>
+
+#include "core.h"
+
+/* */
+
+int qtnf_register_wiphy(struct qtnf_bus *bus, struct qtnf_wmac *mac);
+int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev);
+struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
+                                          const char *name,
+                                          unsigned char name_assign_type,
+                                          enum nl80211_iftype type, u32 *flags,
+                                          struct vif_params *params);
+
+#endif /* _QTN_FMAC_CFG80211_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
new file mode 100644
index 0000000..382d156
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -0,0 +1,1927 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include <linux/types.h>
+#include <linux/skbuff.h>
+
+#include "cfg80211.h"
+#include "core.h"
+#include "qlink.h"
+#include "qlink_util.h"
+#include "bus.h"
+#include "commands.h"
+
+static int qtnf_cmd_check_reply_header(const struct qlink_host_cmd *resp,
+                                      u16 cmd_id, u8 mac_id, u8 vif_id)
+{
+       if (unlikely(le16_to_cpu(resp->cmd_id) != cmd_id)) {
+               pr_warn("%s: invalid response cmd_id: 0x%.4X != 0x%.4X\n",
+                       __func__, le16_to_cpu(resp->cmd_id), cmd_id);
+               return -EINVAL;
+       }
+
+       if (unlikely(resp->macid != mac_id)) {
+               pr_warn("%s: invalid response mac_id: 0x%.2X != 0x%.2X\n",
+                       __func__, resp->macid, mac_id);
+               return -EINVAL;
+       }
+
+       if (unlikely(resp->vifid != vif_id)) {
+               pr_warn("%s: invalid response vif_id: 0x%.2X != 0x%.2X\n",
+                       __func__, resp->vifid, vif_id);
+               return -EINVAL;
+       }
+
+       return 0;
+}
+
+static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
+                                   struct sk_buff *cmd_skb,
+                                   struct sk_buff **response_skb,
+                                   u16 *result_code,
+                                   const u8 **payload, size_t *payload_size)
+{
+       struct qlink_host_cmd *cmd;
+       const struct qlink_host_cmd *resp;
+       struct sk_buff *resp_skb = NULL;
+       u16 cmd_id;
+       u8 mac_id, vif_id;
+       int ret;
+
+       /* If you pass payload pointer then you also should pass response_skb to
+        * transfer the ownership of response skb buffer (caller should consume
+        * response_skb by itself later).
+        */
+       WARN_ON(!response_skb && payload);
+
+       if (unlikely(!cmd_skb)) {
+               pr_err("%s: no command skb\n", __func__);
+               return -EFAULT;
+       }
+
+       if (unlikely(!cmd_skb->data) || unlikely(cmd_skb->len < sizeof(*cmd))) {
+               pr_err("%s: invalid command skb data\n", __func__);
+               kfree_skb(cmd_skb);
+               return -EFAULT;
+       }
+
+       cmd = (struct qlink_host_cmd *)cmd_skb->data;
+       cmd_id = le16_to_cpu(cmd->cmd_id);
+       mac_id = cmd->macid;
+       vif_id = cmd->vifid;
+       cmd->header.len = cpu_to_le16(cmd_skb->len);
+
+       if (unlikely(bus->fw_state != QTNF_FW_STATE_ACTIVE &&
+                    le16_to_cpu(cmd->cmd_id) != QLINK_HOSTCMD_FW_INIT)) {
+               pr_warn("%s: drop cmd 0x%.4X in fw state %d\n", __func__,
+                       le16_to_cpu(cmd->cmd_id), bus->fw_state);
+               return -ENODEV;
+       }
+
+       pr_debug("%s: cmd 0x%.4X mac 0x%.2X vif 0x%.2X\n", __func__,
+                le16_to_cpu(cmd->cmd_id), cmd->macid, cmd->vifid);
+
+       ret = qtnf_trans_send_cmd_with_resp(bus, cmd_skb, &resp_skb);
+
+       if (unlikely(ret))
+               goto out;
+
+       resp = (const struct qlink_host_cmd *)resp_skb->data;
+       ret = qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (likely(result_code))
+               *result_code = le16_to_cpu(resp->result);
+
+       if (response_skb) {
+               if (likely(payload))
+                       *payload = resp->payload;
+
+               if (likely(payload_size))
+                       *payload_size = le16_to_cpu(resp->header.len) -
+                                       QTNF_DEF_CMDHDR_SZ;
+       }
+
+out:
+       if (response_skb)
+               *response_skb = resp_skb;
+       else
+               consume_skb(resp_skb);
+
+       return ret;
+}
+
+static struct sk_buff *qtnf_cmd_alloc_new_cmdskb(u8 macid, u8 vifid, u16 cmd_no)
+{
+       struct qlink_host_cmd *cmd;
+       struct sk_buff *cmd_skb;
+
+       cmd_skb = __dev_alloc_skb(sizeof(struct qlink_host_cmd) +
+                                 QTNF_MAX_CMD_BUF_SIZE, GFP_KERNEL);
+       if (unlikely(!cmd_skb)) {
+               pr_err("%s: failed to allocate cmd_skb\n", __func__);
+               return NULL;
+       }
+
+       memset(skb_put(cmd_skb, sizeof(*cmd)), 0, sizeof(*cmd));
+
+       cmd = (void *)cmd_skb->data;
+       cmd->header.len = cpu_to_le16(cmd_skb->len);
+       cmd->header.type = cpu_to_le16(QLINK_MSG_TYPE_CMD);
+       cmd->cmd_id = cpu_to_le16(cmd_no);
+       cmd->macid = macid;
+       cmd->vifid = vifid;
+
+       return cmd_skb;
+}
+
+int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
+{
+       struct sk_buff *cmd_skb;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_START_AP);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       vif->bss_status |= QTNF_STATE_AP_START;
+       netif_carrier_on(vif->netdev);
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *mac, u16 action,
+                                   const char *alpha2)
+{
+       struct sk_buff *cmd_skb;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       if ((action == QTNF_HOSTCMD_ACTION_SET) && !alpha2)
+               return -EINVAL;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
+                                           QLINK_HOSTCMD_REG_REGION);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_cmd_skb_put_action(cmd_skb, action);
+       qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_COUNTRY, alpha2,
+                                QTNF_MAX_ALPHA_LEN);
+
+       ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       memcpy(mac->bus->hw_info.country_code, alpha2,
+              sizeof(mac->bus->hw_info.country_code));
+out:
+       return ret;
+}
+
+int qtnf_cmd_send_config_ap(struct qtnf_vif *vif)
+{
+       struct sk_buff *cmd_skb;
+       struct qtnf_bss_config *bss_cfg = &vif->bss_cfg;
+       struct qlink_auth_encr aen;
+       u8 channel;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+       int i;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_CONFIG_AP);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       channel = ieee80211_frequency_to_channel(
+                                           bss_cfg->chandef.chan->center_freq);
+
+       qtnf_cmd_skb_put_action(cmd_skb, QTNF_HOSTCMD_ACTION_SET);
+       qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, bss_cfg->ssid,
+                                bss_cfg->ssid_len);
+       qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_BCN_PERIOD,
+                                bss_cfg->bcn_period);
+       qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_DTIM, bss_cfg->dtim);
+       qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_CHANNEL_CFG, channel);
+
+       memset(&aen, 0, sizeof(aen));
+       aen.auth_type = bss_cfg->auth_type;
+       aen.privacy = !!bss_cfg->privacy;
+       aen.mfp = bss_cfg->mfp;
+       aen.wpa_versions = cpu_to_le32(bss_cfg->crypto.wpa_versions);
+       aen.cipher_group = cpu_to_le32(bss_cfg->crypto.cipher_group);
+       aen.n_ciphers_pairwise = cpu_to_le32(
+                                       bss_cfg->crypto.n_ciphers_pairwise);
+       for (i = 0; i < QLINK_MAX_NR_CIPHER_SUITES; i++)
+               aen.ciphers_pairwise[i] = cpu_to_le32(
+                                       bss_cfg->crypto.ciphers_pairwise[i]);
+       aen.n_akm_suites = cpu_to_le32(
+                                       bss_cfg->crypto.n_akm_suites);
+       for (i = 0; i < QLINK_MAX_NR_AKM_SUITES; i++)
+               aen.akm_suites[i] = cpu_to_le32(
+                                       bss_cfg->crypto.akm_suites[i]);
+       aen.control_port = bss_cfg->crypto.control_port;
+       aen.control_port_no_encrypt =
+                       bss_cfg->crypto.control_port_no_encrypt;
+       aen.control_port_ethertype = cpu_to_le16(be16_to_cpu(
+                               bss_cfg->crypto.control_port_ethertype));
+
+       qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_CRYPTO, (u8 *)&aen,
+                                sizeof(aen));
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       vif->bss_status |= QTNF_STATE_AP_CONFIG;
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
+{
+       struct sk_buff *cmd_skb;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_STOP_AP);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       vif->bss_status &= ~QTNF_STATE_AP_START;
+       vif->bss_status &= ~QTNF_STATE_AP_CONFIG;
+
+       netif_carrier_off(vif->netdev);
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool reg)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_mgmt_frame_reg_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_REGISTER_MGMT);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_mgmt_frame_reg_req *)skb_put(cmd_skb, sizeof(*req));
+       req->frame_type = cpu_to_le16(frame_type);
+       req->do_register = reg;
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
+                            u16 freq, const u8 *buf, size_t len)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_mgmt_frame_tx_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       if (sizeof(*req) + len > QTNF_MAX_CMD_BUF_SIZE) {
+               pr_warn("%s: frame is too big: %zu\n", __func__, len);
+               return -E2BIG;
+       }
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_SEND_MGMT_FRAME);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_mgmt_frame_tx_req *)skb_put(cmd_skb,
+                                                       sizeof(*req) + len);
+       req->cookie = cpu_to_le32(cookie);
+       req->freq = cpu_to_le16(freq);
+       req->flags = cpu_to_le16(flags);
+
+       memcpy(req->frame_data, buf, len);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
+                                const u8 *buf, size_t len)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_mgmt_append_ie_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       if (sizeof(*req) + len > QTNF_MAX_CMD_BUF_SIZE) {
+               pr_warn("%s: frame is too big: %zu\n", __func__, len);
+               return -E2BIG;
+       }
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_MGMT_SET_APPIE);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_mgmt_append_ie_req *)skb_put(cmd_skb,
+                                                        sizeof(*req) + len);
+       req->type = frame_type;
+       req->flags = 0;
+
+       /* if len == 0 then IE buf for specified frame type
+        * should be cleared on EP.
+        */
+       if (len && buf)
+               memcpy(req->frame_data, buf, len);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+static void
+qtnf_parse_basic_sta_counters(struct station_info *sinfo, void *ptr)
+{
+       const struct qlink_sta_stat_basic_counters *counters = ptr;
+
+       sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES) |
+                        BIT(NL80211_STA_INFO_TX_BYTES);
+       sinfo->rx_bytes = qtnf_get_unaligned_le64(&counters->rx_bytes);
+       sinfo->tx_bytes = qtnf_get_unaligned_le64(&counters->tx_bytes);
+
+       sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS) |
+                        BIT(NL80211_STA_INFO_TX_PACKETS) |
+                        BIT(NL80211_STA_INFO_BEACON_RX);
+       sinfo->rx_packets = qtnf_get_unaligned_le32(&counters->rx_packets);
+       sinfo->tx_packets = qtnf_get_unaligned_le32(&counters->tx_packets);
+       sinfo->rx_beacon = qtnf_get_unaligned_le64(&counters->rx_beacons);
+
+       sinfo->filled |= BIT(NL80211_STA_INFO_RX_DROP_MISC) |
+                        BIT(NL80211_STA_INFO_TX_FAILED);
+       sinfo->rx_dropped_misc = qtnf_get_unaligned_le32(&counters->rx_dropped);
+       sinfo->tx_failed = qtnf_get_unaligned_le32(&counters->tx_failed);
+}
+
+static void
+qtnf_sta_info_parse_rate(struct rate_info *rate_dst,
+                        const struct  qlink_sta_info_rate *rate_src)
+{
+       rate_dst->legacy = qtnf_get_unaligned_le16(&rate_src->rate) * 10;
+
+       rate_dst->mcs = rate_src->mcs;
+       rate_dst->nss = rate_src->nss;
+       rate_dst->flags = 0;
+
+       switch (rate_src->bw) {
+       case QLINK_STA_INFO_RATE_BW_5:
+               rate_dst->bw = RATE_INFO_BW_5;
+               break;
+       case QLINK_STA_INFO_RATE_BW_10:
+               rate_dst->bw = RATE_INFO_BW_10;
+               break;
+       case QLINK_STA_INFO_RATE_BW_20:
+               rate_dst->bw = RATE_INFO_BW_20;
+               break;
+       case QLINK_STA_INFO_RATE_BW_40:
+               rate_dst->bw = RATE_INFO_BW_40;
+               break;
+       case QLINK_STA_INFO_RATE_BW_80:
+               rate_dst->bw = RATE_INFO_BW_80;
+               break;
+       case QLINK_STA_INFO_RATE_BW_160:
+               rate_dst->bw = RATE_INFO_BW_160;
+               break;
+       default:
+               rate_dst->bw = 0;
+               break;
+       }
+
+       if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_HT_MCS)
+               rate_dst->flags |= RATE_INFO_FLAGS_MCS;
+       else if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_VHT_MCS)
+               rate_dst->flags |= RATE_INFO_FLAGS_VHT_MCS;
+}
+
+static void
+qtnf_sta_info_parse_flags(struct nl80211_sta_flag_update *dst,
+                         const struct qlink_sta_info_state *src)
+{
+       u32 mask, value;
+
+       dst->mask = 0;
+       dst->set = 0;
+
+       mask = le32_to_cpu(src->mask);
+       value = le32_to_cpu(src->value);
+
+       if (mask & QLINK_STA_FLAG_AUTHORIZED) {
+               dst->mask |= BIT(NL80211_STA_FLAG_AUTHORIZED);
+               if (value & QLINK_STA_FLAG_AUTHORIZED)
+                       dst->set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
+       }
+
+       if (mask & QLINK_STA_FLAG_SHORT_PREAMBLE) {
+               dst->mask |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
+               if (value & QLINK_STA_FLAG_SHORT_PREAMBLE)
+                       dst->set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
+       }
+
+       if (mask & QLINK_STA_FLAG_WME) {
+               dst->mask |= BIT(NL80211_STA_FLAG_WME);
+               if (value & QLINK_STA_FLAG_WME)
+                       dst->set |= BIT(NL80211_STA_FLAG_WME);
+       }
+
+       if (mask & QLINK_STA_FLAG_MFP) {
+               dst->mask |= BIT(NL80211_STA_FLAG_MFP);
+               if (value & QLINK_STA_FLAG_MFP)
+                       dst->set |= BIT(NL80211_STA_FLAG_MFP);
+       }
+
+       if (mask & QLINK_STA_FLAG_AUTHENTICATED) {
+               dst->mask |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
+               if (value & QLINK_STA_FLAG_AUTHENTICATED)
+                       dst->set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
+       }
+
+       if (mask & QLINK_STA_FLAG_TDLS_PEER) {
+               dst->mask |= BIT(NL80211_STA_FLAG_TDLS_PEER);
+               if (value & QLINK_STA_FLAG_TDLS_PEER)
+                       dst->set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
+       }
+
+       if (mask & QLINK_STA_FLAG_ASSOCIATED) {
+               dst->mask |= BIT(NL80211_STA_FLAG_ASSOCIATED);
+               if (value & QLINK_STA_FLAG_ASSOCIATED)
+                       dst->set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
+       }
+}
+
+static void
+qtnf_sta_info_parse_generic_info(struct station_info *sinfo,
+                                const struct qlink_sta_info_generic *info)
+{
+       sinfo->filled |= BIT(NL80211_STA_INFO_CONNECTED_TIME) |
+                        BIT(NL80211_STA_INFO_INACTIVE_TIME);
+       sinfo->connected_time = qtnf_get_unaligned_le32(&info->connected_time);
+       sinfo->inactive_time = qtnf_get_unaligned_le32(&info->inactive_time);
+
+       sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
+                        BIT(NL80211_STA_INFO_SIGNAL_AVG);
+       sinfo->signal = info->rssi - 120;
+       sinfo->signal_avg = info->rssi_avg - QLINK_RSSI_OFFSET;
+
+       if (info->rx_rate.rate) {
+               sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
+               qtnf_sta_info_parse_rate(&sinfo->rxrate, &info->rx_rate);
+       }
+
+       if (info->tx_rate.rate) {
+               sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+               qtnf_sta_info_parse_rate(&sinfo->txrate, &info->tx_rate);
+       }
+
+       sinfo->filled |= BIT(NL80211_STA_INFO_STA_FLAGS);
+       qtnf_sta_info_parse_flags(&sinfo->sta_flags, &info->state);
+}
+
+static int qtnf_cmd_sta_info_parse(struct station_info *sinfo,
+                                  const u8 *payload, size_t payload_size)
+{
+       const struct qlink_sta_stat_basic_counters *counters;
+       const struct qlink_sta_info_generic *sta_info;
+       u16 tlv_type;
+       u16 tlv_value_len;
+       size_t tlv_full_len;
+       const struct qlink_tlv_hdr *tlv;
+
+       sinfo->filled = 0;
+
+       tlv = (const struct qlink_tlv_hdr *)payload;
+       while (payload_size >= sizeof(struct qlink_tlv_hdr)) {
+               tlv_type = le16_to_cpu(tlv->type);
+               tlv_value_len = le16_to_cpu(tlv->len);
+               tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+               if (tlv_full_len > payload_size) {
+                       pr_warn("%s: malformed TLV 0x%.2X; LEN: %u\n",
+                               __func__, tlv_type, tlv_value_len);
+                       return -EINVAL;
+               }
+               switch (tlv_type) {
+               case QTN_TLV_ID_STA_BASIC_COUNTERS:
+                       if (unlikely(tlv_value_len < sizeof(*counters))) {
+                               pr_err("%s: invalid TLV size %.4X: %u\n",
+                                      __func__, tlv_type, tlv_value_len);
+                               break;
+                       }
+
+                       counters = (void *)tlv->val;
+                       qtnf_parse_basic_sta_counters(sinfo, (void *)counters);
+                       break;
+               case QTN_TLV_ID_STA_GENERIC_INFO:
+                       if (unlikely(tlv_value_len < sizeof(*sta_info)))
+                               break;
+
+                       sta_info = (void *)tlv->val;
+                       qtnf_sta_info_parse_generic_info(sinfo, sta_info);
+                       break;
+               default:
+                       pr_info("%s: unexpected TLV type: %.4X\n",
+                               __func__, tlv_type);
+                       break;
+               }
+               payload_size -= tlv_full_len;
+               tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+       }
+
+       if (payload_size) {
+               pr_warn("%s: malformed IEs buf; bytes left: %zu\n",
+                       __func__, payload_size);
+               return -EINVAL;
+       }
+
+       return 0;
+}
+
+int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
+                         struct station_info *sinfo)
+{
+       struct sk_buff *req_skb, *resp_skb = NULL;
+       struct qlink_sta_info_req *req;
+       const struct qlink_sta_info_res *resp;
+       size_t payload_len = 0;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       req_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_GET_STA_INFO);
+
+       if (unlikely(!req_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_sta_info_req *)skb_put(req_skb, sizeof(*req));
+       ether_addr_copy(req->sta_addr, sta_mac);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, req_skb, &resp_skb,
+                                      &res_code, (const u8 **)&resp,
+                                      &payload_len);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               switch (res_code) {
+               case QLINK_HOSTCMD_RESULT_ENOTFOUND:
+                       pr_info("%s: STA %pM not found\n", __func__, sta_mac);
+                       ret = -ENOENT;
+                       break;
+               default:
+                       pr_err("%s: error returned: %u\n", __func__, res_code);
+                       ret = -EFAULT;
+                       break;
+               }
+               goto out;
+       }
+
+       if (unlikely(payload_len < sizeof(struct qlink_sta_info_res))) {
+               pr_err("%s: too small payload: %zu\n", __func__, payload_len);
+               ret = -EINVAL;
+               goto out;
+       }
+
+       if (unlikely(!ether_addr_equal(sta_mac, resp->sta_addr))) {
+               pr_err("%s: wrong mac in reply: %pM != %pM\n", __func__,
+                      resp->sta_addr, sta_mac);
+               ret = -EINVAL;
+               goto out;
+       }
+
+       ret = qtnf_cmd_sta_info_parse(sinfo, resp->payload,
+                                     payload_len - sizeof(*resp));
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       consume_skb(resp_skb);
+
+       return ret;
+}
+
+static int qtnf_cmd_send_add_change_intf(struct qtnf_vif *vif,
+                                        enum nl80211_iftype iftype,
+                                        u8 *mac_addr,
+                                        enum qlink_host_cmd_type cmd_type)
+{
+       struct sk_buff *cmd_skb, *resp_skb = NULL;
+       struct qlink_intf_info *ifinfo;
+       const struct qlink_intf_info *ql_ifinfo = NULL;
+       size_t response_size = 0;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           cmd_type);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       qtnf_cmd_skb_put_action(cmd_skb, QTNF_HOSTCMD_ACTION_SET);
+
+       ifinfo = (struct qlink_intf_info *)skb_put(cmd_skb, sizeof(*ifinfo));
+
+       switch (iftype) {
+       case NL80211_IFTYPE_AP:
+               ifinfo->if_type = cpu_to_le16(QLINK_IFTYPE_AP);
+               break;
+       case NL80211_IFTYPE_STATION:
+               ifinfo->if_type = cpu_to_le16(QLINK_IFTYPE_STATION);
+               break;
+       default:
+               pr_err("%s: unsupported iftype %d\n", __func__, iftype);
+               ret = -EINVAL;
+               goto out;
+       }
+
+       if (mac_addr)
+               ether_addr_copy(ifinfo->mac_addr, mac_addr);
+       else
+               eth_zero_addr(ifinfo->mac_addr);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, &resp_skb,
+                                      &res_code, (const u8 **)&ql_ifinfo,
+                                      &response_size);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       if (unlikely(response_size < sizeof(*ql_ifinfo))) {
+               pr_warn("%s: invalid response payload size: %zu < %zu\n",
+                       __func__, response_size, sizeof(*ql_ifinfo));
+               ret = -EINVAL;
+               goto out;
+       }
+
+       ether_addr_copy(vif->mac_addr, ql_ifinfo->mac_addr);
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       consume_skb(resp_skb);
+
+       return ret;
+}
+
+int qtnf_cmd_send_add_intf(struct qtnf_vif *vif,
+                          enum nl80211_iftype iftype, u8 *mac_addr)
+{
+       return qtnf_cmd_send_add_change_intf(vif, iftype, mac_addr,
+                       QLINK_HOSTCMD_ADD_INTF);
+}
+
+int qtnf_cmd_send_change_intf_type(struct qtnf_vif *vif,
+                                  enum nl80211_iftype iftype, u8 *mac_addr)
+{
+       return qtnf_cmd_send_add_change_intf(vif, iftype, mac_addr,
+                                            QLINK_HOSTCMD_CHANGE_INTF);
+}
+
+int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_intf_info *ifinfo;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_DEL_INTF);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       qtnf_cmd_skb_put_action(cmd_skb, QTNF_HOSTCMD_ACTION_SET);
+
+       ifinfo = (struct qlink_intf_info *)skb_put(cmd_skb, sizeof(*ifinfo));
+
+       switch (vif->wdev.iftype) {
+       case NL80211_IFTYPE_AP:
+               ifinfo->if_type = cpu_to_le16(QLINK_IFTYPE_AP);
+               break;
+       case NL80211_IFTYPE_STATION:
+               ifinfo->if_type = cpu_to_le16(QLINK_IFTYPE_STATION);
+               break;
+       default:
+               pr_warn("%s: unsupported iftype %d\n", __func__,
+                       vif->wdev.iftype);
+               ret = -EINVAL;
+               goto out;
+       }
+
+       eth_zero_addr(ifinfo->mac_addr);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+static int qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
+                                     const struct qlink_hw_info *hw_info,
+                                     size_t hw_info_size)
+{
+       struct qtnf_hw_info *hwinfo;
+       size_t payload_len;
+       u16 tlv_type;
+       u16 tlv_value_len;
+       size_t tlv_full_len;
+       const struct qlink_tlv_hdr *tlv;
+
+       hwinfo = &bus->hw_info;
+
+       hwinfo->num_mac = hw_info->num_mac;
+       hwinfo->mac_bitmap = hw_info->mac_bitmap;
+       hwinfo->fw_api_ver = le32_to_cpu(hw_info->fw_api_ver);
+       hwinfo->ql_proto_ver = le16_to_cpu(hw_info->ql_proto_ver);
+       memcpy(hwinfo->country_code, hw_info->country_code,
+              sizeof(hwinfo->country_code));
+       pr_info("country-code from EP: %c%c\n", hwinfo->country_code[0],
+               hwinfo->country_code[1]);
+       hwinfo->total_tx_chain = hw_info->total_tx_chain;
+       hwinfo->total_rx_chain = hw_info->total_rx_chain;
+       hwinfo->hw_capab = le32_to_cpu(hw_info->hw_capab);
+
+       pr_info("fw_version = %d, num_mac=%d, mac_bitmap=%#x\n",
+               hwinfo->fw_api_ver, hwinfo->num_mac, hwinfo->mac_bitmap);
+
+       payload_len = hw_info_size - sizeof(*hw_info);
+       tlv = (struct qlink_tlv_hdr *)hw_info->payload;
+       while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+               tlv_type = le16_to_cpu(tlv->type);
+               tlv_value_len = le16_to_cpu(tlv->len);
+               tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+               if (tlv_full_len > payload_len) {
+                       pr_warn("%s: malformed TLV 0x%.2X; LEN: %u\n",
+                               __func__, tlv_type, tlv_value_len);
+                       return -EINVAL;
+               }
+               switch (tlv_type) {
+               default:
+                       pr_err("%s: Unknown TLV type: %#x\n", __func__,
+                              le16_to_cpu(tlv->type));
+                       break;
+               }
+               payload_len -= tlv_full_len;
+               tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+       }
+
+       if (payload_len) {
+               pr_warn("%s: malformed IEs buf; bytes left: %zu\n", __func__,
+                       payload_len);
+               return -EINVAL;
+       }
+
+       return 0;
+}
+
+static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
+                                       const u8 *tlv_buf, size_t tlv_buf_size)
+{
+       struct ieee80211_iface_limit *limits = NULL;
+       const struct qlink_iface_limit *limit_record;
+       size_t record_count = 0, rec = 0;
+       u16 tlv_type, tlv_value_len, mask;
+       struct qlink_iface_comb_num *comb;
+       size_t tlv_full_len;
+       const struct qlink_tlv_hdr *tlv;
+
+       mac->macinfo.n_limits = 0;
+
+       tlv = (const struct qlink_tlv_hdr *)tlv_buf;
+       while (tlv_buf_size >= sizeof(struct qlink_tlv_hdr)) {
+               tlv_type = le16_to_cpu(tlv->type);
+               tlv_value_len = le16_to_cpu(tlv->len);
+               tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+               if (tlv_full_len > tlv_buf_size) {
+                       pr_warn("%s: malformed TLV 0x%.2X; LEN: %u\n",
+                               __func__, tlv_type, tlv_value_len);
+                       return -EINVAL;
+               }
+
+               switch (tlv_type) {
+               case QTN_TLV_ID_NUM_IFACE_COMB:
+                       if (unlikely(tlv_value_len != sizeof(*comb)))
+                               return -EINVAL;
+
+                       comb = (void *)tlv->val;
+                       record_count = le16_to_cpu(comb->iface_comb_num);
+
+                       mac->macinfo.n_limits = record_count;
+                       /* free earlier iface limits memory */
+                       kfree(mac->macinfo.limits);
+                       mac->macinfo.limits =
+                               kzalloc(sizeof(*mac->macinfo.limits) *
+                                       record_count, GFP_KERNEL);
+
+                       if (unlikely(!mac->macinfo.limits))
+                               return -ENOMEM;
+
+                       limits = mac->macinfo.limits;
+                       pr_info("iface limit record count=%zu\n", record_count);
+                       break;
+               case QTN_TLV_ID_IFACE_LIMIT:
+                       if (unlikely(!limits)) {
+                               pr_warn("limits yet not initialized..\n");
+                               return -EINVAL;
+                       }
+                       if (unlikely(tlv_value_len != sizeof(*limit_record))) {
+                               pr_warn("record size mismatch\n");
+                               return -EINVAL;
+                       }
+
+                       limit_record = (void *)tlv->val;
+                       limits[rec].max = le16_to_cpu(limit_record->max_num);
+                       mask = le16_to_cpu(limit_record->type_mask);
+                       limits[rec].types = qlink_iface_type_mask_to_nl(mask);
+                       /* only AP and STA modes are supported */
+                       limits[rec].types &= BIT(NL80211_IFTYPE_AP) |
+                                            BIT(NL80211_IFTYPE_STATION);
+
+                       pr_debug("%s: MAX: %u; TYPES: %.4X\n", __func__,
+                                limits[rec].max, limits[rec].types);
+
+                       if (limits[rec].types)
+                               rec++;
+                       break;
+               default:
+                       break;
+               }
+               tlv_buf_size -= tlv_full_len;
+               tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+       }
+       if (tlv_buf_size) {
+               pr_warn("%s: malformed IEs buf; bytes left: %zu\n", __func__,
+                       tlv_buf_size);
+               return -EINVAL;
+       }
+
+       if (WARN_ON(mac->macinfo.n_limits != rec)) {
+               pr_warn("%s: interface combination count mismatch: reported=%zu, parsed from TLVs=%zu\n",
+                       __func__, mac->macinfo.n_limits, rec);
+               return -1;
+       }
+
+       return 0;
+}
+
+static int
+qtnf_cmd_resp_proc_mac_info(struct qtnf_wmac *mac,
+                           const struct qlink_mac_info *mac_info_packed,
+                           size_t mac_info_size)
+{
+       struct qtnf_mac_info *mac_info;
+       const size_t payload_size = mac_info_size - sizeof(*mac_info_packed);
+       const struct qlink_ht_mcs_info *ht_mcs_info_packed;
+       struct ieee80211_mcs_info *ht_mcs_info;
+       const struct qlink_vht_mcs_info *vht_mcs_info_packed;
+       struct ieee80211_vht_mcs_info *vht_mcs_info;
+       struct qtnf_vif *vif;
+       int ret = 0;
+
+       ht_mcs_info_packed = &mac_info_packed->ht_cap.mcs;
+       vht_mcs_info_packed = &mac_info_packed->vht_cap.supp_mcs;
+       mac_info = &mac->macinfo;
+       ht_mcs_info = &mac_info->ht_cap.mcs;
+       vht_mcs_info = &mac_info->vht_cap.supp_mcs;
+
+       /* Struct copy */
+       mac_info->phymode = le16_to_cpu(mac_info_packed->phymode);
+       memcpy(&mac_info->dev_mac, &mac_info_packed->dev_mac,
+              sizeof(mac_info->dev_mac));
+
+       ether_addr_copy(mac->macaddr, mac_info->dev_mac);
+       vif = qtnf_get_base_vif(mac);
+
+       if (!vif)
+               pr_err("%s: could not get valid base vif\n", __func__);
+
+       if (vif)
+               ether_addr_copy(vif->mac_addr, mac->macaddr);
+
+       mac_info->num_tx_chain = mac_info_packed->num_tx_chain;
+       mac_info->num_rx_chain = mac_info_packed->num_rx_chain;
+
+       mac_info->max_ap_assoc_sta =
+                       le16_to_cpu(mac_info_packed->max_ap_assoc_sta);
+       mac_info->radar_detect_widths =
+                       qlink_chan_width_mask_to_nl(le16_to_cpu(
+                                       mac_info_packed->radar_detect_widths));
+
+       /* HT CAP copy */
+       mac_info->ht_cap.cap_info = mac_info_packed->ht_cap.cap_info;
+       mac_info->ht_cap.ampdu_params_info =
+               mac_info_packed->ht_cap.ampdu_params_info;
+
+       memcpy(&ht_mcs_info->rx_mask, &ht_mcs_info_packed->rx_mask,
+              sizeof(ht_mcs_info->rx_mask));
+       ht_mcs_info->rx_highest = ht_mcs_info_packed->rx_highest;
+       ht_mcs_info->tx_params = ht_mcs_info_packed->tx_params;
+       memcpy(&ht_mcs_info->reserved, &ht_mcs_info_packed->reserved,
+              sizeof(ht_mcs_info->reserved));
+
+       mac_info->ht_cap.extended_ht_cap_info =
+                                  mac_info_packed->ht_cap.extended_ht_cap_info;
+       mac_info->ht_cap.tx_BF_cap_info =
+                                        mac_info_packed->ht_cap.tx_BF_cap_info;
+       mac_info->ht_cap.antenna_selection_info =
+               mac_info_packed->ht_cap.antenna_selection_info;
+
+       /* VHT CAP copy */
+       mac_info->vht_cap.vht_cap_info = mac_info_packed->vht_cap.vht_cap_info;
+       vht_mcs_info->rx_mcs_map = vht_mcs_info_packed->rx_mcs_map;
+       vht_mcs_info->rx_highest = vht_mcs_info_packed->rx_highest;
+       vht_mcs_info->tx_mcs_map = vht_mcs_info_packed->tx_mcs_map;
+       vht_mcs_info->tx_highest = vht_mcs_info_packed->tx_highest;
+
+       ret = qtnf_parse_variable_mac_info(mac, mac_info_packed->payload,
+                                          payload_size);
+
+       return ret;
+}
+
+static int qtnf_cmd_resp_proc_mac_chan_info(struct qtnf_wmac *mac,
+                                           const u8 *payload,
+                                           size_t payload_len)
+{
+       struct qtnf_mac_info *mac_info;
+       struct qlink_channel *qlink_channel;
+       struct qlink_chan_count *chan_count;
+       u16 tlv_type;
+       u16 tlv_value_len;
+       size_t tlv_full_len;
+       const struct qlink_tlv_hdr *tlv;
+       struct ieee80211_channel *channel;
+       int count = 0;
+
+       mac_info = &mac->macinfo;
+
+       tlv = (struct qlink_tlv_hdr *)payload;
+       while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+               tlv_type = le16_to_cpu(tlv->type);
+               tlv_value_len = le16_to_cpu(tlv->len);
+               tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+               if (tlv_full_len > payload_len) {
+                       pr_warn("%s: malformed TLV 0x%.2X; LEN: %u\n",
+                               __func__, tlv_type, tlv_value_len);
+                       return -EINVAL;
+               }
+               switch (tlv_type) {
+               case QTN_TLV_ID_CHAN_COUNT:
+                       if (unlikely(tlv_value_len != sizeof(*chan_count)))
+                               return -EINVAL;
+                       chan_count = (void *)tlv->val;
+                       if (le16_to_cpu(chan_count->count) >
+                           QLINK_MAX_CHANNELS) {
+                               pr_err("EP reported channel num more than max channels");
+                               return -ENOMEM;
+                       }
+
+                       mac_info->n_channels = le16_to_cpu(chan_count->count);
+
+                       /* Receiving new channel information; free earlier
+                        * channel structrues.
+                        */
+                       kfree(mac_info->channels);
+                       mac_info->channels = (void *)
+                               kzalloc(mac_info->n_channels *
+                                       sizeof(struct ieee80211_channel),
+                                       GFP_KERNEL);
+                       if (!mac_info->channels) {
+                               mac_info->n_channels = 0;
+                               return -ENOMEM;
+                       }
+                       pr_info("MAC%d reported channels %d\n",
+                               mac->macid, mac->macinfo.n_channels);
+                       break;
+               case QTN_TLV_ID_CHANNEL_CFG:
+                       if (unlikely(tlv_value_len != sizeof(*qlink_channel))) {
+                               pr_err("wmac_info: invalid channel length\n");
+                               return -EINVAL;
+                       }
+                       if (unlikely(!mac_info->n_channels)) {
+                               /* This means we yet havent received channel
+                                * count TLV and channels array is unallocated.
+                                */
+                               pr_err("Channel num info yet not populated\n");
+                               return -EINVAL;
+                       }
+
+                       qlink_channel = (void *)tlv->val;
+                       channel = &mac_info->channels[count++];
+                       if (count > mac_info->n_channels)
+                               return -EFAULT;
+                       channel->hw_value = qlink_channel->ic_ieee;
+                       channel->center_freq =
+                               le16_to_cpu(qlink_channel->ic_freq);
+                       channel->max_reg_power = qlink_channel->ic_maxregpower;
+                       channel->max_power = qlink_channel->ic_maxpower;
+                       if (le32_to_cpu(qlink_channel->ic_flags) &
+                           QLINK_CHAN_DFS) {
+                               channel->flags |= IEEE80211_CHAN_RADAR;
+                               channel->dfs_cac_ms = QTNF_DEF_DFS_CAC_TIME;
+                               channel->dfs_state = NL80211_DFS_USABLE;
+                               channel->dfs_state_entered = jiffies;
+                       }
+
+                       if (mac_info->phymode & QLINK_PHYMODE_BGN)
+                               channel->band = NL80211_BAND_2GHZ;
+                       else
+                               channel->band = NL80211_BAND_5GHZ;
+
+                       pr_debug("channel=%d, band=%d, freq=%d, max power=%d, reg_power=%d, flags = %#x\n",
+                                channel->hw_value, channel->band,
+                                channel->center_freq, channel->max_power,
+                                channel->max_reg_power, channel->flags);
+                       break;
+               default:
+                       pr_warn("%s: Unknown TLV type: %#x\n",
+                               __func__, le16_to_cpu(tlv->type));
+               }
+               payload_len -= tlv_full_len;
+               tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+       }
+       if (payload_len) {
+               pr_warn("%s: malformed IEs buf; bytes left: %zu\n", __func__,
+                       payload_len);
+               return -EINVAL;
+       }
+
+       if (WARN_ON(mac_info->n_channels != count)) {
+               pr_warn("%s: channel count mismatch: reported=%d, parsed from TLVs=%d\n",
+                       __func__, mac_info->n_channels, count);
+               return -1;
+       }
+
+       return 0;
+}
+
+static int qtnf_cmd_resp_proc_phy_params(struct qtnf_wmac *mac,
+                                        const u8 *payload, size_t payload_len)
+{
+       struct qtnf_mac_info *mac_info;
+       struct qlink_tlv_frag_rts_thr *phy_thr;
+       struct qlink_tlv_rlimit *limit;
+       struct qlink_tlv_cclass *class;
+       u16 tlv_type;
+       u16 tlv_value_len;
+       size_t tlv_full_len;
+       const struct qlink_tlv_hdr *tlv;
+
+       mac_info = &mac->macinfo;
+
+       tlv = (struct qlink_tlv_hdr *)payload;
+       while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+               tlv_type = le16_to_cpu(tlv->type);
+               tlv_value_len = le16_to_cpu(tlv->len);
+               tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+               if (tlv_full_len > payload_len) {
+                       pr_warn("%s: malformed TLV 0x%.2X; LEN: %u\n",
+                               __func__, tlv_type, tlv_value_len);
+                       return -EINVAL;
+               }
+               switch (tlv_type) {
+               case QTN_TLV_ID_FRAG_THRESH:
+                       phy_thr = (void *)tlv;
+                       mac_info->frag_thr = (u32)le16_to_cpu(phy_thr->thr);
+                       break;
+               case QTN_TLV_ID_RTS_THRESH:
+                       phy_thr = (void *)tlv;
+                       mac_info->rts_thr = (u32)le16_to_cpu(phy_thr->thr);
+                       break;
+               case QTN_TLV_ID_SRETRY_LIMIT:
+                       limit = (void *)tlv;
+                       mac_info->sretry_limit = limit->rlimit;
+                       break;
+               case QTN_TLV_ID_LRETRY_LIMIT:
+                       limit = (void *)tlv;
+                       mac_info->lretry_limit = limit->rlimit;
+                       break;
+               case QTN_TLV_ID_COVERAGE_CLASS:
+                       class = (void *)tlv;
+                       mac_info->coverage_class = class->cclass;
+                       break;
+               default:
+                       pr_err("%s: Unknown TLV type: %#x\n", __func__,
+                              le16_to_cpu(tlv->type));
+                       break;
+               }
+               payload_len -= tlv_full_len;
+               tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+       }
+       if (payload_len) {
+               pr_warn("%s: malformed IEs buf; bytes left: %zu\n", __func__,
+                       payload_len);
+               return -EINVAL;
+       }
+
+       return 0;
+}
+
+int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
+{
+       struct sk_buff *cmd_skb, *resp_skb = NULL;
+       const struct qlink_mac_info *mac_info = NULL;
+       size_t response_size = 0;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
+                                           QLINK_HOSTCMD_MAC_INFO);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(mac->bus);
+
+       ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb,
+                                      &res_code, (const u8 **)&mac_info,
+                                      &response_size);
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       if (unlikely(response_size < sizeof(*mac_info))) {
+               pr_warn("%s: invalid response payload size: %zu < %zu\n",
+                       __func__, response_size, sizeof(*mac_info));
+               ret = -EINVAL;
+               goto out;
+       }
+
+       ret = qtnf_cmd_resp_proc_mac_info(mac, mac_info, response_size);
+
+out:
+       qtnf_bus_unlock(mac->bus);
+       consume_skb(resp_skb);
+
+       return ret;
+}
+
+int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
+{
+       struct sk_buff *cmd_skb, *resp_skb = NULL;
+       const struct qlink_hw_info *hw_info = NULL;
+       size_t response_size = 0;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
+                                           QLINK_HOSTCMD_HW_INFO);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(bus);
+
+       ret = qtnf_cmd_send_with_reply(bus, cmd_skb, &resp_skb, &res_code,
+                                      (const u8 **)&hw_info, &response_size);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       if (unlikely(response_size < sizeof(*hw_info))) {
+               pr_warn("%s: invalid response payload size: %zu < %zu\n",
+                       __func__, response_size, sizeof(*hw_info));
+               ret = -EINVAL;
+               goto out;
+       }
+
+       ret = qtnf_cmd_resp_proc_hw_info(bus, hw_info, response_size);
+
+out:
+       qtnf_bus_unlock(bus);
+       consume_skb(resp_skb);
+
+       return ret;
+}
+
+int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac)
+{
+       struct sk_buff *cmd_skb, *resp_skb = NULL;
+       size_t response_size = 0;
+       const u8 *response = NULL;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
+                                           QLINK_HOSTCMD_MAC_CHAN_INFO);
+       if (!cmd_skb)
+               return -ENOMEM;
+
+       qtnf_cmd_skb_put_action(cmd_skb, QTNF_HOSTCMD_ACTION_GET);
+       ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+                                      &response, &response_size);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       ret = qtnf_cmd_resp_proc_mac_chan_info(mac, response, response_size);
+
+out:
+       consume_skb(resp_skb);
+
+       return ret;
+}
+
+int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac)
+{
+       struct sk_buff *cmd_skb, *resp_skb = NULL;
+       size_t response_size = 0;
+       const u8 *response = NULL;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
+                                           QLINK_HOSTCMD_PHY_PARAMS);
+       if (!cmd_skb)
+               return -ENOMEM;
+
+       qtnf_bus_lock(mac->bus);
+
+       qtnf_cmd_skb_put_action(cmd_skb, QTNF_HOSTCMD_ACTION_GET);
+       ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+                                      &response, &response_size);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+       ret = qtnf_cmd_resp_proc_phy_params(mac, response, response_size);
+
+out:
+       qtnf_bus_unlock(mac->bus);
+       consume_skb(resp_skb);
+
+       return ret;
+}
+
+int qtnf_cmd_send_update_phy_params(struct qtnf_wmac *mac, u16 cmd_action,
+                                   u32 changed)
+{
+       struct wiphy *wiphy = priv_to_wiphy(mac);
+       struct sk_buff *cmd_skb;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
+                                           QLINK_HOSTCMD_PHY_PARAMS);
+       if (!cmd_skb)
+               return -ENOMEM;
+
+       qtnf_bus_lock(mac->bus);
+
+       qtnf_cmd_skb_put_action(cmd_skb, cmd_action);
+
+       if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
+               qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_FRAG_THRESH,
+                                        wiphy->frag_threshold);
+       if (changed & WIPHY_PARAM_RTS_THRESHOLD)
+               qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_RTS_THRESH,
+                                        wiphy->rts_threshold);
+       if (changed & WIPHY_PARAM_COVERAGE_CLASS)
+               qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_COVERAGE_CLASS,
+                                       wiphy->coverage_class);
+
+       ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, NULL, &res_code, NULL,
+                                      NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_init_fw(struct qtnf_bus *bus)
+{
+       struct sk_buff *cmd_skb;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
+                                           QLINK_HOSTCMD_FW_INIT);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(bus);
+
+       ret = qtnf_cmd_send_with_reply(bus, cmd_skb, NULL, &res_code, NULL,
+                                      NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(bus);
+       return ret;
+}
+EXPORT_SYMBOL_GPL(qtnf_cmd_send_init_fw);
+
+int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
+                         const u8 *mac_addr, struct key_params *params)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_add_key_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_ADD_KEY);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_add_key_req *)skb_put(cmd_skb, sizeof(*req));
+       if (mac_addr)
+               ether_addr_copy(req->addr, mac_addr);
+       else
+               eth_broadcast_addr(req->addr);
+       req->cipher = cpu_to_le32(params->cipher);
+       req->key_index = key_index;
+       req->pairwise = pairwise;
+       if (params->key && params->key_len > 0) {
+               qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_KEY,
+                                        params->key,
+                                        params->key_len);
+       }
+       if (params->seq && params->seq_len > 0) {
+               qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_SEQ,
+                                        params->seq,
+                                        params->seq_len);
+       }
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
+                         const u8 *mac_addr)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_del_key_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_DEL_KEY);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_del_key_req *)skb_put(cmd_skb, sizeof(*req));
+       if (mac_addr)
+               ether_addr_copy(req->addr, mac_addr);
+       else
+               eth_broadcast_addr(req->addr);
+       req->key_index = key_index;
+       req->pairwise = pairwise;
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_set_default_key(struct qtnf_vif *vif, u8 key_index,
+                                 bool unicast, bool multicast)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_set_def_key_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_SET_DEFAULT_KEY);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_set_def_key_req *)skb_put(cmd_skb, sizeof(*req));
+       req->key_index = key_index;
+       req->unicast = unicast;
+       req->multicast = multicast;
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_vif *vif, u8 key_index)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_set_def_mgmt_key_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_SET_DEFAULT_MGMT_KEY);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_set_def_mgmt_key_req *)
+                       skb_put(cmd_skb, sizeof(*req));
+       req->key_index = key_index;
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+static u32 qtnf_encode_sta_flags(u32 flags)
+{
+       u32 code = 0;
+
+       if (flags & BIT(NL80211_STA_FLAG_AUTHORIZED))
+               code |= QLINK_STA_FLAG_AUTHORIZED;
+       if (flags & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
+               code |= QLINK_STA_FLAG_SHORT_PREAMBLE;
+       if (flags & BIT(NL80211_STA_FLAG_WME))
+               code |= QLINK_STA_FLAG_WME;
+       if (flags & BIT(NL80211_STA_FLAG_MFP))
+               code |= QLINK_STA_FLAG_MFP;
+       if (flags & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+               code |= QLINK_STA_FLAG_AUTHENTICATED;
+       if (flags & BIT(NL80211_STA_FLAG_TDLS_PEER))
+               code |= QLINK_STA_FLAG_TDLS_PEER;
+       if (flags & BIT(NL80211_STA_FLAG_ASSOCIATED))
+               code |= QLINK_STA_FLAG_ASSOCIATED;
+       return code;
+}
+
+int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
+                            struct station_parameters *params)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_sta_params_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_CHANGE_STA);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_sta_params_req *)skb_put(cmd_skb, sizeof(*req));
+       ether_addr_copy(req->sta_addr, mac);
+       req->sta_flags_mask = cpu_to_le32(qtnf_encode_sta_flags(
+                                         params->sta_flags_mask));
+       req->sta_flags_set = cpu_to_le32(qtnf_encode_sta_flags(
+                                        params->sta_flags_set));
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
+                         struct station_del_parameters *params)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_del_sta_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret = 0;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_DEL_STA);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_del_sta_req *)skb_put(cmd_skb, sizeof(*req));
+       if (params->mac)
+               ether_addr_copy(req->sta_addr, params->mac);
+       else
+               eth_broadcast_addr(req->sta_addr);      /* flush all stations */
+       req->subtype = params->subtype;
+       req->reason_code = cpu_to_le16(params->reason_code);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
+{
+       struct sk_buff *cmd_skb;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
+                                           QLINK_HOSTCMD_SCAN);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(mac->bus);
+
+       if (mac->scan_req->n_ssids != 0) {
+               qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID,
+                                        mac->scan_req->ssids[0].ssid,
+                                        mac->scan_req->ssids[0].ssid_len);
+       }
+       if (mac->scan_req->ie_len != 0) {
+               qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_IE_SET,
+                                        mac->scan_req->ie,
+                                        mac->scan_req->ie_len);
+       }
+
+       ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       pr_debug("Scan started on wmac %u\n", mac->macid);
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+out:
+       qtnf_bus_unlock(mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_connect(struct qtnf_vif *vif,
+                         struct cfg80211_connect_params *sme)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_connect_req *req;
+       struct qtnf_bss_config *bss_cfg = &vif->bss_cfg;
+       struct qlink_auth_encr aen;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+       int i;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_CONNECT);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_connect_req *)skb_put(cmd_skb, sizeof(*req));
+
+       memset(req, 0, sizeof(*req));
+
+       ether_addr_copy(req->bssid, bss_cfg->bssid);
+       if (bss_cfg->chandef.chan)
+               req->freq = cpu_to_le16(bss_cfg->chandef.chan->center_freq);
+       req->bg_scan_period = cpu_to_le16(bss_cfg->bg_scan_period);
+
+       memset(&aen, 0, sizeof(aen));
+       aen.auth_type = bss_cfg->auth_type;
+       aen.privacy = !!bss_cfg->privacy;
+       aen.mfp = bss_cfg->mfp;
+       aen.wpa_versions = cpu_to_le32(bss_cfg->crypto.wpa_versions);
+       aen.cipher_group = cpu_to_le32(bss_cfg->crypto.cipher_group);
+       aen.n_ciphers_pairwise = cpu_to_le32(
+                                       bss_cfg->crypto.n_ciphers_pairwise);
+       for (i = 0; i < QLINK_MAX_NR_CIPHER_SUITES; i++)
+               aen.ciphers_pairwise[i] = cpu_to_le32(
+                                       bss_cfg->crypto.ciphers_pairwise[i]);
+       aen.n_akm_suites = cpu_to_le32(
+                                       bss_cfg->crypto.n_akm_suites);
+       for (i = 0; i < QLINK_MAX_NR_AKM_SUITES; i++)
+               aen.akm_suites[i] = cpu_to_le32(
+                                       bss_cfg->crypto.akm_suites[i]);
+       aen.control_port = bss_cfg->crypto.control_port;
+       aen.control_port_no_encrypt =
+                       bss_cfg->crypto.control_port_no_encrypt;
+       aen.control_port_ethertype = cpu_to_le16(be16_to_cpu(
+                               bss_cfg->crypto.control_port_ethertype));
+
+       qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, bss_cfg->ssid,
+                                bss_cfg->ssid_len);
+
+       qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_CRYPTO, (u8 *)&aen,
+                                sizeof(aen));
+
+       if (sme->ie_len != 0) {
+               qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_IE_SET,
+                                        sme->ie,
+                                        sme->ie_len);
+       }
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, u16 reason_code)
+{
+       struct sk_buff *cmd_skb;
+       struct qlink_disconnect_req *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_DISCONNECT);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       qtnf_bus_lock(vif->mac->bus);
+
+       req = (struct qlink_disconnect_req *)skb_put(cmd_skb, sizeof(*req));
+       req->reason = cpu_to_le16(reason_code);
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+out:
+       qtnf_bus_unlock(vif->mac->bus);
+       return ret;
+}
+
+int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif, bool up)
+{
+       struct sk_buff *cmd_skb;
+       u8 *req;
+       u16 res_code = QLINK_HOSTCMD_RESULT_OK;
+       int ret;
+
+       cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+                                           QLINK_HOSTCMD_UPDOWN_INTF);
+       if (unlikely(!cmd_skb))
+               return -ENOMEM;
+
+       req = (u8 *)skb_put(cmd_skb, sizeof(*req));
+       *req = !!up;
+
+       ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, NULL,
+                                      &res_code, NULL, NULL);
+
+       if (unlikely(ret))
+               goto out;
+
+       if (unlikely(res_code != QLINK_HOSTCMD_RESULT_OK)) {
+               pr_err("%s: cmd exec failed: 0x%.4X\n", __func__, res_code);
+               ret = -EFAULT;
+               goto out;
+       }
+out:
+       return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
new file mode 100644
index 0000000..01daa75
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -0,0 +1,73 @@
+/**
+ * Copyright (c) 2016 Quantenna Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef QLINK_COMMANDS_H_
+#define QLINK_COMMANDS_H_
+
+#include <linux/nl80211.h>
+
+#include "core.h"
+#include "bus.h"
+
+int qtnf_cmd_send_init_fw(struct qtnf_bus *bus);
+int qtnf_cmd_get_hw_info(struct qtnf_bus *bus);
+int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac);
+int qtnf_cmd_send_add_intf(struct qtnf_vif *vif, enum nl80211_iftype iftype,
+                          u8 *mac_addr);
+int qtnf_cmd_send_change_intf_type(struct qtnf_vif *vif,
+                                  enum nl80211_iftype iftype, u8 *mac_addr);
+int qtnf_cmd_send_del_intf(struct qtnf_vif *vif);
+int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac);
+int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *mac, u16 action,
+                                   const char *alpha2);
+int qtnf_cmd_send_config_ap(struct qtnf_vif *vif);
+int qtnf_cmd_send_start_ap(struct qtnf_vif *vif);
+int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif);
+int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool reg);
+int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
+                            u16 freq, const u8 *buf, size_t len);
+int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
+                                const u8 *buf, size_t len);
+int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
+                         struct station_info *sinfo);
+int qtnf_cmd_send_phy_params(struct qtnf_wmac *mac, u16 cmd_action,
+                            void *data_buf);
+int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
+                         const u8 *mac_addr, struct key_params *params);
+int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
+                         const u8 *mac_addr);
+int qtnf_cmd_send_set_default_key(struct qtnf_vif *vif, u8 key_index,
+                                 bool unicast, bool multicast);
+int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_vif *vif, u8 key_index);
+int qtnf_cmd_send_add_sta(struct qtnf_vif *vif, const u8 *mac,
+                         struct station_parameters *params);
+int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
+                            struct station_parameters *params);
+int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
+                         struct station_del_parameters *params);
+
+int qtnf_cmd_resp_parse(struct qtnf_bus *bus, struct sk_buff *resp_skb);
+int qtnf_cmd_resp_check(const struct qtnf_vif *vif,
+                       const struct sk_buff *resp_skb, u16 cmd_id,
+                       u16 *result, const u8 **payload, size_t *payload_size);
+int qtnf_cmd_send_scan(struct qtnf_wmac *mac);
+int qtnf_cmd_send_connect(struct qtnf_vif *vif,
+                         struct cfg80211_connect_params *sme);
+int qtnf_cmd_send_disconnect(struct qtnf_vif *vif,
+                            u16 reason_code);
+int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
+                             bool up);
+
+#endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
new file mode 100644
index 0000000..1983d9d
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -0,0 +1,220 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/if_vlan.h>
+#include <linux/if_ether.h>
+
+#include "core.h"
+#include "pcie.h"
+#include "bus.h"
+
+#define QTNF_DMP_MAX_LEN 48
+
+struct qtnf_frame_meta_info {
+       u8 magic_s;
+       u8 ifidx;
+       u8 macid;
+       u8 magic_e;
+} __packed;
+
+static inline int qtnf_is_frame_meta_magic_valid(struct qtnf_frame_meta_info *m)
+{
+       return m->magic_s == 0xAB && m->magic_e == 0xBA;
+}
+
+struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid)
+{
+       struct qtnf_wmac *mac = NULL;
+
+       if (unlikely(macid >= QTNF_MAX_MAC)) {
+               pr_err("%s: invalid macid received: %u\n", __func__,
+                      macid);
+               return NULL;
+       }
+
+       mac = bus->mac[macid];
+
+       if (unlikely(!mac) || unlikely(!mac->mac_started)) {
+               pr_err("%s: mac %u not initialized\n", __func__,
+                      macid);
+               return NULL;
+       }
+
+       return mac;
+}
+
+struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+       struct qtnf_frame_meta_info *meta;
+       struct net_device *ndev = NULL;
+       struct qtnf_wmac *mac;
+       struct qtnf_vif *vif;
+
+       meta = (struct qtnf_frame_meta_info *)
+               (skb_tail_pointer(skb) - sizeof(*meta));
+
+       if (unlikely(!qtnf_is_frame_meta_magic_valid(meta))) {
+               pr_err_ratelimited("%s: invalid magic(0x%x:0x%x)\n",
+                                  __func__, meta->magic_s, meta->magic_e);
+               goto out;
+       }
+
+       if (unlikely(meta->macid >= QTNF_MAX_MAC)) {
+               pr_err_ratelimited("%s: invalid macid(%u)\n", __func__,
+                                  meta->macid);
+               goto out;
+       }
+
+       if (unlikely(meta->ifidx >= QTNF_MAX_INTF)) {
+               pr_err_ratelimited("%s: invalid vifid(%u)\n", __func__,
+                                  meta->ifidx);
+               goto out;
+       }
+
+       mac = bus->mac[meta->macid];
+
+       if (unlikely(!mac)) {
+               pr_err_ratelimited("%s: mac(%d) does not exist\n", __func__,
+                                  meta->macid);
+               goto out;
+       }
+
+       vif = &mac->iflist[meta->ifidx];
+
+       if (unlikely(vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)) {
+               pr_err_ratelimited("%s: vif(%u) does not exists\n", __func__,
+                                  meta->ifidx);
+               goto out;
+       }
+
+       ndev = vif->netdev;
+
+       if (unlikely(!ndev)) {
+               pr_err_ratelimited("%s: netdev for wlan%u.%u does not exists\n",
+                                  __func__, meta->macid, meta->ifidx);
+               goto out;
+       }
+
+       __skb_trim(skb, skb->len - sizeof(*meta));
+
+       pr_debug("RCVD MAC(%d) VIF(%d)\n", meta->macid, meta->ifidx);
+
+out:
+       return ndev;
+}
+EXPORT_SYMBOL_GPL(qtnf_classify_skb);
+
+/* Netdev handler for open.
+ */
+static int qtnf_netdev_open(struct net_device *ndev)
+{
+       netif_carrier_off(ndev);
+       qtnf_netdev_updown(ndev, 1);
+       return 0;
+}
+
+/* Netdev handler for close.
+ */
+static int qtnf_netdev_close(struct net_device *ndev)
+{
+       netif_carrier_off(ndev);
+       qtnf_virtual_intf_cleanup(ndev);
+       qtnf_netdev_updown(ndev, 0);
+       return 0;
+}
+
+/* Netdev handler for data transmission.
+ */
+static int
+qtnf_netdev_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+       struct qtnf_vif *vif;
+       struct qtnf_wmac *mac;
+
+       vif = qtnf_netdev_get_priv(ndev);
+
+       if (unlikely(vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)) {
+               dev_kfree_skb_any(skb);
+               return 0;
+       }
+
+       mac = vif->mac;
+       if (unlikely(!mac)) {
+               pr_warn("start_xmit: NULL mac pointer");
+               dev_kfree_skb_any(skb);
+               return 0;
+       }
+
+       if (!skb->len || (skb->len > ETH_FRAME_LEN)) {
+               pr_err("start_xmit: invalid skb len %d\n", skb->len);
+               dev_kfree_skb_any(skb);
+               ndev->stats.tx_dropped++;
+               return 0;
+       }
+
+       return qtnf_bus_data_tx(mac->bus, skb);
+}
+
+/* Netdev handler for getting stats.
+ */
+static struct net_device_stats *qtnf_netdev_get_stats(struct net_device *dev)
+{
+       return &dev->stats;
+}
+
+/* Netdev handler for transmission timeout.
+ */
+static void qtnf_netdev_tx_timeout(struct net_device *ndev)
+{
+       struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+
+       if (unlikely(!vif || !vif->mac))
+               return;
+
+       pr_warn("qtnf: Tx timeout- %lu, mac/vif num = %d/%d\n", jiffies,
+               vif->mac->macid, vif->vifid);
+
+       netif_carrier_off(ndev);
+       qtnf_virtual_intf_cleanup(ndev);
+       qtnf_netdev_updown(ndev, 0);
+}
+
+/* Network device ops handlers */
+const struct net_device_ops qtnf_netdev_ops = {
+       .ndo_open = qtnf_netdev_open,
+       .ndo_stop = qtnf_netdev_close,
+       .ndo_start_xmit = qtnf_netdev_hard_start_xmit,
+       .ndo_tx_timeout = qtnf_netdev_tx_timeout,
+       .ndo_get_stats = qtnf_netdev_get_stats,
+};
+
+static int __init qtnf_module_init(void)
+{
+       return 0;
+}
+
+static void __exit qtnf_module_exit(void)
+{
+}
+
+module_init(qtnf_module_init);
+module_exit(qtnf_module_exit);
+
+MODULE_AUTHOR("Quantenna Communications");
+MODULE_DESCRIPTION("Quantenna 802.11 wireless LAN FullMAC driver.");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
new file mode 100644
index 0000000..a0e19d6
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -0,0 +1,170 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_CORE_H_
+#define _QTN_FMAC_CORE_H_
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <net/sock.h>
+#include <net/lib80211.h>
+#include <net/cfg80211.h>
+#include <linux/vmalloc.h>
+#include <linux/firmware.h>
+#include <linux/ctype.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+
+#include "qlink.h"
+#include "trans.h"
+
+#define QTNF_MAX_TX_QLEN               100
+#define QTNF_MAX_SSID_LIST_LENGTH      2
+#define QTNF_MAX_VSIE_LEN              255
+#define QTNF_MAX_ALPHA_LEN             2
+#define QTNF_MAX_INTF                  8
+#define QTNF_MAX_EVENT_QUEUE_LEN       255
+#define QTNF_DEFAULT_BG_SCAN_PERIOD    300
+#define QTNF_MAX_BG_SCAN_PERIOD                0xffff
+
+#define QTNF_DEF_BSS_PRIORITY          0
+#define QTNF_DEF_WDOG_TIMEOUT          5
+
+#define QTNF_STATE_AP_CONFIG           BIT(2)
+#define QTNF_STATE_AP_START            BIT(1)
+
+extern const struct net_device_ops qtnf_netdev_ops;
+struct qtnf_bus;
+struct qtnf_vif;
+
+struct qtnf_bss_config {
+       u8 ssid[IEEE80211_MAX_SSID_LEN];
+       u8 bssid[ETH_ALEN];
+       size_t ssid_len;
+       u8 dtim;
+       u16 bcn_period;
+       u16 auth_type;
+       bool privacy;
+       enum nl80211_mfp mfp;
+       struct cfg80211_chan_def chandef;
+       struct cfg80211_crypto_settings crypto;
+       u16 bg_scan_period;
+       u32 connect_flags;
+};
+
+struct qtnf_sta_node {
+       struct list_head list;
+       u8 mac_addr[ETH_ALEN];
+};
+
+struct qtnf_sta_list {
+       struct list_head head;
+       atomic_t size;
+};
+
+enum qtnf_sta_state {
+       QTNF_STA_DISCONNECTED,
+       QTNF_STA_CONNECTING,
+       QTNF_STA_CONNECTED
+};
+
+struct qtnf_vif {
+       struct wireless_dev wdev;
+       u8 vifid;
+       u8 bss_priority;
+       u8 bss_status;
+       enum qtnf_sta_state sta_state;
+       u16 mgmt_frames_bitmask;
+       struct net_device *netdev;
+       struct qtnf_wmac *mac;
+       u8 mac_addr[ETH_ALEN];
+       struct work_struct multicast_work;
+       struct qtnf_bss_config bss_cfg;
+       struct qtnf_sta_list sta_list;
+};
+
+struct qtnf_mac_info {
+       u16 phymode;
+       u8 dev_mac[ETH_ALEN];
+       u8 num_tx_chain;
+       u8 num_rx_chain;
+       u16 max_ap_assoc_sta;
+       u32 frag_thr;
+       u32 rts_thr;
+       u8 lretry_limit;
+       u8 sretry_limit;
+       u8 coverage_class;
+       u8 radar_detect_widths;
+       struct ieee80211_ht_cap ht_cap;
+       struct ieee80211_vht_cap vht_cap;
+       struct ieee80211_iface_limit *limits;
+       size_t n_limits;
+       u16 n_channels;
+       struct ieee80211_channel *channels;
+};
+
+struct qtnf_wmac {
+       u8 macid;
+       u8 mac_started;
+       u8 wiphy_registered;
+       struct qtnf_bus *bus;
+       u8 macaddr[ETH_ALEN];
+       struct qtnf_mac_info macinfo;
+       struct qtnf_vif iflist[QTNF_MAX_INTF];
+       struct cfg80211_scan_request *scan_req;
+};
+
+struct qtnf_hw_info {
+       u8 num_mac;
+       u8 mac_bitmap;
+       u32 fw_api_ver;
+       u16 ql_proto_ver;
+       u8 country_code[QTNF_MAX_ALPHA_LEN];
+       u8 total_tx_chain;
+       u8 total_rx_chain;
+       u32 hw_capab;
+};
+
+struct qtnf_vif *qtnf_get_free_vif(struct qtnf_wmac *mac);
+struct qtnf_vif *qtnf_get_base_vif(struct qtnf_wmac *mac);
+struct wiphy *qtnf_allocate_wiphy(struct qtnf_bus *bus);
+int qtnf_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *priv,
+                   const char *name, unsigned char name_assign_type,
+                   enum nl80211_iftype iftype);
+void qtnf_main_work_queue(struct work_struct *work);
+int qtnf_cmd_send_update_phy_params(struct qtnf_wmac *mac, u16 cmd_action,
+                                   u32 changed);
+int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac);
+
+struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid);
+struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb);
+
+void qtnf_virtual_intf_cleanup(struct net_device *ndev);
+
+void qtnf_netdev_updown(struct net_device *ndev, bool up);
+
+static inline struct qtnf_vif *qtnf_netdev_get_priv(struct net_device *dev)
+{
+       return (struct qtnf_vif *)(*(unsigned long *)netdev_priv(dev));
+}
+
+#endif /* _QTN_FMAC_CORE_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
new file mode 100644
index 0000000..ffc25d3
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -0,0 +1,436 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "cfg80211.h"
+#include "core.h"
+#include "qlink.h"
+#include "bus.h"
+#include "trans.h"
+#include "util.h"
+#include "event.h"
+
+static int
+qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
+                           const struct qlink_event_sta_assoc *sta_assoc,
+                           u16 len)
+{
+       const u8 *sta_addr;
+       u16 frame_control;
+       struct station_info sinfo = { 0 };
+       size_t payload_len;
+       u16 tlv_type;
+       u16 tlv_value_len;
+       size_t tlv_full_len;
+       const struct qlink_tlv_hdr *tlv;
+
+       if (unlikely(len < sizeof(struct qlink_event_sta_assoc))) {
+               pr_err("%s: payload is too short (%u < %zu)\n", __func__,
+                      len, sizeof(struct qlink_event_sta_assoc));
+               return -EINVAL;
+       }
+
+       if (vif->wdev.iftype != NL80211_IFTYPE_AP) {
+               pr_err("%s: STA_ASSOC event when not in AP mode\n", __func__);
+               return -EPROTO;
+       }
+       if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+               pr_err("%s: STA_ASSOC event when AP is not started\n",
+                      __func__);
+               return -EPROTO;
+       }
+
+       sta_addr = sta_assoc->sta_addr;
+       frame_control = le16_to_cpu(sta_assoc->frame_control);
+
+       pr_debug("%s: MAC: %pM; FC: %x\n", __func__, sta_addr, frame_control);
+
+       qtnf_sta_list_add(&vif->sta_list, sta_addr);
+
+       sinfo.assoc_req_ies = NULL;
+       sinfo.assoc_req_ies_len = 0;
+
+       payload_len = len - sizeof(struct qlink_event_sta_assoc);
+       tlv = (struct qlink_tlv_hdr *)sta_assoc->payload;
+       while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+               tlv_type = le16_to_cpu(tlv->type);
+               tlv_value_len = le16_to_cpu(tlv->len);
+               tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+               if (tlv_full_len > payload_len) {
+                       pr_warn("%s: malformed TLV 0x%.2X; LEN: %u\n",
+                               __func__, tlv_type, tlv_value_len);
+                       return -EINVAL;
+               }
+               if (tlv_type == QTN_TLV_ID_IE_SET) {
+                       sinfo.assoc_req_ies = tlv->val;
+                       sinfo.assoc_req_ies_len = tlv_value_len;
+               }
+               payload_len -= tlv_full_len;
+               tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+       }
+       if (payload_len) {
+               pr_warn("%s: malformed IEs buf; bytes left: %zu\n", __func__,
+                       payload_len);
+               return -EINVAL;
+       }
+
+       cfg80211_new_sta(vif->netdev, sta_assoc->sta_addr, &sinfo,
+                        GFP_KERNEL);
+
+       return 0;
+}
+
+static int
+qtnf_event_handle_sta_deauth(struct qtnf_wmac *mac, struct qtnf_vif *vif,
+                            const struct qlink_event_sta_deauth *sta_deauth,
+                            u16 len)
+{
+       const u8 *sta_addr;
+       u16 reason;
+
+       if (unlikely(len < sizeof(struct qlink_event_sta_deauth))) {
+               pr_err("%s: payload is too short (%u < %zu)\n", __func__,
+                      len, sizeof(struct qlink_event_sta_deauth));
+               return -EINVAL;
+       }
+
+       if (vif->wdev.iftype != NL80211_IFTYPE_AP) {
+               pr_err("%s: STA_DEAUTH event when not in AP mode\n", __func__);
+               return -EPROTO;
+       }
+       if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+               pr_err("%s: STA_DEAUTH event when AP is not started\n",
+                      __func__);
+               return -EPROTO;
+       }
+
+       sta_addr = sta_deauth->sta_addr;
+       reason = le16_to_cpu(sta_deauth->reason);
+
+       pr_debug("%s: MAC: %pM; reason: %x\n", __func__, sta_addr, reason);
+
+       if (qtnf_sta_list_del(&vif->sta_list, sta_addr))
+               cfg80211_del_sta(vif->netdev, sta_deauth->sta_addr,
+                                GFP_KERNEL);
+
+       return 0;
+}
+
+static int
+qtnf_event_handle_bss_join(struct qtnf_vif *vif,
+                          const struct qlink_event_bss_join *join_info,
+                          u16 len)
+{
+       if (unlikely(len < sizeof(struct qlink_event_bss_join))) {
+               pr_err("%s: payload is too short (%u < %zu)\n", __func__,
+                      len, sizeof(struct qlink_event_bss_join));
+               return -EINVAL;
+       }
+
+       if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
+               pr_err("%s: BSS_JOIN event when not in STA mode\n", __func__);
+               return -EPROTO;
+       }
+       if (vif->sta_state != QTNF_STA_CONNECTING) {
+               pr_err("%s: BSS_JOIN event when STA is not connecting\n",
+                      __func__);
+               return -EPROTO;
+       }
+
+       pr_debug("%s: BSSID: %pM\n", __func__, join_info->bssid);
+
+       cfg80211_connect_result(vif->netdev, join_info->bssid, NULL, 0, NULL,
+                               0, le16_to_cpu(join_info->status), GFP_KERNEL);
+
+       if (le16_to_cpu(join_info->status) == WLAN_STATUS_SUCCESS) {
+               vif->sta_state = QTNF_STA_CONNECTED;
+               netif_carrier_on(vif->netdev);
+       } else {
+               vif->sta_state = QTNF_STA_DISCONNECTED;
+       }
+
+       return 0;
+}
+
+static int
+qtnf_event_handle_bss_leave(struct qtnf_vif *vif,
+                           const struct qlink_event_bss_leave *leave_info,
+                           u16 len)
+{
+       if (unlikely(len < sizeof(struct qlink_event_bss_leave))) {
+               pr_err("%s: payload is too short (%u < %zu)\n", __func__,
+                      len, sizeof(struct qlink_event_bss_leave));
+               return -EINVAL;
+       }
+
+       if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
+               pr_err("%s: BSS_LEAVE event when not in STA mode\n", __func__);
+               return -EPROTO;
+       }
+       if (vif->sta_state != QTNF_STA_CONNECTED) {
+               pr_err("%s: BSS_LEAVE event when STA is not connected\n",
+                      __func__);
+               return -EPROTO;
+       }
+
+       pr_debug("%s: disconnected\n", __func__);
+
+       cfg80211_disconnected(vif->netdev, leave_info->reason, NULL, 0, 0,
+                             GFP_KERNEL);
+
+       vif->sta_state = QTNF_STA_DISCONNECTED;
+       netif_carrier_off(vif->netdev);
+
+       return 0;
+}
+
+static int qtnf_event_handle_mgmt_received(struct qtnf_vif *vif,
+                                          struct qlink_event_rxmgmt *rxmgmt,
+                                          u16 len)
+{
+       const size_t min_len = sizeof(struct qlink_event_rxmgmt) +
+                              sizeof(struct ieee80211_hdr_3addr);
+       const struct ieee80211_hdr_3addr *frame = (void *)rxmgmt->frame_data;
+       const u16 frame_len = len - sizeof(struct qlink_event_rxmgmt);
+       enum nl80211_rxmgmt_flags flags = 0;
+
+       if (unlikely(len < min_len)) {
+               pr_err("%s: payload is too short (%u < %zu)\n", __func__,
+                      len, min_len);
+               return -EINVAL;
+       }
+
+       if (le32_to_cpu(rxmgmt->flags) & QLINK_RXMGMT_FLAG_ANSWERED)
+               flags |= NL80211_RXMGMT_FLAG_ANSWERED;
+
+       pr_debug("%s: %s LEN: %u; FC: %.4X; SA: %pM\n", __func__,
+                vif->netdev->name, frame_len,
+                le16_to_cpu(frame->frame_control), frame->addr2);
+
+       cfg80211_rx_mgmt(&vif->wdev, le32_to_cpu(rxmgmt->freq),
+                        le32_to_cpu(rxmgmt->sig_mbm), rxmgmt->frame_data,
+                        frame_len, flags);
+
+       return 0;
+}
+
+static int qtnf_event_handle_scan_results(struct qtnf_vif *vif,
+                                         struct qlink_event_scan_entry *se,
+                                         u16 len)
+{
+       struct cfg80211_bss *bss;
+       struct ieee80211_channel *channel;
+       struct wiphy *wiphy = priv_to_wiphy(vif->mac);
+       enum cfg80211_bss_frame_type frame_type;
+       size_t payload_len;
+       u16 tlv_type;
+       u16 tlv_value_len;
+       size_t tlv_full_len;
+       const struct qlink_tlv_hdr *tlv;
+
+       const u8 *ies = NULL;
+       size_t ies_len = 0;
+
+       if (len < sizeof(struct qlink_event_scan_entry)) {
+               pr_err("%s: payload is too short\n", __func__);
+               return -EINVAL;
+       }
+
+       channel = ieee80211_get_channel(wiphy, le16_to_cpu(se->freq));
+       if (!channel) {
+               pr_err("%s: channel at %u MHz not found\n", __func__,
+                      le16_to_cpu(se->freq));
+               return -EINVAL;
+       }
+
+       switch (se->frame_type) {
+       case QLINK_BSS_FTYPE_BEACON:
+               frame_type = CFG80211_BSS_FTYPE_BEACON;
+               break;
+       case QLINK_BSS_FTYPE_PRESP:
+               frame_type = CFG80211_BSS_FTYPE_PRESP;
+               break;
+       default:
+               frame_type = CFG80211_BSS_FTYPE_UNKNOWN;
+       }
+
+       payload_len = len - sizeof(struct qlink_event_scan_entry);
+       tlv = (struct qlink_tlv_hdr *)se->payload;
+       while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+               tlv_type = le16_to_cpu(tlv->type);
+               tlv_value_len = le16_to_cpu(tlv->len);
+               tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+               if (tlv_full_len > payload_len) {
+                       pr_warn("%s: malformed TLV 0x%.2X; LEN: %u\n",
+                               __func__, tlv_type, tlv_value_len);
+                       return -EINVAL;
+               }
+               if (tlv_type == QTN_TLV_ID_IE_SET) {
+                       ies = tlv->val;
+                       ies_len = tlv_value_len;
+               }
+               payload_len -= tlv_full_len;
+               tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+       }
+
+       if (payload_len) {
+               pr_warn("%s: malformed IEs buf; bytes left: %zu\n", __func__,
+                       payload_len);
+               return -EINVAL;
+       }
+
+       bss = cfg80211_inform_bss(wiphy, channel, frame_type,
+                                 se->bssid, get_unaligned_le64(&se->tsf),
+                                 le16_to_cpu(se->capab),
+                                 le16_to_cpu(se->bintval), ies, ies_len,
+                                 se->signal, GFP_KERNEL);
+       if (!bss)
+               return -ENOMEM;
+
+       cfg80211_put_bss(wiphy, bss);
+
+       return 0;
+}
+
+static int
+qtnf_event_handle_scan_complete(struct qtnf_wmac *mac,
+                               struct qlink_event_scan_complete *status,
+                               u16 len)
+{
+       u32 flags;
+
+       if (len < sizeof(struct qlink_event_scan_complete)) {
+               pr_err("%s: payload is too short\n", __func__);
+               return -EINVAL;
+       }
+       if (!mac->scan_req)
+               return 0;
+
+       flags = le32_to_cpu(status->flags);
+       cfg80211_scan_done(mac->scan_req, flags & QLINK_SCAN_ABORTED);
+       mac->scan_req = NULL;
+       return 0;
+}
+
+static int qtnf_event_parse(struct qtnf_wmac *mac,
+                           const struct sk_buff *event_skb)
+{
+       const struct qlink_event_header *event;
+       struct qtnf_vif *vif = NULL;
+       int ret = -1;
+       u16 event_id;
+       u16 event_payload_len;
+
+       event = (void *)event_skb->data;
+       event_id = le16_to_cpu(event->event_id);
+       event_payload_len = le16_to_cpu(event->header.len) - QTNF_DEF_EVHDR_SZ;
+
+       if (likely(event->vifid < QTNF_MAX_INTF)) {
+               vif = &mac->iflist[event->vifid];
+       } else {
+               pr_err("%s: invalid vif id: %u\n", __func__, event->vifid);
+               return -EINVAL;
+       }
+
+       switch (event_id) {
+       case QLINK_EVENT_STA_ASSOCIATED:
+               ret = qtnf_event_handle_sta_assoc(mac, vif,
+                                                 (const void *)event->payload,
+                                                 event_payload_len);
+               break;
+       case QLINK_EVENT_STA_DEAUTH:
+               ret = qtnf_event_handle_sta_deauth(mac, vif,
+                                                  (const void *)event->payload,
+                                                  event_payload_len);
+               break;
+       case QLINK_EVENT_MGMT_RECEIVED:
+               ret = qtnf_event_handle_mgmt_received(vif,
+                                                     (void *)event->payload,
+                                                     event_payload_len);
+               break;
+       case QLINK_EVENT_SCAN_RESULTS:
+               ret = qtnf_event_handle_scan_results(vif,
+                                                    (void *)event->payload,
+                                                    event_payload_len);
+               break;
+       case QLINK_EVENT_SCAN_COMPLETE:
+               ret = qtnf_event_handle_scan_complete(mac,
+                                                     (void *)event->payload,
+                                                     event_payload_len);
+               break;
+       case QLINK_EVENT_BSS_JOIN:
+               ret = qtnf_event_handle_bss_join(vif,
+                                                (void *)event->payload,
+                                                event_payload_len);
+               break;
+       case QLINK_EVENT_BSS_LEAVE:
+               ret = qtnf_event_handle_bss_leave(vif,
+                                                 (void *)event->payload,
+                                                 event_payload_len);
+               break;
+       default:
+               pr_warn("%s: unknown event type: %x\n", __func__, event_id);
+               break;
+       }
+
+       return ret;
+}
+
+static int qtnf_event_process_skb(struct qtnf_bus *bus,
+                                 const struct sk_buff *skb)
+{
+       const struct qlink_event_header *event;
+       struct qtnf_wmac *mac;
+       int res;
+
+       if (unlikely(!skb || skb->len < QTNF_DEF_EVHDR_SZ)) {
+               pr_err("%s: invalid event buffer\n", __func__);
+               return -EINVAL;
+       }
+
+       event = (struct qlink_event_header *)skb->data;
+
+       mac = qtnf_core_get_mac(bus, event->macid);
+
+       pr_debug("qtnfmac: new event: id: %x; len: %u; mac: %u; vif: %u\n",
+                le16_to_cpu(event->event_id), le16_to_cpu(event->header.len),
+                event->macid, event->vifid);
+
+       if (unlikely(!mac))
+               return -ENXIO;
+
+       qtnf_bus_lock(bus);
+       res = qtnf_event_parse(mac, skb);
+       qtnf_bus_unlock(bus);
+
+       return res;
+}
+
+void qtnf_event_work_handler(struct work_struct *work)
+{
+       struct qtnf_bus *bus = container_of(work, struct qtnf_bus, event_work);
+       struct sk_buff_head *event_queue = &bus->trans.event_queue;
+       struct sk_buff *current_event_skb = skb_dequeue(event_queue);
+
+       while (current_event_skb) {
+               qtnf_event_process_skb(bus, current_event_skb);
+               dev_kfree_skb_any(current_event_skb);
+               current_event_skb = skb_dequeue(event_queue);
+       }
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.h b/drivers/net/wireless/quantenna/qtnfmac/event.h
new file mode 100644
index 0000000..a693130
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.h
@@ -0,0 +1,27 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_EVENT_H_
+#define _QTN_FMAC_EVENT_H_
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "qlink.h"
+
+void qtnf_event_work_handler(struct work_struct *work);
+
+#endif /* _QTN_FMAC_EVENT_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/init.c b/drivers/net/wireless/quantenna/qtnfmac/init.c
new file mode 100644
index 0000000..322215c
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/init.c
@@ -0,0 +1,320 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include <linux/types.h>
+#include <linux/export.h>
+#include <net/mac80211.h>
+
+#include "core.h"
+#include "bus.h"
+#include "commands.h"
+#include "event.h"
+#include "cfg80211.h"
+#include "util.h"
+
+struct qtnf_vif *qtnf_get_free_vif(struct qtnf_wmac *mac)
+{
+       struct qtnf_vif *vif;
+       int i;
+
+       for (i = 0; i < QTNF_MAX_INTF; i++) {
+               vif = &mac->iflist[i];
+               if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
+                       return vif;
+       }
+
+       return NULL;
+}
+
+struct qtnf_vif *qtnf_get_base_vif(struct qtnf_wmac *mac)
+{
+       struct qtnf_vif *vif;
+
+       vif = &mac->iflist[0];
+
+       if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
+               return NULL;
+
+       return vif;
+}
+
+static int qtnf_add_default_intf(struct qtnf_wmac *mac)
+{
+       struct qtnf_vif *vif;
+
+       vif = (void *)qtnf_get_free_vif(mac);
+       if (!vif) {
+               pr_err("qtnfmac: %s:could not get free vif structure\n",
+                      __func__);
+               return -EFAULT;
+       }
+
+       vif->wdev.iftype = NL80211_IFTYPE_AP;
+       vif->bss_priority = QTNF_DEF_BSS_PRIORITY;
+       vif->wdev.wiphy = priv_to_wiphy(mac);
+
+       return 0;
+}
+
+static struct qtnf_wmac *qtnf_init_mac(struct qtnf_bus *bus, int macid)
+{
+       struct wiphy *wiphy;
+       struct qtnf_wmac *mac;
+       u8 i;
+
+       wiphy = qtnf_allocate_wiphy(bus);
+       if (!wiphy)
+               return ERR_PTR(-ENOMEM);
+
+       mac = wiphy_priv(wiphy);
+
+       mac->macid = macid;
+       mac->bus = bus;
+
+       for (i = 0; i < QTNF_MAX_INTF; i++) {
+               memset(&mac->iflist[i], 0, sizeof(struct qtnf_vif));
+               mac->iflist[i].wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+               mac->iflist[i].mac = mac;
+               mac->iflist[i].vifid = i;
+               qtnf_sta_list_init(&mac->iflist[i].sta_list);
+       }
+
+       if (qtnf_add_default_intf(mac)) {
+               pr_err("failed to create default interface for mac=%d\n",
+                      macid);
+               wiphy_free(wiphy);
+               return NULL;
+       }
+
+       mac->mac_started = 1;
+       bus->mac[macid] = mac;
+       return mac;
+}
+
+int qtnf_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *vif,
+                   const char *name, unsigned char name_assign_type,
+                   enum nl80211_iftype iftype)
+{
+       struct wiphy *wiphy = priv_to_wiphy(mac);
+       struct net_device *dev;
+       void *qdev_vif;
+
+       dev = alloc_netdev_mqs(sizeof(struct qtnf_vif *), name,
+                              name_assign_type, ether_setup, 1, 1);
+       if (!dev) {
+               pr_err("no memory available for netdevice\n");
+               memset(&vif->wdev, 0, sizeof(vif->wdev));
+               vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+               return -ENOMEM;
+       }
+
+       vif->netdev = dev;
+
+       dev->netdev_ops = &qtnf_netdev_ops;
+       dev->destructor = free_netdev;
+       dev_net_set(dev, wiphy_net(wiphy));
+       dev->ieee80211_ptr = &vif->wdev;
+       dev->ieee80211_ptr->iftype = iftype;
+       ether_addr_copy(dev->dev_addr, vif->mac_addr);
+       SET_NETDEV_DEV(dev, wiphy_dev(wiphy));
+       dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+       dev->watchdog_timeo = QTNF_DEF_WDOG_TIMEOUT;
+       dev->tx_queue_len = QTNF_MAX_TX_QLEN;
+
+       qdev_vif = netdev_priv(dev);
+       *((unsigned long *)qdev_vif) = (unsigned long)vif;
+
+       SET_NETDEV_DEV(dev, mac->bus->dev);
+
+       if (register_netdevice(dev)) {
+               pr_err("qtnfmac: cannot register virtual network device\n");
+               free_netdev(dev);
+               vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+               return -EFAULT;
+       }
+
+       return 0;
+}
+
+static int qtnf_core_mac_init(struct qtnf_bus *bus, int macid)
+{
+       struct qtnf_wmac *mac;
+       struct qtnf_vif *vif;
+
+       pr_info("%s: macid=%d\n", __func__, macid);
+
+       if (!(bus->hw_info.mac_bitmap & BIT(macid))) {
+               pr_warn("WMAC with id=%d is not available for RC operation\n",
+                       macid);
+               return 0;
+       }
+
+       mac = qtnf_init_mac(bus, macid);
+       if (!mac) {
+               pr_err("%s: failed to initialize mac; macid=%d\n", __func__,
+                      macid);
+               return -1;
+       }
+
+       if (qtnf_cmd_get_mac_info(mac)) {
+               pr_err("failed to get MAC information\n");
+               return -1;
+       }
+
+       vif = qtnf_get_base_vif(mac);
+       if (!vif) {
+               pr_err("core_attach: could not get valid vif pointer\n");
+               return -1;
+       }
+
+       if (qtnf_cmd_send_add_intf(vif, NL80211_IFTYPE_AP, vif->mac_addr)) {
+               pr_err("core_attach: could not add default vif\n");
+               return -1;
+       }
+
+       if (qtnf_cmd_send_get_phy_params(mac)) {
+               pr_err("core_attach: could not get phy thresholds for mac\n");
+               return -1;
+       }
+
+       if (qtnf_cmd_get_mac_chan_info(mac)) {
+               pr_err("core_attach: could not get channel information for mac\n");
+               return -1;
+       }
+
+       if (qtnf_register_wiphy(bus, mac)) {
+               pr_err("core_attach: wiphy registartion failed\n");
+               return -1;
+       }
+
+       mac->wiphy_registered = 1;
+
+       /* add primary networking interface */
+       rtnl_lock();
+       if (qtnf_net_attach(mac, vif, "wlan%d", NET_NAME_ENUM,
+                           NL80211_IFTYPE_AP)) {
+               pr_err("could not attach netdev\n");
+               vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+               vif->netdev = NULL;
+               rtnl_unlock();
+               return -1;
+       }
+       rtnl_unlock();
+
+       return 0;
+}
+
+int qtnf_core_attach(struct qtnf_bus *bus)
+{
+       int i;
+
+       qtnf_trans_init(bus);
+
+       if (qtnf_bus_poll_state(bus, QTN_BUS_DEVICE, QTN_EP_FW_QLINK_DONE,
+                               QTN_FW_QLINK_TIMEOUT_MS)) {
+               pr_err("Qlink server init timeout\n");
+               return -1;
+       }
+
+       bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
+       qtnf_bus_data_rx_start(bus);
+
+       bus->workqueue = alloc_ordered_workqueue("QTNF", 0);
+       if (!bus->workqueue) {
+               pr_err("failed to alloc main workqueue\n");
+               return -1;
+       }
+
+       INIT_WORK(&bus->event_work, qtnf_event_work_handler);
+
+       if (qtnf_cmd_send_init_fw(bus)) {
+               pr_err("failed to send FW init commands\n");
+               return -1;
+       }
+
+       bus->fw_state = QTNF_FW_STATE_ACTIVE;
+
+       if (qtnf_cmd_get_hw_info(bus)) {
+               pr_err("failed to get HW information\n");
+               return -1;
+       }
+
+       if (bus->hw_info.ql_proto_ver != QLINK_PROTO_VER) {
+               pr_err("qlink protocol version mismatch\n");
+               return -1;
+       }
+
+       if (bus->hw_info.num_mac > QTNF_MAX_MAC) {
+               pr_err("invalid supported mac number from EP\n");
+               return -1;
+       }
+
+       for (i = 0; i < bus->hw_info.num_mac; i++) {
+               if (qtnf_core_mac_init(bus, i)) {
+                       pr_err("init failed for mac interface; macid=%d", i);
+                       return -1;
+               }
+       }
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(qtnf_core_attach);
+
+void qtnf_core_detach(struct qtnf_bus *bus)
+{
+       struct wiphy *wiphy;
+       struct qtnf_wmac *mac;
+       struct qtnf_vif *vif;
+       int i, cnt;
+
+       for (cnt = 0; cnt < QTNF_MAX_MAC; cnt++) {
+               mac = bus->mac[cnt];
+
+               if (!mac || !mac->mac_started)
+                       continue;
+
+               wiphy = priv_to_wiphy(mac);
+
+               for (i = 0; i < QTNF_MAX_INTF; i++) {
+                       vif = &mac->iflist[i];
+                       rtnl_lock();
+                       if (vif->netdev &&
+                           vif->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED) {
+                               qtnf_virtual_intf_cleanup(vif->netdev);
+                               qtnf_del_virtual_intf(wiphy, &vif->wdev);
+                       }
+                       rtnl_unlock();
+                       qtnf_sta_list_free(&vif->sta_list);
+               }
+
+               if (mac->wiphy_registered)
+                       wiphy_unregister(wiphy);
+
+               kfree(mac->macinfo.channels);
+               kfree(mac->macinfo.limits);
+               kfree(wiphy->iface_combinations);
+               wiphy_free(wiphy);
+               bus->mac[cnt] = NULL;
+       }
+
+       if (bus->workqueue) {
+               flush_workqueue(bus->workqueue);
+               destroy_workqueue(bus->workqueue);
+       }
+
+       qtnf_trans_free(bus);
+}
+EXPORT_SYMBOL_GPL(qtnf_core_detach);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie.c
new file mode 100644
index 0000000..44975dd
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie.c
@@ -0,0 +1,1374 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#undef DEBUG
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/pci.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/crc32.h>
+#include <linux/completion.h>
+#include <linux/spinlock.h>
+
+#include "qtn_hw_ids.h"
+
+#include "commands.h"
+#include "pcie.h"
+#include "core.h"
+#include "bus.h"
+
+/* */
+
+static bool use_msi = true;
+module_param(use_msi, bool, 0644);
+MODULE_PARM_DESC(use_msi, "set 0 to use legacy interrupt");
+
+static unsigned int tx_bd_size_param = 256;
+module_param(tx_bd_size_param, uint, 0644);
+MODULE_PARM_DESC(tx_bd_size_param, "Tx descriptors queue size");
+
+static unsigned int rx_bd_size_param = 256;
+module_param(rx_bd_size_param, uint, 0644);
+MODULE_PARM_DESC(rx_bd_size_param, "Rx descriptors queue size");
+
+static unsigned int rx_bd_reserved_param = 16;
+module_param(rx_bd_reserved_param, uint, 0644);
+MODULE_PARM_DESC(rx_bd_reserved_param, "Reserved RX descriptors");
+
+#define DRV_NAME       "Quantenna FMAC PCIe"
+
+/* */
+
+static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
+{
+       writel(val, basereg);
+
+       /* flush posted write */
+       readl(basereg);
+}
+
+/* */
+
+static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&priv->irq_lock, flags);
+       priv->pcie_irq_mask = (PCIE_HDP_INT_RX_BITS | PCIE_HDP_INT_TX_BITS);
+       spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&priv->irq_lock, flags);
+       writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+       spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&priv->irq_lock, flags);
+       writel(0x0, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+       spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&priv->irq_lock, flags);
+       priv->pcie_irq_mask |= PCIE_HDP_INT_RX_BITS;
+       writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+       spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&priv->irq_lock, flags);
+       priv->pcie_irq_mask &= ~PCIE_HDP_INT_RX_BITS;
+       writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+       spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_en_txdone_irq(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&priv->irq_lock, flags);
+       priv->pcie_irq_mask |= PCIE_HDP_INT_TX_BITS;
+       writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+       spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&priv->irq_lock, flags);
+       priv->pcie_irq_mask &= ~PCIE_HDP_INT_TX_BITS;
+       writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+       spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static int qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
+{
+       struct pci_dev *pdev = priv->pdev;
+
+       /* fall back to legacy INTx interrupts by default */
+       priv->msi_enabled = 0;
+
+       /* check if MSI capability is available */
+       if (use_msi) {
+               if (!pci_enable_msi(pdev)) {
+                       pr_info("enabled PCIE MSI interrupt\n");
+                       priv->msi_enabled = 1;
+               } else {
+                       pr_warn("couldn't enable PCIE MSI interrupts");
+               }
+       }
+
+       if (!priv->msi_enabled) {
+               pr_warn("legacy PCIE interrupts enabled\n");
+               pci_intx(pdev, 1);
+       }
+
+       return 0;
+}
+
+static void qtnf_deassert_intx(struct qtnf_pcie_bus_priv *priv)
+{
+       void __iomem *reg = priv->sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
+       u32 cfg;
+
+       cfg = readl(reg);
+       cfg &= ~PEARL_ASSERT_INTX;
+       qtnf_non_posted_write(cfg, reg);
+}
+
+/* shared memory IPC */
+
+static void qtnf_ipc_gen_ep_int(void *arg)
+{
+       const struct qtnf_pcie_bus_priv *priv = arg;
+       const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_IPC_IRQ);
+       void __iomem *reg = priv->sysctl_bar +
+                           QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
+
+       qtnf_non_posted_write(data, reg);
+}
+
+/* */
+
+static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 index)
+{
+       void __iomem *vaddr;
+       dma_addr_t busaddr;
+       size_t len;
+       int ret;
+
+       ret = pcim_iomap_regions(priv->pdev, 1 << index, DRV_NAME);
+       if (ret) {
+               pr_err("pcim_iomap_regions error for BAR %d\n", index);
+               return IOMEM_ERR_PTR(ret);
+       }
+
+       busaddr = pci_resource_start(priv->pdev, index);
+       vaddr = pcim_iomap_table(priv->pdev)[index];
+       len = pci_resource_len(priv->pdev, index);
+
+       pr_info("%s: BAR[%u] vaddr=0x%p busaddr=0x%p len=%u\n",
+               __func__, index, vaddr, (void *)busaddr, (int)len);
+
+       return vaddr;
+}
+
+static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t len)
+{
+       struct qtnf_pcie_bus_priv *priv = arg;
+       struct qtnf_bus *bus = pci_get_drvdata(priv->pdev);
+       struct sk_buff *skb;
+
+       if (unlikely(len == 0)) {
+               pr_warn("%s: zero length packet received\n", __func__);
+               return;
+       }
+
+       skb = __dev_alloc_skb(len, GFP_KERNEL);
+
+       if (unlikely(!skb)) {
+               pr_err("%s: failed to allocate skb\n", __func__);
+               return;
+       }
+
+       memcpy(skb_put(skb, len), buf, len);
+
+       qtnf_trans_handle_rx_ctl_packet(bus, skb);
+}
+
+static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+{
+       struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
+       struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
+       const struct qtnf_shm_ipc_int ipc_int = { qtnf_ipc_gen_ep_int, priv };
+       const struct qtnf_shm_ipc_rx_callback rx_callback = {
+                                       qtnf_pcie_control_rx_callback, priv };
+
+       ipc_tx_reg = &priv->bda->bda_shm_reg1;
+       ipc_rx_reg = &priv->bda->bda_shm_reg2;
+
+       qtnf_shm_ipc_init(&priv->shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
+                         ipc_tx_reg, priv->workqueue,
+                         &ipc_int, &rx_callback);
+       qtnf_shm_ipc_init(&priv->shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
+                         ipc_rx_reg, priv->workqueue,
+                         &ipc_int, &rx_callback);
+
+       return 0;
+}
+
+static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+{
+       qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
+       qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
+}
+
+static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
+{
+       int ret;
+
+       priv->sysctl_bar = qtnf_map_bar(priv, QTN_SYSCTL_BAR);
+       if (IS_ERR_OR_NULL(priv->sysctl_bar)) {
+               pr_err("%s: error mapping sysctl\n", __func__);
+               return ret;
+       }
+
+       priv->dmareg_bar = qtnf_map_bar(priv, QTN_DMA_BAR);
+       if (IS_ERR_OR_NULL(priv->dmareg_bar)) {
+               pr_err("%s: error mapping dma regs\n", __func__);
+               return ret;
+       }
+
+       priv->epmem_bar = qtnf_map_bar(priv, QTN_SHMEM_BAR);
+       if (IS_ERR_OR_NULL(priv->epmem_bar)) {
+               pr_err("%s: error mapping epmem\n", __func__);
+               return ret;
+       }
+
+       priv->pcie_reg_base = priv->dmareg_bar;
+       priv->bda = priv->epmem_bar;
+       writel(priv->msi_enabled, &priv->bda->bda_rc_msi_enabled);
+
+       return 0;
+}
+
+static int
+qtnf_pcie_init_dma_mask(struct qtnf_pcie_bus_priv *priv, u64 dma_mask)
+{
+       int ret;
+
+       ret = dma_supported(&priv->pdev->dev, dma_mask);
+       if (!ret) {
+               pr_err("DMA mask %llu not supported: %d\n", dma_mask, ret);
+               return ret;
+       }
+
+       ret = pci_set_dma_mask(priv->pdev, dma_mask);
+       if (ret) {
+               pr_err("DMA mask %llu not available: %d\n", dma_mask, ret);
+               return ret;
+       }
+
+       ret = pci_set_consistent_dma_mask(priv->pdev, dma_mask);
+       if (ret) {
+               pr_err("consistent DMA mask %llu not available: %d\n",
+                      dma_mask, ret);
+               return ret;
+       }
+
+       return ret;
+}
+
+/* */
+
+static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
+{
+       struct pci_dev *pdev = priv->pdev;
+       struct pci_dev *parent;
+       int mps_p, mps_o, mps_m, mps;
+       int ret;
+
+       /* current mps */
+       mps_o = pcie_get_mps(pdev);
+
+       /* maximum supported mps */
+       mps_m = 128 << pdev->pcie_mpss;
+
+       /* suggested new mps value */
+       mps = mps_m;
+
+       if (pdev->bus && pdev->bus->self) {
+               /* parent (bus) mps */
+               parent = pdev->bus->self;
+
+               if (pci_is_pcie(parent)) {
+                       mps_p = pcie_get_mps(parent);
+                       mps = min(mps_m, mps_p);
+               }
+       }
+
+       ret = pcie_set_mps(pdev, mps);
+       if (ret) {
+               pr_err("%s: failed to set mps to %d, keep using current %d\n",
+                      __func__, mps, mps_o);
+               priv->mps = mps_o;
+               return;
+       }
+
+       pr_info("%s: set mps to %d (was %d, max %d)\n",
+               __func__, mps, mps_o, mps_m);
+       priv->mps = mps;
+}
+
+/* */
+
+static int qtnf_is_state(struct qtnf_bus *bus, enum qtnf_bus_end ep, u32 state)
+{
+       struct qtnf_pcie_bus_priv *pcie_priv = (void *)get_bus_priv(bus);
+       struct qtnf_pcie_bda __iomem *bda = pcie_priv->bda;
+       void __iomem *reg;
+       u32 s;
+
+       reg = (ep == QTN_BUS_HOST) ? &bda->bda_rc_state : &bda->bda_ep_state;
+       s = readl(reg);
+
+       return (s & state);
+}
+
+static void
+qtnf_set_state(struct qtnf_bus *bus, enum qtnf_bus_end ep, u32 state)
+{
+       struct qtnf_pcie_bus_priv *pcie_priv = (void *)get_bus_priv(bus);
+       struct qtnf_pcie_bda __iomem *bda = pcie_priv->bda;
+       void __iomem *reg;
+       u32 s;
+
+       reg = (ep == QTN_BUS_HOST) ? &bda->bda_rc_state : &bda->bda_ep_state;
+       s = readl(reg);
+
+       qtnf_non_posted_write(state | s, reg);
+}
+
+static void
+qtnf_clear_state(struct qtnf_bus *bus, enum qtnf_bus_end ep, u32 state)
+{
+       struct qtnf_pcie_bus_priv *pcie_priv = (void *)get_bus_priv(bus);
+       struct qtnf_pcie_bda __iomem *bda = pcie_priv->bda;
+       void __iomem *reg;
+       u32 s;
+
+       reg = (ep == QTN_BUS_HOST) ? &bda->bda_rc_state : &bda->bda_ep_state;
+       s = readl(reg);
+
+       qtnf_non_posted_write((s & ~state), reg);
+}
+
+static int
+qtnf_poll_state(struct qtnf_bus *bus, enum qtnf_bus_end ep, u32 state,
+               u32 delay_in_ms)
+{
+       u32 timeout = 0;
+
+       while ((qtnf_is_state(bus, ep, state) == 0)) {
+               usleep_range(1000, 1200);
+               if (++timeout > delay_in_ms)
+                       return -1;
+       }
+
+       return 0;
+}
+
+/* */
+
+static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long addr;
+       int len;
+
+       len = priv->tx_bd_num * sizeof(*priv->tx_skb) +
+               priv->rx_bd_num * sizeof(*priv->rx_skb);
+       addr = (unsigned long)devm_kzalloc(&priv->pdev->dev, len, GFP_KERNEL);
+
+       if (!addr)
+               return -ENOMEM;
+
+       priv->tx_skb = (struct sk_buff **)addr;
+
+       addr += priv->tx_bd_num * sizeof(*priv->tx_skb);
+       priv->rx_skb = (struct sk_buff **)addr;
+
+       return 0;
+}
+
+static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
+{
+       unsigned long vaddr;
+       dma_addr_t paddr;
+       int len;
+
+       len = priv->tx_bd_num * sizeof(struct qtnf_tx_bd) +
+               priv->rx_bd_num * sizeof(struct qtnf_rx_bd);
+
+       vaddr = (unsigned long)dmam_alloc_coherent(&priv->pdev->dev,
+                                                  len, &paddr, GFP_KERNEL);
+       if (!vaddr)
+               return -ENOMEM;
+
+       /* tx bd */
+
+       memset((void *)vaddr, 0, len);
+
+       priv->bd_table_vaddr = vaddr;
+       priv->bd_table_paddr = paddr;
+       priv->bd_table_len = len;
+
+       priv->tx_bd_vbase = (struct qtnf_tx_bd *)vaddr;
+       priv->tx_bd_pbase = paddr;
+
+       pr_debug("TX descriptor table: vaddr=0x%p paddr=0x%p\n",
+                (void *)vaddr, (void *)paddr);
+
+       priv->tx_bd_reclaim_start = 0;
+       priv->tx_bd_index = 0;
+       priv->tx_queue_len = 0;
+
+       /* rx bd */
+
+       vaddr += priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
+       paddr += priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
+
+       priv->rx_bd_vbase = (struct qtnf_rx_bd *)vaddr;
+       priv->rx_bd_pbase = paddr;
+
+       writel(QTN_HOST_LO32(paddr),
+              PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
+       writel(QTN_HOST_HI32(paddr),
+              PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
+       writel(priv->rx_bd_num | (sizeof(struct qtnf_rx_bd)) << 16,
+              PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
+
+       priv->hw_txproc_wr_ptr = priv->rx_bd_num - rx_bd_reserved_param;
+
+       writel(priv->hw_txproc_wr_ptr,
+              PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
+
+       pr_debug("RX descriptor table: vaddr=0x%p paddr=0x%p\n",
+                (void *)vaddr, (void *)paddr);
+
+       priv->rx_bd_index = 0;
+
+       return 0;
+}
+
+static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 rx_bd_index)
+{
+       struct qtnf_rx_bd *rxbd;
+       struct sk_buff *skb;
+       dma_addr_t paddr;
+
+       skb = __dev_alloc_skb(SKB_BUF_SIZE + NET_IP_ALIGN,
+                             GFP_ATOMIC);
+       if (!skb) {
+               priv->rx_skb[rx_bd_index] = NULL;
+               return -ENOMEM;
+       }
+
+       priv->rx_skb[rx_bd_index] = skb;
+
+       skb_reserve(skb, NET_IP_ALIGN);
+
+       rxbd = &priv->rx_bd_vbase[rx_bd_index];
+
+       paddr = pci_map_single(priv->pdev, skb->data,
+                              SKB_BUF_SIZE, PCI_DMA_FROMDEVICE);
+
+       writel(QTN_HOST_LO32(paddr),
+              PCIE_HDP_HHBM_BUF_PTR(priv->pcie_reg_base));
+       writel(QTN_HOST_HI32(paddr),
+              PCIE_HDP_HHBM_BUF_PTR_H(priv->pcie_reg_base));
+
+       /* keep rx skb paddrs in rx buffer descriptors for cleanup purposes */
+       rxbd->addr = cpu_to_le32(QTN_HOST_LO32(paddr));
+       rxbd->addr_h = cpu_to_le32(QTN_HOST_HI32(paddr));
+
+       rxbd->info = 0x0;
+
+       return 0;
+}
+
+static int alloc_rx_buffers(struct qtnf_pcie_bus_priv *priv)
+{
+       u16 i;
+       int ret = 0;
+
+       memset((void *)priv->rx_bd_vbase, 0x0,
+              priv->rx_bd_num * sizeof(struct qtnf_rx_bd));
+
+       for (i = 0; i < priv->rx_bd_num; i++) {
+               ret = skb2rbd_attach(priv, i);
+               if (ret)
+                       break;
+       }
+
+       return ret;
+}
+
+/* all rx/tx activity should have ceased before calling this function */
+static void free_xfer_buffers(void *data)
+{
+       struct qtnf_pcie_bus_priv *priv = (struct qtnf_pcie_bus_priv *)data;
+       struct qtnf_rx_bd *rxbd;
+       dma_addr_t paddr;
+       int i;
+
+       /* free rx buffers */
+       for (i = 0; i < priv->rx_bd_num; i++) {
+               if (priv->rx_skb[i]) {
+                       rxbd = &priv->rx_bd_vbase[i];
+                       paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
+                                             le32_to_cpu(rxbd->addr));
+                       pci_unmap_single(priv->pdev, paddr, SKB_BUF_SIZE,
+                                        PCI_DMA_FROMDEVICE);
+
+                       dev_kfree_skb_any(priv->rx_skb[i]);
+               }
+       }
+
+       /* free tx buffers */
+       for (i = 0; i < priv->tx_bd_num; i++) {
+               if (priv->tx_skb[i]) {
+                       dev_kfree_skb_any(priv->tx_skb[i]);
+                       priv->tx_skb[i] = NULL;
+               }
+       }
+}
+
+static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
+{
+       int ret;
+
+       priv->tx_bd_num = tx_bd_size_param;
+       priv->rx_bd_num = rx_bd_size_param;
+
+       ret = alloc_skb_array(priv);
+       if (ret) {
+               pr_err("%s: can't allocate skb array\n", __func__);
+               return ret;
+       }
+
+       ret = alloc_bd_table(priv);
+       if (ret) {
+               pr_err("%s: can't allocate bd table\n", __func__);
+               return ret;
+       }
+
+       ret = alloc_rx_buffers(priv);
+       if (ret) {
+               pr_err("%s: can't allocate rx buffers\n", __func__);
+               return ret;
+       }
+
+       return ret;
+}
+
+/* */
+
+static int qtnf_pcie_data_tx_reclaim(struct qtnf_bus *bus)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+       struct qtnf_tx_bd *txbd;
+       struct sk_buff *skb;
+       dma_addr_t paddr;
+       int last_sent;
+       int i;
+
+       last_sent = readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
+                       % priv->tx_bd_num;
+
+       i = priv->tx_bd_reclaim_start;
+
+       while (i != last_sent) {
+               skb = priv->tx_skb[i];
+               if (!skb)
+                       break;
+
+               txbd = &priv->tx_bd_vbase[i];
+               paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
+                                     le32_to_cpu(txbd->addr));
+               pci_unmap_single(priv->pdev, paddr, skb->len, PCI_DMA_TODEVICE);
+
+               if (skb->dev) {
+                       skb->dev->stats.tx_packets++;
+                       skb->dev->stats.tx_bytes += skb->len;
+               }
+               dev_kfree_skb_any(skb);
+
+               priv->tx_skb[i] = NULL;
+               priv->tx_queue_len--;
+
+               if (++i >= priv->tx_bd_num)
+                       i = 0;
+       }
+
+       priv->tx_bd_reclaim_start = i;
+
+       return 0;
+}
+
+static bool qtnf_tx_queue_ready(struct qtnf_bus *bus)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+       if (priv->tx_queue_len >= priv->tx_bd_num - 1) {
+               /* TX queue full: emergency reclaim */
+               pr_err_ratelimited("%s: TX emergency\n", __func__);
+               qtnf_pcie_data_tx_reclaim(bus);
+
+               if (priv->tx_queue_len >= priv->tx_bd_num - 1) {
+                       priv->tx_full_count++;
+                       return false;
+               }
+       }
+
+       return true;
+}
+
+static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+       dma_addr_t txbd_paddr, skb_paddr;
+       struct qtnf_tx_bd *txbd;
+       unsigned long flags;
+       int len, i;
+       u32 info;
+       int ret = 0;
+
+       spin_lock_irqsave(&priv->tx_lock, flags);
+
+       if (!qtnf_tx_queue_ready(bus)) {
+               pr_err_ratelimited("%s: FULL TX queue\n", __func__);
+               spin_unlock_irqrestore(&priv->tx_lock, flags);
+               return NETDEV_TX_BUSY;
+       }
+
+       i = priv->tx_bd_index;
+       priv->tx_skb[i] = skb;
+       len = skb->len;
+
+       skb_paddr = pci_map_single(priv->pdev, skb->data,
+                                  skb->len, PCI_DMA_TODEVICE);
+       if (pci_dma_mapping_error(priv->pdev, skb_paddr)) {
+               pr_err("can't map TX skb");
+               ret = -ENOMEM;
+               goto tx_done;
+       }
+
+       txbd = &priv->tx_bd_vbase[i];
+       txbd->addr = cpu_to_le32(QTN_HOST_LO32(skb_paddr));
+       txbd->addr_h = cpu_to_le32(QTN_HOST_HI32(skb_paddr));
+
+       info = (len & QTN_PCIE_TX_DESC_LEN_MASK) << QTN_PCIE_TX_DESC_LEN_SHIFT;
+       txbd->info = cpu_to_le32(info);
+
+       /* sync up all descriptor updates before passing them to EP */
+       wmb();
+
+       /* write new TX descriptor to PCIE_RX_FIFO on EP */
+       txbd_paddr = priv->tx_bd_pbase + i * sizeof(struct qtnf_tx_bd);
+       writel(QTN_HOST_LO32(txbd_paddr),
+              PCIE_HDP_HOST_WR_DESC0(priv->pcie_reg_base));
+       writel(QTN_HOST_HI32(txbd_paddr),
+              PCIE_HDP_HOST_WR_DESC0_H(priv->pcie_reg_base));
+
+       if (++i >= priv->tx_bd_num)
+               i = 0;
+
+       priv->tx_bd_index = i;
+       priv->tx_queue_len++;
+
+tx_done:
+       if (ret && skb->dev)
+               skb->dev->stats.tx_dropped++;
+
+       spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+       return NETDEV_TX_OK;
+}
+
+static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+       return qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
+}
+
+/* */
+
+static irqreturn_t qtnf_interrupt(int irq, void *data)
+{
+       struct qtnf_bus *bus = (struct qtnf_bus *)data;
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+       u32 status;
+
+       priv->pcie_irq_count++;
+       status = readl(PCIE_HDP_INT_STATUS(priv->pcie_reg_base));
+
+       qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_in);
+       qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_out);
+
+       if (!(status & priv->pcie_irq_mask))
+               goto irq_done;
+
+       if (status & PCIE_HDP_INT_RX_BITS) {
+               qtnf_dis_rxdone_irq(priv);
+               napi_schedule(&bus->mux_napi);
+       }
+
+       if (status & PCIE_HDP_INT_TX_BITS) {
+               qtnf_dis_txdone_irq(priv);
+               tasklet_hi_schedule(&priv->reclaim_tq);
+       }
+
+irq_done:
+       /* H/W workaround: clean all bits, not only enabled */
+       qtnf_non_posted_write(~0U, PCIE_HDP_INT_STATUS(priv->pcie_reg_base));
+
+       if (!priv->msi_enabled)
+               qtnf_deassert_intx(priv);
+
+       return IRQ_HANDLED;
+}
+
+/* */
+
+static inline void hw_txproc_wr_ptr_inc(struct qtnf_pcie_bus_priv *priv)
+{
+       u32 index;
+
+       index = priv->hw_txproc_wr_ptr;
+
+       if (++index >= priv->rx_bd_num)
+               index = 0;
+
+       priv->hw_txproc_wr_ptr = index;
+}
+
+static int qtnf_rx_poll(struct napi_struct *napi, int budget)
+{
+       struct qtnf_bus *bus = container_of(napi, struct qtnf_bus, mux_napi);
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+       struct net_device *ndev = NULL;
+       struct sk_buff *skb = NULL;
+       int processed = 0;
+       struct qtnf_rx_bd *rxbd;
+       dma_addr_t skb_paddr;
+       u32 descw;
+       u16 index;
+       int ret;
+
+       index = priv->rx_bd_index;
+       rxbd = &priv->rx_bd_vbase[index];
+
+       descw = le32_to_cpu(rxbd->info);
+
+       while ((descw & QTN_TXDONE_MASK) && (processed < budget)) {
+               skb = priv->rx_skb[index];
+
+               if (likely(skb)) {
+                       skb_put(skb, QTN_GET_LEN(descw));
+
+                       skb_paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
+                                                 le32_to_cpu(rxbd->addr));
+                       pci_unmap_single(priv->pdev, skb_paddr, SKB_BUF_SIZE,
+                                        PCI_DMA_FROMDEVICE);
+
+                       ndev = qtnf_classify_skb(bus, skb);
+                       if (likely(ndev)) {
+                               ndev->stats.rx_packets++;
+                               ndev->stats.rx_bytes += skb->len;
+                               ndev->last_rx = jiffies;
+
+                               skb->protocol = eth_type_trans(skb, ndev);
+                               netif_receive_skb(skb);
+                       } else {
+                               pr_err("drop untagged skb\n");
+                               bus->mux_dev.stats.rx_dropped++;
+                               dev_kfree_skb_any(skb);
+                       }
+
+                       processed++;
+               } else {
+                       pr_err("missing rx_skb[%d]...\n", index);
+               }
+
+               /* attached rx buffer is passed upstream: map a new one */
+               ret = skb2rbd_attach(priv, index);
+               if (likely(!ret)) {
+                       if (++index >= priv->rx_bd_num)
+                               index = 0;
+
+                       priv->rx_bd_index = index;
+                       hw_txproc_wr_ptr_inc(priv);
+
+                       rxbd = &priv->rx_bd_vbase[index];
+                       descw = le32_to_cpu(rxbd->info);
+               } else {
+                       pr_err("couldn't allocate new rx_skb[%d]...\n", index);
+                       break;
+               }
+
+               writel(priv->hw_txproc_wr_ptr,
+                      PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
+       }
+
+       if (processed < budget) {
+               napi_complete(napi);
+               qtnf_en_rxdone_irq(priv);
+       }
+
+       return processed;
+}
+
+static void qtnf_pcie_data_rx_start(struct qtnf_bus *bus)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+       qtnf_enable_hdp_irqs(priv);
+       napi_enable(&bus->mux_napi);
+}
+
+static void qtnf_pcie_data_rx_stop(struct qtnf_bus *bus)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+       napi_disable(&bus->mux_napi);
+       qtnf_disable_hdp_irqs(priv);
+}
+
+/* */
+
+static struct qtnf_bus_ops qtnf_pcie_bus_ops = {
+       /* boot state methods */
+       .is_state       = qtnf_is_state,
+       .set_state      = qtnf_set_state,
+       .clear_state    = qtnf_clear_state,
+       .poll_state     = qtnf_poll_state,
+
+       /* control path methods */
+       .control_tx     = qtnf_pcie_control_tx,
+
+       /* data path methods */
+       .data_tx                = qtnf_pcie_data_tx,
+       .data_rx_start          = qtnf_pcie_data_rx_start,
+       .data_rx_stop           = qtnf_pcie_data_rx_stop,
+};
+
+/* */
+
+static int qtnf_ep_fw_send(struct qtnf_pcie_bus_priv *priv, uint32_t size,
+                          int blk, const u8 *pblk, const u8 *fw)
+{
+       struct pci_dev *pdev = priv->pdev;
+       struct qtnf_bus *bus = pci_get_drvdata(pdev);
+
+       struct qtnf_pcie_fw_hdr *hdr;
+       u8 *pdata;
+
+       int hds = sizeof(*hdr);
+       struct sk_buff *skb = NULL;
+       int len = 0;
+       int ret;
+
+       /* allocate MPS bytes for extra alignment due to hardware limitation*/
+       skb = __dev_alloc_skb(QTN_PCIE_FW_BUFSZ + priv->mps, GFP_KERNEL);
+       if (!skb)
+               return -ENOMEM;
+
+       /* align data to MPS boudary for hardware */
+       skb_reserve(skb, align_up_off((unsigned long)skb->data, priv->mps));
+
+       skb->len = QTN_PCIE_FW_BUFSZ;
+       skb->dev = NULL;
+
+       hdr = (struct qtnf_pcie_fw_hdr *)skb->data;
+       memcpy(hdr->boardflg, QTN_PCIE_BOARDFLG, strlen(QTN_PCIE_BOARDFLG));
+       hdr->fwsize = cpu_to_le32(size);
+       hdr->seqnum = cpu_to_le32(blk);
+
+       if (blk)
+               hdr->type = cpu_to_le32(QTN_FW_DSUB);
+       else
+               hdr->type = cpu_to_le32(QTN_FW_DBEGIN);
+
+       pdata = skb->data + hds;
+
+       len = QTN_PCIE_FW_BUFSZ - hds;
+       if (pblk >= (fw + size - len)) {
+               len = fw + size - pblk;
+               hdr->type = cpu_to_le32(QTN_FW_DEND);
+       }
+
+       hdr->pktlen = cpu_to_le32(len);
+       memcpy(pdata, pblk, len);
+       hdr->crc = cpu_to_le32(~crc32(0, pdata, len));
+
+       ret = qtnf_pcie_data_tx(bus, skb);
+
+       return (ret == NETDEV_TX_OK) ? len : 0;
+}
+
+static int
+qtnf_ep_fw_load(struct qtnf_pcie_bus_priv *priv, const u8 *fw, u32 fw_size)
+{
+       struct pci_dev *pdev = priv->pdev;
+       struct qtnf_bus *bus = pci_get_drvdata(pdev);
+
+       int blk_size = QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pcie_fw_hdr);
+       int blk_count = fw_size / blk_size + 1;
+       const u8 *pblk = fw;
+       int threshold = 0;
+       int blk = 0;
+       int len;
+
+       pr_info("fw download started: fw start addr = 0x%p, size=%d\n",
+               fw, fw_size);
+
+       while (blk < blk_count) {
+               if (++threshold > 10000) {
+                       pr_err("fw download failed: too many retries...\n");
+                       return -ETIMEDOUT;
+               }
+
+               len = qtnf_ep_fw_send(priv, fw_size, blk, pblk, fw);
+               if (len <= 0)
+                       continue;
+
+               if (!((blk + 1) & QTN_PCIE_FW_DLMASK) ||
+                   (blk == (blk_count - 1))) {
+                       qtnf_set_state(bus, QTN_BUS_HOST, QTN_RC_FW_SYNC);
+                       if (qtnf_poll_state(bus, QTN_BUS_DEVICE, QTN_EP_FW_SYNC,
+                                           QTN_FW_DL_TIMEOUT_MS)) {
+                               pr_err("fw download failed: SYNC timeout...\n");
+                               return -ETIMEDOUT;
+                       }
+
+                       qtnf_clear_state(bus, QTN_BUS_DEVICE, QTN_EP_FW_SYNC);
+
+                       if (qtnf_is_state(bus, QTN_BUS_DEVICE,
+                                         QTN_EP_FW_RETRY)) {
+                               if (blk == (blk_count - 1)) {
+                                       int last_round =
+                                               blk_count & QTN_PCIE_FW_DLMASK;
+                                       blk -= last_round;
+                                       pblk -= ((last_round - 1) *
+                                               blk_size + len);
+                               } else {
+                                       blk -= QTN_PCIE_FW_DLMASK;
+                                       pblk -= QTN_PCIE_FW_DLMASK * blk_size;
+                               }
+
+                               qtnf_clear_state(bus, QTN_BUS_DEVICE,
+                                                QTN_EP_FW_RETRY);
+
+                               pr_warn("fw download retry: block #%d\n", blk);
+                               continue;
+                       }
+
+                       qtnf_pcie_data_tx_reclaim(bus);
+               }
+
+               pblk += len;
+               blk++;
+       }
+
+       pr_info("fw download completed: totally sent %d blocks\n", blk);
+       return 0;
+}
+
+static void qtnf_firmware_load(const struct firmware *fw, void *context)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)context;
+       struct pci_dev *pdev = priv->pdev;
+       struct qtnf_bus *bus = pci_get_drvdata(pdev);
+       int ret;
+
+       if (!fw) {
+               pr_err("Failed to get firmware %s\n", bus->fwname);
+               goto fw_load_err;
+       }
+
+       ret = qtnf_ep_fw_load(priv, fw->data, fw->size);
+       if (ret) {
+               pr_err("fw download error\n");
+               goto fw_load_err;
+       }
+
+       if (qtnf_poll_state(bus, QTN_BUS_DEVICE, QTN_EP_FW_DONE,
+                           QTN_FW_DL_TIMEOUT_MS)) {
+               pr_err("EP bringup timeout\n");
+               goto fw_load_err;
+       }
+
+       bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
+       pr_notice("EP is up and running\n");
+
+fw_load_err:
+
+       if (fw)
+               release_firmware(fw);
+
+       complete(&bus->request_firmware_complete);
+}
+
+static int qtnf_bringup_fw(struct qtnf_bus *bus)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+       struct pci_dev *pdev = priv->pdev;
+       int ret;
+
+       pr_info("RC is ready to boot EP...\n");
+
+       qtnf_set_state(bus, QTN_BUS_HOST, QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK);
+       if (qtnf_poll_state(bus, QTN_BUS_DEVICE, QTN_EP_FW_LOADRDY,
+                           QTN_FW_DL_TIMEOUT_MS)) {
+               pr_err("EP is not ready to boot...\n");
+               return -ETIMEDOUT;
+       }
+
+       pr_info("starting download firmware %s...\n", bus->fwname);
+
+       qtnf_clear_state(bus, QTN_BUS_DEVICE, QTN_EP_FW_LOADRDY);
+
+       ret = request_firmware_nowait(THIS_MODULE, 1, bus->fwname, &pdev->dev,
+                                     GFP_KERNEL, priv, qtnf_firmware_load);
+       if (ret)
+               pr_err("request_firmware_nowait error %d\n", ret);
+
+       return ret;
+}
+
+static void qtnf_reclaim_tasklet_fn(unsigned long data)
+{
+       struct qtnf_pcie_bus_priv *priv = (void *)data;
+       struct qtnf_bus *bus = pci_get_drvdata(priv->pdev);
+       unsigned long flags;
+
+       spin_lock_irqsave(&priv->tx_lock, flags);
+       qtnf_pcie_data_tx_reclaim(bus);
+       spin_unlock_irqrestore(&priv->tx_lock, flags);
+       qtnf_en_txdone_irq(priv);
+}
+
+/* sysfs knobs: stats and other diagnistics */
+
+static ssize_t
+qtnf_pcie_stats_show(struct device *dev,
+                    struct device_attribute *attr, char *buf)
+{
+       struct qtnf_bus *bus = dev_get_drvdata(dev);
+       struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+       ssize_t len = 0;
+
+       len += snprintf(buf + len, PAGE_SIZE - len,
+                       "qtn stats:\n");
+       len += snprintf(buf + len, PAGE_SIZE - len,
+                       "\ttx_full_count(%u)\n", priv->tx_full_count);
+       len += snprintf(buf + len, PAGE_SIZE - len,
+                       "\tpcie_irq_count(%u)\n", priv->pcie_irq_count);
+
+       return len;
+}
+
+static DEVICE_ATTR(qtnf_stats, S_IRUGO | S_IWUSR | S_IWGRP,
+                  qtnf_pcie_stats_show, NULL);
+
+static struct attribute *qtnf_sysfs_entries[] = {
+       &dev_attr_qtnf_stats.attr,
+       NULL
+};
+
+static struct attribute_group qtnf_attrs_group = {
+       .name = NULL,
+       .attrs = qtnf_sysfs_entries,
+};
+
+/* */
+
+static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+       struct qtnf_pcie_bus_priv *pcie_priv;
+       struct qtnf_bus *bus;
+       int ret;
+
+       bus = devm_kzalloc(&pdev->dev,
+                          sizeof(*bus) + sizeof(*pcie_priv), GFP_KERNEL);
+       if (!bus) {
+               ret = -ENOMEM;
+               goto err_init;
+       }
+
+       pcie_priv = get_bus_priv(bus);
+
+       pci_set_drvdata(pdev, bus);
+       bus->bus_ops = &qtnf_pcie_bus_ops;
+       bus->dev = &pdev->dev;
+       bus->fw_state = QTNF_FW_STATE_RESET;
+       pcie_priv->pdev = pdev;
+
+       strcpy(bus->fwname, QTN_PCI_FW_NAME);
+       init_completion(&bus->request_firmware_complete);
+       mutex_init(&bus->bus_lock);
+       spin_lock_init(&pcie_priv->irq_lock);
+       spin_lock_init(&pcie_priv->tx_lock);
+
+       /* reset diag stats */
+       pcie_priv->tx_full_count = 0;
+       pcie_priv->pcie_irq_count = 0;
+
+       pcie_priv->workqueue = create_singlethread_workqueue("QTNF_BUS");
+       if (!pcie_priv->workqueue) {
+               pr_err("failed to alloc bus workqueue\n");
+               ret = -ENODEV;
+               goto err_priv;
+       }
+
+       if (!pci_is_pcie(pdev)) {
+               pr_err("Device %s is not PCI Express\n", pci_name(pdev));
+               ret = -EIO;
+               goto err_base;
+       }
+
+       qtnf_tune_pcie_mps(pcie_priv);
+
+       ret = pcim_enable_device(pdev);
+       if (ret) {
+               pr_err("failed to init PCI device %x\n", pdev->device);
+               goto err_base;
+       } else {
+               pr_info("successful init of PCI device %x\n", pdev->device);
+       }
+
+       pcim_pin_device(pdev);
+       pci_set_master(pdev);
+
+       ret = qtnf_pcie_init_irq(pcie_priv);
+       if (ret < 0) {
+               pr_err("irq init failed\n");
+               goto err_base;
+       }
+
+       ret = qtnf_pcie_init_memory(pcie_priv);
+       if (ret < 0) {
+               pr_err("PCIE memory init failed\n");
+               goto err_base;
+       }
+
+       ret = qtnf_pcie_init_shm_ipc(pcie_priv);
+       if (ret < 0) {
+               pr_err("PCIE SHM IPC init failed\n");
+               goto err_base;
+       }
+
+       ret = qtnf_pcie_init_dma_mask(pcie_priv, DMA_BIT_MASK(32));
+       if (ret) {
+               pr_err("PCIE DMA mask init failed\n");
+               goto err_base;
+       }
+
+       ret = devm_add_action(&pdev->dev, free_xfer_buffers, (void *)pcie_priv);
+       if (ret) {
+               pr_err("Custom release callback init failed\n");
+               goto err_base;
+       }
+
+       ret = qtnf_pcie_init_xfer(pcie_priv);
+       if (ret) {
+               pr_err("PCIE xfer init failed\n");
+               goto err_base;
+       }
+
+       /* init default irq settings */
+       qtnf_init_hdp_irqs(pcie_priv);
+
+       /* start with disabled irqs */
+       qtnf_disable_hdp_irqs(pcie_priv);
+
+       ret = devm_request_irq(&pdev->dev, pdev->irq, &qtnf_interrupt, 0,
+                              "qtnf_pcie_irq", (void *)bus);
+       if (ret) {
+               pr_err("failed to request pcie irq %d\n", pdev->irq);
+               goto err_base;
+       }
+
+       tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
+                    (unsigned long)pcie_priv);
+       init_dummy_netdev(&bus->mux_dev);
+       netif_napi_add(&bus->mux_dev, &bus->mux_napi,
+                      qtnf_rx_poll, 10);
+
+       ret = qtnf_bringup_fw(bus);
+       if (ret) {
+               pr_err("failed to bringup EP\n");
+               goto err_bringup_fw;
+       }
+
+       wait_for_completion(&bus->request_firmware_complete);
+       if (bus->fw_state != QTNF_FW_STATE_FW_DNLD_DONE) {
+               pr_err("failed to launch EP Qlink server\n");
+               goto err_bringup_fw;
+       }
+
+       ret = qtnf_core_attach(bus);
+       if (ret) {
+               pr_err("failed to attach core\n");
+               goto err_core_attach;
+       }
+
+       ret = sysfs_create_group(&pdev->dev.kobj, &qtnf_attrs_group);
+       if (ret) {
+               pr_err("Failed to create qtnf sysfs group\n");
+               goto err_core_attach;
+       }
+
+       return 0;
+
+err_core_attach:
+       qtnf_core_detach(bus);
+       qtnf_pcie_data_rx_stop(bus);
+
+err_bringup_fw:
+       netif_napi_del(&bus->mux_napi);
+
+err_base:
+       flush_workqueue(pcie_priv->workqueue);
+       destroy_workqueue(pcie_priv->workqueue);
+
+err_priv:
+       pci_set_drvdata(pdev, NULL);
+
+err_init:
+       return ret;
+}
+
+static void qtnf_pcie_remove(struct pci_dev *pdev)
+{
+       struct qtnf_pcie_bus_priv *priv;
+       struct qtnf_bus *bus;
+
+       bus = pci_get_drvdata(pdev);
+       if (!bus)
+               return;
+
+       priv = get_bus_priv(bus);
+
+       qtnf_core_detach(bus);
+       qtnf_bus_data_rx_stop(bus);
+       netif_napi_del(&bus->mux_napi);
+
+       flush_workqueue(priv->workqueue);
+       destroy_workqueue(priv->workqueue);
+       tasklet_kill(&priv->reclaim_tq);
+       sysfs_remove_group(&pdev->dev.kobj, &qtnf_attrs_group);
+
+       qtnf_pcie_free_shm_ipc(priv);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int qtnf_pcie_suspend(struct device *dev)
+{
+       return -ENOSYS;
+}
+
+static int qtnf_pcie_resume(struct device *dev)
+{
+       return -ENOSYS;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_SLEEP
+/* Power Management Hooks */
+static SIMPLE_DEV_PM_OPS(qtnf_pcie_pm_ops, qtnf_pcie_suspend,
+                        qtnf_pcie_resume);
+#endif
+
+static struct pci_device_id qtnf_pcie_devid_table[] = {
+       {
+               PCIE_VENDOR_ID_QUANTENNA, PCIE_DEVICE_ID_QTN_PEARL,
+               PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+       },
+       { },
+};
+
+MODULE_DEVICE_TABLE(pci, qtnf_pcie_devid_table);
+
+static struct pci_driver qtnf_pcie_drv_data = {
+       .name = "qtnfmac_pcie",
+       .id_table = qtnf_pcie_devid_table,
+       .probe = qtnf_pcie_probe,
+       .remove = qtnf_pcie_remove,
+#ifdef CONFIG_PM_SLEEP
+       .driver = {
+               .pm = &qtnf_pcie_pm_ops,
+       },
+#endif
+};
+
+static int __init qtnf_pcie_register(void)
+{
+       int err;
+
+       pr_info("Register Quantenna FullMAC PCIE driver\n");
+       err = pci_register_driver(&qtnf_pcie_drv_data);
+       if (err)
+               pr_err("PCIE driver registration failed, err=%d\n", err);
+
+       return 0;
+}
+
+static void __exit qtnf_pcie_exit(void)
+{
+       pr_info("Unregister Quantenna FullMAC PCIE driver\n");
+       pci_unregister_driver(&qtnf_pcie_drv_data);
+}
+
+module_init(qtnf_pcie_register);
+module_exit(qtnf_pcie_exit);
+
+MODULE_AUTHOR("Quantenna Communications");
+MODULE_DESCRIPTION("Quantenna PCIe bus driver for 802.11 wireless LAN.");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie.h b/drivers/net/wireless/quantenna/qtnfmac/pcie.h
new file mode 100644
index 0000000..93e3a67
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie.h
@@ -0,0 +1,143 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_PCIE_H_
+#define _QTN_FMAC_PCIE_H_
+
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+
+#include "pcie_regs_pearl.h"
+#include "pcie_ipc.h"
+#include "shm_ipc.h"
+
+/* */
+
+struct qtnf_pcie_bus_priv {
+       struct pci_dev  *pdev;
+
+       /* lock for irq configuration changes */
+       spinlock_t irq_lock;
+
+       /* lock for tx operations */
+       spinlock_t tx_lock;
+       u8 msi_enabled;
+       int mps;
+
+       struct workqueue_struct *workqueue;
+       struct tasklet_struct reclaim_tq;
+
+       void __iomem *sysctl_bar;
+       void __iomem *epmem_bar;
+       void __iomem *dmareg_bar;
+
+       struct qtnf_shm_ipc shm_ipc_ep_in;
+       struct qtnf_shm_ipc shm_ipc_ep_out;
+
+       struct qtnf_pcie_bda __iomem *bda;
+       void __iomem *pcie_reg_base;
+
+       u16 tx_bd_num;
+       u16 rx_bd_num;
+
+       struct sk_buff **tx_skb;
+       struct sk_buff **rx_skb;
+
+       struct qtnf_tx_bd *tx_bd_vbase;
+       dma_addr_t tx_bd_pbase;
+
+       struct qtnf_rx_bd *rx_bd_vbase;
+       dma_addr_t rx_bd_pbase;
+
+       unsigned long bd_table_vaddr;
+       dma_addr_t bd_table_paddr;
+       u32 bd_table_len;
+
+       u32 hw_txproc_wr_ptr;
+
+       u16 tx_bd_reclaim_start;
+       u16 tx_bd_index;
+       u32 tx_queue_len;
+
+       u16 rx_bd_index;
+
+       u32 pcie_irq_mask;
+
+       /* diagnostics stats */
+       u32 pcie_irq_count;
+       u32 tx_full_count;
+};
+
+/* alignment helper functions */
+
+static __always_inline unsigned long
+align_up_off(unsigned long val, unsigned long step)
+{
+       return (((val + (step - 1)) & (~(step - 1))) - val);
+}
+
+static __always_inline unsigned long
+align_down_off(unsigned long val, unsigned long step)
+{
+       return ((val) & ((step) - 1));
+}
+
+static __always_inline unsigned long
+align_val_up(unsigned long val, unsigned long step)
+{
+       return ((val + step - 1) & (~(step - 1)));
+}
+
+static __always_inline unsigned long
+align_val_down(unsigned long val, unsigned long step)
+{
+       return (val & (~(step - 1)));
+}
+
+static __always_inline void *
+align_buf_dma(void *addr)
+{
+       return (void *)align_val_up((unsigned long)addr,
+                                   dma_get_cache_alignment());
+}
+
+static __always_inline unsigned long
+align_buf_dma_offset(void *addr)
+{
+       return (align_buf_dma(addr) - addr);
+}
+
+static __always_inline void *
+align_buf_cache(void *addr)
+{
+       return (void *)align_val_down((unsigned long)addr,
+                                     dma_get_cache_alignment());
+}
+
+static __always_inline unsigned long
+align_buf_cache_offset(void *addr)
+{
+       return (addr - align_buf_cache(addr));
+}
+
+static __always_inline unsigned long
+align_buf_cache_size(void *addr, unsigned long size)
+{
+       return align_val_up(size + align_buf_cache_offset(addr),
+                           dma_get_cache_alignment());
+}
+
+#endif /* _QTN_FMAC_PCIE_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pcie_ipc.h
new file mode 100644
index 0000000..f0ba5e6
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie_ipc.h
@@ -0,0 +1,144 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_PCIE_IPC_H_
+#define _QTN_FMAC_PCIE_IPC_H_
+
+#include <linux/types.h>
+
+#include "shm_ipc_defs.h"
+
+/* */
+
+#define PCIE_HDP_INT_RX_BITS (0                \
+       | PCIE_HDP_INT_EP_TXDMA         \
+       | PCIE_HDP_INT_EP_TXEMPTY       \
+       )
+
+#define PCIE_HDP_INT_TX_BITS (0                \
+       | PCIE_HDP_INT_EP_RXDMA         \
+       )
+
+#if BITS_PER_LONG == 64
+#define QTN_HOST_HI32(a)       ((u32)(((u64)a) >> 32))
+#define QTN_HOST_LO32(a)       ((u32)(((u64)a) & 0xffffffffUL))
+#define QTN_HOST_ADDR(h, l)    ((((u64)h) << 32) | ((u64)l))
+#elif BITS_PER_LONG == 32
+#define QTN_HOST_HI32(a)       0
+#define QTN_HOST_LO32(a)       ((u32)(((u32)a) & 0xffffffffUL))
+#define QTN_HOST_ADDR(h, l)    ((u32)l)
+#else
+#error Unexpected BITS_PER_LONG value
+#endif
+
+/* */
+
+#define QTN_SYSCTL_BAR 0
+#define QTN_SHMEM_BAR  2
+#define QTN_DMA_BAR    3
+
+#define QTN_PCIE_BDA_VERSION           0x1002
+
+/* */
+
+#define PCIE_BDA_NAMELEN               32
+#define PCIE_HHBM_MAX_SIZE             512
+
+#define SKB_BUF_SIZE           2048
+
+/* */
+
+#define QTN_PCIE_BOARDFLG      "PCIEQTN"
+#define QTN_PCIE_FW_DLMASK     0xF
+#define QTN_PCIE_FW_BUFSZ      2048
+
+#define QTN_ENET_ADDR_LENGTH   6
+
+/* */
+
+#define QTN_TXDONE_MASK                ((u32)0x80000000)
+#define QTN_GET_LEN(x)         ((x) & 0xFFFF)
+
+#define QTN_PCIE_TX_DESC_LEN_MASK      0xFFFF
+#define QTN_PCIE_TX_DESC_LEN_SHIFT     0
+#define QTN_PCIE_TX_DESC_PORT_MASK     0xF
+#define QTN_PCIE_TX_DESC_PORT_SHIFT    16
+#define QTN_PCIE_TX_DESC_TQE_BIT       BIT(24)
+
+#define QTN_EP_LHOST_TQE_PORT  4
+
+/* */
+
+enum qtnf_pcie_bda_ipc_flags {
+       QTN_PCIE_IPC_FLAG_HBM_MAGIC     = BIT(0),
+       QTN_PCIE_IPC_FLAG_SHM_PIO       = BIT(1),
+};
+
+struct qtnf_pcie_bda {
+       __le16 bda_len;
+       __le16 bda_version;
+       __le32 bda_pci_endian;
+       __le32 bda_ep_state;
+       __le32 bda_rc_state;
+       __le32 bda_dma_mask;
+       __le32 bda_msi_addr;
+       __le32 bda_flashsz;
+       u8 bda_boardname[PCIE_BDA_NAMELEN];
+       __le32 bda_rc_msi_enabled;
+       __le32 bda_hhbm_list[PCIE_HHBM_MAX_SIZE];
+       __le32 bda_dsbw_start_index;
+       __le32 bda_dsbw_end_index;
+       __le32 bda_dsbw_total_bytes;
+       __le32 bda_rc_tx_bd_base;
+       __le32 bda_rc_tx_bd_num;
+       u8 bda_pcie_mac[QTN_ENET_ADDR_LENGTH];
+       struct qtnf_shm_ipc_region bda_shm_reg1 __aligned(4096); /* host TX */
+       struct qtnf_shm_ipc_region bda_shm_reg2 __aligned(4096); /* host RX */
+} __packed;
+
+struct qtnf_tx_bd {
+       __le32 addr;
+       __le32 addr_h;
+       __le32 info;
+       __le32 info_h;
+} __packed;
+
+struct qtnf_rx_bd {
+       __le32 addr;
+       __le32 addr_h;
+       __le32 info;
+       __le32 info_h;
+       __le32 next_ptr;
+       __le32 next_ptr_h;
+} __packed;
+
+enum qtnf_fw_loadtype {
+       QTN_FW_DBEGIN,
+       QTN_FW_DSUB,
+       QTN_FW_DEND,
+       QTN_FW_CTRL
+};
+
+struct qtnf_pcie_fw_hdr {
+       u8 boardflg[8];
+       __le32 fwsize;
+       __le32 seqnum;
+       __le32 type;
+       __le32 pktlen;
+       __le32 crc;
+} __packed;
+
+#endif /* _QTN_FMAC_PCIE_IPC_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
new file mode 100644
index 0000000..8ed35ba
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -0,0 +1,71 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include <linux/nl80211.h>
+
+#include "qlink_util.h"
+
+u16 qlink_iface_type_mask_to_nl(u16 qlink_mask)
+{
+       u16 result = 0;
+
+       if (qlink_mask & QLINK_IFTYPE_AP)
+               result |= BIT(NL80211_IFTYPE_AP);
+
+       if (qlink_mask & QLINK_IFTYPE_STATION)
+               result |= BIT(NL80211_IFTYPE_STATION);
+
+       if (qlink_mask & QLINK_IFTYPE_ADHOC)
+               result |= BIT(NL80211_IFTYPE_ADHOC);
+
+       if (qlink_mask & QLINK_IFTYPE_MONITOR)
+               result |= BIT(NL80211_IFTYPE_MONITOR);
+
+       if (qlink_mask & QLINK_IFTYPE_WDS)
+               result |= BIT(NL80211_IFTYPE_WDS);
+
+       return result;
+}
+
+u8 qlink_chan_width_mask_to_nl(u16 qlink_mask)
+{
+       u8 result = 0;
+
+       if (qlink_mask & QLINK_CHAN_WIDTH_5)
+               result |= BIT(NL80211_CHAN_WIDTH_5);
+
+       if (qlink_mask & QLINK_CHAN_WIDTH_10)
+               result |= BIT(NL80211_CHAN_WIDTH_10);
+
+       if (qlink_mask & QLINK_CHAN_WIDTH_20_NOHT)
+               result |= BIT(NL80211_CHAN_WIDTH_20_NOHT);
+
+       if (qlink_mask & QLINK_CHAN_WIDTH_20)
+               result |= BIT(NL80211_CHAN_WIDTH_20);
+
+       if (qlink_mask & QLINK_CHAN_WIDTH_40)
+               result |= BIT(NL80211_CHAN_WIDTH_40);
+
+       if (qlink_mask & QLINK_CHAN_WIDTH_80)
+               result |= BIT(NL80211_CHAN_WIDTH_80);
+
+       if (qlink_mask & QLINK_CHAN_WIDTH_80P80)
+               result |= BIT(NL80211_CHAN_WIDTH_80P80);
+
+       if (qlink_mask & QLINK_CHAN_WIDTH_160)
+               result |= BIT(NL80211_CHAN_WIDTH_160);
+
+       return result;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
new file mode 100644
index 0000000..d2a7433
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -0,0 +1,87 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_QLINK_UTIL_H_
+#define _QTN_FMAC_QLINK_UTIL_H_
+
+#include <linux/types.h>
+#include <linux/skbuff.h>
+#include <asm/unaligned.h>
+
+#include "qlink.h"
+
+static inline void qtnf_cmd_skb_put_action(struct sk_buff *skb, u16 action)
+{
+       __le16 *buf_ptr;
+
+       buf_ptr = (__le16 *)skb_put(skb, sizeof(action));
+       *buf_ptr = cpu_to_le16(action);
+}
+
+static inline void qtnf_cmd_skb_put_tlv_arr(struct sk_buff *skb,
+                                           u16 tlv_id, const u8 arr[],
+                                           size_t arr_len)
+{
+       struct qlink_tlv_hdr *hdr =
+                       (void *)skb_put(skb, sizeof(*hdr) + arr_len);
+
+       hdr->type = cpu_to_le16(tlv_id);
+       hdr->len = cpu_to_le16(arr_len);
+       memcpy(hdr->val, arr, arr_len);
+}
+
+static inline void qtnf_cmd_skb_put_tlv_u8(struct sk_buff *skb, u16 tlv_id,
+                                          u8 value)
+{
+       struct qlink_tlv_hdr *hdr =
+                       (void *)skb_put(skb, sizeof(*hdr) + sizeof(value));
+
+       hdr->type = cpu_to_le16(tlv_id);
+       hdr->len = cpu_to_le16(sizeof(value));
+       *hdr->val = value;
+}
+
+static inline void qtnf_cmd_skb_put_tlv_u16(struct sk_buff *skb,
+                                           u16 tlv_id, u16 value)
+{
+       struct qlink_tlv_hdr *hdr =
+                       (void *)skb_put(skb, sizeof(*hdr) + sizeof(value));
+       __le16 tmp = cpu_to_le16(value);
+
+       hdr->type = cpu_to_le16(tlv_id);
+       hdr->len = cpu_to_le16(sizeof(value));
+       memcpy(hdr->val, &tmp, sizeof(tmp));
+}
+
+static inline u64 qtnf_get_unaligned_le64(const __le64 *ptr)
+{
+       return le64_to_cpu(get_unaligned(ptr));
+}
+
+static inline u32 qtnf_get_unaligned_le32(const __le32 *ptr)
+{
+       return le32_to_cpu(get_unaligned(ptr));
+}
+
+static inline u16 qtnf_get_unaligned_le16(const __le16 *ptr)
+{
+       return le16_to_cpu(get_unaligned(ptr));
+}
+
+u16 qlink_iface_type_mask_to_nl(u16 qlink_mask);
+u8 qlink_chan_width_mask_to_nl(u16 qlink_mask);
+
+#endif /* _QTN_FMAC_QLINK_UTIL_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
new file mode 100644
index 0000000..282281f
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
@@ -0,0 +1,169 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include <linux/types.h>
+#include <linux/io.h>
+
+#include "shm_ipc.h"
+
+static bool qtnf_shm_ipc_has_new_data(struct qtnf_shm_ipc *ipc)
+{
+       const u32 flags = readl(&ipc->shm_region->headroom.hdr.flags);
+
+       return (flags & QTNF_SHM_IPC_NEW_DATA);
+}
+
+static void qtnf_shm_handle_new_data(struct qtnf_shm_ipc *ipc)
+{
+       size_t size;
+       bool rx_buff_ok = true;
+       struct qtnf_shm_ipc_region_header __iomem *shm_reg_hdr;
+
+       shm_reg_hdr = &ipc->shm_region->headroom.hdr;
+
+       size = readw(&shm_reg_hdr->data_len);
+
+       if (unlikely(size == 0 || size > QTN_IPC_MAX_DATA_SZ)) {
+               pr_err("%s: wrong rx packet size: %zu\n", __func__, size);
+               rx_buff_ok = false;
+       } else {
+               memcpy_fromio(ipc->rx_data, ipc->shm_region->data, size);
+       }
+
+       writel(QTNF_SHM_IPC_ACK, &shm_reg_hdr->flags);
+       readl(&shm_reg_hdr->flags); /* flush PCIe write */
+
+       ipc->interrupt.fn(ipc->interrupt.arg);
+
+       if (likely(rx_buff_ok)) {
+               ipc->rx_packet_count++;
+               ipc->rx_callback.fn(ipc->rx_callback.arg, ipc->rx_data, size);
+       }
+}
+
+static void qtnf_shm_ipc_irq_work(struct work_struct *work)
+{
+       struct qtnf_shm_ipc *ipc = container_of(work, struct qtnf_shm_ipc,
+                                               irq_work);
+
+       while (qtnf_shm_ipc_has_new_data(ipc))
+               qtnf_shm_handle_new_data(ipc);
+}
+
+static void qtnf_shm_ipc_irq_inbound_handler(struct qtnf_shm_ipc *ipc)
+{
+       u32 flags;
+
+       flags = readl(&ipc->shm_region->headroom.hdr.flags);
+
+       if (flags & QTNF_SHM_IPC_NEW_DATA)
+               queue_work(ipc->workqueue, &ipc->irq_work);
+}
+
+static void qtnf_shm_ipc_irq_outbound_handler(struct qtnf_shm_ipc *ipc)
+{
+       u32 flags;
+
+       if (!READ_ONCE(ipc->waiting_for_ack))
+               return;
+
+       flags = readl(&ipc->shm_region->headroom.hdr.flags);
+
+       if (flags & QTNF_SHM_IPC_ACK) {
+               WRITE_ONCE(ipc->waiting_for_ack, 0);
+               complete(&ipc->tx_completion);
+       }
+}
+
+int qtnf_shm_ipc_init(struct qtnf_shm_ipc *ipc,
+                     enum qtnf_shm_ipc_direction direction,
+                     struct qtnf_shm_ipc_region __iomem *shm_region,
+                     struct workqueue_struct *workqueue,
+                     const struct qtnf_shm_ipc_int *interrupt,
+                     const struct qtnf_shm_ipc_rx_callback *rx_callback)
+{
+       BUILD_BUG_ON(offsetof(struct qtnf_shm_ipc_region, data) !=
+                    QTN_IPC_REG_HDR_SZ);
+       BUILD_BUG_ON(sizeof(struct qtnf_shm_ipc_region) > QTN_IPC_REG_SZ);
+
+       ipc->shm_region = shm_region;
+       ipc->direction = direction;
+       ipc->interrupt = *interrupt;
+       ipc->rx_callback = *rx_callback;
+       ipc->tx_packet_count = 0;
+       ipc->rx_packet_count = 0;
+       ipc->workqueue = workqueue;
+       ipc->waiting_for_ack = 0;
+       ipc->tx_timeout_count = 0;
+
+       switch (direction) {
+       case QTNF_SHM_IPC_OUTBOUND:
+               ipc->irq_handler = qtnf_shm_ipc_irq_outbound_handler;
+               break;
+       case QTNF_SHM_IPC_INBOUND:
+               ipc->irq_handler = qtnf_shm_ipc_irq_inbound_handler;
+               break;
+       default:
+               return -EINVAL;
+       }
+
+       INIT_WORK(&ipc->irq_work, qtnf_shm_ipc_irq_work);
+       init_completion(&ipc->tx_completion);
+
+       return 0;
+}
+
+void qtnf_shm_ipc_free(struct qtnf_shm_ipc *ipc)
+{
+       complete_all(&ipc->tx_completion);
+}
+
+int qtnf_shm_ipc_send(struct qtnf_shm_ipc *ipc, const u8 *buf, size_t size)
+{
+       int ret = 0;
+       struct qtnf_shm_ipc_region_header __iomem *shm_reg_hdr;
+
+       shm_reg_hdr = &ipc->shm_region->headroom.hdr;
+
+       if (unlikely(size > QTN_IPC_MAX_DATA_SZ))
+               return -E2BIG;
+
+       ipc->tx_packet_count++;
+
+       writew(size, &shm_reg_hdr->data_len);
+       memcpy_toio(ipc->shm_region->data, buf, size);
+
+       WRITE_ONCE(ipc->waiting_for_ack, 1);
+
+       wmb(); /* sync previous writes before announcing new data ready */
+
+       writel(QTNF_SHM_IPC_NEW_DATA, &shm_reg_hdr->flags);
+       readl(&shm_reg_hdr->flags); /* flush PCIe write */
+
+       ipc->interrupt.fn(ipc->interrupt.arg);
+
+       if (!wait_for_completion_timeout(&ipc->tx_completion,
+                                        QTN_SHM_IPC_ACK_TIMEOUT)) {
+               ret = -ETIMEDOUT;
+               ipc->tx_timeout_count++;
+               pr_err("%s: TX ACK timeout\n", __func__);
+       }
+
+       /* now we're not waiting for ACK even in case of timeout */
+       WRITE_ONCE(ipc->waiting_for_ack, 0);
+
+       return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
new file mode 100644
index 0000000..faddf40
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
@@ -0,0 +1,80 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_SHM_IPC_H_
+#define _QTN_FMAC_SHM_IPC_H_
+
+#include <linux/workqueue.h>
+#include <linux/completion.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+#include "shm_ipc_defs.h"
+
+#define QTN_SHM_IPC_ACK_TIMEOUT                (2 * HZ)
+
+struct qtnf_shm_ipc_int {
+       void (*fn)(void *arg);
+       void *arg;
+};
+
+struct qtnf_shm_ipc_rx_callback {
+       void (*fn)(void *arg, const u8 *buf, size_t len);
+       void *arg;
+};
+
+enum qtnf_shm_ipc_direction {
+       QTNF_SHM_IPC_OUTBOUND           = BIT(0),
+       QTNF_SHM_IPC_INBOUND            = BIT(1),
+};
+
+struct qtnf_shm_ipc {
+       struct qtnf_shm_ipc_region __iomem *shm_region;
+       enum qtnf_shm_ipc_direction direction;
+       size_t tx_packet_count;
+       size_t rx_packet_count;
+
+       size_t tx_timeout_count;
+
+       u8 waiting_for_ack;
+
+       u8 rx_data[QTN_IPC_MAX_DATA_SZ] __aligned(sizeof(u32));
+
+       struct qtnf_shm_ipc_int interrupt;
+       struct qtnf_shm_ipc_rx_callback rx_callback;
+
+       void (*irq_handler)(struct qtnf_shm_ipc *ipc);
+
+       struct workqueue_struct *workqueue;
+       struct work_struct irq_work;
+       struct completion tx_completion;
+};
+
+int qtnf_shm_ipc_init(struct qtnf_shm_ipc *ipc,
+                     enum qtnf_shm_ipc_direction direction,
+                     struct qtnf_shm_ipc_region __iomem *shm_region,
+                     struct workqueue_struct *workqueue,
+                     const struct qtnf_shm_ipc_int *interrupt,
+                     const struct qtnf_shm_ipc_rx_callback *rx_callback);
+void qtnf_shm_ipc_free(struct qtnf_shm_ipc *ipc);
+int qtnf_shm_ipc_send(struct qtnf_shm_ipc *ipc, const u8 *buf, size_t size);
+
+static inline void qtnf_shm_ipc_irq_handler(struct qtnf_shm_ipc *ipc)
+{
+       ipc->irq_handler(ipc);
+}
+
+#endif /* _QTN_FMAC_SHM_IPC_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/trans.c b/drivers/net/wireless/quantenna/qtnfmac/trans.c
new file mode 100644
index 0000000..fe04722
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/trans.c
@@ -0,0 +1,224 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include <linux/types.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+
+#include "core.h"
+#include "commands.h"
+#include "event.h"
+#include "bus.h"
+
+#define QTNF_DEF_SYNC_CMD_TIMEOUT      (5 * HZ)
+
+int qtnf_trans_send_cmd_with_resp(struct qtnf_bus *bus, struct sk_buff *cmd_skb,
+                                 struct sk_buff **response_skb)
+{
+       struct qtnf_cmd_ctl_node *ctl_node = &bus->trans.curr_cmd;
+       struct qlink_host_cmd *cmd = (void *)cmd_skb->data;
+       int ret = 0;
+       long status;
+       bool resp_not_handled = true;
+       struct sk_buff *resp_skb = NULL;
+
+       if (unlikely(!response_skb))
+               return -EFAULT;
+
+       spin_lock(&ctl_node->resp_lock);
+       ctl_node->seq_num++;
+       cmd->seq_num = cpu_to_le16(ctl_node->seq_num);
+       WARN_ON(ctl_node->resp_skb);
+       ctl_node->waiting_for_resp = true;
+       spin_unlock(&ctl_node->resp_lock);
+
+       ret = qtnf_bus_control_tx(bus, cmd_skb);
+       dev_kfree_skb(cmd_skb);
+
+       if (unlikely(ret))
+               goto out;
+
+       status = wait_for_completion_interruptible_timeout(
+                                               &ctl_node->cmd_resp_completion,
+                                               QTNF_DEF_SYNC_CMD_TIMEOUT);
+
+       spin_lock(&ctl_node->resp_lock);
+       resp_not_handled = ctl_node->waiting_for_resp;
+       resp_skb = ctl_node->resp_skb;
+       ctl_node->resp_skb = NULL;
+       ctl_node->waiting_for_resp = false;
+       spin_unlock(&ctl_node->resp_lock);
+
+       if (unlikely(status <= 0)) {
+               if (status == 0) {
+                       ret = -ETIMEDOUT;
+                       pr_err("%s: response timeout\n", __func__);
+               } else {
+                       ret = -EINTR;
+                       pr_info("%s: interrupted\n", __func__);
+               }
+       }
+
+       if (unlikely(!resp_skb || resp_not_handled)) {
+               if (!ret)
+                       ret = -EFAULT;
+
+               goto out;
+       }
+
+       ret = 0;
+       *response_skb = resp_skb;
+
+out:
+       if (unlikely(resp_skb && resp_not_handled))
+               dev_kfree_skb(resp_skb);
+
+       return ret;
+}
+
+static void qtnf_trans_signal_cmdresp(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+       struct qtnf_cmd_ctl_node *ctl_node = &bus->trans.curr_cmd;
+       const struct qlink_host_cmd *resp = (void *)skb->data;
+       const u16 recvd_seq_num = le16_to_cpu(resp->seq_num);
+
+       spin_lock(&ctl_node->resp_lock);
+
+       if (unlikely(!ctl_node->waiting_for_resp))
+               goto out_err;
+
+       if (unlikely(recvd_seq_num != ctl_node->seq_num))
+               goto out_err;
+
+       ctl_node->resp_skb = skb;
+       ctl_node->waiting_for_resp = false;
+
+       spin_unlock(&ctl_node->resp_lock);
+
+       complete(&ctl_node->cmd_resp_completion);
+       return;
+
+out_err:
+       spin_unlock(&ctl_node->resp_lock);
+       dev_kfree_skb(skb);
+       pr_info("%s: skb dropped\n", __func__);
+}
+
+static int qtnf_trans_event_enqueue(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+       struct qtnf_qlink_transport *trans = &bus->trans;
+
+       if (likely(skb_queue_len(&trans->event_queue) <
+                  trans->event_queue_max_len)) {
+               skb_queue_tail(&trans->event_queue, skb);
+               queue_work(bus->workqueue, &bus->event_work);
+       } else {
+               pr_warn("qtnfmac: event dropped due to queue overflow\n");
+               dev_kfree_skb(skb);
+               return -1;
+       }
+
+       return 0;
+}
+
+void qtnf_trans_init(struct qtnf_bus *bus)
+{
+       struct qtnf_qlink_transport *trans = &bus->trans;
+
+       init_completion(&trans->curr_cmd.cmd_resp_completion);
+       spin_lock_init(&trans->curr_cmd.resp_lock);
+
+       spin_lock(&trans->curr_cmd.resp_lock);
+       trans->curr_cmd.seq_num = 0;
+       trans->curr_cmd.waiting_for_resp = false;
+       trans->curr_cmd.resp_skb = NULL;
+       spin_unlock(&trans->curr_cmd.resp_lock);
+
+       /* Init event handling related fields */
+       skb_queue_head_init(&trans->event_queue);
+       trans->event_queue_max_len = QTNF_MAX_EVENT_QUEUE_LEN;
+}
+
+static void qtnf_trans_free_events(struct qtnf_bus *bus)
+{
+       struct sk_buff_head *event_queue = &bus->trans.event_queue;
+       struct sk_buff *current_event_skb = skb_dequeue(event_queue);
+
+       while (current_event_skb) {
+               dev_kfree_skb_any(current_event_skb);
+               current_event_skb = skb_dequeue(event_queue);
+       }
+}
+
+void qtnf_trans_free(struct qtnf_bus *bus)
+{
+       if (!bus) {
+               pr_err("%s: invalid bus pointer\n", __func__);
+               return;
+       }
+
+       qtnf_trans_free_events(bus);
+}
+
+int qtnf_trans_handle_rx_ctl_packet(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+       const struct qlink_msg_header *header = (void *)skb->data;
+       int ret = -1;
+
+       if (unlikely(skb->len < sizeof(*header))) {
+               pr_warn("%s: packet is too small: %u\n", __func__, skb->len);
+               dev_kfree_skb(skb);
+               return -EINVAL;
+       }
+
+       if (unlikely(skb->len != le16_to_cpu(header->len))) {
+               pr_warn("%s: cmd reply length mismatch: %u != %u\n",
+                       __func__, skb->len, le16_to_cpu(header->len));
+               dev_kfree_skb(skb);
+               return -EFAULT;
+       }
+
+       switch (le16_to_cpu(header->type)) {
+       case QLINK_MSG_TYPE_CMDRSP:
+               if (unlikely(skb->len < sizeof(struct qlink_host_cmd))) {
+                       pr_warn("%s: too short cmd reply received: %u\n",
+                               __func__, skb->len);
+                       dev_kfree_skb(skb);
+                       break;
+               }
+
+               qtnf_trans_signal_cmdresp(bus, skb);
+               break;
+       case QLINK_MSG_TYPE_EVENT:
+               if (unlikely(skb->len < sizeof(struct qlink_event_header))) {
+                       pr_warn("%s: too short event packet received: %u\n",
+                               __func__, skb->len);
+                       dev_kfree_skb(skb);
+                       break;
+               }
+
+               ret = qtnf_trans_event_enqueue(bus, skb);
+               break;
+       default:
+               pr_warn("%s: received packet with unknown type: %x\n",
+                       __func__, le16_to_cpu(header->type));
+               dev_kfree_skb(skb);
+               break;
+       }
+
+       return ret;
+}
+EXPORT_SYMBOL_GPL(qtnf_trans_handle_rx_ctl_packet);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/trans.h b/drivers/net/wireless/quantenna/qtnfmac/trans.h
new file mode 100644
index 0000000..6009221
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/trans.h
@@ -0,0 +1,57 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#ifndef _QTN_FMAC_TRANS_H_
+#define _QTN_FMAC_TRANS_H_
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/mutex.h>
+
+#include "qlink.h"
+
+#define QTNF_CMD_FLAG_RESP_REQ         BIT(0)
+
+#define QTNF_MAX_CMD_BUF_SIZE  2048
+#define QTNF_DEF_CMD_HROOM     4
+
+struct qtnf_bus;
+
+struct qtnf_cmd_ctl_node {
+       struct completion cmd_resp_completion;
+       struct sk_buff *resp_skb;
+       u16 seq_num;
+       bool waiting_for_resp;
+       spinlock_t resp_lock; /* lock for resp_skb & waiting_for_resp changes */
+};
+
+struct qtnf_qlink_transport {
+       struct qtnf_cmd_ctl_node curr_cmd;
+       struct sk_buff_head event_queue;
+       size_t event_queue_max_len;
+};
+
+void qtnf_trans_init(struct qtnf_bus *bus);
+void qtnf_trans_free(struct qtnf_bus *bus);
+
+int qtnf_trans_send_next_cmd(struct qtnf_bus *bus);
+int qtnf_trans_handle_rx_ctl_packet(struct qtnf_bus *bus, struct sk_buff *skb);
+int qtnf_trans_send_cmd_with_resp(struct qtnf_bus *bus,
+                                 struct sk_buff *cmd_skb,
+                                 struct sk_buff **response_skb);
+
+#endif /* _QTN_FMAC_TRANS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.c b/drivers/net/wireless/quantenna/qtnfmac/util.c
new file mode 100644
index 0000000..5a8a174
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.c
@@ -0,0 +1,134 @@
+/**
+ * Copyright (c) 2015-2016 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ **/
+
+#include "util.h"
+
+bool qtnf_ieee80211_check_ie_buf(const u8 *buf, size_t len)
+{
+       const struct qtnf_ieee80211_ie_hdr *ie_hdr = (void *)buf;
+
+       if (!buf || !len)
+               return false;
+
+       while (len >= sizeof(*ie_hdr)) {
+               size_t ie_elem_len = sizeof(*ie_hdr) + ie_hdr->len;
+
+               if (unlikely(len < ie_elem_len))
+                       break;
+
+               len -= ie_elem_len;
+               ie_hdr = (void *)(ie_hdr->info + ie_hdr->len);
+       }
+
+       return len == 0;
+}
+
+void qtnf_sta_list_init(struct qtnf_sta_list *list)
+{
+       if (unlikely(!list))
+               return;
+
+       INIT_LIST_HEAD(&list->head);
+       atomic_set(&list->size, 0);
+}
+
+struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
+                                          const u8 *mac)
+{
+       struct qtnf_sta_node *node;
+
+       if (unlikely(!mac))
+               return NULL;
+
+       list_for_each_entry(node, &list->head, list) {
+               if (ether_addr_equal(node->mac_addr, mac))
+                       return node;
+       }
+
+       return NULL;
+}
+
+struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
+                                                size_t index)
+{
+       struct qtnf_sta_node *node;
+
+       if (qtnf_sta_list_size(list) <= index)
+               return NULL;
+
+       list_for_each_entry(node, &list->head, list) {
+               if (index-- == 0)
+                       return node;
+       }
+
+       return NULL;
+}
+
+struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
+                                       const u8 *mac)
+{
+       struct qtnf_sta_node *node;
+
+       if (unlikely(!mac))
+               return NULL;
+
+       node = qtnf_sta_list_lookup(list, mac);
+
+       if (node)
+               goto done;
+
+       node = kzalloc(sizeof(*node), GFP_KERNEL);
+       if (unlikely(!node))
+               goto done;
+
+       ether_addr_copy(node->mac_addr, mac);
+       list_add_tail(&node->list, &list->head);
+       atomic_inc(&list->size);
+
+done:
+       return node;
+}
+
+bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac)
+{
+       struct qtnf_sta_node *node;
+       bool ret = false;
+
+       node = qtnf_sta_list_lookup(list, mac);
+
+       if (node) {
+               list_del(&node->list);
+               atomic_dec(&list->size);
+               kfree(node);
+               ret = true;
+       }
+
+       return ret;
+}
+
+void qtnf_sta_list_free(struct qtnf_sta_list *list)
+{
+       struct qtnf_sta_node *node, *tmp;
+
+       atomic_set(&list->size, 0);
+
+       list_for_each_entry_safe(node, tmp, &list->head, list) {
+               list_del(&node->list);
+               kfree(node);
+       }
+
+       INIT_LIST_HEAD(&list->head);
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.h b/drivers/net/wireless/quantenna/qtnfmac/util.h
new file mode 100644
index 0000000..76831b4
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2015-2016 Quantenna Communications
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef QTNFMAC_UTIL_H
+#define QTNFMAC_UTIL_H
+
+#include <linux/kernel.h>
+#include "core.h"
+
+struct qtnf_ieee80211_ie_hdr {
+       u8 element_id;
+       u8 len;
+       u8 info[0];
+} __packed;
+
+bool qtnf_ieee80211_check_ie_buf(const u8 *buf, size_t len);
+
+void qtnf_sta_list_init(struct qtnf_sta_list *list);
+
+struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
+                                          const u8 *mac);
+struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
+                                                size_t index);
+struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
+                                       const u8 *mac);
+bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac);
+
+void qtnf_sta_list_free(struct qtnf_sta_list *list);
+
+static inline size_t qtnf_sta_list_size(const struct qtnf_sta_list *list)
+{
+       return atomic_read(&list->size);
+}
+
+static inline bool qtnf_sta_list_empty(const struct qtnf_sta_list *list)
+{
+       return list_empty(&list->head);
+}
+
+#endif /* QTNFMAC_UTIL_H */
--
1.9.1



This email, including its contents and any attachment(s), may contain confidential information of Quantenna Communications, Inc. and is solely for the intended recipient(s). If you may have received this in error, please contact the sender and permanently delete this email, its contents and any attachment(s).
