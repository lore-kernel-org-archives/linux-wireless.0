Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22352 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752702AbdDEHKC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:10:02 -0400
Subject: [PATCH 2/7] ath10k: add ath10k_sdio_writesb()
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 5 Apr 2017 10:06:39 +0300
Message-ID: <149137599947.4898.11552190369103872038.stgit@potku.adurom.net> (sfid-20170405_091008_536631_542C5C72)
In-Reply-To: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
References: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c |   85 +++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index c7bc86e5063f..56728d44dd12 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -287,6 +287,39 @@ static int ath10k_sdio_write32(struct ath10k *ar, u32 addr, u32 val)
 	return ret;
 }
 
+static int ath10k_sdio_writesb32(struct ath10k *ar, u32 addr, u32 val)
+{
+	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
+	struct sdio_func *func = ar_sdio->func;
+	__le32 *buf;
+	int ret;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	*buf = cpu_to_le32(val);
+
+	sdio_claim_host(func);
+
+	ret = sdio_writesb(func, addr, buf, sizeof(*buf));
+	if (ret) {
+		ath10k_warn(ar, "failed to write value 0x%x to fixed sb address 0x%x: %d\n",
+			    val, addr, ret);
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_SDIO, "sdio writesb32 addr 0x%x val 0x%x\n",
+		   addr, val);
+
+out:
+	sdio_release_host(func);
+
+	kfree(buf);
+
+	return ret;
+}
+
 static int ath10k_sdio_read32(struct ath10k *ar, u32 addr, u32 *val)
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
@@ -709,21 +742,16 @@ static int ath10k_sdio_mbox_proc_err_intr(struct ath10k *ar)
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
 	struct ath10k_sdio_irq_data *irq_data = &ar_sdio->irq_data;
-	u8 error_int_status, *reg_buf;
+	u8 error_int_status;
 	int ret;
 
-	reg_buf = kzalloc(4, GFP_KERNEL);
-	if (!reg_buf)
-		return -ENOMEM;
-
 	ath10k_dbg(ar, ATH10K_DBG_SDIO, "sdio error interrupt\n");
 
 	error_int_status = irq_data->irq_proc_reg->error_int_status & 0x0F;
 	if (!error_int_status) {
 		ath10k_warn(ar, "invalid error interrupt status: 0x%x\n",
 			    error_int_status);
-		ret = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_SDIO,
@@ -744,29 +772,25 @@ static int ath10k_sdio_mbox_proc_err_intr(struct ath10k *ar)
 	/* Clear the interrupt */
 	irq_data->irq_proc_reg->error_int_status &= ~error_int_status;
 
+	/* FIXME: is this correct? originally it was "reg_buf[0] =
+	 * error_int_status" and not sure if this is the same anymore */
 	/* set W1C value to clear the interrupt, this hits the register first */
-	reg_buf[0] = error_int_status;
-
-	ret = ath10k_sdio_read_write_sync(ar,
-					  MBOX_ERROR_INT_STATUS_ADDRESS,
-					  reg_buf, 4, HIF_WR_SYNC_BYTE_FIX);
+	ret = ath10k_sdio_writesb32(ar, MBOX_ERROR_INT_STATUS_ADDRESS,
+				    error_int_status);
 	if (ret) {
 		ath10k_warn(ar, "unable to write to error int status address: %d\n",
 			    ret);
-		goto out;
+		return ret;
 	}
 
-out:
-	kfree(reg_buf);
-
-	return ret;
+	return 0;
 }
 
 static int ath10k_sdio_mbox_proc_cpu_intr(struct ath10k *ar)
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
 	struct ath10k_sdio_irq_data *irq_data = &ar_sdio->irq_data;
-	u8 cpu_int_status, *reg_buf;
+	u8 cpu_int_status;
 	int ret;
 
 	mutex_lock(&irq_data->mtx);
@@ -781,32 +805,23 @@ static int ath10k_sdio_mbox_proc_cpu_intr(struct ath10k *ar)
 	/* Clear the interrupt */
 	irq_data->irq_proc_reg->cpu_int_status &= ~cpu_int_status;
 
-	/* Set up the register transfer buffer to hit the register 4 times ,
+	/* FIXME: is this correct? originally it was "reg_buf[0] =
+	 * cpu_int_status" and not sure if this is the same anymore */
+	/* Set up the register transfer buffer to hit the register 4 times,
 	 * this is done to make the access 4-byte aligned to mitigate issues
 	 * with host bus interconnects that restrict bus transfer lengths to
 	 * be a multiple of 4-bytes.
+	 *
+	 * Set W1C value to clear the interrupt, this hits the register first.
 	 */
-	reg_buf = kzalloc(4, GFP_KERNEL);
-	if (!reg_buf) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* set W1C value to clear the interrupt, this hits the register first */
-	reg_buf[0] = cpu_int_status;
-
-	ret = ath10k_sdio_read_write_sync(ar,
-					  MBOX_CPU_INT_STATUS_ADDRESS,
-					  reg_buf, 4, HIF_WR_SYNC_BYTE_FIX);
+	ret = ath10k_sdio_writesb32(ar, MBOX_CPU_INT_STATUS_ADDRESS,
+				    cpu_int_status);
 	if (ret) {
 		ath10k_warn(ar, "unable to write to cpu interrupt status address: %d\n",
 			    ret);
-		goto out_free;
+		goto out;
 	}
 
-out_free:
-	kfree(reg_buf);
-
 out:
 	mutex_unlock(&irq_data->mtx);
 	return ret;
