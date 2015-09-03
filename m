Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34282 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbICIo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 04:44:29 -0400
Received: by laeb10 with SMTP id b10so24075541lae.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2015 01:44:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: split switch_vif_chanctx guts
Date: Thu,  3 Sep 2015 10:44:51 +0200
Message-Id: <1441269892-438-1-git-send-email-michal.kazior@tieto.com> (sfid-20150903_104434_291307_EF304D4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is necessary to make vdev restarting logic
reusable later.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 168 ++++++++++++++++++----------------
 1 file changed, 89 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 64674c955d44..13e9d5659e96 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6218,6 +6218,94 @@ ath10k_mac_update_rx_channel(struct ath10k *ar,
 	rcu_read_unlock();
 }
 
+static void
+ath10k_mac_update_vif_chan(struct ath10k *ar,
+			   struct ieee80211_vif_chanctx_switch *vifs,
+			   int n_vifs)
+{
+	struct ath10k_vif *arvif;
+	int ret;
+	int i;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	/* First stop monitor interface. Some FW versions crash if there's a
+	 * lone monitor interface.
+	 */
+	if (ar->monitor_started)
+		ath10k_monitor_stop(ar);
+
+	for (i = 0; i < n_vifs; i++) {
+		arvif = ath10k_vif_to_arvif(vifs[i].vif);
+
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac chanctx switch vdev_id %i freq %hu->%hu width %d->%d\n",
+			   arvif->vdev_id,
+			   vifs[i].old_ctx->def.chan->center_freq,
+			   vifs[i].new_ctx->def.chan->center_freq,
+			   vifs[i].old_ctx->def.width,
+			   vifs[i].new_ctx->def.width);
+
+		if (WARN_ON(!arvif->is_started))
+			continue;
+
+		if (WARN_ON(!arvif->is_up))
+			continue;
+
+		ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
+		if (ret) {
+			ath10k_warn(ar, "failed to down vdev %d: %d\n",
+				    arvif->vdev_id, ret);
+			continue;
+		}
+	}
+
+	/* All relevant vdevs are downed and associated channel resources
+	 * should be available for the channel switch now.
+	 */
+
+	spin_lock_bh(&ar->data_lock);
+	ath10k_mac_update_rx_channel(ar, NULL, vifs, n_vifs);
+	spin_unlock_bh(&ar->data_lock);
+
+	for (i = 0; i < n_vifs; i++) {
+		arvif = ath10k_vif_to_arvif(vifs[i].vif);
+
+		if (WARN_ON(!arvif->is_started))
+			continue;
+
+		if (WARN_ON(!arvif->is_up))
+			continue;
+
+		ret = ath10k_mac_setup_bcn_tmpl(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to update bcn tmpl during csa: %d\n",
+				    ret);
+
+		ret = ath10k_mac_setup_prb_tmpl(arvif);
+		if (ret)
+			ath10k_warn(ar, "failed to update prb tmpl during csa: %d\n",
+				    ret);
+
+		ret = ath10k_vdev_restart(arvif, &vifs[i].new_ctx->def);
+		if (ret) {
+			ath10k_warn(ar, "failed to restart vdev %d: %d\n",
+				    arvif->vdev_id, ret);
+			continue;
+		}
+
+		ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
+					 arvif->bssid);
+		if (ret) {
+			ath10k_warn(ar, "failed to bring vdev up %d: %d\n",
+				    arvif->vdev_id, ret);
+			continue;
+		}
+	}
+
+	ath10k_monitor_recalc(ar);
+}
+
 static int
 ath10k_mac_op_add_chanctx(struct ieee80211_hw *hw,
 			  struct ieee80211_chanctx_conf *ctx)
@@ -6402,91 +6490,13 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 				 enum ieee80211_chanctx_switch_mode mode)
 {
 	struct ath10k *ar = hw->priv;
-	struct ath10k_vif *arvif;
-	int ret;
-	int i;
 
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac chanctx switch n_vifs %d mode %d\n",
 		   n_vifs, mode);
-
-	/* First stop monitor interface. Some FW versions crash if there's a
-	 * lone monitor interface.
-	 */
-	if (ar->monitor_started)
-		ath10k_monitor_stop(ar);
-
-	for (i = 0; i < n_vifs; i++) {
-		arvif = ath10k_vif_to_arvif(vifs[i].vif);
-
-		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac chanctx switch vdev_id %i freq %hu->%hu width %d->%d\n",
-			   arvif->vdev_id,
-			   vifs[i].old_ctx->def.chan->center_freq,
-			   vifs[i].new_ctx->def.chan->center_freq,
-			   vifs[i].old_ctx->def.width,
-			   vifs[i].new_ctx->def.width);
-
-		if (WARN_ON(!arvif->is_started))
-			continue;
-
-		if (WARN_ON(!arvif->is_up))
-			continue;
-
-		ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
-		if (ret) {
-			ath10k_warn(ar, "failed to down vdev %d: %d\n",
-				    arvif->vdev_id, ret);
-			continue;
-		}
-	}
-
-	/* All relevant vdevs are downed and associated channel resources
-	 * should be available for the channel switch now.
-	 */
-
-	spin_lock_bh(&ar->data_lock);
-	ath10k_mac_update_rx_channel(ar, NULL, vifs, n_vifs);
-	spin_unlock_bh(&ar->data_lock);
-
-	for (i = 0; i < n_vifs; i++) {
-		arvif = ath10k_vif_to_arvif(vifs[i].vif);
-
-		if (WARN_ON(!arvif->is_started))
-			continue;
-
-		if (WARN_ON(!arvif->is_up))
-			continue;
-
-		ret = ath10k_mac_setup_bcn_tmpl(arvif);
-		if (ret)
-			ath10k_warn(ar, "failed to update bcn tmpl during csa: %d\n",
-				    ret);
-
-		ret = ath10k_mac_setup_prb_tmpl(arvif);
-		if (ret)
-			ath10k_warn(ar, "failed to update prb tmpl during csa: %d\n",
-				    ret);
-
-		ret = ath10k_vdev_restart(arvif, &vifs[i].new_ctx->def);
-		if (ret) {
-			ath10k_warn(ar, "failed to restart vdev %d: %d\n",
-				    arvif->vdev_id, ret);
-			continue;
-		}
-
-		ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
-					 arvif->bssid);
-		if (ret) {
-			ath10k_warn(ar, "failed to bring vdev up %d: %d\n",
-				    arvif->vdev_id, ret);
-			continue;
-		}
-	}
-
-	ath10k_monitor_recalc(ar);
+	ath10k_mac_update_vif_chan(ar, vifs, n_vifs);
 
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
-- 
2.1.4

