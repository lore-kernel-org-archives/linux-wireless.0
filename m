Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:53798 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0ADU6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:58:00 -0500
Date: Mon, 4 Jan 2010 21:57:59 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 12/14] mwl8k: pass in HT capabilities and rates when associating
Message-ID: <20100104205758.GL1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass the AP's MCS rate mask to SET_RATE when associating, and make
UPDATE_STADB pass in the peer's HT caps and rates when adding a new
hardware station database entry.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cea131d..85e0d2d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2153,7 +2153,7 @@ struct mwl8k_cmd_set_rate {
 
 static int
 mwl8k_cmd_set_rate(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   u32 legacy_rate_mask)
+		   u32 legacy_rate_mask, u8 *mcs_rates)
 {
 	struct mwl8k_cmd_set_rate *cmd;
 	int rc;
@@ -2165,6 +2165,7 @@ mwl8k_cmd_set_rate(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_RATE);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	legacy_rate_mask_to_array(cmd->legacy_rates, legacy_rate_mask);
+	memcpy(cmd->mcs_set, mcs_rates, 16);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2666,7 +2667,7 @@ struct mwl8k_cmd_update_stadb {
 
 static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
-				      u8 *addr, u32 legacy_rate_mask)
+				      struct ieee80211_sta *sta)
 {
 	struct mwl8k_cmd_update_stadb *cmd;
 	struct peer_capability_info *p;
@@ -2679,12 +2680,18 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_UPDATE_STADB);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le32(MWL8K_STA_DB_MODIFY_ENTRY);
-	memcpy(cmd->peer_addr, addr, ETH_ALEN);
+	memcpy(cmd->peer_addr, sta->addr, ETH_ALEN);
 
 	p = &cmd->peer_info;
 	p->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
 	p->basic_caps = cpu_to_le16(vif->bss_conf.assoc_capability);
-	legacy_rate_mask_to_array(p->legacy_rates, legacy_rate_mask);
+	p->ht_support = sta->ht_cap.ht_supported;
+	p->ht_caps = sta->ht_cap.cap;
+	p->extended_ht_caps = (sta->ht_cap.ampdu_factor & 3) |
+		((sta->ht_cap.ampdu_density & 7) << 2);
+	legacy_rate_mask_to_array(p->legacy_rates,
+				  sta->supp_rates[IEEE80211_BAND_2GHZ]);
+	memcpy(p->ht_rates, sta->ht_cap.mcs.rx_mask, 16);
 	p->interop = 1;
 	p->amsdu_enabled = 0;
 
@@ -2967,6 +2974,7 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct mwl8k_priv *priv = hw->priv;
 	u32 ap_legacy_rates;
+	u8 ap_mcs_rates[16];
 	int rc;
 
 	if (mwl8k_fw_lock(hw))
@@ -2979,12 +2987,11 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		priv->capture_beacon = false;
 
 	/*
-	 * Get the AP's legacy rates.
+	 * Get the AP's legacy and MCS rates.
 	 */
 	ap_legacy_rates = 0;
 	if (vif->bss_conf.assoc) {
 		struct ieee80211_sta *ap;
-
 		rcu_read_lock();
 
 		ap = ieee80211_find_sta(vif, vif->bss_conf.bssid);
@@ -2994,12 +3001,13 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		}
 
 		ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
+		memcpy(ap_mcs_rates, ap->ht_cap.mcs.rx_mask, 16);
 
 		rcu_read_unlock();
 	}
 
 	if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc) {
-		rc = mwl8k_cmd_set_rate(hw, vif, ap_legacy_rates);
+		rc = mwl8k_cmd_set_rate(hw, vif, ap_legacy_rates, ap_mcs_rates);
 		if (rc)
 			goto out;
 
@@ -3188,8 +3196,7 @@ struct mwl8k_sta_notify_item
 	struct list_head list;
 	struct ieee80211_vif *vif;
 	enum sta_notify_cmd cmd;
-	u8 addr[ETH_ALEN];
-	u32 legacy_rate_mask;
+	struct ieee80211_sta sta;
 };
 
 static void mwl8k_sta_notify_worker(struct work_struct *work)
@@ -3211,19 +3218,18 @@ static void mwl8k_sta_notify_worker(struct work_struct *work)
 		if (s->cmd == STA_NOTIFY_ADD) {
 			int rc;
 
-			rc = mwl8k_cmd_update_stadb_add(hw, s->vif,
-						s->addr, s->legacy_rate_mask);
+			rc = mwl8k_cmd_update_stadb_add(hw, s->vif, &s->sta);
 			if (rc >= 0) {
 				struct ieee80211_sta *sta;
 
 				rcu_read_lock();
-				sta = ieee80211_find_sta(s->vif, s->addr);
+				sta = ieee80211_find_sta(s->vif, s->sta.addr);
 				if (sta != NULL)
 					MWL8K_STA(sta)->peer_id = rc;
 				rcu_read_unlock();
 			}
 		} else {
-			mwl8k_cmd_update_stadb_del(hw, s->vif, s->addr);
+			mwl8k_cmd_update_stadb_del(hw, s->vif, s->sta.addr);
 		}
 
 		kfree(s);
@@ -3247,8 +3253,7 @@ mwl8k_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (s != NULL) {
 		s->vif = vif;
 		s->cmd = cmd;
-		memcpy(s->addr, sta->addr, ETH_ALEN);
-		s->legacy_rate_mask = sta->supp_rates[IEEE80211_BAND_2GHZ];
+		s->sta = *sta;
 
 		spin_lock(&priv->sta_notify_list_lock);
 		list_add_tail(&s->list, &priv->sta_notify_list);
-- 
1.5.6.4
