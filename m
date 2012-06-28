Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2F1NPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 09:15:22 -0400
Message-ID: <1340889318.4491.45.camel@jlt3.sipsolutions.net> (sfid-20120628_151526_307209_AC0F223E)
Subject: [PATCH] compat-wireless: add patch to fix message tracing in
 mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 28 Jun 2012 15:15:18 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just like in iwlwifi, the tracing in mac80211 needs to
copy va_args as some old kernels don't do it for %pV.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/56-mac80211-trace-fix.patch |   79 +++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 patches/56-mac80211-trace-fix.patch

diff --git a/patches/56-mac80211-trace-fix.patch b/patches/56-mac80211-trace-fix.patch
new file mode 100644
index 0000000..1e82fb6
--- /dev/null
+++ b/patches/56-mac80211-trace-fix.patch
@@ -0,0 +1,79 @@
+--- a/net/mac80211/trace.c
++++ b/net/mac80211/trace.c
+@@ -15,12 +15,16 @@ void __sdata_info(const char *fmt, ...)
+ 	struct va_format vaf = {
+ 		.fmt = fmt,
+ 	};
+-	va_list args;
++	va_list args, args2;
+ 
+ 	va_start(args, fmt);
+-	vaf.va = &args;
+ 
++	va_copy(args2, args);
++	vaf.va = &args2;
+ 	pr_info("%pV", &vaf);
++	va_end(args2);
++
++	vaf.va = &args;
+ 	trace_mac80211_info(&vaf);
+ 	va_end(args);
+ }
+@@ -33,10 +37,16 @@ void __sdata_dbg(bool print, const char *fmt, ...)
+ 	va_list args;
+ 
+ 	va_start(args, fmt);
+-	vaf.va = &args;
+ 
+-	if (print)
++	if (print) {
++		va_list args2;
++
++		va_copy(args2, args);
++		vaf.va = &args2;
+ 		pr_debug("%pV", &vaf);
++		va_end(args2);
++	}
++	vaf.va = &args;
+ 	trace_mac80211_dbg(&vaf);
+ 	va_end(args);
+ }
+@@ -46,12 +56,16 @@ void __sdata_err(const char *fmt, ...)
+ 	struct va_format vaf = {
+ 		.fmt = fmt,
+ 	};
+-	va_list args;
++	va_list args, args2;
+ 
+ 	va_start(args, fmt);
+-	vaf.va = &args;
+ 
++	va_copy(args2, args);
++	vaf.va = &args2;
+ 	pr_err("%pV", &vaf);
++	va_end(args2);
++
++	vaf.va = &args;
+ 	trace_mac80211_err(&vaf);
+ 	va_end(args);
+ }
+@@ -64,10 +78,16 @@ void __wiphy_dbg(struct wiphy *wiphy, bool print, const char *fmt, ...)
+ 	va_list args;
+ 
+ 	va_start(args, fmt);
+-	vaf.va = &args;
+ 
+-	if (print)
+-		wiphy_dbg(wiphy, "%pV", &vaf);
++	if (print) {
++		va_list args2;
++
++		va_copy(args2, args);
++		vaf.va = &args2;
++		pr_debug("%pV", &vaf);
++		va_end(args2);
++	}
++	vaf.va = &args;
+ 	trace_mac80211_dbg(&vaf);
+ 	va_end(args);
+ }
-- 
1.7.10



