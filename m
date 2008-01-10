Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbYAJRGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 12:06:20 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 7/8] iwlwifi: A-MPDU Tx conform API to mac80211
Date: Thu, 10 Jan 2008 19:02:22 +0200
Message-Id: <11999845544142-git-send-email-ron.rindjunsky@intel.com> (sfid-20080110_170629_391695_71F5F907)
In-Reply-To: <1199984547375-git-send-email-ron.rindjunsky@intel.com>
References: <1199984547375-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch alters the current API in order to fit the new
API mac80211 gives for A-MPDU Tx

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   13 +++++++++----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    6 +-----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ----
 3 files changed, 10 insertions(+), 13 deletions(-)

Index: wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965.c
===================================================================
--- wl2_6_24_rc5_upstream.orig/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4721,7 +4721,7 @@ static void iwl4965_sta_modify_del_ba_ti
 
 int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 			     enum ieee80211_ampdu_mlme_action action,
-			     const u8 *addr, u16 tid, u16 ssn)
+			     u8 *addr, u16 tid, u16 *ssn)
 {
 	struct iwl4965_priv *priv = hw->priv;
 	int sta_id;
@@ -4733,12 +4733,18 @@ int iwl4965_mac_ampdu_action(struct ieee
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT("start Rx\n");
-		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, ssn);
+		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT("stop Rx\n");
 		iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
 		break;
+	case IEEE80211_AMPDU_TX_START:
+		IWL_DEBUG_HT("start Tx\n");
+		return iwl4965_mac_ht_tx_agg_start(hw, addr, tid, ssn);
+	case IEEE80211_AMPDU_TX_STOP:
+		IWL_DEBUG_HT("stop Tx\n");
+		return iwl4965_mac_ht_tx_agg_stop(hw, addr, tid);
 	default:
 		IWL_DEBUG_HT("unknown\n");
 		return -EINVAL;
@@ -4837,8 +4843,7 @@ int iwl4965_mac_ht_tx_agg_start(struct i
 }
 
 
-int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da, u16 tid,
-			   int generator)
+int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da, u16 tid)
 {
 
 	struct iwl4965_priv *priv = hw->priv;
Index: wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965.h
===================================================================
--- wl2_6_24_rc5_upstream.orig/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -778,12 +778,8 @@ extern void iwl4965_set_ht_add_station(s
 				struct ieee80211_ht_info *sta_ht_inf);
 extern int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    enum ieee80211_ampdu_mlme_action action,
-				    const u8 *addr, u16 tid, u16 ssn);
+				    u8 *addr, u16 tid, u16 *ssn);
 #ifdef CONFIG_IWL4965_HT_AGG
-extern int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
-				   u16 tid, u16 *start_seq_num);
-extern int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da,
-				  u16 tid, int generator);
 extern void iwl4965_turn_off_agg(struct iwl4965_priv *priv, u8 tid);
 extern void iwl4965_tl_get_stats(struct iwl4965_priv *priv,
 				struct ieee80211_hdr *hdr);
Index: wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- wl2_6_24_rc5_upstream.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8973,10 +8973,6 @@ static struct ieee80211_ops iwl4965_hw_o
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
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

