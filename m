Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:29654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbYLIT2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:28:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/4] iwlwifi: 3945 remove qos module parameter
Date: Tue,  9 Dec 2008 11:29:00 -0800
Message-Id: <1228850941-16677-4-git-send-email-reinette.chatre@intel.com> (sfid-20081209_202810_608866_135FD760)
In-Reply-To: <1228850941-16677-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228850941-16677-1-git-send-email-reinette.chatre@intel.com>
 <1228850941-16677-2-git-send-email-reinette.chatre@intel.com>
 <1228850941-16677-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

The ability of disabling qos from module params is not required
anymore.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   42 +++++++++-----------------
 2 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index b7e366e..ec6084c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -476,7 +476,6 @@ union iwl3945_qos_capabity {
 
 /* QoS structures */
 struct iwl3945_qos_info {
-	int qos_enable;
 	int qos_active;
 	union iwl3945_qos_capabity qos_cap;
 	struct iwl3945_qosparam_cmd def_qos_parm;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f789cb8..56c6e65 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -69,7 +69,6 @@ static int iwl3945_param_debug;    /* def: 0 = minimal debug log messages */
 static int iwl3945_param_disable;  /* def: 0 = enable radio */
 static int iwl3945_param_antenna;  /* def: 0 = both antennas (use diversity) */
 int iwl3945_param_hwcrypto;        /* def: 0 = use software encryption */
-static int iwl3945_param_qos_enable = 1; /* def: 1 = use quality of service */
 int iwl3945_param_queues_num = IWL39_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 
 /*
@@ -1695,17 +1694,21 @@ static void iwl3945_reset_qos(struct iwl3945_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->qos_data.qos_active = 0;
 
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC) {
-		if (priv->qos_data.qos_enable)
-			priv->qos_data.qos_active = 1;
-		if (!(priv->active_rate & 0xfff0)) {
-			cw_min = 31;
-			is_legacy = 1;
-		}
-	} else if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		if (priv->qos_data.qos_enable)
-			priv->qos_data.qos_active = 1;
-	} else if (!(priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK)) {
+	/* QoS always active in AP and ADHOC mode
+	 * In STA mode wait for association
+	 */
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC ||
+	    priv->iw_mode == NL80211_IFTYPE_AP)
+		priv->qos_data.qos_active = 1;
+	else
+		priv->qos_data.qos_active = 0;
+
+
+	/* check for legacy mode */
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+	     (priv->active_rate & IWL_OFDM_RATES_MASK) == 0) ||
+	    (priv->iw_mode == NL80211_IFTYPE_STATION &&
+	     (priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK) == 0)) {
 		cw_min = 31;
 		is_legacy = 1;
 	}
@@ -1777,9 +1780,6 @@ static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (!priv->qos_data.qos_enable)
-		return;
-
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->qos_data.def_qos_parm.qos_flags = 0;
 
@@ -7112,11 +7112,6 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		return 0;
 	}
 
-	if (!priv->qos_data.qos_enable) {
-		priv->qos_data.qos_active = 0;
-		IWL_DEBUG_MAC80211("leave - qos not enabled\n");
-		return 0;
-	}
 	q = AC_NUM - 1 - queue;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -7997,9 +7992,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 
-	if (iwl3945_param_qos_enable)
-		priv->qos_data.qos_enable = 1;
-
 	iwl3945_reset_qos(priv);
 
 	priv->qos_data.qos_active = 0;
@@ -8390,9 +8382,5 @@ MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 module_param_named(queues_num, iwl3945_param_queues_num, int, 0444);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
 
-/* QoS */
-module_param_named(qos_enable, iwl3945_param_qos_enable, int, 0444);
-MODULE_PARM_DESC(qos_enable, "enable all QoS functionality");
-
 module_exit(iwl3945_exit);
 module_init(iwl3945_init);
-- 
1.5.4.3

