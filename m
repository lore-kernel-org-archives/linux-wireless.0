Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38817 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbFCKRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 06:17:18 -0400
Received: by wibdt2 with SMTP id dt2so6720817wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 03:17:17 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: fix channel switching
Date: Wed,  3 Jun 2015 12:16:56 +0200
Message-Id: <1433326616-23279-3-git-send-email-michal.kazior@tieto.com> (sfid-20150603_121723_829466_BF0A11F1)
In-Reply-To: <1433326616-23279-1-git-send-email-michal.kazior@tieto.com>
References: <1433326616-23279-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the midst of chanctx patch review channel
switching became broken which I failed to notice
until now.

Function ath10k_mac_vif_chan() reports current
chandef which isn't updated until after
switch_vif_chanctx() is returned from.
Consequently the driver just restarted operation
on channels it was residing already instead of
switching to the new ones.

Fixes: 500ff9f9389d ("ath10k: implement chanctx API")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 142 +++++++++++++++-------------------
 1 file changed, 62 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b60369f78940..e834a9d2fffd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3949,83 +3949,6 @@ static int ath10k_config_ps(struct ath10k *ar)
 	return ret;
 }
 
-static void ath10k_mac_chan_reconfigure(struct ath10k *ar)
-{
-	struct ath10k_vif *arvif;
-	struct cfg80211_chan_def def;
-	int ret;
-
-	lockdep_assert_held(&ar->conf_mutex);
-
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac chan reconfigure\n");
-
-	/* First stop monitor interface. Some FW versions crash if there's a
-	 * lone monitor interface. */
-	if (ar->monitor_started)
-		ath10k_monitor_stop(ar);
-
-	list_for_each_entry(arvif, &ar->arvifs, list) {
-		if (!arvif->is_started)
-			continue;
-
-		if (!arvif->is_up)
-			continue;
-
-		if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
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
-	/* all vdevs are downed now - attempt to restart and re-up them */
-
-	list_for_each_entry(arvif, &ar->arvifs, list) {
-		if (!arvif->is_started)
-			continue;
-
-		if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
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
-		if (WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def)))
-			continue;
-
-		ret = ath10k_vdev_restart(arvif, &def);
-		if (ret) {
-			ath10k_warn(ar, "failed to restart vdev %d: %d\n",
-				    arvif->vdev_id, ret);
-			continue;
-		}
-
-		if (!arvif->is_up)
-			continue;
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
-}
-
 static int ath10k_mac_txpower_setup(struct ath10k *ar, int txpower)
 {
 	int ret;
@@ -6365,6 +6288,7 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif;
+	int ret;
 	int i;
 
 	mutex_lock(&ar->conf_mutex);
@@ -6373,7 +6297,12 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 		   "mac chanctx switch n_vifs %d mode %d\n",
 		   n_vifs, mode);
 
-	spin_lock_bh(&ar->data_lock);
+	/* First stop monitor interface. Some FW versions crash if there's a
+	 * lone monitor interface.
+	 */
+	if (ar->monitor_started)
+		ath10k_monitor_stop(ar);
+
 	for (i = 0; i < n_vifs; i++) {
 		arvif = ath10k_vif_to_arvif(vifs[i].vif);
 
@@ -6384,12 +6313,65 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 			   vifs[i].new_ctx->def.chan->center_freq,
 			   vifs[i].old_ctx->def.width,
 			   vifs[i].new_ctx->def.width);
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
 	}
+
+	/* All relevant vdevs are downed and associated channel resources
+	 * should be available for the channel switch now.
+	 */
+
+	spin_lock_bh(&ar->data_lock);
 	ath10k_mac_update_rx_channel(ar, NULL, vifs, n_vifs);
 	spin_unlock_bh(&ar->data_lock);
 
-	/* FIXME: Reconfigure only affected vifs */
-	ath10k_mac_chan_reconfigure(ar);
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
 
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
-- 
2.1.4

