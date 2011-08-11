Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39453 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1HKGvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 02:51:47 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	Kevin Fang <chienf@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 7/7] ath6kl: seperate BMI_MAX_DATA_SZ between usb and sdio
Date: Thu, 11 Aug 2011 14:48:15 +0800
Message-ID: <1313045295-16202-7-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20110811_085149_579814_410689C3)
In-Reply-To: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
References: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bmi max data size between usb and sdio is quite different.
The bmi max data size of sdio is 256, and the max data size of usb is 252

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.c |   62 +++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/bmi.h |    7 +---
 2 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index ed87bc2..1e56f79 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -19,6 +19,17 @@
 #include "target.h"
 #include "debug.h"
 
+static u32 ath6kl_bmi_get_max_data_size(struct ath6kl *ar)
+{
+	return (ar->hif_type == HIF_TYPE_SDIO) ?
+		BMI_SDIO_DATASZ_MAX : BMI_USB_DATASZ_MAX;
+}
+
+static u32 ath6kl_bmi_get_max_cmd_size(struct ath6kl *ar)
+{
+	return ath6kl_bmi_get_max_data_size(ar) + (sizeof(u32) * 3);
+}
+
 int ath6kl_bmi_done(struct ath6kl *ar)
 {
 	int ret;
@@ -120,6 +131,8 @@ int ath6kl_bmi_read(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	int ret;
 	u32 offset;
 	u32 len_remain, rx_len;
+	u32 max_data_sz = ath6kl_bmi_get_max_data_size(ar);
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
 	u16 size;
 
 	if (ar->bmi.done_sent) {
@@ -127,8 +140,8 @@ int ath6kl_bmi_read(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 		return -EACCES;
 	}
 
-	size = BMI_DATASZ_MAX + sizeof(cid) + sizeof(addr) + sizeof(len);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	size = max_data_sz + sizeof(cid) + sizeof(addr) + sizeof(len);
+	if (size > max_cmd_sz) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -141,8 +154,8 @@ int ath6kl_bmi_read(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	len_remain = len;
 
 	while (len_remain) {
-		rx_len = (len_remain < BMI_DATASZ_MAX) ?
-					len_remain : BMI_DATASZ_MAX;
+		rx_len = (len_remain < max_data_sz) ?
+					len_remain : max_data_sz;
 		offset = 0;
 		memcpy(&(ar->bmi.cmd_buf[offset]), &cid, sizeof(cid));
 		offset += sizeof(cid);
@@ -179,7 +192,9 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	u32 offset;
 	u32 len_remain, tx_len;
 	const u32 header = sizeof(cid) + sizeof(addr) + sizeof(len);
-	u8 aligned_buf[BMI_DATASZ_MAX];
+	u32 max_data_sz = ath6kl_bmi_get_max_data_size(ar);
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
+	u8 aligned_buf[max_data_sz];
 	u8 *src;
 
 	if (ar->bmi.done_sent) {
@@ -187,12 +202,12 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 		return -EACCES;
 	}
 
-	if ((BMI_DATASZ_MAX + header) > MAX_BMI_CMDBUF_SZ) {
+	if ((max_data_sz + header) > max_cmd_sz) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
-	memset(ar->bmi.cmd_buf, 0, BMI_DATASZ_MAX + header);
+	memset(ar->bmi.cmd_buf, 0, max_data_sz + header);
 
 	ath6kl_dbg(ATH6KL_DBG_BMI,
 		  "bmi write memory: addr: 0x%x, len: %d\n", addr, len);
@@ -201,7 +216,7 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	while (len_remain) {
 		src = &buf[len - len_remain];
 
-		if (len_remain < (BMI_DATASZ_MAX - header)) {
+		if (len_remain < (max_data_sz - header)) {
 			if (len_remain & 3) {
 				/* align it with 4 bytes */
 				len_remain = len_remain +
@@ -211,7 +226,7 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 			}
 			tx_len = len_remain;
 		} else {
-			tx_len = (BMI_DATASZ_MAX - header);
+			tx_len = (max_data_sz - header);
 		}
 
 		offset = 0;
@@ -241,6 +256,7 @@ int ath6kl_bmi_execute(struct ath6kl *ar, u32 addr, u32 *param)
 	u32 cid = BMI_EXECUTE;
 	int ret;
 	u32 offset;
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
 	u16 size;
 
 	if (ar->bmi.done_sent) {
@@ -249,7 +265,7 @@ int ath6kl_bmi_execute(struct ath6kl *ar, u32 addr, u32 *param)
 	}
 
 	size = sizeof(cid) + sizeof(addr) + sizeof(param);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > max_cmd_sz) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -289,6 +305,7 @@ int ath6kl_bmi_set_app_start(struct ath6kl *ar, u32 addr)
 	u32 cid = BMI_SET_APP_START;
 	int ret;
 	u32 offset;
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
 	u16 size;
 
 	if (ar->bmi.done_sent) {
@@ -297,7 +314,7 @@ int ath6kl_bmi_set_app_start(struct ath6kl *ar, u32 addr)
 	}
 
 	size = sizeof(cid) + sizeof(addr);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > max_cmd_sz) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -325,6 +342,7 @@ int ath6kl_bmi_reg_read(struct ath6kl *ar, u32 addr, u32 *param)
 	u32 cid = BMI_READ_SOC_REGISTER;
 	int ret;
 	u32 offset;
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
 	u16 size;
 
 	if (ar->bmi.done_sent) {
@@ -333,7 +351,7 @@ int ath6kl_bmi_reg_read(struct ath6kl *ar, u32 addr, u32 *param)
 	}
 
 	size = sizeof(cid) + sizeof(addr);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > max_cmd_sz) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -369,6 +387,7 @@ int ath6kl_bmi_reg_write(struct ath6kl *ar, u32 addr, u32 param)
 	u32 cid = BMI_WRITE_SOC_REGISTER;
 	int ret;
 	u32 offset;
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
 	u16 size;
 
 	if (ar->bmi.done_sent) {
@@ -377,7 +396,7 @@ int ath6kl_bmi_reg_write(struct ath6kl *ar, u32 addr, u32 param)
 	}
 
 	size = sizeof(cid) + sizeof(addr) + sizeof(param);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > max_cmd_sz) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -411,6 +430,8 @@ int ath6kl_bmi_lz_data(struct ath6kl *ar, u8 *buf, u32 len)
 	u32 offset;
 	u32 len_remain, tx_len;
 	const u32 header = sizeof(cid) + sizeof(len);
+	u32 max_data_sz = ath6kl_bmi_get_max_data_size(ar);
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
 	u16 size;
 
 	if (ar->bmi.done_sent) {
@@ -418,8 +439,8 @@ int ath6kl_bmi_lz_data(struct ath6kl *ar, u8 *buf, u32 len)
 		return -EACCES;
 	}
 
-	size = BMI_DATASZ_MAX + header;
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	size = max_data_sz + header;
+	if (size > max_cmd_sz) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -430,8 +451,8 @@ int ath6kl_bmi_lz_data(struct ath6kl *ar, u8 *buf, u32 len)
 
 	len_remain = len;
 	while (len_remain) {
-		tx_len = (len_remain < (BMI_DATASZ_MAX - header)) ?
-			  len_remain : (BMI_DATASZ_MAX - header);
+		tx_len = (len_remain < (max_data_sz - header)) ?
+			  len_remain : (max_data_sz - header);
 
 		offset = 0;
 		memcpy(&(ar->bmi.cmd_buf[offset]), &cid, sizeof(cid));
@@ -460,6 +481,7 @@ int ath6kl_bmi_lz_stream_start(struct ath6kl *ar, u32 addr)
 	u32 cid = BMI_LZ_STREAM_START;
 	int ret;
 	u32 offset;
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
 	u16 size;
 
 	if (ar->bmi.done_sent) {
@@ -468,7 +490,7 @@ int ath6kl_bmi_lz_stream_start(struct ath6kl *ar, u32 addr)
 	}
 
 	size = sizeof(cid) + sizeof(addr);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > max_cmd_sz) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -527,7 +549,9 @@ int ath6kl_bmi_fast_download(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 
 int ath6kl_bmi_init(struct ath6kl *ar)
 {
-	ar->bmi.cmd_buf = kzalloc(MAX_BMI_CMDBUF_SZ, GFP_ATOMIC);
+	u32 max_cmd_sz = ath6kl_bmi_get_max_cmd_size(ar);
+
+	ar->bmi.cmd_buf = kzalloc(max_cmd_sz, GFP_ATOMIC);
 
 	if (!ar->bmi.cmd_buf)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index 3d55c9a..2592abe 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -44,11 +44,8 @@
  * BMI handles all required Target-side cache flushing.
  */
 
-#define MAX_BMI_CMDBUF_SZ (BMI_DATASZ_MAX + \
-			   (sizeof(u32) * 3 /* cmd + addr + len */))
-
-/* Maximum data size used for BMI transfers */
-#define BMI_DATASZ_MAX                      256
+#define BMI_SDIO_DATASZ_MAX                      256
+#define BMI_USB_DATASZ_MAX                      252
 
 /* BMI Commands */
 
-- 
1.7.0.4

