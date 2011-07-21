Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1GUP0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/25] iwlagn: probe would crash with DEBUG_SHIRQ
Date: Thu, 21 Jul 2011 07:50:28 -0700
Message-Id: <1311259828-8415-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172712_197679_81DD1855)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is since my patch:

    iwlagn: introduce transport layer and implement rx_init

The IRQ is requested before the locks are initialized, hence the crash.
Initialize the tasklet before we request the IRQ on the way.

Reported-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans.c |    6 +++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 299acb4..4b666b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3645,10 +3645,6 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 	priv->cfg = cfg;
 	priv->inta_mask = CSR_INI_SET_MASK;
 
-	err = iwl_trans_register(&priv->trans, priv);
-	if (err)
-		goto out_free_priv;
-
 	/* is antenna coupling more than 35dB ? */
 	priv->bt_ant_couple_ok =
 		(iwlagn_ant_coupling > IWL_BT_ANTENNA_COUPLING_THRESHOLD) ?
@@ -3682,10 +3678,14 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		priv->cfg->name, hw_rev);
 
+	err = iwl_trans_register(&priv->trans, priv);
+	if (err)
+		goto out_free_traffic_mem;
+
 	if (trans_prepare_card_hw(&priv->trans)) {
 		err = -EIO;
 		IWL_WARN(priv, "Failed, HW not ready\n");
-		goto out_free_traffic_mem;
+		goto out_free_trans;
 	}
 
 	/*****************
@@ -3695,7 +3695,7 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 	err = iwl_eeprom_init(priv, hw_rev);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
-		goto out_free_traffic_mem;
+		goto out_free_trans;
 	}
 	err = iwl_eeprom_check_version(priv);
 	if (err)
@@ -3778,10 +3778,10 @@ out_destroy_workqueue:
 	iwl_uninit_drv(priv);
 out_free_eeprom:
 	iwl_eeprom_free(priv);
+out_free_trans:
+	trans_free(&priv->trans);
 out_free_traffic_mem:
 	iwl_free_traffic_mem(priv);
-	trans_free(&priv->trans);
-out_free_priv:
 	ieee80211_free_hw(priv->hw);
 out:
 	return err;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 582ab1b..41f0de9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1153,6 +1153,9 @@ int iwl_trans_register(struct iwl_trans *trans, struct iwl_priv *priv)
 	priv->trans.ops = &trans_ops;
 	priv->trans.priv = priv;
 
+	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+		iwl_irq_tasklet, (unsigned long)priv);
+
 	iwl_alloc_isr_ict(priv);
 
 	err = request_irq(priv->bus->irq, iwl_isr_ict, IRQF_SHARED,
@@ -1163,9 +1166,6 @@ int iwl_trans_register(struct iwl_trans *trans, struct iwl_priv *priv)
 		return err;
 	}
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		iwl_irq_tasklet, (unsigned long)priv);
-
 	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
 
 	return 0;
-- 
1.7.0.4

