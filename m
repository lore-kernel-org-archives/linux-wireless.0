Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38253 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbaJBBCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 21:02:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 01/10] ath: Add support for tracing
Date: Thu,  2 Oct 2014 06:33:11 +0530
Message-Id: <1412211800-24344-2-git-send-email-sujith@msujith.org> (sfid-20141002_030252_294789_A2B82661)
In-Reply-To: <1412211800-24344-1-git-send-email-sujith@msujith.org>
References: <1412211800-24344-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/Kconfig  |  8 +++++
 drivers/net/wireless/ath/Makefile |  4 +++
 drivers/net/wireless/ath/ath.h    |  1 +
 drivers/net/wireless/ath/main.c   |  3 ++
 drivers/net/wireless/ath/trace.c  | 20 +++++++++++
 drivers/net/wireless/ath/trace.h  | 71 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 107 insertions(+)
 create mode 100644 drivers/net/wireless/ath/trace.c
 create mode 100644 drivers/net/wireless/ath/trace.h

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index c63d115..ce78260 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -25,6 +25,14 @@ config ATH_DEBUG
 	  Say Y, if you want to debug atheros wireless drivers.
 	  Right now only ath9k makes use of this.
 
+config ATH_TRACEPOINTS
+       bool "Atheros wireless tracing"
+       depends on ATH_DEBUG
+       depends on EVENT_TRACING
+       ---help---
+         This option enables tracepoints for atheros wireless drivers.
+	 Currently, ath9k makes use of this facility.
+
 config ATH_REG_DYNAMIC_USER_REG_HINTS
 	bool "Atheros dynamic user regulatory hints"
 	depends on CFG80211_CERTIFICATION_ONUS
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 7d023b0..89f8d59 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -17,4 +17,8 @@ ath-objs :=	main.o \
 		dfs_pri_detector.o
 
 ath-$(CONFIG_ATH_DEBUG) += debug.o
+ath-$(CONFIG_ATH_TRACEPOINTS) += trace.o
+
 ccflags-y += -D__CHECK_ENDIAN__
+
+CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index a3b6e27..e5ba6fa 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -268,6 +268,7 @@ enum ATH_DEBUG {
 };
 
 #define ATH_DBG_DEFAULT (ATH_DBG_FATAL)
+#define ATH_DBG_MAX_LEN 512
 
 #ifdef CONFIG_ATH_DEBUG
 
diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
index 8b0ac14..83f47af 100644
--- a/drivers/net/wireless/ath/main.c
+++ b/drivers/net/wireless/ath/main.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 
 #include "ath.h"
+#include "trace.h"
 
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless LAN cards.");
@@ -84,6 +85,8 @@ void ath_printk(const char *level, const struct ath_common* common,
 	else
 		printk("%sath: %pV", level, &vaf);
 
+	trace_ath_log(common->hw->wiphy, &vaf);
+
 	va_end(args);
 }
 EXPORT_SYMBOL(ath_printk);
diff --git a/drivers/net/wireless/ath/trace.c b/drivers/net/wireless/ath/trace.c
new file mode 100644
index 0000000..18fb3a0
--- /dev/null
+++ b/drivers/net/wireless/ath/trace.c
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/drivers/net/wireless/ath/trace.h b/drivers/net/wireless/ath/trace.h
new file mode 100644
index 0000000..ba71164
--- /dev/null
+++ b/drivers/net/wireless/ath/trace.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#if !defined(_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_H
+
+#include <linux/tracepoint.h>
+#include "ath.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ath
+
+#if !defined(CONFIG_ATH_TRACEPOINTS)
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) static inline void trace_ ## name(proto) {}
+
+#endif /* CONFIG_ATH_TRACEPOINTS */
+
+TRACE_EVENT(ath_log,
+
+	    TP_PROTO(struct wiphy *wiphy,
+		     struct va_format *vaf),
+
+	    TP_ARGS(wiphy, vaf),
+
+	    TP_STRUCT__entry(
+		    __string(device, wiphy_name(wiphy))
+		    __string(driver, KBUILD_MODNAME)
+		    __dynamic_array(char, msg, ATH_DBG_MAX_LEN)
+	    ),
+
+	    TP_fast_assign(
+		    __assign_str(device, wiphy_name(wiphy));
+		    __assign_str(driver, KBUILD_MODNAME);
+		    WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+					   ATH_DBG_MAX_LEN,
+					   vaf->fmt,
+					   *vaf->va) >= ATH_DBG_MAX_LEN);
+	    ),
+
+	    TP_printk(
+		    "%s %s %s",
+		    __get_str(driver),
+		    __get_str(device),
+		    __get_str(msg)
+	    )
+);
+
+#endif /* _TRACE_H || TRACE_HEADER_MULTI_READ */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.1.1

