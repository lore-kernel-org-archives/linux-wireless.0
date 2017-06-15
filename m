Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45335 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbdFOG05 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 02:26:57 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v3 3/3] wil6210: remove ioctl interface
Date: Thu, 15 Jun 2017 09:26:48 +0300
Message-Id: <1497508008-9536-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170615_082701_797914_F6EA74E1)
In-Reply-To: <1497508008-9536-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1497508008-9536-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless drivers should not be using ioctl interface,
hence remove this interface for wil6210 driver.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile  |   1 -
 drivers/net/wireless/ath/wil6210/ioctl.c   | 180 -----------------------------
 drivers/net/wireless/ath/wil6210/netdev.c  |   8 --
 drivers/net/wireless/ath/wil6210/wil6210.h |   1 -
 include/uapi/linux/wil6210_uapi.h          |  87 --------------
 5 files changed, 277 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/wil6210/ioctl.c
 delete mode 100644 include/uapi/linux/wil6210_uapi.h

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index 89bf2f9..4ae21da 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -10,7 +10,6 @@ wil6210-y += interrupt.o
 wil6210-y += txrx.o
 wil6210-y += debug.o
 wil6210-y += rx_reorder.o
-wil6210-y += ioctl.o
 wil6210-y += fw.o
 wil6210-y += pm.o
 wil6210-y += pmc.o
diff --git a/drivers/net/wireless/ath/wil6210/ioctl.c b/drivers/net/wireless/ath/wil6210/ioctl.c
deleted file mode 100644
index 1c49ad8..0000000
--- a/drivers/net/wireless/ath/wil6210/ioctl.c
+++ /dev/null
@@ -1,180 +0,0 @@
-/*
- * Copyright (c) 2014,2017 Qualcomm Atheros, Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/uaccess.h>
-
-#include "wil6210.h"
-#include <uapi/linux/wil6210_uapi.h>
-
-#define wil_hex_dump_ioctl(prefix_str, buf, len) \
-	print_hex_dump_debug("DBG[IOC ]" prefix_str, \
-			     DUMP_PREFIX_OFFSET, 16, 1, buf, len, true)
-#define wil_dbg_ioctl(wil, fmt, arg...) wil_dbg(wil, "DBG[IOC ]" fmt, ##arg)
-
-static void __iomem *wil_ioc_addr(struct wil6210_priv *wil, uint32_t addr,
-				  uint32_t size, enum wil_memio_op op)
-{
-	void __iomem *a;
-	u32 off;
-
-	switch (op & wil_mmio_addr_mask) {
-	case wil_mmio_addr_linker:
-		a = wmi_buffer(wil, cpu_to_le32(addr));
-		break;
-	case wil_mmio_addr_ahb:
-		a = wmi_addr(wil, addr);
-		break;
-	case wil_mmio_addr_bar:
-		a = wmi_addr(wil, addr + WIL6210_FW_HOST_OFF);
-		break;
-	default:
-		wil_err(wil, "Unsupported address mode, op = 0x%08x\n", op);
-		return NULL;
-	}
-
-	off = a - wil->csr;
-	if (size >= wil->bar_size - off) {
-		wil_err(wil, "Requested block does not fit into memory: "
-			"off = 0x%08x size = 0x%08x\n", off, size);
-		return NULL;
-	}
-
-	return a;
-}
-
-static int wil_ioc_memio_dword(struct wil6210_priv *wil, void __user *data)
-{
-	struct wil_memio io;
-	void __iomem *a;
-	bool need_copy = false;
-
-	if (copy_from_user(&io, data, sizeof(io)))
-		return -EFAULT;
-
-	wil_dbg_ioctl(wil, "IO: addr = 0x%08x val = 0x%08x op = 0x%08x\n",
-		      io.addr, io.val, io.op);
-
-	a = wil_ioc_addr(wil, io.addr, sizeof(u32), io.op);
-	if (!a) {
-		wil_err(wil, "invalid address 0x%08x, op = 0x%08x\n", io.addr,
-			io.op);
-		return -EINVAL;
-	}
-	/* operation */
-	switch (io.op & wil_mmio_op_mask) {
-	case wil_mmio_read:
-		io.val = readl(a);
-		need_copy = true;
-		break;
-	case wil_mmio_write:
-		writel(io.val, a);
-		wmb(); /* make sure write propagated to HW */
-		break;
-	default:
-		wil_err(wil, "Unsupported operation, op = 0x%08x\n", io.op);
-		return -EINVAL;
-	}
-
-	if (need_copy) {
-		wil_dbg_ioctl(wil, "IO done: addr = 0x%08x"
-			      " val = 0x%08x op = 0x%08x\n",
-			      io.addr, io.val, io.op);
-		if (copy_to_user(data, &io, sizeof(io)))
-			return -EFAULT;
-	}
-
-	return 0;
-}
-
-static int wil_ioc_memio_block(struct wil6210_priv *wil, void __user *data)
-{
-	struct wil_memio_block io;
-	void *block;
-	void __iomem *a;
-	int rc = 0;
-
-	if (copy_from_user(&io, data, sizeof(io)))
-		return -EFAULT;
-
-	wil_dbg_ioctl(wil, "IO: addr = 0x%08x size = 0x%08x op = 0x%08x\n",
-		      io.addr, io.size, io.op);
-
-	/* size */
-	if (io.size % 4) {
-		wil_err(wil, "size is not multiple of 4:  0x%08x\n", io.size);
-		return -EINVAL;
-	}
-
-	a = wil_ioc_addr(wil, io.addr, io.size, io.op);
-	if (!a) {
-		wil_err(wil, "invalid address 0x%08x, op = 0x%08x\n", io.addr,
-			io.op);
-		return -EINVAL;
-	}
-
-	block = kmalloc(io.size, GFP_USER);
-	if (!block)
-		return -ENOMEM;
-
-	/* operation */
-	switch (io.op & wil_mmio_op_mask) {
-	case wil_mmio_read:
-		wil_memcpy_fromio_32(block, a, io.size);
-		wil_hex_dump_ioctl("Read  ", block, io.size);
-		if (copy_to_user(io.block, block, io.size)) {
-			rc = -EFAULT;
-			goto out_free;
-		}
-		break;
-	case wil_mmio_write:
-		if (copy_from_user(block, io.block, io.size)) {
-			rc = -EFAULT;
-			goto out_free;
-		}
-		wil_memcpy_toio_32(a, block, io.size);
-		wmb(); /* make sure write propagated to HW */
-		wil_hex_dump_ioctl("Write ", block, io.size);
-		break;
-	default:
-		wil_err(wil, "Unsupported operation, op = 0x%08x\n", io.op);
-		rc = -EINVAL;
-		break;
-	}
-
-out_free:
-	kfree(block);
-	return rc;
-}
-
-int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd)
-{
-	int ret;
-
-	switch (cmd) {
-	case WIL_IOCTL_MEMIO:
-		ret = wil_ioc_memio_dword(wil, data);
-		break;
-	case WIL_IOCTL_MEMIO_BLOCK:
-		ret = wil_ioc_memio_block(wil, data);
-		break;
-	default:
-		wil_dbg_ioctl(wil, "Unsupported IOCTL 0x%04x\n", cmd);
-		return -ENOIOCTLCMD;
-	}
-
-	wil_dbg_ioctl(wil, "ioctl(0x%04x) -> %d\n", cmd, ret);
-	return ret;
-}
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 708facd..4a6ab2d 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -42,20 +42,12 @@ static int wil_stop(struct net_device *ndev)
 	return wil_down(wil);
 }
 
-static int wil_do_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
-{
-	struct wil6210_priv *wil = ndev_to_wil(ndev);
-
-	return wil_ioctl(wil, ifr->ifr_data, cmd);
-}
-
 static const struct net_device_ops wil_netdev_ops = {
 	.ndo_open		= wil_open,
 	.ndo_stop		= wil_stop,
 	.ndo_start_xmit		= wil_start_xmit,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= wil_do_ioctl,
 };
 
 static int wil6210_netdev_poll_rx(struct napi_struct *napi, int budget)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 35f0554..d085ccf 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -977,7 +977,6 @@ void wil_update_net_queues_bh(struct wil6210_priv *wil, struct vring *vring,
 
 int wil_iftype_nl2wmi(enum nl80211_iftype type);
 
-int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd);
 int wil_request_firmware(struct wil6210_priv *wil, const char *name,
 			 bool load);
 bool wil_fw_verify_file_exists(struct wil6210_priv *wil, const char *name);
diff --git a/include/uapi/linux/wil6210_uapi.h b/include/uapi/linux/wil6210_uapi.h
deleted file mode 100644
index 6a3cddd..0000000
--- a/include/uapi/linux/wil6210_uapi.h
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * Copyright (c) 2014 Qualcomm Atheros, Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef __WIL6210_UAPI_H__
-#define __WIL6210_UAPI_H__
-
-#if !defined(__KERNEL__)
-#define __user
-#endif
-
-#include <linux/sockios.h>
-
-/* Numbers SIOCDEVPRIVATE and SIOCDEVPRIVATE + 1
- * are used by Android devices to implement PNO (preferred network offload).
- * Albeit it is temporary solution, use different numbers to avoid conflicts
- */
-
-/**
- * Perform 32-bit I/O operation to the card memory
- *
- * User code should arrange data in memory like this:
- *
- *	struct wil_memio io;
- *	struct ifreq ifr = {
- *		.ifr_data = &io,
- *	};
- */
-#define WIL_IOCTL_MEMIO (SIOCDEVPRIVATE + 2)
-
-/**
- * Perform block I/O operation to the card memory
- *
- * User code should arrange data in memory like this:
- *
- *	void *buf;
- *	struct wil_memio_block io = {
- *		.block = buf,
- *	};
- *	struct ifreq ifr = {
- *		.ifr_data = &io,
- *	};
- */
-#define WIL_IOCTL_MEMIO_BLOCK (SIOCDEVPRIVATE + 3)
-
-/**
- * operation to perform
- *
- * @wil_mmio_op_mask - bits defining operation,
- * @wil_mmio_addr_mask - bits defining addressing mode
- */
-enum wil_memio_op {
-	wil_mmio_read = 0,
-	wil_mmio_write = 1,
-	wil_mmio_op_mask = 0xff,
-	wil_mmio_addr_linker = 0 << 8,
-	wil_mmio_addr_ahb = 1 << 8,
-	wil_mmio_addr_bar = 2 << 8,
-	wil_mmio_addr_mask = 0xff00,
-};
-
-struct wil_memio {
-	uint32_t op; /* enum wil_memio_op */
-	uint32_t addr; /* should be 32-bit aligned */
-	uint32_t val;
-};
-
-struct wil_memio_block {
-	uint32_t op; /* enum wil_memio_op */
-	uint32_t addr; /* should be 32-bit aligned */
-	uint32_t size; /* should be multiple of 4 */
-	void __user *block; /* block address */
-};
-
-#endif /* __WIL6210_UAPI_H__ */
-- 
1.9.1
