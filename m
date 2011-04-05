Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab1DERBh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/25] iwlagn: remove rxb page bookkeeping
Date: Tue,  5 Apr 2011 09:42:10 -0700
Message-Id: <1302021732-21250-24-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We never use the value in alloc_rxb_page,
so there's no point in keeping it either.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    3 ---
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    1 -
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 9a3d69d..9e47be6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -912,7 +912,6 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
-		priv->alloc_rxb_page++;
 
 		spin_unlock_irqrestore(&rxq->lock, flags);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 460316b..22cac44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1190,7 +1190,6 @@ struct iwl_priv {
 	int frames_count;
 
 	enum ieee80211_band band;
-	int alloc_rxb_page;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb);
@@ -1609,12 +1608,10 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 static inline void __iwl_free_pages(struct iwl_priv *priv, struct page *page)
 {
 	__free_pages(page, priv->hw_params.rx_page_order);
-	priv->alloc_rxb_page--;
 }
 
 static inline void iwl_free_pages(struct iwl_priv *priv, unsigned long page)
 {
 	free_pages(page, priv->hw_params.rx_page_order);
-	priv->alloc_rxb_page--;
 }
 #endif				/* __iwl_dev_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b5124de..c421f56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -898,7 +898,6 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(priv->hw, skb);
-	priv->alloc_rxb_page--;
 	rxb->page = NULL;
 }
 
-- 
1.7.0.4

