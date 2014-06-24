Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51850 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaFXTxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:53:06 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so6592665wib.11
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:53:05 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/27] iwlwivi: mvm: BT Coex - properly set the priority of beacons
Date: Tue, 24 Jun 2014 22:52:20 +0300
Message-Id: <1403639541-4621-26-git-send-email-egrumbach@gmail.com> (sfid-20140624_215951_692270_34C25640)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the new API allows multiple priorities, we need to
properly set the beacon's prorities in the TX cmd associated
to it.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 3b0390b..aad3621 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -904,7 +904,7 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 	struct iwl_mac_beacon_cmd beacon_cmd = {};
 	struct ieee80211_tx_info *info;
 	u32 beacon_skb_len;
-	u32 rate;
+	u32 rate, tx_flags;
 
 	if (WARN_ON(!beacon))
 		return -EINVAL;
@@ -914,14 +914,17 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 	/* TODO: for now the beacon template id is set to be the mac context id.
 	 * Might be better to handle it as another resource ... */
 	beacon_cmd.template_id = cpu_to_le32((u32)mvmvif->id);
+	info = IEEE80211_SKB_CB(beacon);
 
 	/* Set up TX command fields */
 	beacon_cmd.tx.len = cpu_to_le16((u16)beacon_skb_len);
 	beacon_cmd.tx.sta_id = mvmvif->bcast_sta.sta_id;
 	beacon_cmd.tx.life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
-	beacon_cmd.tx.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
-					     TX_CMD_FLG_BT_DIS  |
-					     TX_CMD_FLG_TSF);
+	tx_flags = TX_CMD_FLG_SEQ_CTL | TX_CMD_FLG_TSF;
+	tx_flags |=
+		iwl_mvm_bt_coex_tx_prio(mvm, (void *)beacon->data, info, 0) <<
+						TX_CMD_FLG_BT_PRIO_POS;
+	beacon_cmd.tx.tx_flags = cpu_to_le32(tx_flags);
 
 	mvm->mgmt_last_antenna_idx =
 		iwl_mvm_next_antenna(mvm, mvm->fw->valid_tx_ant,
@@ -931,8 +934,6 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 		cpu_to_le32(BIT(mvm->mgmt_last_antenna_idx) <<
 			    RATE_MCS_ANT_POS);
 
-	info = IEEE80211_SKB_CB(beacon);
-
 	if (info->band == IEEE80211_BAND_5GHZ || vif->p2p) {
 		rate = IWL_FIRST_OFDM_RATE;
 	} else {
-- 
1.8.3.2

