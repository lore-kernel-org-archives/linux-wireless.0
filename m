Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZA2IkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 03:40:14 -0500
Message-Id: <20090129005807.911026064@sipsolutions.net> (sfid-20090129_094020_112467_60F9723D)
References: <20090129005450.068797016@sipsolutions.net>
Date: Thu, 29 Jan 2009 01:54:52 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: m.sujith@gmail.com, tomasw@gmail.com
Subject: [RFC/RFT 02/11] mac80211: fix RX aggregation timeouts
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The values are in TUs (1.024ms), not ms.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mesh_hwmp.c   |    1 -
 net/mac80211/rx.c          |   16 ++++++----------
 net/mac80211/sta_info.h    |    2 +-
 4 files changed, 9 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-01-27 11:39:15.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-01-27 11:39:20.000000000 +0100
@@ -1650,11 +1650,9 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		start_seq_num = le16_to_cpu(bar->start_seq_num) >> 4;
 
 		/* reset session timer */
-		if (tid_agg_rx->timeout) {
-			unsigned long expires =
-				jiffies + (tid_agg_rx->timeout / 1000) * HZ;
-			mod_timer(&tid_agg_rx->session_timer, expires);
-		}
+		if (tid_agg_rx->timeout)
+			mod_timer(&tid_agg_rx->session_timer,
+				  TU_TO_EXP_TIME(tid_agg_rx->timeout));
 
 		/* manage reordering buffer according to requested */
 		/* sequence number */
@@ -2391,11 +2389,9 @@ static u8 ieee80211_rx_reorder_ampdu(str
 	/* new un-ordered ampdu frame - process it */
 
 	/* reset session timer */
-	if (tid_agg_rx->timeout) {
-		unsigned long expires =
-			jiffies + (tid_agg_rx->timeout / 1000) * HZ;
-		mod_timer(&tid_agg_rx->session_timer, expires);
-	}
+	if (tid_agg_rx->timeout)
+		mod_timer(&tid_agg_rx->session_timer,
+			  TU_TO_EXP_TIME(tid_agg_rx->timeout));
 
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-01-27 11:39:16.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-01-27 11:39:23.000000000 +0100
@@ -88,7 +88,7 @@ struct tid_ampdu_tx {
  * @stored_mpdu_num: number of MPDUs in reordering buffer
  * @ssn: Starting Sequence Number expected to be aggregated.
  * @buf_size: buffer size for incoming A-MPDUs
- * @timeout: reset timer value.
+ * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  */
 struct tid_ampdu_rx {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-27 11:39:15.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-27 11:39:24.000000000 +0100
@@ -57,6 +57,8 @@ struct ieee80211_local;
  */
 #define IEEE80211_SCAN_RESULT_EXPIRE (10 * HZ)
 
+#define TU_TO_EXP_TIME(x)	(jiffies + usecs_to_jiffies((x) * 1024))
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2009-01-27 11:39:15.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2009-01-27 11:39:20.000000000 +0100
@@ -58,7 +58,6 @@ static inline u32 u32_field_get(u8 *preq
 #define PERR_IE_DST_ADDR(x)	(x + 2)
 #define PERR_IE_DST_DSN(x)	u32_field_get(x, 8, 0);
 
-#define TU_TO_EXP_TIME(x) (jiffies + msecs_to_jiffies(x * 1024 / 1000))
 #define MSEC_TO_TU(x) (x*1000/1024)
 #define DSN_GT(x, y) ((long) (y) - (long) (x) < 0)
 #define DSN_LT(x, y) ((long) (x) - (long) (y) < 0)

-- 

