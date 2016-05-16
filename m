Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63805 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbcEPTYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 15:24:12 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 6/6] wil6210: align wil log functions to wil_dbg_ratelimited implementation
Date: Mon, 16 May 2016 22:23:35 +0300
Message-Id: <1463426615-15523-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160516_212415_669335_83441A71)
In-Reply-To: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the implementation of wil log functions for consistency
with __wil_dbg_ratelimited.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debug.c | 46 ++++++++++++++------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debug.c b/drivers/net/wireless/ath/wil6210/debug.c
index c312a66..217a459 100644
--- a/drivers/net/wireless/ath/wil6210/debug.c
+++ b/drivers/net/wireless/ath/wil6210/debug.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ * Copyright (c) 2013,2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -19,34 +19,31 @@
 
 void __wil_err(struct wil6210_priv *wil, const char *fmt, ...)
 {
-	struct net_device *ndev = wil_to_ndev(wil);
-	struct va_format vaf = {
-		.fmt = fmt,
-	};
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
+	vaf.fmt = fmt;
 	vaf.va = &args;
-	netdev_err(ndev, "%pV", &vaf);
+	netdev_err(wil_to_ndev(wil), "%pV", &vaf);
 	trace_wil6210_log_err(&vaf);
 	va_end(args);
 }
 
 void __wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
 {
-	if (net_ratelimit()) {
-		struct net_device *ndev = wil_to_ndev(wil);
-		struct va_format vaf = {
-			.fmt = fmt,
-		};
-		va_list args;
+	struct va_format vaf;
+	va_list args;
 
-		va_start(args, fmt);
-		vaf.va = &args;
-		netdev_err(ndev, "%pV", &vaf);
-		trace_wil6210_log_err(&vaf);
-		va_end(args);
-	}
+	if (!net_ratelimit())
+		return;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	netdev_err(wil_to_ndev(wil), "%pV", &vaf);
+	trace_wil6210_log_err(&vaf);
+	va_end(args);
 }
 
 void wil_dbg_ratelimited(const struct wil6210_priv *wil, const char *fmt, ...)
@@ -67,27 +64,24 @@ void wil_dbg_ratelimited(const struct wil6210_priv *wil, const char *fmt, ...)
 
 void __wil_info(struct wil6210_priv *wil, const char *fmt, ...)
 {
-	struct net_device *ndev = wil_to_ndev(wil);
-	struct va_format vaf = {
-		.fmt = fmt,
-	};
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
+	vaf.fmt = fmt;
 	vaf.va = &args;
-	netdev_info(ndev, "%pV", &vaf);
+	netdev_info(wil_to_ndev(wil), "%pV", &vaf);
 	trace_wil6210_log_info(&vaf);
 	va_end(args);
 }
 
 void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...)
 {
-	struct va_format vaf = {
-		.fmt = fmt,
-	};
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
+	vaf.fmt = fmt;
 	vaf.va = &args;
 	trace_wil6210_log_dbg(&vaf);
 	va_end(args);
-- 
1.8.5.2

