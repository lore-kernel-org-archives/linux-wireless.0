Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15586 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbYICDbo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:44 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 38/39] iwl3945: enable active scanning on active channels
Date: Wed,  3 Sep 2008 11:26:58 +0800
Message-Id: <1220412419-15404-39-git-send-email-yi.zhu@intel.com> (sfid-20080903_055041_410940_4350951F)
In-Reply-To: <1220412419-15404-38-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-33-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-34-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-35-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-36-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-37-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-38-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

This patch enables active scanning on active channels.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   54 +++++++++++++--------------
 1 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 709be78..53e234d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4782,8 +4782,11 @@ static void iwl3945_free_channel_map(struct iwl3945_priv *priv)
 /* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
  * sending probe req.  This should be set long enough to hear probe responses
  * from more than one AP.  */
-#define IWL_ACTIVE_DWELL_TIME_24    (20)	/* all times in msec */
-#define IWL_ACTIVE_DWELL_TIME_52    (10)
+#define IWL_ACTIVE_DWELL_TIME_24    (30)	/* all times in msec */
+#define IWL_ACTIVE_DWELL_TIME_52    (20)
+
+#define IWL_ACTIVE_DWELL_FACTOR_24GHZ (3)
+#define IWL_ACTIVE_DWELL_FACTOR_52GHZ (2)
 
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
@@ -4792,7 +4795,7 @@ static void iwl3945_free_channel_map(struct iwl3945_priv *priv)
  * no other traffic).
  * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
 #define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)	/* packets */
-#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(5)	/* msec */
+#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(10)	/* msec */
 
 /* For passive scan, listen PASSIVE_DWELL_TIME (msec) on each channel.
  * Must be set longer than active dwell time.
@@ -4802,13 +4805,18 @@ static void iwl3945_free_channel_map(struct iwl3945_priv *priv)
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
+#define IWL_SCAN_PROBE_MASK(n)	 cpu_to_le32((BIT(n) | (BIT(n) - BIT(1))))
+
 static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv,
-						enum ieee80211_band band)
+						enum ieee80211_band band,
+						u8 n_probes)
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
 
 static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
@@ -4833,7 +4841,7 @@ static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
 
 static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 					 enum ieee80211_band band,
-				     u8 is_active, u8 direct_mask,
+				     u8 is_active, u8 n_probes,
 				     struct iwl3945_scan_channel *scan_ch)
 {
 	const struct ieee80211_channel *channels = NULL;
@@ -4849,7 +4857,7 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 
 	channels = sband->channels;
 
-	active_dwell = iwl3945_get_active_dwell_time(priv, band);
+	active_dwell = iwl3945_get_active_dwell_time(priv, band, n_probes);
 	passive_dwell = iwl3945_get_passive_dwell_time(priv, band);
 
 	if (passive_dwell <= active_dwell)
@@ -4874,8 +4882,8 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 		else
 			scan_ch->type = 1;	/* active */
 
-		if (scan_ch->type & 1)
-			scan_ch->type |= (direct_mask << 1);
+		if ((scan_ch->type & 1) && n_probes)
+			scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
 
 		scan_ch->active_dwell = cpu_to_le16(active_dwell);
 		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
@@ -6092,7 +6100,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	int rc = 0;
 	struct iwl3945_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
-	u8 direct_mask;
+	u8 n_probes = 2;
 	enum ieee80211_band band;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
@@ -6200,7 +6208,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
 		       priv->direct_ssid, priv->direct_ssid_len);
-		direct_mask = 1;
+		n_probes++;
 	} else if (!iwl3945_is_associated(priv) && priv->essid_len) {
 		IWL_DEBUG_SCAN
 		  ("Kicking off one direct scan for '%s' when not associated\n",
@@ -6208,11 +6216,9 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
-		direct_mask = 1;
-	} else {
+		n_probes++;
+	} else
 		IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
-		direct_mask = 0;
-	}
 
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
@@ -6245,18 +6251,10 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
-	if (direct_mask)
-		scan->channel_count =
-			iwl3945_get_channels_for_scan(
-				priv, band, 1, /* active */
-				direct_mask,
-				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-	else
-		scan->channel_count =
-			iwl3945_get_channels_for_scan(
-				priv, band, 0, /* passive */
-				direct_mask,
-				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+	scan->channel_count =
+		iwl3945_get_channels_for_scan(priv, band, 1, /* active */
+					      n_probes,
+			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl3945_scan_channel);
-- 
1.5.3.6

