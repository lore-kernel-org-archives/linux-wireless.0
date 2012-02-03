Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab2BCQdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:33:24 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 21/25] iwlegacy: get rid of ctx structure
Date: Fri,  3 Feb 2012 17:31:57 +0100
Message-Id: <1328286721-11309-22-git-send-email-sgruszka@redhat.com> (sfid-20120203_173330_806890_126D29FD)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   67 +++++------
 drivers/net/wireless/iwlegacy/3945-rs.c  |    3 +-
 drivers/net/wireless/iwlegacy/3945.c     |   23 ++--
 drivers/net/wireless/iwlegacy/3945.h     |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c |  150 +++++++++-------------
 drivers/net/wireless/iwlegacy/4965-rs.c  |   35 ++----
 drivers/net/wireless/iwlegacy/4965.c     |   62 +++++-----
 drivers/net/wireless/iwlegacy/4965.h     |   19 ++--
 drivers/net/wireless/iwlegacy/common.c   |  199 ++++++++++++------------------
 drivers/net/wireless/iwlegacy/common.h   |   79 +++++--------
 10 files changed, 261 insertions(+), 378 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 7c81f5a..b2e04c5 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -341,7 +341,7 @@ il3945_send_beacon_cmd(struct il_priv *il)
 		return -ENOMEM;
 	}
 
-	rate = il_get_lowest_plcp(il, &il->ctx);
+	rate = il_get_lowest_plcp(il);
 
 	frame_size = il3945_hw_get_beacon_cmd(il, frame, rate);
 
@@ -512,7 +512,7 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find idx into station table for destination station */
-	sta_id = il_sta_id_or_broadcast(il, &il->ctx, info->control.sta);
+	sta_id = il_sta_id_or_broadcast(il, info->control.sta);
 	if (sta_id == IL_INVALID_STATION) {
 		D_DROP("Dropping - INVALID STATION: %pM\n", hdr->addr1);
 		goto drop;
@@ -541,7 +541,6 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct il_tx_info));
 	txq->txb[q->write_ptr].skb = skb;
-	txq->txb[q->write_ptr].ctx = &il->ctx;
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
@@ -2208,7 +2207,7 @@ il3945_alive_start(struct il_priv *il)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		il_connection_init_rx_config(il, &il->ctx);
+		il_connection_init_rx_config(il);
 	}
 
 	/* Configure Bluetooth device coexistence support */
@@ -2217,7 +2216,7 @@ il3945_alive_start(struct il_priv *il)
 	set_bit(S_READY, &il->status);
 
 	/* Configure the adapter for unassociated operation */
-	il3945_commit_rxon(il, &il->ctx);
+	il3945_commit_rxon(il);
 
 	il3945_reg_txpower_periodic(il);
 
@@ -2249,7 +2248,7 @@ __il3945_down(struct il_priv *il)
 	del_timer_sync(&il->watchdog);
 
 	/* Station information will now be cleared in device */
-	il_clear_ucode_stations(il, NULL);
+	il_clear_ucode_stations(il);
 	il_dealloc_bcast_stations(il);
 	il_clear_driver_stations(il);
 
@@ -2335,12 +2334,11 @@ il3945_down(struct il_priv *il)
 static int
 il3945_alloc_bcast_station(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->ctx;
 	unsigned long flags;
 	u8 sta_id;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
-	sta_id = il_prep_station(il, ctx, il_bcast_addr, false, NULL);
+	sta_id = il_prep_station(il, il_bcast_addr, false, NULL);
 	if (sta_id == IL_INVALID_STATION) {
 		IL_ERR("Unable to prepare broadcast station\n");
 		spin_unlock_irqrestore(&il->sta_lock, flags);
@@ -2660,14 +2658,12 @@ il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 void
 il3945_post_scan(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->ctx;
-
 	/*
 	 * Since setting the RXON may have been deferred while
 	 * performing the scan, fire one off if needed
 	 */
 	if (memcmp(&il->staging, &il->active, sizeof(il->staging)))
-		il3945_commit_rxon(il, ctx);
+		il3945_commit_rxon(il);
 }
 
 static void
@@ -2680,7 +2676,8 @@ il3945_bg_restart(struct work_struct *data)
 
 	if (test_and_clear_bit(S_FW_ERROR, &il->status)) {
 		mutex_lock(&il->mutex);
-		il->ctx.vif = NULL;
+		/* FIXME: vif can be dereferenced */
+		il->vif = NULL;
 		il->is_open = 0;
 		mutex_unlock(&il->mutex);
 		il3945_down(il);
@@ -2718,12 +2715,11 @@ il3945_post_associate(struct il_priv *il)
 {
 	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
-	struct il_rxon_context *ctx = &il->ctx;
 
-	if (!ctx->vif || !il->is_open)
+	if (!il->vif || !il->is_open)
 		return;
 
-	D_ASSOC("Associated as %d to: %pM\n", ctx->vif->bss_conf.aid,
+	D_ASSOC("Associated as %d to: %pM\n", il->vif->bss_conf.aid,
 		il->active.bssid_addr);
 
 	if (test_bit(S_EXIT_PENDING, &il->status))
@@ -2734,34 +2730,34 @@ il3945_post_associate(struct il_priv *il)
 	conf = &il->hw->conf;
 
 	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	il3945_commit_rxon(il, ctx);
+	il3945_commit_rxon(il);
 
-	rc = il_send_rxon_timing(il, ctx);
+	rc = il_send_rxon_timing(il);
 	if (rc)
 		IL_WARN("C_RXON_TIMING failed - " "Attempting to continue.\n");
 
 	il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	il->staging.assoc_id = cpu_to_le16(ctx->vif->bss_conf.aid);
+	il->staging.assoc_id = cpu_to_le16(il->vif->bss_conf.aid);
 
-	D_ASSOC("assoc id %d beacon interval %d\n", ctx->vif->bss_conf.aid,
-		ctx->vif->bss_conf.beacon_int);
+	D_ASSOC("assoc id %d beacon interval %d\n", il->vif->bss_conf.aid,
+		il->vif->bss_conf.beacon_int);
 
-	if (ctx->vif->bss_conf.use_short_preamble)
+	if (il->vif->bss_conf.use_short_preamble)
 		il->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
 		il->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 	if (il->staging.flags & RXON_FLG_BAND_24G_MSK) {
-		if (ctx->vif->bss_conf.use_short_slot)
+		if (il->vif->bss_conf.use_short_slot)
 			il->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
 			il->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
-	il3945_commit_rxon(il, ctx);
+	il3945_commit_rxon(il);
 
-	switch (ctx->vif->type) {
+	switch (il->vif->type) {
 	case NL80211_IFTYPE_STATION:
 		il3945_rate_scale_init(il->hw, IL_AP_ID);
 		break;
@@ -2770,7 +2766,7 @@ il3945_post_associate(struct il_priv *il)
 		break;
 	default:
 		IL_ERR("%s Should not be called in %d mode\n", __func__,
-		       ctx->vif->type);
+		      il->vif->type);
 		break;
 	}
 }
@@ -2887,8 +2883,7 @@ il3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 void
 il3945_config_ap(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->ctx;
-	struct ieee80211_vif *vif = ctx->vif;
+	struct ieee80211_vif *vif = il->vif;
 	int rc = 0;
 
 	if (test_bit(S_EXIT_PENDING, &il->status))
@@ -2899,10 +2894,10 @@ il3945_config_ap(struct il_priv *il)
 
 		/* RXON - unassoc (to set timing command) */
 		il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		il3945_commit_rxon(il, ctx);
+		il3945_commit_rxon(il);
 
 		/* RXON Timing */
-		rc = il_send_rxon_timing(il, ctx);
+		rc = il_send_rxon_timing(il);
 		if (rc)
 			IL_WARN("C_RXON_TIMING failed - "
 				"Attempting to continue.\n");
@@ -2922,7 +2917,7 @@ il3945_config_ap(struct il_priv *il)
 		}
 		/* restore RXON assoc */
 		il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		il3945_commit_rxon(il, ctx);
+		il3945_commit_rxon(il);
 	}
 	il3945_send_beacon_cmd(il);
 }
@@ -2955,7 +2950,7 @@ il3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	static_key = !il_is_associated(il);
 
 	if (!static_key) {
-		sta_id = il_sta_id_or_broadcast(il, &il->ctx, sta);
+		sta_id = il_sta_id_or_broadcast(il, sta);
 		if (sta_id == IL_INVALID_STATION)
 			return -EINVAL;
 	}
@@ -3003,8 +2998,7 @@ il3945_mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	D_INFO("proceeding to add station %pM\n", sta->addr);
 	sta_priv->common.sta_id = IL_INVALID_STATION;
 
-	ret =
-	    il_add_station_common(il, &il->ctx, sta->addr, is_ap, sta, &sta_id);
+	ret = il_add_station_common(il, sta->addr, is_ap, sta, &sta_id);
 	if (ret) {
 		IL_ERR("Unable to add station %pM (%d)\n", sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
@@ -3184,7 +3178,7 @@ il3945_store_flags(struct device *d, struct device_attribute *attr,
 		else {
 			D_INFO("Committing rxon.flags = 0x%04X\n", flags);
 			il->staging.flags = cpu_to_le32(flags);
-			il3945_commit_rxon(il, &il->ctx);
+			il3945_commit_rxon(il);
 		}
 	}
 	mutex_unlock(&il->mutex);
@@ -3220,7 +3214,7 @@ il3945_store_filter_flags(struct device *d, struct device_attribute *attr,
 			D_INFO("Committing rxon.filter_flags = " "0x%04X\n",
 			       filter_flags);
 			il->staging.filter_flags = cpu_to_le32(filter_flags);
-			il3945_commit_rxon(il, &il->ctx);
+			il3945_commit_rxon(il);
 		}
 	}
 	mutex_unlock(&il->mutex);
@@ -3750,8 +3744,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_release_irq;
 	}
 
-	il_set_rxon_channel(il, &il->bands[IEEE80211_BAND_2GHZ].channels[5],
-			    &il->ctx);
+	il_set_rxon_channel(il, &il->bands[IEEE80211_BAND_2GHZ].channels[5]);
 	il3945_setup_deferred_work(il);
 	il3945_setup_handlers(il);
 	il_power_initialize(il);
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index 6a782b5..70bee1a 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -927,8 +927,7 @@ il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	rcu_read_lock();
 
-	sta =
-	    ieee80211_find_sta(il->ctx.vif, il->stations[sta_id].sta.sta.addr);
+	sta = ieee80211_find_sta(il->vif, il->stations[sta_id].sta.sta.addr);
 	if (!sta) {
 		D_RATE("Unable to find station to initialize rate scaling.\n");
 		rcu_read_unlock();
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 3024645..1e617c9 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -1662,7 +1662,7 @@ il3945_hw_reg_set_txpower(struct il_priv *il, s8 power)
 }
 
 static int
-il3945_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
+il3945_send_rxon_assoc(struct il_priv *il)
 {
 	int rc = 0;
 	struct il_rx_pkt *pkt;
@@ -1714,7 +1714,7 @@ il3945_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
  * a HW tune is required based on the RXON structure changes.
  */
 int
-il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
+il3945_commit_rxon(struct il_priv *il)
 {
 	/* cast away the const for active_rxon in this function */
 	struct il3945_rxon_cmd *active_rxon = (void *)&il->active;
@@ -1735,7 +1735,7 @@ il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	staging_rxon->flags &= ~(RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_SEL_MSK);
 	staging_rxon->flags |= il3945_get_antenna_flags(il);
 
-	rc = il_check_rxon_cmd(il, ctx);
+	rc = il_check_rxon_cmd(il);
 	if (rc) {
 		IL_ERR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
@@ -1744,8 +1744,8 @@ il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	/* If we don't need to send a full RXON, we can use
 	 * il3945_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
-	if (!il_full_rxon_required(il, &il->ctx)) {
-		rc = il_send_rxon_assoc(il, &il->ctx);
+	if (!il_full_rxon_required(il)) {
+		rc = il_send_rxon_assoc(il);
 		if (rc) {
 			IL_ERR("Error setting RXON_ASSOC "
 			       "configuration (%d).\n", rc);
@@ -1786,8 +1786,8 @@ il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 			       "configuration (%d).\n", rc);
 			return rc;
 		}
-		il_clear_ucode_stations(il, &il->ctx);
-		il_restore_stations(il, &il->ctx);
+		il_clear_ucode_stations(il);
+		il_restore_stations(il);
 	}
 
 	D_INFO("Sending RXON\n" "* with%s RXON_FILTER_ASSOC_MSK\n"
@@ -1801,7 +1801,7 @@ il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	staging_rxon->reserved4 = 0;
 	staging_rxon->reserved5 = 0;
 
-	il_set_rxon_hwcrypto(il, ctx, !il3945_mod_params.sw_crypto);
+	il_set_rxon_hwcrypto(il, !il3945_mod_params.sw_crypto);
 
 	/* Apply the new configuration */
 	rc = il_send_cmd_pdu(il, C_RXON, sizeof(struct il3945_rxon_cmd),
@@ -1814,8 +1814,8 @@ il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
 
 	if (!new_assoc) {
-		il_clear_ucode_stations(il, &il->ctx);
-		il_restore_stations(il, &il->ctx);
+		il_clear_ucode_stations(il);
+		il_restore_stations(il);
 	}
 
 	/* If we issue a new RXON command which required a tune then we must
@@ -2258,7 +2258,6 @@ il3945_build_addsta_hcmd(const struct il_addsta_cmd *cmd, u8 * data)
 static int
 il3945_add_bssid_station(struct il_priv *il, const u8 * addr, u8 * sta_id_r)
 {
-	struct il_rxon_context *ctx = &il->ctx;
 	int ret;
 	u8 sta_id;
 	unsigned long flags;
@@ -2266,7 +2265,7 @@ il3945_add_bssid_station(struct il_priv *il, const u8 * addr, u8 * sta_id_r)
 	if (sta_id_r)
 		*sta_id_r = IL_INVALID_STATION;
 
-	ret = il_add_station_common(il, ctx, addr, 0, NULL, &sta_id);
+	ret = il_add_station_common(il, addr, 0, NULL, &sta_id);
 	if (ret) {
 		IL_ERR("Unable to add station %pM\n", addr);
 		return ret;
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 9f42f79..8bee127 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -249,7 +249,7 @@ extern int il4965_get_temperature(const struct il_priv *il);
 extern void il3945_post_associate(struct il_priv *il);
 extern void il3945_config_ap(struct il_priv *il);
 
-extern int il3945_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx);
+extern int il3945_commit_rxon(struct il_priv *il);
 
 /**
  * il3945_hw_find_station - Find station id for a given BSSID
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 1a54c1a..4be53cc 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -843,7 +843,6 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		.flags = CMD_SIZE_HUGE,
 	};
 	struct il_scan_cmd *scan;
-	struct il_rxon_context *ctx = &il->ctx;
 	u32 rate_flags = 0;
 	u16 cmd_len;
 	u16 rx_chain = 0;
@@ -859,8 +858,6 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&il->mutex);
 
-	ctx = il_rxon_ctx_from_vif(vif);
-
 	if (!il->scan_cmd) {
 		il->scan_cmd =
 		    kmalloc(sizeof(struct il_scan_cmd) + IL_MAX_SCAN_SIZE,
@@ -1033,8 +1030,7 @@ il4965_manage_ibss_station(struct il_priv *il, struct ieee80211_vif *vif,
 	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
 
 	if (add)
-		return il4965_add_bssid_station(il, vif_priv->ctx,
-						vif->bss_conf.bssid,
+		return il4965_add_bssid_station(il, vif->bss_conf.bssid,
 						&vif_priv->ibss_bssid_sta_id);
 	return il_remove_station(il, vif_priv->ibss_bssid_sta_id,
 				 vif->bss_conf.bssid);
@@ -1127,7 +1123,7 @@ il4965_count_chain_bitmap(u32 chain_bitmap)
  * This should not be used for scan command ... it puts data in wrong place.
  */
 void
-il4965_set_rxon_chain(struct il_priv *il, struct il_rxon_context *ctx)
+il4965_set_rxon_chain(struct il_priv *il)
 {
 	bool is_single = il4965_is_single_rx_stream(il);
 	bool is_cam = !test_bit(S_POWER_PMI, &il->status);
@@ -1456,7 +1452,7 @@ il4965_get_ac_from_tid(u16 tid)
 }
 
 static inline int
-il4965_get_fifo_from_tid(struct il_rxon_context *ctx, u16 tid)
+il4965_get_fifo_from_tid(u16 tid)
 {
 	const u8 ac_to_fifo[] = {
 		IL_TX_FIFO_VO,
@@ -1645,7 +1641,6 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	struct il_device_cmd *out_cmd;
 	struct il_cmd_meta *out_meta;
 	struct il_tx_cmd *tx_cmd;
-	struct il_rxon_context *ctx = &il->ctx;
 	int txq_id;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
@@ -1661,9 +1656,6 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	unsigned long flags;
 	bool is_agg = false;
 
-	if (info->control.vif)
-		ctx = il_rxon_ctx_from_vif(info->control.vif);
-
 	spin_lock_irqsave(&il->lock, flags);
 	if (il_is_rfkill(il)) {
 		D_DROP("Dropping - RF KILL\n");
@@ -1688,7 +1680,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		sta_id = il->hw_params.bcast_id;
 	else {
 		/* Find idx into station table for destination station */
-		sta_id = il_sta_id_or_broadcast(il, ctx, info->control.sta);
+		sta_id = il_sta_id_or_broadcast(il, info->control.sta);
 
 		if (sta_id == IL_INVALID_STATION) {
 			D_DROP("Dropping - INVALID STATION: %pM\n", hdr->addr1);
@@ -1764,7 +1756,6 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct il_tx_info));
 	txq->txb[q->write_ptr].skb = skb;
-	txq->txb[q->write_ptr].ctx = ctx;
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[q->write_ptr];
@@ -2228,7 +2219,8 @@ il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 	unsigned long flags;
 	struct il_tid_data *tid_data;
 
-	tx_fifo = il4965_get_fifo_from_tid(il_rxon_ctx_from_vif(vif), tid);
+	/* FIXME: warning if tx fifo not found ? */
+	tx_fifo = il4965_get_fifo_from_tid(tid);
 	if (unlikely(tx_fifo < 0))
 		return tx_fifo;
 
@@ -2321,7 +2313,8 @@ il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
 	int write_ptr, read_ptr;
 	unsigned long flags;
 
-	tx_fifo_id = il4965_get_fifo_from_tid(il_rxon_ctx_from_vif(vif), tid);
+	/* FIXME: warning if tx_fifo_id not found ? */
+	tx_fifo_id = il4965_get_fifo_from_tid(tid);
 	if (unlikely(tx_fifo_id < 0))
 		return tx_fifo_id;
 
@@ -2395,9 +2388,6 @@ il4965_txq_check_empty(struct il_priv *il, int sta_id, u8 tid, int txq_id)
 	struct il_queue *q = &il->txq[txq_id].q;
 	u8 *addr = il->stations[sta_id].sta.sta.addr;
 	struct il_tid_data *tid_data = &il->stations[sta_id].tid[tid];
-	struct il_rxon_context *ctx;
-
-	ctx = &il->ctx;
 
 	lockdep_assert_held(&il->sta_lock);
 
@@ -2408,11 +2398,11 @@ il4965_txq_check_empty(struct il_priv *il, int sta_id, u8 tid, int txq_id)
 		if (txq_id == tid_data->agg.txq_id &&
 		    q->read_ptr == q->write_ptr) {
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
-			int tx_fifo = il4965_get_fifo_from_tid(ctx, tid);
+			int tx_fifo = il4965_get_fifo_from_tid(tid);
 			D_HT("HW queue empty: continue DELBA flow\n");
 			il4965_txq_agg_disable(il, txq_id, ssn, tx_fifo);
 			tid_data->agg.state = IL_AGG_OFF;
-			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
+			ieee80211_stop_tx_ba_cb_irqsafe(il->vif, addr, tid);
 		}
 		break;
 	case IL_EMPTYING_HW_QUEUE_ADDBA:
@@ -2420,7 +2410,7 @@ il4965_txq_check_empty(struct il_priv *il, int sta_id, u8 tid, int txq_id)
 		if (tid_data->tfds_in_queue == 0) {
 			D_HT("HW queue empty: continue ADDBA flow\n");
 			tid_data->agg.state = IL_AGG_ON;
-			ieee80211_start_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
+			ieee80211_start_tx_ba_cb_irqsafe(il->vif, addr, tid);
 		}
 		break;
 	}
@@ -2429,14 +2419,13 @@ il4965_txq_check_empty(struct il_priv *il, int sta_id, u8 tid, int txq_id)
 }
 
 static void
-il4965_non_agg_tx_status(struct il_priv *il, struct il_rxon_context *ctx,
-			 const u8 *addr1)
+il4965_non_agg_tx_status(struct il_priv *il, const u8 *addr1)
 {
 	struct ieee80211_sta *sta;
 	struct il_station_priv *sta_priv;
 
 	rcu_read_lock();
-	sta = ieee80211_find_sta(ctx->vif, addr1);
+	sta = ieee80211_find_sta(il->vif, addr1);
 	if (sta) {
 		sta_priv = (void *)sta->drv_priv;
 		/* avoid atomic ops if this isn't a client */
@@ -2453,7 +2442,7 @@ il4965_tx_status(struct il_priv *il, struct il_tx_info *tx_info, bool is_agg)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx_info->skb->data;
 
 	if (!is_agg)
-		il4965_non_agg_tx_status(il, tx_info->ctx, hdr->addr1);
+		il4965_non_agg_tx_status(il, hdr->addr1);
 
 	ieee80211_tx_status_irqsafe(il->hw, tx_info->skb);
 }
@@ -2769,8 +2758,7 @@ il4965_sta_alloc_lq(struct il_priv *il, u8 sta_id)
  * Function sleeps.
  */
 int
-il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
-			 const u8 *addr, u8 *sta_id_r)
+il4965_add_bssid_station(struct il_priv *il, const u8 *addr, u8 *sta_id_r)
 {
 	int ret;
 	u8 sta_id;
@@ -2780,7 +2768,7 @@ il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
 	if (sta_id_r)
 		*sta_id_r = IL_INVALID_STATION;
 
-	ret = il_add_station_common(il, ctx, addr, 0, NULL, &sta_id);
+	ret = il_add_station_common(il, addr, 0, NULL, &sta_id);
 	if (ret) {
 		IL_ERR("Unable to add station %pM\n", addr);
 		return ret;
@@ -2801,7 +2789,7 @@ il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
 		return -ENOMEM;
 	}
 
-	ret = il_send_lq_cmd(il, ctx, link_cmd, CMD_SYNC, true);
+	ret = il_send_lq_cmd(il, link_cmd, CMD_SYNC, true);
 	if (ret)
 		IL_ERR("Link quality command failed (%d)\n", ret);
 
@@ -2813,8 +2801,7 @@ il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
 }
 
 static int
-il4965_static_wepkey_cmd(struct il_priv *il, struct il_rxon_context *ctx,
-			 bool send_if_empty)
+il4965_static_wepkey_cmd(struct il_priv *il, bool send_if_empty)
 {
 	int i;
 	u8 buff[sizeof(struct il_wep_cmd) +
@@ -2860,15 +2847,15 @@ il4965_static_wepkey_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 }
 
 int
-il4965_restore_default_wep_keys(struct il_priv *il, struct il_rxon_context *ctx)
+il4965_restore_default_wep_keys(struct il_priv *il)
 {
 	lockdep_assert_held(&il->mutex);
 
-	return il4965_static_wepkey_cmd(il, ctx, false);
+	return il4965_static_wepkey_cmd(il, false);
 }
 
 int
-il4965_remove_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
+il4965_remove_default_wep_key(struct il_priv *il,
 			      struct ieee80211_key_conf *keyconf)
 {
 	int ret;
@@ -2884,14 +2871,14 @@ il4965_remove_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
 		/* but keys in device are clear anyway so return success */
 		return 0;
 	}
-	ret = il4965_static_wepkey_cmd(il, ctx, 1);
+	ret = il4965_static_wepkey_cmd(il, 1);
 	D_WEP("Remove default WEP key: idx=%d ret=%d\n", idx, ret);
 
 	return ret;
 }
 
 int
-il4965_set_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
+il4965_set_default_wep_key(struct il_priv *il,
 			   struct ieee80211_key_conf *keyconf)
 {
 	int ret;
@@ -2912,14 +2899,14 @@ il4965_set_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
 	il->_4965.wep_keys[idx].key_size = len;
 	memcpy(&il->_4965.wep_keys[idx].key, &keyconf->key, len);
 
-	ret = il4965_static_wepkey_cmd(il, ctx, false);
+	ret = il4965_static_wepkey_cmd(il, false);
 
 	D_WEP("Set default WEP key: len=%d idx=%d ret=%d\n", len, idx, ret);
 	return ret;
 }
 
 static int
-il4965_set_wep_dynamic_key_info(struct il_priv *il, struct il_rxon_context *ctx,
+il4965_set_wep_dynamic_key_info(struct il_priv *il,
 				struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	unsigned long flags;
@@ -2974,7 +2961,6 @@ il4965_set_wep_dynamic_key_info(struct il_priv *il, struct il_rxon_context *ctx,
 
 static int
 il4965_set_ccmp_dynamic_key_info(struct il_priv *il,
-				 struct il_rxon_context *ctx,
 				 struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	unsigned long flags;
@@ -3023,7 +3009,6 @@ il4965_set_ccmp_dynamic_key_info(struct il_priv *il,
 
 static int
 il4965_set_tkip_dynamic_key_info(struct il_priv *il,
-				 struct il_rxon_context *ctx,
 				 struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	unsigned long flags;
@@ -3068,9 +3053,8 @@ il4965_set_tkip_dynamic_key_info(struct il_priv *il,
 }
 
 void
-il4965_update_tkip_key(struct il_priv *il, struct il_rxon_context *ctx,
-		       struct ieee80211_key_conf *keyconf,
-		       struct ieee80211_sta *sta, u32 iv32, u16 * phase1key)
+il4965_update_tkip_key(struct il_priv *il, struct ieee80211_key_conf *keyconf,
+		       struct ieee80211_sta *sta, u32 iv32, u16 *phase1key)
 {
 	u8 sta_id;
 	unsigned long flags;
@@ -3082,7 +3066,7 @@ il4965_update_tkip_key(struct il_priv *il, struct il_rxon_context *ctx,
 		return;
 	}
 
-	sta_id = il_sta_id_or_broadcast(il, ctx, sta);
+	sta_id = il_sta_id_or_broadcast(il, sta);
 	if (sta_id == IL_INVALID_STATION)
 		return;
 
@@ -3100,11 +3084,10 @@ il4965_update_tkip_key(struct il_priv *il, struct il_rxon_context *ctx,
 	il_send_add_sta(il, &il->stations[sta_id].sta, CMD_ASYNC);
 
 	spin_unlock_irqrestore(&il->sta_lock, flags);
-
 }
 
 int
-il4965_remove_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
+il4965_remove_dynamic_key(struct il_priv *il,
 			  struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	unsigned long flags;
@@ -3165,8 +3148,8 @@ il4965_remove_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
 }
 
 int
-il4965_set_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
-		       struct ieee80211_key_conf *keyconf, u8 sta_id)
+il4965_set_dynamic_key(struct il_priv *il, struct ieee80211_key_conf *keyconf,
+		       u8 sta_id)
 {
 	int ret;
 
@@ -3178,15 +3161,15 @@ il4965_set_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
 		ret =
-		    il4965_set_ccmp_dynamic_key_info(il, ctx, keyconf, sta_id);
+		    il4965_set_ccmp_dynamic_key_info(il, keyconf, sta_id);
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		ret =
-		    il4965_set_tkip_dynamic_key_info(il, ctx, keyconf, sta_id);
+		    il4965_set_tkip_dynamic_key_info(il, keyconf, sta_id);
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		ret = il4965_set_wep_dynamic_key_info(il, ctx, keyconf, sta_id);
+		ret = il4965_set_wep_dynamic_key_info(il, keyconf, sta_id);
 		break;
 	default:
 		IL_ERR("Unknown alg: %s cipher = %x\n", __func__,
@@ -3208,14 +3191,14 @@ il4965_set_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
  * device at the next best time.
  */
 int
-il4965_alloc_bcast_station(struct il_priv *il, struct il_rxon_context *ctx)
+il4965_alloc_bcast_station(struct il_priv *il)
 {
 	struct il_link_quality_cmd *link_cmd;
 	unsigned long flags;
 	u8 sta_id;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
-	sta_id = il_prep_station(il, ctx, il_bcast_addr, false, NULL);
+	sta_id = il_prep_station(il, il_bcast_addr, false, NULL);
 	if (sta_id == IL_INVALID_STATION) {
 		IL_ERR("Unable to prepare broadcast station\n");
 		spin_unlock_irqrestore(&il->sta_lock, flags);
@@ -3248,7 +3231,7 @@ il4965_alloc_bcast_station(struct il_priv *il, struct il_rxon_context *ctx)
  * code together.
  */
 static int
-il4965_update_bcast_station(struct il_priv *il, struct il_rxon_context *ctx)
+il4965_update_bcast_station(struct il_priv *il)
 {
 	unsigned long flags;
 	struct il_link_quality_cmd *link_cmd;
@@ -3274,7 +3257,7 @@ il4965_update_bcast_station(struct il_priv *il, struct il_rxon_context *ctx)
 int
 il4965_update_bcast_stations(struct il_priv *il)
 {
-	return il4965_update_bcast_station(il, &il->ctx);
+	return il4965_update_bcast_station(il);
 }
 
 /**
@@ -3375,9 +3358,9 @@ void
 il4965_update_chain_flags(struct il_priv *il)
 {
 	if (il->cfg->ops->hcmd->set_rxon_chain) {
-		il->cfg->ops->hcmd->set_rxon_chain(il, &il->ctx);
+		il->cfg->ops->hcmd->set_rxon_chain(il);
 		if (il->active.rx_chain != il->staging.rx_chain)
-			il_commit_rxon(il, &il->ctx);
+			il_commit_rxon(il);
 	}
 }
 
@@ -3489,8 +3472,8 @@ il4965_hw_get_beacon_cmd(struct il_priv *il, struct il_frame *frame)
 
 	lockdep_assert_held(&il->mutex);
 
-	if (!il->beacon_ctx) {
-		IL_ERR("trying to build beacon w/o beacon context!\n");
+	if (!il->beacon_enabled) {
+		IL_ERR("Trying to build beacon without beaconing enabled\n");
 		return 0;
 	}
 
@@ -3520,7 +3503,7 @@ il4965_hw_get_beacon_cmd(struct il_priv *il, struct il_frame *frame)
 			      frame_size);
 
 	/* Set up packet rate and flags */
-	rate = il_get_lowest_plcp(il, il->beacon_ctx);
+	rate = il_get_lowest_plcp(il);
 	il4965_toggle_tx_ant(il, &il->mgmt_tx_ant, il->hw_params.valid_tx_ant);
 	rate_flags = BIT(il->mgmt_tx_ant) << RATE_MCS_ANT_POS;
 	if ((rate >= IL_FIRST_CCK_RATE) && (rate <= IL_LAST_CCK_RATE))
@@ -4977,7 +4960,6 @@ static void
 il4965_alive_start(struct il_priv *il)
 {
 	int ret = 0;
-	struct il_rxon_context *ctx = &il->ctx;
 
 	D_INFO("Runtime Alive received.\n");
 
@@ -5025,10 +5007,10 @@ il4965_alive_start(struct il_priv *il)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		il_connection_init_rx_config(il, &il->ctx);
+		il_connection_init_rx_config(il);
 
 		if (il->cfg->ops->hcmd->set_rxon_chain)
-			il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
+			il->cfg->ops->hcmd->set_rxon_chain(il);
 	}
 
 	/* Configure bluetooth coexistence if enabled */
@@ -5039,7 +5021,7 @@ il4965_alive_start(struct il_priv *il)
 	set_bit(S_READY, &il->status);
 
 	/* Configure the adapter for unassociated operation */
-	il_commit_rxon(il, ctx);
+	il_commit_rxon(il);
 
 	/* At this point, the NIC is initialized and operational */
 	il4965_rf_kill_ct_config(il);
@@ -5074,7 +5056,7 @@ __il4965_down(struct il_priv *il)
 	 * to prevent rearm timer */
 	del_timer_sync(&il->watchdog);
 
-	il_clear_ucode_stations(il, NULL);
+	il_clear_ucode_stations(il);
 
 	/* FIXME: race conditions ? */
 	spin_lock_irq(&il->sta_lock);
@@ -5239,7 +5221,7 @@ __il4965_up(struct il_priv *il)
 		return -EIO;
 	}
 
-	ret = il4965_alloc_bcast_station(il, &il->ctx);
+	ret = il4965_alloc_bcast_station(il);
 	if (ret) {
 		il_dealloc_bcast_stations(il);
 		return ret;
@@ -5393,7 +5375,8 @@ il4965_bg_restart(struct work_struct *data)
 
 	if (test_and_clear_bit(S_FW_ERROR, &il->status)) {
 		mutex_lock(&il->mutex);
-		il->ctx.vif = NULL;
+		/* FIXME: do we dereference vif without mutex locked ? */
+		il->vif = NULL;
 		il->is_open = 0;
 
 		__il4965_down(il);
@@ -5590,12 +5573,10 @@ il4965_mac_update_tkip_key(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta, u32 iv32, u16 * phase1key)
 {
 	struct il_priv *il = hw->priv;
-	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
 
 	D_MAC80211("enter\n");
 
-	il4965_update_tkip_key(il, vif_priv->ctx, keyconf, sta, iv32,
-			       phase1key);
+	il4965_update_tkip_key(il, keyconf, sta, iv32, phase1key);
 
 	D_MAC80211("leave\n");
 }
@@ -5606,8 +5587,6 @@ il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		   struct ieee80211_key_conf *key)
 {
 	struct il_priv *il = hw->priv;
-	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct il_rxon_context *ctx = vif_priv->ctx;
 	int ret;
 	u8 sta_id;
 	bool is_default_wep_key = false;
@@ -5619,7 +5598,7 @@ il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	sta_id = il_sta_id_or_broadcast(il, vif_priv->ctx, sta);
+	sta_id = il_sta_id_or_broadcast(il, sta);
 	if (sta_id == IL_INVALID_STATION)
 		return -EINVAL;
 
@@ -5644,20 +5623,17 @@ il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	switch (cmd) {
 	case SET_KEY:
 		if (is_default_wep_key)
-			ret =
-			    il4965_set_default_wep_key(il, vif_priv->ctx, key);
+			ret = il4965_set_default_wep_key(il, key);
 		else
-			ret =
-			    il4965_set_dynamic_key(il, vif_priv->ctx, key,
-						   sta_id);
+			ret = il4965_set_dynamic_key(il, key, sta_id);
 
 		D_MAC80211("enable hwcrypto key\n");
 		break;
 	case DISABLE_KEY:
 		if (is_default_wep_key)
-			ret = il4965_remove_default_wep_key(il, ctx, key);
+			ret = il4965_remove_default_wep_key(il, key);
 		else
-			ret = il4965_remove_dynamic_key(il, ctx, key, sta_id);
+			ret = il4965_remove_dynamic_key(il, key, sta_id);
 
 		D_MAC80211("disable hwcrypto key\n");
 		break;
@@ -5723,7 +5699,6 @@ il4965_mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct il_priv *il = hw->priv;
 	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
 	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
 	int ret;
 	u8 sta_id;
@@ -5736,8 +5711,7 @@ il4965_mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	atomic_set(&sta_priv->pending_frames, 0);
 
 	ret =
-	    il_add_station_common(il, vif_priv->ctx, sta->addr, is_ap, sta,
-				  &sta_id);
+	    il_add_station_common(il, sta->addr, is_ap, sta, &sta_id);
 	if (ret) {
 		IL_ERR("Unable to add station %pM (%d)\n", sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
@@ -5764,8 +5738,6 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = ch_switch->channel;
 	struct il_ht_config *ht_conf = &il->current_ht_config;
-
-	struct il_rxon_context *ctx = &il->ctx;
 	u16 ch;
 
 	D_MAC80211("enter\n");
@@ -5822,9 +5794,9 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	if ((le16_to_cpu(il->staging.channel) != ch))
 		il->staging.flags = 0;
 
-	il_set_rxon_channel(il, channel, ctx);
+	il_set_rxon_channel(il, channel);
 	il_set_rxon_ht(il, ht_conf);
-	il_set_flags_for_band(il, ctx, channel->band, ctx->vif);
+	il_set_flags_for_band(il, channel->band, il->vif);
 
 	spin_unlock_irq(&il->lock);
 
@@ -5838,7 +5810,7 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	if (il->cfg->ops->lib->set_channel_switch(il, ch_switch)) {
 		clear_bit(S_CHANNEL_SWITCH_PENDING, &il->status);
 		il->switch_channel = 0;
-		ieee80211_chswitch_done(ctx->vif, false);
+		ieee80211_chswitch_done(il->vif, false);
 	}
 
 out:
@@ -6049,7 +6021,7 @@ il4965_init_drv(struct il_priv *il)
 
 	/* Choose which receivers/antennas to use */
 	if (il->cfg->ops->hcmd->set_rxon_chain)
-		il->cfg->ops->hcmd->set_rxon_chain(il, &il->ctx);
+		il->cfg->ops->hcmd->set_rxon_chain(il);
 
 	il_init_scan_params(il);
 
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index ad186d9..d7e2856 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -820,8 +820,6 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	u32 tx_rate;
 	struct il_scale_tbl_info tbl_type;
 	struct il_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
-	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
 	D_RATE("get frame ack response, update rate scale win\n");
 
@@ -889,7 +887,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 		lq_sta->missed_rate_counter++;
 		if (lq_sta->missed_rate_counter > IL_MISSED_RATE_MAX) {
 			lq_sta->missed_rate_counter = 0;
-			il_send_lq_cmd(il, ctx, &lq_sta->lq, CMD_ASYNC, false);
+			il_send_lq_cmd(il, &lq_sta->lq, CMD_ASYNC, false);
 		}
 		/* Regardless, ignore this status info for outdated rate */
 		return;
@@ -1181,8 +1179,6 @@ il4965_rs_switch_to_mimo2(struct il_priv *il, struct il_lq_sta *lq_sta,
 	u16 rate_mask;
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
-	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
@@ -1203,7 +1199,7 @@ il4965_rs_switch_to_mimo2(struct il_priv *il, struct il_lq_sta *lq_sta,
 	tbl->max_search = IL_MAX_SEARCH;
 	rate_mask = lq_sta->active_mimo2_rate;
 
-	if (il_is_ht40_tx_allowed(il, ctx, &sta->ht_cap))
+	if (il_is_ht40_tx_allowed(il, &sta->ht_cap))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -1237,8 +1233,6 @@ il4965_rs_switch_to_siso(struct il_priv *il, struct il_lq_sta *lq_sta,
 	u16 rate_mask;
 	u8 is_green = lq_sta->is_green;
 	s32 rate;
-	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
@@ -1251,7 +1245,7 @@ il4965_rs_switch_to_siso(struct il_priv *il, struct il_lq_sta *lq_sta,
 	tbl->max_search = IL_MAX_SEARCH;
 	rate_mask = lq_sta->active_siso_rate;
 
-	if (il_is_ht40_tx_allowed(il, ctx, &sta->ht_cap))
+	if (il_is_ht40_tx_allowed(il, &sta->ht_cap))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -1730,8 +1724,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
  * setup rate table in uCode
  */
 static void
-il4965_rs_update_rate_tbl(struct il_priv *il, struct il_rxon_context *ctx,
-			  struct il_lq_sta *lq_sta,
+il4965_rs_update_rate_tbl(struct il_priv *il, struct il_lq_sta *lq_sta,
 			  struct il_scale_tbl_info *tbl, int idx, u8 is_green)
 {
 	u32 rate;
@@ -1739,7 +1732,7 @@ il4965_rs_update_rate_tbl(struct il_priv *il, struct il_rxon_context *ctx,
 	/* Update uCode's rate table. */
 	rate = il4965_rate_n_flags_from_tbl(il, tbl, idx, is_green);
 	il4965_rs_fill_link_cmd(il, lq_sta, rate);
-	il_send_lq_cmd(il, ctx, &lq_sta->lq, CMD_ASYNC, false);
+	il_send_lq_cmd(il, &lq_sta->lq, CMD_ASYNC, false);
 }
 
 /*
@@ -1775,8 +1768,6 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 	s32 sr;
 	u8 tid = MAX_TID_COUNT;
 	struct il_tid_data *tid_data;
-	struct il_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
 	D_RATE("rate scale calculate new rate for skb\n");
 
@@ -1851,7 +1842,7 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 			/* get "active" rate info */
 			idx = il4965_hwrate_to_plcp_idx(tbl->current_rate);
-			il4965_rs_update_rate_tbl(il, ctx, lq_sta, tbl, idx,
+			il4965_rs_update_rate_tbl(il, lq_sta, tbl, idx,
 						      is_green);
 		}
 		return;
@@ -2054,8 +2045,7 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq)
-		il4965_rs_update_rate_tbl(il, ctx, lq_sta, tbl, idx,
-					      is_green);
+		il4965_rs_update_rate_tbl(il, lq_sta, tbl, idx, is_green);
 
 	/* Should we stay with this modulation mode,
 	 * or search for a new one? */
@@ -2095,7 +2085,7 @@ lq_update:
 			D_RATE("Switch current  mcs: %X idx: %d\n",
 			       tbl->current_rate, idx);
 			il4965_rs_fill_link_cmd(il, lq_sta, tbl->current_rate);
-			il_send_lq_cmd(il, ctx, &lq_sta->lq, CMD_ASYNC, false);
+			il_send_lq_cmd(il, &lq_sta->lq, CMD_ASYNC, false);
 		} else
 			done_search = 1;
 	}
@@ -2167,13 +2157,11 @@ il4965_rs_initialize_lq(struct il_priv *il, struct ieee80211_conf *conf,
 	u8 active_tbl = 0;
 	u8 valid_tx_ant;
 	struct il_station_priv *sta_priv;
-	struct il_rxon_context *ctx;
 
 	if (!sta || !lq_sta)
 		return;
 
 	sta_priv = (void *)sta->drv_priv;
-	ctx = sta_priv->common.ctx;
 
 	i = lq_sta->last_txrate_idx;
 
@@ -2205,7 +2193,7 @@ il4965_rs_initialize_lq(struct il_priv *il, struct ieee80211_conf *conf,
 	il4965_rs_set_expected_tpt_table(lq_sta, tbl);
 	il4965_rs_fill_link_cmd(NULL, lq_sta, rate);
 	il->stations[lq_sta->lq.sta_id].lq = &lq_sta->lq;
-	il_send_lq_cmd(il, ctx, &lq_sta->lq, CMD_SYNC, true);
+	il_send_lq_cmd(il, &lq_sta->lq, CMD_SYNC, true);
 }
 
 static void
@@ -2576,9 +2564,6 @@ il4965_rs_sta_dbgfs_scale_table_write(struct file *file,
 	char buf[64];
 	size_t buf_size;
 	u32 parsed_rate;
-	struct il_station_priv *sta_priv =
-	    container_of(lq_sta, struct il_station_priv, lq_sta);
-	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
 	il = lq_sta->drv;
 	memset(buf, 0, sizeof(buf));
@@ -2600,7 +2585,7 @@ il4965_rs_sta_dbgfs_scale_table_write(struct file *file,
 
 	if (lq_sta->dbg_fixed_rate) {
 		il4965_rs_fill_link_cmd(NULL, lq_sta, lq_sta->dbg_fixed_rate);
-		il_send_lq_cmd(lq_sta->drv, ctx, &lq_sta->lq, CMD_ASYNC, false);
+		il_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC, false);
 	}
 
 	return count;
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 7b0192a..9d9197f 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1370,7 +1370,7 @@ out:
 }
 
 static int
-il4965_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
+il4965_send_rxon_assoc(struct il_priv *il)
 {
 	int ret = 0;
 	struct il4965_rxon_assoc_cmd rxon_assoc;
@@ -1409,7 +1409,7 @@ il4965_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
 }
 
 static int
-il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
+il4965_commit_rxon(struct il_priv *il)
 {
 	/* cast away the const for active_rxon in this function */
 	struct il_rxon_cmd *active_rxon = (void *)&il->active;
@@ -1422,7 +1422,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	/* always get timestamp with Rx frame */
 	il->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
-	ret = il_check_rxon_cmd(il, ctx);
+	ret = il_check_rxon_cmd(il);
 	if (ret) {
 		IL_ERR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
@@ -1442,15 +1442,15 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	/* If we don't need to send a full RXON, we can use
 	 * il_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
-	if (!il_full_rxon_required(il, ctx)) {
-		ret = il_send_rxon_assoc(il, ctx);
+	if (!il_full_rxon_required(il)) {
+		ret = il_send_rxon_assoc(il);
 		if (ret) {
 			IL_ERR("Error setting RXON_ASSOC (%d)\n", ret);
 			return ret;
 		}
 
 		memcpy(active_rxon, &il->staging, sizeof(*active_rxon));
-		il_print_rx_config_cmd(il, ctx);
+		il_print_rx_config_cmd(il);
 		/*
 		 * We do not commit tx power settings while channel changing,
 		 * do it now if tx power changed.
@@ -1478,9 +1478,9 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 			IL_ERR("Error clearing ASSOC_MSK (%d)\n", ret);
 			return ret;
 		}
-		il_clear_ucode_stations(il, ctx);
-		il_restore_stations(il, ctx);
-		ret = il4965_restore_default_wep_keys(il, ctx);
+		il_clear_ucode_stations(il);
+		il_restore_stations(il);
+		ret = il4965_restore_default_wep_keys(il);
 		if (ret) {
 			IL_ERR("Failed to restore WEP keys (%d)\n", ret);
 			return ret;
@@ -1491,7 +1491,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	       "* channel = %d\n" "* bssid = %pM\n", (new_assoc ? "" : "out"),
 	       le16_to_cpu(il->staging.channel), il->staging.bssid_addr);
 
-	il_set_rxon_hwcrypto(il, ctx, !il->cfg->mod_params->sw_crypto);
+	il_set_rxon_hwcrypto(il, !il->cfg->mod_params->sw_crypto);
 
 	/* Apply the new configuration
 	 * RXON unassoc clears the station table in uCode so restoration of
@@ -1507,9 +1507,9 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		}
 		D_INFO("Return from !new_assoc RXON.\n");
 		memcpy(active_rxon, &il->staging, sizeof(*active_rxon));
-		il_clear_ucode_stations(il, ctx);
-		il_restore_stations(il, ctx);
-		ret = il4965_restore_default_wep_keys(il, ctx);
+		il_clear_ucode_stations(il);
+		il_restore_stations(il);
+		ret = il4965_restore_default_wep_keys(il);
 		if (ret) {
 			IL_ERR("Failed to restore WEP keys (%d)\n", ret);
 			return ret;
@@ -1529,7 +1529,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		}
 		memcpy(active_rxon, &il->staging, sizeof(*active_rxon));
 	}
-	il_print_rx_config_cmd(il, ctx);
+	il_print_rx_config_cmd(il);
 
 	il4965_init_sensitivity(il);
 
@@ -1548,7 +1548,6 @@ static int
 il4965_hw_channel_switch(struct il_priv *il,
 			 struct ieee80211_channel_switch *ch_switch)
 {
-	struct il_rxon_context *ctx = &il->ctx;
 	int rc;
 	u8 band = 0;
 	bool is_ht40 = false;
@@ -1560,8 +1559,11 @@ il4965_hw_channel_switch(struct il_priv *il,
 	u32 tsf_low;
 	u8 switch_count;
 	u16 beacon_interval = le16_to_cpu(il->timing.beacon_interval);
-	struct ieee80211_vif *vif = ctx->vif;
-	band = il->band == IEEE80211_BAND_2GHZ;
+	struct ieee80211_vif *vif = il->vif;
+	band = (il->band == IEEE80211_BAND_2GHZ);
+
+	if (WARN_ON_ONCE(vif == NULL))
+		return -EIO;
 
 	is_ht40 = iw4965_is_ht40_channel(il->staging.flags);
 
@@ -2128,21 +2130,18 @@ static struct il_hcmd_ops il4965_hcmd = {
 static void
 il4965_post_scan(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->ctx;
-
 	/*
 	 * Since setting the RXON may have been deferred while
 	 * performing the scan, fire one off if needed
 	 */
 	if (memcmp(&il->staging, &il->active, sizeof(il->staging)))
-		il_commit_rxon(il, ctx);
+		il_commit_rxon(il);
 }
 
 static void
 il4965_post_associate(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->ctx;
-	struct ieee80211_vif *vif = ctx->vif;
+	struct ieee80211_vif *vif = il->vif;
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
 
@@ -2157,9 +2156,9 @@ il4965_post_associate(struct il_priv *il)
 	conf = &il->hw->conf;
 
 	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	il_commit_rxon(il, ctx);
+	il_commit_rxon(il);
 
-	ret = il_send_rxon_timing(il, ctx);
+	ret = il_send_rxon_timing(il);
 	if (ret)
 		IL_WARN("RXON timing - " "Attempting to continue.\n");
 
@@ -2168,7 +2167,7 @@ il4965_post_associate(struct il_priv *il)
 	il_set_rxon_ht(il, &il->current_ht_config);
 
 	if (il->cfg->ops->hcmd->set_rxon_chain)
-		il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
+		il->cfg->ops->hcmd->set_rxon_chain(il);
 
 	il->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
@@ -2187,7 +2186,7 @@ il4965_post_associate(struct il_priv *il)
 			il->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
-	il_commit_rxon(il, ctx);
+	il_commit_rxon(il);
 
 	D_ASSOC("Associated as %d to: %pM\n", vif->bss_conf.aid,
 		il->active.bssid_addr);
@@ -2218,8 +2217,7 @@ il4965_post_associate(struct il_priv *il)
 static void
 il4965_config_ap(struct il_priv *il)
 {
-	struct il_rxon_context *ctx = &il->ctx;
-	struct ieee80211_vif *vif = ctx->vif;
+	struct ieee80211_vif *vif = il->vif;
 	int ret = 0;
 
 	lockdep_assert_held(&il->mutex);
@@ -2232,10 +2230,10 @@ il4965_config_ap(struct il_priv *il)
 
 		/* RXON - unassoc (to set timing command) */
 		il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		il_commit_rxon(il, ctx);
+		il_commit_rxon(il);
 
 		/* RXON Timing */
-		ret = il_send_rxon_timing(il, ctx);
+		ret = il_send_rxon_timing(il);
 		if (ret)
 			IL_WARN("RXON timing failed - "
 				"Attempting to continue.\n");
@@ -2244,7 +2242,7 @@ il4965_config_ap(struct il_priv *il)
 		il->chain_noise_data.active_chains = il->hw_params.valid_rx_ant;
 		il_set_rxon_ht(il, &il->current_ht_config);
 		if (il->cfg->ops->hcmd->set_rxon_chain)
-			il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
+			il->cfg->ops->hcmd->set_rxon_chain(il);
 
 		il->staging.assoc_id = 0;
 
@@ -2263,7 +2261,7 @@ il4965_config_ap(struct il_priv *il)
 		il4965_send_beacon_cmd(il);
 		/* restore RXON assoc */
 		il->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		il_commit_rxon(il, ctx);
+		il_commit_rxon(il);
 	}
 	il4965_send_beacon_cmd(il);
 }
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index f280e01..6789960 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -48,7 +48,7 @@ void il4965_free_tfds_in_queue(struct il_priv *il, int sta_id, int tid,
 			       int freed);
 
 /* RXON */
-void il4965_set_rxon_chain(struct il_priv *il, struct il_rxon_context *ctx);
+void il4965_set_rxon_chain(struct il_priv *il);
 
 /* uCode */
 int il4965_verify_ucode(struct il_priv *il);
@@ -134,21 +134,18 @@ il4965_get_tx_fail_reason(u32 status)
 #endif
 
 /* station management */
-int il4965_alloc_bcast_station(struct il_priv *il, struct il_rxon_context *ctx);
-int il4965_add_bssid_station(struct il_priv *il, struct il_rxon_context *ctx,
-			     const u8 *addr, u8 *sta_id_r);
+int il4965_alloc_bcast_station(struct il_priv *il);
+int il4965_add_bssid_station(struct il_priv *il, const u8 *addr, u8 *sta_id_r);
 int il4965_remove_default_wep_key(struct il_priv *il,
-				  struct il_rxon_context *ctx,
 				  struct ieee80211_key_conf *key);
-int il4965_set_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
+int il4965_set_default_wep_key(struct il_priv *il,
 			       struct ieee80211_key_conf *key);
-int il4965_restore_default_wep_keys(struct il_priv *il,
-				    struct il_rxon_context *ctx);
-int il4965_set_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
+int il4965_restore_default_wep_keys(struct il_priv *il);
+int il4965_set_dynamic_key(struct il_priv *il,
 			   struct ieee80211_key_conf *key, u8 sta_id);
-int il4965_remove_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
+int il4965_remove_dynamic_key(struct il_priv *il,
 			      struct ieee80211_key_conf *key, u8 sta_id);
-void il4965_update_tkip_key(struct il_priv *il, struct il_rxon_context *ctx,
+void il4965_update_tkip_key(struct il_priv *il,
 			    struct ieee80211_key_conf *keyconf,
 			    struct ieee80211_sta *sta, u32 iv32,
 			    u16 *phase1key);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index ea2fa97..bee11a3 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1442,7 +1442,6 @@ u16
 il_get_passive_dwell_time(struct il_priv *il, enum ieee80211_band band,
 			  struct ieee80211_vif *vif)
 {
-	struct il_rxon_context *ctx = &il->ctx;
 	u16 value;
 
 	u16 passive =
@@ -1457,7 +1456,7 @@ il_get_passive_dwell_time(struct il_priv *il, enum ieee80211_band band,
 		 * dwell time to be 98% of the smallest beacon interval
 		 * (minus 2 * channel tune time)
 		 */
-		value = ctx->vif ? ctx->vif->bss_conf.beacon_int : 0;
+		value = il->vif ? il->vif->bss_conf.beacon_int : 0;
 		if (value > IL_PASSIVE_DWELL_BASE || !value)
 			value = IL_PASSIVE_DWELL_BASE;
 		value = (value * 98) / 100 - IL_CHANNEL_TUNE_TIME * 2;
@@ -1832,8 +1831,7 @@ il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags)
 EXPORT_SYMBOL(il_send_add_sta);
 
 static void
-il_set_ht_add_station(struct il_priv *il, u8 idx, struct ieee80211_sta *sta,
-		      struct il_rxon_context *ctx)
+il_set_ht_add_station(struct il_priv *il, u8 idx, struct ieee80211_sta *sta)
 {
 	struct ieee80211_sta_ht_cap *sta_ht_inf = &sta->ht_cap;
 	__le32 sta_flags;
@@ -1874,7 +1872,7 @@ il_set_ht_add_station(struct il_priv *il, u8 idx, struct ieee80211_sta *sta,
 	    cpu_to_le32((u32) sta_ht_inf->
 			ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
 
-	if (il_is_ht40_tx_allowed(il, ctx, &sta->ht_cap))
+	if (il_is_ht40_tx_allowed(il, &sta->ht_cap))
 		sta_flags |= STA_FLG_HT40_EN_MSK;
 	else
 		sta_flags &= ~STA_FLG_HT40_EN_MSK;
@@ -1890,8 +1888,8 @@ done:
  * should be called with sta_lock held
  */
 u8
-il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
-		const u8 *addr, bool is_ap, struct ieee80211_sta *sta)
+il_prep_station(struct il_priv *il, const u8 *addr, bool is_ap,
+		struct ieee80211_sta *sta)
 {
 	struct il_station_entry *station;
 	int i;
@@ -1952,19 +1950,12 @@ il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 	station->sta.sta.sta_id = sta_id;
 	station->sta.station_flags = 0;
 
-	if (sta) {
-		struct il_station_priv_common *sta_priv;
-
-		sta_priv = (void *)sta->drv_priv;
-		sta_priv->ctx = ctx;
-	}
-
 	/*
 	 * OK to call unconditionally, since local stations (IBSS BSSID
 	 * STA and broadcast STA) pass in a NULL sta, and mac80211
 	 * doesn't allow HT IBSS.
 	 */
-	il_set_ht_add_station(il, sta_id, sta, ctx);
+	il_set_ht_add_station(il, sta_id, sta);
 
 	/* 3945 only */
 	rate = (il->band == IEEE80211_BAND_5GHZ) ? RATE_6M_PLCP : RATE_1M_PLCP;
@@ -1982,9 +1973,8 @@ EXPORT_SYMBOL_GPL(il_prep_station);
  * il_add_station_common -
  */
 int
-il_add_station_common(struct il_priv *il, struct il_rxon_context *ctx,
-		      const u8 *addr, bool is_ap, struct ieee80211_sta *sta,
-		      u8 *sta_id_r)
+il_add_station_common(struct il_priv *il, const u8 *addr, bool is_ap,
+		      struct ieee80211_sta *sta, u8 *sta_id_r)
 {
 	unsigned long flags_spin;
 	int ret = 0;
@@ -1993,7 +1983,7 @@ il_add_station_common(struct il_priv *il, struct il_rxon_context *ctx,
 
 	*sta_id_r = 0;
 	spin_lock_irqsave(&il->sta_lock, flags_spin);
-	sta_id = il_prep_station(il, ctx, addr, is_ap, sta);
+	sta_id = il_prep_station(il, addr, is_ap, sta);
 	if (sta_id == IL_INVALID_STATION) {
 		IL_ERR("Unable to prepare station %pM for addition\n", addr);
 		spin_unlock_irqrestore(&il->sta_lock, flags_spin);
@@ -2180,7 +2170,7 @@ EXPORT_SYMBOL_GPL(il_remove_station);
  * the ucode, e.g. unassociated RXON.
  */
 void
-il_clear_ucode_stations(struct il_priv *il, struct il_rxon_context *ctx)
+il_clear_ucode_stations(struct il_priv *il)
 {
 	int i;
 	unsigned long flags_spin;
@@ -2212,7 +2202,7 @@ EXPORT_SYMBOL(il_clear_ucode_stations);
  * Function sleeps.
  */
 void
-il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
+il_restore_stations(struct il_priv *il)
 {
 	struct il_addsta_cmd sta_cmd;
 	struct il_link_quality_cmd lq;
@@ -2267,7 +2257,7 @@ il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
 			 * current LQ command
 			 */
 			if (send_lq)
-				il_send_lq_cmd(il, ctx, &lq, CMD_SYNC, true);
+				il_send_lq_cmd(il, &lq, CMD_SYNC, true);
 			spin_lock_irqsave(&il->sta_lock, flags_spin);
 			il->stations[i].used &= ~IL_STA_UCODE_INPROGRESS;
 		}
@@ -2347,8 +2337,7 @@ il_dump_lq_cmd(struct il_priv *il, struct il_link_quality_cmd *lq)
  * RXON flags are updated and when LQ command is updated.
  */
 static bool
-il_is_lq_table_valid(struct il_priv *il, struct il_rxon_context *ctx,
-		     struct il_link_quality_cmd *lq)
+il_is_lq_table_valid(struct il_priv *il, struct il_link_quality_cmd *lq)
 {
 	int i;
 
@@ -2376,8 +2365,8 @@ il_is_lq_table_valid(struct il_priv *il, struct il_rxon_context *ctx,
  * progress.
  */
 int
-il_send_lq_cmd(struct il_priv *il, struct il_rxon_context *ctx,
-	       struct il_link_quality_cmd *lq, u8 flags, bool init)
+il_send_lq_cmd(struct il_priv *il, struct il_link_quality_cmd *lq,
+	       u8 flags, bool init)
 {
 	int ret = 0;
 	unsigned long flags_spin;
@@ -2402,7 +2391,7 @@ il_send_lq_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 	il_dump_lq_cmd(il, lq);
 	BUG_ON(init && (cmd.flags & CMD_ASYNC));
 
-	if (il_is_lq_table_valid(il, ctx, lq))
+	if (il_is_lq_table_valid(il, lq))
 		ret = il_send_cmd(il, &cmd);
 	else
 		ret = -EINVAL;
@@ -3556,8 +3545,7 @@ il_is_channel_extension(struct il_priv *il, enum ieee80211_band band,
 }
 
 bool
-il_is_ht40_tx_allowed(struct il_priv *il, struct il_rxon_context *ctx,
-		      struct ieee80211_sta_ht_cap *ht_cap)
+il_is_ht40_tx_allowed(struct il_priv *il, struct ieee80211_sta_ht_cap *ht_cap)
 {
 	if (!il->ht.enabled || !il->ht.is_40mhz)
 		return false;
@@ -3615,13 +3603,13 @@ il_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
 }
 
 int
-il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
+il_send_rxon_timing(struct il_priv *il)
 {
 	u64 tsf;
 	s32 interval_tm, rem;
 	struct ieee80211_conf *conf = NULL;
 	u16 beacon_int;
-	struct ieee80211_vif *vif = ctx->vif;
+	struct ieee80211_vif *vif = il->vif;
 
 	conf = &il->hw->conf;
 
@@ -3664,8 +3652,7 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 EXPORT_SYMBOL(il_send_rxon_timing);
 
 void
-il_set_rxon_hwcrypto(struct il_priv *il, struct il_rxon_context *ctx,
-		     int hw_decrypt)
+il_set_rxon_hwcrypto(struct il_priv *il, int hw_decrypt)
 {
 	struct il_rxon_cmd *rxon = &il->staging;
 
@@ -3679,7 +3666,7 @@ EXPORT_SYMBOL(il_set_rxon_hwcrypto);
 
 /* validate RXON structure is valid */
 int
-il_check_rxon_cmd(struct il_priv *il, struct il_rxon_context *ctx)
+il_check_rxon_cmd(struct il_priv *il)
 {
 	struct il_rxon_cmd *rxon = &il->staging;
 	bool error = false;
@@ -3759,7 +3746,7 @@ EXPORT_SYMBOL(il_check_rxon_cmd);
  * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
 int
-il_full_rxon_required(struct il_priv *il, struct il_rxon_context *ctx)
+il_full_rxon_required(struct il_priv *il)
 {
 	const struct il_rxon_cmd *staging = &il->staging;
 	const struct il_rxon_cmd *active = &il->active;
@@ -3813,7 +3800,7 @@ il_full_rxon_required(struct il_priv *il, struct il_rxon_context *ctx)
 EXPORT_SYMBOL(il_full_rxon_required);
 
 u8
-il_get_lowest_plcp(struct il_priv *il, struct il_rxon_context *ctx)
+il_get_lowest_plcp(struct il_priv *il)
 {
 	/*
 	 * Assign the lowest rate -- should really get this from
@@ -3827,8 +3814,7 @@ il_get_lowest_plcp(struct il_priv *il, struct il_rxon_context *ctx)
 EXPORT_SYMBOL(il_get_lowest_plcp);
 
 static void
-_il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
-		struct il_rxon_context *ctx)
+_il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf)
 {
 	struct il_rxon_cmd *rxon = &il->staging;
 
@@ -3848,7 +3834,7 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 	/* clear the HT channel mode before set the mode */
 	rxon->flags &=
 	    ~(RXON_FLG_CHANNEL_MODE_MSK | RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
-	if (il_is_ht40_tx_allowed(il, ctx, NULL)) {
+	if (il_is_ht40_tx_allowed(il, NULL)) {
 		/* pure ht40 */
 		if (il->ht.protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
 			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
@@ -3886,7 +3872,7 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 	}
 
 	if (il->cfg->ops->hcmd->set_rxon_chain)
-		il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
+		il->cfg->ops->hcmd->set_rxon_chain(il);
 
 	D_ASSOC("rxon flags 0x%X operation mode :0x%X "
 		"extension channel offset 0x%x\n", le32_to_cpu(rxon->flags),
@@ -3896,7 +3882,7 @@ _il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf,
 void
 il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf)
 {
-	_il_set_rxon_ht(il, ht_conf, &il->ctx);
+	_il_set_rxon_ht(il, ht_conf);
 }
 EXPORT_SYMBOL(il_set_rxon_ht);
 
@@ -3939,8 +3925,7 @@ EXPORT_SYMBOL(il_get_single_channel_number);
  * in the staging RXON flag structure based on the ch->band
  */
 int
-il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch,
-		    struct il_rxon_context *ctx)
+il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch)
 {
 	enum ieee80211_band band = ch->band;
 	u16 channel = ch->hw_value;
@@ -3963,8 +3948,8 @@ il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch,
 EXPORT_SYMBOL(il_set_rxon_channel);
 
 void
-il_set_flags_for_band(struct il_priv *il, struct il_rxon_context *ctx,
-		      enum ieee80211_band band, struct ieee80211_vif *vif)
+il_set_flags_for_band(struct il_priv *il, enum ieee80211_band band,
+		      struct ieee80211_vif *vif)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
 		il->staging.flags &=
@@ -3989,35 +3974,26 @@ EXPORT_SYMBOL(il_set_flags_for_band);
  * initialize rxon structure with default values from eeprom
  */
 void
-il_connection_init_rx_config(struct il_priv *il, struct il_rxon_context *ctx)
+il_connection_init_rx_config(struct il_priv *il)
 {
 	const struct il_channel_info *ch_info;
 
 	memset(&il->staging, 0, sizeof(il->staging));
 
-	if (!ctx->vif) {
+	if (!il->vif) {
 		il->staging.dev_type = RXON_DEV_TYPE_ESS;
-	} else
-		switch (ctx->vif->type) {
-
-		case NL80211_IFTYPE_STATION:
-			il->staging.dev_type = RXON_DEV_TYPE_ESS;
-			il->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
-			break;
-
-		case NL80211_IFTYPE_ADHOC:
-			il->staging.dev_type = RXON_DEV_TYPE_IBSS;
-			il->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
-			il->staging.filter_flags =
-			    RXON_FILTER_BCON_AWARE_MSK |
-			    RXON_FILTER_ACCEPT_GRP_MSK;
-			break;
-
-		default:
-			IL_ERR("Unsupported interface type %d\n",
-			       ctx->vif->type);
-			break;
-		}
+	} else if (il->vif->type == NL80211_IFTYPE_STATION) {
+		il->staging.dev_type = RXON_DEV_TYPE_ESS;
+		il->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
+	} else if (il->vif->type == NL80211_IFTYPE_ADHOC) {
+		il->staging.dev_type = RXON_DEV_TYPE_IBSS;
+		il->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
+		il->staging.filter_flags =
+		    RXON_FILTER_BCON_AWARE_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
+	} else {
+		IL_ERR("Unsupported interface type %d\n", il->vif->type);
+		return;
+	}
 
 #if 0
 	/* TODO:  Figure out when short_preamble would be set and cache from
@@ -4037,7 +4013,7 @@ il_connection_init_rx_config(struct il_priv *il, struct il_rxon_context *ctx)
 	il->staging.channel = cpu_to_le16(ch_info->channel);
 	il->band = ch_info->band;
 
-	il_set_flags_for_band(il, ctx, il->band, ctx->vif);
+	il_set_flags_for_band(il, il->band, il->vif);
 
 	il->staging.ofdm_basic_rates =
 	    (IL_OFDM_RATES_MASK >> IL_FIRST_OFDM_RATE) & 0xFF;
@@ -4047,8 +4023,8 @@ il_connection_init_rx_config(struct il_priv *il, struct il_rxon_context *ctx)
 	/* clear both MIX and PURE40 mode flag */
 	il->staging.flags &=
 	    ~(RXON_FLG_CHANNEL_MODE_MIXED | RXON_FLG_CHANNEL_MODE_PURE_40);
-	if (ctx->vif)
-		memcpy(il->staging.node_addr, ctx->vif->addr, ETH_ALEN);
+	if (il->vif)
+		memcpy(il->staging.node_addr, il->vif->addr, ETH_ALEN);
 
 	il->staging.ofdm_ht_single_stream_basic_rates = 0xff;
 	il->staging.ofdm_ht_dual_stream_basic_rates = 0xff;
@@ -4089,13 +4065,11 @@ EXPORT_SYMBOL(il_set_rate);
 void
 il_chswitch_done(struct il_priv *il, bool is_success)
 {
-	struct il_rxon_context *ctx = &il->ctx;
-
 	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
 	if (test_and_clear_bit(S_CHANNEL_SWITCH_PENDING, &il->status))
-		ieee80211_chswitch_done(ctx->vif, is_success);
+		ieee80211_chswitch_done(il->vif, is_success);
 }
 EXPORT_SYMBOL(il_chswitch_done);
 
@@ -4124,7 +4098,7 @@ EXPORT_SYMBOL(il_hdl_csa);
 
 #ifdef CONFIG_IWLEGACY_DEBUG
 void
-il_print_rx_config_cmd(struct il_priv *il, struct il_rxon_context *ctx)
+il_print_rx_config_cmd(struct il_priv *il)
 {
 	struct il_rxon_cmd *rxon = &il->staging;
 
@@ -4161,7 +4135,7 @@ il_irq_handle_error(struct il_priv *il)
 		il->cfg->ops->lib->dump_fh(il, NULL, false);
 #ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_FW_ERRORS)
-		il_print_rx_config_cmd(il, &il->ctx);
+		il_print_rx_config_cmd(il);
 #endif
 
 	wake_up(&il->wait_command_queue);
@@ -4523,21 +4497,20 @@ il_mac_tx_last_beacon(struct ieee80211_hw *hw)
 EXPORT_SYMBOL_GPL(il_mac_tx_last_beacon);
 
 static int
-il_set_mode(struct il_priv *il, struct il_rxon_context *ctx)
+il_set_mode(struct il_priv *il)
 {
-	il_connection_init_rx_config(il, ctx);
+	il_connection_init_rx_config(il);
 
 	if (il->cfg->ops->hcmd->set_rxon_chain)
-		il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
+		il->cfg->ops->hcmd->set_rxon_chain(il);
 
-	return il_commit_rxon(il, ctx);
+	return il_commit_rxon(il);
 }
 
 int
 il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct il_priv *il = hw->priv;
-	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
 	int err;
 
 	D_MAC80211("enter: type %d, addr %pM\n", vif->type, vif->addr);
@@ -4550,18 +4523,17 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out;
 	}
 
-	if (il->ctx.vif) {
+	if (il->vif) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	vif_priv->ctx = &il->ctx;
-	il->ctx.vif = vif;
+	il->vif = vif;
 	il->iw_mode = vif->type;
 
-	err = il_set_mode(il, &il->ctx);
+	err = il_set_mode(il);
 	if (err) {
-		il->ctx.vif = NULL;
+		il->vif = NULL;
 		il->iw_mode = NL80211_IFTYPE_STATION;
 	}
 
@@ -4577,8 +4549,6 @@ static void
 il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif,
 		      bool mode_change)
 {
-	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
-
 	lockdep_assert_held(&il->mutex);
 
 	if (il->scan_vif == vif) {
@@ -4587,7 +4557,7 @@ il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif,
 	}
 
 	if (!mode_change)
-		il_set_mode(il, ctx);
+		il_set_mode(il);
 
 }
 
@@ -4595,14 +4565,13 @@ void
 il_mac_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct il_priv *il = hw->priv;
-	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
 
 	D_MAC80211("enter\n");
 
 	mutex_lock(&il->mutex);
 
-	WARN_ON(ctx->vif != vif);
-	ctx->vif = NULL;
+	WARN_ON(il->vif != vif);
+	il->vif = NULL;
 
 	il_teardown_interface(il, vif, false);
 
@@ -4941,7 +4910,6 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum nl80211_iftype newtype, bool newp2p)
 {
 	struct il_priv *il = hw->priv;
-	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
 	int err;
 
 	if (newp2p)
@@ -4949,7 +4917,7 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&il->mutex);
 
-	if (!ctx->vif || !il_is_ready_rf(il)) {
+	if (!il->vif || !il_is_ready_rf(il)) {
 		/*
 		 * Huh? But wait ... this can maybe happen when
 		 * we're in the middle of a firmware restart!
@@ -4962,7 +4930,7 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	il_teardown_interface(il, vif, true);
 	vif->type = newtype;
 	vif->p2p = false;
-	err = il_set_mode(il, ctx);
+	err = il_set_mode(il);
 	WARN_ON(err);
 	/*
 	 * We've switched internally, but submitting to the
@@ -5194,7 +5162,7 @@ EXPORT_SYMBOL(il_pm_ops);
 #endif /* CONFIG_PM */
 
 static void
-il_update_qos(struct il_priv *il, struct il_rxon_context *ctx)
+il_update_qos(struct il_priv *il)
 {
 	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
@@ -5226,7 +5194,6 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = conf->channel;
 	struct il_ht_config *ht_conf = &il->current_ht_config;
-	struct il_rxon_context *ctx = &il->ctx;
 	unsigned long flags = 0;
 	int ret = 0;
 	u16 ch;
@@ -5259,7 +5226,7 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		 * configured.
 		 */
 		if (il->cfg->ops->hcmd->set_rxon_chain)
-			il->cfg->ops->hcmd->set_rxon_chain(il, &il->ctx);
+			il->cfg->ops->hcmd->set_rxon_chain(il);
 	}
 
 	/* during scanning mac80211 will delay channel setting until
@@ -5321,10 +5288,10 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		if ((le16_to_cpu(il->staging.channel) != ch))
 			il->staging.flags = 0;
 
-		il_set_rxon_channel(il, channel, ctx);
+		il_set_rxon_channel(il, channel);
 		il_set_rxon_ht(il, ht_conf);
 
-		il_set_flags_for_band(il, ctx, channel->band, ctx->vif);
+		il_set_flags_for_band(il, channel->band, il->vif);
 
 		spin_unlock_irqrestore(&il->lock, flags);
 
@@ -5360,11 +5327,11 @@ set_ch_out:
 		goto out;
 
 	if (memcmp(&il->active, &il->staging, sizeof(il->staging)))
-		il_commit_rxon(il, ctx);
+		il_commit_rxon(il);
 	else
 		D_INFO("Not re-sending same RXON configuration.\n");
 	if (ht_changed)
-		il_update_qos(il, ctx);
+		il_update_qos(il);
 
 out:
 	D_MAC80211("leave\n");
@@ -5378,7 +5345,6 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct il_priv *il = hw->priv;
 	unsigned long flags;
-	struct il_rxon_context *ctx = &il->ctx;
 
 	if (WARN_ON(!il->cfg->ops->legacy))
 		return;
@@ -5413,7 +5379,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
 	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	il_commit_rxon(il, ctx);
+	il_commit_rxon(il);
 
 	il_set_rate(il);
 
@@ -5486,8 +5452,6 @@ il_ht_conf(struct il_priv *il, struct ieee80211_vif *vif)
 static inline void
 il_set_no_assoc(struct il_priv *il, struct ieee80211_vif *vif)
 {
-	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
-
 	/*
 	 * inform the ucode that there is no longer an
 	 * association and that no more packets should be
@@ -5495,7 +5459,7 @@ il_set_no_assoc(struct il_priv *il, struct ieee80211_vif *vif)
 	 */
 	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	il->staging.assoc_id = 0;
-	il_commit_rxon(il, ctx);
+	il_commit_rxon(il);
 }
 
 static void
@@ -5513,8 +5477,8 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&il->mutex);
 
-	if (!il->beacon_ctx) {
-		IL_ERR("update beacon but no beacon context!\n");
+	if (!il->beacon_enabled) {
+		IL_ERR("update beacon with no beaconing enabled\n");
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -5545,7 +5509,6 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *bss_conf, u32 changes)
 {
 	struct il_priv *il = hw->priv;
-	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
 	int ret;
 
 	if (WARN_ON(!il->cfg->ops->legacy))
@@ -5565,20 +5528,16 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 		spin_lock_irqsave(&il->lock, flags);
 		il->qos_data.qos_active = bss_conf->qos;
-		il_update_qos(il, ctx);
+		il_update_qos(il);
 		spin_unlock_irqrestore(&il->lock, flags);
 	}
 
 	if (changes & BSS_CHANGED_BEACON_ENABLED) {
-		/*
-		 * the add_interface code must make sure we only ever
-		 * have a single interface that could be beaconing at
-		 * any time.
-		 */
+		/* FIXME: can we remove beacon_enabled ? */
 		if (vif->bss_conf.enable_beacon)
-			il->beacon_ctx = ctx;
+			il->beacon_enabled = true;
 		else
-			il->beacon_ctx = NULL;
+			il->beacon_enabled = false;
 	}
 
 	if (changes & BSS_CHANGED_BSSID) {
@@ -5658,7 +5617,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		il_ht_conf(il, vif);
 
 		if (il->cfg->ops->hcmd->set_rxon_chain)
-			il->cfg->ops->hcmd->set_rxon_chain(il, ctx);
+			il->cfg->ops->hcmd->set_rxon_chain(il);
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
@@ -5674,7 +5633,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	if (changes && il_is_associated(il) && bss_conf->aid) {
 		D_MAC80211("Changes (%#x) while associated\n", changes);
-		ret = il_send_rxon_assoc(il, ctx);
+		ret = il_send_rxon_assoc(il);
 		if (!ret) {
 			/* Sync active_rxon with latest change. */
 			memcpy((void *)&il->active, &il->staging,
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 51c1eec..746eec0 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -146,7 +146,6 @@ struct il_queue {
 /* One for each TFD */
 struct il_tx_info {
 	struct sk_buff *skb;
-	struct il_rxon_context *ctx;
 };
 
 /**
@@ -741,7 +740,6 @@ struct il_station_entry {
 };
 
 struct il_station_priv_common {
-	struct il_rxon_context *ctx;
 	u8 sta_id;
 };
 
@@ -752,7 +750,6 @@ struct il_station_priv_common {
  * space for us to put data into.
  */
 struct il_vif_priv {
-	struct il_rxon_context *ctx;
 	u8 ibss_bssid_sta_id;
 };
 
@@ -1257,7 +1254,7 @@ struct il_priv {
 	u8 ucode_write_complete;	/* the image write is complete */
 	char firmware_name[25];
 
-	struct il_rxon_context ctx;
+	struct ieee80211_vif *vif;
 
 	struct il_qos_info qos_data;
 
@@ -1426,7 +1423,7 @@ struct il_priv {
 	struct work_struct rx_replenish;
 	struct work_struct abort_scan;
 
-	struct il_rxon_context *beacon_ctx;
+	bool beacon_enabled;
 	struct sk_buff *beacon_skb;
 
 	struct work_struct tx_flush;
@@ -1493,17 +1490,6 @@ il_tx_queue_get_hdr(struct il_priv *il, int txq_id, int idx)
 	return NULL;
 }
 
-static inline struct il_rxon_context *
-il_rxon_ctx_from_vif(struct ieee80211_vif *vif)
-{
-	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
-
-	return vif_priv->ctx;
-}
-
-#define for_each_context(il, _ctx) \
-	for (_ctx = &il->ctx; _ctx == &il->ctx; _ctx++)
-
 static inline int
 il_is_associated(struct il_priv *il)
 {
@@ -1585,10 +1571,9 @@ il_free_pages(struct il_priv *il, unsigned long page)
 #define IL_RX_BUF_SIZE_8K (8 * 1024)
 
 struct il_hcmd_ops {
-	int (*rxon_assoc) (struct il_priv *il, struct il_rxon_context *ctx);
-	int (*commit_rxon) (struct il_priv *il, struct il_rxon_context *ctx);
-	void (*set_rxon_chain) (struct il_priv *il,
-				struct il_rxon_context *ctx);
+	int (*rxon_assoc) (struct il_priv *il);
+	int (*commit_rxon) (struct il_priv *il);
+	void (*set_rxon_chain) (struct il_priv *il);
 };
 
 struct il_hcmd_utils_ops {
@@ -1811,20 +1796,17 @@ int il_mac_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params);
 int il_mac_tx_last_beacon(struct ieee80211_hw *hw);
 
-void il_set_rxon_hwcrypto(struct il_priv *il, struct il_rxon_context *ctx,
-			  int hw_decrypt);
-int il_check_rxon_cmd(struct il_priv *il, struct il_rxon_context *ctx);
-int il_full_rxon_required(struct il_priv *il, struct il_rxon_context *ctx);
-int il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch,
-			struct il_rxon_context *ctx);
-void il_set_flags_for_band(struct il_priv *il, struct il_rxon_context *ctx,
-			   enum ieee80211_band band, struct ieee80211_vif *vif);
+void il_set_rxon_hwcrypto(struct il_priv *il, int hw_decrypt);
+int il_check_rxon_cmd(struct il_priv *il);
+int il_full_rxon_required(struct il_priv *il);
+int il_set_rxon_channel(struct il_priv *il, struct ieee80211_channel *ch);
+void il_set_flags_for_band(struct il_priv *il, enum ieee80211_band band,
+			   struct ieee80211_vif *vif);
 u8 il_get_single_channel_number(struct il_priv *il, enum ieee80211_band band);
 void il_set_rxon_ht(struct il_priv *il, struct il_ht_config *ht_conf);
-bool il_is_ht40_tx_allowed(struct il_priv *il, struct il_rxon_context *ctx,
+bool il_is_ht40_tx_allowed(struct il_priv *il,
 			   struct ieee80211_sta_ht_cap *ht_cap);
-void il_connection_init_rx_config(struct il_priv *il,
-				  struct il_rxon_context *ctx);
+void il_connection_init_rx_config(struct il_priv *il);
 void il_set_rate(struct il_priv *il);
 int il_set_decrypted_flag(struct il_priv *il, struct ieee80211_hdr *hdr,
 			  u32 decrypt_res, struct ieee80211_rx_status *stats);
@@ -1927,7 +1909,7 @@ int il_set_tx_power(struct il_priv *il, s8 tx_power, bool force);
  * Rate
  ******************************************************************************/
 
-u8 il_get_lowest_plcp(struct il_priv *il, struct il_rxon_context *ctx);
+u8 il_get_lowest_plcp(struct il_priv *il);
 
 /*******************************************************************************
  * Scanning
@@ -2014,10 +1996,10 @@ extern const struct dev_pm_ops il_pm_ops;
 ******************************************************/
 void il4965_dump_nic_error_log(struct il_priv *il);
 #ifdef CONFIG_IWLEGACY_DEBUG
-void il_print_rx_config_cmd(struct il_priv *il, struct il_rxon_context *ctx);
+void il_print_rx_config_cmd(struct il_priv *il);
 #else
 static inline void
-il_print_rx_config_cmd(struct il_priv *il, struct il_rxon_context *ctx)
+il_print_rx_config_cmd(struct il_priv *il)
 {
 }
 #endif
@@ -2106,17 +2088,18 @@ extern int il_send_stats_request(struct il_priv *il, u8 flags, bool clear);
 void il_apm_stop(struct il_priv *il);
 int il_apm_init(struct il_priv *il);
 
-int il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx);
+int il_send_rxon_timing(struct il_priv *il);
+
 static inline int
-il_send_rxon_assoc(struct il_priv *il, struct il_rxon_context *ctx)
+il_send_rxon_assoc(struct il_priv *il)
 {
-	return il->cfg->ops->hcmd->rxon_assoc(il, ctx);
+	return il->cfg->ops->hcmd->rxon_assoc(il);
 }
 
 static inline int
-il_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
+il_commit_rxon(struct il_priv *il)
 {
-	return il->cfg->ops->hcmd->commit_rxon(il, ctx);
+	return il->cfg->ops->hcmd->commit_rxon(il);
 }
 
 static inline const struct ieee80211_supported_band *
@@ -2274,23 +2257,22 @@ il_clear_bits_prph(struct il_priv *il, u32 reg, u32 mask)
 				   (this is for the IBSS BSSID stations) */
 #define IL_STA_BCAST BIT(4)	/* this station is the special bcast station */
 
-void il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx);
-void il_clear_ucode_stations(struct il_priv *il, struct il_rxon_context *ctx);
+void il_restore_stations(struct il_priv *il);
+void il_clear_ucode_stations(struct il_priv *il);
 void il_dealloc_bcast_stations(struct il_priv *il);
 int il_get_free_ucode_key_idx(struct il_priv *il);
 int il_send_add_sta(struct il_priv *il, struct il_addsta_cmd *sta, u8 flags);
-int il_add_station_common(struct il_priv *il, struct il_rxon_context *ctx,
-			  const u8 *addr, bool is_ap,
+int il_add_station_common(struct il_priv *il, const u8 *addr, bool is_ap,
 			  struct ieee80211_sta *sta, u8 *sta_id_r);
 int il_remove_station(struct il_priv *il, const u8 sta_id, const u8 * addr);
 int il_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
 
-u8 il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
-		   const u8 *addr, bool is_ap, struct ieee80211_sta *sta);
+u8 il_prep_station(struct il_priv *il, const u8 *addr, bool is_ap,
+		   struct ieee80211_sta *sta);
 
-int il_send_lq_cmd(struct il_priv *il, struct il_rxon_context *ctx,
-		   struct il_link_quality_cmd *lq, u8 flags, bool init);
+int il_send_lq_cmd(struct il_priv *il, struct il_link_quality_cmd *lq,
+		   u8 flags, bool init);
 
 /**
  * il_clear_driver_stations - clear knowledge of all stations from driver
@@ -2334,8 +2316,7 @@ il_sta_id(struct ieee80211_sta *sta)
  * inline wraps that pattern.
  */
 static inline int
-il_sta_id_or_broadcast(struct il_priv *il, struct il_rxon_context *context,
-		       struct ieee80211_sta *sta)
+il_sta_id_or_broadcast(struct il_priv *il, struct ieee80211_sta *sta)
 {
 	int sta_id;
 
-- 
1.7.1

