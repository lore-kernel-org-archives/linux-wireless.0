Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38980 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2J2TJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 15:09:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: pass P2P powersave parameters to driver
Date: Mon, 29 Oct 2012 20:10:18 +0100
Message-Id: <1351537819-21342-1-git-send-email-johannes@sipsolutions.net> (sfid-20121029_200950_127785_265D88D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

While connected to a GO, parse the P2P NoA attribute
and pass the CT Window and opportunistic powersave
parameters to the driver.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    7 +++++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |   37 +++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h       |    4 ++++
 4 files changed, 50 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dfa589b..23803ad 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -208,6 +208,8 @@ struct ieee80211_chanctx_conf {
  * @BSS_CHANGED_AP_PROBE_RESP: Probe Response changed for this BSS (AP mode)
  * @BSS_CHANGED_PS: PS changed for this BSS (STA mode)
  * @BSS_CHANGED_TXPOWER: TX power setting changed for this interface
+ * @BSS_CHANGED_P2P_PS: P2P powersave settings (CTWindow, opportunistic PS)
+ *	changed (currently only in P2P client mode, GO mode will be later)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -229,6 +231,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_AP_PROBE_RESP	= 1<<16,
 	BSS_CHANGED_PS			= 1<<17,
 	BSS_CHANGED_TXPOWER		= 1<<18,
+	BSS_CHANGED_P2P_PS		= 1<<19,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -312,6 +315,8 @@ enum ieee80211_rssi_event {
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
  * @txpower: TX power in dBm
+ * @p2p_ctwindow: P2P CTWindow, only for P2P client interfaces
+ * @p2p_oppps: P2P opportunistic PS is enabled
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -345,6 +350,8 @@ struct ieee80211_bss_conf {
 	size_t ssid_len;
 	bool hidden_ssid;
 	int txpower;
+	u8 p2p_ctwindow;
+	bool p2p_oppps;
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 37c08d3..904b4d8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -473,6 +473,8 @@ struct ieee80211_if_managed {
 
 	u8 use_4addr;
 
+	u8 p2p_noa_index;
+
 	/* Signal strength from the last Beacon frame in the current BSS. */
 	int last_beacon_signal;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c2a1150..da14fe0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1364,6 +1364,22 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	sdata->u.mgd.flags |= IEEE80211_STA_RESET_SIGNAL_AVE;
 
+	if (sdata->vif.p2p) {
+		u8 noa[2];
+		int ret;
+
+		ret = cfg80211_get_p2p_attr(cbss->information_elements,
+					    cbss->len_information_elements,
+					    12, /* TODO: proper constant */
+					    noa, sizeof(noa));
+		if (ret >= 2) {
+			bss_conf->p2p_oppps = noa[1] & 0x80;
+			bss_conf->p2p_ctwindow = noa[1] & 0x7f;
+			bss_info_changed |= BSS_CHANGED_P2P_PS;
+			sdata->u.mgd.p2p_noa_index = noa[0];
+		}
+	}
+
 	/* just to be sure */
 	ieee80211_stop_poll(sdata);
 
@@ -2617,6 +2633,27 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	if (sdata->vif.p2p) {
+		u8 noa[2];
+		int ret;
+
+		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
+					    len - baselen,
+					    12, /* TODO: proper constant */
+					    noa, sizeof(noa));
+		if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa[0]) {
+			bss_conf->p2p_oppps = noa[1] & 0x80;
+			bss_conf->p2p_ctwindow = noa[1] & 0x7f;
+			changed |= BSS_CHANGED_P2P_PS;
+			sdata->u.mgd.p2p_noa_index = noa[0];
+			/*
+			 * make sure we update all information, the CRC
+			 * mechanism doesn't look at P2P attributes.
+			 */
+			ifmgd->beacon_crc_valid = false;
+		}
+	}
+
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
 		return;
 	ifmgd->beacon_crc = ncrc;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index eeebbd9..7794e53 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -343,6 +343,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__dynamic_array(u8, ssid, info->ssid_len);
 		__field(bool, hidden_ssid);
 		__field(int, txpower)
+		__field(u8, p2p_ctwindow)
+		__field(bool, p2p_oppps)
 	),
 
 	TP_fast_assign(
@@ -378,6 +380,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		memcpy(__get_dynamic_array(ssid), info->ssid, info->ssid_len);
 		__entry->hidden_ssid = info->hidden_ssid;
 		__entry->txpower = info->txpower;
+		__entry->p2p_ctwindow = info->p2p_ctwindow;
+		__entry->p2p_oppps = info->p2p_oppps;
 	),
 
 	TP_printk(
-- 
1.7.10.4

