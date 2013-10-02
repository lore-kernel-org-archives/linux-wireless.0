Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43376 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3JBIJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 04:09:51 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so696280pab.32
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 01:09:51 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v2 4/5] {nl,cfg,mac}80211: finalizing mesh channel switching
Date: Wed,  2 Oct 2013 01:02:43 -0700
Message-Id: <1380700964-844-5-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131002_100956_989032_1840DF85)
In-Reply-To: <1380700964-844-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1380700964-844-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finalizing the required procedures for channel switching completion based
on the procedures  defined in the IEEE Std 802.11-2012 section 10.9.8.4.3:
 * Add the function for updating the beacon and probe response frames
   with CSA and MCSP elements during the period of switching to the new
   channel.
 * The ifmsh->csa_settings is set to NULL and the CSA and MCSP elements
   will then be removed from the beacon or probe response frames once the
   new channel is switched to.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
v2: fix typo mistake, commit message and return value.  
    use spinlock to protect csa_settings  (Johannes Berg)

 net/mac80211/cfg.c         |    7 +++++-
 net/mac80211/ieee80211_i.h |    4 ++++
 net/mac80211/mesh.c        |   56 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c          |    5 +++-
 net/mac80211/tx.c          |   16 +++++++++++++
 net/wireless/nl80211.c     |    3 ++-
 6 files changed, 88 insertions(+), 3 deletions(-)

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
index f50e471..175ec7e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1346,6 +1346,10 @@ void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata);
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
index 7729679..93cfcb0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -12,6 +12,7 @@
 #include <asm/unaligned.h>
 #include "ieee80211_i.h"
 #include "mesh.h"
+#include "driver-ops.h"
 
 static int mesh_allocated;
 static struct kmem_cache *rm_cache;
@@ -956,6 +957,61 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			stype, mgmt, &elems, rx_status);
 }
 
+int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	int ret = 0;
+
+	/* Remove the CSA and MCSP elements from the beacon */
+	spin_lock_bh(&ifmsh->csa_set_lock);
+	kfree(ifmsh->csa_settings);
+	ifmsh->csa_settings = NULL;
+	spin_unlock_bh(&ifmsh->csa_set_lock);
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
+	struct cfg80211_csa_settings *tmp_csa_settings;
+	int ret = 0;
+
+	if (csa_action)
+		ieee80211_send_action_csa(sdata, csa_settings);
+
+	tmp_csa_settings = kmalloc(sizeof(struct cfg80211_csa_settings),
+				   GFP_ATOMIC);
+	if (!tmp_csa_settings)
+		return -ENOMEM;
+
+	spin_lock_bh(&ifmsh->csa_set_lock);
+	ifmsh->csa_settings = tmp_csa_settings;
+	memcpy(ifmsh->csa_settings, csa_settings,
+	       sizeof(struct cfg80211_csa_settings));
+	spin_unlock_bh(&ifmsh->csa_set_lock);
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

