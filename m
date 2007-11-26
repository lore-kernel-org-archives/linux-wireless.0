Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbXKZOVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:50 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 10/15] iwlwifi: 802.11n configuring hw_mode parameters to support HT in A/G
Date: Mon, 26 Nov 2007 16:14:37 +0200
Message-Id: <11960864912211-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_142200_180177_35602793)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fills the mac80211's ieee80211_hw_mode structures with the
needed 802.11n data needed for the new framework

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   24 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   24 +++++++-----------------
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9b8560d..1cf50f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3668,6 +3668,30 @@ static int parse_elems(u8 *start, size_t len, struct ieee802_11_elems *elems)
 
 	return 0;
 }
+
+void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info, int mode)
+{
+	ht_info->cap = 0;
+	memset(ht_info->supp_mcs_set, 0, 16);
+
+	ht_info->ht_supported = 1;
+
+	if (mode == MODE_IEEE80211A) {
+		ht_info->cap |= (u16)IEEE80211_HT_CAP_SUP_WIDTH;
+		ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_40;
+		ht_info->supp_mcs_set[4] = 0x01;
+	}
+	ht_info->cap |= (u16)IEEE80211_HT_CAP_GRN_FLD;
+	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
+	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
+			     (IWL_MIMO_PS_NONE << 2));
+
+	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
+	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
+
+	ht_info->supp_mcs_set[0] = 0xFF;
+	ht_info->supp_mcs_set[1] = 0xFF;
+}
 #endif /* CONFIG_IWL4965_HT */
 
 static void iwl4965_sta_modify_ps_wake(struct iwl4965_priv *priv, int sta_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 1be1ca2..7cb5cbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -764,6 +764,8 @@ extern int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv, int phymode,
 extern void iwl4965_rf_kill_ct_config(struct iwl4965_priv *priv);
 
 #ifdef CONFIG_IWL4965_HT
+extern void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
+					int mode);
 #ifdef CONFIG_IWL4965_HT_AGG
 extern int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 				   u16 tid, u16 *start_seq_num);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 29627bf..d45a7da 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5644,10 +5644,8 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 		A = 0,
 		B = 1,
 		G = 2,
-		A_11N = 3,
-		G_11N = 4,
 	};
-	int mode_count = 5;
+	int mode_count = 3;
 
 	if (priv->modes) {
 		IWL_DEBUG_INFO("Geography modes already initialized.\n");
@@ -5687,6 +5685,9 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 	modes[A].num_rates = 8;	/* just OFDM */
 	modes[A].rates = &rates[4];
 	modes[A].num_channels = 0;
+#ifdef CONFIG_IWL4965_HT
+	iwl4965_init_ht_hw_capab(&modes[A].ht_info, MODE_IEEE80211A);
+#endif
 
 	modes[B].mode = MODE_IEEE80211B;
 	modes[B].channels = channels;
@@ -5699,18 +5700,9 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 	modes[G].rates = rates;
 	modes[G].num_rates = 12;	/* OFDM & CCK */
 	modes[G].num_channels = 0;
-
-	modes[G_11N].mode = MODE_IEEE80211G;
-	modes[G_11N].channels = channels;
-	modes[G_11N].num_rates = 13;        /* OFDM & CCK */
-	modes[G_11N].rates = rates;
-	modes[G_11N].num_channels = 0;
-
-	modes[A_11N].mode = MODE_IEEE80211A;
-	modes[A_11N].channels = &channels[ARRAY_SIZE(iwl4965_eeprom_band_1)];
-	modes[A_11N].rates = &rates[4];
-	modes[A_11N].num_rates = 9; /* just OFDM */
-	modes[A_11N].num_channels = 0;
+#ifdef CONFIG_IWL4965_HT
+	iwl4965_init_ht_hw_capab(&modes[G].ht_info, MODE_IEEE80211G);
+#endif
 
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
@@ -5730,11 +5722,9 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 
 		if (is_channel_a_band(ch)) {
 			geo_ch = &modes[A].channels[modes[A].num_channels++];
-			modes[A_11N].num_channels++;
 		} else {
 			geo_ch = &modes[B].channels[modes[B].num_channels++];
 			modes[G].num_channels++;
-			modes[G_11N].num_channels++;
 		}
 
 		geo_ch->freq = ieee80211chan2mhz(ch->channel);
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
