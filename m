Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52906 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752967AbdDEHIA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:08:00 -0400
Subject: [PATCH 7/7] ath10k: remove unused sdio wrappers
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 5 Apr 2017 10:07:49 +0300
Message-ID: <149137606916.4898.873080560482504845.stgit@potku.adurom.net> (sfid-20170405_090804_690261_39189D18)
In-Reply-To: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
References: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c |   44 --------------------------------
 drivers/net/wireless/ath/ath10k/sdio.h |   35 -------------------------
 2 files changed, 79 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 8ea1629c7bae..a5ed4282b3b3 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -219,50 +219,6 @@ static int ath10k_sdio_config(struct ath10k *ar)
 	return ret;
 }
 
-static int ath10k_sdio_io(struct ath10k *ar, u32 request, u32 addr,
-			  u8 *buf, u32 len)
-{
-	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
-	struct sdio_func *func = ar_sdio->func;
-	int ret;
-
-	sdio_claim_host(func);
-
-	if (request & HIF_WRITE) {
-		if (request & HIF_FIXED_ADDRESS)
-			ret = sdio_writesb(func, addr, buf, len);
-		else
-			ret = sdio_memcpy_toio(func, addr, buf, len);
-	} else {
-		if (request & HIF_FIXED_ADDRESS)
-			ret = sdio_readsb(func, buf, addr, len);
-		else
-			ret = sdio_memcpy_fromio(func, buf, addr, len);
-	}
-
-	sdio_release_host(func);
-
-	ath10k_dbg(ar, ATH10K_DBG_SDIO, "sdio %s addr 0x%x%s buf 0x%p len %d\n",
-		   request & HIF_WRITE ? "wr" : "rd", addr,
-		   request & HIF_FIXED_ADDRESS ? " (fixed)" : "", buf, len);
-	ath10k_dbg_dump(ar, ATH10K_DBG_SDIO_DUMP, NULL,
-			request & HIF_WRITE ? "sdio wr " : "sdio rd ",
-			buf, len);
-
-	return ret;
-}
-
-static int ath10k_sdio_read_write_sync(struct ath10k *ar, u32 addr, u8 *buf,
-				       u32 len, u32 request)
-{
-	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
-
-	if (request & HIF_BLOCK_BASIS)
-		len = round_down(len, ar_sdio->mbox_info.block_size);
-
-	return ath10k_sdio_io(ar, request, addr, buf, len);
-}
-
 static int ath10k_sdio_write32(struct ath10k *ar, u32 addr, u32 val)
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
diff --git a/drivers/net/wireless/ath/ath10k/sdio.h b/drivers/net/wireless/ath/ath10k/sdio.h
index 1bce56447e53..62d2699123ec 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.h
+++ b/drivers/net/wireless/ath/ath10k/sdio.h
@@ -136,41 +136,6 @@ struct ath10k_sdio_rx_data {
 	int status;
 };
 
-/* direction of transfer (read/write) */
-#define HIF_READ                    0x00000001
-#define HIF_WRITE                   0x00000002
-
-/*     dmode - An interface may support different kinds of commands based on
- *             the tradeoff between the amount of data it can carry and the
- *             setup time. Byte and Block modes are supported (HIF_BYTE_BASIS/
- *             HIF_BLOCK_BASIS). In case of latter, the data is rounded off
- *             to the nearest block size by padding. The size of the block is
- *             configurable at compile time using the HIF_BLOCK_SIZE and is
- *             negotiated with the target during initialization after the
- *             ATH10K interrupts are enabled.
- */
-#define HIF_BYTE_BASIS              0x00000040
-#define HIF_BLOCK_BASIS             0x00000080
-
-/*     amode - This indicates if the address has to be incremented on ATH10K
- *             after every read/write operation (HIF?FIXED_ADDRESS/
- *             HIF_INCREMENTAL_ADDRESS).
- */
-#define HIF_FIXED_ADDRESS           0x00000100
-#define HIF_INCREMENTAL_ADDRESS     0x00000200
-
-#define HIF_WR_SYNC_BYTE_FIX					\
-	(HIF_WRITE | HIF_BYTE_BASIS | HIF_FIXED_ADDRESS)
-
-#define HIF_WR_SYNC_BYTE_INC					\
-	(HIF_WRITE | HIF_BYTE_BASIS | HIF_INCREMENTAL_ADDRESS)
-
-#define HIF_RD_SYNC_BYTE_INC						\
-	(HIF_READ | HIF_BYTE_BASIS | HIF_INCREMENTAL_ADDRESS)
-
-#define HIF_RD_SYNC_BLOCK_FIX						\
-	(HIF_READ | HIF_BLOCK_BASIS | HIF_FIXED_ADDRESS)
-
 struct ath10k_sdio_irq_proc_regs {
 	u8 host_int_status;
 	u8 cpu_int_status;
