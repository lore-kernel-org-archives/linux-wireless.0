Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0073.outbound.protection.outlook.com ([104.47.33.73]:3680
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756370AbdEKVv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 17:51:27 -0400
From: <igor.mitsyanko.os@quantenna.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna chipsets
Date: Thu, 11 May 2017 14:51:01 -0700
Message-ID: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com> (sfid-20170511_235138_575600_618E8812)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

This patch adds support for new FullMAC WiFi driver for Quantenna
QSR10G chipsets.

QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
5G WMAC supports 160M, 8x8 configuration. FW supports
up to 8 concurrent virtual interfaces on each WMAC.

Patch introduces 2 new drivers:
- qtnfmac.ko for interfacing with kernel wireless core
- qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface

Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
Signed-off-by: Bindu Therthala <btherthala@quantenna.com>
Signed-off-by: Huizhao Wang <hwang@quantenna.com>
Signed-off-by: Kamlesh Rath <krath@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
Changelist V5->V6:
1. Rebase to wireless-next master (add_virtual_intf, change_virtual_intf
   signature chnages are the only conflicts).
2. Add interface information to error/debug messages. This required to
   modify relatevly high number of code lines, but changes are
   mechanical.

 MAINTAINERS                                        |    8 +
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/quantenna/Kconfig             |   16 +
 drivers/net/wireless/quantenna/Makefile            |    6 +
 drivers/net/wireless/quantenna/qtnfmac/Kconfig     |   19 +
 drivers/net/wireless/quantenna/qtnfmac/Makefile    |   31 +
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |  139 ++
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  995 ++++++++++
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h  |   43 +
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 1982 ++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   74 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  618 ++++++
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  173 ++
 drivers/net/wireless/quantenna/qtnfmac/debug.c     |   46 +
 drivers/net/wireless/quantenna/qtnfmac/debug.h     |   50 +
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  452 +++++
 drivers/net/wireless/quantenna/qtnfmac/event.h     |   27 +
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 1378 ++++++++++++++
 .../quantenna/qtnfmac/pearl/pcie_bus_priv.h        |   89 +
 .../wireless/quantenna/qtnfmac/pearl/pcie_ipc.h    |  158 ++
 .../quantenna/qtnfmac/pearl/pcie_regs_pearl.h      |  353 ++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  901 +++++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |   71 +
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   80 +
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    |   32 +
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c   |  176 ++
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h   |   80 +
 .../net/wireless/quantenna/qtnfmac/shm_ipc_defs.h  |   46 +
 drivers/net/wireless/quantenna/qtnfmac/trans.c     |  224 +++
 drivers/net/wireless/quantenna/qtnfmac/trans.h     |   57 +
 drivers/net/wireless/quantenna/qtnfmac/util.c      |  114 ++
 drivers/net/wireless/quantenna/qtnfmac/util.h      |   45 +
 33 files changed, 8485 insertions(+)
 create mode 100644 drivers/net/wireless/quantenna/Kconfig
 create mode 100644 drivers/net/wireless/quantenna/Makefile
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/Kconfig
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/Makefile
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/bus.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/commands.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/commands.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/core.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/core.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/debug.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/debug.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/event.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/event.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/qlink.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/trans.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/trans.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/util.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/util.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 28ea78b..2d2bf30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10444,6 +10444,14 @@ L:	qemu-devel@nongnu.org
 S:	Maintained
 F:	drivers/firmware/qemu_fw_cfg.c
 
+QUANTENNA QTNFMAC WIRELESS DRIVER
+M:   Igor Mitsyanko <imitsyanko@quantenna.com>
+M:   Avinash Patil <avinashp@quantenna.com>
+M:   Sergey Matyukevich <smatyukevich@quantenna.com>
+L:   linux-wireless@vger.kernel.org
+S:   Maintained
+F:   drivers/net/wireless/quantenna
+
 RADOS BLOCK DEVICE (RBD)
 M:	Ilya Dryomov <idryomov@gmail.com>
 M:	Sage Weil <sage@redhat.com>
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8f5a3f4..166920a 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -45,6 +45,7 @@ source "drivers/net/wireless/rsi/Kconfig"
 source "drivers/net/wireless/st/Kconfig"
 source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zydas/Kconfig"
+source "drivers/net/wireless/quantenna/Kconfig"
 
 config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4GHz wireless support"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index f00d429..54b41ac 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_WLAN_VENDOR_RSI) += rsi/
 obj-$(CONFIG_WLAN_VENDOR_ST) += st/
 obj-$(CONFIG_WLAN_VENDOR_TI) += ti/
 obj-$(CONFIG_WLAN_VENDOR_ZYDAS) += zydas/
+obj-$(CONFIG_WLAN_VENDOR_QUANTENNA) += quantenna/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
diff --git a/drivers/net/wireless/quantenna/Kconfig b/drivers/net/wireless/quantenna/Kconfig
new file mode 100644
index 0000000..3094365
--- /dev/null
+++ b/drivers/net/wireless/quantenna/Kconfig
@@ -0,0 +1,16 @@
+config WLAN_VENDOR_QUANTENNA
+	bool "Quantenna wireless cards support"
+	default y
+	---help---
+	  If you have a wireless card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about  cards. If you say Y, you will be asked for
+	  your specific card in the following questions.
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
+obj-$(CONFIG_QTNFMAC)	+= qtnfmac/
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Kconfig b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
new file mode 100644
index 0000000..025fa60
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
@@ -0,0 +1,19 @@
+config QTNFMAC
+	tristate
+	depends on QTNFMAC_PEARL_PCIE
+	default m if QTNFMAC_PEARL_PCIE=m
+	default y if QTNFMAC_PEARL_PCIE=y
+
+config QTNFMAC_PEARL_PCIE
+	tristate "Quantenna QSR10g PCIe support"
+	default n
+	depends on HAS_DMA && PCI && CFG80211
+	select QTNFMAC
+	select FW_LOADER
+	select CRC32
+	---help---
+	  This option adds support for wireless adapters based on Quantenna
+	  802.11ac QSR10g (aka Pearl) FullMAC chipset running over PCIe.
+
+	  If you choose to build it as a module, two modules will be built:
+	  qtnfmac.ko and qtnfmac_pearl_pcie.ko.
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/wireless/quantenna/qtnfmac/Makefile
new file mode 100644
index 0000000..0d618e5
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -0,0 +1,31 @@
+#
+# Copyright (c) 2015-2016 Quantenna Communications, Inc.
+# All rights reserved.
+#
+
+ccflags-y += \
+	-Idrivers/net/wireless/quantenna/qtnfmac
+
+obj-$(CONFIG_QTNFMAC) += qtnfmac.o
+qtnfmac-objs += \
+	core.o \
+	commands.o \
+	trans.o \
+	cfg80211.o \
+	event.o \
+	util.o \
+	qlink_util.o
+
+#
+
+obj-$(CONFIG_QTNFMAC_PEARL_PCIE) += qtnfmac_pearl_pcie.o
+
+qtnfmac_pearl_pcie-objs += \
+	shm_ipc.o \
+	pearl/pcie.o
+
+qtnfmac_pearl_pcie-$(CONFIG_DEBUG_FS) += debug.o
+
+#
+
+ccflags-y += -D__CHECK_ENDIAN
diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
new file mode 100644
index 0000000..dda0500
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -0,0 +1,139 @@
+/*
+ * Copyright (c) 2015 Quantenna Communications
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
+#include <linux/netdevice.h>
+#include <linux/workqueue.h>
+
+#define QTNF_MAX_MAC		3
+
+enum qtnf_fw_state {
+	QTNF_FW_STATE_RESET,
+	QTNF_FW_STATE_FW_DNLD_DONE,
+	QTNF_FW_STATE_BOOT_DONE,
+	QTNF_FW_STATE_ACTIVE,
+	QTNF_FW_STATE_DEAD,
+};
+
+struct qtnf_bus;
+
+struct qtnf_bus_ops {
+	/* mgmt methods */
+	int (*preinit)(struct qtnf_bus *);
+	void (*stop)(struct qtnf_bus *);
+
+	/* control path methods */
+	int (*control_tx)(struct qtnf_bus *, struct sk_buff *);
+
+	/* data xfer methods */
+	int (*data_tx)(struct qtnf_bus *, struct sk_buff *);
+	void (*data_tx_timeout)(struct qtnf_bus *, struct net_device *);
+	void (*data_rx_start)(struct qtnf_bus *);
+	void (*data_rx_stop)(struct qtnf_bus *);
+};
+
+struct qtnf_bus {
+	struct device *dev;
+	enum qtnf_fw_state fw_state;
+	u32 chip;
+	u32 chiprev;
+	const struct qtnf_bus_ops *bus_ops;
+	struct qtnf_wmac *mac[QTNF_MAX_MAC];
+	struct qtnf_qlink_transport trans;
+	struct qtnf_hw_info hw_info;
+	char fwname[32];
+	struct napi_struct mux_napi;
+	struct net_device mux_dev;
+	struct completion request_firmware_complete;
+	struct workqueue_struct *workqueue;
+	struct work_struct event_work;
+	struct mutex bus_lock; /* lock during command/event processing */
+	struct dentry *dbg_dir;
+	/* bus private data */
+	char bus_priv[0] __aligned(sizeof(void *));
+};
+
+static inline void *get_bus_priv(struct qtnf_bus *bus)
+{
+	if (WARN(!bus, "qtnfmac: invalid bus pointer"))
+		return NULL;
+
+	return &bus->bus_priv;
+}
+
+/* callback wrappers */
+
+static inline int qtnf_bus_preinit(struct qtnf_bus *bus)
+{
+	if (!bus->bus_ops->preinit)
+		return 0;
+	return bus->bus_ops->preinit(bus);
+}
+
+static inline void qtnf_bus_stop(struct qtnf_bus *bus)
+{
+	if (!bus->bus_ops->stop)
+		return;
+	bus->bus_ops->stop(bus);
+}
+
+static inline int qtnf_bus_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	return bus->bus_ops->data_tx(bus, skb);
+}
+
+static inline void
+qtnf_bus_data_tx_timeout(struct qtnf_bus *bus, struct net_device *ndev)
+{
+	return bus->bus_ops->data_tx_timeout(bus, ndev);
+}
+
+static inline int qtnf_bus_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	return bus->bus_ops->control_tx(bus, skb);
+}
+
+static inline void qtnf_bus_data_rx_start(struct qtnf_bus *bus)
+{
+	return bus->bus_ops->data_rx_start(bus);
+}
+
+static inline void qtnf_bus_data_rx_stop(struct qtnf_bus *bus)
+{
+	return bus->bus_ops->data_rx_stop(bus);
+}
+
+static __always_inline void qtnf_bus_lock(struct qtnf_bus *bus)
+{
+	mutex_lock(&bus->bus_lock);
+}
+
+static __always_inline void qtnf_bus_unlock(struct qtnf_bus *bus)
+{
+	mutex_unlock(&bus->bus_lock);
+}
+
+/* interface functions from common layer */
+
+void qtnf_rx_frame(struct device *dev, struct sk_buff *rxp);
+int qtnf_core_attach(struct qtnf_bus *bus);
+void qtnf_core_detach(struct qtnf_bus *bus);
+void qtnf_txflowblock(struct device *dev, bool state);
+void qtnf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
+
+#endif /* QTNFMAC_BUS_H */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
new file mode 100644
index 0000000..fc0ce2c
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -0,0 +1,995 @@
+/*
+ * Copyright (c) 2012-2012 Quantenna Communications, Inc.
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
+ */
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
+static struct ieee80211_rate qtnf_rates_2g[] = {
+	{.bitrate = 10, .hw_value = 2, },
+	{.bitrate = 20, .hw_value = 4, },
+	{.bitrate = 55, .hw_value = 11, },
+	{.bitrate = 110, .hw_value = 22, },
+	{.bitrate = 60, .hw_value = 12, },
+	{.bitrate = 90, .hw_value = 18, },
+	{.bitrate = 120, .hw_value = 24, },
+	{.bitrate = 180, .hw_value = 36, },
+	{.bitrate = 240, .hw_value = 48, },
+	{.bitrate = 360, .hw_value = 72, },
+	{.bitrate = 480, .hw_value = 96, },
+	{.bitrate = 540, .hw_value = 108, },
+};
+
+/* Supported rates to be advertised to the cfg80211 */
+static struct ieee80211_rate qtnf_rates_5g[] = {
+	{.bitrate = 60, .hw_value = 12, },
+	{.bitrate = 90, .hw_value = 18, },
+	{.bitrate = 120, .hw_value = 24, },
+	{.bitrate = 180, .hw_value = 36, },
+	{.bitrate = 240, .hw_value = 48, },
+	{.bitrate = 360, .hw_value = 72, },
+	{.bitrate = 480, .hw_value = 96, },
+	{.bitrate = 540, .hw_value = 108, },
+};
+
+/* Supported crypto cipher suits to be advertised to cfg80211 */
+static const u32 qtnf_cipher_suites[] = {
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+	WLAN_CIPHER_SUITE_AES_CMAC,
+};
+
+/* Supported mgmt frame types to be advertised to cfg80211 */
+static const struct ieee80211_txrx_stypes
+qtnf_mgmt_stypes[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_STATION] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+	},
+};
+
+static int
+qtnf_change_virtual_intf(struct wiphy *wiphy,
+			 struct net_device *dev,
+			 enum nl80211_iftype type,
+			 struct vif_params *params)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	u8 *mac_addr;
+	int ret;
+
+	if (params)
+		mac_addr = params->macaddr;
+	else
+		mac_addr = NULL;
+
+	qtnf_scan_done(vif->mac, true);
+
+	ret = qtnf_cmd_send_change_intf_type(vif, type, mac_addr);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to change VIF type: %d\n",
+		       vif->mac->macid, vif->vifid, ret);
+		return ret;
+	}
+
+	vif->wdev.iftype = type;
+	return 0;
+}
+
+int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	struct net_device *netdev =  wdev->netdev;
+	struct qtnf_vif *vif;
+
+	if (WARN_ON(!netdev))
+		return -EFAULT;
+
+	vif = qtnf_netdev_get_priv(wdev->netdev);
+
+	if (qtnf_cmd_send_del_intf(vif))
+		pr_err("VIF%u.%u: failed to delete VIF\n", vif->mac->macid,
+		       vif->vifid);
+
+	/* Stop data */
+	netif_tx_stop_all_queues(netdev);
+	if (netif_carrier_ok(netdev))
+		netif_carrier_off(netdev);
+
+	if (netdev->reg_state == NETREG_REGISTERED)
+		unregister_netdevice(netdev);
+
+	vif->netdev->ieee80211_ptr = NULL;
+	vif->netdev = NULL;
+	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+	eth_zero_addr(vif->mac_addr);
+
+	return 0;
+}
+
+static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
+						  const char *name,
+						  unsigned char name_assign_t,
+						  enum nl80211_iftype type,
+						  struct vif_params *params)
+{
+	struct qtnf_wmac *mac;
+	struct qtnf_vif *vif;
+	u8 *mac_addr = NULL;
+
+	mac = wiphy_priv(wiphy);
+
+	if (!mac)
+		return ERR_PTR(-EFAULT);
+
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+		vif = qtnf_mac_get_free_vif(mac);
+		if (!vif) {
+			pr_err("MAC%u: no free VIF available\n", mac->macid);
+			return ERR_PTR(-EFAULT);
+		}
+
+		eth_zero_addr(vif->mac_addr);
+		vif->bss_priority = QTNF_DEF_BSS_PRIORITY;
+		vif->wdev.wiphy = wiphy;
+		vif->wdev.iftype = type;
+		vif->sta_state = QTNF_STA_DISCONNECTED;
+		break;
+	default:
+		pr_err("MAC%u: unsupported IF type %d\n", mac->macid, type);
+		return ERR_PTR(-ENOTSUPP);
+	}
+
+	if (params)
+		mac_addr = params->macaddr;
+
+	if (qtnf_cmd_send_add_intf(vif, type, mac_addr)) {
+		pr_err("VIF%u.%u: failed to add VIF\n", mac->macid, vif->vifid);
+		goto err_cmd;
+	}
+
+	if (!is_valid_ether_addr(vif->mac_addr)) {
+		pr_err("VIF%u.%u: FW reported bad MAC: %pM\n",
+		       mac->macid, vif->vifid, vif->mac_addr);
+		goto err_mac;
+	}
+
+	if (qtnf_core_net_attach(mac, vif, name, name_assign_t, type)) {
+		pr_err("VIF%u.%u: failed to attach netdev\n", mac->macid,
+		       vif->vifid);
+		goto err_net;
+	}
+
+	vif->wdev.netdev = vif->netdev;
+	return &vif->wdev;
+
+err_net:
+	vif->netdev = NULL;
+err_mac:
+	qtnf_cmd_send_del_intf(vif);
+err_cmd:
+	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+
+	return ERR_PTR(-EFAULT);
+}
+
+static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
+			       const struct cfg80211_beacon_data *info)
+{
+	int ret = 0;
+
+	if (!info->beacon_ies || !info->beacon_ies_len) {
+		ret = qtnf_cmd_send_mgmt_set_appie(vif, QLINK_MGMT_FRAME_BEACON,
+						   NULL, 0);
+	} else {
+		ret = qtnf_cmd_send_mgmt_set_appie(vif, QLINK_MGMT_FRAME_BEACON,
+						   info->beacon_ies,
+						   info->beacon_ies_len);
+	}
+
+	if (ret)
+		goto out;
+
+	if (!info->proberesp_ies || !info->proberesp_ies_len) {
+		ret = qtnf_cmd_send_mgmt_set_appie(vif,
+						   QLINK_MGMT_FRAME_PROBE_RESP,
+						   NULL, 0);
+	} else {
+		ret = qtnf_cmd_send_mgmt_set_appie(vif,
+						   QLINK_MGMT_FRAME_PROBE_RESP,
+						   info->proberesp_ies,
+						   info->proberesp_ies_len);
+	}
+
+	if (ret)
+		goto out;
+
+	if (!info->assocresp_ies || !info->assocresp_ies_len) {
+		ret = qtnf_cmd_send_mgmt_set_appie(vif,
+						   QLINK_MGMT_FRAME_ASSOC_RESP,
+						   NULL, 0);
+	} else {
+		ret = qtnf_cmd_send_mgmt_set_appie(vif,
+						   QLINK_MGMT_FRAME_ASSOC_RESP,
+						   info->assocresp_ies,
+						   info->assocresp_ies_len);
+	}
+
+out:
+	return ret;
+}
+
+static int qtnf_change_beacon(struct wiphy *wiphy, struct net_device *dev,
+			      struct cfg80211_beacon_data *info)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+		pr_err("VIF%u.%u: not started\n", vif->mac->macid, vif->vifid);
+		return -EFAULT;
+	}
+
+	return qtnf_mgmt_set_appie(vif, info);
+}
+
+static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
+			 struct cfg80211_ap_settings *settings)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	struct qtnf_bss_config *bss_cfg;
+	int ret;
+
+	bss_cfg = &vif->bss_cfg;
+
+	memset(bss_cfg, 0, sizeof(*bss_cfg));
+
+	bss_cfg->bcn_period = settings->beacon_interval;
+	bss_cfg->dtim = settings->dtim_period;
+	bss_cfg->auth_type = settings->auth_type;
+	bss_cfg->privacy = settings->privacy;
+
+	bss_cfg->ssid_len = settings->ssid_len;
+	memcpy(&bss_cfg->ssid, settings->ssid, bss_cfg->ssid_len);
+
+	memcpy(&bss_cfg->chandef, &settings->chandef,
+	       sizeof(struct cfg80211_chan_def));
+	memcpy(&bss_cfg->crypto, &settings->crypto,
+	       sizeof(struct cfg80211_crypto_settings));
+
+	ret = qtnf_cmd_send_config_ap(vif);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to push config to FW\n",
+		       vif->mac->macid, vif->vifid);
+		goto out;
+	}
+
+	if (!(vif->bss_status & QTNF_STATE_AP_CONFIG)) {
+		pr_err("VIF%u.%u: AP config failed in FW\n", vif->mac->macid,
+		       vif->vifid);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = qtnf_mgmt_set_appie(vif, &settings->beacon);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to add IEs to beacon\n",
+		       vif->mac->macid, vif->vifid);
+		goto out;
+	}
+
+	ret = qtnf_cmd_send_start_ap(vif);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to start AP\n", vif->mac->macid,
+		       vif->vifid);
+		goto out;
+	}
+
+	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+		pr_err("VIF%u.%u: FW failed to start AP operation\n",
+		       vif->mac->macid, vif->vifid);
+		ret = -EFAULT;
+	}
+
+out:
+	return ret;
+}
+
+static int qtnf_stop_ap(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	ret = qtnf_cmd_send_stop_ap(vif);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to stop AP operation in FW\n",
+		       vif->mac->macid, vif->vifid);
+		vif->bss_status &= ~QTNF_STATE_AP_START;
+		vif->bss_status &= ~QTNF_STATE_AP_CONFIG;
+
+		netif_carrier_off(vif->netdev);
+	}
+
+	return ret;
+}
+
+static int qtnf_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct qtnf_vif *vif;
+	int ret;
+
+	vif = qtnf_mac_get_base_vif(mac);
+	if (!vif) {
+		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
+		return -EFAULT;
+	}
+
+	if (changed & (WIPHY_PARAM_RETRY_LONG | WIPHY_PARAM_RETRY_SHORT)) {
+		pr_err("MAC%u: can't modify retry params\n", mac->macid);
+		return -EOPNOTSUPP;
+	}
+
+	ret = qtnf_cmd_send_update_phy_params(mac, changed);
+	if (ret)
+		pr_err("MAC%u: failed to update PHY params\n", mac->macid);
+
+	return ret;
+}
+
+static void
+qtnf_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
+			 u16 frame_type, bool reg)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(wdev->netdev);
+	u16 mgmt_type;
+	u16 new_mask;
+	u16 qlink_frame_type = 0;
+
+	mgmt_type = (frame_type & IEEE80211_FCTL_STYPE) >> 4;
+
+	if (reg)
+		new_mask = vif->mgmt_frames_bitmask | BIT(mgmt_type);
+	else
+		new_mask = vif->mgmt_frames_bitmask & ~BIT(mgmt_type);
+
+	if (new_mask == vif->mgmt_frames_bitmask)
+		return;
+
+	switch (frame_type & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_PROBE_REQ:
+		qlink_frame_type = QLINK_MGMT_FRAME_PROBE_REQ;
+		break;
+	case IEEE80211_STYPE_ACTION:
+		qlink_frame_type = QLINK_MGMT_FRAME_ACTION;
+		break;
+	default:
+		pr_warn("VIF%u.%u: unsupported frame type: %X\n",
+			vif->mac->macid, vif->vifid,
+			(frame_type & IEEE80211_FCTL_STYPE) >> 4);
+		return;
+	}
+
+	if (qtnf_cmd_send_register_mgmt(vif, qlink_frame_type, reg)) {
+		pr_warn("VIF%u.%u: failed to %sregister mgmt frame type 0x%x\n",
+			vif->mac->macid, vif->vifid, reg ? "" : "un",
+			frame_type);
+		return;
+	}
+
+	vif->mgmt_frames_bitmask = new_mask;
+	pr_debug("VIF%u.%u: %sregistered mgmt frame type 0x%x\n",
+		 vif->mac->macid, vif->vifid, reg ? "" : "un", frame_type);
+}
+
+static int
+qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
+	     struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(wdev->netdev);
+	const struct ieee80211_mgmt *mgmt_frame = (void *)params->buf;
+	u32 short_cookie = prandom_u32();
+	u16 flags = 0;
+
+	*cookie = short_cookie;
+
+	if (params->offchan)
+		flags |= QLINK_MGMT_FRAME_TX_FLAG_OFFCHAN;
+
+	if (params->no_cck)
+		flags |= QLINK_MGMT_FRAME_TX_FLAG_NO_CCK;
+
+	if (params->dont_wait_for_ack)
+		flags |= QLINK_MGMT_FRAME_TX_FLAG_ACK_NOWAIT;
+
+	pr_debug("%s freq:%u; FC:%.4X; DA:%pM; len:%zu; C:%.8X; FL:%.4X\n",
+		 wdev->netdev->name, params->chan->center_freq,
+		 le16_to_cpu(mgmt_frame->frame_control), mgmt_frame->da,
+		 params->len, short_cookie, flags);
+
+	return qtnf_cmd_send_mgmt_frame(vif, short_cookie, flags,
+					params->chan->center_freq,
+					params->buf, params->len);
+}
+
+static int
+qtnf_get_station(struct wiphy *wiphy, struct net_device *dev,
+		 const u8 *mac, struct station_info *sinfo)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+
+	return qtnf_cmd_get_sta_info(vif, mac, sinfo);
+}
+
+static int
+qtnf_dump_station(struct wiphy *wiphy, struct net_device *dev,
+		  int idx, u8 *mac, struct station_info *sinfo)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	const struct qtnf_sta_node *sta_node;
+	int ret;
+
+	sta_node = qtnf_sta_list_lookup_index(&vif->sta_list, idx);
+
+	if (unlikely(!sta_node))
+		return -ENOENT;
+
+	ether_addr_copy(mac, sta_node->mac_addr);
+
+	ret = qtnf_cmd_get_sta_info(vif, sta_node->mac_addr, sinfo);
+
+	if (unlikely(ret == -ENOENT)) {
+		qtnf_sta_list_del(&vif->sta_list, mac);
+		cfg80211_del_sta(vif->netdev, mac, GFP_KERNEL);
+		sinfo->filled = 0;
+	}
+
+	return ret;
+}
+
+static int qtnf_add_key(struct wiphy *wiphy, struct net_device *dev,
+			u8 key_index, bool pairwise, const u8 *mac_addr,
+			struct key_params *params)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	ret = qtnf_cmd_send_add_key(vif, key_index, pairwise, mac_addr, params);
+	if (ret)
+		pr_err("VIF%u.%u: failed to add key: cipher=%x idx=%u pw=%u\n",
+		       vif->mac->macid, vif->vifid, params->cipher, key_index,
+		       pairwise);
+
+	return ret;
+}
+
+static int qtnf_del_key(struct wiphy *wiphy, struct net_device *dev,
+			u8 key_index, bool pairwise, const u8 *mac_addr)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	ret = qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr);
+	if (ret)
+		pr_err("VIF%u.%u: failed to delete key: idx=%u pw=%u\n",
+		       vif->mac->macid, vif->vifid, key_index, pairwise);
+
+	return ret;
+}
+
+static int qtnf_set_default_key(struct wiphy *wiphy, struct net_device *dev,
+				u8 key_index, bool unicast, bool multicast)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	ret = qtnf_cmd_send_set_default_key(vif, key_index, unicast, multicast);
+	if (ret)
+		pr_err("VIF%u.%u: failed to set dflt key: idx=%u uc=%u mc=%u\n",
+		       vif->mac->macid, vif->vifid, key_index, unicast,
+		       multicast);
+
+	return ret;
+}
+
+static int
+qtnf_set_default_mgmt_key(struct wiphy *wiphy, struct net_device *dev,
+			  u8 key_index)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	ret = qtnf_cmd_send_set_default_mgmt_key(vif, key_index);
+	if (ret)
+		pr_err("VIF%u.%u: failed to set default MGMT key: idx=%u\n",
+		       vif->mac->macid, vif->vifid, key_index);
+
+	return ret;
+}
+
+static int
+qtnf_change_station(struct wiphy *wiphy, struct net_device *dev,
+		    const u8 *mac, struct station_parameters *params)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	ret = qtnf_cmd_send_change_sta(vif, mac, params);
+	if (ret)
+		pr_err("VIF%u.%u: failed to change STA %pM\n",
+		       vif->mac->macid, vif->vifid, mac);
+
+	return ret;
+}
+
+static int
+qtnf_del_station(struct wiphy *wiphy, struct net_device *dev,
+		 struct station_del_parameters *params)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	if (params->mac &&
+	    (vif->wdev.iftype == NL80211_IFTYPE_AP) &&
+	    !is_broadcast_ether_addr(params->mac) &&
+	    !qtnf_sta_list_lookup(&vif->sta_list, params->mac))
+		return 0;
+
+	qtnf_scan_done(vif->mac, true);
+
+	ret = qtnf_cmd_send_del_sta(vif, params);
+	if (ret)
+		pr_err("VIF%u.%u: failed to delete STA %pM\n",
+		       vif->mac->macid, vif->vifid, params->mac);
+	return ret;
+}
+
+static int
+qtnf_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	int ret;
+
+	mac->scan_req = request;
+
+	ret = qtnf_cmd_send_scan(mac);
+	if (ret)
+		pr_err("MAC%u: failed to start scan\n", mac->macid);
+
+	return ret;
+}
+
+static int
+qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
+	     struct cfg80211_connect_params *sme)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	struct qtnf_bss_config *bss_cfg;
+	int ret;
+
+	if (vif->wdev.iftype != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (vif->sta_state != QTNF_STA_DISCONNECTED)
+		return -EBUSY;
+
+	bss_cfg = &vif->bss_cfg;
+	memset(bss_cfg, 0, sizeof(*bss_cfg));
+
+	bss_cfg->ssid_len = sme->ssid_len;
+	memcpy(&bss_cfg->ssid, sme->ssid, bss_cfg->ssid_len);
+	bss_cfg->chandef.chan = sme->channel;
+	bss_cfg->auth_type = sme->auth_type;
+	bss_cfg->privacy = sme->privacy;
+	bss_cfg->mfp = sme->mfp;
+
+	if ((sme->bg_scan_period > 0) &&
+	    (sme->bg_scan_period <= QTNF_MAX_BG_SCAN_PERIOD))
+		bss_cfg->bg_scan_period = sme->bg_scan_period;
+	else if (sme->bg_scan_period == -1)
+		bss_cfg->bg_scan_period = QTNF_DEFAULT_BG_SCAN_PERIOD;
+	else
+		bss_cfg->bg_scan_period = 0; /* disabled */
+
+	bss_cfg->connect_flags = 0;
+
+	if (sme->flags & ASSOC_REQ_DISABLE_HT)
+		bss_cfg->connect_flags |= QLINK_STA_CONNECT_DISABLE_HT;
+	if (sme->flags & ASSOC_REQ_DISABLE_VHT)
+		bss_cfg->connect_flags |= QLINK_STA_CONNECT_DISABLE_VHT;
+	if (sme->flags & ASSOC_REQ_USE_RRM)
+		bss_cfg->connect_flags |= QLINK_STA_CONNECT_USE_RRM;
+
+	memcpy(&bss_cfg->crypto, &sme->crypto, sizeof(bss_cfg->crypto));
+	if (sme->bssid)
+		ether_addr_copy(bss_cfg->bssid, sme->bssid);
+	else
+		eth_zero_addr(bss_cfg->bssid);
+
+	ret = qtnf_cmd_send_connect(vif, sme);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to connect\n", vif->mac->macid,
+		       vif->vifid);
+		return ret;
+	}
+
+	vif->sta_state = QTNF_STA_CONNECTING;
+	return 0;
+}
+
+static int
+qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
+		u16 reason_code)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct qtnf_vif *vif;
+	int ret;
+
+	vif = qtnf_mac_get_base_vif(mac);
+	if (!vif) {
+		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
+		return -EFAULT;
+	}
+
+	if (vif->wdev.iftype != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (vif->sta_state == QTNF_STA_DISCONNECTED)
+		return 0;
+
+	ret = qtnf_cmd_send_disconnect(vif, reason_code);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to disconnect\n", mac->macid,
+		       vif->vifid);
+		return ret;
+	}
+
+	vif->sta_state = QTNF_STA_DISCONNECTED;
+	return 0;
+}
+
+static struct cfg80211_ops qtn_cfg80211_ops = {
+	.add_virtual_intf	= qtnf_add_virtual_intf,
+	.change_virtual_intf	= qtnf_change_virtual_intf,
+	.del_virtual_intf	= qtnf_del_virtual_intf,
+	.start_ap		= qtnf_start_ap,
+	.change_beacon		= qtnf_change_beacon,
+	.stop_ap		= qtnf_stop_ap,
+	.set_wiphy_params	= qtnf_set_wiphy_params,
+	.mgmt_frame_register	= qtnf_mgmt_frame_register,
+	.mgmt_tx		= qtnf_mgmt_tx,
+	.change_station		= qtnf_change_station,
+	.del_station		= qtnf_del_station,
+	.get_station		= qtnf_get_station,
+	.dump_station		= qtnf_dump_station,
+	.add_key		= qtnf_add_key,
+	.del_key		= qtnf_del_key,
+	.set_default_key	= qtnf_set_default_key,
+	.set_default_mgmt_key	= qtnf_set_default_mgmt_key,
+	.scan			= qtnf_scan,
+	.connect		= qtnf_connect,
+	.disconnect		= qtnf_disconnect
+};
+
+static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy,
+				       struct regulatory_request *req)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct qtnf_bus *bus;
+	struct qtnf_vif *vif;
+	struct qtnf_wmac *chan_mac;
+	int i;
+	enum nl80211_band band;
+
+	bus = mac->bus;
+
+	pr_debug("MAC%u: initiator=%d alpha=%c%c\n", mac->macid, req->initiator,
+		 req->alpha2[0], req->alpha2[1]);
+
+	vif = qtnf_mac_get_base_vif(mac);
+	if (!vif) {
+		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
+		return;
+	}
+
+	/* ignore non-ISO3166 country codes */
+	for (i = 0; i < sizeof(req->alpha2); i++) {
+		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
+			pr_err("MAC%u: not an ISO3166 code\n", mac->macid);
+			return;
+		}
+	}
+	if (!strncasecmp(req->alpha2, bus->hw_info.alpha2_code,
+			 sizeof(req->alpha2))) {
+		pr_warn("MAC%u: unchanged country code\n", mac->macid);
+		return;
+	}
+
+	if (qtnf_cmd_send_regulatory_config(mac, req->alpha2)) {
+		pr_err("MAC%u: failed to configure regulatory\n", mac->macid);
+		return;
+	}
+
+	for (i = 0; i < bus->hw_info.num_mac; i++) {
+		chan_mac = bus->mac[i];
+
+		if (!chan_mac)
+			continue;
+
+		if (!(bus->hw_info.mac_bitmap & BIT(i)))
+			continue;
+
+		for (band = 0; band < NUM_NL80211_BANDS; ++band) {
+			if (!wiphy->bands[band])
+				continue;
+
+			if (qtnf_cmd_get_mac_chan_info(chan_mac,
+						       wiphy->bands[band])) {
+				pr_err("MAC%u: can't get channel info\n",
+				       chan_mac->macid);
+				qtnf_core_detach(bus);
+
+				return;
+			}
+		}
+	}
+}
+
+void qtnf_band_setup_htvht_caps(struct qtnf_mac_info *macinfo,
+				struct ieee80211_supported_band *band)
+{
+	struct ieee80211_sta_ht_cap *ht_cap;
+	struct ieee80211_sta_vht_cap *vht_cap;
+
+	ht_cap = &band->ht_cap;
+	ht_cap->ht_supported = true;
+	memcpy(&ht_cap->cap, &macinfo->ht_cap.cap_info,
+	       sizeof(u16));
+	ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_cap->ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
+	memcpy(&ht_cap->mcs, &macinfo->ht_cap.mcs,
+	       sizeof(ht_cap->mcs));
+
+	if (macinfo->phymode_cap & QLINK_PHYMODE_AC) {
+		vht_cap = &band->vht_cap;
+		vht_cap->vht_supported = true;
+		memcpy(&vht_cap->cap,
+		       &macinfo->vht_cap.vht_cap_info, sizeof(u32));
+		/* Update MCS support for VHT */
+		memcpy(&vht_cap->vht_mcs,
+		       &macinfo->vht_cap.supp_mcs,
+		       sizeof(struct ieee80211_vht_mcs_info));
+	}
+}
+
+struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus)
+{
+	struct wiphy *wiphy;
+
+	wiphy = wiphy_new(&qtn_cfg80211_ops, sizeof(struct qtnf_wmac));
+	if (!wiphy)
+		return NULL;
+
+	set_wiphy_dev(wiphy, bus->dev);
+
+	return wiphy;
+}
+
+static int qtnf_wiphy_setup_if_comb(struct wiphy *wiphy,
+				    struct ieee80211_iface_combination *if_comb,
+				    const struct qtnf_mac_info *mac_info)
+{
+	size_t max_interfaces = 0;
+	u16 interface_modes = 0;
+	size_t i;
+
+	if (unlikely(!mac_info->limits || !mac_info->n_limits))
+		return -ENOENT;
+
+	if_comb->limits = mac_info->limits;
+	if_comb->n_limits = mac_info->n_limits;
+
+	for (i = 0; i < mac_info->n_limits; i++) {
+		max_interfaces += mac_info->limits[i].max;
+		interface_modes |= mac_info->limits[i].types;
+	}
+
+	if_comb->num_different_channels = 1;
+	if_comb->beacon_int_infra_match = true;
+	if_comb->max_interfaces = max_interfaces;
+	if_comb->radar_detect_widths = mac_info->radar_detect_widths;
+	wiphy->interface_modes = interface_modes;
+
+	return 0;
+}
+
+int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
+{
+	struct wiphy *wiphy = priv_to_wiphy(mac);
+	struct ieee80211_iface_combination *iface_comb = NULL;
+	int ret;
+
+	if (!wiphy) {
+		pr_err("invalid wiphy pointer\n");
+		return -EFAULT;
+	}
+
+	iface_comb = kzalloc(sizeof(*iface_comb), GFP_KERNEL);
+	if (!iface_comb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = qtnf_wiphy_setup_if_comb(wiphy, iface_comb, &mac->macinfo);
+	if (ret)
+		goto out;
+
+	pr_info("MAC%u: phymode=%#x radar=%#x\n", mac->macid,
+		mac->macinfo.phymode_cap, mac->macinfo.radar_detect_widths);
+
+	wiphy->frag_threshold = mac->macinfo.frag_thr;
+	wiphy->rts_threshold = mac->macinfo.rts_thr;
+	wiphy->retry_short = mac->macinfo.sretry_limit;
+	wiphy->retry_long = mac->macinfo.lretry_limit;
+	wiphy->coverage_class = mac->macinfo.coverage_class;
+
+	wiphy->max_scan_ssids = QTNF_MAX_SSID_LIST_LENGTH;
+	wiphy->max_scan_ie_len = QTNF_MAX_VSIE_LEN;
+	wiphy->mgmt_stypes = qtnf_mgmt_stypes;
+	wiphy->max_remain_on_channel_duration = 5000;
+
+	wiphy->iface_combinations = iface_comb;
+	wiphy->n_iface_combinations = 1;
+
+	/* Initialize cipher suits */
+	wiphy->cipher_suites = qtnf_cipher_suites;
+	wiphy->n_cipher_suites = ARRAY_SIZE(qtnf_cipher_suites);
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
+			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
+			WIPHY_FLAG_AP_UAPSD;
+
+	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
+
+	wiphy->available_antennas_tx = mac->macinfo.num_tx_chain;
+	wiphy->available_antennas_rx = mac->macinfo.num_rx_chain;
+
+	wiphy->max_ap_assoc_sta = mac->macinfo.max_ap_assoc_sta;
+
+	ether_addr_copy(wiphy->perm_addr, mac->macaddr);
+
+	if (hw_info->hw_capab & QLINK_HW_SUPPORTS_REG_UPDATE) {
+		pr_debug("device supports REG_UPDATE\n");
+		wiphy->reg_notifier = qtnf_cfg80211_reg_notifier;
+		pr_debug("hint regulatory about EP region: %c%c\n",
+			 hw_info->alpha2_code[0],
+			 hw_info->alpha2_code[1]);
+		regulatory_hint(wiphy, hw_info->alpha2_code);
+	} else {
+		pr_debug("device doesn't support REG_UPDATE\n");
+		wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
+	}
+
+	ret = wiphy_register(wiphy);
+
+out:
+	if (ret < 0) {
+		kfree(iface_comb);
+		return ret;
+	}
+
+	return 0;
+}
+
+void qtnf_netdev_updown(struct net_device *ndev, bool up)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+
+	if (qtnf_cmd_send_updown_intf(vif, up))
+		pr_err("failed to send up/down command to FW\n");
+}
+
+void qtnf_virtual_intf_cleanup(struct net_device *ndev)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	struct qtnf_wmac *mac = mac = wiphy_priv(vif->wdev.wiphy);
+
+	if (vif->wdev.iftype == NL80211_IFTYPE_STATION) {
+		switch (vif->sta_state) {
+		case QTNF_STA_DISCONNECTED:
+			break;
+		case QTNF_STA_CONNECTING:
+			cfg80211_connect_result(vif->netdev,
+						vif->bss_cfg.bssid, NULL, 0,
+						NULL, 0,
+						WLAN_STATUS_UNSPECIFIED_FAILURE,
+						GFP_KERNEL);
+			qtnf_disconnect(vif->wdev.wiphy, ndev,
+					WLAN_REASON_DEAUTH_LEAVING);
+			break;
+		case QTNF_STA_CONNECTED:
+			cfg80211_disconnected(vif->netdev,
+					      WLAN_REASON_DEAUTH_LEAVING,
+					      NULL, 0, 1, GFP_KERNEL);
+			qtnf_disconnect(vif->wdev.wiphy, ndev,
+					WLAN_REASON_DEAUTH_LEAVING);
+			break;
+		}
+
+		vif->sta_state = QTNF_STA_DISCONNECTED;
+		qtnf_scan_done(mac, true);
+	}
+}
+
+void qtnf_cfg80211_vif_reset(struct qtnf_vif *vif)
+{
+	if (vif->wdev.iftype == NL80211_IFTYPE_STATION) {
+		switch (vif->sta_state) {
+		case QTNF_STA_CONNECTING:
+			cfg80211_connect_result(vif->netdev,
+						vif->bss_cfg.bssid, NULL, 0,
+						NULL, 0,
+						WLAN_STATUS_UNSPECIFIED_FAILURE,
+						GFP_KERNEL);
+			break;
+		case QTNF_STA_CONNECTED:
+			cfg80211_disconnected(vif->netdev,
+					      WLAN_REASON_DEAUTH_LEAVING,
+					      NULL, 0, 1, GFP_KERNEL);
+			break;
+		case QTNF_STA_DISCONNECTED:
+			break;
+		}
+	}
+
+	cfg80211_shutdown_all_interfaces(vif->wdev.wiphy);
+	vif->sta_state = QTNF_STA_DISCONNECTED;
+}
+
+void qtnf_band_init_rates(struct ieee80211_supported_band *band)
+{
+	switch (band->band) {
+	case NL80211_BAND_2GHZ:
+		band->bitrates = qtnf_rates_2g;
+		band->n_bitrates = ARRAY_SIZE(qtnf_rates_2g);
+		break;
+	case NL80211_BAND_5GHZ:
+		band->bitrates = qtnf_rates_5g;
+		band->n_bitrates = ARRAY_SIZE(qtnf_rates_5g);
+		break;
+	default:
+		band->bitrates = NULL;
+		band->n_bitrates = 0;
+		break;
+	}
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
new file mode 100644
index 0000000..5bd3312
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
@@ -0,0 +1,43 @@
+/*
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
+ */
+
+#ifndef _QTN_FMAC_CFG80211_H_
+#define _QTN_FMAC_CFG80211_H_
+
+#include <net/cfg80211.h>
+
+#include "core.h"
+
+int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac);
+int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev);
+void qtnf_cfg80211_vif_reset(struct qtnf_vif *vif);
+void qtnf_band_init_rates(struct ieee80211_supported_band *band);
+void qtnf_band_setup_htvht_caps(struct qtnf_mac_info *macinfo,
+				struct ieee80211_supported_band *band);
+
+static inline void qtnf_scan_done(struct qtnf_wmac *mac, bool aborted)
+{
+	struct cfg80211_scan_info info = {
+		.aborted = aborted,
+	};
+
+	if (mac->scan_req) {
+		cfg80211_scan_done(mac->scan_req, &info);
+		mac->scan_req = NULL;
+	}
+}
+
+#endif /* _QTN_FMAC_CFG80211_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
new file mode 100644
index 0000000..f0a0cfa
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -0,0 +1,1982 @@
+/*
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
+ */
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
+static int qtnf_cmd_check_reply_header(const struct qlink_resp *resp,
+				       u16 cmd_id, u8 mac_id, u8 vif_id,
+				       size_t resp_size)
+{
+	if (unlikely(le16_to_cpu(resp->cmd_id) != cmd_id)) {
+		pr_warn("VIF%u.%u CMD%x: bad cmd_id in response: 0x%.4X\n",
+			mac_id, vif_id, cmd_id, le16_to_cpu(resp->cmd_id));
+		return -EINVAL;
+	}
+
+	if (unlikely(resp->macid != mac_id)) {
+		pr_warn("VIF%u.%u CMD%x: bad MAC in response: %u\n",
+			mac_id, vif_id, cmd_id, resp->macid);
+		return -EINVAL;
+	}
+
+	if (unlikely(resp->vifid != vif_id)) {
+		pr_warn("VIF%u.%u CMD%x: bad VIF in response: %u\n",
+			mac_id, vif_id, cmd_id, resp->vifid);
+		return -EINVAL;
+	}
+
+	if (unlikely(le16_to_cpu(resp->mhdr.len) < resp_size)) {
+		pr_warn("VIF%u.%u CMD%x: bad response size %u < %zu\n",
+			mac_id, vif_id, cmd_id,
+			le16_to_cpu(resp->mhdr.len), resp_size);
+		return -ENOSPC;
+	}
+
+	return 0;
+}
+
+static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
+				    struct sk_buff *cmd_skb,
+				    struct sk_buff **response_skb,
+				    u16 *result_code,
+				    size_t const_resp_size,
+				    size_t *var_resp_size)
+{
+	struct qlink_cmd *cmd;
+	const struct qlink_resp *resp;
+	struct sk_buff *resp_skb = NULL;
+	u16 cmd_id;
+	u8 mac_id, vif_id;
+	int ret;
+
+	cmd = (struct qlink_cmd *)cmd_skb->data;
+	cmd_id = le16_to_cpu(cmd->cmd_id);
+	mac_id = cmd->macid;
+	vif_id = cmd->vifid;
+	cmd->mhdr.len = cpu_to_le16(cmd_skb->len);
+
+	if (unlikely(bus->fw_state != QTNF_FW_STATE_ACTIVE &&
+		     le16_to_cpu(cmd->cmd_id) != QLINK_CMD_FW_INIT)) {
+		pr_warn("VIF%u.%u: drop cmd 0x%.4X in fw state %d\n",
+			mac_id, vif_id, le16_to_cpu(cmd->cmd_id),
+			bus->fw_state);
+		return -ENODEV;
+	}
+
+	pr_debug("VIF%u.%u cmd=0x%.4X\n", mac_id, vif_id,
+		 le16_to_cpu(cmd->cmd_id));
+
+	ret = qtnf_trans_send_cmd_with_resp(bus, cmd_skb, &resp_skb);
+
+	if (unlikely(ret))
+		goto out;
+
+	resp = (const struct qlink_resp *)resp_skb->data;
+	ret = qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id,
+					  const_resp_size);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (likely(result_code))
+		*result_code = le16_to_cpu(resp->result);
+
+	/* Return length of variable part of response */
+	if (response_skb && var_resp_size)
+		*var_resp_size = le16_to_cpu(resp->mhdr.len) - const_resp_size;
+
+out:
+	if (response_skb)
+		*response_skb = resp_skb;
+	else
+		consume_skb(resp_skb);
+
+	return ret;
+}
+
+static inline int qtnf_cmd_send(struct qtnf_bus *bus,
+				struct sk_buff *cmd_skb,
+				u16 *result_code)
+{
+	return qtnf_cmd_send_with_reply(bus, cmd_skb, NULL, result_code,
+					sizeof(struct qlink_resp), NULL);
+}
+
+static struct sk_buff *qtnf_cmd_alloc_new_cmdskb(u8 macid, u8 vifid, u16 cmd_no,
+						 size_t cmd_size)
+{
+	struct qlink_cmd *cmd;
+	struct sk_buff *cmd_skb;
+
+	cmd_skb = __dev_alloc_skb(sizeof(*cmd) +
+				  QTNF_MAX_CMD_BUF_SIZE, GFP_KERNEL);
+	if (unlikely(!cmd_skb)) {
+		pr_err("VIF%u.%u CMD %u: alloc failed\n", macid, vifid, cmd_no);
+		return NULL;
+	}
+
+	memset(skb_put(cmd_skb, cmd_size), 0, cmd_size);
+
+	cmd = (struct qlink_cmd *)cmd_skb->data;
+	cmd->mhdr.len = cpu_to_le16(cmd_skb->len);
+	cmd->mhdr.type = cpu_to_le16(QLINK_MSG_TYPE_CMD);
+	cmd->cmd_id = cpu_to_le16(cmd_no);
+	cmd->macid = macid;
+	cmd->vifid = vifid;
+
+	return cmd_skb;
+}
+
+int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
+{
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_START_AP,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	vif->bss_status |= QTNF_STATE_AP_START;
+	netif_carrier_on(vif->netdev);
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *mac, const char *alpha2)
+{
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
+					    QLINK_CMD_REG_REGION,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_COUNTRY, alpha2,
+				 QTNF_MAX_ALPHA_LEN);
+
+	ret = qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	memcpy(mac->bus->hw_info.alpha2_code, alpha2,
+	       sizeof(mac->bus->hw_info.alpha2_code));
+out:
+	return ret;
+}
+
+int qtnf_cmd_send_config_ap(struct qtnf_vif *vif)
+{
+	struct sk_buff *cmd_skb;
+	struct qtnf_bss_config *bss_cfg = &vif->bss_cfg;
+	struct cfg80211_chan_def *chandef = &bss_cfg->chandef;
+	struct qlink_tlv_channel *qchan;
+	struct qlink_auth_encr aen;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+	int i;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_CONFIG_AP,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, bss_cfg->ssid,
+				 bss_cfg->ssid_len);
+	qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_BCN_PERIOD,
+				 bss_cfg->bcn_period);
+	qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_DTIM, bss_cfg->dtim);
+
+	qchan = (struct qlink_tlv_channel *)skb_put(cmd_skb, sizeof(*qchan));
+
+	memset(qchan, 0, sizeof(*qchan));
+	qchan->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANNEL);
+	qchan->hdr.len = cpu_to_le16(sizeof(*qchan) -
+			sizeof(struct qlink_tlv_hdr));
+	qchan->hw_value = cpu_to_le16(
+		ieee80211_frequency_to_channel(chandef->chan->center_freq));
+
+	memset(&aen, 0, sizeof(aen));
+	aen.auth_type = bss_cfg->auth_type;
+	aen.privacy = !!bss_cfg->privacy;
+	aen.mfp = bss_cfg->mfp;
+	aen.wpa_versions = cpu_to_le32(bss_cfg->crypto.wpa_versions);
+	aen.cipher_group = cpu_to_le32(bss_cfg->crypto.cipher_group);
+	aen.n_ciphers_pairwise = cpu_to_le32(
+					bss_cfg->crypto.n_ciphers_pairwise);
+	for (i = 0; i < QLINK_MAX_NR_CIPHER_SUITES; i++)
+		aen.ciphers_pairwise[i] = cpu_to_le32(
+					bss_cfg->crypto.ciphers_pairwise[i]);
+	aen.n_akm_suites = cpu_to_le32(
+					bss_cfg->crypto.n_akm_suites);
+	for (i = 0; i < QLINK_MAX_NR_AKM_SUITES; i++)
+		aen.akm_suites[i] = cpu_to_le32(
+					bss_cfg->crypto.akm_suites[i]);
+	aen.control_port = bss_cfg->crypto.control_port;
+	aen.control_port_no_encrypt =
+			bss_cfg->crypto.control_port_no_encrypt;
+	aen.control_port_ethertype = cpu_to_le16(be16_to_cpu(
+				bss_cfg->crypto.control_port_ethertype));
+
+	qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_CRYPTO, (u8 *)&aen,
+				 sizeof(aen));
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	vif->bss_status |= QTNF_STATE_AP_CONFIG;
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
+{
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_STOP_AP,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	vif->bss_status &= ~QTNF_STATE_AP_START;
+	vif->bss_status &= ~QTNF_STATE_AP_CONFIG;
+
+	netif_carrier_off(vif->netdev);
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool reg)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_mgmt_frame_register *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_REGISTER_MGMT,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_mgmt_frame_register *)cmd_skb->data;
+	cmd->frame_type = cpu_to_le16(frame_type);
+	cmd->do_register = reg;
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
+			     u16 freq, const u8 *buf, size_t len)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_mgmt_frame_tx *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	if (sizeof(*cmd) + len > QTNF_MAX_CMD_BUF_SIZE) {
+		pr_warn("VIF%u.%u: frame is too big: %zu\n", vif->mac->macid,
+			vif->vifid, len);
+		return -E2BIG;
+	}
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_SEND_MGMT_FRAME,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_mgmt_frame_tx *)cmd_skb->data;
+	cmd->cookie = cpu_to_le32(cookie);
+	cmd->freq = cpu_to_le16(freq);
+	cmd->flags = cpu_to_le16(flags);
+
+	if (len && buf)
+		qtnf_cmd_skb_put_buffer(cmd_skb, buf, len);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
+				 const u8 *buf, size_t len)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_mgmt_append_ie *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	if (sizeof(*cmd) + len > QTNF_MAX_CMD_BUF_SIZE) {
+		pr_warn("VIF%u.%u: %u frame is too big: %zu\n", vif->mac->macid,
+			vif->vifid, frame_type, len);
+		return -E2BIG;
+	}
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_MGMT_SET_APPIE,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_mgmt_append_ie *)cmd_skb->data;
+	cmd->type = frame_type;
+	cmd->flags = 0;
+
+	/* If len == 0 then IE buf for specified frame type
+	 * should be cleared on EP.
+	 */
+	if (len && buf)
+		qtnf_cmd_skb_put_buffer(cmd_skb, buf, len);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u frame %u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, frame_type, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+static void
+qtnf_sta_info_parse_basic_counters(struct station_info *sinfo,
+		const struct qlink_sta_stat_basic_counters *counters)
+{
+	sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES) |
+			 BIT(NL80211_STA_INFO_TX_BYTES);
+	sinfo->rx_bytes = get_unaligned_le64(&counters->rx_bytes);
+	sinfo->tx_bytes = get_unaligned_le64(&counters->tx_bytes);
+
+	sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS) |
+			 BIT(NL80211_STA_INFO_TX_PACKETS) |
+			 BIT(NL80211_STA_INFO_BEACON_RX);
+	sinfo->rx_packets = get_unaligned_le32(&counters->rx_packets);
+	sinfo->tx_packets = get_unaligned_le32(&counters->tx_packets);
+	sinfo->rx_beacon = get_unaligned_le64(&counters->rx_beacons);
+
+	sinfo->filled |= BIT(NL80211_STA_INFO_RX_DROP_MISC) |
+			 BIT(NL80211_STA_INFO_TX_FAILED);
+	sinfo->rx_dropped_misc = get_unaligned_le32(&counters->rx_dropped);
+	sinfo->tx_failed = get_unaligned_le32(&counters->tx_failed);
+}
+
+static void
+qtnf_sta_info_parse_rate(struct rate_info *rate_dst,
+			 const struct  qlink_sta_info_rate *rate_src)
+{
+	rate_dst->legacy = get_unaligned_le16(&rate_src->rate) * 10;
+
+	rate_dst->mcs = rate_src->mcs;
+	rate_dst->nss = rate_src->nss;
+	rate_dst->flags = 0;
+
+	switch (rate_src->bw) {
+	case QLINK_STA_INFO_RATE_BW_5:
+		rate_dst->bw = RATE_INFO_BW_5;
+		break;
+	case QLINK_STA_INFO_RATE_BW_10:
+		rate_dst->bw = RATE_INFO_BW_10;
+		break;
+	case QLINK_STA_INFO_RATE_BW_20:
+		rate_dst->bw = RATE_INFO_BW_20;
+		break;
+	case QLINK_STA_INFO_RATE_BW_40:
+		rate_dst->bw = RATE_INFO_BW_40;
+		break;
+	case QLINK_STA_INFO_RATE_BW_80:
+		rate_dst->bw = RATE_INFO_BW_80;
+		break;
+	case QLINK_STA_INFO_RATE_BW_160:
+		rate_dst->bw = RATE_INFO_BW_160;
+		break;
+	default:
+		rate_dst->bw = 0;
+		break;
+	}
+
+	if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_HT_MCS)
+		rate_dst->flags |= RATE_INFO_FLAGS_MCS;
+	else if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_VHT_MCS)
+		rate_dst->flags |= RATE_INFO_FLAGS_VHT_MCS;
+}
+
+static void
+qtnf_sta_info_parse_flags(struct nl80211_sta_flag_update *dst,
+			  const struct qlink_sta_info_state *src)
+{
+	u32 mask, value;
+
+	dst->mask = 0;
+	dst->set = 0;
+
+	mask = le32_to_cpu(src->mask);
+	value = le32_to_cpu(src->value);
+
+	if (mask & QLINK_STA_FLAG_AUTHORIZED) {
+		dst->mask |= BIT(NL80211_STA_FLAG_AUTHORIZED);
+		if (value & QLINK_STA_FLAG_AUTHORIZED)
+			dst->set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
+	}
+
+	if (mask & QLINK_STA_FLAG_SHORT_PREAMBLE) {
+		dst->mask |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
+		if (value & QLINK_STA_FLAG_SHORT_PREAMBLE)
+			dst->set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
+	}
+
+	if (mask & QLINK_STA_FLAG_WME) {
+		dst->mask |= BIT(NL80211_STA_FLAG_WME);
+		if (value & QLINK_STA_FLAG_WME)
+			dst->set |= BIT(NL80211_STA_FLAG_WME);
+	}
+
+	if (mask & QLINK_STA_FLAG_MFP) {
+		dst->mask |= BIT(NL80211_STA_FLAG_MFP);
+		if (value & QLINK_STA_FLAG_MFP)
+			dst->set |= BIT(NL80211_STA_FLAG_MFP);
+	}
+
+	if (mask & QLINK_STA_FLAG_AUTHENTICATED) {
+		dst->mask |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
+		if (value & QLINK_STA_FLAG_AUTHENTICATED)
+			dst->set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
+	}
+
+	if (mask & QLINK_STA_FLAG_TDLS_PEER) {
+		dst->mask |= BIT(NL80211_STA_FLAG_TDLS_PEER);
+		if (value & QLINK_STA_FLAG_TDLS_PEER)
+			dst->set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
+	}
+
+	if (mask & QLINK_STA_FLAG_ASSOCIATED) {
+		dst->mask |= BIT(NL80211_STA_FLAG_ASSOCIATED);
+		if (value & QLINK_STA_FLAG_ASSOCIATED)
+			dst->set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
+	}
+}
+
+static void
+qtnf_sta_info_parse_generic_info(struct station_info *sinfo,
+				 const struct qlink_sta_info_generic *info)
+{
+	sinfo->filled |= BIT(NL80211_STA_INFO_CONNECTED_TIME) |
+			 BIT(NL80211_STA_INFO_INACTIVE_TIME);
+	sinfo->connected_time = get_unaligned_le32(&info->connected_time);
+	sinfo->inactive_time = get_unaligned_le32(&info->inactive_time);
+
+	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
+			 BIT(NL80211_STA_INFO_SIGNAL_AVG);
+	sinfo->signal = info->rssi - 120;
+	sinfo->signal_avg = info->rssi_avg - QLINK_RSSI_OFFSET;
+
+	if (info->rx_rate.rate) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
+		qtnf_sta_info_parse_rate(&sinfo->rxrate, &info->rx_rate);
+	}
+
+	if (info->tx_rate.rate) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+		qtnf_sta_info_parse_rate(&sinfo->txrate, &info->tx_rate);
+	}
+
+	sinfo->filled |= BIT(NL80211_STA_INFO_STA_FLAGS);
+	qtnf_sta_info_parse_flags(&sinfo->sta_flags, &info->state);
+}
+
+static int qtnf_cmd_sta_info_parse(struct station_info *sinfo,
+				   const u8 *payload, size_t payload_size)
+{
+	const struct qlink_sta_stat_basic_counters *counters;
+	const struct qlink_sta_info_generic *sta_info;
+	u16 tlv_type;
+	u16 tlv_value_len;
+	size_t tlv_full_len;
+	const struct qlink_tlv_hdr *tlv;
+
+	sinfo->filled = 0;
+
+	tlv = (const struct qlink_tlv_hdr *)payload;
+	while (payload_size >= sizeof(struct qlink_tlv_hdr)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_value_len = le16_to_cpu(tlv->len);
+		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+		if (tlv_full_len > payload_size) {
+			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
+				tlv_type, tlv_value_len);
+			return -EINVAL;
+		}
+		switch (tlv_type) {
+		case QTN_TLV_ID_STA_BASIC_COUNTERS:
+			if (unlikely(tlv_value_len < sizeof(*counters))) {
+				pr_err("invalid TLV size %.4X: %u\n",
+				       tlv_type, tlv_value_len);
+				break;
+			}
+
+			counters = (void *)tlv->val;
+			qtnf_sta_info_parse_basic_counters(sinfo, counters);
+			break;
+		case QTN_TLV_ID_STA_GENERIC_INFO:
+			if (unlikely(tlv_value_len < sizeof(*sta_info)))
+				break;
+
+			sta_info = (void *)tlv->val;
+			qtnf_sta_info_parse_generic_info(sinfo, sta_info);
+			break;
+		default:
+			pr_warn("unexpected TLV type: %.4X\n", tlv_type);
+			break;
+		}
+		payload_size -= tlv_full_len;
+		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+	}
+
+	if (payload_size) {
+		pr_warn("malformed TLV buf; bytes left: %zu\n", payload_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
+			  struct station_info *sinfo)
+{
+	struct sk_buff *cmd_skb, *resp_skb = NULL;
+	struct qlink_cmd_get_sta_info *cmd;
+	const struct qlink_resp_get_sta_info *resp;
+	size_t var_resp_len;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_GET_STA_INFO,
+					    sizeof(*cmd));
+
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_get_sta_info *)cmd_skb->data;
+	ether_addr_copy(cmd->sta_addr, sta_mac);
+
+	ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, &resp_skb,
+				       &res_code, sizeof(*resp),
+				       &var_resp_len);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		switch (res_code) {
+		case QLINK_CMD_RESULT_ENOTFOUND:
+			pr_warn("VIF%u.%u: %pM STA not found\n",
+				vif->mac->macid, vif->vifid, sta_mac);
+			ret = -ENOENT;
+			break;
+		default:
+			pr_err("VIF%u.%u: can't get info for %pM: %u\n",
+			       vif->mac->macid, vif->vifid, sta_mac, res_code);
+			ret = -EFAULT;
+			break;
+		}
+		goto out;
+	}
+
+	resp = (const struct qlink_resp_get_sta_info *)resp_skb->data;
+
+	if (unlikely(!ether_addr_equal(sta_mac, resp->sta_addr))) {
+		pr_err("VIF%u.%u: wrong mac in reply: %pM != %pM\n",
+		       vif->mac->macid, vif->vifid, resp->sta_addr, sta_mac);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = qtnf_cmd_sta_info_parse(sinfo, resp->info, var_resp_len);
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	consume_skb(resp_skb);
+
+	return ret;
+}
+
+static int qtnf_cmd_send_add_change_intf(struct qtnf_vif *vif,
+					 enum nl80211_iftype iftype,
+					 u8 *mac_addr,
+					 enum qlink_cmd_type cmd_type)
+{
+	struct sk_buff *cmd_skb, *resp_skb = NULL;
+	struct qlink_cmd_manage_intf *cmd;
+	const struct qlink_resp_manage_intf *resp;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    cmd_type,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_manage_intf *)cmd_skb->data;
+
+	switch (iftype) {
+	case NL80211_IFTYPE_AP:
+		cmd->intf_info.if_type = cpu_to_le16(QLINK_IFTYPE_AP);
+		break;
+	case NL80211_IFTYPE_STATION:
+		cmd->intf_info.if_type = cpu_to_le16(QLINK_IFTYPE_STATION);
+		break;
+	default:
+		pr_err("VIF%u.%u: unsupported type %d\n", vif->mac->macid,
+		       vif->vifid, iftype);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (mac_addr)
+		ether_addr_copy(cmd->intf_info.mac_addr, mac_addr);
+	else
+		eth_zero_addr(cmd->intf_info.mac_addr);
+
+	ret = qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, &resp_skb,
+				       &res_code, sizeof(*resp), NULL);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD %d failed: %u\n", vif->mac->macid,
+		       vif->vifid, cmd_type, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	resp = (const struct qlink_resp_manage_intf *)resp_skb->data;
+	ether_addr_copy(vif->mac_addr, resp->intf_info.mac_addr);
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	consume_skb(resp_skb);
+
+	return ret;
+}
+
+int qtnf_cmd_send_add_intf(struct qtnf_vif *vif,
+			   enum nl80211_iftype iftype, u8 *mac_addr)
+{
+	return qtnf_cmd_send_add_change_intf(vif, iftype, mac_addr,
+			QLINK_CMD_ADD_INTF);
+}
+
+int qtnf_cmd_send_change_intf_type(struct qtnf_vif *vif,
+				   enum nl80211_iftype iftype, u8 *mac_addr)
+{
+	return qtnf_cmd_send_add_change_intf(vif, iftype, mac_addr,
+					     QLINK_CMD_CHANGE_INTF);
+}
+
+int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_manage_intf *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_DEL_INTF,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_manage_intf *)cmd_skb->data;
+
+	switch (vif->wdev.iftype) {
+	case NL80211_IFTYPE_AP:
+		cmd->intf_info.if_type = cpu_to_le16(QLINK_IFTYPE_AP);
+		break;
+	case NL80211_IFTYPE_STATION:
+		cmd->intf_info.if_type = cpu_to_le16(QLINK_IFTYPE_STATION);
+		break;
+	default:
+		pr_warn("VIF%u.%u: unsupported iftype %d\n", vif->mac->macid,
+			vif->vifid, vif->wdev.iftype);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	eth_zero_addr(cmd->intf_info.mac_addr);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+static int
+qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
+			   const struct qlink_resp_get_hw_info *resp)
+{
+	struct qtnf_hw_info *hwinfo = &bus->hw_info;
+
+	hwinfo->num_mac = resp->num_mac;
+	hwinfo->mac_bitmap = resp->mac_bitmap;
+	hwinfo->fw_ver = le32_to_cpu(resp->fw_ver);
+	hwinfo->ql_proto_ver = le16_to_cpu(resp->ql_proto_ver);
+	memcpy(hwinfo->alpha2_code, resp->alpha2_code,
+	       sizeof(hwinfo->alpha2_code));
+	hwinfo->total_tx_chain = resp->total_tx_chain;
+	hwinfo->total_rx_chain = resp->total_rx_chain;
+	hwinfo->hw_capab = le32_to_cpu(resp->hw_capab);
+
+	pr_info("fw_version=%d, MACs map %#x, alpha2=\"%c%c\", chains Tx=%u Rx=%u\n",
+		hwinfo->fw_ver, hwinfo->mac_bitmap,
+		hwinfo->alpha2_code[0], hwinfo->alpha2_code[1],
+		hwinfo->total_tx_chain, hwinfo->total_rx_chain);
+
+	return 0;
+}
+
+static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
+					const u8 *tlv_buf, size_t tlv_buf_size)
+{
+	struct ieee80211_iface_limit *limits = NULL;
+	const struct qlink_iface_limit *limit_record;
+	size_t record_count = 0, rec = 0;
+	u16 tlv_type, tlv_value_len, mask;
+	struct qlink_iface_comb_num *comb;
+	size_t tlv_full_len;
+	const struct qlink_tlv_hdr *tlv;
+
+	mac->macinfo.n_limits = 0;
+
+	tlv = (const struct qlink_tlv_hdr *)tlv_buf;
+	while (tlv_buf_size >= sizeof(struct qlink_tlv_hdr)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_value_len = le16_to_cpu(tlv->len);
+		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+		if (tlv_full_len > tlv_buf_size) {
+			pr_warn("MAC%u: malformed TLV 0x%.2X; LEN: %u\n",
+				mac->macid, tlv_type, tlv_value_len);
+			return -EINVAL;
+		}
+
+		switch (tlv_type) {
+		case QTN_TLV_ID_NUM_IFACE_COMB:
+			if (unlikely(tlv_value_len != sizeof(*comb)))
+				return -EINVAL;
+
+			comb = (void *)tlv->val;
+			record_count = le16_to_cpu(comb->iface_comb_num);
+
+			mac->macinfo.n_limits = record_count;
+			/* free earlier iface limits memory */
+			kfree(mac->macinfo.limits);
+			mac->macinfo.limits =
+				kzalloc(sizeof(*mac->macinfo.limits) *
+					record_count, GFP_KERNEL);
+
+			if (unlikely(!mac->macinfo.limits))
+				return -ENOMEM;
+
+			limits = mac->macinfo.limits;
+			break;
+		case QTN_TLV_ID_IFACE_LIMIT:
+			if (unlikely(!limits)) {
+				pr_warn("MAC%u: limits are not inited\n",
+					mac->macid);
+				return -EINVAL;
+			}
+
+			if (unlikely(tlv_value_len != sizeof(*limit_record))) {
+				pr_warn("MAC%u: record size mismatch\n",
+					mac->macid);
+				return -EINVAL;
+			}
+
+			limit_record = (void *)tlv->val;
+			limits[rec].max = le16_to_cpu(limit_record->max_num);
+			mask = le16_to_cpu(limit_record->type_mask);
+			limits[rec].types = qlink_iface_type_mask_to_nl(mask);
+			/* only AP and STA modes are supported */
+			limits[rec].types &= BIT(NL80211_IFTYPE_AP) |
+					     BIT(NL80211_IFTYPE_STATION);
+
+			pr_debug("MAC%u: MAX: %u; TYPES: %.4X\n", mac->macid,
+				 limits[rec].max, limits[rec].types);
+
+			if (limits[rec].types)
+				rec++;
+			break;
+		default:
+			break;
+		}
+		tlv_buf_size -= tlv_full_len;
+		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+	}
+
+	if (tlv_buf_size) {
+		pr_warn("MAC%u: malformed TLV buf; bytes left: %zu\n",
+			mac->macid, tlv_buf_size);
+		return -EINVAL;
+	}
+
+	if (mac->macinfo.n_limits != rec) {
+		pr_err("MAC%u: combination mismatch: reported=%zu parsed=%zu\n",
+		       mac->macid, mac->macinfo.n_limits, rec);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void
+qtnf_cmd_resp_proc_mac_info(struct qtnf_wmac *mac,
+			    const struct qlink_resp_get_mac_info *resp_info)
+{
+	struct qtnf_mac_info *mac_info;
+	struct qtnf_vif *vif;
+
+	mac_info = &mac->macinfo;
+
+	mac_info->bands_cap = resp_info->bands_cap;
+	mac_info->phymode_cap = resp_info->phymode_cap;
+	memcpy(&mac_info->dev_mac, &resp_info->dev_mac,
+	       sizeof(mac_info->dev_mac));
+
+	ether_addr_copy(mac->macaddr, mac_info->dev_mac);
+
+	vif = qtnf_mac_get_base_vif(mac);
+	if (vif)
+		ether_addr_copy(vif->mac_addr, mac->macaddr);
+	else
+		pr_err("could not get valid base vif\n");
+
+	mac_info->num_tx_chain = resp_info->num_tx_chain;
+	mac_info->num_rx_chain = resp_info->num_rx_chain;
+
+	mac_info->max_ap_assoc_sta = le16_to_cpu(resp_info->max_ap_assoc_sta);
+	mac_info->radar_detect_widths =
+			qlink_chan_width_mask_to_nl(le16_to_cpu(
+					resp_info->radar_detect_widths));
+
+	memcpy(&mac_info->ht_cap, &resp_info->ht_cap, sizeof(mac_info->ht_cap));
+	memcpy(&mac_info->vht_cap, &resp_info->vht_cap,
+	       sizeof(mac_info->vht_cap));
+}
+
+static int
+qtnf_cmd_resp_fill_channels_info(struct ieee80211_supported_band *band,
+				 struct qlink_resp_get_chan_info *resp,
+				 size_t payload_len)
+{
+	u16 tlv_type;
+	size_t tlv_len;
+	const struct qlink_tlv_hdr *tlv;
+	const struct qlink_tlv_channel *qchan;
+	struct ieee80211_channel *chan;
+	unsigned int chidx = 0;
+	u32 qflags;
+
+	kfree(band->channels);
+	band->channels = NULL;
+
+	band->n_channels = resp->num_chans;
+	if (band->n_channels == 0)
+		return 0;
+
+	band->channels = kcalloc(band->n_channels, sizeof(*chan), GFP_KERNEL);
+	if (!band->channels) {
+		band->n_channels = 0;
+		return -ENOMEM;
+	}
+
+	tlv = (struct qlink_tlv_hdr *)resp->info;
+
+	while (payload_len >= sizeof(*tlv)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_len = le16_to_cpu(tlv->len) + sizeof(*tlv);
+
+		if (tlv_len > payload_len) {
+			pr_warn("malformed TLV 0x%.2X; LEN: %zu\n",
+				tlv_type, tlv_len);
+			goto error_ret;
+		}
+
+		switch (tlv_type) {
+		case QTN_TLV_ID_CHANNEL:
+			if (unlikely(tlv_len != sizeof(*qchan))) {
+				pr_err("invalid channel TLV len %zu\n",
+				       tlv_len);
+				goto error_ret;
+			}
+
+			if (chidx == band->n_channels) {
+				pr_err("too many channel TLVs\n");
+				goto error_ret;
+			}
+
+			qchan = (const struct qlink_tlv_channel *)tlv;
+			chan = &band->channels[chidx++];
+			qflags = le32_to_cpu(qchan->flags);
+
+			chan->hw_value = le16_to_cpu(qchan->hw_value);
+			chan->band = band->band;
+			chan->center_freq = le16_to_cpu(qchan->center_freq);
+			chan->max_antenna_gain = (int)qchan->max_antenna_gain;
+			chan->max_power = (int)qchan->max_power;
+			chan->max_reg_power = (int)qchan->max_reg_power;
+			chan->beacon_found = qchan->beacon_found;
+			chan->dfs_cac_ms = le32_to_cpu(qchan->dfs_cac_ms);
+			chan->flags = 0;
+
+			if (qflags & QLINK_CHAN_DISABLED)
+				chan->flags |= IEEE80211_CHAN_DISABLED;
+
+			if (qflags & QLINK_CHAN_NO_IR)
+				chan->flags |= IEEE80211_CHAN_NO_IR;
+
+			if (qflags & QLINK_CHAN_NO_HT40PLUS)
+				chan->flags |= IEEE80211_CHAN_NO_HT40PLUS;
+
+			if (qflags & QLINK_CHAN_NO_HT40MINUS)
+				chan->flags |= IEEE80211_CHAN_NO_HT40MINUS;
+
+			if (qflags & QLINK_CHAN_NO_OFDM)
+				chan->flags |= IEEE80211_CHAN_NO_OFDM;
+
+			if (qflags & QLINK_CHAN_NO_80MHZ)
+				chan->flags |= IEEE80211_CHAN_NO_80MHZ;
+
+			if (qflags & QLINK_CHAN_NO_160MHZ)
+				chan->flags |= IEEE80211_CHAN_NO_160MHZ;
+
+			if (qflags & QLINK_CHAN_INDOOR_ONLY)
+				chan->flags |= IEEE80211_CHAN_INDOOR_ONLY;
+
+			if (qflags & QLINK_CHAN_IR_CONCURRENT)
+				chan->flags |= IEEE80211_CHAN_IR_CONCURRENT;
+
+			if (qflags & QLINK_CHAN_NO_20MHZ)
+				chan->flags |= IEEE80211_CHAN_NO_20MHZ;
+
+			if (qflags & QLINK_CHAN_NO_10MHZ)
+				chan->flags |= IEEE80211_CHAN_NO_10MHZ;
+
+			if (qflags & QLINK_CHAN_RADAR) {
+				chan->flags |= IEEE80211_CHAN_RADAR;
+				chan->dfs_state_entered = jiffies;
+
+				if (qchan->dfs_state == QLINK_DFS_USABLE)
+					chan->dfs_state = NL80211_DFS_USABLE;
+				else if (qchan->dfs_state ==
+					QLINK_DFS_AVAILABLE)
+					chan->dfs_state = NL80211_DFS_AVAILABLE;
+				else
+					chan->dfs_state =
+						NL80211_DFS_UNAVAILABLE;
+			}
+
+			pr_debug("chan=%d flags=%#x max_pow=%d max_reg_pow=%d\n",
+				 chan->hw_value, chan->flags, chan->max_power,
+				 chan->max_reg_power);
+			break;
+		default:
+			pr_warn("unknown TLV type: %#x\n", tlv_type);
+			break;
+		}
+
+		payload_len -= tlv_len;
+		tlv = (struct qlink_tlv_hdr *)((u8 *)tlv + tlv_len);
+	}
+
+	if (payload_len) {
+		pr_err("malformed TLV buf; bytes left: %zu\n", payload_len);
+		goto error_ret;
+	}
+
+	if (band->n_channels != chidx) {
+		pr_err("channel count mismatch: reported=%d, parsed=%d\n",
+		       band->n_channels, chidx);
+		goto error_ret;
+	}
+
+	return 0;
+
+error_ret:
+	kfree(band->channels);
+	band->channels = NULL;
+	band->n_channels = 0;
+
+	return -EINVAL;
+}
+
+static int qtnf_cmd_resp_proc_phy_params(struct qtnf_wmac *mac,
+					 const u8 *payload, size_t payload_len)
+{
+	struct qtnf_mac_info *mac_info;
+	struct qlink_tlv_frag_rts_thr *phy_thr;
+	struct qlink_tlv_rlimit *limit;
+	struct qlink_tlv_cclass *class;
+	u16 tlv_type;
+	u16 tlv_value_len;
+	size_t tlv_full_len;
+	const struct qlink_tlv_hdr *tlv;
+
+	mac_info = &mac->macinfo;
+
+	tlv = (struct qlink_tlv_hdr *)payload;
+	while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_value_len = le16_to_cpu(tlv->len);
+		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+
+		if (tlv_full_len > payload_len) {
+			pr_warn("MAC%u: malformed TLV 0x%.2X; LEN: %u\n",
+				mac->macid, tlv_type, tlv_value_len);
+			return -EINVAL;
+		}
+
+		switch (tlv_type) {
+		case QTN_TLV_ID_FRAG_THRESH:
+			phy_thr = (void *)tlv;
+			mac_info->frag_thr = (u32)le16_to_cpu(phy_thr->thr);
+			break;
+		case QTN_TLV_ID_RTS_THRESH:
+			phy_thr = (void *)tlv;
+			mac_info->rts_thr = (u32)le16_to_cpu(phy_thr->thr);
+			break;
+		case QTN_TLV_ID_SRETRY_LIMIT:
+			limit = (void *)tlv;
+			mac_info->sretry_limit = limit->rlimit;
+			break;
+		case QTN_TLV_ID_LRETRY_LIMIT:
+			limit = (void *)tlv;
+			mac_info->lretry_limit = limit->rlimit;
+			break;
+		case QTN_TLV_ID_COVERAGE_CLASS:
+			class = (void *)tlv;
+			mac_info->coverage_class = class->cclass;
+			break;
+		default:
+			pr_err("MAC%u: Unknown TLV type: %#x\n", mac->macid,
+			       le16_to_cpu(tlv->type));
+			break;
+		}
+
+		payload_len -= tlv_full_len;
+		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+	}
+
+	if (payload_len) {
+		pr_warn("MAC%u: malformed TLV buf; bytes left: %zu\n",
+			mac->macid, payload_len);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
+{
+	struct sk_buff *cmd_skb, *resp_skb = NULL;
+	const struct qlink_resp_get_mac_info *resp;
+	size_t var_data_len;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
+					    QLINK_CMD_MAC_INFO,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(mac->bus);
+
+	ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+				       sizeof(*resp), &var_data_len);
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	resp = (const struct qlink_resp_get_mac_info *)resp_skb->data;
+	qtnf_cmd_resp_proc_mac_info(mac, resp);
+	ret = qtnf_parse_variable_mac_info(mac, resp->var_info, var_data_len);
+
+out:
+	qtnf_bus_unlock(mac->bus);
+	consume_skb(resp_skb);
+
+	return ret;
+}
+
+int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
+{
+	struct sk_buff *cmd_skb, *resp_skb = NULL;
+	const struct qlink_resp_get_hw_info *resp;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
+					    QLINK_CMD_GET_HW_INFO,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(bus);
+
+	ret = qtnf_cmd_send_with_reply(bus, cmd_skb, &resp_skb, &res_code,
+				       sizeof(*resp), NULL);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	resp = (const struct qlink_resp_get_hw_info *)resp_skb->data;
+	ret = qtnf_cmd_resp_proc_hw_info(bus, resp);
+
+out:
+	qtnf_bus_unlock(bus);
+	consume_skb(resp_skb);
+
+	return ret;
+}
+
+int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
+			       struct ieee80211_supported_band *band)
+{
+	struct sk_buff *cmd_skb, *resp_skb = NULL;
+	size_t info_len;
+	struct qlink_cmd_chans_info_get *cmd;
+	struct qlink_resp_get_chan_info *resp;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+	u8 qband;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
+					    QLINK_CMD_CHANS_INFO_GET,
+					    sizeof(*cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	switch (band->band) {
+	case NL80211_BAND_2GHZ:
+		qband = QLINK_BAND_2GHZ;
+		break;
+	case NL80211_BAND_5GHZ:
+		qband = QLINK_BAND_5GHZ;
+		break;
+	case NL80211_BAND_60GHZ:
+		qband = QLINK_BAND_60GHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	cmd = (struct qlink_cmd_chans_info_get *)cmd_skb->data;
+	cmd->band = qband;
+	ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+				       sizeof(*resp), &info_len);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	resp = (struct qlink_resp_get_chan_info *)resp_skb->data;
+	if (resp->band != qband) {
+		pr_err("MAC%u: reply band %u != cmd band %u\n", mac->macid,
+		       resp->band, qband);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = qtnf_cmd_resp_fill_channels_info(band, resp, info_len);
+
+out:
+	consume_skb(resp_skb);
+
+	return ret;
+}
+
+int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac)
+{
+	struct sk_buff *cmd_skb, *resp_skb = NULL;
+	size_t response_size;
+	struct qlink_resp_phy_params *resp;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
+					    QLINK_CMD_PHY_PARAMS_GET,
+					    sizeof(struct qlink_cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	qtnf_bus_lock(mac->bus);
+
+	ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+				       sizeof(*resp), &response_size);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	resp = (struct qlink_resp_phy_params *)resp_skb->data;
+	ret = qtnf_cmd_resp_proc_phy_params(mac, resp->info, response_size);
+
+out:
+	qtnf_bus_unlock(mac->bus);
+	consume_skb(resp_skb);
+
+	return ret;
+}
+
+int qtnf_cmd_send_update_phy_params(struct qtnf_wmac *mac, u32 changed)
+{
+	struct wiphy *wiphy = priv_to_wiphy(mac);
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
+					    QLINK_CMD_PHY_PARAMS_SET,
+					    sizeof(struct qlink_cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	qtnf_bus_lock(mac->bus);
+
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
+		qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_FRAG_THRESH,
+					 wiphy->frag_threshold);
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD)
+		qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_RTS_THRESH,
+					 wiphy->rts_threshold);
+	if (changed & WIPHY_PARAM_COVERAGE_CLASS)
+		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_COVERAGE_CLASS,
+					wiphy->coverage_class);
+
+	ret = qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_init_fw(struct qtnf_bus *bus)
+{
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
+					    QLINK_CMD_FW_INIT,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(bus);
+
+	ret = qtnf_cmd_send(bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(bus);
+	return ret;
+}
+
+void qtnf_cmd_send_deinit_fw(struct qtnf_bus *bus)
+{
+	struct sk_buff *cmd_skb;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
+					    QLINK_CMD_FW_DEINIT,
+					    sizeof(struct qlink_cmd));
+	if (!cmd_skb)
+		return;
+
+	qtnf_bus_lock(bus);
+
+	qtnf_cmd_send(bus, cmd_skb, NULL);
+
+	qtnf_bus_unlock(bus);
+}
+
+int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
+			  const u8 *mac_addr, struct key_params *params)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_add_key *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_ADD_KEY,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_add_key *)cmd_skb->data;
+
+	if (mac_addr)
+		ether_addr_copy(cmd->addr, mac_addr);
+	else
+		eth_broadcast_addr(cmd->addr);
+
+	cmd->cipher = cpu_to_le32(params->cipher);
+	cmd->key_index = key_index;
+	cmd->pairwise = pairwise;
+
+	if (params->key && params->key_len > 0)
+		qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_KEY,
+					 params->key,
+					 params->key_len);
+
+	if (params->seq && params->seq_len > 0)
+		qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_SEQ,
+					 params->seq,
+					 params->seq_len);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n",
+		       vif->mac->macid, vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
+			  const u8 *mac_addr)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_del_key *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_DEL_KEY,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_del_key *)cmd_skb->data;
+
+	if (mac_addr)
+		ether_addr_copy(cmd->addr, mac_addr);
+	else
+		eth_broadcast_addr(cmd->addr);
+
+	cmd->key_index = key_index;
+	cmd->pairwise = pairwise;
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n",
+		       vif->mac->macid, vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_set_default_key(struct qtnf_vif *vif, u8 key_index,
+				  bool unicast, bool multicast)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_set_def_key *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_SET_DEFAULT_KEY,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_set_def_key *)cmd_skb->data;
+	cmd->key_index = key_index;
+	cmd->unicast = unicast;
+	cmd->multicast = multicast;
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_vif *vif, u8 key_index)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_set_def_mgmt_key *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_SET_DEFAULT_MGMT_KEY,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_set_def_mgmt_key *)cmd_skb->data;
+	cmd->key_index = key_index;
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+static u32 qtnf_encode_sta_flags(u32 flags)
+{
+	u32 code = 0;
+
+	if (flags & BIT(NL80211_STA_FLAG_AUTHORIZED))
+		code |= QLINK_STA_FLAG_AUTHORIZED;
+	if (flags & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
+		code |= QLINK_STA_FLAG_SHORT_PREAMBLE;
+	if (flags & BIT(NL80211_STA_FLAG_WME))
+		code |= QLINK_STA_FLAG_WME;
+	if (flags & BIT(NL80211_STA_FLAG_MFP))
+		code |= QLINK_STA_FLAG_MFP;
+	if (flags & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+		code |= QLINK_STA_FLAG_AUTHENTICATED;
+	if (flags & BIT(NL80211_STA_FLAG_TDLS_PEER))
+		code |= QLINK_STA_FLAG_TDLS_PEER;
+	if (flags & BIT(NL80211_STA_FLAG_ASSOCIATED))
+		code |= QLINK_STA_FLAG_ASSOCIATED;
+	return code;
+}
+
+int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
+			     struct station_parameters *params)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_change_sta *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_CHANGE_STA,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_change_sta *)cmd_skb->data;
+	ether_addr_copy(cmd->sta_addr, mac);
+	cmd->sta_flags_mask = cpu_to_le32(qtnf_encode_sta_flags(
+					  params->sta_flags_mask));
+	cmd->sta_flags_set = cpu_to_le32(qtnf_encode_sta_flags(
+					 params->sta_flags_set));
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
+			  struct station_del_parameters *params)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_del_sta *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_DEL_STA,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_del_sta *)cmd_skb->data;
+
+	if (params->mac)
+		ether_addr_copy(cmd->sta_addr, params->mac);
+	else
+		eth_broadcast_addr(cmd->sta_addr);	/* flush all stations */
+
+	cmd->subtype = params->subtype;
+	cmd->reason_code = cpu_to_le16(params->reason_code);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
+{
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	struct ieee80211_channel *sc;
+	struct cfg80211_scan_request *scan_req = mac->scan_req;
+	struct qlink_tlv_channel *qchan;
+	int n_channels;
+	int count = 0;
+	int ret;
+	u32 flags;
+
+	if (scan_req->n_ssids > QTNF_MAX_SSID_LIST_LENGTH) {
+		pr_err("MAC%u: too many SSIDs in scan request\n", mac->macid);
+		return -EINVAL;
+	}
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
+					    QLINK_CMD_SCAN,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(mac->bus);
+
+	if (scan_req->n_ssids != 0) {
+		while (count < scan_req->n_ssids) {
+			qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID,
+				scan_req->ssids[count].ssid,
+				scan_req->ssids[count].ssid_len);
+			count++;
+		}
+	}
+
+	if (scan_req->ie_len != 0)
+		qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_IE_SET,
+					 scan_req->ie,
+					 scan_req->ie_len);
+
+	if (scan_req->n_channels) {
+		n_channels = scan_req->n_channels;
+		count = 0;
+
+		while (n_channels != 0) {
+			sc = scan_req->channels[count];
+			if (sc->flags & IEEE80211_CHAN_DISABLED) {
+				n_channels--;
+				continue;
+			}
+
+			pr_debug("MAC%u: scan chan=%d, freq=%d, flags=%#x\n",
+				 mac->macid, sc->hw_value, sc->center_freq,
+				 sc->flags);
+			qchan = (struct qlink_tlv_channel *)
+					skb_put(cmd_skb, sizeof(*qchan));
+			memset(qchan, 0, sizeof(*qchan));
+			flags = 0;
+
+			qchan->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANNEL);
+			qchan->hdr.len = cpu_to_le16(sizeof(*qchan) -
+					sizeof(struct qlink_tlv_hdr));
+			qchan->center_freq = cpu_to_le16(sc->center_freq);
+			qchan->hw_value = cpu_to_le16(sc->hw_value);
+
+			if (sc->flags & IEEE80211_CHAN_NO_IR)
+				flags |= QLINK_CHAN_NO_IR;
+
+			if (sc->flags & IEEE80211_CHAN_RADAR)
+				flags |= QLINK_CHAN_RADAR;
+
+			qchan->flags = cpu_to_le32(flags);
+			n_channels--;
+			count++;
+		}
+	}
+
+	ret = qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	pr_debug("MAC%u: scan started\n", mac->macid);
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+out:
+	qtnf_bus_unlock(mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_connect(struct qtnf_vif *vif,
+			  struct cfg80211_connect_params *sme)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_connect *cmd;
+	struct qtnf_bss_config *bss_cfg = &vif->bss_cfg;
+	struct qlink_auth_encr aen;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+	int i;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_CONNECT,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_connect *)cmd_skb->data;
+
+	ether_addr_copy(cmd->bssid, bss_cfg->bssid);
+
+	if (bss_cfg->chandef.chan)
+		cmd->freq = cpu_to_le16(bss_cfg->chandef.chan->center_freq);
+
+	cmd->bg_scan_period = cpu_to_le16(bss_cfg->bg_scan_period);
+
+	memset(&aen, 0, sizeof(aen));
+	aen.auth_type = bss_cfg->auth_type;
+	aen.privacy = !!bss_cfg->privacy;
+	aen.mfp = bss_cfg->mfp;
+	aen.wpa_versions = cpu_to_le32(bss_cfg->crypto.wpa_versions);
+	aen.cipher_group = cpu_to_le32(bss_cfg->crypto.cipher_group);
+	aen.n_ciphers_pairwise = cpu_to_le32(
+					bss_cfg->crypto.n_ciphers_pairwise);
+
+	for (i = 0; i < QLINK_MAX_NR_CIPHER_SUITES; i++)
+		aen.ciphers_pairwise[i] = cpu_to_le32(
+					bss_cfg->crypto.ciphers_pairwise[i]);
+
+	aen.n_akm_suites = cpu_to_le32(bss_cfg->crypto.n_akm_suites);
+
+	for (i = 0; i < QLINK_MAX_NR_AKM_SUITES; i++)
+		aen.akm_suites[i] = cpu_to_le32(
+					bss_cfg->crypto.akm_suites[i]);
+
+	aen.control_port = bss_cfg->crypto.control_port;
+	aen.control_port_no_encrypt =
+			bss_cfg->crypto.control_port_no_encrypt;
+	aen.control_port_ethertype = cpu_to_le16(be16_to_cpu(
+				bss_cfg->crypto.control_port_ethertype));
+
+	qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, bss_cfg->ssid,
+				 bss_cfg->ssid_len);
+	qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_CRYPTO, (u8 *)&aen,
+				 sizeof(aen));
+
+	if (sme->ie_len != 0)
+		qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_IE_SET,
+					 sme->ie,
+					 sme->ie_len);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, u16 reason_code)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_disconnect *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_DISCONNECT,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	cmd = (struct qlink_cmd_disconnect *)cmd_skb->data;
+	cmd->reason = cpu_to_le16(reason_code);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
+
+int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif, bool up)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_updown *cmd;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_UPDOWN_INTF,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	cmd = (struct qlink_cmd_updown *)cmd_skb->data;
+	cmd->if_up = !!up;
+
+	qtnf_bus_lock(vif->mac->bus);
+
+	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
new file mode 100644
index 0000000..6c51854
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -0,0 +1,74 @@
+/*
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
+ */
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
+void qtnf_cmd_send_deinit_fw(struct qtnf_bus *bus);
+int qtnf_cmd_get_hw_info(struct qtnf_bus *bus);
+int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac);
+int qtnf_cmd_send_add_intf(struct qtnf_vif *vif, enum nl80211_iftype iftype,
+			   u8 *mac_addr);
+int qtnf_cmd_send_change_intf_type(struct qtnf_vif *vif,
+				   enum nl80211_iftype iftype, u8 *mac_addr);
+int qtnf_cmd_send_del_intf(struct qtnf_vif *vif);
+int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
+			       struct ieee80211_supported_band *band);
+int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *mac, const char *alpha2);
+int qtnf_cmd_send_config_ap(struct qtnf_vif *vif);
+int qtnf_cmd_send_start_ap(struct qtnf_vif *vif);
+int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif);
+int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool reg);
+int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
+			     u16 freq, const u8 *buf, size_t len);
+int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
+				 const u8 *buf, size_t len);
+int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
+			  struct station_info *sinfo);
+int qtnf_cmd_send_phy_params(struct qtnf_wmac *mac, u16 cmd_action,
+			     void *data_buf);
+int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
+			  const u8 *mac_addr, struct key_params *params);
+int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 key_index, bool pairwise,
+			  const u8 *mac_addr);
+int qtnf_cmd_send_set_default_key(struct qtnf_vif *vif, u8 key_index,
+				  bool unicast, bool multicast);
+int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_vif *vif, u8 key_index);
+int qtnf_cmd_send_add_sta(struct qtnf_vif *vif, const u8 *mac,
+			  struct station_parameters *params);
+int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
+			     struct station_parameters *params);
+int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
+			  struct station_del_parameters *params);
+
+int qtnf_cmd_resp_parse(struct qtnf_bus *bus, struct sk_buff *resp_skb);
+int qtnf_cmd_resp_check(const struct qtnf_vif *vif,
+			const struct sk_buff *resp_skb, u16 cmd_id,
+			u16 *result, const u8 **payload, size_t *payload_size);
+int qtnf_cmd_send_scan(struct qtnf_wmac *mac);
+int qtnf_cmd_send_connect(struct qtnf_vif *vif,
+			  struct cfg80211_connect_params *sme);
+int qtnf_cmd_send_disconnect(struct qtnf_vif *vif,
+			     u16 reason_code);
+int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
+			      bool up);
+
+#endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
new file mode 100644
index 0000000..c5ac252
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -0,0 +1,618 @@
+/*
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
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/if_ether.h>
+
+#include "core.h"
+#include "bus.h"
+#include "trans.h"
+#include "commands.h"
+#include "cfg80211.h"
+#include "event.h"
+#include "util.h"
+
+#define QTNF_DMP_MAX_LEN 48
+#define QTNF_PRIMARY_VIF_IDX	0
+
+struct qtnf_frame_meta_info {
+	u8 magic_s;
+	u8 ifidx;
+	u8 macid;
+	u8 magic_e;
+} __packed;
+
+struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid)
+{
+	struct qtnf_wmac *mac = NULL;
+
+	if (unlikely(macid >= QTNF_MAX_MAC)) {
+		pr_err("invalid MAC index %u\n", macid);
+		return NULL;
+	}
+
+	mac = bus->mac[macid];
+
+	if (unlikely(!mac)) {
+		pr_err("MAC%u: not initialized\n", macid);
+		return NULL;
+	}
+
+	return mac;
+}
+
+/* Netdev handler for open.
+ */
+static int qtnf_netdev_open(struct net_device *ndev)
+{
+	netif_carrier_off(ndev);
+	qtnf_netdev_updown(ndev, 1);
+	return 0;
+}
+
+/* Netdev handler for close.
+ */
+static int qtnf_netdev_close(struct net_device *ndev)
+{
+	netif_carrier_off(ndev);
+	qtnf_virtual_intf_cleanup(ndev);
+	qtnf_netdev_updown(ndev, 0);
+	return 0;
+}
+
+/* Netdev handler for data transmission.
+ */
+static int
+qtnf_netdev_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct qtnf_vif *vif;
+	struct qtnf_wmac *mac;
+
+	vif = qtnf_netdev_get_priv(ndev);
+
+	if (unlikely(skb->dev != ndev)) {
+		pr_err_ratelimited("invalid skb->dev");
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
+
+	if (unlikely(vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)) {
+		pr_err_ratelimited("%s: VIF not initialized\n", ndev->name);
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
+
+	mac = vif->mac;
+	if (unlikely(!mac)) {
+		pr_err_ratelimited("%s: NULL mac pointer", ndev->name);
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
+
+	if (!skb->len || (skb->len > ETH_FRAME_LEN)) {
+		pr_err_ratelimited("%s: invalid skb len %d\n", ndev->name,
+				   skb->len);
+		dev_kfree_skb_any(skb);
+		ndev->stats.tx_dropped++;
+		return 0;
+	}
+
+	/* tx path is enabled: reset vif timeout */
+	vif->cons_tx_timeout_cnt = 0;
+
+	return qtnf_bus_data_tx(mac->bus, skb);
+}
+
+/* Netdev handler for getting stats.
+ */
+static struct net_device_stats *qtnf_netdev_get_stats(struct net_device *dev)
+{
+	return &dev->stats;
+}
+
+/* Netdev handler for transmission timeout.
+ */
+static void qtnf_netdev_tx_timeout(struct net_device *ndev)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	struct qtnf_wmac *mac;
+	struct qtnf_bus *bus;
+
+	if (unlikely(!vif || !vif->mac || !vif->mac->bus))
+		return;
+
+	mac = vif->mac;
+	bus = mac->bus;
+
+	pr_warn("VIF%u.%u: Tx timeout- %lu\n", mac->macid, vif->vifid, jiffies);
+
+	qtnf_bus_data_tx_timeout(bus, ndev);
+	ndev->stats.tx_errors++;
+
+	if (++vif->cons_tx_timeout_cnt > QTNF_TX_TIMEOUT_TRSHLD) {
+		pr_err("Tx timeout threshold exceeded !\n");
+		pr_err("schedule interface %s reset !\n", netdev_name(ndev));
+		queue_work(bus->workqueue, &vif->reset_work);
+	}
+}
+
+/* Network device ops handlers */
+const struct net_device_ops qtnf_netdev_ops = {
+	.ndo_open = qtnf_netdev_open,
+	.ndo_stop = qtnf_netdev_close,
+	.ndo_start_xmit = qtnf_netdev_hard_start_xmit,
+	.ndo_tx_timeout = qtnf_netdev_tx_timeout,
+	.ndo_get_stats = qtnf_netdev_get_stats,
+};
+
+static int qtnf_mac_init_single_band(struct wiphy *wiphy,
+				     struct qtnf_wmac *mac,
+				     enum nl80211_band band)
+{
+	int ret;
+
+	wiphy->bands[band] = kzalloc(sizeof(*wiphy->bands[band]), GFP_KERNEL);
+	if (!wiphy->bands[band])
+		return -ENOMEM;
+
+	wiphy->bands[band]->band = band;
+
+	ret = qtnf_cmd_get_mac_chan_info(mac, wiphy->bands[band]);
+	if (ret) {
+		pr_err("MAC%u: band %u: failed to get chans info: %d\n",
+		       mac->macid, band, ret);
+		return ret;
+	}
+
+	qtnf_band_init_rates(wiphy->bands[band]);
+	qtnf_band_setup_htvht_caps(&mac->macinfo, wiphy->bands[band]);
+
+	return 0;
+}
+
+static int qtnf_mac_init_bands(struct qtnf_wmac *mac)
+{
+	struct wiphy *wiphy = priv_to_wiphy(mac);
+	int ret = 0;
+
+	if (mac->macinfo.bands_cap & QLINK_BAND_2GHZ) {
+		ret = qtnf_mac_init_single_band(wiphy, mac, NL80211_BAND_2GHZ);
+		if (ret)
+			goto out;
+	}
+
+	if (mac->macinfo.bands_cap & QLINK_BAND_5GHZ) {
+		ret = qtnf_mac_init_single_band(wiphy, mac, NL80211_BAND_5GHZ);
+		if (ret)
+			goto out;
+	}
+
+	if (mac->macinfo.bands_cap & QLINK_BAND_60GHZ)
+		ret = qtnf_mac_init_single_band(wiphy, mac, NL80211_BAND_60GHZ);
+
+out:
+	return ret;
+}
+
+struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac)
+{
+	struct qtnf_vif *vif;
+	int i;
+
+	for (i = 0; i < QTNF_MAX_INTF; i++) {
+		vif = &mac->iflist[i];
+		if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
+			return vif;
+	}
+
+	return NULL;
+}
+
+struct qtnf_vif *qtnf_mac_get_base_vif(struct qtnf_wmac *mac)
+{
+	struct qtnf_vif *vif;
+
+	vif = &mac->iflist[QTNF_PRIMARY_VIF_IDX];
+
+	if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
+		return NULL;
+
+	return vif;
+}
+
+static void qtnf_vif_reset_handler(struct work_struct *work)
+{
+	struct qtnf_vif *vif = container_of(work, struct qtnf_vif, reset_work);
+
+	rtnl_lock();
+
+	if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED) {
+		rtnl_unlock();
+		return;
+	}
+
+	/* stop tx completely */
+	netif_tx_stop_all_queues(vif->netdev);
+	if (netif_carrier_ok(vif->netdev))
+		netif_carrier_off(vif->netdev);
+
+	qtnf_cfg80211_vif_reset(vif);
+
+	rtnl_unlock();
+}
+
+static void qtnf_mac_init_primary_intf(struct qtnf_wmac *mac)
+{
+	struct qtnf_vif *vif = &mac->iflist[QTNF_PRIMARY_VIF_IDX];
+
+	vif->wdev.iftype = NL80211_IFTYPE_AP;
+	vif->bss_priority = QTNF_DEF_BSS_PRIORITY;
+	vif->wdev.wiphy = priv_to_wiphy(mac);
+	INIT_WORK(&vif->reset_work, qtnf_vif_reset_handler);
+	vif->cons_tx_timeout_cnt = 0;
+}
+
+static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
+					     unsigned int macid)
+{
+	struct wiphy *wiphy;
+	struct qtnf_wmac *mac;
+	unsigned int i;
+
+	wiphy = qtnf_wiphy_allocate(bus);
+	if (!wiphy)
+		return ERR_PTR(-ENOMEM);
+
+	mac = wiphy_priv(wiphy);
+
+	mac->macid = macid;
+	mac->bus = bus;
+
+	for (i = 0; i < QTNF_MAX_INTF; i++) {
+		memset(&mac->iflist[i], 0, sizeof(struct qtnf_vif));
+		mac->iflist[i].wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		mac->iflist[i].mac = mac;
+		mac->iflist[i].vifid = i;
+		qtnf_sta_list_init(&mac->iflist[i].sta_list);
+	}
+
+	qtnf_mac_init_primary_intf(mac);
+	bus->mac[macid] = mac;
+
+	return mac;
+}
+
+int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *vif,
+			 const char *name, unsigned char name_assign_type,
+			 enum nl80211_iftype iftype)
+{
+	struct wiphy *wiphy = priv_to_wiphy(mac);
+	struct net_device *dev;
+	void *qdev_vif;
+	int ret;
+
+	dev = alloc_netdev_mqs(sizeof(struct qtnf_vif *), name,
+			       name_assign_type, ether_setup, 1, 1);
+	if (!dev) {
+		memset(&vif->wdev, 0, sizeof(vif->wdev));
+		vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		return -ENOMEM;
+	}
+
+	vif->netdev = dev;
+
+	dev->netdev_ops = &qtnf_netdev_ops;
+	dev->destructor = free_netdev;
+	dev_net_set(dev, wiphy_net(wiphy));
+	dev->ieee80211_ptr = &vif->wdev;
+	dev->ieee80211_ptr->iftype = iftype;
+	ether_addr_copy(dev->dev_addr, vif->mac_addr);
+	SET_NETDEV_DEV(dev, wiphy_dev(wiphy));
+	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+	dev->watchdog_timeo = QTNF_DEF_WDOG_TIMEOUT;
+	dev->tx_queue_len = 100;
+
+	qdev_vif = netdev_priv(dev);
+	*((void **)qdev_vif) = vif;
+
+	SET_NETDEV_DEV(dev, mac->bus->dev);
+
+	ret = register_netdevice(dev);
+	if (ret) {
+		free_netdev(dev);
+		vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+	}
+
+	return ret;
+}
+
+static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
+{
+	struct qtnf_wmac *mac;
+	struct wiphy *wiphy;
+	struct qtnf_vif *vif;
+	unsigned int i;
+	enum nl80211_band band;
+
+	mac = bus->mac[macid];
+
+	if (!mac)
+		return;
+
+	wiphy = priv_to_wiphy(mac);
+
+	for (i = 0; i < QTNF_MAX_INTF; i++) {
+		vif = &mac->iflist[i];
+		rtnl_lock();
+		if (vif->netdev &&
+		    vif->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED) {
+			qtnf_virtual_intf_cleanup(vif->netdev);
+			qtnf_del_virtual_intf(wiphy, &vif->wdev);
+		}
+		rtnl_unlock();
+		qtnf_sta_list_free(&vif->sta_list);
+	}
+
+	if (mac->wiphy_registered)
+		wiphy_unregister(wiphy);
+
+	for (band = NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; ++band) {
+		if (!wiphy->bands[band])
+			continue;
+
+		kfree(wiphy->bands[band]->channels);
+		wiphy->bands[band]->n_channels = 0;
+
+		kfree(wiphy->bands[band]);
+		wiphy->bands[band] = NULL;
+	}
+
+	kfree(mac->macinfo.limits);
+	kfree(wiphy->iface_combinations);
+	wiphy_free(wiphy);
+	bus->mac[macid] = NULL;
+}
+
+static int qtnf_core_mac_attach(struct qtnf_bus *bus, unsigned int macid)
+{
+	struct qtnf_wmac *mac;
+	struct qtnf_vif *vif;
+	int ret;
+
+	if (!(bus->hw_info.mac_bitmap & BIT(macid))) {
+		pr_info("MAC%u is not active in FW\n", macid);
+		return 0;
+	}
+
+	mac = qtnf_core_mac_alloc(bus, macid);
+	if (IS_ERR(mac)) {
+		pr_err("MAC%u allocation failed\n", macid);
+		return PTR_ERR(mac);
+	}
+
+	ret = qtnf_cmd_get_mac_info(mac);
+	if (ret) {
+		pr_err("MAC%u: failed to get info\n", macid);
+		goto error;
+	}
+
+	vif = qtnf_mac_get_base_vif(mac);
+	if (!vif) {
+		pr_err("MAC%u: primary VIF is not ready\n", macid);
+		ret = -EFAULT;
+		goto error;
+	}
+
+	ret = qtnf_cmd_send_add_intf(vif, NL80211_IFTYPE_AP, vif->mac_addr);
+	if (ret) {
+		pr_err("MAC%u: failed to add VIF\n", macid);
+		goto error;
+	}
+
+	ret = qtnf_cmd_send_get_phy_params(mac);
+	if (ret) {
+		pr_err("MAC%u: failed to get PHY settings\n", macid);
+		goto error;
+	}
+
+	ret = qtnf_mac_init_bands(mac);
+	if (ret) {
+		pr_err("MAC%u: failed to init bands\n", macid);
+		goto error;
+	}
+
+	ret = qtnf_wiphy_register(&bus->hw_info, mac);
+	if (ret) {
+		pr_err("MAC%u: wiphy registration failed\n", macid);
+		goto error;
+	}
+
+	mac->wiphy_registered = 1;
+
+	rtnl_lock();
+
+	ret = qtnf_core_net_attach(mac, vif, "wlan%d", NET_NAME_ENUM,
+				   NL80211_IFTYPE_AP);
+	rtnl_unlock();
+
+	if (ret) {
+		pr_err("MAC%u: failed to attach netdev\n", macid);
+		vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		vif->netdev = NULL;
+		goto error;
+	}
+
+	pr_debug("MAC%u initialized\n", macid);
+
+	return 0;
+
+error:
+	qtnf_core_mac_detach(bus, macid);
+	return ret;
+}
+
+int qtnf_core_attach(struct qtnf_bus *bus)
+{
+	unsigned int i;
+	int ret;
+
+	qtnf_trans_init(bus);
+
+	bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
+	qtnf_bus_data_rx_start(bus);
+
+	bus->workqueue = alloc_ordered_workqueue("QTNF_BUS", 0);
+	if (!bus->workqueue) {
+		pr_err("failed to alloc main workqueue\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	INIT_WORK(&bus->event_work, qtnf_event_work_handler);
+
+	ret = qtnf_cmd_send_init_fw(bus);
+	if (ret) {
+		pr_err("failed to init FW: %d\n", ret);
+		goto error;
+	}
+
+	bus->fw_state = QTNF_FW_STATE_ACTIVE;
+
+	ret = qtnf_cmd_get_hw_info(bus);
+	if (ret) {
+		pr_err("failed to get HW info: %d\n", ret);
+		goto error;
+	}
+
+	if (bus->hw_info.ql_proto_ver != QLINK_PROTO_VER) {
+		pr_err("qlink version mismatch %u != %u\n",
+		       QLINK_PROTO_VER, bus->hw_info.ql_proto_ver);
+		ret = -EPROTONOSUPPORT;
+		goto error;
+	}
+
+	if (bus->hw_info.num_mac > QTNF_MAX_MAC) {
+		pr_err("no support for number of MACs=%u\n",
+		       bus->hw_info.num_mac);
+		ret = -ERANGE;
+		goto error;
+	}
+
+	for (i = 0; i < bus->hw_info.num_mac; i++) {
+		ret = qtnf_core_mac_attach(bus, i);
+
+		if (ret) {
+			pr_err("MAC%u: attach failed: %d\n", i, ret);
+			goto error;
+		}
+	}
+
+	return 0;
+
+error:
+	qtnf_core_detach(bus);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qtnf_core_attach);
+
+void qtnf_core_detach(struct qtnf_bus *bus)
+{
+	unsigned int macid;
+
+	qtnf_bus_data_rx_stop(bus);
+
+	for (macid = 0; macid < QTNF_MAX_MAC; macid++)
+		qtnf_core_mac_detach(bus, macid);
+
+	if (bus->fw_state == QTNF_FW_STATE_ACTIVE)
+		qtnf_cmd_send_deinit_fw(bus);
+
+	bus->fw_state = QTNF_FW_STATE_DEAD;
+
+	if (bus->workqueue) {
+		flush_workqueue(bus->workqueue);
+		destroy_workqueue(bus->workqueue);
+	}
+
+	qtnf_trans_free(bus);
+}
+EXPORT_SYMBOL_GPL(qtnf_core_detach);
+
+static inline int qtnf_is_frame_meta_magic_valid(struct qtnf_frame_meta_info *m)
+{
+	return m->magic_s == 0xAB && m->magic_e == 0xBA;
+}
+
+struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	struct qtnf_frame_meta_info *meta;
+	struct net_device *ndev = NULL;
+	struct qtnf_wmac *mac;
+	struct qtnf_vif *vif;
+
+	meta = (struct qtnf_frame_meta_info *)
+		(skb_tail_pointer(skb) - sizeof(*meta));
+
+	if (unlikely(!qtnf_is_frame_meta_magic_valid(meta))) {
+		pr_err_ratelimited("invalid magic 0x%x:0x%x\n",
+				   meta->magic_s, meta->magic_e);
+		goto out;
+	}
+
+	if (unlikely(meta->macid >= QTNF_MAX_MAC)) {
+		pr_err_ratelimited("invalid mac(%u)\n", meta->macid);
+		goto out;
+	}
+
+	if (unlikely(meta->ifidx >= QTNF_MAX_INTF)) {
+		pr_err_ratelimited("invalid vif(%u)\n", meta->ifidx);
+		goto out;
+	}
+
+	mac = bus->mac[meta->macid];
+
+	if (unlikely(!mac)) {
+		pr_err_ratelimited("mac(%d) does not exist\n", meta->macid);
+		goto out;
+	}
+
+	vif = &mac->iflist[meta->ifidx];
+
+	if (unlikely(vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)) {
+		pr_err_ratelimited("vif(%u) does not exists\n", meta->ifidx);
+		goto out;
+	}
+
+	ndev = vif->netdev;
+
+	if (unlikely(!ndev)) {
+		pr_err_ratelimited("netdev for wlan%u.%u does not exists\n",
+				   meta->macid, meta->ifidx);
+		goto out;
+	}
+
+	__skb_trim(skb, skb->len - sizeof(*meta));
+
+out:
+	return ndev;
+}
+EXPORT_SYMBOL_GPL(qtnf_classify_skb);
+
+MODULE_AUTHOR("Quantenna Communications");
+MODULE_DESCRIPTION("Quantenna 802.11 wireless LAN FullMAC driver.");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
new file mode 100644
index 0000000..a616434
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -0,0 +1,173 @@
+/*
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
+ */
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
+#undef pr_fmt
+#define pr_fmt(fmt)	KBUILD_MODNAME ": %s: " fmt, __func__
+
+#define QTNF_MAX_SSID_LIST_LENGTH	2
+#define QTNF_MAX_VSIE_LEN		255
+#define QTNF_MAX_ALPHA_LEN		2
+#define QTNF_MAX_INTF			8
+#define QTNF_MAX_EVENT_QUEUE_LEN	255
+#define QTNF_DEFAULT_BG_SCAN_PERIOD	300
+#define QTNF_MAX_BG_SCAN_PERIOD		0xffff
+
+#define QTNF_DEF_BSS_PRIORITY		0
+#define QTNF_DEF_WDOG_TIMEOUT		5
+#define QTNF_TX_TIMEOUT_TRSHLD		100
+
+#define QTNF_STATE_AP_CONFIG		BIT(2)
+#define QTNF_STATE_AP_START		BIT(1)
+
+extern const struct net_device_ops qtnf_netdev_ops;
+struct qtnf_bus;
+struct qtnf_vif;
+
+struct qtnf_bss_config {
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 bssid[ETH_ALEN];
+	size_t ssid_len;
+	u8 dtim;
+	u16 bcn_period;
+	u16 auth_type;
+	bool privacy;
+	enum nl80211_mfp mfp;
+	struct cfg80211_chan_def chandef;
+	struct cfg80211_crypto_settings crypto;
+	u16 bg_scan_period;
+	u32 connect_flags;
+};
+
+struct qtnf_sta_node {
+	struct list_head list;
+	u8 mac_addr[ETH_ALEN];
+};
+
+struct qtnf_sta_list {
+	struct list_head head;
+	atomic_t size;
+};
+
+enum qtnf_sta_state {
+	QTNF_STA_DISCONNECTED,
+	QTNF_STA_CONNECTING,
+	QTNF_STA_CONNECTED
+};
+
+struct qtnf_vif {
+	struct wireless_dev wdev;
+	u8 vifid;
+	u8 bss_priority;
+	u8 bss_status;
+	enum qtnf_sta_state sta_state;
+	u16 mgmt_frames_bitmask;
+	struct net_device *netdev;
+	struct qtnf_wmac *mac;
+	u8 mac_addr[ETH_ALEN];
+	struct work_struct reset_work;
+	struct qtnf_bss_config bss_cfg;
+	struct qtnf_sta_list sta_list;
+	unsigned long cons_tx_timeout_cnt;
+};
+
+struct qtnf_mac_info {
+	u8 bands_cap;
+	u8 phymode_cap;
+	u8 dev_mac[ETH_ALEN];
+	u8 num_tx_chain;
+	u8 num_rx_chain;
+	u16 max_ap_assoc_sta;
+	u32 frag_thr;
+	u32 rts_thr;
+	u8 lretry_limit;
+	u8 sretry_limit;
+	u8 coverage_class;
+	u8 radar_detect_widths;
+	struct ieee80211_ht_cap ht_cap;
+	struct ieee80211_vht_cap vht_cap;
+	struct ieee80211_iface_limit *limits;
+	size_t n_limits;
+};
+
+struct qtnf_wmac {
+	u8 macid;
+	u8 wiphy_registered;
+	u8 macaddr[ETH_ALEN];
+	struct qtnf_bus *bus;
+	struct qtnf_mac_info macinfo;
+	struct qtnf_vif iflist[QTNF_MAX_INTF];
+	struct cfg80211_scan_request *scan_req;
+};
+
+struct qtnf_hw_info {
+	u8 num_mac;
+	u8 mac_bitmap;
+	u8 alpha2_code[QTNF_MAX_ALPHA_LEN];
+	u32 fw_ver;
+	u16 ql_proto_ver;
+	u8 total_tx_chain;
+	u8 total_rx_chain;
+	u32 hw_capab;
+};
+
+struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac);
+struct qtnf_vif *qtnf_mac_get_base_vif(struct qtnf_wmac *mac);
+struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus);
+int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *priv,
+			 const char *name, unsigned char name_assign_type,
+			 enum nl80211_iftype iftype);
+void qtnf_main_work_queue(struct work_struct *work);
+int qtnf_cmd_send_update_phy_params(struct qtnf_wmac *mac, u32 changed);
+int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac);
+
+struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_bus *bus, u8 macid);
+struct net_device *qtnf_classify_skb(struct qtnf_bus *bus, struct sk_buff *skb);
+struct net_device *qtnf_classify_skb_no_mbss(struct qtnf_bus *bus,
+					     struct sk_buff *skb);
+
+void qtnf_virtual_intf_cleanup(struct net_device *ndev);
+
+void qtnf_netdev_updown(struct net_device *ndev, bool up);
+
+static inline struct qtnf_vif *qtnf_netdev_get_priv(struct net_device *dev)
+{
+	return *((void **)netdev_priv(dev));
+}
+
+#endif /* _QTN_FMAC_CORE_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/debug.c b/drivers/net/wireless/quantenna/qtnfmac/debug.c
new file mode 100644
index 0000000..9f826b9
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/debug.c
@@ -0,0 +1,46 @@
+/*
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
+ */
+
+#include "debug.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"qtnfmac dbg: %s: " fmt, __func__
+
+void qtnf_debugfs_init(struct qtnf_bus *bus, const char *name)
+{
+	bus->dbg_dir = debugfs_create_dir(name, NULL);
+
+	if (IS_ERR_OR_NULL(bus->dbg_dir)) {
+		pr_warn("failed to create debugfs root dir\n");
+		bus->dbg_dir = NULL;
+	}
+}
+
+void qtnf_debugfs_remove(struct qtnf_bus *bus)
+{
+	debugfs_remove_recursive(bus->dbg_dir);
+	bus->dbg_dir = NULL;
+}
+
+void qtnf_debugfs_add_entry(struct qtnf_bus *bus, const char *name,
+			    int (*fn)(struct seq_file *seq, void *data))
+{
+	struct dentry *entry;
+
+	entry = debugfs_create_devm_seqfile(bus->dev, name, bus->dbg_dir, fn);
+	if (IS_ERR_OR_NULL(entry))
+		pr_warn("failed to add entry (%s)\n", name);
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/debug.h b/drivers/net/wireless/quantenna/qtnfmac/debug.h
new file mode 100644
index 0000000..d6dd12b5
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/debug.h
@@ -0,0 +1,50 @@
+/*
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
+ */
+
+#ifndef _QTN_FMAC_DEBUG_H_
+#define _QTN_FMAC_DEBUG_H_
+
+#include <linux/debugfs.h>
+
+#include "core.h"
+#include "bus.h"
+
+#ifdef CONFIG_DEBUG_FS
+
+void qtnf_debugfs_init(struct qtnf_bus *bus, const char *name);
+void qtnf_debugfs_remove(struct qtnf_bus *bus);
+void qtnf_debugfs_add_entry(struct qtnf_bus *bus, const char *name,
+			    int (*fn)(struct seq_file *seq, void *data));
+
+#else
+
+static inline void qtnf_debugfs_init(struct qtnf_bus *bus, const char *name)
+{
+}
+
+static inline void qtnf_debugfs_remove(struct qtnf_bus *bus)
+{
+}
+
+static inline void
+qtnf_debugfs_add_entry(struct qtnf_bus *bus, const char *name,
+		       int (*fn)(struct seq_file *seq, void *data))
+{
+}
+
+#endif /* CONFIG_DEBUG_FS */
+
+#endif /* _QTN_FMAC_DEBUG_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
new file mode 100644
index 0000000..9b61e9a
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -0,0 +1,452 @@
+/*
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
+ */
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
+			    const struct qlink_event_sta_assoc *sta_assoc,
+			    u16 len)
+{
+	const u8 *sta_addr;
+	u16 frame_control;
+	struct station_info sinfo = { 0 };
+	size_t payload_len;
+	u16 tlv_type;
+	u16 tlv_value_len;
+	size_t tlv_full_len;
+	const struct qlink_tlv_hdr *tlv;
+
+	if (unlikely(len < sizeof(*sta_assoc))) {
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       mac->macid, vif->vifid, len, sizeof(*sta_assoc));
+		return -EINVAL;
+	}
+
+	if (vif->wdev.iftype != NL80211_IFTYPE_AP) {
+		pr_err("VIF%u.%u: STA_ASSOC event when not in AP mode\n",
+		       mac->macid, vif->vifid);
+		return -EPROTO;
+	}
+
+	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+		pr_err("VIF%u.%u: STA_ASSOC event when AP is not started\n",
+		       mac->macid, vif->vifid);
+		return -EPROTO;
+	}
+
+	sta_addr = sta_assoc->sta_addr;
+	frame_control = le16_to_cpu(sta_assoc->frame_control);
+
+	pr_debug("VIF%u.%u: MAC:%pM FC:%x\n", mac->macid, vif->vifid, sta_addr,
+		 frame_control);
+
+	qtnf_sta_list_add(&vif->sta_list, sta_addr);
+
+	sinfo.assoc_req_ies = NULL;
+	sinfo.assoc_req_ies_len = 0;
+
+	payload_len = len - sizeof(*sta_assoc);
+	tlv = (struct qlink_tlv_hdr *)sta_assoc->ies;
+
+	while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_value_len = le16_to_cpu(tlv->len);
+		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+
+		if (tlv_full_len > payload_len) {
+			pr_warn("VIF%u.%u: malformed TLV 0x%.2X; LEN: %u\n",
+				mac->macid, vif->vifid, tlv_type,
+				tlv_value_len);
+			return -EINVAL;
+		}
+
+		if (tlv_type == QTN_TLV_ID_IE_SET) {
+			sinfo.assoc_req_ies = tlv->val;
+			sinfo.assoc_req_ies_len = tlv_value_len;
+		}
+
+		payload_len -= tlv_full_len;
+		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+	}
+
+	if (payload_len) {
+		pr_warn("VIF%u.%u: malformed TLV buf; bytes left: %zu\n",
+			mac->macid, vif->vifid, payload_len);
+		return -EINVAL;
+	}
+
+	cfg80211_new_sta(vif->netdev, sta_assoc->sta_addr, &sinfo,
+			 GFP_KERNEL);
+
+	return 0;
+}
+
+static int
+qtnf_event_handle_sta_deauth(struct qtnf_wmac *mac, struct qtnf_vif *vif,
+			     const struct qlink_event_sta_deauth *sta_deauth,
+			     u16 len)
+{
+	const u8 *sta_addr;
+	u16 reason;
+
+	if (unlikely(len < sizeof(*sta_deauth))) {
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       mac->macid, vif->vifid, len,
+		       sizeof(struct qlink_event_sta_deauth));
+		return -EINVAL;
+	}
+
+	if (vif->wdev.iftype != NL80211_IFTYPE_AP) {
+		pr_err("VIF%u.%u: STA_DEAUTH event when not in AP mode\n",
+		       mac->macid, vif->vifid);
+		return -EPROTO;
+	}
+
+	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+		pr_err("VIF%u.%u: STA_DEAUTH event when AP is not started\n",
+		       mac->macid, vif->vifid);
+		return -EPROTO;
+	}
+
+	sta_addr = sta_deauth->sta_addr;
+	reason = le16_to_cpu(sta_deauth->reason);
+
+	pr_debug("VIF%u.%u: MAC:%pM reason:%x\n", mac->macid, vif->vifid,
+		 sta_addr, reason);
+
+	if (qtnf_sta_list_del(&vif->sta_list, sta_addr))
+		cfg80211_del_sta(vif->netdev, sta_deauth->sta_addr,
+				 GFP_KERNEL);
+
+	return 0;
+}
+
+static int
+qtnf_event_handle_bss_join(struct qtnf_vif *vif,
+			   const struct qlink_event_bss_join *join_info,
+			   u16 len)
+{
+	if (unlikely(len < sizeof(*join_info))) {
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       vif->mac->macid, vif->vifid, len,
+		       sizeof(struct qlink_event_bss_join));
+		return -EINVAL;
+	}
+
+	if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
+		pr_err("VIF%u.%u: BSS_JOIN event when not in STA mode\n",
+		       vif->mac->macid, vif->vifid);
+		return -EPROTO;
+	}
+
+	if (vif->sta_state != QTNF_STA_CONNECTING) {
+		pr_err("VIF%u.%u: BSS_JOIN event when STA is not connecting\n",
+		       vif->mac->macid, vif->vifid);
+		return -EPROTO;
+	}
+
+	pr_debug("VIF%u.%u: BSSID:%pM\n", vif->mac->macid, vif->vifid,
+		 join_info->bssid);
+
+	cfg80211_connect_result(vif->netdev, join_info->bssid, NULL, 0, NULL,
+				0, le16_to_cpu(join_info->status), GFP_KERNEL);
+
+	if (le16_to_cpu(join_info->status) == WLAN_STATUS_SUCCESS) {
+		vif->sta_state = QTNF_STA_CONNECTED;
+		netif_carrier_on(vif->netdev);
+	} else {
+		vif->sta_state = QTNF_STA_DISCONNECTED;
+	}
+
+	return 0;
+}
+
+static int
+qtnf_event_handle_bss_leave(struct qtnf_vif *vif,
+			    const struct qlink_event_bss_leave *leave_info,
+			    u16 len)
+{
+	if (unlikely(len < sizeof(*leave_info))) {
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       vif->mac->macid, vif->vifid, len,
+		       sizeof(struct qlink_event_bss_leave));
+		return -EINVAL;
+	}
+
+	if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
+		pr_err("VIF%u.%u: BSS_LEAVE event when not in STA mode\n",
+		       vif->mac->macid, vif->vifid);
+		return -EPROTO;
+	}
+
+	if (vif->sta_state != QTNF_STA_CONNECTED) {
+		pr_err("VIF%u.%u: BSS_LEAVE event when STA is not connected\n",
+		       vif->mac->macid, vif->vifid);
+		return -EPROTO;
+	}
+
+	pr_debug("VIF%u.%u: disconnected\n", vif->mac->macid, vif->vifid);
+
+	cfg80211_disconnected(vif->netdev, leave_info->reason, NULL, 0, 0,
+			      GFP_KERNEL);
+
+	vif->sta_state = QTNF_STA_DISCONNECTED;
+	netif_carrier_off(vif->netdev);
+
+	return 0;
+}
+
+static int
+qtnf_event_handle_mgmt_received(struct qtnf_vif *vif,
+				const struct qlink_event_rxmgmt *rxmgmt,
+				u16 len)
+{
+	const size_t min_len = sizeof(*rxmgmt) +
+			       sizeof(struct ieee80211_hdr_3addr);
+	const struct ieee80211_hdr_3addr *frame = (void *)rxmgmt->frame_data;
+	const u16 frame_len = len - sizeof(*rxmgmt);
+	enum nl80211_rxmgmt_flags flags = 0;
+
+	if (unlikely(len < min_len)) {
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       vif->mac->macid, vif->vifid, len, min_len);
+		return -EINVAL;
+	}
+
+	if (le32_to_cpu(rxmgmt->flags) & QLINK_RXMGMT_FLAG_ANSWERED)
+		flags |= NL80211_RXMGMT_FLAG_ANSWERED;
+
+	pr_debug("%s LEN:%u FC:%.4X SA:%pM\n", vif->netdev->name, frame_len,
+		 le16_to_cpu(frame->frame_control), frame->addr2);
+
+	cfg80211_rx_mgmt(&vif->wdev, le32_to_cpu(rxmgmt->freq),
+			 le32_to_cpu(rxmgmt->sig_dbm), rxmgmt->frame_data,
+			 frame_len, flags);
+
+	return 0;
+}
+
+static int
+qtnf_event_handle_scan_results(struct qtnf_vif *vif,
+			       const struct qlink_event_scan_result *sr,
+			       u16 len)
+{
+	struct cfg80211_bss *bss;
+	struct ieee80211_channel *channel;
+	struct wiphy *wiphy = priv_to_wiphy(vif->mac);
+	enum cfg80211_bss_frame_type frame_type;
+	size_t payload_len;
+	u16 tlv_type;
+	u16 tlv_value_len;
+	size_t tlv_full_len;
+	const struct qlink_tlv_hdr *tlv;
+
+	const u8 *ies = NULL;
+	size_t ies_len = 0;
+
+	if (len < sizeof(*sr)) {
+		pr_err("VIF%u.%u: payload is too short\n", vif->mac->macid,
+		       vif->vifid);
+		return -EINVAL;
+	}
+
+	channel = ieee80211_get_channel(wiphy, le16_to_cpu(sr->freq));
+	if (!channel) {
+		pr_err("VIF%u.%u: channel at %u MHz not found\n",
+		       vif->mac->macid, vif->vifid, le16_to_cpu(sr->freq));
+		return -EINVAL;
+	}
+
+	switch (sr->frame_type) {
+	case QLINK_BSS_FTYPE_BEACON:
+		frame_type = CFG80211_BSS_FTYPE_BEACON;
+		break;
+	case QLINK_BSS_FTYPE_PRESP:
+		frame_type = CFG80211_BSS_FTYPE_PRESP;
+		break;
+	default:
+		frame_type = CFG80211_BSS_FTYPE_UNKNOWN;
+	}
+
+	payload_len = len - sizeof(*sr);
+	tlv = (struct qlink_tlv_hdr *)sr->payload;
+
+	while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_value_len = le16_to_cpu(tlv->len);
+		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
+
+		if (tlv_full_len > payload_len) {
+			pr_warn("VIF%u.%u: malformed TLV 0x%.2X; LEN: %u\n",
+				vif->mac->macid, vif->vifid, tlv_type,
+				tlv_value_len);
+			return -EINVAL;
+		}
+
+		if (tlv_type == QTN_TLV_ID_IE_SET) {
+			ies = tlv->val;
+			ies_len = tlv_value_len;
+		}
+
+		payload_len -= tlv_full_len;
+		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+	}
+
+	if (payload_len) {
+		pr_warn("VIF%u.%u: malformed TLV buf; bytes left: %zu\n",
+			vif->mac->macid, vif->vifid, payload_len);
+		return -EINVAL;
+	}
+
+	bss = cfg80211_inform_bss(wiphy, channel, frame_type,
+				  sr->bssid, get_unaligned_le64(&sr->tsf),
+				  le16_to_cpu(sr->capab),
+				  le16_to_cpu(sr->bintval), ies, ies_len,
+				  sr->signal, GFP_KERNEL);
+	if (!bss)
+		return -ENOMEM;
+
+	cfg80211_put_bss(wiphy, bss);
+
+	return 0;
+}
+
+static int
+qtnf_event_handle_scan_complete(struct qtnf_wmac *mac,
+				const struct qlink_event_scan_complete *status,
+				u16 len)
+{
+	if (len < sizeof(*status)) {
+		pr_err("MAC%u: payload is too short\n", mac->macid);
+		return -EINVAL;
+	}
+
+	qtnf_scan_done(mac, le32_to_cpu(status->flags) & QLINK_SCAN_ABORTED);
+
+	return 0;
+}
+
+static int qtnf_event_parse(struct qtnf_wmac *mac,
+			    const struct sk_buff *event_skb)
+{
+	const struct qlink_event *event;
+	struct qtnf_vif *vif = NULL;
+	int ret = -1;
+	u16 event_id;
+	u16 event_len;
+
+	event = (const struct qlink_event *)event_skb->data;
+	event_id = le16_to_cpu(event->event_id);
+	event_len = le16_to_cpu(event->mhdr.len);
+
+	if (likely(event->vifid < QTNF_MAX_INTF)) {
+		vif = &mac->iflist[event->vifid];
+	} else {
+		pr_err("invalid vif(%u)\n", event->vifid);
+		return -EINVAL;
+	}
+
+	switch (event_id) {
+	case QLINK_EVENT_STA_ASSOCIATED:
+		ret = qtnf_event_handle_sta_assoc(mac, vif, (const void *)event,
+						  event_len);
+		break;
+	case QLINK_EVENT_STA_DEAUTH:
+		ret = qtnf_event_handle_sta_deauth(mac, vif,
+						   (const void *)event,
+						   event_len);
+		break;
+	case QLINK_EVENT_MGMT_RECEIVED:
+		ret = qtnf_event_handle_mgmt_received(vif, (const void *)event,
+						      event_len);
+		break;
+	case QLINK_EVENT_SCAN_RESULTS:
+		ret = qtnf_event_handle_scan_results(vif, (const void *)event,
+						     event_len);
+		break;
+	case QLINK_EVENT_SCAN_COMPLETE:
+		ret = qtnf_event_handle_scan_complete(mac, (const void *)event,
+						      event_len);
+		break;
+	case QLINK_EVENT_BSS_JOIN:
+		ret = qtnf_event_handle_bss_join(vif, (const void *)event,
+						 event_len);
+		break;
+	case QLINK_EVENT_BSS_LEAVE:
+		ret = qtnf_event_handle_bss_leave(vif, (const void *)event,
+						  event_len);
+		break;
+	default:
+		pr_warn("unknown event type: %x\n", event_id);
+		break;
+	}
+
+	return ret;
+}
+
+static int qtnf_event_process_skb(struct qtnf_bus *bus,
+				  const struct sk_buff *skb)
+{
+	const struct qlink_event *event;
+	struct qtnf_wmac *mac;
+	int res;
+
+	if (unlikely(!skb || skb->len < sizeof(*event))) {
+		pr_err("invalid event buffer\n");
+		return -EINVAL;
+	}
+
+	event = (struct qlink_event *)skb->data;
+
+	mac = qtnf_core_get_mac(bus, event->macid);
+
+	pr_debug("new event id:%x len:%u mac:%u vif:%u\n",
+		 le16_to_cpu(event->event_id), le16_to_cpu(event->mhdr.len),
+		 event->macid, event->vifid);
+
+	if (unlikely(!mac))
+		return -ENXIO;
+
+	qtnf_bus_lock(bus);
+	res = qtnf_event_parse(mac, skb);
+	qtnf_bus_unlock(bus);
+
+	return res;
+}
+
+void qtnf_event_work_handler(struct work_struct *work)
+{
+	struct qtnf_bus *bus = container_of(work, struct qtnf_bus, event_work);
+	struct sk_buff_head *event_queue = &bus->trans.event_queue;
+	struct sk_buff *current_event_skb = skb_dequeue(event_queue);
+
+	while (current_event_skb) {
+		qtnf_event_process_skb(bus, current_event_skb);
+		dev_kfree_skb_any(current_event_skb);
+		current_event_skb = skb_dequeue(event_queue);
+	}
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.h b/drivers/net/wireless/quantenna/qtnfmac/event.h
new file mode 100644
index 0000000..ae759b6
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.h
@@ -0,0 +1,27 @@
+/*
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
+ */
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
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
new file mode 100644
index 0000000..4814d90
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -0,0 +1,1378 @@
+/*
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
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/pci.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/crc32.h>
+#include <linux/spinlock.h>
+
+#include "qtn_hw_ids.h"
+#include "pcie_bus_priv.h"
+#include "core.h"
+#include "bus.h"
+#include "debug.h"
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
+static u8 flashboot = 1;
+module_param(flashboot, byte, 0644);
+MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary file on FS");
+
+#define DRV_NAME	"qtnfmac_pearl_pcie"
+
+static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
+{
+	writel(val, basereg);
+
+	/* flush posted write */
+	readl(basereg);
+}
+
+static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irq_lock, flags);
+	priv->pcie_irq_mask = (PCIE_HDP_INT_RX_BITS | PCIE_HDP_INT_TX_BITS);
+	spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irq_lock, flags);
+	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irq_lock, flags);
+	writel(0x0, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irq_lock, flags);
+	priv->pcie_irq_mask |= PCIE_HDP_INT_RX_BITS;
+	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irq_lock, flags);
+	priv->pcie_irq_mask &= ~PCIE_HDP_INT_RX_BITS;
+	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_en_txdone_irq(struct qtnf_pcie_bus_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irq_lock, flags);
+	priv->pcie_irq_mask |= PCIE_HDP_INT_TX_BITS;
+	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_bus_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irq_lock, flags);
+	priv->pcie_irq_mask &= ~PCIE_HDP_INT_TX_BITS;
+	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	spin_unlock_irqrestore(&priv->irq_lock, flags);
+}
+
+static int qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
+{
+	struct pci_dev *pdev = priv->pdev;
+
+	/* fall back to legacy INTx interrupts by default */
+	priv->msi_enabled = 0;
+
+	/* check if MSI capability is available */
+	if (use_msi) {
+		if (!pci_enable_msi(pdev)) {
+			pr_debug("MSI interrupt enabled\n");
+			priv->msi_enabled = 1;
+		} else {
+			pr_warn("failed to enable MSI interrupts");
+		}
+	}
+
+	if (!priv->msi_enabled) {
+		pr_warn("legacy PCIE interrupts enabled\n");
+		pci_intx(pdev, 1);
+	}
+
+	return 0;
+}
+
+static void qtnf_deassert_intx(struct qtnf_pcie_bus_priv *priv)
+{
+	void __iomem *reg = priv->sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
+	u32 cfg;
+
+	cfg = readl(reg);
+	cfg &= ~PEARL_ASSERT_INTX;
+	qtnf_non_posted_write(cfg, reg);
+}
+
+static void qtnf_ipc_gen_ep_int(void *arg)
+{
+	const struct qtnf_pcie_bus_priv *priv = arg;
+	const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_IPC_IRQ);
+	void __iomem *reg = priv->sysctl_bar +
+			    QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
+
+	qtnf_non_posted_write(data, reg);
+}
+
+static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 index)
+{
+	void __iomem *vaddr;
+	dma_addr_t busaddr;
+	size_t len;
+	int ret;
+
+	ret = pcim_iomap_regions(priv->pdev, 1 << index, DRV_NAME);
+	if (ret)
+		return IOMEM_ERR_PTR(ret);
+
+	busaddr = pci_resource_start(priv->pdev, index);
+	vaddr = pcim_iomap_table(priv->pdev)[index];
+	len = pci_resource_len(priv->pdev, index);
+
+	pr_debug("BAR%u vaddr=0x%p busaddr=%pad len=%u\n",
+		 index, vaddr, &busaddr, (int)len);
+
+	return vaddr;
+}
+
+static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t len)
+{
+	struct qtnf_pcie_bus_priv *priv = arg;
+	struct qtnf_bus *bus = pci_get_drvdata(priv->pdev);
+	struct sk_buff *skb;
+
+	if (unlikely(len == 0)) {
+		pr_warn("zero length packet received\n");
+		return;
+	}
+
+	skb = __dev_alloc_skb(len, GFP_KERNEL);
+
+	if (unlikely(!skb)) {
+		pr_err("failed to allocate skb\n");
+		return;
+	}
+
+	memcpy(skb_put(skb, len), buf, len);
+
+	qtnf_trans_handle_rx_ctl_packet(bus, skb);
+}
+
+static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+{
+	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
+	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
+	const struct qtnf_shm_ipc_int ipc_int = { qtnf_ipc_gen_ep_int, priv };
+	const struct qtnf_shm_ipc_rx_callback rx_callback = {
+					qtnf_pcie_control_rx_callback, priv };
+
+	ipc_tx_reg = &priv->bda->bda_shm_reg1;
+	ipc_rx_reg = &priv->bda->bda_shm_reg2;
+
+	qtnf_shm_ipc_init(&priv->shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
+			  ipc_tx_reg, priv->workqueue,
+			  &ipc_int, &rx_callback);
+	qtnf_shm_ipc_init(&priv->shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
+			  ipc_rx_reg, priv->workqueue,
+			  &ipc_int, &rx_callback);
+
+	return 0;
+}
+
+static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+{
+	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
+	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
+}
+
+static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
+{
+	int ret;
+
+	priv->sysctl_bar = qtnf_map_bar(priv, QTN_SYSCTL_BAR);
+	if (IS_ERR_OR_NULL(priv->sysctl_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
+		return ret;
+	}
+
+	priv->dmareg_bar = qtnf_map_bar(priv, QTN_DMA_BAR);
+	if (IS_ERR_OR_NULL(priv->dmareg_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
+		return ret;
+	}
+
+	priv->epmem_bar = qtnf_map_bar(priv, QTN_SHMEM_BAR);
+	if (IS_ERR_OR_NULL(priv->epmem_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
+		return ret;
+	}
+
+	priv->pcie_reg_base = priv->dmareg_bar;
+	priv->bda = priv->epmem_bar;
+	writel(priv->msi_enabled, &priv->bda->bda_rc_msi_enabled);
+
+	return 0;
+}
+
+static int
+qtnf_pcie_init_dma_mask(struct qtnf_pcie_bus_priv *priv, u64 dma_mask)
+{
+	int ret;
+
+	ret = dma_supported(&priv->pdev->dev, dma_mask);
+	if (!ret) {
+		pr_err("DMA mask %llu not supported\n", dma_mask);
+		return ret;
+	}
+
+	ret = pci_set_dma_mask(priv->pdev, dma_mask);
+	if (ret) {
+		pr_err("failed to set DMA mask %llu\n", dma_mask);
+		return ret;
+	}
+
+	ret = pci_set_consistent_dma_mask(priv->pdev, dma_mask);
+	if (ret) {
+		pr_err("failed to set consistent DMA mask %llu\n", dma_mask);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
+{
+	struct pci_dev *pdev = priv->pdev;
+	struct pci_dev *parent;
+	int mps_p, mps_o, mps_m, mps;
+	int ret;
+
+	/* current mps */
+	mps_o = pcie_get_mps(pdev);
+
+	/* maximum supported mps */
+	mps_m = 128 << pdev->pcie_mpss;
+
+	/* suggested new mps value */
+	mps = mps_m;
+
+	if (pdev->bus && pdev->bus->self) {
+		/* parent (bus) mps */
+		parent = pdev->bus->self;
+
+		if (pci_is_pcie(parent)) {
+			mps_p = pcie_get_mps(parent);
+			mps = min(mps_m, mps_p);
+		}
+	}
+
+	ret = pcie_set_mps(pdev, mps);
+	if (ret) {
+		pr_err("failed to set mps to %d, keep using current %d\n",
+		       mps, mps_o);
+		priv->mps = mps_o;
+		return;
+	}
+
+	pr_debug("set mps to %d (was %d, max %d)\n", mps, mps_o, mps_m);
+	priv->mps = mps;
+}
+
+static int qtnf_is_state(__le32 __iomem *reg, u32 state)
+{
+	u32 s = readl(reg);
+
+	return s & state;
+}
+
+static void qtnf_set_state(__le32 __iomem *reg, u32 state)
+{
+	u32 s = readl(reg);
+
+	qtnf_non_posted_write(state | s, reg);
+}
+
+static void qtnf_clear_state(__le32 __iomem *reg, u32 state)
+{
+	u32 s = readl(reg);
+
+	qtnf_non_posted_write(s & ~state, reg);
+}
+
+static int qtnf_poll_state(__le32 __iomem *reg, u32 state, u32 delay_in_ms)
+{
+	u32 timeout = 0;
+
+	while ((qtnf_is_state(reg, state) == 0)) {
+		usleep_range(1000, 1200);
+		if (++timeout > delay_in_ms)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
+{
+	struct sk_buff **vaddr;
+	int len;
+
+	len = priv->tx_bd_num * sizeof(*priv->tx_skb) +
+		priv->rx_bd_num * sizeof(*priv->rx_skb);
+	vaddr = devm_kzalloc(&priv->pdev->dev, len, GFP_KERNEL);
+
+	if (!vaddr)
+		return -ENOMEM;
+
+	priv->tx_skb = vaddr;
+
+	vaddr += priv->tx_bd_num;
+	priv->rx_skb = vaddr;
+
+	return 0;
+}
+
+static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
+{
+	dma_addr_t paddr;
+	void *vaddr;
+	int len;
+
+	len = priv->tx_bd_num * sizeof(struct qtnf_tx_bd) +
+		priv->rx_bd_num * sizeof(struct qtnf_rx_bd);
+
+	vaddr = dmam_alloc_coherent(&priv->pdev->dev, len, &paddr, GFP_KERNEL);
+	if (!vaddr)
+		return -ENOMEM;
+
+	/* tx bd */
+
+	memset(vaddr, 0, len);
+
+	priv->bd_table_vaddr = vaddr;
+	priv->bd_table_paddr = paddr;
+	priv->bd_table_len = len;
+
+	priv->tx_bd_vbase = vaddr;
+	priv->tx_bd_pbase = paddr;
+
+	pr_debug("TX descriptor table: vaddr=0x%p paddr=%pad\n", vaddr, &paddr);
+
+	priv->tx_bd_reclaim_start = 0;
+	priv->tx_bd_index = 0;
+	priv->tx_queue_len = 0;
+
+	/* rx bd */
+
+	vaddr = ((struct qtnf_tx_bd *)vaddr) + priv->tx_bd_num;
+	paddr += priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
+
+	priv->rx_bd_vbase = vaddr;
+	priv->rx_bd_pbase = paddr;
+
+	writel(QTN_HOST_LO32(paddr),
+	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
+	writel(QTN_HOST_HI32(paddr),
+	       PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
+	writel(priv->rx_bd_num | (sizeof(struct qtnf_rx_bd)) << 16,
+	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
+
+	priv->hw_txproc_wr_ptr = priv->rx_bd_num - rx_bd_reserved_param;
+
+	writel(priv->hw_txproc_wr_ptr,
+	       PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
+
+	pr_debug("RX descriptor table: vaddr=0x%p paddr=%pad\n", vaddr, &paddr);
+
+	priv->rx_bd_index = 0;
+
+	return 0;
+}
+
+static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 rx_bd_index)
+{
+	struct qtnf_rx_bd *rxbd;
+	struct sk_buff *skb;
+	dma_addr_t paddr;
+
+	skb = __dev_alloc_skb(SKB_BUF_SIZE + NET_IP_ALIGN,
+			      GFP_ATOMIC);
+	if (!skb) {
+		priv->rx_skb[rx_bd_index] = NULL;
+		return -ENOMEM;
+	}
+
+	priv->rx_skb[rx_bd_index] = skb;
+
+	skb_reserve(skb, NET_IP_ALIGN);
+
+	rxbd = &priv->rx_bd_vbase[rx_bd_index];
+
+	paddr = pci_map_single(priv->pdev, skb->data,
+			       SKB_BUF_SIZE, PCI_DMA_FROMDEVICE);
+	if (pci_dma_mapping_error(priv->pdev, paddr)) {
+		pr_err("skb DMA mapping error: %pad\n", &paddr);
+		return -ENOMEM;
+	}
+
+	writel(QTN_HOST_LO32(paddr),
+	       PCIE_HDP_HHBM_BUF_PTR(priv->pcie_reg_base));
+	writel(QTN_HOST_HI32(paddr),
+	       PCIE_HDP_HHBM_BUF_PTR_H(priv->pcie_reg_base));
+
+	/* keep rx skb paddrs in rx buffer descriptors for cleanup purposes */
+	rxbd->addr = cpu_to_le32(QTN_HOST_LO32(paddr));
+	rxbd->addr_h = cpu_to_le32(QTN_HOST_HI32(paddr));
+
+	rxbd->info = 0x0;
+
+	return 0;
+}
+
+static int alloc_rx_buffers(struct qtnf_pcie_bus_priv *priv)
+{
+	u16 i;
+	int ret = 0;
+
+	memset(priv->rx_bd_vbase, 0x0,
+	       priv->rx_bd_num * sizeof(struct qtnf_rx_bd));
+
+	for (i = 0; i < priv->rx_bd_num; i++) {
+		ret = skb2rbd_attach(priv, i);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/* all rx/tx activity should have ceased before calling this function */
+static void free_xfer_buffers(void *data)
+{
+	struct qtnf_pcie_bus_priv *priv = (struct qtnf_pcie_bus_priv *)data;
+	struct qtnf_rx_bd *rxbd;
+	dma_addr_t paddr;
+	int i;
+
+	/* free rx buffers */
+	for (i = 0; i < priv->rx_bd_num; i++) {
+		if (priv->rx_skb[i]) {
+			rxbd = &priv->rx_bd_vbase[i];
+			paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
+					      le32_to_cpu(rxbd->addr));
+			pci_unmap_single(priv->pdev, paddr, SKB_BUF_SIZE,
+					 PCI_DMA_FROMDEVICE);
+
+			dev_kfree_skb_any(priv->rx_skb[i]);
+		}
+	}
+
+	/* free tx buffers */
+	for (i = 0; i < priv->tx_bd_num; i++) {
+		if (priv->tx_skb[i]) {
+			dev_kfree_skb_any(priv->tx_skb[i]);
+			priv->tx_skb[i] = NULL;
+		}
+	}
+}
+
+static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
+{
+	int ret;
+
+	priv->tx_bd_num = tx_bd_size_param;
+	priv->rx_bd_num = rx_bd_size_param;
+
+	ret = alloc_skb_array(priv);
+	if (ret) {
+		pr_err("failed to allocate skb array\n");
+		return ret;
+	}
+
+	ret = alloc_bd_table(priv);
+	if (ret) {
+		pr_err("failed to allocate bd table\n");
+		return ret;
+	}
+
+	ret = alloc_rx_buffers(priv);
+	if (ret) {
+		pr_err("failed to allocate rx buffers\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static int qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
+{
+	struct qtnf_tx_bd *txbd;
+	struct sk_buff *skb;
+	dma_addr_t paddr;
+	int last_sent;
+	int count;
+	int i;
+
+	last_sent = readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
+			% priv->tx_bd_num;
+	i = priv->tx_bd_reclaim_start;
+	count = 0;
+
+	while (i != last_sent) {
+		skb = priv->tx_skb[i];
+		if (!skb)
+			break;
+
+		txbd = &priv->tx_bd_vbase[i];
+		paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
+				      le32_to_cpu(txbd->addr));
+		pci_unmap_single(priv->pdev, paddr, skb->len, PCI_DMA_TODEVICE);
+
+		if (skb->dev) {
+			skb->dev->stats.tx_packets++;
+			skb->dev->stats.tx_bytes += skb->len;
+
+			if (netif_queue_stopped(skb->dev))
+				netif_wake_queue(skb->dev);
+		}
+
+		dev_kfree_skb_any(skb);
+		priv->tx_skb[i] = NULL;
+		priv->tx_queue_len--;
+		count++;
+
+		if (++i >= priv->tx_bd_num)
+			i = 0;
+	}
+
+	priv->tx_bd_reclaim_start = i;
+	priv->tx_reclaim_done += count;
+	priv->tx_reclaim_req++;
+
+	return count;
+}
+
+static bool qtnf_tx_queue_ready(struct qtnf_pcie_bus_priv *priv)
+{
+	if (priv->tx_queue_len >= priv->tx_bd_num - 1) {
+		pr_err_ratelimited("reclaim full Tx queue\n");
+		qtnf_pcie_data_tx_reclaim(priv);
+
+		if (priv->tx_queue_len >= priv->tx_bd_num - 1) {
+			priv->tx_full_count++;
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	dma_addr_t txbd_paddr, skb_paddr;
+	struct qtnf_tx_bd *txbd;
+	unsigned long flags;
+	int len, i;
+	u32 info;
+	int ret = 0;
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	priv->tx_done_count++;
+
+	if (!qtnf_tx_queue_ready(priv)) {
+		if (skb->dev)
+			netif_stop_queue(skb->dev);
+
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
+		return NETDEV_TX_BUSY;
+	}
+
+	i = priv->tx_bd_index;
+	priv->tx_skb[i] = skb;
+	len = skb->len;
+
+	skb_paddr = pci_map_single(priv->pdev, skb->data,
+				   skb->len, PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(priv->pdev, skb_paddr)) {
+		pr_err("skb DMA mapping error: %pad\n", &skb_paddr);
+		ret = -ENOMEM;
+		goto tx_done;
+	}
+
+	txbd = &priv->tx_bd_vbase[i];
+	txbd->addr = cpu_to_le32(QTN_HOST_LO32(skb_paddr));
+	txbd->addr_h = cpu_to_le32(QTN_HOST_HI32(skb_paddr));
+
+	info = (len & QTN_PCIE_TX_DESC_LEN_MASK) << QTN_PCIE_TX_DESC_LEN_SHIFT;
+	txbd->info = cpu_to_le32(info);
+
+	/* sync up all descriptor updates before passing them to EP */
+	dma_wmb();
+
+	/* write new TX descriptor to PCIE_RX_FIFO on EP */
+	txbd_paddr = priv->tx_bd_pbase + i * sizeof(struct qtnf_tx_bd);
+	writel(QTN_HOST_LO32(txbd_paddr),
+	       PCIE_HDP_HOST_WR_DESC0(priv->pcie_reg_base));
+	writel(QTN_HOST_HI32(txbd_paddr),
+	       PCIE_HDP_HOST_WR_DESC0_H(priv->pcie_reg_base));
+
+	if (++i >= priv->tx_bd_num)
+		i = 0;
+
+	priv->tx_bd_index = i;
+	priv->tx_queue_len++;
+
+tx_done:
+	if (ret && skb) {
+		pr_err_ratelimited("drop skb\n");
+		if (skb->dev)
+			skb->dev->stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
+	}
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	return NETDEV_TX_OK;
+}
+
+static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+	return qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
+}
+
+static irqreturn_t qtnf_interrupt(int irq, void *data)
+{
+	struct qtnf_bus *bus = (struct qtnf_bus *)data;
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	u32 status;
+
+	priv->pcie_irq_count++;
+	status = readl(PCIE_HDP_INT_STATUS(priv->pcie_reg_base));
+
+	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_in);
+	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_out);
+
+	if (!(status & priv->pcie_irq_mask))
+		goto irq_done;
+
+	if (status & PCIE_HDP_INT_RX_BITS) {
+		priv->pcie_irq_rx_count++;
+		qtnf_dis_rxdone_irq(priv);
+		napi_schedule(&bus->mux_napi);
+	}
+
+	if (status & PCIE_HDP_INT_TX_BITS) {
+		priv->pcie_irq_tx_count++;
+		qtnf_dis_txdone_irq(priv);
+		tasklet_hi_schedule(&priv->reclaim_tq);
+	}
+
+irq_done:
+	/* H/W workaround: clean all bits, not only enabled */
+	qtnf_non_posted_write(~0U, PCIE_HDP_INT_STATUS(priv->pcie_reg_base));
+
+	if (!priv->msi_enabled)
+		qtnf_deassert_intx(priv);
+
+	return IRQ_HANDLED;
+}
+
+static inline void hw_txproc_wr_ptr_inc(struct qtnf_pcie_bus_priv *priv)
+{
+	u32 index;
+
+	index = priv->hw_txproc_wr_ptr;
+
+	if (++index >= priv->rx_bd_num)
+		index = 0;
+
+	priv->hw_txproc_wr_ptr = index;
+}
+
+static int qtnf_rx_poll(struct napi_struct *napi, int budget)
+{
+	struct qtnf_bus *bus = container_of(napi, struct qtnf_bus, mux_napi);
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct net_device *ndev = NULL;
+	struct sk_buff *skb = NULL;
+	int processed = 0;
+	struct qtnf_rx_bd *rxbd;
+	dma_addr_t skb_paddr;
+	u32 descw;
+	u16 index;
+	int ret;
+
+	index = priv->rx_bd_index;
+	rxbd = &priv->rx_bd_vbase[index];
+
+	descw = le32_to_cpu(rxbd->info);
+
+	while ((descw & QTN_TXDONE_MASK) && (processed < budget)) {
+		skb = priv->rx_skb[index];
+
+		if (likely(skb)) {
+			skb_put(skb, QTN_GET_LEN(descw));
+
+			skb_paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
+						  le32_to_cpu(rxbd->addr));
+			pci_unmap_single(priv->pdev, skb_paddr, SKB_BUF_SIZE,
+					 PCI_DMA_FROMDEVICE);
+
+			ndev = qtnf_classify_skb(bus, skb);
+			if (likely(ndev)) {
+				ndev->stats.rx_packets++;
+				ndev->stats.rx_bytes += skb->len;
+
+				skb->protocol = eth_type_trans(skb, ndev);
+				netif_receive_skb(skb);
+			} else {
+				pr_debug("drop untagged skb\n");
+				bus->mux_dev.stats.rx_dropped++;
+				dev_kfree_skb_any(skb);
+			}
+
+			processed++;
+		} else {
+			pr_err("missing rx_skb[%d]\n", index);
+		}
+
+		/* attached rx buffer is passed upstream: map a new one */
+		ret = skb2rbd_attach(priv, index);
+		if (likely(!ret)) {
+			if (++index >= priv->rx_bd_num)
+				index = 0;
+
+			priv->rx_bd_index = index;
+			hw_txproc_wr_ptr_inc(priv);
+
+			rxbd = &priv->rx_bd_vbase[index];
+			descw = le32_to_cpu(rxbd->info);
+		} else {
+			pr_err("failed to allocate new rx_skb[%d]\n", index);
+			break;
+		}
+
+		writel(priv->hw_txproc_wr_ptr,
+		       PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
+	}
+
+	if (processed < budget) {
+		napi_complete(napi);
+		qtnf_en_rxdone_irq(priv);
+	}
+
+	return processed;
+}
+
+static void
+qtnf_pcie_data_tx_timeout(struct qtnf_bus *bus, struct net_device *ndev)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+	tasklet_hi_schedule(&priv->reclaim_tq);
+}
+
+static void qtnf_pcie_data_rx_start(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+	qtnf_enable_hdp_irqs(priv);
+	napi_enable(&bus->mux_napi);
+}
+
+static void qtnf_pcie_data_rx_stop(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+
+	napi_disable(&bus->mux_napi);
+	qtnf_disable_hdp_irqs(priv);
+}
+
+static const struct qtnf_bus_ops qtnf_pcie_bus_ops = {
+	/* control path methods */
+	.control_tx	= qtnf_pcie_control_tx,
+
+	/* data path methods */
+	.data_tx		= qtnf_pcie_data_tx,
+	.data_tx_timeout	= qtnf_pcie_data_tx_timeout,
+	.data_rx_start		= qtnf_pcie_data_rx_start,
+	.data_rx_stop		= qtnf_pcie_data_rx_stop,
+};
+
+static int qtnf_ep_fw_send(struct qtnf_pcie_bus_priv *priv, uint32_t size,
+			   int blk, const u8 *pblk, const u8 *fw)
+{
+	struct pci_dev *pdev = priv->pdev;
+	struct qtnf_bus *bus = pci_get_drvdata(pdev);
+
+	struct qtnf_pcie_fw_hdr *hdr;
+	u8 *pdata;
+
+	int hds = sizeof(*hdr);
+	struct sk_buff *skb = NULL;
+	int len = 0;
+	int ret;
+
+	skb = __dev_alloc_skb(QTN_PCIE_FW_BUFSZ, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	skb->len = QTN_PCIE_FW_BUFSZ;
+	skb->dev = NULL;
+
+	hdr = (struct qtnf_pcie_fw_hdr *)skb->data;
+	memcpy(hdr->boardflg, QTN_PCIE_BOARDFLG, strlen(QTN_PCIE_BOARDFLG));
+	hdr->fwsize = cpu_to_le32(size);
+	hdr->seqnum = cpu_to_le32(blk);
+
+	if (blk)
+		hdr->type = cpu_to_le32(QTN_FW_DSUB);
+	else
+		hdr->type = cpu_to_le32(QTN_FW_DBEGIN);
+
+	pdata = skb->data + hds;
+
+	len = QTN_PCIE_FW_BUFSZ - hds;
+	if (pblk >= (fw + size - len)) {
+		len = fw + size - pblk;
+		hdr->type = cpu_to_le32(QTN_FW_DEND);
+	}
+
+	hdr->pktlen = cpu_to_le32(len);
+	memcpy(pdata, pblk, len);
+	hdr->crc = cpu_to_le32(~crc32(0, pdata, len));
+
+	ret = qtnf_pcie_data_tx(bus, skb);
+
+	return (ret == NETDEV_TX_OK) ? len : 0;
+}
+
+static int
+qtnf_ep_fw_load(struct qtnf_pcie_bus_priv *priv, const u8 *fw, u32 fw_size)
+{
+	int blk_size = QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pcie_fw_hdr);
+	int blk_count = fw_size / blk_size + ((fw_size % blk_size) ? 1 : 0);
+	const u8 *pblk = fw;
+	int threshold = 0;
+	int blk = 0;
+	int len;
+
+	pr_debug("FW upload started: fw_addr=0x%p size=%d\n", fw, fw_size);
+
+	while (blk < blk_count) {
+		if (++threshold > 10000) {
+			pr_err("FW upload failed: too many retries\n");
+			return -ETIMEDOUT;
+		}
+
+		len = qtnf_ep_fw_send(priv, fw_size, blk, pblk, fw);
+		if (len <= 0)
+			continue;
+
+		if (!((blk + 1) & QTN_PCIE_FW_DLMASK) ||
+		    (blk == (blk_count - 1))) {
+			qtnf_set_state(&priv->bda->bda_rc_state,
+				       QTN_RC_FW_SYNC);
+			if (qtnf_poll_state(&priv->bda->bda_ep_state,
+					    QTN_EP_FW_SYNC,
+					    QTN_FW_DL_TIMEOUT_MS)) {
+				pr_err("FW upload failed: SYNC timed out\n");
+				return -ETIMEDOUT;
+			}
+
+			qtnf_clear_state(&priv->bda->bda_ep_state,
+					 QTN_EP_FW_SYNC);
+
+			if (qtnf_is_state(&priv->bda->bda_ep_state,
+					  QTN_EP_FW_RETRY)) {
+				if (blk == (blk_count - 1)) {
+					int last_round =
+						blk_count & QTN_PCIE_FW_DLMASK;
+					blk -= last_round;
+					pblk -= ((last_round - 1) *
+						blk_size + len);
+				} else {
+					blk -= QTN_PCIE_FW_DLMASK;
+					pblk -= QTN_PCIE_FW_DLMASK * blk_size;
+				}
+
+				qtnf_clear_state(&priv->bda->bda_ep_state,
+						 QTN_EP_FW_RETRY);
+
+				pr_warn("FW upload retry: block #%d\n", blk);
+				continue;
+			}
+
+			qtnf_pcie_data_tx_reclaim(priv);
+		}
+
+		pblk += len;
+		blk++;
+	}
+
+	pr_debug("FW upload completed: totally sent %d blocks\n", blk);
+	return 0;
+}
+
+static void qtnf_firmware_load(const struct firmware *fw, void *context)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)context;
+	struct pci_dev *pdev = priv->pdev;
+	struct qtnf_bus *bus = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!fw) {
+		pr_err("failed to get firmware %s\n", bus->fwname);
+		goto fw_load_err;
+	}
+
+	ret = qtnf_ep_fw_load(priv, fw->data, fw->size);
+	if (ret) {
+		pr_err("FW upload error\n");
+		goto fw_load_err;
+	}
+
+	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_DONE,
+			    QTN_FW_DL_TIMEOUT_MS)) {
+		pr_err("FW bringup timed out\n");
+		goto fw_load_err;
+	}
+
+	bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
+	pr_info("firmware is up and running\n");
+
+fw_load_err:
+
+	if (fw)
+		release_firmware(fw);
+
+	complete(&bus->request_firmware_complete);
+}
+
+static int qtnf_bringup_fw(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct pci_dev *pdev = priv->pdev;
+	int ret;
+	u32 state = QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
+
+	if (flashboot)
+		state |= QTN_RC_FW_FLASHBOOT;
+
+	qtnf_set_state(&priv->bda->bda_rc_state, state);
+
+	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY,
+			    QTN_FW_DL_TIMEOUT_MS)) {
+		pr_err("card is not ready\n");
+		return -ETIMEDOUT;
+	}
+
+	qtnf_clear_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
+
+	if (flashboot) {
+		pr_info("Booting FW from flash\n");
+
+		if (!qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_DONE,
+				     QTN_FW_DL_TIMEOUT_MS))
+			bus->fw_state = QTNF_FW_STATE_FW_DNLD_DONE;
+
+		return 0;
+	}
+
+	pr_info("starting firmware upload: %s\n", bus->fwname);
+
+	ret = request_firmware_nowait(THIS_MODULE, 1, bus->fwname, &pdev->dev,
+				      GFP_KERNEL, priv, qtnf_firmware_load);
+	if (ret < 0)
+		pr_err("request_firmware_nowait error %d\n", ret);
+	else
+		ret = 1;
+
+	return ret;
+}
+
+static void qtnf_reclaim_tasklet_fn(unsigned long data)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+	qtnf_pcie_data_tx_reclaim(priv);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+	qtnf_en_txdone_irq(priv);
+}
+
+static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "%d\n", priv->mps);
+
+	return 0;
+}
+
+static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "%u\n", priv->msi_enabled);
+
+	return 0;
+}
+
+static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "pcie_irq_count(%u)\n", priv->pcie_irq_count);
+	seq_printf(s, "pcie_irq_tx_count(%u)\n", priv->pcie_irq_tx_count);
+	seq_printf(s, "pcie_irq_rx_count(%u)\n", priv->pcie_irq_rx_count);
+
+	return 0;
+}
+
+static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "tx_full_count(%u)\n", priv->tx_full_count);
+	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
+	seq_printf(s, "tx_reclaim_done(%u)\n", priv->tx_reclaim_done);
+	seq_printf(s, "tx_reclaim_req(%u)\n", priv->tx_reclaim_req);
+	seq_printf(s, "tx_bd_reclaim_start(%u)\n", priv->tx_bd_reclaim_start);
+	seq_printf(s, "tx_bd_index(%u)\n", priv->tx_bd_index);
+	seq_printf(s, "rx_bd_index(%u)\n", priv->rx_bd_index);
+	seq_printf(s, "tx_queue_len(%u)\n", priv->tx_queue_len);
+
+	return 0;
+}
+
+static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+
+	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_in.tx_packet_count);
+	seq_printf(s, "shm_ipc_ep_in.rx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_in.rx_packet_count);
+	seq_printf(s, "shm_ipc_ep_out.tx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_out.tx_timeout_count);
+	seq_printf(s, "shm_ipc_ep_out.rx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_out.rx_packet_count);
+
+	return 0;
+}
+
+static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct qtnf_pcie_bus_priv *pcie_priv;
+	struct qtnf_bus *bus;
+	int ret;
+
+	bus = devm_kzalloc(&pdev->dev,
+			   sizeof(*bus) + sizeof(*pcie_priv), GFP_KERNEL);
+	if (!bus) {
+		ret = -ENOMEM;
+		goto err_init;
+	}
+
+	pcie_priv = get_bus_priv(bus);
+
+	pci_set_drvdata(pdev, bus);
+	bus->bus_ops = &qtnf_pcie_bus_ops;
+	bus->dev = &pdev->dev;
+	bus->fw_state = QTNF_FW_STATE_RESET;
+	pcie_priv->pdev = pdev;
+
+	strcpy(bus->fwname, QTN_PCI_PEARL_FW_NAME);
+	init_completion(&bus->request_firmware_complete);
+	mutex_init(&bus->bus_lock);
+	spin_lock_init(&pcie_priv->irq_lock);
+	spin_lock_init(&pcie_priv->tx_lock);
+
+	/* init stats */
+	pcie_priv->tx_full_count = 0;
+	pcie_priv->tx_done_count = 0;
+	pcie_priv->pcie_irq_count = 0;
+	pcie_priv->pcie_irq_rx_count = 0;
+	pcie_priv->pcie_irq_tx_count = 0;
+	pcie_priv->tx_reclaim_done = 0;
+	pcie_priv->tx_reclaim_req = 0;
+
+	pcie_priv->workqueue = create_singlethread_workqueue("QTNF_PEARL_PCIE");
+	if (!pcie_priv->workqueue) {
+		pr_err("failed to alloc bus workqueue\n");
+		ret = -ENODEV;
+		goto err_priv;
+	}
+
+	if (!pci_is_pcie(pdev)) {
+		pr_err("device %s is not PCI Express\n", pci_name(pdev));
+		ret = -EIO;
+		goto err_base;
+	}
+
+	qtnf_tune_pcie_mps(pcie_priv);
+
+	ret = pcim_enable_device(pdev);
+	if (ret) {
+		pr_err("failed to init PCI device %x\n", pdev->device);
+		goto err_base;
+	} else {
+		pr_debug("successful init of PCI device %x\n", pdev->device);
+	}
+
+	pcim_pin_device(pdev);
+	pci_set_master(pdev);
+
+	ret = qtnf_pcie_init_irq(pcie_priv);
+	if (ret < 0) {
+		pr_err("irq init failed\n");
+		goto err_base;
+	}
+
+	ret = qtnf_pcie_init_memory(pcie_priv);
+	if (ret < 0) {
+		pr_err("PCIE memory init failed\n");
+		goto err_base;
+	}
+
+	ret = qtnf_pcie_init_shm_ipc(pcie_priv);
+	if (ret < 0) {
+		pr_err("PCIE SHM IPC init failed\n");
+		goto err_base;
+	}
+
+	ret = qtnf_pcie_init_dma_mask(pcie_priv, DMA_BIT_MASK(32));
+	if (ret) {
+		pr_err("PCIE DMA mask init failed\n");
+		goto err_base;
+	}
+
+	ret = devm_add_action(&pdev->dev, free_xfer_buffers, (void *)pcie_priv);
+	if (ret) {
+		pr_err("custom release callback init failed\n");
+		goto err_base;
+	}
+
+	ret = qtnf_pcie_init_xfer(pcie_priv);
+	if (ret) {
+		pr_err("PCIE xfer init failed\n");
+		goto err_base;
+	}
+
+	/* init default irq settings */
+	qtnf_init_hdp_irqs(pcie_priv);
+
+	/* start with disabled irqs */
+	qtnf_disable_hdp_irqs(pcie_priv);
+
+	ret = devm_request_irq(&pdev->dev, pdev->irq, &qtnf_interrupt, 0,
+			       "qtnf_pcie_irq", (void *)bus);
+	if (ret) {
+		pr_err("failed to request pcie irq %d\n", pdev->irq);
+		goto err_base;
+	}
+
+	tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
+		     (unsigned long)pcie_priv);
+	init_dummy_netdev(&bus->mux_dev);
+	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
+		       qtnf_rx_poll, 10);
+
+	ret = qtnf_bringup_fw(bus);
+	if (ret < 0)
+		goto err_bringup_fw;
+	else if (ret)
+		wait_for_completion(&bus->request_firmware_complete);
+
+	if (bus->fw_state != QTNF_FW_STATE_FW_DNLD_DONE) {
+		pr_err("failed to start FW\n");
+		goto err_bringup_fw;
+	}
+
+	if (qtnf_poll_state(&pcie_priv->bda->bda_ep_state, QTN_EP_FW_QLINK_DONE,
+			    QTN_FW_QLINK_TIMEOUT_MS)) {
+		pr_err("FW runtime failure\n");
+		goto err_bringup_fw;
+	}
+
+	ret = qtnf_core_attach(bus);
+	if (ret) {
+		pr_err("failed to attach core\n");
+		goto err_bringup_fw;
+	}
+
+	qtnf_debugfs_init(bus, DRV_NAME);
+	qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
+	qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
+	qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
+	qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
+	qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
+
+	return 0;
+
+err_bringup_fw:
+	netif_napi_del(&bus->mux_napi);
+
+err_base:
+	flush_workqueue(pcie_priv->workqueue);
+	destroy_workqueue(pcie_priv->workqueue);
+
+err_priv:
+	pci_set_drvdata(pdev, NULL);
+
+err_init:
+	return ret;
+}
+
+static void qtnf_pcie_remove(struct pci_dev *pdev)
+{
+	struct qtnf_pcie_bus_priv *priv;
+	struct qtnf_bus *bus;
+
+	bus = pci_get_drvdata(pdev);
+	if (!bus)
+		return;
+
+	priv = get_bus_priv(bus);
+
+	qtnf_core_detach(bus);
+	netif_napi_del(&bus->mux_napi);
+
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
+	tasklet_kill(&priv->reclaim_tq);
+
+	qtnf_debugfs_remove(bus);
+
+	qtnf_pcie_free_shm_ipc(priv);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int qtnf_pcie_suspend(struct device *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static int qtnf_pcie_resume(struct device *dev)
+{
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_SLEEP
+/* Power Management Hooks */
+static SIMPLE_DEV_PM_OPS(qtnf_pcie_pm_ops, qtnf_pcie_suspend,
+			 qtnf_pcie_resume);
+#endif
+
+static struct pci_device_id qtnf_pcie_devid_table[] = {
+	{
+		PCIE_VENDOR_ID_QUANTENNA, PCIE_DEVICE_ID_QTN_PEARL,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(pci, qtnf_pcie_devid_table);
+
+static struct pci_driver qtnf_pcie_drv_data = {
+	.name = DRV_NAME,
+	.id_table = qtnf_pcie_devid_table,
+	.probe = qtnf_pcie_probe,
+	.remove = qtnf_pcie_remove,
+#ifdef CONFIG_PM_SLEEP
+	.driver = {
+		.pm = &qtnf_pcie_pm_ops,
+	},
+#endif
+};
+
+static int __init qtnf_pcie_register(void)
+{
+	pr_info("register Quantenna QSR10g FullMAC PCIE driver\n");
+	return pci_register_driver(&qtnf_pcie_drv_data);
+}
+
+static void __exit qtnf_pcie_exit(void)
+{
+	pr_info("unregister Quantenna QSR10g FullMAC PCIE driver\n");
+	pci_unregister_driver(&qtnf_pcie_drv_data);
+}
+
+module_init(qtnf_pcie_register);
+module_exit(qtnf_pcie_exit);
+
+MODULE_AUTHOR("Quantenna Communications");
+MODULE_DESCRIPTION("Quantenna QSR10g PCIe bus driver for 802.11 wireless LAN.");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
new file mode 100644
index 0000000..2a897db
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
@@ -0,0 +1,89 @@
+/*
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
+ */
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
+struct bus;
+
+struct qtnf_pcie_bus_priv {
+	struct pci_dev  *pdev;
+
+	/* lock for irq configuration changes */
+	spinlock_t irq_lock;
+
+	/* lock for tx operations */
+	spinlock_t tx_lock;
+	u8 msi_enabled;
+	int mps;
+
+	struct workqueue_struct *workqueue;
+	struct tasklet_struct reclaim_tq;
+
+	void __iomem *sysctl_bar;
+	void __iomem *epmem_bar;
+	void __iomem *dmareg_bar;
+
+	struct qtnf_shm_ipc shm_ipc_ep_in;
+	struct qtnf_shm_ipc shm_ipc_ep_out;
+
+	struct qtnf_pcie_bda __iomem *bda;
+	void __iomem *pcie_reg_base;
+
+	u16 tx_bd_num;
+	u16 rx_bd_num;
+
+	struct sk_buff **tx_skb;
+	struct sk_buff **rx_skb;
+
+	struct qtnf_tx_bd *tx_bd_vbase;
+	dma_addr_t tx_bd_pbase;
+
+	struct qtnf_rx_bd *rx_bd_vbase;
+	dma_addr_t rx_bd_pbase;
+
+	dma_addr_t bd_table_paddr;
+	void *bd_table_vaddr;
+	u32 bd_table_len;
+
+	u32 hw_txproc_wr_ptr;
+
+	u16 tx_bd_reclaim_start;
+	u16 tx_bd_index;
+	u32 tx_queue_len;
+
+	u16 rx_bd_index;
+
+	u32 pcie_irq_mask;
+
+	/* diagnostics stats */
+	u32 pcie_irq_count;
+	u32 pcie_irq_rx_count;
+	u32 pcie_irq_tx_count;
+	u32 tx_full_count;
+	u32 tx_done_count;
+	u32 tx_reclaim_done;
+	u32 tx_reclaim_req;
+};
+
+#endif /* _QTN_FMAC_PCIE_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
new file mode 100644
index 0000000..e00d508
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
@@ -0,0 +1,158 @@
+/*
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
+ */
+
+#ifndef _QTN_FMAC_PCIE_IPC_H_
+#define _QTN_FMAC_PCIE_IPC_H_
+
+#include <linux/types.h>
+
+#include "shm_ipc_defs.h"
+
+/* bitmap for EP status and flags: updated by EP, read by RC */
+#define QTN_EP_HAS_UBOOT	BIT(0)
+#define QTN_EP_HAS_FIRMWARE	BIT(1)
+#define QTN_EP_REQ_UBOOT	BIT(2)
+#define QTN_EP_REQ_FIRMWARE	BIT(3)
+#define QTN_EP_ERROR_UBOOT	BIT(4)
+#define QTN_EP_ERROR_FIRMWARE	BIT(5)
+
+#define QTN_EP_FW_LOADRDY	BIT(8)
+#define QTN_EP_FW_SYNC		BIT(9)
+#define QTN_EP_FW_RETRY		BIT(10)
+#define QTN_EP_FW_QLINK_DONE	BIT(15)
+#define QTN_EP_FW_DONE		BIT(16)
+
+/* bitmap for RC status and flags: updated by RC, read by EP */
+#define QTN_RC_PCIE_LINK	BIT(0)
+#define QTN_RC_NET_LINK		BIT(1)
+#define QTN_RC_FW_FLASHBOOT	BIT(5)
+#define QTN_RC_FW_QLINK		BIT(7)
+#define QTN_RC_FW_LOADRDY	BIT(8)
+#define QTN_RC_FW_SYNC		BIT(9)
+
+/* state transition timeouts */
+#define QTN_FW_DL_TIMEOUT_MS	3000
+#define QTN_FW_QLINK_TIMEOUT_MS	30000
+
+#define PCIE_HDP_INT_RX_BITS (0		\
+	| PCIE_HDP_INT_EP_TXDMA		\
+	| PCIE_HDP_INT_EP_TXEMPTY	\
+	)
+
+#define PCIE_HDP_INT_TX_BITS (0		\
+	| PCIE_HDP_INT_EP_RXDMA		\
+	)
+
+#if BITS_PER_LONG == 64
+#define QTN_HOST_HI32(a)	((u32)(((u64)a) >> 32))
+#define QTN_HOST_LO32(a)	((u32)(((u64)a) & 0xffffffffUL))
+#define QTN_HOST_ADDR(h, l)	((((u64)h) << 32) | ((u64)l))
+#elif BITS_PER_LONG == 32
+#define QTN_HOST_HI32(a)	0
+#define QTN_HOST_LO32(a)	((u32)(((u32)a) & 0xffffffffUL))
+#define QTN_HOST_ADDR(h, l)	((u32)l)
+#else
+#error Unexpected BITS_PER_LONG value
+#endif
+
+#define QTN_SYSCTL_BAR	0
+#define QTN_SHMEM_BAR	2
+#define QTN_DMA_BAR	3
+
+#define QTN_PCIE_BDA_VERSION		0x1002
+
+#define PCIE_BDA_NAMELEN		32
+#define PCIE_HHBM_MAX_SIZE		512
+
+#define SKB_BUF_SIZE		2048
+
+#define QTN_PCIE_BOARDFLG	"PCIEQTN"
+#define QTN_PCIE_FW_DLMASK	0xF
+#define QTN_PCIE_FW_BUFSZ	2048
+
+#define QTN_ENET_ADDR_LENGTH	6
+
+#define QTN_TXDONE_MASK		((u32)0x80000000)
+#define QTN_GET_LEN(x)		((x) & 0xFFFF)
+
+#define QTN_PCIE_TX_DESC_LEN_MASK	0xFFFF
+#define QTN_PCIE_TX_DESC_LEN_SHIFT	0
+#define QTN_PCIE_TX_DESC_PORT_MASK	0xF
+#define QTN_PCIE_TX_DESC_PORT_SHIFT	16
+#define QTN_PCIE_TX_DESC_TQE_BIT	BIT(24)
+
+#define QTN_EP_LHOST_TQE_PORT	4
+
+enum qtnf_pcie_bda_ipc_flags {
+	QTN_PCIE_IPC_FLAG_HBM_MAGIC	= BIT(0),
+	QTN_PCIE_IPC_FLAG_SHM_PIO	= BIT(1),
+};
+
+struct qtnf_pcie_bda {
+	__le16 bda_len;
+	__le16 bda_version;
+	__le32 bda_pci_endian;
+	__le32 bda_ep_state;
+	__le32 bda_rc_state;
+	__le32 bda_dma_mask;
+	__le32 bda_msi_addr;
+	__le32 bda_flashsz;
+	u8 bda_boardname[PCIE_BDA_NAMELEN];
+	__le32 bda_rc_msi_enabled;
+	__le32 bda_hhbm_list[PCIE_HHBM_MAX_SIZE];
+	__le32 bda_dsbw_start_index;
+	__le32 bda_dsbw_end_index;
+	__le32 bda_dsbw_total_bytes;
+	__le32 bda_rc_tx_bd_base;
+	__le32 bda_rc_tx_bd_num;
+	u8 bda_pcie_mac[QTN_ENET_ADDR_LENGTH];
+	struct qtnf_shm_ipc_region bda_shm_reg1 __aligned(4096); /* host TX */
+	struct qtnf_shm_ipc_region bda_shm_reg2 __aligned(4096); /* host RX */
+} __packed;
+
+struct qtnf_tx_bd {
+	__le32 addr;
+	__le32 addr_h;
+	__le32 info;
+	__le32 info_h;
+} __packed;
+
+struct qtnf_rx_bd {
+	__le32 addr;
+	__le32 addr_h;
+	__le32 info;
+	__le32 info_h;
+	__le32 next_ptr;
+	__le32 next_ptr_h;
+} __packed;
+
+enum qtnf_fw_loadtype {
+	QTN_FW_DBEGIN,
+	QTN_FW_DSUB,
+	QTN_FW_DEND,
+	QTN_FW_CTRL
+};
+
+struct qtnf_pcie_fw_hdr {
+	u8 boardflg[8];
+	__le32 fwsize;
+	__le32 seqnum;
+	__le32 type;
+	__le32 pktlen;
+	__le32 crc;
+} __packed;
+
+#endif /* _QTN_FMAC_PCIE_IPC_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
new file mode 100644
index 0000000..78715b8
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
@@ -0,0 +1,353 @@
+/*
+ * Copyright (c) 2015 Quantenna Communications, Inc.
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
+ */
+
+#ifndef __PEARL_PCIE_H
+#define __PEARL_PCIE_H
+
+#define	PCIE_GEN2_BASE				(0xe9000000)
+#define	PCIE_GEN3_BASE				(0xe7000000)
+
+#define PEARL_CUR_PCIE_BASE			(PCIE_GEN2_BASE)
+#define PCIE_HDP_OFFSET				(0x2000)
+
+#define PCIE_HDP_CTRL(base)			((base) + 0x2c00)
+#define PCIE_HDP_AXI_CTRL(base)			((base) + 0x2c04)
+#define PCIE_HDP_HOST_WR_DESC0(base)		((base) + 0x2c10)
+#define PCIE_HDP_HOST_WR_DESC0_H(base)		((base) + 0x2c14)
+#define PCIE_HDP_HOST_WR_DESC1(base)		((base) + 0x2c18)
+#define PCIE_HDP_HOST_WR_DESC1_H(base)		((base) + 0x2c1c)
+#define PCIE_HDP_HOST_WR_DESC2(base)		((base) + 0x2c20)
+#define PCIE_HDP_HOST_WR_DESC2_H(base)		((base) + 0x2c24)
+#define PCIE_HDP_HOST_WR_DESC3(base)		((base) + 0x2c28)
+#define PCIE_HDP_HOST_WR_DESC4_H(base)		((base) + 0x2c2c)
+#define PCIE_HDP_RX_INT_CTRL(base)		((base) + 0x2c30)
+#define PCIE_HDP_TX_INT_CTRL(base)		((base) + 0x2c34)
+#define PCIE_HDP_INT_STATUS(base)		((base) + 0x2c38)
+#define PCIE_HDP_INT_EN(base)			((base) + 0x2c3c)
+#define PCIE_HDP_RX_DESC0_PTR(base)		((base) + 0x2c40)
+#define PCIE_HDP_RX_DESC0_NOE(base)		((base) + 0x2c44)
+#define PCIE_HDP_RX_DESC1_PTR(base)		((base) + 0x2c48)
+#define PCIE_HDP_RX_DESC1_NOE(base)		((base) + 0x2c4c)
+#define PCIE_HDP_RX_DESC2_PTR(base)		((base) + 0x2c50)
+#define PCIE_HDP_RX_DESC2_NOE(base)		((base) + 0x2c54)
+#define PCIE_HDP_RX_DESC3_PTR(base)		((base) + 0x2c58)
+#define PCIE_HDP_RX_DESC3_NOE(base)		((base) + 0x2c5c)
+
+#define PCIE_HDP_TX0_BASE_ADDR(base)		((base) + 0x2c60)
+#define PCIE_HDP_TX1_BASE_ADDR(base)		((base) + 0x2c64)
+#define PCIE_HDP_TX0_Q_CTRL(base)		((base) + 0x2c70)
+#define PCIE_HDP_TX1_Q_CTRL(base)		((base) + 0x2c74)
+#define PCIE_HDP_CFG0(base)			((base) + 0x2c80)
+#define PCIE_HDP_CFG1(base)			((base) + 0x2c84)
+#define PCIE_HDP_CFG2(base)			((base) + 0x2c88)
+#define PCIE_HDP_CFG3(base)			((base) + 0x2c8c)
+#define PCIE_HDP_CFG4(base)			((base) + 0x2c90)
+#define PCIE_HDP_CFG5(base)			((base) + 0x2c94)
+#define PCIE_HDP_CFG6(base)			((base) + 0x2c98)
+#define PCIE_HDP_CFG7(base)			((base) + 0x2c9c)
+#define PCIE_HDP_CFG8(base)			((base) + 0x2ca0)
+#define PCIE_HDP_CFG9(base)			((base) + 0x2ca4)
+#define PCIE_HDP_CFG10(base)			((base) + 0x2ca8)
+#define PCIE_HDP_CFG11(base)			((base) + 0x2cac)
+#define PCIE_INT(base)				((base) + 0x2cb0)
+#define PCIE_INT_MASK(base)			((base) + 0x2cb4)
+#define PCIE_MSI_MASK(base)			((base) + 0x2cb8)
+#define PCIE_MSI_PNDG(base)			((base) + 0x2cbc)
+#define PCIE_PRI_CFG(base)			((base) + 0x2cc0)
+#define PCIE_PHY_CR(base)			((base) + 0x2cc4)
+#define PCIE_HDP_CTAG_CTRL(base)		((base) + 0x2cf4)
+#define PCIE_HDP_HHBM_BUF_PTR(base)		((base) + 0x2d00)
+#define PCIE_HDP_HHBM_BUF_PTR_H(base)		((base) + 0x2d04)
+#define PCIE_HDP_HHBM_BUF_FIFO_NOE(base)	((base) + 0x2d04)
+#define PCIE_HDP_RX0DMA_CNT(base)		((base) + 0x2d10)
+#define PCIE_HDP_RX1DMA_CNT(base)		((base) + 0x2d14)
+#define PCIE_HDP_RX2DMA_CNT(base)		((base) + 0x2d18)
+#define PCIE_HDP_RX3DMA_CNT(base)		((base) + 0x2d1c)
+#define PCIE_HDP_TX0DMA_CNT(base)		((base) + 0x2d20)
+#define PCIE_HDP_TX1DMA_CNT(base)		((base) + 0x2d24)
+#define PCIE_HDP_RXDMA_CTRL(base)		((base) + 0x2d28)
+#define PCIE_HDP_TX_HOST_Q_SZ_CTRL(base)	((base) + 0x2d2c)
+#define PCIE_HDP_TX_HOST_Q_BASE_L(base)		((base) + 0x2d30)
+#define PCIE_HDP_TX_HOST_Q_BASE_H(base)		((base) + 0x2d34)
+#define PCIE_HDP_TX_HOST_Q_WR_PTR(base)		((base) + 0x2d38)
+#define PCIE_HDP_TX_HOST_Q_RD_PTR(base)		((base) + 0x2d3c)
+#define PCIE_HDP_TX_HOST_Q_STS(base)		((base) + 0x2d40)
+
+/* Host HBM pool registers */
+#define PCIE_HHBM_CSR_REG(base)			((base) + 0x2e00)
+#define PCIE_HHBM_Q_BASE_REG(base)		((base) + 0x2e04)
+#define PCIE_HHBM_Q_LIMIT_REG(base)		((base) + 0x2e08)
+#define PCIE_HHBM_Q_WR_REG(base)		((base) + 0x2e0c)
+#define PCIE_HHBM_Q_RD_REG(base)		((base) + 0x2e10)
+#define PCIE_HHBM_POOL_DATA_0_H(base)		((base) + 0x2e90)
+#define PCIE_HHBM_CONFIG(base)			((base) + 0x2f9c)
+#define PCIE_HHBM_POOL_REQ_0(base)		((base) + 0x2f10)
+#define PCIE_HHBM_POOL_DATA_0(base)		((base) + 0x2f40)
+#define PCIE_HHBM_WATERMARK_MASKED_INT(base)	((base) + 0x2f68)
+#define PCIE_HHBM_WATERMARK_INT(base)		((base) + 0x2f6c)
+#define PCIE_HHBM_POOL_WATERMARK(base)		((base) + 0x2f70)
+#define PCIE_HHBM_POOL_OVERFLOW_CNT(base)	((base) + 0x2f90)
+#define PCIE_HHBM_POOL_UNDERFLOW_CNT(base)	((base) + 0x2f94)
+#define HBM_INT_STATUS(base)			((base) + 0x2f9c)
+#define PCIE_HHBM_POOL_CNFIG(base)		((base) + 0x2f9c)
+
+/* host HBM bit field definition */
+#define HHBM_CONFIG_SOFT_RESET			(BIT(8))
+#define HHBM_WR_REQ				(BIT(0))
+#define HHBM_RD_REQ				(BIT(1))
+#define HHBM_DONE				(BIT(31))
+
+/* offsets for dual PCIE */
+#define PCIE_PORT_LINK_CTL(base)		((base) + 0x0710)
+#define PCIE_GEN2_CTL(base)			((base) + 0x080C)
+#define PCIE_GEN3_OFF(base)			((base) + 0x0890)
+#define PCIE_ATU_CTRL1(base)			((base) + 0x0904)
+#define PCIE_ATU_CTRL2(base)			((base) + 0x0908)
+#define PCIE_ATU_BASE_LOW(base)			((base) + 0x090C)
+#define PCIE_ATU_BASE_HIGH(base)		((base) + 0x0910)
+#define PCIE_ATU_BASE_LIMIT(base)		((base) + 0x0914)
+#define PCIE_ATU_TGT_LOW(base)			((base) + 0x0918)
+#define PCIE_ATU_TGT_HIGH(base)			((base) + 0x091C)
+#define PCIE_DMA_WR_ENABLE(base)		((base) + 0x097C)
+#define PCIE_DMA_WR_CHWTLOW(base)		((base) + 0x0988)
+#define PCIE_DMA_WR_CHWTHIG(base)		((base) + 0x098C)
+#define PCIE_DMA_WR_INTSTS(base)		((base) + 0x09BC)
+#define PCIE_DMA_WR_INTMASK(base)		((base) + 0x09C4)
+#define PCIE_DMA_WR_INTCLER(base)		((base) + 0x09C8)
+#define PCIE_DMA_WR_DONE_IMWR_ADDR_L(base)	((base) + 0x09D0)
+#define PCIE_DMA_WR_DONE_IMWR_ADDR_H(base)	((base) + 0x09D4)
+#define PCIE_DMA_WR_ABORT_IMWR_ADDR_L(base)	((base) + 0x09D8)
+#define PCIE_DMA_WR_ABORT_IMWR_ADDR_H(base)	((base) + 0x09DC)
+#define PCIE_DMA_WR_IMWR_DATA(base)		((base) + 0x09E0)
+#define PCIE_DMA_WR_LL_ERR_EN(base)		((base) + 0x0A00)
+#define PCIE_DMA_WR_DOORBELL(base)		((base) + 0x0980)
+#define PCIE_DMA_RD_ENABLE(base)		((base) + 0x099C)
+#define PCIE_DMA_RD_DOORBELL(base)		((base) + 0x09A0)
+#define PCIE_DMA_RD_CHWTLOW(base)		((base) + 0x09A8)
+#define PCIE_DMA_RD_CHWTHIG(base)		((base) + 0x09AC)
+#define PCIE_DMA_RD_INTSTS(base)		((base) + 0x0A10)
+#define PCIE_DMA_RD_INTMASK(base)		((base) + 0x0A18)
+#define PCIE_DMA_RD_INTCLER(base)		((base) + 0x0A1C)
+#define PCIE_DMA_RD_ERR_STS_L(base)		((base) + 0x0A24)
+#define PCIE_DMA_RD_ERR_STS_H(base)		((base) + 0x0A28)
+#define PCIE_DMA_RD_LL_ERR_EN(base)		((base) + 0x0A34)
+#define PCIE_DMA_RD_DONE_IMWR_ADDR_L(base)	((base) + 0x0A3C)
+#define PCIE_DMA_RD_DONE_IMWR_ADDR_H(base)	((base) + 0x0A40)
+#define PCIE_DMA_RD_ABORT_IMWR_ADDR_L(base)	((base) + 0x0A44)
+#define PCIE_DMA_RD_ABORT_IMWR_ADDR_H(base)	((base) + 0x0A48)
+#define PCIE_DMA_RD_IMWR_DATA(base)		((base) + 0x0A4C)
+#define PCIE_DMA_CHNL_CONTEXT(base)		((base) + 0x0A6C)
+#define PCIE_DMA_CHNL_CNTRL(base)		((base) + 0x0A70)
+#define PCIE_DMA_XFR_SIZE(base)			((base) + 0x0A78)
+#define PCIE_DMA_SAR_LOW(base)			((base) + 0x0A7C)
+#define PCIE_DMA_SAR_HIGH(base)			((base) + 0x0A80)
+#define PCIE_DMA_DAR_LOW(base)			((base) + 0x0A84)
+#define PCIE_DMA_DAR_HIGH(base)			((base) + 0x0A88)
+#define PCIE_DMA_LLPTR_LOW(base)		((base) + 0x0A8C)
+#define PCIE_DMA_LLPTR_HIGH(base)		((base) + 0x0A90)
+#define PCIE_DMA_WRLL_ERR_ENB(base)		((base) + 0x0A00)
+#define PCIE_DMA_RDLL_ERR_ENB(base)		((base) + 0x0A34)
+#define PCIE_DMABD_CHNL_CNTRL(base)		((base) + 0x8000)
+#define PCIE_DMABD_XFR_SIZE(base)		((base) + 0x8004)
+#define PCIE_DMABD_SAR_LOW(base)		((base) + 0x8008)
+#define PCIE_DMABD_SAR_HIGH(base)		((base) + 0x800c)
+#define PCIE_DMABD_DAR_LOW(base)		((base) + 0x8010)
+#define PCIE_DMABD_DAR_HIGH(base)		((base) + 0x8014)
+#define PCIE_DMABD_LLPTR_LOW(base)		((base) + 0x8018)
+#define PCIE_DMABD_LLPTR_HIGH(base)		((base) + 0x801c)
+#define PCIE_WRDMA0_CHNL_CNTRL(base)		((base) + 0x8000)
+#define PCIE_WRDMA0_XFR_SIZE(base)		((base) + 0x8004)
+#define PCIE_WRDMA0_SAR_LOW(base)		((base) + 0x8008)
+#define PCIE_WRDMA0_SAR_HIGH(base)		((base) + 0x800c)
+#define PCIE_WRDMA0_DAR_LOW(base)		((base) + 0x8010)
+#define PCIE_WRDMA0_DAR_HIGH(base)		((base) + 0x8014)
+#define PCIE_WRDMA0_LLPTR_LOW(base)		((base) + 0x8018)
+#define PCIE_WRDMA0_LLPTR_HIGH(base)		((base) + 0x801c)
+#define PCIE_WRDMA1_CHNL_CNTRL(base)		((base) + 0x8020)
+#define PCIE_WRDMA1_XFR_SIZE(base)		((base) + 0x8024)
+#define PCIE_WRDMA1_SAR_LOW(base)		((base) + 0x8028)
+#define PCIE_WRDMA1_SAR_HIGH(base)		((base) + 0x802c)
+#define PCIE_WRDMA1_DAR_LOW(base)		((base) + 0x8030)
+#define PCIE_WRDMA1_DAR_HIGH(base)		((base) + 0x8034)
+#define PCIE_WRDMA1_LLPTR_LOW(base)		((base) + 0x8038)
+#define PCIE_WRDMA1_LLPTR_HIGH(base)		((base) + 0x803c)
+#define PCIE_RDDMA0_CHNL_CNTRL(base)		((base) + 0x8040)
+#define PCIE_RDDMA0_XFR_SIZE(base)		((base) + 0x8044)
+#define PCIE_RDDMA0_SAR_LOW(base)		((base) + 0x8048)
+#define PCIE_RDDMA0_SAR_HIGH(base)		((base) + 0x804c)
+#define PCIE_RDDMA0_DAR_LOW(base)		((base) + 0x8050)
+#define PCIE_RDDMA0_DAR_HIGH(base)		((base) + 0x8054)
+#define PCIE_RDDMA0_LLPTR_LOW(base)		((base) + 0x8058)
+#define PCIE_RDDMA0_LLPTR_HIGH(base)		((base) + 0x805c)
+#define PCIE_RDDMA1_CHNL_CNTRL(base)		((base) + 0x8060)
+#define PCIE_RDDMA1_XFR_SIZE(base)		((base) + 0x8064)
+#define PCIE_RDDMA1_SAR_LOW(base)		((base) + 0x8068)
+#define PCIE_RDDMA1_SAR_HIGH(base)		((base) + 0x806c)
+#define PCIE_RDDMA1_DAR_LOW(base)		((base) + 0x8070)
+#define PCIE_RDDMA1_DAR_HIGH(base)		((base) + 0x8074)
+#define PCIE_RDDMA1_LLPTR_LOW(base)		((base) + 0x8078)
+#define PCIE_RDDMA1_LLPTR_HIGH(base)		((base) + 0x807c)
+
+#define PCIE_ID(base)				((base) + 0x0000)
+#define PCIE_CMD(base)				((base) + 0x0004)
+#define PCIE_BAR(base, n)			((base) + 0x0010 + ((n) << 2))
+#define PCIE_CAP_PTR(base)			((base) + 0x0034)
+#define PCIE_MSI_LBAR(base)			((base) + 0x0054)
+#define PCIE_MSI_CTRL(base)			((base) + 0x0050)
+#define PCIE_MSI_ADDR_L(base)			((base) + 0x0054)
+#define PCIE_MSI_ADDR_H(base)			((base) + 0x0058)
+#define PCIE_MSI_DATA(base)			((base) + 0x005C)
+#define PCIE_MSI_MASK_BIT(base)			((base) + 0x0060)
+#define PCIE_MSI_PEND_BIT(base)			((base) + 0x0064)
+#define PCIE_DEVCAP(base)			((base) + 0x0074)
+#define PCIE_DEVCTLSTS(base)			((base) + 0x0078)
+
+#define PCIE_CMDSTS(base)			((base) + 0x0004)
+#define PCIE_LINK_STAT(base)			((base) + 0x80)
+#define PCIE_LINK_CTL2(base)			((base) + 0xa0)
+#define PCIE_ASPM_L1_CTRL(base)			((base) + 0x70c)
+#define PCIE_ASPM_LINK_CTRL(base)		(PCIE_LINK_STAT)
+#define PCIE_ASPM_L1_SUBSTATE_TIMING(base)	((base) + 0xB44)
+#define PCIE_L1SUB_CTRL1(base)			((base) + 0x150)
+#define PCIE_PMCSR(base)			((base) + 0x44)
+#define PCIE_CFG_SPACE_LIMIT(base)		((base) + 0x100)
+
+/* PCIe link defines */
+#define PEARL_PCIE_LINKUP			(0x7)
+#define PEARL_PCIE_DATA_LINK			(BIT(0))
+#define PEARL_PCIE_PHY_LINK			(BIT(1))
+#define PEARL_PCIE_LINK_RST			(BIT(3))
+#define PEARL_PCIE_FATAL_ERR			(BIT(5))
+#define PEARL_PCIE_NONFATAL_ERR			(BIT(6))
+
+/* PCIe Lane defines */
+#define PCIE_G2_LANE_X1				((BIT(0)) << 16)
+#define PCIE_G2_LANE_X2				((BIT(0) | BIT(1)) << 16)
+
+/* PCIe DLL link enable */
+#define PCIE_DLL_LINK_EN			((BIT(0)) << 5)
+
+#define PCIE_LINK_GEN1				(BIT(0))
+#define PCIE_LINK_GEN2				(BIT(1))
+#define PCIE_LINK_GEN3				(BIT(2))
+#define PCIE_LINK_MODE(x)			(((x) >> 16) & 0x7)
+
+#define MSI_EN					(BIT(0))
+#define MSI_64_EN				(BIT(7))
+#define PCIE_MSI_ADDR_OFFSET(a)			((a) & 0xFFFF)
+#define PCIE_MSI_ADDR_ALIGN(a)			((a) & (~0xFFFF))
+
+#define PCIE_BAR_MASK(base, n)			((base) + 0x1010 + ((n) << 2))
+#define PCIE_MAX_BAR				(6)
+
+#define PCIE_ATU_VIEW(base)			((base) + 0x0900)
+#define PCIE_ATU_CTL1(base)			((base) + 0x0904)
+#define PCIE_ATU_CTL2(base)			((base) + 0x0908)
+#define PCIE_ATU_LBAR(base)			((base) + 0x090c)
+#define PCIE_ATU_UBAR(base)			((base) + 0x0910)
+#define PCIE_ATU_LAR(base)			((base) + 0x0914)
+#define PCIE_ATU_LTAR(base)			((base) + 0x0918)
+#define PCIE_ATU_UTAR(base)			((base) + 0x091c)
+
+#define PCIE_MSI_ADDR_LOWER(base)		((base) + 0x0820)
+#define PCIE_MSI_ADDR_UPPER(base)		((base) + 0x0824)
+#define PCIE_MSI_ENABLE(base)			((base) + 0x0828)
+#define PCIE_MSI_MASK_RC(base)			((base) + 0x082c)
+#define PCIE_MSI_STATUS(base)			((base) + 0x0830)
+#define PEARL_PCIE_MSI_REGION			(0xce000000)
+#define PEARL_PCIE_MSI_DATA			(0)
+#define PCIE_MSI_GPIO(base)			((base) + 0x0888)
+
+#define PCIE_HDP_HOST_QUEUE_FULL	(BIT(17))
+#define USE_BAR_MATCH_MODE
+#define PCIE_ATU_OB_REGION		(BIT(0))
+#define PCIE_ATU_EN_REGION		(BIT(31))
+#define PCIE_ATU_EN_MATCH		(BIT(30))
+#define PCIE_BASE_REGION		(0xb0000000)
+#define PCIE_MEM_MAP_SIZE		(512 * 1024)
+
+#define PCIE_OB_REG_REGION		(0xcf000000)
+#define PCIE_CONFIG_REGION		(0xcf000000)
+#define PCIE_CONFIG_SIZE		(4096)
+#define PCIE_CONFIG_CH			(1)
+
+/* inbound mapping */
+#define PCIE_IB_BAR0			(0x00000000)	/* ddr */
+#define PCIE_IB_BAR0_CH			(0)
+#define PCIE_IB_BAR3			(0xe0000000)	/* sys_reg */
+#define PCIE_IB_BAR3_CH			(1)
+
+/* outbound mapping */
+#define PCIE_MEM_CH			(0)
+#define PCIE_REG_CH			(1)
+#define PCIE_MEM_REGION			(0xc0000000)
+#define	PCIE_MEM_SIZE			(0x000fffff)
+#define PCIE_MEM_TAR			(0x80000000)
+
+#define PCIE_MSI_REGION			(0xce000000)
+#define PCIE_MSI_SIZE			(KBYTE(4) - 1)
+#define PCIE_MSI_CH			(1)
+
+/* size of config region */
+#define PCIE_CFG_SIZE			(0x0000ffff)
+
+#define PCIE_ATU_DIR_IB			(BIT(31))
+#define PCIE_ATU_DIR_OB			(0)
+#define PCIE_ATU_DIR_CFG		(2)
+#define PCIE_ATU_DIR_MATCH_IB		(BIT(31) | BIT(30))
+
+#define PCIE_DMA_WR_0			(0)
+#define PCIE_DMA_WR_1			(1)
+#define PCIE_DMA_RD_0			(2)
+#define PCIE_DMA_RD_1			(3)
+
+#define PCIE_DMA_CHNL_CNTRL_CB		(BIT(0))
+#define PCIE_DMA_CHNL_CNTRL_TCB		(BIT(1))
+#define PCIE_DMA_CHNL_CNTRL_LLP		(BIT(2))
+#define PCIE_DMA_CHNL_CNTRL_LIE		(BIT(3))
+#define PCIE_DMA_CHNL_CNTRL_RIE		(BIT(4))
+#define PCIE_DMA_CHNL_CNTRL_CSS		(BIT(8))
+#define PCIE_DMA_CHNL_CNTRL_LLE		(BIT(9))
+#define PCIE_DMA_CHNL_CNTRL_TLP		(BIT(26))
+
+#define PCIE_DMA_CHNL_CONTEXT_RD	(BIT(31))
+#define PCIE_DMA_CHNL_CONTEXT_WR	(0)
+#define PCIE_MAX_BAR			(6)
+
+/* PCIe HDP interrupt status definition */
+#define PCIE_HDP_INT_EP_RXDMA		(BIT(0))
+#define PCIE_HDP_INT_HBM_UF		(BIT(1))
+#define PCIE_HDP_INT_RX_LEN_ERR		(BIT(2))
+#define PCIE_HDP_INT_RX_HDR_LEN_ERR	(BIT(3))
+#define PCIE_HDP_INT_EP_TXDMA		(BIT(12))
+#define PCIE_HDP_INT_EP_TXEMPTY		(BIT(15))
+#define PCIE_HDP_INT_IPC		(BIT(29))
+
+/* PCIe interrupt status definition */
+#define PCIE_INT_MSI			(BIT(24))
+#define PCIE_INT_INTX			(BIT(23))
+
+/* PCIe legacy INTx */
+#define PEARL_PCIE_CFG0_OFFSET		(0x6C)
+#define PEARL_ASSERT_INTX		(BIT(9))
+
+/* SYS CTL regs */
+#define QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET	(0x001C)
+
+#define QTN_PEARL_IPC_IRQ_WORD(irq)	(BIT(irq) | BIT(irq + 16))
+#define QTN_PEARL_LHOST_IPC_IRQ		(6)
+
+#endif /* __PEARL_PCIE_H */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
new file mode 100644
index 0000000..6eafc15
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -0,0 +1,901 @@
+/*
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
+ */
+
+#ifndef _QTN_QLINK_H_
+#define _QTN_QLINK_H_
+
+#include <linux/ieee80211.h>
+
+#define QLINK_PROTO_VER		3
+
+#define QLINK_MACID_RSVD		0xFF
+#define QLINK_VIFID_RSVD		0xFF
+
+/* Common QLINK protocol messages definitions.
+ */
+
+/**
+ * enum qlink_msg_type - QLINK message types
+ *
+ * Used to distinguish between message types of QLINK protocol.
+ *
+ * @QLINK_MSG_TYPE_CMD: Message is carrying data of a command sent from
+ *	driver to wireless hardware.
+ * @QLINK_MSG_TYPE_CMDRSP: Message is carrying data of a response to a command.
+ *	Sent from wireless HW to driver in reply to previously issued command.
+ * @QLINK_MSG_TYPE_EVENT: Data for an event originated in wireless hardware and
+ *	sent asynchronously to driver.
+ */
+enum qlink_msg_type {
+	QLINK_MSG_TYPE_CMD	= 1,
+	QLINK_MSG_TYPE_CMDRSP	= 2,
+	QLINK_MSG_TYPE_EVENT	= 3
+};
+
+/**
+ * struct qlink_msg_header - common QLINK protocol message header
+ *
+ * Portion of QLINK protocol header common for all message types.
+ *
+ * @type: Message type, one of &enum qlink_msg_type.
+ * @len: Total length of message including all headers.
+ */
+struct qlink_msg_header {
+	__le16 type;
+	__le16 len;
+} __packed;
+
+/* Generic definitions of data and information carried in QLINK messages
+ */
+
+enum qlink_hw_capab {
+	QLINK_HW_SUPPORTS_REG_UPDATE	= BIT(0),
+};
+
+enum qlink_phy_mode {
+	QLINK_PHYMODE_BGN	= BIT(0),
+	QLINK_PHYMODE_AN	= BIT(1),
+	QLINK_PHYMODE_AC	= BIT(2),
+};
+
+enum qlink_iface_type {
+	QLINK_IFTYPE_AP		= 1,
+	QLINK_IFTYPE_STATION	= 2,
+	QLINK_IFTYPE_ADHOC	= 3,
+	QLINK_IFTYPE_MONITOR	= 4,
+	QLINK_IFTYPE_WDS	= 5,
+};
+
+/**
+ * struct qlink_intf_info - information on virtual interface.
+ *
+ * Data describing a single virtual interface.
+ *
+ * @if_type: Mode of interface operation, one of &enum qlink_iface_type
+ * @flags: interface flagsmap.
+ * @mac_addr: MAC address of virtual interface.
+ */
+struct qlink_intf_info {
+	__le16 if_type;
+	__le16 flags;
+	u8 mac_addr[ETH_ALEN];
+	u8 rsvd[2];
+} __packed;
+
+enum qlink_sta_flags {
+	QLINK_STA_FLAG_INVALID		= 0,
+	QLINK_STA_FLAG_AUTHORIZED		= BIT(0),
+	QLINK_STA_FLAG_SHORT_PREAMBLE	= BIT(1),
+	QLINK_STA_FLAG_WME			= BIT(2),
+	QLINK_STA_FLAG_MFP			= BIT(3),
+	QLINK_STA_FLAG_AUTHENTICATED		= BIT(4),
+	QLINK_STA_FLAG_TDLS_PEER		= BIT(5),
+	QLINK_STA_FLAG_ASSOCIATED		= BIT(6),
+};
+
+enum qlink_channel_width {
+	QLINK_CHAN_WIDTH_5		= BIT(0),
+	QLINK_CHAN_WIDTH_10		= BIT(1),
+	QLINK_CHAN_WIDTH_20_NOHT	= BIT(2),
+	QLINK_CHAN_WIDTH_20		= BIT(3),
+	QLINK_CHAN_WIDTH_40		= BIT(4),
+	QLINK_CHAN_WIDTH_80		= BIT(5),
+	QLINK_CHAN_WIDTH_80P80		= BIT(6),
+	QLINK_CHAN_WIDTH_160		= BIT(7),
+};
+
+/* QLINK Command messages related definitions
+ */
+
+/**
+ * enum qlink_cmd_type - list of supported commands
+ *
+ * Commands are QLINK messages of type @QLINK_MSG_TYPE_CMD, sent by driver to
+ * wireless network device for processing. Device is expected to send back a
+ * reply message of type &QLINK_MSG_TYPE_CMDRSP, containing at least command
+ * execution status (one of &enum qlink_cmd_result) at least. Reply message
+ * may also contain data payload specific to the command type.
+ *
+ * @QLINK_CMD_CHANS_INFO_GET: for the specified MAC and specified band, get
+ *	number of operational channels and information on each of the channel.
+ *	This command is generic to a specified MAC, interface index must be set
+ *	to QLINK_VIFID_RSVD in command header.
+ */
+enum qlink_cmd_type {
+	QLINK_CMD_FW_INIT		= 0x0001,
+	QLINK_CMD_FW_DEINIT		= 0x0002,
+	QLINK_CMD_REGISTER_MGMT		= 0x0003,
+	QLINK_CMD_SEND_MGMT_FRAME	= 0x0004,
+	QLINK_CMD_MGMT_SET_APPIE	= 0x0005,
+	QLINK_CMD_PHY_PARAMS_GET	= 0x0011,
+	QLINK_CMD_PHY_PARAMS_SET	= 0x0012,
+	QLINK_CMD_GET_HW_INFO		= 0x0013,
+	QLINK_CMD_MAC_INFO		= 0x0014,
+	QLINK_CMD_ADD_INTF		= 0x0015,
+	QLINK_CMD_DEL_INTF		= 0x0016,
+	QLINK_CMD_CHANGE_INTF		= 0x0017,
+	QLINK_CMD_UPDOWN_INTF		= 0x0018,
+	QLINK_CMD_REG_REGION		= 0x0019,
+	QLINK_CMD_CHANS_INFO_GET	= 0x001A,
+	QLINK_CMD_CONFIG_AP		= 0x0020,
+	QLINK_CMD_START_AP		= 0x0021,
+	QLINK_CMD_STOP_AP		= 0x0022,
+	QLINK_CMD_GET_STA_INFO		= 0x0030,
+	QLINK_CMD_ADD_KEY		= 0x0040,
+	QLINK_CMD_DEL_KEY		= 0x0041,
+	QLINK_CMD_SET_DEFAULT_KEY	= 0x0042,
+	QLINK_CMD_SET_DEFAULT_MGMT_KEY	= 0x0043,
+	QLINK_CMD_CHANGE_STA		= 0x0051,
+	QLINK_CMD_DEL_STA		= 0x0052,
+	QLINK_CMD_SCAN			= 0x0053,
+	QLINK_CMD_CONNECT		= 0x0060,
+	QLINK_CMD_DISCONNECT		= 0x0061,
+};
+
+/**
+ * struct qlink_cmd - QLINK command message header
+ *
+ * Header used for QLINK messages of QLINK_MSG_TYPE_CMD type.
+ *
+ * @mhdr: Common QLINK message header.
+ * @cmd_id: command id, one of &enum qlink_cmd_type.
+ * @seq_num: sequence number of command message, used for matching with
+ *	response message.
+ * @macid: index of physical radio device the command is destined to or
+ *	QLINK_MACID_RSVD if not applicable.
+ * @vifid: index of virtual wireless interface on specified @macid the command
+ *	is destined to or QLINK_VIFID_RSVD if not applicable.
+ */
+struct qlink_cmd {
+	struct qlink_msg_header mhdr;
+	__le16 cmd_id;
+	__le16 seq_num;
+	u8 rsvd[2];
+	u8 macid;
+	u8 vifid;
+} __packed;
+
+/**
+ * struct qlink_cmd_manage_intf - interface management command
+ *
+ * Data for interface management commands QLINK_CMD_ADD_INTF, QLINK_CMD_DEL_INTF
+ * and QLINK_CMD_CHANGE_INTF.
+ *
+ * @intf_info: interface description.
+ */
+struct qlink_cmd_manage_intf {
+	struct qlink_cmd chdr;
+	struct qlink_intf_info intf_info;
+} __packed;
+
+enum qlink_mgmt_frame_type {
+	QLINK_MGMT_FRAME_ASSOC_REQ	= 0x00,
+	QLINK_MGMT_FRAME_ASSOC_RESP	= 0x01,
+	QLINK_MGMT_FRAME_REASSOC_REQ	= 0x02,
+	QLINK_MGMT_FRAME_REASSOC_RESP	= 0x03,
+	QLINK_MGMT_FRAME_PROBE_REQ	= 0x04,
+	QLINK_MGMT_FRAME_PROBE_RESP	= 0x05,
+	QLINK_MGMT_FRAME_BEACON		= 0x06,
+	QLINK_MGMT_FRAME_ATIM		= 0x07,
+	QLINK_MGMT_FRAME_DISASSOC	= 0x08,
+	QLINK_MGMT_FRAME_AUTH		= 0x09,
+	QLINK_MGMT_FRAME_DEAUTH		= 0x0A,
+	QLINK_MGMT_FRAME_ACTION		= 0x0B,
+
+	QLINK_MGMT_FRAME_TYPE_COUNT
+};
+
+/**
+ * struct qlink_cmd_mgmt_frame_register - data for QLINK_CMD_REGISTER_MGMT
+ *
+ * @frame_type: MGMT frame type the registration request describes, one of
+ *	&enum qlink_mgmt_frame_type.
+ * @do_register: 0 - unregister, otherwise register for reception of specified
+ *	MGMT frame type.
+ */
+struct qlink_cmd_mgmt_frame_register {
+	struct qlink_cmd chdr;
+	__le16 frame_type;
+	u8 do_register;
+} __packed;
+
+enum qlink_mgmt_frame_tx_flags {
+	QLINK_MGMT_FRAME_TX_FLAG_NONE		= 0,
+	QLINK_MGMT_FRAME_TX_FLAG_OFFCHAN	= BIT(0),
+	QLINK_MGMT_FRAME_TX_FLAG_NO_CCK		= BIT(1),
+	QLINK_MGMT_FRAME_TX_FLAG_ACK_NOWAIT	= BIT(2),
+};
+
+/**
+ * struct qlink_cmd_mgmt_frame_tx - data for QLINK_CMD_SEND_MGMT_FRAME command
+ *
+ * @cookie: opaque request identifier.
+ * @freq: Frequency to use for frame transmission.
+ * @flags: Transmission flags, one of &enum qlink_mgmt_frame_tx_flags.
+ * @frame_data: frame to transmit.
+ */
+struct qlink_cmd_mgmt_frame_tx {
+	struct qlink_cmd chdr;
+	__le32 cookie;
+	__le16 freq;
+	__le16 flags;
+	u8 frame_data[0];
+} __packed;
+
+/**
+ * struct qlink_cmd_mgmt_append_ie - data for QLINK_CMD_MGMT_SET_APPIE command
+ *
+ * @type: type of MGMT frame to appent requested IEs to, one of
+ *	&enum qlink_mgmt_frame_type.
+ * @flags: for future use.
+ * @ie_data: IEs data to append.
+ */
+struct qlink_cmd_mgmt_append_ie {
+	struct qlink_cmd chdr;
+	u8 type;
+	u8 flags;
+	u8 ie_data[0];
+} __packed;
+
+/**
+ * struct qlink_cmd_get_sta_info - data for QLINK_CMD_GET_STA_INFO command
+ *
+ * @sta_addr: MAC address of the STA statistics is requested for.
+ */
+struct qlink_cmd_get_sta_info {
+	struct qlink_cmd chdr;
+	u8 sta_addr[ETH_ALEN];
+} __packed;
+
+/**
+ * struct qlink_cmd_add_key - data for QLINK_CMD_ADD_KEY command.
+ *
+ * @key_index: index of the key being installed.
+ * @pairwise: whether to use pairwise key.
+ * @addr: MAC address of a STA key is being installed to.
+ * @cipher: cipher suite.
+ * @key_data: key data itself.
+ */
+struct qlink_cmd_add_key {
+	struct qlink_cmd chdr;
+	u8 key_index;
+	u8 pairwise;
+	u8 addr[ETH_ALEN];
+	__le32 cipher;
+	u8 key_data[0];
+} __packed;
+
+/**
+ * struct qlink_cmd_del_key_req - data for QLINK_CMD_DEL_KEY command
+ *
+ * @key_index: index of the key being removed.
+ * @pairwise: whether to use pairwise key.
+ * @addr: MAC address of a STA for which a key is removed.
+ */
+struct qlink_cmd_del_key {
+	struct qlink_cmd chdr;
+	u8 key_index;
+	u8 pairwise;
+	u8 addr[ETH_ALEN];
+} __packed;
+
+/**
+ * struct qlink_cmd_set_def_key - data for QLINK_CMD_SET_DEFAULT_KEY command
+ *
+ * @key_index: index of the key to be set as default one.
+ * @unicast: key is unicast.
+ * @multicast: key is multicast.
+ */
+struct qlink_cmd_set_def_key {
+	struct qlink_cmd chdr;
+	u8 key_index;
+	u8 unicast;
+	u8 multicast;
+} __packed;
+
+/**
+ * struct qlink_cmd_set_def_mgmt_key - data for QLINK_CMD_SET_DEFAULT_MGMT_KEY
+ *
+ * @key_index: index of the key to be set as default MGMT key.
+ */
+struct qlink_cmd_set_def_mgmt_key {
+	struct qlink_cmd chdr;
+	u8 key_index;
+} __packed;
+
+/**
+ * struct qlink_cmd_change_sta - data for QLINK_CMD_CHANGE_STA command
+ *
+ * @sta_flags_mask: STA flags mask, bitmap of &enum qlink_sta_flags
+ * @sta_flags_set: STA flags values, bitmap of &enum qlink_sta_flags
+ * @sta_addr: address of the STA for which parameters are set.
+ */
+struct qlink_cmd_change_sta {
+	struct qlink_cmd chdr;
+	__le32 sta_flags_mask;
+	__le32 sta_flags_set;
+	u8 sta_addr[ETH_ALEN];
+} __packed;
+
+/**
+ * struct qlink_cmd_del_sta - data for QLINK_CMD_DEL_STA command.
+ *
+ * See &struct station_del_parameters
+ */
+struct qlink_cmd_del_sta {
+	struct qlink_cmd chdr;
+	__le16 reason_code;
+	u8 subtype;
+	u8 sta_addr[ETH_ALEN];
+} __packed;
+
+enum qlink_sta_connect_flags {
+	QLINK_STA_CONNECT_DISABLE_HT	= BIT(0),
+	QLINK_STA_CONNECT_DISABLE_VHT	= BIT(1),
+	QLINK_STA_CONNECT_USE_RRM	= BIT(2),
+};
+
+/**
+ * struct qlink_cmd_connect - data for QLINK_CMD_CONNECT command
+ *
+ * @flags: for future use.
+ * @freq: center frequence of a channel which should be used to connect.
+ * @bg_scan_period: period of background scan.
+ * @bssid: BSSID of the BSS to connect to.
+ * @payload: variable portion of connection request.
+ */
+struct qlink_cmd_connect {
+	struct qlink_cmd chdr;
+	__le32 flags;
+	__le16 freq;
+	__le16 bg_scan_period;
+	u8 bssid[ETH_ALEN];
+	u8 payload[0];
+} __packed;
+
+/**
+ * struct qlink_cmd_disconnect - data for QLINK_CMD_DISCONNECT command
+ *
+ * @reason: code of the reason of disconnect, see &enum ieee80211_reasoncode.
+ */
+struct qlink_cmd_disconnect {
+	struct qlink_cmd chdr;
+	__le16 reason;
+} __packed;
+
+/**
+ * struct qlink_cmd_updown - data for QLINK_CMD_UPDOWN_INTF command
+ *
+ * @if_up: bring specified interface DOWN (if_up==0) or UP (otherwise).
+ *	Interface is specified in common command header @chdr.
+ */
+struct qlink_cmd_updown {
+	struct qlink_cmd chdr;
+	u8 if_up;
+} __packed;
+
+/**
+ * enum qlink_band - a list of frequency bands
+ *
+ * @QLINK_BAND_2GHZ: 2.4GHz band
+ * @QLINK_BAND_5GHZ: 5GHz band
+ * @QLINK_BAND_60GHZ: 60GHz band
+ */
+enum qlink_band {
+	QLINK_BAND_2GHZ = BIT(0),
+	QLINK_BAND_5GHZ = BIT(1),
+	QLINK_BAND_60GHZ = BIT(2),
+};
+
+/**
+ * struct qlink_cmd_chans_info_get - data for QLINK_CMD_CHANS_INFO_GET command
+ *
+ * @band: a PHY band for which channels info is needed, one of @enum qlink_band
+ */
+struct qlink_cmd_chans_info_get {
+	struct qlink_cmd chdr;
+	u8 band;
+} __packed;
+
+/* QLINK Command Responses messages related definitions
+ */
+
+enum qlink_cmd_result {
+	QLINK_CMD_RESULT_OK = 0,
+	QLINK_CMD_RESULT_INVALID,
+	QLINK_CMD_RESULT_ENOTSUPP,
+	QLINK_CMD_RESULT_ENOTFOUND,
+};
+
+/**
+ * struct qlink_resp - QLINK command response message header
+ *
+ * Header used for QLINK messages of QLINK_MSG_TYPE_CMDRSP type.
+ *
+ * @mhdr: see &struct qlink_msg_header.
+ * @cmd_id: command ID the response corresponds to, one of &enum qlink_cmd_type.
+ * @seq_num: sequence number of command message, used for matching with
+ *	response message.
+ * @result: result of the command execution, one of &enum qlink_cmd_result.
+ * @macid: index of physical radio device the response is sent from or
+ *	QLINK_MACID_RSVD if not applicable.
+ * @vifid: index of virtual wireless interface on specified @macid the response
+ *	is sent from or QLINK_VIFID_RSVD if not applicable.
+ */
+struct qlink_resp {
+	struct qlink_msg_header mhdr;
+	__le16 cmd_id;
+	__le16 seq_num;
+	__le16 result;
+	u8 macid;
+	u8 vifid;
+} __packed;
+
+/**
+ * struct qlink_resp_get_mac_info - response for QLINK_CMD_MAC_INFO command
+ *
+ * Data describing specific physical device providing wireless MAC
+ * functionality.
+ *
+ * @dev_mac: MAC address of physical WMAC device (used for first BSS on
+ *	specified WMAC).
+ * @num_tx_chain: Number of transmit chains used by WMAC.
+ * @num_rx_chain: Number of receive chains used by WMAC.
+ * @vht_cap: VHT capabilities.
+ * @ht_cap: HT capabilities.
+ * @bands_cap: wireless bands WMAC can operate in, bitmap of &enum qlink_band.
+ * @phymode_cap: PHY modes WMAC can operate in, bitmap of &enum qlink_phy_mode.
+ * @max_ap_assoc_sta: Maximum number of associations supported by WMAC.
+ * @radar_detect_widths: bitmask of channels BW for which WMAC can detect radar.
+ * @var_info: variable-length WMAC info data.
+ */
+struct qlink_resp_get_mac_info {
+	struct qlink_resp rhdr;
+	u8 dev_mac[ETH_ALEN];
+	u8 num_tx_chain;
+	u8 num_rx_chain;
+	struct ieee80211_vht_cap vht_cap;
+	struct ieee80211_ht_cap ht_cap;
+	u8 bands_cap;
+	u8 phymode_cap;
+	__le16 max_ap_assoc_sta;
+	__le16 radar_detect_widths;
+	u8 var_info[0];
+} __packed;
+
+/**
+ * struct qlink_resp_get_hw_info - response for QLINK_CMD_GET_HW_INFO command
+ *
+ * Description of wireless hardware capabilities and features.
+ *
+ * @fw_ver: wireless hardware firmware version.
+ * @hw_capab: Bitmap of capabilities supported by firmware.
+ * @ql_proto_ver: Version of QLINK protocol used by firmware.
+ * @country_code: country code ID firmware is configured to.
+ * @num_mac: Number of separate physical radio devices provided by hardware.
+ * @mac_bitmap: Bitmap of MAC IDs that are active and can be used in firmware.
+ * @total_tx_chains: total number of transmit chains used by device.
+ * @total_rx_chains: total number of receive chains.
+ */
+struct qlink_resp_get_hw_info {
+	struct qlink_resp rhdr;
+	__le32 fw_ver;
+	__le32 hw_capab;
+	__le16 ql_proto_ver;
+	u8 alpha2_code[2];
+	u8 num_mac;
+	u8 mac_bitmap;
+	u8 total_tx_chain;
+	u8 total_rx_chain;
+} __packed;
+
+/**
+ * struct qlink_resp_manage_intf - response for interface management commands
+ *
+ * Response data for QLINK_CMD_ADD_INTF and QLINK_CMD_CHANGE_INTF commands.
+ *
+ * @rhdr: Common Command Response message header.
+ * @intf_info: interface description.
+ */
+struct qlink_resp_manage_intf {
+	struct qlink_resp rhdr;
+	struct qlink_intf_info intf_info;
+} __packed;
+
+/**
+ * struct qlink_resp_get_sta_info - response for QLINK_CMD_GET_STA_INFO command
+ *
+ * Response data containing statistics for specified STA.
+ *
+ * @sta_addr: MAC address of STA the response carries statistic for.
+ * @info: statistics for specified STA.
+ */
+struct qlink_resp_get_sta_info {
+	struct qlink_resp rhdr;
+	u8 sta_addr[ETH_ALEN];
+	u8 info[0];
+} __packed;
+
+/**
+ * struct qlink_resp_get_chan_info - response for QLINK_CMD_CHANS_INFO_GET cmd
+ *
+ * @band: frequency band to which channels belong to, one of @enum qlink_band.
+ * @num_chans: total number of channels info data contained in reply data.
+ * @info: variable-length channels info.
+ */
+struct qlink_resp_get_chan_info {
+	struct qlink_resp rhdr;
+	u8 band;
+	u8 num_chans;
+	u8 rsvd[2];
+	u8 info[0];
+} __packed;
+
+/**
+ * struct qlink_resp_phy_params - response for QLINK_CMD_PHY_PARAMS_GET command
+ *
+ * @info: variable-length array of PHY params.
+ */
+struct qlink_resp_phy_params {
+	struct qlink_resp rhdr;
+	u8 info[0];
+} __packed;
+
+/* QLINK Events messages related definitions
+ */
+
+enum qlink_event_type {
+	QLINK_EVENT_STA_ASSOCIATED	= 0x0021,
+	QLINK_EVENT_STA_DEAUTH		= 0x0022,
+	QLINK_EVENT_MGMT_RECEIVED	= 0x0023,
+	QLINK_EVENT_SCAN_RESULTS	= 0x0024,
+	QLINK_EVENT_SCAN_COMPLETE	= 0x0025,
+	QLINK_EVENT_BSS_JOIN		= 0x0026,
+	QLINK_EVENT_BSS_LEAVE		= 0x0027,
+};
+
+/**
+ * struct qlink_event - QLINK event message header
+ *
+ * Header used for QLINK messages of QLINK_MSG_TYPE_EVENT type.
+ *
+ * @mhdr: Common QLINK message header.
+ * @event_id: Specifies specific event ID, one of &enum qlink_event_type.
+ * @macid: index of physical radio device the event was generated on or
+ *	QLINK_MACID_RSVD if not applicable.
+ * @vifid: index of virtual wireless interface on specified @macid the event
+ *	was generated on or QLINK_VIFID_RSVD if not applicable.
+ */
+struct qlink_event {
+	struct qlink_msg_header mhdr;
+	__le16 event_id;
+	u8 macid;
+	u8 vifid;
+} __packed;
+
+/**
+ * struct qlink_event_sta_assoc - data for QLINK_EVENT_STA_ASSOCIATED event
+ *
+ * @sta_addr: Address of a STA for which new association event was generated
+ * @frame_control: control bits from 802.11 ASSOC_REQUEST header.
+ * @payload: IEs from association request.
+ */
+struct qlink_event_sta_assoc {
+	struct qlink_event ehdr;
+	u8 sta_addr[ETH_ALEN];
+	__le16 frame_control;
+	u8 ies[0];
+} __packed;
+
+/**
+ * struct qlink_event_sta_deauth - data for QLINK_EVENT_STA_DEAUTH event
+ *
+ * @sta_addr: Address of a deauthenticated STA.
+ * @reason: reason for deauthentication.
+ */
+struct qlink_event_sta_deauth {
+	struct qlink_event ehdr;
+	u8 sta_addr[ETH_ALEN];
+	__le16 reason;
+} __packed;
+
+/**
+ * struct qlink_event_bss_join - data for QLINK_EVENT_BSS_JOIN event
+ *
+ * @bssid: BSSID of a BSS which interface tried to joined.
+ * @status: status of joining attempt, see &enum ieee80211_statuscode.
+ */
+struct qlink_event_bss_join {
+	struct qlink_event ehdr;
+	u8 bssid[ETH_ALEN];
+	__le16 status;
+} __packed;
+
+/**
+ * struct qlink_event_bss_leave - data for QLINK_EVENT_BSS_LEAVE event
+ *
+ * @reason: reason of disconnecting from BSS.
+ */
+struct qlink_event_bss_leave {
+	struct qlink_event ehdr;
+	u16 reason;
+} __packed;
+
+enum qlink_rxmgmt_flags {
+	QLINK_RXMGMT_FLAG_ANSWERED = 1 << 0,
+};
+
+/**
+ * struct qlink_event_rxmgmt - data for QLINK_EVENT_MGMT_RECEIVED event
+ *
+ * @freq: Frequency on which the frame was received in MHz.
+ * @sig_dbm: signal strength in dBm.
+ * @flags: bitmap of &enum qlink_rxmgmt_flags.
+ * @frame_data: data of Rx'd frame itself.
+ */
+struct qlink_event_rxmgmt {
+	struct qlink_event ehdr;
+	__le32 freq;
+	__le32 sig_dbm;
+	__le32 flags;
+	u8 frame_data[0];
+} __packed;
+
+enum qlink_frame_type {
+	QLINK_BSS_FTYPE_UNKNOWN,
+	QLINK_BSS_FTYPE_BEACON,
+	QLINK_BSS_FTYPE_PRESP,
+};
+
+/**
+ * struct qlink_event_scan_result - data for QLINK_EVENT_SCAN_RESULTS event
+ *
+ * @tsf: TSF timestamp indicating when scan results were generated.
+ * @freq: Center frequency of the channel where BSS for which the scan result
+ *	event was generated was discovered.
+ * @capab: capabilities field.
+ * @bintval: beacon interval announced by discovered BSS.
+ * @signal: signal strength.
+ * @frame_type: frame type used to get scan result, see &enum qlink_frame_type.
+ * @bssid: BSSID announced by discovered BSS.
+ * @ssid_len: length of SSID announced by BSS.
+ * @ssid: SSID announced by discovered BSS.
+ * @payload: IEs that are announced by discovered BSS in its MGMt frames.
+ */
+struct qlink_event_scan_result {
+	struct qlink_event ehdr;
+	__le64 tsf;
+	__le16 freq;
+	__le16 capab;
+	__le16 bintval;
+	s8 signal;
+	u8 frame_type;
+	u8 bssid[ETH_ALEN];
+	u8 ssid_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 payload[0];
+} __packed;
+
+/**
+ * enum qlink_scan_complete_flags - indicates result of scan request.
+ *
+ * @QLINK_SCAN_NONE: Scan request was processed.
+ * @QLINK_SCAN_ABORTED: Scan was aborted.
+ */
+enum qlink_scan_complete_flags {
+	QLINK_SCAN_NONE		= 0,
+	QLINK_SCAN_ABORTED	= BIT(0),
+};
+
+/**
+ * struct qlink_event_scan_complete - data for QLINK_EVENT_SCAN_COMPLETE event
+ *
+ * @flags: flags indicating the status of pending scan request,
+ *	see &enum qlink_scan_complete_flags.
+ */
+struct qlink_event_scan_complete {
+	struct qlink_event ehdr;
+	__le32 flags;
+} __packed;
+
+/* QLINK TLVs (Type-Length Values) definitions
+ */
+
+enum qlink_tlv_id {
+	QTN_TLV_ID_FRAG_THRESH		= 0x0201,
+	QTN_TLV_ID_RTS_THRESH		= 0x0202,
+	QTN_TLV_ID_SRETRY_LIMIT		= 0x0203,
+	QTN_TLV_ID_LRETRY_LIMIT		= 0x0204,
+	QTN_TLV_ID_BCN_PERIOD		= 0x0205,
+	QTN_TLV_ID_DTIM			= 0x0206,
+	QTN_TLV_ID_CHANNEL		= 0x020F,
+	QTN_TLV_ID_COVERAGE_CLASS	= 0x0213,
+	QTN_TLV_ID_IFACE_LIMIT		= 0x0214,
+	QTN_TLV_ID_NUM_IFACE_COMB	= 0x0215,
+	QTN_TLV_ID_STA_BASIC_COUNTERS	= 0x0300,
+	QTN_TLV_ID_STA_GENERIC_INFO	= 0x0301,
+	QTN_TLV_ID_KEY			= 0x0302,
+	QTN_TLV_ID_SEQ			= 0x0303,
+	QTN_TLV_ID_CRYPTO		= 0x0304,
+	QTN_TLV_ID_IE_SET		= 0x0305,
+};
+
+struct qlink_tlv_hdr {
+	__le16 type;
+	__le16 len;
+	u8 val[0];
+} __packed;
+
+struct qlink_iface_limit {
+	__le16 max_num;
+	__le16 type_mask;
+} __packed;
+
+struct qlink_iface_comb_num {
+	__le16 iface_comb_num;
+} __packed;
+
+struct qlink_sta_stat_basic_counters {
+	__le64 rx_bytes;
+	__le64 tx_bytes;
+	__le64 rx_beacons;
+	__le32 rx_packets;
+	__le32 tx_packets;
+	__le32 rx_dropped;
+	__le32 tx_failed;
+} __packed;
+
+enum qlink_sta_info_rate_flags {
+	QLINK_STA_INFO_RATE_FLAG_INVALID	= 0,
+	QLINK_STA_INFO_RATE_FLAG_HT_MCS		= BIT(0),
+	QLINK_STA_INFO_RATE_FLAG_VHT_MCS	= BIT(1),
+	QLINK_STA_INFO_RATE_FLAG_SHORT_GI	= BIT(2),
+	QLINK_STA_INFO_RATE_FLAG_60G		= BIT(3),
+};
+
+enum qlink_sta_info_rate_bw {
+	QLINK_STA_INFO_RATE_BW_5		= 0,
+	QLINK_STA_INFO_RATE_BW_10		= 1,
+	QLINK_STA_INFO_RATE_BW_20		= 2,
+	QLINK_STA_INFO_RATE_BW_40		= 3,
+	QLINK_STA_INFO_RATE_BW_80		= 4,
+	QLINK_STA_INFO_RATE_BW_160		= 5,
+};
+
+/**
+ * struct qlink_sta_info_rate - STA rate statistics
+ *
+ * @rate: data rate in Mbps.
+ * @flags: bitmap of &enum qlink_sta_flags.
+ * @mcs: 802.11-defined MCS index.
+ * nss: Number of Spatial Streams.
+ * @bw: bandwidth, one of &enum qlink_sta_info_rate_bw.
+ */
+struct qlink_sta_info_rate {
+	__le16 rate;
+	u8 flags;
+	u8 mcs;
+	u8 nss;
+	u8 bw;
+} __packed;
+
+struct qlink_sta_info_state {
+	__le32 mask;
+	__le32 value;
+} __packed;
+
+#define QLINK_RSSI_OFFSET	120
+
+struct qlink_sta_info_generic {
+	struct qlink_sta_info_state state;
+	__le32 connected_time;
+	__le32 inactive_time;
+	struct qlink_sta_info_rate rx_rate;
+	struct qlink_sta_info_rate tx_rate;
+	u8 rssi;
+	u8 rssi_avg;
+} __packed;
+
+struct qlink_tlv_frag_rts_thr {
+	struct qlink_tlv_hdr hdr;
+	__le16 thr;
+} __packed;
+
+struct qlink_tlv_rlimit {
+	struct qlink_tlv_hdr hdr;
+	u8 rlimit;
+} __packed;
+
+struct qlink_tlv_cclass {
+	struct qlink_tlv_hdr hdr;
+	u8 cclass;
+} __packed;
+
+enum qlink_dfs_state {
+	QLINK_DFS_USABLE,
+	QLINK_DFS_UNAVAILABLE,
+	QLINK_DFS_AVAILABLE,
+};
+
+enum qlink_channel_flags {
+	QLINK_CHAN_DISABLED		= BIT(0),
+	QLINK_CHAN_NO_IR		= BIT(1),
+	QLINK_CHAN_RADAR		= BIT(3),
+	QLINK_CHAN_NO_HT40PLUS		= BIT(4),
+	QLINK_CHAN_NO_HT40MINUS		= BIT(5),
+	QLINK_CHAN_NO_OFDM		= BIT(6),
+	QLINK_CHAN_NO_80MHZ		= BIT(7),
+	QLINK_CHAN_NO_160MHZ		= BIT(8),
+	QLINK_CHAN_INDOOR_ONLY		= BIT(9),
+	QLINK_CHAN_IR_CONCURRENT	= BIT(10),
+	QLINK_CHAN_NO_20MHZ		= BIT(11),
+	QLINK_CHAN_NO_10MHZ		= BIT(12),
+};
+
+struct qlink_tlv_channel {
+	struct qlink_tlv_hdr hdr;
+	__le16 hw_value;
+	__le16 center_freq;
+	__le32 flags;
+	u8 band;
+	u8 max_antenna_gain;
+	u8 max_power;
+	u8 max_reg_power;
+	__le32 dfs_cac_ms;
+	u8 dfs_state;
+	u8 beacon_found;
+	u8 rsvd[2];
+} __packed;
+
+#define QLINK_MAX_NR_CIPHER_SUITES            5
+#define QLINK_MAX_NR_AKM_SUITES               2
+
+struct qlink_auth_encr {
+	__le32 wpa_versions;
+	__le32 cipher_group;
+	__le32 n_ciphers_pairwise;
+	__le32 ciphers_pairwise[QLINK_MAX_NR_CIPHER_SUITES];
+	__le32 n_akm_suites;
+	__le32 akm_suites[QLINK_MAX_NR_AKM_SUITES];
+	__le16 control_port_ethertype;
+	u8 auth_type;
+	u8 privacy;
+	u8 mfp;
+	u8 control_port;
+	u8 control_port_no_encrypt;
+} __packed;
+
+#endif /* _QTN_QLINK_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
new file mode 100644
index 0000000..49ae652
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -0,0 +1,71 @@
+/*
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
+ */
+
+#include <linux/nl80211.h>
+
+#include "qlink_util.h"
+
+u16 qlink_iface_type_mask_to_nl(u16 qlink_mask)
+{
+	u16 result = 0;
+
+	if (qlink_mask & QLINK_IFTYPE_AP)
+		result |= BIT(NL80211_IFTYPE_AP);
+
+	if (qlink_mask & QLINK_IFTYPE_STATION)
+		result |= BIT(NL80211_IFTYPE_STATION);
+
+	if (qlink_mask & QLINK_IFTYPE_ADHOC)
+		result |= BIT(NL80211_IFTYPE_ADHOC);
+
+	if (qlink_mask & QLINK_IFTYPE_MONITOR)
+		result |= BIT(NL80211_IFTYPE_MONITOR);
+
+	if (qlink_mask & QLINK_IFTYPE_WDS)
+		result |= BIT(NL80211_IFTYPE_WDS);
+
+	return result;
+}
+
+u8 qlink_chan_width_mask_to_nl(u16 qlink_mask)
+{
+	u8 result = 0;
+
+	if (qlink_mask & QLINK_CHAN_WIDTH_5)
+		result |= BIT(NL80211_CHAN_WIDTH_5);
+
+	if (qlink_mask & QLINK_CHAN_WIDTH_10)
+		result |= BIT(NL80211_CHAN_WIDTH_10);
+
+	if (qlink_mask & QLINK_CHAN_WIDTH_20_NOHT)
+		result |= BIT(NL80211_CHAN_WIDTH_20_NOHT);
+
+	if (qlink_mask & QLINK_CHAN_WIDTH_20)
+		result |= BIT(NL80211_CHAN_WIDTH_20);
+
+	if (qlink_mask & QLINK_CHAN_WIDTH_40)
+		result |= BIT(NL80211_CHAN_WIDTH_40);
+
+	if (qlink_mask & QLINK_CHAN_WIDTH_80)
+		result |= BIT(NL80211_CHAN_WIDTH_80);
+
+	if (qlink_mask & QLINK_CHAN_WIDTH_80P80)
+		result |= BIT(NL80211_CHAN_WIDTH_80P80);
+
+	if (qlink_mask & QLINK_CHAN_WIDTH_160)
+		result |= BIT(NL80211_CHAN_WIDTH_160);
+
+	return result;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
new file mode 100644
index 0000000..d8de484
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -0,0 +1,80 @@
+/*
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
+ */
+
+#ifndef _QTN_FMAC_QLINK_UTIL_H_
+#define _QTN_FMAC_QLINK_UTIL_H_
+
+#include <linux/types.h>
+#include <linux/skbuff.h>
+
+#include "qlink.h"
+
+static inline void qtnf_cmd_skb_put_action(struct sk_buff *skb, u16 action)
+{
+	__le16 *buf_ptr;
+
+	buf_ptr = (__le16 *)skb_put(skb, sizeof(action));
+	*buf_ptr = cpu_to_le16(action);
+}
+
+static inline void
+qtnf_cmd_skb_put_buffer(struct sk_buff *skb, const u8 *buf_src, size_t len)
+{
+	u8 *buf_dst;
+
+	buf_dst = skb_put(skb, len);
+	memcpy(buf_dst, buf_src, len);
+}
+
+static inline void qtnf_cmd_skb_put_tlv_arr(struct sk_buff *skb,
+					    u16 tlv_id, const u8 arr[],
+					    size_t arr_len)
+{
+	struct qlink_tlv_hdr *hdr =
+			(void *)skb_put(skb, sizeof(*hdr) + arr_len);
+
+	hdr->type = cpu_to_le16(tlv_id);
+	hdr->len = cpu_to_le16(arr_len);
+	memcpy(hdr->val, arr, arr_len);
+}
+
+static inline void qtnf_cmd_skb_put_tlv_u8(struct sk_buff *skb, u16 tlv_id,
+					   u8 value)
+{
+	struct qlink_tlv_hdr *hdr =
+			(void *)skb_put(skb, sizeof(*hdr) + sizeof(value));
+
+	hdr->type = cpu_to_le16(tlv_id);
+	hdr->len = cpu_to_le16(sizeof(value));
+	*hdr->val = value;
+}
+
+static inline void qtnf_cmd_skb_put_tlv_u16(struct sk_buff *skb,
+					    u16 tlv_id, u16 value)
+{
+	struct qlink_tlv_hdr *hdr =
+			(void *)skb_put(skb, sizeof(*hdr) + sizeof(value));
+	__le16 tmp = cpu_to_le16(value);
+
+	hdr->type = cpu_to_le16(tlv_id);
+	hdr->len = cpu_to_le16(sizeof(value));
+	memcpy(hdr->val, &tmp, sizeof(tmp));
+}
+
+u16 qlink_iface_type_mask_to_nl(u16 qlink_mask);
+u8 qlink_chan_width_mask_to_nl(u16 qlink_mask);
+
+#endif /* _QTN_FMAC_QLINK_UTIL_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
new file mode 100644
index 0000000..c4ad40d
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
@@ -0,0 +1,32 @@
+/*
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
+ */
+
+#ifndef	_QTN_HW_IDS_H_
+#define	_QTN_HW_IDS_H_
+
+#include <linux/pci_ids.h>
+
+#define PCIE_VENDOR_ID_QUANTENNA	(0x1bb5)
+
+/* PCIE Device IDs */
+
+#define	PCIE_DEVICE_ID_QTN_PEARL	(0x0008)
+
+/* FW names */
+
+#define QTN_PCI_PEARL_FW_NAME		"qtn/fmac_qsr10g.img"
+
+#endif	/* _QTN_HW_IDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
new file mode 100644
index 0000000..aa106dd
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
@@ -0,0 +1,176 @@
+/*
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
+ */
+
+#include <linux/types.h>
+#include <linux/io.h>
+
+#include "shm_ipc.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"qtnfmac shm_ipc: %s: " fmt, __func__
+
+static bool qtnf_shm_ipc_has_new_data(struct qtnf_shm_ipc *ipc)
+{
+	const u32 flags = readl(&ipc->shm_region->headroom.hdr.flags);
+
+	return (flags & QTNF_SHM_IPC_NEW_DATA);
+}
+
+static void qtnf_shm_handle_new_data(struct qtnf_shm_ipc *ipc)
+{
+	size_t size;
+	bool rx_buff_ok = true;
+	struct qtnf_shm_ipc_region_header __iomem *shm_reg_hdr;
+
+	shm_reg_hdr = &ipc->shm_region->headroom.hdr;
+
+	size = readw(&shm_reg_hdr->data_len);
+
+	if (unlikely(size == 0 || size > QTN_IPC_MAX_DATA_SZ)) {
+		pr_err("wrong rx packet size: %zu\n", size);
+		rx_buff_ok = false;
+	} else {
+		memcpy_fromio(ipc->rx_data, ipc->shm_region->data, size);
+	}
+
+	writel(QTNF_SHM_IPC_ACK, &shm_reg_hdr->flags);
+	readl(&shm_reg_hdr->flags); /* flush PCIe write */
+
+	ipc->interrupt.fn(ipc->interrupt.arg);
+
+	if (likely(rx_buff_ok)) {
+		ipc->rx_packet_count++;
+		ipc->rx_callback.fn(ipc->rx_callback.arg, ipc->rx_data, size);
+	}
+}
+
+static void qtnf_shm_ipc_irq_work(struct work_struct *work)
+{
+	struct qtnf_shm_ipc *ipc = container_of(work, struct qtnf_shm_ipc,
+						irq_work);
+
+	while (qtnf_shm_ipc_has_new_data(ipc))
+		qtnf_shm_handle_new_data(ipc);
+}
+
+static void qtnf_shm_ipc_irq_inbound_handler(struct qtnf_shm_ipc *ipc)
+{
+	u32 flags;
+
+	flags = readl(&ipc->shm_region->headroom.hdr.flags);
+
+	if (flags & QTNF_SHM_IPC_NEW_DATA)
+		queue_work(ipc->workqueue, &ipc->irq_work);
+}
+
+static void qtnf_shm_ipc_irq_outbound_handler(struct qtnf_shm_ipc *ipc)
+{
+	u32 flags;
+
+	if (!READ_ONCE(ipc->waiting_for_ack))
+		return;
+
+	flags = readl(&ipc->shm_region->headroom.hdr.flags);
+
+	if (flags & QTNF_SHM_IPC_ACK) {
+		WRITE_ONCE(ipc->waiting_for_ack, 0);
+		complete(&ipc->tx_completion);
+	}
+}
+
+int qtnf_shm_ipc_init(struct qtnf_shm_ipc *ipc,
+		      enum qtnf_shm_ipc_direction direction,
+		      struct qtnf_shm_ipc_region __iomem *shm_region,
+		      struct workqueue_struct *workqueue,
+		      const struct qtnf_shm_ipc_int *interrupt,
+		      const struct qtnf_shm_ipc_rx_callback *rx_callback)
+{
+	BUILD_BUG_ON(offsetof(struct qtnf_shm_ipc_region, data) !=
+		     QTN_IPC_REG_HDR_SZ);
+	BUILD_BUG_ON(sizeof(struct qtnf_shm_ipc_region) > QTN_IPC_REG_SZ);
+
+	ipc->shm_region = shm_region;
+	ipc->direction = direction;
+	ipc->interrupt = *interrupt;
+	ipc->rx_callback = *rx_callback;
+	ipc->tx_packet_count = 0;
+	ipc->rx_packet_count = 0;
+	ipc->workqueue = workqueue;
+	ipc->waiting_for_ack = 0;
+	ipc->tx_timeout_count = 0;
+
+	switch (direction) {
+	case QTNF_SHM_IPC_OUTBOUND:
+		ipc->irq_handler = qtnf_shm_ipc_irq_outbound_handler;
+		break;
+	case QTNF_SHM_IPC_INBOUND:
+		ipc->irq_handler = qtnf_shm_ipc_irq_inbound_handler;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	INIT_WORK(&ipc->irq_work, qtnf_shm_ipc_irq_work);
+	init_completion(&ipc->tx_completion);
+
+	return 0;
+}
+
+void qtnf_shm_ipc_free(struct qtnf_shm_ipc *ipc)
+{
+	complete_all(&ipc->tx_completion);
+}
+
+int qtnf_shm_ipc_send(struct qtnf_shm_ipc *ipc, const u8 *buf, size_t size)
+{
+	int ret = 0;
+	struct qtnf_shm_ipc_region_header __iomem *shm_reg_hdr;
+
+	shm_reg_hdr = &ipc->shm_region->headroom.hdr;
+
+	if (unlikely(size > QTN_IPC_MAX_DATA_SZ))
+		return -E2BIG;
+
+	ipc->tx_packet_count++;
+
+	writew(size, &shm_reg_hdr->data_len);
+	memcpy_toio(ipc->shm_region->data, buf, size);
+
+	/* sync previous writes before proceeding */
+	dma_wmb();
+
+	WRITE_ONCE(ipc->waiting_for_ack, 1);
+
+	/* sync previous memory write before announcing new data ready */
+	wmb();
+
+	writel(QTNF_SHM_IPC_NEW_DATA, &shm_reg_hdr->flags);
+	readl(&shm_reg_hdr->flags); /* flush PCIe write */
+
+	ipc->interrupt.fn(ipc->interrupt.arg);
+
+	if (!wait_for_completion_timeout(&ipc->tx_completion,
+					 QTN_SHM_IPC_ACK_TIMEOUT)) {
+		ret = -ETIMEDOUT;
+		ipc->tx_timeout_count++;
+		pr_err("TX ACK timeout\n");
+	}
+
+	/* now we're not waiting for ACK even in case of timeout */
+	WRITE_ONCE(ipc->waiting_for_ack, 0);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
new file mode 100644
index 0000000..453dd64
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
@@ -0,0 +1,80 @@
+/*
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
+ */
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
+#define QTN_SHM_IPC_ACK_TIMEOUT		(2 * HZ)
+
+struct qtnf_shm_ipc_int {
+	void (*fn)(void *arg);
+	void *arg;
+};
+
+struct qtnf_shm_ipc_rx_callback {
+	void (*fn)(void *arg, const u8 *buf, size_t len);
+	void *arg;
+};
+
+enum qtnf_shm_ipc_direction {
+	QTNF_SHM_IPC_OUTBOUND		= BIT(0),
+	QTNF_SHM_IPC_INBOUND		= BIT(1),
+};
+
+struct qtnf_shm_ipc {
+	struct qtnf_shm_ipc_region __iomem *shm_region;
+	enum qtnf_shm_ipc_direction direction;
+	size_t tx_packet_count;
+	size_t rx_packet_count;
+
+	size_t tx_timeout_count;
+
+	u8 waiting_for_ack;
+
+	u8 rx_data[QTN_IPC_MAX_DATA_SZ] __aligned(sizeof(u32));
+
+	struct qtnf_shm_ipc_int interrupt;
+	struct qtnf_shm_ipc_rx_callback rx_callback;
+
+	void (*irq_handler)(struct qtnf_shm_ipc *ipc);
+
+	struct workqueue_struct *workqueue;
+	struct work_struct irq_work;
+	struct completion tx_completion;
+};
+
+int qtnf_shm_ipc_init(struct qtnf_shm_ipc *ipc,
+		      enum qtnf_shm_ipc_direction direction,
+		      struct qtnf_shm_ipc_region __iomem *shm_region,
+		      struct workqueue_struct *workqueue,
+		      const struct qtnf_shm_ipc_int *interrupt,
+		      const struct qtnf_shm_ipc_rx_callback *rx_callback);
+void qtnf_shm_ipc_free(struct qtnf_shm_ipc *ipc);
+int qtnf_shm_ipc_send(struct qtnf_shm_ipc *ipc, const u8 *buf, size_t size);
+
+static inline void qtnf_shm_ipc_irq_handler(struct qtnf_shm_ipc *ipc)
+{
+	ipc->irq_handler(ipc);
+}
+
+#endif /* _QTN_FMAC_SHM_IPC_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h
new file mode 100644
index 0000000..95a5f89
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc_defs.h
@@ -0,0 +1,46 @@
+/*
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
+ */
+
+#ifndef _QTN_FMAC_SHM_IPC_DEFS_H_
+#define _QTN_FMAC_SHM_IPC_DEFS_H_
+
+#include <linux/types.h>
+
+#define QTN_IPC_REG_HDR_SZ	(32)
+#define QTN_IPC_REG_SZ		(4096)
+#define QTN_IPC_MAX_DATA_SZ	(QTN_IPC_REG_SZ - QTN_IPC_REG_HDR_SZ)
+
+enum qtnf_shm_ipc_region_flags {
+	QTNF_SHM_IPC_NEW_DATA		= BIT(0),
+	QTNF_SHM_IPC_ACK		= BIT(1),
+};
+
+struct qtnf_shm_ipc_region_header {
+	__le32 flags;
+	__le16 data_len;
+} __packed;
+
+union qtnf_shm_ipc_region_headroom {
+	struct qtnf_shm_ipc_region_header hdr;
+	u8 headroom[QTN_IPC_REG_HDR_SZ];
+} __packed;
+
+struct qtnf_shm_ipc_region {
+	union qtnf_shm_ipc_region_headroom headroom;
+	u8 data[QTN_IPC_MAX_DATA_SZ];
+} __packed;
+
+#endif /* _QTN_FMAC_SHM_IPC_DEFS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/trans.c b/drivers/net/wireless/quantenna/qtnfmac/trans.c
new file mode 100644
index 0000000..ccddfeb
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/trans.c
@@ -0,0 +1,224 @@
+/*
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
+ */
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
+#define QTNF_DEF_SYNC_CMD_TIMEOUT	(5 * HZ)
+
+int qtnf_trans_send_cmd_with_resp(struct qtnf_bus *bus, struct sk_buff *cmd_skb,
+				  struct sk_buff **response_skb)
+{
+	struct qtnf_cmd_ctl_node *ctl_node = &bus->trans.curr_cmd;
+	struct qlink_cmd *cmd = (void *)cmd_skb->data;
+	int ret = 0;
+	long status;
+	bool resp_not_handled = true;
+	struct sk_buff *resp_skb = NULL;
+
+	if (unlikely(!response_skb))
+		return -EFAULT;
+
+	spin_lock(&ctl_node->resp_lock);
+	ctl_node->seq_num++;
+	cmd->seq_num = cpu_to_le16(ctl_node->seq_num);
+	WARN(ctl_node->resp_skb, "qtnfmac: response skb not empty\n");
+	ctl_node->waiting_for_resp = true;
+	spin_unlock(&ctl_node->resp_lock);
+
+	ret = qtnf_bus_control_tx(bus, cmd_skb);
+	dev_kfree_skb(cmd_skb);
+
+	if (unlikely(ret))
+		goto out;
+
+	status = wait_for_completion_interruptible_timeout(
+						&ctl_node->cmd_resp_completion,
+						QTNF_DEF_SYNC_CMD_TIMEOUT);
+
+	spin_lock(&ctl_node->resp_lock);
+	resp_not_handled = ctl_node->waiting_for_resp;
+	resp_skb = ctl_node->resp_skb;
+	ctl_node->resp_skb = NULL;
+	ctl_node->waiting_for_resp = false;
+	spin_unlock(&ctl_node->resp_lock);
+
+	if (unlikely(status <= 0)) {
+		if (status == 0) {
+			ret = -ETIMEDOUT;
+			pr_err("response timeout\n");
+		} else {
+			ret = -EINTR;
+			pr_debug("interrupted\n");
+		}
+	}
+
+	if (unlikely(!resp_skb || resp_not_handled)) {
+		if (!ret)
+			ret = -EFAULT;
+
+		goto out;
+	}
+
+	ret = 0;
+	*response_skb = resp_skb;
+
+out:
+	if (unlikely(resp_skb && resp_not_handled))
+		dev_kfree_skb(resp_skb);
+
+	return ret;
+}
+
+static void qtnf_trans_signal_cmdresp(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	struct qtnf_cmd_ctl_node *ctl_node = &bus->trans.curr_cmd;
+	const struct qlink_resp *resp = (const struct qlink_resp *)skb->data;
+	const u16 recvd_seq_num = le16_to_cpu(resp->seq_num);
+
+	spin_lock(&ctl_node->resp_lock);
+
+	if (unlikely(!ctl_node->waiting_for_resp)) {
+		pr_err("unexpected response\n");
+		goto out_err;
+	}
+
+	if (unlikely(recvd_seq_num != ctl_node->seq_num)) {
+		pr_err("seq num mismatch\n");
+		goto out_err;
+	}
+
+	ctl_node->resp_skb = skb;
+	ctl_node->waiting_for_resp = false;
+
+	spin_unlock(&ctl_node->resp_lock);
+
+	complete(&ctl_node->cmd_resp_completion);
+	return;
+
+out_err:
+	spin_unlock(&ctl_node->resp_lock);
+	dev_kfree_skb(skb);
+}
+
+static int qtnf_trans_event_enqueue(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	struct qtnf_qlink_transport *trans = &bus->trans;
+
+	if (likely(skb_queue_len(&trans->event_queue) <
+		   trans->event_queue_max_len)) {
+		skb_queue_tail(&trans->event_queue, skb);
+		queue_work(bus->workqueue, &bus->event_work);
+	} else {
+		pr_warn("event dropped due to queue overflow\n");
+		dev_kfree_skb(skb);
+		return -1;
+	}
+
+	return 0;
+}
+
+void qtnf_trans_init(struct qtnf_bus *bus)
+{
+	struct qtnf_qlink_transport *trans = &bus->trans;
+
+	init_completion(&trans->curr_cmd.cmd_resp_completion);
+	spin_lock_init(&trans->curr_cmd.resp_lock);
+
+	spin_lock(&trans->curr_cmd.resp_lock);
+	trans->curr_cmd.seq_num = 0;
+	trans->curr_cmd.waiting_for_resp = false;
+	trans->curr_cmd.resp_skb = NULL;
+	spin_unlock(&trans->curr_cmd.resp_lock);
+
+	/* Init event handling related fields */
+	skb_queue_head_init(&trans->event_queue);
+	trans->event_queue_max_len = QTNF_MAX_EVENT_QUEUE_LEN;
+}
+
+static void qtnf_trans_free_events(struct qtnf_bus *bus)
+{
+	struct sk_buff_head *event_queue = &bus->trans.event_queue;
+	struct sk_buff *current_event_skb = skb_dequeue(event_queue);
+
+	while (current_event_skb) {
+		dev_kfree_skb_any(current_event_skb);
+		current_event_skb = skb_dequeue(event_queue);
+	}
+}
+
+void qtnf_trans_free(struct qtnf_bus *bus)
+{
+	if (!bus) {
+		pr_err("invalid bus pointer\n");
+		return;
+	}
+
+	qtnf_trans_free_events(bus);
+}
+
+int qtnf_trans_handle_rx_ctl_packet(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	const struct qlink_msg_header *header = (void *)skb->data;
+	int ret = -1;
+
+	if (unlikely(skb->len < sizeof(*header))) {
+		pr_warn("packet is too small: %u\n", skb->len);
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	if (unlikely(skb->len != le16_to_cpu(header->len))) {
+		pr_warn("cmd reply length mismatch: %u != %u\n",
+			skb->len, le16_to_cpu(header->len));
+		dev_kfree_skb(skb);
+		return -EFAULT;
+	}
+
+	switch (le16_to_cpu(header->type)) {
+	case QLINK_MSG_TYPE_CMDRSP:
+		if (unlikely(skb->len < sizeof(struct qlink_cmd))) {
+			pr_warn("cmd reply too short: %u\n", skb->len);
+			dev_kfree_skb(skb);
+			break;
+		}
+
+		qtnf_trans_signal_cmdresp(bus, skb);
+		break;
+	case QLINK_MSG_TYPE_EVENT:
+		if (unlikely(skb->len < sizeof(struct qlink_event))) {
+			pr_warn("event too short: %u\n", skb->len);
+			dev_kfree_skb(skb);
+			break;
+		}
+
+		ret = qtnf_trans_event_enqueue(bus, skb);
+		break;
+	default:
+		pr_warn("unknown packet type: %x\n", le16_to_cpu(header->type));
+		dev_kfree_skb(skb);
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qtnf_trans_handle_rx_ctl_packet);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/trans.h b/drivers/net/wireless/quantenna/qtnfmac/trans.h
new file mode 100644
index 0000000..9a473e0
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/trans.h
@@ -0,0 +1,57 @@
+/*
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
+ */
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
+#define QTNF_CMD_FLAG_RESP_REQ		BIT(0)
+
+#define QTNF_MAX_CMD_BUF_SIZE	2048
+#define QTNF_DEF_CMD_HROOM	4
+
+struct qtnf_bus;
+
+struct qtnf_cmd_ctl_node {
+	struct completion cmd_resp_completion;
+	struct sk_buff *resp_skb;
+	u16 seq_num;
+	bool waiting_for_resp;
+	spinlock_t resp_lock; /* lock for resp_skb & waiting_for_resp changes */
+};
+
+struct qtnf_qlink_transport {
+	struct qtnf_cmd_ctl_node curr_cmd;
+	struct sk_buff_head event_queue;
+	size_t event_queue_max_len;
+};
+
+void qtnf_trans_init(struct qtnf_bus *bus);
+void qtnf_trans_free(struct qtnf_bus *bus);
+
+int qtnf_trans_send_next_cmd(struct qtnf_bus *bus);
+int qtnf_trans_handle_rx_ctl_packet(struct qtnf_bus *bus, struct sk_buff *skb);
+int qtnf_trans_send_cmd_with_resp(struct qtnf_bus *bus,
+				  struct sk_buff *cmd_skb,
+				  struct sk_buff **response_skb);
+
+#endif /* _QTN_FMAC_TRANS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.c b/drivers/net/wireless/quantenna/qtnfmac/util.c
new file mode 100644
index 0000000..ed38e87
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.c
@@ -0,0 +1,114 @@
+/*
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
+ */
+
+#include "util.h"
+
+void qtnf_sta_list_init(struct qtnf_sta_list *list)
+{
+	if (unlikely(!list))
+		return;
+
+	INIT_LIST_HEAD(&list->head);
+	atomic_set(&list->size, 0);
+}
+
+struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
+					   const u8 *mac)
+{
+	struct qtnf_sta_node *node;
+
+	if (unlikely(!mac))
+		return NULL;
+
+	list_for_each_entry(node, &list->head, list) {
+		if (ether_addr_equal(node->mac_addr, mac))
+			return node;
+	}
+
+	return NULL;
+}
+
+struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
+						 size_t index)
+{
+	struct qtnf_sta_node *node;
+
+	if (qtnf_sta_list_size(list) <= index)
+		return NULL;
+
+	list_for_each_entry(node, &list->head, list) {
+		if (index-- == 0)
+			return node;
+	}
+
+	return NULL;
+}
+
+struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
+					const u8 *mac)
+{
+	struct qtnf_sta_node *node;
+
+	if (unlikely(!mac))
+		return NULL;
+
+	node = qtnf_sta_list_lookup(list, mac);
+
+	if (node)
+		goto done;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (unlikely(!node))
+		goto done;
+
+	ether_addr_copy(node->mac_addr, mac);
+	list_add_tail(&node->list, &list->head);
+	atomic_inc(&list->size);
+
+done:
+	return node;
+}
+
+bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac)
+{
+	struct qtnf_sta_node *node;
+	bool ret = false;
+
+	node = qtnf_sta_list_lookup(list, mac);
+
+	if (node) {
+		list_del(&node->list);
+		atomic_dec(&list->size);
+		kfree(node);
+		ret = true;
+	}
+
+	return ret;
+}
+
+void qtnf_sta_list_free(struct qtnf_sta_list *list)
+{
+	struct qtnf_sta_node *node, *tmp;
+
+	atomic_set(&list->size, 0);
+
+	list_for_each_entry_safe(node, tmp, &list->head, list) {
+		list_del(&node->list);
+		kfree(node);
+	}
+
+	INIT_LIST_HEAD(&list->head);
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.h b/drivers/net/wireless/quantenna/qtnfmac/util.h
new file mode 100644
index 0000000..0359eae
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (c) 2015 Quantenna Communications
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
+void qtnf_sta_list_init(struct qtnf_sta_list *list);
+
+struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
+					   const u8 *mac);
+struct qtnf_sta_node *qtnf_sta_list_lookup_index(struct qtnf_sta_list *list,
+						 size_t index);
+struct qtnf_sta_node *qtnf_sta_list_add(struct qtnf_sta_list *list,
+					const u8 *mac);
+bool qtnf_sta_list_del(struct qtnf_sta_list *list, const u8 *mac);
+
+void qtnf_sta_list_free(struct qtnf_sta_list *list);
+
+static inline size_t qtnf_sta_list_size(const struct qtnf_sta_list *list)
+{
+	return atomic_read(&list->size);
+}
+
+static inline bool qtnf_sta_list_empty(const struct qtnf_sta_list *list)
+{
+	return list_empty(&list->head);
+}
+
+#endif /* QTNFMAC_UTIL_H */
-- 
2.9.3
