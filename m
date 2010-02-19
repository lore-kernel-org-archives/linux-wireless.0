Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab0BSSSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:18:42 -0500
Subject: [RFC/RFT] mwl8k: convert to new station add/remove callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20100219180737.156138399@sipsolutions.net>
References: <20100219180652.409890561@sipsolutions.net>
	 <20100219180737.156138399@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 19:18:37 +0100
Message-ID: <1266603517.10689.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This converts mwl8k to use the new station
add/remove callbacks instead of using the
old sta_notify callback.

The new callbacks can sleep, so a lot of
code can be removed now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
FWIW, I did the remove/add order in the file
to make the patch easier to read .....

 drivers/net/wireless/mwl8k.c |  106 ++++++++-----------------------------------
 1 file changed, 22 insertions(+), 84 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2010-02-19 19:08:37.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2010-02-19 19:14:47.000000000 +0100
@@ -188,10 +188,6 @@ struct mwl8k_priv {
 	bool sniffer_enabled;
 	bool wmm_enabled;
 
-	struct work_struct sta_notify_worker;
-	spinlock_t sta_notify_list_lock;
-	struct list_head sta_notify_list;
-
 	/* XXX need to convert this to handle multiple interfaces */
 	bool capture_beacon;
 	u8 capture_bssid[ETH_ALEN];
@@ -3706,90 +3702,36 @@ static int mwl8k_set_rts_threshold(struc
 	return mwl8k_cmd_set_rts_threshold(hw, value);
 }
 
-struct mwl8k_sta_notify_item
-{
-	struct list_head list;
-	struct ieee80211_vif *vif;
-	enum sta_notify_cmd cmd;
-	struct ieee80211_sta sta;
-};
-
-static void
-mwl8k_do_sta_notify(struct ieee80211_hw *hw, struct mwl8k_sta_notify_item *s)
+static int mwl8k_sta_remove(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta)
 {
 	struct mwl8k_priv *priv = hw->priv;
 
-	/*
-	 * STA firmware uses UPDATE_STADB, AP firmware uses SET_NEW_STN.
-	 */
-	if (!priv->ap_fw && s->cmd == STA_NOTIFY_ADD) {
-		int rc;
-
-		rc = mwl8k_cmd_update_stadb_add(hw, s->vif, &s->sta);
-		if (rc >= 0) {
-			struct ieee80211_sta *sta;
-
-			rcu_read_lock();
-			sta = ieee80211_find_sta(s->vif, s->sta.addr);
-			if (sta != NULL)
-				MWL8K_STA(sta)->peer_id = rc;
-			rcu_read_unlock();
-		}
-	} else if (!priv->ap_fw && s->cmd == STA_NOTIFY_REMOVE) {
-		mwl8k_cmd_update_stadb_del(hw, s->vif, s->sta.addr);
-	} else if (priv->ap_fw && s->cmd == STA_NOTIFY_ADD) {
-		mwl8k_cmd_set_new_stn_add(hw, s->vif, &s->sta);
-	} else if (priv->ap_fw && s->cmd == STA_NOTIFY_REMOVE) {
-		mwl8k_cmd_set_new_stn_del(hw, s->vif, s->sta.addr);
-	}
-}
-
-static void mwl8k_sta_notify_worker(struct work_struct *work)
-{
-	struct mwl8k_priv *priv =
-		container_of(work, struct mwl8k_priv, sta_notify_worker);
-	struct ieee80211_hw *hw = priv->hw;
-
-	spin_lock_bh(&priv->sta_notify_list_lock);
-	while (!list_empty(&priv->sta_notify_list)) {
-		struct mwl8k_sta_notify_item *s;
-
-		s = list_entry(priv->sta_notify_list.next,
-			       struct mwl8k_sta_notify_item, list);
-		list_del(&s->list);
-
-		spin_unlock_bh(&priv->sta_notify_list_lock);
-
-		mwl8k_do_sta_notify(hw, s);
-		kfree(s);
-
-		spin_lock_bh(&priv->sta_notify_list_lock);
-	}
-	spin_unlock_bh(&priv->sta_notify_list_lock);
+	if (priv->ap_fw)
+		return mwl8k_cmd_set_new_stn_del(hw, vif, sta->addr);
+	else
+		return mwl8k_cmd_update_stadb_del(hw, vif, sta->addr);
 }
 
-static void
-mwl8k_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		 enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
+static int mwl8k_sta_add(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_sta_notify_item *s;
-
-	if (cmd != STA_NOTIFY_ADD && cmd != STA_NOTIFY_REMOVE)
-		return;
+	int ret;
 
-	s = kmalloc(sizeof(*s), GFP_ATOMIC);
-	if (s != NULL) {
-		s->vif = vif;
-		s->cmd = cmd;
-		s->sta = *sta;
-
-		spin_lock_bh(&priv->sta_notify_list_lock);
-		list_add_tail(&s->list, &priv->sta_notify_list);
-		spin_unlock_bh(&priv->sta_notify_list_lock);
+	if (!priv->ap_fw) {
+		ret = mwl8k_cmd_update_stadb_add(hw, vif, sta);
+		if (ret >= 0) {
+			MWL8K_STA(sta)->peer_id = ret;
+			return 0;
+		}
 
-		ieee80211_queue_work(hw, &priv->sta_notify_worker);
+		return ret;
 	}
+
+	return mwl8k_cmd_set_new_stn_add(hw, vif, sta);
 }
 
 static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
@@ -3849,7 +3791,8 @@ static const struct ieee80211_ops mwl8k_
 	.prepare_multicast	= mwl8k_prepare_multicast,
 	.configure_filter	= mwl8k_configure_filter,
 	.set_rts_threshold	= mwl8k_set_rts_threshold,
-	.sta_notify		= mwl8k_sta_notify,
+	.sta_add		= mwl8k_sta_add,
+	.sta_remove		= mwl8k_sta_remove,
 	.conf_tx		= mwl8k_conf_tx,
 	.get_stats		= mwl8k_get_stats,
 	.ampdu_action		= mwl8k_ampdu_action,
@@ -4051,11 +3994,6 @@ static int __devinit mwl8k_probe(struct
 	priv->radio_on = 0;
 	priv->radio_short_preamble = 0;
 
-	/* Station database handling */
-	INIT_WORK(&priv->sta_notify_worker, mwl8k_sta_notify_worker);
-	spin_lock_init(&priv->sta_notify_list_lock);
-	INIT_LIST_HEAD(&priv->sta_notify_list);
-
 	/* Finalize join worker */
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
 


