Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:44837 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3CINFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 08:05:25 -0500
Subject: [PATCH v2 3/7] ath6kl: add tracing point for hif irqs
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 15:05:22 +0200
Message-ID: <20130309130522.13371.87977.stgit@localhost6.localdomain6> (sfid-20130309_140529_360719_73A68F2D)
In-Reply-To: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
References: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a tracing point for hif irq and dump the register content to user space.
This is in hif.c as we could use the same code also with SPI but, as ath6kl
doesn't SPI and most likely never will be, this is used just by SDIO so
name the trace point as ath6kl_sdio_irq to make it easier to manage filters.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.c   |    3 +++
 drivers/net/wireless/ath/ath6kl/trace.h |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index a6b6144..fea7709 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -22,6 +22,7 @@
 #include "target.h"
 #include "hif-ops.h"
 #include "debug.h"
+#include "trace.h"
 
 #define MAILBOX_FOR_BLOCK_SIZE          1
 
@@ -436,6 +437,8 @@ static int proc_pending_irqs(struct ath6kl_device *dev, bool *done)
 
 		ath6kl_dump_registers(dev, &dev->irq_proc_reg,
 				      &dev->irq_en_reg);
+		trace_ath6kl_sdio_irq(&dev->irq_en_reg,
+				      sizeof(dev->irq_en_reg));
 
 		/* Update only those registers that are enabled */
 		host_int_status = dev->irq_proc_reg.host_int_status &
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index 9db616c..541729b 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -165,6 +165,26 @@ TRACE_EVENT(ath6kl_sdio_scat,
 	)
 );
 
+TRACE_EVENT(ath6kl_sdio_irq,
+	TP_PROTO(void *buf, size_t buf_len),
+
+	TP_ARGS(buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"irq len %d\n", __entry->buf_len
+	)
+);
+
 #endif /* _ ATH6KL_TRACE_H || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */

