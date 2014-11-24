Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34268 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaKXOfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:41 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so5979330wiw.9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:40 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/75] iwlwifi: mvm: support random MAC address for scanning
Date: Mon, 24 Nov 2014 16:34:03 +0200
Message-Id: <1416839691-28533-27-git-send-email-egrumbach@gmail.com> (sfid-20141124_154121_342276_F21192F6)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For background and scheduled scan, using the new unified scan API,
support random MAC address scanning.

Unfortunately, the firmware right now doesn't support randomising
itself, so for now do it on the host - we'll change this once the
firmware supports randomising the address for each scan iteration
using the address/mask.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  6 ++++-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 35 ++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index bc5883a..d37d5a8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -344,8 +344,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	}
 
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN ||
-	    mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+	    mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
+		hw->wiphy->features |=
+			NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
+			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
+	}
 
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 2191745..54303d9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1224,14 +1224,25 @@ static u8 *iwl_mvm_copy_and_insert_ds_elem(struct iwl_mvm *mvm, const u8 *ies,
 static void
 iwl_mvm_build_unified_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				 struct ieee80211_scan_ies *ies,
-				 struct iwl_scan_probe_req *preq)
+				 struct iwl_scan_probe_req *preq,
+				 const u8 *mac_addr, const u8 *mac_addr_mask)
 {
 	struct ieee80211_mgmt *frame = (struct ieee80211_mgmt *)preq->buf;
 	u8 *pos, *newpos;
 
+	/*
+	 * Unfortunately, right now the offload scan doesn't support randomising
+	 * within the firmware, so until the firmware API is ready we implement
+	 * it in the driver. This means that the scan iterations won't really be
+	 * random, only when it's restarted, but at least that helps a bit.
+	 */
+	if (mac_addr)
+		get_random_mask_addr(frame->sa, mac_addr, mac_addr_mask);
+	else
+		memcpy(frame->sa, vif->addr, ETH_ALEN);
+
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
 	eth_broadcast_addr(frame->da);
-	memcpy(frame->sa, vif->addr, ETH_ALEN);
 	eth_broadcast_addr(frame->bssid);
 	frame->seq_ctrl = 0;
 
@@ -1375,7 +1386,10 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			mvm->fw->ucode_capa.n_scan_channels);
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, preq);
+	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, preq,
+		req->req.flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			req->req.mac_addr : NULL,
+		req->req.mac_addr_mask);
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (!ret) {
@@ -1466,7 +1480,10 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			mvm->fw->ucode_capa.n_scan_channels);
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, preq);
+	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, preq,
+		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			req->mac_addr : NULL,
+		req->mac_addr_mask);
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (!ret) {
@@ -1796,7 +1813,10 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	sec_part->schedule[0].iter_count = 1;
 	sec_part->delay = 0;
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, &sec_part->preq);
+	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, &sec_part->preq,
+		req->req.flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			req->req.mac_addr : NULL,
+		req->req.mac_addr_mask);
 
 	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, req->req.ssids,
 				req->req.n_ssids, 0);
@@ -1901,7 +1921,10 @@ int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	sec_part->delay = 0;
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, &sec_part->preq);
+	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, &sec_part->preq,
+		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			req->mac_addr : NULL,
+		req->mac_addr_mask);
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (!ret) {
-- 
1.9.1

