Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57549 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab0L2Xci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 18:32:38 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so4753430eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 15:32:37 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v4 09/18] wl1271: Configure AP on BSS info change
Date: Thu, 30 Dec 2010 01:32:04 +0200
Message-Id: <1293665533-7599-10-git-send-email-arik@wizery.com>
In-Reply-To: <1293665533-7599-1-git-send-email-arik@wizery.com>
References: <1293665533-7599-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure AP-specific beacon and probe response templates.
Start the AP when beaconing is enabled.

The wl1271_bss_info_changed() function has been split into AP/STA
specific handlers.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |  340 +++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +
 2 files changed, 234 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d1075a5..0f16307 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1843,7 +1843,7 @@ out:
 	return ret;
 }
 
-static void wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
+static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 			    int offset)
 {
 	u8 *ptr = skb->data + offset;
@@ -1853,89 +1853,206 @@ static void wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 		if (ptr[0] == WLAN_EID_SSID) {
 			wl->ssid_len = ptr[1];
 			memcpy(wl->ssid, ptr+2, wl->ssid_len);
-			return;
+			return 0;
 		}
 		ptr += (ptr[1] + 2);
 	}
+
 	wl1271_error("No SSID in IEs!\n");
+	return -ENOENT;
 }
 
-static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
+static int wl1271_bss_erp_info_changed(struct wl1271 *wl,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
 {
-	enum wl1271_cmd_ps_mode mode;
-	struct wl1271 *wl = hw->priv;
-	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
-	bool do_join = false;
-	bool set_assoc = false;
-	int ret;
+	int ret = 0;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (bss_conf->use_short_slot)
+			ret = wl1271_acx_slot(wl, SLOT_TIME_SHORT);
+		else
+			ret = wl1271_acx_slot(wl, SLOT_TIME_LONG);
+		if (ret < 0) {
+			wl1271_warning("Set slot time failed %d", ret);
+			goto out;
+		}
+	}
 
-	mutex_lock(&wl->mutex);
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		if (bss_conf->use_short_preamble)
+			wl1271_acx_set_preamble(wl, ACX_PREAMBLE_SHORT);
+		else
+			wl1271_acx_set_preamble(wl, ACX_PREAMBLE_LONG);
+	}
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
-		goto out;
+	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
+		if (bss_conf->use_cts_prot)
+			ret = wl1271_acx_cts_protect(wl, CTSPROTECT_ENABLE);
+		else
+			ret = wl1271_acx_cts_protect(wl, CTSPROTECT_DISABLE);
+		if (ret < 0) {
+			wl1271_warning("Set ctsprotect failed %d", ret);
+			goto out;
+		}
+	}
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
-	if (ret < 0)
-		goto out;
+out:
+	return ret;
+}
 
-	if ((changed & BSS_CHANGED_BEACON_INT) &&
-	    (wl->bss_type == BSS_TYPE_IBSS)) {
-		wl1271_debug(DEBUG_ADHOC, "ad-hoc beacon interval updated: %d",
+static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_bss_conf *bss_conf,
+					  u32 changed)
+{
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	int ret = 0;
+
+	if ((changed & BSS_CHANGED_BEACON_INT)) {
+		wl1271_debug(DEBUG_MASTER, "beacon interval updated: %d",
 			bss_conf->beacon_int);
 
 		wl->beacon_int = bss_conf->beacon_int;
-		do_join = true;
 	}
 
-	if ((changed & BSS_CHANGED_BEACON) &&
-	    (wl->bss_type == BSS_TYPE_IBSS)) {
-		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+	if ((changed & BSS_CHANGED_BEACON)) {
+		struct ieee80211_hdr *hdr;
+		int ieoffset = offsetof(struct ieee80211_mgmt,
+					u.beacon.variable);
+		struct sk_buff *beacon = ieee80211_beacon_get(wl->hw, vif);
+		u16 tmpl_id;
+
+		if (!beacon)
+			goto out;
+
+		wl1271_debug(DEBUG_MASTER, "beacon updated");
+
+		ret = wl1271_ssid_set(wl, beacon, ieoffset);
+		if (ret < 0) {
+			dev_kfree_skb(beacon);
+			goto out;
+		}
+		tmpl_id = is_ap ? CMD_TEMPL_AP_BEACON :
+				  CMD_TEMPL_BEACON;
+		ret = wl1271_cmd_template_set(wl, tmpl_id,
+					      beacon->data,
+					      beacon->len, 0,
+					      wl1271_tx_min_rate_get(wl));
+		if (ret < 0) {
+			dev_kfree_skb(beacon);
+			goto out;
+		}
+
+		hdr = (struct ieee80211_hdr *) beacon->data;
+		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						 IEEE80211_STYPE_PROBE_RESP);
+
+		tmpl_id = is_ap ? CMD_TEMPL_AP_PROBE_RESPONSE :
+				  CMD_TEMPL_PROBE_RESPONSE;
+		ret = wl1271_cmd_template_set(wl,
+					      tmpl_id,
+					      beacon->data,
+					      beacon->len, 0,
+					      wl1271_tx_min_rate_get(wl));
+		dev_kfree_skb(beacon);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	return ret;
+}
+
+/* AP mode changes */
+static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_bss_conf *bss_conf,
+				       u32 changed)
+{
+	int ret = 0;
 
-		wl1271_debug(DEBUG_ADHOC, "ad-hoc beacon updated");
+	if ((changed & BSS_CHANGED_BASIC_RATES)) {
+		u32 rates = bss_conf->basic_rates;
+		struct conf_tx_rate_class mgmt_rc;
 
-		if (beacon) {
-			struct ieee80211_hdr *hdr;
-			int ieoffset = offsetof(struct ieee80211_mgmt,
-						u.beacon.variable);
+		wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl, rates);
+		wl->basic_rate = wl1271_tx_min_rate_get(wl);
+		wl1271_debug(DEBUG_AP, "basic rates: 0x%x",
+			     wl->basic_rate_set);
+
+		/* update the AP management rate policy with the new rates */
+		mgmt_rc.enabled_rates = wl->basic_rate_set;
+		mgmt_rc.long_retry_limit = 10;
+		mgmt_rc.short_retry_limit = 10;
+		mgmt_rc.aflags = 0;
+		ret = wl1271_acx_ap_rate_policy(wl, &mgmt_rc,
+						ACX_TX_AP_MODE_MGMT_RATE);
+		if (ret < 0) {
+			wl1271_error("AP mgmt policy change failed %d", ret);
+			goto out;
+		}
+	}
 
-			wl1271_ssid_set(wl, beacon, ieoffset);
+	ret = wl1271_bss_beacon_info_changed(wl, vif, bss_conf, changed);
+	if (ret < 0)
+		goto out;
 
-			ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
-						      beacon->data,
-						      beacon->len, 0,
-						      wl1271_tx_min_rate_get(wl));
+	if ((changed & BSS_CHANGED_BEACON_ENABLED)) {
+		if (bss_conf->enable_beacon) {
+			if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
+				ret = wl1271_cmd_start_bss(wl);
+				if (ret < 0)
+					goto out;
 
-			if (ret < 0) {
-				dev_kfree_skb(beacon);
-				goto out_sleep;
+				set_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
+				wl1271_debug(DEBUG_AP, "started AP");
 			}
+		} else {
+			if (test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
+				ret = wl1271_cmd_stop_bss(wl);
+				if (ret < 0)
+					goto out;
 
-			hdr = (struct ieee80211_hdr *) beacon->data;
-			hdr->frame_control = cpu_to_le16(
-				IEEE80211_FTYPE_MGMT |
-				IEEE80211_STYPE_PROBE_RESP);
+				clear_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
+				wl1271_debug(DEBUG_AP, "stopped AP");
+			}
+		}
+	}
 
-			ret = wl1271_cmd_template_set(wl,
-						      CMD_TEMPL_PROBE_RESPONSE,
-						      beacon->data,
-						      beacon->len, 0,
-						      wl1271_tx_min_rate_get(wl));
-			dev_kfree_skb(beacon);
-			if (ret < 0)
-				goto out_sleep;
+	ret = wl1271_bss_erp_info_changed(wl, bss_conf, changed);
+	if (ret < 0)
+		goto out;
+out:
+	return;
+}
 
-			/* Need to update the SSID (for filtering etc) */
-			do_join = true;
-		}
+/* STA/IBSS mode changes */
+static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
+					struct ieee80211_vif *vif,
+					struct ieee80211_bss_conf *bss_conf,
+					u32 changed)
+{
+	bool do_join = false, set_assoc = false;
+	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
+	int ret;
+	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
+
+	if (is_ibss) {
+		ret = wl1271_bss_beacon_info_changed(wl, vif, bss_conf,
+						     changed);
+		if (ret < 0)
+			goto out;
 	}
 
-	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
-	    (wl->bss_type == BSS_TYPE_IBSS)) {
+	if ((changed & BSS_CHANGED_BEACON_INT)  && is_ibss)
+		do_join = true;
+
+	/* Need to update the SSID (for filtering etc) */
+	if ((changed & BSS_CHANGED_BEACON) && is_ibss)
+		do_join = true;
+
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) && is_ibss) {
 		wl1271_debug(DEBUG_ADHOC, "ad-hoc beaconing: %s",
 			     bss_conf->enable_beacon ? "enabled" : "disabled");
 
@@ -1946,7 +2063,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		do_join = true;
 	}
 
-	if (changed & BSS_CHANGED_CQM) {
+	if ((changed & BSS_CHANGED_CQM)) {
 		bool enable = false;
 		if (bss_conf->cqm_rssi_thold)
 			enable = true;
@@ -1964,24 +2081,24 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	     * and enable the BSSID filter
 	     */
 	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
-			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
+		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
 
-			ret = wl1271_cmd_build_null_data(wl);
-			if (ret < 0)
-				goto out_sleep;
+		ret = wl1271_cmd_build_null_data(wl);
+		if (ret < 0)
+			goto out;
 
-			ret = wl1271_build_qos_null_data(wl);
-			if (ret < 0)
-				goto out_sleep;
+		ret = wl1271_build_qos_null_data(wl);
+		if (ret < 0)
+			goto out;
 
-			/* filter out all packets not from this BSSID */
-			wl1271_configure_filters(wl, 0);
+		/* filter out all packets not from this BSSID */
+		wl1271_configure_filters(wl, 0);
 
-			/* Need to update the BSSID (for filtering etc) */
-			do_join = true;
+		/* Need to update the BSSID (for filtering etc) */
+		do_join = true;
 	}
 
-	if (changed & BSS_CHANGED_ASSOC) {
+	if ((changed & BSS_CHANGED_ASSOC)) {
 		if (bss_conf->assoc) {
 			u32 rates;
 			int ieoffset;
@@ -2000,7 +2117,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl->basic_rate = wl1271_tx_min_rate_get(wl);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
-				goto out_sleep;
+				goto out;
 
 			/*
 			 * with wl1271, we don't need to update the
@@ -2010,7 +2127,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			 */
 			ret = wl1271_cmd_build_ps_poll(wl, wl->aid);
 			if (ret < 0)
-				goto out_sleep;
+				goto out;
 
 			/*
 			 * Get a template for hardware connection maintenance
@@ -2024,17 +2141,19 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			/* enable the connection monitoring feature */
 			ret = wl1271_acx_conn_monit_params(wl, true);
 			if (ret < 0)
-				goto out_sleep;
+				goto out;
 
 			/* If we want to go in PSM but we're not there yet */
 			if (test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags) &&
 			    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+				enum wl1271_cmd_ps_mode mode;
+
 				mode = STATION_POWER_SAVE_MODE;
 				ret = wl1271_ps_set_mode(wl, mode,
 							 wl->basic_rate,
 							 true);
 				if (ret < 0)
-					goto out_sleep;
+					goto out;
 			}
 		} else {
 			/* use defaults when not associated */
@@ -2054,7 +2173,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl->basic_rate = wl1271_tx_min_rate_get(wl);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
-				goto out_sleep;
+				goto out;
 
 			/* disable connection monitor features */
 			ret = wl1271_acx_conn_monit_params(wl, false);
@@ -2062,43 +2181,17 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			/* Disable the keep-alive feature */
 			ret = wl1271_acx_keep_alive_mode(wl, false);
 			if (ret < 0)
-				goto out_sleep;
+				goto out;
 
 			/* restore the bssid filter and go to dummy bssid */
 			wl1271_unjoin(wl);
 			wl1271_dummy_join(wl);
 		}
-
-	}
-
-	if (changed & BSS_CHANGED_ERP_SLOT) {
-		if (bss_conf->use_short_slot)
-			ret = wl1271_acx_slot(wl, SLOT_TIME_SHORT);
-		else
-			ret = wl1271_acx_slot(wl, SLOT_TIME_LONG);
-		if (ret < 0) {
-			wl1271_warning("Set slot time failed %d", ret);
-			goto out_sleep;
-		}
-	}
-
-	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		if (bss_conf->use_short_preamble)
-			wl1271_acx_set_preamble(wl, ACX_PREAMBLE_SHORT);
-		else
-			wl1271_acx_set_preamble(wl, ACX_PREAMBLE_LONG);
 	}
 
-	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		if (bss_conf->use_cts_prot)
-			ret = wl1271_acx_cts_protect(wl, CTSPROTECT_ENABLE);
-		else
-			ret = wl1271_acx_cts_protect(wl, CTSPROTECT_DISABLE);
-		if (ret < 0) {
-			wl1271_warning("Set ctsprotect failed %d", ret);
-			goto out_sleep;
-		}
-	}
+	ret = wl1271_bss_erp_info_changed(wl, bss_conf, changed);
+	if (ret < 0)
+		goto out;
 
 	/*
 	 * Takes care of: New association with HT enable,
@@ -2110,13 +2203,13 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true);
 		if (ret < 0) {
 			wl1271_warning("Set ht cap true failed %d", ret);
-			goto out_sleep;
+			goto out;
 		}
 			ret = wl1271_acx_set_ht_information(wl,
 				bss_conf->ht_operation_mode);
 		if (ret < 0) {
 			wl1271_warning("Set ht information failed %d", ret);
-			goto out_sleep;
+			goto out;
 		}
 	}
 	/*
@@ -2127,7 +2220,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, false);
 		if (ret < 0) {
 			wl1271_warning("Set ht cap false failed %d", ret);
-			goto out_sleep;
+			goto out;
 		}
 	}
 
@@ -2146,7 +2239,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl1271_cmd_build_arp_rsp(wl, addr);
 			if (ret < 0) {
 				wl1271_warning("build arp rsp failed: %d", ret);
-				goto out_sleep;
+				goto out;
 			}
 
 			ret = wl1271_acx_arp_ip_filter(wl,
@@ -2157,18 +2250,47 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl1271_acx_arp_ip_filter(wl, 0, addr);
 
 		if (ret < 0)
-			goto out_sleep;
+			goto out;
 	}
 
 	if (do_join) {
 		ret = wl1271_join(wl, set_assoc);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
-			goto out_sleep;
+			goto out;
 		}
 	}
 
-out_sleep:
+out:
+	return;
+}
+
+static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_bss_conf *bss_conf,
+				       u32 changed)
+{
+	struct wl1271 *wl = hw->priv;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed 0x%x",
+		     (int)changed);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	if (is_ap)
+		wl1271_bss_info_changed_ap(wl, vif, bss_conf, changed);
+	else
+		wl1271_bss_info_changed_sta(wl, vif, bss_conf, changed);
+
 	wl1271_ps_elp_sleep(wl);
 
 out:
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index ebb4a4d..a378d52 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -57,6 +57,8 @@ enum {
 	DEBUG_SDIO	= BIT(14),
 	DEBUG_FILTERS   = BIT(15),
 	DEBUG_ADHOC     = BIT(16),
+	DEBUG_AP	= BIT(17),
+	DEBUG_MASTER	= (DEBUG_ADHOC | DEBUG_AP),
 	DEBUG_ALL	= ~0,
 };
 
@@ -284,6 +286,7 @@ struct wl1271 {
 #define WL1271_FLAG_PSPOLL_FAILURE    (12)
 #define WL1271_FLAG_STA_STATE_SENT    (13)
 #define WL1271_FLAG_FW_TX_BUSY        (14)
+#define WL1271_FLAG_AP_STARTED        (15)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
-- 
1.7.1

