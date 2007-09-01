Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61850 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbXIAEgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:55 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 1EBDB618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:55 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 28/35] Convert dbg() to at76_dbg() or remove it
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:54 -0400
Message-ID: <20070901043654.2498.77110.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using two debug macros is inconsistent.  Besides, dbg() only prints
something if DEBUG is defined.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |  283 ++++++++++++++++++---------------------
 1 files changed, 127 insertions(+), 156 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index fb4a45c..c648d5c 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1063,40 +1063,40 @@ static int at76_dump_mib_mac_wep(struct at76_priv *priv)
 {
 	int ret = 0;
 	char *defkey;
-	struct mib_mac_wep *mac_wep =
-	    kmalloc(sizeof(struct mib_mac_wep), GFP_KERNEL);
+	struct mib_mac_wep *m = kmalloc(sizeof(struct mib_mac_wep), GFP_KERNEL);
 
-	if (!mac_wep) {
+	if (!m) {
 		ret = -ENOMEM;
 		goto exit;
 	}
-	ret = at76_get_mib(priv->udev, MIB_MAC_WEP, mac_wep,
-			   sizeof(struct mib_mac_wep));
+	ret =
+	    at76_get_mib(priv->udev, MIB_MAC_WEP, m,
+			 sizeof(struct mib_mac_wep));
 	if (ret < 0) {
 		err("%s: at76_get_mib (MAC_WEP) failed: %d", priv->netdev->name,
 		    ret);
 		goto error;
 	}
 
-	if (mac_wep->wep_default_key_id < 4)
+	if (m->wep_default_key_id < 4)
 		defkey =
-		    hex2str(mac_wep->
-			    wep_default_keyvalue[mac_wep->wep_default_key_id],
-			    mac_wep->encryption_level == 2 ? 13 : 5);
+		    hex2str(m->
+			    wep_default_keyvalue[m->wep_default_key_id],
+			    m->encryption_level == 2 ? 13 : 5);
 	else
 		defkey = "<invalid key id>";
 
-	dbg("%s: MIB MAC_WEP: priv_invoked %u def_key_id %u key_len %u "
-	    "excl_unencr %u wep_icv_err %u wep_excluded %u encr_level %u "
-	    "key %d: %s", priv->netdev->name, mac_wep->privacy_invoked,
-	    mac_wep->wep_default_key_id, mac_wep->wep_key_mapping_len,
-	    mac_wep->exclude_unencrypted,
-	    le32_to_cpu(mac_wep->wep_icv_error_count),
-	    le32_to_cpu(mac_wep->wep_excluded_count), mac_wep->encryption_level,
-	    mac_wep->wep_default_key_id, defkey);
+	at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: priv_invoked %u def_key_id %u "
+		 "key_len %u excl_unencr %u wep_icv_err %u wep_excluded %u "
+		 "encr_level %u key %d: %s", priv->netdev->name,
+		 m->privacy_invoked, m->wep_default_key_id,
+		 m->wep_key_mapping_len, m->exclude_unencrypted,
+		 le32_to_cpu(m->wep_icv_error_count),
+		 le32_to_cpu(m->wep_excluded_count), m->encryption_level,
+		 m->wep_default_key_id, defkey);
 
 error:
-	kfree(mac_wep);
+	kfree(m);
 exit:
 	return ret;
 }
@@ -1104,51 +1104,43 @@ exit:
 static int at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 {
 	int ret = 0;
-	struct mib_mac_mgmt *mac_mgmt =
+	struct mib_mac_mgmt *m =
 	    kmalloc(sizeof(struct mib_mac_mgmt), GFP_KERNEL);
 	char country_string[4];
 
-	if (!mac_mgmt) {
+	if (!m) {
 		ret = -ENOMEM;
 		goto exit;
 	}
-	ret = at76_get_mib(priv->udev, MIB_MAC_MGMT, mac_mgmt,
+	ret = at76_get_mib(priv->udev, MIB_MAC_MGMT, m,
 			   sizeof(struct mib_mac_mgmt));
 	if (ret < 0) {
 		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
 		goto error;
 	}
 
-	memcpy(&country_string, mac_mgmt->country_string, 3);
+	memcpy(&country_string, m->country_string, 3);
 	country_string[3] = '\0';
 
-	dbg("%s: MIB MAC_MGMT: beacon_period %d CFP_max_duration %d "
-	    "medium_occupancy_limit %d station_id 0x%x ATIM_window %d "
-	    "CFP_mode %d privacy_opt_impl %d DTIM_period %d CFP_period %d "
-	    "current_bssid %s current_essid %s current_bss_type %d "
-	    "pm_mode %d ibss_change %d res %d "
-	    "multi_domain_capability_implemented %d "
-	    "international_roaming %d country_string %s",
-	    priv->netdev->name,
-	    le16_to_cpu(mac_mgmt->beacon_period),
-	    le16_to_cpu(mac_mgmt->CFP_max_duration),
-	    le16_to_cpu(mac_mgmt->medium_occupancy_limit),
-	    le16_to_cpu(mac_mgmt->station_id),
-	    le16_to_cpu(mac_mgmt->ATIM_window),
-	    mac_mgmt->CFP_mode,
-	    mac_mgmt->privacy_option_implemented,
-	    mac_mgmt->DTIM_period,
-	    mac_mgmt->CFP_period,
-	    mac2str(mac_mgmt->current_bssid),
-	    hex2str(mac_mgmt->current_essid, IW_ESSID_MAX_SIZE),
-	    mac_mgmt->current_bss_type,
-	    mac_mgmt->power_mgmt_mode,
-	    mac_mgmt->ibss_change,
-	    mac_mgmt->res,
-	    mac_mgmt->multi_domain_capability_implemented,
-	    mac_mgmt->multi_domain_capability_enabled, country_string);
+	at76_dbg(DBG_MIB, "%s: MIB MAC_MGMT: beacon_period %d CFP_max_duration "
+		 "%d medium_occupancy_limit %d station_id 0x%x ATIM_window %d "
+		 "CFP_mode %d privacy_opt_impl %d DTIM_period %d CFP_period %d "
+		 "current_bssid %s current_essid %s current_bss_type %d "
+		 "pm_mode %d ibss_change %d res %d "
+		 "multi_domain_capability_implemented %d "
+		 "international_roaming %d country_string %s",
+		 priv->netdev->name, le16_to_cpu(m->beacon_period),
+		 le16_to_cpu(m->CFP_max_duration),
+		 le16_to_cpu(m->medium_occupancy_limit),
+		 le16_to_cpu(m->station_id), le16_to_cpu(m->ATIM_window),
+		 m->CFP_mode, m->privacy_option_implemented, m->DTIM_period,
+		 m->CFP_period, mac2str(m->current_bssid),
+		 hex2str(m->current_essid, IW_ESSID_MAX_SIZE),
+		 m->current_bss_type, m->power_mgmt_mode, m->ibss_change,
+		 m->res, m->multi_domain_capability_implemented,
+		 m->multi_domain_capability_enabled, country_string);
 error:
-	kfree(mac_mgmt);
+	kfree(m);
 exit:
 	return ret;
 }
@@ -1156,44 +1148,38 @@ exit:
 static int at76_dump_mib_mac(struct at76_priv *priv)
 {
 	int ret = 0;
-	struct mib_mac *mac = kmalloc(sizeof(struct mib_mac), GFP_KERNEL);
+	struct mib_mac *m = kmalloc(sizeof(struct mib_mac), GFP_KERNEL);
 
-	if (!mac) {
+	if (!m) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	ret = at76_get_mib(priv->udev, MIB_MAC, mac, sizeof(struct mib_mac));
+	ret = at76_get_mib(priv->udev, MIB_MAC, m, sizeof(struct mib_mac));
 	if (ret < 0) {
 		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
 		goto error;
 	}
 
-	dbg("%s: MIB MAC: max_tx_msdu_lifetime %d max_rx_lifetime %d "
-	    "frag_threshold %d rts_threshold %d cwmin %d cwmax %d "
-	    "short_retry_time %d long_retry_time %d scan_type %d "
-	    "scan_channel %d probe_delay %u min_channel_time %d "
-	    "max_channel_time %d listen_int %d desired_ssid %s "
-	    "desired_bssid %s desired_bsstype %d",
-	    priv->netdev->name,
-	    le32_to_cpu(mac->max_tx_msdu_lifetime),
-	    le32_to_cpu(mac->max_rx_lifetime),
-	    le16_to_cpu(mac->frag_threshold),
-	    le16_to_cpu(mac->rts_threshold),
-	    le16_to_cpu(mac->cwmin),
-	    le16_to_cpu(mac->cwmax),
-	    mac->short_retry_time,
-	    mac->long_retry_time,
-	    mac->scan_type,
-	    mac->scan_channel,
-	    le16_to_cpu(mac->probe_delay),
-	    le16_to_cpu(mac->min_channel_time),
-	    le16_to_cpu(mac->max_channel_time),
-	    le16_to_cpu(mac->listen_interval),
-	    hex2str(mac->desired_ssid, IW_ESSID_MAX_SIZE),
-	    mac2str(mac->desired_bssid), mac->desired_bsstype);
+	at76_dbg(DBG_MIB, "%s: MIB MAC: max_tx_msdu_lifetime %d "
+		 "max_rx_lifetime %d frag_threshold %d rts_threshold %d "
+		 "cwmin %d cwmax %d short_retry_time %d long_retry_time %d "
+		 "scan_type %d scan_channel %d probe_delay %u "
+		 "min_channel_time %d max_channel_time %d listen_int %d "
+		 "desired_ssid %s desired_bssid %s desired_bsstype %d",
+		 priv->netdev->name, le32_to_cpu(m->max_tx_msdu_lifetime),
+		 le32_to_cpu(m->max_rx_lifetime),
+		 le16_to_cpu(m->frag_threshold), le16_to_cpu(m->rts_threshold),
+		 le16_to_cpu(m->cwmin), le16_to_cpu(m->cwmax),
+		 m->short_retry_time, m->long_retry_time, m->scan_type,
+		 m->scan_channel, le16_to_cpu(m->probe_delay),
+		 le16_to_cpu(m->min_channel_time),
+		 le16_to_cpu(m->max_channel_time),
+		 le16_to_cpu(m->listen_interval),
+		 hex2str(m->desired_ssid, IW_ESSID_MAX_SIZE),
+		 mac2str(m->desired_bssid), m->desired_bsstype);
 error:
-	kfree(mac);
+	kfree(m);
 exit:
 	return ret;
 }
@@ -1201,38 +1187,35 @@ exit:
 static int at76_dump_mib_phy(struct at76_priv *priv)
 {
 	int ret = 0;
-	struct mib_phy *phy = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
+	struct mib_phy *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
 
-	if (!phy) {
+	if (!m) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	ret = at76_get_mib(priv->udev, MIB_PHY, phy, sizeof(struct mib_phy));
+	ret = at76_get_mib(priv->udev, MIB_PHY, m, sizeof(struct mib_phy));
 	if (ret < 0) {
 		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
 		goto error;
 	}
 
-	dbg("%s: MIB PHY: ed_threshold %d slot_time %d sifs_time %d "
-	    "preamble_length %d plcp_header_length %d mpdu_max_length %d "
-	    "cca_mode_supported %d operation_rate_set "
-	    "0x%x 0x%x 0x%x 0x%x channel_id %d current_cca_mode %d "
-	    "phy_type %d current_reg_domain %d",
-	    priv->netdev->name,
-	    le32_to_cpu(phy->ed_threshold),
-	    le16_to_cpu(phy->slot_time),
-	    le16_to_cpu(phy->sifs_time),
-	    le16_to_cpu(phy->preamble_length),
-	    le16_to_cpu(phy->plcp_header_length),
-	    le16_to_cpu(phy->mpdu_max_length),
-	    le16_to_cpu(phy->cca_mode_supported),
-	    phy->operation_rate_set[0], phy->operation_rate_set[1],
-	    phy->operation_rate_set[2], phy->operation_rate_set[3],
-	    phy->channel_id,
-	    phy->current_cca_mode, phy->phy_type, phy->current_reg_domain);
+	at76_dbg(DBG_MIB, "%s: MIB PHY: ed_threshold %d slot_time %d "
+		 "sifs_time %d preamble_length %d plcp_header_length %d "
+		 "mpdu_max_length %d cca_mode_supported %d operation_rate_set "
+		 "0x%x 0x%x 0x%x 0x%x channel_id %d current_cca_mode %d "
+		 "phy_type %d current_reg_domain %d",
+		 priv->netdev->name, le32_to_cpu(m->ed_threshold),
+		 le16_to_cpu(m->slot_time), le16_to_cpu(m->sifs_time),
+		 le16_to_cpu(m->preamble_length),
+		 le16_to_cpu(m->plcp_header_length),
+		 le16_to_cpu(m->mpdu_max_length),
+		 le16_to_cpu(m->cca_mode_supported), m->operation_rate_set[0],
+		 m->operation_rate_set[1], m->operation_rate_set[2],
+		 m->operation_rate_set[3], m->channel_id, m->current_cca_mode,
+		 m->phy_type, m->current_reg_domain);
 error:
-	kfree(phy);
+	kfree(m);
 exit:
 	return ret;
 }
@@ -1240,28 +1223,26 @@ exit:
 static int at76_dump_mib_local(struct at76_priv *priv)
 {
 	int ret = 0;
-	struct mib_local *local = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
+	struct mib_local *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
 
-	if (!local) {
+	if (!m) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	ret = at76_get_mib(priv->udev, MIB_LOCAL, local,
-			   sizeof(struct mib_local));
+	ret = at76_get_mib(priv->udev, MIB_LOCAL, m, sizeof(struct mib_local));
 	if (ret < 0) {
 		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
 		goto error;
 	}
 
-	dbg("%s: MIB PHY: beacon_enable %d txautorate_fallback %d "
-	    "ssid_size %d promiscuous_mode %d preamble_type %d",
-	    priv->netdev->name,
-	    local->beacon_enable,
-	    local->txautorate_fallback,
-	    local->ssid_size, local->promiscuous_mode, local->preamble_type);
+	at76_dbg(DBG_MIB, "%s: MIB PHY: beacon_enable %d "
+		 "txautorate_fallback %d ssid_size %d promiscuous_mode %d "
+		 "preamble_type %d", priv->netdev->name, m->beacon_enable,
+		 m->txautorate_fallback, m->ssid_size, m->promiscuous_mode,
+		 m->preamble_type);
 error:
-	kfree(local);
+	kfree(m);
 exit:
 	return ret;
 }
@@ -2934,19 +2915,18 @@ static int at76_iw_set_debug(struct net_device *netdev,
 		if (ptr == extra)
 			val = DBG_DEFAULTS;
 
-		dbg("%s: AT76_SET_DEBUG input %d: %s -> 0x%x",
-		    netdev->name, data->length, extra, val);
+		at76_dbg(DBG_IOCTL, "%s: AT76_SET_DEBUG input %d: %s -> 0x%x",
+			 netdev->name, data->length, extra, val);
 	} else
 		val = DBG_DEFAULTS;
 
-	dbg("%s: AT76_SET_DEBUG, old 0x%x, new 0x%x",
-	    netdev->name, at76_debug, val);
+	at76_dbg(DBG_IOCTL, "%s: AT76_SET_DEBUG, old 0x%x, new 0x%x",
+		 netdev->name, at76_debug, val);
 
 	/* jal: some more output to pin down lockups */
-	dbg("%s: netif running %d queue_stopped %d carrier_ok %d",
-	    netdev->name,
-	    netif_running(netdev),
-	    netif_queue_stopped(netdev), netif_carrier_ok(netdev));
+	at76_dbg(DBG_IOCTL, "%s: netif running %d queue_stopped %d "
+		 "carrier_ok %d", netdev->name, netif_running(netdev),
+		 netif_queue_stopped(netdev), netif_carrier_ok(netdev));
 
 	at76_debug = val;
 
@@ -4025,39 +4005,38 @@ static int at76_startup_device(struct at76_priv *priv)
 {
 	struct at76_card_config *ccfg = &priv->card_config;
 	int ret;
-
-	if (at76_debug & DBG_PARAMS) {
-		char ossid[IW_ESSID_MAX_SIZE + 1];
-
-		/* make priv->essid printable */
-		BUG_ON(priv->essid_size > IW_ESSID_MAX_SIZE);
-		memcpy(ossid, priv->essid, priv->essid_size);
-		ossid[priv->essid_size] = '\0';
-
-		dbg("%s param: ssid %s (%s) mode %s ch %d wep %s key %d "
-		    "keylen %d", priv->netdev->name, ossid,
-		    hex2str(priv->essid, IW_ESSID_MAX_SIZE),
-		    priv->iw_mode == IW_MODE_ADHOC ? "adhoc" : "infra",
-		    priv->channel, priv->wep_enabled ? "enabled" : "disabled",
-		    priv->wep_key_id, priv->wep_keys_len[priv->wep_key_id]);
-		dbg("%s param: preamble %s rts %d retry %d frag %d "
-		    "txrate %s auth_mode %d", priv->netdev->name,
-		    preambles[priv->preamble_type], priv->rts_threshold,
-		    priv->short_retry_limit, priv->frag_threshold,
-		    priv->txrate == TX_RATE_1MBIT ? "1MBit" : priv->txrate ==
-		    TX_RATE_2MBIT ? "2MBit" : priv->txrate ==
-		    TX_RATE_5_5MBIT ? "5.5MBit" : priv->txrate ==
-		    TX_RATE_11MBIT ? "11MBit" : priv->txrate ==
-		    TX_RATE_AUTO ? "auto" : "<invalid>", priv->auth_mode);
-		dbg("%s param: pm_mode %d pm_period %d auth_mode %s "
-		    "scan_times %d %d scan_mode %s international_roaming %d",
-		    priv->netdev->name, priv->pm_mode, priv->pm_period,
-		    priv->auth_mode ==
-		    WLAN_AUTH_OPEN ? "open" : "shared_secret",
-		    priv->scan_min_time, priv->scan_max_time,
-		    priv->scan_mode == SCAN_TYPE_ACTIVE ? "active" : "passive",
-		    priv->international_roaming);
-	}
+	char ossid[IW_ESSID_MAX_SIZE + 1];
+
+	/* make priv->essid printable */
+	BUG_ON(priv->essid_size > IW_ESSID_MAX_SIZE);
+	memcpy(ossid, priv->essid, priv->essid_size);
+	ossid[priv->essid_size] = '\0';
+
+	at76_dbg(DBG_PARAMS,
+		 "%s param: ssid %s (%s) mode %s ch %d wep %s key %d "
+		 "keylen %d", priv->netdev->name, ossid,
+		 hex2str(priv->essid, IW_ESSID_MAX_SIZE),
+		 priv->iw_mode == IW_MODE_ADHOC ? "adhoc" : "infra",
+		 priv->channel, priv->wep_enabled ? "enabled" : "disabled",
+		 priv->wep_key_id, priv->wep_keys_len[priv->wep_key_id]);
+	at76_dbg(DBG_PARAMS,
+		 "%s param: preamble %s rts %d retry %d frag %d "
+		 "txrate %s auth_mode %d", priv->netdev->name,
+		 preambles[priv->preamble_type], priv->rts_threshold,
+		 priv->short_retry_limit, priv->frag_threshold,
+		 priv->txrate == TX_RATE_1MBIT ? "1MBit" : priv->txrate ==
+		 TX_RATE_2MBIT ? "2MBit" : priv->txrate ==
+		 TX_RATE_5_5MBIT ? "5.5MBit" : priv->txrate ==
+		 TX_RATE_11MBIT ? "11MBit" : priv->txrate ==
+		 TX_RATE_AUTO ? "auto" : "<invalid>", priv->auth_mode);
+	at76_dbg(DBG_PARAMS,
+		 "%s param: pm_mode %d pm_period %d auth_mode %s "
+		 "scan_times %d %d scan_mode %s international_roaming %d",
+		 priv->netdev->name, priv->pm_mode, priv->pm_period,
+		 priv->auth_mode == WLAN_AUTH_OPEN ? "open" : "shared_secret",
+		 priv->scan_min_time, priv->scan_max_time,
+		 priv->scan_mode == SCAN_TYPE_ACTIVE ? "active" : "passive",
+		 priv->international_roaming);
 
 	memset(ccfg, 0, sizeof(struct at76_card_config));
 	ccfg->promiscuous_mode = 0;
@@ -4758,9 +4737,6 @@ static void at76_ieee80211_to_eth(struct sk_buff *skb, int iw_mode)
 
 	i802_11_hdr = (struct ieee80211_hdr_3addr *)skb->data;
 
-	dbg("%s: ENTRY skb len %d data %s", __func__,
-	    skb->len, hex2str(skb->data, 64));
-
 	/* That would be the ethernet header if the hardware converted
 	 * the frame for us.  Make sure the source and the destination
 	 * match the 802.11 header.  Which hardware does it? */
@@ -4802,11 +4778,6 @@ static void at76_ieee80211_to_eth(struct sk_buff *skb, int iw_mode)
 	}
 
 	skb->protocol = eth_type_trans(skb, skb->dev);
-
-	dbg("%s: EXIT skb da %s sa %s proto 0x%04x len %d data %s",
-	    __func__, mac2str(eth_hdr(skb)->h_dest),
-	    mac2str(eth_hdr(skb)->h_source), ntohs(skb->protocol), skb->len,
-	    hex2str(skb->data, 64));
 }
 
 /* Check for fragmented data in priv->rx_skb. If the packet was no fragment
