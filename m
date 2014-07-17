Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63706 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807AbaGQOOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:18 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so2097496wgh.23
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:16 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/15] mac80211: move TDLS data to mgd private part
Date: Thu, 17 Jul 2014 17:14:25 +0300
Message-Id: <1405606471-30128-10-git-send-email-arik@wizery.com> (sfid-20140717_161428_954002_3870A939)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can only be a station for TDLS connections. Also fix a bug where
a delayed work could be left scheduled if the station interface was
brought down during TDLS setup.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  6 +++---
 net/mac80211/iface.c       |  2 --
 net/mac80211/mlme.c        |  3 +++
 net/mac80211/tdls.c        | 28 ++++++++++++++--------------
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cb87476..0d8539c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -503,6 +503,9 @@ struct ieee80211_if_managed {
 	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
 	struct ieee80211_vht_cap vht_capa; /* configured VHT overrides */
 	struct ieee80211_vht_cap vht_capa_mask; /* Valid parts of vht_capa */
+
+	u8 tdls_peer[ETH_ALEN] __aligned(2);
+	struct delayed_work tdls_peer_del_work;
 };
 
 struct ieee80211_if_ibss {
@@ -815,9 +818,6 @@ struct ieee80211_sub_if_data {
 	bool radar_required;
 	struct delayed_work dfs_cac_timer_work;
 
-	u8 tdls_peer[ETH_ALEN] __aligned(2);
-	struct delayed_work tdls_peer_del_work;
-
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bbf51b2..2a12b8a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1672,8 +1672,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			  ieee80211_dfs_cac_timer_work);
 	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
 			  ieee80211_delayed_tailroom_dec);
-	INIT_DELAYED_WORK(&sdata->tdls_peer_del_work,
-			  ieee80211_tdls_peer_del_work);
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d863ff8..fcc0748 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3713,6 +3713,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_WORK(&ifmgd->csa_connection_drop_work,
 		  ieee80211_csa_connection_drop_work);
 	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_mgd_work);
+	INIT_DELAYED_WORK(&ifmgd->tdls_peer_del_work,
+			  ieee80211_tdls_peer_del_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,
@@ -4576,6 +4578,7 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	cancel_work_sync(&ifmgd->request_smps_work);
 	cancel_work_sync(&ifmgd->csa_connection_drop_work);
 	cancel_work_sync(&ifmgd->chswitch_work);
+	cancel_delayed_work_sync(&ifmgd->tdls_peer_del_work);
 
 	sdata_lock(sdata);
 	if (ifmgd->assoc_data) {
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 72eebea..c59b8f4 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -22,14 +22,14 @@ void ieee80211_tdls_peer_del_work(struct work_struct *wk)
 	struct ieee80211_local *local;
 
 	sdata = container_of(wk, struct ieee80211_sub_if_data,
-			     tdls_peer_del_work.work);
+			     u.mgd.tdls_peer_del_work.work);
 	local = sdata->local;
 
 	mutex_lock(&local->mtx);
-	if (!is_zero_ether_addr(sdata->tdls_peer)) {
-		tdls_dbg(sdata, "TDLS del peer %pM\n", sdata->tdls_peer);
-		sta_info_destroy_addr(sdata, sdata->tdls_peer);
-		eth_zero_addr(sdata->tdls_peer);
+	if (!is_zero_ether_addr(sdata->u.mgd.tdls_peer)) {
+		tdls_dbg(sdata, "TDLS del peer %pM\n", sdata->u.mgd.tdls_peer);
+		sta_info_destroy_addr(sdata, sdata->u.mgd.tdls_peer);
+		eth_zero_addr(sdata->u.mgd.tdls_peer);
 	}
 	mutex_unlock(&local->mtx);
 }
@@ -561,8 +561,8 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	mutex_lock(&local->mtx);
 
 	/* we don't support concurrent TDLS peer setups */
-	if (!is_zero_ether_addr(sdata->tdls_peer) &&
-	    !ether_addr_equal(sdata->tdls_peer, peer)) {
+	if (!is_zero_ether_addr(sdata->u.mgd.tdls_peer) &&
+	    !ether_addr_equal(sdata->u.mgd.tdls_peer, peer)) {
 		ret = -EBUSY;
 		goto exit;
 	}
@@ -593,9 +593,9 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	if (ret < 0)
 		goto exit;
 
-	memcpy(sdata->tdls_peer, peer, ETH_ALEN);
+	memcpy(sdata->u.mgd.tdls_peer, peer, ETH_ALEN);
 	ieee80211_queue_delayed_work(&sdata->local->hw,
-				     &sdata->tdls_peer_del_work,
+				     &sdata->u.mgd.tdls_peer_del_work,
 				     TDLS_PEER_SETUP_TIMEOUT);
 
 exit:
@@ -751,8 +751,8 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		set_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH);
 		rcu_read_unlock();
 
-		WARN_ON_ONCE(is_zero_ether_addr(sdata->tdls_peer) ||
-			     !ether_addr_equal(sdata->tdls_peer, peer));
+		WARN_ON_ONCE(is_zero_ether_addr(sdata->u.mgd.tdls_peer) ||
+			     !ether_addr_equal(sdata->u.mgd.tdls_peer, peer));
 		ret = 0;
 		break;
 	case NL80211_TDLS_DISABLE_LINK:
@@ -766,9 +766,9 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	}
 
-	if (ret == 0 && ether_addr_equal(sdata->tdls_peer, peer)) {
-		cancel_delayed_work(&sdata->tdls_peer_del_work);
-		eth_zero_addr(sdata->tdls_peer);
+	if (ret == 0 && ether_addr_equal(sdata->u.mgd.tdls_peer, peer)) {
+		cancel_delayed_work(&sdata->u.mgd.tdls_peer_del_work);
+		eth_zero_addr(sdata->u.mgd.tdls_peer);
 	}
 
 	mutex_unlock(&local->mtx);
-- 
1.9.1

