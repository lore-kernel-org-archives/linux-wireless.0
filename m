Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:37237 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3CINFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 08:05:18 -0500
Subject: [PATCH v2 2/7] ath6kl: add tracing points for sdio transfers
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 15:05:13 +0200
Message-ID: <20130309130513.13371.64139.stgit@localhost6.localdomain6> (sfid-20130309_140524_695387_68D552E5)
In-Reply-To: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
References: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tracing points for sdio transfers, just dump the address, flags and the
buffer.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c  |   10 +++
 drivers/net/wireless/ath/ath6kl/trace.c |    5 ++
 drivers/net/wireless/ath/ath6kl/trace.h |   90 +++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 0bd8ff6..fb14145 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -28,6 +28,7 @@
 #include "target.h"
 #include "debug.h"
 #include "cfg80211.h"
+#include "trace.h"
 
 struct ath6kl_sdio {
 	struct sdio_func *func;
@@ -179,6 +180,8 @@ static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 		   request & HIF_FIXED_ADDRESS ? " (fixed)" : "", buf, len);
 	ath6kl_dbg_dump(ATH6KL_DBG_SDIO_DUMP, NULL, "sdio ", buf, len);
 
+	trace_ath6kl_sdio(addr, request, buf, len);
+
 	return ret;
 }
 
@@ -309,6 +312,13 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	sdio_claim_host(ar_sdio->func);
 
 	mmc_set_data_timeout(&data, ar_sdio->func->card);
+
+	trace_ath6kl_sdio_scat(scat_req->addr,
+			       scat_req->req,
+			       scat_req->len,
+			       scat_req->scat_entries,
+			       scat_req->scat_list);
+
 	/* synchronous call to process request */
 	mmc_wait_for_req(ar_sdio->func->card->host, &mmc_req);
 
diff --git a/drivers/net/wireless/ath/ath6kl/trace.c b/drivers/net/wireless/ath/ath6kl/trace.c
index 4118a29..e7d64b1 100644
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
+EXPORT_TRACEPOINT_SYMBOL(ath6kl_sdio);
+EXPORT_TRACEPOINT_SYMBOL(ath6kl_sdio_scat);
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index 0787619..9db616c 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -4,6 +4,7 @@
 #include <linux/skbuff.h>
 #include <linux/tracepoint.h>
 #include "wmi.h"
+#include "hif.h"
 
 #if !defined(_ATH6KL_TRACE_H)
 static inline unsigned int ath6kl_get_wmi_id(void *buf, size_t buf_len)
@@ -75,6 +76,95 @@ TRACE_EVENT(ath6kl_wmi_event,
 	)
 );
 
+TRACE_EVENT(ath6kl_sdio,
+	TP_PROTO(unsigned int addr, int flags,
+		 void *buf, size_t buf_len),
+
+	TP_ARGS(addr, flags, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, tx)
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
+
+		if (flags & HIF_WRITE)
+			__entry->tx = 1;
+		else
+			__entry->tx = 0;
+	),
+
+	TP_printk(
+		"%s addr 0x%x flags 0x%x len %d\n",
+		__entry->tx ? "tx" : "rx",
+		__entry->addr,
+		__entry->flags,
+		__entry->buf_len
+	)
+);
+
+TRACE_EVENT(ath6kl_sdio_scat,
+	TP_PROTO(unsigned int addr, int flags, unsigned int total_len,
+		 unsigned int entries, struct hif_scatter_item *list),
+
+	TP_ARGS(addr, flags, total_len, entries, list),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, tx)
+		__field(unsigned int, addr)
+		__field(int, flags)
+		__field(unsigned int, entries)
+		__field(size_t, total_len)
+		__dynamic_array(unsigned int, len_array, entries)
+		__dynamic_array(u8, data, total_len)
+	),
+
+	TP_fast_assign(
+		unsigned int *len_array;
+		int i, offset = 0;
+		size_t len;
+
+		__entry->addr = addr;
+		__entry->flags = flags;
+		__entry->entries = entries;
+		__entry->total_len = total_len;
+
+		if (flags & HIF_WRITE)
+			__entry->tx = 1;
+		else
+			__entry->tx = 0;
+
+		len_array = __get_dynamic_array(len_array);
+
+		for (i = 0; i < entries; i++) {
+			len = list[i].len;
+
+			memcpy((u8 *) __get_dynamic_array(data) + offset,
+			       list[i].buf, len);
+
+			len_array[i] = len;
+			offset += len;
+		}
+	),
+
+	TP_printk(
+		"%s addr 0x%x flags 0x%x entries %d total_len %d\n",
+		__entry->tx ? "tx" : "rx",
+		__entry->addr,
+		__entry->flags,
+		__entry->entries,
+		__entry->total_len
+	)
+);
+
 #endif /* _ ATH6KL_TRACE_H || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */

