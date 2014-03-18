Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34338 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaCRUpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 16:45:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rsi: make rsi_dbg a regular function
Date: Tue, 18 Mar 2014 16:39:48 -0400
Message-Id: <1395175188-9833-1-git-send-email-linville@tuxdriver.com> (sfid-20140318_214525_809462_0EA8D952)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to address reports of this:

In file included from drivers/net/wireless/rsi/rsi_mgmt.h:22:0,
                 from drivers/net/wireless/rsi/rsi_91x_core.c:17:
drivers/net/wireless/rsi/rsi_91x_core.c: In function 'rsi_dbg':
drivers/net/wireless/rsi/rsi_main.h:44:20: error: function 'rsi_dbg' can never be inlined because it uses variable argument lists
 static inline void rsi_dbg(u32 zone, const char *fmt, ...)

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Although I'm not sure why a variable argument list prevents inlining
a function?  Well, anyway...

 drivers/net/wireless/rsi/rsi_91x_main.c | 23 +++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h     | 16 +---------------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 410a4a423578..7367be4a58ad 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -32,6 +32,29 @@ u32 rsi_zone_enabled = /* INFO_ZONE |
 EXPORT_SYMBOL_GPL(rsi_zone_enabled);
 
 /**
+ * rsi_dbg() - This function outputs informational messages.
+ * @zone: Zone of interest for output message.
+ * @fmt: printf-style format for output message.
+ *
+ * Return: none
+ */
+void rsi_dbg(u32 zone, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (zone & rsi_zone_enabled)
+		pr_info("%pV", &vaf);
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(rsi_dbg);
+
+/**
  * rsi_prepare_skb() - This function prepares the skb.
  * @common: Pointer to the driver private structure.
  * @buffer: Pointer to the packet data.
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index bebdc2ae6c5b..e97e6ad07562 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -40,21 +40,7 @@
 #define FSM_MAC_INIT_DONE               6
 
 extern u32 rsi_zone_enabled;
-
-static inline void rsi_dbg(u32 zone, const char *fmt, ...)
-{
-	struct va_format vaf;
-	va_list args;
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	if (zone & rsi_zone_enabled)
-		pr_info("%pV", &vaf);
-	va_end(args);
-}
+extern void rsi_dbg(u32 zone, const char *fmt, ...);
 
 #define RSI_MAX_VIFS                    1
 #define NUM_EDCA_QUEUES                 4
-- 
1.8.5.3

