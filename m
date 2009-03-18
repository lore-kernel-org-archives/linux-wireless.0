Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZCREq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/13] iwlwifi: return 0 for AMPDU_TX/RX_STOP request if NIC is going down
Date: Tue, 17 Mar 2009 21:51:43 -0700
Message-Id: <1237351913-19202-4-git-send-email-reinette.chatre@intel.com> (sfid-20090318_060339_401419_BEE92C3F)
In-Reply-To: <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When receive IEEE80211_AMPDU_RX_STOP or IEEE80211_AMPDU_TX_STOP request
in iwl_mac_ampdu_action() from mac80211; check STATUS_EXIT_PENDING bit,
if NIC is on the way out, then return 0 back to mac80211, this can
prevent mac80211 report HW error incorrectly.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4d2ed52..c148285 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2683,6 +2683,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			     struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct iwl_priv *priv = hw->priv;
+	int ret;
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
@@ -2696,13 +2697,21 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 		return iwl_sta_rx_agg_start(priv, sta->addr, tid, *ssn);
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT(priv, "stop Rx\n");
-		return iwl_sta_rx_agg_stop(priv, sta->addr, tid);
+		ret = iwl_sta_rx_agg_stop(priv, sta->addr, tid);
+		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+			return 0;
+		else
+			return ret;
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		return iwl_tx_agg_start(priv, sta->addr, tid, ssn);
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
-		return iwl_tx_agg_stop(priv, sta->addr, tid);
+		ret = iwl_tx_agg_stop(priv, sta->addr, tid);
+		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+			return 0;
+		else
+			return ret;
 	default:
 		IWL_DEBUG_HT(priv, "unknown\n");
 		return -EINVAL;
-- 
1.5.6.3

