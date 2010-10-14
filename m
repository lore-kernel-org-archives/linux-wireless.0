Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8111 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab0JNSEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:20 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/9] iwlwifi: clean up some beacon handling
Date: Thu, 14 Oct 2010 11:02:45 -0700
Message-Id: <1287079370-20587-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to check for NULL before
calling dev_kfree_skb() since it is valid
to call it on NULL -- it becomes a no-op.

There's also no need to initialise the
beacon_skb variable to NULL just after
the memory it is in has been kzalloc'ed.

Some minor whitespace cleanups, and a
lock assertion in a function that needs
the mutex (to access the beacon_skb var)
complete the patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0cc090b..7079efb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -314,9 +314,11 @@ static void iwl_free_frame(struct iwl_priv *priv, struct iwl_frame *frame)
 }
 
 static u32 iwl_fill_beacon_frame(struct iwl_priv *priv,
-					  struct ieee80211_hdr *hdr,
-					  int left)
+				 struct ieee80211_hdr *hdr,
+				 int left)
 {
+	lockdep_assert_held(&priv->mutex);
+
 	if (!priv->beacon_skb)
 		return 0;
 
@@ -330,8 +332,8 @@ static u32 iwl_fill_beacon_frame(struct iwl_priv *priv,
 
 /* Parse the beacon frame to find the TIM element and set tim_idx & tim_size */
 static void iwl_set_beacon_tim(struct iwl_priv *priv,
-		struct iwl_tx_beacon_cmd *tx_beacon_cmd,
-		u8 *beacon, u32 frame_size)
+			       struct iwl_tx_beacon_cmd *tx_beacon_cmd,
+			       u8 *beacon, u32 frame_size)
 {
 	u16 tim_idx;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)beacon;
@@ -393,7 +395,7 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	/* Set up TX beacon command fields */
 	iwl_set_beacon_tim(priv, tx_beacon_cmd, (u8 *)tx_beacon_cmd->frame,
-			frame_size);
+			   frame_size);
 
 	/* Set up packet rate and flags */
 	rate = iwl_rate_get_lowest_plcp(priv, priv->beacon_ctx);
@@ -648,13 +650,12 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
 	beacon = ieee80211_beacon_get(priv->hw, priv->beacon_ctx->vif);
 	if (!beacon) {
-		IWL_ERR(priv, "update beacon failed\n");
+		IWL_ERR(priv, "update beacon failed -- keeping old\n");
 		goto out;
 	}
 
 	/* new beacon skb is allocated every time; dispose previous.*/
-	if (priv->beacon_skb)
-		dev_kfree_skb(priv->beacon_skb);
+	dev_kfree_skb(priv->beacon_skb);
 
 	priv->beacon_skb = beacon;
 
@@ -2993,8 +2994,7 @@ static void __iwl_down(struct iwl_priv *priv)
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
-	if (priv->beacon_skb)
-		dev_kfree_skb(priv->beacon_skb);
+	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
 
 	/* clear out any free frames */
@@ -4131,8 +4131,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 
-	priv->beacon_skb = NULL;
-
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
@@ -4645,8 +4643,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 
 	iwl_free_isr_ict(priv);
 
-	if (priv->beacon_skb)
-		dev_kfree_skb(priv->beacon_skb);
+	dev_kfree_skb(priv->beacon_skb);
 
 	ieee80211_free_hw(priv->hw);
 }
-- 
1.7.0.4

