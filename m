Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45426 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZK3RdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:33:04 -0500
Date: Mon, 30 Nov 2009 18:33:09 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] mwl8k: remove duplicate local per-vif copy of ieee80211_bss_conf
Message-ID: <20091130173309.GA20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   38 ++++++++++++++++----------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index c53968b..047cde6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -205,12 +205,11 @@ struct mwl8k_priv {
 
 /* Per interface specific private data */
 struct mwl8k_vif {
-	/* BSS config of AP or IBSS from mac80211*/
-	struct ieee80211_bss_conf bss_info;
+	/* Local MAC address.  */
+	u8 mac_addr[ETH_ALEN];
 
-	/* BSSID of AP or IBSS */
-	u8	bssid[ETH_ALEN];
-	u8	mac_addr[ETH_ALEN];
+	/* BSSID of AP.  */
+	u8 bssid[ETH_ALEN];
 
 	/* Index into station database. Returned by UPDATE_STADB.  */
 	u8	peer_id;
@@ -2124,7 +2123,6 @@ static int
 mwl8k_cmd_set_aid(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
-	struct ieee80211_bss_conf *info = &mv_vif->bss_info;
 	struct mwl8k_cmd_update_set_aid *cmd;
 	u16 prot_mode;
 	int rc;
@@ -2135,14 +2133,14 @@ mwl8k_cmd_set_aid(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_AID);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->aid = cpu_to_le16(info->aid);
+	cmd->aid = cpu_to_le16(vif->bss_conf.aid);
 
 	memcpy(cmd->bssid, mv_vif->bssid, ETH_ALEN);
 
-	if (info->use_cts_prot) {
+	if (vif->bss_conf.use_cts_prot) {
 		prot_mode = MWL8K_FRAME_PROT_11G;
 	} else {
-		switch (info->ht_operation_mode &
+		switch (vif->bss_conf.ht_operation_mode &
 			IEEE80211_HT_OP_MODE_PROTECTION) {
 		case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
 			prot_mode = MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY;
@@ -2652,7 +2650,6 @@ static int mwl8k_cmd_update_stadb(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif, __u32 action)
 {
 	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
-	struct ieee80211_bss_conf *info = &mv_vif->bss_info;
 	struct mwl8k_cmd_update_stadb *cmd;
 	struct peer_capability_info *peer_info;
 	int rc;
@@ -2673,7 +2670,8 @@ static int mwl8k_cmd_update_stadb(struct ieee80211_hw *hw,
 	case MWL8K_STA_DB_MODIFY_ENTRY:
 		/* Build peer_info block */
 		peer_info->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
-		peer_info->basic_caps = cpu_to_le16(info->assoc_capability);
+		peer_info->basic_caps =
+			cpu_to_le16(vif->bss_conf.assoc_capability);
 		memcpy(peer_info->legacy_rates, mwl8k_rateids,
 		       sizeof(mwl8k_rateids));
 		peer_info->interop = 1;
@@ -2961,11 +2959,8 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 	if (rc)
 		return;
 
-	if (info->assoc) {
-		memcpy(&mwl8k_vif->bss_info, info,
-			sizeof(struct ieee80211_bss_conf));
-
-		memcpy(mwl8k_vif->bssid, info->bssid, ETH_ALEN);
+	if (vif->bss_conf.assoc) {
+		memcpy(mwl8k_vif->bssid, vif->bss_conf.bssid, ETH_ALEN);
 
 		/* Install rates */
 		rc = mwl8k_cmd_set_rate(hw, vif);
@@ -2979,12 +2974,13 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		/* Set radio preamble */
-		rc = mwl8k_set_radio_preamble(hw, info->use_short_preamble);
+		rc = mwl8k_set_radio_preamble(hw,
+				vif->bss_conf.use_short_preamble);
 		if (rc)
 			goto out;
 
 		/* Set slot time */
-		rc = mwl8k_cmd_set_slot(hw, info->use_short_slot);
+		rc = mwl8k_cmd_set_slot(hw, vif->bss_conf.use_short_slot);
 		if (rc)
 			goto out;
 
@@ -3007,8 +3003,6 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		priv->capture_beacon = true;
 	} else {
 		rc = mwl8k_cmd_update_stadb(hw, vif, MWL8K_STA_DB_DEL_ENTRY);
-		memset(&mwl8k_vif->bss_info, 0,
-			sizeof(struct ieee80211_bss_conf));
 		memset(mwl8k_vif->bssid, 0, ETH_ALEN);
 	}
 
@@ -3240,9 +3234,9 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 	struct mwl8k_priv *priv =
 		container_of(work, struct mwl8k_priv, finalize_join_worker);
 	struct sk_buff *skb = priv->beacon_skb;
-	u8 dtim = MWL8K_VIF(priv->vif)->bss_info.dtim_period;
 
-	mwl8k_cmd_finalize_join(priv->hw, skb->data, skb->len, dtim);
+	mwl8k_cmd_finalize_join(priv->hw, skb->data, skb->len,
+				priv->vif->bss_conf.dtim_period);
 	dev_kfree_skb(skb);
 
 	priv->beacon_skb = NULL;
-- 
1.5.6.4
