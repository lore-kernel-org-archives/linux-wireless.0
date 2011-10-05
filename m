Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:49788 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:23:46 -0400
Subject: [PATCH 5/6] ath6kl: remove unused values from htc_hif.h
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Oct 2011 12:23:42 +0300
Message-ID: <20111005092341.1095.47805.stgit@localhost6.localdomain6> (sfid-20111005_112348_374280_F413AB8C)
In-Reply-To: <20111005092305.1095.713.stgit@localhost6.localdomain6>
References: <20111005092305.1095.713.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also remove some cache line optimisation. It was using hardcoded values
which is wrong.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_hif.h |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index 5572c23..a8a6de5 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -20,29 +20,16 @@
 #include "htc.h"
 #include "hif.h"
 
-#define ATH6KL_MAILBOXES	4
-
 /* HTC runs over mailbox 0 */
 #define HTC_MAILBOX	0
 
 #define ATH6KL_TARGET_DEBUG_INTR_MASK     0x01
 
-#define OTHER_INTS_ENABLED		(INT_STATUS_ENABLE_ERROR_MASK |	\
-					INT_STATUS_ENABLE_CPU_MASK   |	\
-					INT_STATUS_ENABLE_COUNTER_MASK)
-
-#define ATH6KL_REG_IO_BUFFER_SIZE			32
-#define ATH6KL_MAX_REG_IO_BUFFERS			8
+/* FIXME: are these duplicates with MAX_SCATTER_ values in hif.h? */
 #define ATH6KL_SCATTER_ENTRIES_PER_REQ            16
 #define ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER      (16 * 1024)
 #define ATH6KL_SCATTER_REQS                       4
 
-#ifndef A_CACHE_LINE_PAD
-#define A_CACHE_LINE_PAD                        128
-#endif
-#define ATH6KL_MIN_SCATTER_ENTRIES_PER_REQ        2
-#define ATH6KL_MIN_TRANSFER_SIZE_PER_SCATTER      (4 * 1024)
-
 struct ath6kl_irq_proc_registers {
 	u8 host_int_status;
 	u8 cpu_int_status;
@@ -65,11 +52,8 @@ struct ath6kl_irq_enable_reg {
 
 struct ath6kl_device {
 	spinlock_t lock;
-	u8 pad1[A_CACHE_LINE_PAD];
 	struct ath6kl_irq_proc_registers irq_proc_reg;
-	u8 pad2[A_CACHE_LINE_PAD];
 	struct ath6kl_irq_enable_reg irq_en_reg;
-	u8 pad3[A_CACHE_LINE_PAD];
 	struct htc_target *htc_cnxt;
 	struct ath6kl *ar;
 };

