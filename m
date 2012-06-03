Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43559 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2FCUa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 16:30:27 -0400
Received: by wgbdr13 with SMTP id dr13so3444419wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2012 13:30:26 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: stop Rx during HW reconfig
Date: Sun,  3 Jun 2012 23:30:22 +0300
Message-Id: <1338755422-13220-1-git-send-email-arik@wizery.com> (sfid-20120603_223029_986198_56590100)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While HW reconfig is in progress, drop all incoming Rx. This prevents
incoming packets from changing the internal state of the driver or
calling callbacks of the low level driver while it is in inconsistent
state.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/rx.c          |    7 +++++++
 net/mac80211/util.c        |   10 ++++++++++
 3 files changed, 20 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1975f35..9b915c6 100644
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
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 489093b..d08b431 100644
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
index 7c7e571..f369e5e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1233,6 +1233,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		return res;
 	}
 
+	/*
+	 * Stop all Rx during the reconfig. We don't want state changes
+	 * or driver callbacks while this is in progress.
+	 */
+	local->in_reconfig = true;
+	smp_wmb();
+
 	/* setup fragmentation threshold */
 	drv_set_frag_threshold(local, hw->wiphy->frag_threshold);
 
@@ -1376,6 +1383,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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

