Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52800 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0ADUzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:55:23 -0500
Date: Mon, 4 Jan 2010 21:55:21 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 06/14] mwl8k: remove mwl8k_vif::bssid, which is now useless
Message-ID: <20100104205521.GF1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f43270f..ab12c44 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -211,9 +211,6 @@ struct mwl8k_vif {
 	/* Local MAC address.  */
 	u8 mac_addr[ETH_ALEN];
 
-	/* BSSID of AP.  */
-	u8 bssid[ETH_ALEN];
-
 	/* Index into station database. Returned by UPDATE_STADB.  */
 	u8	peer_id;
 
@@ -2001,7 +1998,7 @@ struct mwl8k_cmd_set_post_scan {
 } __attribute__((packed));
 
 static int
-mwl8k_cmd_set_post_scan(struct ieee80211_hw *hw, __u8 *mac)
+mwl8k_cmd_set_post_scan(struct ieee80211_hw *hw, const __u8 *mac)
 {
 	struct mwl8k_cmd_set_post_scan *cmd;
 	int rc;
@@ -2077,7 +2074,6 @@ struct mwl8k_cmd_update_set_aid {
 static int
 mwl8k_cmd_set_aid(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
 	struct mwl8k_cmd_update_set_aid *cmd;
 	u16 prot_mode;
 	int rc;
@@ -2090,7 +2086,7 @@ mwl8k_cmd_set_aid(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->aid = cpu_to_le16(vif->bss_conf.aid);
 
-	memcpy(cmd->bssid, mv_vif->bssid, ETH_ALEN);
+	memcpy(cmd->bssid, vif->bss_conf.bssid, ETH_ALEN);
 
 	if (vif->bss_conf.use_cts_prot) {
 		prot_mode = MWL8K_FRAME_PROT_11G;
@@ -2945,7 +2941,6 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 				   u32 changed)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
 	int rc;
 
 	if ((changed & BSS_CHANGED_ASSOC) == 0)
@@ -2958,8 +2953,6 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		return;
 
 	if (vif->bss_conf.assoc) {
-		memcpy(mwl8k_vif->bssid, vif->bss_conf.bssid, ETH_ALEN);
-
 		/* Install rates */
 		rc = mwl8k_cmd_set_rate(hw, vif);
 		if (rc)
@@ -2991,10 +2984,8 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		 * Finalize the join.  Tell rx handler to process
 		 * next beacon from our BSSID.
 		 */
-		memcpy(priv->capture_bssid, mwl8k_vif->bssid, ETH_ALEN);
+		memcpy(priv->capture_bssid, vif->bss_conf.bssid, ETH_ALEN);
 		priv->capture_beacon = true;
-	} else {
-		memset(mwl8k_vif->bssid, 0, ETH_ALEN);
 	}
 
 out:
@@ -3099,7 +3090,7 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 			 */
 			mwl8k_cmd_set_pre_scan(hw);
 		} else {
-			u8 *bssid;
+			const u8 *bssid;
 
 			/*
 			 * Enable the BSS filter.
@@ -3111,7 +3102,7 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 			 */
 			bssid = "\x01\x00\x00\x00\x00\x00";
 			if (priv->vif != NULL)
-				bssid = MWL8K_VIF(priv->vif)->bssid;
+				bssid = priv->vif->bss_conf.bssid;
 
 			mwl8k_cmd_set_post_scan(hw, bssid);
 		}
-- 
1.5.6.4
