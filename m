Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeC0GuT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 02:50:19 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFC 2/3] mac80211: Use proper smps_mode enum in sta opmode event
Date: Tue, 27 Mar 2018 12:18:15 +0530
Message-Id: <1522133296-2583-3-git-send-email-tamizhr@codeaurora.org> (sfid-20180327_085023_292887_ED01A2EA)
In-Reply-To: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
References: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SMPS_MODE change value notified via nl80211 contains mac80211
specific value(ieee80211_smps_mode) and user space application
will not know those values. This patch add support to map
the mac80211 enum value to nl80211_smps_mode which will be
understood by the userspace application.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/ht.c          | 15 +++++++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/rx.c          |  3 ++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index d752353..c78036a 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -466,6 +466,21 @@ void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 		__ieee80211_stop_tx_ba_session(sta, tid, AGG_STOP_PEER_REQUEST);
 }
 
+enum nl80211_smps_mode
+ieee80211_smps_mode_to_smps_mode(enum ieee80211_smps_mode smps)
+{
+	switch (smps) {
+	case IEEE80211_SMPS_OFF:
+		return NL80211_SMPS_OFF;
+	case IEEE80211_SMPS_STATIC:
+		return NL80211_SMPS_STATIC;
+	case IEEE80211_SMPS_DYNAMIC:
+		return NL80211_SMPS_DYNAMIC;
+	default:
+		return NL80211_SMPS_OFF;
+	}
+}
+
 int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae9c33c..9237ffb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1788,6 +1788,8 @@ void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
 u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
+enum nl80211_smps_mode
+ieee80211_smps_mode_to_smps_mode(enum ieee80211_smps_mode smps);
 
 /* VHT */
 void
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 27bb1f0..f8c69ac 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2883,7 +2883,8 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 			if (rx->sta->sta.smps_mode == smps_mode)
 				goto handled;
 			rx->sta->sta.smps_mode = smps_mode;
-			sta_opmode.smps_mode = smps_mode;
+			sta_opmode.smps_mode =
+				ieee80211_smps_mode_to_smps_mode(smps_mode);
 			sta_opmode.changed = STA_OPMODE_SMPS_MODE_CHANGED;
 
 			sband = rx->local->hw.wiphy->bands[status->band];
-- 
1.9.1
