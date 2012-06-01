Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab2FAKj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 06:39:58 -0400
Message-ID: <1338547195.4884.16.camel@jlt3.sipsolutions.net> (sfid-20120601_124023_742827_1A34F686)
Subject: [PATCH] mac80211: do remain-on-channel while idle
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 01 Jun 2012 12:39:55 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The IDLE handling in HW off-channel is broken right
now since we turn off IDLE only when the off-channel
period already started. Therefore, all drivers that
use it today (only iwlwifi!) must support off-channel
while idle, so playing with idle isn't needed at all.

Also document a small caveat for reporting TX status
from off-channel frames in HW remain-on-channel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |    8 +++++++-
 net/mac80211/cfg.c        |    7 +++----
 net/mac80211/iface.c      |    9 ++-------
 net/mac80211/offchannel.c |    4 ----
 4 files changed, 12 insertions(+), 16 deletions(-)

--- a/include/net/mac80211.h	2012-06-01 10:23:19.000000000 +0200
+++ b/include/net/mac80211.h	2012-06-01 10:33:10.000000000 +0200
@@ -2183,7 +2183,13 @@ enum ieee80211_rate_control_changed {
  *	offload. Frames to transmit on the off-channel channel are transmitted
  *	normally except for the %IEEE80211_TX_CTL_TX_OFFCHAN flag. When the
  *	duration (which will always be non-zero) expires, the driver must call
- *	ieee80211_remain_on_channel_expired(). This callback may sleep.
+ *	ieee80211_remain_on_channel_expired().
+ *	The driver must not call ieee80211_remain_on_channel_expired() before
+ *	the TX status for a frame that was sent off-channel, otherwise the TX
+ *	status is reported to userspace in an invalid way.
+ *	Note that this callback may be called while the device is in IDLE and
+ *	must be accepted in this case.
+ *	This callback may sleep.
  * @cancel_remain_on_channel: Requests that an ongoing off-channel period is
  *	aborted before it expires. This callback may sleep.
  *
--- a/net/mac80211/cfg.c	2012-06-01 10:33:10.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-06-01 10:34:30.000000000 +0200
@@ -2187,8 +2187,6 @@ static int ieee80211_cancel_remain_on_ch
 	local->hw_roc_cookie = 0;
 	local->hw_roc_channel = NULL;
 
-	ieee80211_recalc_idle(local);
-
 	return 0;
 }
 
@@ -2248,7 +2246,7 @@ static int ieee80211_mgmt_tx(struct wiph
 	struct ieee80211_work *wk;
 	const struct ieee80211_mgmt *mgmt = (void *)buf;
 	u32 flags;
-	bool is_offchan = false;
+	bool is_offchan = false, in_hw_roc = false;
 
 	if (dont_wait_for_ack)
 		flags = IEEE80211_TX_CTL_NO_ACK;
@@ -2268,6 +2266,7 @@ static int ieee80211_mgmt_tx(struct wiph
 	if (chan == local->hw_roc_channel) {
 		/* TODO: check channel type? */
 		is_offchan = false;
+		in_hw_roc = true;
 		flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
 	}
 
@@ -2368,7 +2367,7 @@ static int ieee80211_mgmt_tx(struct wiph
 	 * wait is involved, we might otherwise not be on
 	 * the right channel for long enough!
 	 */
-	if (!is_offchan && !wait && !sdata->vif.bss_conf.idle) {
+	if (!is_offchan && !wait && (in_hw_roc || !sdata->vif.bss_conf.idle)) {
 		ieee80211_tx_skb(sdata, skb);
 		return 0;
 	}
--- a/net/mac80211/iface.c	2012-06-01 10:33:10.000000000 +0200
+++ b/net/mac80211/iface.c	2012-06-01 10:33:10.000000000 +0200
@@ -1454,7 +1454,7 @@ u32 __ieee80211_recalc_idle(struct ieee8
 {
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
-	bool working = false, scanning = false, hw_roc = false;
+	bool working = false, scanning = false;
 	struct ieee80211_work *wk;
 	unsigned int led_trig_start = 0, led_trig_stop = 0;
 
@@ -1502,9 +1502,6 @@ u32 __ieee80211_recalc_idle(struct ieee8
 		local->scan_sdata->vif.bss_conf.idle = false;
 	}
 
-	if (local->hw_roc_channel)
-		hw_roc = true;
-
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
 		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -1516,7 +1513,7 @@ u32 __ieee80211_recalc_idle(struct ieee8
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
 	}
 
-	if (working || scanning || hw_roc)
+	if (working || scanning)
 		led_trig_start |= IEEE80211_TPT_LEDTRIG_FL_WORK;
 	else
 		led_trig_stop |= IEEE80211_TPT_LEDTRIG_FL_WORK;
@@ -1528,8 +1525,6 @@ u32 __ieee80211_recalc_idle(struct ieee8
 
 	ieee80211_mod_tpt_led_trig(local, led_trig_start, led_trig_stop);
 
-	if (hw_roc)
-		return ieee80211_idle_off(local, "hw remain-on-channel");
 	if (working)
 		return ieee80211_idle_off(local, "working");
 	if (scanning)
--- a/net/mac80211/offchannel.c	2012-06-01 10:33:10.000000000 +0200
+++ b/net/mac80211/offchannel.c	2012-06-01 10:33:10.000000000 +0200
@@ -207,8 +207,6 @@ static void ieee80211_hw_roc_start(struc
 					  GFP_KERNEL);
 	}
 
-	ieee80211_recalc_idle(local);
-
 	mutex_unlock(&local->mtx);
 }
 
@@ -260,8 +258,6 @@ static void ieee80211_hw_roc_done(struct
 	local->hw_roc_channel = NULL;
 	local->hw_roc_cookie = 0;
 
-	ieee80211_recalc_idle(local);
-
 	mutex_unlock(&local->mtx);
 }
 


