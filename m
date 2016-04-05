Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27539 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbcDELYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 07:24:14 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 1/7] wil6210: add function name to wil log macros
Date: Tue,  5 Apr 2016 14:24:01 +0300
Message-Id: <1459855447-17413-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160405_132423_523129_56EF864F)
In-Reply-To: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add __func__ to all wil log macros for easier debugging.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debug.c   |  6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h | 25 +++++++++++++++++--------
 2 files changed, 20 insertions(+), 11 deletions(-)

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
index 4d699ea4..d005370 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -635,21 +635,30 @@ struct wil6210_priv {
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
 } while (0)
 
-#define wil_dbg_irq(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
-#define wil_dbg_txrx(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
-#define wil_dbg_wmi(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
-#define wil_dbg_misc(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
-#define wil_dbg_pm(wil, fmt, arg...) wil_dbg(wil, "DBG[ PM ]" fmt, ##arg)
+#define wil_dbg_irq(wil, fmt, arg...) \
+	wil_dbg(wil, "DBG[ IRQ]%s: " fmt, __func__, ##arg)
+#define wil_dbg_txrx(wil, fmt, arg...) \
+	wil_dbg(wil, "DBG[TXRX]%s: " fmt, __func__, ##arg)
+#define wil_dbg_wmi(wil, fmt, arg...) \
+	wil_dbg(wil, "DBG[ WMI]%s: " fmt, __func__,  ##arg)
+#define wil_dbg_misc(wil, fmt, arg...) \
+	wil_dbg(wil, "DBG[MISC]%s: " fmt, __func__, ##arg)
+#define wil_dbg_pm(wil, fmt, arg...) \
+	wil_dbg(wil, "DBG[ PM ]%s: " fmt, __func__, ##arg)
+#define wil_err(wil, fmt, arg...) __wil_err(wil, "%s: " fmt, __func__, ##arg)
+#define wil_info(wil, fmt, arg...) __wil_info(wil, "%s: " fmt, __func__, ##arg)
+#define wil_err_ratelimited(wil, fmt, arg...) \
+	__wil_err_ratelimited(wil, "%s: " fmt, __func__, ##arg)
 
 /* target operations */
 /* register read */
-- 
1.8.5.2

