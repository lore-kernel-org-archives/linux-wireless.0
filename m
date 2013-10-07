Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48942 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3JGQlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:41:19 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 2/3] mac80211: enable DFS for IBSS mode
Date: Mon,  7 Oct 2013 18:41:06 +0200
Message-Id: <1381164067-4830-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20131007_184128_451412_8D6EFD13)
In-Reply-To: <1381164067-4830-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1381164067-4830-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow changing to DFS channels if the channel is available for
beaconing and userspace controls DFS operation.

Channel switch announcement from other stations on DFS channels will
be interpreted as radar event. These channels will then be marked as
unvailable.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCHv1:
 * rename control_port_dfs to userspace_handles_dfs
---
 net/mac80211/ibss.c        |   49 +++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |    1 +
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 21a0b88..275bbb2 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -229,6 +229,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *presp;
 	enum nl80211_bss_scan_width scan_width;
 	bool have_higher_than_11mbit;
+	bool radar_required = false;
 	int err;
 
 	sdata_assert_lock(sdata);
@@ -273,6 +274,23 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
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
+		if (!ifibss->userspace_handles_dfs) {
+			sdata_info(sdata,
+				   "Failed to join IBSS, DFS channel without control program\n");
+			return;
+		}
+		radar_required = true;
 	}
 
 	ieee80211_vif_release_channel(sdata);
@@ -297,6 +315,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	rcu_assign_pointer(ifibss->presp, presp);
 	mgmt = (void *)presp->head;
 
+	sdata->radar_required = radar_required;
 	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.beacon_int = beacon_int;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
@@ -796,6 +815,21 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
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
@@ -880,8 +914,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto disconnect;
 	}
 
-	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
-				     IEEE80211_CHAN_DISABLED)) {
+	if (!cfg80211_reg_can_beacon(sdata->local->hw.wiphy, &params.chandef)) {
 		sdata_info(sdata,
 			   "IBSS %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
 			   ifibss->bssid,
@@ -897,10 +930,11 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (err < 0)
 		goto disconnect;
 	if (err) {
+		/* IBSS-DFS only allowed with a control program */
+		if (!ifibss->userspace_handles_dfs)
+			goto disconnect;
+
 		params.radar_required = true;
-
-		/* TODO: IBSS-DFS not (yet) supported, disconnect. */
-		goto disconnect;
 	}
 
 	rcu_read_lock();
@@ -947,12 +981,16 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
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
 
@@ -1688,6 +1726,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.control_port = params->control_port;
+	sdata->u.ibss.userspace_handles_dfs = params->userspace_handles_dfs;
 	sdata->u.ibss.basic_rates = params->basic_rates;
 
 	/* fix basic_rates if channel does not support these rates */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3a87c89..9752567 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -497,6 +497,7 @@ struct ieee80211_if_ibss {
 	bool privacy;
 
 	bool control_port;
+	bool userspace_handles_dfs;
 
 	u8 bssid[ETH_ALEN] __aligned(2);
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
-- 
1.7.10.4

