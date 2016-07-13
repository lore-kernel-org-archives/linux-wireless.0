Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36441 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbcGMUUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 16:20:09 -0400
Received: by mail-wm0-f66.google.com with SMTP id x83so7062260wma.3
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 13:20:08 -0700 (PDT)
From: Alex Briskin <br.shurik@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Alex Briskin <br.shurik@gmail.com>
Subject: [PATCH 3/4 v1] Continue breaking down to smaller functions
Date: Wed, 13 Jul 2016 23:19:55 +0300
Message-Id: <1468441196-23503-4-git-send-email-br.shurik@gmail.com> (sfid-20160713_222013_920402_A9810C61)
In-Reply-To: <1468441196-23503-1-git-send-email-br.shurik@gmail.com>
References: <1468441196-23503-1-git-send-email-br.shurik@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit contains unhandled checkpatch warnings in code moved from
ieee80211_iface_work

Signed-off-by: Alex Briskin <br.shurik@gmail.com>
---
 net/mac80211/iface.c | 150 +++++++++++++++++++++++++++------------------------
 1 file changed, 81 insertions(+), 69 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1793ad2..41c3bd0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1245,6 +1245,85 @@ static bool ieee80211_is_skb_handled_by_pkt_type(struct sk_buff *skb,
 	return true;
 }
 
+static bool ieee80211_is_handled_by_frame_control(struct sk_buff *skb,
+						  struct ieee80211_sub_if_data
+						  *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+
+	if (ieee80211_is_action(mgmt->frame_control) &&
+	    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
+		int len = skb->len;
+
+		mutex_lock(&local->sta_mtx);
+		sta = sta_info_get_bss(sdata, mgmt->sa);
+		if (sta) {
+			switch (mgmt->u.action.u.addba_req.action_code) {
+			case WLAN_ACTION_ADDBA_REQ:
+				ieee80211_process_addba_request(local, sta,
+								mgmt, len);
+				break;
+			case WLAN_ACTION_ADDBA_RESP:
+				ieee80211_process_addba_resp(local, sta,
+							     mgmt, len);
+				break;
+			case WLAN_ACTION_DELBA:
+				ieee80211_process_delba(sdata, sta, mgmt, len);
+				break;
+			default:
+				WARN_ON(1);
+				break;
+			}
+		}
+		mutex_unlock(&local->sta_mtx);
+	} else if (ieee80211_is_action(mgmt->frame_control) &&
+		   mgmt->u.action.category == WLAN_CATEGORY_VHT) {
+		switch (mgmt->u.action.u.vht_group_notif.action_code) {
+		case WLAN_VHT_ACTION_GROUPID_MGMT:
+			ieee80211_process_mu_groups(sdata, mgmt);
+			break;
+		default:
+			WARN_ON(1);
+			break;
+		}
+	} else if (ieee80211_is_data_qos(mgmt->frame_control)) {
+		struct ieee80211_hdr *hdr = (void *)mgmt;
+		/*
+		 * So the frame isn't mgmt, but frame_control
+		 * is at the right place anyway, of course, so
+		 * the if statement is correct.
+		 *
+		 * Warn if we have other data frame types here,
+		 * they must not get here.
+		 */
+		WARN_ON(hdr->frame_control &
+			cpu_to_le16(IEEE80211_STYPE_NULLFUNC));
+		WARN_ON(!(hdr->seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)));
+		/*
+		 * This was a fragment of a frame, received while
+		 * a block-ack session was active. That cannot be
+		 * right, so terminate the session.
+		 */
+		mutex_lock(&local->sta_mtx);
+		sta = sta_info_get_bss(sdata, mgmt->sa);
+		if (sta) {
+			u16 tid = *ieee80211_get_qos_ctl(hdr) &
+			    IEEE80211_QOS_CTL_TID_MASK;
+
+			__ieee80211_stop_rx_ba_session(sta, tid,
+						       WLAN_BACK_RECIPIENT,
+						       WLAN_REASON_QSTA_REQUIRE_SETUP,
+						       true);
+		}
+		mutex_unlock(&local->sta_mtx);
+	} else {
+		return false;
+	}
+	return true;
+}
+
 static void ieee80211_iface_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -1264,77 +1343,10 @@ static void ieee80211_iface_work(struct work_struct *work)
 
 	/* first process frames */
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
-		struct ieee80211_mgmt *mgmt = (void *)skb->data;
-
 		if (ieee80211_is_skb_handled_by_pkt_type(skb, sdata)) {
 			goto free_skb;
-		} else if (ieee80211_is_action(mgmt->frame_control) &&
-			   mgmt->u.action.category == WLAN_CATEGORY_BACK) {
-			int len = skb->len;
-
-			mutex_lock(&local->sta_mtx);
-			sta = sta_info_get_bss(sdata, mgmt->sa);
-			if (sta) {
-				switch (mgmt->u.action.u.addba_req.action_code) {
-				case WLAN_ACTION_ADDBA_REQ:
-					ieee80211_process_addba_request(
-							local, sta, mgmt, len);
-					break;
-				case WLAN_ACTION_ADDBA_RESP:
-					ieee80211_process_addba_resp(local, sta,
-								     mgmt, len);
-					break;
-				case WLAN_ACTION_DELBA:
-					ieee80211_process_delba(sdata, sta,
-								mgmt, len);
-					break;
-				default:
-					WARN_ON(1);
-					break;
-				}
-			}
-			mutex_unlock(&local->sta_mtx);
-		} else if (ieee80211_is_action(mgmt->frame_control) &&
-			   mgmt->u.action.category == WLAN_CATEGORY_VHT) {
-			switch (mgmt->u.action.u.vht_group_notif.action_code) {
-			case WLAN_VHT_ACTION_GROUPID_MGMT:
-				ieee80211_process_mu_groups(sdata, mgmt);
-				break;
-			default:
-				WARN_ON(1);
-				break;
-			}
-		} else if (ieee80211_is_data_qos(mgmt->frame_control)) {
-			struct ieee80211_hdr *hdr = (void *)mgmt;
-			/*
-			 * So the frame isn't mgmt, but frame_control
-			 * is at the right place anyway, of course, so
-			 * the if statement is correct.
-			 *
-			 * Warn if we have other data frame types here,
-			 * they must not get here.
-			 */
-			WARN_ON(hdr->frame_control &
-					cpu_to_le16(IEEE80211_STYPE_NULLFUNC));
-			WARN_ON(!(hdr->seq_ctrl &
-					cpu_to_le16(IEEE80211_SCTL_FRAG)));
-			/*
-			 * This was a fragment of a frame, received while
-			 * a block-ack session was active. That cannot be
-			 * right, so terminate the session.
-			 */
-			mutex_lock(&local->sta_mtx);
-			sta = sta_info_get_bss(sdata, mgmt->sa);
-			if (sta) {
-				u16 tid = *ieee80211_get_qos_ctl(hdr) &
-						IEEE80211_QOS_CTL_TID_MASK;
-
-				__ieee80211_stop_rx_ba_session(
-					sta, tid, WLAN_BACK_RECIPIENT,
-					WLAN_REASON_QSTA_REQUIRE_SETUP,
-					true);
-			}
-			mutex_unlock(&local->sta_mtx);
+		} else if (ieee80211_is_handled_by_frame_control(skb, sdata)) {
+			goto free_skb;
 		} else switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			ieee80211_sta_rx_queued_mgmt(sdata, skb);
-- 
2.5.0

