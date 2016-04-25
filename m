Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40759 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbcDYM6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 08:58:16 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 4/7] wil6210: print debug message when transmitting while disconnected
Date: Mon, 25 Apr 2016 15:57:55 +0300
Message-Id: <1461589078-29854-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160425_145827_862311_150D5952)
In-Reply-To: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Network stack can try to transmit data while AP / STA is
disconnected.
Change this print-out to debug level as this should not be
handled as error.
This patch also adds wil_dbg_ratelimited, used to limit the
above print-out.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debug.c   | 16 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c    |  2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h |  2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debug.c b/drivers/net/wireless/ath/wil6210/debug.c
index 0a30127..c312a66 100644
--- a/drivers/net/wireless/ath/wil6210/debug.c
+++ b/drivers/net/wireless/ath/wil6210/debug.c
@@ -49,6 +49,22 @@ void __wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
 	}
 }
 
+void wil_dbg_ratelimited(const struct wil6210_priv *wil, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	if (!net_ratelimit())
+		return;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	netdev_dbg(wil_to_ndev(wil), "%pV", &vaf);
+	trace_wil6210_log_dbg(&vaf);
+	va_end(args);
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
index b6fc256..50acd13 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -640,6 +640,8 @@ __printf(2, 3)
 void __wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...);
 __printf(2, 3)
 void __wil_info(struct wil6210_priv *wil, const char *fmt, ...);
+__printf(2, 3)
+void wil_dbg_ratelimited(const struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_dbg(wil, fmt, arg...) do { \
 	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
 	wil_dbg_trace(wil, fmt, ##arg); \
-- 
1.8.5.2

