Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58033 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751660AbaKGMcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 07:32:06 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri,  7 Nov 2014 14:31:36 +0200
Message-Id: <1415363497-8475-3-git-send-email-luca@coelho.fi> (sfid-20141107_133216_452842_5FF7094C)
In-Reply-To: <1415363497-8475-1-git-send-email-luca@coelho.fi>
References: <1415363497-8475-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 2/3] mac80211: send channel switch started notifications
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Send a channel switch notification to userspace when a channel switch
is requested or when we react to a remote CSA.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c  | 3 +++
 net/mac80211/mlme.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0618594..c5be146 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3195,6 +3195,9 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_stop_vif_queues(local, sdata,
 					  IEEE80211_QUEUE_STOP_REASON_CSA);
 
+	cfg80211_ch_switch_started_notify(sdata->dev, &sdata->csa_chandef,
+					  params->count);
+
 	if (changed) {
 		ieee80211_bss_info_change_notify(sdata, changed);
 		drv_channel_switch_beacon(sdata, &params->chandef);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0d166e7..e31299f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1205,6 +1205,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 					  IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 
+	cfg80211_ch_switch_started_notify(sdata->dev, &csa_ie.chandef,
+					  csa_ie.count);
+
 	if (local->ops->channel_switch) {
 		/* use driver's channel switch callback */
 		drv_channel_switch(local, sdata, &ch_switch);
-- 
2.1.1

