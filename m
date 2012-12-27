Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:42530 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2L0Lw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 06:52:57 -0500
Subject: [PATCH 2/7] ath6kl: add tracing points for sdio transfers
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com
Date: Thu, 27 Dec 2012 13:44:30 +0200
Message-ID: <20121227114430.27069.9849.stgit@localhost6.localdomain6> (sfid-20121227_125304_397419_424F7D8C)
In-Reply-To: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tracing points for sdio transfers, just dump the address, flags and the
buffer.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c  |   22 ++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/trace.c |    5 ++++
 drivers/net/wireless/ath/ath6kl/trace.h |   41 +++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index d111980..df2131d 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -28,6 +28,7 @@
 #include "target.h"
 #include "debug.h"
 #include "cfg80211.h"
+#include "trace.h"
 
 struct ath6kl_sdio {
 	struct sdio_func *func;
@@ -179,6 +180,11 @@ static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 		   request & HIF_FIXED_ADDRESS ? " (fixed)" : "", buf, len);
 	ath6kl_dbg_dump(ATH6KL_DBG_SDIO_DUMP, NULL, "sdio ", buf, len);
 
+	if (request & HIF_WRITE)
+		trace_ath6kl_sdio_wr(addr, request, buf, len);
+	else
+		trace_ath6kl_sdio_rd(addr, request, buf, len);
+
 	return ret;
 }
 
@@ -260,7 +266,7 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	struct mmc_data data;
 	struct hif_scatter_req *scat_req;
 	u8 opcode, rw;
-	int status, len;
+	int status, len, i;
 
 	scat_req = req->scat_req;
 
@@ -309,6 +315,20 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	sdio_claim_host(ar_sdio->func);
 
 	mmc_set_data_timeout(&data, ar_sdio->func->card);
+
+	for (i = 0; i < scat_req->scat_entries; i++) {
+		if (scat_req->req & HIF_WRITE)
+			trace_ath6kl_sdio_wr(scat_req->addr,
+					     scat_req->req,
+					     scat_req->scat_list[i].buf,
+					     scat_req->scat_list[i].len);
+		else
+			trace_ath6kl_sdio_rd(scat_req->addr,
+					     scat_req->req,
+					     scat_req->scat_list[i].buf,
+					     scat_req->scat_list[i].len);
+	}
+
 	/* synchronous call to process request */
 	mmc_wait_for_req(ar_sdio->func->card->host, &mmc_req);
 
diff --git a/drivers/net/wireless/ath/ath6kl/trace.c b/drivers/net/wireless/ath/ath6kl/trace.c
index 4118a29..adc74a0 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.c
+++ b/drivers/net/wireless/ath/ath6kl/trace.c
@@ -14,5 +14,10 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/module.h>
+
 #define CREATE_TRACE_POINTS
 #include "trace.h"
+
+EXPORT_TRACEPOINT_SYMBOL(ath6kl_sdio_wr);
+EXPORT_TRACEPOINT_SYMBOL(ath6kl_sdio_rd);
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index 0787619..be2e4e2 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -75,6 +75,47 @@ TRACE_EVENT(ath6kl_wmi_event,
 	)
 );
 
+/* FIXME: add sg count */
+DECLARE_EVENT_CLASS(ath6kl_sdio_transaction,
+	TP_PROTO(unsigned int addr, int flags,
+		 void *buf, size_t buf_len),
+
+	TP_ARGS(addr, flags, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, addr)
+		__field(int, flags)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->addr = addr;
+		__entry->flags = flags;
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"addr 0x%x flags 0x%x len %d\n",
+		__entry->addr,
+		__entry->flags,
+		__entry->buf_len
+	)
+);
+
+DEFINE_EVENT(ath6kl_sdio_transaction, ath6kl_sdio_wr,
+	TP_PROTO(unsigned int addr, int flags,
+		 void *buf, size_t buf_len),
+	TP_ARGS(addr, flags, buf, buf_len)
+);
+
+DEFINE_EVENT(ath6kl_sdio_transaction, ath6kl_sdio_rd,
+	TP_PROTO(unsigned int addr, int flags,
+		 void *buf, size_t buf_len),
+	TP_ARGS(addr, flags, buf, buf_len)
+);
+
 #endif /* _ ATH6KL_TRACE_H || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */

