Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35868 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2FFGco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 02:32:44 -0400
Received: by wibhj8 with SMTP id hj8so4661413wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 23:32:43 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: stop Rx during HW reconfig
Date: Wed,  6 Jun 2012 09:32:37 +0300
Message-Id: <1338964357-21685-1-git-send-email-arik@wizery.com> (sfid-20120606_083256_008432_D3D71FF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While HW reconfig is in progress, drop all incoming Rx. This prevents
incoming packets from changing the internal state of the driver or
calling callbacks of the low level driver while it is in inconsistent
state.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2: set in_reconfig when queuing the restart work.

 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/main.c        |    7 +++++++
 net/mac80211/rx.c          |    7 +++++++
 net/mac80211/util.c        |    3 +++
 4 files changed, 20 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae046b5..04e8912 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -912,6 +912,9 @@ struct ieee80211_local {
 	/* device is started */
 	bool started;
 
+	/* device is during a HW reconfig */
+	bool in_reconfig;
+
 	/* wowlan is enabled -- don't reconfig on resume */
 	bool wowlan;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b70f7f0..073f697 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -345,6 +345,13 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 	ieee80211_stop_queues_by_reason(hw,
 		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
+	/*
+	 * Stop all Rx during the reconfig. We don't want state changes
+	 * or driver callbacks while this is in progress.
+	 */
+	local->in_reconfig = true;
+	smp_wmb();
+
 	schedule_work(&local->restart_work);
 }
 EXPORT_SYMBOL(ieee80211_restart_hw);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d5ac02f..9e45fdf 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3023,6 +3023,9 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (WARN_ON(!sband))
 		goto drop;
 
+	/* make sure we get the latest values for the next variable checks */
+	smp_rmb();
+
 	/*
 	 * If we're suspending, it is possible although not too likely
 	 * that we'd be receiving frames after having already partially
@@ -3033,6 +3036,10 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (unlikely(local->quiescing || local->suspended))
 		goto drop;
 
+	/* We might be during a HW reconfig, prevent Rx for the same reason */
+	if (unlikely(local->in_reconfig))
+		goto drop;
+
 	/*
 	 * The same happens when we're not even started,
 	 * but that's worth a warning.
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 76f90c1..309acd4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1399,6 +1399,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
+	local->in_reconfig = false;
+	smp_wmb();
+
  wake_up:
 	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
-- 
1.7.9.5

