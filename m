Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbYEECYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:33 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 24/25] iwlwifi: fix spinlock used before initialized
Date: Mon,  5 May 2008 10:22:51 +0800
Message-Id: <1209954172-3092-25-git-send-email-yi.zhu@intel.com> (sfid-20080505_044417_162310_8032C642)
In-Reply-To: <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

The patch fixes spinlock priv->lock (apm_ops.init) is used before it has
been initialized.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    3 ---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +--
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9801c31..554b0d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -489,10 +489,8 @@ static int iwl4965_disable_tx_fifo(struct iwl_priv *priv)
 
 static int iwl4965_apm_init(struct iwl_priv *priv)
 {
-	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&priv->lock, flags);
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
@@ -524,7 +522,6 @@ static int iwl4965_apm_init(struct iwl_priv *priv)
 
 	iwl_release_nic_access(priv);
 out:
-	spin_unlock_irqrestore(&priv->lock, flags);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2158881..49c8a4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -174,9 +174,8 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	int ret;
 
 	/* nic_init */
-	priv->cfg->ops->lib->apm_ops.init(priv);
-
 	spin_lock_irqsave(&priv->lock, flags);
+	priv->cfg->ops->lib->apm_ops.init(priv);
 	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
1.5.3.6

