Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52965 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab1AaU31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 15:29:27 -0500
Received: by wwa36 with SMTP id 36so6224314wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 12:29:25 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] mac80211: add HW flag for disabling auto link-PS in AP mode
Date: Mon, 31 Jan 2011 22:29:13 +0200
Message-Id: <1296505753-29594-2-git-send-email-arik@wizery.com>
In-Reply-To: <1296505753-29594-1-git-send-email-arik@wizery.com>
References: <1296505753-29594-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in AP mode the wl1271 hardware filters out null-data
packets as well as management packets. This makes it impossible for
mac80211 to monitor the PS mode by using the PM bit of incoming frames.

Implement a HW flag to indicate that mac80211 should ignore the PM bit.
In addition, expose ieee80211_sta_ps_transition() to make low-level
drivers capable of controlling PS-mode.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h  |   54 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/rx.c       |   27 +++++++++++++++++++++-
 net/mac80211/sta_info.c |    3 +-
 net/mac80211/status.c   |    4 +++
 4 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d6b0045..0396cec 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1069,6 +1069,13 @@ enum ieee80211_tkip_key_type {
  *	to decrypt group addressed frames, then IBSS RSN support is still
  *	possible but software crypto will be used. Advertise the wiphy flag
  *	only in that case.
+ *
+ * @IEEE80211_HW_AP_LINK_PS: When operating in AP mode the device
+ *	autonomously manages the PS status of connected stations. When
+ *	this flag is set mac80211 will not trigger PS mode for connected
+ *	stations based on the PM bit of incoming frames.
+ *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
+ *	the PS mode of connected stations.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1093,6 +1100,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
 	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
+	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 };
 
 /**
@@ -1701,7 +1709,9 @@ enum ieee80211_ampdu_mlme_action {
  *	station, AP, IBSS/WDS/mesh peer etc. This callback can sleep.
  *
  * @sta_notify: Notifies low level driver about power state transition of an
- *	associated station, AP,  IBSS/WDS/mesh peer etc. Must be atomic.
+ *	associated station, AP,  IBSS/WDS/mesh peer etc. For a VIF operating
+ *	in AP mode, this callback will not be called when the flag
+ *	%IEEE80211_HW_AP_LINK_PS is set. Must be atomic.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
@@ -2131,6 +2141,48 @@ static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
 	local_bh_enable();
 }
 
+/**
+ * ieee80211_sta_ps_transition - PS transition for connected sta
+ *
+ * When operating in AP mode with the %IEEE80211_HW_AP_LINK_PS
+ * flag set, use this function to inform mac80211 about a connected station
+ * entering/leaving PS mode.
+ *
+ * This function may not be called in IRQ context or with softirqs enabled.
+ *
+ * Calls to this function for a single hardware must be synchronized against
+ * each other.
+ *
+ * The function returns -EINVAL when the requested PS mode is already set.
+ *
+ * @sta: currently connected sta
+ * @start: start or stop PS
+ */
+int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start);
+
+/**
+ * ieee80211_sta_ps_transition_ni - PS transition for connected sta
+ *                                  (in process context)
+ *
+ * Like ieee80211_sta_ps_transition() but can be called in process context
+ * (internally disables bottom halves). Concurrent call restriction still
+ * applies.
+ *
+ * @sta: currently connected sta
+ * @start: start or stop PS
+ */
+static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
+						  bool start)
+{
+	int ret;
+
+	local_bh_disable();
+	ret = ieee80211_sta_ps_transition(sta, start);
+	local_bh_enable();
+
+	return ret;
+}
+
 /*
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f36d70f..a900145 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1088,7 +1088,8 @@ static void ap_sta_ps_start(struct sta_info *sta)
 
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_sta_flags(sta, WLAN_STA_PS_STA);
-	drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
+	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
+		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d enters power save mode\n",
 	       sdata->name, sta->sta.addr, sta->sta.aid);
@@ -1117,6 +1118,27 @@ static void ap_sta_ps_end(struct sta_info *sta)
 	ieee80211_sta_ps_deliver_wakeup(sta);
 }
 
+int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start)
+{
+	struct sta_info *sta_inf = container_of(sta, struct sta_info, sta);
+	bool in_ps;
+
+	WARN_ON(!(sta_inf->local->hw.flags & IEEE80211_HW_AP_LINK_PS));
+
+	/* Don't let the same PS state be set twice */
+	in_ps = test_sta_flags(sta_inf, WLAN_STA_PS_STA);
+	if ((start && in_ps) || (!start && !in_ps))
+		return -EINVAL;
+
+	if (start)
+		ap_sta_ps_start(sta_inf);
+	else
+		ap_sta_ps_end(sta_inf);
+
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_sta_ps_transition);
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
@@ -1161,7 +1183,8 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	 * Change STA power saving mode only at the end of a frame
 	 * exchange sequence.
 	 */
-	if (!ieee80211_has_morefrags(hdr->frame_control) &&
+	if (!(sta->local->hw.flags & IEEE80211_HW_AP_LINK_PS) &&
+	    !ieee80211_has_morefrags(hdr->frame_control) &&
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c426504..5a11078 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -899,7 +899,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	int sent, buffered;
 
-	drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
+	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
+		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 38a7972..ffb0de9 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -98,6 +98,10 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	 *  (b) always process RX events before TX status events if ordering
 	 *      can be unknown, for example with different interrupt status
 	 *	bits.
+	 *  (c) if PS mode transitions are manual (i.e. the flag
+	 *      %IEEE80211_HW_AP_LINK_PS is set), always process PS state
+	 *      changes before calling TX status events if ordering can be
+	 *	unknown.
 	 */
 	if (test_sta_flags(sta, WLAN_STA_PS_STA) &&
 	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
-- 
1.7.1

