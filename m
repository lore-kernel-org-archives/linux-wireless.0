Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:45652 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3LMTN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 14:13:59 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v10 1/5] mac80211: refactor ieee80211_ibss_process_chanswitch()
Date: Fri, 13 Dec 2013 21:13:50 +0200
Message-Id: <1386962034-7141-2-git-send-email-luciano.coelho@intel.com> (sfid-20131213_201414_050842_16F35EE7)
In-Reply-To: <1386962034-7141-1-git-send-email-luciano.coelho@intel.com>
References: <1386962034-7141-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor ieee80211_ibss_process_chanswitch() to use
ieee80211_channel_switch() and avoid code duplication.

Tested by: Simon Wunderlich <sw@simonwunderlich.de>
Acked by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c         |  4 +--
 net/mac80211/ibss.c        | 61 ++++++++++------------------------------------
 net/mac80211/ieee80211_i.h |  2 ++
 3 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a74d61d..96aebe5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3048,8 +3048,8 @@ unlock:
 	sdata_unlock(sdata);
 }
 
-static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-				    struct cfg80211_csa_settings *params)
+int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			     struct cfg80211_csa_settings *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index df21e4f..0c3a45c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -784,18 +784,10 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_csa_settings params;
 	struct ieee80211_csa_ie csa_ie;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_chanctx *chanctx;
 	enum nl80211_channel_type ch_type;
-	int err, num_chanctx;
+	int err;
 	u32 sta_flags;
 
-	if (sdata->vif.csa_active)
-		return true;
-
-	if (!sdata->vif.bss_conf.ibss_joined)
-		return false;
-
 	sta_flags = IEEE80211_STA_DISABLE_VHT;
 	switch (ifibss->chandef.width) {
 	case NL80211_CHAN_WIDTH_5:
@@ -826,9 +818,6 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	params.count = csa_ie.count;
 	params.chandef = csa_ie.chandef;
 
-	if (ifibss->chandef.chan->band != params.chandef.chan->band)
-		goto disconnect;
-
 	switch (ifibss->chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
@@ -884,28 +873,12 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		params.radar_required = true;
 	}
 
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (!chanctx_conf) {
-		rcu_read_unlock();
-		goto disconnect;
-	}
-
-	/* don't handle for multi-VIF cases */
-	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
-		rcu_read_unlock();
-		goto disconnect;
-	}
-	num_chanctx = 0;
-	list_for_each_entry_rcu(chanctx, &sdata->local->chanctx_list, list)
-		num_chanctx++;
-
-	if (num_chanctx > 1) {
-		rcu_read_unlock();
-		goto disconnect;
+	if (cfg80211_chandef_identical(&params.chandef,
+				       &sdata->vif.bss_conf.chandef)) {
+		ibss_dbg(sdata,
+			 "received csa with an identical chandef, ignoring\n");
+		return true;
 	}
-	rcu_read_unlock();
 
 	/* all checks done, now perform the channel switch. */
 	ibss_dbg(sdata,
@@ -914,19 +887,9 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	params.block_tx = !!csa_ie.mode;
 
-	ieee80211_ibss_csa_beacon(sdata, &params);
-	sdata->csa_radar_required = params.radar_required;
-
-	if (params.block_tx)
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
-
-	sdata->csa_chandef = params.chandef;
-	sdata->vif.csa_active = true;
-
-	ieee80211_bss_info_change_notify(sdata, err);
-	drv_channel_switch_beacon(sdata, &params.chandef);
+	if (ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
+				     &params))
+		goto disconnect;
 
 	ieee80211_ibss_csa_mark_radar(sdata);
 
@@ -962,7 +925,8 @@ ieee80211_rx_mgmt_spectrum_mgmt(struct ieee80211_sub_if_data *sdata,
 	if (len < required_len)
 		return;
 
-	ieee80211_ibss_process_chanswitch(sdata, elems, false);
+	if (!sdata->vif.csa_active)
+		ieee80211_ibss_process_chanswitch(sdata, elems, false);
 }
 
 static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
@@ -1143,7 +1107,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		goto put_bss;
 
 	/* process channel switch */
-	if (ieee80211_ibss_process_chanswitch(sdata, elems, true))
+	if (sdata->vif.csa_active ||
+	    ieee80211_ibss_process_chanswitch(sdata, elems, true))
 		goto put_bss;
 
 	/* same BSSID */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 32bae21..a7b4d55 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1442,6 +1442,8 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
 /* channel switch handling */
 void ieee80211_csa_finalize_work(struct work_struct *work);
+int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			     struct cfg80211_csa_settings *params);
 
 /* interface handling */
 int ieee80211_iface_init(void);
-- 
1.8.5.1

