Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44884 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1IZKzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 06:55:13 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so3462643eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 03:55:12 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/5] nl80211/mac80211: allow adding TDLS peers as stations
Date: Mon, 26 Sep 2011 13:54:52 +0300
Message-Id: <1317034493-5300-5-git-send-email-arik@wizery.com> (sfid-20110926_125521_419653_B5DAD54E)
In-Reply-To: <1317034493-5300-1-git-send-email-arik@wizery.com>
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When adding a TDLS peer STA, mark it with a new flag in both nl80211 and
mac80211. Before adding a peer, make sure the wiphy supports TDLS and
our operating mode is appropriate (managed).

In addition, make sure all peers are removed on disassociation.

A TDLS peer is first added just before link setup is initiated. In later
setup stages we have more info about peer supported rates, capabilities,
etc. This info is reported via nl80211_set_station().

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
 include/linux/nl80211.h |    2 ++
 net/mac80211/cfg.c      |   11 +++++++++++
 net/mac80211/mlme.c     |    7 ++++---
 net/mac80211/sta_info.h |    2 ++
 net/wireless/nl80211.c  |   20 +++++++++++++++-----
 5 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 1582916..165a49c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1421,6 +1421,7 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
+ * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1431,6 +1432,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
+	NL80211_STA_FLAG_TDLS_PEER,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1adf823..8a3168c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -713,6 +713,12 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
 			sta->flags |= WLAN_STA_AUTH;
 	}
+
+	if (mask & BIT(NL80211_STA_FLAG_TDLS_PEER)) {
+		sta->flags &= ~WLAN_STA_TDLS_PEER;
+		if (set & BIT(NL80211_STA_FLAG_TDLS_PEER))
+			sta->flags |= WLAN_STA_TDLS_PEER;
+	}
 	spin_unlock_irqrestore(&sta->flaglock, flags);
 
 	sta->sta.uapsd_queues = params->uapsd_queues;
@@ -811,6 +817,11 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sta_apply_parameters(local, sta, params);
 
+	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
+	    (sta->flags & WLAN_STA_TDLS_PEER)) {
+		return -ENOTSUPP;
+	}
+
 	rate_control_rate_init(sta);
 
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1a59fb6..593a244 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1137,8 +1137,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	/* remove AP and TDLS peers */
 	if (remove_sta)
-		sta_info_destroy_addr(sdata, bssid);
+		sta_info_flush(local, sdata);
 
 	del_timer_sync(&sdata->u.mgd.conn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
@@ -2738,7 +2739,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 				       req->reason_code, cookie,
 				       !req->local_state_change);
 	if (assoc_bss)
-		sta_info_destroy_addr(sdata, bssid);
+		sta_info_flush(sdata->local, sdata);
 
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
@@ -2778,7 +2779,7 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_send_deauth_disassoc(sdata, req->bss->bssid,
 			IEEE80211_STYPE_DISASSOC, req->reason_code,
 			cookie, !req->local_state_change);
-	sta_info_destroy_addr(sdata, bssid);
+	sta_info_flush(sdata->local, sdata);
 
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 56a3d38..b6bd4e9 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -45,6 +45,7 @@
  *	station in power-save mode, reply when the driver unblocks.
  * @WLAN_STA_PS_DRIVER_BUF: Station has frames pending in driver internal
  *	buffers. Automatically cleared on station wake-up.
+ * @WLAN_STA_TDLS_PEER: station is a TDLS peer.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -61,6 +62,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PS_DRIVER	= 1<<12,
 	WLAN_STA_PSPOLL		= 1<<13,
 	WLAN_STA_PS_DRIVER_BUF	= 1<<14,
+	WLAN_STA_TDLS_PEER	= 1<<15,
 };
 
 #define STA_TID_NUM 16
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ed9e6d8..8e5184b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2521,18 +2521,18 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		/* disallow everything but AUTHORIZED flag */
+		/* disallow things sta doesn't support */
 		if (params.plink_action)
 			err = -EINVAL;
 		if (params.vlan)
 			err = -EINVAL;
-		if (params.supported_rates)
-			err = -EINVAL;
 		if (params.ht_capa)
 			err = -EINVAL;
 		if (params.listen_interval >= 0)
 			err = -EINVAL;
-		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
+		if (params.sta_flags_mask &
+				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				  BIT(NL80211_STA_FLAG_TDLS_PEER)))
 			err = -EINVAL;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
@@ -2651,7 +2651,17 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
+		return -EINVAL;
+
+	/*
+	 * Managed stations can only add TDLS peers, and only when the
+	 * wiphy supports it.
+	 */
+	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_STATION &&
+	    (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) ||
+	     !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS)))
 		return -EINVAL;
 
 	err = get_vlan(info, rdev, &params.vlan);
-- 
1.7.4.1

