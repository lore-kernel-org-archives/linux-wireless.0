Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38798 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbbFCKRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 06:17:17 -0400
Received: by wibdt2 with SMTP id dt2so6720349wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 03:17:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: remove ath10k_chanctx struct
Date: Wed,  3 Jun 2015 12:16:55 +0200
Message-Id: <1433326616-23279-2-git-send-email-michal.kazior@tieto.com> (sfid-20150603_121721_624083_A75D6252)
In-Reply-To: <1433326616-23279-1-git-send-email-michal.kazior@tieto.com>
References: <1433326616-23279-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In practice there's no point in having a copy of
chanctx_conf.

Most of the time the channel pointer (and band
along with it) is accessed and this can't change
after a chanctx is created because switching is
done using explicit chanctx swapping via
switch_vif_chanctx().

The only thing that can change within a
chanctx_conf and is used by the driver is
radar_enabled and channel width. These are however
always accessed in adequate mac80211 callback
context which guarantees safe access to the
chanctx data.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  9 ------
 drivers/net/wireless/ath/ath10k/mac.c  | 53 ++++------------------------------
 2 files changed, 6 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 45f9603a0868..78094f23c9dd 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -284,15 +284,6 @@ struct ath10k_sta {
 #endif
 };
 
-struct ath10k_chanctx {
-	/* Used to story copy of chanctx_conf to avoid inconsistencies. Ideally
-	 * mac80211 should allow some sort of explicit locking to guarantee
-	 * that the publicly available chanctx_conf can be accessed safely at
-	 * all times.
-	 */
-	struct ieee80211_chanctx_conf conf;
-};
-
 #define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5*HZ)
 
 enum ath10k_beacon_state {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fe53b1f5e6c9..b60369f78940 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6188,25 +6188,11 @@ ath10k_mac_update_rx_channel(struct ath10k *ar,
 	rcu_read_unlock();
 }
 
-static void
-ath10k_mac_chan_ctx_init(struct ath10k *ar,
-			 struct ath10k_chanctx *arctx,
-			 struct ieee80211_chanctx_conf *conf)
-{
-	lockdep_assert_held(&ar->conf_mutex);
-	lockdep_assert_held(&ar->data_lock);
-
-	memset(arctx, 0, sizeof(*arctx));
-
-	arctx->conf = *conf;
-}
-
 static int
 ath10k_mac_op_add_chanctx(struct ieee80211_hw *hw,
 			  struct ieee80211_chanctx_conf *ctx)
 {
 	struct ath10k *ar = hw->priv;
-	struct ath10k_chanctx *arctx = (void *)ctx->drv_priv;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac chanctx add freq %hu width %d ptr %p\n",
@@ -6215,7 +6201,6 @@ ath10k_mac_op_add_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	spin_lock_bh(&ar->data_lock);
-	ath10k_mac_chan_ctx_init(ar, arctx, ctx);
 	ath10k_mac_update_rx_channel(ar, ctx, NULL, 0);
 	spin_unlock_bh(&ar->data_lock);
 
@@ -6255,16 +6240,12 @@ ath10k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 			     u32 changed)
 {
 	struct ath10k *ar = hw->priv;
-	struct ath10k_chanctx *arctx = (void *)ctx->drv_priv;
 
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx change freq %hu->%hu width %d->%d ptr %p changed %x\n",
-		   arctx->conf.def.chan->center_freq,
-		   ctx->def.chan->center_freq,
-		   arctx->conf.def.width, ctx->def.width,
-		   ctx, changed);
+		   "mac chanctx change freq %hu width %d ptr %p changed %x\n",
+		   ctx->def.chan->center_freq, ctx->def.width, ctx, changed);
 
 	/* This shouldn't really happen because channel switching should use
 	 * switch_vif_chanctx().
@@ -6272,10 +6253,6 @@ ath10k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 	if (WARN_ON(changed & IEEE80211_CHANCTX_CHANGE_CHANNEL))
 		goto unlock;
 
-	spin_lock_bh(&ar->data_lock);
-	arctx->conf = *ctx;
-	spin_unlock_bh(&ar->data_lock);
-
 	ath10k_recalc_radar_detection(ar);
 
 	/* FIXME: How to configure Rx chains properly? */
@@ -6295,7 +6272,6 @@ ath10k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 				 struct ieee80211_chanctx_conf *ctx)
 {
 	struct ath10k *ar = hw->priv;
-	struct ath10k_chanctx *arctx = (void *)ctx->drv_priv;
 	struct ath10k_vif *arvif = (void *)vif->drv_priv;
 	int ret;
 
@@ -6310,11 +6286,11 @@ ath10k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 		return -EBUSY;
 	}
 
-	ret = ath10k_vdev_start(arvif, &arctx->conf.def);
+	ret = ath10k_vdev_start(arvif, &ctx->def);
 	if (ret) {
 		ath10k_warn(ar, "failed to start vdev %i addr %pM on freq %d: %d\n",
 			    arvif->vdev_id, vif->addr,
-			    arctx->conf.def.chan->center_freq, ret);
+			    ctx->def.chan->center_freq, ret);
 		goto err;
 	}
 
@@ -6389,7 +6365,6 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif;
-	struct ath10k_chanctx *arctx_new, *arctx_old;
 	int i;
 
 	mutex_lock(&ar->conf_mutex);
@@ -6401,29 +6376,14 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 	spin_lock_bh(&ar->data_lock);
 	for (i = 0; i < n_vifs; i++) {
 		arvif = ath10k_vif_to_arvif(vifs[i].vif);
-		arctx_new = (void *)vifs[i].new_ctx->drv_priv;
-		arctx_old = (void *)vifs[i].old_ctx->drv_priv;
 
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac chanctx switch vdev_id %i freq %hu->%hu width %d->%d ptr %p->%p\n",
+			   "mac chanctx switch vdev_id %i freq %hu->%hu width %d->%d\n",
 			   arvif->vdev_id,
 			   vifs[i].old_ctx->def.chan->center_freq,
 			   vifs[i].new_ctx->def.chan->center_freq,
 			   vifs[i].old_ctx->def.width,
-			   vifs[i].new_ctx->def.width,
-			   arctx_old, arctx_new);
-
-		if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS) {
-			ath10k_mac_chan_ctx_init(ar, arctx_new,
-						 vifs[i].new_ctx);
-		}
-
-		arctx_new->conf = *vifs[i].new_ctx;
-
-		/* FIXME: ath10k_mac_chan_reconfigure() uses current, i.e. not
-		 * yet updated chanctx_conf pointer.
-		 */
-		arctx_old->conf = *vifs[i].new_ctx;
+			   vifs[i].new_ctx->def.width);
 	}
 	ath10k_mac_update_rx_channel(ar, NULL, vifs, n_vifs);
 	spin_unlock_bh(&ar->data_lock);
@@ -6926,7 +6886,6 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
 	ar->hw->sta_data_size = sizeof(struct ath10k_sta);
-	ar->hw->chanctx_data_size = sizeof(struct ath10k_chanctx);
 
 	ar->hw->max_listen_interval = ATH10K_MAX_HW_LISTEN_INTERVAL;
 
-- 
2.1.4

