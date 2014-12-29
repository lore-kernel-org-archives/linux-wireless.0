Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61575 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaL2GYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:32 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so21166544wiw.13
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:31 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.29
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:30 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/13] wlcore: add support for ap csa
Date: Mon, 29 Dec 2014 08:24:09 +0200
Message-Id: <1419834253-18331-9-git-send-email-eliad@wizery.com> (sfid-20141229_072437_676310_E69DF5E2)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support ap csa support by implementing the channel_switch_beacon()
mac80211 op.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/cmd.c   | 11 +++--
 drivers/net/wireless/ti/wlcore/event.c | 10 +++--
 drivers/net/wireless/ti/wlcore/main.c  | 81 +++++++++++++++++++++++++++++++++-
 3 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/cmd.c b/drivers/net/wireless/ti/wl18xx/cmd.c
index 68e12e5..5731950 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.c
+++ b/drivers/net/wireless/ti/wl18xx/cmd.c
@@ -33,7 +33,8 @@ int wl18xx_cmd_channel_switch(struct wl1271 *wl,
 	u32 supported_rates;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "cmd channel switch");
+	wl1271_debug(DEBUG_ACX, "cmd channel switch (count=%d)",
+		     ch_switch->count);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
@@ -60,8 +61,12 @@ int wl18xx_cmd_channel_switch(struct wl1271 *wl,
 		goto out_free;
 	}
 
-	supported_rates = CONF_TX_ENABLED_RATES | CONF_TX_MCS_RATES |
-			  wlcore_hw_sta_get_ap_rate_mask(wl, wlvif);
+	supported_rates = CONF_TX_ENABLED_RATES | CONF_TX_MCS_RATES;
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
+		supported_rates |= wlcore_hw_sta_get_ap_rate_mask(wl, wlvif);
+	else
+		supported_rates |=
+			wlcore_hw_ap_get_mimo_wide_rate_mask(wl, wlvif);
 	if (wlvif->p2p)
 		supported_rates &= ~CONF_TX_CCK_RATES;
 	cmd->local_supported_rates = cpu_to_le32(supported_rates);
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 5153640..69a2661 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -139,7 +139,7 @@ void wlcore_event_channel_switch(struct wl1271 *wl,
 	wl1271_debug(DEBUG_EVENT, "%s: roles=0x%lx success=%d",
 		     __func__, roles_bitmap, success);
 
-	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+	wl12xx_for_each_wlvif(wl, wlvif) {
 		if (wlvif->role_id == WL12XX_INVALID_ROLE_ID ||
 		    !test_bit(wlvif->role_id , &roles_bitmap))
 			continue;
@@ -150,8 +150,12 @@ void wlcore_event_channel_switch(struct wl1271 *wl,
 
 		vif = wl12xx_wlvif_to_vif(wlvif);
 
-		ieee80211_chswitch_done(vif, success);
-		cancel_delayed_work(&wlvif->channel_switch_work);
+		if (wlvif->bss_type == BSS_TYPE_STA_BSS) {
+			ieee80211_chswitch_done(vif, success);
+			cancel_delayed_work(&wlvif->channel_switch_work);
+		} else {
+			ieee80211_csa_finish(vif);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(wlcore_event_channel_switch);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 673bfc4..9a35f30 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5434,6 +5434,83 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static const void *wlcore_get_beacon_ie(struct wl1271 *wl,
+					struct wl12xx_vif *wlvif,
+					u8 eid)
+{
+	int ieoffset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	struct sk_buff *beacon =
+		ieee80211_beacon_get(wl->hw, wl12xx_wlvif_to_vif(wlvif));
+
+	if (!beacon)
+		return NULL;
+
+	return cfg80211_find_ie(eid,
+				beacon->data + ieoffset,
+				beacon->len - ieoffset);
+}
+
+static int wlcore_get_csa_count(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				u8 *csa_count)
+{
+	const u8 *ie;
+	const struct ieee80211_channel_sw_ie *ie_csa;
+
+	ie = wlcore_get_beacon_ie(wl, wlvif, WLAN_EID_CHANNEL_SWITCH);
+	if (!ie)
+		return -EINVAL;
+
+	ie_csa = (struct ieee80211_channel_sw_ie *)&ie[2];
+	*csa_count = ie_csa->count;
+
+	return 0;
+}
+
+static void wlcore_op_channel_switch_beacon(struct ieee80211_hw *hw,
+					    struct ieee80211_vif *vif,
+					    struct cfg80211_chan_def *chandef)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct ieee80211_channel_switch ch_switch = {
+		.block_tx = true,
+		.chandef = *chandef,
+	};
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211,
+		     "mac80211 channel switch beacon (role %d)",
+		     wlvif->role_id);
+
+	ret = wlcore_get_csa_count(wl, wlvif, &ch_switch.count);
+	if (ret < 0) {
+		wl1271_error("error getting beacon (for CSA counter)");
+		return;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl->ops->channel_switch(wl, wlvif, &ch_switch);
+	if (ret)
+		goto out_sleep;
+
+	set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static void wlcore_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    u32 queues, bool drop)
 {
@@ -5808,6 +5885,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.set_bitrate_mask = wl12xx_set_bitrate_mask,
 	.set_default_unicast_key = wl1271_op_set_default_key_idx,
 	.channel_switch = wl12xx_op_channel_switch,
+	.channel_switch_beacon = wlcore_op_channel_switch_beacon,
 	.flush = wlcore_op_flush,
 	.remain_on_channel = wlcore_op_remain_on_channel,
 	.cancel_remain_on_channel = wlcore_op_cancel_remain_on_channel,
@@ -6023,7 +6101,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD |
 				WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-				WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+				WIPHY_FLAG_SUPPORTS_SCHED_SCAN |
+				WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	/* make sure all our channels fit in the scanned_ch bitmask */
 	BUILD_BUG_ON(ARRAY_SIZE(wl1271_channels) +
-- 
1.8.5.2.229.g4448466.dirty

