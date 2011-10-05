Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210Ab1JEJzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:55 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:54 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/29] wl12xx: move bss_type into wlvif
Date: Wed,  5 Oct 2011 11:55:45 +0200
Message-Id: <1317808566-18857-9-git-send-email-eliad@wizery.com> (sfid-20111005_115600_522100_A4C77BD0)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move bss_type into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c     |    2 +-
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/event.c   |   10 ++--
 drivers/net/wireless/wl12xx/init.c    |   10 ++--
 drivers/net/wireless/wl12xx/main.c    |  109 ++++++++++++++++++---------------
 drivers/net/wireless/wl12xx/rx.c      |    4 +-
 drivers/net/wireless/wl12xx/scan.c    |   12 +++-
 drivers/net/wireless/wl12xx/scan.h    |    3 +-
 drivers/net/wireless/wl12xx/tx.c      |   86 ++++++++++++++++----------
 drivers/net/wireless/wl12xx/tx.h      |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |    3 +-
 11 files changed, 141 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 5f4d31d..a0a5051 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1042,7 +1042,7 @@ int wl12xx_cmd_build_null_data(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	int ret = -ENOMEM;
 
 
-	if (wl->bss_type == BSS_TYPE_IBSS) {
+	if (wlvif->bss_type == BSS_TYPE_IBSS) {
 		size = sizeof(struct wl12xx_null_data_template);
 		ptr = NULL;
 	} else {
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 620acbf..8f88ad6 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -350,7 +350,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(rx_counter);
 	DRIVER_STATE_PRINT_INT(session_counter);
 	DRIVER_STATE_PRINT_INT(state);
-	DRIVER_STATE_PRINT_INT(bss_type);
 	DRIVER_STATE_PRINT_INT(channel);
 	DRIVER_STATE_PRINT_INT(band);
 	DRIVER_STATE_PRINT_INT(beacon_int);
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 2066c91..c519858 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -178,9 +178,9 @@ static void wl1271_event_rssi_trigger(struct wl1271 *wl,
 	wl->last_rssi_event = event;
 }
 
-static void wl1271_stop_ba_event(struct wl1271 *wl)
+static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	if (wl->bss_type != BSS_TYPE_AP_BSS) {
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
 		if (!wl->ba_rx_bitmap)
 			return;
 		ieee80211_stop_rx_ba_session(wl->vif, wl->ba_rx_bitmap,
@@ -229,7 +229,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	int ret;
 	u32 vector;
 	bool beacon_loss = false;
-	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	bool disconnect_sta = false;
 	unsigned long sta_bitmap = 0;
 
@@ -263,7 +263,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	}
 
 	if (vector & SOFT_GEMINI_SENSE_EVENT_ID &&
-	    wl->bss_type == BSS_TYPE_STA_BSS)
+	    wlvif->bss_type == BSS_TYPE_STA_BSS)
 		wl12xx_event_soft_gemini_sense(wl,
 					       mbox->soft_gemini_sense_info);
 
@@ -306,7 +306,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		wl->ba_allowed = !!mbox->rx_ba_allowed;
 
 		if (wl->vif && !wl->ba_allowed)
-			wl1271_stop_ba_event(wl);
+			wl1271_stop_ba_event(wl, wlvif);
 	}
 
 	if ((vector & DUMMY_PACKET_EVENT_ID)) {
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 585c969..d3f4183 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -478,7 +478,7 @@ int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	return 0;
 }
 
-static int wl1271_set_ba_policies(struct wl1271 *wl)
+static int wl1271_set_ba_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	/* Reset the BA RX indicators */
 	wl->ba_rx_bitmap = 0;
@@ -486,8 +486,8 @@ static int wl1271_set_ba_policies(struct wl1271 *wl)
 	wl->ba_rx_session_count = 0;
 
 	/* BA is supported in STA/AP modes */
-	if (wl->bss_type != BSS_TYPE_AP_BSS &&
-	    wl->bss_type != BSS_TYPE_STA_BSS) {
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS &&
+	    wlvif->bss_type != BSS_TYPE_STA_BSS) {
 		wl->ba_support = false;
 		return 0;
 	}
@@ -572,7 +572,7 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct conf_tx_ac_category *conf_ac;
 	struct conf_tx_tid *conf_tid;
-	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 
 	int ret, i;
 
@@ -635,7 +635,7 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 		return ret;
 
 	/* Configure initiator BA sessions policies */
-	ret = wl1271_set_ba_policies(wl);
+	ret = wl1271_set_ba_policies(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ad8a324..fd14cdd 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -377,6 +377,7 @@ static char *fwlog_param;
 static bool bug_on_recovery;
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
+					 struct ieee80211_vif *vif,
 					 bool reset_tx_queues);
 static void wl1271_free_ap_keys(struct wl1271 *wl);
 
@@ -844,6 +845,8 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 static void wl12xx_fw_status(struct wl1271 *wl,
 			     struct wl12xx_fw_status *status)
 {
+	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
 	int avail, freed_blocks;
@@ -898,7 +901,7 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 		clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
 	/* for AP update num of allocated TX blocks per link and ps status */
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		wl12xx_irq_update_links_status(wl, status);
 
 	/* update the host-chipset time offset */
@@ -1004,7 +1007,7 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 				 * In order to avoid starvation of the TX path,
 				 * call the work function directly.
 				 */
-				wl1271_tx_work_locked(wl);
+				wl1271_tx_work_locked(wl, wl->vif);
 			} else {
 				spin_unlock_irqrestore(&wl->wl_lock, flags);
 			}
@@ -1251,7 +1254,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	}
 
 	/* reboot the chipset */
-	__wl1271_op_remove_interface(wl, false);
+	__wl1271_op_remove_interface(wl, wl->vif, false);
 
 	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
 
@@ -1389,8 +1392,6 @@ int wl1271_plt_start(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl->bss_type = BSS_TYPE_STA_BSS;
-
 	while (retries) {
 		retries--;
 		ret = wl1271_chip_wakeup(wl);
@@ -1482,6 +1483,8 @@ int wl1271_plt_stop(struct wl1271 *wl)
 static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
+	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(control->control.vif);
 	unsigned long flags;
 	int q, mapping;
 	u8 hlid = 0;
@@ -1489,13 +1492,13 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	mapping = skb_get_queue_mapping(skb);
 	q = wl1271_tx_get_queue(mapping);
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		hlid = wl12xx_tx_get_hlid_ap(wl, skb);
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
 	/* queue the packet */
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
 		if (!wl1271_is_active_sta(wl, hlid)) {
 			wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d",
 				     hlid, q);
@@ -1552,7 +1555,7 @@ int wl1271_tx_dummy_packet(struct wl1271 *wl)
 
 	/* The FW is low on RX memory blocks, so send the dummy packet asap */
 	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags))
-		wl1271_tx_work_locked(wl);
+		wl1271_tx_work_locked(wl, wl->vif);
 
 	/*
 	 * If the FW TX is busy, TX work will be scheduled by the threaded
@@ -1686,9 +1689,9 @@ out_unlock:
 static int wl1271_configure_suspend(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif)
 {
-	if (wl->bss_type == BSS_TYPE_STA_BSS)
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
 		return wl1271_configure_suspend_sta(wl, wlvif);
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl1271_configure_suspend_ap(wl);
 	return 0;
 }
@@ -1697,8 +1700,8 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif)
 {
 	int ret;
-	bool is_sta = wl->bss_type == BSS_TYPE_STA_BSS;
-	bool is_ap = wl->bss_type == BSS_TYPE_AP_BSS;
+	bool is_sta = wlvif->bss_type == BSS_TYPE_STA_BSS;
+	bool is_ap = wlvif->bss_type == BSS_TYPE_AP_BSS;
 
 	if (!is_sta && !is_ap)
 		return;
@@ -1820,9 +1823,9 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
 }
 
-static u8 wl12xx_get_role_type(struct wl1271 *wl)
+static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	switch (wl->bss_type) {
+	switch (wlvif->bss_type) {
 	case BSS_TYPE_AP_BSS:
 		if (wl->p2p)
 			return WL1271_ROLE_P2P_GO;
@@ -1839,13 +1842,14 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl)
 		return WL1271_ROLE_IBSS;
 
 	default:
-		wl1271_error("invalid bss_type: %d", wl->bss_type);
+		wl1271_error("invalid bss_type: %d", wlvif->bss_type);
 	}
 	return WL12XX_INVALID_ROLE_TYPE;
 }
 
 static void wl12xx_init_vif_data(struct wl12xx_vif *wlvif)
 {
+	wlvif->bss_type = MAX_BSS_TYPE;
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -1856,6 +1860,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 {
 	struct wl1271 *wl = hw->priv;
 	struct wiphy *wiphy = hw->wiphy;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int retries = WL1271_BOOT_RETRIES;
 	int ret = 0;
 	u8 role_type;
@@ -1871,7 +1876,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		ret = -EBUSY;
 		goto out;
 	}
-	wl12xx_init_vif_data(wl12xx_vif_to_data(vif));
+	wl12xx_init_vif_data(wlvif);
 
 	/*
 	 * in some very corner case HW recovery scenarios its possible to
@@ -1888,25 +1893,25 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		wl->p2p = 1;
 		/* fall-through */
 	case NL80211_IFTYPE_STATION:
-		wl->bss_type = BSS_TYPE_STA_BSS;
+		wlvif->bss_type = BSS_TYPE_STA_BSS;
 		wl->set_bss_type = BSS_TYPE_STA_BSS;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		wl->bss_type = BSS_TYPE_IBSS;
+		wlvif->bss_type = BSS_TYPE_IBSS;
 		wl->set_bss_type = BSS_TYPE_STA_BSS;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		wl->p2p = 1;
 		/* fall-through */
 	case NL80211_IFTYPE_AP:
-		wl->bss_type = BSS_TYPE_AP_BSS;
+		wlvif->bss_type = BSS_TYPE_AP_BSS;
 		break;
 	default:
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
-	role_type = wl12xx_get_role_type(wl);
+	role_type = wl12xx_get_role_type(wl, wlvif);
 	if (role_type == WL12XX_INVALID_ROLE_TYPE) {
 		ret = -EINVAL;
 		goto out;
@@ -1938,8 +1943,8 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto irq_disable;
 
-		if (wl->bss_type == BSS_TYPE_STA_BSS ||
-		    wl->bss_type == BSS_TYPE_IBSS) {
+		if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
+		    wlvif->bss_type == BSS_TYPE_IBSS) {
 			/*
 			 * The device role is a special role used for
 			 * rx and tx frames prior to association (as
@@ -2020,8 +2025,10 @@ out:
 }
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
+					 struct ieee80211_vif *vif,
 					 bool reset_tx_queues)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret, i;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
@@ -2037,7 +2044,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	mutex_unlock(&wl_list_mutex);
 
 	/* enable dyn ps just in case (if left on due to fw crash etc) */
-	if (wl->bss_type == BSS_TYPE_STA_BSS)
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
 		ieee80211_enable_dyn_ps(wl->vif);
 
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
@@ -2054,7 +2061,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		if (ret < 0)
 			goto deinit;
 
-		if (wl->bss_type == BSS_TYPE_STA_BSS) {
+		if (wlvif->bss_type == BSS_TYPE_STA_BSS) {
 			ret = wl12xx_cmd_role_disable(wl, &wl->dev_role_id);
 			if (ret < 0)
 				goto deinit;
@@ -2100,7 +2107,6 @@ deinit:
 
 	memset(wl->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
 	wl->ssid_len = 0;
-	wl->bss_type = MAX_BSS_TYPE;
 	wl->set_bss_type = MAX_BSS_TYPE;
 	wl->p2p = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
@@ -2169,7 +2175,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	 */
 	if (wl->vif) {
 		WARN_ON(wl->vif != vif);
-		__wl1271_op_remove_interface(wl, true);
+		__wl1271_op_remove_interface(wl, vif, true);
 	}
 
 	mutex_unlock(&wl->mutex);
@@ -2180,7 +2186,7 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			  bool set_assoc)
 {
 	int ret;
-	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
+	bool is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
 
 	/*
 	 * One of the side effects of the JOIN command is that is clears
@@ -2359,7 +2365,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 	}
 
-	is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
@@ -2370,7 +2376,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	    ((wl->band != conf->channel->band) ||
 	     (wl->channel != channel))) {
 		/* send all pending packets */
-		wl1271_tx_work_locked(wl);
+		wl1271_tx_work_locked(wl, vif);
 		wl->band = conf->channel->band;
 		wl->channel = channel;
 
@@ -2531,6 +2537,9 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 {
 	struct wl1271_filter_params *fp = (void *)(unsigned long)multicast;
 	struct wl1271 *wl = hw->priv;
+	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 configure filter changed %x"
@@ -2548,7 +2557,7 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if (wl->bss_type != BSS_TYPE_AP_BSS) {
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
 		if (*total & FIF_ALLMULTI)
 			ret = wl1271_acx_group_address_tbl(wl, false, NULL, 0);
 		else if (fp)
@@ -2668,12 +2677,13 @@ out:
 	return ret;
 }
 
-static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		       u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, u32 tx_seq_32,
 		       u16 tx_seq_16, struct ieee80211_sta *sta)
 {
 	int ret;
-	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 
 	if (is_ap) {
 		struct wl1271_station *wl_sta;
@@ -2769,6 +2779,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			     struct ieee80211_key_conf *key_conf)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 	u32 tx_seq_32 = 0;
 	u16 tx_seq_16 = 0;
@@ -2828,7 +2839,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = wl1271_set_key(wl, KEY_ADD_OR_REPLACE,
+		ret = wl1271_set_key(wl, wlvif, KEY_ADD_OR_REPLACE,
 				 key_conf->keyidx, key_type,
 				 key_conf->keylen, key_conf->key,
 				 tx_seq_32, tx_seq_16, sta);
@@ -2839,7 +2850,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		break;
 
 	case DISABLE_KEY:
-		ret = wl1271_set_key(wl, KEY_REMOVE,
+		ret = wl1271_set_key(wl, wlvif, KEY_REMOVE,
 				     key_conf->keyidx, key_type,
 				     key_conf->keylen, key_conf->key,
 				     0, 0, sta);
@@ -2961,6 +2972,7 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 				      struct ieee80211_sched_scan_ies *ies)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "wl1271_op_sched_scan_start");
@@ -2971,11 +2983,11 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_scan_sched_scan_config(wl, req, ies);
+	ret = wl1271_scan_sched_scan_config(wl, wlvif, req, ies);
 	if (ret < 0)
 		goto out_sleep;
 
-	ret = wl1271_scan_sched_scan_start(wl);
+	ret = wl1271_scan_sched_scan_start(wl, wlvif);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -3220,7 +3232,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 					  u32 changed)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	int ret = 0;
 
 	if ((changed & BSS_CHANGED_BEACON_INT)) {
@@ -3382,7 +3394,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	bool do_join = false, set_assoc = false;
-	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
+	bool is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
 	bool ibss_joined = false;
 	u32 sta_rate_set = 0;
 	int ret;
@@ -3618,7 +3630,7 @@ sta_not_found:
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		__be32 addr = bss_conf->arp_addr_list[0];
-		WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
+		WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS);
 
 		if (bss_conf->arp_addr_cnt == 1 &&
 		    bss_conf->arp_filter_enabled) {
@@ -3737,7 +3749,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				       u32 changed)
 {
 	struct wl1271 *wl = hw->priv;
-	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed 0x%x",
@@ -3927,6 +3940,7 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 			     struct ieee80211_sta *sta)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret = 0;
 	u8 hlid;
 
@@ -3935,7 +3949,7 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	if (wl->bss_type != BSS_TYPE_AP_BSS)
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS)
 		goto out;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add sta %d", (int)sta->aid);
@@ -3977,6 +3991,7 @@ static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
 				struct ieee80211_sta *sta)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_station *wl_sta;
 	int ret = 0, id;
 
@@ -3985,7 +4000,7 @@ static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	if (wl->bss_type != BSS_TYPE_AP_BSS)
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS)
 		goto out;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove sta %d", (int)sta->aid);
@@ -4020,6 +4035,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 				  u8 buf_size)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 	u8 hlid, *ba_bitmap;
 
@@ -4037,10 +4053,10 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	if (wl->bss_type == BSS_TYPE_STA_BSS) {
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS) {
 		hlid = wl->sta_hlid;
 		ba_bitmap = &wl->ba_rx_bitmap;
-	} else if (wl->bss_type == BSS_TYPE_AP_BSS) {
+	} else if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
 		struct wl1271_station *wl_sta;
 
 		wl_sta = (struct wl1271_station *)sta->drv_priv;
@@ -4160,10 +4176,6 @@ static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 
 	/* packets are considered pending if in the TX queue or the FW */
 	ret = (wl1271_tx_total_queue_count(wl) > 0) || (wl->tx_frames_cnt > 0);
-
-	/* the above is appropriate for STA mode for PS purposes */
-	WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
-
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -4805,7 +4817,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
-	wl->bss_type = MAX_BSS_TYPE;
 	wl->set_bss_type = MAX_BSS_TYPE;
 	wl->last_tx_hlid = 0;
 	wl->ap_ps_map = 0;
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index dee4cfe..9cfa0b2 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -185,6 +185,8 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 {
 	struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
+	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	u32 buf_size;
 	u32 fw_rx_counter  = status->fw_rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	u32 drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
@@ -192,7 +194,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 	u32 mem_block;
 	u32 pkt_length;
 	u32 pkt_offset;
-	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	bool had_data = false;
 	bool unaligned = false;
 
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index a857618..197d2c2 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -34,6 +34,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
+	struct wl12xx_vif *wlvif;
 	int ret;
 	bool is_sta, is_ibss;
 
@@ -50,6 +51,8 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
 		goto out;
 
+	wlvif = wl12xx_vif_to_data(wl->scan_vif);
+
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 	wl->scan.req = NULL;
@@ -65,8 +68,8 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	}
 
 	/* return to ROC if needed */
-	is_sta = (wl->bss_type == BSS_TYPE_STA_BSS);
-	is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
+	is_sta = (wlvif->bss_type == BSS_TYPE_STA_BSS);
+	is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
 	if (((is_sta && !test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) ||
 	     (is_ibss && !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))) &&
 	    !test_bit(wl->dev_role_id, wl->roc_map)) {
@@ -589,6 +592,7 @@ out:
 }
 
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
+				  struct wl12xx_vif *wlvif,
 				  struct cfg80211_sched_scan_request *req,
 				  struct ieee80211_sched_scan_ies *ies)
 {
@@ -671,14 +675,14 @@ out:
 	return ret;
 }
 
-int wl1271_scan_sched_scan_start(struct wl1271 *wl)
+int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl1271_cmd_sched_scan_start *start;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_CMD, "cmd periodic scan start");
 
-	if (wl->bss_type != BSS_TYPE_STA_BSS)
+	if (wlvif->bss_type != BSS_TYPE_STA_BSS)
 		return -EOPNOTSUPP;
 
 	if (!test_bit(WL1271_FLAG_IDLE, &wl->flags))
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index 15177bd..a7ed43d 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -36,9 +36,10 @@ int wl1271_scan_build_probe_req(struct wl1271 *wl,
 void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif);
 void wl1271_scan_complete_work(struct work_struct *work);
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
+				     struct wl12xx_vif *wlvif,
 				     struct cfg80211_sched_scan_request *req,
 				     struct ieee80211_sched_scan_ies *ies);
-int wl1271_scan_sched_scan_start(struct wl1271 *wl);
+int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl1271_scan_sched_scan_stop(struct wl1271 *wl);
 void wl1271_scan_sched_scan_results(struct wl1271 *wl);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index bad9e29..5561ec2 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -32,10 +32,11 @@
 #include "tx.h"
 #include "event.h"
 
-static int wl1271_set_default_wep_key(struct wl1271 *wl, u8 id)
+static int wl1271_set_default_wep_key(struct wl1271 *wl,
+				      struct wl12xx_vif *wlvif, u8 id)
 {
 	int ret;
-	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 
 	if (is_ap)
 		ret = wl12xx_cmd_set_default_wep_key(wl, id,
@@ -178,14 +179,17 @@ u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct sk_buff *skb)
 	}
 }
 
-static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct sk_buff *skb)
+static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct ieee80211_vif *vif,
+			     struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+
 
 	if (wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, skb);
 
 	wl1271_tx_update_filters(wl, skb);
@@ -208,9 +212,11 @@ static unsigned int wl12xx_calc_packet_alignment(struct wl1271 *wl,
 		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
 }
 
-static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
-				u32 buf_offset, u8 hlid)
+static int wl1271_tx_allocate(struct wl1271 *wl, struct ieee80211_vif *vif,
+			      struct sk_buff *skb, u32 extra, u32 buf_offset,
+			      u8 hlid)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 len;
@@ -257,7 +263,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->tx_allocated_pkts[ac]++;
 
-		if (wl->bss_type == BSS_TYPE_AP_BSS &&
+		if (wlvif->bss_type == BSS_TYPE_AP_BSS &&
 		    hlid >= WL1271_AP_STA_HLID_START)
 			wl->links[hlid].allocated_pkts++;
 
@@ -273,10 +279,11 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 	return ret;
 }
 
-static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
-			      u32 extra, struct ieee80211_tx_info *control,
-			      u8 hlid)
+static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct ieee80211_vif *vif,
+			       struct sk_buff *skb, u32 extra,
+			       struct ieee80211_tx_info *control, u8 hlid)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct timespec ts;
 	struct wl1271_tx_hw_descr *desc;
 	int aligned_len, ac, rate_idx;
@@ -298,7 +305,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	hosttime = (timespec_to_ns(&ts) >> 10);
 	desc->start_time = cpu_to_le32(hosttime - wl->time_offset);
 
-	if (wl->bss_type != BSS_TYPE_AP_BSS)
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS)
 		desc->life_time = cpu_to_le16(TX_HW_MGMT_PKT_LIFETIME_TU);
 	else
 		desc->life_time = cpu_to_le16(TX_HW_AP_MODE_PKT_LIFETIME_TU);
@@ -324,8 +331,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	}
 
 	desc->hlid = hlid;
-
-	if (wl->bss_type != BSS_TYPE_AP_BSS) {
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
 		/* if the packets are destined for AP (have a STA entry)
 		   send them with AP rate policies, otherwise use default
 		   basic rates */
@@ -383,16 +389,27 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 							u32 buf_offset)
 {
 	struct ieee80211_tx_info *info;
+	struct ieee80211_vif *vif;
+	struct wl12xx_vif *wlvif;
 	u32 extra = 0;
 	int ret = 0;
 	u32 total_len;
 	u8 hlid;
+	bool is_dummy;
 
 	if (!skb)
 		return -EINVAL;
 
 	info = IEEE80211_SKB_CB(skb);
 
+	/* TODO: handle dummy packets on multi-vifs */
+	is_dummy = wl12xx_is_dummy_packet(wl, skb);
+	if (is_dummy)
+		info->control.vif = wl->vif;
+
+	vif = info->control.vif;
+	wlvif = wl12xx_vif_to_data(vif);
+
 	if (info->control.hw_key &&
 	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP)
 		extra = WL1271_TKIP_IV_SPACE;
@@ -406,26 +423,25 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 			 (cipher == WLAN_CIPHER_SUITE_WEP104);
 
 		if (unlikely(is_wep && wl->default_key != idx)) {
-			ret = wl1271_set_default_wep_key(wl, idx);
+			ret = wl1271_set_default_wep_key(wl, wlvif, idx);
 			if (ret < 0)
 				return ret;
 			wl->default_key = idx;
 		}
 	}
-
-	hlid = wl1271_tx_get_hlid(wl, skb);
+	hlid = wl1271_tx_get_hlid(wl, vif, skb);
 	if (hlid == WL12XX_INVALID_LINK_ID) {
 		wl1271_error("invalid hlid. dropping skb 0x%p", skb);
 		return -EINVAL;
 	}
 
-	ret = wl1271_tx_allocate(wl, skb, extra, buf_offset, hlid);
+	ret = wl1271_tx_allocate(wl, vif, skb, extra, buf_offset, hlid);
 	if (ret < 0)
 		return ret;
 
-	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
+	wl1271_tx_fill_hdr(wl, vif, skb, extra, info, hlid);
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS && !is_dummy) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
 		wl1271_tx_regulate_link(wl, hlid);
 	}
@@ -444,7 +460,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
 
 	/* Revert side effects in the dummy packet skb, so it can be reused */
-	if (wl12xx_is_dummy_packet(wl, skb))
+	if (is_dummy)
 		skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
 
 	return total_len;
@@ -586,12 +602,13 @@ static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
 	return skb;
 }
 
-static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
+static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl,
+					  struct wl12xx_vif *wlvif)
 {
 	unsigned long flags;
 	struct sk_buff *skb = NULL;
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		skb = wl1271_ap_skb_dequeue(wl);
 	else
 		skb = wl1271_sta_skb_dequeue(wl);
@@ -610,15 +627,17 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 	return skb;
 }
 
-static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
+static void wl1271_skb_queue_head(struct wl1271 *wl, struct ieee80211_vif *vif,
+				  struct sk_buff *skb)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	unsigned long flags;
 	int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 
 	if (wl12xx_is_dummy_packet(wl, skb)) {
 		set_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags);
-	} else if (wl->bss_type == BSS_TYPE_AP_BSS) {
-		u8 hlid = wl1271_tx_get_hlid(wl, skb);
+	} else if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
+		u8 hlid = wl1271_tx_get_hlid(wl, vif, skb);
 		skb_queue_head(&wl->links[hlid].tx_queue[q], skb);
 
 		/* make sure we dequeue the same packet next time */
@@ -639,19 +658,20 @@ static bool wl1271_tx_is_data_present(struct sk_buff *skb)
 	return ieee80211_is_data_present(hdr->frame_control);
 }
 
-void wl1271_tx_work_locked(struct wl1271 *wl)
+void wl1271_tx_work_locked(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct sk_buff *skb;
 	u32 buf_offset = 0;
 	bool sent_packets = false;
 	bool had_data = false;
-	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	int ret;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		return;
 
-	while ((skb = wl1271_skb_dequeue(wl))) {
+	while ((skb = wl1271_skb_dequeue(wl, wlvif))) {
 		if (wl1271_tx_is_data_present(skb))
 			had_data = true;
 
@@ -661,7 +681,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			 * Aggregation buffer is full.
 			 * Flush buffer and try again.
 			 */
-			wl1271_skb_queue_head(wl, skb);
+			wl1271_skb_queue_head(wl, vif, skb);
 			wl1271_write(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
 				     buf_offset, true);
 			sent_packets = true;
@@ -672,7 +692,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			 * Firmware buffer is full.
 			 * Queue back last skb, and stop aggregating.
 			 */
-			wl1271_skb_queue_head(wl, skb);
+			wl1271_skb_queue_head(wl, vif, skb);
 			/* No work left, avoid scheduling redundant tx work */
 			set_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 			goto out_ack;
@@ -726,7 +746,7 @@ void wl1271_tx_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	wl1271_tx_work_locked(wl);
+	wl1271_tx_work_locked(wl, wl->vif);
 
 	wl1271_ps_elp_sleep(wl);
 out:
@@ -888,12 +908,14 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 /* caller must hold wl->mutex and TX must be stopped */
 void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 {
+	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int i;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 
 	/* TX failure */
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
 		for (i = 0; i < AP_MAX_LINKS; i++) {
 			wl1271_free_sta(wl, i);
 			wl1271_tx_reset_link_queues(wl, i);
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index dc4f09a..ba9403a 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -204,7 +204,7 @@ static inline int wl1271_tx_total_queue_count(struct wl1271 *wl)
 }
 
 void wl1271_tx_work(struct work_struct *work);
-void wl1271_tx_work_locked(struct wl1271 *wl);
+void wl1271_tx_work_locked(struct wl1271 *wl, struct ieee80211_vif *vif);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
 void wl1271_tx_flush(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index efa4720..e38fba1 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -399,7 +399,6 @@ struct wl1271 {
 	s8 hw_pg_ver;
 
 	u8 mac_addr[ETH_ALEN];
-	u8 bss_type;
 	u8 set_bss_type;
 	u8 p2p; /* we are using p2p role */
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
@@ -629,6 +628,8 @@ struct wl1271_station {
 };
 
 struct wl12xx_vif {
+	u8 bss_type;
+
 	u32 basic_rate_set;
 
 	/*
-- 
1.7.6.401.g6a319

