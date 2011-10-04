Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2422 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 25/26] staging: brcm80211: softmac: added event tracing
Date: Tue, 4 Oct 2011 23:19:11 +0200
Message-ID: <1317763152-17607-26-git-send-email-arend@broadcom.com> (sfid-20111004_231958_678115_57959891)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Dpc and timer events can now be traced. Combined with Mac80211
driver callback tracing, all entry points into the driver can now
be traced.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    3 +-
 .../brcm80211/brcmsmac/brcms_trace_events.c        |   23 +++++
 .../brcm80211/brcmsmac/brcms_trace_events.h        |   92 ++++++++++++++++++++
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |   10 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |    2 +
 5 files changed, 124 insertions(+), 6 deletions(-)
 create mode 100644 drivers/staging/brcm80211/brcmsmac/brcms_trace_events.c
 create mode 100644 drivers/staging/brcm80211/brcmsmac/brcms_trace_events.h

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index e44859d..a8a152b 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -42,7 +42,8 @@ BRCMSMAC_OFILES := \
 	otp.o \
 	srom.o \
 	dma.o \
-	nicpci.o
+	nicpci.o \
+	brcms_trace_events.o
 
 MODULEPFX := brcmsmac
 
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_trace_events.c b/drivers/staging/brcm80211/brcmsmac/brcms_trace_events.c
new file mode 100644
index 0000000..52fc9ee
--- /dev/null
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_trace_events.c
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h> /* bug in tracepoint.h, it should include this */
+
+#ifndef __CHECKER__
+#include "mac80211_if.h"
+#define CREATE_TRACE_POINTS
+#include "brcms_trace_events.h"
+#endif
diff --git a/drivers/staging/brcm80211/brcmsmac/brcms_trace_events.h b/drivers/staging/brcm80211/brcmsmac/brcms_trace_events.h
new file mode 100644
index 0000000..27dd73e
--- /dev/null
+++ b/drivers/staging/brcm80211/brcmsmac/brcms_trace_events.h
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM brcmsmac
+
+#if !defined(__TRACE_BRCMSMAC_H) || defined(TRACE_HEADER_MULTI_READ)
+
+#define __TRACE_BRCMSMAC_H
+
+#include <linux/tracepoint.h>
+#include "mac80211_if.h"
+
+#ifndef CONFIG_BRCMDBG
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#endif
+
+/*
+ * We define a tracepoint, its arguments, its printk format and its
+ * 'fast binary record' layout.
+ */
+TRACE_EVENT(brcms_timer,
+	/* TPPROTO is the prototype of the function called by this tracepoint */
+	TP_PROTO(struct brcms_timer *t),
+	/*
+	 * TPARGS(firstarg, p) are the parameters names, same as found in the
+	 * prototype.
+	 */
+	TP_ARGS(t),
+	/*
+	 * Fast binary tracing: define the trace record via TP_STRUCT__entry().
+	 * You can think about it like a regular C structure local variable
+	 * definition.
+	 */
+	TP_STRUCT__entry(
+		__field(uint, ms)
+		__field(uint, set)
+		__field(uint, periodic)
+	),
+	TP_fast_assign(
+		__entry->ms = t->ms;
+		__entry->set = t->set;
+		__entry->periodic = t->periodic;
+	),
+	TP_printk(
+		"ms=%u set=%u periodic=%u",
+		__entry->ms, __entry->set, __entry->periodic
+	)
+);
+
+TRACE_EVENT(brcms_dpc,
+	TP_PROTO(unsigned long data),
+	TP_ARGS(data),
+	TP_STRUCT__entry(
+		__field(unsigned long, data)
+	),
+	TP_fast_assign(
+		__entry->data = data;
+	),
+	TP_printk(
+		"data=%p",
+		(void *)__entry->data
+	)
+);
+
+#endif /* __TRACE_BRCMSMAC_H */
+
+#ifdef CONFIG_BRCMDBG
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE brcms_trace_events
+
+#include <trace/define_trace.h>
+
+#endif /* CONFIG_BRCMDBG */
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index c5afeaf..fa00ab3 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -750,7 +750,7 @@ static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
 	return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
 }
 
-static void brcms_dpc(unsigned long data)
+void brcms_dpc(unsigned long data)
 {
 	struct brcms_info *wl;
 
@@ -1430,7 +1430,7 @@ void brcms_down(struct brcms_info *wl)
 /*
 * precondition: perimeter lock is not acquired
  */
-static void _brcms_timer(struct brcms_timer *t)
+void brcms_timer(struct brcms_timer *t)
 {
 	LOCK(t->wl);
 
@@ -1454,9 +1454,9 @@ static void _brcms_timer(struct brcms_timer *t)
 /*
  * is called by the kernel from software irq context
  */
-static void brcms_timer(unsigned long data)
+static void _brcms_timer(unsigned long data)
 {
-	_brcms_timer((struct brcms_timer *) data);
+	brcms_timer((struct brcms_timer *) data);
 }
 
 /*
@@ -1477,7 +1477,7 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 
 	init_timer(&t->timer);
 	t->timer.data = (unsigned long) t;
-	t->timer.function = brcms_timer;
+	t->timer.function = _brcms_timer;
 	t->wl = wl;
 	t->fn = fn;
 	t->arg = arg;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 2bdcd4c..92256d0 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -101,5 +101,7 @@ extern void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *timer,
 			    uint ms, int periodic);
 extern bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *timer);
 extern void brcms_msleep(struct brcms_info *wl, uint ms);
+extern void brcms_dpc(unsigned long data);
+extern void brcms_timer(struct brcms_timer *t);
 
 #endif				/* _BRCM_MAC80211_IF_H_ */
-- 
1.7.4.1


