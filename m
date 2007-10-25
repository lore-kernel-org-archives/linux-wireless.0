Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbXJYJWl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:41 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/30] iwlwifi: remove cck_power_index_compensation
Date: Thu, 25 Oct 2007 17:15:31 +0800
Message-Id: <11933037663659-git-send-email-yi.zhu@intel.com> (sfid-20071025_102258_588426_B963B1B2)
In-Reply-To: <11933037641168-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

cck_power_index_compensation variable was never used

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-priv.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-priv.h b/drivers/net/wireless/iwlwifi/iwl-priv.h
index 6b490d0..f43679a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-priv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-priv.h
@@ -278,7 +278,6 @@ struct iwl_priv {
 #define IWL_DEFAULT_TX_POWER 0x0F
 	s8 user_txpower_limit;
 	s8 max_channel_txpower_limit;
-	u32 cck_power_index_compensation;
 
 #ifdef CONFIG_PM
 	u32 pm_state[16];
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 315f3ab..0b1d91e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8995,8 +8995,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->channel_width = IWL_CHANNEL_WIDTH_40MHZ;
 	priv->valid_antenna = 0x7;	/* assume all 3 connected */
 	priv->ps_mode = IWL_MIMO_PS_NONE;
-	priv->cck_power_index_compensation = iwl_read32(
-		priv, CSR_HW_REV_WA_REG);
 
 	iwl4965_set_rxon_chain(priv);
 
-- 
1.5.2
