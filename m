Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29320 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaLBJrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 04:47:13 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 02/10] wil6210: introduce wil_err_ratelimited()
Date: Tue, 2 Dec 2014 11:46:30 +0200
Message-ID: <1417513598-18304-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141202_104720_669972_6B0CC421)
In-Reply-To: <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add rate-limited flavor of wil_err(); in some cases,
specially in IRQ and data path, if something went wrong,
error message may be printed at very high rate, rendering
whole system unresponsive or unstable.
Need to do real function and not a macro to have arguments
always evaluated.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debug.c   | 17 +++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debug.c b/drivers/net/wireless/ath/wil6210/debug.c
index 8d99021..3249562 100644
--- a/drivers/net/wireless/ath/wil6210/debug.c
+++ b/drivers/net/wireless/ath/wil6210/debug.c
@@ -32,6 +32,23 @@ void wil_err(struct wil6210_priv *wil, const char *fmt, ...)
 	va_end(args);
 }
 
+void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...)
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
+		netdev_err(ndev, "%pV", &vaf);
+		trace_wil6210_log_err(&vaf);
+		va_end(args);
+	}
+}
+
 void wil_info(struct wil6210_priv *wil, const char *fmt, ...)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 18cff53..450b688 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -475,6 +475,8 @@ void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
 __printf(2, 3)
 void wil_err(struct wil6210_priv *wil, const char *fmt, ...);
 __printf(2, 3)
+void wil_err_ratelimited(struct wil6210_priv *wil, const char *fmt, ...);
+__printf(2, 3)
 void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_dbg(wil, fmt, arg...) do { \
 	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
-- 
2.1.0

