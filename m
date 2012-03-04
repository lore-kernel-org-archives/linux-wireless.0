Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab2CDUnO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:14 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 100/101] iwlwifi: correct status bit refactoring errors
Date: Sun,  4 Mar 2012 11:29:54 -0800
Message-Id: <1330889395-533-101-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214421_868850_00C1BFC0)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

I missed a couple of status bits in my refactoring changes.  This
fixes the ones I missed.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 3ad4333..cc0227c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -628,7 +628,7 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_card_state_notif *card_state_notif = (void *)pkt->data;
 	u32 flags = le32_to_cpu(card_state_notif->flags);
-	unsigned long status = priv->shrd->status;
+	unsigned long status = priv->status;
 
 	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s CT:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3793dc4..28422c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -819,15 +819,15 @@ void iwl_down(struct iwl_priv *priv)
 	iwl_trans_stop_device(trans(priv));
 
 	/* Clear out all status bits but a few that are stable across reset */
-	priv->shrd->status &=
-			test_bit(STATUS_RF_KILL_HW, &priv->status) <<
+	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
 			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 				STATUS_GEO_CONFIGURED |
-			test_bit(STATUS_FW_ERROR, &priv->shrd->status) <<
-				STATUS_FW_ERROR |
 			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
+	priv->shrd->status &=
+			test_bit(STATUS_FW_ERROR, &priv->shrd->status) <<
+				STATUS_FW_ERROR;
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
-- 
1.7.0.4

