Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3JOCI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 22:08:57 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so8144552pbb.33
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 19:08:57 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v5 4/5] {nl,cfg,mac}80211: implement mesh channel switch userspace API
Date: Mon, 14 Oct 2013 19:08:30 -0700
Message-Id: <1381802911-3921-5-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131015_040912_112515_C8E2FAFF)
In-Reply-To: <1381802911-3921-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1381802911-3921-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the required procedures for mesh channel switching as defined
in the IEEE Std 802.11-2012 section 10.9.8.4.3 and also handle the CSA
and MCSP elements as followed:
 * Add the function for updating the beacon and probe response frames
   with CSA and MCSP elements during the period of switching to the new
   channel. Both CSA and MCSP elements must be included in beacon and
   probe response frames until the intended channel switch time.
 * The ifmsh->csa_settings is set to NULL and the CSA and MCSP elements
   will then be removed from the beacon or probe response frames once the
   new channel is switched to.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
v2: fix typo mistake, commit message and return value (Johannes Berg)
v3: use RCU to protect csa_settings for beaconing (Johannes Berg)
v4: fix broken kfree with kree_rcu (Johannes Berg)
v5: introduce wrapper struct for rcu purpose and fix sparse warning 
    on symbol 'ifmsh' warning(Johannes Berg)

 net/mac80211/cfg.c         |    7 +++-
 net/mac80211/ieee80211_i.h |   11 ++++++
 net/mac80211/mesh.c        |   93 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c          |    5 ++-
 net/mac80211/tx.c          |   16 ++++++++
 net/wireless/nl80211.c     |    3 +-
 6 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 438c689..a0b41d7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2887,6 +2887,11 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	case NL80211_IFTYPE_ADHOC:
 		ieee80211_ibss_finish_csa(sdata);
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		err = ieee80211_mesh_finish_csa(sdata);
+		if (err < 0)
+			return;
+		break;
 	default:
 		WARN_ON(1);
 		return;
@@ -3005,7 +3010,7 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
-		err = ieee80211_send_action_csa(sdata, params);
+		err = ieee80211_mesh_csa_beacon(sdata, params, true);
 		if (err < 0)
 			return err;
 		break;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3a6d2e7..2c0b477 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -538,6 +538,11 @@ struct ieee80211_mesh_sync_ops {
 	/* add other framework functions here */
 };
 
+struct mesh_csa_settings {
+	struct rcu_head rcu_head;
+	struct cfg80211_csa_settings settings;
+};
+
 struct ieee80211_if_mesh {
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
@@ -599,7 +604,9 @@ struct ieee80211_if_mesh {
 	int ps_peers_deep_sleep;
 	struct ps_data ps;
 	/* Channel Switching Support */
+	struct mesh_csa_settings __rcu *csa;
 	bool chsw_init;
+	u8 chsw_ttl;
 	u16 pre_value;
 };
 
@@ -1351,6 +1358,10 @@ void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb);
+int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
+			      struct cfg80211_csa_settings *csa_settings,
+			      bool csa_action);
+int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
 void ieee80211_scan_work(struct work_struct *work);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0a3ccaa..50b1863 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -12,6 +12,7 @@
 #include <asm/unaligned.h>
 #include "ieee80211_i.h"
 #include "mesh.h"
+#include "driver-ops.h"
 
 static int mesh_allocated;
 static struct kmem_cache *rm_cache;
@@ -610,6 +611,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct mesh_csa_settings *csa;
 	enum ieee80211_band band;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
@@ -624,6 +626,10 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 
 	head_len = hdr_len +
 		   2 + /* NULL SSID */
+		   /* Channel Switch Announcement */
+		   2 + sizeof(struct ieee80211_channel_sw_ie) +
+		   /* Mesh Channel Swith Parameters */
+		   2 + sizeof(struct ieee80211_mesh_chansw_params_ie) +
 		   2 + 8 + /* supported rates */
 		   2 + 3; /* DS params */
 	tail_len = 2 + (IEEE80211_MAX_SUPP_RATES - 8) +
@@ -665,6 +671,38 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = 0x0;
 
+	rcu_read_lock();
+	csa = rcu_dereference(ifmsh->csa);
+	if (csa) {
+		__le16 pre_value;
+
+		pos = skb_put(skb, 13);
+		memset(pos, 0, 13);
+		*pos++ = WLAN_EID_CHANNEL_SWITCH;
+		*pos++ = 3;
+		*pos++ = 0x0;
+		*pos++ = ieee80211_frequency_to_channel(
+				csa->settings.chandef.chan->center_freq);
+		sdata->csa_counter_offset_beacon = hdr_len + 6;
+		*pos++ = csa->settings.count;
+		*pos++ = WLAN_EID_CHAN_SWITCH_PARAM;
+		*pos++ = 6;
+		if (ifmsh->chsw_init) {
+			*pos++ = ifmsh->mshcfg.dot11MeshTTL;
+			*pos |= WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
+		} else {
+			*pos++ = ifmsh->chsw_ttl;
+		}
+		*pos++ |= csa->settings.block_tx ?
+			  WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT : 0x00;
+		put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos);
+		pos += 2;
+		pre_value = cpu_to_le16(ifmsh->pre_value);
+		memcpy(pos, &pre_value, 2);
+		pos += 2;
+	}
+	rcu_read_unlock();
+
 	if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 	    mesh_add_ds_params_ie(sdata, skb))
 		goto out_free;
@@ -920,6 +958,60 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			stype, mgmt, &elems, rx_status);
 }
 
+int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_csa_settings *tmp_csa_settings;
+	int ret = 0;
+
+	/* Remove the CSA and MCSP elements from the beacon */
+	tmp_csa_settings = rcu_dereference(ifmsh->csa);
+	rcu_assign_pointer(ifmsh->csa, NULL);
+	kfree_rcu(tmp_csa_settings, rcu_head);
+	ret = ieee80211_mesh_rebuild_beacon(sdata);
+	if (ret)
+		return -EINVAL;
+
+	/* Reset the TTL value and Initiator flag */
+	ifmsh->chsw_init = false;
+	ifmsh->chsw_ttl = 0;
+
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+
+	mcsa_dbg(sdata, "complete switching to center freq %d MHz",
+		 sdata->vif.bss_conf.chandef.chan->center_freq);
+	return 0;
+}
+
+int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
+			      struct cfg80211_csa_settings *csa_settings,
+			      bool csa_action)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_csa_settings *tmp_csa_settings;
+	int ret = 0;
+
+	if (csa_action)
+		ieee80211_send_action_csa(sdata, csa_settings);
+
+	tmp_csa_settings = kmalloc(sizeof(*tmp_csa_settings),
+				   GFP_ATOMIC);
+	if (!tmp_csa_settings)
+		return -ENOMEM;
+
+	memcpy(&tmp_csa_settings->settings, csa_settings,
+	       sizeof(struct cfg80211_csa_settings));
+
+	rcu_assign_pointer(ifmsh->csa, tmp_csa_settings);
+
+	ret = ieee80211_mesh_rebuild_beacon(sdata);
+	if (ret)
+		return -EINVAL;
+
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	return 0;
+}
+
 static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
 			       struct ieee80211_mgmt *mgmt, size_t len)
 {
@@ -942,6 +1034,7 @@ static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
 	offset_ttl = (len < 42) ? 7 : 10;
 	*(pos + offset_ttl) -= 1;
 	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
+	sdata->u.mesh.chsw_ttl = *(pos + offset_ttl);
 
 	memcpy(mgmt_fwd, mgmt, len);
 	eth_broadcast_addr(mgmt_fwd->da);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8e908e1..0ba1fad 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2592,13 +2592,16 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 				break;
 
 			if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-			    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+			    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+			    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 				break;
 
 			if (sdata->vif.type == NL80211_IFTYPE_STATION)
 				bssid = sdata->u.mgd.bssid;
 			else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 				bssid = sdata->u.ibss.bssid;
+			else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+				bssid = mgmt->sa;
 			else
 				break;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4fcbf63..80b9a57 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2369,6 +2369,10 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 		beacon_data = beacon->head;
 		beacon_data_len = beacon->head_len;
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		beacon_data = beacon->head;
+		beacon_data_len = beacon->head_len;
+		break;
 	default:
 		return;
 	}
@@ -2425,6 +2429,15 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 
 		beacon_data = beacon->head;
 		beacon_data_len = beacon->head_len;
+	} else if (vif->type == NL80211_IFTYPE_MESH_POINT) {
+		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+		beacon = rcu_dereference(ifmsh->beacon);
+		if (!beacon)
+			goto out;
+
+		beacon_data = beacon->head;
+		beacon_data_len = beacon->head_len;
 	} else {
 		WARN_ON(1);
 		goto out;
@@ -2530,6 +2543,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		if (!bcn)
 			goto out;
 
+		if (sdata->vif.csa_active)
+			ieee80211_update_csa(sdata, bcn);
+
 		if (ifmsh->sync_ops)
 			ifmsh->sync_ops->adjust_tbtt(
 						sdata);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7bb5aca..be844d4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10760,7 +10760,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
-		    wdev->iftype != NL80211_IFTYPE_ADHOC))
+		    wdev->iftype != NL80211_IFTYPE_ADHOC &&
+		    wdev->iftype != NL80211_IFTYPE_MESH_POINT))
 		goto out;
 
 	wdev->channel = chandef->chan;
-- 
1.7.9.5

