Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59948 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1JSSon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 14:44:43 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Fix off-channel problem in work task.
Date: Wed, 19 Oct 2011 11:44:36 -0700
Message-Id: <1319049876-16243-1-git-send-email-greearb@candelatech.com> (sfid-20111019_204446_370230_FCC0BA28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The ieee80211_cfg_on_oper_channel method compared the
current hardware config as well as the desired hardware
config.  In most cases, this is proper, but when deciding
whether to go back on-channel, if the hardware is not
configured on-channel, but logically it *should* be
on-channel, then we must go on-channel.

This patch adds a flag to the ieee80211_cfg_on_oper_channel
logic to disable comparing the actual hardware so we do not
have to create another tricky method with similar logic.

Reported-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  This is tricky stuff, please do not apply until at
least Johannes gets time to review this.

:100644 100644 4c3d1f5... 40ca484... M	net/mac80211/ieee80211_i.h
:100644 100644 d4ee6d2... 3ead637... M	net/mac80211/main.c
:100644 100644 397343a... d1b6b29... M	net/mac80211/scan.c
:100644 100644 bf5be22... 62a3357... M	net/mac80211/work.c
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/main.c        |   13 ++++++++-----
 net/mac80211/scan.c        |   10 +++++-----
 net/mac80211/work.c        |   11 +++++++----
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4c3d1f5..40ca484 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1139,7 +1139,8 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local);
+bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local,
+				   bool check_current_hw_cfg);
 void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
 					bool tell_ap);
 void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d4ee6d2..3ead637 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -94,11 +94,13 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 
 /*
  * Returns true if we are logically configured to be on
- * the operating channel AND the hardware-conf is currently
- * configured on the operating channel.  Compares channel-type
+ * the operating channel and channel-type.
+ * If the check_current_hw_cfg argument is TRUE,
+ * the currently configured hardware value is checked
  * as well.
  */
-bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
+bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local,
+				   bool check_current_hw_cfg)
 {
 	struct ieee80211_channel *chan, *scan_chan;
 	enum nl80211_channel_type channel_type;
@@ -126,8 +128,9 @@ bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
 		return false;
 
 	/* Check current hardware-config against oper_channel. */
-	if ((local->oper_channel != local->hw.conf.channel) ||
-	    (local->_oper_channel_type != local->hw.conf.channel_type))
+	if (check_current_hw_cfg &&
+	    ((local->oper_channel != local->hw.conf.channel) ||
+	     (local->_oper_channel_type != local->hw.conf.channel_type)))
 		return false;
 
 	return true;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 397343a..d1b6b29 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -216,7 +216,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	 * current channel, pass the pkt on up the stack so that
 	 * the rest of the stack can make use of it.
 	 */
-	if (ieee80211_cfg_on_oper_channel(sdata->local)
+	if (ieee80211_cfg_on_oper_channel(sdata->local, true)
 	    && (channel == sdata->local->oper_channel))
 		return RX_CONTINUE;
 
@@ -297,7 +297,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	local->scanning = 0;
 	local->scan_channel = NULL;
 
-	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
+	on_oper_chan = ieee80211_cfg_on_oper_channel(local, true);
 
 	if (was_hw_scan || !on_oper_chan)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
@@ -309,7 +309,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 		bool on_oper_chan2;
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		on_oper_chan2 = ieee80211_cfg_on_oper_channel(local);
+		on_oper_chan2 = ieee80211_cfg_on_oper_channel(local, true);
 		/* We should always be on-channel at this point. */
 		WARN_ON(!on_oper_chan2);
 		if (on_oper_chan2 && (on_oper_chan != on_oper_chan2))
@@ -509,7 +509,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 
 	next_chan = local->scan_req->channels[local->scan_channel_idx];
 
-	if (ieee80211_cfg_on_oper_channel(local)) {
+	if (ieee80211_cfg_on_oper_channel(local, true)) {
 		/* We're currently on operating channel. */
 		if (next_chan == local->oper_channel)
 			/* We don't need to move off of operating channel. */
@@ -587,7 +587,7 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 {
 	/* switch back to the operating channel */
 	local->scan_channel = NULL;
-	if (!ieee80211_cfg_on_oper_channel(local))
+	if (!ieee80211_cfg_on_oper_channel(local, true))
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	/*
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index bf5be22..62a3357 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -973,7 +973,8 @@ static void ieee80211_work_work(struct work_struct *work)
 			bool tmp_chan_changed = false;
 			bool on_oper_chan2;
 			enum nl80211_channel_type wk_ct;
-			on_oper_chan = ieee80211_cfg_on_oper_channel(local);
+			on_oper_chan = ieee80211_cfg_on_oper_channel(local,
+								     true);
 
 			/* Work with existing channel type if possible. */
 			wk_ct = wk->chan_type;
@@ -993,7 +994,8 @@ static void ieee80211_work_work(struct work_struct *work)
 			 * happen to be on the same channel as
 			 * the requested channel.
 			 */
-			on_oper_chan2 = ieee80211_cfg_on_oper_channel(local);
+			on_oper_chan2 = ieee80211_cfg_on_oper_channel(local,
+								      true);
 			if (on_oper_chan != on_oper_chan2) {
 				if (on_oper_chan2) {
 					/* going off oper channel, PS too */
@@ -1091,7 +1093,7 @@ static void ieee80211_work_work(struct work_struct *work)
 	}
 
 	if (!remain_off_channel && local->tmp_channel) {
-		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local);
+		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local, true);
 		local->tmp_channel = NULL;
 		/* If tmp_channel wasn't operating channel, then
 		 * we need to go back on-channel.
@@ -1101,7 +1103,8 @@ static void ieee80211_work_work(struct work_struct *work)
 		 * we still need to do a hardware config.  Currently,
 		 * we cannot be here while scanning, however.
 		 */
-		if (ieee80211_cfg_on_oper_channel(local) && !on_oper_chan)
+		if (ieee80211_cfg_on_oper_channel(local, false) &&
+		    !on_oper_chan)
 			ieee80211_hw_config(local, 0);
 
 		/* At the least, we need to disable offchannel_ps,
-- 
1.7.3.4

