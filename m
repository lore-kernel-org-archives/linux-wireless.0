Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbbCVRVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 13:21:36 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/6] iwlwifi: dvm: drop VO packets when mac80211 tells us to
Date: Sun, 22 Mar 2015 19:21:27 +0200
Message-Id: <1427044892-13907-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150322_182139_170621_56D4736F)
In-Reply-To: <1427044767.8611.4.camel@egrumbacBox>
References: <1427044767.8611.4.camel@egrumbacBox>
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

