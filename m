Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab1LWHO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:29 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/10] iwlegacy: random 3945-rs.c cleanups
Date: Fri, 23 Dec 2011 08:13:48 +0100
Message-Id: <1324624430-3688-8-git-send-email-sgruszka@redhat.com> (sfid-20111223_081431_433244_E9F6FA83)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-rs.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index 30ad404..d7a83f2 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -86,16 +86,16 @@ static struct il3945_tpt_entry il3945_tpt_table_g[] = {
 	{-92, RATE_1M_IDX}
 };
 
-#define RATE_MAX_WINDOW          62
+#define RATE_MAX_WINDOW		62
 #define RATE_FLUSH		(3*HZ)
-#define RATE_WIN_FLUSH       (HZ/2)
-#define IL39_RATE_HIGH_TH          11520
-#define IL_SUCCESS_UP_TH	   8960
-#define IL_SUCCESS_DOWN_TH	  10880
-#define RATE_MIN_FAILURE_TH       6
-#define RATE_MIN_SUCCESS_TH       8
-#define RATE_DECREASE_TH       1920
-#define RATE_RETRY_TH	     15
+#define RATE_WIN_FLUSH		(HZ/2)
+#define IL39_RATE_HIGH_TH	11520
+#define IL_SUCCESS_UP_TH	8960
+#define IL_SUCCESS_DOWN_TH	10880
+#define RATE_MIN_FAILURE_TH	6
+#define RATE_MIN_SUCCESS_TH	8
+#define RATE_DECREASE_TH	1920
+#define RATE_RETRY_TH		15
 
 static u8
 il3945_get_rate_idx_by_rssi(s32 rssi, enum ieee80211_band band)
@@ -112,12 +112,10 @@ il3945_get_rate_idx_by_rssi(s32 rssi, enum ieee80211_band band)
 		tpt_table = il3945_tpt_table_g;
 		table_size = ARRAY_SIZE(il3945_tpt_table_g);
 		break;
-
 	case IEEE80211_BAND_5GHZ:
 		tpt_table = il3945_tpt_table_a;
 		table_size = ARRAY_SIZE(il3945_tpt_table_a);
 		break;
-
 	default:
 		BUG();
 		break;
@@ -126,7 +124,7 @@ il3945_get_rate_idx_by_rssi(s32 rssi, enum ieee80211_band band)
 	while (idx < table_size && rssi < tpt_table[idx].min_rssi)
 		idx++;
 
-	idx = min(idx, (table_size - 1));
+	idx = min(idx, table_size - 1);
 
 	return tpt_table[idx].idx;
 }
@@ -328,7 +326,6 @@ il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 	win->stamp = jiffies;
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
-
 }
 
 /*
@@ -386,8 +383,7 @@ il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 	/* For 5 GHz band it start at IL_FIRST_OFDM_RATE */
 	if (sband->band == IEEE80211_BAND_5GHZ) {
 		rs_sta->last_txrate_idx += IL_FIRST_OFDM_RATE;
-		il->_3945.sta_supp_rates =
-		    il->_3945.sta_supp_rates << IL_FIRST_OFDM_RATE;
+		il->_3945.sta_supp_rates <<= IL_FIRST_OFDM_RATE;
 	}
 
 out:
@@ -406,7 +402,6 @@ il3945_rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 static void
 il3945_rs_free(void *il)
 {
-	return;
 }
 
 static void *
@@ -791,19 +786,16 @@ il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 
 	switch (scale_action) {
 	case -1:
-
 		/* Decrese rate */
 		if (low != RATE_INVALID)
 			idx = low;
 		break;
-
 	case 1:
 		/* Increase rate */
 		if (high != RATE_INVALID)
 			idx = high;
 
 		break;
-
 	case 0:
 	default:
 		/* No change */
@@ -958,7 +950,6 @@ il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 		} else
 			rs_sta->expected_tpt = il3945_expected_tpt_g;
 		break;
-
 	case IEEE80211_BAND_5GHZ:
 		rs_sta->expected_tpt = il3945_expected_tpt_a;
 		break;
-- 
1.7.4.4

