Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:47912 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:23:53 -0400
Subject: [PATCH 6/6] ath6kl: move remaining content from htc_hif.h to hif.h
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Oct 2011 12:23:49 +0300
Message-ID: <20111005092349.1095.92154.stgit@localhost6.localdomain6> (sfid-20111005_112355_826328_81B826DB)
In-Reply-To: <20111005092305.1095.713.stgit@localhost6.localdomain6>
References: <20111005092305.1095.713.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now htc_hif.h can be removed.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h   |    2 -
 drivers/net/wireless/ath/ath6kl/hif.c     |    2 -
 drivers/net/wireless/ath/ath6kl/hif.h     |   53 ++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/htc.c     |    2 -
 drivers/net/wireless/ath/ath6kl/htc_hif.h |   76 -----------------------------
 drivers/net/wireless/ath/ath6kl/sdio.c    |    2 -
 6 files changed, 57 insertions(+), 80 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.h

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 9288a3c..e3740b0 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -17,7 +17,7 @@
 #ifndef DEBUG_H
 #define DEBUG_H
 
-#include "htc_hif.h"
+#include "hif.h"
 
 enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_WLAN_CONNECT = BIT(0),     /* wlan connect */
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index 9f8271e..fb8058e 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -13,11 +13,11 @@
  * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
+#include "hif.h"
 
 #include "core.h"
 #include "target.h"
 #include "hif-ops.h"
-#include "htc_hif.h"
 #include "debug.h"
 
 #define MAILBOX_FOR_BLOCK_SIZE          1
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 906fde9..93d2912 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -59,6 +59,16 @@
 /* mode to enable special 4-bit interrupt assertion without clock */
 #define SDIO_IRQ_MODE_ASYNC_4BIT_IRQ   (1 << 0)
 
+/* HTC runs over mailbox 0 */
+#define HTC_MAILBOX	0
+
+#define ATH6KL_TARGET_DEBUG_INTR_MASK     0x01
+
+/* FIXME: are these duplicates with MAX_SCATTER_ values in hif.h? */
+#define ATH6KL_SCATTER_ENTRIES_PER_REQ            16
+#define ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER      (16 * 1024)
+#define ATH6KL_SCATTER_REQS                       4
+
 struct bus_request {
 	struct list_head list;
 
@@ -186,6 +196,34 @@ struct hif_scatter_req {
 	struct hif_scatter_item scat_list[1];
 };
 
+struct ath6kl_irq_proc_registers {
+	u8 host_int_status;
+	u8 cpu_int_status;
+	u8 error_int_status;
+	u8 counter_int_status;
+	u8 mbox_frame;
+	u8 rx_lkahd_valid;
+	u8 host_int_status2;
+	u8 gmbox_rx_avail;
+	__le32 rx_lkahd[2];
+	__le32 rx_gmbox_lkahd_alias[2];
+} __packed;
+
+struct ath6kl_irq_enable_reg {
+	u8 int_status_en;
+	u8 cpu_int_status_en;
+	u8 err_int_status_en;
+	u8 cntr_int_status_en;
+} __packed;
+
+struct ath6kl_device {
+	spinlock_t lock;
+	struct ath6kl_irq_proc_registers irq_proc_reg;
+	struct ath6kl_irq_enable_reg irq_en_reg;
+	struct htc_target *htc_cnxt;
+	struct ath6kl *ar;
+};
+
 struct ath6kl_hif_ops {
 	int (*read_write_sync)(struct ath6kl *ar, u32 addr, u8 *buf,
 			       u32 len, u32 request);
@@ -206,4 +244,19 @@ struct ath6kl_hif_ops {
 	int (*resume)(struct ath6kl *ar);
 };
 
+int ath6kl_hif_setup(struct ath6kl_device *dev);
+int ath6kl_hif_unmask_intrs(struct ath6kl_device *dev);
+int ath6kl_hif_mask_intrs(struct ath6kl_device *dev);
+int ath6kl_hif_poll_mboxmsg_rx(struct ath6kl_device *dev,
+			       u32 *lk_ahd, int timeout);
+int ath6kl_hif_rx_control(struct ath6kl_device *dev, bool enable_rx);
+int ath6kl_hif_disable_intrs(struct ath6kl_device *dev);
+
+int ath6kl_hif_rw_comp_handler(void *context, int status);
+int ath6kl_hif_intr_bh_handler(struct ath6kl *ar);
+
+/* Scatter Function and Definitions */
+int ath6kl_hif_submit_scat_req(struct ath6kl_device *dev,
+			       struct hif_scatter_req *scat_req, bool read);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index f141dcc..7ab3e53 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -15,7 +15,7 @@
  */
 
 #include "core.h"
-#include "htc_hif.h"
+#include "hif.h"
 #include "debug.h"
 #include "hif-ops.h"
 #include <asm/unaligned.h>
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
deleted file mode 100644
index a8a6de5..0000000
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * Copyright (c) 2007-2011 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef HTC_HIF_H
-#define HTC_HIF_H
-
-#include "htc.h"
-#include "hif.h"
-
-/* HTC runs over mailbox 0 */
-#define HTC_MAILBOX	0
-
-#define ATH6KL_TARGET_DEBUG_INTR_MASK     0x01
-
-/* FIXME: are these duplicates with MAX_SCATTER_ values in hif.h? */
-#define ATH6KL_SCATTER_ENTRIES_PER_REQ            16
-#define ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER      (16 * 1024)
-#define ATH6KL_SCATTER_REQS                       4
-
-struct ath6kl_irq_proc_registers {
-	u8 host_int_status;
-	u8 cpu_int_status;
-	u8 error_int_status;
-	u8 counter_int_status;
-	u8 mbox_frame;
-	u8 rx_lkahd_valid;
-	u8 host_int_status2;
-	u8 gmbox_rx_avail;
-	__le32 rx_lkahd[2];
-	__le32 rx_gmbox_lkahd_alias[2];
-} __packed;
-
-struct ath6kl_irq_enable_reg {
-	u8 int_status_en;
-	u8 cpu_int_status_en;
-	u8 err_int_status_en;
-	u8 cntr_int_status_en;
-} __packed;
-
-struct ath6kl_device {
-	spinlock_t lock;
-	struct ath6kl_irq_proc_registers irq_proc_reg;
-	struct ath6kl_irq_enable_reg irq_en_reg;
-	struct htc_target *htc_cnxt;
-	struct ath6kl *ar;
-};
-
-int ath6kl_hif_setup(struct ath6kl_device *dev);
-int ath6kl_hif_unmask_intrs(struct ath6kl_device *dev);
-int ath6kl_hif_mask_intrs(struct ath6kl_device *dev);
-int ath6kl_hif_poll_mboxmsg_rx(struct ath6kl_device *dev,
-			       u32 *lk_ahd, int timeout);
-int ath6kl_hif_rx_control(struct ath6kl_device *dev, bool enable_rx);
-int ath6kl_hif_disable_intrs(struct ath6kl_device *dev);
-
-int ath6kl_hif_rw_comp_handler(void *context, int status);
-int ath6kl_hif_intr_bh_handler(struct ath6kl *ar);
-
-/* Scatter Function and Definitions */
-int ath6kl_hif_submit_scat_req(struct ath6kl_device *dev,
-			       struct hif_scatter_req *scat_req, bool read);
-
-#endif /*ATH6KL_H_ */
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 5b1df82..2394c17 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -21,7 +21,7 @@
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sd.h>
-#include "htc_hif.h"
+#include "hif.h"
 #include "hif-ops.h"
 #include "target.h"
 #include "debug.h"

