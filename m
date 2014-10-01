Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63358 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJAMFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 08:05:55 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 2/2] wil6210: atomic I/O for the card memory
Date: Wed, 1 Oct 2014 15:05:25 +0300
Message-ID: <1412165125-30435-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141001_140559_261815_0AA42CDA)
In-Reply-To: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce netdev IOCTLs, to be used by the debug tools.

Allows to read/write single dword value or
memory block, aligned to dword
Different address modes supported:
- BAR offset
- Firmware "linker" address
- target's AHB bus

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 MAINTAINERS                                |   1 +
 drivers/net/wireless/ath/wil6210/Makefile  |   1 +
 drivers/net/wireless/ath/wil6210/ioctl.c   | 173 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c  |  12 ++
 drivers/net/wireless/ath/wil6210/wil6210.h |   2 +
 include/uapi/linux/wil6210_uapi.h          |  88 +++++++++++++++
 6 files changed, 277 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/ioctl.c
 create mode 100644 include/uapi/linux/wil6210_uapi.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 133d2fd..5f2b1dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1617,6 +1617,7 @@ L:	wil6210@qca.qualcomm.com
 S:	Supported
 W:	http://wireless.kernel.org/en/users/Drivers/wil6210
 F:	drivers/net/wireless/ath/wil6210/
+F:	include/uapi/linux/wil6210_uapi.h
 
 CARL9170 LINUX COMMUNITY WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@googlemail.com>
diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index 05f29a6..8ad4b5f 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -10,6 +10,7 @@ wil6210-y += interrupt.o
 wil6210-y += txrx.o
 wil6210-y += debug.o
 wil6210-y += rx_reorder.o
+wil6210-y += ioctl.o
 wil6210-y += fw.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 wil6210-y += wil_platform.o
diff --git a/drivers/net/wireless/ath/wil6210/ioctl.c b/drivers/net/wireless/ath/wil6210/ioctl.c
new file mode 100644
index 0000000..e9c0673
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/ioctl.c
@@ -0,0 +1,173 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/uaccess.h>
+
+#include "wil6210.h"
+#include <uapi/linux/wil6210_uapi.h>
+
+#define wil_hex_dump_ioctl(prefix_str, buf, len) \
+	print_hex_dump_debug("DBG[IOC ]" prefix_str, \
+			     DUMP_PREFIX_OFFSET, 16, 1, buf, len, true)
+#define wil_dbg_ioctl(wil, fmt, arg...) wil_dbg(wil, "DBG[IOC ]" fmt, ##arg)
+
+static void __iomem *wil_ioc_addr(struct wil6210_priv *wil, uint32_t addr,
+				  uint32_t size, enum wil_memio_op op)
+{
+	void __iomem *a;
+	u32 off;
+
+	switch (op & wil_mmio_addr_mask) {
+	case wil_mmio_addr_linker:
+		a = wmi_buffer(wil, cpu_to_le32(addr));
+		break;
+	case wil_mmio_addr_ahb:
+		a = wmi_addr(wil, addr);
+		break;
+	case wil_mmio_addr_bar:
+		a = wmi_addr(wil, addr + WIL6210_FW_HOST_OFF);
+		break;
+	default:
+		wil_err(wil, "Unsupported address mode, op = 0x%08x\n", op);
+		return NULL;
+	}
+
+	off = a - wil->csr;
+	if (size >= WIL6210_MEM_SIZE - off) {
+		wil_err(wil, "Requested block does not fit into memory: "
+			"off = 0x%08x size = 0x%08x\n", off, size);
+		return NULL;
+	}
+
+	return a;
+}
+
+static int wil_ioc_memio_dword(struct wil6210_priv *wil, void __user *data)
+{
+	struct wil_memio io;
+	void __iomem *a;
+	bool need_copy = false;
+
+	if (copy_from_user(&io, data, sizeof(io)))
+		return -EFAULT;
+
+	wil_dbg_ioctl(wil, "IO: addr = 0x%08x val = 0x%08x op = 0x%08x\n",
+		      io.addr, io.val, io.op);
+
+	a = wil_ioc_addr(wil, io.addr, sizeof(u32), io.op);
+	if (!a) {
+		wil_err(wil, "invalid address 0x%08x, op = 0x%08x\n", io.addr,
+			io.op);
+		return -EINVAL;
+	}
+	/* operation */
+	switch (io.op & wil_mmio_op_mask) {
+	case wil_mmio_read:
+		io.val = ioread32(a);
+		need_copy = true;
+		break;
+	case wil_mmio_write:
+		iowrite32(io.val, a);
+		wmb(); /* make sure write propagated to HW */
+		break;
+	default:
+		wil_err(wil, "Unsupported operation, op = 0x%08x\n", io.op);
+		return -EINVAL;
+	}
+
+	if (need_copy) {
+		wil_dbg_ioctl(wil, "IO done: addr = 0x%08x"
+			      " val = 0x%08x op = 0x%08x\n",
+			      io.addr, io.val, io.op);
+		if (copy_to_user(data, &io, sizeof(io)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int wil_ioc_memio_block(struct wil6210_priv *wil, void __user *data)
+{
+	struct wil_memio_block io;
+	void *block;
+	void __iomem *a;
+	int rc = 0;
+
+	if (copy_from_user(&io, data, sizeof(io)))
+		return -EFAULT;
+
+	wil_dbg_ioctl(wil, "IO: addr = 0x%08x size = 0x%08x op = 0x%08x\n",
+		      io.addr, io.size, io.op);
+
+	/* size */
+	if (io.size % 4) {
+		wil_err(wil, "size is not multiple of 4:  0x%08x\n", io.size);
+		return -EINVAL;
+	}
+
+	a = wil_ioc_addr(wil, io.addr, io.size, io.op);
+	if (!a) {
+		wil_err(wil, "invalid address 0x%08x, op = 0x%08x\n", io.addr,
+			io.op);
+		return -EINVAL;
+	}
+
+	block = kmalloc(io.size, GFP_USER);
+	if (!block)
+		return -ENOMEM;
+
+	/* operation */
+	switch (io.op & wil_mmio_op_mask) {
+	case wil_mmio_read:
+		wil_memcpy_fromio_32(block, a, io.size);
+		wil_hex_dump_ioctl("Read  ", block, io.size);
+		if (copy_to_user(io.block, block, io.size)) {
+			rc = -EFAULT;
+			goto out_free;
+		}
+		break;
+	case wil_mmio_write:
+		if (copy_from_user(block, io.block, io.size)) {
+			rc = -EFAULT;
+			goto out_free;
+		}
+		wil_memcpy_toio_32(a, block, io.size);
+		wmb(); /* make sure write propagated to HW */
+		wil_hex_dump_ioctl("Write ", block, io.size);
+		break;
+	default:
+		wil_err(wil, "Unsupported operation, op = 0x%08x\n", io.op);
+		rc = -EINVAL;
+		break;
+	}
+
+out_free:
+	kfree(block);
+	return rc;
+}
+
+int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd)
+{
+	switch (cmd) {
+	case WIL_IOCTL_MEMIO:
+		return wil_ioc_memio_dword(wil, data);
+	case WIL_IOCTL_MEMIO_BLOCK:
+		return wil_ioc_memio_block(wil, data);
+	default:
+		wil_dbg_ioctl(wil, "Unsupported IOCTL 0x%04x\n", cmd);
+		return -ENOIOCTLCMD;
+	}
+}
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index c3f0ddf..2399651 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -52,6 +52,17 @@ static int wil_change_mtu(struct net_device *ndev, int new_mtu)
 	return 0;
 }
 
+static int wil_do_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	int ret = wil_ioctl(wil, ifr->ifr_data, cmd);
+
+	wil_dbg_misc(wil, "ioctl(0x%04x) -> %d\n", cmd, ret);
+
+	return ret;
+}
+
 static const struct net_device_ops wil_netdev_ops = {
 	.ndo_open		= wil_open,
 	.ndo_stop		= wil_stop,
@@ -59,6 +70,7 @@ static const struct net_device_ops wil_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= wil_change_mtu,
+	.ndo_do_ioctl		= wil_do_ioctl,
 };
 
 static int wil6210_netdev_poll_rx(struct napi_struct *napi, int budget)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 2991609..61cceca 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -595,5 +595,7 @@ void wil6210_unmask_irq_rx(struct wil6210_priv *wil);
 
 int wil_iftype_nl2wmi(enum nl80211_iftype type);
 
+int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd);
 int wil_request_firmware(struct wil6210_priv *wil, const char *name);
+
 #endif /* __WIL6210_H__ */
diff --git a/include/uapi/linux/wil6210_uapi.h b/include/uapi/linux/wil6210_uapi.h
new file mode 100644
index 0000000..d9ec1d0
--- /dev/null
+++ b/include/uapi/linux/wil6210_uapi.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __WIL6210_UAPI_H__
+#define __WIL6210_UAPI_H__
+
+#if !defined(__KERNEL__)
+#define __user
+#endif
+
+#include <linux/sockios.h>
+
+/* Numbers SIOCDEVPRIVATE and SIOCDEVPRIVATE + 1
+ * are used by Android devices to implement PNO (preferred network offload).
+ * Albeit it is temporary solution, use different numbers to avoid conflicts
+ */
+
+/**
+ * Perform 32-bit I/O operation to the card memory
+ *
+ * User code should arrange data in memory like this:
+ *
+ *	struct wil_memio io;
+ *	struct ifreq ifr = {
+ *		.ifr_data = &io,
+ *	};
+ */
+#define WIL_IOCTL_MEMIO (SIOCDEVPRIVATE + 2)
+
+/**
+ * Perform block I/O operation to the card memory
+ *
+ * User code should arrange data in memory like this:
+ *
+ *	void *buf;
+ *	struct wil_memio_block io = {
+ *		.block = buf,
+ *	};
+ *	struct ifreq ifr = {
+ *		.ifr_data = &io,
+ *	};
+ */
+#define WIL_IOCTL_MEMIO_BLOCK (SIOCDEVPRIVATE + 3)
+
+/**
+ * operation to perform
+ *
+ * @wil_mmio_op_mask - bits defining operation,
+ * @wil_mmio_addr_mask - bits defining addressing mode
+ */
+enum wil_memio_op {
+	wil_mmio_read = 0,
+	wil_mmio_write = 1,
+	wil_mmio_op_mask = 0xff,
+	wil_mmio_addr_linker = 0 << 8,
+	wil_mmio_addr_ahb = 1 << 8,
+	wil_mmio_addr_bar = 2 << 8,
+	wil_mmio_addr_mask = 0xff00,
+};
+
+struct wil_memio {
+	uint32_t op; /* enum wil_memio_op */
+	uint32_t addr; /* should be 32-bit aligned */
+	uint32_t val;
+};
+
+struct wil_memio_block {
+	uint32_t op; /* enum wil_memio_op */
+	uint32_t addr; /* should be 32-bit aligned */
+	uint32_t size; /* should be multiple of 4 */
+	void __user *block; /* block address */
+};
+
+#endif /* __WIL6210_UAPI_H__ */
+
-- 
1.9.1

