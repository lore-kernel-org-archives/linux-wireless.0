Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab0JNSEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:20 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/9] iwlwifi: rename ibss_beacon variable
Date: Thu, 14 Oct 2010 11:02:44 -0700
Message-Id: <1287079370-20587-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we're also going to support AP (GO) mode,
the variable isn't used for just IBSS beacons
any more -- rename it to not mislead readers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   26 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   26 +++++++++++++-------------
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6771c40..0cc090b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -317,15 +317,15 @@ static u32 iwl_fill_beacon_frame(struct iwl_priv *priv,
 					  struct ieee80211_hdr *hdr,
 					  int left)
 {
-	if (!priv->ibss_beacon)
+	if (!priv->beacon_skb)
 		return 0;
 
-	if (priv->ibss_beacon->len > left)
+	if (priv->beacon_skb->len > left)
 		return 0;
 
-	memcpy(hdr, priv->ibss_beacon->data, priv->ibss_beacon->len);
+	memcpy(hdr, priv->beacon_skb->data, priv->beacon_skb->len);
 
-	return priv->ibss_beacon->len;
+	return priv->beacon_skb->len;
 }
 
 /* Parse the beacon frame to find the TIM element and set tim_idx & tim_size */
@@ -653,10 +653,10 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 	}
 
 	/* new beacon skb is allocated every time; dispose previous.*/
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
 
-	priv->ibss_beacon = beacon;
+	priv->beacon_skb = beacon;
 
 	iwl_send_beacon_cmd(priv);
  out:
@@ -2993,9 +2993,9 @@ static void __iwl_down(struct iwl_priv *priv)
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
-	priv->ibss_beacon = NULL;
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
+	priv->beacon_skb = NULL;
 
 	/* clear out any free frames */
 	iwl_clear_free_frames(priv);
@@ -4131,7 +4131,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 
-	priv->ibss_beacon = NULL;
+	priv->beacon_skb = NULL;
 
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
@@ -4645,8 +4645,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 
 	iwl_free_isr_ict(priv);
 
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
 
 	ieee80211_free_hw(priv->hw);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 89b1827..09a4d17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1552,10 +1552,10 @@ static void iwlcore_beacon_update(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
 
-	priv->ibss_beacon = skb;
+	priv->beacon_skb = skb;
 
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
 	priv->timestamp = le64_to_cpu(timestamp);
@@ -1610,8 +1610,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_BEACON && vif->type == NL80211_IFTYPE_AP) {
-		dev_kfree_skb(priv->ibss_beacon);
-		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
+		dev_kfree_skb(priv->beacon_skb);
+		priv->beacon_skb = ieee80211_beacon_get(hw, vif);
 	}
 
 	if (changes & BSS_CHANGED_BEACON_INT && vif->type == NL80211_IFTYPE_AP)
@@ -2060,10 +2060,10 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* new association get rid of ibss beacon skb */
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
 
-	priv->ibss_beacon = NULL;
+	priv->beacon_skb = NULL;
 
 	priv->timestamp = 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index de43e13..70e07fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1383,8 +1383,6 @@ struct iwl_priv {
 
 	enum nl80211_iftype iw_mode;
 
-	struct sk_buff *ibss_beacon;
-
 	/* Last Rx'd beacon timestamp */
 	u64 timestamp;
 
@@ -1496,8 +1494,10 @@ struct iwl_priv {
 	struct work_struct scan_completed;
 	struct work_struct rx_replenish;
 	struct work_struct abort_scan;
+
 	struct work_struct beacon_update;
 	struct iwl_rxon_context *beacon_ctx;
+	struct sk_buff *beacon_skb;
 
 	struct work_struct tt_work;
 	struct work_struct ct_enter;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3ee3e55..8f8c4b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -317,15 +317,15 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 				int left)
 {
 
-	if (!iwl_is_associated(priv, IWL_RXON_CTX_BSS) || !priv->ibss_beacon)
+	if (!iwl_is_associated(priv, IWL_RXON_CTX_BSS) || !priv->beacon_skb)
 		return 0;
 
-	if (priv->ibss_beacon->len > left)
+	if (priv->beacon_skb->len > left)
 		return 0;
 
-	memcpy(hdr, priv->ibss_beacon->data, priv->ibss_beacon->len);
+	memcpy(hdr, priv->beacon_skb->data, priv->beacon_skb->len);
 
-	return priv->ibss_beacon->len;
+	return priv->beacon_skb->len;
 }
 
 static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
@@ -813,10 +813,10 @@ static void iwl3945_bg_beacon_update(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 	/* new beacon skb is allocated every time; dispose previous.*/
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
 
-	priv->ibss_beacon = beacon;
+	priv->beacon_skb = beacon;
 	mutex_unlock(&priv->mutex);
 
 	iwl3945_send_beacon_cmd(priv);
@@ -2642,9 +2642,9 @@ static void __iwl3945_down(struct iwl_priv *priv)
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
-	priv->ibss_beacon = NULL;
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
+	priv->beacon_skb = NULL;
 
 	/* clear out any free frames */
 	iwl3945_clear_free_frames(priv);
@@ -3848,7 +3848,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 
 	priv->retry_rate = 1;
-	priv->ibss_beacon = NULL;
+	priv->beacon_skb = NULL;
 
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
@@ -4256,8 +4256,8 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl_free_channel_map(priv);
 	iwlcore_free_geos(priv);
 	kfree(priv->scan_cmd);
-	if (priv->ibss_beacon)
-		dev_kfree_skb(priv->ibss_beacon);
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
 
 	ieee80211_free_hw(priv->hw);
 }
-- 
1.7.0.4

