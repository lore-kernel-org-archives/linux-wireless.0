Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35390 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaHVPKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 11:10:01 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 8/8] ath9k: Isolate ath9k_use_chanctx module parameter
Date: Fri, 22 Aug 2014 20:39:31 +0530
Message-Id: <1408720171-9765-9-git-send-email-sujith@msujith.org> (sfid-20140822_171007_600452_C0AF7555)
In-Reply-To: <1408720171-9765-1-git-send-email-sujith@msujith.org>
References: <1408720171-9765-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch ensures that the module parameter "use_chanctx" is
visible only when CONFIG_ATH9K_CHANNEL_CONTEXT is selected.
Also register the channel context callbacks with mac80211 only
when it is explicitly enabled and compile them out of the driver
when CONFIG_ATH9K_CHANNEL_CONTEXT is not selected.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 10 ++++-
 drivers/net/wireless/ath/ath9k/channel.c |  5 +++
 drivers/net/wireless/ath/ath9k/init.c    | 63 +++++++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/main.c    | 14 ++++---
 drivers/net/wireless/ath/ath9k/recv.c    |  2 +-
 5 files changed, 62 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 642cc19..035f6f9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -408,7 +408,6 @@ struct ath_offchannel {
 	     ctx <= &sc->chanctx[ARRAY_SIZE(sc->chanctx) - 1];      \
 	     ctx++)
 
-void ath9k_fill_chanctx_ops(void);
 void ath9k_chanctx_force_active(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif);
 static inline struct ath_chanctx *
@@ -437,6 +436,8 @@ void ath_scan_complete(struct ath_softc *sc, bool abort);
 void ath_roc_complete(struct ath_softc *sc, bool abort);
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+bool ath9k_is_chanctx_enabled(void);
+void ath9k_fill_chanctx_ops(void);
 int ath9k_init_p2p(struct ath_softc *sc);
 void ath9k_deinit_p2p(struct ath_softc *sc);
 void ath9k_p2p_remove_vif(struct ath_softc *sc,
@@ -446,6 +447,13 @@ void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 				struct ieee80211_vif *vif);
 void ath9k_p2p_ps_timer(void *priv);
 #else
+static inline bool ath9k_is_chanctx_enabled(void)
+{
+	return false;
+}
+static inline void ath9k_fill_chanctx_ops(void)
+{
+}
 static inline int ath9k_init_p2p(struct ath_softc *sc)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index c54a3df..36d73c0 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -949,6 +949,11 @@ void ath_offchannel_timer(unsigned long data)
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 
+bool ath9k_is_chanctx_enabled(void)
+{
+	return (ath9k_use_chanctx == 1);
+}
+
 /*****************/
 /* P2P Powersave */
 /*****************/
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 5c48be9..cfd475b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -61,10 +61,14 @@ static int ath9k_ps_enable;
 module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
 MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
 int ath9k_use_chanctx;
 module_param_named(use_chanctx, ath9k_use_chanctx, int, 0444);
 MODULE_PARM_DESC(use_chanctx, "Enable channel context for concurrency");
 
+#endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
+
 bool is_ath9k_unloaded;
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -511,7 +515,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	sc->tx99_power = MAX_RATE_POWER + 1;
 	init_waitqueue_head(&sc->tx_wait);
 	sc->cur_chan = &sc->chanctx[0];
-	if (!ath9k_use_chanctx)
+	if (!ath9k_is_chanctx_enabled())
 		sc->cur_chan->hw_queue_base = 0;
 
 	if (!pdata || pdata->use_eeprom) {
@@ -673,20 +677,14 @@ static const struct ieee80211_iface_limit wds_limits[] = {
 	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_WDS) },
 };
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
 static const struct ieee80211_iface_limit if_limits_multi[] = {
 	{ .max = 1,	.types = BIT(NL80211_IFTYPE_STATION) },
 	{ .max = 1,	.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) },
 };
 
-static const struct ieee80211_iface_limit if_dfs_limits[] = {
-	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) |
-#ifdef CONFIG_MAC80211_MESH
-				 BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-				 BIT(NL80211_IFTYPE_ADHOC) },
-};
-
 static const struct ieee80211_iface_combination if_comb_multi[] = {
 	{
 		.limits = if_limits_multi,
@@ -697,6 +695,16 @@ static const struct ieee80211_iface_combination if_comb_multi[] = {
 	},
 };
 
+#endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
+
+static const struct ieee80211_iface_limit if_dfs_limits[] = {
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+				 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+				 BIT(NL80211_IFTYPE_ADHOC) },
+};
+
 static const struct ieee80211_iface_combination if_comb[] = {
 	{
 		.limits = if_limits,
@@ -764,26 +772,31 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_AP) |
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_ADHOC) |
-			BIT(NL80211_IFTYPE_MESH_POINT);
-		if (!ath9k_use_chanctx) {
+			BIT(NL80211_IFTYPE_MESH_POINT) |
+			BIT(NL80211_IFTYPE_WDS);
+
 			hw->wiphy->iface_combinations = if_comb;
 			hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
-			hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_WDS);
-		} else {
-			hw->wiphy->iface_combinations = if_comb_multi;
-			hw->wiphy->n_iface_combinations =
-				ARRAY_SIZE(if_comb_multi);
-			hw->wiphy->max_scan_ssids = 255;
-			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
-			hw->wiphy->max_remain_on_channel_duration = 10000;
-			hw->chanctx_data_size = sizeof(void *);
-			hw->extra_beacon_tailroom =
-				sizeof(struct ieee80211_p2p_noa_attr) + 9;
-
-			ath_dbg(common, CHAN_CTX, "Use channel contexts\n");
-		}
 	}
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
+	if (ath9k_is_chanctx_enabled()) {
+		hw->wiphy->interface_modes &= ~ BIT(NL80211_IFTYPE_WDS);
+		hw->wiphy->iface_combinations = if_comb_multi;
+		hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb_multi);
+		hw->wiphy->max_scan_ssids = 255;
+		hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+		hw->wiphy->max_remain_on_channel_duration = 10000;
+		hw->chanctx_data_size = sizeof(void *);
+		hw->extra_beacon_tailroom =
+			sizeof(struct ieee80211_p2p_noa_attr) + 9;
+
+		ath_dbg(common, CHAN_CTX, "Use channel contexts\n");
+	}
+
+#endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
+
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 32e80fc..ed281ac 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -268,7 +268,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 
-	if (!ath9k_use_chanctx)
+	if (!ath9k_is_chanctx_enabled())
 		ieee80211_wake_queues(sc->hw);
 	else {
 		if (sc->cur_chan == &sc->offchannel.chan)
@@ -1139,7 +1139,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		ath9k_beacon_assign_slot(sc, vif);
 
 	avp->vif = vif;
-	if (!ath9k_use_chanctx) {
+	if (!ath9k_is_chanctx_enabled()) {
 		avp->chanctx = sc->cur_chan;
 		list_add_tail(&avp->list, &avp->chanctx->vifs);
 	}
@@ -1217,7 +1217,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	sc->nvifs--;
 	sc->tx99_vif = NULL;
-	if (!ath9k_use_chanctx)
+	if (!ath9k_is_chanctx_enabled())
 		list_del(&avp->list);
 
 	if (ath9k_uses_beacons(vif->type))
@@ -1395,7 +1395,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (!ath9k_use_chanctx && (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
+	if (!ath9k_is_chanctx_enabled() && (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
 		ctx->offchannel = !!(conf->flags & IEEE80211_CONF_OFFCHANNEL);
 		ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef);
 	}
@@ -2108,6 +2108,8 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 }
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
 static int ath9k_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_scan_request *hw_req)
 {
@@ -2339,7 +2341,7 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
 
 void ath9k_fill_chanctx_ops(void)
 {
-	if (!ath9k_use_chanctx)
+	if (!ath9k_is_chanctx_enabled())
 		return;
 
 	ath9k_ops.hw_scan                  = ath9k_hw_scan;
@@ -2354,6 +2356,8 @@ void ath9k_fill_chanctx_ops(void)
 	ath9k_ops.mgd_prepare_tx           = ath9k_chanctx_force_active;
 }
 
+#endif
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index e6669fd..ae0d1e9 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -425,7 +425,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (AR_SREV_9550(sc->sc_ah) || AR_SREV_9531(sc->sc_ah))
 		rfilt |= ATH9K_RX_FILTER_4ADDRESS;
 
-	if (ath9k_use_chanctx &&
+	if (ath9k_is_chanctx_enabled() &&
 	    test_bit(ATH_OP_SCANNING, &common->op_flags))
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
-- 
2.0.4

