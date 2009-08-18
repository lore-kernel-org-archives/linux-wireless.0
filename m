Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45762 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbZHRDyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:54:46 -0400
Date: Tue, 18 Aug 2009 05:54:47 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 22/29] mwl8k: get rid of mwl8k_bss_info_changed() workqueue use
Message-ID: <20090818035447.GA18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  102 ++++++++++++++++--------------------------
 1 files changed, 38 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index d03e55b..927f987 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2672,58 +2672,62 @@ out:
 	return rc;
 }
 
-struct mwl8k_bss_info_changed_worker {
-	struct mwl8k_work_struct header;
-	struct ieee80211_vif *vif;
-	struct ieee80211_bss_conf *info;
-	u32 changed;
-};
-
-static int mwl8k_bss_info_changed_wt(struct work_struct *wt)
+static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_bss_conf *info,
+				   u32 changed)
 {
-	struct mwl8k_bss_info_changed_worker *worker =
-		(struct mwl8k_bss_info_changed_worker *)wt;
-	struct ieee80211_hw *hw = worker->header.hw;
-	struct ieee80211_vif *vif = worker->vif;
-	struct ieee80211_bss_conf *info = worker->info;
-	u32 changed;
-	int rc;
-
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
+	int rc;
+
+	if (changed & BSS_CHANGED_BSSID)
+		memcpy(mwl8k_vif->bssid, info->bssid, ETH_ALEN);
+
+	if ((changed & BSS_CHANGED_ASSOC) == 0)
+		return;
 
-	changed = worker->changed;
 	priv->capture_beacon = false;
 
+	rc = mwl8k_fw_lock(hw);
+	if (!rc)
+		return;
+
 	if (info->assoc) {
 		memcpy(&mwl8k_vif->bss_info, info,
 			sizeof(struct ieee80211_bss_conf));
 
 		/* Install rates */
-		if (mwl8k_update_rateset(hw, vif))
-			goto mwl8k_bss_info_changed_exit;
+		rc = mwl8k_update_rateset(hw, vif);
+		if (rc)
+			goto out;
 
 		/* Turn on rate adaptation */
-		if (mwl8k_cmd_use_fixed_rate(hw, MWL8K_USE_AUTO_RATE,
-			MWL8K_UCAST_RATE, NULL))
-			goto mwl8k_bss_info_changed_exit;
+		rc = mwl8k_cmd_use_fixed_rate(hw, MWL8K_USE_AUTO_RATE,
+			MWL8K_UCAST_RATE, NULL);
+		if (rc)
+			goto out;
 
 		/* Set radio preamble */
-		if (mwl8k_set_radio_preamble(hw, info->use_short_preamble))
-			goto mwl8k_bss_info_changed_exit;
+		rc = mwl8k_set_radio_preamble(hw, info->use_short_preamble);
+		if (rc)
+			goto out;
 
 		/* Set slot time */
-		if (mwl8k_cmd_set_slot(hw, info->use_short_slot))
-			goto mwl8k_bss_info_changed_exit;
+		rc = mwl8k_cmd_set_slot(hw, info->use_short_slot);
+		if (rc)
+			goto out;
 
 		/* Update peer rate info */
-		if (mwl8k_cmd_update_sta_db(hw, vif,
-				MWL8K_STA_DB_MODIFY_ENTRY))
-			goto mwl8k_bss_info_changed_exit;
+		rc = mwl8k_cmd_update_sta_db(hw, vif,
+				MWL8K_STA_DB_MODIFY_ENTRY);
+		if (rc)
+			goto out;
 
 		/* Set AID */
-		if (mwl8k_cmd_set_aid(hw, vif))
-			goto mwl8k_bss_info_changed_exit;
+		rc = mwl8k_cmd_set_aid(hw, vif);
+		if (rc)
+			goto out;
 
 		/*
 		 * Finalize the join.  Tell rx handler to process
@@ -2732,44 +2736,14 @@ static int mwl8k_bss_info_changed_wt(struct work_struct *wt)
 		memcpy(priv->capture_bssid, mwl8k_vif->bssid, ETH_ALEN);
 		priv->capture_beacon = true;
 	} else {
-		mwl8k_cmd_update_sta_db(hw, vif, MWL8K_STA_DB_DEL_ENTRY);
+		rc = mwl8k_cmd_update_sta_db(hw, vif, MWL8K_STA_DB_DEL_ENTRY);
 		memset(&mwl8k_vif->bss_info, 0,
 			sizeof(struct ieee80211_bss_conf));
 		memset(mwl8k_vif->bssid, 0, ETH_ALEN);
 	}
 
-mwl8k_bss_info_changed_exit:
-	rc = 0;
-	return rc;
-}
-
-static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   struct ieee80211_bss_conf *info,
-				   u32 changed)
-{
-	struct mwl8k_bss_info_changed_worker *worker;
-	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
-	int rc;
-
-	if (changed & BSS_CHANGED_BSSID)
-		memcpy(mv_vif->bssid, info->bssid, ETH_ALEN);
-
-	if ((changed & BSS_CHANGED_ASSOC) == 0)
-		return;
-
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker == NULL)
-		return;
-
-	worker->header.sleep = 1;
-	worker->vif = vif;
-	worker->info = info;
-	worker->changed = changed;
-	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_bss_info_changed_wt);
-	kfree(worker);
-	if (rc == -ETIMEDOUT)
-		printk(KERN_ERR "%s() timed out\n", __func__);
+out:
+	mwl8k_fw_unlock(hw);
 }
 
 struct mwl8k_configure_filter_worker {
-- 
1.5.6.4
