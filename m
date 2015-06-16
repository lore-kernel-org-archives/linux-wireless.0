Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49531 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbbFPFPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:15:08 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 09/10] ath10k: Add support for code swap
Date: Tue, 16 Jun 2015 10:42:21 +0530
Message-ID: <1434431542-14724-10-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150616_071512_695894_20A556BB)
In-Reply-To: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code swap is a mechanism to use host memory to store
some fw binary code segment. Ath10k host driver allocates
and loads the code swap binary into the host memory and
configures the target with the host allocated memory
information at the address taken from code swap binary.
This patch adds code swap support for firmware binary.
Code swap binary for firmware bin is available in
ATH10K_FW_IE_FW_CODE_SWAP_IMAGE.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Makefile |   3 +-
 drivers/net/wireless/ath/ath10k/core.c   |  24 ++++
 drivers/net/wireless/ath/ath10k/core.h   |   7 ++
 drivers/net/wireless/ath/ath10k/hw.h     |   3 +
 drivers/net/wireless/ath/ath10k/swap.c   | 208 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/swap.h   |  72 +++++++++++
 6 files changed, 316 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/swap.c
 create mode 100644 drivers/net/wireless/ath/ath10k/swap.h

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 9729e69..c04fb00 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -11,7 +11,8 @@ ath10k_core-y += mac.o \
 		 wmi-tlv.o \
 		 bmi.o \
 		 hw.o \
-		 p2p.o
+		 p2p.o \
+		 swap.o
 
 ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
 ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index de85ec8..6346711 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -426,6 +426,13 @@ static int ath10k_download_fw(struct ath10k *ar, enum ath10k_firmware_mode mode)
 		data = ar->firmware_data;
 		data_len = ar->firmware_len;
 		mode_name = "normal";
+		ret = ath10k_swap_code_seg_configure(ar,
+				ATH10K_SWAP_CODE_SEG_BIN_TYPE_FW);
+		if (ret) {
+			ath10k_err(ar, "failed to configure fw code swap: %d\n",
+				   ret);
+			return ret;
+		}
 		break;
 	case ATH10K_FIRMWARE_MODE_UTF:
 		data = ar->testmode.utf->data;
@@ -465,6 +472,8 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	if (!IS_ERR(ar->cal_file))
 		release_firmware(ar->cal_file);
 
+	ath10k_swap_code_seg_release(ar);
+
 	ar->board = NULL;
 	ar->board_data = NULL;
 	ar->board_len = 0;
@@ -478,6 +487,7 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	ar->firmware_len = 0;
 
 	ar->cal_file = NULL;
+
 }
 
 static int ath10k_fetch_cal_file(struct ath10k *ar)
@@ -751,6 +761,13 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ath10k_dbg(ar, ATH10K_DBG_BOOT, "found fw ie htt op version %d\n",
 				   ar->htt.op_version);
 			break;
+		case ATH10K_FW_IE_FW_CODE_SWAP_IMAGE:
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "found fw code swap image ie (%zd B)\n",
+				   ie_len);
+			ar->swap.firmware_codeswap_data = data;
+			ar->swap.firmware_codeswap_len = ie_len;
+			break;
 		default:
 			ath10k_warn(ar, "Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
@@ -1344,6 +1361,13 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_free_firmware_files;
 	}
 
+	ret = ath10k_swap_code_seg_init(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to initialize code swap segment: %d\n",
+			   ret);
+		goto err_free_firmware_files;
+	}
+
 	mutex_lock(&ar->conf_mutex);
 
 	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ae92f64..335b2fc 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -36,6 +36,7 @@
 #include "spectral.h"
 #include "thermal.h"
 #include "wow.h"
+#include "swap.h"
 
 #define MS(_v, _f) (((_v) & _f##_MASK) >> _f##_LSB)
 #define SM(_v, _f) (((_v) << _f##_LSB) & _f##_MASK)
@@ -603,6 +604,12 @@ struct ath10k {
 
 	const struct firmware *cal_file;
 
+	struct {
+		const void *firmware_codeswap_data;
+		size_t firmware_codeswap_len;
+		struct ath10k_swap_code_seg_info *firmware_swap_code_seg_info;
+	} swap;
+
 	char spec_board_id[100];
 	bool spec_board_loaded;
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 35cd8ca..3e27781 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -124,6 +124,9 @@ enum ath10k_fw_ie_type {
 	 * FW API 5 and above.
 	 */
 	ATH10K_FW_IE_HTT_OP_VERSION = 6,
+
+	/* Code swap image for firmware binary */
+	ATH10K_FW_IE_FW_CODE_SWAP_IMAGE = 7,
 };
 
 enum ath10k_fw_wmi_op_version {
diff --git a/drivers/net/wireless/ath/ath10k/swap.c b/drivers/net/wireless/ath/ath10k/swap.c
new file mode 100644
index 0000000..a6d2f34
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/swap.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
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
+/* This file has implementation for code swap logic. With code swap feature,
+ * target can run the fw binary with even smaller IRAM size by using host
+ * memory to store some of the code segments.
+ */
+
+#include "core.h"
+#include "bmi.h"
+#include "debug.h"
+
+static int ath10k_swap_code_seg_fill(struct ath10k *ar,
+				     struct ath10k_swap_code_seg_info *seg_info,
+				     const void *data, size_t data_len)
+{
+	u8 *virt_addr = seg_info->virt_address[0];
+	u8 swap_magic[ATH10K_SWAP_CODE_SEG_MAGIC_BYTES_SZ] = {};
+	const u8 *fw_data = data;
+	union ath10k_swap_code_seg_item *swap_item;
+	u32 length = 0;
+	u32 payload_len;
+	u32 total_payload_len = 0;
+	u32 size_left = data_len;
+
+	/* Parse swap bin and copy the content to host allocated memory.
+	 * The format is Address, length and value. The last 4-bytes is
+	 * target write address. Currently address field is not used.
+	 */
+	seg_info->target_addr = -1;
+	while (size_left >= sizeof(*swap_item)) {
+		swap_item = (union ath10k_swap_code_seg_item *)fw_data;
+		payload_len = __le32_to_cpu(swap_item->tlv.length);
+		if ((payload_len > size_left) ||
+		    (payload_len == 0 &&
+		     size_left != sizeof(struct ath10k_swap_code_seg_tail))) {
+			ath10k_err(ar, "refusing to parse invalid tlv length %d\n",
+				   payload_len);
+			return -EINVAL;
+		}
+
+		if (payload_len == 0) {
+			if (memcmp(swap_item->tail.magic_signature, swap_magic,
+				   ATH10K_SWAP_CODE_SEG_MAGIC_BYTES_SZ)) {
+				ath10k_err(ar, "refusing an invalid swap file\n");
+				return -EINVAL;
+			}
+			seg_info->target_addr =
+				__le32_to_cpu(swap_item->tail.bmi_write_addr);
+			break;
+		}
+
+		memcpy(virt_addr, swap_item->tlv.data, payload_len);
+		virt_addr += payload_len;
+		length = payload_len +  sizeof(struct ath10k_swap_code_seg_tlv);
+		size_left -= length;
+		fw_data += length;
+		total_payload_len += payload_len;
+	}
+
+	if (seg_info->target_addr == -1) {
+		ath10k_err(ar, "failed to parse invalid swap file\n");
+		return -EINVAL;
+	}
+	seg_info->seg_hw_info.swap_size = __cpu_to_le32(total_payload_len);
+
+	return 0;
+}
+
+static void
+ath10k_swap_code_seg_free(struct ath10k *ar,
+			  struct ath10k_swap_code_seg_info *seg_info)
+{
+	u32 seg_size;
+
+	if (!seg_info)
+		return;
+
+	if (!seg_info->virt_address[0])
+		return;
+
+	seg_size = __le32_to_cpu(seg_info->seg_hw_info.size);
+	dma_free_coherent(ar->dev, seg_size, seg_info->virt_address[0],
+			  seg_info->paddr[0]);
+}
+
+static struct ath10k_swap_code_seg_info *
+ath10k_swap_code_seg_alloc(struct ath10k *ar, size_t swap_bin_len)
+{
+	struct ath10k_swap_code_seg_info *seg_info;
+	void *virt_addr;
+	dma_addr_t paddr;
+
+	swap_bin_len = roundup(swap_bin_len, 2);
+	if (swap_bin_len > ATH10K_SWAP_CODE_SEG_BIN_LEN_MAX) {
+		ath10k_err(ar, "refusing code swap bin because it is too big %zd > %d\n",
+			   swap_bin_len, ATH10K_SWAP_CODE_SEG_BIN_LEN_MAX);
+		return NULL;
+	}
+
+	seg_info = devm_kzalloc(ar->dev, sizeof(*seg_info), GFP_KERNEL);
+	if (!seg_info)
+		return NULL;
+
+	virt_addr = dma_alloc_coherent(ar->dev, swap_bin_len, &paddr,
+				       GFP_KERNEL);
+	if (!virt_addr) {
+		ath10k_err(ar, "failed to allocate dma coherent memory\n");
+		return NULL;
+	}
+
+	seg_info->seg_hw_info.bus_addr[0] = __cpu_to_le32(paddr);
+	seg_info->seg_hw_info.size = __cpu_to_le32(swap_bin_len);
+	seg_info->seg_hw_info.swap_size = __cpu_to_le32(swap_bin_len);
+	seg_info->seg_hw_info.num_segs =
+			__cpu_to_le32(ATH10K_SWAP_CODE_SEG_NUM_SUPPORTED);
+	seg_info->seg_hw_info.size_log2 = __cpu_to_le32(ilog2(swap_bin_len));
+	seg_info->virt_address[0] = virt_addr;
+	seg_info->paddr[0] = paddr;
+
+	return seg_info;
+}
+
+int ath10k_swap_code_seg_configure(struct ath10k *ar,
+				   enum ath10k_swap_code_seg_bin_type type)
+{
+	int ret;
+	struct ath10k_swap_code_seg_info *seg_info = NULL;
+
+	switch (type) {
+	case ATH10K_SWAP_CODE_SEG_BIN_TYPE_FW:
+		if (!ar->swap.firmware_swap_code_seg_info)
+			return 0;
+
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot found firmware code swap binary\n");
+		seg_info = ar->swap.firmware_swap_code_seg_info;
+		break;
+	default:
+	case ATH10K_SWAP_CODE_SEG_BIN_TYPE_OTP:
+	case ATH10K_SWAP_CODE_SEG_BIN_TYPE_UTF:
+		ath10k_warn(ar, "ignoring unknown code swap binary type %d\n",
+			    type);
+		return 0;
+	}
+
+	ret = ath10k_bmi_write_memory(ar, seg_info->target_addr,
+				      &seg_info->seg_hw_info,
+				      sizeof(seg_info->seg_hw_info));
+	if (ret) {
+		ath10k_err(ar, "failed to write Code swap segment information (%d)\n",
+			   ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ath10k_swap_code_seg_release(struct ath10k *ar)
+{
+	ath10k_swap_code_seg_free(ar, ar->swap.firmware_swap_code_seg_info);
+	ar->swap.firmware_codeswap_data = NULL;
+	ar->swap.firmware_codeswap_len = 0;
+	ar->swap.firmware_swap_code_seg_info = NULL;
+}
+
+int ath10k_swap_code_seg_init(struct ath10k *ar)
+{
+	int ret;
+	struct ath10k_swap_code_seg_info *seg_info;
+
+	if (!ar->swap.firmware_codeswap_len || !ar->swap.firmware_codeswap_data)
+		return 0;
+
+	seg_info = ath10k_swap_code_seg_alloc(ar,
+					      ar->swap.firmware_codeswap_len);
+	if (!seg_info) {
+		ath10k_err(ar, "failed to allocate fw code swap segment\n");
+		return -ENOMEM;
+	}
+
+	ret = ath10k_swap_code_seg_fill(ar, seg_info,
+					ar->swap.firmware_codeswap_data,
+					ar->swap.firmware_codeswap_len);
+
+	if (ret) {
+		ath10k_warn(ar, "failed to initialize fw code swap segment: %d\n",
+			    ret);
+		ath10k_swap_code_seg_free(ar, seg_info);
+		return ret;
+	}
+
+	ar->swap.firmware_swap_code_seg_info = seg_info;
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath10k/swap.h b/drivers/net/wireless/ath/ath10k/swap.h
new file mode 100644
index 0000000..5c89952
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/swap.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
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
+#ifndef _SWAP_H_
+#define _SWAP_H_
+
+#define ATH10K_SWAP_CODE_SEG_BIN_LEN_MAX	(512 * 1024)
+#define ATH10K_SWAP_CODE_SEG_MAGIC_BYTES_SZ	12
+#define ATH10K_SWAP_CODE_SEG_NUM_MAX		16
+/* Currently only one swap segment is supported */
+#define ATH10K_SWAP_CODE_SEG_NUM_SUPPORTED	1
+
+struct ath10k_swap_code_seg_tlv {
+	__le32 address;
+	__le32 length;
+	u8 data[0];
+} __packed;
+
+struct ath10k_swap_code_seg_tail {
+	u8 magic_signature[ATH10K_SWAP_CODE_SEG_MAGIC_BYTES_SZ];
+	__le32 bmi_write_addr;
+} __packed;
+
+union ath10k_swap_code_seg_item {
+	struct ath10k_swap_code_seg_tlv tlv;
+	struct ath10k_swap_code_seg_tail tail;
+} __packed;
+
+enum ath10k_swap_code_seg_bin_type {
+	 ATH10K_SWAP_CODE_SEG_BIN_TYPE_OTP,
+	 ATH10K_SWAP_CODE_SEG_BIN_TYPE_FW,
+	 ATH10K_SWAP_CODE_SEG_BIN_TYPE_UTF,
+};
+
+struct ath10k_swap_code_seg_hw_info {
+	/* Swap binary image size */
+	__le32 swap_size;
+	__le32 num_segs;
+
+	/* Swap data size */
+	__le32 size;
+	__le32 size_log2;
+	__le32 bus_addr[ATH10K_SWAP_CODE_SEG_NUM_MAX];
+	__le64 reserved[ATH10K_SWAP_CODE_SEG_NUM_MAX];
+} __packed;
+
+struct ath10k_swap_code_seg_info {
+	struct ath10k_swap_code_seg_hw_info seg_hw_info;
+	void *virt_address[ATH10K_SWAP_CODE_SEG_NUM_SUPPORTED];
+	u32 target_addr;
+	dma_addr_t paddr[ATH10K_SWAP_CODE_SEG_NUM_SUPPORTED];
+};
+
+int ath10k_swap_code_seg_configure(struct ath10k *ar,
+				   enum ath10k_swap_code_seg_bin_type type);
+void ath10k_swap_code_seg_release(struct ath10k *ar);
+int ath10k_swap_code_seg_init(struct ath10k *ar);
+
+#endif
-- 
1.9.1

