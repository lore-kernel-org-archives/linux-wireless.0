Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3CZNgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 09:36:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/4] mac80211: support extended channel switch
Date: Tue, 26 Mar 2013 14:36:00 +0100
Message-Id: <1364304961-32028-4-git-send-email-johannes@sipsolutions.net> (sfid-20130326_143617_182116_83A9ED6D)
In-Reply-To: <1364304961-32028-1-git-send-email-johannes@sipsolutions.net>
References: <1364304961-32028-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Support extended channel switch when the operating
class is one of the global operating classes as
defined in Annex E of 802.11-2012. If it isn't,
disconnect from the AP instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  | 12 ++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 77 ++++++++++++++++++++++++++++++----------------
 net/mac80211/util.c        |  7 +++++
 4 files changed, 71 insertions(+), 26 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ba8b10e..4305fc5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -673,6 +673,18 @@ struct ieee80211_channel_sw_ie {
 } __packed;
 
 /**
+ * struct ieee80211_ext_chansw_ie
+ *
+ * This structure represents the "Extended Channel Switch Announcement element"
+ */
+struct ieee80211_ext_chansw_ie {
+	u8 mode;
+	u8 new_operating_class;
+	u8 new_ch_num;
+	u8 count;
+} __packed;
+
+/**
  * struct ieee80211_tim
  *
  * This structure refers to "Traffic Indication Map information element"
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bd6ab0e..ca7df00 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1181,6 +1181,7 @@ struct ieee802_11_elems {
 	const u8 *perr;
 	const struct ieee80211_rann_ie *rann;
 	const struct ieee80211_channel_sw_ie *ch_switch_ie;
+	const struct ieee80211_ext_chansw_ie *ext_chansw_ie;
 	const u8 *country_elem;
 	const u8 *pwr_constr_elem;
 	const u8 *quiet_elem;	/* first quite element */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d266e52..538a417 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1058,56 +1058,79 @@ static void
 ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				 u64 timestamp, struct ieee802_11_elems *elems)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_bss *cbss = ifmgd->associated;
 	struct ieee80211_bss *bss;
 	struct ieee80211_channel *new_ch;
-	int new_freq;
 	struct ieee80211_chanctx *chanctx;
+	enum ieee80211_band new_band;
+	int new_freq;
+	u8 new_chan_no;
+	u8 count;
+	u8 mode;
 
 	ASSERT_MGD_MTX(ifmgd);
 
 	if (!cbss)
 		return;
 
-	if (sdata->local->scanning)
+	if (local->scanning)
 		return;
 
 	/* disregard subsequent announcements if we are already processing */
 	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
 		return;
 
-	if (!elems->ch_switch_ie)
+	if (elems->ext_chansw_ie) {
+		if (!ieee80211_operating_class_to_band(
+				elems->ext_chansw_ie->new_operating_class,
+				&new_band)) {
+			sdata_info(sdata,
+				   "cannot understand ECSA IE operating class %d, disconnecting\n",
+				   elems->ext_chansw_ie->new_operating_class);
+			ieee80211_queue_work(&local->hw,
+					     &ifmgd->csa_connection_drop_work);
+		}
+		new_chan_no = elems->ext_chansw_ie->new_ch_num;
+		count = elems->ext_chansw_ie->count;
+		mode = elems->ext_chansw_ie->mode;
+	} else if (elems->ch_switch_ie) {
+		new_band = cbss->channel->band;
+		new_chan_no = elems->ch_switch_ie->new_ch_num;
+		count = elems->ch_switch_ie->count;
+		mode = elems->ch_switch_ie->mode;
+	} else {
+		/* nothing here we understand */
 		return;
+	}
 
 	bss = (void *)cbss->priv;
 
-	new_freq = ieee80211_channel_to_frequency(
-			elems->ch_switch_ie->new_ch_num,
-			cbss->channel->band);
-	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
+	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
+	new_ch = ieee80211_get_channel(local->hw.wiphy, new_freq);
 	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED) {
 		sdata_info(sdata,
 			   "AP %pM switches to unsupported channel (%d MHz), disconnecting\n",
 			   ifmgd->associated->bssid, new_freq);
-		ieee80211_queue_work(&sdata->local->hw,
+		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
 		return;
 	}
 
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 
-	if (sdata->local->use_chanctx) {
+	if (local->use_chanctx) {
 		sdata_info(sdata,
 			   "not handling channel switch with channel contexts\n");
-		ieee80211_queue_work(&sdata->local->hw,
+		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
 		return;
 	}
 
-	mutex_lock(&sdata->local->chanctx_mtx);
+	mutex_lock(&local->chanctx_mtx);
 	if (WARN_ON(!rcu_access_pointer(sdata->vif.chanctx_conf))) {
-		mutex_unlock(&sdata->local->chanctx_mtx);
+		mutex_unlock(&local->chanctx_mtx);
 		return;
 	}
 	chanctx = container_of(rcu_access_pointer(sdata->vif.chanctx_conf),
@@ -1115,40 +1138,39 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (chanctx->refcount > 1) {
 		sdata_info(sdata,
 			   "channel switch with multiple interfaces on the same channel, disconnecting\n");
-		ieee80211_queue_work(&sdata->local->hw,
+		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&sdata->local->chanctx_mtx);
+		mutex_unlock(&local->chanctx_mtx);
 		return;
 	}
-	mutex_unlock(&sdata->local->chanctx_mtx);
+	mutex_unlock(&local->chanctx_mtx);
 
-	sdata->local->csa_channel = new_ch;
+	local->csa_channel = new_ch;
 
-	if (elems->ch_switch_ie->mode)
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+	if (mode)
+		ieee80211_stop_queues_by_reason(&local->hw,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	if (sdata->local->ops->channel_switch) {
+	if (local->ops->channel_switch) {
 		/* use driver's channel switch callback */
 		struct ieee80211_channel_switch ch_switch = {
 			.timestamp = timestamp,
-			.block_tx = elems->ch_switch_ie->mode,
+			.block_tx = mode,
 			.channel = new_ch,
-			.count = elems->ch_switch_ie->count,
+			.count = count,
 		};
 
-		drv_channel_switch(sdata->local, &ch_switch);
+		drv_channel_switch(local, &ch_switch);
 		return;
 	}
 
 	/* channel switch handled in software */
-	if (elems->ch_switch_ie->count <= 1)
-		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
+	if (count <= 1)
+		ieee80211_queue_work(&local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  TU_TO_EXP_TIME(elems->ch_switch_ie->count *
-					 cbss->beacon_interval));
+			  TU_TO_EXP_TIME(count * cbss->beacon_interval));
 }
 
 static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
@@ -2683,6 +2705,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_channel *channel;
 	bool need_ps = false;
 
+	lockdep_assert_held(&sdata->u.mgd.mtx);
+
 	if ((sdata->u.mgd.associated &&
 	     ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid)) ||
 	    (sdata->u.mgd.assoc_data &&
@@ -2724,6 +2748,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime, elems);
+
 }
 
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1734cd2..543bb69 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -870,6 +870,13 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			}
 			elems->ch_switch_ie = (void *)pos;
 			break;
+		case WLAN_EID_EXT_CHANSWITCH_ANN:
+			if (elen != sizeof(struct ieee80211_ext_chansw_ie)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->ext_chansw_ie = (void *)pos;
+			break;
 		case WLAN_EID_QUIET:
 			if (!elems->quiet_elem) {
 				elems->quiet_elem = pos;
-- 
1.8.0

