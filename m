Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab2BQUXt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:49 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/26] iwlwifi: trace debug messages
Date: Fri, 17 Feb 2012 11:13:32 -0800
Message-Id: <1329506034-1394-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212356_042531_21EBB075)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make iwlwifi record all debug messages into
tracing, even if debug_level is not enabled.
Due to the lack of APIs, the debug messages
are now recorded up to a max length of 100,
the only one above that is the RXON which is
not needed if you trace the commands as well
as it only dumps the command contents.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.c    |  127 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-debug.h    |   83 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   65 ++++++++++++++
 4 files changed, 235 insertions(+), 42 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-debug.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 9dc84a7..46622a0 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,7 +1,7 @@
 # WIFI
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
 iwlwifi-objs		:= iwl-agn.o iwl-agn-rs.o iwl-mac80211.o
-iwlwifi-objs		+= iwl-ucode.o iwl-agn-tx.o
+iwlwifi-objs		+= iwl-ucode.o iwl-agn-tx.o iwl-debug.o
 iwlwifi-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
 iwlwifi-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-rx.o
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.c b/drivers/net/wireless/iwlwifi/iwl-debug.c
new file mode 100644
index 0000000..4bc2e70
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.c
@@ -0,0 +1,127 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include <linux/interrupt.h>
+#include "iwl-debug.h"
+
+#define __iwl_fn(fn)						\
+void __iwl_ ##fn(struct device *dev, const char *fmt, ...)	\
+{								\
+	struct va_format vaf = {				\
+		.fmt = fmt,					\
+	};							\
+	va_list args;						\
+								\
+	va_start(args, fmt);					\
+	vaf.va = &args;						\
+	dev_ ##fn(dev, "%pV", &vaf);				\
+	trace_iwlwifi_ ##fn(&vaf);				\
+	va_end(args);						\
+}
+
+__iwl_fn(warn)
+__iwl_fn(info)
+__iwl_fn(crit)
+
+void __iwl_err(struct device *dev, bool rfkill_prefix, bool trace_only,
+		const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	if (!trace_only) {
+		if (rfkill_prefix)
+			dev_err(dev, "(RFKILL) %pV", &vaf);
+		else
+			dev_err(dev, "%pV", &vaf);
+	}
+	trace_iwlwifi_err(&vaf);
+	va_end(args);
+}
+
+#if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
+void __iwl_dbg(struct iwl_shared *shared, struct device *dev,
+	       u32 level, bool limit, const char *function,
+	       const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(shared) & level &&
+	    (!limit || net_ratelimit()))
+		dev_err(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
+			function, &vaf);
+#endif
+	trace_iwlwifi_dbg(level, in_interrupt(), function, &vaf);
+	va_end(args);
+}
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 351b41d..bfc0849 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -31,14 +31,33 @@
 
 #include "iwl-bus.h"
 #include "iwl-shared.h"
+#include "iwl-devtrace.h"
 
 struct iwl_priv;
 
-/*No matter what is m (priv, bus, trans), this will work */
-#define IWL_ERR(m, f, a...) dev_err(trans(m)->dev, f, ## a)
-#define IWL_WARN(m, f, a...) dev_warn(trans(m)->dev, f, ## a)
-#define IWL_INFO(m, f, a...) dev_info(trans(m)->dev, f, ## a)
-#define IWL_CRIT(m, f, a...) dev_crit(trans(m)->dev, f, ## a)
+void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
+		const char *fmt, ...);
+void __iwl_warn(struct device *dev, const char *fmt, ...);
+void __iwl_info(struct device *dev, const char *fmt, ...);
+void __iwl_crit(struct device *dev, const char *fmt, ...);
+
+/* No matter what is m (priv, bus, trans), this will work */
+#define IWL_ERR(m, f, a...) __iwl_err(trans(m)->dev, false, false, f, ## a)
+#define IWL_WARN(m, f, a...) __iwl_warn(trans(m)->dev, f, ## a)
+#define IWL_INFO(m, f, a...) __iwl_info(trans(m)->dev, f, ## a)
+#define IWL_CRIT(m, f, a...) __iwl_crit(trans(m)->dev, f, ## a)
+
+#if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
+void __iwl_dbg(struct iwl_shared *shared, struct device *dev,
+	       u32 level, bool limit, const char *function,
+	       const char *fmt, ...);
+#else
+static inline void
+__iwl_dbg(struct iwl_shared *shared, struct device *dev,
+	  u32 level, bool limit, const char *function,
+	  const char *fmt, ...)
+{}
+#endif
 
 #define iwl_print_hex_error(m, p, len)					\
 do {									\
@@ -46,53 +65,35 @@ do {									\
 		       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);		\
 } while (0)
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-#define IWL_DEBUG(m, level, fmt, ...)					\
-do {									\
-	if (iwl_get_debug_level((m)->shrd) & (level))			\
-		dev_err(trans(m)->dev, "%c %s " fmt,			\
-			in_interrupt() ? 'I' : 'U', __func__,		\
-			##__VA_ARGS__);					\
-} while (0)
-
-#define IWL_DEBUG_LIMIT(m, level, fmt, ...)				\
-do {									\
-	if (iwl_get_debug_level((m)->shrd) & (level) &&			\
-	    net_ratelimit())						\
-		dev_err(trans(m)->dev, "%c %s " fmt,			\
-			in_interrupt() ? 'I' : 'U', __func__,		\
-			##__VA_ARGS__);					\
-} while (0)
+#define IWL_DEBUG(m, level, fmt, args...)				\
+	__iwl_dbg((m)->shrd, trans(m)->dev, level, false, __func__, fmt, ##args)
+#define IWL_DEBUG_LIMIT(m, level, fmt, args...)				\
+	__iwl_dbg((m)->shrd, trans(m)->dev, level, true, __func__, fmt, ##args)
 
+#ifdef CONFIG_IWLWIFI_DEBUG
 #define iwl_print_hex_dump(m, level, p, len)				\
 do {                                            			\
 	if (iwl_get_debug_level((m)->shrd) & level)			\
 		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
-
-#define IWL_DEBUG_QUIET_RFKILL(p, fmt, ...)				\
+#define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
 do {									\
-	if (!iwl_is_rfkill(p->shrd))					\
-		dev_err(trans(p)->dev, "%s%c %s " fmt,			\
-			"",						\
-			in_interrupt() ? 'I' : 'U', __func__,		\
-			##__VA_ARGS__);					\
-	else if	(iwl_get_debug_level(p->shrd) & IWL_DL_RADIO)		\
-		dev_err(trans(p)->dev, "%s%c %s " fmt,			\
-			"(RFKILL) ",					\
-			in_interrupt() ? 'I' : 'U', __func__,		\
-			##__VA_ARGS__);					\
+	if (!iwl_is_rfkill((m)->shrd))					\
+		IWL_ERR(m, fmt, ##args);				\
+	else								\
+		__iwl_err(trans(m)->dev, true,				\
+			  !(iwl_get_debug_level((m)->shrd) & IWL_DL_RADIO),\
+			  fmt, ##args);					\
 } while (0)
-
 #else
-#define IWL_DEBUG(m, level, fmt, args...)
-#define IWL_DEBUG_LIMIT(m, level, fmt, args...)
 #define iwl_print_hex_dump(m, level, p, len)
-#define IWL_DEBUG_QUIET_RFKILL(p, fmt, args...)	\
-do {							\
-	if (!iwl_is_rfkill(p->shrd))			\
-		IWL_ERR(p, fmt, ##args);		\
+#define IWL_DEBUG_QUIET_RFKILL(m, fmt, args...)	\
+do {									\
+	if (!iwl_is_rfkill((m)->shrd))					\
+		IWL_ERR(m, fmt, ##args);				\
+	else								\
+		__iwl_err(trans(m)->dev, true, true, fmt, ##args);	\
 } while (0)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 4d89221..96e6233 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -34,6 +34,11 @@
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
 #endif
 
 #define PRIV_ENTRY	__field(void *, priv)
@@ -164,6 +169,66 @@ TRACE_EVENT(iwlwifi_dev_ucode_wrap_event,
 );
 
 #undef TRACE_SYSTEM
+#define TRACE_SYSTEM iwlwifi_msg
+
+#define MAX_MSG_LEN	100
+
+DECLARE_EVENT_CLASS(iwlwifi_msg_event,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf),
+	TP_STRUCT__entry(
+		__dynamic_array(char, msg, MAX_MSG_LEN)
+	),
+	TP_fast_assign(
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       MAX_MSG_LEN, vaf->fmt,
+				       *vaf->va) >= MAX_MSG_LEN);
+	),
+	TP_printk("%s", (char *)__get_dynamic_array(msg))
+);
+
+DEFINE_EVENT(iwlwifi_msg_event, iwlwifi_err,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(iwlwifi_msg_event, iwlwifi_warn,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(iwlwifi_msg_event, iwlwifi_info,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(iwlwifi_msg_event, iwlwifi_crit,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+TRACE_EVENT(iwlwifi_dbg,
+	TP_PROTO(u32 level, bool in_interrupt, const char *function,
+		 struct va_format *vaf),
+	TP_ARGS(level, in_interrupt, function, vaf),
+	TP_STRUCT__entry(
+		__field(u32, level)
+		__field(u8, in_interrupt)
+		__string(function, function)
+		__dynamic_array(char, msg, MAX_MSG_LEN)
+	),
+	TP_fast_assign(
+		__entry->level = level;
+		__entry->in_interrupt = in_interrupt;
+		__assign_str(function, function);
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       MAX_MSG_LEN, vaf->fmt,
+				       *vaf->va) >= MAX_MSG_LEN);
+	),
+	TP_printk("%s", (char *)__get_dynamic_array(msg))
+);
+
+#undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi
 
 TRACE_EVENT(iwlwifi_dev_hcmd,
-- 
1.7.0.4

