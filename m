Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42954 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZKTUFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/19] iwlwifi: control led while update tx/rx bytes counts
Date: Fri, 20 Nov 2009 12:04:54 -0800
Message-Id: <1258747510-21233-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

LED blinking rate is based on tx/rx traffic, the most reasonable place
to do it is after update the traffic byte counts

This fixes the recent LED blinking breakage on 3945 introduced by "iwlwifi:
separate led function from statistic notification"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 --
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4da0d3b..9dda463 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1079,7 +1079,6 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 		iwl_rx_handle(priv);
 		priv->isr_stats.rx++;
-		iwl_leds_background(priv);
 		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 	}
 
@@ -1288,7 +1287,6 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 				    CSR_INT_PERIODIC_ENA);
 
 		priv->isr_stats.rx++;
-		iwl_leds_background(priv);
 	}
 
 	/* This "Tx" DMA channel is used only for loading uCode */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3a4b855..de16485 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -3188,6 +3188,7 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 		stats->data_cnt++;
 		stats->data_bytes += len;
 	}
+	iwl_leds_background(priv);
 }
 EXPORT_SYMBOL(iwl_update_stats);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c68ca8f..f38e4cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -390,6 +390,7 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 		/* data */
 		stats->data_bytes += len;
 	}
+	iwl_leds_background(priv);
 }
 #endif
 /*****************************************************
-- 
1.5.6.3

