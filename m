Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41986 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab3BGSik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 13:38:40 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv9 1/3] mac80211: lock AP_VLAN list with iflist_mtx
Date: Thu,  7 Feb 2013 19:38:20 +0100
Message-Id: <1360262304-28362-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130207_193853_213351_2CB8362C)
In-Reply-To: <1360262304-28362-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1360262304-28362-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To remove the dependency to rtnl_lock() for
ieee80211_vif_use/release_channel in AP mode, protect the AP_VLAN
list with local->iflist_mtx instead.

RTNL can not be used from within mac80211 workers, but the
DFS AP interface requires to release channels (after DFS channel
availability checks).

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/cfg.c         |   14 ++++++++++++++
 net/mac80211/chan.c        |    4 ++--
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/iface.c       |   11 ++++++++++-
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 661b878..4a99a8f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -923,8 +923,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
+	mutex_lock(&sdata->local->iflist_mtx);
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
+	mutex_unlock(&sdata->local->iflist_mtx);
 	if (err)
 		return err;
 
@@ -934,12 +936,14 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	sdata->control_port_protocol = params->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
+	mutex_lock(&sdata->local->iflist_mtx);
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
 		vlan->control_port_protocol =
 			params->crypto.control_port_ethertype;
 		vlan->control_port_no_encrypt =
 			params->crypto.control_port_no_encrypt;
 	}
+	mutex_unlock(&sdata->local->iflist_mtx);
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = params->dtim_period;
@@ -972,8 +976,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(dev);
+	mutex_lock(&sdata->local->iflist_mtx);
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		netif_carrier_on(vlan->dev);
+	mutex_unlock(&sdata->local->iflist_mtx);
 
 	return 0;
 }
@@ -1012,8 +1018,10 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	old_probe_resp = rtnl_dereference(sdata->u.ap.probe_resp);
 
 	/* turn off carrier for this interface and dependent VLANs */
+	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		netif_carrier_off(vlan->dev);
+	mutex_unlock(&local->iflist_mtx);
 	netif_carrier_off(dev);
 
 	/* remove beacon and probe response */
@@ -1023,12 +1031,16 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	if (old_probe_resp)
 		kfree_rcu(old_probe_resp, rcu_head);
 
+	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		sta_info_flush_defer(vlan);
+	mutex_unlock(&local->iflist_mtx);
 	sta_info_flush_defer(sdata);
 	rcu_barrier();
+	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		sta_info_flush_cleanup(vlan);
+	mutex_unlock(&local->iflist_mtx);
 	sta_info_flush_cleanup(sdata);
 
 	sdata->vif.bss_conf.enable_beacon = false;
@@ -1041,7 +1053,9 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
 	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
 
+	mutex_lock(&local->iflist_mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->iflist_mtx);
 
 	return 0;
 }
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 1bfe0a8..cbdc999 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -202,7 +202,7 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 		struct ieee80211_sub_if_data *vlan;
 
 		/* for the VLAN list */
-		ASSERT_RTNL();
+		lockdep_assert_held(&local->iflist_mtx);
 		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 			rcu_assign_pointer(vlan->vif.chanctx_conf, NULL);
 	}
@@ -330,7 +330,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_sub_if_data *vlan;
 
 		/* for the VLAN list */
-		ASSERT_RTNL();
+		lockdep_assert_held(&local->iflist_mtx);
 		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 			rcu_assign_pointer(vlan->vif.chanctx_conf, &ctx->conf);
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5fba867..b619cf7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -294,6 +294,7 @@ struct ieee80211_if_ap {
 	struct beacon_data __rcu *beacon;
 	struct probe_resp __rcu *probe_resp;
 
+	/* protected with local->iflist_mtx */
 	struct list_head vlans;
 
 	struct ps_data ps;
@@ -306,6 +307,7 @@ struct ieee80211_if_wds {
 };
 
 struct ieee80211_if_vlan {
+	/* protected with local->iflist_mtx */
 	struct list_head list;
 
 	/* used for all tx if the VLAN is configured to 4-addr mode */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0a36dc6..dbb7fed 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -517,7 +517,9 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		if (!sdata->bss)
 			return -ENOLINK;
 
+		mutex_lock(&local->iflist_mtx);
 		list_add(&sdata->u.vlan.list, &sdata->bss->vlans);
+		mutex_unlock(&local->iflist_mtx);
 
 		master = container_of(sdata->bss,
 				      struct ieee80211_sub_if_data, u.ap);
@@ -717,8 +719,11 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		drv_stop(local);
  err_del_bss:
 	sdata->bss = NULL;
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		mutex_lock(&sdata->local->iflist_mtx);
 		list_del(&sdata->u.vlan.list);
+		mutex_unlock(&sdata->local->iflist_mtx);
+	}
 	/* might already be clear but that doesn't matter */
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 	return res;
@@ -821,10 +826,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
 
+		mutex_lock(&local->iflist_mtx);
 		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
 					 u.vlan.list)
 			dev_close(vlan->dev);
+		mutex_unlock(&local->iflist_mtx);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
@@ -835,7 +842,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
+		mutex_lock(&sdata->local->iflist_mtx);
 		list_del(&sdata->u.vlan.list);
+		mutex_unlock(&sdata->local->iflist_mtx);
 		rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 		/* no need to tell driver */
 		break;
-- 
1.7.10.4

