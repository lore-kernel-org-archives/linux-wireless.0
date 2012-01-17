Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:40665 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2AQSJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 13:09:32 -0500
Subject: [PATCH v3 6/8] ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump()
	into functions
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 20:09:27 +0200
Message-ID: <20120117180927.29995.1063.stgit@localhost6.localdomain6> (sfid-20120117_190935_450722_0FA2A980)
In-Reply-To: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
References: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That way it's possible to not export debug_mask outside the upcoming
ath6kl_core.ko and that makes it easier to ath6kl_core.ko in the
following patch.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h |   25 ++++---------------------
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index bd2f1fa..4ba6560 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -57,6 +57,36 @@ int ath6kl_printk(const char *level, const char *fmt, ...)
 
 #ifdef CONFIG_ATH6KL_DEBUG
 
+void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	if (!(debug_mask & mask))
+		return;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	ath6kl_printk(KERN_DEBUG, "%pV", &vaf);
+
+	va_end(args);
+}
+
+void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
+		     const char *msg, const char *prefix,
+		     const void *buf, size_t len)
+{
+	if (debug_mask & mask) {
+		if (msg)
+			ath6kl_dbg(mask, "%s\n", msg);
+
+		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
+	}
+}
+
 #define REG_OUTPUT_LEN_PER_LINE	25
 #define REGTYPE_STR_LEN		100
 
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 9dc3975..872a8ce 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -60,28 +60,11 @@ enum ath6kl_war {
 };
 
 #ifdef CONFIG_ATH6KL_DEBUG
-#define ath6kl_dbg(mask, fmt, ...)					\
-	({								\
-	 int rtn;							\
-	 if (debug_mask & mask)						\
-		rtn = ath6kl_printk(KERN_DEBUG, fmt, ##__VA_ARGS__);	\
-	 else								\
-		rtn = 0;						\
-									\
-	 rtn;								\
-	 })
 
-static inline void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
-				   const char *msg, const char *prefix,
-				   const void *buf, size_t len)
-{
-	if (debug_mask & mask) {
-		if (msg)
-			ath6kl_dbg(mask, "%s\n", msg);
-
-		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
-	}
-}
+void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...);
+void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
+		     const char *msg, const char *prefix,
+		     const void *buf, size_t len);
 
 void ath6kl_dump_registers(struct ath6kl_device *dev,
 			   struct ath6kl_irq_proc_registers *irq_proc_reg,

