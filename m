Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:36174 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1I0LbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:31:08 -0400
Subject: [PATCH 2/4] ath6kl: add sdio debug messages
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Sep 2011 14:30:58 +0300
Message-ID: <20110927113058.11592.98540.stgit@localhost6.localdomain6> (sfid-20110927_133112_462555_C94AA2B5)
In-Reply-To: <20110927113045.11592.15974.stgit@localhost6.localdomain6>
References: <20110927113045.11592.15974.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add extensive debug messages to sdio.c. Makes it easier to debug
various problems.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |    2 ++
 drivers/net/wireless/ath/ath6kl/sdio.c  |   36 +++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 3730e09..63eb1c1 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -36,6 +36,8 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_WLAN_CFG     = BIT(13),    /* cfg80211 i/f file tracing */
 	ATH6KL_DBG_RAW_BYTES    = BIT(14),    /* dump tx/rx and wmi frames */
 	ATH6KL_DBG_AGGR		= BIT(15),    /* aggregation */
+	ATH6KL_DBG_SDIO		= BIT(16),
+	ATH6KL_DBG_SDIO_DUMP	= BIT(17),
 	ATH6KL_DBG_ANY	        = 0xffffffff  /* enable all logs */
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 4724ddf..f1dc311 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -135,10 +135,12 @@ static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 	int ret = 0;
 
 	if (request & HIF_WRITE) {
+		/* FIXME: looks like ugly workaround for something */
 		if (addr >= HIF_MBOX_BASE_ADDR &&
 		    addr <= HIF_MBOX_END_ADDR)
 			addr += (HIF_MBOX_WIDTH - len);
 
+		/* FIXME: this also looks like ugly workaround */
 		if (addr == HIF_MBOX0_EXT_BASE_ADDR)
 			addr += HIF_MBOX0_EXT_WIDTH - len;
 
@@ -153,6 +155,11 @@ static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 			ret = sdio_memcpy_fromio(func, buf, addr, len);
 	}
 
+	ath6kl_dbg(ATH6KL_DBG_SDIO, "%s addr 0x%x%s buf 0x%p len %d\n",
+		   request & HIF_WRITE ? "wr" : "rd", addr,
+		   request & HIF_FIXED_ADDRESS ? " (fixed)" : "", buf, len);
+	ath6kl_dbg_dump(ATH6KL_DBG_SDIO_DUMP, NULL, "sdio ", buf, len);
+
 	return ret;
 }
 
@@ -173,7 +180,8 @@ static struct bus_request *ath6kl_sdio_alloc_busreq(struct ath6kl_sdio *ar_sdio)
 	list_del(&bus_req->list);
 
 	spin_unlock_irqrestore(&ar_sdio->lock, flag);
-	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: bus request 0x%p\n", __func__, bus_req);
+	ath6kl_dbg(ATH6KL_DBG_SCATTER, "%s: bus request 0x%p\n",
+		   __func__, bus_req);
 
 	return bus_req;
 }
@@ -183,7 +191,8 @@ static void ath6kl_sdio_free_bus_req(struct ath6kl_sdio *ar_sdio,
 {
 	unsigned long flag;
 
-	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: bus request 0x%p\n", __func__, bus_req);
+	ath6kl_dbg(ATH6KL_DBG_SCATTER, "%s: bus request 0x%p\n",
+		   __func__, bus_req);
 
 	spin_lock_irqsave(&ar_sdio->lock, flag);
 	list_add_tail(&bus_req->list, &ar_sdio->bus_req_freeq);
@@ -438,6 +447,8 @@ static void ath6kl_sdio_irq_handler(struct sdio_func *func)
 	int status;
 	struct ath6kl_sdio *ar_sdio;
 
+	ath6kl_dbg(ATH6KL_DBG_SDIO, "irq\n");
+
 	ar_sdio = sdio_get_drvdata(func);
 	atomic_set(&ar_sdio->irq_handling, 1);
 
@@ -675,7 +686,7 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 				MAX_SCATTER_REQUESTS, virt_scat);
 
 		if (!ret) {
-			ath6kl_dbg(ATH6KL_DBG_ANY,
+			ath6kl_dbg(ATH6KL_DBG_SCATTER,
 				   "hif-scatter enabled: max scatter req : %d entries: %d\n",
 				   MAX_SCATTER_REQUESTS,
 				   MAX_SCATTER_ENTRIES_PER_REQ);
@@ -700,7 +711,7 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 			return ret;
 		}
 
-		ath6kl_dbg(ATH6KL_DBG_ANY,
+		ath6kl_dbg(ATH6KL_DBG_SCATTER,
 			   "Vitual scatter enabled, max_scat_req:%d, entries:%d\n",
 			   ATH6KL_SCATTER_REQS, ATH6KL_SCATTER_ENTRIES_PER_REQ);
 
@@ -723,6 +734,9 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 
 	if (!(flags & MMC_PM_KEEP_POWER))
 		/* as host doesn't support keep power we need to bail out */
+		ath6kl_dbg(ATH6KL_DBG_SDIO,
+			   "func %d doesn't support MMC_PM_KEEP_POWER\n",
+			   func->num);
 		return -EINVAL;
 
 	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
@@ -758,10 +772,10 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	struct ath6kl *ar;
 	int count;
 
-	ath6kl_dbg(ATH6KL_DBG_TRC,
-		   "%s: func: 0x%X, vendor id: 0x%X, dev id: 0x%X, block size: 0x%X/0x%X\n",
-		   __func__, func->num, func->vendor,
-		   func->device, func->max_blksize, func->cur_blksize);
+	ath6kl_dbg(ATH6KL_DBG_SDIO,
+		   "new func %d vendor 0x%x device 0x%x block 0x%x/0x%x\n",
+		   func->num, func->vendor, func->device,
+		   func->max_blksize, func->cur_blksize);
 
 	ar_sdio = kzalloc(sizeof(struct ath6kl_sdio), GFP_KERNEL);
 	if (!ar_sdio)
@@ -820,7 +834,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 			goto err_cfg80211;
 		}
 
-		ath6kl_dbg(ATH6KL_DBG_TRC, "4-bit async irq mode enabled\n");
+		ath6kl_dbg(ATH6KL_DBG_SDIO, "4-bit async irq mode enabled\n");
 	}
 
 	/* give us some time to enable, in ms */
@@ -868,6 +882,10 @@ static void ath6kl_sdio_remove(struct sdio_func *func)
 {
 	struct ath6kl_sdio *ar_sdio;
 
+	ath6kl_dbg(ATH6KL_DBG_SDIO,
+		   "removed func %d vendor 0x%x device 0x%x\n",
+		   func->num, func->vendor, func->device);
+
 	ar_sdio = sdio_get_drvdata(func);
 
 	ath6kl_stop_txrx(ar_sdio->ar);

