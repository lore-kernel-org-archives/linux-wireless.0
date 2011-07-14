Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33991 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1GNHUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 03:20:52 -0400
Received: by wwe5 with SMTP id 5so69142wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 00:20:51 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: reconfigure tx on device reconfiguration
Date: Thu, 14 Jul 2011 10:21:10 +0300
Message-Id: <1310628070-6012-1-git-send-email-eliad@wizery.com> (sfid-20110714_092055_849205_F0B2B3D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tx_conf array to save the current tx queues
configuration, and reconfig it on resume (ieee80211_reconfig).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    1 +
 net/mac80211/util.c        |    7 ++++++-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4f2e424..a976d8d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -721,6 +721,7 @@ struct ieee80211_local {
 	struct workqueue_struct *workqueue;
 
 	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
+	struct ieee80211_tx_queue_params tx_conf[IEEE80211_MAX_QUEUES];
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 182cda6..6d0883a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -917,6 +917,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 			    params.aifs, params.cw_min, params.cw_max,
 			    params.txop, params.uapsd);
 #endif
+		local->tx_conf[queue] = params;
 		if (drv_conf_tx(local, queue, &params))
 			wiphy_debug(local->hw.wiphy,
 				    "failed to set TX queue parameters for queue %d\n",
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index faa392e..466ded7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -799,6 +799,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 
 		qparam.uapsd = false;
 
+		local->tx_conf[queue] = qparam;
 		drv_conf_tx(local, queue, &qparam);
 	}
 
@@ -1146,7 +1147,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
-	int res;
+	int res, i;
 
 #ifdef CONFIG_PM
 	if (local->suspended)
@@ -1219,6 +1220,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	/* setup RTS threshold */
 	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
 
+	/* reconfigure tx conf */
+	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
+		drv_conf_tx(local, i, &local->tx_conf[i]);
+
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
 
-- 
1.7.0.4

