Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:48227 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751515AbdF1N2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 09:28:10 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] mac80211_hwsim: use dyndbg for debug messages
Date: Wed, 28 Jun 2017 15:17:26 +0200
Message-Id: <20170628131726.15528-1-lkundrak@v3.sk> (sfid-20170628_152839_416866_A87C596C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211_hwsim doesn't offer a way to disable the debugging output.
Unfortunately, it's pretty chatty, dumping a  lot of stuff into the message
buffer.

This patch changes it to use dyndbg for controlling the debug output.
It's disabled by default, but can be enabled by a module parameter (1),
at runtime (2) or persisted in modprobe.conf (3).

  (1) modprobe mac80211_hwsim dyndbg=+p
  (2) echo "module mac80211_hwsim +p" >/sys/kernel/debug/dynamic_debug/control
  (3) echo "options mac80211_hwsim dyndbg=+p" >>/etc/modprobe.d/my.conf

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/mac80211_hwsim.c | 96 +++++++++++++++++------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c854a557998b..8ec4835a623e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -396,7 +396,7 @@ static int mac80211_hwsim_vendor_cmd_test(struct wiphy *wiphy,
 	if (!tb[QCA_WLAN_VENDOR_ATTR_TEST])
 		return -EINVAL;
 	val = nla_get_u32(tb[QCA_WLAN_VENDOR_ATTR_TEST]);
-	wiphy_debug(wiphy, "%s: test=%u\n", __func__, val);
+	wiphy_dbg(wiphy, "%s: test=%u\n", __func__, val);
 
 	/* Send a vendor event as a test. Note that this would not normally be
 	 * done within a command handler, but rather, based on some other
@@ -643,7 +643,7 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
 	if (!vp->assoc)
 		return;
 
-	wiphy_debug(data->hw->wiphy,
+	wiphy_dbg(data->hw->wiphy,
 		    "%s: send PS-Poll to %pM for aid %d\n",
 		    __func__, vp->bssid, vp->aid);
 
@@ -674,7 +674,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	if (!vp->assoc)
 		return;
 
-	wiphy_debug(data->hw->wiphy,
+	wiphy_dbg(data->hw->wiphy,
 		    "%s: send data::nullfunc to %pM ps=%d\n",
 		    __func__, vp->bssid, ps);
 
@@ -1034,7 +1034,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
 			       HWSIM_CMD_FRAME);
 	if (msg_head == NULL) {
-		printk(KERN_DEBUG "mac80211_hwsim: problem with msg_head\n");
+		pr_debug("mac80211_hwsim: problem with msg_head\n");
 		goto nla_put_failure;
 	}
 
@@ -1093,7 +1093,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 nla_put_failure:
 	nlmsg_free(skb);
 err_free_txskb:
-	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
+	pr_debug("mac80211_hwsim: error occurred in %s\n", __func__);
 	ieee80211_free_txskb(hw, my_skb);
 	data->tx_failed++;
 }
@@ -1347,7 +1347,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	}
 
 	if (data->idle && !data->tmp_chan) {
-		wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
+		wiphy_dbg(hw->wiphy, "Trying to TX when idle - reject\n");
 		ieee80211_free_txskb(hw, skb);
 		return;
 	}
@@ -1410,7 +1410,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
-	wiphy_debug(hw->wiphy, "%s\n", __func__);
+	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 	data->started = true;
 	return 0;
 }
@@ -1421,14 +1421,14 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
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
+	wiphy_dbg(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
 		    __func__, ieee80211_vif_type_p2p(vif),
 		    vif->addr);
 	hwsim_set_magic(vif);
@@ -1449,7 +1449,7 @@ static int mac80211_hwsim_change_interface(struct ieee80211_hw *hw,
 					   bool newp2p)
 {
 	newtype = ieee80211_iftype_p2p(newtype, newp2p);
-	wiphy_debug(hw->wiphy,
+	wiphy_dbg(hw->wiphy,
 		    "%s (old type=%d, new type=%d, mac_addr=%pM)\n",
 		    __func__, ieee80211_vif_type_p2p(vif),
 		    newtype, vif->addr);
@@ -1467,7 +1467,7 @@ static int mac80211_hwsim_change_interface(struct ieee80211_hw *hw,
 static void mac80211_hwsim_remove_interface(
 	struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	wiphy_debug(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
+	wiphy_dbg(hw->wiphy, "%s (type=%d mac_addr=%pM)\n",
 		    __func__, ieee80211_vif_type_p2p(vif),
 		    vif->addr);
 	hwsim_check_magic(vif);
@@ -1591,7 +1591,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	int idx;
 
 	if (conf->chandef.chan)
-		wiphy_debug(hw->wiphy,
+		wiphy_dbg(hw->wiphy,
 			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
 			    __func__,
 			    conf->chandef.chan->center_freq,
@@ -1602,7 +1602,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 			    !!(conf->flags & IEEE80211_CONF_PS),
 			    smps_modes[conf->smps_mode]);
 	else
-		wiphy_debug(hw->wiphy,
+		wiphy_dbg(hw->wiphy,
 			    "%s (freq=0 idle=%d ps=%d smps=%s)\n",
 			    __func__,
 			    !!(conf->flags & IEEE80211_CONF_IDLE),
@@ -1661,7 +1661,7 @@ static void mac80211_hwsim_configure_filter(struct ieee80211_hw *hw,
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 
-	wiphy_debug(hw->wiphy, "%s\n", __func__);
+	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 
 	data->rx_filter = 0;
 	if (*total_flags & FIF_ALLMULTI)
@@ -1690,24 +1690,24 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 
 	hwsim_check_magic(vif);
 
-	wiphy_debug(hw->wiphy, "%s(changed=0x%x vif->addr=%pM)\n",
+	wiphy_dbg(hw->wiphy, "%s(changed=0x%x vif->addr=%pM)\n",
 		    __func__, changed, vif->addr);
 
 	if (changed & BSS_CHANGED_BSSID) {
-		wiphy_debug(hw->wiphy, "%s: BSSID changed: %pM\n",
+		wiphy_dbg(hw->wiphy, "%s: BSSID changed: %pM\n",
 			    __func__, info->bssid);
 		memcpy(vp->bssid, info->bssid, ETH_ALEN);
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		wiphy_debug(hw->wiphy, "  ASSOC: assoc=%d aid=%d\n",
+		wiphy_dbg(hw->wiphy, "  ASSOC: assoc=%d aid=%d\n",
 			    info->assoc, info->aid);
 		vp->assoc = info->assoc;
 		vp->aid = info->aid;
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		wiphy_debug(hw->wiphy, "  BCN EN: %d (BI=%u)\n",
+		wiphy_dbg(hw->wiphy, "  BCN EN: %d (BI=%u)\n",
 			    info->enable_beacon, info->beacon_int);
 		vp->bcn_en = info->enable_beacon;
 		if (data->started &&
@@ -1727,7 +1727,7 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			ieee80211_iterate_active_interfaces_atomic(
 				data->hw, IEEE80211_IFACE_ITER_NORMAL,
 				mac80211_hwsim_bcn_en_iter, &count);
-			wiphy_debug(hw->wiphy, "  beaconing vifs remaining: %u",
+			wiphy_dbg(hw->wiphy, "  beaconing vifs remaining: %u",
 				    count);
 			if (count == 0) {
 				tasklet_hrtimer_cancel(&data->beacon_timer);
@@ -1737,31 +1737,31 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		wiphy_debug(hw->wiphy, "  ERP_CTS_PROT: %d\n",
+		wiphy_dbg(hw->wiphy, "  ERP_CTS_PROT: %d\n",
 			    info->use_cts_prot);
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		wiphy_debug(hw->wiphy, "  ERP_PREAMBLE: %d\n",
+		wiphy_dbg(hw->wiphy, "  ERP_PREAMBLE: %d\n",
 			    info->use_short_preamble);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-		wiphy_debug(hw->wiphy, "  ERP_SLOT: %d\n", info->use_short_slot);
+		wiphy_dbg(hw->wiphy, "  ERP_SLOT: %d\n", info->use_short_slot);
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		wiphy_debug(hw->wiphy, "  HT: op_mode=0x%x\n",
+		wiphy_dbg(hw->wiphy, "  HT: op_mode=0x%x\n",
 			    info->ht_operation_mode);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		wiphy_debug(hw->wiphy, "  BASIC_RATES: 0x%llx\n",
+		wiphy_dbg(hw->wiphy, "  BASIC_RATES: 0x%llx\n",
 			    (unsigned long long) info->basic_rates);
 	}
 
 	if (changed & BSS_CHANGED_TXPOWER)
-		wiphy_debug(hw->wiphy, "  TX Power: %d dBm\n", info->txpower);
+		wiphy_dbg(hw->wiphy, "  TX Power: %d dBm\n", info->txpower);
 }
 
 static int mac80211_hwsim_sta_add(struct ieee80211_hw *hw,
@@ -1815,7 +1815,7 @@ static int mac80211_hwsim_conf_tx(
 	struct ieee80211_vif *vif, u16 queue,
 	const struct ieee80211_tx_queue_params *params)
 {
-	wiphy_debug(hw->wiphy,
+	wiphy_dbg(hw->wiphy,
 		    "%s (queue=%d txop=%d cw_min=%d cw_max=%d aifs=%d)\n",
 		    __func__, queue,
 		    params->txop, params->cw_min,
@@ -1983,7 +1983,7 @@ static void hw_scan_work(struct work_struct *work)
 			.aborted = false,
 		};
 
-		wiphy_debug(hwsim->hw->wiphy, "hw scan complete\n");
+		wiphy_dbg(hwsim->hw->wiphy, "hw scan complete\n");
 		ieee80211_scan_completed(hwsim->hw, &info);
 		hwsim->hw_scan_request = NULL;
 		hwsim->hw_scan_vif = NULL;
@@ -1992,7 +1992,7 @@ static void hw_scan_work(struct work_struct *work)
 		return;
 	}
 
-	wiphy_debug(hwsim->hw->wiphy, "hw scan %d MHz\n",
+	wiphy_dbg(hwsim->hw->wiphy, "hw scan %d MHz\n",
 		    req->channels[hwsim->scan_chan_idx]->center_freq);
 
 	hwsim->tmp_chan = req->channels[hwsim->scan_chan_idx];
@@ -2063,7 +2063,7 @@ static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 	memset(hwsim->survey_data, 0, sizeof(hwsim->survey_data));
 	mutex_unlock(&hwsim->mutex);
 
-	wiphy_debug(hw->wiphy, "hwsim hw_scan request\n");
+	wiphy_dbg(hw->wiphy, "hwsim hw_scan request\n");
 
 	ieee80211_queue_delayed_work(hwsim->hw, &hwsim->hw_scan, 0);
 
@@ -2078,7 +2078,7 @@ static void mac80211_hwsim_cancel_hw_scan(struct ieee80211_hw *hw,
 		.aborted = true,
 	};
 
-	wiphy_debug(hw->wiphy, "hwsim cancel_hw_scan\n");
+	wiphy_dbg(hw->wiphy, "hwsim cancel_hw_scan\n");
 
 	cancel_delayed_work_sync(&hwsim->hw_scan);
 
@@ -2099,11 +2099,11 @@ static void mac80211_hwsim_sw_scan(struct ieee80211_hw *hw,
 	mutex_lock(&hwsim->mutex);
 
 	if (hwsim->scanning) {
-		printk(KERN_DEBUG "two hwsim sw_scans detected!\n");
+		pr_debug("two hwsim sw_scans detected!\n");
 		goto out;
 	}
 
-	printk(KERN_DEBUG "hwsim sw_scan request, prepping stuff\n");
+	pr_debug("hwsim sw_scan request, prepping stuff\n");
 
 	memcpy(hwsim->scan_addr, mac_addr, ETH_ALEN);
 	hwsim->scanning = true;
@@ -2120,7 +2120,7 @@ static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw,
 
 	mutex_lock(&hwsim->mutex);
 
-	printk(KERN_DEBUG "hwsim sw_scan_complete\n");
+	pr_debug("hwsim sw_scan_complete\n");
 	hwsim->scanning = false;
 	eth_zero_addr(hwsim->scan_addr);
 
@@ -2134,7 +2134,7 @@ static void hw_roc_start(struct work_struct *work)
 
 	mutex_lock(&hwsim->mutex);
 
-	wiphy_debug(hwsim->hw->wiphy, "hwsim ROC begins\n");
+	wiphy_dbg(hwsim->hw->wiphy, "hwsim ROC begins\n");
 	hwsim->tmp_chan = hwsim->roc_chan;
 	ieee80211_ready_on_channel(hwsim->hw);
 
@@ -2154,7 +2154,7 @@ static void hw_roc_done(struct work_struct *work)
 	hwsim->tmp_chan = NULL;
 	mutex_unlock(&hwsim->mutex);
 
-	wiphy_debug(hwsim->hw->wiphy, "hwsim ROC expired\n");
+	wiphy_dbg(hwsim->hw->wiphy, "hwsim ROC expired\n");
 }
 
 static int mac80211_hwsim_roc(struct ieee80211_hw *hw,
@@ -2175,7 +2175,7 @@ static int mac80211_hwsim_roc(struct ieee80211_hw *hw,
 	hwsim->roc_duration = duration;
 	mutex_unlock(&hwsim->mutex);
 
-	wiphy_debug(hw->wiphy, "hwsim ROC (%d MHz, %d ms)\n",
+	wiphy_dbg(hw->wiphy, "hwsim ROC (%d MHz, %d ms)\n",
 		    chan->center_freq, duration);
 	ieee80211_queue_delayed_work(hw, &hwsim->roc_start, HZ/50);
 
@@ -2193,7 +2193,7 @@ static int mac80211_hwsim_croc(struct ieee80211_hw *hw)
 	hwsim->tmp_chan = NULL;
 	mutex_unlock(&hwsim->mutex);
 
-	wiphy_debug(hw->wiphy, "hwsim ROC canceled\n");
+	wiphy_dbg(hw->wiphy, "hwsim ROC canceled\n");
 
 	return 0;
 }
@@ -2202,7 +2202,7 @@ static int mac80211_hwsim_add_chanctx(struct ieee80211_hw *hw,
 				      struct ieee80211_chanctx_conf *ctx)
 {
 	hwsim_set_chanctx_magic(ctx);
-	wiphy_debug(hw->wiphy,
+	wiphy_dbg(hw->wiphy,
 		    "add channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
 		    ctx->def.chan->center_freq, ctx->def.width,
 		    ctx->def.center_freq1, ctx->def.center_freq2);
@@ -2212,7 +2212,7 @@ static int mac80211_hwsim_add_chanctx(struct ieee80211_hw *hw,
 static void mac80211_hwsim_remove_chanctx(struct ieee80211_hw *hw,
 					  struct ieee80211_chanctx_conf *ctx)
 {
-	wiphy_debug(hw->wiphy,
+	wiphy_dbg(hw->wiphy,
 		    "remove channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
 		    ctx->def.chan->center_freq, ctx->def.width,
 		    ctx->def.center_freq1, ctx->def.center_freq2);
@@ -2225,7 +2225,7 @@ static void mac80211_hwsim_change_chanctx(struct ieee80211_hw *hw,
 					  u32 changed)
 {
 	hwsim_check_chanctx_magic(ctx);
-	wiphy_debug(hw->wiphy,
+	wiphy_dbg(hw->wiphy,
 		    "change channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
 		    ctx->def.chan->center_freq, ctx->def.width,
 		    ctx->def.center_freq1, ctx->def.center_freq2);
@@ -2482,7 +2482,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		ops = &mac80211_hwsim_mchan_ops;
 	hw = ieee80211_alloc_hw_nm(sizeof(*data), ops, param->hwname);
 	if (!hw) {
-		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw failed\n");
+		pr_debug("mac80211_hwsim: ieee80211_alloc_hw failed\n");
 		err = -ENOMEM;
 		goto failed;
 	}
@@ -2510,7 +2510,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	data->dev->driver = &mac80211_hwsim_driver.driver;
 	err = device_bind_driver(data->dev);
 	if (err != 0) {
-		printk(KERN_DEBUG "mac80211_hwsim: device_bind_driver failed (%d)\n",
+		pr_debug("mac80211_hwsim: device_bind_driver failed (%d)\n",
 		       err);
 		goto failed_bind;
 	}
@@ -2701,12 +2701,12 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
-		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
+		pr_debug("mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
 		       err);
 		goto failed_hw;
 	}
 
-	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
+	wiphy_dbg(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
 
 	if (param->reg_alpha2) {
 		data->alpha2[0] = param->reg_alpha2[0];
@@ -3070,7 +3070,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	return 0;
 err:
-	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
+	pr_debug("mac80211_hwsim: error occurred in %s\n", __func__);
 out:
 	dev_kfree_skb(skb);
 	return -EINVAL;
@@ -3101,7 +3101,7 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 
 	hwsim_register_wmediumd(net, info->snd_portid);
 
-	printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
+	pr_debug("mac80211_hwsim: received a REGISTER, "
 	       "switching to wmediumd mode with pid %d\n", info->snd_portid);
 
 	return 0;
@@ -3390,7 +3390,7 @@ static int __init hwsim_init_netlink(void)
 	return 0;
 
 failure:
-	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
+	pr_debug("mac80211_hwsim: error occurred in %s\n", __func__);
 	return -EINVAL;
 }
 
@@ -3581,7 +3581,7 @@ module_init(init_mac80211_hwsim);
 
 static void __exit exit_mac80211_hwsim(void)
 {
-	printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
+	pr_debug("mac80211_hwsim: unregister radios\n");
 
 	hwsim_exit_netlink();
 
-- 
2.13.0
