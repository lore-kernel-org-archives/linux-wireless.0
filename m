Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581AbZC3LXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 07:23:41 -0400
Subject: [PATCH] mac80211: move ieee80211_enable_ht function to mlme.c
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 13:23:35 +0200
Message-Id: <1238412215.24972.40.camel@johannes.local> (sfid-20090330_132344_684611_5EA1866B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It really belongs into that file since it is only relevant
for managed mode. Move 1:1, not even whitespace changes,
but make it static and remove from header file.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ht.c          |   83 ---------------------------------------------
 net/mac80211/ieee80211_i.h |    3 -
 net/mac80211/mlme.c        |   83 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 86 deletions(-)

--- wireless-testing.orig/net/mac80211/ht.c	2009-03-30 11:43:05.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2009-03-30 11:43:54.000000000 +0200
@@ -83,89 +83,6 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
 		ht_cap->mcs.rx_mask[32/8] |= 1;
 }
 
-/*
- * ieee80211_enable_ht should be called only after the operating band
- * has been determined as ht configuration depends on the hw's
- * HT abilities for a specific band.
- */
-u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_ht_info *hti,
-			u16 ap_ht_cap_flags)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_bss_ht_conf ht;
-	struct sta_info *sta;
-	u32 changed = 0;
-	bool enable_ht = true, ht_changed;
-	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	memset(&ht, 0, sizeof(ht));
-
-	/* HT is not supported */
-	if (!sband->ht_cap.ht_supported)
-		enable_ht = false;
-
-	/* check that channel matches the right operating channel */
-	if (local->hw.conf.channel->center_freq !=
-	    ieee80211_channel_to_frequency(hti->control_chan))
-		enable_ht = false;
-
-	if (enable_ht) {
-		channel_type = NL80211_CHAN_HT20;
-
-		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
-		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
-			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				channel_type = NL80211_CHAN_HT40PLUS;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				channel_type = NL80211_CHAN_HT40MINUS;
-				break;
-			}
-		}
-	}
-
-	ht_changed = conf_is_ht(&local->hw.conf) != enable_ht ||
-		     channel_type != local->hw.conf.channel_type;
-
-	local->oper_channel_type = channel_type;
-
-	if (ht_changed) {
-                /* channel_type change automatically detected */
-		ieee80211_hw_config(local, 0);
-
-		rcu_read_lock();
-
-		sta = sta_info_get(local, ifmgd->bssid);
-		if (sta)
-			rate_control_rate_update(local, sband, sta,
-						 IEEE80211_RC_HT_CHANGED);
-
-		rcu_read_unlock();
-
-        }
-
-	/* disable HT */
-	if (!enable_ht)
-		return 0;
-
-	ht.operation_mode = le16_to_cpu(hti->operation_mode);
-
-	/* if bss configuration changed store the new one */
-	if (memcmp(&sdata->vif.bss_conf.ht, &ht, sizeof(ht))) {
-		changed |= BSS_CHANGED_HT;
-		sdata->vif.bss_conf.ht = ht;
-	}
-
-	return changed;
-}
-
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta)
 {
 	int i;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-30 11:43:05.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-30 11:44:02.000000000 +0200
@@ -1002,9 +1002,6 @@ int ieee80211_subif_start_xmit(struct sk
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
-u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_ht_info *hti,
-			u16 ap_ht_cap_flags);
 void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
--- wireless-testing.orig/net/mac80211/mlme.c	2009-03-30 11:43:05.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-03-30 11:43:54.000000000 +0200
@@ -81,6 +81,89 @@ static int ieee80211_compatible_rates(st
 	return count;
 }
 
+/*
+ * ieee80211_enable_ht should be called only after the operating band
+ * has been determined as ht configuration depends on the hw's
+ * HT abilities for a specific band.
+ */
+static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_ht_info *hti,
+			       u16 ap_ht_cap_flags)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_bss_ht_conf ht;
+	struct sta_info *sta;
+	u32 changed = 0;
+	bool enable_ht = true, ht_changed;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	memset(&ht, 0, sizeof(ht));
+
+	/* HT is not supported */
+	if (!sband->ht_cap.ht_supported)
+		enable_ht = false;
+
+	/* check that channel matches the right operating channel */
+	if (local->hw.conf.channel->center_freq !=
+	    ieee80211_channel_to_frequency(hti->control_chan))
+		enable_ht = false;
+
+	if (enable_ht) {
+		channel_type = NL80211_CHAN_HT20;
+
+		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
+			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				channel_type = NL80211_CHAN_HT40PLUS;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				channel_type = NL80211_CHAN_HT40MINUS;
+				break;
+			}
+		}
+	}
+
+	ht_changed = conf_is_ht(&local->hw.conf) != enable_ht ||
+		     channel_type != local->hw.conf.channel_type;
+
+	local->oper_channel_type = channel_type;
+
+	if (ht_changed) {
+                /* channel_type change automatically detected */
+		ieee80211_hw_config(local, 0);
+
+		rcu_read_lock();
+
+		sta = sta_info_get(local, ifmgd->bssid);
+		if (sta)
+			rate_control_rate_update(local, sband, sta,
+						 IEEE80211_RC_HT_CHANGED);
+
+		rcu_read_unlock();
+
+        }
+
+	/* disable HT */
+	if (!enable_ht)
+		return 0;
+
+	ht.operation_mode = le16_to_cpu(hti->operation_mode);
+
+	/* if bss configuration changed store the new one */
+	if (memcmp(&sdata->vif.bss_conf.ht, &ht, sizeof(ht))) {
+		changed |= BSS_CHANGED_HT;
+		sdata->vif.bss_conf.ht = ht;
+	}
+
+	return changed;
+}
+
 /* frame sending functions */
 
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)


