Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741AbZDTVbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:06 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/11] iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode
Date: Mon, 20 Apr 2009 14:37:00 -0700
Message-Id: <1240263424-8495-8-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233348_080638_841D20FB)
In-Reply-To: <1240263424-8495-7-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-6-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This patch clean up the code for NL80211_IFTYPE_MONITOR mode,
priv->iw_mode is set in add_interface, but add_interface is never called
for monitor mode.
The only way mac80211 informs us about monitor mode is through
configuring filter; since iw_mode will never set to
NL80211_IFTYPE_MONITOR, modify and remove all the code refer to
NL80211_IFTYPE_MONITOR and replace with iwl_is_monitor_mode() function
call.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 --
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    7 -------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    5 -----
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 8 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2751736..fc52d32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2001,8 +2001,6 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 
 out:
 	priv->is_open = 1;
-	/* default to MONITOR mode */
-	priv->iw_mode = NL80211_IFTYPE_MONITOR;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c43c57d..bf7ad51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -904,10 +904,11 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
  * never called for monitor mode. The only way mac80211 informs us about
  * monitor mode is through configuring filters (call to configure_filter).
  */
-static bool iwl_is_monitor_mode(struct iwl_priv *priv)
+bool iwl_is_monitor_mode(struct iwl_priv *priv)
 {
 	return !!(priv->staging_rxon.filter_flags & RXON_FILTER_PROMISC_MSK);
 }
+EXPORT_SYMBOL(iwl_is_monitor_mode);
 
 /**
  * iwl_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
@@ -1071,11 +1072,6 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
 						  RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
-	case NL80211_IFTYPE_MONITOR:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_SNIFFER;
-		priv->staging_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
-		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
 	default:
 		IWL_ERR(priv, "Unsupported interface type %d\n", mode);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8ab60df..3bc2f6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -267,6 +267,7 @@ int iwl_setup_mac(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
 int iwl_init_drv(struct iwl_priv *priv);
 void iwl_uninit_drv(struct iwl_priv *priv);
+bool iwl_is_monitor_mode(struct iwl_priv *priv);
 void iwl_post_associate(struct iwl_priv *priv);
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8f65908..fae8426 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1102,13 +1102,6 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	if (rx_start->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
-	/* Take shortcut when only in monitor mode */
-	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
-		iwl_pass_packet_to_mac80211(priv, include_phy,
-						 rxb, &rx_status);
-		return;
-	}
-
 	network_packet = iwl_is_network_packet(priv, header);
 	if (network_packet) {
 		priv->last_rx_rssi = rx_status.signal;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 25311e1..799f5eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -747,7 +747,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 	scan->tx_cmd.len = cpu_to_le16(cmd_len);
 
-	if (priv->iw_mode == NL80211_IFTYPE_MONITOR)
+	if (iwl_is_monitor_mode(priv))
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
 	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index b8f18c6..17a4dd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1078,11 +1078,6 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_params.bcast_sta_id;
 
-	/* If we are in monitor mode, use BCAST. This is required for
-	 * packet injection. */
-	case NL80211_IFTYPE_MONITOR:
-		return priv->hw_params.bcast_sta_id;
-
 	default:
 		IWL_WARN(priv, "Unknown mode of operation: %d\n",
 			priv->iw_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index c734c5f..58cdd32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -728,7 +728,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* drop all data frame if we are not associated */
 	if (ieee80211_is_data(fc) &&
-	    (priv->iw_mode != NL80211_IFTYPE_MONITOR ||
+	    (!iwl_is_monitor_mode(priv) ||
 	    !(info->flags & IEEE80211_TX_CTL_INJECTED)) && /* packet injection */
 	    (!iwl_is_associated(priv) ||
 	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id) ||
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f4978bd..e22282e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -729,7 +729,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* drop all data frame if we are not associated */
 	if (ieee80211_is_data(fc) &&
-	    (priv->iw_mode != NL80211_IFTYPE_MONITOR) && /* packet injection */
+	    (!iwl_is_monitor_mode(priv)) && /* packet injection */
 	    (!iwl_is_associated(priv) ||
 	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id))) {
 		IWL_DEBUG_DROP(priv, "Dropping - !iwl_is_associated\n");
@@ -3113,7 +3113,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	/* select Rx antennas */
 	scan->flags |= iwl3945_get_antenna_flags(priv);
 
-	if (priv->iw_mode == NL80211_IFTYPE_MONITOR)
+	if (iwl_is_monitor_mode(priv))
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
 	scan->channel_count =
-- 
1.5.6.3

