Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761931AbZLJWhW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/7 w-t and 2.6.33] iwlwifi: allocated rx page accounting cleanup
Date: Thu, 10 Dec 2009 14:37:21 -0800
Message-Id: <1260484647-5114-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
References: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

In iwlwifi, priv->alloc_rxb_page is used to keep track of the Rx
pages allocated by the driver. This cleans up the page free routines
by introducing __iwl_free_pages/iwl_free_pages so that the accounting
is more accurate and less error prone. This also fixes two instances where
the counter was not updated.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    8 ++------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 +++-------
 7 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7da1dab..4609323 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1835,8 +1835,7 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 		rc = -EIO;
 	}
 
-	priv->alloc_rxb_page--;
-	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
+	iwl_free_pages(priv, cmd.reply_page);
 
 	return rc;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2673e9a..e1032f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1353,4 +1353,15 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
+static inline void __iwl_free_pages(struct iwl_priv *priv, struct page *page)
+{
+	__free_pages(page, priv->hw_params.rx_page_order);
+	priv->alloc_rxb_page--;
+}
+
+static inline void iwl_free_pages(struct iwl_priv *priv, unsigned long page)
+{
+	free_pages(page, priv->hw_params.rx_page_order);
+	priv->alloc_rxb_page--;
+}
 #endif				/* __iwl_dev_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index a231659..30e9ea6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -234,7 +234,7 @@ cancel:
 	}
 fail:
 	if (cmd->reply_page) {
-		free_pages(cmd->reply_page, priv->hw_params.rx_page_order);
+		iwl_free_pages(priv, cmd->reply_page);
 		cmd->reply_page = 0;
 	}
 out:
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 6090bc1..f5c87e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -345,10 +345,8 @@ void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
 				PCI_DMA_FROMDEVICE);
-			__free_pages(rxq->pool[i].page,
-				     priv->hw_params.rx_page_order);
+			__iwl_free_pages(priv, rxq->pool[i].page);
 			rxq->pool[i].page = NULL;
-			priv->alloc_rxb_page--;
 		}
 	}
 
@@ -416,9 +414,7 @@ void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
 				PCI_DMA_FROMDEVICE);
-			priv->alloc_rxb_page--;
-			__free_pages(rxq->pool[i].page,
-				     priv->hw_params.rx_page_order);
+			__iwl_free_pages(priv, rxq->pool[i].page);
 			rxq->pool[i].page = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index a2b2b83..fa1c89b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -144,8 +144,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		clear_bit(STATUS_SCAN_HW, &priv->status);
 	}
 
-	priv->alloc_rxb_page--;
-	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
+	iwl_free_pages(priv, cmd.reply_page);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index cd6a690..cde09a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -164,9 +164,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 			break;
 		}
 	}
-
-	priv->alloc_rxb_page--;
-	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
+	iwl_free_pages(priv, cmd.reply_page);
 
 	return ret;
 }
@@ -391,9 +389,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 			break;
 		}
 	}
-
-	priv->alloc_rxb_page--;
-	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
+	iwl_free_pages(priv, cmd.reply_page);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2a28a1f..994db4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -812,7 +812,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 		break;
 	}
 
-	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
+	iwl_free_pages(priv, cmd.reply_page);
 
 	return rc;
 }
@@ -1198,9 +1198,7 @@ void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
 				PCI_DMA_FROMDEVICE);
-			priv->alloc_rxb_page--;
-			__free_pages(rxq->pool[i].page,
-				     priv->hw_params.rx_page_order);
+			__iwl_free_pages(priv, rxq->pool[i].page);
 			rxq->pool[i].page = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
@@ -1247,10 +1245,8 @@ static void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rx
 			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
 				PCI_DMA_FROMDEVICE);
-			__free_pages(rxq->pool[i].page,
-				     priv->hw_params.rx_page_order);
+			__iwl_free_pages(priv, rxq->pool[i].page);
 			rxq->pool[i].page = NULL;
-			priv->alloc_rxb_page--;
 		}
 	}
 
-- 
1.5.6.3

