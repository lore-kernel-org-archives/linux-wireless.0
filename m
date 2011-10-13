Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:36586 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1JMMV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 08:21:57 -0400
Subject: [PATCH 4/4] ath6kl: add debug level for hif
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Oct 2011 15:21:53 +0300
Message-ID: <20111013122153.30551.80262.stgit@localhost6.localdomain6> (sfid-20111013_142201_789946_B246D9F2)
In-Reply-To: <20111013122115.30551.94.stgit@localhost6.localdomain6>
References: <20111013122115.30551.94.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That way we htc level debug messages can be removed from hif files. Also
add few new messages and remove useless debug message about using
synchrous irq processing (we don't support anything else).

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/hif-ops.h |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/hif.c     |   17 ++++++++---------
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 01f4015..cbabc25 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -26,7 +26,7 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_WLAN_RX      = BIT(3),     /* wlan rx */
 	ATH6KL_DBG_BMI		= BIT(4),     /* bmi tracing */
 	ATH6KL_DBG_HTC		= BIT(5),
-	/* hole */
+	ATH6KL_DBG_HIF		= BIT(6),
 	ATH6KL_DBG_IRQ		= BIT(7),     /* interrupt processing */
 	ATH6KL_DBG_PM           = BIT(8),     /* power management */
 	ATH6KL_DBG_WLAN_NODE    = BIT(9),     /* general wlan node tracing */
diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index 21b1575..95e7303 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -18,10 +18,16 @@
 #define HIF_OPS_H
 
 #include "hif.h"
+#include "debug.h"
 
 static inline int hif_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 				      u32 len, u32 request)
 {
+	ath6kl_dbg(ATH6KL_DBG_HIF,
+		   "hif %s sync addr 0x%x buf 0x%p len %d request 0x%x\n",
+		   (request & HIF_WRITE) ? "write" : "read",
+		   addr, buf, len, request);
+
 	return ar->hif_ops->read_write_sync(ar, addr, buf, len, request);
 }
 
@@ -29,16 +35,24 @@ static inline int hif_write_async(struct ath6kl *ar, u32 address, u8 *buffer,
 				  u32 length, u32 request,
 				  struct htc_packet *packet)
 {
+	ath6kl_dbg(ATH6KL_DBG_HIF,
+		   "hif write async addr 0x%x buf 0x%p len %d request 0x%x\n",
+		   address, buffer, length, request);
+
 	return ar->hif_ops->write_async(ar, address, buffer, length,
 					request, packet);
 }
 static inline void ath6kl_hif_irq_enable(struct ath6kl *ar)
 {
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif irq enable\n");
+
 	return ar->hif_ops->irq_enable(ar);
 }
 
 static inline void ath6kl_hif_irq_disable(struct ath6kl *ar)
 {
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif irq disable\n");
+
 	return ar->hif_ops->irq_disable(ar);
 }
 
@@ -71,11 +85,15 @@ static inline void ath6kl_hif_cleanup_scatter(struct ath6kl *ar)
 
 static inline int ath6kl_hif_suspend(struct ath6kl *ar)
 {
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif suspend\n");
+
 	return ar->hif_ops->suspend(ar);
 }
 
 static inline int ath6kl_hif_resume(struct ath6kl *ar)
 {
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif resume\n");
+
 	return ar->hif_ops->resume(ar);
 }
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index 7cc6cec..e2d8088 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -51,8 +51,7 @@ int ath6kl_hif_rw_comp_handler(void *context, int status)
 {
 	struct htc_packet *packet = context;
 
-	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "ath6kl_hif_rw_comp_handler (pkt:0x%p , status: %d\n",
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif rw completion pkt 0x%p status %d\n",
 		   packet, status);
 
 	packet->status = status;
@@ -119,7 +118,7 @@ int ath6kl_hif_poll_mboxmsg_rx(struct ath6kl_device *dev, u32 *lk_ahd,
 
 		/* delay a little  */
 		mdelay(ATH6KL_TIME_QUANTUM);
-		ath6kl_dbg(ATH6KL_DBG_HTC, "retry mbox poll : %d\n", i);
+		ath6kl_dbg(ATH6KL_DBG_HIF, "hif retry mbox poll try %d\n", i);
 	}
 
 	if (i == 0) {
@@ -147,6 +146,9 @@ int ath6kl_hif_rx_control(struct ath6kl_device *dev, bool enable_rx)
 	struct ath6kl_irq_enable_reg regs;
 	int status = 0;
 
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif rx %s\n",
+		   enable_rx ? "enable" : "disable");
+
 	/* take the lock to protect interrupt enable shadows */
 	spin_lock_bh(&dev->lock);
 
@@ -186,8 +188,8 @@ int ath6kl_hif_submit_scat_req(struct ath6kl_device *dev,
 			dev->ar->mbox_info.htc_addr;
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "ath6kl_hif_submit_scat_req, entries: %d, total len: %d mbox:0x%X (mode: %s : %s)\n",
+	ath6kl_dbg(ATH6KL_DBG_HIF,
+		   "hif submit scatter request entries %d len %d mbox 0x%x %s %s\n",
 		   scat_req->scat_entries, scat_req->len,
 		   scat_req->addr, !read ? "async" : "sync",
 		   (read) ? "rd" : "wr");
@@ -629,12 +631,9 @@ int ath6kl_hif_setup(struct ath6kl_device *dev)
 	/* assemble mask, used for padding to a block */
 	dev->htc_cnxt->block_mask = dev->htc_cnxt->block_sz - 1;
 
-	ath6kl_dbg(ATH6KL_DBG_TRC, "block size: %d, mbox addr:0x%X\n",
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif block size %d mbox addr 0x%x\n",
 		   dev->htc_cnxt->block_sz, dev->ar->mbox_info.htc_addr);
 
-	ath6kl_dbg(ATH6KL_DBG_TRC,
-		   "hif interrupt processing is sync only\n");
-
 	status = ath6kl_hif_disable_intrs(dev);
 
 fail_setup:

