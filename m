Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45826 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab1IGGGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 02:06:00 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH v2] mac80211: retry sending failed BAR frames later instead of tearing down aggr
Date: Wed,  7 Sep 2011 08:05:44 +0200
Message-Id: <1315375544-94891-1-git-send-email-nbd@openwrt.org> (sfid-20110907_080611_871838_63C107C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately failed BAR tx attempts happen more frequently than I
expected, and the resulting aggregation teardowns cause performance
issues, as the aggregation session does not always get re-established
properly.
Instead of tearing down the entire aggr session, we can simply store the
SSN of the last failed BAR tx attempt, wait for the first successful
tx status event, and then send another BAR with the same SSN.

Also fix an endian bug on accessing the control field of the BAR

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/sta_info.h |    5 +++++
 net/mac80211/status.c   |   44 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e9eb565..56a3d38 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -86,6 +86,8 @@ enum ieee80211_sta_info_flags {
  * @stop_initiator: initiator of a session stop
  * @tx_stop: TX DelBA frame when stopping
  * @buf_size: reorder buffer size at receiver
+ * @failed_bar_ssn: ssn of the last failed BAR tx attempt
+ * @bar_pending: BAR needs to be re-sent
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
@@ -106,6 +108,9 @@ struct tid_ampdu_tx {
 	u8 stop_initiator;
 	bool tx_stop;
 	u8 buf_size;
+
+	u16 failed_bar_ssn;
+	bool bar_pending;
 };
 
 /**
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e51bd2a..56a0e55 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -127,12 +127,32 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	dev_kfree_skb(skb);
 }
 
+static void ieee80211_check_pending_bar(struct sta_info *sta, u8 *addr, u8 tid)
+{
+	struct tid_ampdu_tx *tid_tx;
+
+	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+	if (!tid_tx || !tid_tx->bar_pending)
+		return;
+
+	tid_tx->bar_pending = false;
+	ieee80211_send_bar(sta->sdata, addr, tid, tid_tx->failed_bar_ssn);
+}
+
 static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *) skb->data;
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (ieee80211_is_data_qos(mgmt->frame_control)) {
+		struct ieee80211_hdr *hdr = (void *) skb->data;
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
+		u16 tid = qc[0] & 0xf;
+
+		ieee80211_check_pending_bar(sta, hdr->addr1, tid);
+	}
+
 	if (ieee80211_is_action(mgmt->frame_control) &&
 	    sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    mgmt->u.action.category == WLAN_CATEGORY_HT &&
@@ -161,6 +181,18 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	}
 }
 
+static void ieee80211_set_bar_pending(struct sta_info *sta, u8 tid, u16 ssn)
+{
+	struct tid_ampdu_tx *tid_tx;
+
+	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+	if (!tid_tx)
+		return;
+
+	tid_tx->failed_bar_ssn = ssn;
+	tid_tx->bar_pending = true;
+}
+
 /*
  * Use a static threshold for now, best value to be determined
  * by testing ...
@@ -246,6 +278,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 
 		if (!acked && ieee80211_is_back_req(fc)) {
+			u16 control;
+
 			/*
 			 * BAR failed, let's tear down the BA session as a
 			 * last resort as some STAs (Intel 5100 on Windows)
@@ -253,11 +287,15 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			 * correctly.
 			 */
 			bar = (struct ieee80211_bar *) skb->data;
-			if (!(bar->control & IEEE80211_BAR_CTRL_MULTI_TID)) {
-				tid = (bar->control &
+			control = le16_to_cpu(bar->control);
+			if (!(control & IEEE80211_BAR_CTRL_MULTI_TID)) {
+				u16 ssn = le16_to_cpu(bar->start_seq_num);
+
+				tid = (control &
 				       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
 				      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
-				ieee80211_stop_tx_ba_session(&sta->sta, tid);
+
+				ieee80211_set_bar_pending(sta, tid, ssn);
 			}
 		}
 
-- 
1.7.3.2

