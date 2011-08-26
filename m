Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2067 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab1HZGxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 33/60] iwlagn: move iwl_free_pages to iwl-shared.h
Date: Thu, 25 Aug 2011 23:11:05 -0700
Message-Id: <1314339092-20797-34-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085440_580943_D46E0CCF)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This helper is used by the transport and the upper layer.
Kill __iwl_free_pages which was used in the transport only.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-sta.c           |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c         |    3 ++-
 6 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ab9816a..eac25c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1505,13 +1505,4 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
-static inline void __iwl_free_pages(struct iwl_priv *priv, struct page *page)
-{
-	__free_pages(page, hw_params(priv).rx_page_order);
-}
-
-static inline void iwl_free_pages(struct iwl_priv *priv, unsigned long page)
-{
-	free_pages(page, hw_params(priv).rx_page_order);
-}
 #endif				/* __iwl_dev_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 2bb94f7..fc5af34 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -91,7 +91,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		ret = -EIO;
 	}
 
-	iwl_free_pages(priv, cmd.reply_page);
+	iwl_free_pages(priv->shrd, cmd.reply_page);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index ff4c04f..1229eb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -229,6 +229,11 @@ static inline u32 iwl_get_debug_level(struct iwl_shared *shrd)
 }
 #endif
 
+static inline void iwl_free_pages(struct iwl_shared *shrd, unsigned long page)
+{
+	free_pages(page, shrd->hw_params.rx_page_order);
+}
+
 struct iwl_rx_mem_buffer {
 	dma_addr_t page_dma;
 	struct page *page;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 1154e48..26b2bd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -177,7 +177,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		pkt = (struct iwl_rx_packet *)cmd.reply_page;
 		ret = iwl_process_add_sta_resp(priv, sta, pkt, true);
 	}
-	iwl_free_pages(priv, cmd.reply_page);
+	iwl_free_pages(priv->shrd, cmd.reply_page);
 
 	return ret;
 }
@@ -455,7 +455,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 			break;
 		}
 	}
-	iwl_free_pages(priv, cmd.reply_page);
+	iwl_free_pages(priv->shrd, cmd.reply_page);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 6107e66..8ba9a46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -1023,7 +1023,7 @@ cancel:
 	}
 fail:
 	if (cmd->reply_page) {
-		iwl_free_pages(priv, cmd->reply_page);
+		iwl_free_pages(priv->shrd, cmd->reply_page);
 		cmd->reply_page = 0;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index b080e69..8956008 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -129,7 +129,8 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
 			dma_unmap_page(bus(trans)->dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
-			__iwl_free_pages(priv(trans), rxq->pool[i].page);
+			__free_pages(rxq->pool[i].page,
+				     hw_params(trans).rx_page_order);
 			rxq->pool[i].page = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-- 
1.7.0.4

