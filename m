Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39662 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755986AbcECN6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 09:58:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Date: Tue,  3 May 2016 16:58:00 +0300
Message-Id: <1462283880-4666-1-git-send-email-luca@coelho.fi> (sfid-20160503_155815_875401_2A24B001)
Subject: [PATCH] mac80211: allow software PS-Poll/U-APSD with AP_LINK_PS
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When using RSS, frames might not be processed in the correct order,
and thus AP_LINK_PS must be used; most likely with firmware keeping
track of the powersave state, this is the case in iwlwifi now.

In this case, the driver can use ieee80211_sta_ps_transition() to
still have mac80211 manage powersave buffering. However, for U-APSD
and PS-Poll this isn't sufficient. If the device can't manage that
entirely on its own, mac80211's code should be used.

To allow this, export two functions: ieee80211_sta_uapsd_trigger()
and ieee80211_sta_pspoll().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 27 +++++++++++++++++++
 net/mac80211/rx.c      | 70 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 71 insertions(+), 26 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ce2f6e3..be30b05 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3996,6 +3996,33 @@ static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
 	return ret;
 }
 
+/**
+ * ieee80211_sta_pspoll - PS-Poll frame received
+ * @sta: currently connected station
+ *
+ * When operating in AP mode with the %IEEE80211_HW_AP_LINK_PS flag set,
+ * use this function to inform mac80211 that a PS-Poll frame from a
+ * connected station was received.
+ * This must be used in conjunction with ieee80211_sta_ps_transition()
+ * and possibly ieee80211_sta_uapsd_trigger(); calls to all three must
+ * be serialized.
+ */
+void ieee80211_sta_pspoll(struct ieee80211_sta *sta);
+
+/**
+ * ieee80211_sta_uapsd_trigger - (potential) U-APSD trigger frame received
+ * @sta: currently connected station
+ * @tid: TID of the received (potential) trigger frame
+ *
+ * When operating in AP mode with the %IEEE80211_HW_AP_LINK_PS flag set,
+ * use this function to inform mac80211 that a (potential) trigger frame
+ * from a connected station was received.
+ * This must be used in conjunction with ieee80211_sta_ps_transition()
+ * and possibly ieee80211_sta_pspoll(); calls to all three must be
+ * serialized.
+ */
+void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *sta, u8 tid);
+
 /*
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c567870..5e65e83 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1319,13 +1319,52 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *pubsta, bool start)
 }
 EXPORT_SYMBOL(ieee80211_sta_ps_transition);
 
+void ieee80211_sta_pspoll(struct ieee80211_sta *pubsta)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+
+	if (test_sta_flag(sta, WLAN_STA_SP))
+		return;
+
+	if (!test_sta_flag(sta, WLAN_STA_PS_DRIVER))
+		ieee80211_sta_ps_deliver_poll_response(sta);
+	else
+		set_sta_flag(sta, WLAN_STA_PSPOLL);
+}
+EXPORT_SYMBOL(ieee80211_sta_pspoll);
+
+void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	u8 ac = ieee802_1d_to_ac[tid & 7];
+
+	/*
+	 * If this AC is not trigger-enabled do nothing.
+	 *
+	 * NB: This could/should check a separate bitmap of trigger-
+	 * enabled queues, but for now we only implement uAPSD w/o
+	 * TSPEC changes to the ACs, so they're always the same.
+	 */
+	if (!(sta->sta.uapsd_queues & BIT(ac)))
+		return;
+
+	/* if we are in a service period, do nothing */
+	if (test_sta_flag(sta, WLAN_STA_SP))
+		return;
+
+	if (!test_sta_flag(sta, WLAN_STA_PS_DRIVER))
+		ieee80211_sta_ps_deliver_uapsd(sta);
+	else
+		set_sta_flag(sta, WLAN_STA_UAPSD);
+}
+EXPORT_SYMBOL(ieee80211_sta_uapsd_trigger);
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_hdr *hdr = (void *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
-	int tid, ac;
 
 	if (!rx->sta)
 		return RX_CONTINUE;
@@ -1351,12 +1390,7 @@ ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
 		return RX_CONTINUE;
 
 	if (unlikely(ieee80211_is_pspoll(hdr->frame_control))) {
-		if (!test_sta_flag(rx->sta, WLAN_STA_SP)) {
-			if (!test_sta_flag(rx->sta, WLAN_STA_PS_DRIVER))
-				ieee80211_sta_ps_deliver_poll_response(rx->sta);
-			else
-				set_sta_flag(rx->sta, WLAN_STA_PSPOLL);
-		}
+		ieee80211_sta_pspoll(&rx->sta->sta);
 
 		/* Free PS Poll skb here instead of returning RX_DROP that would
 		 * count as an dropped frame. */
@@ -1368,27 +1402,11 @@ ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
 		   ieee80211_has_pm(hdr->frame_control) &&
 		   (ieee80211_is_data_qos(hdr->frame_control) ||
 		    ieee80211_is_qos_nullfunc(hdr->frame_control))) {
-		tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-		ac = ieee802_1d_to_ac[tid & 7];
+		u8 tid;
 
-		/*
-		 * If this AC is not trigger-enabled do nothing.
-		 *
-		 * NB: This could/should check a separate bitmap of trigger-
-		 * enabled queues, but for now we only implement uAPSD w/o
-		 * TSPEC changes to the ACs, so they're always the same.
-		 */
-		if (!(rx->sta->sta.uapsd_queues & BIT(ac)))
-			return RX_CONTINUE;
-
-		/* if we are in a service period, do nothing */
-		if (test_sta_flag(rx->sta, WLAN_STA_SP))
-			return RX_CONTINUE;
+		tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
-		if (!test_sta_flag(rx->sta, WLAN_STA_PS_DRIVER))
-			ieee80211_sta_ps_deliver_uapsd(rx->sta);
-		else
-			set_sta_flag(rx->sta, WLAN_STA_UAPSD);
+		ieee80211_sta_uapsd_trigger(&rx->sta->sta, tid);
 	}
 
 	return RX_CONTINUE;
-- 
2.8.0.rc3

