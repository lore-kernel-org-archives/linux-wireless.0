Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3300 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbXLTJmI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 04:42:08 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 8/8 v2] iwlwifi: A-MPDU Rx flow enabled
Date: Thu, 20 Dec 2007 11:39:12 +0200
Message-Id: <11981435621026-git-send-email-ron.rindjunsky@intel.com> (sfid-20071220_094215_118692_7C9120F0)
In-Reply-To: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables the A-MPDU Rx flow. it contains several
adjustments to new mac80211 A-MPDU Rx flow.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   66 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    7 +--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +-
 3 files changed, 36 insertions(+), 40 deletions(-)

Index: wl2_6_24_rc5/drivers/net/wireless/iwlwifi/iwl-4965.c
===================================================================
--- wl2_6_24_rc5.orig/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ wl2_6_24_rc5/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3868,9 +3868,7 @@ static void iwl4965_rx_reply_rx(struct i
 		.antenna = 0,
 		.rate = iwl4965_hw_get_rate(rx_start->rate_n_flags),
 		.flag = 0,
-#ifdef CONFIG_IWL4965_HT_AGG
-		.ordered = 0
-#endif /* CONFIG_IWL4965_HT_AGG */
+		.ordered = TXRX_CONTINUE
 	};
 	u8 network_packet;
 
@@ -4065,7 +4063,7 @@ static void iwl4965_rx_reply_rx(struct i
 		break;
 
 	case IEEE80211_FTYPE_CTL:
-#ifdef CONFIG_IWL4965_HT_AGG
+#ifdef CONFIG_IWL4965_HT
 		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_BACK_REQ:
 			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
@@ -4076,7 +4074,6 @@ static void iwl4965_rx_reply_rx(struct i
 			break;
 		}
 #endif
-
 		break;
 
 	case IEEE80211_FTYPE_DATA: {
@@ -4663,8 +4660,6 @@ void iwl4965_set_ht_add_station(struct i
 	return;
 }
 
-#ifdef CONFIG_IWL4965_HT_AGG
-
 static void iwl4965_sta_modify_add_ba_tid(struct iwl4965_priv *priv,
 					  int sta_id, int tid, u16 ssn)
 {
@@ -4696,6 +4691,36 @@ static void iwl4965_sta_modify_del_ba_ti
 	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
+int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
+			     enum ieee80211_ampdu_mlme_action action,
+			     const u8 *addr, u16 tid, u16 ssn)
+{
+	struct iwl4965_priv *priv = hw->priv;
+	int sta_id;
+	DECLARE_MAC_BUF(mac);
+
+	IWL_DEBUG_HT("A-MPDU action on da=%s tid=%d ",
+			print_mac(mac, addr), tid);
+	sta_id = iwl4965_hw_find_station(priv, addr);
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		IWL_DEBUG_HT("start Rx\n");
+		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, ssn);
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		IWL_DEBUG_HT("stop Rx\n");
+		iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
+		break;
+	default:
+		IWL_DEBUG_HT("unknown\n");
+		return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
+#ifdef CONFIG_IWL4965_HT_AGG
+
 static const u16 default_tid_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC1,
 	IWL_TX_FIFO_AC0,
@@ -4825,33 +4850,6 @@ int iwl4965_mac_ht_tx_agg_stop(struct ie
 	return 0;
 }
 
-int iwl4965_mac_ht_rx_agg_start(struct ieee80211_hw *hw, u8 *da,
-			    u16 tid, u16 start_seq_num)
-{
-	struct iwl4965_priv *priv = hw->priv;
-	int sta_id;
-	DECLARE_MAC_BUF(mac);
-
-	IWL_WARNING("iwl-AGG iwl4965_mac_ht_rx_agg_start on da=%s"
-		    " tid=%d\n", print_mac(mac, da), tid);
-	sta_id = iwl4965_hw_find_station(priv, da);
-	iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, start_seq_num);
-	return 0;
-}
-
-int iwl4965_mac_ht_rx_agg_stop(struct ieee80211_hw *hw, u8 *da,
-			   u16 tid, int generator)
-{
-	struct iwl4965_priv *priv = hw->priv;
-	int sta_id;
-	DECLARE_MAC_BUF(mac);
-
-	IWL_WARNING("iwl-AGG iwl4965_mac_ht_rx_agg_stop on da=%s tid=%d\n",
-		    print_mac(mac, da), tid);
-	sta_id = iwl4965_hw_find_station(priv, da);
-	iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
-	return 0;
-}
 
 #endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
Index: wl2_6_24_rc5/drivers/net/wireless/iwlwifi/iwl-4965.h
===================================================================
--- wl2_6_24_rc5.orig/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ wl2_6_24_rc5/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -802,13 +802,12 @@ extern void iwl4965_set_rxon_ht(struct i
 				struct iwl_ht_info *ht_info);
 extern void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
 				struct ieee80211_ht_info *sta_ht_inf);
+extern int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
+				    enum ieee80211_ampdu_mlme_action action,
+				    const u8 *addr, u16 tid, u16 ssn);
 #ifdef CONFIG_IWL4965_HT_AGG
 extern int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 				   u16 tid, u16 *start_seq_num);
-extern int iwl4965_mac_ht_rx_agg_start(struct ieee80211_hw *hw, u8 *da,
-				   u16 tid, u16 start_seq_num);
-extern int iwl4965_mac_ht_rx_agg_stop(struct ieee80211_hw *hw, u8 *da,
-				  u16 tid, int generator);
 extern int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da,
 				  u16 tid, int generator);
 extern void iwl4965_turn_off_agg(struct iwl4965_priv *priv, u8 tid);
Index: wl2_6_24_rc5/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- wl2_6_24_rc5.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ wl2_6_24_rc5/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -9054,11 +9054,10 @@ static struct ieee80211_ops iwl4965_hw_o
 	.erp_ie_changed = iwl4965_mac_erp_ie_changed,
 #ifdef CONFIG_IWL4965_HT
 	.conf_ht = iwl4965_mac_conf_ht,
+	.ampdu_action = iwl4965_mac_ampdu_action,
 #ifdef CONFIG_IWL4965_HT_AGG
 	.ht_tx_agg_start = iwl4965_mac_ht_tx_agg_start,
 	.ht_tx_agg_stop = iwl4965_mac_ht_tx_agg_stop,
-	.ht_rx_agg_start = iwl4965_mac_ht_rx_agg_start,
-	.ht_rx_agg_stop = iwl4965_mac_ht_rx_agg_stop,
 #endif  /* CONFIG_IWL4965_HT_AGG */
 #endif  /* CONFIG_IWL4965_HT */
 	.hw_scan = iwl4965_mac_hw_scan
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

