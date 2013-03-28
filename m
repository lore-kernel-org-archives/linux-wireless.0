Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3C1Pqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 11:46:43 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: don't fiddle with netdev queues in MLME code
Date: Thu, 28 Mar 2013 16:46:34 +0100
Message-Id: <1364485596-30425-2-git-send-email-johannes@sipsolutions.net> (sfid-20130328_164651_892712_35917279)
In-Reply-To: <1364485596-30425-1-git-send-email-johannes@sipsolutions.net>
References: <1364485596-30425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The netdev queues should always represent the state that
the driver gave them, so fiddling with them isn't really
appropriate in the mlme code. Also, since we stop queues
for flushing now, this really isn't necessary any more.

As the scan/offchannel code has also been modified to no
longer do this a while ago, remove the outdated smp_mb()
and comments about it.

While at it, also add a pair of braces that was missing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e12fedc..8a71796 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1443,13 +1443,11 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    !(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
-		netif_tx_stop_all_queues(sdata->dev);
-
-		if (drv_tx_frames_pending(local))
+		if (drv_tx_frames_pending(local)) {
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(
 				  local->hw.conf.dynamic_ps_timeout));
-		else {
+		} else {
 			ieee80211_send_nullfunc(local, sdata, 1);
 			/* Flush to get the tx status of nullfunc frame */
 			ieee80211_flush_queues(local, sdata);
@@ -1463,9 +1461,6 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
-
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-		netif_tx_wake_all_queues(sdata->dev);
 }
 
 void ieee80211_dynamic_ps_timer(unsigned long data)
@@ -1725,7 +1720,6 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_smps(sdata);
 	ieee80211_recalc_ps_vif(sdata);
 
-	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
 }
 
@@ -1748,22 +1742,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_stop_poll(sdata);
 
 	ifmgd->associated = NULL;
-
-	/*
-	 * we need to commit the associated = NULL change because the
-	 * scan code uses that to determine whether this iface should
-	 * go to/wake up from powersave or not -- and could otherwise
-	 * wake the queues erroneously.
-	 */
-	smp_mb();
-
-	/*
-	 * Thus, we can only afterwards stop the queues -- to account
-	 * for the case where another CPU is finishing a scan at this
-	 * time -- we don't want the scan code to enable queues.
-	 */
-
-	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
 	/*
-- 
1.8.0

