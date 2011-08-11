Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23187 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1HKGtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 02:49:14 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	Kevin Fang <chienf@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 4/7] ath6kl: add call back function for bmi send/receive buf
Date: Thu, 11 Aug 2011 14:48:12 +0800
Message-ID: <1313045295-16202-4-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20110811_084917_546260_7A9A15ED)
In-Reply-To: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
References: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is conflict method of send/receive buf between sdio and usb.
Therefore, add callback function for these send/receive buf method.

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.c     |  204 ++++-------------------------
 drivers/net/wireless/ath/ath6kl/hif-ops.h |   11 ++
 drivers/net/wireless/ath/ath6kl/hif.h     |    3 +
 drivers/net/wireless/ath/ath6kl/sdio.c    |  164 +++++++++++++++++++++++
 4 files changed, 205 insertions(+), 177 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index 8467669..ed87bc2 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -19,166 +19,6 @@
 #include "target.h"
 #include "debug.h"
 
-static int ath6kl_get_bmi_cmd_credits(struct ath6kl *ar)
-{
-	u32 addr;
-	unsigned long timeout;
-	int ret;
-
-	ar->bmi.cmd_credits = 0;
-
-	/* Read the counter register to get the command credits */
-	addr = COUNT_DEC_ADDRESS + (HTC_MAILBOX_NUM_MAX + ENDPOINT1) * 4;
-
-	timeout = jiffies + msecs_to_jiffies(BMI_COMMUNICATION_TIMEOUT);
-	while (time_before(jiffies, timeout) && !ar->bmi.cmd_credits) {
-
-		/*
-		 * Hit the credit counter with a 4-byte access, the first byte
-		 * read will hit the counter and cause a decrement, while the
-		 * remaining 3 bytes has no effect. The rationale behind this
-		 * is to make all HIF accesses 4-byte aligned.
-		 */
-		ret = hif_read_write_sync(ar, addr,
-					 (u8 *)&ar->bmi.cmd_credits, 4,
-					 HIF_RD_SYNC_BYTE_INC);
-		if (ret) {
-			ath6kl_err("Unable to decrement the command credit count register: %d\n",
-				   ret);
-			return ret;
-		}
-
-		/* The counter is only 8 bits.
-		 * Ignore anything in the upper 3 bytes
-		 */
-		ar->bmi.cmd_credits &= 0xFF;
-	}
-
-	if (!ar->bmi.cmd_credits) {
-		ath6kl_err("bmi communication timeout\n");
-		return -ETIMEDOUT;
-	}
-
-	return 0;
-}
-
-static int ath6kl_bmi_get_rx_lkahd(struct ath6kl *ar, bool need_timeout)
-{
-	unsigned long timeout;
-	u32 rx_word = 0;
-	int ret = 0;
-
-	timeout = jiffies + msecs_to_jiffies(BMI_COMMUNICATION_TIMEOUT);
-	while ((!need_timeout || time_before(jiffies, timeout)) && !rx_word) {
-		ret = hif_read_write_sync(ar, RX_LOOKAHEAD_VALID_ADDRESS,
-					  (u8 *)&rx_word, sizeof(rx_word),
-					  HIF_RD_SYNC_BYTE_INC);
-		if (ret) {
-			ath6kl_err("unable to read RX_LOOKAHEAD_VALID\n");
-			return ret;
-		}
-
-		 /* all we really want is one bit */
-		rx_word &= (1 << ENDPOINT1);
-	}
-
-	if (!rx_word) {
-		ath6kl_err("bmi_recv_buf FIFO empty\n");
-		return -EINVAL;
-	}
-
-	return ret;
-}
-
-static int ath6kl_bmi_send_buf(struct ath6kl *ar, u8 *buf, u32 len)
-{
-	int ret;
-	u32 addr;
-
-	ret = ath6kl_get_bmi_cmd_credits(ar);
-	if (ret)
-		return ret;
-
-	addr = ar->mbox_info.htc_addr;
-
-	ret = hif_read_write_sync(ar, addr, buf, len,
-				  HIF_WR_SYNC_BYTE_INC);
-	if (ret)
-		ath6kl_err("unable to send the bmi data to the device\n");
-
-	return ret;
-}
-
-static int ath6kl_bmi_recv_buf(struct ath6kl *ar,
-			u8 *buf, u32 len, bool want_timeout)
-{
-	int ret;
-	u32 addr;
-
-	/*
-	 * During normal bootup, small reads may be required.
-	 * Rather than issue an HIF Read and then wait as the Target
-	 * adds successive bytes to the FIFO, we wait here until
-	 * we know that response data is available.
-	 *
-	 * This allows us to cleanly timeout on an unexpected
-	 * Target failure rather than risk problems at the HIF level.
-	 * In particular, this avoids SDIO timeouts and possibly garbage
-	 * data on some host controllers.  And on an interconnect
-	 * such as Compact Flash (as well as some SDIO masters) which
-	 * does not provide any indication on data timeout, it avoids
-	 * a potential hang or garbage response.
-	 *
-	 * Synchronization is more difficult for reads larger than the
-	 * size of the MBOX FIFO (128B), because the Target is unable
-	 * to push the 129th byte of data until AFTER the Host posts an
-	 * HIF Read and removes some FIFO data.  So for large reads the
-	 * Host proceeds to post an HIF Read BEFORE all the data is
-	 * actually available to read.  Fortunately, large BMI reads do
-	 * not occur in practice -- they're supported for debug/development.
-	 *
-	 * So Host/Target BMI synchronization is divided into these cases:
-	 *  CASE 1: length < 4
-	 *        Should not happen
-	 *
-	 *  CASE 2: 4 <= length <= 128
-	 *        Wait for first 4 bytes to be in FIFO
-	 *        If CONSERVATIVE_BMI_READ is enabled, also wait for
-	 *        a BMI command credit, which indicates that the ENTIRE
-	 *        response is available in the the FIFO
-	 *
-	 *  CASE 3: length > 128
-	 *        Wait for the first 4 bytes to be in FIFO
-	 *
-	 * For most uses, a small timeout should be sufficient and we will
-	 * usually see a response quickly; but there may be some unusual
-	 * (debug) cases of BMI_EXECUTE where we want an larger timeout.
-	 * For now, we use an unbounded busy loop while waiting for
-	 * BMI_EXECUTE.
-	 *
-	 * If BMI_EXECUTE ever needs to support longer-latency execution,
-	 * especially in production, this code needs to be enhanced to sleep
-	 * and yield.  Also note that BMI_COMMUNICATION_TIMEOUT is currently
-	 * a function of Host processor speed.
-	 */
-	if (len >= 4) { /* NB: Currently, always true */
-		ret = ath6kl_bmi_get_rx_lkahd(ar, want_timeout);
-		if (ret)
-			return ret;
-	}
-
-	addr = ar->mbox_info.htc_addr;
-	ret = hif_read_write_sync(ar, addr, buf, len,
-				  HIF_RD_SYNC_BYTE_INC);
-	if (ret) {
-		ath6kl_err("Unable to read the bmi data from the device: %d\n",
-			   ret);
-		return ret;
-	}
-
-	return 0;
-}
-
 int ath6kl_bmi_done(struct ath6kl *ar)
 {
 	int ret;
@@ -191,7 +31,7 @@ int ath6kl_bmi_done(struct ath6kl *ar)
 
 	ar->bmi.done_sent = true;
 
-	ret = ath6kl_bmi_send_buf(ar, (u8 *)&cid, sizeof(cid));
+	ret = ath6kl_hif_bmi_send_buf(ar, (u8 *)&cid, sizeof(cid));
 	if (ret) {
 		ath6kl_err("Unable to send bmi done: %d\n", ret);
 		return ret;
@@ -213,14 +53,20 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 		return -EACCES;
 	}
 
-	ret = ath6kl_bmi_send_buf(ar, (u8 *)&cid, sizeof(cid));
+	ret = ath6kl_hif_bmi_send_buf(ar, (u8 *)&cid, sizeof(cid));
 	if (ret) {
 		ath6kl_err("Unable to send get target info: %d\n", ret);
 		return ret;
 	}
 
-	ret = ath6kl_bmi_recv_buf(ar, (u8 *)&targ_info->version,
-			sizeof(targ_info->version), true);
+	if (ar->hif_type == HIF_TYPE_USB) {
+		ret = ath6kl_hif_bmi_recv_buf(ar, (u8 *)targ_info,
+				sizeof(struct ath6kl_bmi_target_info), true);
+	} else {
+		ret = ath6kl_hif_bmi_recv_buf(ar, (u8 *)&targ_info->version,
+				sizeof(targ_info->version), true);
+	}
+
 	if (ret) {
 		ath6kl_err("Unable to recv target info: %d\n", ret);
 		return ret;
@@ -228,7 +74,7 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 
 	if (le32_to_cpu(targ_info->version) == TARGET_VERSION_SENTINAL) {
 		/* Determine how many bytes are in the Target's targ_info */
-		ret = ath6kl_bmi_recv_buf(ar,
+		ret = ath6kl_hif_bmi_recv_buf(ar,
 				   (u8 *)&targ_info->byte_count,
 				   sizeof(targ_info->byte_count),
 				   true);
@@ -248,7 +94,7 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 		}
 
 		/* Read the remainder of the targ_info */
-		ret = ath6kl_bmi_recv_buf(ar,
+		ret = ath6kl_hif_bmi_recv_buf(ar,
 				   ((u8 *)targ_info) +
 				   sizeof(targ_info->byte_count),
 				   sizeof(*targ_info) -
@@ -305,13 +151,15 @@ int ath6kl_bmi_read(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 		memcpy(&(ar->bmi.cmd_buf[offset]), &rx_len, sizeof(rx_len));
 		offset += sizeof(len);
 
-		ret = ath6kl_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
+		ret = ath6kl_hif_bmi_send_buf(ar, ar->bmi.cmd_buf,
+					offset);
 		if (ret) {
 			ath6kl_err("Unable to write to the device: %d\n",
 				   ret);
 			return ret;
 		}
-		ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, rx_len, true);
+		ret = ath6kl_hif_bmi_recv_buf(ar, ar->bmi.cmd_buf,
+					rx_len, true);
 		if (ret) {
 			ath6kl_err("Unable to read from the device: %d\n",
 				   ret);
@@ -376,7 +224,7 @@ int ath6kl_bmi_write(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 		memcpy(&(ar->bmi.cmd_buf[offset]), src, tx_len);
 		offset += tx_len;
 
-		ret = ath6kl_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
+		ret = ath6kl_hif_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
 		if (ret) {
 			ath6kl_err("Unable to write to the device: %d\n",
 				   ret);
@@ -418,13 +266,14 @@ int ath6kl_bmi_execute(struct ath6kl *ar, u32 addr, u32 *param)
 	memcpy(&(ar->bmi.cmd_buf[offset]), param, sizeof(*param));
 	offset += sizeof(*param);
 
-	ret = ath6kl_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
+	ret = ath6kl_hif_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
 	if (ret) {
 		ath6kl_err("Unable to write to the device: %d\n", ret);
 		return ret;
 	}
 
-	ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, sizeof(*param), false);
+	ret = ath6kl_hif_bmi_recv_buf(ar, ar->bmi.cmd_buf,
+				sizeof(*param), false);
 	if (ret) {
 		ath6kl_err("Unable to read from the device: %d\n", ret);
 		return ret;
@@ -462,7 +311,7 @@ int ath6kl_bmi_set_app_start(struct ath6kl *ar, u32 addr)
 	memcpy(&(ar->bmi.cmd_buf[offset]), &addr, sizeof(addr));
 	offset += sizeof(addr);
 
-	ret = ath6kl_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
+	ret = ath6kl_hif_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
 	if (ret) {
 		ath6kl_err("Unable to write to the device: %d\n", ret);
 		return ret;
@@ -498,13 +347,14 @@ int ath6kl_bmi_reg_read(struct ath6kl *ar, u32 addr, u32 *param)
 	memcpy(&(ar->bmi.cmd_buf[offset]), &addr, sizeof(addr));
 	offset += sizeof(addr);
 
-	ret = ath6kl_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
+	ret = ath6kl_hif_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
 	if (ret) {
 		ath6kl_err("Unable to write to the device: %d\n", ret);
 		return ret;
 	}
 
-	ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, sizeof(*param), true);
+	ret = ath6kl_hif_bmi_recv_buf(ar, ar->bmi.cmd_buf,
+				sizeof(*param), true);
 	if (ret) {
 		ath6kl_err("Unable to read from the device: %d\n", ret);
 		return ret;
@@ -545,7 +395,7 @@ int ath6kl_bmi_reg_write(struct ath6kl *ar, u32 addr, u32 param)
 	memcpy(&(ar->bmi.cmd_buf[offset]), &param, sizeof(param));
 	offset += sizeof(param);
 
-	ret = ath6kl_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
+	ret = ath6kl_hif_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
 	if (ret) {
 		ath6kl_err("Unable to write to the device: %d\n", ret);
 		return ret;
@@ -592,7 +442,7 @@ int ath6kl_bmi_lz_data(struct ath6kl *ar, u8 *buf, u32 len)
 			tx_len);
 		offset += tx_len;
 
-		ret = ath6kl_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
+		ret = ath6kl_hif_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
 		if (ret) {
 			ath6kl_err("Unable to write to the device: %d\n",
 				   ret);
@@ -634,7 +484,7 @@ int ath6kl_bmi_lz_stream_start(struct ath6kl *ar, u32 addr)
 	memcpy(&(ar->bmi.cmd_buf[offset]), &addr, sizeof(addr));
 	offset += sizeof(addr);
 
-	ret = ath6kl_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
+	ret = ath6kl_hif_bmi_send_buf(ar, ar->bmi.cmd_buf, offset);
 	if (ret) {
 		ath6kl_err("Unable to start LZ stream to the device: %d\n",
 			   ret);
diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index a42acba..5625187 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -89,4 +89,15 @@ static inline int ath6kl_hif_write_diag(struct ath6kl *ar, u32 address,
 	return ar->hif_ops->write_reg_diag(ar, address, data);
 }
 
+static inline int ath6kl_hif_bmi_recv_buf(struct ath6kl *ar,
+					u8 *buf, u32 len, bool want_timeout)
+{
+	return ar->hif_ops->bmi_recv_buf(ar, buf, len, want_timeout);
+}
+
+static inline int ath6kl_hif_bmi_send_buf(struct ath6kl *ar, u8 *buf,
+					u32 len)
+{
+	return ar->hif_ops->bmi_send_buf(ar, buf, len);
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 2fff554..4c75e25 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -207,6 +207,9 @@ struct ath6kl_hif_ops {
 			u32 *data);
 	int (*write_reg_diag)(struct ath6kl *ar, u32 address,
 			u32 *data);
+	int (*bmi_recv_buf)(struct ath6kl *ar,
+			u8 *buf, u32 len, bool want_timeout);
+	int (*bmi_send_buf)(struct ath6kl *ar, u8 *buf, u32 len);
 };
 
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index e5a5563..eff70f2 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -819,6 +819,168 @@ static int ath6kl_sdio_write_reg_diag(struct ath6kl *ar, u32 address,
 				      address);
 }
 
+static int ath6kl_get_bmi_cmd_credits(struct ath6kl *ar)
+{
+	u32 addr;
+	unsigned long timeout;
+	int ret;
+
+	ar->bmi.cmd_credits = 0;
+
+	/* Read the counter register to get the command credits */
+	addr = COUNT_DEC_ADDRESS + (HTC_MAILBOX_NUM_MAX + ENDPOINT1) * 4;
+
+	timeout = jiffies + msecs_to_jiffies(BMI_COMMUNICATION_TIMEOUT);
+	while (time_before(jiffies, timeout) && !ar->bmi.cmd_credits) {
+
+		/*
+		 * Hit the credit counter with a 4-byte access, the first byte
+		 * read will hit the counter and cause a decrement, while the
+		 * remaining 3 bytes has no effect. The rationale behind this
+		 * is to make all HIF accesses 4-byte aligned.
+		 */
+		ret = ath6kl_sdio_read_write_sync(ar, addr,
+					 (u8 *)&ar->bmi.cmd_credits, 4,
+					 HIF_RD_SYNC_BYTE_INC);
+		if (ret) {
+			ath6kl_err("Unable to decrement the command credit "
+						"count register: %d\n", ret);
+			return ret;
+		}
+
+		/* The counter is only 8 bits.
+		 * Ignore anything in the upper 3 bytes
+		 */
+		ar->bmi.cmd_credits &= 0xFF;
+	}
+
+	if (!ar->bmi.cmd_credits) {
+		ath6kl_err("bmi communication timeout\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int ath6kl_bmi_get_rx_lkahd(struct ath6kl *ar, bool need_timeout)
+{
+	unsigned long timeout;
+	u32 rx_word = 0;
+	int ret = 0;
+
+	timeout = jiffies + msecs_to_jiffies(BMI_COMMUNICATION_TIMEOUT);
+	while ((!need_timeout || time_before(jiffies, timeout)) && !rx_word) {
+		ret = ath6kl_sdio_read_write_sync(ar,
+					RX_LOOKAHEAD_VALID_ADDRESS,
+					(u8 *)&rx_word, sizeof(rx_word),
+					HIF_RD_SYNC_BYTE_INC);
+		if (ret) {
+			ath6kl_err("unable to read RX_LOOKAHEAD_VALID\n");
+			return ret;
+		}
+
+		 /* all we really want is one bit */
+		rx_word &= (1 << ENDPOINT1);
+	}
+
+	if (!rx_word) {
+		ath6kl_err("bmi_recv_buf FIFO empty\n");
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static int ath6kl_sdio_bmi_send_buf(struct ath6kl *ar,
+			u8 *buf, u32 len)
+{
+	int ret;
+	u32 addr;
+
+	ret = ath6kl_get_bmi_cmd_credits(ar);
+	if (ret)
+		return ret;
+
+	addr = ar->mbox_info.htc_addr;
+
+	ret = ath6kl_sdio_read_write_sync(ar, addr, buf, len,
+				  HIF_WR_SYNC_BYTE_INC);
+	if (ret)
+		ath6kl_err("unable to send the bmi data to the device\n");
+
+	return ret;
+}
+
+static int ath6kl_sdio_bmi_recv_buf(struct ath6kl *ar,
+			u8 *buf, u32 len, bool want_timeout)
+{
+	int ret;
+	u32 addr;
+
+	/*
+	 * During normal bootup, small reads may be required.
+	 * Rather than issue an HIF Read and then wait as the Target
+	 * adds successive bytes to the FIFO, we wait here until
+	 * we know that response data is available.
+	 *
+	 * This allows us to cleanly timeout on an unexpected
+	 * Target failure rather than risk problems at the HIF level.
+	 * In particular, this avoids SDIO timeouts and possibly garbage
+	 * data on some host controllers.  And on an interconnect
+	 * such as Compact Flash (as well as some SDIO masters) which
+	 * does not provide any indication on data timeout, it avoids
+	 * a potential hang or garbage response.
+	 *
+	 * Synchronization is more difficult for reads larger than the
+	 * size of the MBOX FIFO (128B), because the Target is unable
+	 * to push the 129th byte of data until AFTER the Host posts an
+	 * HIF Read and removes some FIFO data.  So for large reads the
+	 * Host proceeds to post an HIF Read BEFORE all the data is
+	 * actually available to read.  Fortunately, large BMI reads do
+	 * not occur in practice -- they're supported for debug/development.
+	 *
+	 * So Host/Target BMI synchronization is divided into these cases:
+	 *  CASE 1: length < 4
+	 *        Should not happen
+	 *
+	 *  CASE 2: 4 <= length <= 128
+	 *        Wait for first 4 bytes to be in FIFO
+	 *        If CONSERVATIVE_BMI_READ is enabled, also wait for
+	 *        a BMI command credit, which indicates that the ENTIRE
+	 *        response is available in the the FIFO
+	 *
+	 *  CASE 3: length > 128
+	 *        Wait for the first 4 bytes to be in FIFO
+	 *
+	 * For most uses, a small timeout should be sufficient and we will
+	 * usually see a response quickly; but there may be some unusual
+	 * (debug) cases of BMI_EXECUTE where we want an larger timeout.
+	 * For now, we use an unbounded busy loop while waiting for
+	 * BMI_EXECUTE.
+	 *
+	 * If BMI_EXECUTE ever needs to support longer-latency execution,
+	 * especially in production, this code needs to be enhanced to sleep
+	 * and yield.  Also note that BMI_COMMUNICATION_TIMEOUT is currently
+	 * a function of Host processor speed.
+	 */
+	if (len >= 4) { /* NB: Currently, always true */
+		ret = ath6kl_bmi_get_rx_lkahd(ar, want_timeout);
+		if (ret)
+			return ret;
+	}
+
+	addr = ar->mbox_info.htc_addr;
+	ret = ath6kl_sdio_read_write_sync(ar, addr, buf, len,
+				  HIF_RD_SYNC_BYTE_INC);
+	if (ret) {
+		ath6kl_err("Unable to read the bmi data from the device: %d\n",
+			   ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.read_write_sync = ath6kl_sdio_read_write_sync,
 	.write_async = ath6kl_sdio_write_async,
@@ -831,6 +993,8 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
 	.read_reg_diag = ath6kl_sdio_read_reg_diag,
 	.write_reg_diag = ath6kl_sdio_write_reg_diag,
+	.bmi_recv_buf = ath6kl_sdio_bmi_recv_buf,
+	.bmi_send_buf = ath6kl_sdio_bmi_send_buf,
 };
 
 static int ath6kl_sdio_probe(struct sdio_func *func,
-- 
1.7.0.4

