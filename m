Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:42540 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2L0Lw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 06:52:57 -0500
Subject: [PATCH 7/7] ath6kl: add tracing support to debug message macros
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com
Date: Thu, 27 Dec 2012 13:44:58 +0200
Message-ID: <20121227114458.27069.96579.stgit@localhost6.localdomain6> (sfid-20121227_125305_036529_672FE8EA)
In-Reply-To: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now all log messages are sent through the tracing infrastruture as well.
Tracing point doesn't follow debug_mask module parameter, instead it sends
all debug messages, so once you enable ath6kl_log_dbg tracing point you will
get a lot of messages. Needs to be discussed if this is sensible or not.
The overhead should be small enough and we anyway include debug level as
well so it's easy to filter in user space.

I wasn't really sure what to do with ath6kl_dbg_dump() and for now decided
that it also sends the buffer to user space. But most likely in the future
ath6kl_dbg_dump() should go away in favor of using proper tracing points but
we will see.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   12 ++++++---
 drivers/net/wireless/ath/ath6kl/trace.h |   42 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 15cfe30..2620910 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -63,15 +63,15 @@ void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...)
 	struct va_format vaf;
 	va_list args;
 
-	if (!(debug_mask & mask))
-		return;
-
 	va_start(args, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	ath6kl_printk(KERN_DEBUG, "%pV", &vaf);
+	if (debug_mask & mask)
+		ath6kl_printk(KERN_DEBUG, "%pV", &vaf);
+
+	trace_ath6kl_log_dbg(mask, &vaf);
 
 	va_end(args);
 }
@@ -87,6 +87,10 @@ void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
 
 		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
 	}
+
+	/* tracing code doesn't like null strings :/ */
+	trace_ath6kl_log_dbg_dump(msg ? msg : "", prefix ? prefix : "",
+				  buf, len);
 }
 EXPORT_SYMBOL(ath6kl_dbg_dump);
 
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index 8278143..0676ef0 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -229,6 +229,48 @@ DEFINE_EVENT(ath6kl_log_event, ath6kl_log_info,
 	     TP_ARGS(vaf)
 );
 
+TRACE_EVENT(ath6kl_log_dbg,
+	TP_PROTO(unsigned int level, struct va_format *vaf),
+	TP_ARGS(level, vaf),
+	TP_STRUCT__entry(
+		__field(unsigned int, level)
+		__dynamic_array(char, msg, ATH6KL_MSG_MAX)
+	),
+	TP_fast_assign(
+		__entry->level = level;
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       ATH6KL_MSG_MAX,
+				       vaf->fmt,
+				       *vaf->va) >= ATH6KL_MSG_MAX);
+	),
+	TP_printk("%s", __get_str(msg))
+);
+
+TRACE_EVENT(ath6kl_log_dbg_dump,
+	TP_PROTO(const char *msg, const char *prefix,
+		 const void *buf, size_t buf_len),
+
+	TP_ARGS(msg, prefix, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__string(msg, msg)
+		__string(prefix, prefix)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__assign_str(msg, msg);
+		__assign_str(prefix, prefix);
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"%s/%s\n", __get_str(prefix), __get_str(msg)
+	)
+);
+
 #endif /* _ ATH6KL_TRACE_H || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */

