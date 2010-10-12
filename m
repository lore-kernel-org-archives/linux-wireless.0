Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49464 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab0JLOUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 10:20:13 -0400
Received: by wwj40 with SMTP id 40so5087961wwj.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 07:20:12 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ido Yariv <ido@wizery.com>
Subject: [PATCH v4 3/4] wl1271: Allocate TX descriptors more efficiently
Date: Tue, 12 Oct 2010 16:20:06 +0200
Message-Id: <1286893206-24930-1-git-send-email-ido@wizery.com>
In-Reply-To: <1286888188.3753.4.camel@jlt3.sipsolutions.net>
References: <1286888188.3753.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On each TX descriptor allocation, a free entry is found by traversing the TX
descriptors array.

Improve this by holding a bitmap of all TX descriptors, and using efficient
bit operations to search for free entries.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
Changes from v3:
- Use non-atomic bitops when allocating/deallocating TX descriptors

 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |    1 +
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   38 ++++++++++++++++------------
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 4a034a3..718e96d 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -398,6 +398,7 @@ struct wl1271 {
 	struct work_struct tx_work;
 
 	/* Pending TX frames */
+	unsigned long tx_frames_map[BITS_TO_LONGS(ACX_TX_DESCRIPTORS)];
 	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
 	int tx_frames_cnt;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 18aff22..0fd4725 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2532,6 +2532,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
 
+	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index cf32a77..85878e5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -30,17 +30,26 @@
 #include "wl1271_ps.h"
 #include "wl1271_tx.h"
 
-static int wl1271_tx_id(struct wl1271 *wl, struct sk_buff *skb)
+static int wl1271_alloc_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 {
-	int i;
-	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
-		if (wl->tx_frames[i] == NULL) {
-			wl->tx_frames[i] = skb;
-			wl->tx_frames_cnt++;
-			return i;
-		}
+	int id;
+
+	id = find_first_zero_bit(wl->tx_frames_map, ACX_TX_DESCRIPTORS);
+	if (id >= ACX_TX_DESCRIPTORS)
+		return -EBUSY;
+
+	__set_bit(id, wl->tx_frames_map);
+	wl->tx_frames[id] = skb;
+	wl->tx_frames_cnt++;
+	return id;
+}
 
-	return -EBUSY;
+static void wl1271_free_tx_id(struct wl1271 *wl, int id)
+{
+	if (__test_and_clear_bit(id, wl->tx_frames_map)) {
+		wl->tx_frames[id] = NULL;
+		wl->tx_frames_cnt--;
+	}
 }
 
 static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
@@ -55,7 +64,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		return -EAGAIN;
 
 	/* allocate free identifier for the packet */
-	id = wl1271_tx_id(wl, skb);
+	id = wl1271_alloc_tx_id(wl, skb);
 	if (id < 0)
 		return id;
 
@@ -79,8 +88,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 			     "tx_allocate: size: %d, blocks: %d, id: %d",
 			     total_len, total_blocks, id);
 	} else {
-		wl->tx_frames[id] = NULL;
-		wl->tx_frames_cnt--;
+		wl1271_free_tx_id(wl, id);
 	}
 
 	return ret;
@@ -352,8 +360,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 
 	/* return the packet to the stack */
 	ieee80211_tx_status(wl->hw, skb);
-	wl->tx_frames[result->id] = NULL;
-	wl->tx_frames_cnt--;
+	wl1271_free_tx_id(wl, result->id);
 }
 
 /* Called upon reception of a TX complete interrupt */
@@ -422,11 +429,10 @@ void wl1271_tx_reset(struct wl1271 *wl)
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		if (wl->tx_frames[i] != NULL) {
 			skb = wl->tx_frames[i];
-			wl->tx_frames[i] = NULL;
+			wl1271_free_tx_id(wl, i);
 			wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
 			ieee80211_tx_status(wl->hw, skb);
 		}
-	wl->tx_frames_cnt = 0;
 }
 
 #define WL1271_TX_FLUSH_TIMEOUT 500000
-- 
1.7.0.4

