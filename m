Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4690 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaIJNfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:08 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 01/22] wil6210: firmware download
Date: Wed, 10 Sep 2014 16:34:30 +0300
Message-ID: <1410356091-19219-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153520_510269_74E8707C)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware download implemented but is still experimental feature;
flag controlling it added, no_fw_load. It is true by default,
use no_fw_load=N to activate feature.

Reset flows also got some adjustment for the fw download to work

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile    |   1 +
 drivers/net/wireless/ath/wil6210/fw.c        |  45 +++
 drivers/net/wireless/ath/wil6210/fw.h        | 149 ++++++++
 drivers/net/wireless/ath/wil6210/fw_inc.c    | 495 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |   1 +
 drivers/net/wireless/ath/wil6210/main.c      |  93 +++--
 drivers/net/wireless/ath/wil6210/wil6210.h   |  12 +
 7 files changed, 764 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/fw.c
 create mode 100644 drivers/net/wireless/ath/wil6210/fw.h
 create mode 100644 drivers/net/wireless/ath/wil6210/fw_inc.c

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index c7a3465..dc788a1 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -10,6 +10,7 @@ wil6210-y += interrupt.o
 wil6210-y += txrx.o
 wil6210-y += debug.o
 wil6210-y += rx_reorder.o
+wil6210-y += fw.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 
 # for tracing framework to find trace.h
diff --git a/drivers/net/wireless/ath/wil6210/fw.c b/drivers/net/wireless/ath/wil6210/fw.c
new file mode 100644
index 0000000..8c6f3b0
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/fw.c
@@ -0,0 +1,45 @@
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
+#include <linux/firmware.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/crc32.h>
+#include "wil6210.h"
+#include "fw.h"
+
+MODULE_FIRMWARE(WIL_FW_NAME);
+
+/* target operations */
+/* register read */
+#define R(a) ioread32(wil->csr + HOSTADDR(a))
+/* register write. wmb() to make sure it is completed */
+#define W(a, v) do { iowrite32(v, wil->csr + HOSTADDR(a)); wmb(); } while (0)
+/* register set = read, OR, write */
+#define S(a, v) W(a, R(a) | v)
+/* register clear = read, AND with inverted, write */
+#define C(a, v) W(a, R(a) & ~v)
+
+static
+void wil_memset_toio_32(volatile void __iomem *dst, u32 val,
+			size_t count)
+{
+	volatile u32 __iomem *d = dst;
+
+	for (count += 4; count > 4; count -= 4)
+		__raw_writel(val, d++);
+}
+
+#include "fw_inc.c"
diff --git a/drivers/net/wireless/ath/wil6210/fw.h b/drivers/net/wireless/ath/wil6210/fw.h
new file mode 100644
index 0000000..7a2c6c1
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/fw.h
@@ -0,0 +1,149 @@
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
+#define WIL_FW_SIGNATURE (0x36323130) /* '0126' */
+#define WIL_FW_FMT_VERSION (1) /* format version driver supports */
+
+enum wil_fw_record_type {
+	wil_fw_type_comment = 1,
+	wil_fw_type_data = 2,
+	wil_fw_type_fill = 3,
+	wil_fw_type_action = 4,
+	wil_fw_type_verify = 5,
+	wil_fw_type_file_header = 6,
+	wil_fw_type_direct_write = 7,
+	wil_fw_type_gateway_data = 8,
+	wil_fw_type_gateway_data4 = 9,
+};
+
+struct wil_fw_record_head {
+	__le16 type; /* enum wil_fw_record_type */
+	__le16 flags; /* to be defined */
+	__le32 size; /* whole record, bytes after head */
+} __packed;
+
+/* data block. write starting from @addr
+ * data_size inferred from the @head.size. For this case,
+ * data_size = @head.size - offsetof(struct wil_fw_record_data, data)
+ */
+struct wil_fw_record_data { /* type == wil_fw_type_data */
+	__le32 addr;
+	__le32 data[0]; /* [data_size], see above */
+} __packed;
+
+/* fill with constant @value, @size bytes starting from @addr */
+struct wil_fw_record_fill { /* type == wil_fw_type_fill */
+	__le32 addr;
+	__le32 value;
+	__le32 size;
+} __packed;
+
+/* free-form comment
+ * for informational purpose, data_size is @head.size from record header
+ */
+struct wil_fw_record_comment { /* type == wil_fw_type_comment */
+	u8 data[0]; /* free-form data [data_size], see above */
+} __packed;
+
+/* perform action
+ * data_size = @head.size - offsetof(struct wil_fw_record_action, data)
+ */
+struct wil_fw_record_action { /* type == wil_fw_type_action */
+	__le32 action; /* action to perform: reset, wait for fw ready etc. */
+	__le32 data[0]; /* action specific, [data_size], see above */
+} __packed;
+
+/* data block for struct wil_fw_record_direct_write */
+struct wil_fw_data_dwrite {
+	__le32 addr;
+	__le32 value;
+	__le32 mask;
+} __packed;
+
+/* write @value to the @addr,
+ * preserve original bits accordingly to the @mask
+ * data_size is @head.size where @head is record header
+ */
+struct wil_fw_record_direct_write { /* type == wil_fw_type_direct_write */
+	struct wil_fw_data_dwrite data[0];
+} __packed;
+
+/* verify condition: [@addr] & @mask == @value
+ * if condition not met, firmware download fails
+ */
+struct wil_fw_record_verify { /* type == wil_fw_verify */
+	__le32 addr; /* read from this address */
+	__le32 value; /* reference value */
+	__le32 mask; /* mask for verification */
+} __packed;
+
+/* file header
+ * First record of every file
+ */
+struct wil_fw_record_file_header {
+	__le32 signature ; /* Wilocity signature */
+	__le32 reserved;
+	__le32 crc; /* crc32 of the following data  */
+	__le32 version; /* format version */
+	__le32 data_len; /* total data in file, including this record */
+	u8 comment[32]; /* short description */
+} __packed;
+
+/* 1-dword gateway */
+/* data block for the struct wil_fw_record_gateway_data */
+struct wil_fw_data_gw {
+	__le32 addr;
+	__le32 value;
+} __packed;
+
+/* gateway write block.
+ * write starting address and values from the data buffer
+ * through the gateway
+ * data_size inferred from the @head.size. For this case,
+ * data_size = @head.size - offsetof(struct wil_fw_record_gateway_data, data)
+ */
+struct wil_fw_record_gateway_data { /* type == wil_fw_type_gateway_data */
+	__le32 gateway_addr_addr;
+	__le32 gateway_value_addr;
+	__le32 gateway_cmd_addr;
+	__le32 gateway_ctrl_address;
+#define WIL_FW_GW_CTL_BUSY	BIT(29) /* gateway busy performing operation */
+#define WIL_FW_GW_CTL_RUN	BIT(30) /* start gateway operation */
+	__le32 command;
+	struct wil_fw_data_gw data[0]; /* total size [data_size], see above */
+} __packed;
+
+/* 4-dword gateway */
+/* data block for the struct wil_fw_record_gateway_data4 */
+struct wil_fw_data_gw4 {
+	__le32 addr;
+	__le32 value[4];
+} __packed;
+
+/* gateway write block.
+ * write starting address and values from the data buffer
+ * through the gateway
+ * data_size inferred from the @head.size. For this case,
+ * data_size = @head.size - offsetof(struct wil_fw_record_gateway_data4, data)
+ */
+struct wil_fw_record_gateway_data4 { /* type == wil_fw_type_gateway_data4 */
+	__le32 gateway_addr_addr;
+	__le32 gateway_value_addr[4];
+	__le32 gateway_cmd_addr;
+	__le32 gateway_ctrl_address; /* same logic as for 1-dword gw */
+	__le32 command;
+	struct wil_fw_data_gw4 data[0]; /* total size [data_size], see above */
+} __packed;
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
new file mode 100644
index 0000000..44cb71f
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -0,0 +1,495 @@
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
+/* Algorithmic part of the firmware download.
+ * To be included in the container file providing framework
+ */
+
+#define wil_err_fw(wil, fmt, arg...) wil_err(wil, "ERR[ FW ]" fmt, ##arg)
+#define wil_dbg_fw(wil, fmt, arg...) wil_dbg(wil, "DBG[ FW ]" fmt, ##arg)
+#define wil_hex_dump_fw(prefix_str, prefix_type, rowsize,		\
+			groupsize, buf, len, ascii)			\
+			print_hex_dump_debug("DBG[ FW ]" prefix_str,	\
+					     prefix_type, rowsize,	\
+					     groupsize, buf, len, ascii)
+
+#define FW_ADDR_CHECK(ioaddr, val, msg) do { \
+		ioaddr = wmi_buffer(wil, val); \
+		if (!ioaddr) { \
+			wil_err_fw(wil, "bad " msg ": 0x%08x\n", \
+				   le32_to_cpu(val)); \
+			return -EINVAL; \
+		} \
+	} while (0)
+
+/**
+ * wil_fw_verify - verify firmware file validity
+ *
+ * perform various checks for the firmware file header.
+ * records are not validated.
+ *
+ * Return file size or negative error
+ */
+static int wil_fw_verify(struct wil6210_priv *wil, const u8 *data, size_t size)
+{
+	const struct wil_fw_record_head *hdr = (const void *)data;
+	struct wil_fw_record_file_header fh;
+	const struct wil_fw_record_file_header *fh_;
+	u32 crc;
+	u32 dlen;
+
+	if (size % 4) {
+		wil_err_fw(wil, "image size not aligned: %zu\n", size);
+		return -EINVAL;
+	}
+	/* have enough data for the file header? */
+	if (size < sizeof(*hdr) + sizeof(fh)) {
+		wil_err_fw(wil, "file too short: %zu bytes\n", size);
+		return -EINVAL;
+	}
+
+	/* start with the file header? */
+	if (le16_to_cpu(hdr->type) != wil_fw_type_file_header) {
+		wil_err_fw(wil, "no file header\n");
+		return -EINVAL;
+	}
+
+	/* data_len */
+	fh_ = (struct wil_fw_record_file_header *)&hdr[1];
+	dlen = le32_to_cpu(fh_->data_len);
+	if (dlen % 4) {
+		wil_err_fw(wil, "data length not aligned: %lu\n", (ulong)dlen);
+		return -EINVAL;
+	}
+	if (size < dlen) {
+		wil_err_fw(wil, "file truncated at %zu/%lu\n",
+			   size, (ulong)dlen);
+		return -EINVAL;
+	}
+	if (dlen < sizeof(*hdr) + sizeof(fh)) {
+		wil_err_fw(wil, "data length too short: %lu\n", (ulong)dlen);
+		return -EINVAL;
+	}
+
+	/* signature */
+	if (le32_to_cpu(fh_->signature) != WIL_FW_SIGNATURE) {
+		wil_err_fw(wil, "bad header signature: 0x%08x\n",
+			   le32_to_cpu(fh_->signature));
+		return -EINVAL;
+	}
+
+	/* version */
+	if (le32_to_cpu(fh_->version) > WIL_FW_FMT_VERSION) {
+		wil_err_fw(wil, "unsupported header version: %d\n",
+			   le32_to_cpu(fh_->version));
+		return -EINVAL;
+	}
+
+	/* checksum. ~crc32(~0, data, size) when fh.crc set to 0*/
+	fh = *fh_;
+	fh.crc = 0;
+
+	crc = crc32_le(~0, (unsigned char const *)hdr, sizeof(*hdr));
+	crc = crc32_le(crc, (unsigned char const *)&fh, sizeof(fh));
+	crc = crc32_le(crc, (unsigned char const *)&fh_[1],
+		       dlen - sizeof(*hdr) - sizeof(fh));
+	crc = ~crc;
+
+	if (crc != le32_to_cpu(fh_->crc)) {
+		wil_err_fw(wil, "checksum mismatch:"
+			   " calculated for %lu bytes 0x%08x != 0x%08x\n",
+			   (ulong)dlen, crc, le32_to_cpu(fh_->crc));
+		return -EINVAL;
+	}
+
+	return (int)dlen;
+}
+
+static int fw_handle_comment(struct wil6210_priv *wil, const void *data,
+			     size_t size)
+{
+	wil_hex_dump_fw("", DUMP_PREFIX_OFFSET, 16, 1, data, size, true);
+
+	return 0;
+}
+
+static int fw_handle_data(struct wil6210_priv *wil, const void *data,
+			  size_t size)
+{
+	const struct wil_fw_record_data *d = data;
+	void __iomem *dst;
+	size_t s = size - sizeof(*d);
+
+	if (size < sizeof(*d) + sizeof(u32)) {
+		wil_err_fw(wil, "data record too short: %zu\n", size);
+		return -EINVAL;
+	}
+
+	FW_ADDR_CHECK(dst, d->addr, "address");
+	wil_dbg_fw(wil, "write [0x%08x] <== %zu bytes\n", le32_to_cpu(d->addr),
+		   s);
+	wil_memcpy_toio_32(dst, d->data, s);
+	wmb(); /* finish before processing next record */
+
+	return 0;
+}
+
+static int fw_handle_fill(struct wil6210_priv *wil, const void *data,
+			  size_t size)
+{
+	const struct wil_fw_record_fill *d = data;
+	void __iomem *dst;
+	u32 v;
+	size_t s = (size_t)le32_to_cpu(d->size);
+
+	if (size != sizeof(*d)) {
+		wil_err_fw(wil, "bad size for fill record: %zu\n", size);
+		return -EINVAL;
+	}
+
+	if (s < sizeof(u32)) {
+		wil_err_fw(wil, "fill size too short: %zu\n", s);
+		return -EINVAL;
+	}
+
+	if (s % sizeof(u32)) {
+		wil_err_fw(wil, "fill size not aligned: %zu\n", s);
+		return -EINVAL;
+	}
+
+	FW_ADDR_CHECK(dst, d->addr, "address");
+
+	v = le32_to_cpu(d->value);
+	wil_dbg_fw(wil, "fill [0x%08x] <== 0x%08x, %zu bytes\n",
+		   le32_to_cpu(d->addr), v, s);
+	wil_memset_toio_32(dst, v, s);
+	wmb(); /* finish before processing next record */
+
+	return 0;
+}
+
+static int fw_handle_file_header(struct wil6210_priv *wil, const void *data,
+				 size_t size)
+{
+	const struct wil_fw_record_file_header *d = data;
+
+	if (size != sizeof(*d)) {
+		wil_err_fw(wil, "file header length incorrect: %zu\n", size);
+		return -EINVAL;
+	}
+
+	wil_dbg_fw(wil, "new file, ver. %d, %i bytes\n",
+		   d->version, d->data_len);
+	wil_hex_dump_fw("", DUMP_PREFIX_OFFSET, 16, 1, d->comment,
+			sizeof(d->comment), true);
+
+	return 0;
+}
+
+static int fw_handle_direct_write(struct wil6210_priv *wil, const void *data,
+				  size_t size)
+{
+	const struct wil_fw_record_direct_write *d = data;
+	const struct wil_fw_data_dwrite *block = d->data;
+	int n, i;
+
+	if (size % sizeof(*block)) {
+		wil_err_fw(wil, "record size not aligned on %zu: %zu\n",
+			   sizeof(*block), size);
+		return -EINVAL;
+	}
+	n = size / sizeof(*block);
+
+	for (i = 0; i < n; i++) {
+		void __iomem *dst;
+		u32 m = le32_to_cpu(block[i].mask);
+		u32 v = le32_to_cpu(block[i].value);
+		u32 x, y;
+
+		FW_ADDR_CHECK(dst, block[i].addr, "address");
+
+		x = ioread32(dst);
+		y = (x & m) | (v & ~m);
+		wil_dbg_fw(wil, "write [0x%08x] <== 0x%08x "
+			   "(old 0x%08x val 0x%08x mask 0x%08x)\n",
+			   le32_to_cpu(block[i].addr), y, x, v, m);
+		iowrite32(y, dst);
+		wmb(); /* finish before processing next record */
+	}
+
+	return 0;
+}
+
+static int gw_write(struct wil6210_priv *wil, void __iomem *gwa_addr,
+		    void __iomem *gwa_cmd, void __iomem *gwa_ctl, u32 gw_cmd,
+		    u32 a)
+{
+	unsigned delay = 0;
+
+	iowrite32(a, gwa_addr);
+	iowrite32(gw_cmd, gwa_cmd);
+	wmb(); /* finish before activate gw */
+
+	iowrite32(WIL_FW_GW_CTL_RUN, gwa_ctl); /* activate gw */
+	do {
+		udelay(1); /* typical time is few usec */
+		if (delay++ > 100) {
+			wil_err_fw(wil, "gw timeout\n");
+			return -EINVAL;
+		}
+	} while (ioread32(gwa_ctl) & WIL_FW_GW_CTL_BUSY); /* gw done? */
+
+	return 0;
+}
+
+static int fw_handle_gateway_data(struct wil6210_priv *wil, const void *data,
+				  size_t size)
+{
+	const struct wil_fw_record_gateway_data *d = data;
+	const struct wil_fw_data_gw *block = d->data;
+	void __iomem *gwa_addr;
+	void __iomem *gwa_val;
+	void __iomem *gwa_cmd;
+	void __iomem *gwa_ctl;
+	u32 gw_cmd;
+	int n, i;
+
+	if (size < sizeof(*d) + sizeof(*block)) {
+		wil_err_fw(wil, "gateway record too short: %zu\n", size);
+		return -EINVAL;
+	}
+
+	if ((size - sizeof(*d)) % sizeof(*block)) {
+		wil_err_fw(wil, "gateway record data size"
+			   " not aligned on %zu: %zu\n",
+			   sizeof(*block), size - sizeof(*d));
+		return -EINVAL;
+	}
+	n = (size - sizeof(*d)) / sizeof(*block);
+
+	gw_cmd = le32_to_cpu(d->command);
+
+	wil_dbg_fw(wil, "gw write record [%3d] blocks, cmd 0x%08x\n",
+		   n, gw_cmd);
+
+	FW_ADDR_CHECK(gwa_addr, d->gateway_addr_addr, "gateway_addr_addr");
+	FW_ADDR_CHECK(gwa_val, d->gateway_value_addr, "gateway_value_addr");
+	FW_ADDR_CHECK(gwa_cmd, d->gateway_cmd_addr, "gateway_cmd_addr");
+	FW_ADDR_CHECK(gwa_ctl, d->gateway_ctrl_address, "gateway_ctrl_address");
+
+	wil_dbg_fw(wil, "gw addresses: addr 0x%08x val 0x%08x"
+		   " cmd 0x%08x ctl 0x%08x\n",
+		   le32_to_cpu(d->gateway_addr_addr),
+		   le32_to_cpu(d->gateway_value_addr),
+		   le32_to_cpu(d->gateway_cmd_addr),
+		   le32_to_cpu(d->gateway_ctrl_address));
+
+	for (i = 0; i < n; i++) {
+		int rc;
+		u32 a = le32_to_cpu(block[i].addr);
+		u32 v = le32_to_cpu(block[i].value);
+
+		wil_dbg_fw(wil, "  gw write[%3d] [0x%08x] <== 0x%08x\n",
+			   i, a, v);
+
+		iowrite32(v, gwa_val);
+		rc = gw_write(wil, gwa_addr, gwa_cmd, gwa_ctl, gw_cmd, a);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int fw_handle_gateway_data4(struct wil6210_priv *wil, const void *data,
+				   size_t size)
+{
+	const struct wil_fw_record_gateway_data4 *d = data;
+	const struct wil_fw_data_gw4 *block = d->data;
+	void __iomem *gwa_addr;
+	void __iomem *gwa_val[ARRAY_SIZE(block->value)];
+	void __iomem *gwa_cmd;
+	void __iomem *gwa_ctl;
+	u32 gw_cmd;
+	int n, i, k;
+
+	if (size < sizeof(*d) + sizeof(*block)) {
+		wil_err_fw(wil, "gateway4 record too short: %zu\n", size);
+		return -EINVAL;
+	}
+
+	if ((size - sizeof(*d)) % sizeof(*block)) {
+		wil_err_fw(wil, "gateway4 record data size"
+			   " not aligned on %zu: %zu\n",
+			   sizeof(*block), size - sizeof(*d));
+		return -EINVAL;
+	}
+	n = (size - sizeof(*d)) / sizeof(*block);
+
+	gw_cmd = le32_to_cpu(d->command);
+
+	wil_dbg_fw(wil, "gw4 write record [%3d] blocks, cmd 0x%08x\n",
+		   n, gw_cmd);
+
+	FW_ADDR_CHECK(gwa_addr, d->gateway_addr_addr, "gateway_addr_addr");
+	for (k = 0; k < ARRAY_SIZE(block->value); k++)
+		FW_ADDR_CHECK(gwa_val[k], d->gateway_value_addr[k],
+			      "gateway_value_addr");
+	FW_ADDR_CHECK(gwa_cmd, d->gateway_cmd_addr, "gateway_cmd_addr");
+	FW_ADDR_CHECK(gwa_ctl, d->gateway_ctrl_address, "gateway_ctrl_address");
+
+	wil_dbg_fw(wil, "gw4 addresses: addr 0x%08x cmd 0x%08x ctl 0x%08x\n",
+		   le32_to_cpu(d->gateway_addr_addr),
+		   le32_to_cpu(d->gateway_cmd_addr),
+		   le32_to_cpu(d->gateway_ctrl_address));
+	wil_hex_dump_fw("val addresses: ", DUMP_PREFIX_NONE, 16, 4,
+			d->gateway_value_addr, sizeof(d->gateway_value_addr),
+			false);
+
+	for (i = 0; i < n; i++) {
+		int rc;
+		u32 a = le32_to_cpu(block[i].addr);
+		u32 v[ARRAY_SIZE(block->value)];
+
+		for (k = 0; k < ARRAY_SIZE(block->value); k++)
+			v[k] = le32_to_cpu(block[i].value[k]);
+
+		wil_dbg_fw(wil, "  gw4 write[%3d] [0x%08x] <==\n", i, a);
+		wil_hex_dump_fw("    val ", DUMP_PREFIX_NONE, 16, 4, v,
+				sizeof(v), false);
+
+		for (k = 0; k < ARRAY_SIZE(block->value); k++)
+			iowrite32(v[k], gwa_val[k]);
+		rc = gw_write(wil, gwa_addr, gwa_cmd, gwa_ctl, gw_cmd, a);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static const struct {
+	int type;
+	int (*handler)(struct wil6210_priv *wil, const void *data, size_t size);
+} wil_fw_handlers[] = {
+	{wil_fw_type_comment, fw_handle_comment},
+	{wil_fw_type_data, fw_handle_data},
+	{wil_fw_type_fill, fw_handle_fill},
+	/* wil_fw_type_action */
+	/* wil_fw_type_verify */
+	{wil_fw_type_file_header, fw_handle_file_header},
+	{wil_fw_type_direct_write, fw_handle_direct_write},
+	{wil_fw_type_gateway_data, fw_handle_gateway_data},
+	{wil_fw_type_gateway_data4, fw_handle_gateway_data4},
+};
+
+static int wil_fw_handle_record(struct wil6210_priv *wil, int type,
+				const void *data, size_t size)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wil_fw_handlers); i++) {
+		if (wil_fw_handlers[i].type == type)
+			return wil_fw_handlers[i].handler(wil, data, size);
+	}
+
+	wil_err_fw(wil, "unknown record type: %d\n", type);
+	return -EINVAL;
+}
+
+/**
+ * wil_fw_load - load FW into device
+ *
+ * Load the FW and uCode code and data to the corresponding device
+ * memory regions
+ *
+ * Return error code
+ */
+static int wil_fw_load(struct wil6210_priv *wil, const void *data, size_t size)
+{
+	int rc = 0;
+	const struct wil_fw_record_head *hdr;
+	size_t s, hdr_sz;
+
+	for (hdr = data;; hdr = (const void *)hdr + s, size -= s) {
+		if (size < sizeof(*hdr))
+			break;
+		hdr_sz = le32_to_cpu(hdr->size);
+		s = sizeof(*hdr) + hdr_sz;
+		if (s > size)
+			break;
+		if (hdr_sz % 4) {
+			wil_err_fw(wil, "unaligned record size: %zu\n",
+				   hdr_sz);
+			return -EINVAL;
+		}
+		rc = wil_fw_handle_record(wil, le16_to_cpu(hdr->type),
+					  &hdr[1], hdr_sz);
+		if (rc)
+			return rc;
+	}
+	if (size) {
+		wil_err_fw(wil, "unprocessed bytes: %zu\n", size);
+		if (size >= sizeof(*hdr)) {
+			wil_err_fw(wil, "Stop at offset %ld"
+				   " record type %d [%zd bytes]\n",
+				   (const void *)hdr - data,
+				   le16_to_cpu(hdr->type), hdr_sz);
+		}
+		return -EINVAL;
+	}
+	/* Mark FW as loaded from host */
+	S(RGF_USER_USAGE_6, 1);
+
+	return rc;
+}
+
+/**
+ * wil_request_firmware - Request firmware and load to device
+ *
+ * Request firmware image from the file and load it to device
+ *
+ * Return error code
+ */
+int wil_request_firmware(struct wil6210_priv *wil, const char *name)
+{
+	int rc, rc1;
+	const struct firmware *fw;
+	size_t sz;
+	const void *d;
+
+	rc = request_firmware(&fw, name, wil_to_pcie_dev(wil));
+	if (rc) {
+		wil_err_fw(wil, "Failed to load firmware %s\n", name);
+		return rc;
+	}
+	wil_dbg_fw(wil, "Loading <%s>, %zu bytes\n", name, fw->size);
+
+	for (sz = fw->size, d = fw->data; sz; sz -= rc1, d += rc1) {
+		rc1 = wil_fw_verify(wil, d, sz);
+		if (rc1 < 0) {
+			rc = rc1;
+			goto out;
+		}
+		rc = wil_fw_load(wil, d, rc1);
+		if (rc < 0)
+			goto out;
+	}
+
+out:
+	release_firmware(fw);
+	return rc;
+}
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 98bfbb6..6411651 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -522,6 +522,7 @@ void wil6210_clear_irq(struct wil6210_priv *wil)
 		    offsetof(struct RGF_ICR, ICR));
 	wil_clear32(wil->csr + HOSTADDR(RGF_DMA_EP_MISC_ICR) +
 		    offsetof(struct RGF_ICR, ICR));
+	wmb(); /* make sure write completed */
 }
 
 int wil6210_init_irq(struct wil6210_priv *wil, int irq)
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index b69d90f..7dfbcfb 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -25,6 +25,10 @@ static bool no_fw_recovery;
 module_param(no_fw_recovery, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_fw_recovery, " disable FW error recovery");
 
+static bool no_fw_load = true;
+module_param(no_fw_load, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(no_fw_load, " do not download FW, use one in on-card flash.");
+
 #define RST_DELAY (20) /* msec, for loop in @wil_target_reset */
 #define RST_COUNT (1 + 1000/RST_DELAY) /* round up to be above 1 sec total */
 
@@ -312,6 +316,28 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	destroy_workqueue(wil->wmi_wq);
 }
 
+/* target operations */
+/* register read */
+#define R(a) ioread32(wil->csr + HOSTADDR(a))
+/* register write. wmb() to make sure it is completed */
+#define W(a, v) do { iowrite32(v, wil->csr + HOSTADDR(a)); wmb(); } while (0)
+/* register set = read, OR, write */
+#define S(a, v) W(a, R(a) | v)
+/* register clear = read, AND with inverted, write */
+#define C(a, v) W(a, R(a) & ~v)
+
+static inline void wil_halt_cpu(struct wil6210_priv *wil)
+{
+	W(RGF_USER_USER_CPU_0, BIT_USER_USER_CPU_MAN_RST);
+	W(RGF_USER_MAC_CPU_0,  BIT_USER_MAC_CPU_MAN_RST);
+}
+
+static inline void wil_release_cpu(struct wil6210_priv *wil)
+{
+	/* Start CPU */
+	W(RGF_USER_USER_CPU_0, 1);
+}
+
 static int wil_target_reset(struct wil6210_priv *wil)
 {
 	int delay = 0;
@@ -321,60 +347,41 @@ static int wil_target_reset(struct wil6210_priv *wil)
 
 	wil_dbg_misc(wil, "Resetting \"%s\"...\n", wil->board->name);
 
-	/* register read */
-#define R(a) ioread32(wil->csr + HOSTADDR(a))
-	/* register write */
-#define W(a, v) iowrite32(v, wil->csr + HOSTADDR(a))
-	/* register set = read, OR, write */
-#define S(a, v) W(a, R(a) | v)
-	/* register clear = read, AND with inverted, write */
-#define C(a, v) W(a, R(a) & ~v)
-
-	wmb(); /* If host reorder writes here -> race in NIC */
-	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
 	wil->hw_version = R(RGF_USER_FW_REV_ID);
 	rev_id = wil->hw_version & 0xff;
 
 	/* Clear MAC link up */
 	S(RGF_HP_CTRL, BIT(15));
-	/* hpal_perst_from_pad_src_n_mask */
-	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(6));
-	/* car_perst_rst_src_n_mask */
-	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(7));
-	wmb(); /* order is important here */
+	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_HPAL_PERST_FROM_PAD);
+	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_CAR_PERST_RST);
+
+	wil_halt_cpu(wil);
+	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_CAR_AHB_SW_SEL); /* 40 MHz */
 
 	if (is_sparrow) {
 		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x3ff81f);
-		wmb(); /* order is important here */
+		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1, 0xf);
 	}
 
-	W(RGF_USER_USER_CPU_0, BIT(1)); /* user_cpu_man_rst */
-	wmb(); /* If host reorder writes here -> race in NIC */
-	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
-	wmb(); /* order is important here */
-
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, is_sparrow ? 0x000000B0 : 0x00000170);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FC00);
-	wmb(); /* order is important here */
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, is_sparrow ? 0x000000f0 : 0x00000170);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FE00);
 
 	if (is_sparrow) {
 		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x0);
-		wmb(); /* order is important here */
+		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1, 0x0);
 	}
 
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
-	wmb(); /* order is important here */
 
 	if (is_sparrow) {
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000003);
 		/* reset A2 PCIE AHB */
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
-
 	} else {
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000001);
 		if (rev_id == 1) {
@@ -389,7 +396,6 @@ static int wil_target_reset(struct wil6210_priv *wil)
 
 	/* TODO: check order here!!! Erez code is different */
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
-	wmb(); /* order is important here */
 
 	/* wait until device ready. typical time is 200..250 msec */
 	do {
@@ -407,16 +413,15 @@ static int wil_target_reset(struct wil6210_priv *wil)
 		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(8));
 
 	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
-	wmb(); /* order is important here */
 
 	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay * RST_DELAY);
 	return 0;
+}
 
 #undef R
 #undef W
 #undef S
 #undef C
-}
 
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
 {
@@ -480,12 +485,36 @@ int wil_reset(struct wil6210_priv *wil)
 	if (rc)
 		return rc;
 
+	if (!no_fw_load) {
+		wil_info(wil, "Use firmware <%s>\n", WIL_FW_NAME);
+		wil_halt_cpu(wil);
+		/* Loading f/w from the file */
+		rc = wil_request_firmware(wil, WIL_FW_NAME);
+		if (rc)
+			return rc;
+
+		/* clear any interrupts which on-card-firmware may have set */
+		wil6210_clear_irq(wil);
+		{ /* CAF_ICR - clear and mask */
+			u32 a = HOSTADDR(RGF_CAF_ICR) +
+				offsetof(struct RGF_ICR, ICR);
+			u32 m = HOSTADDR(RGF_CAF_ICR) +
+				offsetof(struct RGF_ICR, IMV);
+			u32 icr = ioread32(wil->csr + a);
+
+			iowrite32(icr, wil->csr + a); /* W1C */
+			iowrite32(~0, wil->csr + m);
+			wmb(); /* wait for completion */
+		}
+		wil_release_cpu(wil);
+	} else {
+		wil_info(wil, "Use firmware from on-card flash\n");
+	}
 
 	/* init after reset */
 	wil->pending_connect_cid = -1;
 	reinit_completion(&wil->wmi_ready);
 
-	/* TODO: release MAC reset */
 	wil6210_enable_irq(wil);
 
 	/* we just started MAC, wait for FW ready */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f8718fe..063beaf 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -23,6 +23,7 @@
 #include <linux/timex.h>
 
 #define WIL_NAME "wil6210"
+#define WIL_FW_NAME "wil6210.fw"
 
 struct wil_board {
 	int board;
@@ -86,22 +87,29 @@ struct RGF_ICR {
 
 /* registers - FW addresses */
 #define RGF_USER_USAGE_1		(0x880004)
+#define RGF_USER_USAGE_6		(0x880018)
 #define RGF_USER_HW_MACHINE_STATE	(0x8801dc)
 	#define HW_MACHINE_BOOT_DONE	(0x3fffffd)
 #define RGF_USER_USER_CPU_0		(0x8801e0)
+	#define BIT_USER_USER_CPU_MAN_RST	BIT(1) /* user_cpu_man_rst */
 #define RGF_USER_MAC_CPU_0		(0x8801fc)
+	#define BIT_USER_MAC_CPU_MAN_RST	BIT(1) /* mac_cpu_man_rst */
 #define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
 #define RGF_USER_FW_REV_ID		(0x880a8c) /* chip revision */
 #define RGF_USER_CLKS_CTL_0		(0x880abc)
+	#define BIT_USER_CLKS_CAR_AHB_SW_SEL	BIT(1) /* ref clk/PLL */
 	#define BIT_USER_CLKS_RST_PWGD	BIT(11) /* reset on "power good" */
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_0	(0x880b04)
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_1	(0x880b08)
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_2	(0x880b0c)
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_3	(0x880b10)
 #define RGF_USER_CLKS_CTL_SW_RST_MASK_0	(0x880b14)
+	#define BIT_HPAL_PERST_FROM_PAD	BIT(6)
+	#define BIT_CAR_PERST_RST	BIT(7)
 #define RGF_USER_USER_ICR		(0x880b4c) /* struct RGF_ICR */
 	#define BIT_USER_USER_ICR_SW_INT_2	BIT(18)
 #define RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0	(0x880c18)
+#define RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1	(0x880c2c)
 
 #define RGF_DMA_EP_TX_ICR		(0x881bb4) /* struct RGF_ICR */
 	#define BIT_DMA_EP_TX_ICR_TX_DONE	BIT(0)
@@ -136,6 +144,8 @@ struct RGF_ICR {
 /* MAC timer, usec, for packet lifetime */
 #define RGF_MAC_MTRL_COUNTER_0		(0x886aa8)
 
+#define RGF_CAF_ICR			(0x88946c) /* struct RGF_ICR */
+
 /* popular locations */
 #define HOST_MBOX   HOSTADDR(RGF_USER_USER_SCRATCH_PAD)
 #define HOST_SW_INT (HOSTADDR(RGF_USER_USER_ICR) + \
@@ -435,6 +445,7 @@ struct wil6210_priv {
 #define wdev_to_wil(w) (struct wil6210_priv *)(wdev_priv(w))
 #define wil_to_ndev(i) (wil_to_wdev(i)->netdev)
 #define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
+#define wil_to_pcie_dev(i) (&i->pdev->dev)
 
 int wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
 int wil_err(struct wil6210_priv *wil, const char *fmt, ...);
@@ -547,4 +558,5 @@ void wil6210_unmask_irq_rx(struct wil6210_priv *wil);
 
 int wil_iftype_nl2wmi(enum nl80211_iftype type);
 
+int wil_request_firmware(struct wil6210_priv *wil, const char *name);
 #endif /* __WIL6210_H__ */
-- 
1.9.1

