Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:26023 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0EXISx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:18:53 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 3/6] wl1271: Flush TX buffers to air before going to idle
Date: Mon, 24 May 2010 11:18:17 +0300
Message-Id: <1274689100-14785-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
References: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The mac80211 changes to idle almost immediately after transmitting some
frames, such as deauth etc. When going to idle, the wl1271 is disconnected,
which causes TX frames already on buffers, but not yet transmitted, to be
deleted.

To make sure deauth frames reach the air, allow the TX buffers to flush
before proceeding to idle.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   11 ++++++++-
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   36 ++++++++++++++++++++++++++--
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    1 +
 4 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 973b742..dd2dafc 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -422,6 +422,7 @@ struct wl1271 {
 
 	/* Pending TX frames */
 	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
+	int tx_frames_cnt;
 
 	/* Security sequence number counters */
 	u8 tx_security_last_seq;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 7404aa6..50650e6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1044,7 +1044,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&wl->mutex);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
-	wl1271_tx_flush(wl);
+	wl1271_tx_reset(wl);
 	wl1271_power_off(wl);
 
 	memset(wl->bssid, 0, ETH_ALEN);
@@ -1291,6 +1291,15 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		     conf->power_level,
 		     conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use");
 
+	/*
+	 * mac80211 will go to idle nearly immediately after transmitting some
+	 * frames, such as the deauth. To make sure those frames reach the air,
+	 * wait here until the TX queue is fully flushed.
+	 */
+	if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
+	    (conf->flags & IEEE80211_CONF_IDLE))
+		wl1271_tx_flush(wl);
+
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 62db795..c592cc2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -36,6 +36,7 @@ static int wl1271_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		if (wl->tx_frames[i] == NULL) {
 			wl->tx_frames[i] = skb;
+			wl->tx_frames_cnt++;
 			return i;
 		}
 
@@ -73,8 +74,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
 		wl1271_debug(DEBUG_TX,
 			     "tx_allocate: size: %d, blocks: %d, id: %d",
 			     total_len, total_blocks, id);
-	} else
+	} else {
 		wl->tx_frames[id] = NULL;
+		wl->tx_frames_cnt--;
+	}
 
 	return ret;
 }
@@ -358,6 +361,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	/* return the packet to the stack */
 	ieee80211_tx_status(wl->hw, skb);
 	wl->tx_frames[result->id] = NULL;
+	wl->tx_frames_cnt--;
 }
 
 /* Called upon reception of a TX complete interrupt */
@@ -412,7 +416,7 @@ void wl1271_tx_complete(struct wl1271 *wl)
 }
 
 /* caller must hold wl->mutex */
-void wl1271_tx_flush(struct wl1271 *wl)
+void wl1271_tx_reset(struct wl1271 *wl)
 {
 	int i;
 	struct sk_buff *skb;
@@ -421,7 +425,7 @@ void wl1271_tx_flush(struct wl1271 *wl)
 /* 	control->flags = 0; FIXME */
 
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
-		wl1271_debug(DEBUG_TX, "flushing skb 0x%p", skb);
+		wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
 		ieee80211_tx_status(wl->hw, skb);
 	}
 
@@ -429,6 +433,32 @@ void wl1271_tx_flush(struct wl1271 *wl)
 		if (wl->tx_frames[i] != NULL) {
 			skb = wl->tx_frames[i];
 			wl->tx_frames[i] = NULL;
+			wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
 			ieee80211_tx_status(wl->hw, skb);
 		}
+	wl->tx_frames_cnt = 0;
+}
+
+#define WL1271_TX_FLUSH_TIMEOUT 500000
+
+/* caller must *NOT* hold wl->mutex */
+void wl1271_tx_flush(struct wl1271 *wl)
+{
+	unsigned long timeout;
+	timeout = jiffies + usecs_to_jiffies(WL1271_TX_FLUSH_TIMEOUT);
+
+	while (!time_after(jiffies, timeout)) {
+		mutex_lock(&wl->mutex);
+		wl1271_debug(DEBUG_TX, "flushing tx buffer: %d",
+			     wl->tx_frames_cnt);
+		if ((wl->tx_frames_cnt == 0) &&
+		    skb_queue_empty(&wl->tx_queue)) {
+			mutex_unlock(&wl->mutex);
+			return;
+		}
+		mutex_unlock(&wl->mutex);
+		msleep(1);
+	}
+
+	wl1271_warning("Unable to flush all TX buffers, timed out.");
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index 3b8b7ac..0ae0063 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -158,6 +158,7 @@ static inline int wl1271_tx_ac_to_tid(int ac)
 
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_complete(struct wl1271 *wl);
+void wl1271_tx_reset(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
 u8 wl1271_rate_to_idx(struct wl1271 *wl, int rate);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
-- 
1.6.3.3

