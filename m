Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1FRQFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/25] iwlagn: store the irq number to iwl_bus just like dev
Date: Sat, 18 Jun 2011 08:34:25 -0700
Message-Id: <1308411271-26093-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180556_629792_9D9EF0A7)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the irq number is just an unsigned int, store it inside iwl_bus
instead of calling the get_irq ops every time it is needed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 +
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1382863..1ac6c64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3496,6 +3496,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	priv->bus.priv = priv;
 	priv->bus.bus_specific = bus_specific;
 	priv->bus.ops = bus_ops;
+	priv->bus.irq = priv->bus.ops->get_irq(&priv->bus);
 	priv->bus.ops->set_drv_data(&priv->bus, priv);
 	priv->bus.dev = priv->bus.ops->get_dev(&priv->bus);
 
@@ -3603,11 +3604,10 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	 ********************/
 	iwl_alloc_isr_ict(priv);
 
-	err = request_irq(priv->bus.ops->get_irq(&priv->bus), iwl_isr_ict,
-			  IRQF_SHARED, DRV_NAME, priv);
+	err = request_irq(priv->bus.irq, iwl_isr_ict, IRQF_SHARED,
+			  DRV_NAME, priv);
 	if (err) {
-		IWL_ERR(priv, "Error allocating IRQ %d\n",
-			priv->bus.ops->get_irq(&priv->bus));
+		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->bus.irq);
 		goto out_uninit_drv;
 	}
 
@@ -3644,7 +3644,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
  out_destroy_workqueue:
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
-	free_irq(priv->bus.ops->get_irq(&priv->bus), priv);
+	free_irq(priv->bus.irq, priv);
 	iwl_free_isr_ict(priv);
  out_uninit_drv:
 	iwl_uninit_drv(priv);
@@ -3716,7 +3716,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	priv->workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
-	free_irq(priv->bus.ops->get_irq(&priv->bus), priv);
+	free_irq(priv->bus.irq, priv);
 	priv->bus.ops->set_drv_data(&priv->bus, NULL);
 
 	iwl_uninit_drv(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 848a6c3..6d5584a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -125,7 +125,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data);
 static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 {
 	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(priv->bus.ops->get_irq(&priv->bus));
+	synchronize_irq(priv->bus.irq);
 	tasklet_kill(&priv->irq_tasklet);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2d13d89..8ec04f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1224,6 +1224,7 @@ struct iwl_bus {
 	struct iwl_priv *priv; /* driver's context */
 	struct device *dev;
 	struct iwl_bus_ops *ops;
+	unsigned int irq;
 };
 
 struct iwl_priv {
-- 
1.7.0.4

