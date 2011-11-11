Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:57828 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1KKKRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:17:48 -0500
Subject: [PATCH 02/10] ath6kl: change bmi sizes being configurable by HIF
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:17:42 +0200
Message-ID: <20111111101742.12075.23791.stgit@localhost6.localdomain6> (sfid-20111111_111750_473331_31E8F8C6)
In-Reply-To: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
References: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SDIO and USB have different maximum sizes for BMI commands so make that
configurable.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.c  |   46 +++++++++++++++++++-------------
 drivers/net/wireless/ath/ath6kl/bmi.h  |    6 ----
 drivers/net/wireless/ath/ath6kl/core.h |    2 +
 drivers/net/wireless/ath/ath6kl/sdio.c |    1 +
 4 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index 12f5b57..bce3575 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -117,8 +117,8 @@ int ath6kl_bmi_read(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 		return -EACCES;
 	}
 
-	size = BMI_DATASZ_MAX + sizeof(cid) + sizeof(addr) + sizeof(len);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	size = ar->bmi.max_data_size + sizeof(cid) + sizeof(addr) + sizeof(len);
+	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -131,8 +131,8 @@ int ath6kl_bmi_read(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	len_remain = len;
 
 	while (len_remain) {
-		rx_len = (len_remain < BMI_DATASZ_MAX) ?
-					len_remain : BMI_DATASZ_MAX;
+		rx_len = (len_remain < ar->bmi.max_data_size) ?
+					len_remain : ar->bmi.max_data_size;
 		offset = 0;
 		memcpy(&(ar->bmi.cmd_buf[offset]), &cid, sizeof(cid));
 		offset += sizeof(cid);
@@ -167,7 +167,7 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	u32 offset;
 	u32 len_remain, tx_len;
 	const u32 header = sizeof(cid) + sizeof(addr) + sizeof(len);
-	u8 aligned_buf[BMI_DATASZ_MAX];
+	u8 aligned_buf[400];
 	u8 *src;
 
 	if (ar->bmi.done_sent) {
@@ -175,12 +175,15 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 		return -EACCES;
 	}
 
-	if ((BMI_DATASZ_MAX + header) > MAX_BMI_CMDBUF_SZ) {
+	if ((ar->bmi.max_data_size + header) > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
-	memset(ar->bmi.cmd_buf, 0, BMI_DATASZ_MAX + header);
+	if (WARN_ON(ar->bmi.max_data_size > sizeof(aligned_buf)))
+		return -E2BIG;
+
+	memset(ar->bmi.cmd_buf, 0, ar->bmi.max_data_size + header);
 
 	ath6kl_dbg(ATH6KL_DBG_BMI,
 		  "bmi write memory: addr: 0x%x, len: %d\n", addr, len);
@@ -189,7 +192,7 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	while (len_remain) {
 		src = &buf[len - len_remain];
 
-		if (len_remain < (BMI_DATASZ_MAX - header)) {
+		if (len_remain < (ar->bmi.max_data_size - header)) {
 			if (len_remain & 3) {
 				/* align it with 4 bytes */
 				len_remain = len_remain +
@@ -199,7 +202,7 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 			}
 			tx_len = len_remain;
 		} else {
-			tx_len = (BMI_DATASZ_MAX - header);
+			tx_len = (ar->bmi.max_data_size - header);
 		}
 
 		offset = 0;
@@ -237,7 +240,7 @@ int ath6kl_bmi_execute(struct ath6kl *ar, u32 addr, u32 *param)
 	}
 
 	size = sizeof(cid) + sizeof(addr) + sizeof(param);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -284,7 +287,7 @@ int ath6kl_bmi_set_app_start(struct ath6kl *ar, u32 addr)
 	}
 
 	size = sizeof(cid) + sizeof(addr);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -320,7 +323,7 @@ int ath6kl_bmi_reg_read(struct ath6kl *ar, u32 addr, u32 *param)
 	}
 
 	size = sizeof(cid) + sizeof(addr);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -363,7 +366,7 @@ int ath6kl_bmi_reg_write(struct ath6kl *ar, u32 addr, u32 param)
 	}
 
 	size = sizeof(cid) + sizeof(addr) + sizeof(param);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -404,8 +407,8 @@ int ath6kl_bmi_lz_data(struct ath6kl *ar, u8 *buf, u32 len)
 		return -EACCES;
 	}
 
-	size = BMI_DATASZ_MAX + header;
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	size = ar->bmi.max_data_size + header;
+	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -416,8 +419,8 @@ int ath6kl_bmi_lz_data(struct ath6kl *ar, u8 *buf, u32 len)
 
 	len_remain = len;
 	while (len_remain) {
-		tx_len = (len_remain < (BMI_DATASZ_MAX - header)) ?
-			  len_remain : (BMI_DATASZ_MAX - header);
+		tx_len = (len_remain < (ar->bmi.max_data_size - header)) ?
+			  len_remain : (ar->bmi.max_data_size - header);
 
 		offset = 0;
 		memcpy(&(ar->bmi.cmd_buf[offset]), &cid, sizeof(cid));
@@ -454,7 +457,7 @@ int ath6kl_bmi_lz_stream_start(struct ath6kl *ar, u32 addr)
 	}
 
 	size = sizeof(cid) + sizeof(addr);
-	if (size > MAX_BMI_CMDBUF_SZ) {
+	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -518,8 +521,13 @@ void ath6kl_bmi_reset(struct ath6kl *ar)
 
 int ath6kl_bmi_init(struct ath6kl *ar)
 {
-	ar->bmi.cmd_buf = kzalloc(MAX_BMI_CMDBUF_SZ, GFP_ATOMIC);
+	if (WARN_ON(ar->bmi.max_data_size == 0))
+		return -EINVAL;
+
+	/* cmd + addr + len + data_size */
+	ar->bmi.max_cmd_size = ar->bmi.max_data_size + (sizeof(u32) * 3);
 
+	ar->bmi.cmd_buf = kzalloc(ar->bmi.max_cmd_size, GFP_ATOMIC);
 	if (!ar->bmi.cmd_buf)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index 009e8f6..f1ca681 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -44,12 +44,6 @@
  * BMI handles all required Target-side cache flushing.
  */
 
-#define MAX_BMI_CMDBUF_SZ (BMI_DATASZ_MAX + \
-			   (sizeof(u32) * 3 /* cmd + addr + len */))
-
-/* Maximum data size used for BMI transfers */
-#define BMI_DATASZ_MAX                      256
-
 /* BMI Commands */
 
 #define BMI_NO_COMMAND                      0
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index e7e095e..c08c02e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -272,6 +272,8 @@ struct ath6kl_bmi {
 	u32 cmd_credits;
 	bool done_sent;
 	u8 *cmd_buf;
+	u32 max_data_size;
+	u32 max_cmd_size;
 };
 
 struct target_stats {
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 2a803b3..beb73c7 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1140,6 +1140,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	ar_sdio->ar = ar;
 	ar->hif_priv = ar_sdio;
 	ar->hif_ops = &ath6kl_sdio_ops;
+	ar->bmi.max_data_size = 256;
 
 	ath6kl_sdio_set_mbox_info(ar);
 

