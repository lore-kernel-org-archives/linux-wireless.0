Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35147 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab1GNR3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 13:29:24 -0400
Received: by wyg8 with SMTP id 8so304384wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 10:29:23 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3] mac80211: reconfigure tx on device reconfiguration
Date: Thu, 14 Jul 2011 20:29:42 +0300
Message-Id: <1310664582-11973-1-git-send-email-eliad@wizery.com> (sfid-20110714_192927_724513_87966210)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tx_conf array to save the current tx queues
configuration, and reconfig it on resume (ieee80211_reconfig).

On resume, the driver is being reconfigured. Without
reconfiguring the tx queues as well, the driver might
configure the device to use wrong ac params (e.g. ps-poll
instead of uapsd).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: edit commit message
v3: use hw->queues, save tx conf in ieee80211_set_txq_params

 net/mac80211/cfg.c         |    4 ++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    1 +
 net/mac80211/util.c        |    7 ++++++-
 4 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d7ea34a..4938841 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1262,6 +1262,10 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 	 */
 	p.uapsd = false;
 
+	if (params->queue >= local->hw.queues)
+		return -EINVAL;
+
+	local->tx_conf[params->queue] = p;
 	if (drv_conf_tx(local, params->queue, &p)) {
 		wiphy_debug(local->hw.wiphy,
 			    "failed to set TX queue parameters for queue %d\n",
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
index faa392e..96f4cf9 100644
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
+	for (i = 0; i < hw->queues; i++)
+		drv_conf_tx(local, i, &local->tx_conf[i]);
+
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
 
-- 
1.7.0.4

