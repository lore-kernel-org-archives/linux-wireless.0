Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28906 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbdFOFup (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 01:50:45 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 3/3] wil6210: remove ioctl interface
Date: Thu, 15 Jun 2017 08:50:34 +0300
Message-Id: <1497505834-9704-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170615_075049_445504_2586A14D)
In-Reply-To: <1497505834-9704-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1497505834-9704-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless drivers should not be using ioctl interface,
hence remove this interface for wil6210 driver.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile |   1 -
 drivers/net/wireless/ath/wil6210/ioctl.c  | 180 ------------------------------
 drivers/net/wireless/ath/wil6210/netdev.c |   8 --
 3 files changed, 189 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/wil6210/ioctl.c

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
-- 
1.9.1
