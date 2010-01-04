Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52804 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0ADUzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:55:53 -0500
Date: Mon, 4 Jan 2010 21:55:52 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 08/14] mwl8k: honor peer rate set
Message-ID: <20100104205551.GH1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When calling SET_RATE, SET_AID, or when creating a station database
entry for our AP, pass in the AP's rate set instead of just blindly
enabling all legacy rates, so as to end up doing the right thing when
talking to 11b-only APs.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   57 +++++++++++++++++++++++++++++++----------
 1 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b5095c7..ea5e3f7 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -256,10 +256,6 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 	{ .bitrate = 720, .hw_value = 144, },
 };
 
-static const u8 mwl8k_rateids[12] = {
-	2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108,
-};
-
 /* Set or get info from Firmware */
 #define MWL8K_CMD_SET			0x0001
 #define MWL8K_CMD_GET			0x0000
@@ -2076,8 +2072,25 @@ struct mwl8k_cmd_update_set_aid {
 	__u8	supp_rates[14];
 } __attribute__((packed));
 
+static void legacy_rate_mask_to_array(u8 *rates, u32 mask)
+{
+	int i;
+	int j;
+
+	/*
+	 * Clear nonstandard rates 4 and 13.
+	 */
+	mask &= 0x1fef;
+
+	for (i = 0, j = 0; i < 14; i++) {
+		if (mask & (1 << i))
+			rates[j++] = mwl8k_rates[i].hw_value;
+	}
+}
+
 static int
-mwl8k_cmd_set_aid(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
+		  struct ieee80211_vif *vif, u32 legacy_rate_mask)
 {
 	struct mwl8k_cmd_update_set_aid *cmd;
 	u16 prot_mode;
@@ -2090,7 +2103,6 @@ mwl8k_cmd_set_aid(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_AID);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->aid = cpu_to_le16(vif->bss_conf.aid);
-
 	memcpy(cmd->bssid, vif->bss_conf.bssid, ETH_ALEN);
 
 	if (vif->bss_conf.use_cts_prot) {
@@ -2111,7 +2123,7 @@ mwl8k_cmd_set_aid(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 	cmd->protection_mode = cpu_to_le16(prot_mode);
 
-	memcpy(cmd->supp_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
+	legacy_rate_mask_to_array(cmd->supp_rates, legacy_rate_mask);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2132,7 +2144,8 @@ struct mwl8k_cmd_set_rate {
 } __attribute__((packed));
 
 static int
-mwl8k_cmd_set_rate(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+mwl8k_cmd_set_rate(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   u32 legacy_rate_mask)
 {
 	struct mwl8k_cmd_set_rate *cmd;
 	int rc;
@@ -2143,7 +2156,7 @@ mwl8k_cmd_set_rate(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_RATE);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	memcpy(cmd->legacy_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
+	legacy_rate_mask_to_array(cmd->legacy_rates, legacy_rate_mask);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2644,7 +2657,8 @@ struct mwl8k_cmd_update_stadb {
 #define MWL8K_PEER_TYPE_ACCESSPOINT	2
 
 static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif, u8 *addr)
+				      struct ieee80211_vif *vif,
+				      u8 *addr, u32 legacy_rate_mask)
 {
 	struct mwl8k_cmd_update_stadb *cmd;
 	struct peer_capability_info *p;
@@ -2662,7 +2676,7 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p = &cmd->peer_info;
 	p->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
 	p->basic_caps = cpu_to_le16(vif->bss_conf.assoc_capability);
-	memcpy(p->legacy_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
+	legacy_rate_mask_to_array(p->legacy_rates, legacy_rate_mask);
 	p->interop = 1;
 	p->amsdu_enabled = 0;
 
@@ -2956,8 +2970,20 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		return;
 
 	if (vif->bss_conf.assoc) {
+		struct ieee80211_sta *ap;
+		u32 legacy_rate_mask;
+
+		rcu_read_lock();
+		ap = ieee80211_find_sta(vif, vif->bss_conf.bssid);
+		if (ap != NULL)
+			legacy_rate_mask = ap->supp_rates[IEEE80211_BAND_2GHZ];
+		rcu_read_unlock();
+
+		if (ap == NULL)
+			goto out;
+
 		/* Install rates */
-		rc = mwl8k_cmd_set_rate(hw, vif);
+		rc = mwl8k_cmd_set_rate(hw, vif, legacy_rate_mask);
 		if (rc)
 			goto out;
 
@@ -2979,7 +3005,7 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		/* Set AID */
-		rc = mwl8k_cmd_set_aid(hw, vif);
+		rc = mwl8k_cmd_set_aid(hw, vif, legacy_rate_mask);
 		if (rc)
 			goto out;
 
@@ -3141,6 +3167,7 @@ struct mwl8k_sta_notify_item
 	struct ieee80211_vif *vif;
 	enum sta_notify_cmd cmd;
 	u8 addr[ETH_ALEN];
+	u32 legacy_rate_mask;
 };
 
 static void mwl8k_sta_notify_worker(struct work_struct *work)
@@ -3162,7 +3189,8 @@ static void mwl8k_sta_notify_worker(struct work_struct *work)
 		if (s->cmd == STA_NOTIFY_ADD) {
 			int rc;
 
-			rc = mwl8k_cmd_update_stadb_add(hw, s->vif, s->addr);
+			rc = mwl8k_cmd_update_stadb_add(hw, s->vif,
+						s->addr, s->legacy_rate_mask);
 			if (rc >= 0) {
 				struct ieee80211_sta *sta;
 
@@ -3198,6 +3226,7 @@ mwl8k_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		s->vif = vif;
 		s->cmd = cmd;
 		memcpy(s->addr, sta->addr, ETH_ALEN);
+		s->legacy_rate_mask = sta->supp_rates[IEEE80211_BAND_2GHZ];
 
 		spin_lock(&priv->sta_notify_list_lock);
 		list_add_tail(&s->list, &priv->sta_notify_list);
-- 
1.5.6.4
