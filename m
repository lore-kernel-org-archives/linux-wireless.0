Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2FVRO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:14:57 -0400
Message-ID: <1340385295.4491.38.camel@jlt3.sipsolutions.net> (sfid-20120622_191500_355766_3DC25C2C)
Subject: [PATCH] compat-wireless: add patch to fix iwlwifi tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 19:14:55 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

See the description in the file -- the current code
is safe only on recent upstream kernels, with 3.1
for example it can crash. The new code is safe on
all kernels that even support %pV, others just get
a pointer unfortunately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/55-iwlwifi-msg-trace-fix.patch |   70 ++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 patches/55-iwlwifi-msg-trace-fix.patch

diff --git a/patches/55-iwlwifi-msg-trace-fix.patch b/patches/55-iwlwifi-msg-trace-fix.patch
new file mode 100644
index 0000000..1e8803f
--- /dev/null
+++ b/patches/55-iwlwifi-msg-trace-fix.patch
@@ -0,0 +1,70 @@
+In recent kernels, %pV will copy the va_list before using it.
+This isn't true for all kernels, so copy the va_list for use
+by the dev_*() functions, otherwise the kernel will crash if
+the message is printed and traced.
+
+--- a/drivers/net/wireless/iwlwifi/iwl-debug.c
++++ b/drivers/net/wireless/iwlwifi/iwl-debug.c
+@@ -72,13 +72,16 @@ void __iwl_ ##fn(struct device *dev, const char *fmt, ...)	\
+ 	struct va_format vaf = {				\
+ 		.fmt = fmt,					\
+ 	};							\
+-	va_list args;						\
++	va_list args1, args2;					\
+ 								\
+-	va_start(args, fmt);					\
+-	vaf.va = &args;						\
++	va_start(args1, fmt);					\
++	va_copy(args2, args1);					\
++	vaf.va = &args2;					\
+ 	dev_ ##fn(dev, "%pV", &vaf);				\
++	va_end(args2);						\
++	vaf.va = &args1;					\
+ 	trace_iwlwifi_ ##fn(&vaf);				\
+-	va_end(args);						\
++	va_end(args1);						\
+ }
+ 
+ __iwl_fn(warn)
+@@ -97,13 +100,18 @@ void __iwl_err(struct device *dev, bool rfkill_prefix, bool trace_only,
+ 	va_list args;
+ 
+ 	va_start(args, fmt);
+-	vaf.va = &args;
+ 	if (!trace_only) {
++		va_list args2;
++
++		va_copy(args2, args);
++		vaf.va = &args2;
+ 		if (rfkill_prefix)
+ 			dev_err(dev, "(RFKILL) %pV", &vaf);
+ 		else
+ 			dev_err(dev, "%pV", &vaf);
++		va_end(args2);
+ 	}
++	vaf.va = &args;
+ 	trace_iwlwifi_err(&vaf);
+ 	va_end(args);
+ }
+@@ -120,13 +128,19 @@ void __iwl_dbg(struct device *dev,
+ 	va_list args;
+ 
+ 	va_start(args, fmt);
+-	vaf.va = &args;
+ #ifdef CONFIG_IWLWIFI_DEBUG
+ 	if (iwl_have_debug_level(level) &&
+-	    (!limit || net_ratelimit()))
++	    (!limit || net_ratelimit())) {
++		va_list args2;
++
++		va_copy(args2, args);
++		vaf.va = &args2;
+ 		dev_err(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
+ 			function, &vaf);
++		va_end(args2);
++	}
+ #endif
++	vaf.va = &args;
+ 	trace_iwlwifi_dbg(level, in_interrupt(), function, &vaf);
+ 	va_end(args);
+ }
-- 
1.7.10



