Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab3AHSKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 13:10:54 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 2/3] mac80211: Convey information about off-channel powersave to drivers
Date: Tue,  8 Jan 2013 12:10:44 -0600
Message-Id: <1357668645-5101-3-git-send-email-seth.forshee@canonical.com> (sfid-20130108_191057_108622_0D199A88)
In-Reply-To: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Responsibility for setting PM in frame control when powersave is enabled
falls to the drivers/hardware. This is a problem during off-channel
operation, when the hardware isn't actually in powersave but PM still
needs to be set so that the AP will buffer frames while the STA is
off-channel, as the drivers don't currently receive enough information
to know of this state.

To rememdy this, convert the powersave information in ieee80211_conf
from a binary flag to a set of states. This patch is the first step
towards doing this. A new set of powersave states is defined and added
to ieee80211_conf, and mac80211 is updated to set and use these states.
Once all drivers have been moved over to using the new states
IEEE80211_CONF_PS can be removed.

Currnetly this patch also has changes to a couple of drivers to use the
new states for testing purposes. The driver changes should be split out
into separate commits.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---

Currently this patch includes changes to the drivers I've been testing
with. My plan is to split those out into separate patches, add patches
for other drivers to use the ps_mode field instead of IEEE80211_CONF_PS,
then remove IEEE80211_CONF_PS completely. But I'd like to get comments
on the mac80211 changes before doing the work to convert all the
drivers.

 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   16 +++++++---
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   10 +++++++
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    3 ++
 include/net/mac80211.h                             |   23 +++++++++++++++
 net/mac80211/mlme.c                                |   19 ++++++++----
 net/mac80211/offchannel.c                          |   31 +++++++++++++-------
 net/mac80211/util.c                                |    2 +-
 8 files changed, 83 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index be30a9a..a216142 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -689,7 +689,7 @@ static void ath9k_tx(struct ieee80211_hw *hw,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned long flags;
 
-	if (sc->ps_enabled) {
+	if (hw->conf.ps_mode != IEEE80211_PS_DISABLED) {
 		/*
 		 * mac80211 does not set PM field for normal data frames, so we
 		 * need to update that based on the current PS mode.
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 1fbd8ec..dc317a5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -390,10 +390,18 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 		brcms_dbg_info(core, "%s: change monitor mode: %s\n",
 			       __func__, conf->flags & IEEE80211_CONF_MONITOR ?
 			       "true" : "false");
-	if (changed & IEEE80211_CONF_CHANGE_PS)
-		brcms_err(core, "%s: change power-save mode: %s (implement)\n",
-			  __func__, conf->flags & IEEE80211_CONF_PS ?
-			  "true" : "false");
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		/*
+		 * brcmsmac doesn't support powersave, but it does support
+		 * setting the PM bit in frame control for off-channel PS
+		 */
+		if (conf->ps_mode == IEEE80211_PS_ENABLED)
+			brcms_err(core, "%s: change power-save mode: %s (implement)\n",
+				  __func__, conf->flags & IEEE80211_CONF_PS ?
+				  "true" : "false");
+		else
+			brcms_c_set_ps(wl->wlc, conf->ps_mode);
+	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		err = brcms_c_set_tx_power(wl->wlc, conf->power_level);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 17594de..0286305 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3054,6 +3054,11 @@ static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
 static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 {
 	struct brcms_bss_cfg *cfg = wlc->bsscfg;
+	struct ieee80211_conf *hw_cfg = &wlc->pub->ieee_hw->conf;
+
+	/* allow PS when off-channel PS enabled */
+	if (hw_cfg->ps_mode == IEEE80211_PS_OFFCHANNEL)
+		return true;
 
 	/* disallow PS when one of the following global conditions meets */
 	if (!wlc->pub->associated)
@@ -7546,6 +7551,11 @@ void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
 		brcms_c_bcn_li_upd(wlc);
 }
 
+void brcms_c_set_ps(struct brcms_c_info *wlc, enum ieee80211_ps_mode mode)
+{
+	brcms_c_set_ps_ctrl(wlc);
+}
+
 int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr)
 {
 	uint qdbm;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 4fb2834..40c05f9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -18,6 +18,7 @@
 #define _BRCM_PUB_H_
 
 #include <linux/bcma/bcma.h>
+#include <net/mac80211.h>
 #include <brcmu_wifi.h>
 #include "types.h"
 #include "defs.h"
@@ -328,6 +329,8 @@ extern void brcms_c_set_shortslot_override(struct brcms_c_info *wlc,
 				    s8 sslot_override);
 extern void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc,
 					u8 interval);
+extern void brcms_c_set_ps(struct brcms_c_info *wlc,
+			   enum ieee80211_ps_mode mode);
 extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
 extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ee50c5e..237cf16 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -910,6 +910,27 @@ enum ieee80211_conf_changed {
 };
 
 /**
+ * enum ieee80211_ps_mode - power save mode
+ *
+ * @IEEE80211_PS_DISABLED: disabled
+ * @IEEE80211_PS_ENABLED: enabled
+ * @IEEE80211_PS_OFFCHANNEL: Off-channel power save
+ *	For off-channel power save drivers need to ensure that PM is set
+ *	in frame control during STA operation for all frames which will be
+ *	acked by the associated AP. In all other respects power save should
+ *	remain disabled.
+ * @IEEE80211_PS_NUM_MODES: internal, don't use
+ */
+enum ieee80211_ps_mode {
+	IEEE80211_PS_DISABLED,
+	IEEE80211_PS_ENABLED,
+	IEEE80211_PS_OFFCHANNEL,
+
+	/* keep last */
+	IEEE80211_PS_NUM_MODES,
+};
+
+/**
  * enum ieee80211_smps_mode - spatial multiplexing power save mode
  *
  * @IEEE80211_SMPS_AUTOMATIC: automatic
@@ -935,6 +956,7 @@ enum ieee80211_smps_mode {
  *
  * @flags: configuration flags defined above
  *
+ * @ps_mode: current powersave mode
  * @listen_interval: listen interval in units of beacon interval
  * @max_sleep_period: the maximum number of beacon intervals to sleep for
  *	before checking the beacon for a TIM bit (managed mode only); this
@@ -969,6 +991,7 @@ enum ieee80211_smps_mode {
  */
 struct ieee80211_conf {
 	u32 flags;
+	enum ieee80211_ps_mode ps_mode;
 	int power_level, dynamic_ps_timeout;
 	int max_sleep_period;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7753a9c..c4b1243 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -965,6 +965,7 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
 			return;
 
+		conf->ps_mode = IEEE80211_PS_ENABLED;
 		conf->flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
@@ -976,7 +977,8 @@ static void ieee80211_change_ps(struct ieee80211_local *local)
 
 	if (local->ps_sdata) {
 		ieee80211_enable_ps(local, local->ps_sdata);
-	} else if (conf->flags & IEEE80211_CONF_PS) {
+	} else if (conf->ps_mode == IEEE80211_PS_ENABLED) {
+		conf->ps_mode = IEEE80211_PS_DISABLED;
 		conf->flags &= ~IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 		del_timer_sync(&local->dynamic_ps_timer);
@@ -1115,7 +1117,8 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 		container_of(work, struct ieee80211_local,
 			     dynamic_ps_disable_work);
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+	if (local->hw.conf.ps_mode == IEEE80211_PS_ENABLED) {
+		local->hw.conf.ps_mode = IEEE80211_PS_DISABLED;
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
@@ -1140,7 +1143,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 
 	ifmgd = &sdata->u.mgd;
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS)
+	if (local->hw.conf.ps_mode == IEEE80211_PS_ENABLED)
 		return;
 
 	if (!local->disable_dynamic_ps &&
@@ -1191,6 +1194,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
 	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+		local->hw.conf.ps_mode = IEEE80211_PS_ENABLED;
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
@@ -1492,7 +1496,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	 * to do it before sending disassoc, as otherwise the null-packet
 	 * won't be valid.
 	 */
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+	if (local->hw.conf.ps_mode != IEEE80211_PS_DISABLED) {
+		local->hw.conf.ps_mode = IEEE80211_PS_DISABLED;
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
@@ -2622,13 +2627,15 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 							ifmgd->aid);
 		if (directed_tim) {
 			if (local->hw.conf.dynamic_ps_timeout > 0) {
-				if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+				if (local->hw.conf.ps_mode == IEEE80211_PS_ENABLED) {
+					local->hw.conf.ps_mode = IEEE80211_PS_DISABLED;
 					local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 					ieee80211_hw_config(local,
 							    IEEE80211_CONF_CHANGE_PS);
 				}
 				ieee80211_send_nullfunc(local, sdata, 0);
-			} else if (!local->pspolling && sdata->u.mgd.powersave) {
+			} else if (!local->pspolling &&
+				   local->hw.conf.ps_mode != IEEE80211_PS_DISABLED) {
 				local->pspolling = true;
 
 				/*
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index ccb91a2..4b759b2 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -42,9 +42,16 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->offchannel_ps_enabled = true;
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
+	/*
+	 * Change powersave state even if driver doesn't support
+	 * powersave, as drivers are responsible for setting PM in
+	 * frame control.
+	 */
+	local->hw.conf.ps_mode = IEEE80211_PS_OFFCHANNEL;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+
 	if (!local->offchannel_ps_enabled ||
 	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
 		/*
@@ -65,9 +72,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 
-	if (!local->ps_sdata)
-		ieee80211_send_nullfunc(local, sdata, 0);
-	else if (local->offchannel_ps_enabled) {
+	if (local->offchannel_ps_enabled) {
 		/*
 		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
 		 * will send a nullfunc frame with the powersave bit set
@@ -84,18 +89,22 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 		/* TODO:  Only set hardware if CONF_PS changed?
 		 * TODO:  Should we set offchannel_ps_enabled to false?
 		 */
+		local->hw.conf.ps_mode = IEEE80211_PS_ENABLED;
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	} else if (local->hw.conf.dynamic_ps_timeout > 0) {
+	} else {
 		/*
-		 * If IEEE80211_CONF_PS was not set and the dynamic_ps_timer
-		 * had been running before leaving the operating channel,
-		 * restart the timer now and send a nullfunc frame to inform
-		 * the AP that we are awake.
+		 * For all other cases we need to return powersave to the
+		 * disabled state and send a nullfunc frame to inform the
+		 * AP that we are awake. Also restart dynamic_ps_timer if
+		 * it had been running before leaving the operating channel.
 		 */
+		local->hw.conf.ps_mode = IEEE80211_PS_DISABLED;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 		ieee80211_send_nullfunc(local, sdata, 0);
-		mod_timer(&local->dynamic_ps_timer, jiffies +
-			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+		if (local->hw.conf.dynamic_ps_timeout > 0)
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f11e8c5..4dc85af 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1580,7 +1580,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * explicitly send a null packet in order to make sure
 	 * it'll sync against the ap (and get out of psm).
 	 */
-	if (!(local->hw.conf.flags & IEEE80211_CONF_PS)) {
+	if (local->hw.conf.ps_mode == IEEE80211_PS_DISABLED) {
 		list_for_each_entry(sdata, &local->interfaces, list) {
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
-- 
1.7.9.5

