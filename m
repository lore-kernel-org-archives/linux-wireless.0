Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbbCAHKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/16] mac80211: remove channel_switch_beacon operation
Date: Sun,  1 Mar 2015 09:10:14 +0200
Message-Id: <1425193815-17785-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_083417_867724_2D3FB177)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

This operation has been replaced by a more generic pre_channel_switch
callback, that can be called for any interface type.  No driver is
using it anymore, and the ones that were using it were not doing any
beacon-related operation anyway.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h    | 26 ++++++++++++--------------
 net/mac80211/cfg.c        |  1 -
 net/mac80211/driver-ops.h | 13 -------------
 net/mac80211/trace.h      | 25 -------------------------
 4 files changed, 12 insertions(+), 53 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 78ecfe5..dcd309b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2959,20 +2959,21 @@ enum ieee80211_reconfig_type {
  *	Currently, this is only called for managed or P2P client interfaces.
  *	This callback is optional; it must not sleep.
  *
- * @channel_switch_beacon: Starts a channel switch to a new channel.
- *	Beacons are modified to include CSA or ECSA IEs before calling this
- *	function. The corresponding count fields in these IEs must be
- *	decremented, and when they reach 1 the driver must call
- *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
- *	get the csa counter decremented by mac80211, but must check if it is
- *	1 using ieee80211_csa_is_complete() after the beacon has been
- *	transmitted and then call ieee80211_csa_finish().
- *	If the CSA count starts as zero or 1, this function will not be called,
- *	since there won't be any time to beacon before the switch anyway.
  * @pre_channel_switch: This is an optional callback that is called
  *	before a channel switch procedure is started (ie. when a STA
  *	gets a CSA or an userspace initiated channel-switch), allowing
- *	the driver to prepare for the channel switch.
+ *	the driver to prepare for the channel switch.  For beaconing
+ *	interfaces, the beacons will be modified to include CSA or
+ *	ECSA IEs after this function is called. The corresponding
+ *	count fields in these IEs must be decremented, and when they
+ *	reach 1 the driver must call ieee80211_csa_finish(). Drivers
+ *	which use ieee80211_beacon_get() get the csa counter
+ *	decremented by mac80211, but must check if it is 1 using
+ *	ieee80211_csa_is_complete() after the beacon has been
+ *	transmitted and then call ieee80211_csa_finish().  If the CSA
+ *	count starts as zero or 1, this function will not be called,
+ *	since there won't be any time to beacon before the switch
+ *	anyway.
  * @post_channel_switch: This is an optional callback that is called
  *	after a channel switch procedure is completed, allowing the
  *	driver to go back to a normal configuration.
@@ -3209,9 +3210,6 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct inet6_dev *idev);
 #endif
-	void (*channel_switch_beacon)(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif,
-				      struct cfg80211_chan_def *chandef);
 	int (*pre_channel_switch)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  struct ieee80211_channel_switch *ch_switch);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bc33911..9c5244d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3287,7 +3287,6 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
 	if (changed) {
 		ieee80211_bss_info_change_notify(sdata, changed);
-		drv_channel_switch_beacon(sdata, &params->chandef);
 	} else {
 		/* if the beacon didn't change, we can finalize immediately */
 		ieee80211_csa_finalize(sdata);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index fdeda17..1ee1981 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1211,19 +1211,6 @@ static inline void drv_ipv6_addr_change(struct ieee80211_local *local,
 }
 #endif
 
-static inline void
-drv_channel_switch_beacon(struct ieee80211_sub_if_data *sdata,
-			  struct cfg80211_chan_def *chandef)
-{
-	struct ieee80211_local *local = sdata->local;
-
-	if (local->ops->channel_switch_beacon) {
-		trace_drv_channel_switch_beacon(local, sdata, chandef);
-		local->ops->channel_switch_beacon(&local->hw, &sdata->vif,
-						  chandef);
-	}
-}
-
 static inline int
 drv_pre_channel_switch(struct ieee80211_sub_if_data *sdata,
 		       struct ieee80211_channel_switch *ch_switch)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 263a956..77c9c93 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2117,31 +2117,6 @@ TRACE_EVENT(api_radar_detected,
 	)
 );
 
-TRACE_EVENT(drv_channel_switch_beacon,
-	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 struct cfg80211_chan_def *chandef),
-
-	TP_ARGS(local, sdata, chandef),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		VIF_ENTRY
-		CHANDEF_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		VIF_ASSIGN;
-		CHANDEF_ASSIGN(chandef);
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT " channel switch to " CHANDEF_PR_FMT,
-		LOCAL_PR_ARG, VIF_PR_ARG, CHANDEF_PR_ARG
-	)
-);
-
 TRACE_EVENT(drv_pre_channel_switch,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
1.9.1

