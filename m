Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27539 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbcDELYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 07:24:19 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 4/7] wil6210: print debug message when transmitting while disconnected
Date: Tue,  5 Apr 2016 14:24:04 +0300
Message-Id: <1459855447-17413-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160405_132424_656569_FD1AFF17)
In-Reply-To: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Network stack can try to transmit data while AP / STA is
disconnected.
Change this print-out to debug level as this should not be
handled as error.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debug.c   | 17 +++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c    |  2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h |  4 ++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debug.c b/drivers/net/wireless/ath/wil6210/debug.c
index 0a30127..e5395fd 100644
--- a/drivers/net/wireless/ath/wil6210/debug.c
+++ b/drivers/net/wireless/ath/wil6210/debug.c
@@ -49,6 +49,23 @@ void __wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
 	}
 }
 
+void __wil_dbg_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
+{
+	if (net_ratelimit()) {
+		struct net_device *ndev = wil_to_ndev(wil);
+		struct va_format vaf = {
+			.fmt = fmt,
+		};
+		va_list args;
+
+		va_start(args, fmt);
+		vaf.va = &args;
+		netdev_dbg(ndev, "%pV", &vaf);
+		trace_wil6210_log_dbg(&vaf);
+		va_end(args);
+	}
+}
+
 void __wil_info(struct wil6210_priv *wil, const char *fmt, ...)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index f260b232..a4e4379 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1759,7 +1759,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		goto drop;
 	}
 	if (unlikely(!test_bit(wil_status_fwconnected, wil->status))) {
-		wil_err_ratelimited(wil, "FW not connected\n");
+		wil_dbg_ratelimited(wil, "FW not connected, packet dropped\n");
 		goto drop;
 	}
 	if (unlikely(wil->wdev->iftype == NL80211_IFTYPE_MONITOR)) {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 7fcfd6f..84b3fa6 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -640,6 +640,8 @@ __printf(2, 3)
 void __wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...);
 __printf(2, 3)
 void __wil_info(struct wil6210_priv *wil, const char *fmt, ...);
+__printf(2, 3)
+void __wil_dbg_ratelimited(struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_dbg(wil, fmt, arg...) do { \
 	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
 	wil_dbg_trace(wil, fmt, ##arg); \
@@ -659,6 +661,8 @@ void __wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_info(wil, fmt, arg...) __wil_info(wil, "%s: " fmt, __func__, ##arg)
 #define wil_err_ratelimited(wil, fmt, arg...) \
 	__wil_err_ratelimited(wil, "%s: " fmt, __func__, ##arg)
+#define wil_dbg_ratelimited(wil, fmt, arg...) \
+	__wil_dbg_ratelimited(wil, "%s: " fmt, __func__, ##arg)
 
 /* target operations */
 /* register read */
-- 
1.8.5.2

