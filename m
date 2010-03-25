Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab0CYUpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:45:04 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 21/22] iwlwifi: change spin_lock to spin_lock_irqsave
Date: Thu, 25 Mar 2010 13:44:49 -0700
Message-Id: <1269549890-19195-22-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Use spin_lock_irqsave() in interrupt handler to disable interrupts locally
and provide the spinlock on SMP. This covers both interrupt and SMP
concurrency.

With this changes, also fix the sparse warning issues.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |   14 ++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c    |    7 ++++---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index 4c5395e..a273e37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -141,13 +141,14 @@ static irqreturn_t iwl_isr(int irq, void *data)
 {
 	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
+	unsigned long flags;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	u32 inta_fh;
 #endif
 	if (!priv)
 		return IRQ_NONE;
 
-	spin_lock(&priv->lock);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
@@ -190,7 +191,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		iwl_enable_interrupts(priv);
 
  unplugged:
-	spin_unlock(&priv->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_HANDLED;
 
  none:
@@ -199,7 +200,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
 		iwl_enable_interrupts(priv);
 
-	spin_unlock(&priv->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_NONE;
 }
 
@@ -216,6 +217,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
 	u32 val = 0;
+	unsigned long flags;
 
 	if (!priv)
 		return IRQ_NONE;
@@ -226,7 +228,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	if (!priv->_agn.use_ict)
 		return iwl_isr(irq, data);
 
-	spin_lock(&priv->lock);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 * back-to-back ISRs and sporadic interrupts from our NIC.
@@ -290,7 +292,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 		iwl_enable_interrupts(priv);
 	}
 
-	spin_unlock(&priv->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_HANDLED;
 
  none:
@@ -300,6 +302,6 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
 		iwl_enable_interrupts(priv);
 
-	spin_unlock(&priv->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_NONE;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d152198..9e48352 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1531,10 +1531,11 @@ irqreturn_t iwl_isr_legacy(int irq, void *data)
 	struct iwl_priv *priv = data;
 	u32 inta, inta_mask;
 	u32 inta_fh;
+	unsigned long flags;
 	if (!priv)
 		return IRQ_NONE;
 
-	spin_lock(&priv->lock);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
@@ -1572,7 +1573,7 @@ irqreturn_t iwl_isr_legacy(int irq, void *data)
 		tasklet_schedule(&priv->irq_tasklet);
 
  unplugged:
-	spin_unlock(&priv->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_HANDLED;
 
  none:
@@ -1580,7 +1581,7 @@ irqreturn_t iwl_isr_legacy(int irq, void *data)
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
-	spin_unlock(&priv->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_NONE;
 }
 EXPORT_SYMBOL(iwl_isr_legacy);
-- 
1.6.3.3

