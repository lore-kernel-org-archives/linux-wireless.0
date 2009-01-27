Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZA0WZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 17:25:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/7] iwl3945: Getting rid of the *39_rxon iwl_priv fields
Date: Tue, 27 Jan 2009 14:27:52 -0800
Message-Id: <1233095278-5850-2-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232526_138704_AC675221)
In-Reply-To: <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

The iwl_rxon_cmd is really just a iwl3945_rxon_cmd structure extension.
So, we can use the *_rxon fields from iwl_priv instead of the 3945 specific
ones (*39_rxon). We have to then be careful when submitting REPLY_RXON host
commands, since the command length as to be set according to the HW. As
another precaution the reserved4 and reserved5 fields are cleared before being
sent to the 3945.

With the *39_rxon removal, a lot of duplicated code can be removed from the
3945 code base.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c           |   13 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h           |    8 -
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c |  109 ----
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  358 +----------
 drivers/net/wireless/iwlwifi/iwl-core.c           |  434 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h           |   19 +
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    7 -
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    9 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c       |  711 ++++-----------------
 11 files changed, 585 insertions(+), 1087 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index fec2fbf..ddc8b31 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -8,7 +8,7 @@ iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
 iwlcore-$(CONFIG_IWLAGN_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
 
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
-iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-hcmd-check.o
+iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 044abf7..b93f5ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -934,7 +934,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	switch (priv->band) {
 	case IEEE80211_BAND_2GHZ:
 		/* TODO: this always does G, not a regression */
-		if (priv->active39_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
+		if (priv->active_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
 			rs_sta->tgg = 1;
 			rs_sta->expected_tpt = iwl3945_expected_tpt_g_prot;
 		} else
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 12f93b6..610ee17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -251,7 +251,7 @@ int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate)
 		break;
 	case IEEE80211_BAND_2GHZ:
 		if (!(priv->sta_supp_rates & IWL_OFDM_RATES_MASK) &&
-		    iwl3945_is_associated(priv)) {
+		    iwl_is_associated(priv)) {
 			if (rate == IWL_RATE_11M_INDEX)
 				next_rate = IWL_RATE_5M_INDEX;
 		}
@@ -579,7 +579,8 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 	skb_put(rxb->skb, le16_to_cpu(rx_hdr->len));
 
 	if (!iwl3945_mod_params.sw_crypto)
-		iwl3945_set_decrypted_flag(priv, rxb->skb,
+		iwl_set_decrypted_flag(priv,
+				       (struct ieee80211_hdr *)rxb->skb->data,
 				       le32_to_cpu(rx_end->status), stats);
 
 #ifdef CONFIG_IWL3945_LEDS
@@ -1694,17 +1695,17 @@ int iwl3945_send_tx_power(struct iwl_priv *priv)
 	int rate_idx, i;
 	const struct iwl_channel_info *ch_info = NULL;
 	struct iwl3945_txpowertable_cmd txpower = {
-		.channel = priv->active39_rxon.channel,
+		.channel = priv->active_rxon.channel,
 	};
 
 	txpower.band = (priv->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
 	ch_info = iwl_get_channel_info(priv,
 				       priv->band,
-				       le16_to_cpu(priv->active39_rxon.channel));
+				       le16_to_cpu(priv->active_rxon.channel));
 	if (!ch_info) {
 		IWL_ERR(priv,
 			"Failed to get channel info for channel %d [%d]\n",
-			le16_to_cpu(priv->active39_rxon.channel), priv->band);
+			le16_to_cpu(priv->active_rxon.channel), priv->band);
 		return -EINVAL;
 	}
 
@@ -2432,7 +2433,7 @@ int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 		 * 1M CCK rates */
 
 		if (!(priv->sta_supp_rates & IWL_OFDM_RATES_MASK) &&
-		    iwl3945_is_associated(priv)) {
+		    iwl_is_associated(priv)) {
 
 			index = IWL_FIRST_CCK_RATE;
 			for (i = IWL_RATE_6M_INDEX_TABLE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index fef54e9..ab7aaf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -222,9 +222,6 @@ extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
 					 struct iwl_host_cmd *cmd);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
-extern void iwl3945_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
-				   u32 decrypt_res,
-				   struct ieee80211_rx_status *stats);
 
 /*
  * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
@@ -303,11 +300,6 @@ extern int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv);
 extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags);
 
-static inline int iwl3945_is_associated(struct iwl_priv *priv)
-{
-	return (priv->active39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
-}
-
 extern const struct iwl_channel_info *iwl3945_get_channel_info(
 	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
deleted file mode 100644
index 1217a1d..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
+++ /dev/null
@@ -1,109 +0,0 @@
-/******************************************************************************
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *****************************************************************************/
-
-#include <linux/kernel.h>
-#include <net/mac80211.h>
-#include "iwl-dev.h"
-#include "iwl-debug.h"
-#include "iwl-commands.h"
-
-
-/**
- * iwl_check_rxon_cmd - validate RXON structure is valid
- *
- * NOTE:  This is really only useful during development and can eventually
- * be #ifdef'd out once the driver is stable and folks aren't actively
- * making changes
- */
-int iwl_agn_check_rxon_cmd(struct iwl_priv *priv)
-{
-	int error = 0;
-	int counter = 1;
-	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
-
-	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
-		error |= le32_to_cpu(rxon->flags &
-				(RXON_FLG_TGJ_NARROW_BAND_MSK |
-				 RXON_FLG_RADAR_DETECT_MSK));
-		if (error)
-			IWL_WARN(priv, "check 24G fields %d | %d\n",
-				    counter++, error);
-	} else {
-		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
-				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
-		if (error)
-			IWL_WARN(priv, "check 52 fields %d | %d\n",
-				    counter++, error);
-		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
-		if (error)
-			IWL_WARN(priv, "check 52 CCK %d | %d\n",
-				    counter++, error);
-	}
-	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
-	if (error)
-		IWL_WARN(priv, "check mac addr %d | %d\n", counter++, error);
-
-	/* make sure basic rates 6Mbps and 1Mbps are supported */
-	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
-		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
-	if (error)
-		IWL_WARN(priv, "check basic rate %d | %d\n", counter++, error);
-
-	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
-	if (error)
-		IWL_WARN(priv, "check assoc id %d | %d\n", counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
-	if (error)
-		IWL_WARN(priv, "check CCK and short slot %d | %d\n",
-			    counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
-	if (error)
-		IWL_WARN(priv, "check CCK & auto detect %d | %d\n",
-			    counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
-			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
-	if (error)
-		IWL_WARN(priv, "check TGG and auto detect %d | %d\n",
-			    counter++, error);
-
-	if (error)
-		IWL_WARN(priv, "Tuning to channel %d\n",
-			    le16_to_cpu(rxon->channel));
-
-	if (error) {
-		IWL_ERR(priv, "Not a valid iwl_rxon_assoc_cmd field values\n");
-		return -1;
-	}
-	return 0;
-}
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 757a9bd..2307c75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -94,66 +94,6 @@ MODULE_ALIAS("iwl4965");
 
 /**************************************************************/
 
-
-
-static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
-{
-	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
-
-	if (hw_decrypt)
-		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
-	else
-		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
-
-}
-
-/**
- * iwl_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
- * @priv: staging_rxon is compared to active_rxon
- *
- * If the RXON structure is changing enough to require a new tune,
- * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
- * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
- */
-static int iwl_full_rxon_required(struct iwl_priv *priv)
-{
-
-	/* These items are only settable from the full RXON command */
-	if (!(iwl_is_associated(priv)) ||
-	    compare_ether_addr(priv->staging_rxon.bssid_addr,
-			       priv->active_rxon.bssid_addr) ||
-	    compare_ether_addr(priv->staging_rxon.node_addr,
-			       priv->active_rxon.node_addr) ||
-	    compare_ether_addr(priv->staging_rxon.wlap_bssid_addr,
-			       priv->active_rxon.wlap_bssid_addr) ||
-	    (priv->staging_rxon.dev_type != priv->active_rxon.dev_type) ||
-	    (priv->staging_rxon.channel != priv->active_rxon.channel) ||
-	    (priv->staging_rxon.air_propagation !=
-	     priv->active_rxon.air_propagation) ||
-	    (priv->staging_rxon.ofdm_ht_single_stream_basic_rates !=
-	     priv->active_rxon.ofdm_ht_single_stream_basic_rates) ||
-	    (priv->staging_rxon.ofdm_ht_dual_stream_basic_rates !=
-	     priv->active_rxon.ofdm_ht_dual_stream_basic_rates) ||
-	    (priv->staging_rxon.assoc_id != priv->active_rxon.assoc_id))
-		return 1;
-
-	/* flags, filter_flags, ofdm_basic_rates, and cck_basic_rates can
-	 * be updated with the RXON_ASSOC command -- however only some
-	 * flag transitions are allowed using RXON_ASSOC */
-
-	/* Check if we are not switching bands */
-	if ((priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) !=
-	    (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK))
-		return 1;
-
-	/* Check if we are switching association toggle */
-	if ((priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) !=
-		(priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK))
-		return 1;
-
-	return 0;
-}
-
 /**
  * iwl_commit_rxon - commit staging_rxon to hardware
  *
@@ -179,7 +119,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	 * 5000, but will not damage 4965 */
 	priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
 
-	ret = iwl_agn_check_rxon_cmd(priv);
+	ret = iwl_check_rxon_cmd(priv);
 	if (ret) {
 		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
@@ -374,31 +314,6 @@ static unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
-static u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv)
-{
-	int i;
-	int rate_mask;
-
-	/* Set rate mask*/
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
-		rate_mask = priv->active_rate_basic & IWL_CCK_RATES_MASK;
-	else
-		rate_mask = priv->active_rate_basic & IWL_OFDM_RATES_MASK;
-
-	/* Find lowest valid rate */
-	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
-					i = iwl_rates[i].next_ieee) {
-		if (rate_mask & (1 << i))
-			return iwl_rates[i].plcp;
-	}
-
-	/* No valid rate was found. Assign the lowest one */
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
-		return IWL_RATE_1M_PLCP;
-	else
-		return IWL_RATE_6M_PLCP;
-}
-
 static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 				       struct iwl_frame *frame, u8 rate)
 {
@@ -771,111 +686,10 @@ static void iwl_setup_rxon_timing(struct iwl_priv *priv)
 			le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
-static void iwl_set_flags_for_band(struct iwl_priv *priv,
-				   enum ieee80211_band band)
-{
-	if (band == IEEE80211_BAND_5GHZ) {
-		priv->staging_rxon.flags &=
-		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
-		      | RXON_FLG_CCK_MSK);
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
-	} else {
-		/* Copied from iwl_post_associate() */
-		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
-		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
-		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
-		priv->staging_rxon.flags |= RXON_FLG_AUTO_DETECT_MSK;
-		priv->staging_rxon.flags &= ~RXON_FLG_CCK_MSK;
-	}
-}
-
-/*
- * initialize rxon structure with default values from eeprom
- */
-static void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
-{
-	const struct iwl_channel_info *ch_info;
-
-	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
-
-	switch (mode) {
-	case NL80211_IFTYPE_AP:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
-		break;
-
-	case NL80211_IFTYPE_STATION:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_ESS;
-		priv->staging_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
-
-	case NL80211_IFTYPE_ADHOC:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_IBSS;
-		priv->staging_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
-		priv->staging_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
-						  RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
-
-	case NL80211_IFTYPE_MONITOR:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_SNIFFER;
-		priv->staging_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
-		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
-	default:
-		IWL_ERR(priv, "Unsupported interface type %d\n", mode);
-		break;
-	}
-
-#if 0
-	/* TODO:  Figure out when short_preamble would be set and cache from
-	 * that */
-	if (!hw_to_local(priv->hw)->short_preamble)
-		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
-	else
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
-#endif
-
-	ch_info = iwl_get_channel_info(priv, priv->band,
-				       le16_to_cpu(priv->active_rxon.channel));
-
-	if (!ch_info)
-		ch_info = &priv->channel_info[0];
-
-	/*
-	 * in some case A channels are all non IBSS
-	 * in this case force B/G channel
-	 */
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
-	    !(is_channel_ibss(ch_info)))
-		ch_info = &priv->channel_info[0];
-
-	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
-	priv->band = ch_info->band;
-
-	iwl_set_flags_for_band(priv, priv->band);
-
-	priv->staging_rxon.ofdm_basic_rates =
-	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-	priv->staging_rxon.cck_basic_rates =
-	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-
-	priv->staging_rxon.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
-					RXON_FLG_CHANNEL_MODE_PURE_40_MSK);
-	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
-	memcpy(priv->staging_rxon.wlap_bssid_addr, priv->mac_addr, ETH_ALEN);
-	priv->staging_rxon.ofdm_ht_single_stream_basic_rates = 0xff;
-	priv->staging_rxon.ofdm_ht_dual_stream_basic_rates = 0xff;
-	iwl_set_rxon_chain(priv);
-}
-
 static int iwl_set_mode(struct iwl_priv *priv, int mode)
 {
 	iwl_connection_init_rx_config(priv, mode);
+	iwl_set_rxon_chain(priv);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
 	iwl_clear_stations_table(priv);
@@ -896,54 +710,6 @@ static int iwl_set_mode(struct iwl_priv *priv, int mode)
 	return 0;
 }
 
-static void iwl_set_rate(struct iwl_priv *priv)
-{
-	const struct ieee80211_supported_band *hw = NULL;
-	struct ieee80211_rate *rate;
-	int i;
-
-	hw = iwl_get_hw_mode(priv, priv->band);
-	if (!hw) {
-		IWL_ERR(priv, "Failed to set rate: unable to get hw mode\n");
-		return;
-	}
-
-	priv->active_rate = 0;
-	priv->active_rate_basic = 0;
-
-	for (i = 0; i < hw->n_bitrates; i++) {
-		rate = &(hw->bitrates[i]);
-		if (rate->hw_value < IWL_RATE_COUNT)
-			priv->active_rate |= (1 << rate->hw_value);
-	}
-
-	IWL_DEBUG_RATE("Set active_rate = %0x, active_rate_basic = %0x\n",
-		       priv->active_rate, priv->active_rate_basic);
-
-	/*
-	 * If a basic rate is configured, then use it (adding IWL_RATE_1M_MASK)
-	 * otherwise set it to the default of all CCK rates and 6, 12, 24 for
-	 * OFDM
-	 */
-	if (priv->active_rate_basic & IWL_CCK_BASIC_RATES_MASK)
-		priv->staging_rxon.cck_basic_rates =
-		    ((priv->active_rate_basic &
-		      IWL_CCK_RATES_MASK) >> IWL_FIRST_CCK_RATE) & 0xF;
-	else
-		priv->staging_rxon.cck_basic_rates =
-		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-
-	if (priv->active_rate_basic & IWL_OFDM_BASIC_RATES_MASK)
-		priv->staging_rxon.ofdm_basic_rates =
-		    ((priv->active_rate_basic &
-		      (IWL_OFDM_BASIC_RATES_MASK | IWL_RATE_6M_MASK)) >>
-		      IWL_FIRST_OFDM_RATE) & 0xFF;
-	else
-		priv->staging_rxon.ofdm_basic_rates =
-		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-}
-
-
 /******************************************************************************
  *
  * Generic RX handler implementations
@@ -999,19 +765,6 @@ static void iwl_rx_reply_error(struct iwl_priv *priv,
 		le32_to_cpu(pkt->u.err_resp.error_info));
 }
 
-#define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
-
-static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
-	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
-	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
-		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
-	rxon->channel = csa->channel;
-	priv->staging_rxon.channel = csa->channel;
-}
-
 static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
@@ -1370,27 +1123,6 @@ void iwl_rx_handle(struct iwl_priv *priv)
 	iwl_rx_queue_restock(priv);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
-{
-	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
-
-	IWL_DEBUG_RADIO("RX CONFIG:\n");
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
-	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
-	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
-	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
-			le32_to_cpu(rxon->filter_flags));
-	IWL_DEBUG_RADIO("u8 dev_type: 0x%x\n", rxon->dev_type);
-	IWL_DEBUG_RADIO("u8 ofdm_basic_rates: 0x%02x\n",
-			rxon->ofdm_basic_rates);
-	IWL_DEBUG_RADIO("u8 cck_basic_rates: 0x%02x\n", rxon->cck_basic_rates);
-	IWL_DEBUG_RADIO("u8[6] node_addr: %pM\n", rxon->node_addr);
-	IWL_DEBUG_RADIO("u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
-	IWL_DEBUG_RADIO("u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
-}
-#endif
-
 /* call this function to flush any scheduled tasklet */
 static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 {
@@ -1399,45 +1131,6 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-/**
- * iwl_irq_handle_error - called for HW or SW error interrupt from card
- */
-static void iwl_irq_handle_error(struct iwl_priv *priv)
-{
-	/* Set the FW error flag -- cleared on iwl_down */
-	set_bit(STATUS_FW_ERROR, &priv->status);
-
-	/* Cancel currently queued command. */
-	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & IWL_DL_FW_ERRORS) {
-		iwl_dump_nic_error_log(priv);
-		iwl_dump_nic_event_log(priv);
-		iwl_print_rx_config_cmd(priv);
-	}
-#endif
-
-	wake_up_interruptible(&priv->wait_command_queue);
-
-	/* Keep the restart process from trying to send host
-	 * commands by clearing the INIT status bit */
-	clear_bit(STATUS_READY, &priv->status);
-
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG(IWL_DL_FW_ERRORS,
-			  "Restarting adapter due to uCode error.\n");
-
-		if (iwl_is_associated(priv)) {
-			memcpy(&priv->recovery_rxon, &priv->active_rxon,
-			       sizeof(priv->recovery_rxon));
-			priv->error_recovering = 1;
-		}
-		if (priv->cfg->mod_params->restart_fw)
-			queue_work(priv->workqueue, &priv->restart);
-	}
-}
-
 static void iwl_error_recovery(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -2006,6 +1699,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	} else {
 		/* Initialize our rx_config data */
 		iwl_connection_init_rx_config(priv, priv->iw_mode);
+		iwl_set_rxon_chain(priv);
 		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
@@ -2895,52 +2589,6 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl_configure_filter(struct ieee80211_hw *hw,
-				 unsigned int changed_flags,
-				 unsigned int *total_flags,
-				 int mc_count, struct dev_addr_list *mc_list)
-{
-	struct iwl_priv *priv = hw->priv;
-	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
-
-	IWL_DEBUG_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
-			changed_flags, *total_flags);
-
-	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
-		if (*total_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS))
-			*filter_flags |= RXON_FILTER_PROMISC_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_PROMISC_MSK;
-	}
-	if (changed_flags & FIF_ALLMULTI) {
-		if (*total_flags & FIF_ALLMULTI)
-			*filter_flags |= RXON_FILTER_ACCEPT_GRP_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_ACCEPT_GRP_MSK;
-	}
-	if (changed_flags & FIF_CONTROL) {
-		if (*total_flags & FIF_CONTROL)
-			*filter_flags |= RXON_FILTER_CTL2HOST_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_CTL2HOST_MSK;
-	}
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			*filter_flags |= RXON_FILTER_BCON_AWARE_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_BCON_AWARE_MSK;
-	}
-
-	/* We avoid iwl_commit_rxon here to commit the new filter flags
-	 * since mac80211 will call ieee80211_hw_config immediately.
-	 * (mc_list is not supported at this time). Otherwise, we need to
-	 * queue a background iwl_commit_rxon work.
-	 */
-
-	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
-			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
-}
-
 static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_if_init_conf *conf)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 21f3865..4f2b88c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -28,6 +28,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/etherdevice.h>
 #include <net/mac80211.h>
 
 #include "iwl-eeprom.h"
@@ -403,6 +404,7 @@ static void iwlcore_init_hw_rates(struct iwl_priv *priv,
 	}
 }
 
+
 /**
  * iwlcore_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
@@ -586,6 +588,167 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_is_fat_tx_allowed);
 
+void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
+{
+	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+
+	if (hw_decrypt)
+		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
+	else
+		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
+
+}
+EXPORT_SYMBOL(iwl_set_rxon_hwcrypto);
+
+/**
+ * iwl_check_rxon_cmd - validate RXON structure is valid
+ *
+ * NOTE:  This is really only useful during development and can eventually
+ * be #ifdef'd out once the driver is stable and folks aren't actively
+ * making changes
+ */
+int iwl_check_rxon_cmd(struct iwl_priv *priv)
+{
+	int error = 0;
+	int counter = 1;
+	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+
+	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
+		error |= le32_to_cpu(rxon->flags &
+				(RXON_FLG_TGJ_NARROW_BAND_MSK |
+				 RXON_FLG_RADAR_DETECT_MSK));
+		if (error)
+			IWL_WARN(priv, "check 24G fields %d | %d\n",
+				    counter++, error);
+	} else {
+		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
+				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
+		if (error)
+			IWL_WARN(priv, "check 52 fields %d | %d\n",
+				    counter++, error);
+		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
+		if (error)
+			IWL_WARN(priv, "check 52 CCK %d | %d\n",
+				    counter++, error);
+	}
+	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
+	if (error)
+		IWL_WARN(priv, "check mac addr %d | %d\n", counter++, error);
+
+	/* make sure basic rates 6Mbps and 1Mbps are supported */
+	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
+		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
+	if (error)
+		IWL_WARN(priv, "check basic rate %d | %d\n", counter++, error);
+
+	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
+	if (error)
+		IWL_WARN(priv, "check assoc id %d | %d\n", counter++, error);
+
+	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
+	if (error)
+		IWL_WARN(priv, "check CCK and short slot %d | %d\n",
+			    counter++, error);
+
+	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
+	if (error)
+		IWL_WARN(priv, "check CCK & auto detect %d | %d\n",
+			    counter++, error);
+
+	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
+			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
+	if (error)
+		IWL_WARN(priv, "check TGG and auto detect %d | %d\n",
+			    counter++, error);
+
+	if (error)
+		IWL_WARN(priv, "Tuning to channel %d\n",
+			    le16_to_cpu(rxon->channel));
+
+	if (error) {
+		IWL_ERR(priv, "Not a valid iwl_rxon_assoc_cmd field values\n");
+		return -1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(iwl_check_rxon_cmd);
+
+/**
+ * iwl_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
+ * @priv: staging_rxon is compared to active_rxon
+ *
+ * If the RXON structure is changing enough to require a new tune,
+ * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
+ * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
+ */
+int iwl_full_rxon_required(struct iwl_priv *priv)
+{
+
+	/* These items are only settable from the full RXON command */
+	if (!(iwl_is_associated(priv)) ||
+	    compare_ether_addr(priv->staging_rxon.bssid_addr,
+			       priv->active_rxon.bssid_addr) ||
+	    compare_ether_addr(priv->staging_rxon.node_addr,
+			       priv->active_rxon.node_addr) ||
+	    compare_ether_addr(priv->staging_rxon.wlap_bssid_addr,
+			       priv->active_rxon.wlap_bssid_addr) ||
+	    (priv->staging_rxon.dev_type != priv->active_rxon.dev_type) ||
+	    (priv->staging_rxon.channel != priv->active_rxon.channel) ||
+	    (priv->staging_rxon.air_propagation !=
+	     priv->active_rxon.air_propagation) ||
+	    (priv->staging_rxon.ofdm_ht_single_stream_basic_rates !=
+	     priv->active_rxon.ofdm_ht_single_stream_basic_rates) ||
+	    (priv->staging_rxon.ofdm_ht_dual_stream_basic_rates !=
+	     priv->active_rxon.ofdm_ht_dual_stream_basic_rates) ||
+	    (priv->staging_rxon.assoc_id != priv->active_rxon.assoc_id))
+		return 1;
+
+	/* flags, filter_flags, ofdm_basic_rates, and cck_basic_rates can
+	 * be updated with the RXON_ASSOC command -- however only some
+	 * flag transitions are allowed using RXON_ASSOC */
+
+	/* Check if we are not switching bands */
+	if ((priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) !=
+	    (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK))
+		return 1;
+
+	/* Check if we are switching association toggle */
+	if ((priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) !=
+		(priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK))
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_full_rxon_required);
+
+u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv)
+{
+	int i;
+	int rate_mask;
+
+	/* Set rate mask*/
+	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+		rate_mask = priv->active_rate_basic & IWL_CCK_RATES_MASK;
+	else
+		rate_mask = priv->active_rate_basic & IWL_OFDM_RATES_MASK;
+
+	/* Find lowest valid rate */
+	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
+					i = iwl_rates[i].next_ieee) {
+		if (rate_mask & (1 << i))
+			return iwl_rates[i].plcp;
+	}
+
+	/* No valid rate was found. Assign the lowest one */
+	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+		return IWL_RATE_1M_PLCP;
+	else
+		return IWL_RATE_6M_PLCP;
+}
+EXPORT_SYMBOL(iwl_rate_get_lowest_plcp);
+
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
@@ -821,6 +984,277 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 }
 EXPORT_SYMBOL(iwl_set_rxon_channel);
 
+void iwl_set_flags_for_band(struct iwl_priv *priv,
+			    enum ieee80211_band band)
+{
+	if (band == IEEE80211_BAND_5GHZ) {
+		priv->staging_rxon.flags &=
+		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
+		      | RXON_FLG_CCK_MSK);
+		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+	} else {
+		/* Copied from iwl_post_associate() */
+		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
+			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+		else
+			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
+			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+
+		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
+		priv->staging_rxon.flags |= RXON_FLG_AUTO_DETECT_MSK;
+		priv->staging_rxon.flags &= ~RXON_FLG_CCK_MSK;
+	}
+}
+EXPORT_SYMBOL(iwl_set_flags_for_band);
+
+/*
+ * initialize rxon structure with default values from eeprom
+ */
+void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
+{
+	const struct iwl_channel_info *ch_info;
+
+	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
+
+	switch (mode) {
+	case NL80211_IFTYPE_AP:
+		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
+		break;
+
+	case NL80211_IFTYPE_STATION:
+		priv->staging_rxon.dev_type = RXON_DEV_TYPE_ESS;
+		priv->staging_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
+		break;
+
+	case NL80211_IFTYPE_ADHOC:
+		priv->staging_rxon.dev_type = RXON_DEV_TYPE_IBSS;
+		priv->staging_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
+		priv->staging_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
+						  RXON_FILTER_ACCEPT_GRP_MSK;
+		break;
+
+	case NL80211_IFTYPE_MONITOR:
+		priv->staging_rxon.dev_type = RXON_DEV_TYPE_SNIFFER;
+		priv->staging_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
+		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
+		break;
+	default:
+		IWL_ERR(priv, "Unsupported interface type %d\n", mode);
+		break;
+	}
+
+#if 0
+	/* TODO:  Figure out when short_preamble would be set and cache from
+	 * that */
+	if (!hw_to_local(priv->hw)->short_preamble)
+		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+	else
+		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+#endif
+
+	ch_info = iwl_get_channel_info(priv, priv->band,
+				       le16_to_cpu(priv->active_rxon.channel));
+
+	if (!ch_info)
+		ch_info = &priv->channel_info[0];
+
+	/*
+	 * in some case A channels are all non IBSS
+	 * in this case force B/G channel
+	 */
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
+	    !(is_channel_ibss(ch_info)))
+		ch_info = &priv->channel_info[0];
+
+	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
+	priv->band = ch_info->band;
+
+	iwl_set_flags_for_band(priv, priv->band);
+
+	priv->staging_rxon.ofdm_basic_rates =
+	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
+	priv->staging_rxon.cck_basic_rates =
+	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
+
+	priv->staging_rxon.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
+					RXON_FLG_CHANNEL_MODE_PURE_40_MSK);
+	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
+	memcpy(priv->staging_rxon.wlap_bssid_addr, priv->mac_addr, ETH_ALEN);
+	priv->staging_rxon.ofdm_ht_single_stream_basic_rates = 0xff;
+	priv->staging_rxon.ofdm_ht_dual_stream_basic_rates = 0xff;
+}
+EXPORT_SYMBOL(iwl_connection_init_rx_config);
+
+void iwl_set_rate(struct iwl_priv *priv)
+{
+	const struct ieee80211_supported_band *hw = NULL;
+	struct ieee80211_rate *rate;
+	int i;
+
+	hw = iwl_get_hw_mode(priv, priv->band);
+	if (!hw) {
+		IWL_ERR(priv, "Failed to set rate: unable to get hw mode\n");
+		return;
+	}
+
+	priv->active_rate = 0;
+	priv->active_rate_basic = 0;
+
+	for (i = 0; i < hw->n_bitrates; i++) {
+		rate = &(hw->bitrates[i]);
+		if (rate->hw_value < IWL_RATE_COUNT)
+			priv->active_rate |= (1 << rate->hw_value);
+	}
+
+	IWL_DEBUG_RATE("Set active_rate = %0x, active_rate_basic = %0x\n",
+		       priv->active_rate, priv->active_rate_basic);
+
+	/*
+	 * If a basic rate is configured, then use it (adding IWL_RATE_1M_MASK)
+	 * otherwise set it to the default of all CCK rates and 6, 12, 24 for
+	 * OFDM
+	 */
+	if (priv->active_rate_basic & IWL_CCK_BASIC_RATES_MASK)
+		priv->staging_rxon.cck_basic_rates =
+		    ((priv->active_rate_basic &
+		      IWL_CCK_RATES_MASK) >> IWL_FIRST_CCK_RATE) & 0xF;
+	else
+		priv->staging_rxon.cck_basic_rates =
+		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
+
+	if (priv->active_rate_basic & IWL_OFDM_BASIC_RATES_MASK)
+		priv->staging_rxon.ofdm_basic_rates =
+		    ((priv->active_rate_basic &
+		      (IWL_OFDM_BASIC_RATES_MASK | IWL_RATE_6M_MASK)) >>
+		      IWL_FIRST_OFDM_RATE) & 0xFF;
+	else
+		priv->staging_rxon.ofdm_basic_rates =
+		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
+}
+EXPORT_SYMBOL(iwl_set_rate);
+
+void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
+	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
+	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
+		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
+	rxon->channel = csa->channel;
+	priv->staging_rxon.channel = csa->channel;
+}
+EXPORT_SYMBOL(iwl_rx_csa);
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
+{
+	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+
+	IWL_DEBUG_RADIO("RX CONFIG:\n");
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
+	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
+	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
+			le32_to_cpu(rxon->filter_flags));
+	IWL_DEBUG_RADIO("u8 dev_type: 0x%x\n", rxon->dev_type);
+	IWL_DEBUG_RADIO("u8 ofdm_basic_rates: 0x%02x\n",
+			rxon->ofdm_basic_rates);
+	IWL_DEBUG_RADIO("u8 cck_basic_rates: 0x%02x\n", rxon->cck_basic_rates);
+	IWL_DEBUG_RADIO("u8[6] node_addr: %pM\n", rxon->node_addr);
+	IWL_DEBUG_RADIO("u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
+	IWL_DEBUG_RADIO("u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
+}
+#endif
+
+/**
+ * iwl_irq_handle_error - called for HW or SW error interrupt from card
+ */
+void iwl_irq_handle_error(struct iwl_priv *priv)
+{
+	/* Set the FW error flag -- cleared on iwl_down */
+	set_bit(STATUS_FW_ERROR, &priv->status);
+
+	/* Cancel currently queued command. */
+	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (priv->debug_level & IWL_DL_FW_ERRORS) {
+		iwl_dump_nic_error_log(priv);
+		iwl_dump_nic_event_log(priv);
+		iwl_print_rx_config_cmd(priv);
+	}
+#endif
+
+	wake_up_interruptible(&priv->wait_command_queue);
+
+	/* Keep the restart process from trying to send host
+	 * commands by clearing the INIT status bit */
+	clear_bit(STATUS_READY, &priv->status);
+
+	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+		IWL_DEBUG(IWL_DL_FW_ERRORS,
+			  "Restarting adapter due to uCode error.\n");
+
+		if (iwl_is_associated(priv)) {
+			memcpy(&priv->recovery_rxon, &priv->active_rxon,
+			       sizeof(priv->recovery_rxon));
+			priv->error_recovering = 1;
+		}
+		if (priv->cfg->mod_params->restart_fw)
+			queue_work(priv->workqueue, &priv->restart);
+	}
+}
+EXPORT_SYMBOL(iwl_irq_handle_error);
+
+void iwl_configure_filter(struct ieee80211_hw *hw,
+			  unsigned int changed_flags,
+			  unsigned int *total_flags,
+			  int mc_count, struct dev_addr_list *mc_list)
+{
+	struct iwl_priv *priv = hw->priv;
+	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
+
+	IWL_DEBUG_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
+			changed_flags, *total_flags);
+
+	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
+		if (*total_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS))
+			*filter_flags |= RXON_FILTER_PROMISC_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_PROMISC_MSK;
+	}
+	if (changed_flags & FIF_ALLMULTI) {
+		if (*total_flags & FIF_ALLMULTI)
+			*filter_flags |= RXON_FILTER_ACCEPT_GRP_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_ACCEPT_GRP_MSK;
+	}
+	if (changed_flags & FIF_CONTROL) {
+		if (*total_flags & FIF_CONTROL)
+			*filter_flags |= RXON_FILTER_CTL2HOST_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_CTL2HOST_MSK;
+	}
+	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+			*filter_flags |= RXON_FILTER_BCON_AWARE_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_BCON_AWARE_MSK;
+	}
+
+	/* We avoid iwl_commit_rxon here to commit the new filter flags
+	 * since mac80211 will call ieee80211_hw_config immediately.
+	 * (mc_list is not supported at this time). Otherwise, we need to
+	 * queue a background iwl_commit_rxon work.
+	 */
+
+	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
+			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
+}
+EXPORT_SYMBOL(iwl_configure_filter);
+
 int iwl_setup_mac(struct iwl_priv *priv)
 {
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3c6a4b0..0a719ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -221,11 +221,25 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
 void iwl_hw_detect(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
+void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt);
+int iwl_check_rxon_cmd(struct iwl_priv *priv);
+int iwl_full_rxon_required(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info);
 u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_sta_ht_cap *sta_ht_inf);
+void iwl_set_flags_for_band(struct iwl_priv *priv, enum ieee80211_band band);
+void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode);
+int iwl_set_decrypted_flag(struct iwl_priv *priv,
+			   struct ieee80211_hdr *hdr,
+			   u32 decrypt_res,
+			   struct ieee80211_rx_status *stats);
+void iwl_irq_handle_error(struct iwl_priv *priv);
+void iwl_configure_filter(struct ieee80211_hw *hw,
+			  unsigned int changed_flags,
+			  unsigned int *total_flags,
+			  int mc_count, struct dev_addr_list *mc_list);
 int iwl_hw_nic_init(struct iwl_priv *priv);
 int iwl_setup_mac(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
@@ -253,6 +267,7 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
+void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
 /* TX helpers */
 
@@ -296,6 +311,10 @@ void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			      struct ieee80211_tx_info *info);
 int iwl_hwrate_to_plcp_idx(u32 rate_n_flags);
 
+u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv);
+
+void iwl_set_rate(struct iwl_priv *priv);
+
 u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx);
 
 static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 437c05b..b9954bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1078,13 +1078,6 @@ struct iwl_priv {
 
 	/*For 3945*/
 #define IWL_DEFAULT_TX_POWER 0x0F
-	/* We declare this const so it can only be
-	 * changed via explicit cast within the
-	 * routines that actually update the physical
-	 * hardware */
-	const struct iwl3945_rxon_cmd active39_rxon;
-	struct iwl3945_rxon_cmd staging39_rxon;
-	struct iwl3945_rxon_cmd recovery39_rxon;
 
 	struct iwl3945_notif_statistics statistics_39;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 3314520..c8865d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -772,10 +772,10 @@ static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
 /*
  * returns non-zero if packet should be dropped
  */
-static int iwl_set_decrypted_flag(struct iwl_priv *priv,
-				      struct ieee80211_hdr *hdr,
-				      u32 decrypt_res,
-				      struct ieee80211_rx_status *stats)
+int iwl_set_decrypted_flag(struct iwl_priv *priv,
+			   struct ieee80211_hdr *hdr,
+			   u32 decrypt_res,
+			   struct ieee80211_rx_status *stats)
 {
 	u16 fc = le16_to_cpu(hdr->frame_control);
 
@@ -815,6 +815,7 @@ static int iwl_set_decrypted_flag(struct iwl_priv *priv,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(iwl_set_decrypted_flag);
 
 static u32 iwl_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 25a3508..6a2c8a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -233,166 +233,6 @@ u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flag
 
 }
 
-/**
- * iwl3945_set_rxon_channel - Set the phymode and channel values in staging RXON
- * @band: 2.4 or 5 GHz band
- * @channel: Any channel valid for the requested band
-
- * In addition to setting the staging RXON, priv->band is also set.
- *
- * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
- * in the staging RXON flag structure based on the band
- */
-static int iwl3945_set_rxon_channel(struct iwl_priv *priv,
-				    enum ieee80211_band band,
-				    u16 channel)
-{
-	if (!iwl_get_channel_info(priv, band, channel)) {
-		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
-			       channel, band);
-		return -EINVAL;
-	}
-
-	if ((le16_to_cpu(priv->staging39_rxon.channel) == channel) &&
-	    (priv->band == band))
-		return 0;
-
-	priv->staging39_rxon.channel = cpu_to_le16(channel);
-	if (band == IEEE80211_BAND_5GHZ)
-		priv->staging39_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
-	else
-		priv->staging39_rxon.flags |= RXON_FLG_BAND_24G_MSK;
-
-	priv->band = band;
-
-	IWL_DEBUG_INFO("Staging channel set to %d [%d]\n", channel, band);
-
-	return 0;
-}
-
-/**
- * iwl3945_check_rxon_cmd - validate RXON structure is valid
- *
- * NOTE:  This is really only useful during development and can eventually
- * be #ifdef'd out once the driver is stable and folks aren't actively
- * making changes
- */
-static int iwl3945_check_rxon_cmd(struct iwl_priv *priv)
-{
-	int error = 0;
-	int counter = 1;
-	struct iwl3945_rxon_cmd *rxon = &priv->staging39_rxon;
-
-	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
-		error |= le32_to_cpu(rxon->flags &
-				(RXON_FLG_TGJ_NARROW_BAND_MSK |
-				 RXON_FLG_RADAR_DETECT_MSK));
-		if (error)
-			IWL_WARN(priv, "check 24G fields %d | %d\n",
-				    counter++, error);
-	} else {
-		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
-				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
-		if (error)
-			IWL_WARN(priv, "check 52 fields %d | %d\n",
-				    counter++, error);
-		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
-		if (error)
-			IWL_WARN(priv, "check 52 CCK %d | %d\n",
-				    counter++, error);
-	}
-	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
-	if (error)
-		IWL_WARN(priv, "check mac addr %d | %d\n", counter++, error);
-
-	/* make sure basic rates 6Mbps and 1Mbps are supported */
-	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
-		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
-	if (error)
-		IWL_WARN(priv, "check basic rate %d | %d\n", counter++, error);
-
-	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
-	if (error)
-		IWL_WARN(priv, "check assoc id %d | %d\n", counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
-	if (error)
-		IWL_WARN(priv, "check CCK and short slot %d | %d\n",
-			    counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
-	if (error)
-		IWL_WARN(priv, "check CCK & auto detect %d | %d\n",
-			    counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
-			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
-	if (error)
-		IWL_WARN(priv, "check TGG and auto detect %d | %d\n",
-			    counter++, error);
-
-	if ((rxon->flags & RXON_FLG_DIS_DIV_MSK))
-		error |= ((rxon->flags & (RXON_FLG_ANT_B_MSK |
-				RXON_FLG_ANT_A_MSK)) == 0);
-	if (error)
-		IWL_WARN(priv, "check antenna %d %d\n", counter++, error);
-
-	if (error)
-		IWL_WARN(priv, "Tuning to channel %d\n",
-			    le16_to_cpu(rxon->channel));
-
-	if (error) {
-		IWL_ERR(priv, "Not a valid rxon_assoc_cmd field values\n");
-		return -1;
-	}
-	return 0;
-}
-
-/**
- * iwl3945_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
- * @priv: staging_rxon is compared to active_rxon
- *
- * If the RXON structure is changing enough to require a new tune,
- * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
- * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
- */
-static int iwl3945_full_rxon_required(struct iwl_priv *priv)
-{
-
-	/* These items are only settable from the full RXON command */
-	if (!(iwl3945_is_associated(priv)) ||
-	    compare_ether_addr(priv->staging39_rxon.bssid_addr,
-			       priv->active39_rxon.bssid_addr) ||
-	    compare_ether_addr(priv->staging39_rxon.node_addr,
-			       priv->active39_rxon.node_addr) ||
-	    compare_ether_addr(priv->staging39_rxon.wlap_bssid_addr,
-			       priv->active39_rxon.wlap_bssid_addr) ||
-	    (priv->staging39_rxon.dev_type != priv->active39_rxon.dev_type) ||
-	    (priv->staging39_rxon.channel != priv->active39_rxon.channel) ||
-	    (priv->staging39_rxon.air_propagation !=
-	     priv->active39_rxon.air_propagation) ||
-	    (priv->staging39_rxon.assoc_id != priv->active39_rxon.assoc_id))
-		return 1;
-
-	/* flags, filter_flags, ofdm_basic_rates, and cck_basic_rates can
-	 * be updated with the RXON_ASSOC command -- however only some
-	 * flag transitions are allowed using RXON_ASSOC */
-
-	/* Check if we are not switching bands */
-	if ((priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK) !=
-	    (priv->active39_rxon.flags & RXON_FLG_BAND_24G_MSK))
-		return 1;
-
-	/* Check if we are switching association toggle */
-	if ((priv->staging39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) !=
-		(priv->active39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK))
-		return 1;
-
-	return 0;
-}
-
 static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 {
 	int rc = 0;
@@ -404,8 +244,8 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 		.meta.flags = CMD_WANT_SKB,
 		.data = &rxon_assoc,
 	};
-	const struct iwl3945_rxon_cmd *rxon1 = &priv->staging39_rxon;
-	const struct iwl3945_rxon_cmd *rxon2 = &priv->active39_rxon;
+	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
+	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
 
 	if ((rxon1->flags == rxon2->flags) &&
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
@@ -415,10 +255,10 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 		return 0;
 	}
 
-	rxon_assoc.flags = priv->staging39_rxon.flags;
-	rxon_assoc.filter_flags = priv->staging39_rxon.filter_flags;
-	rxon_assoc.ofdm_basic_rates = priv->staging39_rxon.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = priv->staging39_rxon.cck_basic_rates;
+	rxon_assoc.flags = priv->staging_rxon.flags;
+	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
+	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
 	rxon_assoc.reserved = 0;
 
 	rc = iwl_send_cmd_sync(priv, &cmd);
@@ -485,21 +325,22 @@ __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
 static int iwl3945_commit_rxon(struct iwl_priv *priv)
 {
 	/* cast away the const for active_rxon in this function */
-	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active39_rxon;
+	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
+	struct iwl3945_rxon_cmd *staging_rxon = (void *)&priv->staging_rxon;
 	int rc = 0;
 
 	if (!iwl_is_alive(priv))
 		return -1;
 
 	/* always get timestamp with Rx frame */
-	priv->staging39_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
+	staging_rxon->flags |= RXON_FLG_TSF2HOST_MSK;
 
 	/* select antenna */
-	priv->staging39_rxon.flags &=
+	staging_rxon->flags &=
 	    ~(RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_SEL_MSK);
-	priv->staging39_rxon.flags |= iwl3945_get_antenna_flags(priv);
+	staging_rxon->flags |= iwl3945_get_antenna_flags(priv);
 
-	rc = iwl3945_check_rxon_cmd(priv);
+	rc = iwl_check_rxon_cmd(priv);
 	if (rc) {
 		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
@@ -508,7 +349,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	/* If we don't need to send a full RXON, we can use
 	 * iwl3945_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
-	if (!iwl3945_full_rxon_required(priv)) {
+	if (!iwl_full_rxon_required(priv)) {
 		rc = iwl3945_send_rxon_assoc(priv);
 		if (rc) {
 			IWL_ERR(priv, "Error setting RXON_ASSOC "
@@ -516,7 +357,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 			return rc;
 		}
 
-		memcpy(active_rxon, &priv->staging39_rxon, sizeof(*active_rxon));
+		memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
 
 		return 0;
 	}
@@ -525,14 +366,20 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (iwl3945_is_associated(priv) &&
-	    (priv->staging39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK)) {
+	if (iwl_is_associated(priv) &&
+	    (staging_rxon->filter_flags & RXON_FILTER_ASSOC_MSK)) {
 		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
+		/*
+		 * reserved4 and 5 could have been filled by the iwlcore code.
+		 * Let's clear them before pushing to the 3945.
+		 */
+		active_rxon->reserved4 = 0;
+		active_rxon->reserved5 = 0;
 		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 				      sizeof(struct iwl3945_rxon_cmd),
-				      &priv->active39_rxon);
+				      &priv->active_rxon);
 
 		/* If the mask clearing failed then we set
 		 * active_rxon back to what it was previously */
@@ -548,20 +395,28 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		       "* with%s RXON_FILTER_ASSOC_MSK\n"
 		       "* channel = %d\n"
 		       "* bssid = %pM\n",
-		       ((priv->staging39_rxon.filter_flags &
+		       ((priv->staging_rxon.filter_flags &
 			 RXON_FILTER_ASSOC_MSK) ? "" : "out"),
-		       le16_to_cpu(priv->staging39_rxon.channel),
-		       priv->staging_rxon.bssid_addr);
+		       le16_to_cpu(staging_rxon->channel),
+		       staging_rxon->bssid_addr);
+
+	/*
+	 * reserved4 and 5 could have been filled by the iwlcore code.
+	 * Let's clear them before pushing to the 3945.
+	 */
+	staging_rxon->reserved4 = 0;
+	staging_rxon->reserved5 = 0;
 
 	/* Apply the new configuration */
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
-			      sizeof(struct iwl3945_rxon_cmd), &priv->staging39_rxon);
+			      sizeof(struct iwl3945_rxon_cmd),
+			      staging_rxon);
 	if (rc) {
 		IWL_ERR(priv, "Error setting new configuration (%d).\n", rc);
 		return rc;
 	}
 
-	memcpy(active_rxon, &priv->staging39_rxon, sizeof(*active_rxon));
+	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
 
 	iwl3945_clear_stations_table(priv);
 
@@ -582,9 +437,10 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
-	if (iwl3945_is_associated(priv) &&
+	if (iwl_is_associated(priv) &&
 	    (priv->iw_mode == NL80211_IFTYPE_STATION))
-		if (iwl3945_add_station(priv, priv->active39_rxon.bssid_addr, 1, 0)
+		if (iwl3945_add_station(priv, priv->active_rxon.bssid_addr,
+					1, 0)
 		    == IWL_INVALID_STATION) {
 			IWL_ERR(priv, "Error adding AP address for transmit\n");
 			return -EIO;
@@ -710,7 +566,7 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 				int left)
 {
 
-	if (!iwl3945_is_associated(priv) || !priv->ibss_beacon ||
+	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
 	    ((priv->iw_mode != NL80211_IFTYPE_ADHOC) &&
 	     (priv->iw_mode != NL80211_IFTYPE_AP)))
 		return 0;
@@ -723,30 +579,6 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
-static u8 iwl3945_rate_get_lowest_plcp(struct iwl_priv *priv)
-{
-	u8 i;
-	int rate_mask;
-
-	/* Set rate mask*/
-	if (priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK)
-		rate_mask = priv->active_rate_basic & IWL_CCK_RATES_MASK;
-	else
-		rate_mask = priv->active_rate_basic & IWL_OFDM_RATES_MASK;
-
-	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
-	     i = iwl3945_rates[i].next_ieee) {
-		if (rate_mask & (1 << i))
-			return iwl3945_rates[i].plcp;
-	}
-
-	/* No valid rate was found. Assign the lowest one */
-	if (priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK)
-		return IWL_RATE_1M_PLCP;
-	else
-		return IWL_RATE_6M_PLCP;
-}
-
 static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl3945_frame *frame;
@@ -762,7 +594,7 @@ static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 		return -ENOMEM;
 	}
 
-	rate = iwl3945_rate_get_lowest_plcp(priv);
+	rate = iwl_rate_get_lowest_plcp(priv);
 
 	frame_size = iwl3945_hw_get_beacon_cmd(priv, frame, rate);
 
@@ -815,7 +647,7 @@ static void iwl3945_activate_qos(struct iwl_priv *priv, u8 force)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (force || iwl3945_is_associated(priv)) {
+	if (force || iwl_is_associated(priv)) {
 		IWL_DEBUG_QOS("send QoS cmd with QoS active %d \n",
 			      priv->qos_data.qos_active);
 
@@ -1082,115 +914,6 @@ static int iwl3945_scan_initiate(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl3945_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
-{
-	struct iwl3945_rxon_cmd *rxon = &priv->staging39_rxon;
-
-	if (hw_decrypt)
-		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
-	else
-		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
-
-	return 0;
-}
-
-static void iwl3945_set_flags_for_phymode(struct iwl_priv *priv,
-					  enum ieee80211_band band)
-{
-	if (band == IEEE80211_BAND_5GHZ) {
-		priv->staging39_rxon.flags &=
-		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
-		      | RXON_FLG_CCK_MSK);
-		priv->staging39_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
-	} else {
-		/* Copied from iwl3945_bg_post_associate() */
-		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
-			priv->staging39_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
-		else
-			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
-			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
-		priv->staging39_rxon.flags |= RXON_FLG_BAND_24G_MSK;
-		priv->staging39_rxon.flags |= RXON_FLG_AUTO_DETECT_MSK;
-		priv->staging39_rxon.flags &= ~RXON_FLG_CCK_MSK;
-	}
-}
-
-/*
- * initialize rxon structure with default values from eeprom
- */
-static void iwl3945_connection_init_rx_config(struct iwl_priv *priv,
-					      int mode)
-{
-	const struct iwl_channel_info *ch_info;
-
-	memset(&priv->staging39_rxon, 0, sizeof(priv->staging39_rxon));
-
-	switch (mode) {
-	case NL80211_IFTYPE_AP:
-		priv->staging39_rxon.dev_type = RXON_DEV_TYPE_AP;
-		break;
-
-	case NL80211_IFTYPE_STATION:
-		priv->staging39_rxon.dev_type = RXON_DEV_TYPE_ESS;
-		priv->staging39_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
-
-	case NL80211_IFTYPE_ADHOC:
-		priv->staging39_rxon.dev_type = RXON_DEV_TYPE_IBSS;
-		priv->staging39_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
-		priv->staging39_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
-						  RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
-
-	case NL80211_IFTYPE_MONITOR:
-		priv->staging39_rxon.dev_type = RXON_DEV_TYPE_SNIFFER;
-		priv->staging39_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
-		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
-	default:
-		IWL_ERR(priv, "Unsupported interface type %d\n", mode);
-		break;
-	}
-
-#if 0
-	/* TODO:  Figure out when short_preamble would be set and cache from
-	 * that */
-	if (!hw_to_local(priv->hw)->short_preamble)
-		priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
-	else
-		priv->staging39_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
-#endif
-
-	ch_info = iwl_get_channel_info(priv, priv->band,
-				       le16_to_cpu(priv->active39_rxon.channel));
-
-	if (!ch_info)
-		ch_info = &priv->channel_info[0];
-
-	/*
-	 * in some case A channels are all non IBSS
-	 * in this case force B/G channel
-	 */
-	if ((mode == NL80211_IFTYPE_ADHOC) && !(is_channel_ibss(ch_info)))
-		ch_info = &priv->channel_info[0];
-
-	priv->staging39_rxon.channel = cpu_to_le16(ch_info->channel);
-	if (is_channel_a_band(ch_info))
-		priv->band = IEEE80211_BAND_5GHZ;
-	else
-		priv->band = IEEE80211_BAND_2GHZ;
-
-	iwl3945_set_flags_for_phymode(priv, priv->band);
-
-	priv->staging39_rxon.ofdm_basic_rates =
-	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-	priv->staging39_rxon.cck_basic_rates =
-	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-}
-
 static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 {
 	if (mode == NL80211_IFTYPE_ADHOC) {
@@ -1198,17 +921,16 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 
 		ch_info = iwl_get_channel_info(priv,
 			priv->band,
-			le16_to_cpu(priv->staging39_rxon.channel));
+			le16_to_cpu(priv->staging_rxon.channel));
 
 		if (!ch_info || !is_channel_ibss(ch_info)) {
 			IWL_ERR(priv, "channel %d not IBSS channel\n",
-				  le16_to_cpu(priv->staging39_rxon.channel));
+				  le16_to_cpu(priv->staging_rxon.channel));
 			return -EINVAL;
 		}
 	}
 
-	iwl3945_connection_init_rx_config(priv, mode);
-	memcpy(priv->staging39_rxon.node_addr, priv->mac_addr, ETH_ALEN);
+	iwl_connection_init_rx_config(priv, mode);
 
 	iwl3945_clear_stations_table(priv);
 
@@ -1455,9 +1177,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* drop all data frame if we are not associated */
 	if (ieee80211_is_data(fc) &&
 	    (priv->iw_mode != NL80211_IFTYPE_MONITOR) && /* packet injection */
-	    (!iwl3945_is_associated(priv) ||
+	    (!iwl_is_associated(priv) ||
 	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id))) {
-		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
+		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
 		goto drop_unlock;
 	}
 
@@ -1622,60 +1344,6 @@ drop:
 	return -1;
 }
 
-static void iwl3945_set_rate(struct iwl_priv *priv)
-{
-	const struct ieee80211_supported_band *sband = NULL;
-	struct ieee80211_rate *rate;
-	int i;
-
-	sband = iwl_get_hw_mode(priv, priv->band);
-	if (!sband) {
-		IWL_ERR(priv, "Failed to set rate: unable to get hw mode\n");
-		return;
-	}
-
-	priv->active_rate = 0;
-	priv->active_rate_basic = 0;
-
-	IWL_DEBUG_RATE("Setting rates for %s GHz\n",
-		       sband->band == IEEE80211_BAND_2GHZ ? "2.4" : "5");
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		rate = &sband->bitrates[i];
-		if ((rate->hw_value < IWL_RATE_COUNT) &&
-		    !(rate->flags & IEEE80211_CHAN_DISABLED)) {
-			IWL_DEBUG_RATE("Adding rate index %d (plcp %d)\n",
-				       rate->hw_value, iwl3945_rates[rate->hw_value].plcp);
-			priv->active_rate |= (1 << rate->hw_value);
-		}
-	}
-
-	IWL_DEBUG_RATE("Set active_rate = %0x, active_rate_basic = %0x\n",
-		       priv->active_rate, priv->active_rate_basic);
-
-	/*
-	 * If a basic rate is configured, then use it (adding IWL_RATE_1M_MASK)
-	 * otherwise set it to the default of all CCK rates and 6, 12, 24 for
-	 * OFDM
-	 */
-	if (priv->active_rate_basic & IWL_CCK_BASIC_RATES_MASK)
-		priv->staging39_rxon.cck_basic_rates =
-		    ((priv->active_rate_basic &
-		      IWL_CCK_RATES_MASK) >> IWL_FIRST_CCK_RATE) & 0xF;
-	else
-		priv->staging39_rxon.cck_basic_rates =
-		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-
-	if (priv->active_rate_basic & IWL_OFDM_BASIC_RATES_MASK)
-		priv->staging39_rxon.ofdm_basic_rates =
-		    ((priv->active_rate_basic &
-		      (IWL_OFDM_BASIC_RATES_MASK | IWL_RATE_6M_MASK)) >>
-		      IWL_FIRST_OFDM_RATE) & 0xFF;
-	else
-		priv->staging39_rxon.ofdm_basic_rates =
-		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-}
-
 static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 {
 	unsigned long flags;
@@ -1726,38 +1394,6 @@ static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	return;
 }
 
-void iwl3945_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
-			    u32 decrypt_res, struct ieee80211_rx_status *stats)
-{
-	u16 fc =
-	    le16_to_cpu(((struct ieee80211_hdr *)skb->data)->frame_control);
-
-	if (priv->active39_rxon.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
-		return;
-
-	if (!(fc & IEEE80211_FCTL_PROTECTED))
-		return;
-
-	IWL_DEBUG_RX("decrypt_res:0x%x\n", decrypt_res);
-	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
-	case RX_RES_STATUS_SEC_TYPE_TKIP:
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_BAD_ICV_MIC)
-			stats->flag |= RX_FLAG_MMIC_ERROR;
-	case RX_RES_STATUS_SEC_TYPE_WEP:
-	case RX_RES_STATUS_SEC_TYPE_CCMP:
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_DECRYPT_OK) {
-			IWL_DEBUG_RX("hw decrypt successfully!!!\n");
-			stats->flag |= RX_FLAG_DECRYPTED;
-		}
-		break;
-
-	default:
-		break;
-	}
-}
-
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
@@ -1827,7 +1463,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	int spectrum_resp_status;
 	int duration = le16_to_cpu(params->duration);
 
-	if (iwl3945_is_associated(priv))
+	if (iwl_is_associated(priv))
 		add_time =
 		    iwl3945_usecs_to_beacons(
 			le64_to_cpu(params->start_time) - priv->last_tsf,
@@ -1842,7 +1478,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	cmd.len = sizeof(spectrum);
 	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
 
-	if (iwl3945_is_associated(priv))
+	if (iwl_is_associated(priv))
 		spectrum.start_time =
 		    iwl3945_add_beacon_time(priv->last_beacon_time,
 				add_time,
@@ -1853,7 +1489,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	spectrum.channels[0].duration = cpu_to_le32(duration * TIME_UNIT);
 	spectrum.channels[0].channel = params->channel;
 	spectrum.channels[0].type = type;
-	if (priv->active39_rxon.flags & RXON_FLG_BAND_24G_MSK)
+	if (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK)
 		spectrum.flags |= RXON_FLG_BAND_24G_MSK |
 		    RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK;
 
@@ -1951,19 +1587,6 @@ static void iwl3945_rx_reply_error(struct iwl_priv *priv,
 		le32_to_cpu(pkt->u.err_resp.error_info));
 }
 
-#define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
-
-static void iwl3945_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_rxon_cmd *rxon = (void *)&priv->active39_rxon;
-	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
-	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
-		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
-	rxon->channel = csa->channel;
-	priv->staging39_rxon.channel = csa->channel;
-}
-
 static void iwl3945_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
@@ -2224,7 +1847,7 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_ALIVE] = iwl3945_rx_reply_alive;
 	priv->rx_handlers[REPLY_ADD_STA] = iwl3945_rx_reply_add_sta;
 	priv->rx_handlers[REPLY_ERROR] = iwl3945_rx_reply_error;
-	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl3945_rx_csa;
+	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
 	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
 	    iwl3945_rx_spectrum_measure_notif;
 	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl3945_rx_pm_sleep_notif;
@@ -2728,26 +2351,6 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	iwl3945_rx_queue_restock(priv);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static void iwl3945_print_rx_config_cmd(struct iwl_priv *priv,
-					struct iwl3945_rxon_cmd *rxon)
-{
-	IWL_DEBUG_RADIO("RX CONFIG:\n");
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
-	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
-	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
-	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
-			le32_to_cpu(rxon->filter_flags));
-	IWL_DEBUG_RADIO("u8 dev_type: 0x%x\n", rxon->dev_type);
-	IWL_DEBUG_RADIO("u8 ofdm_basic_rates: 0x%02x\n",
-			rxon->ofdm_basic_rates);
-	IWL_DEBUG_RADIO("u8 cck_basic_rates: 0x%02x\n", rxon->cck_basic_rates);
-	IWL_DEBUG_RADIO("u8[6] node_addr: %pM\n", rxon->node_addr);
-	IWL_DEBUG_RADIO("u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
-	IWL_DEBUG_RADIO("u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
-}
-#endif
-
 static void iwl3945_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR("Enabling interrupts\n");
@@ -2957,58 +2560,19 @@ static void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 }
 
-/**
- * iwl3945_irq_handle_error - called for HW or SW error interrupt from card
- */
-static void iwl3945_irq_handle_error(struct iwl_priv *priv)
-{
-	/* Set the FW error flag -- cleared on iwl3945_down */
-	set_bit(STATUS_FW_ERROR, &priv->status);
-
-	/* Cancel currently queued command. */
-	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (priv->debug_level & IWL_DL_FW_ERRORS) {
-		iwl3945_dump_nic_error_log(priv);
-		iwl3945_dump_nic_event_log(priv);
-		iwl3945_print_rx_config_cmd(priv, &priv->staging39_rxon);
-	}
-#endif
-
-	wake_up_interruptible(&priv->wait_command_queue);
-
-	/* Keep the restart process from trying to send host
-	 * commands by clearing the INIT status bit */
-	clear_bit(STATUS_READY, &priv->status);
-
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG(IWL_DL_INFO | IWL_DL_FW_ERRORS,
-			  "Restarting adapter due to uCode error.\n");
-
-		if (iwl3945_is_associated(priv)) {
-			memcpy(&priv->recovery39_rxon, &priv->active39_rxon,
-			       sizeof(priv->recovery39_rxon));
-			priv->error_recovering = 1;
-		}
-		if (priv->cfg->mod_params->restart_fw)
-			queue_work(priv->workqueue, &priv->restart);
-	}
-}
-
 static void iwl3945_error_recovery(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
-	memcpy(&priv->staging39_rxon, &priv->recovery39_rxon,
-	       sizeof(priv->staging39_rxon));
-	priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	memcpy(&priv->staging_rxon, &priv->recovery_rxon,
+	       sizeof(priv->staging_rxon));
+	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl3945_commit_rxon(priv);
 
 	iwl3945_add_station(priv, priv->bssid, 1, 0);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->assoc_id = le16_to_cpu(priv->staging39_rxon.assoc_id);
+	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
 	priv->error_recovering = 0;
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
@@ -3061,7 +2625,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		/* Tell the device to stop sending interrupts */
 		iwl3945_disable_interrupts(priv);
 
-		iwl3945_irq_handle_error(priv);
+		iwl_irq_handle_error(priv);
 
 		handled |= CSR_INT_BIT_HW_ERR;
 
@@ -3089,7 +2653,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_SW_ERR) {
 		IWL_ERR(priv, "Microcode SW error detected. "
 			"Restarting 0x%X.\n", inta);
-		iwl3945_irq_handle_error(priv);
+		iwl_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
 
@@ -3893,17 +3457,16 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	iwl3945_send_power_mode(priv, IWL_POWER_LEVEL(priv->power_mode));
 
-	if (iwl3945_is_associated(priv)) {
+	if (iwl_is_associated(priv)) {
 		struct iwl3945_rxon_cmd *active_rxon =
-				(struct iwl3945_rxon_cmd *)(&priv->active39_rxon);
+				(struct iwl3945_rxon_cmd *)(&priv->active_rxon);
 
-		memcpy(&priv->staging39_rxon, &priv->active39_rxon,
-		       sizeof(priv->staging39_rxon));
+		memcpy(&priv->staging_rxon, &priv->active_rxon,
+		       sizeof(priv->staging_rxon));
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		iwl3945_connection_init_rx_config(priv, priv->iw_mode);
-		memcpy(priv->staging39_rxon.node_addr, priv->mac_addr, ETH_ALEN);
+		iwl_connection_init_rx_config(priv, priv->iw_mode);
 	}
 
 	/* Configure Bluetooth device coexistence support */
@@ -4278,7 +3841,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
-	if (iwl3945_is_associated(priv)) {
+	if (iwl_is_associated(priv)) {
 		u16 interval = 0;
 		u32 extra;
 		u32 suspend_time = 100;
@@ -4449,7 +4012,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 
 
 	IWL_DEBUG_ASSOC("Associated as %d to: %pM\n",
-			priv->assoc_id, priv->active39_rxon.bssid_addr);
+			priv->assoc_id, priv->active_rxon.bssid_addr);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -4461,7 +4024,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
-	priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl3945_commit_rxon(priv);
 
 	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
@@ -4472,26 +4035,26 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
-	priv->staging39_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
+	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	priv->staging39_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
+	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
 	IWL_DEBUG_ASSOC("assoc id %d beacon interval %d\n",
 			priv->assoc_id, priv->beacon_int);
 
 	if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
-		priv->staging39_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-	if (priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK) {
+	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
 		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
-			priv->staging39_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
-			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 	}
 
@@ -4547,7 +4110,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	memset(&priv->staging39_rxon, 0, sizeof(struct iwl3945_rxon_cmd));
+	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
 	 * ucode filename and max sizes are card-specific. */
 
@@ -4732,14 +4295,14 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 	}
 
-	iwl3945_set_rxon_channel(priv, conf->channel->band, conf->channel->hw_value);
+	iwl_set_rxon_channel(priv, conf->channel);
 
-	iwl3945_set_flags_for_phymode(priv, conf->channel->band);
+	iwl_set_flags_for_band(priv, conf->channel->band);
 
 	/* The list of supported rates and rate mask can be different
 	 * for each phymode; since the phymode may have changed, reset
 	 * the rate mask to what mac80211 lists */
-	iwl3945_set_rate(priv);
+	iwl_set_rate(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -4763,10 +4326,10 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 	}
 
-	iwl3945_set_rate(priv);
+	iwl_set_rate(priv);
 
-	if (memcmp(&priv->active39_rxon,
-		   &priv->staging39_rxon, sizeof(priv->staging39_rxon)))
+	if (memcmp(&priv->active_rxon,
+		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
 		iwl3945_commit_rxon(priv);
 	else
 		IWL_DEBUG_INFO("No re-sending same RXON configuration.\n");
@@ -4787,10 +4350,10 @@ static void iwl3945_config_ap(struct iwl_priv *priv)
 		return;
 
 	/* The following should be done only at AP bring up */
-	if (!(iwl3945_is_associated(priv))) {
+	if (!(iwl_is_associated(priv))) {
 
 		/* RXON - unassoc (to set timing command) */
-		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 
 		/* RXON Timing */
@@ -4804,29 +4367,29 @@ static void iwl3945_config_ap(struct iwl_priv *priv)
 					"Attempting to continue.\n");
 
 		/* FIXME: what should be the assoc_id for AP? */
-		priv->staging39_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
+		priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
-			priv->staging39_rxon.flags |=
+			priv->staging_rxon.flags |=
 				RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			priv->staging39_rxon.flags &=
+			priv->staging_rxon.flags &=
 				~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-		if (priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK) {
+		if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
 			if (priv->assoc_capability &
 				WLAN_CAPABILITY_SHORT_SLOT_TIME)
-				priv->staging39_rxon.flags |=
+				priv->staging_rxon.flags |=
 					RXON_FLG_SHORT_SLOT_MSK;
 			else
-				priv->staging39_rxon.flags &=
+				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 
 			if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
-				priv->staging39_rxon.flags &=
+				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
 		/* restore RXON assoc */
-		priv->staging39_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 		iwl3945_add_station(priv, iwl_bcast_addr, 0, 0);
 	}
@@ -4907,7 +4470,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 			mutex_unlock(&priv->mutex);
 			return -EAGAIN;
 		}
-		memcpy(priv->staging39_rxon.bssid_addr, conf->bssid, ETH_ALEN);
+		memcpy(priv->staging_rxon.bssid_addr, conf->bssid, ETH_ALEN);
 
 		/* TODO: Audit driver for usage of these members and see
 		 * if mac80211 deprecates them (priv->bssid looks like it
@@ -4921,12 +4484,12 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 			rc = iwl3945_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
 				iwl3945_add_station(priv,
-					priv->active39_rxon.bssid_addr, 1, 0);
+					priv->active_rxon.bssid_addr, 1, 0);
 		}
 
 	} else {
 		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
 
@@ -4937,52 +4500,6 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl3945_configure_filter(struct ieee80211_hw *hw,
-				 unsigned int changed_flags,
-				 unsigned int *total_flags,
-				 int mc_count, struct dev_addr_list *mc_list)
-{
-	struct iwl_priv *priv = hw->priv;
-	__le32 *filter_flags = &priv->staging39_rxon.filter_flags;
-
-	IWL_DEBUG_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
-			changed_flags, *total_flags);
-
-	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
-		if (*total_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS))
-			*filter_flags |= RXON_FILTER_PROMISC_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_PROMISC_MSK;
-	}
-	if (changed_flags & FIF_ALLMULTI) {
-		if (*total_flags & FIF_ALLMULTI)
-			*filter_flags |= RXON_FILTER_ACCEPT_GRP_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_ACCEPT_GRP_MSK;
-	}
-	if (changed_flags & FIF_CONTROL) {
-		if (*total_flags & FIF_CONTROL)
-			*filter_flags |= RXON_FILTER_CTL2HOST_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_CTL2HOST_MSK;
-	}
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			*filter_flags |= RXON_FILTER_BCON_AWARE_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_BCON_AWARE_MSK;
-	}
-
-	/* We avoid iwl_commit_rxon here to commit the new filter flags
-	 * since mac80211 will call ieee80211_hw_config immediately.
-	 * (mc_list is not supported at this time). Otherwise, we need to
-	 * queue a background iwl_commit_rxon work.
-	 */
-
-	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
-			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
-}
-
 static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_if_init_conf *conf)
 {
@@ -4994,7 +4511,7 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 
 	if (iwl_is_ready_rf(priv)) {
 		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
 	if (priv->vif == conf->vif) {
@@ -5021,17 +4538,18 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 		IWL_DEBUG_MAC80211("ERP_PREAMBLE %d\n",
 				   bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
-			priv->staging39_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+			priv->staging_rxon.flags &=
+				~RXON_FLG_SHORT_PREAMBLE_MSK;
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
 		IWL_DEBUG_MAC80211("ERP_CTS %d\n", bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
-			priv->staging39_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
+			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
-			priv->staging39_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
@@ -5055,7 +4573,7 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 			priv->assoc_id = 0;
 			IWL_DEBUG_MAC80211("DISASSOC %d\n", bss_conf->assoc);
 		}
-	} else if (changes && iwl3945_is_associated(priv) && priv->assoc_id) {
+	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
 			IWL_DEBUG_MAC80211("Associated Changes %d\n", changes);
 			iwl3945_send_rxon_assoc(priv);
 	}
@@ -5148,7 +4666,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case  SET_KEY:
 		ret = iwl3945_update_sta_key_info(priv, key, sta_id);
 		if (!ret) {
-			iwl3945_set_rxon_hwcrypto(priv, 1);
+			iwl_set_rxon_hwcrypto(priv, 1);
 			iwl3945_commit_rxon(priv);
 			key->hw_key_idx = sta_id;
 			IWL_DEBUG_MAC80211("set_key success, using hwcrypto\n");
@@ -5158,7 +4676,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case DISABLE_KEY:
 		ret = iwl3945_clear_sta_key_info(priv, sta_id);
 		if (!ret) {
-			iwl3945_set_rxon_hwcrypto(priv, 0);
+			iwl_set_rxon_hwcrypto(priv, 0);
 			iwl3945_commit_rxon(priv);
 			IWL_DEBUG_MAC80211("disable hwcrypto key\n");
 		}
@@ -5210,7 +4728,7 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	mutex_lock(&priv->mutex);
 	if (priv->iw_mode == NL80211_IFTYPE_AP)
 		iwl3945_activate_qos(priv, 1);
-	else if (priv->assoc_id && iwl3945_is_associated(priv))
+	else if (priv->assoc_id && iwl_is_associated(priv))
 		iwl3945_activate_qos(priv, 0);
 
 	mutex_unlock(&priv->mutex);
@@ -5292,7 +4810,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	*/
 	if (priv->iw_mode != NL80211_IFTYPE_AP) {
 		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
 
@@ -5304,7 +4822,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 		return;
 	}
 
-	iwl3945_set_rate(priv);
+	iwl_set_rate(priv);
 
 	mutex_unlock(&priv->mutex);
 
@@ -5437,7 +4955,7 @@ static ssize_t show_flags(struct device *d,
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
-	return sprintf(buf, "0x%04X\n", priv->active39_rxon.flags);
+	return sprintf(buf, "0x%04X\n", priv->active_rxon.flags);
 }
 
 static ssize_t store_flags(struct device *d,
@@ -5448,14 +4966,14 @@ static ssize_t store_flags(struct device *d,
 	u32 flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
-	if (le32_to_cpu(priv->staging39_rxon.flags) != flags) {
+	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
 		/* Cancel any currently running scans... */
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
 				       flags);
-			priv->staging39_rxon.flags = cpu_to_le32(flags);
+			priv->staging_rxon.flags = cpu_to_le32(flags);
 			iwl3945_commit_rxon(priv);
 		}
 	}
@@ -5472,7 +4990,7 @@ static ssize_t show_filter_flags(struct device *d,
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n",
-		le32_to_cpu(priv->active39_rxon.filter_flags));
+		le32_to_cpu(priv->active_rxon.filter_flags));
 }
 
 static ssize_t store_filter_flags(struct device *d,
@@ -5483,14 +5001,14 @@ static ssize_t store_filter_flags(struct device *d,
 	u32 filter_flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
-	if (le32_to_cpu(priv->staging39_rxon.filter_flags) != filter_flags) {
+	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
-			priv->staging39_rxon.filter_flags =
+			priv->staging_rxon.filter_flags =
 				cpu_to_le32(filter_flags);
 			iwl3945_commit_rxon(priv);
 		}
@@ -5543,7 +5061,7 @@ static ssize_t store_measurement(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct ieee80211_measurement_params params = {
-		.channel = le16_to_cpu(priv->active39_rxon.channel),
+		.channel = le16_to_cpu(priv->active_rxon.channel),
 		.start_time = cpu_to_le64(priv->last_tsf),
 		.duration = cpu_to_le16(1),
 	};
@@ -5890,7 +5408,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.remove_interface = iwl3945_mac_remove_interface,
 	.config = iwl3945_mac_config,
 	.config_interface = iwl3945_mac_config_interface,
-	.configure_filter = iwl3945_configure_filter,
+	.configure_filter = iwl_configure_filter,
 	.set_key = iwl3945_mac_set_key,
 	.get_tx_stats = iwl3945_mac_get_tx_stats,
 	.conf_tx = iwl3945_mac_conf_tx,
@@ -6163,7 +5681,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_release_irq;
 	}
 
-	iwl3945_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
+	iwl_set_rxon_channel(priv,
+			     &priv->bands[IEEE80211_BAND_2GHZ].channels[5]);
 	iwl3945_setup_deferred_work(priv);
 	iwl3945_setup_rx_handlers(priv);
 
-- 
1.5.4.3

