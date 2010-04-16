Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab0DPVwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 20/21] iwlwifi: remove monitor check
Date: Fri, 16 Apr 2010 14:52:37 -0700
Message-Id: <1271454758-14351-21-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Off-channel reception is acceptable in monitor
mode, and checking for monitor mode this way is
not really correct anyway since it could be the
case while operating.

Now iwl_is_monitor_mode() is no longer used so
remove it completely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d282bef..7a82b1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -828,18 +828,6 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
 }
 
 /**
- * iwl_is_monitor_mode - Determine if interface in monitor mode
- *
- * priv->iw_mode is set in add_interface, but add_interface is
- * never called for monitor mode. The only way mac80211 informs us about
- * monitor mode is through configuring filters (call to configure_filter).
- */
-static bool iwl_is_monitor_mode(struct iwl_priv *priv)
-{
-	return !!(priv->staging_rxon.filter_flags & RXON_FILTER_PROMISC_MSK);
-}
-
-/**
  * iwl_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
  *
  * Selects how many and which Rx receivers/antennas/chains to use.
@@ -882,19 +870,6 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	rx_chain |= active_rx_cnt << RXON_RX_CHAIN_MIMO_CNT_POS;
 	rx_chain |= idle_rx_cnt  << RXON_RX_CHAIN_CNT_POS;
 
-	/* copied from 'iwl_bg_request_scan()' */
-	/* Force use of chains B and C (0x6) for Rx
-	 * Avoid A (0x1) for the device has off-channel reception on A-band.
-	 * MIMO is not used here, but value is required */
-	if (iwl_is_monitor_mode(priv) &&
-	    !(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) &&
-	    priv->cfg->off_channel_workaround) {
-		rx_chain = ANT_ABC << RXON_RX_CHAIN_VALID_POS;
-		rx_chain |= ANT_BC << RXON_RX_CHAIN_FORCE_SEL_POS;
-		rx_chain |= ANT_ABC << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
-		rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
-	}
-
 	priv->staging_rxon.rx_chain = cpu_to_le16(rx_chain);
 
 	if (!is_single && (active_rx_cnt >= IWL_NUM_RX_CHAINS_SINGLE) && is_cam)
-- 
1.6.3.3

