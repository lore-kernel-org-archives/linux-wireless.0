Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab2DWVwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/29] iwlwifi: properly set basic rates
Date: Mon, 23 Apr 2012 14:47:18 -0700
Message-Id: <1335217660-21950-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235357_384771_4DE70475)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This fixes a long-standing bug: iwlwifi always assumes
that the CCK ACK rates are 1 and 2 MBps and the OFDM
ACK rates are 6, 12 and 24 MBps. Fix this problem by
using the basic rates the AP (or in AP case hostapd)
told us to use and add the necessary mandatory rates
to the mix.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |   26 ------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |  119 +++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    1 -
 4 files changed, 94 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 203b1c1..351717a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -174,32 +174,6 @@ enum {
 	IWL_RATE_11M_IEEE = 22,
 };
 
-#define IWL_CCK_BASIC_RATES_MASK    \
-       (IWL_RATE_1M_MASK          | \
-	IWL_RATE_2M_MASK)
-
-#define IWL_CCK_RATES_MASK          \
-       (IWL_CCK_BASIC_RATES_MASK  | \
-	IWL_RATE_5M_MASK          | \
-	IWL_RATE_11M_MASK)
-
-#define IWL_OFDM_BASIC_RATES_MASK   \
-	(IWL_RATE_6M_MASK         | \
-	IWL_RATE_12M_MASK         | \
-	IWL_RATE_24M_MASK)
-
-#define IWL_OFDM_RATES_MASK         \
-       (IWL_OFDM_BASIC_RATES_MASK | \
-	IWL_RATE_9M_MASK          | \
-	IWL_RATE_18M_MASK         | \
-	IWL_RATE_36M_MASK         | \
-	IWL_RATE_48M_MASK         | \
-	IWL_RATE_54M_MASK)
-
-#define IWL_BASIC_RATES_MASK         \
-	(IWL_OFDM_BASIC_RATES_MASK | \
-	 IWL_CCK_BASIC_RATES_MASK)
-
 #define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
 
 #define IWL_INVALID_VALUE    -1
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d950166..8f41543 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -87,11 +87,6 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 
 	iwl_set_flags_for_band(priv, ctx, priv->band, ctx->vif);
 
-	ctx->staging.ofdm_basic_rates =
-	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-	ctx->staging.cck_basic_rates =
-	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-
 	/* clear both MIX and PURE40 mode flag */
 	ctx->staging.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED |
 					RXON_FLG_CHANNEL_MODE_PURE_40);
@@ -771,19 +766,6 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 	}
 }
 
-void iwl_set_rate(struct iwl_priv *priv)
-{
-	struct iwl_rxon_context *ctx;
-
-	for_each_context(priv, ctx) {
-		ctx->staging.cck_basic_rates =
-		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-
-		ctx->staging.ofdm_basic_rates =
-		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-	}
-}
-
 static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv,
 				  struct iwl_rxon_context *ctx, int hw_decrypt)
 {
@@ -959,6 +941,97 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
+static void iwl_calc_basic_rates(struct iwl_priv *priv,
+				 struct iwl_rxon_context *ctx)
+{
+	int lowest_present_ofdm = 100;
+	int lowest_present_cck = 100;
+	u8 cck = 0;
+	u8 ofdm = 0;
+
+	if (ctx->vif) {
+		struct ieee80211_supported_band *sband;
+		unsigned long basic = ctx->vif->bss_conf.basic_rates;
+		int i;
+
+		sband = priv->hw->wiphy->bands[priv->hw->conf.channel->band];
+
+		for_each_set_bit(i, &basic, BITS_PER_LONG) {
+			int hw = sband->bitrates[i].hw_value;
+			if (hw >= IWL_FIRST_OFDM_RATE) {
+				ofdm |= BIT(hw - IWL_FIRST_OFDM_RATE);
+				if (lowest_present_ofdm > hw)
+					lowest_present_ofdm = hw;
+			} else {
+				BUILD_BUG_ON(IWL_FIRST_CCK_RATE != 0);
+
+				cck |= BIT(hw);
+				if (lowest_present_cck > hw)
+					lowest_present_cck = hw;
+			}
+		}
+	}
+
+	/*
+	 * Now we've got the basic rates as bitmaps in the ofdm and cck
+	 * variables. This isn't sufficient though, as there might not
+	 * be all the right rates in the bitmap. E.g. if the only basic
+	 * rates are 5.5 Mbps and 11 Mbps, we still need to add 1 Mbps
+	 * and 6 Mbps because the 802.11-2007 standard says in 9.6:
+	 *
+	 *    [...] a STA responding to a received frame shall transmit
+	 *    its Control Response frame [...] at the highest rate in the
+	 *    BSSBasicRateSet parameter that is less than or equal to the
+	 *    rate of the immediately previous frame in the frame exchange
+	 *    sequence ([...]) and that is of the same modulation class
+	 *    ([...]) as the received frame. If no rate contained in the
+	 *    BSSBasicRateSet parameter meets these conditions, then the
+	 *    control frame sent in response to a received frame shall be
+	 *    transmitted at the highest mandatory rate of the PHY that is
+	 *    less than or equal to the rate of the received frame, and
+	 *    that is of the same modulation class as the received frame.
+	 *
+	 * As a consequence, we need to add all mandatory rates that are
+	 * lower than all of the basic rates to these bitmaps.
+	 */
+
+	if (IWL_RATE_24M_INDEX < lowest_present_ofdm)
+		ofdm |= IWL_RATE_24M_MASK >> IWL_FIRST_OFDM_RATE;
+	if (IWL_RATE_12M_INDEX < lowest_present_ofdm)
+		ofdm |= IWL_RATE_12M_MASK >> IWL_FIRST_OFDM_RATE;
+	/* 6M already there or needed so always add */
+	ofdm |= IWL_RATE_6M_MASK >> IWL_FIRST_OFDM_RATE;
+
+	/*
+	 * CCK is a bit more complex with DSSS vs. HR/DSSS vs. ERP.
+	 * Note, however:
+	 *  - if no CCK rates are basic, it must be ERP since there must
+	 *    be some basic rates at all, so they're OFDM => ERP PHY
+	 *    (or we're in 5 GHz, and the cck bitmap will never be used)
+	 *  - if 11M is a basic rate, it must be ERP as well, so add 5.5M
+	 *  - if 5.5M is basic, 1M and 2M are mandatory
+	 *  - if 2M is basic, 1M is mandatory
+	 *  - if 1M is basic, that's the only valid ACK rate.
+	 * As a consequence, it's not as complicated as it sounds, just add
+	 * any lower rates to the ACK rate bitmap.
+	 */
+	if (IWL_RATE_11M_INDEX < lowest_present_ofdm)
+		ofdm |= IWL_RATE_11M_MASK >> IWL_FIRST_CCK_RATE;
+	if (IWL_RATE_5M_INDEX < lowest_present_ofdm)
+		ofdm |= IWL_RATE_5M_MASK >> IWL_FIRST_CCK_RATE;
+	if (IWL_RATE_2M_INDEX < lowest_present_ofdm)
+		ofdm |= IWL_RATE_2M_MASK >> IWL_FIRST_CCK_RATE;
+	/* 1M already there or needed so always add */
+	cck |= IWL_RATE_1M_MASK >> IWL_FIRST_CCK_RATE;
+
+	IWL_DEBUG_RATE(priv, "Set basic rates cck:0x%.2x ofdm:0x%.2x\n",
+		       cck, ofdm);
+
+	/* "basic_rates" is a misnomer here -- should be called ACK rates */
+	ctx->staging.cck_basic_rates = cck;
+	ctx->staging.ofdm_basic_rates = ofdm;
+}
+
 /**
  * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
@@ -998,6 +1071,9 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
+	/* recalculate basic rates */
+	iwl_calc_basic_rates(priv, ctx);
+
 	/*
 	 * force CTS-to-self frames protection if RTS-CTS is not preferred
 	 * one aggregation protection method
@@ -1186,13 +1262,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 		}
 
 		iwl_update_bcast_stations(priv);
-
-		/*
-		 * The list of supported rates and rate mask can be different
-		 * for each band; since the band may have changed, reset
-		 * the rate mask to what mac80211 lists.
-		 */
-		iwl_set_rate(priv);
 	}
 
 	if (changed & (IEEE80211_CONF_CHANGE_PS |
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 3d6f3e2..bd467c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -154,7 +154,6 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    enum ieee80211_band band,
 			    struct ieee80211_vif *vif);
-void iwl_set_rate(struct iwl_priv *priv);
 
 /* uCode */
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index b309ede..8adbbf2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -894,7 +894,6 @@ void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	iwl_set_rxon_ht(priv, ht_conf);
 	iwl_set_flags_for_band(priv, ctx, channel->band, ctx->vif);
 
-	iwl_set_rate(priv);
 	/*
 	 * at this point, staging_rxon has the
 	 * configuration for channel switch
-- 
1.7.0.4

