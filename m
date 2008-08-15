Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYHOCEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:42 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/15] iwlwifi: Added bss_info_changed callback to 3945
Date: Fri, 15 Aug 2008 10:01:06 +0800
Message-Id: <1218765680-8378-2-git-send-email-yi.zhu@intel.com> (sfid-20080815_040449_961444_539811EF)
In-Reply-To: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 ++++++++++++++++++++++++--
 1 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7095d8c..8e88f3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6321,11 +6321,8 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
-static void iwl3945_bg_post_associate(struct work_struct *data)
+static void iwl3945_post_associate(struct iwl3945_priv *priv)
 {
-	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv,
-					     post_associate.work);
-
 	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
 	DECLARE_MAC_BUF(mac);
@@ -6343,8 +6340,6 @@ static void iwl3945_bg_post_associate(struct work_struct *data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	mutex_lock(&priv->mutex);
-
 	if (!priv->vif || !priv->is_open) {
 		mutex_unlock(&priv->mutex);
 		return;
@@ -6420,6 +6415,15 @@ static void iwl3945_bg_post_associate(struct work_struct *data)
 
 	/* we have just associated, don't start scan too early */
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
+}
+
+static void iwl3945_bg_post_associate(struct work_struct *data)
+{
+	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv,
+					     post_associate.work);
+
+	mutex_lock(&priv->mutex);
+	iwl3945_post_associate(priv);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -6949,6 +6953,63 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
+#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
+
+static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *bss_conf,
+				     u32 changes)
+{
+	struct iwl3945_priv *priv = hw->priv;
+
+	IWL_DEBUG_MAC80211("changes = 0x%X\n", changes);
+
+	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
+		IWL_DEBUG_MAC80211("ERP_PREAMBLE %d\n",
+				   bss_conf->use_short_preamble);
+		if (bss_conf->use_short_preamble)
+			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		else
+			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+	}
+
+	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
+		IWL_DEBUG_MAC80211("ERP_CTS %d\n", bss_conf->use_cts_prot);
+		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
+			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
+		else
+			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+	}
+
+	if (changes & BSS_CHANGED_ASSOC) {
+		IWL_DEBUG_MAC80211("ASSOC %d\n", bss_conf->assoc);
+		/* This should never happen as this function should
+		 * never be called from interrupt context. */
+		if (WARN_ON_ONCE(in_interrupt()))
+			return;
+		if (bss_conf->assoc) {
+			priv->assoc_id = bss_conf->aid;
+			priv->beacon_int = bss_conf->beacon_int;
+			priv->timestamp0 = bss_conf->timestamp & 0xFFFFFFFF;
+			priv->timestamp1 = (bss_conf->timestamp >> 32) &
+					     0xFFFFFFFF;
+			priv->assoc_capability = bss_conf->assoc_capability;
+			priv->next_scan_jiffies = jiffies +
+					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
+			mutex_lock(&priv->mutex);
+			iwl3945_post_associate(priv);
+			mutex_unlock(&priv->mutex);
+		} else {
+			priv->assoc_id = 0;
+			IWL_DEBUG_MAC80211("DISASSOC %d\n", bss_conf->assoc);
+		}
+	} else if (changes && iwl3945_is_associated(priv) && priv->assoc_id) {
+			IWL_DEBUG_MAC80211("Associated Changes %d\n", changes);
+			iwl3945_send_rxon_assoc(priv);
+	}
+
+}
+
 static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
@@ -7829,6 +7890,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.conf_tx = iwl3945_mac_conf_tx,
 	.get_tsf = iwl3945_mac_get_tsf,
 	.reset_tsf = iwl3945_mac_reset_tsf,
+	.bss_info_changed = iwl3945_bss_info_changed,
 	.hw_scan = iwl3945_mac_hw_scan
 };
 
-- 
1.5.3.6

