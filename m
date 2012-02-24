Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46948 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2BXCaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 21:30:24 -0500
Received: by pbcun15 with SMTP id un15so2095081pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 18:30:24 -0800 (PST)
MIME-Version: 1.0
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH] {nl,cfg,mac}80211: Enable control quality monitoring for mesh
Date: Thu, 23 Feb 2012 18:30:21 -0800
Message-Id: <1330050621-8955-1-git-send-email-ashok@cozybit.com> (sfid-20120224_033027_978577_9073776C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh peer links are established only if average rssi of the peer
candidate satisfies the threshold. This is not in 802.11s specification
but was requested by David Fulgham, an open80211s user. This is a way to avoid
marginal peer links with stations that are barely within range.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 net/mac80211/cfg.c                    |    1 +
 net/mac80211/mesh_plink.c             |   22 +++++++++++++++++++++-
 net/wireless/nl80211.c                |    3 ++-
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4b9e730..ca7d5a6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -729,6 +729,7 @@ static int mac80211_hwsim_add_interface(struct ieee80211_hw *hw,
 		    __func__, ieee80211_vif_type_p2p(vif),
 		    vif->addr);
 	hwsim_set_magic(vif);
+	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 	return 0;
 }
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f7eb25a..d50258d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1853,6 +1853,7 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 
 	/* tell the driver upon association, unless already associated */
 	if (sdata->u.mgd.associated &&
+	    sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8806e5e..6144f35 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -31,6 +31,17 @@
 #define dot11MeshHoldingTimeout(s) (s->u.mesh.mshcfg.dot11MeshHoldingTimeout)
 #define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
 
+/*
+ * NOTE: Mesh peer links are established only if average rssi of the peer
+ * candidate satisfies the threshold. sta_meets_rssi_treshold doesn't use
+ * hysteresis as fluctuations around threshold have no adverse effects.
+ */
+
+#define sta_meets_rssi_threshold(sta, sdata) \
+		(sdata->vif.bss_conf.cqm_rssi_thold == 0 || \
+		((s8) -ewma_read(&sta->avg_signal)) > \
+		 sdata->vif.bss_conf.cqm_rssi_thold)
+
 enum plink_event {
 	PLINK_UNDEFINED,
 	OPN_ACPT,
@@ -301,7 +312,8 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 	if (mesh_peer_accepts_plinks(elems) &&
 			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
-			sdata->u.mesh.mshcfg.auto_open_plinks)
+			sdata->u.mesh.mshcfg.auto_open_plinks &&
+			sta_meets_rssi_threshold(sta, sdata))
 		mesh_plink_open(sta);
 
 	rcu_read_unlock();
@@ -531,6 +543,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
+	if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
+	    !sta_meets_rssi_threshold(sta, sdata)) {
+		mpl_dbg("Mesh plink: %pM does not meet rssi threshold\n",
+			sta->sta.addr);
+		rcu_read_unlock();
+		return;
+	}
+
 	if (sta && !test_sta_flag(sta, WLAN_STA_AUTH)) {
 		mpl_dbg("Mesh plink: Action frame from non-authed peer\n");
 		rcu_read_unlock();
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1998c36..6feff8c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5796,7 +5796,8 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 		return -EOPNOTSUPP;
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION &&
-	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    wdev->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
 	return rdev->ops->set_cqm_rssi_config(wdev->wiphy, dev,
-- 
1.7.0.4

