Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22822 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbYA1MHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 07:07:41 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 09/12 v2] iwlwifi: A-MPDU Tx conform API to mac80211
Date: Mon, 28 Jan 2008 14:07:23 +0200
Message-Id: <12015220543992-git-send-email-ron.rindjunsky@intel.com> (sfid-20080128_120754_022567_E347DCEC)
In-Reply-To: <12015220461052-git-send-email-ron.rindjunsky@intel.com>
References: <12015220461052-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch alters the current API in order to fit the new
API mac80211 gives for A-MPDU Tx

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   77 ++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    4 --
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 --
 3 files changed, 47 insertions(+), 38 deletions(-)

Index: wl2_6_24_rc8_ev/drivers/net/wireless/iwlwifi/iwl-4965.c
===================================================================
--- wl2_6_24_rc8_ev.orig/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ wl2_6_24_rc8_ev/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4717,34 +4717,6 @@ static void iwl4965_sta_modify_del_ba_ti
 	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
-int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
-			     enum ieee80211_ampdu_mlme_action action,
-			     const u8 *addr, u16 tid, u16 *ssn)
-{
-	struct iwl4965_priv *priv = hw->priv;
-	int sta_id;
-	DECLARE_MAC_BUF(mac);
-
-	IWL_DEBUG_HT("A-MPDU action on da=%s tid=%d ",
-			print_mac(mac, addr), tid);
-	sta_id = iwl4965_hw_find_station(priv, addr);
-	switch (action) {
-	case IEEE80211_AMPDU_RX_START:
-		IWL_DEBUG_HT("start Rx\n");
-		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
-		break;
-	case IEEE80211_AMPDU_RX_STOP:
-		IWL_DEBUG_HT("stop Rx\n");
-		iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
-		break;
-	default:
-		IWL_DEBUG_HT("unknown\n");
-		return -EINVAL;
-		break;
-	}
-	return 0;
-}
-
 #ifdef CONFIG_IWL4965_HT_AGG
 
 static const u16 default_tid_to_tx_fifo[] = {
@@ -4835,8 +4807,7 @@ int iwl4965_mac_ht_tx_agg_start(struct i
 }
 
 
-int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da, u16 tid,
-			   int generator)
+int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da, u16 tid)
 {
 
 	struct iwl4965_priv *priv = hw->priv;
@@ -4878,6 +4849,52 @@ int iwl4965_mac_ht_tx_agg_stop(struct ie
 
 
 #endif /* CONFIG_IWL4965_HT_AGG */
+
+int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da, u16 tid,
+				u16 *start_seq_num)
+{
+	return 0;
+}
+
+int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da, u16 tid)
+{
+	return 0;
+}
+
+int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
+			     enum ieee80211_ampdu_mlme_action action,
+			     const u8 *addr, u16 tid, u16 *ssn)
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
+		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		IWL_DEBUG_HT("stop Rx\n");
+		iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		IWL_DEBUG_HT("start Tx\n");
+		return iwl4965_mac_ht_tx_agg_start(hw, addr, tid, ssn);
+	case IEEE80211_AMPDU_TX_STOP:
+		IWL_DEBUG_HT("stop Tx\n");
+		return iwl4965_mac_ht_tx_agg_stop(hw, addr, tid);
+	default:
+		IWL_DEBUG_HT("unknown\n");
+		return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
 #endif /* CONFIG_IWL4965_HT */
 
 /* Set up 4965-specific Rx frame reply handlers */
Index: wl2_6_24_rc8_ev/drivers/net/wireless/iwlwifi/iwl-4965.h
===================================================================
--- wl2_6_24_rc8_ev.orig/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ wl2_6_24_rc8_ev/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -779,10 +779,6 @@ extern int iwl4965_mac_ampdu_action(stru
 				    enum ieee80211_ampdu_mlme_action action,
 				    const u8 *addr, u16 tid, u16 *ssn);
 #ifdef CONFIG_IWL4965_HT_AGG
-extern int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
-				   u16 tid, u16 *start_seq_num);
-extern int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da,
-				  u16 tid, int generator);
 extern void iwl4965_turn_off_agg(struct iwl4965_priv *priv, u8 tid);
 extern void iwl4965_tl_get_stats(struct iwl4965_priv *priv,
 				struct ieee80211_hdr *hdr);
Index: wl2_6_24_rc8_ev/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- wl2_6_24_rc8_ev.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ wl2_6_24_rc8_ev/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -9012,10 +9012,6 @@ static struct ieee80211_ops iwl4965_hw_o
 #ifdef CONFIG_IWL4965_HT
 	.conf_ht = iwl4965_mac_conf_ht,
 	.ampdu_action = iwl4965_mac_ampdu_action,
-#ifdef CONFIG_IWL4965_HT_AGG
-	.ht_tx_agg_start = iwl4965_mac_ht_tx_agg_start,
-	.ht_tx_agg_stop = iwl4965_mac_ht_tx_agg_stop,
-#endif  /* CONFIG_IWL4965_HT_AGG */
 #endif  /* CONFIG_IWL4965_HT */
 	.hw_scan = iwl4965_mac_hw_scan
 };
