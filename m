Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934243Ab1KJPY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:24:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ROWUq-0006mX-MB
	for linux-wireless@vger.kernel.org; Thu, 10 Nov 2011 16:24:56 +0100
Subject: [RFC] mac80211: allow powersave with multiple interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 16:24:54 +0100
Message-ID: <1320938694.3967.70.camel@jlt3.sipsolutions.net> (sfid-20111110_162501_155607_391F86BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow devices that implement powersave in the
device to enter powersave with multiple virtual
interfaces. If the device implements it, then
presumably it can deal with that (or it should
implement other logic itself).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

--- a/net/mac80211/mlme.c	2011-11-10 09:27:32.000000000 +0100
+++ b/net/mac80211/mlme.c	2011-11-10 16:13:29.000000000 +0100
@@ -604,23 +604,25 @@ static void ieee80211_enable_ps(struct i
 		mod_timer(&local->dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(conf->dynamic_ps_timeout));
 	} else {
-		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
+			if (WARN_ON(!sdata))
+				return;
 			ieee80211_send_nullfunc(local, sdata, 1);
 
-		if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
-			return;
+			if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+				return;
+		}
 
 		conf->flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 }
 
-static void ieee80211_change_ps(struct ieee80211_local *local)
+static void ieee80211_change_ps(struct ieee80211_local *local, bool enable)
 {
 	struct ieee80211_conf *conf = &local->hw.conf;
 
-	if (local->ps_sdata) {
+	if (enable) {
 		ieee80211_enable_ps(local, local->ps_sdata);
 	} else if (conf->flags & IEEE80211_CONF_PS) {
 		conf->flags &= ~IEEE80211_CONF_PS;
@@ -665,8 +667,9 @@ static bool ieee80211_powersave_allowed(
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 {
 	struct ieee80211_sub_if_data *sdata, *found = NULL;
-	int count = 0;
+	int allowed = 0, not_allowed = 0;
 	int timeout;
+	bool enable;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS)) {
 		local->ps_sdata = NULL;
@@ -675,6 +678,7 @@ void ieee80211_recalc_ps(struct ieee8021
 
 	if (!list_empty(&local->work_list)) {
 		local->ps_sdata = NULL;
+		enable = false;
 		goto change;
 	}
 
@@ -682,20 +686,25 @@ void ieee80211_recalc_ps(struct ieee8021
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 		if (sdata->vif.type == NL80211_IFTYPE_AP) {
-			/* If an AP vif is found, then disable PS
-			 * by setting the count to zero thereby setting
-			 * ps_sdata to NULL.
-			 */
-			count = 0;
+			not_allowed++;
 			break;
 		}
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			continue;
+		if (!ieee80211_powersave_allowed(sdata)) {
+			not_allowed++;
+			break;
+		}
 		found = sdata;
-		count++;
+		allowed++;
 	}
 
-	if (count == 1 && ieee80211_powersave_allowed(found)) {
+	if (not_allowed == 0 && allowed > 0 &&
+	    local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS) {
+		/* Hardware can handle PS -- so presumably with multiple VIFs */
+		local->ps_sdata = NULL;
+		enable = true;
+	} else if (allowed == 1 && not_allowed == 0) {
 		struct ieee80211_conf *conf = &local->hw.conf;
 		s32 beaconint_us;
 
@@ -727,6 +736,7 @@ void ieee80211_recalc_ps(struct ieee8021
 
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
+			enable = false;
 		} else {
 			struct ieee80211_bss *bss;
 			int maxslp = 1;
@@ -745,13 +755,15 @@ void ieee80211_recalc_ps(struct ieee8021
 			local->hw.conf.max_sleep_period = maxslp;
 			local->hw.conf.ps_dtim_period = dtimper;
 			local->ps_sdata = found;
+			enable = true;
 		}
 	} else {
 		local->ps_sdata = NULL;
+		enable = false;
 	}
 
  change:
-	ieee80211_change_ps(local);
+	ieee80211_change_ps(local, enable);
 }
 
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work)


