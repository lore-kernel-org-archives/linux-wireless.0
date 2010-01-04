Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52802 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0ADUzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:55:44 -0500
Date: Mon, 4 Jan 2010 21:55:42 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 07/14] mwl8k: move ->peer_id from mwl8k_vif to mwl8k_sta
Message-ID: <20100104205542.GG1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For STA firmware, move the per-peer hardware station ID to the
driver-private part of struct ieee80211_sta, where it belongs.

(Since issuing a hardware station database maintenance command sleeps,
we can't hold a reference to the ieee80211_sta * across the command,
and since we won't know the station ID until after the command
completes, we need to re-lookup the sta when the command is done to
write the returned station ID back to its driver-private part.)

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  119 +++++++++++++++++++++++------------------
 1 files changed, 67 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ab12c44..b5095c7 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -211,15 +211,17 @@ struct mwl8k_vif {
 	/* Local MAC address.  */
 	u8 mac_addr[ETH_ALEN];
 
-	/* Index into station database. Returned by UPDATE_STADB.  */
-	u8	peer_id;
-
 	/* Non AMPDU sequence number assigned by driver */
-	u16	seqno;
+	u16 seqno;
 };
-
 #define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
 
+struct mwl8k_sta {
+	/* Index into station database. Returned by UPDATE_STADB.  */
+	u8 peer_id;
+};
+#define MWL8K_STA(_sta) ((struct mwl8k_sta *)&((_sta)->drv_priv))
+
 static const struct ieee80211_channel mwl8k_channels[] = {
 	{ .center_freq = 2412, .hw_value = 1, },
 	{ .center_freq = 2417, .hw_value = 2, },
@@ -1402,7 +1404,10 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	tx->pkt_phys_addr = cpu_to_le32(dma);
 	tx->pkt_len = cpu_to_le16(skb->len);
 	tx->rate_info = 0;
-	tx->peer_id = mwl8k_vif->peer_id;
+	if (!priv->ap_fw && tx_info->control.sta != NULL)
+		tx->peer_id = MWL8K_STA(tx_info->control.sta)->peer_id;
+	else
+		tx->peer_id = 0;
 	wmb();
 	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
 
@@ -2582,14 +2587,6 @@ static int mwl8k_cmd_set_rateadapt_mode(struct ieee80211_hw *hw, __u16 mode)
 /*
  * CMD_UPDATE_STADB.
  */
-#define MWL8K_STA_DB_ADD_ENTRY		0
-#define MWL8K_STA_DB_MODIFY_ENTRY	1
-#define MWL8K_STA_DB_DEL_ENTRY		2
-#define MWL8K_STA_DB_FLUSH		3
-
-/* Peer Entry flags - used to define the type of the peer node */
-#define MWL8K_PEER_TYPE_ACCESSPOINT	2
-
 struct ewc_ht_info {
 	__le16	control1;
 	__le16	control2;
@@ -2640,12 +2637,17 @@ struct mwl8k_cmd_update_stadb {
 	struct peer_capability_info	peer_info;
 } __attribute__((packed));
 
-static int mwl8k_cmd_update_stadb(struct ieee80211_hw *hw,
-		struct ieee80211_vif *vif, __u32 action, u8 *addr)
+#define MWL8K_STA_DB_MODIFY_ENTRY	1
+#define MWL8K_STA_DB_DEL_ENTRY		2
+
+/* Peer Entry flags - used to define the type of the peer node */
+#define MWL8K_PEER_TYPE_ACCESSPOINT	2
+
+static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif, u8 *addr)
 {
-	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
 	struct mwl8k_cmd_update_stadb *cmd;
-	struct peer_capability_info *peer_info;
+	struct peer_capability_info *p;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -2654,37 +2656,38 @@ static int mwl8k_cmd_update_stadb(struct ieee80211_hw *hw,
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_UPDATE_STADB);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le32(MWL8K_STA_DB_MODIFY_ENTRY);
+	memcpy(cmd->peer_addr, addr, ETH_ALEN);
 
-	cmd->action = cpu_to_le32(action);
-	peer_info = &cmd->peer_info;
+	p = &cmd->peer_info;
+	p->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
+	p->basic_caps = cpu_to_le16(vif->bss_conf.assoc_capability);
+	memcpy(p->legacy_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
+	p->interop = 1;
+	p->amsdu_enabled = 0;
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc ? rc : p->station_id;
+}
+
+static int mwl8k_cmd_update_stadb_del(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif, u8 *addr)
+{
+	struct mwl8k_cmd_update_stadb *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_UPDATE_STADB);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le32(MWL8K_STA_DB_DEL_ENTRY);
 	memcpy(cmd->peer_addr, addr, ETH_ALEN);
 
-	switch (action) {
-	case MWL8K_STA_DB_ADD_ENTRY:
-	case MWL8K_STA_DB_MODIFY_ENTRY:
-		/* Build peer_info block */
-		peer_info->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
-		peer_info->basic_caps =
-			cpu_to_le16(vif->bss_conf.assoc_capability);
-		memcpy(peer_info->legacy_rates, mwl8k_rateids,
-		       sizeof(mwl8k_rateids));
-		peer_info->interop = 1;
-		peer_info->amsdu_enabled = 0;
-
-		rc = mwl8k_post_cmd(hw, &cmd->header);
-		if (rc == 0)
-			mv_vif->peer_id = peer_info->station_id;
-
-		break;
-
-	case MWL8K_STA_DB_DEL_ENTRY:
-	case MWL8K_STA_DB_FLUSH:
-	default:
-		rc = mwl8k_post_cmd(hw, &cmd->header);
-		if (rc == 0)
-			mv_vif->peer_id = 0;
-		break;
-	}
+	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
 
 	return rc;
@@ -3144,11 +3147,11 @@ static void mwl8k_sta_notify_worker(struct work_struct *work)
 {
 	struct mwl8k_priv *priv =
 		container_of(work, struct mwl8k_priv, sta_notify_worker);
+	struct ieee80211_hw *hw = priv->hw;
 
 	spin_lock_bh(&priv->sta_notify_list_lock);
 	while (!list_empty(&priv->sta_notify_list)) {
 		struct mwl8k_sta_notify_item *s;
-		int action;
 
 		s = list_entry(priv->sta_notify_list.next,
 			       struct mwl8k_sta_notify_item, list);
@@ -3156,11 +3159,22 @@ static void mwl8k_sta_notify_worker(struct work_struct *work)
 
 		spin_unlock_bh(&priv->sta_notify_list_lock);
 
-		if (s->cmd == STA_NOTIFY_ADD)
-			action = MWL8K_STA_DB_MODIFY_ENTRY;
-		else
-			action = MWL8K_STA_DB_DEL_ENTRY;
-		mwl8k_cmd_update_stadb(priv->hw, s->vif, action, s->addr);
+		if (s->cmd == STA_NOTIFY_ADD) {
+			int rc;
+
+			rc = mwl8k_cmd_update_stadb_add(hw, s->vif, s->addr);
+			if (rc >= 0) {
+				struct ieee80211_sta *sta;
+
+				rcu_read_lock();
+				sta = ieee80211_find_sta(s->vif, s->addr);
+				if (sta != NULL)
+					MWL8K_STA(sta)->peer_id = rc;
+				rcu_read_unlock();
+			}
+		} else {
+			mwl8k_cmd_update_stadb_del(hw, s->vif, s->addr);
+		}
 
 		kfree(s);
 
@@ -3450,6 +3464,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	/* Set rssi and noise values to dBm */
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_NOISE_DBM;
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
+	hw->sta_data_size = sizeof(struct mwl8k_sta);
 	priv->vif = NULL;
 
 	/* Set default radio state and preamble */
-- 
1.5.6.4
