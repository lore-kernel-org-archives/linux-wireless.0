Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:39198 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751636AbaEBNlO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2014 09:41:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: michal.kazior@tieto.com
Date: Fri,  2 May 2014 16:40:29 +0300
Message-Id: <1399038031-23206-2-git-send-email-luca@coelho.fi> (sfid-20140502_154120_940377_82EBF5A9)
In-Reply-To: <1399038031-23206-1-git-send-email-luca@coelho.fi>
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 2/4] mac80211: send channel switch started notifications
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Send a channel switch notification to userspace when a channel switch
is requested or when we react to a remote CSA.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c  | 2 ++
 net/mac80211/mlme.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7b8d3cf..53a2cfe 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3281,6 +3281,8 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	sdata->csa_chandef = params->chandef;
 	sdata->vif.csa_active = true;
 
+	cfg80211_ch_switch_started_notify(sdata->dev, &sdata->csa_chandef);
+
 	if (changed) {
 		ieee80211_bss_info_change_notify(sdata, changed);
 		drv_channel_switch_beacon(sdata, &params->chandef);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 488826f..139005d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1107,6 +1107,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
+	cfg80211_ch_switch_started_notify(sdata->dev, &csa_ie.chandef);
+
 	if (local->ops->channel_switch) {
 		/* use driver's channel switch callback */
 		struct ieee80211_channel_switch ch_switch = {
-- 
1.9.2

