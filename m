Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbYGKD5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:57:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 11/14] iwlwifi: enable active scanning
Date: Fri, 11 Jul 2008 11:53:39 +0800
Message-Id: <1215748422-12672-12-git-send-email-yi.zhu@intel.com> (sfid-20080711_061544_990354_625CC68F)
In-Reply-To: <1215748422-12672-11-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-8-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-9-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-10-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-11-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch enables active scan on active channels.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   86 ++++++++++++++++---------------
 1 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index cf24c27..efc750d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -38,8 +38,11 @@
 /* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
  * sending probe req.  This should be set long enough to hear probe responses
  * from more than one AP.  */
-#define IWL_ACTIVE_DWELL_TIME_24    (20)       /* all times in msec */
-#define IWL_ACTIVE_DWELL_TIME_52    (10)
+#define IWL_ACTIVE_DWELL_TIME_24    (30)       /* all times in msec */
+#define IWL_ACTIVE_DWELL_TIME_52    (20)
+
+#define IWL_ACTIVE_DWELL_FACTOR_24GHZ (3)
+#define IWL_ACTIVE_DWELL_FACTOR_52GHZ (2)
 
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
@@ -48,7 +51,7 @@
  * no other traffic).
  * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
 #define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)  /* packets */
-#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(5)  /* msec */
+#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(10)  /* msec */
 
 /* For passive scan, listen PASSIVE_DWELL_TIME (msec) on each channel.
  * Must be set longer than active dwell time.
@@ -58,10 +61,15 @@
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
+#define IWL_SCAN_PROBE_MASK(n) 	cpu_to_le32((BIT(n) | (BIT(n) - BIT(1))))
+
+
 static int scan_tx_ant[3] = {
 	RATE_MCS_ANT_A_MSK, RATE_MCS_ANT_B_MSK, RATE_MCS_ANT_C_MSK
 };
 
+
+
 static int iwl_is_empty_essid(const char *essid, int essid_len)
 {
 	/* Single white space is for Linksys APs */
@@ -226,8 +234,9 @@ static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
 		       "(TSF: 0x%08X:%08X) - %d (beacon timer %u)\n",
 		       notif->channel,
 		       notif->band ? "bg" : "a",
-		       notif->tsf_high,
-		       notif->tsf_low, notif->status, notif->beacon_timer);
+		       le32_to_cpu(notif->tsf_high),
+		       le32_to_cpu(notif->tsf_low),
+		       notif->status, notif->beacon_timer);
 }
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
@@ -332,19 +341,21 @@ void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_setup_rx_scan_handlers);
 
 static inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
-						enum ieee80211_band band)
+					    enum ieee80211_band band,
+					    u8 n_probes)
 {
 	if (band == IEEE80211_BAND_5GHZ)
-		return IWL_ACTIVE_DWELL_TIME_52;
+		return IWL_ACTIVE_DWELL_TIME_52 +
+			IWL_ACTIVE_DWELL_FACTOR_52GHZ * (n_probes + 1);
 	else
-		return IWL_ACTIVE_DWELL_TIME_24;
+		return IWL_ACTIVE_DWELL_TIME_24 +
+			IWL_ACTIVE_DWELL_FACTOR_24GHZ * (n_probes + 1);
 }
 
 static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
-					  enum ieee80211_band band)
+				      enum ieee80211_band band)
 {
-	u16 active = iwl_get_active_dwell_time(priv, band);
-	u16 passive = (band != IEEE80211_BAND_5GHZ) ?
+	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
@@ -358,15 +369,12 @@ static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 		passive = (passive * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 	}
 
-	if (passive <= active)
-		passive = active + 1;
-
 	return passive;
 }
 
 static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 				     enum ieee80211_band band,
-				     u8 is_active, u8 direct_mask,
+				     u8 is_active, u8 n_probes,
 				     struct iwl_scan_channel *scan_ch)
 {
 	const struct ieee80211_channel *channels = NULL;
@@ -383,9 +391,12 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 
 	channels = sband->channels;
 
-	active_dwell = iwl_get_active_dwell_time(priv, band);
+	active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
 	passive_dwell = iwl_get_passive_dwell_time(priv, band);
 
+	if (passive_dwell <= active_dwell)
+		passive_dwell = active_dwell + 1;
+
 	for (i = 0, added = 0; i < sband->n_channels; i++) {
 		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
 			continue;
@@ -407,8 +418,8 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		else
 			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
 
-		if (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE)
-			scan_ch->type |= cpu_to_le32(direct_mask << 1);
+		if ((scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) && n_probes)
+			scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
 
 		scan_ch->active_dwell = cpu_to_le16(active_dwell);
 		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
@@ -416,18 +427,17 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		/* Set txpower levels to defaults */
 		scan_ch->dsp_atten = 110;
 
+		/* NOTE: if we were doing 6Mb OFDM for scans we'd use
+		 * power level:
+		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
+		 */
 		if (band == IEEE80211_BAND_5GHZ)
 			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		else {
+		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
-			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
-			 * power level:
-			 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
-			 */
-		}
 
-		IWL_DEBUG_SCAN("Scanning %d [%s %d]\n",
-			       channel,
+		IWL_DEBUG_SCAN("Scanning ch=%d prob=0x%X [%s %d]\n",
+			       channel, le32_to_cpu(scan_ch->type),
 			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
 				"ACTIVE" : "PASSIVE",
 			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
@@ -676,7 +686,7 @@ static u32 iwl_scan_tx_ant(struct iwl_priv *priv, enum ieee80211_band band)
 			break;
 		}
 	}
-
+	IWL_DEBUG_SCAN("select TX ANT = %c\n", 'A' + ind);
 	return scan_tx_ant[ind];
 }
 
@@ -696,7 +706,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	u32 tx_ant;
 	u16 cmd_len;
 	enum ieee80211_band band;
-	u8 direct_mask;
+	u8 n_probes = 2;
 	u8 rx_chain = 0x7; /* bitmap: ABC chains */
 
 	conf = ieee80211_get_hw_conf(priv->hw);
@@ -796,17 +806,16 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
 		       priv->direct_ssid, priv->direct_ssid_len);
-		direct_mask = 1;
+		n_probes++;
 	} else if (!iwl_is_associated(priv) && priv->essid_len) {
 		IWL_DEBUG_SCAN("Start direct scan for '%s' (not associated)\n",
 				iwl_escape_essid(priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
-		direct_mask = 1;
+		n_probes++;
 	} else {
 		IWL_DEBUG_SCAN("Start indirect scan.\n");
-		direct_mask = 0;
 	}
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
@@ -863,16 +872,11 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
 			       RXON_FILTER_BCON_AWARE_MSK);
 
-	if (direct_mask)
-		scan->channel_count =
-			iwl_get_channels_for_scan(priv, band, 1, /* active */
-						  direct_mask,
-				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-	else
-		scan->channel_count =
-			iwl_get_channels_for_scan(priv, band, 0, /* passive */
-						  direct_mask,
-				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+	scan->channel_count =
+		iwl_get_channels_for_scan(priv, band, 1, /* active */
+			n_probes,
+			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
 		goto done;
-- 
1.5.3.6

