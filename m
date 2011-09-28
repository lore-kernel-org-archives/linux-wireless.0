Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44514 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1I1LNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 07:13:14 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so428931fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2011 04:13:13 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 4/5] nl80211/mac80211: allow adding TDLS peers as stations
Date: Wed, 28 Sep 2011 14:12:53 +0300
Message-Id: <1317208374-19286-4-git-send-email-arik@wizery.com> (sfid-20110928_131322_309178_3117660B)
In-Reply-To: <1317208374-19286-1-git-send-email-arik@wizery.com>
References: <1317208374-19286-1-git-send-email-arik@wizery.com>
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
 net/mac80211/cfg.c      |   20 ++++++++++++++++++++
 net/mac80211/mlme.c     |    7 ++++---
 net/mac80211/sta_info.h |    2 ++
 net/wireless/nl80211.c  |   26 ++++++++++++++++++++++----
 5 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a5ab23d..9d797f2 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1434,6 +1434,7 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
+ * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1444,6 +1445,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
+	NL80211_STA_FLAG_TDLS_PEER,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 158d65d..866677e 100644
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
@@ -811,6 +817,12 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sta_apply_parameters(local, sta, params);
 
+	/* Only TDLS-supporting stations can add TDLS peers */
+	if ((sta->flags & WLAN_STA_TDLS_PEER) &&
+	    !((wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
+	      sdata->vif.type == NL80211_IFTYPE_STATION))
+		return -ENOTSUPP;
+
 	rate_control_rate_init(sta);
 
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
@@ -863,6 +875,14 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		return -ENOENT;
 	}
 
+	/* The TDLS bit cannot be toggled after the STA was added */
+	if ((params->sta_flags_mask & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
+	    !!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) !=
+	    !!test_sta_flags(sta, WLAN_STA_TDLS_PEER)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
 	if (params->vlan && params->vlan != sta->sdata->dev) {
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cd37a4e..b98c43a 100644
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
index 235b77a..9010858 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2530,18 +2530,25 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
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
+		if (params.supported_rates &&
+		    !(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
 			err = -EINVAL;
 		if (params.ht_capa)
 			err = -EINVAL;
 		if (params.listen_interval >= 0)
 			err = -EINVAL;
-		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
+		if (params.sta_flags_mask &
+				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				  BIT(NL80211_STA_FLAG_TDLS_PEER)))
+			err = -EINVAL;
+		/* can't change the TDLS bit */
+		if (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
+		    (params.sta_flags_mask & BIT(NL80211_STA_FLAG_TDLS_PEER)))
 			err = -EINVAL;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
@@ -2660,7 +2667,18 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
+		return -EINVAL;
+
+	/*
+	 * Only managed stations can add TDLS peers, and only when the
+	 * wiphy supports external TDLS setup.
+	 */
+	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_STATION &&
+	    !((params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
+	      (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
+	      (rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP)))
 		return -EINVAL;
 
 	err = get_vlan(info, rdev, &params.vlan);
-- 
1.7.4.1

