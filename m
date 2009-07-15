Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbZGOAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/21] iwlwifi: remove rs_get_rate workaround
Date: Tue, 14 Jul 2009 20:13:55 -0400
Message-Id: <1247616853-11221-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the work around implemented for transmitting on
an unsupported band on iwlwifi. This was added via the patch:

8e1856e82cb8f541e925738bebfbc473420cda68:
iwlwifi: fix rs_get_rate WARN_ON()

Cc: Mohamed Abbas <mohamed.abbas@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   12 ++----------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   11 +----------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 5eb538d..b23fd53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -674,28 +674,20 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	unsigned long flags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	u16 fc;
-	u16 rate_mask = 0;
+	u16 rate_mask = sta ? sta->supp_rates[sband->band] : 0;
 	s8 max_rate_idx = -1;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	IWL_DEBUG_RATE(priv, "enter\n");
 
-	if (sta)
-		rate_mask = sta->supp_rates[sband->band];
-
 	/* Send management frames and NO_ACK data using lowest rate. */
 	fc = le16_to_cpu(hdr->frame_control);
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    info->flags & IEEE80211_TX_CTL_NO_ACK ||
 	    !sta || !priv_sta) {
 		IWL_DEBUG_RATE(priv, "leave: No STA priv data to update!\n");
-		if (!rate_mask)
-			info->control.rates[0].idx =
-					rate_lowest_index(sband, NULL);
-		else
-			info->control.rates[0].idx =
-					rate_lowest_index(sband, sta);
+		info->control.rates[0].idx = rate_lowest_index(sband, sta);
 		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 			info->control.rates[0].count = 1;
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index ff20e50..3fea027 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2466,7 +2466,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	int rate_idx;
-	u64 mask_bit = 0;
 
 	IWL_DEBUG_RATE_LIMIT(priv, "rate scale calculate new rate for skb\n");
 
@@ -2481,18 +2480,10 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 			lq_sta->max_rate_idx = -1;
 	}
 
-	if (sta)
-		mask_bit = sta->supp_rates[sband->band];
-
 	/* Send management frames and NO_ACK data using lowest rate. */
 	if (!ieee80211_is_data(hdr->frame_control) ||
 	    info->flags & IEEE80211_TX_CTL_NO_ACK || !sta || !lq_sta) {
-		if (!mask_bit)
-			info->control.rates[0].idx =
-					rate_lowest_index(sband, NULL);
-		else
-			info->control.rates[0].idx =
-					rate_lowest_index(sband, sta);
+		info->control.rates[0].idx = rate_lowest_index(sband, sta);
 		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 			info->control.rates[0].count = 1;
 		return;
-- 
1.6.0.6

