Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZA0KFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 05:05:31 -0500
Subject: [RFC/RFT 6/7 v2] mac80211: fix RX aggregation timeouts
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Sujith.Manoharan@atheros.com, tomasw@gmail.com
In-Reply-To: <20090126184925.677935607@sipsolutions.net> (sfid-20090126_195229_297052_DA233D7F)
References: <20090126184740.036240879@sipsolutions.net>
	 <20090126184925.677935607@sipsolutions.net>
	 (sfid-20090126_195229_297052_DA233D7F)
Content-Type: text/plain
Date: Tue, 27 Jan 2009 11:05:26 +0100
Message-Id: <1233050726.4012.24.camel@johannes.local> (sfid-20090127_110536_775867_BE4D7389)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The values are in TUs (1.024ms), not ms.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Not sure what I was thinking, but clearly wrong. This is correct and
cleaner, I hope.

 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mesh_hwmp.c   |    1 -
 net/mac80211/rx.c          |   16 ++++++----------
 net/mac80211/sta_info.h    |    2 +-
 4 files changed, 9 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-01-27 10:13:33.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-01-27 10:59:10.000000000 +0100
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
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-01-27 10:13:33.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-01-27 10:56:50.000000000 +0100
@@ -88,7 +88,7 @@ struct tid_ampdu_tx {
  * @stored_mpdu_num: number of MPDUs in reordering buffer
  * @ssn: Starting Sequence Number expected to be aggregated.
  * @buf_size: buffer size for incoming A-MPDUs
- * @timeout: reset timer value.
+ * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  */
 struct tid_ampdu_rx {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-27 10:57:58.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-27 11:02:57.000000000 +0100
@@ -57,6 +57,8 @@ struct ieee80211_local;
  */
 #define IEEE80211_SCAN_RESULT_EXPIRE (10 * HZ)
 
+#define TU_TO_EXP_TIME(x)	(jiffies + usecs_to_jiffies((x) * 1024))
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2009-01-27 10:57:48.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2009-01-27 10:57:57.000000000 +0100
@@ -58,7 +58,6 @@ static inline u32 u32_field_get(u8 *preq
 #define PERR_IE_DST_ADDR(x)	(x + 2)
 #define PERR_IE_DST_DSN(x)	u32_field_get(x, 8, 0);
 
-#define TU_TO_EXP_TIME(x) (jiffies + msecs_to_jiffies(x * 1024 / 1000))
 #define MSEC_TO_TU(x) (x*1000/1024)
 #define DSN_GT(x, y) ((long) (y) - (long) (x) < 0)
 #define DSN_LT(x, y) ((long) (x) - (long) (y) < 0)


