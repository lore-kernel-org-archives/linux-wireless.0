Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:60269 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbZEWS2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2009 14:28:21 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ar9170: use bitop macros for tx filter flags
Date: Sat, 23 May 2009 20:28:21 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200905232028.21844.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in configure_filter's (sub-)routines.
We never really cleared the flags once we updated the hardware state,
so we wasted our resources by applying already active settings.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

please apply these together with the bits from the last series

[PATCH 1/6] ar9170: fix beacon plcp settings
[PATCH 2/6] ar9170: update hardware definitions
[PATCH 3/6] ar9170: 40MHz fixes
[PATCH 4/6] ar9170: introduce functions for MAC programming

to wireless-2.6 when you're back from Spain.

Regards,
	Chr
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 77dc647..1247dcb 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -140,7 +140,7 @@ struct ar9170 {
 	struct work_struct filter_config_work;
 	u64 cur_mc_hash, want_mc_hash;
 	u32 cur_filter, want_filter;
-	unsigned int filter_changed;
+	unsigned long filter_changed;
 	unsigned int filter_state;
 	bool sniffer_enabled;
 
@@ -195,7 +195,7 @@ struct ar9170_sta_info {
 #define IS_STARTED(a)		(a->state >= AR9170_STARTED)
 #define IS_ACCEPTING_CMD(a)	(a->state >= AR9170_IDLE)
 
-#define AR9170_FILTER_CHANGED_PROMISC		BIT(0)
+#define AR9170_FILTER_CHANGED_MODE		BIT(0)
 #define AR9170_FILTER_CHANGED_MULTICAST		BIT(1)
 #define AR9170_FILTER_CHANGED_FRAMEFILTER	BIT(2)
 
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c54c42e..201989a 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -957,6 +957,8 @@ static int ar9170_op_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&ar->mutex);
 
+	ar->filter_changed = 0;
+
 	/* reinitialize queues statistics */
 	memset(&ar->tx_stats, 0, sizeof(ar->tx_stats));
 	for (i = 0; i < ARRAY_SIZE(ar->tx_stats); i++)
@@ -1376,20 +1378,26 @@ static void ar9170_set_filters(struct work_struct *work)
 		return ;
 
 	mutex_lock(&ar->mutex);
-	if (ar->filter_changed & AR9170_FILTER_CHANGED_PROMISC) {
+	if (test_and_clear_bit(AR9170_FILTER_CHANGED_MODE,
+			       &ar->filter_changed)) {
 		err = ar9170_set_operating_mode(ar);
 		if (err)
 			goto unlock;
 	}
 
-	if (ar->filter_changed & AR9170_FILTER_CHANGED_MULTICAST) {
+	if (test_and_clear_bit(AR9170_FILTER_CHANGED_MULTICAST,
+			       &ar->filter_changed)) {
 		err = ar9170_update_multicast(ar);
 		if (err)
 			goto unlock;
 	}
 
-	if (ar->filter_changed & AR9170_FILTER_CHANGED_FRAMEFILTER)
+	if (test_and_clear_bit(AR9170_FILTER_CHANGED_FRAMEFILTER,
+			       &ar->filter_changed)) {
 		err = ar9170_update_frame_filter(ar);
+		if (err)
+			goto unlock;
+	}
 
 unlock:
 	mutex_unlock(&ar->mutex);
@@ -1419,7 +1427,7 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 			int i;
 
 			/* always get broadcast frames */
-			mchash = 1ULL << (0xff>>2);
+			mchash = 1ULL << (0xff >> 2);
 
 			for (i = 0; i < mc_count; i++) {
 				if (WARN_ON(!mclist))
@@ -1429,7 +1437,7 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 			}
 		ar->want_mc_hash = mchash;
 		}
-		ar->filter_changed |= AR9170_FILTER_CHANGED_MULTICAST;
+		set_bit(AR9170_FILTER_CHANGED_MULTICAST, &ar->filter_changed);
 	}
 
 	if (changed_flags & FIF_CONTROL) {
@@ -1445,12 +1453,14 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 		else
 			ar->want_filter = ar->cur_filter & ~filter;
 
-		ar->filter_changed |= AR9170_FILTER_CHANGED_FRAMEFILTER;
+		set_bit(AR9170_FILTER_CHANGED_FRAMEFILTER,
+			&ar->filter_changed);
 	}
 
 	if (changed_flags & FIF_PROMISC_IN_BSS) {
 		ar->sniffer_enabled = ((*new_flags) & FIF_PROMISC_IN_BSS) != 0;
-		ar->filter_changed |= AR9170_FILTER_CHANGED_PROMISC;
+		set_bit(AR9170_FILTER_CHANGED_MODE,
+			&ar->filter_changed);
 	}
 
 	if (likely(IS_STARTED(ar)))
