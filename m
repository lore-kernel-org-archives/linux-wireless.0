Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab0CJPYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 10:24:12 -0500
Date: Wed, 10 Mar 2010 16:22:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [RFC PATCH 2/2] iwlwifi: implement disable_qos
Message-ID: <20100310152220.GD2969@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   16 +++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 4 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 921dc4a..56bfe49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2879,6 +2879,7 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.get_stats = iwl_mac_get_stats,
 	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
+	.disable_qos = iwl_mac_disable_qos,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
 	.ampdu_action = iwl_mac_ampdu_action,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0cd4ec4..f99fdae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -303,7 +303,7 @@ EXPORT_SYMBOL(iwl_activate_qos);
  * AC_BE      15            1023        3           0               0
  * AC_VI       7              15        2          6.016ms       3.008ms
  * AC_VO       3               7        2          3.264ms       1.504ms
- */
+	 */
 void iwl_reset_qos(struct iwl_priv *priv)
 {
 	u16 cw_min = 15;
@@ -2227,6 +2227,20 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 }
 EXPORT_SYMBOL(iwl_mac_conf_tx);
 
+int iwl_mac_disable_qos(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->qos_data.qos_active = 0;
+	iwl_activate_qos(priv, 1);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_mac_disable_qos);
+
 static void iwl_ht_conf(struct iwl_priv *priv,
 			    struct ieee80211_bss_conf *bss_conf)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7754538..61ccd44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -270,6 +270,7 @@ void iwl_reset_qos(struct iwl_priv *priv);
 void iwl_activate_qos(struct iwl_priv *priv, u8 force);
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
+int iwl_mac_disable_qos(struct ieee80211_hw *hw);
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv);
 int iwl_full_rxon_required(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5f26c93..1b90171 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3774,6 +3774,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.set_key = iwl3945_mac_set_key,
 	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
+	.disable_qos = iwl_mac_disable_qos,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
 	.hw_scan = iwl_mac_hw_scan
-- 
1.6.6

