Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233AbXHHHh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/28] iwlwifi: remove priv stuff zeroing in iwl_pci_probe
Date: Wed,  8 Aug 2007 15:33:27 +0800
Message-Id: <11865584503648-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584473732-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove priv stuff zeroing in iwl_pci_probe() since priv is already zeroed
by ieee80211_alloc_hw().

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index ca4edd2..e419391 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -9045,9 +9045,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	iwl_clear_stations_table(priv);
 
-	memset(&(priv->txq[0]), 0,
-	       sizeof(struct iwl_tx_queue) * IWL_MAX_NUM_QUEUES);
-	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
@@ -9138,7 +9135,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 #ifdef CONFIG_IWLWIFI_QOS
-	memset(&priv->qos_data, 0, sizeof(struct iwl_qos_info));
 	if (iwl_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 	priv->qos_data.qos_active = 0;
-- 
1.5.2
