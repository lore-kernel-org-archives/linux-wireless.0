Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46531 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbdDEHLL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:11:11 -0400
Subject: [PATCH 4/7] ath10k: add ath10k_sdio_write()
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 5 Apr 2017 10:07:08 +0300
Message-ID: <149137602808.4898.9375951462565501167.stgit@potku.adurom.net> (sfid-20170405_091134_220373_0977FD46)
In-Reply-To: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
References: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c |   48 +++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index bbd8317de861..beb1749672f0 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -368,6 +368,34 @@ static int ath10k_sdio_read(struct ath10k *ar, u32 addr, void *buf, size_t len)
 	return ret;
 }
 
+static int ath10k_sdio_write(struct ath10k *ar, u32 addr, const void *buf, size_t len)
+{
+	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
+	struct sdio_func *func = ar_sdio->func;
+	int ret;
+
+	sdio_claim_host(func);
+
+	/* For some reason toio() doesn't have const for the buffer, need
+	 * an ugly hack to workaround that.
+	 */
+	ret = sdio_memcpy_toio(func, addr, (void *)buf, len);
+	if (ret) {
+		ath10k_warn(ar, "failed to write to address 0x%x: %d\n",
+			    addr, ret);
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_SDIO, "sdio write addr 0x%x buf 0x%p len %zu\n",
+		   addr, buf, len);
+	ath10k_dbg_dump(ar, ATH10K_DBG_SDIO_DUMP, NULL, "sdio write ", buf, len);
+
+out:
+	sdio_release_host(func);
+
+	return ret;
+}
+
 /* HIF mbox functions */
 
 static int ath10k_sdio_mbox_rx_process_packet(struct ath10k *ar,
@@ -1131,9 +1159,7 @@ static int ath10k_sdio_bmi_exchange_msg(struct ath10k *ar,
 		addr = ar_sdio->mbox_info.htc_addr;
 
 		memcpy(ar_sdio->bmi_buf, req, req_len);
-		ret = ath10k_sdio_read_write_sync(ar, addr, ar_sdio->bmi_buf,
-						  req_len,
-						  HIF_WR_SYNC_BYTE_INC);
+		ret = ath10k_sdio_write(ar, addr, ar_sdio->bmi_buf, req_len);
 		if (ret) {
 			ath10k_warn(ar,
 				    "unable to send the bmi data to the device: %d\n",
@@ -1361,10 +1387,8 @@ static int ath10k_sdio_hif_disable_intrs(struct ath10k *ar)
 	mutex_lock(&irq_data->mtx);
 
 	memset(regs, 0, sizeof(*regs));
-	ret = ath10k_sdio_read_write_sync(ar,
-					  MBOX_INT_STATUS_ENABLE_ADDRESS,
-					  &regs->int_status_en, sizeof(*regs),
-					  HIF_WR_SYNC_BYTE_INC);
+	ret = ath10k_sdio_write(ar, MBOX_INT_STATUS_ENABLE_ADDRESS,
+				&regs->int_status_en, sizeof(*regs));
 	if (ret)
 		ath10k_warn(ar, "unable to disable sdio interrupts: %d\n", ret);
 
@@ -1498,10 +1522,8 @@ static int ath10k_sdio_hif_enable_intrs(struct ath10k *ar)
 		FIELD_PREP(MBOX_COUNTER_INT_STATUS_ENABLE_BIT_MASK,
 			   ATH10K_SDIO_TARGET_DEBUG_INTR_MASK);
 
-	ret = ath10k_sdio_read_write_sync(ar,
-					  MBOX_INT_STATUS_ENABLE_ADDRESS,
-					  &regs->int_status_en, sizeof(*regs),
-					  HIF_WR_SYNC_BYTE_INC);
+	ret = ath10k_sdio_write(ar, MBOX_INT_STATUS_ENABLE_ADDRESS,
+				&regs->int_status_en, sizeof(*regs));
 	if (ret)
 		ath10k_warn(ar,
 			    "failed to update mbox interrupt status register : %d\n",
@@ -1596,9 +1618,7 @@ static int ath10k_sdio_hif_diag_write_mem(struct ath10k *ar, u32 address,
 	int ret;
 
 	/* set write data */
-	ret = ath10k_sdio_read_write_sync(ar, MBOX_WINDOW_DATA_ADDRESS,
-					  (u8 *)data, nbytes,
-					  HIF_WR_SYNC_BYTE_INC);
+	ret = ath10k_sdio_write(ar, MBOX_WINDOW_DATA_ADDRESS, data, nbytes);
 	if (ret) {
 		ath10k_warn(ar,
 			    "failed to write 0x%p to mbox window data addrress: %d\n",
