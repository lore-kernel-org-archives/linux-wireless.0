Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5799 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbZH1Qot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 12:44:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/5] iwlwifi: use iwl_hwrate_get_mac80211_idx where appropriate
Date: Fri, 28 Aug 2009 09:44:47 -0700
Message-Id: <1251477889-13732-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
References: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

For HT packets, mac80211 expects the rate_idx to be an MCS number, which is the
lower byte of rate_n_flags.  However, iwl_hwrate_to_plcp_idx takes the MCS
number and reduces it down to the range 0-8 (6 to 60 Mbps), removing the bits
that signify multiply streams, HT40 Duplicate mode, or unequal modulation.
This version is used for various internal purposes through the driver.

Add the function iwl_hwrate_get_mac80211_idx, an alternate version which takes
the rate and the band and returns the mac80211 index (MCS, for HT packets, and
PLCP rate, for legacy packets).

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-core.c   |   27 ++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c     |    9 ++++-----
 4 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 8239e55..40b207a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -878,6 +878,12 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		rs_index -= IWL_FIRST_OFDM_RATE;
 	mac_flags = info->status.rates[0].flags;
 	mac_index = info->status.rates[0].idx;
+	/* For HT packets, map MCS to PLCP */
+	if (mac_flags & IEEE80211_TX_RC_MCS) {
+		mac_index &= RATE_MCS_CODE_MSK;	/* Remove # of streams */
+		if (mac_index >= (IWL_RATE_9M_INDEX - IWL_FIRST_OFDM_RATE))
+			mac_index++;
+	}
 
 	if ((mac_index < 0) ||
 	    (tbl_type.is_SGI != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
@@ -886,8 +892,8 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	    (tbl_type.ant_type != info->antenna_sel_tx) ||
 	    (!!(tx_rate & RATE_MCS_HT_MSK) != !!(mac_flags & IEEE80211_TX_RC_MCS)) ||
 	    (!!(tx_rate & RATE_MCS_GF_MSK) != !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
-	    rs_index != mac_index) {
-		IWL_DEBUG_RATE(priv, "initial rate does not match 0x%x\n", tx_rate);
+	    (rs_index != mac_index)) {
+		IWL_DEBUG_RATE(priv, "initial rate %d does not match %d (0x%x)\n", mac_index, rs_index, tx_rate);
 		/* the last LQ command could failed so the LQ in ucode not
 		 * the same in driver sync up
 		 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ad32a11..d9b5f35 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -96,7 +96,6 @@ EXPORT_SYMBOL(iwl_rates);
 void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 				  struct ieee80211_tx_info *info)
 {
-	int rate_index;
 	struct ieee80211_tx_rate *r = &info->control.rates[0];
 
 	info->antenna_sel_tx =
@@ -111,10 +110,7 @@ void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 		r->flags |= IEEE80211_TX_RC_DUP_DATA;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
 		r->flags |= IEEE80211_TX_RC_SHORT_GI;
-	rate_index = iwl_hwrate_to_plcp_idx(rate_n_flags);
-	if (info->band == IEEE80211_BAND_5GHZ)
-		rate_index -= IWL_FIRST_OFDM_RATE;
-	r->idx = rate_index;
+	r->idx = iwl_hwrate_to_mac80211_idx(rate_n_flags, info->band);
 }
 EXPORT_SYMBOL(iwl_hwrate_to_tx_control);
 
@@ -149,6 +145,27 @@ int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 }
 EXPORT_SYMBOL(iwl_hwrate_to_plcp_idx);
 
+int iwl_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
+{
+	int idx = 0;
+	int band_offset = 0;
+
+	/* HT rate format: mac80211 wants an MCS number, which is just LSB */
+	if (rate_n_flags & RATE_MCS_HT_MSK) {
+		idx = (rate_n_flags & 0xff);
+		return idx;
+	/* Legacy rate format, search for match in table */
+	} else {
+		if (band == IEEE80211_BAND_5GHZ)
+			band_offset = IWL_FIRST_OFDM_RATE;
+		for (idx = band_offset; idx < IWL_RATE_COUNT_LEGACY; idx++)
+			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
+				return idx - band_offset;
+	}
+
+	return -1;
+}
+
 u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant)
 {
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 62d9036..c04d2a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -423,6 +423,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			      struct ieee80211_tx_info *info);
 int iwl_hwrate_to_plcp_idx(u32 rate_n_flags);
+int iwl_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index e34d3fc..8150c5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -962,6 +962,9 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		return;
 	}
 
+	/* This will be used in several places later */
+	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
+
 	/* rx_status carries information about the packet to mac80211 */
 	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
 	rx_status.freq =
@@ -969,10 +972,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.rate_idx =
-		iwl_hwrate_to_plcp_idx(le32_to_cpu(phy_res->rate_n_flags));
-	if (rx_status.band == IEEE80211_BAND_5GHZ)
-		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
-
+		iwl_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
 	rx_status.flag = 0;
 
 	/* TSF isn't reliable. In order to allow smooth user experience,
@@ -1034,7 +1034,6 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
 	/* Set up the HT phy flags */
-	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
 	if (rate_n_flags & RATE_MCS_HT_MSK)
 		rx_status.flag |= RX_FLAG_HT;
 	if (rate_n_flags & RATE_MCS_HT40_MSK)
-- 
1.5.6.3

