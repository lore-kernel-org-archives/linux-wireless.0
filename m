Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:62947 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaIOFNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:42 -0400
Received: by mail-we0-f178.google.com with SMTP id q58so3380941wes.37
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:41 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/28] iwlwifi: mvm: Fix skip over dtim configuration in d0i3
Date: Mon, 15 Sep 2014 08:12:57 +0300
Message-Id: <1410757980-2138-25-git-send-email-egrumbach@gmail.com> (sfid-20140915_073115_443783_F0497492)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

There was some confusion concerning the units of the beacon interval.
The driver assumed that it was in msec where it was in TU - so fix that.
Skip over dtim was capped by 300TU where it should be by 306TU.
It should also be subjected to several conditions:
Not a DFS channel, dtim period < 10, and the multicast wake-lock
is off.  Concerning multicast lock - there is an implementation gap
in the supplicant, so just leave a TODO.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 48 +++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 5a29c19..ff842ee 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -286,12 +286,28 @@ static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 	return true;
 }
 
+static bool iwl_mvm_power_is_radar(struct ieee80211_vif *vif)
+{
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan;
+	bool radar_detect = false;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+	WARN_ON(!chanctx_conf);
+	if (chanctx_conf) {
+		chan = chanctx_conf->def.chan;
+		radar_detect = chan->flags & IEEE80211_CHAN_RADAR;
+	}
+	rcu_read_unlock();
+
+	return radar_detect;
+}
+
 static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    struct iwl_mac_power_cmd *cmd)
 {
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_channel *chan;
 	int dtimper, dtimper_msec;
 	int keep_alive;
 	bool radar_detect = false;
@@ -333,14 +349,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	}
 
 	/* Check if radar detection is required on current channel */
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(vif->chanctx_conf);
-	WARN_ON(!chanctx_conf);
-	if (chanctx_conf) {
-		chan = chanctx_conf->def.chan;
-		radar_detect = chan->flags & IEEE80211_CHAN_RADAR;
-	}
-	rcu_read_unlock();
+	radar_detect = iwl_mvm_power_is_radar(vif);
 
 	/* Check skip over DTIM conditions */
 	if (!radar_detect && (dtimper <= 10) &&
@@ -961,17 +970,22 @@ int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
 
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
 	if (enable) {
-		/* configure skip over dtim up to 300 msec */
+		/* configure skip over dtim up to 306TU - 314 msec */
 		int dtimper = vif->bss_conf.dtim_period ?: 1;
-		int dtimper_msec = dtimper * vif->bss_conf.beacon_int;
+		int dtimper_tu = dtimper * vif->bss_conf.beacon_int;
+		bool radar_detect = iwl_mvm_power_is_radar(vif);
 
-		if (WARN_ON(!dtimper_msec))
+		if (WARN_ON(!dtimper_tu))
 			return 0;
 
-		cmd.skip_dtim_periods = 300 / dtimper_msec;
-		if (cmd.skip_dtim_periods)
-			cmd.flags |=
-				cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+		/* Check skip over DTIM conditions */
+		/* TODO: check that multicast wake lock is off */
+		if (!radar_detect && (dtimper < 10)) {
+			cmd.skip_dtim_periods = 306 / dtimper_tu;
+			if (cmd.skip_dtim_periods)
+				cmd.flags |= cpu_to_le16(
+					POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+		}
 	}
 	iwl_mvm_power_log(mvm, &cmd);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.9.1

