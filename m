Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1HNKRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:13 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:12 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 05/40] wl12xx: remove rx filtering stuff
Date: Sun, 14 Aug 2011 13:17:04 +0300
Message-Id: <1313317059-16567-6-git-send-email-eliad@wizery.com> (sfid-20110814_121719_741723_C52862D4)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new fw doesn't support rx_filtering configuration (as a
stand-alone command. the rx filtering is done automatically
according to the active role).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: s/wl1271/wl12xx

 drivers/net/wireless/wl12xx/acx.c     |   28 --------
 drivers/net/wireless/wl12xx/acx.h     |  118 ---------------------------------
 drivers/net/wireless/wl12xx/boot.c    |    3 -
 drivers/net/wireless/wl12xx/cmd.c     |    4 -
 drivers/net/wireless/wl12xx/debugfs.c |    3 -
 drivers/net/wireless/wl12xx/init.c    |   12 +---
 drivers/net/wireless/wl12xx/io.h      |    1 -
 drivers/net/wireless/wl12xx/main.c    |   62 ++----------------
 drivers/net/wireless/wl12xx/reg.h     |   75 ---------------------
 drivers/net/wireless/wl12xx/rx.c      |   11 ---
 drivers/net/wireless/wl12xx/rx.h      |    1 -
 drivers/net/wireless/wl12xx/scan.c    |    3 -
 drivers/net/wireless/wl12xx/tx.c      |    4 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |   22 ------
 14 files changed, 8 insertions(+), 339 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 7e33f1f..6447a09 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -180,40 +180,12 @@ int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl)
 
 out:
 	kfree(acx);
 	return ret;
 }
 
-int wl1271_acx_rx_config(struct wl1271 *wl, u32 config, u32 filter)
-{
-	struct acx_rx_config *rx_config;
-	int ret;
-
-	wl1271_debug(DEBUG_ACX, "acx rx config");
-
-	rx_config = kzalloc(sizeof(*rx_config), GFP_KERNEL);
-	if (!rx_config) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	rx_config->config_options = cpu_to_le32(config);
-	rx_config->filter_options = cpu_to_le32(filter);
-
-	ret = wl1271_cmd_configure(wl, ACX_RX_CFG,
-				   rx_config, sizeof(*rx_config));
-	if (ret < 0) {
-		wl1271_warning("failed to set rx config: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(rx_config);
-	return ret;
-}
-
 int wl1271_acx_pd_threshold(struct wl1271 *wl)
 {
 	struct acx_packet_detection *pd;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "acx data pd threshold");
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index d2eb86e..4ae0085 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -157,100 +157,12 @@ struct acx_rx_msdu_lifetime {
 	 * The maximum amount of time, in TU, before the
 	 * firmware discards the MSDU.
 	 */
 	__le32 lifetime;
 } __packed;
 
-/*
- * RX Config Options Table
- * Bit		Definition
- * ===		==========
- * 31:14		Reserved
- * 13		Copy RX Status - when set, write three receive status words
- *		to top of rx'd MPDUs.
- *		When cleared, do not write three status words (added rev 1.5)
- * 12		Reserved
- * 11		RX Complete upon FCS error - when set, give rx complete
- *		interrupt for FCS errors, after the rx filtering, e.g. unicast
- *		frames not to us with FCS error will not generate an interrupt.
- * 10		SSID Filter Enable - When set, the WiLink discards all beacon,
- *	        probe request, and probe response frames with an SSID that does
- *		not match the SSID specified by the host in the START/JOIN
- *		command.
- *		When clear, the WiLink receives frames with any SSID.
- * 9		Broadcast Filter Enable - When set, the WiLink discards all
- *		broadcast frames. When clear, the WiLink receives all received
- *		broadcast frames.
- * 8:6		Reserved
- * 5		BSSID Filter Enable - When set, the WiLink discards any frames
- *		with a BSSID that does not match the BSSID specified by the
- *		host.
- *		When clear, the WiLink receives frames from any BSSID.
- * 4		MAC Addr Filter - When set, the WiLink discards any frames
- *		with a destination address that does not match the MAC address
- *		of the adaptor.
- *		When clear, the WiLink receives frames destined to any MAC
- *		address.
- * 3		Promiscuous - When set, the WiLink receives all valid frames
- *		(i.e., all frames that pass the FCS check).
- *		When clear, only frames that pass the other filters specified
- *		are received.
- * 2		FCS - When set, the WiLink includes the FCS with the received
- *		frame.
- *		When cleared, the FCS is discarded.
- * 1		PLCP header - When set, write all data from baseband to frame
- *		buffer including PHY header.
- * 0		Reserved - Always equal to 0.
- *
- * RX Filter Options Table
- * Bit		Definition
- * ===		==========
- * 31:12		Reserved - Always equal to 0.
- * 11		Association - When set, the WiLink receives all association
- *		related frames (association request/response, reassocation
- *		request/response, and disassociation). When clear, these frames
- *		are discarded.
- * 10		Auth/De auth - When set, the WiLink receives all authentication
- *		and de-authentication frames. When clear, these frames are
- *		discarded.
- * 9		Beacon - When set, the WiLink receives all beacon frames.
- *		When clear, these frames are discarded.
- * 8		Contention Free - When set, the WiLink receives all contention
- *		free frames.
- *		When clear, these frames are discarded.
- * 7		Control - When set, the WiLink receives all control frames.
- *		When clear, these frames are discarded.
- * 6		Data - When set, the WiLink receives all data frames.
- *		When clear, these frames are discarded.
- * 5		FCS Error - When set, the WiLink receives frames that have FCS
- *		errors.
- *		When clear, these frames are discarded.
- * 4		Management - When set, the WiLink receives all management
- *		frames.
- *		When clear, these frames are discarded.
- * 3		Probe Request - When set, the WiLink receives all probe request
- *		frames.
- *		When clear, these frames are discarded.
- * 2		Probe Response - When set, the WiLink receives all probe
- *		response frames.
- *		When clear, these frames are discarded.
- * 1		RTS/CTS/ACK - When set, the WiLink receives all RTS, CTS and ACK
- *		frames.
- *		When clear, these frames are discarded.
- * 0		Rsvd Type/Sub Type - When set, the WiLink receives all frames
- *		that have reserved frame types and sub types as defined by the
- *		802.11 specification.
- *		When clear, these frames are discarded.
- */
-struct acx_rx_config {
-	struct acx_header header;
-
-	__le32 config_options;
-	__le32 filter_options;
-} __packed;
-
 struct acx_packet_detection {
 	struct acx_header header;
 
 	__le32 threshold;
 } __packed;
 
@@ -421,41 +333,12 @@ struct acx_event_mask {
 	struct acx_header header;
 
 	__le32 event_mask;
 	__le32 high_event_mask; /* Unused */
 } __packed;
 
-#define CFG_RX_FCS		BIT(2)
-#define CFG_RX_ALL_GOOD		BIT(3)
-#define CFG_UNI_FILTER_EN	BIT(4)
-#define CFG_BSSID_FILTER_EN	BIT(5)
-#define CFG_MC_FILTER_EN	BIT(6)
-#define CFG_MC_ADDR0_EN		BIT(7)
-#define CFG_MC_ADDR1_EN		BIT(8)
-#define CFG_BC_REJECT_EN	BIT(9)
-#define CFG_SSID_FILTER_EN	BIT(10)
-#define CFG_RX_INT_FCS_ERROR	BIT(11)
-#define CFG_RX_INT_ENCRYPTED	BIT(12)
-#define CFG_RX_WR_RX_STATUS	BIT(13)
-#define CFG_RX_FILTER_NULTI	BIT(14)
-#define CFG_RX_RESERVE		BIT(15)
-#define CFG_RX_TIMESTAMP_TSF	BIT(16)
-
-#define CFG_RX_RSV_EN		BIT(0)
-#define CFG_RX_RCTS_ACK		BIT(1)
-#define CFG_RX_PRSP_EN		BIT(2)
-#define CFG_RX_PREQ_EN		BIT(3)
-#define CFG_RX_MGMT_EN		BIT(4)
-#define CFG_RX_FCS_ERROR	BIT(5)
-#define CFG_RX_DATA_EN		BIT(6)
-#define CFG_RX_CTL_EN		BIT(7)
-#define CFG_RX_CF_EN		BIT(8)
-#define CFG_RX_BCN_EN		BIT(9)
-#define CFG_RX_AUTH_EN		BIT(10)
-#define CFG_RX_ASSOC_EN		BIT(11)
-
 #define SCAN_PASSIVE		BIT(0)
 #define SCAN_5GHZ_BAND		BIT(1)
 #define SCAN_TRIGGERED		BIT(2)
 #define SCAN_PRIORITY_HIGH	BIT(3)
 
 /* When set, disable HW encryption */
@@ -1339,13 +1222,12 @@ int wl1271_acx_wake_up_conditions(struct wl1271 *wl);
 int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth);
 int wl1271_acx_tx_power(struct wl1271 *wl, int power);
 int wl1271_acx_feature_cfg(struct wl1271 *wl);
 int wl1271_acx_mem_map(struct wl1271 *wl,
 		       struct acx_header *mem_map, size_t len);
 int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl);
-int wl1271_acx_rx_config(struct wl1271 *wl, u32 config, u32 filter);
 int wl1271_acx_pd_threshold(struct wl1271 *wl);
 int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time);
 int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
 				 void *mc_list, u32 mc_list_len);
 int wl1271_acx_service_period_timeout(struct wl1271 *wl);
 int wl1271_acx_rts_threshold(struct wl1271 *wl, u32 rts_threshold);
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 930a638..41791ff 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -842,14 +842,11 @@ int wl1271_boot(struct wl1271 *wl)
 	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
 		       WL1271_ACX_ALL_EVENTS_VECTOR);
 
 	/* Enable firmware interrupts now */
 	wl1271_boot_enable_interrupts(wl);
 
-	/* set the wl1271 default filters */
-	wl1271_set_default_filters(wl);
-
 	wl1271_event_mbox_config(wl);
 
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 97dd237..b6ef65a 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -379,14 +379,12 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 
 	/* Reverse order BSSID */
 	bssid = (u8 *) &join->bssid_lsb;
 	for (i = 0; i < ETH_ALEN; i++)
 		bssid[i] = wl->bssid[ETH_ALEN - i - 1];
 
-	join->rx_config_options = cpu_to_le32(wl->rx_config);
-	join->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	join->bss_type = bss_type;
 	join->basic_rate_set = cpu_to_le32(wl->basic_rate_set);
 	join->supported_rate_set = cpu_to_le32(wl->rate_set);
 
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
@@ -1001,14 +999,12 @@ int wl1271_cmd_disconnect(struct wl1271 *wl)
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	cmd->rx_config_options = cpu_to_le32(wl->rx_config);
-	cmd->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	/* disconnect reason is not used in immediate disconnections */
 	cmd->type = DISCONNECT_IMMEDIATE;
 
 	ret = wl1271_cmd_send(wl, CMD_DISCONNECT, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to send disconnect command");
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 3b5f240..fd1c301 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -363,15 +363,12 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_HEX(basic_rate_set);
 	DRIVER_STATE_PRINT_HEX(basic_rate);
 	DRIVER_STATE_PRINT_INT(band);
 	DRIVER_STATE_PRINT_INT(beacon_int);
 	DRIVER_STATE_PRINT_INT(psm_entry_retry);
 	DRIVER_STATE_PRINT_INT(ps_poll_failures);
-	DRIVER_STATE_PRINT_HEX(filters);
-	DRIVER_STATE_PRINT_HEX(rx_config);
-	DRIVER_STATE_PRINT_HEX(rx_filter);
 	DRIVER_STATE_PRINT_INT(power_level);
 	DRIVER_STATE_PRINT_INT(rssi_thold);
 	DRIVER_STATE_PRINT_INT(last_rssi_event);
 	DRIVER_STATE_PRINT_INT(sg_enabled);
 	DRIVER_STATE_PRINT_INT(enable_11a);
 	DRIVER_STATE_PRINT_INT(noise);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index c3e9a2e..44cd515 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -224,24 +224,20 @@ static int wl1271_ap_init_templates_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-static int wl1271_init_rx_config(struct wl1271 *wl, u32 config, u32 filter)
+static int wl12xx_init_rx_config(struct wl1271 *wl)
 {
 	int ret;
 
 	ret = wl1271_acx_rx_msdu_life_time(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_rx_config(wl, config, filter);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
 int wl1271_init_phy_config(struct wl1271 *wl)
 {
 	int ret;
@@ -647,17 +643,13 @@ int wl1271_hw_init(struct wl1271 *wl)
 	/* Default memory configuration */
 	ret = wl1271_acx_init_mem_config(wl);
 	if (ret < 0)
 		return ret;
 
 	/* RX config */
-	ret = wl1271_init_rx_config(wl,
-				    RX_CFG_PROMISCUOUS | RX_CFG_TSF,
-				    RX_FILTER_OPTION_DEF);
-	/* RX_CONFIG_OPTION_ANY_DST_ANY_BSS,
-	   RX_FILTER_OPTION_FILTER_ALL); */
+	ret = wl12xx_init_rx_config(wl);
 	if (ret < 0)
 		goto out_free_memmap;
 
 	/* PHY layer config */
 	ret = wl1271_init_phy_config(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index a2fe4f5..e839341 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -183,9 +183,8 @@ void wl1271_unregister_hw(struct wl1271 *wl);
 int wl1271_init_ieee80211(struct wl1271 *wl);
 struct ieee80211_hw *wl1271_alloc_hw(void);
 int wl1271_free_hw(struct wl1271 *wl);
 irqreturn_t wl1271_irq(int irq, void *data);
 bool wl1271_set_block_size(struct wl1271 *wl);
 int wl1271_tx_dummy_packet(struct wl1271 *wl);
-void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4fa7602..7fcdfa3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1988,13 +1988,12 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->vif = NULL;
-	wl->filters = 0;
 	wl1271_free_ap_keys(wl);
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
 
@@ -2034,57 +2033,21 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	}
 
 	mutex_unlock(&wl->mutex);
 	cancel_work_sync(&wl->recovery_work);
 }
 
-void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
-{
-	wl1271_set_default_filters(wl);
-
-	/* combine requested filters with current filter config */
-	filters = wl->filters | filters;
-
-	wl1271_debug(DEBUG_FILTERS, "RX filters set: ");
-
-	if (filters & FIF_PROMISC_IN_BSS) {
-		wl1271_debug(DEBUG_FILTERS, " - FIF_PROMISC_IN_BSS");
-		wl->rx_config &= ~CFG_UNI_FILTER_EN;
-		wl->rx_config |= CFG_BSSID_FILTER_EN;
-	}
-	if (filters & FIF_BCN_PRBRESP_PROMISC) {
-		wl1271_debug(DEBUG_FILTERS, " - FIF_BCN_PRBRESP_PROMISC");
-		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
-		wl->rx_config &= ~CFG_SSID_FILTER_EN;
-	}
-	if (filters & FIF_OTHER_BSS) {
-		wl1271_debug(DEBUG_FILTERS, " - FIF_OTHER_BSS");
-		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
-	}
-	if (filters & FIF_CONTROL) {
-		wl1271_debug(DEBUG_FILTERS, " - FIF_CONTROL");
-		wl->rx_filter |= CFG_RX_CTL_EN;
-	}
-	if (filters & FIF_FCSFAIL) {
-		wl1271_debug(DEBUG_FILTERS, " - FIF_FCSFAIL");
-		wl->rx_filter |= CFG_RX_FCS_ERROR;
-	}
-}
-
 static int wl1271_dummy_join(struct wl1271 *wl)
 {
 	int ret = 0;
 	/* we need to use a dummy BSSID for now */
 	static const u8 dummy_bssid[ETH_ALEN] = { 0x0b, 0xad, 0xde,
 						  0xad, 0xbe, 0xef };
 
 	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
 
-	/* pass through frames from all BSS */
-	wl1271_configure_filters(wl, FIF_OTHER_BSS);
-
 	ret = wl1271_cmd_join(wl, wl->set_bss_type);
 	if (ret < 0)
 		goto out;
 
 	set_bit(WL1271_FLAG_JOINED, &wl->flags);
 
@@ -2160,15 +2123,12 @@ static int wl1271_unjoin(struct wl1271 *wl)
 	memset(wl->bssid, 0, ETH_ALEN);
 
 	/* reset TX security counters on a clean disconnect */
 	wl->tx_security_last_seq_lsb = 0;
 	wl->tx_security_seq = 0;
 
-	/* stop filtering packets based on bssid */
-	wl1271_configure_filters(wl, FIF_OTHER_BSS);
-
 out:
 	return ret;
 }
 
 static void wl1271_set_band_rate(struct wl1271 *wl)
 {
@@ -2431,24 +2391,17 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 							   fp->mc_list,
 							   fp->mc_list_length);
 		if (ret < 0)
 			goto out_sleep;
 	}
 
-	/* determine, whether supported filter values have changed */
-	if (changed == 0)
-		goto out_sleep;
-
-	/* configure filters */
-	wl->filters = *total;
-	wl1271_configure_filters(wl, 0);
-
-	/* apply configured filters */
-	ret = wl1271_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
-	if (ret < 0)
-		goto out_sleep;
+	/*
+	 * the fw doesn't provide an api to configure the filters. instead,
+	 * the filters configuration is based on the active roles / ROC
+	 * state.
+	 */
 
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -3165,15 +3118,12 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 				goto out;
 
 			ret = wl1271_build_qos_null_data(wl);
 			if (ret < 0)
 				goto out;
 
-			/* filter out all packets not from this BSSID */
-			wl1271_configure_filters(wl, 0);
-
 			/* Need to update the BSSID (for filtering etc) */
 			do_join = true;
 		}
 	}
 
 	rcu_read_lock();
@@ -4360,14 +4310,12 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	}
 
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
 	wl->default_key = 0;
 	wl->rx_counter = 0;
-	wl->rx_config = WL1271_DEFAULT_STA_RX_CONFIG;
-	wl->rx_filter = WL1271_DEFAULT_STA_RX_FILTER;
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->band = IEEE80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/wl12xx/reg.h b/drivers/net/wireless/wl12xx/reg.h
index 440a4ee..3f570f3 100644
--- a/drivers/net/wireless/wl12xx/reg.h
+++ b/drivers/net/wireless/wl12xx/reg.h
@@ -293,87 +293,12 @@
  The information mailbox pointer is not valid
  until after the host receives the Init Complete interrupt from
  the Wlan hardware.
  ===============================================*/
 #define REG_EVENT_MAILBOX_PTR				(SCR_PAD1)
 
-
-/* Misc */
-
-#define REG_ENABLE_TX_RX				(ENABLE)
-/*
- * Rx configuration (filter) information element
- * ---------------------------------------------
- */
-#define REG_RX_CONFIG				(RX_CFG)
-#define REG_RX_FILTER				(RX_FILTER_CFG)
-
-
-#define RX_CFG_ENABLE_PHY_HEADER_PLCP	 0x0002
-
-/* promiscuous - receives all valid frames */
-#define RX_CFG_PROMISCUOUS		 0x0008
-
-/* receives frames from any BSSID */
-#define RX_CFG_BSSID			 0x0020
-
-/* receives frames destined to any MAC address */
-#define RX_CFG_MAC			 0x0010
-
-#define RX_CFG_ENABLE_ONLY_MY_DEST_MAC	 0x0010
-#define RX_CFG_ENABLE_ANY_DEST_MAC	 0x0000
-#define RX_CFG_ENABLE_ONLY_MY_BSSID	 0x0020
-#define RX_CFG_ENABLE_ANY_BSSID		 0x0000
-
-/* discards all broadcast frames */
-#define RX_CFG_DISABLE_BCAST		 0x0200
-
-#define RX_CFG_ENABLE_ONLY_MY_SSID	 0x0400
-#define RX_CFG_ENABLE_RX_CMPLT_FCS_ERROR 0x0800
-#define RX_CFG_COPY_RX_STATUS		 0x2000
-#define RX_CFG_TSF			 0x10000
-
-#define RX_CONFIG_OPTION_ANY_DST_MY_BSS	 (RX_CFG_ENABLE_ANY_DEST_MAC | \
-					  RX_CFG_ENABLE_ONLY_MY_BSSID)
-
-#define RX_CONFIG_OPTION_MY_DST_ANY_BSS	 (RX_CFG_ENABLE_ONLY_MY_DEST_MAC\
-					  | RX_CFG_ENABLE_ANY_BSSID)
-
-#define RX_CONFIG_OPTION_ANY_DST_ANY_BSS (RX_CFG_ENABLE_ANY_DEST_MAC | \
-					  RX_CFG_ENABLE_ANY_BSSID)
-
-#define RX_CONFIG_OPTION_MY_DST_MY_BSS	 (RX_CFG_ENABLE_ONLY_MY_DEST_MAC\
-					  | RX_CFG_ENABLE_ONLY_MY_BSSID)
-
-#define RX_CONFIG_OPTION_FOR_SCAN  (RX_CFG_ENABLE_PHY_HEADER_PLCP \
-				    | RX_CFG_ENABLE_RX_CMPLT_FCS_ERROR \
-				    | RX_CFG_COPY_RX_STATUS | RX_CFG_TSF)
-
-#define RX_CONFIG_OPTION_FOR_MEASUREMENT (RX_CFG_ENABLE_ANY_DEST_MAC)
-
-#define RX_CONFIG_OPTION_FOR_JOIN	 (RX_CFG_ENABLE_ONLY_MY_BSSID | \
-					  RX_CFG_ENABLE_ONLY_MY_DEST_MAC)
-
-#define RX_CONFIG_OPTION_FOR_IBSS_JOIN   (RX_CFG_ENABLE_ONLY_MY_SSID | \
-					  RX_CFG_ENABLE_ONLY_MY_DEST_MAC)
-
-#define RX_FILTER_OPTION_DEF	      (CFG_RX_MGMT_EN | CFG_RX_DATA_EN\
-				       | CFG_RX_CTL_EN | CFG_RX_BCN_EN\
-				       | CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
-
-#define RX_FILTER_OPTION_FILTER_ALL	 0
-
-#define RX_FILTER_OPTION_DEF_PRSP_BCN  (CFG_RX_PRSP_EN | CFG_RX_MGMT_EN\
-					| CFG_RX_RCTS_ACK | CFG_RX_BCN_EN)
-
-#define RX_FILTER_OPTION_JOIN	     (CFG_RX_MGMT_EN | CFG_RX_DATA_EN\
-				      | CFG_RX_BCN_EN | CFG_RX_AUTH_EN\
-				      | CFG_RX_ASSOC_EN | CFG_RX_RCTS_ACK\
-				      | CFG_RX_PRSP_EN)
-
-
 /*===============================================
  EEPROM Read/Write Request 32bit RW
  ------------------------------------------
  1 EE_READ - EEPROM Read Request 1 - Setting this bit
  loads a single byte of data into the EE_DATA
  register from the EEPROM location specified in
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 46f4af6..7a0c5fe 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -280,17 +280,6 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 					     &wl->rx_streaming_enable_work);
 
 		mod_timer(&wl->rx_streaming_timer,
 			  jiffies + msecs_to_jiffies(timeout));
 	}
 }
-
-void wl1271_set_default_filters(struct wl1271 *wl)
-{
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
-		wl->rx_config = WL1271_DEFAULT_AP_RX_CONFIG;
-		wl->rx_filter = WL1271_DEFAULT_AP_RX_FILTER;
-	} else {
-		wl->rx_config = WL1271_DEFAULT_STA_RX_CONFIG;
-		wl->rx_filter = WL1271_DEFAULT_STA_RX_FILTER;
-	}
-}
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 0325b9d..d3c0591 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -128,9 +128,8 @@ struct wl1271_rx_descriptor {
 	u8  pad_len;
 	u8  reserved;
 } __packed;
 
 void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
-void wl1271_set_default_filters(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index edfe01c..78a9b23 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -164,15 +164,12 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 	if (cmd->params.n_ch == 0) {
 		ret = WL1271_NOTHING_TO_SCAN;
 		goto out;
 	}
 
 	cmd->params.tx_rate = cpu_to_le32(basic_rate);
-	cmd->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
-	cmd->params.rx_filter_options =
-		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN | CFG_RX_BCN_EN);
 
 	cmd->params.n_probe_reqs = wl->conf.scan.num_probe_reqs;
 	cmd->params.tx_rate = cpu_to_le32(basic_rate);
 	cmd->params.tid_trigger = 0;
 	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 938af1d..8a745fb 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -87,15 +87,13 @@ static int wl1271_tx_update_filters(struct wl1271 *wl,
 	 * responses coming from BSSIDs it isn't familiar with (e.g. on
 	 * roaming)
 	 */
 	if (!ieee80211_is_auth(hdr->frame_control))
 		return 0;
 
-	wl1271_configure_filters(wl, FIF_OTHER_BSS);
-
-	return wl1271_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
+	return 0;
 }
 
 static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 						 struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 0bdeae5..7707895 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -109,30 +109,12 @@ extern u32 wl12xx_debug_level;
 				       DUMP_PREFIX_OFFSET, 16, 1,	\
 				       buf,				\
 				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
 				       true);				\
 	} while (0)
 
-#define WL1271_DEFAULT_STA_RX_CONFIG (CFG_UNI_FILTER_EN |	\
-				  CFG_BSSID_FILTER_EN | \
-				  CFG_MC_FILTER_EN)
-
-#define WL1271_DEFAULT_STA_RX_FILTER (CFG_RX_RCTS_ACK | CFG_RX_PRSP_EN |  \
-				  CFG_RX_MGMT_EN | CFG_RX_DATA_EN |   \
-				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
-				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
-
-#define WL1271_DEFAULT_AP_RX_CONFIG  0
-
-#define WL1271_DEFAULT_AP_RX_FILTER  (CFG_RX_RCTS_ACK | CFG_RX_PREQ_EN | \
-				  CFG_RX_MGMT_EN | CFG_RX_DATA_EN | \
-				  CFG_RX_CTL_EN | CFG_RX_AUTH_EN | \
-				  CFG_RX_ASSOC_EN)
-
-
-
 #define WL127X_FW_NAME "ti-connectivity/wl127x-fw-3.bin"
 #define WL128X_FW_NAME "ti-connectivity/wl128x-fw-3.bin"
 
 /*
  * wl127x and wl128x are using the same NVS file name. However, the
  * ini parameters between them are different.  The driver validates
@@ -529,16 +511,12 @@ struct wl1271 {
 
 	/* Rx Streaming */
 	struct work_struct rx_streaming_enable_work;
 	struct work_struct rx_streaming_disable_work;
 	struct timer_list rx_streaming_timer;
 
-	unsigned int filters;
-	unsigned int rx_config;
-	unsigned int rx_filter;
-
 	struct completion *elp_compl;
 	struct completion *ps_compl;
 	struct delayed_work elp_work;
 	struct delayed_work pspoll_work;
 
 	/* counter for ps-poll delivery failures */
-- 
1.7.6.401.g6a319

