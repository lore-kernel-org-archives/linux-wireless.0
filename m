Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58286 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161168Ab2KNMSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 07:18:01 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>
Subject: [RFC] dynamic_debug: introduce debug_hex_dump()
Date: Wed, 14 Nov 2012 14:17:43 +0200
Message-ID: <1352895463-22851-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121114_131805_386269_C8E3F850)
In-Reply-To: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce debug_hex_dump() that can be dynamically controlled, similar to
pr_debug.

Implement only 'p' flag (_DPRINTK_FLAGS_PRINT) to keep it simple since hex dump prints
multiple lines and long prefix would impact readability.
To provide line/file etc. information, use pr_debug or similar
before/after debug_hex_dump()

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 Documentation/dynamic-debug-howto.txt |    9 +++++++--
 include/linux/dynamic_debug.h         |   10 ++++++++++
 include/linux/printk.h                |   14 ++++++++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 6e16849..4be8d9d 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -6,8 +6,11 @@ This document describes how to use the dynamic debug (dyndbg) feature.
 
 Dynamic debug is designed to allow you to dynamically enable/disable
 kernel code to obtain additional kernel information.  Currently, if
-CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() calls can
-be dynamically enabled per-callsite.
+CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() and
+debug_hex_dump() calls can be dynamically enabled per-callsite.
+
+If CONFIG_DYNAMIC_DEBUG is not set, debug_hex_dump() is just shortcut
+for print_hex_dump(KERN_DEBUG).
 
 Dynamic debug has even more useful features:
 
@@ -202,6 +205,8 @@ The flags are:
   t    Include thread ID in messages not generated from interrupt context
   _    No flags are set. (Or'd with others on input)
 
+For debug_hex_dump(), only 'p' flag have meaning, other flags ignored.
+
 For display, the flags are preceded by '='
 (mnemonic: what the flags are currently equal to).
 
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 6dd4787..17565ab 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -95,6 +95,16 @@ do {								\
 				     ##__VA_ARGS__);		\
 } while (0)
 
+#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)		\
+do {								\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, prefix_str);	\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+		print_hex_dump(KERN_DEBUG, prefix_str,		\
+			       prefix_type, rowsize, groupsize,	\
+			       buf, len, ascii);		\
+} while (0)
+
 #else
 
 #include <linux/string.h>
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9afc01e..0c9be93 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -220,6 +220,20 @@ extern void dump_stack(void) __cold;
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)		\
+		       dynamic_hex_dump(prefix_str, prefix_type,\
+					rowsize, groupsize, buf,\
+					len, ascii)
+#else
+#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)		\
+		       print_hex_dump(KERN_DEBUG, prefix_str,	\
+				      prefix_type, rowsize,	\
+				      groupsize, buf, len, ascii)
+#endif
+
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
-- 
1.7.10.4

