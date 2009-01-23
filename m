Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbZAWVms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:48 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/15] iwl3945: Use iwlcore scan code
Date: Fri, 23 Jan 2009 13:45:12 -0800
Message-Id: <1232747123-7261-5-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224256_611582_E7D3F291)
In-Reply-To: <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

A lot of the scanning related code is duplicated between 3945 and agn. Let's
use the iwlcore one and get rid of the 3945.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |   21 ++
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   42 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  289 +--------------------------
 3 files changed, 51 insertions(+), 301 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2f23f78..409caaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -316,9 +316,30 @@ void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 int iwl_scan_initiate(struct iwl_priv *priv);
+u16 iwl_fill_probe_req(struct iwl_priv *priv, enum ieee80211_band band,
+		       struct ieee80211_mgmt *frame, int left);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
+u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
+			      enum ieee80211_band band,
+			      u8 n_probes);
+u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
+			       enum ieee80211_band band);
+void iwl_bg_scan_check(struct work_struct *data);
+void iwl_bg_abort_scan(struct work_struct *work);
+void iwl_bg_scan_completed(struct work_struct *work);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 
+/* For faster active scanning, scan will move to the next channel if fewer than
+ * PLCP_QUIET_THRESH packets are heard on this channel within
+ * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
+ * time if it's a quiet channel (nothing responded to our probe, and there's
+ * no other traffic).
+ * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
+#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(10)  /* msec */
+#define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)  /* packets */
+
+#define IWL_SCAN_PROBE_MASK(n) 	cpu_to_le32((BIT(n) | (BIT(n) - BIT(1))))
+
 /*******************************************************************************
  * Calibrations - implemented in iwl-calib.c
  ******************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index e510f51..0ce122a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -46,15 +46,6 @@
 #define IWL_ACTIVE_DWELL_FACTOR_24GHZ (3)
 #define IWL_ACTIVE_DWELL_FACTOR_52GHZ (2)
 
-/* For faster active scanning, scan will move to the next channel if fewer than
- * PLCP_QUIET_THRESH packets are heard on this channel within
- * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
- * time if it's a quiet channel (nothing responded to our probe, and there's
- * no other traffic).
- * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
-#define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)  /* packets */
-#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(10)  /* msec */
-
 /* For passive scan, listen PASSIVE_DWELL_TIME (msec) on each channel.
  * Must be set longer than active dwell time.
  * For the most reliable scan, set > AP beacon interval (typically 100msec). */
@@ -63,7 +54,6 @@
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
-#define IWL_SCAN_PROBE_MASK(n) 	cpu_to_le32((BIT(n) | (BIT(n) - BIT(1))))
 
 
 /**
@@ -296,9 +286,9 @@ void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_setup_rx_scan_handlers);
 
-static inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
-					    enum ieee80211_band band,
-					    u8 n_probes)
+inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
+				     enum ieee80211_band band,
+				     u8 n_probes)
 {
 	if (band == IEEE80211_BAND_5GHZ)
 		return IWL_ACTIVE_DWELL_TIME_52 +
@@ -307,9 +297,10 @@ static inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 		return IWL_ACTIVE_DWELL_TIME_24 +
 			IWL_ACTIVE_DWELL_FACTOR_24GHZ * (n_probes + 1);
 }
+EXPORT_SYMBOL(iwl_get_active_dwell_time);
 
-static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
-				      enum ieee80211_band band)
+u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
+			       enum ieee80211_band band)
 {
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
@@ -327,6 +318,7 @@ static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 
 	return passive;
 }
+EXPORT_SYMBOL(iwl_get_passive_dwell_time);
 
 static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 				     enum ieee80211_band band,
@@ -450,7 +442,7 @@ EXPORT_SYMBOL(iwl_scan_initiate);
 
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
 
-static void iwl_bg_scan_check(struct work_struct *data)
+void iwl_bg_scan_check(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, scan_check.work);
@@ -470,6 +462,8 @@ static void iwl_bg_scan_check(struct work_struct *data)
 	}
 	mutex_unlock(&priv->mutex);
 }
+EXPORT_SYMBOL(iwl_bg_scan_check);
+
 /**
  * iwl_supported_rate_to_ie - fill in the supported rate in IE field
  *
@@ -527,10 +521,10 @@ static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
  */
 
-static u16 iwl_fill_probe_req(struct iwl_priv *priv,
-				  enum ieee80211_band band,
-				  struct ieee80211_mgmt *frame,
-				  int left)
+u16 iwl_fill_probe_req(struct iwl_priv *priv,
+		       enum ieee80211_band band,
+		       struct ieee80211_mgmt *frame,
+		       int left)
 {
 	int len = 0;
 	u8 *pos = NULL;
@@ -624,6 +618,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 
 	return (u16)len;
 }
+EXPORT_SYMBOL(iwl_fill_probe_req);
 
 static void iwl_bg_request_scan(struct work_struct *data)
 {
@@ -839,7 +834,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_abort_scan(struct work_struct *work)
+void iwl_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
@@ -853,8 +848,9 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 
 	mutex_unlock(&priv->mutex);
 }
+EXPORT_SYMBOL(iwl_bg_abort_scan);
 
-static void iwl_bg_scan_completed(struct work_struct *work)
+void iwl_bg_scan_completed(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
@@ -872,7 +868,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
 	mutex_unlock(&priv->mutex);
 }
-
+EXPORT_SYMBOL(iwl_bg_scan_completed);
 
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 997ac33..c7bb9c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -791,47 +791,6 @@ static int iwl3945_send_bt_config(struct iwl_priv *priv)
 					sizeof(bt_cmd), &bt_cmd);
 }
 
-static int iwl3945_send_scan_abort(struct iwl_priv *priv)
-{
-	int rc = 0;
-	struct iwl_rx_packet *res;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_SCAN_ABORT_CMD,
-		.meta.flags = CMD_WANT_SKB,
-	};
-
-	/* If there isn't a scan actively going on in the hardware
-	 * then we are in between scan bands and not actually
-	 * actively scanning, so don't send the abort command */
-	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		return 0;
-	}
-
-	rc = iwl_send_cmd_sync(priv, &cmd);
-	if (rc) {
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		return rc;
-	}
-
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
-	if (res->u.status != CAN_ABORT_STATUS) {
-		/* The scan abort will return 1 for success or
-		 * 2 for "failure".  A failure condition can be
-		 * due to simply not being in an active scan which
-		 * can occur if we send the scan abort before we
-		 * the microcode has notified us that a scan is
-		 * completed. */
-		IWL_DEBUG_INFO("SCAN_ABORT returned %d.\n", res->u.status);
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		clear_bit(STATUS_SCAN_HW, &priv->status);
-	}
-
-	dev_kfree_skb_any(cmd.meta.u.skb);
-
-	return rc;
-}
-
 static int iwl3945_add_sta_sync_callback(struct iwl_priv *priv,
 				     struct iwl_cmd *cmd, struct sk_buff *skb)
 {
@@ -1168,115 +1127,6 @@ static void iwl3945_unset_hw_params(struct iwl_priv *priv)
 				    priv->shared_phys);
 }
 
-/**
- * iwl3945_supported_rate_to_ie - fill in the supported rate in IE field
- *
- * return : set the bit for each supported rate insert in ie
- */
-static u16 iwl3945_supported_rate_to_ie(u8 *ie, u16 supported_rate,
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
-			rates[*cnt] = iwl3945_rates[i].ieee |
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
-/**
- * iwl3945_fill_probe_req - fill in all required fields and IE for probe request
- */
-static u16 iwl3945_fill_probe_req(struct iwl_priv *priv,
-			      struct ieee80211_mgmt *frame,
-			      int left)
-{
-	int len = 0;
-	u8 *pos = NULL;
-	u16 active_rates, ret_rates, cck_rates;
-
-	/* Make sure there is enough space for the probe request,
-	 * two mandatory IEs and the data */
-	left -= 24;
-	if (left < 0)
-		return 0;
-	len += 24;
-
-	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
-	memcpy(frame->sa, priv->mac_addr, ETH_ALEN);
-	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
-	frame->seq_ctrl = 0;
-
-	/* fill in our indirect SSID IE */
-	/* ...next IE... */
-
-	left -= 2;
-	if (left < 0)
-		return 0;
-	len += 2;
-	pos = &(frame->u.probe_req.variable[0]);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = 0;
-
-	/* fill in supported rate */
-	/* ...next IE... */
-	left -= 2;
-	if (left < 0)
-		return 0;
-
-	/* ... fill it in... */
-	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos = 0;
-
-	priv->active_rate = priv->rates_mask;
-	active_rates = priv->active_rate;
-	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
-
-	cck_rates = IWL_CCK_RATES_MASK & active_rates;
-	ret_rates = iwl3945_supported_rate_to_ie(pos, cck_rates,
-			priv->active_rate_basic, &left);
-	active_rates &= ~ret_rates;
-
-	ret_rates = iwl3945_supported_rate_to_ie(pos, active_rates,
-				 priv->active_rate_basic, &left);
-	active_rates &= ~ret_rates;
-
-	len += 2 + *pos;
-	pos += (*pos) + 1;
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
-	iwl3945_supported_rate_to_ie(pos, active_rates,
-				 priv->active_rate_basic, &left);
-	if (*pos > 0)
-		len += 2 + *pos;
-
- fill_end:
-	return (u16)len;
-}
-
 /*
  * QoS  support
 */
@@ -3955,66 +3805,6 @@ static void iwl3945_free_channel_map(struct iwl_priv *priv)
 	priv->channel_count = 0;
 }
 
-/* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
- * sending probe req.  This should be set long enough to hear probe responses
- * from more than one AP.  */
-#define IWL_ACTIVE_DWELL_TIME_24    (30)	/* all times in msec */
-#define IWL_ACTIVE_DWELL_TIME_52    (20)
-
-#define IWL_ACTIVE_DWELL_FACTOR_24GHZ (3)
-#define IWL_ACTIVE_DWELL_FACTOR_52GHZ (2)
-
-/* For faster active scanning, scan will move to the next channel if fewer than
- * PLCP_QUIET_THRESH packets are heard on this channel within
- * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
- * time if it's a quiet channel (nothing responded to our probe, and there's
- * no other traffic).
- * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
-#define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)	/* packets */
-#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(10)	/* msec */
-
-/* For passive scan, listen PASSIVE_DWELL_TIME (msec) on each channel.
- * Must be set longer than active dwell time.
- * For the most reliable scan, set > AP beacon interval (typically 100msec). */
-#define IWL_PASSIVE_DWELL_TIME_24   (20)	/* all times in msec */
-#define IWL_PASSIVE_DWELL_TIME_52   (10)
-#define IWL_PASSIVE_DWELL_BASE      (100)
-#define IWL_CHANNEL_TUNE_TIME       5
-
-#define IWL_SCAN_PROBE_MASK(n)	 (BIT(n) | (BIT(n) - BIT(1)))
-
-static inline u16 iwl3945_get_active_dwell_time(struct iwl_priv *priv,
-						enum ieee80211_band band,
-						u8 n_probes)
-{
-	if (band == IEEE80211_BAND_5GHZ)
-		return IWL_ACTIVE_DWELL_TIME_52 +
-			IWL_ACTIVE_DWELL_FACTOR_52GHZ * (n_probes + 1);
-	else
-		return IWL_ACTIVE_DWELL_TIME_24 +
-			IWL_ACTIVE_DWELL_FACTOR_24GHZ * (n_probes + 1);
-}
-
-static u16 iwl3945_get_passive_dwell_time(struct iwl_priv *priv,
-					  enum ieee80211_band band)
-{
-	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
-	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
-	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
-
-	if (iwl3945_is_associated(priv)) {
-		/* If we're associated, we clamp the maximum passive
-		 * dwell time to be 98% of the beacon interval (minus
-		 * 2 * channel tune time) */
-		passive = priv->beacon_int;
-		if ((passive > IWL_PASSIVE_DWELL_BASE) || !passive)
-			passive = IWL_PASSIVE_DWELL_BASE;
-		passive = (passive * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
-	}
-
-	return passive;
-}
-
 static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 					 enum ieee80211_band band,
 				     u8 is_active, u8 n_probes,
@@ -4033,8 +3823,8 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 
 	channels = sband->channels;
 
-	active_dwell = iwl3945_get_active_dwell_time(priv, band, n_probes);
-	passive_dwell = iwl3945_get_passive_dwell_time(priv, band);
+	active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
+	passive_dwell = iwl_get_passive_dwell_time(priv, band);
 
 	if (passive_dwell <= active_dwell)
 		passive_dwell = active_dwell + 1;
@@ -5135,28 +4925,6 @@ static void iwl3945_rfkill_poll(struct work_struct *data)
 }
 
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
-
-static void iwl3945_bg_scan_check(struct work_struct *data)
-{
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, scan_check.work);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCANNING, &priv->status) ||
-	    test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG(IWL_DL_INFO | IWL_DL_SCAN,
-			  "Scan completion watchdog resetting adapter (%dms)\n",
-			  jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
-
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-			iwl3945_send_scan_abort(priv);
-	}
-	mutex_unlock(&priv->mutex);
-}
-
 static void iwl3945_bg_request_scan(struct work_struct *data)
 {
 	struct iwl_priv *priv =
@@ -5284,9 +5052,6 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
-	scan->tx_cmd.len = cpu_to_le16(
-		iwl3945_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(*scan)));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
@@ -5307,6 +5072,11 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
+	scan->tx_cmd.len = cpu_to_le16(
+		iwl_fill_probe_req(priv, band,
+				   (struct ieee80211_mgmt *)scan->data,
+				   IWL_MAX_SCAN_SIZE - sizeof(*scan)));
+
 	/* select Rx antennas */
 	scan->flags |= iwl3945_get_antenna_flags(priv);
 
@@ -5482,45 +5252,8 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 }
 
-static void iwl3945_bg_abort_scan(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
-
-	if (!iwl_is_ready(priv))
-		return;
-
-	mutex_lock(&priv->mutex);
-
-	set_bit(STATUS_SCAN_ABORTING, &priv->status);
-	iwl3945_send_scan_abort(priv);
-
-	mutex_unlock(&priv->mutex);
-}
-
 static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed);
 
-static void iwl3945_bg_scan_completed(struct work_struct *work)
-{
-	struct iwl_priv *priv =
-	    container_of(work, struct iwl_priv, scan_completed);
-
-	IWL_DEBUG(IWL_DL_INFO | IWL_DL_SCAN, "SCAN complete scan\n");
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (test_bit(STATUS_CONF_PENDING, &priv->status))
-		iwl3945_mac_config(priv->hw, 0);
-
-	ieee80211_scan_completed(priv->hw);
-
-	/* Since setting the TXPOWER may have been deferred while
-	 * performing the scan, fire one off */
-	mutex_lock(&priv->mutex);
-	priv->cfg->ops->lib->send_tx_power(priv);
-	mutex_unlock(&priv->mutex);
-}
-
 /*****************************************************************************
  *
  * mac80211 entry point functions
@@ -6821,15 +6554,15 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->up, iwl3945_bg_up);
 	INIT_WORK(&priv->restart, iwl3945_bg_restart);
 	INIT_WORK(&priv->rx_replenish, iwl3945_bg_rx_replenish);
-	INIT_WORK(&priv->scan_completed, iwl3945_bg_scan_completed);
-	INIT_WORK(&priv->request_scan, iwl3945_bg_request_scan);
-	INIT_WORK(&priv->abort_scan, iwl3945_bg_abort_scan);
 	INIT_WORK(&priv->rf_kill, iwl_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
-	INIT_DELAYED_WORK(&priv->scan_check, iwl3945_bg_scan_check);
 	INIT_DELAYED_WORK(&priv->rfkill_poll, iwl3945_rfkill_poll);
+	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
+	INIT_WORK(&priv->request_scan, iwl3945_bg_request_scan);
+	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
+	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
 
 	iwl3945_hw_setup_deferred_work(priv);
 
-- 
1.5.4.3

