Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55782 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbbCLHth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 03:49:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: dvm: drop VO packets when mac80211 tells us to
Date: Thu, 12 Mar 2015 09:49:32 +0200
Message-Id: <1426146573-8068-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_084942_887264_0EDC8C65)
In-Reply-To: <1426146488.8748.16.camel@egrumbacBox>
References: <1426146488.8748.16.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 now informs the driver when to drop the packets
upon flush(). This will happen before disconnecting, or
before we shut down the interface. We can now rely on this
to drop all the packets including the VO queues.
When mac80211 sets drop to false, wait for all the queues
to be empty.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 47e64e8..cceb026 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1114,16 +1114,17 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	scd_queues &= ~(BIT(IWL_IPAN_CMD_QUEUE_NUM) |
 			BIT(IWL_DEFAULT_CMD_QUEUE_NUM));
 
-	if (vif)
-		scd_queues &= ~BIT(vif->hw_queue[IEEE80211_AC_VO]);
-
-	IWL_DEBUG_TX_QUEUES(priv, "Flushing SCD queues: 0x%x\n", scd_queues);
-	if (iwlagn_txfifo_flush(priv, scd_queues)) {
-		IWL_ERR(priv, "flush request fail\n");
-		goto done;
+	if (drop) {
+		IWL_DEBUG_TX_QUEUES(priv, "Flushing SCD queues: 0x%x\n",
+				    scd_queues);
+		if (iwlagn_txfifo_flush(priv, scd_queues)) {
+			IWL_ERR(priv, "flush request fail\n");
+			goto done;
+		}
 	}
+
 	IWL_DEBUG_TX_QUEUES(priv, "wait transmit/flush all frames\n");
-	iwl_trans_wait_tx_queue_empty(priv->trans, 0xffffffff);
+	iwl_trans_wait_tx_queue_empty(priv->trans, scd_queues);
 done:
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-- 
1.9.1

