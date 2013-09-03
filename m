Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51729 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409Ab3ICRnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 13:43:35 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 3/4] mac80211: enable DFS for IBSS mode
Date: Tue,  3 Sep 2013 19:43:20 +0200
Message-Id: <1378230201-25446-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130903_194344_389318_8D0EF6F7)
In-Reply-To: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow changing to DFS channels if the channel is available for
beaconing and a control program is available.

Channel switch announcement on DFS channels will trigger a radar event
and mark these channels as unavailable.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ibss.c        |   50 +++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |    1 +
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5ea9b3a..c3bf369 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -229,6 +229,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *presp;
 	enum nl80211_bss_scan_width scan_width;
 	bool have_higher_than_11mbit;
+	bool radar_required = false;
+	int err;
 
 	sdata_assert_lock(sdata);
 
@@ -271,6 +273,23 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 		chandef.width = NL80211_CHAN_WIDTH_20;
 		chandef.center_freq1 = chan->center_freq;
+		/* check again for downgraded chandef */
+		if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+			sdata_info(sdata,
+				   "Failed to join IBSS, beacons forbidden\n");
+			return;
+		}
+	}
+
+	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
+					    &chandef);
+	if (err > 0) {
+		if (!ifibss->control_port_dfs) {
+			sdata_info(sdata,
+				   "Failed to join IBSS, DFS channel without control program\n");
+			return;
+		}
+		radar_required = true;
 	}
 
 	ieee80211_vif_release_channel(sdata);
@@ -295,6 +314,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	rcu_assign_pointer(ifibss->presp, presp);
 	mgmt = (void *)presp->head;
 
+	sdata->radar_required = radar_required;
 	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.beacon_int = beacon_int;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
@@ -778,6 +798,21 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
 
+static void ieee80211_ibss_csa_mark_radar(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	int err;
+
+	/* if the current channel is a DFS channel, mark the channel as
+	 * unavailable.
+	 */
+	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
+					    &ifibss->chandef);
+	if (err > 0)
+		cfg80211_radar_event(sdata->local->hw.wiphy, &ifibss->chandef,
+				     GFP_ATOMIC);
+}
+
 static bool
 ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				  struct ieee802_11_elems *elems,
@@ -862,8 +897,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto disconnect;
 	}
 
-	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
-				     IEEE80211_CHAN_DISABLED)) {
+	if (!cfg80211_reg_can_beacon(sdata->local->hw.wiphy, &params.chandef)) {
 		sdata_info(sdata,
 			   "IBSS %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
 			   ifibss->bssid,
@@ -879,10 +913,11 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (err < 0)
 		goto disconnect;
 	if (err) {
+		/* IBSS-DFS only allowed with a control program */
+		if (!ifibss->control_port_dfs)
+			goto disconnect;
+
 		params.radar_required = true;
-
-		/* TODO: IBSS-DFS not (yet) supported, disconnect. */
-		goto disconnect;
 	}
 
 	rcu_read_lock();
@@ -929,12 +964,16 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, err);
 	drv_channel_switch_beacon(sdata, &params.chandef);
 
+	ieee80211_ibss_csa_mark_radar(sdata);
+
 	return true;
 disconnect:
 	ibss_dbg(sdata, "Can't handle channel switch, disconnect\n");
 	ieee80211_queue_work(&sdata->local->hw,
 			     &ifibss->csa_connection_drop_work);
 
+	ieee80211_ibss_csa_mark_radar(sdata);
+
 	return true;
 }
 
@@ -1670,6 +1709,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.control_port = params->control_port;
+	sdata->u.ibss.control_port_dfs = params->control_port_dfs;
 	sdata->u.ibss.basic_rates = params->basic_rates;
 
 	/* fix basic_rates if channel does not support these rates */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3a87c89..2bb01b6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -497,6 +497,7 @@ struct ieee80211_if_ibss {
 	bool privacy;
 
 	bool control_port;
+	bool control_port_dfs;
 
 	u8 bssid[ETH_ALEN] __aligned(2);
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
-- 
1.7.10.4

