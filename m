Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36091 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1APFmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:32 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so4134866wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:42:32 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/10] mac80211: add HW flag for disabling auto link-PS in AP mode
Date: Sun, 16 Jan 2011 07:42:10 +0200
Message-Id: <1295156534-4178-7-git-send-email-arik@wizery.com>
In-Reply-To: <1295156534-4178-1-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in AP mode the wl1271 hardware filters our null-data
packets as well as management packets. This makes it impossible for
mac80211 to monitor the PS mode by using the PM bit of incoming frames.

Implement a HW flag to indicate that mac80211 should ignore the PM bit.
In addition, expose ieee80211_start_ps()/ieee80211_end_ps() to make
low-level drivers capable of controlling PS-mode.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h |   38 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c      |   19 ++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 62c0ce2..26a8cfb 100644
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
@@ -2113,6 +2121,36 @@ static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
 	local_bh_enable();
 }
 
+/**
+ * ieee80211_start_ps - start PS for connected sta
+ *
+ * When operating in AP mode, use this function to inform mac80211
+ * about a station entering PS mode.
+ * Note that by default mac80211 will automatically call the internal
+ * equivalent of this function according to the PM bit of incoming frames.
+ * Use the IEEE80211_HW_AP_LINK_PS flag to change this.
+ *
+ * This function may not be called in IRQ context or process context.
+ *
+ * @sta: currently connected sta
+ */
+void ieee80211_start_ps(struct ieee80211_sta *sta);
+
+/**
+ * ieee80211_end_ps - end PS for connection sta
+ *
+ * When operating in AP mode, use this function to inform mac80211
+ * about a station exiting PS mode.
+ * Note that by default mac80211 will automatically call the internal
+ * equivalent of this function according to the PM bit of incoming frames.
+ * Use the IEEE80211_HW_AP_LINK_PS flag to change this.
+ *
+ * This function may not be called in IRQ context or process context.
+ *
+ * @sta: currently connected sta
+ */
+void ieee80211_end_ps(struct ieee80211_sta *sta);
+
 /*
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a6701ed..c892271 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1095,6 +1095,14 @@ static void ap_sta_ps_start(struct sta_info *sta)
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
 
+void ieee80211_start_ps(struct ieee80211_sta *sta)
+{
+	struct sta_info *sta_inf = container_of(sta, struct sta_info, sta);
+
+	ap_sta_ps_start(sta_inf);
+}
+EXPORT_SYMBOL(ieee80211_start_ps);
+
 static void ap_sta_ps_end(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -1117,6 +1125,14 @@ static void ap_sta_ps_end(struct sta_info *sta)
 	ieee80211_sta_ps_deliver_wakeup(sta);
 }
 
+void ieee80211_end_ps(struct ieee80211_sta *sta)
+{
+	struct sta_info *sta_inf = container_of(sta, struct sta_info, sta);
+
+	ap_sta_ps_end(sta_inf);
+}
+EXPORT_SYMBOL(ieee80211_end_ps);
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
@@ -1161,7 +1177,8 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	 * Change STA power saving mode only at the end of a frame
 	 * exchange sequence.
 	 */
-	if (!ieee80211_has_morefrags(hdr->frame_control) &&
+	if (!(sta->local->hw.flags & IEEE80211_HW_AP_LINK_PS) &&
+	    !ieee80211_has_morefrags(hdr->frame_control) &&
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
-- 
1.7.1

