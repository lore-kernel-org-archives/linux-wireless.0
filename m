Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:38681 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3CSNZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 09:25:26 -0400
Subject: [PATCH] ath6kl: fix size_t printf warnings
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 15:25:20 +0200
Message-ID: <20130319132520.30756.84770.stgit@localhost6.localdomain6> (sfid-20130319_142529_643234_F52D4322)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My new tracing code for ath6kl introduced these warnings on 64-bit:

trace.h:38:1: warning: format '%d' expects argument of type 'int',
	but argument 4 has type 'size_t' [-Wformat]
trace.h:61:1: warning: format '%d' expects argument of type 'int',
	but argument 4 has type 'size_t' [-Wformat]
trace.h:84:1: warning: format '%d' expects argument of type 'int',
	but argument 6 has type 'size_t' [-Wformat]
trace.h:119:1: warning: format '%d' expects argument of type 'int',
	but argument 7 has type 'size_t' [-Wformat]
trace.h:173:1: warning: format '%d' expects argument of type 'int',
	but argument 3 has type 'size_t' [-Wformat]
trace.h:193:1: warning: format '%d' expects argument of type 'int',
	but argument 5 has type 'size_t' [-Wformat]
trace.h:221:1: warning: format '%d' expects argument of type 'int',
	but argument 5 has type 'size_t' [-Wformat]

Fix them by using %zd.

Reported-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/trace.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index 6af6fa0..1a1ea78 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -53,7 +53,7 @@ TRACE_EVENT(ath6kl_wmi_cmd,
 	),
 
 	TP_printk(
-		"id %d len %d",
+		"id %d len %zd",
 		__entry->id, __entry->buf_len
 	)
 );
@@ -76,7 +76,7 @@ TRACE_EVENT(ath6kl_wmi_event,
 	),
 
 	TP_printk(
-		"id %d len %d",
+		"id %d len %zd",
 		__entry->id, __entry->buf_len
 	)
 );
@@ -108,7 +108,7 @@ TRACE_EVENT(ath6kl_sdio,
 	),
 
 	TP_printk(
-		"%s addr 0x%x flags 0x%x len %d\n",
+		"%s addr 0x%x flags 0x%x len %zd\n",
 		__entry->tx ? "tx" : "rx",
 		__entry->addr,
 		__entry->flags,
@@ -161,7 +161,7 @@ TRACE_EVENT(ath6kl_sdio_scat,
 	),
 
 	TP_printk(
-		"%s addr 0x%x flags 0x%x entries %d total_len %d\n",
+		"%s addr 0x%x flags 0x%x entries %d total_len %zd\n",
 		__entry->tx ? "tx" : "rx",
 		__entry->addr,
 		__entry->flags,
@@ -186,7 +186,7 @@ TRACE_EVENT(ath6kl_sdio_irq,
 	),
 
 	TP_printk(
-		"irq len %d\n", __entry->buf_len
+		"irq len %zd\n", __entry->buf_len
 	)
 );
 
@@ -211,7 +211,7 @@ TRACE_EVENT(ath6kl_htc_rx,
 	),
 
 	TP_printk(
-		"status %d endpoint %d len %d\n",
+		"status %d endpoint %d len %zd\n",
 		__entry->status,
 		__entry->endpoint,
 		__entry->buf_len
@@ -239,7 +239,7 @@ TRACE_EVENT(ath6kl_htc_tx,
 	),
 
 	TP_printk(
-		"status %d endpoint %d len %d\n",
+		"status %d endpoint %d len %zd\n",
 		__entry->status,
 		__entry->endpoint,
 		__entry->buf_len

