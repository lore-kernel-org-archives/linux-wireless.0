Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17988 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaFDNr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:29 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 09/13] ath9k: Implement channel context ops
Date: Wed, 4 Jun 2014 19:16:35 +0530
Message-ID: <1401889599-412-10-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154811_216192_BA43F17C)
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
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
 drivers/net/wireless/ath/ath9k/ath9k.h   |  8 +++
 drivers/net/wireless/ath/ath9k/beacon.c  |  2 +-
 drivers/net/wireless/ath/ath9k/channel.c | 92 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c    |  1 +
 drivers/net/wireless/ath/ath9k/link.c    |  2 +-
 drivers/net/wireless/ath/ath9k/main.c    | 17 ++----
 drivers/net/wireless/ath/ath9k/pci.c     |  8 +--
 drivers/net/wireless/ath/ath9k/tx99.c    |  2 +-
 8 files changed, 110 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7b4a147..3c7ec1c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -331,6 +331,7 @@ struct ath_chanctx {
 	bool offchannel;
 	bool stopped;
 	bool active;
+	bool assigned;
 };
 
 enum ath_offchannel_state {
@@ -364,7 +365,14 @@ int ath9k_remain_on_channel(struct ieee80211_hw *hw,
 			    struct ieee80211_channel *chan, int duration,
 			    enum ieee80211_roc_type type);
 int ath9k_cancel_remain_on_channel(struct ieee80211_hw *hw);
+void ath_chanctx_fill_ops(void);
 
+static inline struct ath_chanctx *
+ath_chanctx_get(struct ieee80211_chanctx_conf *ctx)
+{
+	struct ath_chanctx **ptr = (void *) ctx->drv_priv;
+	return *ptr;
+}
 void ath_chanctx_init(struct ath_softc *sc);
 int ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			      struct cfg80211_chan_def *chandef);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index e387f0b..ed58a9e 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -80,7 +80,7 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	u8 chainmask = ah->txchainmask;
 	u8 rate = 0;
 
-	sband = &common->sbands[common->hw->conf.chandef.chan->band];
+	sband = &common->sbands[sc->cur_chan->chandef.chan->band];
 	rate = sband->bitrates[rateidx].hw_value;
 	if (vif->bss_conf.use_short_preamble)
 		rate |= sband->bitrates[rateidx].hw_value_short;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 02de0ab..099e673 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -295,3 +295,95 @@ void ath_chanctx_offchan_switch(struct ath_softc *sc,
 
 	ath_chanctx_switch(sc, ATH9K_NUM_CHANCTX - 1);
 }
+
+static int ath9k_add_chanctx(struct ieee80211_hw *hw,
+			     struct ieee80211_chanctx_conf *conf)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_chanctx *ctx, **ptr;
+	int i;
+
+	for (i = 0; i < ATH9K_NUM_CHANCTX; i++) {
+		if (!sc->chanctx[i].assigned)
+			break;
+	}
+	if (i == ATH9K_NUM_CHANCTX)
+		return -ENOSPC;
+
+	ctx = &sc->chanctx[i];
+	ptr = (void *) conf->drv_priv;
+	*ptr = ctx;
+	ctx->assigned = true;
+	ath_chanctx_set_channel(sc, ctx, &conf->def);
+
+	return 0;
+}
+
+
+static void ath9k_remove_chanctx(struct ieee80211_hw *hw,
+				 struct ieee80211_chanctx_conf *conf)
+{
+	struct ath_chanctx *ctx = ath_chanctx_get(conf);
+
+	ctx->assigned = false;
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
+void ath_chanctx_fill_ops(void)
+{
+	if (!ath9k_use_chanctx)
+		return;
+
+	ath9k_ops.hw_scan = ath9k_hw_scan;
+	ath9k_ops.cancel_hw_scan = ath9k_cancel_hw_scan;
+	ath9k_ops.remain_on_channel = ath9k_remain_on_channel;
+	ath9k_ops.cancel_remain_on_channel = ath9k_cancel_remain_on_channel;
+	ath9k_ops.add_chanctx = ath9k_add_chanctx;
+	ath9k_ops.remove_chanctx = ath9k_remove_chanctx;
+	ath9k_ops.change_chanctx = ath9k_change_chanctx;
+	ath9k_ops.assign_vif_chanctx = ath9k_assign_vif_chanctx;
+	ath9k_ops.unassign_vif_chanctx = ath9k_unassign_vif_chanctx;
+}
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
 
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 6f91974..d8d87f0 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -178,7 +178,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	txctl.txq = sc->tx.txq_map[IEEE80211_AC_BE];
 
 	memset(tx_info, 0, sizeof(*tx_info));
-	tx_info->band = hw->conf.chandef.chan->band;
+	tx_info->band = sc->cur_chan->chandef.chan->band;
 	tx_info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	tx_info->control.rates[0].idx = 0;
 	tx_info->control.rates[0].count = 1;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c79ab6d..7326eca 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -627,7 +627,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+	struct ieee80211_channel *curchan = sc->cur_chan->chandef.chan;
 	struct ath_chanctx *ctx = sc->cur_chan;
 	struct ath9k_channel *init_channel;
 	int r;
@@ -639,7 +639,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
-	memcpy(&ctx->chandef, &hw->conf.chandef, sizeof(ctx->chandef));
 	init_channel = ath9k_cmn_get_channel(hw, ah, &ctx->chandef);
 
 	/* Reset SERDES registers */
@@ -1042,11 +1041,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
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
@@ -1135,7 +1131,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	}
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-	list_del(&avp->list);
 	sc->nvifs--;
 	sc->tx99_vif = NULL;
 
@@ -1147,7 +1142,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_ps_restore(sc);
 
 	ath_tx_node_cleanup(sc, &avp->mcast_node);
-	ath_chanctx_check_active(sc, avp->chanctx);
 
 	mutex_unlock(&sc->mutex);
 }
@@ -1274,7 +1268,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ath_chanctx *ctx = sc->cur_chan;
-	bool reset_channel = false;
 
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
@@ -1290,7 +1283,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			 * The chip needs a reset to properly wake up from
 			 * full sleep
 			 */
-			reset_channel = ah->chip_fullsleep;
+			ath_chanctx_set_channel(sc, ctx, &ctx->chandef);
 		}
 	}
 
@@ -1320,7 +1313,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
+	if (!ath9k_use_chanctx && (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
 		ctx->offchannel = !!(conf->flags & IEEE80211_CONF_OFFCHANNEL);
 		if (ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef) < 0) {
 			ath_err(common, "Unable to set channel\n");
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 48b4a72..1d4393f 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -842,13 +842,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");
 		return -ENODEV;
 	}
-	if (ath9k_use_chanctx) {
-		ath9k_ops.hw_scan = ath9k_hw_scan;
-		ath9k_ops.cancel_hw_scan = ath9k_cancel_hw_scan;
-		ath9k_ops.remain_on_channel = ath9k_remain_on_channel;
-		ath9k_ops.cancel_remain_on_channel =
-			ath9k_cancel_remain_on_channel;
-	}
+	ath_chanctx_fill_ops();
 
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
 	if (!hw) {
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

