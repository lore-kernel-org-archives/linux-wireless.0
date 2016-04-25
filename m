Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40759 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbcDYM6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 08:58:15 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 1/7] wil6210: add function name to wil log macros
Date: Mon, 25 Apr 2016 15:57:52 +0300
Message-Id: <1461589078-29854-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160425_145822_175346_E7C6DB1B)
In-Reply-To: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add __func__ to wil_err and wil_info for easier
debugging.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debug.c   |  6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h | 10 +++++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debug.c b/drivers/net/wireless/ath/wil6210/debug.c
index 3249562..0a30127 100644
--- a/drivers/net/wireless/ath/wil6210/debug.c
+++ b/drivers/net/wireless/ath/wil6210/debug.c
@@ -17,7 +17,7 @@
 #include "wil6210.h"
 #include "trace.h"
 
-void wil_err(struct wil6210_priv *wil, const char *fmt, ...)
+void __wil_err(struct wil6210_priv *wil, const char *fmt, ...)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct va_format vaf = {
@@ -32,7 +32,7 @@ void wil_err(struct wil6210_priv *wil, const char *fmt, ...)
 	va_end(args);
 }
 
-void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
+void __wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
 {
 	if (net_ratelimit()) {
 		struct net_device *ndev = wil_to_ndev(wil);
@@ -49,7 +49,7 @@ void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
 	}
 }
 
-void wil_info(struct wil6210_priv *wil, const char *fmt, ...)
+void __wil_info(struct wil6210_priv *wil, const char *fmt, ...)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct va_format vaf = {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 4d699ea4..5dee909 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -635,11 +635,11 @@ struct wil6210_priv {
 __printf(2, 3)
 void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
 __printf(2, 3)
-void wil_err(struct wil6210_priv *wil, const char *fmt, ...);
+void __wil_err(struct wil6210_priv *wil, const char *fmt, ...);
 __printf(2, 3)
-void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...);
+void __wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...);
 __printf(2, 3)
-void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
+void __wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_dbg(wil, fmt, arg...) do { \
 	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
 	wil_dbg_trace(wil, fmt, ##arg); \
@@ -650,6 +650,10 @@ void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_dbg_wmi(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
 #define wil_dbg_misc(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
 #define wil_dbg_pm(wil, fmt, arg...) wil_dbg(wil, "DBG[ PM ]" fmt, ##arg)
+#define wil_err(wil, fmt, arg...) __wil_err(wil, "%s: " fmt, __func__, ##arg)
+#define wil_info(wil, fmt, arg...) __wil_info(wil, "%s: " fmt, __func__, ##arg)
+#define wil_err_ratelimited(wil, fmt, arg...) \
+	__wil_err_ratelimited(wil, "%s: " fmt, __func__, ##arg)
 
 /* target operations */
 /* register read */
-- 
1.8.5.2

