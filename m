Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65393 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2GSNLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 09:11:09 -0400
Received: by wibhm11 with SMTP id hm11so5889822wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 06:11:08 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: add PS flag to bss_conf
Date: Thu, 19 Jul 2012 16:11:04 +0300
Message-Id: <1342703465-26703-1-git-send-email-eliad@wizery.com> (sfid-20120719_151113_702313_2D9C902C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, ps mode is indicated per device (rather than
per interface), which doesn't make a lot of sense.

Moreover, there are subtle bugs caused by the inability
to indicate ps change along with other changes
(e.g. when the AP deauth us, we'd like to indicate
CHANGED_PS | CHANGED_ASSOC, as changing PS before
notifying about disassociation will result in null-packets
being sent (if IEEE80211_HW_SUPPORTS_DYNAMIC_PS) while
the sta is already disconnected.)

Keep the current per-device notifications, and add
additional per-vif notifications. In order to keep it
simple, these notifications are NOT called due to
(temporary) dynamic_ps/offchannel operations.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/mlme.c    |   22 ++++++++++++++++++++++
 net/mac80211/util.c    |    3 ++-
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3a700fd..1fcb109 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -171,6 +171,7 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
  * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
  * @BSS_CHANGED_AP_PROBE_RESP: Probe Response changed for this BSS (AP mode)
+ * @BSS_CHANGED_PS: PS changed for this BSS (STA mode)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -190,6 +191,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_IDLE		= 1<<14,
 	BSS_CHANGED_SSID		= 1<<15,
 	BSS_CHANGED_AP_PROBE_RESP	= 1<<16,
+	BSS_CHANGED_PS			= 1<<17,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -266,6 +268,8 @@ enum ieee80211_rssi_event {
  * @idle: This interface is idle. There's also a global idle flag in the
  *	hardware config which may be more appropriate depending on what
  *	your driver/device needs to do.
+ * @ps: power-save mode (STA only). This flag is NOT affected by
+ *	offchannel/dynamic_ps operations.
  * @ssid: The SSID of the current vif. Only valid in AP-mode.
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
@@ -296,6 +300,7 @@ struct ieee80211_bss_conf {
 	bool arp_filter_enabled;
 	bool qos;
 	bool idle;
+	bool ps;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	bool hidden_ssid;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bf3da5a..b8452d5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1004,6 +1004,26 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		local->ps_sdata = NULL;
 	}
 
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			continue;
+
+		/* already in ps */
+		if (sdata == local->ps_sdata &&
+		    sdata->vif.bss_conf.ps)
+			continue;
+
+		/* already active */
+		if (sdata != local->ps_sdata &&
+		    !sdata->vif.bss_conf.ps)
+			continue;
+
+		sdata->vif.bss_conf.ps = local->ps_sdata == sdata;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_PS);
+	}
+
 	ieee80211_change_ps(local);
 }
 
@@ -1368,6 +1388,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		sdata->vif.bss_conf.ps = false;
+		changed |= BSS_CHANGED_PS;
 	}
 	local->ps_sdata = NULL;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 39b82fe..037d148 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1359,7 +1359,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			changed |= BSS_CHANGED_ASSOC |
-				   BSS_CHANGED_ARP_FILTER;
+				   BSS_CHANGED_ARP_FILTER |
+				   BSS_CHANGED_PS;
 			mutex_lock(&sdata->u.mgd.mtx);
 			ieee80211_bss_info_change_notify(sdata, changed);
 			mutex_unlock(&sdata->u.mgd.mtx);
-- 
1.7.6.401.g6a319

