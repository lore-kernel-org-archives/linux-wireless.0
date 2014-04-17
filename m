Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:36021 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaDQN1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 09:27:49 -0400
Received: by mail-pb0-f43.google.com with SMTP id um1so379057pbc.30
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 06:27:48 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/6] mac80211_hwsim: replace wiphy_debug() with wiphy_dbg()
Date: Thu, 17 Apr 2014 21:27:10 +0800
Message-Id: <e4834b59cf973c1ce4182103e1186ff7070db4d5.1397741141.git.gamerh2o@gmail.com> (sfid-20140417_152752_180019_8919893A)
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dynamic debug function wiphy_dbg() is more convenient for debugging,
and if user doesn't enable CONFIG_DYNAMIC_DEBUG, it will fall back to
normal static debug, just as what wiphy_debug() does.

When all the users of wiphy_debug() are gone, wiphy_debug() can be
removed.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 168 +++++++++++++++++-----------------
 1 file changed, 84 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9d7a52f..5fc0683 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -513,9 +513,9 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
 	if (!vp->assoc)
 		return;
 
-	wiphy_debug(data->hw->wiphy,
-		    "%s: send PS-Poll to %pM for aid %d\n",
-		    __func__, vp->bssid, vp->aid);
+	wiphy_dbg(data->hw->wiphy,
+		  "%s: send PS-Poll to %pM for aid %d\n",
+		  __func__, vp->bssid, vp->aid);
 
 	skb = dev_alloc_skb(sizeof(*pspoll));
 	if (!skb)
@@ -544,9 +544,9 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	if (!vp->assoc)
 		return;
 
-	wiphy_debug(data->hw->wiphy,
-		    "%s: send data::nullfunc to %pM ps=%d\n",
-		    __func__, vp->bssid, ps);
+	wiphy_dbg(data->hw->wiphy,
+		  "%s: send data::nullfunc to %pM ps=%d\n",
+		  __func__, vp->bssid, ps);
 
 	skb = dev_alloc_skb(sizeof(*hdr));
 	if (!skb)
@@ -1107,7 +1107,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	}
 
 	if (data->idle && !data->tmp_chan) {
-		wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
+		wiphy_dbg(hw->wiphy, "Trying to TX when idle - reject\n");
 		ieee80211_free_txskb(hw, skb);
 		return;
 	}
@@ -1154,7 +1154,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
-	wiphy_debug(hw->wiphy, "%s\n", __func__);
+	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 	data->started = true;
 	return 0;
 }
@@ -1165,16 +1165,16 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = false;
 	tasklet_hrtimer_cancel(&data->beacon_timer);
-	wiphy_debug(hw->wiphy, "%s\n", __func__);
+	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 }
 
 
 static int mac80211_hwsim_add_interface(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif)
 {
-	wiphy_debug(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
-		    __func__, ieee80211_vif_type_p2p(vif),
-		    vif->addr);
+	wiphy_dbg(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
+		  __func__, ieee80211_vif_type_p2p(vif),
+		  vif->addr);
 	hwsim_set_magic(vif);
 
 	vif->cab_queue = 0;
@@ -1193,10 +1193,10 @@ static int mac80211_hwsim_change_interface(struct ieee80211_hw *hw,
 					   bool newp2p)
 {
 	newtype = ieee80211_iftype_p2p(newtype, newp2p);
-	wiphy_debug(hw->wiphy,
-		    "%s (old type=%d, new type=%d, mac_addr=%pM)\n",
-		    __func__, ieee80211_vif_type_p2p(vif),
-		    newtype, vif->addr);
+	wiphy_dbg(hw->wiphy,
+		  "%s (old type=%d, new type=%d, mac_addr=%pM)\n",
+		  __func__, ieee80211_vif_type_p2p(vif),
+		  newtype, vif->addr);
 	hwsim_check_magic(vif);
 
 	/*
@@ -1211,9 +1211,9 @@ static int mac80211_hwsim_change_interface(struct ieee80211_hw *hw,
 static void mac80211_hwsim_remove_interface(
 	struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	wiphy_debug(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
-		    __func__, ieee80211_vif_type_p2p(vif),
-		    vif->addr);
+	wiphy_dbg(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
+		  __func__, ieee80211_vif_type_p2p(vif),
+		  vif->addr);
 	hwsim_check_magic(vif);
 	hwsim_clear_magic(vif);
 }
@@ -1333,23 +1333,23 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	};
 
 	if (conf->chandef.chan)
-		wiphy_debug(hw->wiphy,
-			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
-			    __func__,
-			    conf->chandef.chan->center_freq,
-			    conf->chandef.center_freq1,
-			    conf->chandef.center_freq2,
-			    hwsim_chanwidths[conf->chandef.width],
-			    !!(conf->flags & IEEE80211_CONF_IDLE),
-			    !!(conf->flags & IEEE80211_CONF_PS),
-			    smps_modes[conf->smps_mode]);
+		wiphy_dbg(hw->wiphy,
+			  "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
+			  __func__,
+			  conf->chandef.chan->center_freq,
+			  conf->chandef.center_freq1,
+			  conf->chandef.center_freq2,
+			  hwsim_chanwidths[conf->chandef.width],
+			  !!(conf->flags & IEEE80211_CONF_IDLE),
+			  !!(conf->flags & IEEE80211_CONF_PS),
+			  smps_modes[conf->smps_mode]);
 	else
-		wiphy_debug(hw->wiphy,
-			    "%s (freq=0 idle=%d ps=%d smps=%s)\n",
-			    __func__,
-			    !!(conf->flags & IEEE80211_CONF_IDLE),
-			    !!(conf->flags & IEEE80211_CONF_PS),
-			    smps_modes[conf->smps_mode]);
+		wiphy_dbg(hw->wiphy,
+			  "%s (freq=0 idle=%d ps=%d smps=%s)\n",
+			  __func__,
+			  !!(conf->flags & IEEE80211_CONF_IDLE),
+			  !!(conf->flags & IEEE80211_CONF_PS),
+			  smps_modes[conf->smps_mode]);
 
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
@@ -1380,7 +1380,7 @@ static void mac80211_hwsim_configure_filter(struct ieee80211_hw *hw,
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 
-	wiphy_debug(hw->wiphy, "%s\n", __func__);
+	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 
 	data->rx_filter = 0;
 	if (*total_flags & FIF_PROMISC_IN_BSS)
@@ -1411,29 +1411,29 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 
 	hwsim_check_magic(vif);
 
-	wiphy_debug(hw->wiphy, "%s(changed=0x%x vif->addr=%pM)\n",
-		    __func__, changed, vif->addr);
+	wiphy_dbg(hw->wiphy, "%s(changed=0x%x vif->addr=%pM)\n",
+		  __func__, changed, vif->addr);
 
 	if (changed & BSS_CHANGED_BSSID) {
-		wiphy_debug(hw->wiphy, "%s: BSSID changed: %pM\n",
-			    __func__, info->bssid);
+		wiphy_dbg(hw->wiphy, "%s: BSSID changed: %pM\n",
+			  __func__, info->bssid);
 		memcpy(vp->bssid, info->bssid, ETH_ALEN);
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		wiphy_debug(hw->wiphy, "  ASSOC: assoc=%d aid=%d\n",
-			    info->assoc, info->aid);
+		wiphy_dbg(hw->wiphy, "  ASSOC: assoc=%d aid=%d\n",
+			  info->assoc, info->aid);
 		vp->assoc = info->assoc;
 		vp->aid = info->aid;
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
-		wiphy_debug(hw->wiphy, "  BCNINT: %d\n", info->beacon_int);
+		wiphy_dbg(hw->wiphy, "  BCNINT: %d\n", info->beacon_int);
 		data->beacon_int = info->beacon_int * 1024;
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		wiphy_debug(hw->wiphy, "  BCN EN: %d\n", info->enable_beacon);
+		wiphy_dbg(hw->wiphy, "  BCN EN: %d\n", info->enable_beacon);
 		vp->bcn_en = info->enable_beacon;
 		if (data->started &&
 		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
@@ -1453,39 +1453,39 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			ieee80211_iterate_active_interfaces_atomic(
 				data->hw, IEEE80211_IFACE_ITER_NORMAL,
 				mac80211_hwsim_bcn_en_iter, &count);
-			wiphy_debug(hw->wiphy, "  beaconing vifs remaining: %u",
-				    count);
+			wiphy_dbg(hw->wiphy, "  beaconing vifs remaining: %u",
+				  count);
 			if (count == 0)
 				tasklet_hrtimer_cancel(&data->beacon_timer);
 		}
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		wiphy_debug(hw->wiphy, "  ERP_CTS_PROT: %d\n",
-			    info->use_cts_prot);
+		wiphy_dbg(hw->wiphy, "  ERP_CTS_PROT: %d\n",
+			  info->use_cts_prot);
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		wiphy_debug(hw->wiphy, "  ERP_PREAMBLE: %d\n",
-			    info->use_short_preamble);
+		wiphy_dbg(hw->wiphy, "  ERP_PREAMBLE: %d\n",
+			  info->use_short_preamble);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-		wiphy_debug(hw->wiphy, "  ERP_SLOT: %d\n", info->use_short_slot);
+		wiphy_dbg(hw->wiphy, "  ERP_SLOT: %d\n", info->use_short_slot);
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		wiphy_debug(hw->wiphy, "  HT: op_mode=0x%x\n",
-			    info->ht_operation_mode);
+		wiphy_dbg(hw->wiphy, "  HT: op_mode=0x%x\n",
+			  info->ht_operation_mode);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		wiphy_debug(hw->wiphy, "  BASIC_RATES: 0x%llx\n",
-			    (unsigned long long) info->basic_rates);
+		wiphy_dbg(hw->wiphy, "  BASIC_RATES: 0x%llx\n",
+			  (unsigned long long) info->basic_rates);
 	}
 
 	if (changed & BSS_CHANGED_TXPOWER)
-		wiphy_debug(hw->wiphy, "  TX Power: %d dBm\n", info->txpower);
+		wiphy_dbg(hw->wiphy, "  TX Power: %d dBm\n", info->txpower);
 }
 
 static int mac80211_hwsim_sta_add(struct ieee80211_hw *hw,
@@ -1539,11 +1539,11 @@ static int mac80211_hwsim_conf_tx(
 	struct ieee80211_vif *vif, u16 queue,
 	const struct ieee80211_tx_queue_params *params)
 {
-	wiphy_debug(hw->wiphy,
-		    "%s (queue=%d txop=%d cw_min=%d cw_max=%d aifs=%d)\n",
-		    __func__, queue,
-		    params->txop, params->cw_min,
-		    params->cw_max, params->aifs);
+	wiphy_dbg(hw->wiphy,
+		  "%s (queue=%d txop=%d cw_min=%d cw_max=%d aifs=%d)\n",
+		  __func__, queue,
+		  params->txop, params->cw_min,
+		  params->cw_max, params->aifs);
 	return 0;
 }
 
@@ -1553,7 +1553,7 @@ static int mac80211_hwsim_get_survey(
 {
 	struct ieee80211_conf *conf = &hw->conf;
 
-	wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
+	wiphy_dbg(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
 
 	if (idx != 0)
 		return -ENOENT;
@@ -1690,7 +1690,7 @@ static void hw_scan_work(struct work_struct *work)
 
 	mutex_lock(&hwsim->mutex);
 	if (hwsim->scan_chan_idx >= req->n_channels) {
-		wiphy_debug(hwsim->hw->wiphy, "hw scan complete\n");
+		wiphy_dbg(hwsim->hw->wiphy, "hw scan complete\n");
 		ieee80211_scan_completed(hwsim->hw, false);
 		hwsim->hw_scan_request = NULL;
 		hwsim->hw_scan_vif = NULL;
@@ -1699,8 +1699,8 @@ static void hw_scan_work(struct work_struct *work)
 		return;
 	}
 
-	wiphy_debug(hwsim->hw->wiphy, "hw scan %d MHz\n",
-		    req->channels[hwsim->scan_chan_idx]->center_freq);
+	wiphy_dbg(hwsim->hw->wiphy, "hw scan %d MHz\n",
+		  req->channels[hwsim->scan_chan_idx]->center_freq);
 
 	hwsim->tmp_chan = req->channels[hwsim->scan_chan_idx];
 	if (hwsim->tmp_chan->flags & IEEE80211_CHAN_NO_IR ||
@@ -1752,7 +1752,7 @@ static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 	hwsim->scan_chan_idx = 0;
 	mutex_unlock(&hwsim->mutex);
 
-	wiphy_debug(hw->wiphy, "hwsim hw_scan request\n");
+	wiphy_dbg(hw->wiphy, "hwsim hw_scan request\n");
 
 	ieee80211_queue_delayed_work(hwsim->hw, &hwsim->hw_scan, 0);
 
@@ -1764,7 +1764,7 @@ static void mac80211_hwsim_cancel_hw_scan(struct ieee80211_hw *hw,
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
 
-	wiphy_debug(hw->wiphy, "hwsim cancel_hw_scan\n");
+	wiphy_dbg(hw->wiphy, "hwsim cancel_hw_scan\n");
 
 	cancel_delayed_work_sync(&hwsim->hw_scan);
 
@@ -1816,7 +1816,7 @@ static void hw_roc_done(struct work_struct *work)
 	hwsim->tmp_chan = NULL;
 	mutex_unlock(&hwsim->mutex);
 
-	wiphy_debug(hwsim->hw->wiphy, "hwsim ROC expired\n");
+	wiphy_dbg(hwsim->hw->wiphy, "hwsim ROC expired\n");
 }
 
 static int mac80211_hwsim_roc(struct ieee80211_hw *hw,
@@ -1836,8 +1836,8 @@ static int mac80211_hwsim_roc(struct ieee80211_hw *hw,
 	hwsim->tmp_chan = chan;
 	mutex_unlock(&hwsim->mutex);
 
-	wiphy_debug(hw->wiphy, "hwsim ROC (%d MHz, %d ms)\n",
-		    chan->center_freq, duration);
+	wiphy_dbg(hw->wiphy, "hwsim ROC (%d MHz, %d ms)\n",
+		  chan->center_freq, duration);
 
 	ieee80211_ready_on_channel(hw);
 
@@ -1856,7 +1856,7 @@ static int mac80211_hwsim_croc(struct ieee80211_hw *hw)
 	hwsim->tmp_chan = NULL;
 	mutex_unlock(&hwsim->mutex);
 
-	wiphy_debug(hw->wiphy, "hwsim ROC canceled\n");
+	wiphy_dbg(hw->wiphy, "hwsim ROC canceled\n");
 
 	return 0;
 }
@@ -1865,20 +1865,20 @@ static int mac80211_hwsim_add_chanctx(struct ieee80211_hw *hw,
 				      struct ieee80211_chanctx_conf *ctx)
 {
 	hwsim_set_chanctx_magic(ctx);
-	wiphy_debug(hw->wiphy,
-		    "add channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
-		    ctx->def.chan->center_freq, ctx->def.width,
-		    ctx->def.center_freq1, ctx->def.center_freq2);
+	wiphy_dbg(hw->wiphy,
+		  "add channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
+		  ctx->def.chan->center_freq, ctx->def.width,
+		  ctx->def.center_freq1, ctx->def.center_freq2);
 	return 0;
 }
 
 static void mac80211_hwsim_remove_chanctx(struct ieee80211_hw *hw,
 					  struct ieee80211_chanctx_conf *ctx)
 {
-	wiphy_debug(hw->wiphy,
-		    "remove channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
-		    ctx->def.chan->center_freq, ctx->def.width,
-		    ctx->def.center_freq1, ctx->def.center_freq2);
+	wiphy_dbg(hw->wiphy,
+		  "remove channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
+		  ctx->def.chan->center_freq, ctx->def.width,
+		  ctx->def.center_freq1, ctx->def.center_freq2);
 	hwsim_check_chanctx_magic(ctx);
 	hwsim_clear_chanctx_magic(ctx);
 }
@@ -1888,10 +1888,10 @@ static void mac80211_hwsim_change_chanctx(struct ieee80211_hw *hw,
 					  u32 changed)
 {
 	hwsim_check_chanctx_magic(ctx);
-	wiphy_debug(hw->wiphy,
-		    "change channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
-		    ctx->def.chan->center_freq, ctx->def.width,
-		    ctx->def.center_freq1, ctx->def.center_freq2);
+	wiphy_dbg(hw->wiphy,
+		  "change channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
+		  ctx->def.chan->center_freq, ctx->def.width,
+		  ctx->def.center_freq1, ctx->def.center_freq2);
 }
 
 static int mac80211_hwsim_assign_vif_chanctx(struct ieee80211_hw *hw,
@@ -2153,7 +2153,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		goto failed_hw;
 	}
 
-	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
+	wiphy_dbg(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
 
 	if (reg_alpha2)
 		regulatory_hint(hw->wiphy, reg_alpha2);
-- 
1.9.0

