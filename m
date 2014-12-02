Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55339 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaLBSL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:29 -0500
Received: by mail-wg0-f42.google.com with SMTP id z12so17760239wgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/26] iwlwifi: mvm: remove IWL_UCODE_TLV_CAPA_EXTENDED_BEACON
Date: Tue,  2 Dec 2014 20:10:55 +0200
Message-Id: <1417543877-24193-4-git-send-email-egrumbach@gmail.com> (sfid-20141202_191132_061717_1200F5BA)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This TLV flag is set for all the supported firmwares.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 0cb79bc..f6d86cc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1304,31 +1304,22 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 			    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_extended_beacon_notif *beacon = (void *)pkt->data;
 	struct iwl_mvm_tx_resp *beacon_notify_hdr;
 	struct ieee80211_vif *csa_vif;
 	struct ieee80211_vif *tx_blocked_vif;
-	u64 tsf;
 	u16 status;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_CAPA_EXTENDED_BEACON) {
-		struct iwl_extended_beacon_notif *beacon = (void *)pkt->data;
-
-		beacon_notify_hdr = &beacon->beacon_notify_hdr;
-		tsf = le64_to_cpu(beacon->tsf);
-		mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
-	} else {
-		struct iwl_beacon_notif *beacon = (void *)pkt->data;
-
-		beacon_notify_hdr = &beacon->beacon_notify_hdr;
-		tsf = le64_to_cpu(beacon->tsf);
-	}
+	beacon_notify_hdr = &beacon->beacon_notify_hdr;
+	mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
 
 	status = le16_to_cpu(beacon_notify_hdr->status.status) & TX_STATUS_MSK;
 	IWL_DEBUG_RX(mvm,
 		     "beacon status %#x retries:%d tsf:0x%16llX gp2:0x%X rate:%d\n",
-		     status, beacon_notify_hdr->failure_frame, tsf,
+		     status, beacon_notify_hdr->failure_frame,
+		     le64_to_cpu(beacon->tsf),
 		     mvm->ap_last_beacon_gp2,
 		     le32_to_cpu(beacon_notify_hdr->initial_rate));
 
-- 
1.9.1

