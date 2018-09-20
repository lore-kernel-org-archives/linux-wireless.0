Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbeITRqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:46:07 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [RFCv3 1/2] mac80211: implement ieee80211_tx_rate_update to update rate
Date: Thu, 20 Sep 2018 17:35:15 +0530
Message-Id: <1537445116-10780-2-git-send-email-akolli@codeaurora.org> (sfid-20180920_140301_198122_64924813)
In-Reply-To: <1537445116-10780-1-git-send-email-akolli@codeaurora.org>
References: <1537445116-10780-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current mac80211 has provision to update tx status through
ieee80211_tx_status() and ieee80211_tx_status_ext(). But
drivers like ath10k updates the tx status from the skb except
txrate, txrate will be updated from a different path, peer stats.

Using ieee80211_tx_status_ext() in two different paths
  - (one for the stats, one for the tx rate) will duplicate the stats.

To avoid this stats duplication, ieee80211_tx_rate_update() is implemented.

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
V3:
  - Added new API in mac80211 to update tx rate(Johannes)

 include/net/mac80211.h |   14 ++++++++++++++
 net/mac80211/status.c  |   24 ++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c26d2d36cbe..042186a21770 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4331,6 +4331,20 @@ void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
 					   u32 thr);
 
 /**
+ * ieee80211_tx_rate_update - transmit rate update callback
+ *
+ * This function can be used in drivers that does not have provision
+ * in updating the tx rate in data path.
+ *
+ * @hw: the hardware the frame was transmitted by
+ * @status: tx status information
+ * @pubsta: the station to update the tx rate for.
+ */
+void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
+			      struct ieee80211_sta *pubsta,
+			      struct ieee80211_tx_info *info);
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9a6d7208bf4f..232297ddaa02 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -988,6 +988,30 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_status_ext);
 
+void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
+			      struct ieee80211_sta *pubsta,
+			      struct ieee80211_tx_info *info)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_supported_band *sband;
+	struct sta_info *sta;
+	struct ieee80211_tx_status status;
+
+	sband = hw->wiphy->bands[info->band];
+
+	if (pubsta) {
+		sta = container_of(pubsta, struct sta_info, sta);
+		status.skb = NULL;
+		status.info = info;
+		status.sta = pubsta;
+
+		rate_control_tx_status(local, sband, &status);
+		if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL))
+			sta->tx_stats.last_rate = info->status.rates[0];
+	}
+}
+EXPORT_SYMBOL(ieee80211_tx_rate_update);
+
 void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
-- 
1.7.9.5
