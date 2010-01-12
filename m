Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32815 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0ALInW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 03:43:22 -0500
Subject: [PATCH PATCH v6 3/7] mac80211: create tx handler for dynamic ps
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	a.young.jason@gmail.com
Date: Tue, 12 Jan 2010 10:42:46 +0200
Message-ID: <20100112084246.27492.22088.stgit@tikku>
In-Reply-To: <20100112084059.27492.86738.stgit@tikku>
References: <20100112084059.27492.86738.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Currently dynamic ps check is in ieee80211_xmit(), but it's cleaner
to have a separate tx handler for this. Also this is a prerequisite for
U-APSD client mode which needs to know the queue frame is in.

Also need_dynamic_ps() function is embedded to the tx handler.

No functional changes expect that the code is run in a later phase than
originally.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/tx.c |   81 +++++++++++++++++++++++++++--------------------------
 1 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 140da4a..cf846a3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -180,6 +180,46 @@ static int inline is_ieee80211_device(struct ieee80211_local *local,
 }
 
 /* tx handlers */
+static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_local *local = tx->local;
+
+	/* driver doesn't support power save */
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
+		return TX_CONTINUE;
+
+	/* hardware does dynamic power save */
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
+		return TX_CONTINUE;
+
+	/* dynamic power save disabled */
+	if (local->hw.conf.dynamic_ps_timeout <= 0)
+		return TX_CONTINUE;
+
+	/* we are scanning, don't enable power save */
+	if (local->scanning)
+		return TX_CONTINUE;
+
+	if (!local->ps_sdata)
+		return TX_CONTINUE;
+
+	/* No point if we're going to suspend */
+	if (local->quiescing)
+		return TX_CONTINUE;
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+		ieee80211_stop_queues_by_reason(&local->hw,
+						IEEE80211_QUEUE_STOP_REASON_PS);
+		ieee80211_queue_work(&local->hw,
+				     &local->dynamic_ps_disable_work);
+	}
+
+	mod_timer(&local->dynamic_ps_timer, jiffies +
+		  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+
+	return TX_CONTINUE;
+}
 
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
@@ -1215,6 +1255,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 			goto txh_done;	\
 	} while (0)
 
+	CALL_TXH(ieee80211_tx_h_dynamic_ps);
 	CALL_TXH(ieee80211_tx_h_check_assoc);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_select_key);
@@ -1397,34 +1438,6 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 	return 0;
 }
 
-static bool need_dynamic_ps(struct ieee80211_local *local)
-{
-	/* driver doesn't support power save */
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
-		return false;
-
-	/* hardware does dynamic power save */
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
-		return false;
-
-	/* dynamic power save disabled */
-	if (local->hw.conf.dynamic_ps_timeout <= 0)
-		return false;
-
-	/* we are scanning, don't enable power save */
-	if (local->scanning)
-		return false;
-
-	if (!local->ps_sdata)
-		return false;
-
-	/* No point if we're going to suspend */
-	if (local->quiescing)
-		return false;
-
-	return true;
-}
-
 static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
@@ -1435,18 +1448,6 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	int headroom;
 	bool may_encrypt;
 
-	if (need_dynamic_ps(local)) {
-		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-			ieee80211_stop_queues_by_reason(&local->hw,
-					IEEE80211_QUEUE_STOP_REASON_PS);
-			ieee80211_queue_work(&local->hw,
-					&local->dynamic_ps_disable_work);
-		}
-
-		mod_timer(&local->dynamic_ps_timer, jiffies +
-		        msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
-	}
-
 	rcu_read_lock();
 
 	if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {

