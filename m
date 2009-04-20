Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647AbZDTVbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:03 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/11] iwlwifi: improve scan support
Date: Mon, 20 Apr 2009 14:36:56 -0700
Message-Id: <1240263424-8495-4-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233113_726595_4A196534)
In-Reply-To: <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This modifies iwlwifi to
 * no longer build its own probe request, but use mac80211's
 * therefore, support arbitrary scan IEs (up to the max len)
 * support multiple scan SSIDs
 * support passive scanning

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |  187 +++++---------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   48 ++++---
 6 files changed, 73 insertions(+), 177 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 411a5d2..7b84d52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2474,6 +2474,7 @@ struct iwl_ssid_ie {
 #define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
 #define IWL_GOOD_CRC_TH			cpu_to_le16(1)
 #define IWL_MAX_SCAN_SIZE 1024
+#define IWL_MAX_PROBE_REQUEST		200
 
 /*
  * REPLY_SCAN_CMD = 0x80 (command)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f231752..c43c57d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1309,8 +1309,10 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->custom_regulatory = true;
-	hw->wiphy->max_scan_ssids = 1;
-	hw->wiphy->max_scan_ie_len = 0; /* XXX for now */
+
+	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
+	/* we create the 802.11 header and a zero-length SSID element */
+	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8773d73..8ab60df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -396,8 +396,8 @@ int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 int iwl_scan_initiate(struct iwl_priv *priv);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw, struct cfg80211_scan_request *req);
-u16 iwl_fill_probe_req(struct iwl_priv *priv, enum ieee80211_band band,
-		       struct ieee80211_mgmt *frame, int left);
+u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
+		       const u8 *ie, int ie_len, int left);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
 u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 			      enum ieee80211_band band,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0922e33..e363d9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -889,9 +889,7 @@ struct iwl_priv {
 	unsigned long scan_start_tsf;
 	void *scan;
 	int scan_bands;
-	int one_direct_scan;
-	u8 direct_ssid_len;
-	u8 direct_ssid[IW_ESSID_MAX_SIZE];
+	struct cfg80211_scan_request *scan_request;
 	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
 	u8 mgmt_tx_ant;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 23644cf..9edcf8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -448,13 +448,6 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	unsigned long flags;
 	struct iwl_priv *priv = hw->priv;
 	int ret;
-	u8 *ssid = NULL;
-	size_t ssid_len = 0;
-
-	if (req->n_ssids) {
-		ssid = req->ssids[0].ssid;
-		ssid_len = req->ssids[0].ssid_len;
-	}
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -488,13 +481,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	if (ssid_len) {
-		priv->one_direct_scan = 1;
-		priv->direct_ssid_len =  ssid_len;
-		memcpy(priv->direct_ssid, ssid, priv->direct_ssid_len);
-	} else {
-		priv->one_direct_scan = 0;
-	}
+	priv->scan_request = req;
 
 	ret = iwl_scan_initiate(priv);
 
@@ -533,73 +520,14 @@ void iwl_bg_scan_check(struct work_struct *data)
 EXPORT_SYMBOL(iwl_bg_scan_check);
 
 /**
- * iwl_supported_rate_to_ie - fill in the supported rate in IE field
- *
- * return : set the bit for each supported rate insert in ie
- */
-static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
-				    u16 basic_rate, int *left)
-{
-	u16 ret_rates = 0, bit;
-	int i;
-	u8 *cnt = ie;
-	u8 *rates = ie + 1;
-
-	for (bit = 1, i = 0; i < IWL_RATE_COUNT; i++, bit <<= 1) {
-		if (bit & supported_rate) {
-			ret_rates |= bit;
-			rates[*cnt] = iwl_rates[i].ieee |
-				((bit & basic_rate) ? 0x80 : 0x00);
-			(*cnt)++;
-			(*left)--;
-			if ((*left <= 0) ||
-			    (*cnt >= IWL_SUPPORTED_RATES_IE_LEN))
-				break;
-		}
-	}
-
-	return ret_rates;
-}
-
-
-static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
-			     u8 *pos, int *left)
-{
-	struct ieee80211_ht_cap *ht_cap;
-
-	if (!sband || !sband->ht_cap.ht_supported)
-		return;
-
-	if (*left < sizeof(struct ieee80211_ht_cap))
-		return;
-
-	*pos++ = sizeof(struct ieee80211_ht_cap);
-	ht_cap = (struct ieee80211_ht_cap *) pos;
-
-	ht_cap->cap_info = cpu_to_le16(sband->ht_cap.cap);
-	memcpy(&ht_cap->mcs, &sband->ht_cap.mcs, 16);
-	ht_cap->ampdu_params_info =
-		(sband->ht_cap.ampdu_factor & IEEE80211_HT_AMPDU_PARM_FACTOR) |
-		((sband->ht_cap.ampdu_density << 2) &
-			IEEE80211_HT_AMPDU_PARM_DENSITY);
-	*left -= sizeof(struct ieee80211_ht_cap);
-}
-
-/**
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
  */
 
-u16 iwl_fill_probe_req(struct iwl_priv *priv,
-		       enum ieee80211_band band,
-		       struct ieee80211_mgmt *frame,
-		       int left)
+u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
+		       const u8 *ies, int ie_len, int left)
 {
 	int len = 0;
 	u8 *pos = NULL;
-	u16 active_rates, ret_rates, cck_rates, active_rate_basic;
-	const struct ieee80211_supported_band *sband =
-						iwl_get_hw_mode(priv, band);
-
 
 	/* Make sure there is enough space for the probe request,
 	 * two mandatory IEs and the data */
@@ -627,62 +555,12 @@ u16 iwl_fill_probe_req(struct iwl_priv *priv,
 
 	len += 2;
 
-	/* fill in supported rate */
-	left -= 2;
-	if (left < 0)
-		return 0;
-
-	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos = 0;
-
-	/* exclude 60M rate */
-	active_rates = priv->rates_mask;
-	active_rates &= ~IWL_RATE_60M_MASK;
-
-	active_rate_basic = active_rates & IWL_BASIC_RATES_MASK;
-
-	cck_rates = IWL_CCK_RATES_MASK & active_rates;
-	ret_rates = iwl_supported_rate_to_ie(pos, cck_rates,
-					     active_rate_basic, &left);
-	active_rates &= ~ret_rates;
-
-	ret_rates = iwl_supported_rate_to_ie(pos, active_rates,
-					     active_rate_basic, &left);
-	active_rates &= ~ret_rates;
+	if (WARN_ON(left < ie_len))
+		return len;
 
-	len += 2 + *pos;
-	pos += (*pos) + 1;
-
-	if (active_rates == 0)
-		goto fill_end;
-
-	/* fill in supported extended rate */
-	/* ...next IE... */
-	left -= 2;
-	if (left < 0)
-		return 0;
-	/* ... fill it in... */
-	*pos++ = WLAN_EID_EXT_SUPP_RATES;
-	*pos = 0;
-	iwl_supported_rate_to_ie(pos, active_rates, active_rate_basic, &left);
-	if (*pos > 0) {
-		len += 2 + *pos;
-		pos += (*pos) + 1;
-	} else {
-		pos--;
-	}
-
- fill_end:
-
-	left -= 2;
-	if (left < 0)
-		return 0;
-
-	*pos++ = WLAN_EID_HT_CAPABILITY;
-	*pos = 0;
-	iwl_ht_cap_to_ie(sband, pos, &left);
-	if (*pos > 0)
-		len += 2 + *pos;
+	memcpy(pos, ies, ie_len);
+	len += ie_len;
+	left -= ie_len;
 
 	return (u16)len;
 }
@@ -703,10 +581,10 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	u32 rate_flags = 0;
 	u16 cmd_len;
 	enum ieee80211_band band;
-	u8 n_probes = 2;
+	u8 n_probes = 0;
 	u8 rx_chain = priv->hw_params.valid_rx_ant;
 	u8 rate;
-	DECLARE_SSID_BUF(ssid);
+	bool is_active = false;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -796,19 +674,25 @@ static void iwl_bg_request_scan(struct work_struct *data)
 			       scan_suspend_time, interval);
 	}
 
-	/* We should add the ability for user to lock to PASSIVE ONLY */
-	if (priv->one_direct_scan) {
-		IWL_DEBUG_SCAN(priv, "Start direct scan for '%s'\n",
-				print_ssid(ssid, priv->direct_ssid,
-					   priv->direct_ssid_len));
-		scan->direct_scan[0].id = WLAN_EID_SSID;
-		scan->direct_scan[0].len = priv->direct_ssid_len;
-		memcpy(scan->direct_scan[0].ssid,
-		       priv->direct_ssid, priv->direct_ssid_len);
-		n_probes++;
-	} else {
-		IWL_DEBUG_SCAN(priv, "Start indirect scan.\n");
-	}
+	if (priv->scan_request->n_ssids) {
+		int i, p = 0;
+		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
+		for (i = 0; i < priv->scan_request->n_ssids; i++) {
+			/* always does wildcard anyway */
+			if (!priv->scan_request->ssids[i].ssid_len)
+				continue;
+			scan->direct_scan[p].id = WLAN_EID_SSID;
+			scan->direct_scan[p].len =
+				priv->scan_request->ssids[i].ssid_len;
+			memcpy(scan->direct_scan[p].ssid,
+			       priv->scan_request->ssids[i].ssid,
+			       priv->scan_request->ssids[i].ssid_len);
+			n_probes++;
+			p++;
+		}
+		is_active = true;
+	} else
+		IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
@@ -850,10 +734,11 @@ static void iwl_bg_request_scan(struct work_struct *data)
 				cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
 				(rx_chain << RXON_RX_CHAIN_FORCE_SEL_POS) |
 				(0x7 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS));
-
-	cmd_len = iwl_fill_probe_req(priv, band,
-				     (struct ieee80211_mgmt *)scan->data,
-				     IWL_MAX_SCAN_SIZE - sizeof(*scan));
+	cmd_len = iwl_fill_probe_req(priv,
+				(struct ieee80211_mgmt *)scan->data,
+				priv->scan_request->ie,
+				priv->scan_request->ie_len,
+				IWL_MAX_SCAN_SIZE - sizeof(*scan));
 
 	scan->tx_cmd.len = cpu_to_le16(cmd_len);
 
@@ -864,8 +749,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 			       RXON_FILTER_BCON_AWARE_MSK);
 
 	scan->channel_count =
-		iwl_get_channels_for_scan(priv, band, 1, /* active */
-			n_probes,
+		iwl_get_channels_for_scan(priv, band, is_active, n_probes,
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
 	if (scan->channel_count == 0) {
@@ -928,6 +812,7 @@ void iwl_bg_scan_completed(struct work_struct *work)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	priv->scan_request = NULL;
 	ieee80211_scan_completed(priv->hw, false);
 
 	/* Since setting the TXPOWER may have been deferred while
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5937933..94f10f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2942,9 +2942,9 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	int rc = 0;
 	struct iwl3945_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
-	u8 n_probes = 2;
+	u8 n_probes = 0;
 	enum ieee80211_band band;
-	DECLARE_SSID_BUF(ssid);
+	bool is_active = false;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -3043,18 +3043,25 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 			       scan_suspend_time, interval);
 	}
 
-	/* We should add the ability for user to lock to PASSIVE ONLY */
-	if (priv->one_direct_scan) {
-		IWL_DEBUG_SCAN(priv, "Kicking off one direct scan for '%s'\n",
-				print_ssid(ssid, priv->direct_ssid,
-				priv->direct_ssid_len));
-		scan->direct_scan[0].id = WLAN_EID_SSID;
-		scan->direct_scan[0].len = priv->direct_ssid_len;
-		memcpy(scan->direct_scan[0].ssid,
-		       priv->direct_ssid, priv->direct_ssid_len);
-		n_probes++;
+	if (priv->scan_request->n_ssids) {
+		int i, p = 0;
+		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
+		for (i = 0; i < priv->scan_request->n_ssids; i++) {
+			/* always does wildcard anyway */
+			if (!priv->scan_request->ssids[i].ssid_len)
+				continue;
+			scan->direct_scan[p].id = WLAN_EID_SSID;
+			scan->direct_scan[p].len =
+				priv->scan_request->ssids[i].ssid_len;
+			memcpy(scan->direct_scan[p].ssid,
+			       priv->scan_request->ssids[i].ssid,
+			       priv->scan_request->ssids[i].ssid_len);
+			n_probes++;
+			p++;
+		}
+		is_active = true;
 	} else
-		IWL_DEBUG_SCAN(priv, "Kicking off one indirect scan.\n");
+		IWL_DEBUG_SCAN(priv, "Kicking off passive scan.\n");
 
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
@@ -3079,9 +3086,11 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	}
 
 	scan->tx_cmd.len = cpu_to_le16(
-		iwl_fill_probe_req(priv, band,
-				   (struct ieee80211_mgmt *)scan->data,
-				   IWL_MAX_SCAN_SIZE - sizeof(*scan)));
+			iwl_fill_probe_req(priv,
+				(struct ieee80211_mgmt *)scan->data,
+				priv->scan_request->ie,
+				priv->scan_request->ie_len,
+				IWL_MAX_SCAN_SIZE - sizeof(*scan)));
 
 	/* select Rx antennas */
 	scan->flags |= iwl3945_get_antenna_flags(priv);
@@ -3090,8 +3099,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
 	scan->channel_count =
-		iwl3945_get_channels_for_scan(priv, band, 1, /* active */
-					      n_probes,
+		iwl3945_get_channels_for_scan(priv, band, is_active, n_probes,
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
 	if (scan->channel_count == 0) {
@@ -4119,7 +4127,9 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 
 	hw->wiphy->custom_regulatory = true;
 
-	hw->wiphy->max_scan_ssids = 1; /* WILL FIX */
+	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX_3945;
+	/* we create the 802.11 header and a zero-length SSID element */
+	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
-- 
1.5.6.3

