Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22599 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbdJEGFl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 02:05:41 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: move ath10k_mac_tdls_vif*() functions
Date: Thu, 5 Oct 2017 11:38:28 +0530
Message-ID: <1507183709-585-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20171005_080546_265422_84F3EE06)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

To be able to use ath10k_mac_tdls_vif_stations_count() in
ath10k_hw_scan() in the following patch, move the functions
earlier in the file.

This commit is pure code move, no functional changes.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |  106 ++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5683f1a5330e..0f14da73cf64 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5575,6 +5575,59 @@ static void ath10k_mac_op_set_coverage_class(struct ieee80211_hw *hw, s16 value)
 	ar->hw_params.hw_ops->set_coverage_class(ar, value);
 }
 
+struct ath10k_mac_tdls_iter_data {
+	u32 num_tdls_stations;
+	struct ieee80211_vif *curr_vif;
+};
+
+static void ath10k_mac_tdls_vif_stations_count_iter(void *data,
+						    struct ieee80211_sta *sta)
+{
+	struct ath10k_mac_tdls_iter_data *iter_data = data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ieee80211_vif *sta_vif = arsta->arvif->vif;
+
+	if (sta->tdls && sta_vif == iter_data->curr_vif)
+		iter_data->num_tdls_stations++;
+}
+
+static int ath10k_mac_tdls_vif_stations_count(struct ieee80211_hw *hw,
+					      struct ieee80211_vif *vif)
+{
+	struct ath10k_mac_tdls_iter_data data = {};
+
+	data.curr_vif = vif;
+
+	ieee80211_iterate_stations_atomic(hw,
+					  ath10k_mac_tdls_vif_stations_count_iter,
+					  &data);
+	return data.num_tdls_stations;
+}
+
+static void ath10k_mac_tdls_vifs_count_iter(void *data, u8 *mac,
+					    struct ieee80211_vif *vif)
+{
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	int *num_tdls_vifs = data;
+
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (ath10k_mac_tdls_vif_stations_count(arvif->ar->hw, vif) > 0)
+		(*num_tdls_vifs)++;
+}
+
+static int ath10k_mac_tdls_vifs_count(struct ieee80211_hw *hw)
+{
+	int num_tdls_vifs = 0;
+
+	ieee80211_iterate_active_interfaces_atomic(hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   ath10k_mac_tdls_vifs_count_iter,
+						   &num_tdls_vifs);
+	return num_tdls_vifs;
+}
+
 static int ath10k_hw_scan(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_scan_request *hw_req)
@@ -6000,59 +6053,6 @@ static void ath10k_mac_dec_num_stations(struct ath10k_vif *arvif,
 	ar->num_stations--;
 }
 
-struct ath10k_mac_tdls_iter_data {
-	u32 num_tdls_stations;
-	struct ieee80211_vif *curr_vif;
-};
-
-static void ath10k_mac_tdls_vif_stations_count_iter(void *data,
-						    struct ieee80211_sta *sta)
-{
-	struct ath10k_mac_tdls_iter_data *iter_data = data;
-	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
-	struct ieee80211_vif *sta_vif = arsta->arvif->vif;
-
-	if (sta->tdls && sta_vif == iter_data->curr_vif)
-		iter_data->num_tdls_stations++;
-}
-
-static int ath10k_mac_tdls_vif_stations_count(struct ieee80211_hw *hw,
-					      struct ieee80211_vif *vif)
-{
-	struct ath10k_mac_tdls_iter_data data = {};
-
-	data.curr_vif = vif;
-
-	ieee80211_iterate_stations_atomic(hw,
-					  ath10k_mac_tdls_vif_stations_count_iter,
-					  &data);
-	return data.num_tdls_stations;
-}
-
-static void ath10k_mac_tdls_vifs_count_iter(void *data, u8 *mac,
-					    struct ieee80211_vif *vif)
-{
-	struct ath10k_vif *arvif = (void *)vif->drv_priv;
-	int *num_tdls_vifs = data;
-
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return;
-
-	if (ath10k_mac_tdls_vif_stations_count(arvif->ar->hw, vif) > 0)
-		(*num_tdls_vifs)++;
-}
-
-static int ath10k_mac_tdls_vifs_count(struct ieee80211_hw *hw)
-{
-	int num_tdls_vifs = 0;
-
-	ieee80211_iterate_active_interfaces_atomic(hw,
-						   IEEE80211_IFACE_ITER_NORMAL,
-						   ath10k_mac_tdls_vifs_count_iter,
-						   &num_tdls_vifs);
-	return num_tdls_vifs;
-}
-
 static int ath10k_sta_state(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta,
-- 
1.7.9.5
