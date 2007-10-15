Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22797 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbXJOWuf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 18:50:35 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: Add erp_ie_changed hanlder
Date: Tue, 16 Oct 2007 00:50:25 +0200
Message-Id: <1192488625903-git-send-email-tomas.winkler@intel.com> (sfid-20071015_235053_432349_7E51457A)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds erp_ie_changed handler to iwl4956

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8b6bb49..32a99a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7599,6 +7599,29 @@ static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211("leave\n");
 
 }
+static void iwl_mac_erp_ie_changed(struct ieee80211_hw *hw,
+		u8 changes, int cts_protection, int preamble)
+{
+
+	struct iwl_priv *priv = hw->priv;
+
+	if (changes & IEEE80211_ERP_CHANGE_PREAMBLE) {
+		if (preamble == WLAN_ERP_PREAMBLE_SHORT)
+			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		else
+			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+	}
+
+	if (changes & IEEE80211_ERP_CHANGE_PROTECTION) {
+		if (cts_protection)
+			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
+		else
+			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+	}
+
+	if (iwl_is_associated(priv))
+		iwl_send_rxon_assoc(priv);
+}
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
@@ -8841,6 +8864,7 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.get_tsf = iwl_mac_get_tsf,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.beacon_update = iwl_mac_beacon_update,
+	.erp_ie_changed = iwl_mac_erp_ie_changed,
 #ifdef CONFIG_IWLWIFI_HT
 	.conf_ht = iwl_mac_conf_ht,
 	.get_ht_capab = iwl_mac_get_ht_capab,
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
