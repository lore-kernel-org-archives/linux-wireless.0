Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0CJFWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/24] iwlagn: remove write-only variables
Date: Tue,  9 Mar 2010 21:21:32 -0800
Message-Id: <1268198512-6572-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Updating the variables last_rx_rssi, last_tsf
and last_beacon_time needs a lot of code but
they are not actually used in iwlagn (only in
3945) so we can move them to the 3945 specific
data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   24 ------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 6 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index effdd36..b588cb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -946,7 +946,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-	rssi = priv->last_rx_rssi;
+	rssi = priv->_3945.last_rx_rssi;
 	if (rssi == 0)
 		rssi = IWL_MIN_RSSI_VAL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 867bd69..9a5a7b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -705,9 +705,10 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	iwl_dbg_log_rx_data_frame(priv, le16_to_cpu(rx_hdr->len), header);
 
 	if (network_packet) {
-		priv->last_beacon_time = le32_to_cpu(rx_end->beacon_timestamp);
-		priv->last_tsf = le64_to_cpu(rx_end->timestamp);
-		priv->last_rx_rssi = rx_status.signal;
+		priv->_3945.last_beacon_time =
+			le32_to_cpu(rx_end->beacon_timestamp);
+		priv->_3945.last_tsf = le64_to_cpu(rx_end->timestamp);
+		priv->_3945.last_rx_rssi = rx_status.signal;
 		priv->last_rx_noise = rx_status.noise;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 8bf7c20..696e668 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2956,12 +2956,8 @@ static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 		desc += sprintf(buff+desc,
 				"Bit Rate= %d Mb/s\n",
 				iwl_rates[lq_sta->last_txrate_idx].ieee >> 1);
-	desc += sprintf(buff+desc,
-			"Signal Level= %d dBm\tNoise Level= %d dBm\n",
-			priv->last_rx_rssi, priv->last_rx_noise);
-	desc += sprintf(buff+desc,
-			"Tsf= 0x%llx\tBeacon time= 0x%08X\n",
-			priv->last_tsf, priv->last_beacon_time);
+	desc += sprintf(buff+desc, "Noise Level= %d dBm\n",
+			priv->last_rx_noise);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f9210b7..c277e4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1197,7 +1197,6 @@ struct iwl_priv {
 
 	unsigned long status;
 
-	int last_rx_rssi;	/* From Rx packet statistics */
 	int last_rx_noise;	/* From beacon statistics */
 
 	/* counts mgmt, ctl, and data packets */
@@ -1244,10 +1243,6 @@ struct iwl_priv {
 
 	u8 mac80211_registered;
 
-	/* Rx'd packet timing information */
-	u32 last_beacon_time;
-	u64 last_tsf;
-
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
 	int    nvm_device_type;
@@ -1274,6 +1269,11 @@ struct iwl_priv {
 			struct iwl3945_notif_statistics statistics;
 
 			u32 sta_supp_rates;
+			int last_rx_rssi;	/* From Rx packet statistics */
+
+			/* Rx'd packet timing information */
+			u32 last_beacon_time;
+			u64 last_tsf;
 		} _3945;
 #endif
 #if defined(CONFIG_IWLAGN) || defined(CONFIG_IWLAGN_MODULE)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index df257bc..8116aa0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1036,24 +1036,6 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	rxb->page = NULL;
 }
 
-/* This is necessary only for a number of statistics, see the caller. */
-static int iwl_is_network_packet(struct iwl_priv *priv,
-		struct ieee80211_hdr *header)
-{
-	/* Filter incoming packets to determine if they are targeted toward
-	 * this network, discarding packets coming from ourselves */
-	switch (priv->iw_mode) {
-	case NL80211_IFTYPE_ADHOC: /* Header: Dest. | Source    | BSSID */
-		/* packets to our IBSS update information */
-		return !compare_ether_addr(header->addr3, priv->bssid);
-	case NL80211_IFTYPE_STATION: /* Header: Dest. | AP{BSSID} | Source */
-		/* packets to our IBSS update information */
-		return !compare_ether_addr(header->addr2, priv->bssid);
-	default:
-		return 1;
-	}
-}
-
 /* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
 void iwl_rx_reply_rx(struct iwl_priv *priv,
@@ -1190,12 +1172,6 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status.flag |= RX_FLAG_SHORT_GI;
 
-	if (iwl_is_network_packet(priv, header)) {
-		priv->last_rx_rssi = rx_status.signal;
-		priv->last_beacon_time =  priv->ucode_beacon_time;
-		priv->last_tsf = le64_to_cpu(phy_res->timestamp);
-	}
-
 	iwl_pass_packet_to_mac80211(priv, header, len, ampdu_status,
 				    rxb, &rx_status);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1b3a1ba..a825092 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -753,7 +753,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	if (iwl_is_associated(priv))
 		add_time =
 		    iwl3945_usecs_to_beacons(
-			le64_to_cpu(params->start_time) - priv->last_tsf,
+			le64_to_cpu(params->start_time) - priv->_3945.last_tsf,
 			le16_to_cpu(priv->rxon_timing.beacon_interval));
 
 	memset(&spectrum, 0, sizeof(spectrum));
@@ -767,7 +767,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 
 	if (iwl_is_associated(priv))
 		spectrum.start_time =
-		    iwl3945_add_beacon_time(priv->last_beacon_time,
+		    iwl3945_add_beacon_time(priv->_3945.last_beacon_time,
 				add_time,
 				le16_to_cpu(priv->rxon_timing.beacon_interval));
 	else
@@ -3590,7 +3590,7 @@ static ssize_t store_measurement(struct device *d,
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct ieee80211_measurement_params params = {
 		.channel = le16_to_cpu(priv->active_rxon.channel),
-		.start_time = cpu_to_le64(priv->last_tsf),
+		.start_time = cpu_to_le64(priv->_3945.last_tsf),
 		.duration = cpu_to_le16(1),
 	};
 	u8 type = IWL_MEASURE_BASIC;
-- 
1.6.3.3

