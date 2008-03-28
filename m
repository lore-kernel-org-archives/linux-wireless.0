Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23691 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbYC1XZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8] iwlwifi: add notification infrastructure to iwlcore
Date: Fri, 28 Mar 2008 16:21:05 -0700
Message-Id: <1206746472-10443-2-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232527_398191_31A2FC1B)
In-Reply-To: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch add notification function to be called by low level
iwl driver to notify iwlcore with current state. This function
will call iwlcore subsystem with the new state. This will
help make the code more consistent and easy to extend. For example
the rf-kill need to know when the driver in init, start, stop or
remove state. Instead doing the same call in 3945 and 4965, we
just do it from this function.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   21 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 ++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index da51349..342a269 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -249,3 +249,24 @@ int iwl_setup(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_setup);
 
+/* Low level driver call this function to update iwlcore with
+ * driver status.
+ */
+int iwlcore_low_level_notify(struct iwl_priv *priv,
+			      enum iwlcore_card_notify notify)
+{
+	switch (notify) {
+	case IWLCORE_INIT_EVT:
+		break;
+	case IWLCORE_START_EVT:
+		break;
+	case IWLCORE_STOP_EVT:
+		break;
+	case IWLCORE_REMOVE_EVT:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(iwlcore_low_level_notify);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ce7f90e..4dfa059 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -146,4 +146,13 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 					   struct iwl_cmd *cmd,
 					   struct sk_buff *skb));
 
+enum iwlcore_card_notify {
+	IWLCORE_INIT_EVT = 0,
+	IWLCORE_START_EVT = 1,
+	IWLCORE_STOP_EVT = 2,
+	IWLCORE_REMOVE_EVT = 3,
+};
+
+int iwlcore_low_level_notify(struct iwl_priv *priv,
+			     enum iwlcore_card_notify notify);
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index cf56b95..5261b61 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5724,6 +5724,7 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	if (priv->error_recovering)
 		iwl4965_error_recovery(priv);
 
+	iwlcore_low_level_notify(priv, IWLCORE_START_EVT);
 	return;
 
  restart:
@@ -5747,6 +5748,8 @@ static void __iwl4965_down(struct iwl_priv *priv)
 
 	iwl_leds_unregister(priv);
 
+	iwlcore_low_level_notify(priv, IWLCORE_STOP_EVT);
+
 	iwlcore_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
@@ -8167,6 +8170,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 
+	/* notify iwlcore to init */
+	iwlcore_low_level_notify(priv, IWLCORE_INIT_EVT);
 	return 0;
 
  out_remove_sysfs:
@@ -8209,6 +8214,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 		}
 	}
 
+	iwlcore_low_level_notify(priv, IWLCORE_REMOVE_EVT);
 	iwl_dbgfs_unregister(priv);
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 
-- 
1.5.3.4

