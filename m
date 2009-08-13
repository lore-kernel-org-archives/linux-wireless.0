Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3757 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392AbZHMUbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/13] iwlwifi: include HT configuration when adding stations through rs_rate_init
Date: Thu, 13 Aug 2009 13:30:52 -0700
Message-Id: <1250195462-15811-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Driver's first notification of a new station from mac80211 can be through rate
selection API.  This patch fixes a bug where, in this code path, the HT
capabilities of the new station were ignored.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 1bd7cd4..551c4ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2522,6 +2522,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	struct ieee80211_supported_band *sband = txrc->sband;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_conf *conf = &priv->hw->conf;
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = priv_sta;
@@ -2554,7 +2555,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n",
 				       hdr->addr1);
 			sta_id = iwl_add_station(priv, hdr->addr1,
-						false, CMD_ASYNC, NULL);
+						false, CMD_ASYNC, ht_cap);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq_sta->lq.sta_id = sta_id;
@@ -2623,6 +2624,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	int i, j;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_conf *conf = &priv->hw->conf;
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	u16 mask_bit = 0;
 	int count;
@@ -2651,7 +2653,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
 			sta_id = iwl_add_station(priv, sta->addr, false,
-						CMD_ASYNC, NULL);
+						CMD_ASYNC, ht_cap);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq_sta->lq.sta_id = sta_id;
@@ -2672,19 +2674,19 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
 	 * supp_rates[] does not; shift to convert format, force 9 MBits off.
 	 */
-	lq_sta->active_siso_rate = sta->ht_cap.mcs.rx_mask[0] << 1;
-	lq_sta->active_siso_rate |= sta->ht_cap.mcs.rx_mask[0] & 0x1;
+	lq_sta->active_siso_rate = ht_cap->mcs.rx_mask[0] << 1;
+	lq_sta->active_siso_rate |= ht_cap->mcs.rx_mask[0] & 0x1;
 	lq_sta->active_siso_rate &= ~((u16)0x2);
 	lq_sta->active_siso_rate <<= IWL_FIRST_OFDM_RATE;
 
 	/* Same here */
-	lq_sta->active_mimo2_rate = sta->ht_cap.mcs.rx_mask[1] << 1;
-	lq_sta->active_mimo2_rate |= sta->ht_cap.mcs.rx_mask[1] & 0x1;
+	lq_sta->active_mimo2_rate = ht_cap->mcs.rx_mask[1] << 1;
+	lq_sta->active_mimo2_rate |= ht_cap->mcs.rx_mask[1] & 0x1;
 	lq_sta->active_mimo2_rate &= ~((u16)0x2);
 	lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
 
-	lq_sta->active_mimo3_rate = sta->ht_cap.mcs.rx_mask[2] << 1;
-	lq_sta->active_mimo3_rate |= sta->ht_cap.mcs.rx_mask[2] & 0x1;
+	lq_sta->active_mimo3_rate = ht_cap->mcs.rx_mask[2] << 1;
+	lq_sta->active_mimo3_rate |= ht_cap->mcs.rx_mask[2] & 0x1;
 	lq_sta->active_mimo3_rate &= ~((u16)0x2);
 	lq_sta->active_mimo3_rate <<= IWL_FIRST_OFDM_RATE;
 
-- 
1.5.6.3

