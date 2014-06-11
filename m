Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24923 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaFKKsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:48:53 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 09/28] ath9k: Implement channel context ops
Date: Wed, 11 Jun 2014 16:17:57 +0530
Message-ID: <1402483696-2498-10-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124856_303840_9F95C6E6)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Add channel context operations (add, remove, change, assign and
unassign) to enable support for multiple channels.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   7 +++
 drivers/net/wireless/ath/ath9k/init.c  |   1 +
 drivers/net/wireless/ath/ath9k/main.c  | 104 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/tx99.c  |   2 +-
 4 files changed, 102 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a8ae3e9..eae1830 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -331,6 +331,7 @@ struct ath_chanctx {
 	bool offchannel;
 	bool stopped;
 	bool active;
+	bool assigned;
 };
 
 enum ath_offchannel_state {
@@ -356,6 +357,12 @@ struct ath_offchannel {
 };
 
 void ath9k_fill_chanctx_ops(void);
+static inline struct ath_chanctx *
+ath_chanctx_get(struct ieee80211_chanctx_conf *ctx)
+{
+	struct ath_chanctx **ptr = (void *) ctx->drv_priv;
+	return *ptr;
+}
 void ath_chanctx_init(struct ath_softc *sc);
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 001b7d0..45f198f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -752,6 +752,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			hw->wiphy->max_scan_ssids = 255;
 			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 			hw->wiphy->max_remain_on_channel_duration = 10000;
+			hw->chanctx_data_size = sizeof(void *);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9e10434d..e0cb2af 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -624,7 +624,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+	struct ieee80211_channel *curchan = sc->cur_chan->chandef.chan;
 	struct ath_chanctx *ctx = sc->cur_chan;
 	struct ath9k_channel *init_channel;
 	int r;
@@ -1039,11 +1039,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		ath9k_beacon_assign_slot(sc, vif);
 
 	avp->vif = vif;
-
-	/* XXX - will be removed once chanctx ops are added */
-	avp->chanctx = sc->cur_chan;
-	list_add_tail(&avp->list, &sc->cur_chan->vifs);
-	ath_chanctx_check_active(sc, avp->chanctx);
+	if (!ath9k_use_chanctx)
+		avp->chanctx = sc->cur_chan;
 
 	an->sc = sc;
 	an->sta = NULL;
@@ -1132,7 +1129,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	}
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-	list_del(&avp->list);
 	sc->nvifs--;
 	sc->tx99_vif = NULL;
 
@@ -1144,7 +1140,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_ps_restore(sc);
 
 	ath_tx_node_cleanup(sc, &avp->mcast_node);
-	ath_chanctx_check_active(sc, avp->chanctx);
 
 	mutex_unlock(&sc->mutex);
 }
@@ -1271,7 +1266,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ath_chanctx *ctx = sc->cur_chan;
-	bool reset_channel = false;
 
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
@@ -1287,7 +1281,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			 * The chip needs a reset to properly wake up from
 			 * full sleep
 			 */
-			reset_channel = ah->chip_fullsleep;
+			ath_chanctx_set_channel(sc, ctx, &ctx->chandef);
 		}
 	}
 
@@ -1317,7 +1311,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
+	if (!ath9k_use_chanctx && (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
 		ctx->offchannel = !!(conf->flags & IEEE80211_CONF_OFFCHANNEL);
 		ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef);
 	}
@@ -2433,6 +2427,89 @@ static int ath9k_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	return 0;
 }
 
+static int ath9k_add_chanctx(struct ieee80211_hw *hw,
+			     struct ieee80211_chanctx_conf *conf)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_chanctx *ctx, **ptr;
+	int i;
+
+	mutex_lock(&sc->mutex);
+	for (i = 0; i < ATH9K_NUM_CHANCTX; i++) {
+		if (!sc->chanctx[i].assigned)
+			break;
+	}
+	if (i == ATH9K_NUM_CHANCTX) {
+		mutex_unlock(&sc->mutex);
+		return -ENOSPC;
+	}
+
+	ctx = &sc->chanctx[i];
+	ptr = (void *) conf->drv_priv;
+	*ptr = ctx;
+	ctx->assigned = true;
+	ath_chanctx_set_channel(sc, ctx, &conf->def);
+	mutex_unlock(&sc->mutex);
+
+	return 0;
+}
+
+
+static void ath9k_remove_chanctx(struct ieee80211_hw *hw,
+				 struct ieee80211_chanctx_conf *conf)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_chanctx *ctx = ath_chanctx_get(conf);
+
+	mutex_lock(&sc->mutex);
+	ctx->assigned = false;
+	mutex_unlock(&sc->mutex);
+}
+
+static void ath9k_change_chanctx(struct ieee80211_hw *hw,
+				 struct ieee80211_chanctx_conf *conf,
+				 u32 changed)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_chanctx *ctx = ath_chanctx_get(conf);
+
+	mutex_lock(&sc->mutex);
+	ath_chanctx_set_channel(sc, ctx, &conf->def);
+	mutex_unlock(&sc->mutex);
+}
+
+static int ath9k_assign_vif_chanctx(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_chanctx_conf *conf)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	struct ath_chanctx *ctx = ath_chanctx_get(conf);
+
+	mutex_lock(&sc->mutex);
+	avp->chanctx = ctx;
+	list_add_tail(&avp->list, &ctx->vifs);
+	ath_chanctx_check_active(sc, ctx);
+	mutex_unlock(&sc->mutex);
+
+	return 0;
+}
+
+static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_chanctx_conf *conf)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	struct ath_chanctx *ctx = ath_chanctx_get(conf);
+
+	mutex_lock(&sc->mutex);
+	avp->chanctx = NULL;
+	list_del(&avp->list);
+	ath_chanctx_check_active(sc, ctx);
+	mutex_unlock(&sc->mutex);
+}
+
 void ath9k_fill_chanctx_ops(void)
 {
 	if (!ath9k_use_chanctx)
@@ -2442,6 +2519,11 @@ void ath9k_fill_chanctx_ops(void)
 	ath9k_ops.cancel_hw_scan = ath9k_cancel_hw_scan;
 	ath9k_ops.remain_on_channel  = ath9k_remain_on_channel;
 	ath9k_ops.cancel_remain_on_channel = ath9k_cancel_remain_on_channel;
+	ath9k_ops.add_chanctx        = ath9k_add_chanctx;
+	ath9k_ops.remove_chanctx     = ath9k_remove_chanctx;
+	ath9k_ops.change_chanctx     = ath9k_change_chanctx;
+	ath9k_ops.assign_vif_chanctx = ath9k_assign_vif_chanctx;
+	ath9k_ops.unassign_vif_chanctx = ath9k_unassign_vif_chanctx;
 }
 
 struct ieee80211_ops ath9k_ops = {
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index a65cfb9..2397292 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -76,7 +76,7 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	tx_info = IEEE80211_SKB_CB(skb);
 	memset(tx_info, 0, sizeof(*tx_info));
 	rate = &tx_info->control.rates[0];
-	tx_info->band = hw->conf.chandef.chan->band;
+	tx_info->band = sc->cur_chan->chandef.chan->band;
 	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
 	tx_info->control.vif = sc->tx99_vif;
 	rate->count = 1;
-- 
2.0.0

