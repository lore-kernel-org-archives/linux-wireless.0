Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51808 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751033AbdLWJWI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 04:22:08 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 23 Dec 2017 11:21:56 +0200
Message-Id: <20171223092200.30270-2-luca@coelho.fi> (sfid-20171223_102213_573677_6F2D298E)
In-Reply-To: <20171223092200.30270-1-luca@coelho.fi>
References: <20171223092200.30270-1-luca@coelho.fi>
Subject: [PATCH 1/5] iwlwifi: mvm: flip AMSDU addresses only for 9000 family
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Hardware bug was fixed in later generation.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index a3f7c1bf3cc8..71d6660c48e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -830,6 +830,16 @@ static void iwl_mvm_agg_rx_received(struct iwl_mvm *mvm,
 	rcu_read_unlock();
 }
 
+static void iwl_mvm_flip_address(u8 *addr)
+{
+	int i;
+	u8 mac_addr[ETH_ALEN];
+
+	for (i = 0; i < ETH_ALEN; i++)
+		mac_addr[i] = addr[ETH_ALEN - i - 1];
+	ether_addr_copy(addr, mac_addr);
+}
+
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue)
 {
@@ -984,21 +994,16 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		 */
 		if ((desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU) &&
 		    !WARN_ON(!ieee80211_is_data_qos(hdr->frame_control))) {
-			int i;
 			u8 *qc = ieee80211_get_qos_ctl(hdr);
-			u8 mac_addr[ETH_ALEN];
 
 			*qc &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
-			for (i = 0; i < ETH_ALEN; i++)
-				mac_addr[i] = hdr->addr3[ETH_ALEN - i - 1];
-			ether_addr_copy(hdr->addr3, mac_addr);
+			if (mvm->trans->cfg->device_family ==
+			    IWL_DEVICE_FAMILY_9000) {
+				iwl_mvm_flip_address(hdr->addr3);
 
-			if (ieee80211_has_a4(hdr->frame_control)) {
-				for (i = 0; i < ETH_ALEN; i++)
-					mac_addr[i] =
-						hdr->addr4[ETH_ALEN - i - 1];
-				ether_addr_copy(hdr->addr4, mac_addr);
+				if (ieee80211_has_a4(hdr->frame_control))
+					iwl_mvm_flip_address(hdr->addr4);
 			}
 		}
 		if (baid != IWL_RX_REORDER_DATA_INVALID_BAID) {
-- 
2.15.1
