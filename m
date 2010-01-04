Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52798 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab0ADUzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:55:14 -0500
Date: Mon, 4 Jan 2010 21:55:12 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 05/14] mwl8k: handle station database update for AP's sta entry via ->sta_notify()
Message-ID: <20100104205512.GE1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inserting and removing a hardware station database entry for the AP
when we are in managed mode is currently done in ->bss_info_changed().

To prepare for adding AP mode support, implement the ->sta_notify()
driver method, and let that handle inserting and removing the hardware
station database entry for our AP instead.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   82 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9fb62e9..f43270f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -185,6 +185,10 @@ struct mwl8k_priv {
 	bool sniffer_enabled;
 	bool wmm_enabled;
 
+	struct work_struct sta_notify_worker;
+	spinlock_t sta_notify_list_lock;
+	struct list_head sta_notify_list;
+
 	/* XXX need to convert this to handle multiple interfaces */
 	bool capture_beacon;
 	u8 capture_bssid[ETH_ALEN];
@@ -2641,7 +2645,7 @@ struct mwl8k_cmd_update_stadb {
 } __attribute__((packed));
 
 static int mwl8k_cmd_update_stadb(struct ieee80211_hw *hw,
-		struct ieee80211_vif *vif, __u32 action)
+		struct ieee80211_vif *vif, __u32 action, u8 *addr)
 {
 	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
 	struct mwl8k_cmd_update_stadb *cmd;
@@ -2657,7 +2661,7 @@ static int mwl8k_cmd_update_stadb(struct ieee80211_hw *hw,
 
 	cmd->action = cpu_to_le32(action);
 	peer_info = &cmd->peer_info;
-	memcpy(cmd->peer_addr, mv_vif->bssid, ETH_ALEN);
+	memcpy(cmd->peer_addr, addr, ETH_ALEN);
 
 	switch (action) {
 	case MWL8K_STA_DB_ADD_ENTRY:
@@ -2978,12 +2982,6 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		if (rc)
 			goto out;
 
-		/* Update peer rate info */
-		rc = mwl8k_cmd_update_stadb(hw, vif,
-				MWL8K_STA_DB_MODIFY_ENTRY);
-		if (rc)
-			goto out;
-
 		/* Set AID */
 		rc = mwl8k_cmd_set_aid(hw, vif);
 		if (rc)
@@ -2996,7 +2994,6 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		memcpy(priv->capture_bssid, mwl8k_vif->bssid, ETH_ALEN);
 		priv->capture_beacon = true;
 	} else {
-		rc = mwl8k_cmd_update_stadb(hw, vif, MWL8K_STA_DB_DEL_ENTRY);
 		memset(mwl8k_vif->bssid, 0, ETH_ALEN);
 	}
 
@@ -3144,6 +3141,67 @@ static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return mwl8k_cmd_set_rts_threshold(hw, MWL8K_CMD_SET, value);
 }
 
+struct mwl8k_sta_notify_item
+{
+	struct list_head list;
+	struct ieee80211_vif *vif;
+	enum sta_notify_cmd cmd;
+	u8 addr[ETH_ALEN];
+};
+
+static void mwl8k_sta_notify_worker(struct work_struct *work)
+{
+	struct mwl8k_priv *priv =
+		container_of(work, struct mwl8k_priv, sta_notify_worker);
+
+	spin_lock_bh(&priv->sta_notify_list_lock);
+	while (!list_empty(&priv->sta_notify_list)) {
+		struct mwl8k_sta_notify_item *s;
+		int action;
+
+		s = list_entry(priv->sta_notify_list.next,
+			       struct mwl8k_sta_notify_item, list);
+		list_del(&s->list);
+
+		spin_unlock_bh(&priv->sta_notify_list_lock);
+
+		if (s->cmd == STA_NOTIFY_ADD)
+			action = MWL8K_STA_DB_MODIFY_ENTRY;
+		else
+			action = MWL8K_STA_DB_DEL_ENTRY;
+		mwl8k_cmd_update_stadb(priv->hw, s->vif, action, s->addr);
+
+		kfree(s);
+
+		spin_lock_bh(&priv->sta_notify_list_lock);
+	}
+	spin_unlock_bh(&priv->sta_notify_list_lock);
+}
+
+static void
+mwl8k_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		 enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_sta_notify_item *s;
+
+	if (cmd != STA_NOTIFY_ADD && cmd != STA_NOTIFY_REMOVE)
+		return;
+
+	s = kmalloc(sizeof(*s), GFP_ATOMIC);
+	if (s != NULL) {
+		s->vif = vif;
+		s->cmd = cmd;
+		memcpy(s->addr, sta->addr, ETH_ALEN);
+
+		spin_lock(&priv->sta_notify_list_lock);
+		list_add_tail(&s->list, &priv->sta_notify_list);
+		spin_unlock(&priv->sta_notify_list_lock);
+
+		ieee80211_queue_work(hw, &priv->sta_notify_worker);
+	}
+}
+
 static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
@@ -3203,6 +3261,7 @@ static const struct ieee80211_ops mwl8k_ops = {
 	.prepare_multicast	= mwl8k_prepare_multicast,
 	.configure_filter	= mwl8k_configure_filter,
 	.set_rts_threshold	= mwl8k_set_rts_threshold,
+	.sta_notify		= mwl8k_sta_notify,
 	.conf_tx		= mwl8k_conf_tx,
 	.get_tx_stats		= mwl8k_get_tx_stats,
 	.get_stats		= mwl8k_get_stats,
@@ -3406,6 +3465,11 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->radio_on = 0;
 	priv->radio_short_preamble = 0;
 
+	/* Station database handling */
+	INIT_WORK(&priv->sta_notify_worker, mwl8k_sta_notify_worker);
+	spin_lock_init(&priv->sta_notify_list_lock);
+	INIT_LIST_HEAD(&priv->sta_notify_list);
+
 	/* Finalize join worker */
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
 
-- 
1.5.6.4
