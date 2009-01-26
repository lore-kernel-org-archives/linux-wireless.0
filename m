Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZAZSwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:52:21 -0500
Message-Id: <20090126184925.677935607@sipsolutions.net> (sfid-20090126_195229_297052_DA233D7F)
References: <20090126184740.036240879@sipsolutions.net>
Date: Mon, 26 Jan 2009 19:47:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Sujith.Manoharan@atheros.com, tomasw@gmail.com
Subject: [RFC/RFT 6/7] mac80211: fix RX aggregation timeouts
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The values are in TUs (1.024ms), not ms.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c       |    4 ++--
 net/mac80211/sta_info.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-01-26 16:56:28.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-01-26 16:56:46.000000000 +0100
@@ -1652,7 +1652,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		/* reset session timer */
 		if (tid_agg_rx->timeout) {
 			unsigned long expires =
-				jiffies + (tid_agg_rx->timeout / 1000) * HZ;
+				jiffies + (tid_agg_rx->timeout / 1024) * HZ;
 			mod_timer(&tid_agg_rx->session_timer, expires);
 		}
 
@@ -2393,7 +2393,7 @@ static u8 ieee80211_rx_reorder_ampdu(str
 	/* reset session timer */
 	if (tid_agg_rx->timeout) {
 		unsigned long expires =
-			jiffies + (tid_agg_rx->timeout / 1000) * HZ;
+			jiffies + (tid_agg_rx->timeout / 1024) * HZ;
 		mod_timer(&tid_agg_rx->session_timer, expires);
 	}
 
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-01-26 16:55:59.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-01-26 16:56:10.000000000 +0100
@@ -88,7 +88,7 @@ struct tid_ampdu_tx {
  * @stored_mpdu_num: number of MPDUs in reordering buffer
  * @ssn: Starting Sequence Number expected to be aggregated.
  * @buf_size: buffer size for incoming A-MPDUs
- * @timeout: reset timer value.
+ * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  */
 struct tid_ampdu_rx {

-- 

