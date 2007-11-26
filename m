Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52348 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbXKZOVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:49 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 09/15] iwlwifi: 802.11n new framework structures preperation
Date: Mon, 26 Nov 2007 16:14:36 +0200
Message-Id: <11960864911233-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_142158_950493_17D3B85F)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary or duplicate 802.11n data from structures
in the code, and prepares them for new mac80211's 802.11n framework

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   27 +++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 --
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 4b6aa96..defc392 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1827,7 +1827,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	if (local->hw.conf.phymode == MODE_IEEE80211A)
 		sta->last_txrate += IWL_FIRST_OFDM_RATE;
 
-	crl->is_dup = priv->is_dup;
+	crl->is_dup = 0;
 	crl->valid_antenna = priv->valid_antenna;
 	crl->antenna = priv->antenna;
 	crl->is_green = rs_use_green(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 5944b4b..1be1ca2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -477,22 +477,23 @@ union iwl4965_ht_rate_supp {
 #define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
 #define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
 
-struct sta_ht_info {
+struct iwl_ht_info {
+	/* self configuration data */
 	u8 is_ht;
-	u16 rx_mimo_ps_mode;
+	u8 supported_chan_width;
 	u16 tx_mimo_ps_mode;
-	u16 control_channel;
+	u8 is_green_field;
+	u8 sgf;
 	u8 max_amsdu_size;
 	u8 ampdu_factor;
 	u8 mpdu_density;
-	u8 operating_mode;
-	u8 supported_chan_width;
+	u8 supp_mcs_set[16];
+	/* BSS related data */
+	u8 control_channel;
 	u8 extension_chan_offset;
-	u8 is_green_field;
-	u8 sgf;
-	u8 supp_rates[16];
 	u8 tx_chan_width;
-	u8 chan_width_cap;
+	u8 ht_protection;
+	u8 non_GF_STA_present;
 };
 #endif				/*CONFIG_IWL4965_HT */
 
@@ -1149,11 +1150,6 @@ struct iwl4965_priv {
 	u8 call_post_assoc_from_beacon;
 	u8 assoc_station_added;
 	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
-	/* HT variables */
-	u8 is_dup;
-	u8 is_ht_enabled;
-	u8 channel_width;	/* 0=20MHZ, 1=40MHZ */
-	u8 current_channel_width;
 	u8 valid_antenna;	/* Bit mask of antennas actually connected */
 #ifdef CONFIG_IWL4965_SENSITIVITY
 	struct iwl4965_sensitivity_data sensitivity_data;
@@ -1163,9 +1159,8 @@ struct iwl4965_priv {
 #endif /*CONFIG_IWL4965_SENSITIVITY*/
 
 #ifdef CONFIG_IWL4965_HT
-	struct sta_ht_info current_assoc_ht;
+	struct iwl_ht_info current_ht_config;
 #endif
-	u8 active_rate_ht[2];
 	u8 last_phy_res[100];
 
 	/* Rate scaling data */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index df011ea..29627bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -9068,8 +9068,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->ps_mode = 0;
 	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
-	priv->is_ht_enabled = 1;
-	priv->channel_width = IWL_CHANNEL_WIDTH_40MHZ;
 	priv->valid_antenna = 0x7;	/* assume all 3 connected */
 	priv->ps_mode = IWL_MIMO_PS_NONE;
 
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
